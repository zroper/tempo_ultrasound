#define RELEASE     1
#define VERSION     8
//-------------------------------------------------------------------------
// TGS.C Example TEMPO GRID Application Program
//-------------------------------------------------------------------------
// Usage:
//
//      TGS [switches] [file.log]
//
//  Switches:
//      -e          Display received packets as TEMPO/COBALT epoch data
//
//          If file.log is specified, logging messages will be saved to it.
//          If it already exists, the original will be renamed file.BAK
//
// DESCRIPTION
//  This sample TG program is used to illustrate a number of concepts
//  used by the TG Library.  It is designed to act as a sender of HS
//  data, as a receiver of HS data or as both (ie a "middle man" that
//  passed objects it receives to its output connection).
//
//  So it can be "talk" to itself.  It can be run multiple times and
//  configured differently in each instance.  For example, ELSIE can
//  create a logical computation that contains two NODES, one configuring
//  this program as a sender and the other configuring this program as a
//  be a receiver.
//
//  It can also receive data epochs from any of TEMPO's or COBALT's
//  databases by configuring a receive connection and specifying the -e
//  switch on the command line.
//
//  This program can be configured by ELSIE to run in one of three modes:
//
//      One receive Hyperstream Connection:
//          The program waits for incoming objects from the Hyperstream
//          receive connection, removes the objects from the HS receive
//          buffer and discards the data.  It checks the sequence number
//          and displays a message if it receives objects out of sequence.
//
//          If the -e switch is specified on the command line, the
//          object is interpreted as an LCTEMPO.H header + data from
//          TEMPOW or COBALT.  The header is displayed followed by
//          data from the first few channel sets of each epoch.
//
//      One send Hyperstream Connection:
//          The program produces objects (a sequence number)
//          and writes it to the send connection.
//
//      One send and one receive Hyperstream Connection:
//          The program reads the object from the receive connection
//          and writes it to the send connection.
//
//  It also illustrates some other features:
//
//      o From a NODE's point of view, how it should start and shutdown.
//      o How a NODE can send a message to the controller (ie ELSIE)
//          using tgPrintf()
//      o How a NODE can send a message to another NODE using tgSendf()
//      o How a NODE can receive a message from another NODE (tgcbReceive())
//      o How a NODE can send a query to another NODE using tgQueryf()
//      o How a NODE can process a query from another NODE and return
//          a result (see tgcbQuery)
//      o How a NODE can process LC State information (see tgState())
//      o How a NODE can open and close HS send and receive connections
//          (see tgcbOpenSend(), tgcbCloseSend(), tgcbOpenReceive and
//          tgcbCloseReceive())
//      o How a NODE can send and receive HS objects (see processData()).
//      
//
// It is an exercise left to the reader to add the capability of handling
// multiple HS connections.
//
// This program LOG file is produced with a transcript of all activities.
//
//
// EDIT HISTORY
//  20Jul06 sh  v1.3 Add file.log argument to command line
//  04Sep06 sh  V1.4 Add EXIT STATE
//  20Sep06 sh  modify for tgv1.4 callback table
//  22Sep06 sh  V1.5 Allow for arbitrary connectionID from ELSIE
//  03Oct06 sh  V1.6 include files in TEMPODLL instead of LIB32
//  17Nov06 sh  V1.7 Fix bug handling command line switches
//  08Dec06 sh  V1.8 ProcessData: Display database title from epoch header.
//  10Feb07 sh  V1.9 Don't Sleep(250) before calling tgUninit


#include <windows.h>
#include <stdio.h>
#include <conio.h>
#include <process.h>
#include <io.h>
#include <time.h>

#include    "exceptio.h"        // Win32 Exception handling
#include    "fio.h"             // For debugging
#include    "param.h"           // Parameter manipulation routines
#include    "tg.h"              // TEMPO Grid definitions
#include    "sstempo.h"         // Symphony Server defintions for accessing TEMPO/COBALT



//------------------------------------

#define ESC     '\033'          // ESC key on keyboard (used to abort program)

//------------------------------------
// TG Callback function table and function prototypes
// The user may optionally define a callback function
// which the TEMPO grid will call at the appropriate time.
// These callback functions are called from within the
// context of the TEMPO Grid thread (not your main thread).
// So until they return, your application will not respond
// to the TEMPO grid.
//
// They are intended to inform your application of
// certain events so that your application can perform
// the desired actions.
//
// If your application needs to perform actions that
// can take a "long time" (more than a second or so),
// you should use a worker thread to perform the action.


static long tgcbAskSend(const TG_RQSTRESP     *rr,        // Ask about HS SEND connection
                    const TG_CONNECTINFO      *ci);       // 
static long tgcbOpenSend(const TG_RQSTRESP    *rr,        // Open HS SEND connection
                     const TG_CONNECTINFO     *ci);       // 
static long tgcbCloseSend(const TG_RQSTRESP   *rr,        // Close HS SEND connection
                     const TG_CONNECTINFO     *ci);       //
static long tgcbAskRecv(const TG_RQSTRESP     *rr,        // Ask about HS RECV connection
                     const TG_CONNECTINFO     *ci);       //
static long tgcbOpenRecv(const TG_RQSTRESP    *rr,        // Open HS RECV connection
                     const TG_CONNECTINFO     *ci);       //
static long tgcbCloseRecv(const TG_RQSTRESP   *rr,        // Close HS RECV connection
                     const TG_CONNECTINFO     *ci);       //
static long tgcbState(const TG_RQSTRESP       *rr,        // Logical Computation State
                     long                     state);     //
static long tgcbQuery(const TG_RQSTRESP       *rr);       // Unknown query handler
static long tgcbRecv(const TG_RQSTRESP        *rr);       // Receive message from remote tgSendf
static void tgcbMessage(const TG *hTG, const char *text);   // Status message from TG
static void tgcbLog(const TG *hTG, const char *text);       // debugging messages from TG
static long tgcbMyExceptionHandler(const TG *hTG, const char *threadName, const EXCEPTION_RECORD *pExceptionRecord, const CONTEXT *pContext);


TGCBFUNCTIONS Tgcb =
    {
    TG_VERSION, TG_SET, sizeof(TGCBFUNCTIONS),      // Required for all callback tables
    
    tgcbAskSend,                        // Ask about HS SEND connection
    tgcbOpenSend,                       // Open HS SEND connection
    tgcbCloseSend,                      // Close HS SEND connection
    
    tgcbAskRecv,                        // Ask about HS RECV connection
    tgcbOpenRecv,                       // Open HS RECV connection
    tgcbCloseRecv,                      // Close HS RECV connection
    
    tgcbState,                          // Logical Computation state
    
    tgcbQuery,                          // Unknown query handler
    tgcbRecv,                           // Receive message from remote tgSendf
    
    tgcbMessage,                        // Status message from TG
    tgcbLog,                            // For TG debugging messages
    tgcbMyExceptionHandler              // For Hyperstream and TG thread exceptions (including user's callback)
    };
    


