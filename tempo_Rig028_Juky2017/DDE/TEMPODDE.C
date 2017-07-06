/*  .title  TEMPODDE - C Callable routines to access TEMPO/Win's DDE server
;+
; SYNOPSIS
;   UINT TempoInit(DWORD *hInst);
;   UINT TempoUnInit(DWORD hInst);
;   HCONV TempoOpenConv(DWORD hDDEInst, char *Service, char *Topic);
;   long TempoAdvise(DWORD hInst, HCONV hConv, char *Item, PFNCALLBACK Callback);
;   long TempoUnAdvise(long nAdvise);
;   HDDEDATA TempoGetItem(DWORD hInst, HCONV hConv, char *Item, UINT iFmt, DWORD timeout)
;   BOOL TempoCloseConv(HCONV hConv);
;   long TempoExecute(DWORD hInst, HCONV hConv, char *Command, DWORD timeout);
;
; DESCRIPTION
;   This library of routines provides an C example of client-side
;   routines for accessing TEMPO's DDE Server.
;
;   It uses the standard DDEML interface.  DDEML assumes that the thread(s)
;   that this code runs in have a message pump.
;
;   This code is not thread safe.  To make thread save, add a lock
;   on accessing AdvisoryLink[].
;
;   This package supports more than one DDEML instance.  All instances
;   use the same callback function.  It handles XTYP_ADVDATA
;   messages from DDEML (by calling the user's function).  An internal
;   global table keeps track of outstanding advisory requests for all
;   DDEML instances.
;
;   You should use a different DDEML instance for XTYP_REQUEST
;   requests than you use for XTYP_ADVSTART requests.  If you don't,
;   you could get into the situation where an ADVDATA callback is
;   in progress (i.e,. is handing XTYP_ADVDATA) and the client wants
;   to send a (XTYP_REQUEST) request.  If you do this on the same
;   DDEML instance, you will get an error back from DdeClientTransaction
;   saying you tried to perform a REENTRANT call.  This is why you
;   should separate into their own DDEML instances asynchronous Advisory
;   requests from synchronous (XTYP_REQUEST) requests.
;
;   Note two facts about DDEML.  (1) DdeClientTransaction does not
;   allow for reentrancy on the same DDEML instance.
;   (2) DdeClientTransaction has an internal message pump that runs
;   while it is waiting for the server's response.  Thus, if you
;   establish an ADVSTART with a callback that calls DdeClientTransaction,
;   then you should not call DdeClientTransaction outside of the
;   callback.  The reason is that you could violate (1).
;
;   For instance,
;   suppose you call DdeClientTransaction to START the clock.  While
;   the client waits for the server to confirm this, the server sends
;   the client an ADVDATA message which causes the client's callback
;   function which tries to call DdeClientTransaction recursively!
;
;   Two different DDEML instances CAN have outstanding DdeClientTransaction
;   calls at the same time so the solution is to separate 
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
;   07Jun99 sh  Initial edit
;   22Jun99 sh  Protect calls to DdeClientTransaction with critical section
;   30Mar04 sh  Change TempoExecute() return value to return DMLERR_xxx status
;-
*/
#include    <windows.h>

#define BUGER   0

#if BUGER
#include    "..\lib32\buger.h"
#include    "ddeerr.h"
#endif

#include    "tempodde.h"

//static DWORD tlsClientTransactionDepth = ~0; // TLS index for depth count
static DWORD hOurInst;                  // Currently active hInst

// This table keeps track of active Hot/Warm (Advisory) links.
// We need it so that our DDEML callback function can figure
// out which user function to call when it receives a message.

static ADVISORYLINK AdvisoryLink[NMAXADV];  // List of active advisory links

static HDDEDATA CALLBACK DdeCallback(UINT, UINT, HCONV, HSZ, HSZ, HDDEDATA, DWORD, DWORD);

static long FindAdvisoryLink(HCONV hConv, HSZ hItem);
static long AddAdvisoryLink(DWORD hInst, HCONV hConv, HSZ hItem, PFNCALLBACK Callback);
static long DelAdvisoryLink(long i);
//static short WaitForZeroDepth(DWORD timeout);
//static long MessagePump(void);

