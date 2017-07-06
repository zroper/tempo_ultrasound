#define ELSIE_VERSION   2               // Version of this program
#define ELSIE_RELEASE   9               // Release level

/*  .title  ELSIE - Sample Logical Computation Control Program
;+
; SYNOPSIS
;       elsie [file.lc]
;
;
; DESCRIPTION
;   This program runs a logical computation as defined in the .LC file.
;
;   It also provides an programming example for the LC and TG programming
;   interfaces (API).
;
; SEE ALSO
;   Here's a great reference for Win32 exception handling:
;       Advanced Windows, 3rd Ed, Jeffrey Richter, Microsoft Press, 1997
;       See Chapter 16, Structured Exception Handling, especially the
;       section called Exception Filters and Exception Handlers.  TG and LC
;       both use the __try {..} __except() {..} around all of their threads
;       and around all user TG/LC callback functions.
;
; EDIT HISTORY
;   21Oct06 sh  Initial edit
;   17Feb07 sh  2.2 We don't send UNINVITE states - let the LC library manage those
;               Make changes to send out ELSIE states
;   05Mar07 sh  2.3 In WatchNodes(), check lastError parameter to make sure NCM
;               successfully retrieved the NODE's statcode
;               Display Windows error message when lastErr is set
;   06Mar07 sh  2.4 Add isNodeRunning
;               Add printNCMConnections
;   05Apr07 sh  2.5 change lcNCMGetConnectionInfo to lcNCMFindConnectionInfo
;   24Apr07 sh  2.6 Display CWD in log file
;   13Jul07 sh  2.7 Display TGVersion TGSet NCMSet
;   20Dec07 sh  2.8 Enhance error message from DeleteConnectionByConnectionFromGraph
;   03Mar09 sh  2.9 Show one way to use TG_TIMEOUT_MULTIPLIER
;-
*/
#include    <windows.h>
#include    <stdio.h>
#include    <time.h>
#include    <io.h>
#include    <conio.h>

#include    "fio.h"                     // File logging routines
#include    "fileext.h"                 // File extension routines
#include    "param.h"                   // Parameter list routines
#include    "exceptio.h"                // Exception handling
#include    "syserr.h"                  // Windows error messages

#include    "tg.h"                      // TG library
#include    "lc.h"                      // LC library

// The IsRedirected macro determines if the user redirected stderr
// (ie by typing ">file" on the command line).

#define IsRedirected(stream)    (!isatty(fileno(stream)))   // requires io.h

#define ESC '\033'

char        lcFilename[_MAX_PATH];      // Name of LC file
FILE        *logFid;                    // Log file id
char        logFileName[_MAX_PATH] = "elsie.log";
char        bakFileName[_MAX_PATH] = "elsie.bak";
char        thisComputer[MAX_COMPUTERNAME_LENGTH + 1];  // ELSIE's computer name


//------------------------------------
// TG Callback function table

static long tgcbRecv(const TG_RQSTRESP  *rr);          // Unknown query received
static void tgcbMessage(const TG *hTG, const char *text);           // Status message from TG
static void tgcbLog(const TG *hTG, const char *text);               // Write string to log file

static long tgcbMyExceptionHandler(const TG *hTG, const char *exceptName, const EXCEPTION_RECORD *pExceptionRecord, const CONTEXT *pContext);


TGCBFUNCTIONS Tgcb =
    {
    TG_VERSION, TG_SET, sizeof(TGCBFUNCTIONS),
    
    NULL,                               // tgcbAskSend,  Ask HS connection
    NULL,                               // tgcbOpenSend,  Open HS connection
    NULL,                               // tgcbCloseSend, Close HS connection
    
    NULL,                               // tgcbAskRecv,  Ask HS connection
    NULL,                               // tgcbOpenRecv,  Open HS connection
    NULL,                               // tgcbCloseRecv, Close HS connection

    NULL,                               // tgcbStatus,Logical Computation Status
    
    NULL,                               // Query received from remote NODE calling tgQueryf
    tgcbRecv,                           // Message from remote NODE calling tgSendf
    
    tgcbMessage,                        // Status message from TG
    tgcbLog,                            // Debugging messages from TG
    tgcbMyExceptionHandler              // Called on HS or TG (or our callback) generates an exception
    };


//------------------------------------------------------------------
// Statically defined values


//------------------------------------------------------------------
// Other function prototypes

void myprintf(char *fmt, ...);  //lint -printf(1, myprintf)
void printNodes(LC *lc);
void printConnections(LC *lc);
void printComputers(LC *lc);
void printNCMConnections(LC *lc, char *computerName);
long watchNodes(LC *lc);
//LCERR sendState(LC *lc, LCERRHANDLER *lcErrHandler, long tgsrvparamState, char *nodeName);
//long startNodes(LC *lc);
//long stopNodes(LC *lc);
static void logf(char *fmt, ...);       //lint -printf(1, logf)
static long isNodeStillActive(LC *lc, char *nodeName);
static long isNodeRunning(LC *lc, char *computerName, char *nodeName);



