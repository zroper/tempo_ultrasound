/*  .title  EXAMPLE2.C - NODE that receives a message from another NODE
;+
; SYNOPSIS
;   EXAMPLE2 [remoteNodeName]
;
; DESCRIPTION
;   This sample program illustrates the following concepts
;
;       How to receive a message from another NODE
;       How to receive a State message from ELSIE (and exit).
;       How to cleanly shut down this NODE (ie by request from ELSIE).
;
;   The tbcbReceive() callback is used to receive the message and display
;   it on the screen.
;
;   The State messages from ELSIE server a variety of functions.  They
;   are defined in TG.H with the prefix TGSRVPARAM_STATE_xxx:
;
;       TGSRVPARAM_STATE_BEGINLCINIT         0  // Begin logical computation initialization
;           If we don't specify a NODE name in our tgInit() function, this
;           NODE remains anonymous (unnamed) until ELSIE sends it the BEGINLCINIT
;           state message.
;
;           Hyperstream connections, if any will be established after BEGINLCINIT.
;           HyperStream connections will be opened: tgcbAskSend(), tgcbOpenSend(),
;           tgcbAskRecv() and tgcbOpenRecv() will be called.
;
;
;       TGSRVPARAM_STATE_ENDLCINIT           1  // End logical computation initialization
;           All NODEs in the computer have been started and all HyperStream connections
;           have been established.
;
;       TGSRVPARAM_STATE_START               2  // start logical computation
;           Data will start flowing through the Logical Computation.
;
;       TGSRVPARAM_STATE_STOP                3  // Stop logical computation
;           Data stops flowing through the Logical Computation.
;
;       TGSRVPARAM_STATE_BEGINLCUNINIT       4  // Begin logical computation uninitialization
;           ELSIE will start shutting down one or more Hyperstream Connections and NODES.
;
;           HyperStream connections will be closed: tgcbCloseSend() and tgcbCloseRecv()
;           will be called.
;
;       TGSRVPARAM_STATE_ENDLCUNINIT         5  // End logical computation uninitialization
;           ELSIE completed shutting down one or more Hyperstream Connections and NODES.
;
;       TGSRVPARAM_STATE_EXIT                6  // Exit program
;           ELSIE requests us to exit.  We signal our hMainExitEvent win32 EVENT
;           which causes our main thread to wake up and call tgUninit() and exit.
;       
;   The NODE exits when it receives a State message from ELSIE.  This
;   is done by the tgcbState() callback function.  When it receives an
;   exit request, it signals an Win32 event which our main thread waits
;   on.  When the main thread wakes up, it exits the program.
;
;   This program's main thread waits either for hMainExitEvent win32 EVENT
;   to be signaled (see tgcbState()) or for the user to type a key on the
;   keyboard (a user requested abort).
;
;   While it is waiting, every 1000 ms, it sends a message to the NODE
;   specified on the command line, if one is specified.
;   This allows this program to be run twice in a computation (see example2.lc):
;   One side can be the "sender" of the messages and the other end is
;   the "receiver".
;
;
; ACKNOWLEDGEMENTS
;   Thanks to Mike Page for his help in reviewing and clarifying this code.
;
;
; EDIT HISTORY
;   26Oct06 sh  Initial edit
;   17Jul07 sh  logf: Display NODE name to distinguish messages in EXAMPLE.LOG
;               between sender & receiver.
;               main: Don't send unless we're in the START state.
;-
*/
#include    <windows.h>
#include    <stdio.h>
#include    <io.h>
#include    <conio.h>                   // For getch()
#include    <time.h>

#include    "fio.h"                     // Handy for file logging
#include    "tg.h"

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
static long tgcbRecv(const TG_RQSTRESP *rr);
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
    
    NULL,                               // Receive query from remote tgQueryf
    tgcbRecv,                           // Receive message from remote tgSendf
    
    tgcbMessage,                        // Status messages from TG
    tgcbLog,                            // For TG debugging messages
    NULL                                // For Hyperstream and TG thread exceptions (including user's callback)
    };
    
//------------------------------------------------------------------------
// Other local variables and function prototypes

static char myNodeName[TG_TGCMDSRV_NODENAMESIZE] = "unknown";   // The name ELSIE assigns to this NODE
static char remoteNodeName[TG_TGCMDSRV_NODENAMESIZE]; // Name of remote NODE (or NULL)
static char thisComputerName[MAX_COMPUTERNAME_LENGTH + 1];  // Name of this computer
static char example_log[_MAX_PATH];     // exampl2s.log (sender) or exampl2r.log (receiver)

static HANDLE  hMainExitEvent;          // A Win32 event flag our tgcbState() will signal to exit
static long    State = -1;              // The last TGSRVPARAM_STATE_xxx message we received

static void logf(const char *fmt, ...); // write formatted string to LOG file