//--------------------------------------------------------------------
//lint -esym(429,pDepth) pDepth not freed

UINT
TempoInit(DWORD *hInst)
{
    UINT        err;
//    long        *pDepth;

// ALLOCATE A THREAD-LOCAL-STORAGE INDEX FOR DEPTH COUNT.
// Allocate a long and make the tls index a pointer to it.

//tlsClientTransactionDepth = TlsAlloc();
//
//pDepth = calloc(1, sizeof(long));
//if (!pDepth)
//    {
//    MessageBox(NULL, "No memory for depth counter", "TempoInit", MB_OK);
//    return(DMLERR_MEMORY_ERROR);
//    }
//
//*pDepth = 0;                            // Initialize depth counter to 0
//
//(void) TlsSetValue(tlsClientTransactionDepth, pDepth);

err = DdeInitialize(hInst,
            (PFNCALLBACK) DdeCallback,
            APPCLASS_STANDARD | APPCMD_CLIENTONLY,
            0L);

hOurInst = *hInst;                      // Remember for later

return(err);
}

//--------------------------------------------------------------------
UINT
TempoUnInit(DWORD hInst)
{
    UINT            err;
    long            i;
    ADVISORYLINK    *al;

#if BUGER
Bugerf("TempoUnInit begin\n");
Bugerf("TempoUnInit Abandoning all transactions..\n");
#endif
(void) DdeAbandonTransaction(hOurInst, 0, 0);// Abandon all transactions

for (i = 0, al = AdvisoryLink; i < NMAXADV; i++, al++)
    {
    if (al->hInst && al->hInst == hInst)    // Shut down all advisory links
        {                                   // ..for this DDEML instance
        (void) TempoUnAdvise(i);    
        }
    }

err = DdeUninitialize(hInst);

// Let Windows clean up the TLS and its memory.  Otherwise, we
// could be in the middle of a transaction and freeing this memory
// could cause our ClientTransaction() function to crash.
//
//(void) TlsFree(tlsClientTransactionDepth);
//tlsClientTransactionDepth = ~0;

#if BUGER
Bugerf("TempoUnInit end\n");
#endif

return(err);
}

//--------------------------------------------------------------------
HCONV
TempoOpenConv(DWORD hInst, char *Service, char *Topic)
{
    HSZ     hService;
    HSZ     hTopic;
    HCONV   hConv;

hService = DdeCreateStringHandle(hInst, Service, 0);
hTopic   = DdeCreateStringHandle(hInst, Topic,   0);

hConv = DdeConnect(hInst, hService, hTopic, NULL);

//// IF THAT DOESN'T WORK, TRY RUNNING TEMPO/Win
//
//if (!hConv)
//    {
//    WinExec("TEMPOW", SW_SHOW);
//
//    hConv = DdeConnect(hInst, hszService, hszTopic, NULL);
//    }

// FREE THE STRING HANDLES

DdeFreeStringHandle(hInst, hService);
DdeFreeStringHandle(hInst, hTopic);

if (hConv)
    {
    CONVINFO        ConvInfo;
    char            ourText[256];
    char            PartnerText[256];

    (void) DdeQueryConvInfo(hConv, QID_SYNC, &ConvInfo);   

    GetWindowText(ConvInfo.hwnd, ourText, sizeof(ourText));
    GetWindowText(ConvInfo.hwndPartner, PartnerText, sizeof(PartnerText));

    #if BUGER
    Bugerf("TempoOpenConv context.hwnd=%X(%s) .partner=%X(%s)\n",
        (long)ConvInfo.hwnd, ourText,
        (long)ConvInfo.hwndPartner, PartnerText);
    #endif
    }

return(hConv);
}

//--------------------------------------------------------------------

BOOL
TempoCloseConv(HCONV hConv)
{
    BOOL    err;
    long    i;
    ADVISORYLINK *al;

#if BUGER
Bugerf("TempoCloseConv begin\n");
Bugerf("TempoUnInit Abandoning all transactions for hConv..\n");
#endif

(void) DdeAbandonTransaction(hOurInst, hConv, 0);  // Abandon all transactions for this hConv

for (i = 0, al = AdvisoryLink; i < NMAXADV; i++, al++)
    {
    if (al->hConv == hConv)             // Shut down all advisory links
        {
        (void) TempoUnAdvise(i);
        }
    }

err = DdeDisconnect(hConv);
#if BUGER
Bugerf("TempoCloseConv end\n");
#endif
return(err);
}


