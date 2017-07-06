/*  .title  GETEPOCH - Retrieve an epoch of data from a database
;+
; SYNOPSIS
;       GETEPOCH <db> <epoch> <format>  >data.lst
;
;   Where <db>      is a database number (1, 2, ..)
;         <epoch>   is an epoch number (0, 1, ..)
;         <format>  is =1 (CF_TEXT) or =20 (CF_BINARY)
;  
;   Redirect stdout to a file to save epoch data.
;   If <format> isn't specified, epoch data is retrieved by CF_BINARY
;   If <epoch> isn't specified, the latest epoch is retrieved.
;   If <database> isn't specified, a help message is displayed.
;
; DESCRIPTION
;   This little C program illustrates how to retrieve data
;   from TEMPO's DDE server.  It shows how to access a database's
;   fields, title and epoch data.
;
;   On the command line, you specify the DB, epoch number and the
;   format.  if the format is 0 (CF_TEXT), the actual text data
;   retrieved from TEMPO is printed to stdout.  For format==1 (CF_BINARY),
;   the binary data is converted to text and printed to stdout.
;
;   Errors are sent to stdout.  This program does not perform much
;   error checking; it is intended to illustrate the basics on accessing
;   TEMPO's DDE interface.
;
; NOTE
;   The DDEML interface works with both console applications like
;   this one as well as with Windows based applications such as
;   DDECLI.C.
;
; EDIT HISTORY
;   21Jan00 sh  Initial edit
;-
*/
#include    <windows.h>
#include    <stdio.h>

#include    "tempodde.h"                // TEMPO dde routines
#include    "ddeerr.h"                  // TEMPO dde error messages

static char *help[] = {
"ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿",
"³GETEPOCH - Retrieve an epoch of data from a TEMPO database.          ³",
"³The epoch data is written to stdout.                                 ³",
"³This program is intended to illustrate how to use TEMPO's DDE server ³",
"ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´",
"³Usage: GETEPOCH db epoch fmt                                         ³",
"³Where:                                                               ³",
"³  db      A TEMPO database number [1, 2, ..]                         ³",
"³  epoch   An epoch number [0, 1, ...]  Epoch 0 retrieves latest epoch³",
"³  format  =1 for CF_TEXT (default) or =20 for CF_BINARY              ³",
"³          Format to retrieve epoch data.                             ³",
"³          Epoch data is always written as ascii text to stdout.      ³",
"³                                                                     ³",
"ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ",
0};

static long GetLongData(DWORD hInst, HCONV hConv, long nDb, char *Item, long *value);
static long PrintEpoch(DWORD hInst, HCONV hConv, long nDb, long nEpoch, long nFmt, long dbType, long period, long nchannels);
static long GetTitle(DWORD hInst, HCONV hConv, long nDb, char *buf, long nbytes);

//--------------------------------------------------------------------
void
main(short ac, char *av[])
{
    DWORD   hInst = 0;                 // DDEML application instance
    HCONV   hConvDB = 0;               // DDEML conversation for Topic DB

    UINT    err;
    long    nDb, nEpoch, nFmt;          // Program arguments
    long    period, nchannels;          // Info retrieved from TEMPO
    long    dbType;                     // Database type: HFUNC_SUM, ...
    char    title[256];                 // DB title
    
nDb = 1;                                // Assume database 1
nEpoch = 0;                             // Assume first epoch
nFmt = 1;                               // 1=CF_TEXT 20=CF_BINARY

if (ac <= 1)
    {
    char    **hlp;
    
    for (hlp = help; *hlp; hlp++)
        fprintf(stderr, "%s\n", *hlp);
    return;
    }

nDb = atoi(av[1]);
if (ac > 2)    
    nEpoch = atoi(av[2]);
if (ac > 3)    
    nFmt = atoi(av[3]);
    
nFmt = nFmt;
    
// INITIALIZE DDEML AND GET INSTANCE

err = TempoInit(&hInst);                // Open DDEML application instance
if (err != DMLERR_NO_ERROR)
     {
     fprintf(stderr, "Failed to initialize TEMPO DDE client! %s", ddeerr(err));
     goto EXIT;
     }
     
// OPEN A CONVERSATION TO TOPIC DB
     
hConvDB = TempoOpenConv(hInst, "TEMPO", "DB");
if (!hConvDB)
    {
    fprintf(stderr, "Failed to connect to TEMPO Topic DB\n");
    goto EXIT;
    }

// GET DATABASE INFORMATION

if (GetTitle(hInst, hConvDB, nDb, title, sizeof(title)))
    {
    fprintf(stderr, "Error getting title for DB%d\n", nDb);
    goto EXIT;
    }
    
fprintf(stderr, "Database %d: %s\n", nDb, title);

if (!GetLongData(hInst, hConvDB, nDb, "TYPE", &dbType))
    {
    fprintf(stderr, "Failed to get TYPE for DB%d\n", nDb);
    goto EXIT;
    }
    
fprintf(stderr, "Type is %d\n", dbType);

if (!GetLongData(hInst, hConvDB, nDb, "PERIOD", &period))
    {
    fprintf(stderr, "Failed to get PERIOD for DB%d\n", nDb);
    goto EXIT;
    }

fprintf(stderr, "Period is %d\n", period);

if (!GetLongData(hInst, hConvDB, nDb, "NCHANNELS", &nchannels))
    {
    fprintf(stderr, "Failed to get NCHANNELS for DB%d\n", nDb);
    goto EXIT;
    }

fprintf(stderr, "Channels is %d\n", nchannels);

// RETRIEVE EPOCH DATA

err = PrintEpoch(hInst, hConvDB, nDb, nEpoch, nFmt, dbType, period, nchannels);
if (err)
    {
    fprintf(stderr, "Error retrieving DB%d Epoch %d Fmt %d\n", nDb, nEpoch, nFmt);
    goto EXIT;
    }


EXIT:;

if (hConvDB)
    (void) TempoCloseConv(hConvDB);
    
if (hInst)
    (void) TempoUnInit(hInst);
}