//------------------------------------
// DECLARE global variables here

TG          hTG;                        // TG handle
HANDLE      hMainExitEvent;             // A Win32 event flag we will signal main() to exit
HANDLE      hThreadEvent;               // A Win32 event flag we will signal our thread
char        myNodeName[TG_TGCMDSRV_NODENAMESIZE]; // The NODE name given to us by ELSIE
char        logFileName[_MAX_PATH];     // Name of log file
char        bakFileName[_MAX_PATH];     // Name of BAK file (copy of previous LOG file)
FILE        *logFid = 0;                // FILE id of log file (0 if not opened)
char        myComputerName[MAX_COMPUTERNAME_LENGTH + 1];   // Name of computer that we're running on


//------------------------------------
// We will use the SendConnection[] and RecvConnection[] tables
// to keep track of details about each connection.

//lint -esym(754, reserved)

typedef struct
    {
    char                isUsed;         // == 1 iff this block is used
    char                reserved[3];    //
    char                *buf;           // Malloc'd read/write buffer
    long                nBytes;         // # of bytes of buffer
    TG_CONNECTINFO      ci;             // Connection information
    } CONNECTION;

static CONNECTION   SendConnection[NTGCONNECTIONS];   // Receive connection info
static CONNECTION   RecvConnection[NTGCONNECTIONS];   // Send connection info

static short displayTEMPOdata = 0;      // ==1 for -e switch to display TEMPO epoch


//------------------------------------
// DECLARE local functions here

static long myprintf(char *fmt, ...);   //lint -printf(1, myprintf)  -esym(534,myprintf)
static long statusf(char *fmt, ...);    //lint -printf(1, statusf) -esym(534,statusf)
static char *szHeaderType(char headerType);
static long doOpen(const TG_RQSTRESP *rr, const TG_CONNECTINFO *ci);
static long doClose(const TG_RQSTRESP *rr, const TG_CONNECTINFO *ci);

static void logf(char *fmt, ...);

//------------------------------------
// Here is your main function.

short
main(short ac, char *av[])
{
    long        tgerr;                      // a TG_xxx status
    DWORD       n;
    time_t      startTime;                  // Starting time
    long        iarg;

n = sizeof(myComputerName);
(void) GetComputerName(myComputerName, &n); // Get name of this computer

for (iarg = 1; iarg < ac; iarg++)
    {
    if (av[iarg][0] != '-')                 // switch?
        break;                              // End of switches
        
    switch (tolower(av[iarg][1]))
        {
        case 'e':       displayTEMPOdata = 1; break;
        
        default:        printf("TGS - Unknown switch '%s' ignored.\n", av[iarg]);
        }
    }

// Open a LOG file, if specified

if (iarg < ac && av[iarg])
    {
    sprintf(logFileName, "%.*s", sizeof(logFileName) - 1, av[iarg]);
    sprintf(bakFileName, "%.*s.BAK", sizeof(bakFileName) - 4 - 1, logFileName); // 4=sizeof(".BAK")
    
    if (access(logFileName, 0) == 0)        // Does the LOG file exist?
        {                                   // Yes.
        if (access(bakFileName, 0) == 0)    // Does the BAK file exist?
            remove(bakFileName);            // Yes, delete it
        
        (void) rename(logFileName, bakFileName);   // Rename LOG to BAK
        
        // Now logFileName shouldn't exist
        }
    
    //logFid = fopen(logFileName, "a");       // Open for append
    //if (!logFid)
    //    {
    //    printf("TGS - ERROR opening LOG file '%s'\n", logFileName);
    //    printf("    - LOGGING is disabled.\n");
    //    }
    }

time(&startTime);                           // Time we started
myprintf("TGS %d.%d Set %d.%d Example TEMPO Grid Application\n",
    RELEASE, VERSION,
    TG_VERSION, TG_SET);
myprintf("On COMPUTER '%s' %s", myComputerName, ctime(&startTime));
if (logFileName[0])
    myprintf("LOG file: %s\n", logFileName);
    
// The main thread will wait on the hMainExitEvent then call tgUninit and exit.

hMainExitEvent = CreateEvent(NULL,          // no security
                TRUE,                       // is event manual-reset?
                FALSE,                      // is event initially signaled?
                NULL);                      // event name
if (!hMainExitEvent)
    {
    myprintf("Error creating MAINEXIT event.\n");
    goto EXIT;
    }

// We'll create our data processing thread when we receive
// EndInitialization state message.
// The hThreadEvent will be used to wake up our data processing thread.

hThreadEvent = CreateEvent(NULL,            // no security
                TRUE,                       // is event manual-reset?
                FALSE,                      // is event initially signaled?
                NULL);                      // event name
if (!hThreadEvent)
    {
    myprintf("Error creating THREAD event.\n");
    goto EXIT;
    }


// Initialize the TEMPO Grid
//
// This starts a separate thread and communicates with
// the TEMPO Grid Controller (ELSIE).
// Your application is free to do other things while the
// TEMPO Grid thread runs in the background.
//
// Note that ELSIE will assign our NODE name to us so we
// specify NULL here.

tgerr = tgInit(&hTG, NULL, 0, &Tgcb, 0, 1);
if (tgerr)
    myprintf("tgInit - ERROR %d: %s\n", tgerr, tgErr(tgerr));
else
    {
    // Perform any other actions you wish.
    // The TEMPO Grid runs in a separate thread from
    // your main process thread.
    //
    // Here, we will wait here for either a keyboard hit
    // or when the hStopEvent is signaled.
    
    while (1)
        {
        DWORD       dResult;            // Return value from WaitForSingleObject
        
        // Here is where we wait to be told to exit
        
        dResult = WaitForSingleObject(hMainExitEvent, 250); // Check keyboard ever so often
        (void) ResetEvent(hMainExitEvent);  // Get ready for next time
        switch (dResult)
            {
            case    WAIT_TIMEOUT:;
                {
                if (kbhit())
                    {
                    if (getch() == ESC)
                        {
                        myprintf("TGS - User entered ESC key - Aborting program.\n");
                        goto QUIT;
                        }
                    }
                continue;               // Keep waiting
                }
                
            case    WAIT_OBJECT_0:;
                goto QUIT;              // Our application requested we terminate
                
            case    WAIT_FAILED:;
                                        //lint -fallthrough
            case    WAIT_ABANDONED:;
                                        //lint -fallthrough
            default:    
                goto QUIT;              // Something serious is wrong
            }
        }    
        
    QUIT:;
        
        
    // If we received a state EXIT message, the TG callback thread
    // needs a little time to return a response back to ELSIE.
    
    //Sleep(250);
    
    // When your application is ready to exit, it calls
    // the tgUninit() function to shut down its TEMPO grid thread.
    
    tgerr = tgUninit(&hTG);             // Uninitialize TEMPO Grid
    if (tgerr)
        myprintf("tgUninit - ERROR %d: %s\n", tgerr, tgErr(tgerr));
    }

EXIT:;

if (hMainExitEvent)                     // Close our main event
    {
    CloseHandle(hMainExitEvent);
    hMainExitEvent = 0;
    }

if (hThreadEvent)                       // Close our thread event
    {
    CloseHandle(hThreadEvent);
    hThreadEvent = 0;
    }

if (logFid)
    {
    fclose(logFid);                     // Close LOG file
    logFid = 0;
    }
    
return(0);
}