//------------------------------------------------------------------
short
main(short ac, char *av[])
{
    LC          Lc;                     // An LC handle
    LCERR       lcerr;                  // LC api status return value
    char        progName[64];           // "ELSIE #.#"
    DWORD       nSize;
    time_t      t;
    char        akey;
    long        err;
    char        cwd[_MAX_PATH];         // Current directory

//printf("__argv[0]='%s'\n", __argv[0]);

nSize = sizeof(thisComputer);    
(void) GetComputerName(thisComputer, &nSize);

cwd[0] = 0;
(void) GetCurrentDirectory(sizeof(cwd), cwd);
    

//-------------------------------
// DISPLAY HELP PAGE
    
if (ac < 2)
    {
    printf("Usage: ELSIE file.LC\n");
    return(0);
    }
    

//-------------------------------
// OPEN LOG FILE.  THIS IS WHERE LOG MESSAGES ARE STORED.
    
if (access(logFileName, 0) == 0)        // Does the LOG file exist?
    {                                   // Yes.
    if (access(bakFileName, 0) == 0)    // Does the BAK file exist?
        remove(bakFileName);            // Yes, delete it
    
    (void) rename(logFileName, bakFileName);   // Rename LOG to BAK
    
    // Now logFileName (.LOG) shouldn't exist
    // Since we use the FIO functions, the LOG file will get created
    // the first time a message is written to it.
    }

time(&t);


//-------------------------------
// Get LC filename, append .LC if extention isn't present

fileext(av[1], ".LC", lcFilename, sizeof(lcFilename));    

sprintf(progName, "ELSIE %d.%d TGVersion %d TGSet %d NCMSet %d",
    ELSIE_VERSION, ELSIE_RELEASE, TG_VERSION, TG_SET, tgNCMSet);


myprintf("%s\n", progName);
myprintf("%s", ctime(&t));
myprintf("COMPUTER '%s' Executing %s %s\n",
    thisComputer,
    av[0],
    lcFilename);
    
myprintf("CurrentDirectory='%s'\n", cwd);
    

//-------------------------------
// INITIALIZE LC

memset(&Lc, 0, sizeof(LC));
lcerr = lcInit(&Lc,                     // Place to store LC handle
               &Tgcb,                   // Our TGCBFUNCTIONS callback table
               0,                       // We don't use the "user-defined" value (yet)
               1);                      // We allow TG callbacks now
if (lcerr.lcerr)
    {
    myprintf("lcInit - ERROR %d: %s\n", lcerr.lcerr, lcErr(lcerr.lcerr));
    return(0);
    }




// 03Mar09 Example of how to increase ELSIE's default timeouts so that it gives
//         nodes additional time to respond to ELSIE's messages.  In some circumstances
//         (ie slow computers or networks or due to the application's design), some
//         applications responds too slowly to ELSIE's messages (ie: tgcbAskOpen(), etc).
//         When this happens, ELSIE's requests time out.  It is possible to increase
//         (or decrease) the amount of time ELSIE waits for responses by setting the
//         timeout multipler.  This is a constant, initially 1.0, which a TG node
//         uses to compute the amount of time the node will wait for responses
//         from remote nodes.  There are many timeouts values in Symphony and setting
//         the timeout multiplier allows your controller to increase the timeout(s).
//         So values over 1.0 increase the timeout and values >0 and <1.0 decrease
//         the timeout.  The timeout multiplier must be > 0.
//{
// 
//    TG      tg;
//    
//lcerr = lcGetTG(&Lc, &tg);
//if (lcerr.lcerr)
//    myprintf("lcInit - ERROR %d: getting TG handle %s\n", lcerr.lcerr, lcErr(lcerr.lcerr));
//else
//    {
//    long    tgerr;
//    
//    myprintf("lcInit - Setting TG_TIMEOUT_MULTIPLIER to %f\n", 1.5);
//    tgerr = tgSetTimeout(&tg, TG_TIMEOUT_MULTIPLIER, NULL, 1.5);
//    if (tgerr)
//        {
//        myprintf("lcInit - ERROR %d: setting TG_TIMEOUT_MULTIPLER %s\n", tgerr, tgErr(tgerr));
//        }
//    }
//}





//-------------------------------
// PARSE THE LOGICAL COMPUTATION FILE AND BUILD THE GRAPH

lcerr = lcParse(&Lc, lcFilename);
if (lcerr.lcerr)
    {
    myprintf("ERROR %d parsing %s: %s\n", lcerr.lcerr, lcFilename, lcErr(lcerr.lcerr));
    goto QUIT;
    }
    
printComputers(&Lc);
printNodes(&Lc);
printConnections(&Lc);


//-------------------------------
// RUN ALL NODES (THIS RUNS THE PROGRAMS ASSOCIATED WITH EACH NODE)

myprintf("ELSIE - Running NODES ..\n");

lcerr = lcRunNode(&Lc, NULL, NULL);       // Run all nodes
if (lcerr.lcerr)
    {
    myprintf("lcRunNodes returned %d: %s\n", lcerr.lcerr, lcErr(lcerr.lcerr));
    goto STATUS_STOP;
    }
    
printNodes(&Lc);


//-------------------------------
// TELL ALL NODES WE ARE ABOUT TO INITIALIZE

lcerr = lcSendState(&Lc, NULL, TGSRVPARAM_STATE_BEFOREINIT, NULL, NULL);
if (lcerr.lcerr)
    {
    myprintf("sendState(BEFOREINIT) returned %d\n", lcerr.lcerr);
    }
    

//-------------------------------
// SETUP ALL SEND CONNECTIONS

myprintf("ELSIE - Opening all connections ..\n");

lcerr = lcOpenConnectionByConnection(&Lc, NULL, NULL);
if (lcerr.lcerr)
    {
    myprintf("openConnections returned %d: %s\n", lcerr.lcerr, lcErr(lcerr.lcerr));
    goto STATUS_STOP;
    }

    
printConnections(&Lc);                      // Print connections after they are established

//(void) system("pool >pool.log");            // Helpful for debugging

//-------------------------------
// Printing NCM connections is for illustration only.  We don't generally need it.
//
//myprintf("-------LOCAL NCM CONNECTIONS------------\n");
//
//printNCMConnections(&Lc, NULL);        // Print local connections
    


//-------------------------------
// TELL ALL NODES WE COMPLETED INITIALIZATION

lcerr = lcSendState(&Lc, NULL, TGSRVPARAM_STATE_INIT, NULL, NULL);
if (lcerr.lcerr)
    {
    myprintf("sendState(INIT) returned %d\n", lcerr.lcerr);
    }

    
akey = 0;
if (akey != ESC)
    {
    //-------------------------------
    // TELL ALL NODES WE ARE ABOUT TO START THEIR PROCESSING
    
    lcerr = lcSendState(&Lc, NULL, TGSRVPARAM_STATE_BEFORESTART, NULL, NULL);
    if (lcerr.lcerr)
        {
        myprintf("sendState(BEFORESTART) returned %d\n", lcerr.lcerr);
        }
    

    //-------------------------------
    // TELL ALL NODES TO START THEIR PROCESSING
    
    lcerr = lcSendState(&Lc, NULL, TGSRVPARAM_STATE_START, NULL, NULL);
    if (lcerr.lcerr)
        {
        myprintf("sendState(START) returned %d\n", lcerr.lcerr);
        }
    

    //-------------------------------
    // Write debug information to ELSIE.DBG
    
    remove("elsie.dbg");
    (void) lcDumpf(&Lc, "elsie.dbg", "Debugging information for %s\n", lcFilename);
    
    
    //-------------------------------
    // MONITOR ALL NODES

    err = watchNodes(&Lc);
    if (err)
        {
        myprintf("ELSIE - watchNodes returned %d\n", err);
        }
    }


//-------------------------------
// BREAKDOWN RECV CONNECTIONS

STATUS_STOP:;


//-------------------------------
// Stop the computation

myprintf("ELSIE - Stopping Logical Computation ..\n");


//-------------------------------
// TELL ALL NODES WE ARE ABOUT TO STOP THE COMPUTATION

lcerr = lcSendState(&Lc, NULL, TGSRVPARAM_STATE_BEFORESTOP, NULL, NULL);
if (lcerr.lcerr)
    {
    myprintf("lcSendState(BEFORESTOP) returned %d: %s\n", lcerr.lcerr, lcErr(lcerr.lcerr));
    goto UNINIT_CLOSE;
    }


//-------------------------------
// TELL ALL NODES TO STOP THE COMPUTATION

lcerr = lcSendState(&Lc, NULL, TGSRVPARAM_STATE_STOP, NULL, NULL);
if (lcerr.lcerr)
    {
    myprintf("lcSendState(STOP) returned %d: %s\n", lcerr.lcerr, lcErr(lcerr.lcerr));
    goto UNINIT_CLOSE;
    }


//-------------------------------
// CLOSE SEND CONNECTIONS

UNINIT_CLOSE:;

myprintf("ELSIE - Closing all connections ..\n");


//-------------------------------
// TELL ALL NODES WE ARE ABOUT TO UNINITIALIZE

lcerr = lcSendState(&Lc, NULL, TGSRVPARAM_STATE_BEFOREUNINIT, NULL, NULL);
if (lcerr.lcerr)
    {
    myprintf("lcSendState(BEFOREUNINIT) returned %d: %s\n", lcerr.lcerr, lcErr(lcerr.lcerr));
    goto UNINIT_CLOSE;
    }


//-------------------------------
// CLOSE ALL CONNECTIONS

lcerr = lcCloseConnectionByConnection(&Lc, NULL, NULL);
if (lcerr.lcerr)
    {
    myprintf("CloseConnections returned %d: %s\n", lcerr.lcerr, lcErr(lcerr.lcerr));
    }
    

//-------------------------------
// DELETE ALL CONNECTIONS

myprintf("ELSIE - Deleting all connections ..\n");

//lcerr = lcDeleteConnectionByNodeFromGraph(&Lc, NULL, NULL);
lcerr = lcDeleteConnectionByConnectionFromGraph(&Lc, NULL, NULL);
if (lcerr.lcerr)
    {
    myprintf("DeleteConnectionByConnectionFromGraph - LC ERROR %d: %s\n", lcerr.lcerr, lcErr(lcerr.lcerr));
    myprintf("DeleteConnectionByConnectionFromGraph - Error codes: lc=%d tg=%d ll=%d nw=%d tgsrv=%d user=%d\n",
        lcerr.lcerr,
        lcerr.tgerr,
        lcerr.llerr,
        lcerr.nwerr,
        lcerr.tgsrvStatus,
        lcerr.userStatus);
    }
    
//(void) lcGetConnectionCount(&Lc, &count);
//logf("LIST OF CONNECTIONS SHOULD NOW BE EMPTY (%d reported)\n", count);
//printConnections(&Lc);

//-------------------------------
// TELL ALL NODES TO UNINITIALIZE

myprintf("ELSIE - Uninitializing LC ..\n");
if (IsRedirected(stdout))
    fprintf(stderr, "ELSIE - Uninitializing LC ..\n");

lcerr = lcSendState(&Lc, NULL, TGSRVPARAM_STATE_UNINIT, NULL, NULL);
if (lcerr.lcerr)
    {
    myprintf("lcSendState(UNINIT) returned %d: %s\n", lcerr.lcerr, lcErr(lcerr.lcerr));
    goto UNINIT_CLOSE;
    }


//-------------------------------
// EXIT ALL NODES

// TELL ALL NODES TO STOP EXECUTION AND EXIT
// Note that NODEs which have exitProgram=NO will not be stopped.
// All other nodes will be stopped according to the exitProgram parameter.

myprintf("ELSIE - Exiting ALL NODES ..\n");
if (IsRedirected(stdout))
    fprintf(stderr, "ELSIE - Exiting NODES ..\n");

lcerr = lcExitNode(&Lc, NULL, NULL);      // Tell all nodes to exit
if (lcerr.lcerr)
    {
    myprintf("lcExitNode returned %d:%s \n", lcerr.lcerr, lcErr(lcerr.lcerr));
    goto QUIT;
    }


//-------------------------------
// DELETE ALL NODES FROM THE GRAPH

myprintf("ELSIE - Deleting all NODEs ..\n");

lcerr = lcDeleteNodeFromGraph(&Lc, NULL, NULL);
if (lcerr.lcerr)
    {
    myprintf("lcDeleteNodesFromGraph returned %d: %s\n", lcerr.lcerr, lcErr(lcerr.lcerr));
    }
    
//(void) lcGetConnectionCount(&Lc, &count);
//logf("LIST OF NODES SHOULD NOW BE EMPTY (%d NODEs reported)\n", count);
//printNodes(&Lc);



//-------------------------------
// UNINITIALIZE LC

QUIT:;    
lcerr = lcUninit(&Lc);
if (lcerr.lcerr)
    myprintf("lcUninit - ERROR %d: %s\n", lcerr.lcerr, lcErr(lcerr.lcerr));
    
if (logFid)
    {
    fclose(logFid);
    logFid = 0;
    }

return(0);
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
if (tgerr < 0)
    sprintf(nodeName, "?NoNODEName?");

// Write message to LOG file

logf("%s: %s", nodeName, text);
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
if (tgerr < 0)
    sprintf(nodeName, "?NoNODEName?");

// Write message to stdout

printf("%s: %s\n", nodeName, text);

// Write message to LOG file

logf("%s: %s\n", nodeName, text);                  // Don't use statusf() here!
}




