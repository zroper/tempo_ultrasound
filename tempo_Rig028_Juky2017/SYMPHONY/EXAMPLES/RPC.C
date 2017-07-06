/*  .title  rpc.C - Example of Symphony's RPC calls
;+
; SYNOPSIS
;   rpc [remoteNode]
;
; DESCRIPTION
;   This program shows both the client-side and the server-side of a
;   Remote Procedure Call (RPC).  When this program is invoked without a remoteNode
;   name, it becomes the server-side of an RPC.
;
;   When this program is invoked with a remoteNode name on the command line,
;   it assumes the role of an RPC client and makes an RPC request to the
;   remote node.
;
;   This sample program illustrates the following concepts:
;
;           client-side RPC node (calls remote rpc function)
;           server-side RPC node (executes rpc function when called by client)
;
;       How to send a RPC request to another NODE and receive back its reply.
;           (uses tgRpcRegister(), tgRpcCall(), tgRpcUnregister())
;
;       How to receive an RPC request from another NODE and how to return a reply to it.
;           (uses tgRpcRegister(), user defined RPC function, tgRpcUnregister())
;
;   The tgRpcCall() is the function that sends an RPC request to a remote
;   node.  On the remote node, that request is processed and the results
;   are returned to the requesting node.
;
;   This program's main thread waits either for hMainExitEvent win32 EVENT
;   to be signaled (see tgcbState()) or for the user to type a key on the
;   keyboard (a user requested abort).
;
;
; ACKNOWLEDGEMENTS
;   Thanks to Mike Page for his help in reviewing and clarifying this code.
;
;
; TESTING
;   To run this program, open a Command Window and type the following
;   commands:
;
;       cd \tempo\symphony\examples
;       ncm test
;       elsie rpc.lc
;
;
; EDIT HISTORY
;   03Aug07 sh  Initial edit
;-
*/
#include    <windows.h>
#include    <stdio.h>
#include    <io.h>
#include    <conio.h>                   // For getch()
#include    <time.h>

#include    "fio.h"                     // Handy for file logging
#include    "tg.h"

#define EXAMPLE_LOG     "rpc.log"       // Name of LOG file

//------------------------------------------------------------------------
// TG Callback table - these functions are called by TG

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

static void tgcbMessage(const TG *hTG, const char *text);   // Status message from TG
static void tgcbLog(const TG *hTG, const char *text);       // debug messages from TG
static long tgcbState(const TG_RQSTRESP *rr, long flag);


TGCBFUNCTIONS Tgcb =
    {
    TG_VERSION, TG_SET, sizeof(TGCBFUNCTIONS),      // Required for all callback tables
    
    NULL,                               // Ask about HS SEND connection
    NULL,                               // Open HS SEND connection
    NULL,                               // Close HS SEND connection
    
    NULL,                               // Ask about HS RECV connection
    NULL,                               // Open HS RECV connection
    NULL,                               // Close HS RECV connection
    
    tgcbState,                          // Logical Computation state
    
    NULL,                               // query handler
    NULL,                               // Receive message from remote tgSendf
    
    tgcbMessage,                        // Status messages from TG
    tgcbLog,                            // For TG debugging messages
    NULL                                // For Hyperstream and TG thread exceptions (including user's callback)
    };
    

//------------------------------------------------------------------------
// Other local variables and function prototypes

static char myNodeName[TG_TGCMDSRV_NODENAMESIZE];   // The name ELSIE assigns to this NODE
static char remoteNodeName[TG_TGCMDSRV_NODENAMESIZE]; // Name of remote NODE (or NULL)
static char thisComputerName[MAX_COMPUTERNAME_LENGTH + 1];  // Name of this computer

static HANDLE  hMainExitEvent;       // A Win32 event flag our tgcbState() will signal to exit
    
static void logf(const char *fmt, ...); //lint -printf(1, logf) write formatted string to LOG file

static long currentState;           // Last state message received


//-------------------------
// RPC function related definitions
// The client and server must agree on the following, which can be stored in a .H file.
//
// 1. The name of the server-side RPC function (a string)
// 2. The number of arguments to the RPC function
// 3. The size of each argument.
// 4. The behavior (implementation) of the function must be consistent
//    with what the client expects.
//
// The first 3 are used in tgRpcRegister().  #4 is assumed by the
// client application.

typedef struct
    {
    char        text[100];
    long        l;
    } SS;
    