//------------------------------------
// This function is called if a problem occurs within your
// callback function that causes a program exception.
// Refer to your Win32 documentation on exception handling
// for more information.


static long
tgcbMyExceptionHandler(const TG *hTg, const char *threadName, const EXCEPTION_RECORD *pExceptionRecord, const CONTEXT *pContext)
{
    static  long depth = 0;             // Recursion depth   
    DWORD   Ecode;                      // Exception code
    void    *Eaddr;                     // Address of exception
    char    *Estring;                   // Error string
    
depth++;
    
myprintf("***************************TGS tgcbMyExceptionHandler (depth=%d)***********************\n", depth);

if (depth > 1)
    {
    myprintf("TGS tgcbMyExceptionHandler recursion detected - exiting.\n");
    
    depth--;
    return(0);
    }

hTg = hTg;

myprintf("threadName=%p, pExceptionRecord=%p, pContext=%p processID=%X threadID=%X\n", 
    threadName,
    pExceptionRecord,
    pContext,
    GetCurrentProcessId(),
    GetCurrentThreadId());

if (threadName)
    myprintf("Exception in '%s'\n", threadName);


if (pExceptionRecord)
    {
    Ecode = pExceptionRecord->ExceptionCode;
    Eaddr = pExceptionRecord->ExceptionAddress;
    Estring = GetExceptionString(Ecode);
    }
else
    {
    Ecode = 0;
    Eaddr = 0;
    Estring = "Unknown Exception";
    }
    
myprintf(" Exception detected In: %s\n", threadName);
myprintf(" Program Addr=%p\n", Eaddr);
myprintf(" Ecode=%X %s\n", Ecode, Estring ? Estring : "UnknownException");

pContext = pContext;

(void) flushall();
return(0);
}


//------------------------------------
// logf - Printf to the LOG file
// This is called by TG to put a message into the LOG file
//
// IN
//      fmt         A printf-style format string
//      ...         Additional arguments
//
// RETURNS
//      Number of bytes written to LOG file

static void
logf(char *fmt, ...)
{
    va_list         arg_ptr;            // for formatting
    char            buf[1024];
    
// Format message
    
va_start(arg_ptr, fmt);
memset(buf, 0, sizeof(buf));
(void) _vsnprintf(buf, sizeof(buf) - 1, fmt, arg_ptr);
va_end(arg_ptr);

// Write message to LOG file

if (logFileName[0])
    {
    SYSTEMTIME      systime;
    
    GetSystemTime(&systime);
    
    (void) FIOWriteStrToFilename(logFileName, "%02u.%02u.%03u: %s",
        systime.wMinute,
        systime.wSecond,
        systime.wMilliseconds,
        buf);
    }
}


//------------------------------------
// myprintf - Printf to the screen and LOG file
//
// IN
//      fmt         A printf-style format string
//      ...         Additional arguments
//
// RETURNS
//      Number of bytes written to LOG file

static long
myprintf(char *fmt, ...)
{
    long            n;                  // # bytes in buffer (including NULL)
    va_list         arg_ptr;            // for formatting
    char            buf[2048];

va_start(arg_ptr, fmt);
n = _vsnprintf(buf, sizeof(buf) - 1, fmt, arg_ptr);   // Important to use n-1!
va_end(arg_ptr);

if (n < 0 || n >= (long) sizeof(buf))
    n = sizeof(buf) - 1;
buf[n] = 0;                             // Guarantee NULL terminated

// Write message to LOG file

logf("%s", buf);

printf("%s", buf);

return(n);
}


//------------------------------------
// statusf - statusf to the LOG file and to ELSIE
// Status messages don't have terminating \n so we add one.
//
// IN
//      text        text to display             
//
// RETURNS
//      Number of bytes written to LOG file

static long
statusf(char *fmt, ...)
{
    long            n;                  // # bytes in buffer (including NULL)
    va_list         arg_ptr;            // for formatting
    char            buf[2048];
    TG_QUERY        tgquery;

va_start(arg_ptr, fmt);
n = _vsnprintf(buf, sizeof(buf) - 1, fmt, arg_ptr);   // Important to use n-1!
va_end(arg_ptr);

if (n < 0 || n >= (long) sizeof(buf))
    n = sizeof(buf) - 1;
buf[n] = 0;                             // Guarantee NULL terminated

myprintf("%s\n", buf);

// Here is an example of how to send a message to ELSIE.
// ELSIE will print/display it to the user.

tgquery = tgSendf(&hTG, LCID_UNKNOWN, TGSRVNODENAME_ELSIE, "%s\n", buf);
if (tgquery.tgerr != TG_OK)
    {
    myprintf("statusf - Error %d sending status message to ELSIE: %s\n",
        tgquery.tgerr,
        tgErr(tgquery.tgerr));
    myprintf("status - %s\n", buf);
    }

return(n);
}



//------------------------------------
// tgcbLog - Printf to the LOG file
// This is called by TG to put a message into the LOG file
//
// IN
//      htg         Pointer to TG control block
//      text        TG debug text (with newlines) to but into LOG file
//
// RETURNS
//      Number of bytes written to LOG file

static void
tgcbLog(const TG *htg, const char *text)
{
    char    nodeName[TG_TGCMDSRV_NODENAMESIZE];
    long    tgerr;
    
// Get NODE name for this message
    
tgerr = tgGetInfo(htg, TGGI_GETMYNODENAME, nodeName, sizeof(nodeName));
if (tgerr < 0 || !nodeName[0])
    sprintf(nodeName, "?NoNodeName?");

// Write message to LOG file

logf("tgcbLog %s: %s", nodeName, text);

return;
}



//------------------------------------
// tgcbMessage - Display a status message from TG
// This function is called by TG when to display messages related to unusual conditions.
// These messages are typically one line or less and don't have terminating newline (\n).
//
// IN
//      htg         Pointer to TG control block
//      text        text (without newlines) to display to user            
//
// RETURNS
//      Nothing