//------------------------------------------------------------------
static void
logf(char *fmt, ...)
{
    va_list         arg_ptr;            // for formatting
    SYSTEMTIME      systime;
    char            buf[1024];
    
if (!logFileName[0])
    return;

GetLocalTime(&systime);

memset(buf, 0, sizeof(buf));

va_start(arg_ptr, fmt);
(void) _vsnprintf(buf, sizeof(buf) - 1, fmt, arg_ptr);
va_end(arg_ptr);

(void) FIOWriteStrToFilename(logFileName, "%02u.%02u.%03u: %s",
    systime.wMinute,
    systime.wSecond,
    systime.wMilliseconds,
    buf);
}


//------------------------------------------------------------------
// myprintf - Printf to the screen and LOG file
//
// IN
//      fmt         A printf-style format string
//      ...         Additional arguments
//
// RETURNS
//      Number of bytes written to LOG file

void
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

logf("%s", buf);
printf("%s", buf);

return;
}



//------------------------------------------------------------------
// tgcbRecv - Called when a NODE sends us a message (via its tgSendf)
// We simply display the message we received
//
// IN
//          rr
//
// OUT
//          Nothing useful

static long
tgcbRecv(const TG_RQSTRESP  *rr)
{
myprintf("NODE %s sent %d bytes: '%s'\n",
    rr->fromNodeName,
    strlen(rr->rqst), 
    rr->rqst);
    
return(0);
}


