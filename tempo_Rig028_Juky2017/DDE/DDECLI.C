/*  .title  DDECLI.C - Sample C DDE client for TEMPO/Win
;+
; SYNOPSIS
;
;   DDECLI [db]             db=[1..DATABASES) A database to monitor
;                           Defaults to database 1
;
; DESCRIPTION
;   This program provides an example of how to access TEMPO's DDE server
;   from a C program.
;
; NOTES
;   This program was written in standard C for Win32.  It compiles and
;   runs using Microsoft's C/C++ V5.0 and runs on Windows 95.
;
; DISCLAIMER
;   This code is provided without support of any kind.  It is intended
;   to serve as an example for how to access TEMPO's DDE server.  These
;   files may not be freely distributed without written permission from
;   Reflective Computing.  By receiving these files, you agree that they
;   are a "trade secret" and that you will use them strickly for your
;   own research using the TEMPO software.
;
;   This code is subject to change without notice.  If you use these files
;   in your programs, you may need to make changes to your program in
;   subsequent releases due to changes made here.
;
;   Copyright 1999 Reflective Computing.  All Rights Reserved.
;
; EDIT HISTORY
;   05 Jun 99 sh    Initial edit
;-
*/
#include <windows.h>
#include <stdio.h>
#include <time.h>

#define BUGER 0

#if BUGER
#include    "..\lib32\buger.h"
#include    "ddeerr.h"
#endif

#include    "tempodde.h"

#define WM_USER_INITIATE (WM_USER + 1)  // Our internal message to connect to TEMPO
#define WM_USER_GETEPOCHDATA (WM_USER + 2)  // Our internal message to retrieve epoch data

char  szAppName[] = "DDECLI";           // Our application name

DWORD   hInst;                          // DDEML application instance
HCONV   hConvDB;                        // DDEML conversation for Topic DB
HCONV   hConvCommand;                   // DDEML conversation for Topic COMMAND

HWND    hMainHwnd;                      // Our main window

time_t  StartTime;                      // Time program was started
long    nEpochsDownloaded;              // Total # of epochs downloaded successfully
long    nErrors;                        // # of download errors detected

long nDb;                               // Database number to retrieve [1..NDATABASES]
long nDB1EpochCountClient;              // Client's Latest epoch count
long nDB1EpochCountServer;              // Server's latest epoch count
long DB1Period;                         // Period of epoch (nrows)
long DB1Channels;                       // # of channels (ncols)
long DB1FirstChannel;                   // First channel
short *DB1EpochData;                    // Current epoch values

long DisplayHorzRes;                    // Screen dimensions
long DisplayVertRes;

long hAdvDB1EpochCount;                 // Handle returned by TempoAdvise

LRESULT CALLBACK WndProc(HWND, UINT, WPARAM, LPARAM);

static HDDEDATA CALLBACK EpochCountCallback(UINT iType, UINT iFmt, HCONV hConv,
            HSZ hsz1, HSZ hsz2, HDDEDATA hData, DWORD dwData1, DWORD dwData2);

long GetEpochData(DWORD hInst, HCONV hConv, long db, long nEpoch, short *pSamples);
long GetLongData(HCONV hConv, char *Item, long *value);
void DownloadEpochs(DWORD hInst, HCONV hConv);

void GetTimingInfo(void);

//--------------------------------------------------------------------
//lint -esym(715,hPrevInstance,szCmdLine)           Not referenced