static void
tgcbMessage(const TG *htg, const char *text)
{
    char    nodeName[TG_TGCMDSRV_NODENAMESIZE];
    long    tgerr;
    
// Get NODE name for this message
    
tgerr = tgGetInfo(htg, TGGI_GETMYNODENAME, nodeName, sizeof(nodeName));
if (tgerr < 0 || !nodeName[0])
    sprintf(nodeName, "?NoNodeName?");

// Write message to stdout

printf("tgcbMessage %s: %s\n", nodeName, text);

// Write message to LOG file

logf("tgcbMessage %s: %s\n", nodeName, text);                  // Don't use statusf() here!
}





//------------------------------------
// tgcbAskSend - Ask about a SEND connection
// This function is called by TG before a new SEND connection is being established.
// It allows ELSIE to query the send and receive ends in order to build a list
// of connection parameters (and their values) that both sender and receiver accept.
//
// IN
//      rr              Information about the request
//      ci              Information about the connection
//
// OUT
//      0               We can accept parameter list as it is
//      1               We can accept parameter list with modifications
//      <0              We can not accept parameter list

static long
tgcbAskSend(const TG_RQSTRESP    *rr,
         const TG_CONNECTINFO    *ci)
{
rr = rr;
ci = ci;
return(0);
}

         

//------------------------------------
// tgcbAskRecv - Ask about a RECV connection
// This function is called by TG before a new RECV connection is being established.
// It allows ELSIE to query the send and receive ends in order to build a list
// of connection parameters (and their values) that both sender and receiver accept.
//
// IN
//      rr              Information about the request
//      ci              Information about the connection
//
// OUT
//      0               We can accept parameter list as it is
//      1               We can accept parameter list with modifications
//      <0              We can not accept parameter list

static long
tgcbAskRecv(const TG_RQSTRESP    *rr,
         const TG_CONNECTINFO    *ci)
{
    ULONG   mdbObjects = 0;
    ULONG   mdbObjectSize = 0;
    long    paramerr;
    
ci = ci;

logf("tgcbAskRecv - rr=%p ci=%p\n", rr, ci);
logf("tgcbAskRecv - rr->resp = %p\n", rr->resp);
logf("tgcbAskRecv - rr->resp = '%s'\n", rr->resp);
logf("tgcbAskRecv - rr->nRespSize=%d\n", rr->nRespSize);
    
// If no the MDB object size and count isn't in the LC file
// and the sender doesn't specify it, let's specify it here.

logf("tgcbAskRecv - calling paramGetULong=%p\n", paramGetULong);
paramerr = paramGetULong(rr->resp, &mdbObjects, "%s", TGSRVPARAM_MDBOBJECTS);
logf("tgcbAskRecv - paramGetULong paramerr=%d, mdbObjects=%d MDBOBJECTS='%s'\n", 
    paramerr, mdbObjects, TGSRVPARAM_MDBOBJECTS);

if (!mdbObjects)
    {
    mdbObjects = 10;                    // Set default # of objects
    
    logf("tgcbAskRecv - calling paramAppendUnique=%p.\n", paramAppendUnique);
    paramerr = paramAppendUnique(rr->resp, rr->nRespSize, TGSRVPARAM_MDBOBJECTS "=%u\n", mdbObjects);

    logf("tgcbAskRecv - paramAppendUnique paramerr=%d\n", paramerr);
    logf("tgcbAskRecv - paramAppendUnique rr->resp='%s'\n", rr->resp);
    }

logf("tgcbAskRecv - calling paramGetULong=%p\n", paramGetULong);
paramerr = paramGetULong(rr->resp, &mdbObjectSize, "%s", TGSRVPARAM_MDBOBJECTSIZE);
logf("tgcbAskRecv - paramGetULong paramerr=%d, mdbObjects=%d MDBOBJECTS='%s'\n", 
    paramerr, mdbObjects, TGSRVPARAM_MDBOBJECTS);
    
if (mdbObjectSize < 2)
    {
    mdbObjectSize = 100000;             // Set default object size
    logf("tgcbAskRecv - calling paramAppendUnique=%p.\n", paramAppendUnique);
    paramerr = paramAppendUnique(rr->resp, rr->nRespSize, TGSRVPARAM_MDBOBJECTSIZE "=%u\n", mdbObjectSize);

    logf("tgcbAskRecv - paramAppendUnique paramerr=%d\n", paramerr);
    logf("tgcbAskRecv - paramAppendUnique rr->resp='%s'\n", rr->resp);
    }
    
logf("tgcbAskRecv - returning 0\n");

return(0);
}

         

//------------------------------------
// tgcbOpenSend - Open a SEND connection
// This function is called by TG when a new SEND connection is being established.
//
// IN
//      rr              Information about the request
//      ci              Information about the connection
//
// OUT
//      0               Successful
//      not zero        An error status

static long
tgcbOpenSend(const TG_RQSTRESP    *rr,
         const TG_CONNECTINFO     *ci)
{
return(doOpen(rr, ci));
}

         

//------------------------------------
// tgcbOpenRecv - Open a RECV connection
// This function is called by TG when a new SEND connection is being established.
//
// IN
//      rr              Information about the request
//      ci              Information about the connection
//
// OUT
//      0               Successful
//      not zero        An error status

static long
tgcbOpenRecv(const TG_RQSTRESP    *rr,
         const TG_CONNECTINFO     *ci)

{
return(doOpen(rr, ci));
}



//------------------------------------
// doOpen - Open HS SEND or RECV connection
// This is called when a new SEND or RECV connection is being opened.
//
// IN
//      rr              Information about the request
//      ci              Information about the connection
//
// OUT
//      0               Successful
//      not zero        An error status
//lint -esym(715,rr)