//------------------------------------------------------------------
// tgcbMyExceptionHandler - Handle program exceptions from TG
// Exceptions can either come from the TG/LC library or from the user's tgcbX() functions.
//
// It is _REAL IMPORTANT_ that this exception handler not produce another exception!
// This would cause win32 to go through a recursive loop of handling exceptions and
// would eventually overflow the program stack.
//
//lint -esym(715, pContext)         Not referencedc

static long
tgcbMyExceptionHandler(const TG *hTg, const char *threadName, const EXCEPTION_RECORD *pExceptionRecord, const CONTEXT *pContext)
{
    static  long    depth = 0;          // Detect/prevent recursion
    DWORD   Ecode;                      // Exception code
    void    *Eaddr;                     // Address of exception
    char    *Estring;                   // Error string
    
depth++;                                // Count recursive calls
    
if (!threadName)
    threadName = "NoThreadNameProvided";

myprintf("******************************************************\n");
myprintf("ELSIE exception handler - FATAL EXCEPTION DETECTED in thread %s (hTG=%p, depth=%d).\n",
    threadName,
    hTg,
    depth);
    
if (depth > 1)
    {
    myprintf("tgcbMyExceptionHandler - Exiting due to recursive call.\n");
    depth--;
    return(0);
    }

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
    
myprintf(" Exception detected In: %s  processID=%X  threadID=%X\n",
    threadName,
    GetCurrentProcessId(),
    GetCurrentThreadId());
    
myprintf(" Program Addr=%p\n", Eaddr);
myprintf(" Ecode=%X %s\n", Ecode, Estring ? Estring : "UnknownException");

// Here is where you can insert code to save information about your
// program state to the LOG file.

/* TO DO: insert code here */

myprintf("tgcbMyExceptionHandler - exception handling complete.\n");
myprintf("******************************************************\n");

depth--;
return(0);
}