//--------------------------------------------------------------------
static long
GetLongData(DWORD hInst, HCONV hConv, long nDb, char *Item, long *value)
{
    HDDEDATA        hData;
    DWORD           len;
    char            *pdata;
    char            item[128];
    long            iFmt = CF_BINARY;   // CF_TEXT or CF_BINARY

sprintf(item, "%s %d", Item, nDb);
hData = TempoGetItem(hInst, hConv, item, iFmt, DDE_TIMEOUT);
if (!hData)
    {
    return(0);
    }

pdata = (char *) DdeAccessData(hData, &len);
if (pdata)
    {
    // PARSE DATA AND STORE IN USER'S BUFFER
    
    if (iFmt == CF_BINARY)
        *value = *((long *) pdata);
    else                                // CF_TEXT
        *value = strtol(pdata, &pdata, 10);
    }

(void) DdeUnaccessData(hData);

// WE MUST FREE THIS HANDLE

(void) DdeFreeDataHandle(hData);
return(pdata ? 1 : 0);
}

//--------------------------------------------------------------------
static long
GetTitle(DWORD hInst, HCONV hConv, long nDb, char *buf, long nbytes)
{
    HDDEDATA        hData;
    DWORD           len;
    char            *pdata;
    char            Item[64];

memset(buf, 0, nbytes);
sprintf(Item, "TITLE %d", nDb);
hData = TempoGetItem(hInst, hConv, Item, CF_TEXT, DDE_TIMEOUT);
if (!hData)
    {
    return(-1);                     // Error getting data
    }

pdata = (char *) DdeAccessData(hData, &len);
if (pdata)
    {
    // PARSE DATA AND STORE IN USER'S BUFFER

    sprintf(buf, "%.*s", nbytes - 1, pdata);
    }

(void) DdeUnaccessData(hData);

// WE MUST FREE THIS HANDLE

(void) DdeFreeDataHandle(hData);
return(pdata ? 0 : -2);
}

//--------------------------------------------------------------------
static long
PrintEpoch(DWORD hInst, HCONV hConv, long nDb, long nEpoch, long nFmt, long dbType, long period, long nchannels)
{
    HDDEDATA        hData;
    char            *pdata = 0;
    char            Item[128];
    DWORD           len;


//fprintf(stderr, "nDb=%d nEpoch=%d nFmt=%d dbType=%d period=%d nchannels=%d\n", nDb, nEpoch, nFmt, dbType, period, nchannels);
sprintf(Item, "EPOCHDATA %d %d", nDb, nEpoch);
hData = TempoGetItem(hInst, hConv, Item, nFmt, DDE_TIMEOUT);
if (!hData)
    {
    fprintf(stderr, "PrintEpoch - TempoGetItem failed\n");
    return(0);
    }

pdata = (char *) DdeAccessData(hData, &len);
if (pdata)
    {
    // PARSE DATA AND STORE IN USER'S BUFFER
    
    if (nFmt == CF_BINARY)
        {
        long    sampleSize, isSigned;
        long    row, col;
        
        switch (dbType)
            {
            default:
            case HFUNC_APP:             //  signed (8 bit) char     Append
            case HFUNC_SUM:             //  signed (8 bit) short    Sum
                    isSigned = 1;    
                    sampleSize = sizeof(char);
                    break;
            case HFUNC_USUM:            //  unsigned short          Sum
            case HFUNC_UAPP:            //  unsigned short          Append
            case HFUNC_ESUM:            //  unsigned short          Sum
            case HFUNC_EAPP:            //  unsigned short          Append
                    isSigned = 0;
                    sampleSize = sizeof(unsigned short);
                    break;
            
            case HFUNC_XSUM:            //  signed (12 bit) short   Sum
            case HFUNC_XAPP:            //  signed (12 bit) short   Append
                    isSigned = 1;
                    sampleSize = sizeof(short);
                    break;
            }
            
        //fprintf(stderr, "PrintEpoch - CF_BINARY isSigned=%d sampleSize=%d\n", isSigned, sampleSize);
        
        if (isSigned)
            {
            if (sampleSize == sizeof(char))
                {
                char *p = (char *) pdata;
                
                for (row = 0; row < period; row++)
                    {
                    for (col = 0; col < nchannels; col++)
                        printf("%6d", *p++);
                    printf("\n");
                    }
                }
            else
                {
                short *p = (short *) pdata;
                
                for (row = 0; row < period; row++)
                    {
                    for (col = 0; col < nchannels; col++)
                        printf("%6d", *p++);
                    printf("\n");
                    }
                }
            }
        else
            {
            unsigned short *p = (unsigned short *) pdata;
            
            for (row = 0; row < period; row++)
                {
                for (col = 0; col < nchannels; col++)
                    printf("%6u", *p++);
                printf("\n");
                }
            }
        }
    else // CF_TEXT
        {
        //fprintf(stderr, "PrintEpoch - CF_TEXT..\n");
        printf("%s\n", pdata);
        }
    }

(void) DdeUnaccessData(hData);

// WE MUST FREE THIS HANDLE

(void) DdeFreeDataHandle(hData);

return(!pdata ? 1 : 0);
}