static long
doOpen(const TG_RQSTRESP    *rr,
       const TG_CONNECTINFO *ci)              // Connection information
{
    CONNECTION      *CTable;            // Pointer to RecvConnection[] or SendConnection[]
    CONNECTION      *c;                 // Pointer into CTable[]
    char            *connectionType;    // "SEND" or "RECV"
    long            i;

if (ci->flag== TGCI_RECV)
    myprintf("  tgcbOpen RECV %s (CID %d): %s(%s:%u) --> (CID %d) %s(%s:%u) \n",
        ci->connectName,
        ci->localConnectID,
        ci->remoteNodeName,
        ci->localNode.ip,
        ci->localNode.port,
        ci->remoteConnectID,
        myNodeName,
        ci->remoteNode.ip,
        ci->remoteNode.port);
else
    myprintf("  tgcbOpen SEND %s (CID %d): %s(%s:%u) --> (CID %d) %s(%s:%u) \n",
        ci->connectName,
        ci->localConnectID,
        myNodeName,
        ci->localNode.ip,
        ci->localNode.port,
        ci->remoteConnectID,
        ci->remoteNodeName,
        ci->remoteNode.ip,
        ci->remoteNode.port);
    
    
logf("  Connect Info: flag=0x%X  nObjects=%u nObjectSize=%u remotePort=%u\n",
    ci->flag,
    ci->nObjects,
    ci->nObjectSize,
    ci->remoteNode.port);
    
// Remember connection information

if (ci->flag == TGCI_RECV)
    {
    connectionType = "RECV";
    CTable = RecvConnection;
    }
else
    {
    connectionType = "SEND";
    CTable = SendConnection;
    }
    
// Locate the next free slot in our connection table for this connectid.

for (i = 0, c = CTable; i < NTGCONNECTIONS; i++, c++)
    {
    if (!c->isUsed)
        break;
    }

if (i == NTGCONNECTIONS)
    {
    return(-1);                         // Our connection table is full
    }
    
memset(c, 0, sizeof(CONNECTION));       // Start with a clean slate
c->isUsed = 1;                          // Mark this entry as being used

//// If buffer is already allocated, free it.
//
//if (c->buf)                             // If buffer is already allocated..
//    {
//    myprintf("  tgcbOpen - Closing %s connection %d\n", connectionType, ci->connectid);
//    
//    free(c->buf);                       // ..Free it
//    memset(c, 0, sizeof(CONNECTION));
//    }

//myprintf("  tgcbOpen Opening %s connection %d\n", connectionType, ci->connectid);

c->ci = *ci;                            // Structure copy

c->nBytes = ci->nObjectSize;            // Enough room for one object
if (c->nBytes <= 0)
    {
    myprintf("  tgcbOpen - INVALID %s CONNECTION %s (CID %d): nObjects=%d nObjectSize=%d\n",
        connectionType,
        ci->connectName,
        ci->localConnectID,
        ci->nObjects, ci->nObjectSize);
    
    memset(c, 0, sizeof(CONNECTION));
    return(-2);
    }

// Allocate size of new buffer

//myprintf("tgcbOpen - Allocating %d bytes\n", c->nBytes);

c->buf = calloc(1, c->nBytes);
if (!c->buf)
    {
    myprintf("  tgcbOpen - %s CONNECTION %s (CID %d): No memory (%d bytes)\n",
        connectionType, 
        ci->connectName,
        ci->localConnectID,
        c->nBytes);
        
    memset(c, 0, sizeof(CONNECTION));
    return(-3);
    }
    
//myprintf("  tgcbOpen - %s connection %d opened.\n", connectionType, c->ci.connectid);

//if (ci->flag == TGCI_RECV)
//    {
//    myprintf("tgcbOpen - Press any key..\n");
//    (void) getch();
//    }
return(0);
}


//------------------------------------
// tgcbCloseSend - Close a SEND connection
// This function is called by TG when a SEND connection is being closed
//
// IN
//      rr              Information about the request
//      ci              Information about the connection
//
// OUT
//      0               Successful
//      not zero        An error status

static long
tgcbCloseSend(const TG_RQSTRESP    *rr,
         const TG_CONNECTINFO     *ci)
{
return(doClose(rr, ci));
}

         

//------------------------------------
// tgcbCloseRecv - Close a RECV connection
// This function is called by TG when a SEND connection is being closed
//
// IN
//      rr              Information about the request
//      ci              Information about the connection
//
// OUT
//      0               Successful
//      not zero        An error status

static long
tgcbCloseRecv(const TG_RQSTRESP    *rr,
         const TG_CONNECTINFO     *ci)

{
return(doClose(rr, ci));
}



//------------------------------------
// doClose - Close HS SEND or RECV connection
// This is called when a SEND or RECV connection is being closed
//
// IN
//      rr              Information about the request
//      ci              Information about the connection
//
// OUT
//      0               Successful
//      not zero        An error status
//lint -esym(715,rr)


static long
doClose(const TG_RQSTRESP *rr,       
          const TG_CONNECTINFO *ci)           // Connection information
{
    CONNECTION      *CTable;            // Pointer to RecvConnection[] or SendConnection[]
    CONNECTION      *c;                 // Pointer into CTable[]
    char            *connectionType;    // "SEND" or "RECV"
    long            i;
        
myprintf("  tgcbClose NODE %s CONNECTION %s: %s:%u. remote=%s:%u(CID %d)  local=%s:%u(CID %d)\n",
    myNodeName,
    ci->connectName,
    rr->fromNode.ip,
    rr->fromNode.port,
    ci->remoteNode.ip,
    ci->remoteNode.port,
    ci->remoteConnectID,
    ci->localNode.ip,
    ci->localNode.port,
    ci->localConnectID);
    
logf("  Connect Info: flag=0x%X  nObjects=%u nObjectSize=%u remote.port=%u\n",
    ci->flag,
    ci->nObjects,
    ci->nObjectSize,
    ci->remoteNode.port);
    
// Remember connection information

if (ci->flag == TGCI_RECV)
    {
    connectionType = "RECV";
    CTable = RecvConnection;
    }
else
    {
    connectionType = "SEND";
    CTable = SendConnection;
    }
    
// Find connection in our table

for (i = 0, c = CTable; i < NTGCONNECTIONS; i++, c++)
    {
    if (c->isUsed && c->ci.localConnectID == ci->localConnectID)
        break;
    }

if (i == NTGCONNECTIONS)
    {                                   // This connectID is not found in our table
    myprintf("  tgcbOpen - ERROR %s ci.localConnectID (=%d/%d)\n",
        connectionType,
        ci->localConnectID,
        NTGCONNECTIONS);
    return(-1);
    }


// If buffer is already allocated, free it.

if (c->buf)                             // If buffer is already allocated..
    {
    free(c->buf);                       // ..Free it
    c->buf = 0;
    c->nBytes = 0;
    }

memset(c, 0, sizeof(CONNECTION));

return(0);
}


//------------------------------------
// tgcbState - This function is called by TG when ELSIE changes the LC state.
//
// This function is called when the state of the logical computation changes.
// Under TGSRVPARAM_STATE_START, you will start your processing thread.
// Under TGSRVPARAM_STATE_STOP, you will stop your processing thread.
// You may want to do certain initialization/uninitialization actions
// based on the other values of flag.
//
// The valid states are TGSRVPARAM_STATE_xxx.
//
// OUT
//      >0          Warning
//       0          Success
//      <0          Error

DWORD       hThread;                    // myProcess thread handle
long        myThreadFlag;
#define     PLEASE_EXIT         0       // Ask thread to exit
#define     PLEASE_STOP         1       // Ask thread to stop processing
#define     PLEASE_START        2       // Ask thread to start processing