//--------------------------------------------------
// Display info about POOL and computers in it

void
printComputers(LC *lc)
{
    long        i;
    char        PoolName[NNAMESIZE];
    LCERR       lcerr;
    long        nComputers;
    LCNAMELIST  poolList[NCOMPUTERS];      // List of computer names
    char        poolInfoList[NPARAMSIZE];
    
lcerr = lcGetPoolName(lc, PoolName, sizeof(PoolName));
if (lcerr.lcerr)
    {
    myprintf("printComputer - ERROR %d getting pool name: %s\n",
        lcerr.lcerr, lcErr(lcerr.lcerr));
    return;
    }
    
logf("\n");    
logf("POOL '%s'\n", PoolName);

lcerr = lcGetPoolInfo(lc, poolInfoList, sizeof(poolInfoList));
if (lcerr.lcerr)
    {
    myprintf("printComputer - ERROR %d getting pool information: %s\n",
        lcerr.lcerr, lcErr(lcerr.lcerr));
    return;
    }
    
lcerr = lcGetPoolCount(lc, &nComputers);
if (lcerr.lcerr)
    {
    myprintf("printComputer - ERROR %d getting number of computers in pool: %s\n",
        lcerr.lcerr, lcErr(lcerr.lcerr));
    return;
    }
    
lcerr = lcGetPoolList(lc, poolList, sizeof(poolList));
if (lcerr.lcerr)
    {
    myprintf("printComputer - ERROR %d getting number of computers in pool: %s\n",
        lcerr.lcerr, lcErr(lcerr.lcerr));
 
    goto EXIT;
    }
   
for (i = 0; i < nComputers; i++)
    {
    char        computerInfo[NPARAMSIZE];
    
    lcerr = lcGetPoolComputerInfo(lc, poolList[i].name, computerInfo, sizeof(computerInfo));
    if (lcerr.lcerr)
        {
        myprintf("printComputer - ERROR %d getting COMPUTER '%s' info: %s\n",
            lcerr.lcerr, poolList[i].name, lcErr(lcerr.lcerr));
        break;
        }
        
    logf("COMPUTER '%s'\n%s\n", poolList[i].name, computerInfo);
    }

EXIT:;

logf("\n");
logf("%d Computers in Pool\n", nComputers);
}


//--------------------------------------------------
void
printNodes(LC *lc)
{
    long        i;
    LCNAMELIST  nodeList[NNODES];       // List of node names
    long        nNodes;                 // Number of NODES
    char        paramList[NPARAMSIZE];  // Buffer for NODE's parameters
    char        infoList[NPARAMSIZE];   // Buffer for NODE's information
    LCERR       lcerr;
    
logf("\n");    

lcerr = lcGetNodeCount(lc, &nNodes);
if (lcerr.lcerr || nNodes <= 0)
    {
    return;
    }
    
logf("%d NODES\n", nNodes);

lcerr = lcGetNodeList(lc, nodeList, sizeof(nodeList));
if (lcerr.lcerr)
    {
    myprintf(" ERROR %d getting NODE list: %s\n", 
        lcerr.lcerr,
        lcErr(lcerr.lcerr));

    goto EXIT;
    }
    
for (i = 0; i < nNodes; i++)
    {
    // DISPLAY NODE PARAMETERS
    
    lcerr = lcGetNodeParams(lc, paramList, sizeof(paramList), nodeList[i].name);
    if (lcerr.lcerr)
        {
        myprintf("  ERROR %d getting NODE '%s' information: %s\n",
            lcerr.lcerr,
            nodeList[i].name,
            lcErr(lcerr.lcerr));

        continue;
        }
        
    // DISPLAY NODE INFORMATION
    
    lcerr = lcGetNodeInfo(lc, infoList, sizeof(infoList), nodeList[i].name);
    if (lcerr.lcerr)
        {
        myprintf("  ERROR %d getting NODE '%s' information: %s\n",
            lcerr.lcerr,
            nodeList[i].name,
            lcErr(lcerr.lcerr));
        continue;
        }

    logf("NODE '%s' ------------------\n"
             "      PARAMETERS\n"
             "%s\n"
             "      INFORMATION\n"
             "%s",
            nodeList[i].name, paramList, infoList);
    }
    
EXIT:;
}