//--------------------------------------------------------------------
long
TempoAdvise(DWORD hInst, HCONV hConv, char *Item, PFNCALLBACK Callback)
{
    long        i;
    HSZ         hItem;
    HDDEDATA    hData = 0;

hItem = DdeCreateStringHandle(hInst, Item, 0);

i = FindAdvisoryLink(hConv, hItem);
if (i > 0)                                  // Does it already exist?
    {
    AdvisoryLink[i].Callback = Callback;    // Yes, just change callback
    }
else
    {
    i = AddAdvisoryLink(hInst, hConv, hItem, Callback);
    if (i >= 0)                             // Was it added ok?
        {
        hData = DdeClientTransaction(NULL, 0, hConv, hItem,
                                  CF_TEXT,
                                  XTYP_ADVSTART | XTYPF_ACKREQ,
                                  DDE_TIMEOUT, NULL);

        if (!hData)
            {
            (void) DelAdvisoryLink(i);
            i = -1;                     // Error establishing advisory loop
            }
        }
    }

DdeFreeStringHandle(hInst, hItem);
return(i);
}

//--------------------------------------------------------------------
long
TempoUnAdvise(long i)
{
    HDDEDATA    hData = 0;

#if BUGER
Bugerf("TempoUnAdvise begin\n");
#endif

if (i < 0 || i >= NMAXADV)
    goto EXIT;

if (!AdvisoryLink[i].hConv)
    goto EXIT;

hData = DdeClientTransaction(NULL, 0,
                          AdvisoryLink[i].hConv,
                          AdvisoryLink[i].hItem,
                          CF_TEXT,
                          XTYP_ADVSTOP,
                          DDE_TIMEOUT, NULL);

(void) DelAdvisoryLink(i);              // Delete advisory in our table

EXIT:;
#if BUGER
Bugerf("TempoUnAdvise end hData=%X\n", (long) hData);
#endif
return(hData ? 0 : -1);
}

//--------------------------------------------------------------------
static HDDEDATA CALLBACK
DdeCallback(UINT iType, UINT iFmt, HCONV hConv, HSZ hsz1, HSZ hsz2,
            HDDEDATA hData, DWORD dwData1, DWORD dwData2)
{
switch (iType)
    {
    case XTYP_ADVDATA:                  // Returns DDE_FACK, DDE_FBUSY or DDE_FNOTPROCESSED
        {                               // hsz1  = topic
        long    i;                      // hsz2  = item
                                        // hData = data
        i = FindAdvisoryLink(hConv, hsz2);
        if (i < 0)
            {
            return(DDE_FNOTPROCESSED);
            }
        else
            {
            HDDEDATA    hDataReturned;  // hData returned by user's callback

            // CALL USERS'S CALLBACK TO HANDLE THIS MESSAGE

            if (!AdvisoryLink[i].Callback)
                hDataReturned = 0;
            else
                hDataReturned = (*AdvisoryLink[i].Callback)(iType, iFmt, hConv, hsz1, hsz2, hData, dwData1, dwData2);

            return(hDataReturned);
            }
        }

    case XTYP_DISCONNECT:
        {
        //hOurConv = NULL;

        //MessageBox(NULL, "TEMPO disconnected our link.", "TEMPO DDE", MB_ICONASTERISK | MB_OK);

        break;
        }

    default:
        break;
    }

return(NULL);
}                                       //lint !e715 dwData1, dwData2, hsz1, hConv not referenced

//--------------------------------------------------------------------
static long
AddAdvisoryLink(DWORD hInst, HCONV hConv, HSZ hItem, PFNCALLBACK Callback)
{
    long        i;

for (i = 0; i < NMAXADV; i++)
    {
    if (!AdvisoryLink[i].hInst)
        {
        memset(&AdvisoryLink[i], 0, sizeof(ADVISORYLINK));
        AdvisoryLink[i].hInst = hInst;
        AdvisoryLink[i].hConv = hConv;
        AdvisoryLink[i].hItem = hItem;
        AdvisoryLink[i].Callback = Callback;

        // Increment usage count so the item handle doesn't get deleted.

        (void) DdeKeepStringHandle(hInst, hItem);
        return(i);
        }
    }
return(-1);                             // Table is full
}