static void myThreadFunction(void *pvoid);  // Declare our thread functions

static void processData(const TG_RQSTRESP *rr);   // Function that processes data

#define SET_LONG(x) (*(long *) &(x))    // Allows us to set a value that is declared 'const'


static long
tgcbState(const TG_RQSTRESP *rr, long state)
{
//state /= atoi("0"); // CRASH

switch (state)
    {
    case TGSRVPARAM_STATE_INVITE:
    //-------------------------------
        {
        LCIDENT     lcid;                   // Our LCID
        
        (void) tgGetInfo(&rr->hTG, TGGI_GETMYNODENAME, myNodeName, sizeof(myNodeName));
        
        lcid = 0;
        
        if (rr->rqst && rr->nRqstSize > 0)
            (void) paramGetUI64((char *) rr->rqst, &lcid, TGSRVPARAM_LCID);
        
        myprintf("NODE %s: INVITE into computation initialization (LCID %I64u)\n",
            myNodeName, lcid);
        
        
        myThreadFlag = PLEASE_STOP;     // Initial thread state: STOP processing  
        SetEvent(hThreadEvent);         // Wake up our thread
        
//      break;
//        }
//        
//    case TGSRVPARAM_STATE_ENDLCINIT:
//    //-------------------------------
//        {
        myprintf("NODE %s: End logical computation initialization\n", myNodeName);

        myThreadFlag = PLEASE_STOP;     // Ask thread to STOP processing  
        SetEvent(hThreadEvent);         // Wake up our thread
        
        if (!hThread)                   // Start thread, if not already running
            {
            static  TG_RQSTRESP     ourRR;  // Our private copy
            
            // Make a copy of the TG_RQSTRESP block (it won't exist after
            // we exit!)  We zero some pointers to prevent access to
            // those buffers because they won't exist after we exit!
            // What's left is the from.ip, from.port and hTG.
            
            ourRR = *rr;                // Make copy of rr
            
            ourRR.rqst = 0;             // Just for safety
            ourRR.resp = 0;             // Just for safety
            SET_LONG(ourRR.nRespSize) = 0;      // ..no pointing to TG's buffer!
            
            hThread = _beginthread(
                            myThreadFunction,   // thread address
                            0,                  // stack size
                            &ourRR);            // arg pointer
                            
            if (hThread == (ULONG) -1)          // Error creating the thread?
                {
                hThread = 0;
                myprintf("ERROR %d creating processing thread!\n", errno);
                return(-2);             // Error creating thread
                }
                
            }
        
        break;
        }
        
    case TGSRVPARAM_STATE_START:
    //-------------------------------
        {
        myprintf("NODE %s: Start logical computation\n", myNodeName);
        
        myThreadFlag = PLEASE_START;    // Ask thread to START processing  
        SetEvent(hThreadEvent);         // Wake up our thread
        break;
        }
        
    case TGSRVPARAM_STATE_STOP:
    //-------------------------------
        {
        myprintf("NODE %s: Stop logical computation\n", myNodeName);

        myThreadFlag = PLEASE_STOP;     // Ask thread to STOP processing  
        SetEvent(hThreadEvent);         // Wake up our thread
        break;
        }
        
        
    case TGSRVPARAM_STATE_UNINVITE:   
    //-------------------------------
        {
        myprintf("NODE %s: End logical computation uninitialization\n", myNodeName);
        
        myThreadFlag = PLEASE_EXIT;     // Ask thread to EXIT
        SetEvent(hThreadEvent);         // Wake up our thread
        break;
        }
        
    case TGSRVPARAM_STATE_EXIT:
    //-------------------------------
        {
        myprintf("NODE %s: Exit Program\n", myNodeName);
        
        myThreadFlag = PLEASE_EXIT;
        SetEvent(hThreadEvent);         // Wake up our thread
        
        Sleep(100);                     // Give thread a chance to exit
        
        // Here is were we tell our MAIN thread to stop processing.
        
        SetEvent(hMainExitEvent);       // Tell main program we're quitting
        break;
        }
    
    
    default:
    //-------------------------------
        {
        myprintf("NODE %s: UNKNOWN STATE state=%d\n", myNodeName, state);
        return(1);
        }
    }
    
return(0);
}


//------------------------------------
// tgcbQuery - An query from another NODE (or from ELSIE) was received.
// This is where you would add your own responses to queries from your
// other TG apps.
//
// IN
//      rr          A TG_RQSTRESP block
//
// OUT
//      zero or more "param=value\n" strings in response.
//
// RETURNS
//      A status code (0=success)

static long
tgcbQuery(const TG_RQSTRESP *rr)
{
    char    *resp;
    
//myprintf("tgcbQuery CALLBACK!\n");
//myprintf("REQUEST FROM %s (%s:%u) '%s'\n",
//    rr->fromNodeName,
//    rr->from.ip,
//    rr->from.port,
//    rr->rqst);

resp = rr->resp;
//resp += sprintf(resp, "nRespSize=%d\n", rr->nRespSize);

myprintf("%s requested: '%s'\n",
    rr->fromNodeName,
    rr->rqst);

// Tell the other NODE that we haven't implemented any commands yet.

resp += sprintf(resp, "Yes, %s, this is NODE %s.\n",
    rr->fromNodeName,
    myNodeName);

return(0);
}


//------------------------------------
// tgcbRecv - Receive message from remote NODE's tgSendf
// TG calls this function when the NODE receives a message
// that was sent from a remote NODE's when it called tgSendf.
// Unlike tgcbQuery, there is no response returned to the
// sending NODE.  Note that rr->resp and rr->nRespSize will be 0.
//
// IN
//          rr          An TG_RQSTRESP block
//
// OUT
//          Nothing useful  

static long
tgcbRecv(const TG_RQSTRESP *rr)
{
myprintf("tgcbReceive - %s sent: '%s'\n",
    rr->fromNodeName,
    rr->rqst);
    
return(0);
}