//--------------------------------------------------
void
printConnections(LC *lc)
{
    long        i;
    LCNAMELIST  connectList[NCONNECTIONS];  // List of CONNECT names
    long        nConnect;               // Number of CONNECTIONS
    char        paramList[NPARAMSIZE];  // Buffer for NODE's parameters
    LCERR       lcerr;
    

logf("\n");    
logf("CONNECTIONS:\n");
    
lcerr = lcGetConnectionCount(lc, &nConnect);
if (lcerr.lcerr || nConnect <= 0)
    {
    return;
    }
    
lcerr = lcGetConnectionList(lc, connectList, sizeof(connectList));
if (lcerr.lcerr)
    {
    myprintf(" ERROR %d getting CONNECTION list: %s\n", 
        lcerr.lcerr,
        lcErr(lcerr.lcerr));

    goto EXIT;
    }
    
for (i = 0; i < nConnect; i++)
    {
    logf("CONNECTION %s --------------------------------\n", connectList[i].name);
    
    lcerr = lcGetConnectionInfoByConnection(lc, paramList, sizeof(paramList), connectList[i].name);
    if (lcerr.lcerr)
        {
        myprintf("  ERROR %d getting connection information '%s': %s\n",
            lcerr.lcerr,
            connectList[i].name,
            lcErr(lcerr.lcerr));
        }
    else
        {
        logf(" INFORMATION\n%s\n", paramList);
        }
    
    
    lcerr = lcGetConnectionParams(lc, paramList, sizeof(paramList), connectList[i].name);
    if (lcerr.lcerr)
        {
        myprintf("  ERROR %d getting connection initial parameters '%s': %s\n",
            lcerr.lcerr,
            connectList[i].name,
            lcErr(lcerr.lcerr));
        }
    else
        {
        logf(" INITIAL PARAMETERS\n%s\n", paramList);
        }
        
        
    lcerr = lcGetConnectionFinalParams(lc, paramList, sizeof(paramList), connectList[i].name);
    if (lcerr.lcerr)
        {
        myprintf("  ERROR %d getting connection final parameters '%s': %s\n",
            lcerr.lcerr,
            connectList[i].name,
            lcErr(lcerr.lcerr));
        }
    else
        {
        logf(" FINAL PARAMETERS\n%s\n", paramList);
        }
    }
    
EXIT:;
}





//--------------------------------------------------
//LCERR
//sendState(LC *lc, LCCBERRHANDLER *lccbErrHandler, long tgsrvparamState, char *nodeName)
//{
//    char        *stateMessage;
//    
//stateMessage = (tgsrvparamState >= 0 && tgsrvparamState <= TGSRVPARAM_STATE_LASTONE) ?
//        stateTable[tgsrvparamState] :
//        "Unknown STATE" ;
//
//if (!nodeName || !*nodeName)
//    myprintf("    ALL NODEs <- %s\n", stateMessage);
//else
//    myprintf("    NODE %s <- %s\n", nodeName, stateMessage);
//
//return(lcSendState(lc, lccbErrHandler, tgsrvparamState, nodeName));
//}



//--------------------------------------------------
// watchNodes - Monitor all NODEs to make sure they are still running.
// This function polls all nodes once per second, asking NCM to check
// their Win32 Exit Status Code (see win32's GetExitStatusCode() function).
//
// We loop inside this function until we detect that a node has terminated
// or until we encounter an error of any sort (ie a network or NCM error)
// at which point we exit and ELSIE will proceed to shut down the
// computation.
//
// We also check if the user typed the ESC key and we'll exit.
//
// IN
//      lc          LC handle
// 
// OUT
//      0           Nothing useful

long
watchNodes(LC *lc)
{
    long        i;
    LCNAMELIST  nodeNameList[NNODES];   // List of node names
    long        nNodes;                 // Number of NODES
    LCERR       lcerr;
    
    
// Display NCM's connections

myprintf("--------------------------------------------------------\n");
myprintf("Watching NODES..  Press ESC to abort Logical Computation\n");
myprintf("--------------------------------------------------------\n");

lcerr = lcGetNodeCount(lc, &nNodes);
if (lcerr.lcerr)
    return(lcerr.lcerr);                // Error determining number of nodes
    
if (nNodes <= 0)
    return(nNodes);                     // No nodes to watch
    

lcerr = lcGetNodeList(lc, nodeNameList, sizeof(nodeNameList));
if (lcerr.lcerr)
    {
    myprintf("ELSIE - ERROR %d getting NODE list: %s\n", 
        lcerr.lcerr,
        lcErr(lcerr.lcerr));

    goto EXIT;                          // Unable to get list of node names
    }
    
// Scan NODEs watching for one that terminates

while (1)
    {
    // Check each NODE's statcode
        
    for (i = 0; i < nNodes; i++)
        {
        long        isRunning;
        
        if (kbhit() && getch() == ESC)
            {
            myprintf("ELSIE - watchno User requested abort.\n");
            goto EXIT;
            }
            
        isRunning = isNodeStillActive(lc, nodeNameList[i].name);
        if (isRunning <= 0)
            {
            // Either the node isn't running or we encountered an
            // error trying to get the process exit status code.
            
            goto EXIT;
            }
        }
            
    // Wait a while before checking again (lcUpdateNodeProcessStatus does network i/o)

    Sleep(1000);                        // Wait between checks
    }
        
EXIT:;
myprintf("ELSIE - watchNode: Aborting computation.\n");
return(0);
}
    


