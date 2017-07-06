/*  .title  EXAMPLE3.C - NODES that make queries of other NODES
;+
; SYNOPSIS
;   EXAMPLE3 [remoteNodeName]
;
; DESCRIPTION
;   This sample program illustrates the following concepts
;
;       How to send a query to another NODE and receive back its reply.
;           (uses tgQueryf())
;
;       How to receive a query from another NODE and how to return a reply to it.
;           (uses tgcbQuery())
;
;   The tgQueryf() is the function that sends a query and the tbcbQuery() callback
;   function is used to receive the query, process it, and return a reply.
;
;   Note that EXAMPLE2.C showed how one NODE can send an unsolicited message
;   ("notification") to another NODE in cases where no reply is needed.
;   EXAMPLE3 differs from EXAMPLE2 in that EXAMPLE3 shows you how one NODE
;   (ie., a "client") can make a request of another NODE (ie a "server")
;   and receive back a response to the request.
;
;   This program's main thread waits either for hMainExitEvent win32 EVENT
;   to be signaled (see tgcbState()) or for the user to type a key on the
;   keyboard (a user requested abort).
;
;   While it is waiting, every 1000 ms, it sends a query to the remoteNodeName
;   if a remoteNodeName is specified on the command line.
;
;   This allows this program to be run in two different ways (see example3.lc):
;   either as a query sender (a remoteNodeName is specified on the command line)
;   or as a query receiver (no remote name is specified on the command line).
;
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
;-
*/
#include    <windows.h>
#include    <stdio.h>
#include    <io.h>
#include    <conio.h>                   // For getch()
#include    <time.h>

#include    "fio.h"                     // Handy for file logging
#include    "tg.h"

#define EXAMPLE_LOG     "example.log"   // Name of LOG file

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
static long tgcbQuery(const TG_RQSTRESP *rr);     // process received queries
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
    
    tgcbQuery,                          // query handler
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
    
static void logf(const char *fmt, ...); // write formatted string to LOG file

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

    
// If a remoteNodeName is specified on the command line, we will
// periodically send a message to it using tgSendf().
    
if (ac > 0 && av[1])
    sprintf(remoteNodeName, "%.*s", sizeof(remoteNodeName) - 1, av[1]);
    

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
//
// While we're waiting, if a remoteNodeName was specified on the
// command line, let's send it a query and display the results it
// gives back to us.

while (!kbhit())
    {
    DWORD       dResult;            // Return value from WaitForSingleObject
    
    // Wait whichever comes first: Exit event or 250 ms

    dResult = WaitForSingleObject(hMainExitEvent, 250);
    
    // Reset the win32 manual-reset event
    
    (void) ResetEvent(hMainExitEvent);
    
    // Branch to handle the cause for ending the wait

    switch (dResult)
        {
        // Time out period expired

        case    WAIT_TIMEOUT:;
            {
            // if we were told given name of the remote NODE,
            // we periodically make a query of that NODE.
            
            if (remoteNodeName[0])
                {
                TG_QUERY    tgquery;            // Return value from tgQueryf()
                char        buf[TG_BUFSIZE];    // Place to store reply from remote NODE
                time_t      t;                  // current time
                long        timeout = 1000;     // # of ms to wait for reply
                
                time(&t);                       // Get current time
                

                // Send a query to the remote node (MP).

                printf("-------------------------------------------\n");
                printf("Sending: '%s The time is %s'\n", remoteNodeName, ctime(&t));
                
                tgquery = tgQueryf(&Tg,             // TG handle
                            LCID_UNKNOWN,           // Use default LCID
                            remoteNodeName,         // Destination NODE name
                            buf,                    // Place to store response from remote NODE
                            sizeof(buf),            // Size of our response buffer
                            timeout,                // # of ms to wait for reply
                            "The time is %s",       // Format for the query
                                ctime(&t));         // Rest of string is the query
                                

                // If error print error message

                if (tgquery.tgerr)
                    printf("tgQueryf returned ERROR %d: %s\n", tgquery.tgerr, tgErr(tgquery.tgerr));
                else
                    {
                    // We got back a reply from the remote node, so print it
                    
                    printf("NODE '%s' returned:\n'%s'\n",
                        remoteNodeName,
                        buf);
                    }                

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
// tgcbQuery - An query from another NODE (or from ELSIE) was received.
// This callback function is where you would add your own responses to
// queries from your other NODES.
//
// A pointer to the query is given to this function in rr->rqst.
// The number of bytes in the query is strlen(rr->rqst).
//
// The buffer to store your response in is pointed to by rr->resp.
// The maximum number of bytes you can store is rr->nRespSize.
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
    time_t  t;
    char    *resp;

// Let's provide a standard reply regardless of what the query looks like.

time(&t);

resp = rr->resp;
resp += sprintf(resp, "Yes, %s, this is NODE %s at %s",
            rr->fromNodeName,
            myNodeName,
            ctime(&t));


// Print the query

printf("----------------------------------\n");
printf("%s requested: '%s'\n",
    rr->fromNodeName,
    rr->rqst);
    
printf("OUR REPLY: '%s'\n", rr->resp);


// Successfully processed.

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

// Branch to handle the state

switch (flag)
    {
    case TGSRVPARAM_STATE_INVITE:
    //-------------------------------
        {
        // Until this message is received, our NODE name is not assigned.
        // ELSIE uses this message to assign our NODE's name
        // (ie., from the NODE name specified in the .LC file).
        //
        // Here is how we learn what name we've been assigned to.
        
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

(void) FIOWriteStrToFilename(EXAMPLE_LOG, "%02u.%02u.%03u: %s",
    systime.wMinute,
    systime.wSecond,
    systime.wMilliseconds,
    buf);
    
}