//------------------------------------
static void
myThreadFunction(void *pvoid)
{
    DWORD           dResult;
    TG_RQSTRESP     *rr = (TG_RQSTRESP *) pvoid;    // Point to our copy (ie ourRR)

    long            recvConnectid = 0;
    long            sendConnectid = 0;
    CONNECTION      *Recv = &RecvConnection[recvConnectid];
    CONNECTION      *Send = &SendConnection[sendConnectid];
    HANDLE          hHandleList[3];         // List of hEvents to wait on
    long            nHandles;               // # of hEvents in list
    
    
// Send a message to ELSIE letting her know we're running.
    
statusf("NODE %s thread is running ..\n", myNodeName);
    

//---------------------                    
//{
//    TG_QUERY        tgquery;
//    char            *siblingNodeName = "Sender";    // Name of sibling NODE to send to
//    char            nodeResp[TG_BUFSIZE];   // Response for sibling NODE
//
// OK now we're going to get REAL CUTE!  We're going to
// send a message to another NODE (Sender) in our Logical
// Computation.  The other NODE's tgcbQuery() handler
// will receive it, process it and return us a reply.
// (Have a look at OUR tgcbQuery() processor below).
// If WE are the Sender, then we're sending this message
// to ourselves.  If WE are the Receiver, then it is
// going to the Sender.  Either way, the Sender should
// get two messages (one from Sender and one from Receiver)
// and the Receiver shouldn't get any of these messages.
//
// Note that if tgQueryf() doesn't know where "Sender" is,
// it will ask ELSIE for the location of the Sender NODE.
//
//tgquery = tgQueryf(&rr->hTG, nodeResp, sizeof(nodeResp), 1000,
//        "%s\n"              // This is the name of the NODE we're sending to
//                            // We can make up anything we want for the rest of the request string.
//        "myCommand\n"       // This is the 'command' we're sending
//        "Hi %s.  This is %s.  Are you there?\n",
//            siblingNodeName,                // Destination NODE name
//            siblingNodeName,
//            myNodeName);
//
//if (!tgquery.tgerr)
//    {
//    myprintf("%s's reply: '%s'\n",
//        siblingNodeName,
//        nodeResp);
//    }
//else
//    {
//    myprintf("***ERROR %d trying to send to NODE Sender: %s\n",
//        tgquery.tgerr,
//        tgErr(tgquery.tgerr));
//    myprintf("***nwerr=%d nReceived=%d nLoaded=%d remote.ip=%s:%u \n",
//        tgquery.nwerr,
//        tgquery.nReceived,
//        tgquery.nLoaded,
//        tgquery.remote.ip, tgquery.remote.port);
//    }
//}
//---------------------                    

// Build list of hEvents that will wake us up.
//            
// We can wake up for any of several reasons:
//
//  1. The user wants this thread to terminate (hThreadEvent)
//
//     and either or both of the following:
//
//  2. We received an object on our receive connection
//  3. All of our send objects have been transmitted.

nHandles = 0;
hHandleList[nHandles++] = hThreadEvent;          // Event signaled to force this thread to awake
if (Send->ci.nObjects)                           // Are we a sender?
    hHandleList[nHandles++] = Send->ci.hEmpty;   // Wake up when all objects have been sent
else if (Recv->ci.nObjects)                      // Are we a receiver?
    hHandleList[nHandles++] = Recv->ci.hNotEmpty;// Wake up when there's at least one object in FIFO


while (myThreadFlag != PLEASE_EXIT)
    {
    // Go to sleep until something we're interested wakes us up.
    
    dResult = WaitForMultipleObjects(   // Wait for something important to happen
                        nHandles,       // Number of handles to wait for
                        hHandleList,    // List of handles
                        FALSE,          // bWaitAll - wake up if any event is signaled
                        100);           // timeout in ms
    
    switch (dResult)                    // Why did we wake up?
        {
        case    WAIT_TIMEOUT:           // No one woke us up but we reached our timeout
                                        // Here is where you could do things periodically
            break;                      // Don't quit yet
            
        case    WAIT_OBJECT_0:          // hThreadEvent was signaled
            (void) ResetEvent(hHandleList[0]);    // Get ready for next time
            break;                      // Someone wants us to do something
            
        case    WAIT_OBJECT_0 + 1:      // Send or Recv event was signaled
            (void) ResetEvent(hHandleList[1]);    // Get ready for next time
            break;
                                        
        case    WAIT_OBJECT_0 + 2:      // Send or Recv event was signaled
            (void) ResetEvent(hHandleList[2]);    // Get ready for next time
            break;
            
        case    WAIT_FAILED: 
            goto QUIT;                  // Something serious is wrong

        case    WAIT_ABANDONED: 
            goto QUIT;                  // Something serious is wrong
            
        default:    
            goto QUIT;                  // Something serious is wrong
        }
        
    // Figure out what to do.
        
    switch (myThreadFlag)
        {
        case    PLEASE_START:           // We're asked to process data
            processData(rr);
            break;

        case    PLEASE_EXIT:
            goto QUIT;                  // We're asked to exit

        case    PLEASE_STOP:
            continue;                   // Processing is suspended

        default:
            continue;                   // Some command we know nothing about
        }
    }    

QUIT:;
myprintf("myThreadFunction EXITING.\n");
hThread = 0;                            // We're exiting
_endthread();                           // Terminate this thread
}


//------------------------------------