//--------------------------------------------------------------------
static long
FindAdvisoryLink(HCONV hConv, HSZ hItem)
{
    long        i;

for (i = 0; i < NMAXADV; i++)
    {
    if (AdvisoryLink[i].hInst &&
        AdvisoryLink[i].hConv == hConv && 
        DdeCmpStringHandles(AdvisoryLink[i].hItem, hItem) == 0)
        {
        return(i);
        }
    }
return(-1);                             // Table is full
}

//--------------------------------------------------------------------
static long
DelAdvisoryLink(long i)
{
#if BUGER
Bugerf("DelAdvisoryLink begin\n");
#endif
if (i >= 0 && i < NMAXADV)
    {
    // Reduce usage count for hItem by 1 and delete if 0.

    if (AdvisoryLink[i].hInst && AdvisoryLink[i].hItem)
        (void) DdeFreeStringHandle(AdvisoryLink[i].hInst, AdvisoryLink[i].hItem);

    memset(&AdvisoryLink[i], 0, sizeof(ADVISORYLINK));
    }
#if BUGER
Bugerf("DelAdvisoryLink end\n");
#endif
return(0);
}

//--------------------------------------------------------------------
// TempoGetItem - Retrieve a data item from TEMPO
// The calling application MUST call DdeFreeDataHandle() to free the
// HDDEDATA handle returned by this function.

HDDEDATA
TempoGetItem(DWORD hInst, HCONV hConv, char *Item, UINT iFmt, DWORD timeout)
{
    HDDEDATA        hData;
    HSZ             hItem;

hItem = DdeCreateStringHandle(hInst, Item, 0);

hData = DdeClientTransaction(NULL, 0,
                          hConv,
                          hItem,
                          iFmt,
                          XTYP_REQUEST,
                          timeout, NULL);
            
if (!hData)
    {
    DWORD   err;

    err = DdeGetLastError(hInst);

    #if BUGER
    Bugerf("TempoGetItem - Error retrieving Item='%s': %s\n", Item, ddeerr(err));
    #endif
    }                                   //lint !e550

(void) DdeFreeStringHandle(hInst, hItem);

return(hData);                          // If nonzero, user should free this!
}

//--------------------------------------------------------------------
// TempoExecute - Send a TEMPO command string to TEMPOW client
// IN
//      hInst           DDEML instance handle
//      hConv           DDEML conversation handle
//      Command         TEMPO command string to execute
//      timeout         Maximum timeout to wait (in ms) 
// OUT
//      Returns a DMLERR_xxx status
//      If DMLERR_NO_ERROR (=0), then command was executed successfully.
//      Non-zero value indicates an error.

long
TempoExecute(DWORD hInst, HCONV hConv, char *Command, DWORD timeout)
{
    HDDEDATA        hData;
    long            len;
    DWORD           err;

len = strlen(Command) + 1;              // Include terminating NULL

hData = DdeClientTransaction((LPBYTE) Command, len,
                          hConv,
                          0,
                          0,
                          XTYP_EXECUTE,
                          timeout, NULL);

if (!hData)
    {
    err = DdeGetLastError(hInst);

    #if BUGER
    Bugerf("TempoExecute - Error sending command to TEMPO: '%s': %s\n", Command, ddeerr(err));
    #endif
    }                                   //lint !e550
else
    err = DMLERR_NO_ERROR;

return(err);
}