//--------------------------------------------------
// isNodeStillActive - Ask NCM to see if the process associated with a node is
// still active.
//
// A variety of errors can occur including network errors, NCM errors
// and Windows errors.  In these cases, we are unable to determine if
// the node is still running so we return -1.  If we determine that the
// node has definitely terminated, we return 0.  If we determine that
// the node is definitely still running, we return 1.
//
// In the event of an error, this function prints a message detailing
// the error it encounters.
//
// See the isNodeRunning() function for more information.
//
// IN
//      lc          an LC handle
//      nodeName    Name of node to check
//
// OUT
//      -1          Unknown.  An error prevented this function
//                      from determining if the NODE is still running or not.
//       0          The node has terminated
//       1          The node is still active

static long
isNodeStillActive(LC *lc, char *nodeName)
{    
    LCERR       lcerr;              // An LCERR code
    ULONG       statCode;           // NCM's result from calling GetExitCodeProcess() 
    ULONG       lastError;          // NCM's GetLastError()
    long        paramerr;           // A PARAMERR_xxx status
    char        paramList[NPARAMSIZE];  // Buffer for NODE's parameters
    char        computerName[NNAMESIZE];// Name of NODE's computer
    
// Update NODE's statcode
// (this causes LC to query the NCM computers on which each NODE is running)
// NCM will call win32's GetExitCodeProcess() and the result will be
// stored into this NODE's LCPARAM_STATCODE parameter.
// NCM then calls win32's GetLastError() and stores the result into
// the NODE's LCPARAM_LASTERR parameter.

lcerr = lcUpdateNodeProcessStatus(lc, NULL, nodeName);
if (lcerr.lcerr)
    {
    myprintf("ELSIE - isNodeStillActive(%s): ERROR %d.%d.%d.%d getting NODE status: %s\n",
        nodeName,
        lcerr.lcerr,
        lcerr.tgerr,
        lcerr.llerr,
        lcerr.nwerr,
        lcErr(lcerr.lcerr));

    return(-1);                     // Error trying to get NODE status
    }

// The NODE's status code is one of its "information" parameters

lcerr = lcGetNodeInfo(lc, paramList, sizeof(paramList), nodeName);
if (lcerr.lcerr)
    {
    myprintf("ELSIE - isNodeStillActive(%s): ERROR %d%d.%d.%d getting NODE information: %s\n",
        nodeName,
        lcerr.lcerr,
        lcerr.tgerr,
        lcerr.llerr,
        lcerr.nwerr,
        lcErr(lcerr.lcerr));

    return(-1);                     // Error trying to get NODE status
    }
    
// Just for fun, let's call isNodeRunning just to make sure it
// returns consistent results.  This is NOT a necessary step here
// and wastes time by querying NCM again when we already know the
// answer!

paramerr = paramGetString(paramList, computerName, sizeof(computerName), "%s", LCPARAM_COMPUTER);
if (!paramerr)
    {
    long        answer;
    
    answer = isNodeRunning(lc, computerName, nodeName);
    if (answer != 1)
        myprintf("ELSIE isNodeRunning(%s,%s) returned %d\n", computerName, nodeName, answer);
    }


// See if NCM had a problem obtaining the processes exit status code

lastError = 0;                      // NCM's GetLastError() after caling GetExitCodeProcess()
paramerr = paramGetULong(paramList, &lastError, "%s", LCPARAM_LASTERROR);
if (paramerr || lastError)
    {
    char    errbuf[128];
    
    myprintf("ELSIE - isNodeStillActive(%s): NCM lastError=%X %s\n",
        nodeName,
        lastError,
        formatSysErr(errbuf, sizeof(errbuf), lastError, ""));

    if (lastError == ERROR_PROCESS_ABORTED)
        {
        myprintf("ELSIE - isNodeStillActive(%s): NCM has determined that the NODE has terminated.\n",
            nodeName);
            
        return(0);                  // NCM determined that the process terminated
        }
    else
        {
        myprintf("ELSIE - isNodeStillActive(%s): NCM is unable to determine the NODE exit status code.\n",
            nodeName);

        return(-1);                 // Error in NCM while trying to get NODE status
        }
    }


// See if node has terminated.  If its exit status code is STILL_ACTIVE,
// then it is still running.

statCode = STILL_ACTIVE;            // =259 Win32 status if process is still running

paramerr = paramGetULong(paramList, &statCode, "%s", LCPARAM_STATCODE);

if (paramerr || statCode != STILL_ACTIVE)
    {
    myprintf("ELSIE - isNodeStillActive(%s): NODE exit status code is %u (0x%X)\n",
        nodeName,
        statCode,
        statCode);

    myprintf("ELSIE - isNodeStillActive(%s): watchno aborting computation.\n",
        nodeName);

    return(0);                      // The process has terminated
    }
    
//myprintf("ELSIE - isNodeStillActive(%s): NODE is running.\n", nodeName);

return(1);                          // The process is still running
}



//--------------------------------------------------
// printNCMConnections - Display detailed list of all connections on a remote NCM computer
// This function illustrates the use of the lcNCMGetConnectionInfo function.
//
// IN
//          lc              LC * handle
//          computerName    Name of computer to query
//      
// OUT
//          Displays information about remote NCM