static void
processData(const TG_RQSTRESP *rr)
{
    static long         count = 0;
    static long         nReceived = 0;
    static long         nSent = 0;
    
    long                recvConnectid = 0;
    long                sendConnectid = 0;
    CONNECTION          *Recv = &RecvConnection[recvConnectid];
    CONNECTION          *Send = &SendConnection[sendConnectid];
    long                tgerr;
    long                nMessageFrequency;
//  TG            hTG = rr->hTG;
    
//if (Recv->ci.mdb)
//    myprintf("-------------mdbGetLength(RECV)=%d  buf=%p nBytes=%d\n",
//        mdbGetLength(Recv->ci.mdb),
//        Recv->buf,
//        Recv->nBytes);
//
//if (Send->ci.mdb)
//    myprintf("-------------mdbGetLength(SEND)=%d  buf=%p nBytes=%d\n",
//        mdbGetLength(Send->ci.mdb),
//        Send->buf,
//        Send->nBytes);
//
//if (!Recv->ci.mdb && !Send->ci.mdb)
//    {
//    myprintf("--------------ERROR processData recvMDB=%p sendMDB=%p\n",
//        Recv->ci.mdb,
//        Send->ci.mdb);
//    return;
//    }

// Test tgSend/tbcbReceive functionality

//{
//TG_QUERY    tgquery;
//
//tgquery = tgSendf(&rr->hTG, "ELSIE howdy\n" "What's happening over there?\n");
//if (tgquery.tgerr)
//    {
//    myprintf("-------------------tgSendf ERROR %d: %s\n",
//        tgquery.tgerr, tgErr(tgquery.tgerr));
//    }
//}
    
if (!Recv->ci.nObjects)                 // Is receive connection closed?
    {                                   // Yes, it is closed
    // Then assume we have a SEND connection
    
    nMessageFrequency = Send->ci.nObjects / 10;
    if (nMessageFrequency < 1)
        nMessageFrequency = 1;
    else if (nMessageFrequency > 100)
        nMessageFrequency = 100;
    
    // No open receive connection.
    // Create a bunch of data and copy it to the output connection.
    
    while (1)
        {
        ULONG        nObjects;
        
        tgerr = tgGetObjectCount(&hTG, Send->ci.lcid, Send->ci.localConnectID, &nObjects);
        if (tgerr)
            {
            myprintf("processData - ERROR %d get read count: %s\n",
                    tgerr, tgErr(tgerr));
            return;
            }
            
        if (nObjects >= Send->ci.nObjects)
            return;                     // MDB is full
            
        // Create new buffer to send.
        
        memset(Send->buf, count++, Send->nBytes);

        // Put buffer into outgoing MDB
                
        tgerr = tgWriteObject(&hTG, Send->ci.lcid, Send->ci.localConnectID, Send->buf, Send->nBytes);
        if (tgerr)        
            {
            myprintf("processData - ERROR %d writing data:: %s\n",
                tgerr, tgErr(tgerr));

            return;
            }

        nSent++;
        nObjects++;                     // We wrote one more
        
        if (nSent % nMessageFrequency == 0)
            {
            printf("Queued packet %u: %d bytes [%d] to output connection MDB %d/%d  \r",
                nSent,
                Send->nBytes, count,
                nObjects,
                Send->ci.nObjects);
            }

        // Every so often, lets send a status message to ELSIE
        // So the user know's we're working
            
        if (nSent == 1 || (nSent % (nMessageFrequency * 10)) == 0)
            {
            printf("\n");
            statusf("Queued %d packets..", nSent);
            }
        }
    }
else
    {
    // We have an open RECEIVE connection.
    // Read data from that connection and
    // write to output connection, if it is open.
    
    nMessageFrequency = Recv->ci.nObjects / 10;
    if (nMessageFrequency < 1)
        nMessageFrequency = 1;
    else if (nMessageFrequency > 100)
        nMessageFrequency = 100;
        
    while (1)
        {
        ULONG        nObjects;
        
        // See if there's any more data to read
        
        tgerr = tgGetObjectCount(&hTG, Recv->ci.lcid, Recv->ci.localConnectID, &nObjects);
        if (tgerr)
            {
            myprintf("processData - ERROR %d get read count: %s\n",
                    tgerr, tgErr(tgerr));
            return;
            }
            
        if (!nObjects)
            return;                     // MDB is empty
        
        // Read data from receive connection
        
        tgerr = tgReadNextObject(&hTG, Recv->ci.lcid, Recv->ci.localConnectID, Recv->buf, Recv->nBytes);
        if (tgerr)
            {
            myprintf("processData - ERROR %d writing data: %s\n",
                    tgerr, tgErr(tgerr));
            return;
            }
            
        nReceived++;
        
        if (nReceived == 1 || (nReceived % nMessageFrequency) == 0)
            {
            printf("Received %u/%u packets, %d bytes\n", nReceived, nObjects, Recv->nBytes);
            }
            
        if (displayTEMPOdata)
            {
            long                set;
            SSEPOCH_HEADER      *eh = (SSEPOCH_HEADER *) Recv->buf; //lint !e826
            
            printf("\n");
            printf(" DB %d %s Epoch %d.%d.%d/%d/%d bytes %d\n",
                eh->nDb,
                szHeaderType(eh->headerType),
                eh->FmtSeqNo,
                eh->ZeroSeqNo,
                eh->nEpoch,
                eh->nEpochsAccumulated,
                eh->nMaxEpochs,
                eh->nObjectBytes);

            printf(" Title='%s'\n", eh->Title);                
                
            printf(" hHdr=%d DataOff=%d/%d Chan=[%d..%d] Period=%d   MDB %d/%d  %s\n",
                eh->nHeaderBytes,
                eh->nOffsetToData,
                eh->nDataBytes,
                eh->firstChannel + 1,
                eh->firstChannel + eh->nChannels,
                eh->Period,
                nObjects,                   // # of objects in MDB _before_ the read
                Recv->ci.nObjects,
                eh->flag & SSEPOCH_FLAG_AUTODOWNLOAD ? "AUTODOWNLOAD" : "MANUALDOWNLOAD");
                
            if (!eh->nDataBytes || !eh->nOffsetToData)
                printf(" NO DATA in packet.\n");
            else
                {
                for (set = 0; set < 5; set++)
                    {
                    long        chan;
                    short       *pdata;
                
                    printf(" %d: ", set + 1);
                    
                    pdata = (short *) ((char *) eh + eh->nOffsetToData);    //lint !e826
                    pdata += set * eh->nChannels;
                
                    // Display one channel set
                
                    for (chan = 0; chan < eh->nChannels; chan++, pdata++)
                        printf(" %5d", *pdata);
                    
                    printf("\n");
                    }
                }
            }
        
        // If we have an open send connection,
        // process it and write the results to the outgoing connection.
        
        if (Send->ci.nObjects)
            {
            // Processing consists of copying the data from the
            // input buffer to the output buffer.  If the send
            // buffer is larger than the receive buffer, the
            // trailing stuff is garbage.
            
            memcpy(Send->buf, Recv->buf, min(Send->nBytes, Recv->nBytes));
            
            // Now write the "results" to the outgoing connection.
            
            tgerr = tgWriteObject(&hTG, Send->ci.lcid, Send->ci.localConnectID, Send->buf, Send->nBytes);
            if (tgerr)        
                {
                myprintf("processData - ERROR %d writing data: %s\n",
                    tgerr, tgErr(tgerr));

                return;
                }

            if (nReceived % nMessageFrequency == 0)
                printf("Wrote %d bytes to output   ", Send->nBytes);
            }
        
        if (nReceived % nMessageFrequency == 0)
            printf("\r");
            
        // Every so often, lets send a status message to ELSIE
        // So the user know's we're working
            
        if (nReceived == 1 || (nReceived % (nMessageFrequency * 10)) == 0)
            {
            printf("\n");
            statusf("Received %d packets..", nReceived);
            }
        }
    }
}


//------------------------------------
// szHeaderType - Return short string describing type of SSEPOCH_HEADER
//
// IN
//      headerType          One of SS_HEADERTYPE_xxx
//
// OUT
//      Pointer to a short static string

static char *
szHeaderType(char headerType)
{
switch (headerType)
    {
    case SS_HEADERTYPE_BEGIN:        return("BeginData");       // Begin data with this DB format
    case SS_HEADERTYPE_END:          return("EndData");         // End data with this DB format
    case SS_HEADERTYPE_ZEROED:       return("Zeroed");          // DB has been zeroed
    case SS_HEADERTYPE_EPOCHDATA:    return("EpochData");       // New epoch data
    default:                         return("?UnkHeaderType?");
    
    #if SS_HEADERTYPE_LASTONE != SS_HEADERTYPE_EPOCHDATA
        #error ------PLEASE UPDATE THIS TABLE FROM SSTEMPO.H -----------
    #endif
    }
}