int WINAPI
WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, PSTR szCmdLine, int iCmdShow)
{
    MSG         msg;
    WNDCLASSEX  wndclass;
    ULONG       err;

time(&StartTime);                       // Get program start time

nDb = atoi(szCmdLine);
if (nDb < 1)
    nDb = 1;

wndclass.cbSize        = sizeof(wndclass);
wndclass.style         = CS_HREDRAW | CS_VREDRAW;
wndclass.lpfnWndProc   = WndProc;
wndclass.cbClsExtra    = 0;
wndclass.cbWndExtra    = 0;
wndclass.hInstance     = hInstance;
wndclass.hIcon         = LoadIcon(hInstance, szAppName);
wndclass.hCursor       = LoadCursor(NULL, IDC_ARROW);
wndclass.hbrBackground = (HBRUSH) GetStockObject(WHITE_BRUSH);
wndclass.lpszMenuName  = NULL;
wndclass.lpszClassName = szAppName;
wndclass.hIconSm       = LoadIcon(hInstance, szAppName);

RegisterClassEx(&wndclass);

hMainHwnd = CreateWindow(szAppName, "TEMPO DDE Client",
                    WS_OVERLAPPEDWINDOW,
                    100,                    // left
                    100,                    // top
                    650,                    // right
                    300,                    // bottom
                    NULL, NULL, hInstance, NULL);

ShowWindow(hMainHwnd, iCmdShow);
UpdateWindow(hMainHwnd);

#if BUGER
BugerOpen("DDECLI");
#endif

err = TempoInit(&hInst);                // Open DDEML application instance
if (err != DMLERR_NO_ERROR)
     {
     MessageBox(hMainHwnd, "Failed to initialize TEMPO DDE client!", szAppName, MB_ICONEXCLAMATION | MB_OK);
     return(0);
     }

#if BUGER
Bugerf("MainWin: Sending WM_USER_INITIATE message\n");
#endif
SendMessage(hMainHwnd, WM_USER_INITIATE, 0, 0L);     // Connect to TEMPO

while (GetMessage(&msg, NULL, 0, 0))    // Our message pump
     {
     TranslateMessage(&msg);
     DispatchMessage(&msg);
     }

#if BUGER
Bugerf("DDECLI - WM_DESTROY: Calling TempoUnInit..\n");
#endif
(void) TempoUnInit(hInst);

#if BUGER
BugerClose();
#endif

return(msg.wParam);
}