void
printNCMConnections(LC *lc, char *computerName)
{
    long            i;                      // Index into NCM's connections
    LCNCMCONNINFO   ncm;                    // NCM connection information
    LCERR           lcerr;
    
// i=-1 Starts search at beginning of NCM connection list

for (i = -1; 1; )                           //lint !e506
    {
    lcerr = lcNCMFindConnectionInfo(lc,
                    NULL,                   // PASSWORD
                    computerName,           // computer name
                    i,                      // iConnection
                    0,                      // All service types
                    0,                      // ProcessID
                    "",                     // All nodes
                    &ncm);
    if (lcerr.lcerr)
        {
        myprintf("watchNodes: lcNCMGetConnectionInfo(%d, LC%d.TG%d.LL%d.NW%d): %s\n",
            i, 
            lcerr.lcerr,
            lcerr.tgerr,
            lcerr.llerr,
            lcerr.nwerr,
            lcErr(lcerr.lcerr));
        break;
        }
    else
        {
        myprintf("  NCM COMPUTER %s[%d]: NODE '%s' Service %d   PID=%X\n",
            ncm.computerName,
            ncm.iConnection,
            ncm.nodeName,
            ncm.serviceType,
            ncm.processID);
        myprintf("      Process='%s'\n", 
            ncm.processName);
            
        myprintf("      Local %s:%d   Remote %s:%d\n",
            ncm.quadLocalIP, ncm.localPort,
            ncm.quadRemoteIP, ncm.remotePort);
            
        i = ncm.iConnection;                // Skip to next connection
        if (i < 0)                          // Any more?
            break;
        }
        
    }
}


//--------------------------------------------------
// isNodeRunning - Asks remote NCM if a particular NODE is running.
// We scan the list of connections on a remote NCM computer looking
// for a particular node name with a TG CMD Server port (LCNCM_SERVICE_TGCMDS).
//
// Here are few notes:
//
//  0. This function can be called even if the NODE name isn't currently
//     in the logical computation.  In otherwords, you can call this function
//     before adding a NODE to the computation.  For instance, you can use
//     this function to determine if a manually started node is already
//     running on a remote computer.
//
//  1. This algorithm will not correctly determine if a NODE
//     is running if that NODE is not a TG-Enabled (Symphony) node.
//
//  2. Some NODEs can take a little time after they are
//     started to open their TG CMD Server port so retrying a few times
//     could be useful.  We don't do that here.
//
//  3. We only detect "well named" nodes.  These are nodes that
//     have a NODE name assigned to them, either by the program itself
//     when it called tgInit() or after an ELSIE has assigned a node name
//     to an anonymous node.  Note that this means we won't detect
//     anonymous nodes because they don't yet have a node name!
//
//  4. So why not just call lcUpdateNodeProcessStatus() and look
//     at the NODE's statcode to see if it is STILL_ACTIVE?  Notice
//     that this function doesn't require the node to even exist
//     in the graph!  
//
//     The WatchNodes() method of checking a node relies
//     on the fact that the node exists in the graph and lcRunNode()
//     was called.
//
//     This function directly queries a remote NCM and can therefore be
//     called at any time.  In particular, it could be called BEFORE
//     lcRunNode to determine if the NODE (i.e. TEMPOW) is already running.
//     If it isn't, the controller could set runProgram=YES then call lcRunNode
//     to cause the NODE to be started.  If it is already running,
//     the controller could set runProgram=NO then call lcRunNode and
//     connect to the already running node.  Note that if you implement
//     this logic, you may also want to set exitProgram to not terminate
//     a NODE that was already running (if that's the behavior you
//     want, of course).
//
//  5. Using this method (instead of isNodeStillActive), the lasterror
//     and other parameters for an existing node are _NOT_ updated!
//     isNodeStillActive will update a NODE's parameters.
//
// IN
//      lc              an LC * handle
//      computerName    Name of computer to query
//      nodeName        Name of NODE to look for
//
// OUT
//      -1              An error occurred - we can't determine answer.
//       0              NODE is not running on remote computer
//       1              NODE is running on remote computer

long
isNodeRunning(LC *lc, char *computerName, char *nodeName)
{
    long            i;                  // Index into NCM connection list
    LCERR           lcerr;
    LCNCMCONNINFO   ncm;                // NCM connection information

for (i = -1; 1; )                       //lint !e506
    {    
    lcerr = lcNCMFindConnectionInfo(lc,
                NULL,                   // PASSWORD
                computerName,           // computer name
                i,                      // iConnection (start search at beginning of list)
                LCNCM_SERVICE_TGCMDS,   // Only look at TG CMD Servers
                0,                      // We don't know/care what the processID is
                nodeName,               // It must be this node
                &ncm);

    if (lcerr.lcerr)                    // Did an error occur?
        {
        if (lcerr.lcerr == LCERR_CONNECTIONNOTFOUND)
            return(0);                  // Node is not running
        
        myprintf("isNodeRunning - lcNCMGetConnectionInfo(%d, LC%d.TG%d.LL%d.NW%d): %s\n",
            i, 
            lcerr.lcerr,
            lcerr.tgerr,
            lcerr.llerr,
            lcerr.nwerr,
            lcErr(lcerr.lcerr));
            
        return(-1);                     // We encountered an error, quit immediately with error
        }
        
    // We either got back a connection with the node name we requested
    // in it or the next anonymous node.
    
    if (stricmp(nodeName, ncm.nodeName) == 0)   // Did we find our node?
        return(1);                      // Yes!  The node is running
        
    // Skip to the next NCM connection
    
    i = ncm.iConnection;                // Skip to next connection
    if (i < 0)                          // Any more?
        return(0);                      // No - we failed to find our NODE
    }                                   // (it must not be running)
}