////--------------------------------------------------------------------
//// The following code was a failed attempt to try to protect against
//// DdeClientTransaction's inability to be called recursively.  The
//// reason it failed (I suspect) is because DdeClientTransaction has
//// an internal while loop that runs the message pump as long as an
//// internal variable isn't set during the time it is waiting for a
//// response from the server.
//// 
//// while (!internal_status)
////     {
////     MessagePump();
////     }
////
//// This internal status gets set when the server sends the client the
//// response (or when a WM_TIMER which DdeClientTransaction sets up
//// is received - this is how it implements a timeout.)
////
//// The problem with the idea below is that WE are running OUR while
//// loop.  The server's DDE message is received via OUR message pump
//// and the internal_status is getting set properly but because WE
//// are waiting for depth==0, the currently running call to DdeClientTransaction
//// does not return so depth does not get decremented.  Remember, all
//// of this is running in one thread - not multiple threads (so the
//// usual win32 coordination primitives (critical sections, mutexes, etc.)
//// won't work for us).
////
//// The bottom line is this:  You need to design your DDE client program
//// in such a way as to insure that you will not recursively call
//// DdeClientTransaction.  So if you are calling DdeClientTransaction
//// via an advisory callback AND you are also calling it based on some
//// user driven event, be warned: you may have a problem.  This will
//// show up when DdeClientTransaction returns DMLERR_REENTRANCY.
////
////
////--------------------------------------------------------------------
//// ClientTransaction - Execute DdeClientTransaction non-recursively
//// DDE forbids recursively calling DdeClientTransaction (it returns
//// DMLERR_REENTRANCY).  Even (especially!) within a single thread,
//// here's how recursion is possible.  While DdeClientTransaction
//// is waiting for the server response, it runs a message pump.
//// If a message (i.e,. a WM_TIMER) message arrives which then
//// calls DdeClientTransaction(), voila.  Recursion.
////
//// Oddly, this situation is not uncommon.  For instance, it is
//// easy to set up an advisory link, say, on EPOCHCOUNT.  When an
//// EPOCHCOUNT is received (via a callback - remember DDE is all
//// message based so the callback is invoked because a message
//// was received from the DDE server), the callback may call DdeClientTransaction
//// to download an EPOCHDATA.  But the user could have caused an call
//// to DdeClientTransaction (i.e., from a menu selection) which
//// could be in progress at the time the advisory message is received
//// from the server.
////
//// Note that DdeClientTransaction get recursively called BECAUSE it has
//// an internal message pump and not because there are multiple threads
//// calling it!  This means that the usual synchronization primitives
//// like CRITICALSECTION and MUTEXes don't work because they don't
//// block a thread that already owns the critical section or mutex.
//// So we have to revert to our own wait procedure.  Which works
//// like this:  wait until (1) depth==0 or timeout.  During the wait,
//// run the message pump.
//
//HDDEDATA
//ClientTransaction(LPBYTE pData, DWORD cbData, HCONV hConv,
//                  HSZ hszItem, UINT wFmt, UINT wType,
//                  DWORD dwTimeout, LPDWORD pdwResult)
//{
//    HDDEDATA    hData;
//    long        *pDepth;
//
//pDepth = (long *) TlsGetValue(tlsClientTransactionDepth);
//if (!pDepth)
//    {
//    Bugerf("DDECLI - ClientTransaction pDepth==NULL\n");
//    return(0);                              // This should be a non-NULL pointer
//    }
//
//if (!WaitForZeroDepth(dwTimeout))
//    {
//    Bugerf("DDECLI - ClientTransaction TIMEOUT ERROR WAITING FOR !*pDepth (*pDepth=%d)!!!\n", *pDepth);
//    return(0);                              // Timeout
//    }
//else
//    {
//    *pDepth += 1;                           // We're inside DdeClientTransaction..
//    Bugerf("DDECLI entered ClientTransaction depth=%d\n", *pDepth);
//
//    hData = DdeClientTransaction(
//                pData,                      // pointer to data to pass to server 
//                cbData,                     // length of data 
//                hConv,                      // handle to conversation 
//                hszItem,                    // handle to item name string 
//                wFmt,                       // clipboard data format 
//                wType,                      // transaction type 
//                dwTimeout,                  // time-out duration 
//                pdwResult);                 // pointer to transaction 
//
//    Bugerf("DDECLI leaving ClientTransaction depth=%d (hData=%X)\n", *pDepth, (long) hData);
//    *pDepth -= 1;                           // We're no longer inside it.
//    }
//
//return(hData);
//}
//
////---------------------------------------------------------------------------
//// WaitForZeroDepth - Waits, up to timeout, for a long to goto zero.
//// The message pump *IS* run during the wait.
//// IN
////      timeout     = (ms) INFINITE or [0..60000]
//// OUT
////      1       successfully 
////      0       otherwise (timeout, WM_QUIT, etc).
//
//static short
//WaitForZeroDepth(DWORD timeout)
//{
//    DWORD   startTime = 0, endTime = 0;
//    long    *pDepth;
//
//pDepth = (long *) TlsGetValue(tlsClientTransactionDepth);
//if (!pDepth)
//    {
//    Bugerf("WaitForZeroDepth - TLS error getting pDepth\n");
//    return(0);                          // This should be a non-NULL pointer!
//    }
//
//if (timeout != INFINITE)
//    {
//    startTime = GetTickCount();
//    if (timeout > 60000)
//        timeout = 60000;                // Keep some reasonable limits
//    endTime = startTime + timeout;
//    }
//
//if (*pDepth)
//    {
//    Bugerf("DDECLI WaitForZeroDepth - *pDepth==%d..\n", *pDepth);
//    //MessageBox(NULL, "Depth non-zero", "WaitForZeroDepth", MB_OK);
//    //return(0);
//    }
//
//while (*pDepth)
//    {
//    if (timeout != INFINITE && GetTickCount() > endTime)
//        {
//        Bugerf("WaitForZeroDepth - Timeout pDepth=%d\n", *pDepth);
//        return(0);                      // timeout waiting for pDepth==0
//        }
//
//    if (MessagePump())                  // Process any waiting messages
//        {
//        Bugerf("WaitForZeroDepth - MessagePump returned 0 pDepth=%d\n", *pDepth);
//        return(0);                      // WM_QUIT detected!
//        }
//
//    Sleep(0);                           // Give up CPU for one cycle
//    }
//
//Bugerf("DDECLI WaitForZeroDepth - Wait successful.  *pDepth==%d..\n", *pDepth);
//return(1);                              // Success: depth==0
//}
//
////-----------------------------------------------------------------------
//// MessagePump - Flush message queue and return when done.
//// All messages except WM_QUIT are read and processed.
//// If WM_QUIT is read or the message queue is empty, this
//// function returns immediately.
//// Use of this function allows the main thread to process messages
//// waiting for some event.
//// See p1247, Win32 Programming, Rector
////
//// IN
////      nothing
//// OUT
////      0           No more messages
////      1           WM_QUIT detected
//
////lint -esym(715,requester)     Not used
//
//static long
//MessagePump(void)
//{
//     MSG         msg;
//
//// Note that PeekMessage() only sees messages for the current
//// thread.  So for worker threads that don't have a message queue,
//// PeekMessage will return immediately.
//
//while (PeekMessage(&msg, NULL, 0, 0, PM_NOREMOVE))    // Petzold, p550
//    {
//    if (msg.message >= WM_DDE_FIRST && msg.message <= WM_DDE_LAST)
//        {
//        static char *wmdde[] = {
//            "WM_DDE_INITIATE",
//            "WM_DDE_TERMINATE",
//            "WM_DDE_ADVISE",
//            "WM_DDE_UNADVISE",
//            "WM_DDE_ACK",
//            "WM_DDE_DATA",
//            "WM_DDE_REQUEST",
//            "WM_DDE_POKE",
//            "WM_DDE_EXECUTE"};
//    
//        Bugerf("MessagePump - %s hwnd=%X wParam=%X lParam=%X\n",
//            wmdde[msg.message - WM_DDE_INITIATE], (long) msg.hwnd, msg.wParam, msg.lParam);
//        }
//
//    if (msg.message == WM_QUIT)
//        {
//        //MessageBox(NULL, "WM_QUIT detected", "MessagePump", MB_OK);
//        Bugerf("DDECLI MessagePump - WM_QUIT detected..\n");
//        return(1);                      // Don't unload WM_QUIT
//        }
//
//    if (!GetMessage(&msg, NULL, 0, 0))  // Get the message
//        break;                          // We should never get here
//
//    Bugerf("DDECLI MessagePump - Dispatching MSG 0x%04X..\n", msg.message);
//    TranslateMessage(&msg);
//    DispatchMessage(&msg);
//    }
//return(0);
//}