//--------------------------------------------------------------------
LRESULT CALLBACK
WndProc(HWND hwnd, UINT iMsg, WPARAM wParam, LPARAM lParam)
{
    static long  cxChar, cyChar;
    HDC          hdc;

switch (iMsg)
    {
    case WM_CREATE:
        {
        TEXTMETRIC  tm;
        HFONT       hFont;

        hdc = GetDC(hwnd);
        hFont = SelectObject(hdc, GetStockObject(SYSTEM_FIXED_FONT));

        DisplayHorzRes = GetDeviceCaps(hdc, HORZRES);   // Screen dimensions
        DisplayVertRes = GetDeviceCaps(hdc, VERTRES);

        GetTextMetrics(hdc, &tm);
        cxChar = tm.tmAveCharWidth;
        cyChar = tm.tmHeight + tm.tmExternalLeading;

        SelectObject(hdc, hFont);
        ReleaseDC(hwnd, hdc);

        return(0);
        }

    case WM_USER_INITIATE:
        {
        char    buf[256];

        GetTimingInfo();

        // CONNECT TO TEMPO'S DATABASE #1

        hConvDB = TempoOpenConv(hInst, "TEMPO", "DB");
        if (!hConvDB)
            {
            nErrors++;
            MessageBox(hwnd, "Failed to connect to TEMPO Topic DB", szAppName, MB_ICONEXCLAMATION | MB_OK);
            return(0);
            }

        // GET DATABASE INFORMATION

        sprintf(buf, "PERIOD %d", nDb);
        if (!GetLongData(hConvDB, buf, &DB1Period))
            {
            nErrors++;
            MessageBox(hwnd, "Failed to get PERIOD", szAppName, MB_ICONEXCLAMATION | MB_OK);
            return(0);
            }

        if (DB1Period < 1)
            DB1Period = 1;

        sprintf(buf, "NCHANNELS %d", nDb);
        if (!GetLongData(hConvDB, buf, &DB1Channels))
            {
            nErrors++;
            MessageBox(hwnd, "Failed to get NCHANNELS", szAppName, MB_ICONEXCLAMATION | MB_OK);
            return(0);
            }

        if (DB1Channels < 1)
            DB1Channels = 1;

        sprintf(buf, "FIRSTCHANNEL %d", nDb);
        if (!GetLongData(hConvDB, buf, &DB1FirstChannel))
            {
            nErrors++;
            MessageBox(hwnd, "Failed to get FIRSTCHANNEL", szAppName, MB_ICONEXCLAMATION | MB_OK);
            return(0);
            }

        DB1EpochData = calloc(DB1Period * DB1Channels, sizeof(short));  // Allocate epoch matrix
        if (!DB1EpochData)
            {
            nErrors++;
            sprintf(buf, "No memory for Epoch data: Period=%d, Channels=%d", DB1Period, DB1Channels);
            MessageBox(hwnd, buf, szAppName, MB_ICONEXCLAMATION | MB_OK);
            return(0);
            }

        // REQUEST ADVISORY NOTIFICATION OF THE DATABASE CHANGING.

        sprintf(buf, "EPOCHCOUNT %d", nDb);
        hAdvDB1EpochCount = TempoAdvise(hInst, hConvDB, buf, EpochCountCallback);

        (void) DdeEnableCallback(hInst, hConvDB, EC_DISABLE);  // Disable callbacks while we request command

        // ESTABLISH COMMAND LINK

        hConvCommand = TempoOpenConv(hInst, "TEMPO", "COMMAND");
        if (!hConvCommand)
            {
            nErrors++;
            MessageBox(hwnd, "Failed to connect to TEMPO Topic COMMAND", szAppName, MB_ICONEXCLAMATION | MB_OK);
            return(0);
            }

        if (TempoExecute(hInst, hConvCommand, "DDE SHOW", DDE_TIMEOUT))
            {
            nErrors++;
            MessageBox(hwnd, "Failed to execute TEMPO command", szAppName, MB_ICONEXCLAMATION | MB_OK);
            return(0);
            }

        (void) DdeEnableCallback(hInst, hConvDB, EC_ENABLEALL);  // Disable callbacks while we request command

        // Invalidate window so it gets updated the first time

        InvalidateRect(hMainHwnd, NULL, FALSE);

        return(0);
        }                               //lint !e550 hData not accessed

    case WM_USER_GETEPOCHDATA:          // Our internal message to retrieve epoch data
        {
        DownloadEpochs(hInst, hConvDB);
        return(0);
        }

    case WM_PAINT:                      // Paint main window
        {
        PAINTSTRUCT ps;
        char        buf[256];
        long        len;
        long        row, col, maxrow;
        short       *pData;
        char        *p;
        HFONT       hFont;

        hdc = BeginPaint(hwnd, &ps);
        hFont = SelectObject(hdc, GetStockObject(SYSTEM_FIXED_FONT));

        len = sprintf(buf, "DB%d Epoch=%d/%d Period=%d Channels=%d-%d Errors=%d/%d %.8s    ",
                      nDb,
                      nDB1EpochCountClient, nDB1EpochCountServer,
                      DB1Period, 
                      DB1FirstChannel, DB1FirstChannel + DB1Channels - 1,
                      nErrors, nEpochsDownloaded,
                      ctime(&StartTime) + 11);

        TextOut(hdc, 0, 0, buf, len);

        maxrow = DB1Period > 50 ? 50 : DB1Period;

        if (DB1EpochData)           // Is a buffer allocated?
            {
            for (row = 0, pData = DB1EpochData; row < maxrow; row++)
                {
                p = buf;
                for (col = 0; col < DB1Channels; col++)
                    {
                    p += sprintf(p, "%6d", *pData++);
                    }
                TextOut(hdc, 0, cyChar * (row + 1), buf, strlen(buf));
                }
            }

        SelectObject(hdc, hFont);
        EndPaint(hwnd, &ps);
        return(0);
        }

    case WM_DESTROY:                    // Request to close main window
        {
        BOOL        err;

        // STOP THE ADVISE AND CLOSE CONVERSATION

        #if BUGER
        Bugerf("DDECLI - WM_DESTROY: Unadvising hAdvDB1EpochCount..\n");
        #endif

        //MessageBox(NULL, "TempoUnAdvise calling..", "WM_DESTROY", MB_OK);

        err = TempoUnAdvise(hAdvDB1EpochCount);
        hAdvDB1EpochCount = -1;         // No longer valid

        //MessageBox(NULL, "TempoUnAdvise returned", "WM_DESTROY", MB_OK);

        if (hConvDB)
            {
            #if BUGER
            Bugerf("DDECLI - WM_DESTROY: Closing hConvDB..\n");
            #endif
            err = TempoCloseConv(hConvDB);
            hConvDB = 0;                // No longer valid
            }

        if (hConvCommand)
            {
            #if BUGER
            Bugerf("DDECLI - WM_DESTROY: Closing hConvCommand..\n");
            #endif
            err = TempoCloseConv(hConvCommand);
            hConvCommand = 0;           // No longer valid
            }

        if (DB1EpochData)
            {
            //Bugerf("DDECLI - WM_DESTROY: Freeing DB1EpochData..\n");
            //free(DB1EpochData);         // Free epoch data buffer
            //DB1EpochData = 0;           // No longer valid
            }

        #if BUGER
        Bugerf("DDECLI - WM_DESTROY: done.\n");
        Bugerf("DDECLI WM_DESTORY: Posting QuitMessage.\n");
        #endif

        PostQuitMessage(0);

        #if BUGER
        Bugerf("DDECLI WM_DESTORY: Posted  QuitMessage.\n");
        #endif

        break;                          // for default processing
        }                               //lint !e550    hData, err not accessed

    default:
        break;
    }

return(DefWindowProc(hwnd, iMsg, wParam, lParam));
}                                       //lint !e550 cxChar, cyChar not accessed