#define MYRPCFUNC       "myRpcFunc"     // Server side name of this RPC function
static long myRpcFunc(const TG_RQSTRESP *rr, char *c, long *l, double *d, SS *ss);  // A TG_RPC function
static void callMyRpcFunc(TG *tg);      // Call the myRpcFunc function

#define MYRPCFUNCVAR    "myRpcFuncVar"  // Server side name of this RPC function
static long myRpcFuncVar(const TG_RQSTRESP *rr, char *string);
static void callMyRpcFuncVar(TG *tg);    // Call the myRpcFuncVar function


// CLIENT-SIDE AND SERVER-SIDE RPC FUNCTION NAMES.
//
// This program defaults the client side name of the RPC function to match
// the server-side RPC function name.
//
// This is not mandatory.  The client can register a remote RPC function with any
// name it chooses!  This allows for the situation where two different remote server
// nodes register the same RPC name.  The client can register different
// client-side names for each remote RPC function.
//
// For example, if NODE A registers "foo" with 2 args and NODE B registers
// its "foo" with 3 args, the client can register two "foo" functions
// with different client-side names (ie foo.A and foo.B) then call
// tgRpcCall(foo.A, node A, ..) and tgRpcCall(foo.B, node B, ..);


//------------------------------------------------------------------------
void
main(int ac, char *av[])
{
    TG    Tg;                 // A TG handle
    long        tgerr;              // A TG_xxx status
    DWORD       nSize;

// Get this computers name
    
nSize = sizeof(thisComputerName);
(void) GetComputerName(thisComputerName, &nSize);  // Get name of this computer
    

// Delete old LOG file and get ready with new one

if (_access(EXAMPLE_LOG, 0) == 0)
    remove(EXAMPLE_LOG);            // Delete previous log file
    
logf("%s - Opened LOG file '%s' on COMPUTER '%s'\n",
    av[0],
    EXAMPLE_LOG,
    thisComputerName);

    
// If a remoteNodeName is specified on the command line, set remoteNodeName[].
    
if (ac > 0 && av[1])
    sprintf(remoteNodeName, "%.*s", sizeof(remoteNodeName) - 1, av[1]);
    

// The main thread will wait for the hMainExitEvent event to be signaled.
//
// This event is signaled when ELSIE sends the TGSRVPARAM_STATE_EXIT
// state message (see tgcbState() below).
//
// When signaled, it tells the main thread that its time to exit the program.

hMainExitEvent = CreateEvent(NULL,          // no security
                TRUE,                       // is event manual-reset?
                FALSE,                      // is event initially signaled?
                NULL);                      // event name
if (!hMainExitEvent)
    {
    printf("Error creating hMainExitEvent win32 EVENT.\n");
    return;
    }
    

// Create the Symphony node used by this application

tgerr = tgInit(&Tg,                 // TG handle
               NULL,                // our node name (let ELSIE assign it)
               0,                   // Our server port (let TG assign it)
               &Tgcb,               // Our TG callback table
               0,                   // our user-defined value
               1);                  // Allow TG callbacks
if (tgerr)
    {
    printf("tgInit - ERROR %d: %s\n", tgerr, tgErr(tgerr));
    return;
    }


// ------------------------------------------------------------------
// Register the RPC function.
//
// Both client-side and server-side must register each RPC function
// they want to use.  Both client and server must specify the same
// number of arguments and the same sizes for each argument.
//
// Registering an RPC function tells Symphony a number of things about the
// RPC function including its client-side and server-side names, entry point
// (server only), number of arguments and sizes of each argument.  This helps
// Symphony to insure that when the application provides the correct buffers
// in the tgRpcCall() function when it is invoked.    

logf("Registering RPC function '%s'\n", MYRPCFUNC);

if (remoteNodeName[0])
    {
    // We are the client-side (a remoteNode was specified on command line)

    tgerr = tgRpcRegister(&Tg,
                MYRPCFUNC,          // Client name of RPC function
                NULL,               // Server name of RPC function (NULL=default to serverName)
                NULL,               // This client doesn't serve this function
                sizeof(char),       // size of buffer 1
                sizeof(long),       // size of buffer 2
                sizeof(double),     // size of buffer 3
                sizeof(SS),         // size of buffer 4
                NULL);              // This is MANDATORY!
    
    }
else
    {
    // We are the server-side (no remoteNode was specified on command line)
    
    tgerr = tgRpcRegister(&Tg,
                MYRPCFUNC,          // Client name of RPC function
                NULL,               // Server name of RPC function (NULL=default to serverName)
                (TG_RPC) myRpcFunc, // Entry point for function on server
                sizeof(char),       // size of buffer 1
                sizeof(long),       // size of buffer 2
                sizeof(double),     // size of buffer 3
                sizeof(SS),         // size of buffer 4
                NULL);              // This is MANDATORY!
    
    }

if (tgerr)
    {
    logf("tgRpcRegister(%s) ERROR %d: %s\n", MYRPCFUNC, tgerr, tgErr(tgerr));
    goto TGUNINIT;
    }
else    
    logf("tgRpcRegister(%s) - Successful.\n", MYRPCFUNC);


// Now register a second RPC function that accepts variable length arguments    
    
if (remoteNodeName[0])
    {
    // We are the client-side (a remoteNode was specified on command line)

    tgerr = tgRpcRegister(&Tg,
                MYRPCFUNCVAR,      // Client name of RPC function
                NULL,               // Server name of RPC function (NULL=default to serverName)
                NULL,               // This client doesn't serve this function
                -1,                 // size of buffer 1
                NULL);              // This is MANDATORY!
    
    }
else
    {
    // We are the server-side (no remoteNode was specified on command line)
    
    tgerr = tgRpcRegister(&Tg,
                MYRPCFUNCVAR,      // Client name of RPC function
                NULL,               // Server name of RPC function (NULL=default to serverName)
                (TG_RPC) myRpcFuncVar, // Entry point for function on server
                -1,                 // size of buffer 1
                NULL);              // This is MANDATORY!
    
    }

if (tgerr)
    {
    logf("tgRpcRegister(%s) ERROR %d: %s\n", MYRPCFUNCVAR, tgerr, tgErr(tgerr));
    goto TGUNINIT;
    }
else    
    logf("tgRpcRegister(%s) - Successful.\n", MYRPCFUNCVAR);
    
    

// ------------------------------------------------------------------
    
    
// Wait for the user to abort this NODE by typing ESC
// or for ELSIE to terminate us (by sending our tgcbState()
// function the TGSRVPARAM_STATE_EXIT message.
//
// While we're waiting, if a remoteNodeName was specified on the
// command line, let's send it a query and display the results it
// gives back to us.

while (!kbhit())
    {
    DWORD       dResult;            // Return value from WaitForSingleObject
    
    // Wait whichever comes first: Exit event or 2000 ms

    dResult = WaitForSingleObject(hMainExitEvent, 2000);
    
    // Reset the win32 manual-reset event
    
    (void) ResetEvent(hMainExitEvent);
    
    // Branch to handle the cause for ending the wait

    switch (dResult)
        {
        // Time out period expired

        case    WAIT_TIMEOUT:;
            {
            // if we were given name of the remote NODE,
            // we periodically call that RPC function in the remote NODE.
            //
            // Note that we wait to be told by ELSIE that the
            // computation has been started.
            
            if (currentState == TGSRVPARAM_STATE_START &&
                remoteNodeName[0])
                {
                callMyRpcFunc(&Tg);     // Call the RPC function from client
                callMyRpcFuncVar(&Tg);  // Call the RPC function from client
                }
            
            continue;               // Don't quit yet but check keyboard (above)
            }
            

        // Our application requested we terminate

        case    WAIT_OBJECT_0:;
            goto QUIT;              // Our application requested we terminate
            

        // Handle error conditions.

        case    WAIT_FAILED:;
                                    //lint -fallthrough
        case    WAIT_ABANDONED:;
                                    //lint -fallthrough
        default:    
            goto QUIT;              // Something serious is wrong
        }
    }                               // end switch (dResult)    
    

// Quit the program

QUIT:;
    
if (kbhit())                        // Did the user hit the keyboard?
    (void) getch();                 // Eat the character
    

// Let's unregister our RPC functions
// Both client and server should do this (but its not absolutely necessary).    

logf("Unregistering RPC function '%s'\n", MYRPCFUNC);

tgerr = tgRpcUnregister(&Tg, MYRPCFUNC);
if (tgerr)
    logf("tgRpcUnregister(%s) ERROR %d: %s\n", MYRPCFUNC, tgerr, tgErr(tgerr));

    
logf("Unregistering RPC function '%s'\n", MYRPCFUNCVAR);

tgerr = tgRpcUnregister(&Tg, MYRPCFUNCVAR);
if (tgerr)
    logf("tgRpcUnregister(%s) ERROR %d: %s\n", MYRPCFUNCVAR, tgerr, tgErr(tgerr));
    

// If we received a state EXIT message, the TG callback thread
// needs a little time to return a response back to ELSIE.

Sleep(250);

// Destroy this application's TG node.

TGUNINIT:;

tgerr = tgUninit(&Tg);
if (tgerr)
    {
    printf("tgUninit - ERROR %d: %s\n", tgerr, tgErr(tgerr));
    }
    

// Destroy our exit event

if (hMainExitEvent)                     // Close our main event
    {
    CloseHandle(hMainExitEvent);
    hMainExitEvent = 0;
    }
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

static long
tgcbState(const TG_RQSTRESP *rr, long state)
{

// Branch to handle the state

currentState = state;                   // Remember last state message received

switch (state)
    {
    case TGSRVPARAM_STATE_INVITE:
    //-------------------------------
        {
        // For anonymous nodes such as this one, this is how we learn
        // our node name and LCID from ELSIE.
        //
        // ELSIE uses this message to assign our NODE's name and LCID
        // (ie., from the NODE name specified in the .LC file).
        //
        // Until this message is received, our NODE name and LCID are not assigned.
        
        (void) tgGetInfo(&rr->hTG, TGGI_GETMYNODENAME, myNodeName, sizeof(myNodeName));
        break;
        }
        
    case TGSRVPARAM_STATE_START:
    //-------------------------------
        {
        break;
        }
        
    case TGSRVPARAM_STATE_STOP:
    //-------------------------------
        {
        break;
        }
        
    case TGSRVPARAM_STATE_UNINVITE:
    //-------------------------------
        {
        break;
        }
        
    case TGSRVPARAM_STATE_EXIT:
    //-------------------------------
        {
        // Here is were we tell our MAIN thread to stop processing.
        
        SetEvent(hMainExitEvent);       // Tell main program we're quitting
        break;
        }
    
    
    default:
    //-------------------------------
        {
        //printf("NODE %s: UNKNOWN STATE %d\n", myNodeName, state);
        return(1);
        }
        
    }                                   // end switch (flag)
    
    
// Successful.

return(0);
}


//------------------------------------------------------------------------
// tgcbLog - Printf to the LOG file
//
// IN
//      hTG         TG pointer
//      text        message to display
//
// RETURNS
//      Number of bytes written to LOG file
//
//lint -esym(715, hTG)  not referenced

void
tgcbLog(const TG *hTG, const char *text)
{
logf("%s", text);                        // Write to log file
}



//------------------------------------------------------------------------
// tgcbMessage - Display a status message from TG
// This function is called by TG when to display messages related to unusual conditions.
// These messages are typically one line or less and don't have terminating newline (\n).
//
// IN
//      hTG         Pointer to TG
//      text        message to display
//
// RETURNS
//      Nothing
//

static void
tgcbMessage(const TG *hTG, const char *text)
{
// Log and print message string.

logf("%s\n", text);                      // Append newline character
printf("%s\n", text);                    // Write message to stdout
}



               
//------------------------------------------------------------------------
// logf - This function writes a formatted string to the LOG (text) file
//
// IN
//      fmt             format specification (see printf)
//      ..              optional additional arguments
//
// OUT
//      nothing

static void
logf(const char *fmt, ...)
{
    long            n;                  // # bytes in buffer (including NULL)
    va_list         arg_ptr;            // for formatting
    char            buf[2048];
    SYSTEMTIME      systime;
    

// Expand the format string and variable arguments into a string.

va_start(arg_ptr, fmt);
n = _vsnprintf(buf, sizeof(buf) - 1, fmt, arg_ptr);   // Important to use n-1!
va_end(arg_ptr);

if (n < 0 || n >= (long) sizeof(buf))
    n = sizeof(buf) - 1;
buf[n] = 0;                             // Guarantee NULL terminated


// Get current system time

GetSystemTime(&systime);
    

// Write message to LOG file

(void) FIOWriteStrToFilename(EXAMPLE_LOG, "%02u.%02u.%03u: NODE %s: %s",
    systime.wMinute,
    systime.wSecond,
    systime.wMilliseconds,
    myNodeName,
    buf);
    
}


//------------------------------------------------------------------------
// callMyRpcFunc - Call the myRpcFunc RPC function from client

static void
callMyRpcFunc(TG *tg)
{
    TG_QUERY    tgquery;            // Return value from tgQueryf()
    time_t      t;                  // current time
    long        timeout = 1000;     // # of ms to wait for reply
    
    SS          ss;                 // input/output argument to RPC function
    char        c;                  // input/output argument to RPC function
    long        l;                  // input/output argument to RPC function
    double      d;                  // input/output argument to RPC function
                
// Prepare values to arguments that will be passed to the RPC function.

time(&t);                       // Get current time
c = 'a';
l = t;
d = l;
(void) _snprintf(ss.text, sizeof(ss.text), "%.26s", ctime(&t));
ss.l = 3;

printf("-------------------------------------------\n");
printf("CALLING myRpcFunc on NODE %s\n", remoteNodeName);
printf("  c='%c' l=%d d=%f\n", c, l, d);
printf("  ss->l=%d, ss->text='%s'\n", ss.l, ss.text);

logf("-------------------------------------------\n");
logf("CALLING myRpcFunc on NODE %s\n", remoteNodeName);
logf("  c='%c' l=%d d=%f\n", c, l, d);
logf("  ss.l=%d, ss.text='%s'\n", ss.l, ss.text);

       
// ---------------------------------------------------------------
// Here is where the client-side makes it call to the RPC function.
// ---------------------------------------------------------------

tgquery = tgRpcCall(tg,             // TG handle
            LCID_UNKNOWN,           // Use default LCID
            remoteNodeName,         // Destination NODE name
            MYRPCFUNC,              // Remote RPC function name to call
            timeout,                // # of ms to wait for reply
            &c,                     // arg 1
            &l,                     // arg 2
            &d,                     // arg 3
            &ss);                   // arg 4
                

// If error was detected, print error message

if (tgquery.tgerr)
    {
    logf("tgRpcCall returned ERROR %d: %s\n", tgquery.tgerr, tgErr(tgquery.tgerr));
    logf("          tgquery.userStatus = %d  tgquery.tgsrvStatus=%d\n",
            tgquery.userStatus,
            tgquery.tgsrvStatus);
            
    
    printf("tgRpcCall returned ERROR %d: %s\n", tgquery.tgerr, tgErr(tgquery.tgerr));
    printf("          tgquery.userStatus = %d  tgquery.tgsrvStatus=%d\n",
            tgquery.userStatus,
            tgquery.tgsrvStatus);
            
    }
    
else
    {
    // We got back a reply from the remote node, so print it
    
    printf("-------------------------------------------\n");
    printf("myRpcFunc on NODE %s RETURNED\n", remoteNodeName);
    printf("  c='%c' l=%d d=%f\n", c, l, d);
    printf("  ss.l=%d, ss.text='%s'\n", ss.l, ss.text);

    logf("-------------------------------------------\n");
    logf("myRpcFunc on NODE %s RETURNED\n", remoteNodeName);
    logf("  c='%c' l=%d d=%f\n", c, l, d);
    logf("  ss.l=%d, ss.text='%s'\n", ss.l, ss.text);

    }                
}



//------------------------------------------------------------------------
// myRpcFunc - This function is registered with Symphony on the server side.
// The client-side uses tgRpcCall() to call it.
//
// This example shows how a character, long, double and a structure
// can be passed from the client node to the server node then back to
// the client node.
//
// Note that arrays, can also be passed (not shown here).  Client side pointers,
// kernel events and other client-specific objects should not be passed
// across RPC because these client specific values are meaningless on the
// server.
//
// In otherwords, RPC argument buffers contain data that is passed "by value"
// and not "by reference".
//
// Your RPC functions can, in general, modify the buffers they are given
// and the changed buffers are returned to the client node in the buffers
// the client provided to tgRpcCallEx.

static long
myRpcFunc(const TG_RQSTRESP *rr, char *c, long *l, double *d, SS *ss)
{
    TG_RPCINFO      *rpcinfo;
    long            i;
    
logf("-----------------------------------------------------\n");
logf("NODE %s.%I64u CALLED myRpcFunc RPC FUNCTION WITH\n",
    rr->fromNodeName,
    rr->fromLCID);
    
printf("-----------------------------------------------------\n");
printf("NODE %s.%I64u CALLED myRpcFunc RPC FUNCTION WITH\n",
    rr->fromNodeName,
    rr->fromLCID);
    
rpcinfo = (TG_RPCINFO *) rr->rqst;  //lint !e826 Suspicious pointer conversion    
    
// Display some information from the TG_RPCINFO structure

logf("myRpcFunc - RPCINFO: '%s' nArgs=%d\n", rpcinfo->rpcFuncName, rpcinfo->nArgs);
printf("myRpcFunc - RPCINFO: '%s' nArgs=%d\n", rpcinfo->rpcFuncName, rpcinfo->nArgs);
for (i = 0; i < rpcinfo->nArgs; i++)
    {
    logf("  [%d]: size=%d  ptr=%p\n", i, rpcinfo->argSize[i], rpcinfo->arg[i]);
    printf("  [%d]: size=%d  ptr=%p\n", i, rpcinfo->argSize[i], rpcinfo->arg[i]);
    }

// Display the values of the arguments we received.

logf("myRpcFunc - c='%c' l=%d d=%f\n", *c, *l, *d);
logf("  ss->l=%d, ss->text='%s'\n", ss->l, ss->text);
     
printf("myRpcFunc - c='%c' l=%d d=%f\n", *c, *l, *d);
printf("  ss->l=%d, ss->text='%s'\n", ss->l, ss->text);


    
// Then we change some of the values and return the results to the client.

(void) _snprintf(ss->text, sizeof(ss->text), "Hello from %s on %s",
    myNodeName, thisComputerName);
    
ss->l = *l + 1;

logf("myRpcFunc - RETURNING ..\n");
logf("myRpcFunc - c='%c' l=%d d=%f\n", *c, *l, *d);
logf("  ss->l=%d, ss->text='%s'\n", ss->l, ss->text);

printf("myRpcFunc - RETURNING ..\n");
printf("myRpcFunc - c='%c' l=%d d=%f\n", *c, *l, *d);
printf("  ss->l=%d, ss->text='%s'\n", ss->l, ss->text);

// Finally, we return a status code with our return value.
//
// The client receives this value in TG_QUERY.userStatus member.
//
// If we return a negative value here and no other tgsrvStatus
// Symphony error occurred, SYMPHONY will set the client's
// TG_QUERY.tgsrvStatus=TGSRVSTATUS_REMOTETGCBERR.

return(0);
}



//------------------------------------------------------------------------
// callMyRpcFunc - Call the myRpcFunc RPC function from client

static void
callMyRpcFuncVar(TG *tg)
{
    TG_QUERY    tgquery;            // Return value from tgQueryf()
    time_t      t;                  // current time
    long        timeout = 1000;     // # of ms to wait for reply
    
    char        buf[100];
                
// Prepare values to arguments that will be passed to the RPC function.

time(&t);                       // Get current time
sprintf(buf, "%.26s", ctime(&t));

printf("-------------------------------------------\n");
printf("CALLING myRpcFuncVar on NODE %s\n", remoteNodeName);
printf(" string='%s'\n", buf);

logf("-------------------------------------------\n");
logf("CALLING myRpcFuncVar on NODE %s\n", remoteNodeName);
logf(" string='%s'\n", buf);

       
// ---------------------------------------------------------------
// Here is where the client-side makes it call to the RPC function.
// ---------------------------------------------------------------

tgquery = tgRpcCallEx(tg,           // TG handle
            LCID_UNKNOWN,           // Use default LCID
            remoteNodeName,         // Destination NODE name
            MYRPCFUNCVAR,           // Remote RPC function name to call
            timeout,                // # of ms to wait for reply
            buf,                    // String to pass to remote RPC function
              strlen(buf) + 1);     // string length, including trailing NULL
                

// If error was detected, print error message

if (tgquery.tgerr)
    {
    logf("tgRpcCallEx returned ERROR %d: %s\n", tgquery.tgerr, tgErr(tgquery.tgerr));
    logf("          tgquery.userStatus = %d  tgquery.tgsrvStatus=%d\n",
            tgquery.userStatus,
            tgquery.tgsrvStatus);
            
    
    printf("tgRpcCallEx returned ERROR %d: %s\n", tgquery.tgerr, tgErr(tgquery.tgerr));
    printf("          tgquery.userStatus = %d  tgquery.tgsrvStatus=%d\n",
            tgquery.userStatus,
            tgquery.tgsrvStatus);
            
    }
    
else
    {
    // We got back a reply from the remote node, so print it
    
    printf("-------------------------------------------\n");
    printf("myRpcFuncVar on NODE %s RETURNED\n", remoteNodeName);
    printf(" string='%s'\n", buf);
    

    logf("-------------------------------------------\n");
    logf("myRpcFuncVar on NODE %s RETURNED\n", remoteNodeName);
    logf(" string='%s'\n", buf);
    }                
}



//------------------------------------------------------------------------
// myRpcFuncVar - This function is registered with Symphony on the server side.
// The client-side uses tgRpcCallEx() to call it because it uses at least
// one variable length argument.
//
// This example shows how function with variable length arguments can be
// called from a client node.
//
// In this example, the myRpcFuncVar accepts just one variable length
// argument.  In general, up to TG_RPCNARGS(=16) arguments can be specified and any
// of they can be variable length or fixed length.
//
// Functions like this that accept variable length arguments need to
// consult the rr->resp structure, which points to a TG_RPCINFO structure.
// This structure contains the number of bytes in each argument buffer.
//
// Your RPC functions can, in general, modify the buffers they are given
// and the changed buffers are returned to the client node in the buffers
// the client provided to tgRpcCallEx.
//
// 27Jan09 We randomly return a value in the range [-5..4].  Values
//         below zero are treated as errors (TG_REMOTETGSRVERR) by Symphony.
//         We artificially and randomly generate error codes
//         to illustrate how Symphony returns the returnCode and buffer
//         back to the client application.

static long
myRpcFuncVar(const TG_RQSTRESP *rr, char *string)
{
    TG_RPCINFO      *rpcinfo;
    long            i;
    long            returnCode;         // Value to return
    
logf("-----------------------------------------------------\n");
logf("NODE %s.%I64u CALLED myRpcFunc RPC FUNCTION WITH\n",
    rr->fromNodeName,
    rr->fromLCID);
    
printf("-----------------------------------------------------\n");
printf("NODE %s.%I64u CALLED myRpcFunc RPC FUNCTION WITH\n",
    rr->fromNodeName,
    rr->fromLCID);
    
rpcinfo = (TG_RPCINFO *) rr->rqst;  //lint !e826 Suspicious pointer conversion    
    
// Display some information from the TG_RPCINFO structure

logf("myRpcFunc - RPCINFO: '%s' nArgs=%d\n", rpcinfo->rpcFuncName, rpcinfo->nArgs);
printf("myRpcFunc - RPCINFO: '%s' nArgs=%d\n", rpcinfo->rpcFuncName, rpcinfo->nArgs);
for (i = 0; i < rpcinfo->nArgs; i++)
    {
    logf("  [%d]: size=%d  ptr=%p\n", i, rpcinfo->argSize[i], rpcinfo->arg[i]);
    printf("  [%d]: size=%d  ptr=%p\n", i, rpcinfo->argSize[i], rpcinfo->arg[i]);
    }

// Display the values of the arguments we received.

logf("myRpcFunc - String='%.*s'\n", rpcinfo->argSize[0], string);
printf("myRpcFunc - Sstring='%.*s'\n", rpcinfo->argSize[0], string);

    
// Then we change some of the values and return the results to the client.

returnCode = rand() % 10;           // [0..9]
returnCode -= 5;                    // [-5..4]

if (rpcinfo->argSize[0] > 2)
    sprintf(string, "myRpcFuncVar %d: %.*s", 
        returnCode,
        rpcinfo->argSize[0] - 1,
        thisComputerName);

// We return a random number between [-5..4]
// Return codes below zero are treated as errors by Symphony.
// This allows us to test Symphony's ability to pass server side
// error codes and strings back to the client.

logf("myRpcFunc - RETURNING %d string='%s'\n", returnCode, string);
printf("myRpcFunc - RETURNING %d string='%s'\n", returnCode, string);


// Finally, we return a status code with our return value.
//
// The client receives this value in TG_QUERY.userStatus member.
//
// If we return a negative value here and no other tgsrvStatus
// Symphony error occurred, SYMPHONY will set the client's
// TG_QUERY.tgsrvStatus=TGSRVSTATUS_REMOTETGCBERR.


return(returnCode);
}