//------------------------------------------------------------------------
void
main(int ac, char *av[])
{
    TG          Tg;                 // A TG handle
    long        tgerr;              // A TG_xxx status
    DWORD       nSize;
    

// Get the name of the computer we are running on.
    
nSize = sizeof(thisComputerName);
(void) GetComputerName(thisComputerName, &nSize);  // Get name of this computer
    
// If a remoteNodeName is specified on the command line, we will
// periodically send a message to it using tgSendf().
    
if (ac > 0 && av[1])
    {
    sprintf(remoteNodeName, "%.*s", sizeof(remoteNodeName) - 1, av[1]);
    sprintf(example_log, "exampl2s.log");   // SENDER's LOG file
    }
else
    {
    sprintf(example_log, "exampl2r.log");   // RECEIVER's LOG file
    }
    

// Clean up old LOG file and prepare to use new LOG file.

if (_access(example_log, 0) == 0)
    remove(example_log);            // Delete previous log file

logf("%s - Opened LOG file '%s' on COMPUTER '%s'\n",
    av[0],
    example_log,
    thisComputerName);
    
if (remoteNodeName[0])
    logf(" WE ARE THE SENDER..\n");
else
    logf(" WE ARE THE RECEIVER..\n");

    
    
// The main thread will wait on the hMainExitEvent 

hMainExitEvent = CreateEvent(NULL,          // no security
                TRUE,                       // is event manual-reset?
                FALSE,                      // is event initially signaled?
                NULL);                      // event name
if (!hMainExitEvent)
    {
    printf("Error creating hMainExitEvent win32 EVENT.\n");
    return;
    }


// Create the TG node used by this application

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

    
// Wait for the user to abort this NODE by typing ESC
// or for ELSIE to terminate us (by sending our tgcbState()
// function the TGSRVPARAM_STATE_EXIT message.

while (!kbhit())
    {
    DWORD       dResult;            // Return value from WaitForSingleObject
    
    // Here is where we wait to be told to exit
    
    // Wait whichever comes first:
    //      Exit event signaled or
    //      250 ms timeout (to check keyboard)

    dResult = WaitForSingleObject(hMainExitEvent, 250);
    
    // Reset the win32 manual-reset event
    
    (void) ResetEvent(hMainExitEvent);

    // Branch to handle the cause for ending the wait

    switch (dResult)
        {
        // Time out period expired

        case    WAIT_TIMEOUT:;
            {
            TG_QUERY    tgquery;
            time_t      t;
            
            // We send a message to the receiver if (1) we are the sender and (2)
            // we've been told by ELSIE that the computation has been started.
            // Once the computation has been started, ELSIE has completed its
            // setup of both sender and receiver.  Prior to this, the Receiver
            // may not yet be set up.
            
            if (remoteNodeName[0] &&                // Were we told the name of the remote NODE?
                State == TGSRVPARAM_STATE_START)    // Only send if the computation has been started.
                {
                time(&t);           // Yes, periodically send a message to it.
            
                logf("Sending: 'The time is %s'\n", ctime(&t));
                
                tgquery = tgSendf(&Tg,                          // TG
                                 LCID_UNKNOWN,                  // Use default LCID
                                 remoteNodeName,                // Destination NODE name
                                 "The time is %s", ctime(&t));  // Message to send
                if (tgquery.tgerr)
                    logf("tgSendf returned ERROR %d: %s\n", tgquery.tgerr, tgErr(tgquery.tgerr));
                }
            
            continue;               // Don't quit yet but check keyboard
            }
            

        // Our application requested we terminate.

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
    }    
    
    
// Quit the program

QUIT:;
    
if (kbhit())                        // Did the user hit the keyboard?
    (void) getch();                 // Eat the character
    
// If we received a state EXIT message, the TG callback thread
// needs a little time to return a response back to ELSIE.

Sleep(250);


// Destroy this application's TG node.

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
// tgcbReceive - Receive message from remote NODE's tgSendf
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
printf("tgcbReceive - from NODE %s: '%s'\n",
    rr->fromNodeName,
    rr->rqst);
    
logf("tgcbReceive - from NODE %s: '%s'\n",
    rr->fromNodeName,
    rr->rqst);
    
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

static long
tgcbState(const TG_RQSTRESP *rr, long flag)
{
State = flag;                           // Remember new state

switch (flag)
    {
    case TGSRVPARAM_STATE_INVITE:
    //-------------------------------
        {
        // Until this message is received, our NODE name is not assigned.
        // ELSIE uses the TGSRVPARAM_STATE_BEGINLCINIT to assign our NODE's name
        // (ie., from the NODE name specified in the .LC file).
        //
        // Here is how we learn what name we've been assigned to.
        
        (void) tgGetInfo(&rr->hTG, TGGI_GETMYNODENAME, myNodeName, sizeof(myNodeName));
        printf("NODE %s: Invite into logical computation\n", myNodeName);
        break;
        }
        
    case TGSRVPARAM_STATE_START:
    //-------------------------------
        {
        printf("NODE %s: Start logical computation\n", myNodeName);
        break;
        }
        
    case TGSRVPARAM_STATE_STOP:
    //-------------------------------
        {
        printf("NODE %s: Stop logical computation\n", myNodeName);
        break;
        }
        
        
    case TGSRVPARAM_STATE_UNINVITE:
    //-------------------------------
        {
        printf("NODE %s: Uninvite from computation uninitialization\n", myNodeName);
        break;
        }
        
    case TGSRVPARAM_STATE_EXIT:
    //-------------------------------
        {
        printf("NODE %s: Exit Program\n", myNodeName);
        Sleep(100);                     // Give thread a chance to exit
        
        // Here is were we tell our MAIN thread to stop processing.
        
        SetEvent(hMainExitEvent);       // Tell main program we're quitting
        break;
        }
    
    
    default:
    //-------------------------------
        {
        printf("NODE %s: UNKNOWN STATE %d\n", myNodeName, flag);
        return(1);
        }
    }
    
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



//------------------------------------
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



//------------------------------------
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

(void) FIOWriteStrToFilename(example_log, "%02u.%02u.%03u NODE '%s' %s",
    systime.wMinute,
    systime.wSecond,
    systime.wMilliseconds,
    myNodeName,    
    buf);
    
}