//--------------------------------------------------------------------
// EpochCountCallback - This is called when EPOCHCOUNT changes.
//lint -esym(715, dwData1, dwData2, hsz1, hConv)

static HDDEDATA CALLBACK
EpochCountCallback(UINT iType, UINT iFmt, HCONV hConv, HSZ hsz1, HSZ hsz2,
                   HDDEDATA hData, DWORD dwData1, DWORD dwData2)
{
#if BUGER
Bugerf("DDECLI - EpochCountCallback iType=%d iFmt=%d hConv=%X hsz1=%X hsz2=%X\n",
    iType, iFmt, (long) hConv, (long) hsz1, (long) hsz2);
#endif

switch (iType)
    {
    case XTYP_ADVDATA:                  // Returns DDE_FACK, DDE_FBUSY or DDE_FNOTPROCESSED
        {                               // hsz1  = topic
        char    Item[256];              // hsz2  = item
        char    buf[256];               // hData = data
                                        
        // CHECK FOR MATCHING FORMAT AND DATA ITEM

        if (iFmt != CF_TEXT)
            {
            #if BUGER
            Bugerf("DDECLI - EpochCountCallback expected CF_TEXT format. Got %d\n", iFmt);
            #endif
            nErrors++;
            return(DDE_FNOTPROCESSED);
            }

        (void) DdeQueryString(hInst, hsz2, Item, sizeof(Item), 0);

        sprintf(buf, "EPOCHCOUNT %d", nDb);
        if (stricmp(Item, buf) != 0)
            {
            #if BUGER
            Bugerf("DDECLI - EpochCountCallback expected item '%s'. Got '%s'\n", buf, Item);
            #endif
            nErrors++;
            return(DDE_FNOTPROCESSED);
            }

        // STORE THE DATA AND INVALIDATE THE WINDOW.  WE MUST *NOT*
        // FREE THIS hData HANDLE!

        DdeGetData(hData, (unsigned char *) buf, sizeof(buf), 0);

        nDB1EpochCountServer = atol(buf);

        #if BUGER
        Bugerf("DDECLI - Received EPOCHCOUNT %d (nEpochCountClient=%d)\n",
            nDB1EpochCountServer, nDB1EpochCountClient);
        #endif

        if (nDB1EpochCountClient > nDB1EpochCountServer)
            nDB1EpochCountClient = 0;   // The server wrapped epochs

        // RETRIEVE THE EPOCH DATA FROM TEMPO

        PostMessage(hMainHwnd, WM_USER_GETEPOCHDATA, 0, 0L);     // Start downloading epoch(s)

        InvalidateRect(hMainHwnd, NULL, FALSE);

        return((HDDEDATA) DDE_FACK);
        }

    default:;
    }

return(NULL);
}

//--------------------------------------------------------------------
long
GetLongData(HCONV hConv, char *Item, long *value)
{
    HDDEDATA        hData;
    char            buf[256];
    DWORD           len;
    char            *pdata;

hData = TempoGetItem(hInst, hConv, Item, CF_TEXT, DDE_TIMEOUT);
if (!hData)
    {
    sprintf(buf, "Error retrieving Item %s", Item);
    //MessageBox(hMainHwnd, buf, "GetNumericData", MB_OK);
    #if BUGER
    Bugerf("DDECLI - %s\n", buf);
    #endif
    return(0);
    }

pdata = (char *) DdeAccessData(hData, &len);
if (pdata)
    {
    // PARSE DATA AND STORE IN USER'S BUFFER

    *value = strtol(pdata, &pdata, 10);
    }

(void) DdeUnaccessData(hData);

// WE MUST FREE THIS HANDLE

(void) DdeFreeDataHandle(hData);
return(pdata ? 1 : 0);
}


//--------------------------------------------------------------------
// DownloadEpochs - Download epochs from TEMPO so we have the latest
// IN
//      hInst           DDEML instance handle
//      hConv           DDEML conversation (Service=TEMPO, Topic=DBn)
// OUT
//      nothing.
//lint -esym(715,hInst)

void
DownloadEpochs(DWORD hInst1, HCONV hConv)
{
    static short depth = 0;
    char    buf[256];
    long    err;

if (depth)
    return;                             // Don't enter recursively, once is enough to get all epochs

depth++;
while (nDB1EpochCountServer > 0 && nDB1EpochCountClient < nDB1EpochCountServer)
    {
    // RETRIEVE EPOCH DATA FOR DATABASE 1

    err = GetEpochData(hInst1, hConv, nDb, nDB1EpochCountClient + 1, DB1EpochData);
    if (!err)
        {                    
        sprintf(buf, "Error retrieving DB1 EPOCHDATA %d", nDB1EpochCountClient + 1);
        //MessageBox(hMainHwnd, buf, "EpochCountCallback", MB_OK);
        #if BUGER
        Bugerf("DDECLI - %s\n", buf);
        #endif
        nErrors++;
        break;
        }
    else
        {
        nDB1EpochCountClient++;         // We now have this epoch
        nEpochsDownloaded++;            // Count successful downloads
        }

    InvalidateRect(hMainHwnd, NULL, FALSE);
    }
depth--;
}

//--------------------------------------------------------------------
// GetEpochData - Retrieve data for a database epoch
// IN
//      hInst           DDEML instance handle
//      hConv           Conversation (for a DBn Topic)
//      db              Database number [1..NDATABASES]
//      nEpoch          Epoch number [1..)
//      pSamples        Matrix large enough for one epoch
// OUT
//      0               Error
//      >0              Number of samples retrieved
//lint -esym(550,err)

long
GetEpochData(DWORD hInst1, HCONV hConv, long db, long nEpoch, short *pSamples)
{
    HDDEDATA        hData;
    char            buf[256];
    char            Item[64];
    long            nSamplesRetrieved = 0;
    long            err;

if (nEpoch <= 0)
    {
    #if BUGER
    Bugerf("GetEpochData - nEpoch=%d <=0\n", nEpoch);
    #endif
    return(0);                         // Invalid epoch number
    }

sprintf(Item, "EPOCHDATA %d %d", db, nEpoch);

#if BUGER
Bugerf("DDECLI - ***** Requesting '%s'..\n", Item);
#endif
hData = TempoGetItem(hInst1, hConv, Item, CF_TEXT, DDE_TIMEOUT);
if (!hData)
    {
    sprintf(buf, "Error retrieving %s", Item);
    //MessageBox(hMainHwnd, buf, "GetEpochData", MB_OK);
    #if BUGER
    Bugerf("DDECLI - !!!!!!!!!!!! %s\n", buf);
    #endif
    return(0);
    }
else
    {
    DWORD       len;
    char        *pdata;

    pdata = (char *) DdeAccessData(hData, &len);
    if (!pdata)
        {
        err = DdeGetLastError(hInst1);
        #if BUGER
        Bugerf("DDECLI - Error accessing %s: %s\n", Item, ddeerr(err));
        #endif
        nErrors++;
        }
    else
        {
        #if BUGER
        Bugerf("DDECLI - ***** Received %s: '%.30s'..\n", Item, pdata);
        #endif

        // PARSE DATA AND STORE IN USER'S BUFFER

        while (isspace(*pdata))
            pdata++;                        // Skip leading white space

        while (*pdata == '-' || isdigit(*pdata))
            {
            *pSamples++ = (short) strtol(pdata, &pdata, 10);
            nSamplesRetrieved++;
    
            while (isspace(*pdata))
                pdata++;                    // Skip trailing white space
            }

        (void) DdeUnaccessData(hData);
        }

    // WE MUST FREE THIS HANDLE

    (void) DdeFreeDataHandle(hData);
    }

return(nSamplesRetrieved);
}

//--------------------------------------------------------------------
// GetTimingInfo - perform timing tests on retrieving a symbol from TEMPO

#define NLOOPS  10000

void
GetTimingInfo(void)
{
    HCONV       hConv;
    HDDEDATA    hData;
    DWORD       start, stop, minValue, maxValue, x;
    char        buf[1024];
    long        i;

hConv = TempoOpenConv(hInst, "TEMPO", "EXPR");

start = GetTickCount();
minValue = 10000;                   // A big number (ms)
maxValue = 0;

for (i = 0; i < NLOOPS; i++)
    {
    x = GetTickCount();
    hData = TempoGetItem(hInst, hConv, "COUNT", CF_TEXT, DDE_TIMEOUT);
    if (!hData)
        break;

    (void) DdeFreeDataHandle(hData);
    x = GetTickCount() - x;         // Runtime for this get
    if (minValue > x)
        minValue = x;
    if (maxValue < x)
        maxValue = x;
    }
stop = GetTickCount();

(void) TempoCloseConv(hConv);

if (i < 1)
    i = 1;

sprintf(buf, "Retrieved COUNT %d times took %d ms (%.3f ms/get, max=%d min=%d)",
    i, stop - start, (float) (stop - start) / i, maxValue, minValue);

MessageBox(hMainHwnd, buf, "GetTimingInfo", MB_OK);
}
