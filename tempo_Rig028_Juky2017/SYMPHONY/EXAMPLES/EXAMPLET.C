/*  .title  EXAMPLET.C - Illustrate how a NODE sends a TEMPO command to TEMPO or COBALT
;+
; SYNOPSIS
;   EXAMPLET "tempocommand"
;
; DESCRIPTION
;   This sample program illustrates sending a TEMPO command to TEMPO or COBALT.
;
;   The command that is sent is specified on the NODE's command line.
;
; ACKNOWLEDGEMENTS
;   Thanks to Mike Page for his help in reviewing and clarifying this code.
;
; EDIT HISTORY
;   21Nov06 sh  Initial edit
;   28Nov06 sh  Add myprintf, TempoGetf
;   06Dec06 sh  All caller to pass label in xTempoRequestf
;               Add shutDown() code to clean up some things
;   17Feb07 sh  When we get BEFOREUNINVITE state, destroy our hotlinks with TEMPOW
;   07May07 sh  Expression strings sent to TEMPOW must now be enclosed in quotes
;-
*/
#include    <windows.h>
#include    <stdio.h>
#include    <io.h>                      // For _access
#include    <conio.h>                   // For getch()

#include    "fio.h"                     // Handy for file logging
#include    "tg.h"                      // Symphony TG functions
#include    "param.h"                   // Functions for manipulating parameter lists
#include    "sstempo.h"                 // Symphony Server definitions for talking to TEMPO/COBALT

#define EXAMPLE_LOG     "exampleT.log"  // Name of LOG file

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


static void tgcbMessage(const TG *hTg, const char *text);
static void tgcbLog(const TG *hTg, const char *text);
static void logf(const char *fmt, ...);             //lint -printf(1, logf)
static long tgcbState(const TG_RQSTRESP *rr, long flag);
static long tgcbRecv(const TG_RQSTRESP *rr);


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
    
    NULL,                               // tgcbQuery handler
    tgcbRecv,                           // tgcbRecv handler
    
    tgcbMessage,                        // Status messages from TG
    tgcbLog,                            // For TG debugging messages
    NULL                                // For Hyperstream and TG thread exceptions (including user's callback)
    };
    


//------------------------------------------------------------------------
// Other local variables

static char thisComputerName[MAX_COMPUTERNAME_LENGTH + 1];  // Name of this computer

static HANDLE  hMainExitEvent;          // A Win32 event flag our tgcbState() will signal to exit

static char myNodeName[TG_TGCMDSRV_NODENAMESIZE];   // The name ELSIE assigns to this NODE
static LCIDENT  myLCID;                 // LCID assigned to us by ELSIE
static long currentState = -1;          // Current LC state (see TG.H, TGSRVPARAM_STATE_BEGINLCINIT, etc)


//------------------------------------------------------------------------
// Local function prototypes

long TempoCommandf(const TG *Tg, long msTimeout, char *fmt, ...); //lint -printf(3,TempoCommandf)
long TempoGetLongf(const TG *Tg, long msTimeout, long *pValue, char *fmt, ...);   //lint -printf(4,TempoGetLongf)
long TempoGetf(const TG *Tg, long msTimeout, char *pValue, long nValue, char *fmt, ...);  //lint -printf(5,TempoGetf)
static void myprintf(const char *fmt, ...);                 //lint -printf(1, myprintf)
long xTempoRequestf(char *sstempoRequestType, const TG *Tg, long msTimeout, char *pValue, long nValue, char *fmt, ...);
                                                            //lint -printf(6, xTempoRequestf)

long TempoCreateHotLink(const TG *Tg, long msTimeout, char *pValue, long nValue, char *fmt, ...);
long TempoDestroyHotLink(const TG *Tg, long msTimeout, char *pValue, long nValue, char *fmt, ...);
                                                            //lint -printf(5, xTempoCreateHotLink)
                                                            //lint -printf(5, xTempoDestroyHotLink)
static void shutDown(const TG *tg);    

//------------------------------------------------------------------------
// MAIN - Entry point to console program

void
main(int ac, char *av[])
{
    TG          Tg;                     // A TG handle
    long        tgerr;                  // A TG_xxx status
    DWORD       nSize;
    char        *tempoCommand;          // TEMPO Command string pointer
    long        err;                    //
    long        value;                  // Value of a topic,item
    char        *expression;            // A TEMPO expression string
    char        szValue[128];           // A string value
    long        nDatabase;              // Database [1,2,..] to get information
    long        nEpoch;                 // Epoch number [1,2..] to retrieve
    char        *szConnection;          // connectName or connectID as a string
    char        szRequest[1024];        // A temporary buffer

ac = ac;                                // Not used    

printf("EXAMPLET must be run by ELSIE, not from the command line.\n");

// Open a log file

nSize = sizeof(thisComputerName);
(void) GetComputerName(thisComputerName, &nSize);  // Get name of this computer
    
if (_access(EXAMPLE_LOG, 0) == 0)
    remove(EXAMPLE_LOG);                // Delete previous log file
    
myprintf("%s - Opened LOG file '%s' on COMPUTER '%s'\n",
    av[0],
    EXAMPLE_LOG,
    thisComputerName);

    
// The main thread will wait on the hMainExitEvent 

hMainExitEvent = CreateEvent(NULL,      // no security
                TRUE,                   // is event manual-reset?
                FALSE,                  // is event initially signaled?
                NULL);                  // event name
if (!hMainExitEvent)
    {
    myprintf("ERROR creating hMainExitEvent win32 event.\n");
    return;
    }


// Create the TG node used by this application

tgerr = tgInit(&Tg,                     // TG handle
               NULL,                    // our node name (let ELSIE assign it)
               0,                       // Our server port (let TG assign it)
               &Tgcb,                   // Our TG callback table
               0,                       // our user-defined value
               1);                      // Allow TG callbacks
if (tgerr)
    {
    myprintf("tgInit - ERROR %d: %s\n", tgerr, tgErr(tgerr));
    return;
    }

// Remember the command to process.

tempoCommand = av[1];

// We need to wait until ELSIE "invites" us into a computation
// before we can send messages to other nodes in that computation.
// ELSIE invites us into the computation by sending us the 
// TGSRVPARAM_STATE_BEGINLCINIT message, which assigns our NODE name
// and tells us the LCID that we are participating in.
// So let's wait for that to happen.

myprintf("Waiting for START ... Press the ESC key to abort.\n");

while (currentState < TGSRVPARAM_STATE_START)
    {
    Sleep(250);
    if (kbhit())                        // Did the user request abort?
        {
        myprintf("User aborted this NODE\n");
        goto QUIT;
        }
    }
    
myprintf("ELSIE assigned this NODE name '%s' LCID %I64u\n", 
    myNodeName,
    myLCID);


//------------------------------------------------------------------    
// Send a command to TEMPO

err = TempoCommandf(&Tg, 1000, "%s", tempoCommand);
if (err)
    myprintf("ERROR %d returned by Tempof(%s)\n", err, tempoCommand);
else
    myprintf("SUCCESS!  TEMPO executed the TEMPO command '%s'\n", tempoCommand);


//------------------------------------------------------------------    
// Get current the epoch count for a database

nDatabase = 7;                          // Database to epoch count to retrieve

sprintf(szRequest, "%s %d, %s", 
            SSTEMPO_REQUEST_GET_TOPIC_DB,
            nDatabase, 
            SSTEMPO_REQUEST_GET_DB_EPOCHCOUNT);
    
err = TempoGetLongf(&Tg, 1000, &value, "mylabel=%s", szRequest);
if (err)
    myprintf("ERROR %d from TempoGetLongf(%s)\n", err, szRequest);
else
    myprintf("SUCCESS! %d = %s\n", value, szRequest);
    

//------------------------------------------------------------------    
// Get current the epoch count for a database

nDatabase = 8;                          // Database to epoch count to retrieve
    
sprintf(szRequest, "%s %d, %s", 
            SSTEMPO_REQUEST_GET_TOPIC_DB,
            nDatabase, 
            SSTEMPO_REQUEST_GET_DB_EPOCHCOUNT);
            
err = TempoGetLongf(&Tg, 1000, &value, "mylabel=%s", szRequest);
if (err)
    myprintf("ERROR %d from TempoGetLongf(%s)\n", err, szRequest);
else
    myprintf("SUCCESS!  %d = %s\n", value, szRequest);
    

//------------------------------------------------------------------    
// Get current the database TITLE

nDatabase = 8;                          // Database to epoch count to retrieve

sprintf(szRequest, "%s %d, %s", 
            SSTEMPO_REQUEST_GET_TOPIC_DB,
            nDatabase, 
            SSTEMPO_REQUEST_GET_DB_TITLE);
    
err = TempoGetf(&Tg, 1000, szValue, sizeof(szValue), "mylabel=%s", szRequest);
if (err)
    myprintf("ERROR %d from TempoGetLongf(%s)=%s\n", err, szRequest, szValue);
else
    myprintf("SUCCESS!  %s = %s\n", szValue, szRequest);
    

//------------------------------------------------------------------    
// Get current the database FILENAME

nDatabase = 8;                          // Database to epoch count to retrieve
    
err = TempoGetf(&Tg, 1000, szValue, sizeof(szValue), "mylabel=%s %d, %s",
            SSTEMPO_REQUEST_GET_TOPIC_DB,
            nDatabase, 
            SSTEMPO_REQUEST_GET_DB_FILENAME);
if (err)
    myprintf("ERROR %d from TempoGetLongf(%s)=%s\n", err, szRequest, szValue);
else
    myprintf("SUCCESS!  %s = %s\n", szValue, szRequest);
    

//------------------------------------------------------------------    
// Get value of a TEMPO expression

expression = "juice_time + 7";

err = TempoGetf(&Tg, 1000, szValue, sizeof(szValue), "mylabel=%s,'%s'",
            SSTEMPO_REQUEST_GET_TOPIC_EXPRESSION,
            expression);
if (err)
    myprintf("ERROR %d: %s=%s\n", err, expression, szValue);
else
    myprintf("SUCCESS!  %s=%s\n", expression, szValue);
    


//------------------------------------------------------------------    
// Send a command to TEMPO to START clock

tempoCommand = "START";
err = TempoCommandf(&Tg, 1000, "%s", tempoCommand);
if (err)
    myprintf("ERROR %d returned by Tempof(%s)\n", err, tempoCommand);
else
    myprintf("SUCCESS!  TEMPO executed the TEMPO command 'mylabel=%s'\n", tempoCommand);


//------------------------------------------------------------------    
// Get current state of TEMPO's CLOCK

sprintf(szRequest, "%s, %s", 
                SSTEMPO_REQUEST_GET_TOPIC_SYSINFO,
                SSTEMPO_REQUEST_GET_SYSINFO_CLOCK);

err = TempoGetf(&Tg, 1000, szValue, sizeof(szValue), "mylabel=%s", szRequest);
if (err)
    myprintf("ERROR %d: %s = %s\n", err, szValue, szRequest);
else
    myprintf("SUCCESS!  %s = %s\n", szValue, szRequest);


//------------------------------------------------------------------    
// Now a command to TEMPO to STOP clock

tempoCommand = "STOP";

err = TempoCommandf(&Tg, 1000, "%s", tempoCommand);
if (err)
    myprintf("ERROR %d returned by Tempof(%s)\n", err, tempoCommand);
else
    myprintf("SUCCESS!  TEMPO executed the TEMPO command '%s'\n", tempoCommand);


//------------------------------------------------------------------    
// Get current state of TEMPO's CLOCK

sprintf(szRequest, "%s, %s", 
                SSTEMPO_REQUEST_GET_TOPIC_SYSINFO,
                SSTEMPO_REQUEST_GET_SYSINFO_CLOCK);

err = TempoGetf(&Tg, 1000, szValue, sizeof(szValue), "mylabel=%s", szRequest);
if (err)
    myprintf("ERROR %d: %s = %s\n", err, szValue, szRequest);
else
    myprintf("SUCCESS!  %s = %s\n", szValue, szRequest);

myprintf("\n");


//------------------------------------------------------------------    
// Tell TEMPO to download the latest epoch from DB 10 to NODE Receiver's connection

nDatabase = 10;                          // Database to epoch count to retrieve
nEpoch = 0;                              // Get latest epoch
szConnection = "pipe1";                  // connectName or connectID

sprintf(szRequest, "%s %d, %s %s",
            SSTEMPO_REQUEST_GET_TOPIC_DB,
            nDatabase, 
            SSTEMPO_REQUEST_GET_DB_EPOCHDATA,
            szConnection);
    
err = TempoGetf(&Tg, 1000, szValue, sizeof(szValue), "mylabel=%s", szRequest);
if (err)
    {
    myprintf("ERROR %d %s = %s\n", err, szValue, szRequest);
    myprintf("NOTE It is possible that DB %d epoch %d doesn't exist so this is not a fatal error\n", nDatabase, nEpoch);
    }
else
    myprintf("SUCCESS!  %s = %s\n", szValue, szRequest);
    

//------------------------------------------------------------------    
// Tell TEMPO to download DB1 epoch 3 to NODE Receiver's connection

nDatabase = 1;                          // Database to epoch count to retrieve
nEpoch = 3;
szConnection = "pipe1";                  // connectName or connectID

sprintf(szRequest, "%s %d, %s %s %d", 
            SSTEMPO_REQUEST_GET_TOPIC_DB,
            nDatabase, 
            SSTEMPO_REQUEST_GET_DB_EPOCHDATA,
            szConnection,
            nEpoch);
    
err = TempoGetf(&Tg, 1000, szValue, sizeof(szValue), "mylabel=%s", szRequest);
if (err)
    {
    myprintf("ERROR %d %s = %s\n", err, szValue, szRequest);
    myprintf("NOTE It is possible that DB %d epoch %d doesn't exist so this is not a fatal error\n", nDatabase, nEpoch);
    }
else
    myprintf("SUCCESS!  %s = %s\n", szValue, szRequest);
    

//------------------------------------------------------------------    
// Send a command to TEMPO

tempoCommand = "cload acquire; start";

err = TempoCommandf(&Tg, 5000, "%s", tempoCommand);
if (err)
    myprintf("ERROR %d returned by Tempof(%s)\n", err, tempoCommand);
else
    myprintf("SUCCESS!  TEMPO executed the TEMPO command '%s'\n", tempoCommand);


//------------------------------------------------------------------    
// Create a HOT LINK

nDatabase = 10;

sprintf(szRequest, "%s %d, %s", 
            SSTEMPO_REQUEST_GET_TOPIC_DB,
            nDatabase,
            SSTEMPO_REQUEST_GET_DB_EPOCHCOUNT);

err = TempoCreateHotLink(&Tg, 1000, szValue, sizeof(szValue), "hot1=%s", szRequest);
if (err)
    myprintf("ERROR %d %s = %s\n", err, szValue, szRequest);
else
    myprintf("SUCCESS!  %s = %s\n", szValue, szRequest);


//------------------------------------------------------------------    
// Create a HOT LINK
// This will delete the previous HOTLINK because we use the same label!
// So there will only be one HOTLINK to this label.

nDatabase = 1;

sprintf(szRequest, "%s %d, %s", 
            SSTEMPO_REQUEST_GET_TOPIC_DB,
            nDatabase,
            SSTEMPO_REQUEST_GET_DB_EPOCHCOUNT);

err = TempoCreateHotLink(&Tg, 1000, szValue, sizeof(szValue), "hot2=%s", szRequest);
if (err)
    myprintf("ERROR %d %s = %s\n", err, szValue, szRequest);
else
    myprintf("SUCCESS!  %s = %s\n", szValue, szRequest);



//------------------------------------------------------------------    
// Wait for a key press to terminate.  This gives the user
// a chance to look at the results on the screen before we exit.

myprintf("Press ESC in ELSIE to terminate the computation.\n");

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
            continue;               // Don't quit yet but check keyboard


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

QUIT:;

shutDown(&Tg);                      // Perform clean up
    
//-------------------------------    
// Handle exiting the program by destroying this application's TG node (MP).

tgerr = tgUninit(&Tg);
if (tgerr)
    {
    myprintf("tgUninit - ERROR %d: %s\n", tgerr, tgErr(tgerr));
    }
    
// Return from main()
}




//------------------------------------------------------------------    
// shutDown - Perform clean up of various things before we exit
//
// This is called from main() if the user aborts the program (by typing ESC key).
//
// It is also called from tgcbState() when we receive a UNINVITE.
// We recevie this message from ELSIE when it starts to shut down the computation.
//
// Note that when it is called from main(), shutDown() executes in the context
// of the primary thread.   When it is called from tgcbState(), shutDown() is
// executing in the context of the TG CMD SRV's thread!
//
// Here are the things we do:
//
//      Destroy the HOT1 hot link.
//      Stop TEMPO's clock
//
// Note, we deliberatly leave label HOT2 undestroyed.  When TEMPOW receives
// the UNINVITE state message from ELSIE, TEMPOW will will automatically
// destroy it.  You can verify this by typing the SS SHOW command into TEMPOW's
// command line after ELSIE has terminated this computation to verify that HOT2
// has in fact been destroyed.
//
//
// IN
//          tg          TG* pointer
//
// OUT
//          nothing


static void
shutDown(const TG *tg)
{
    static long     firstTime = 1;
    long            err;
    char            szRequest[128];     // Our request
    char            szValue[128];       // Response to our request
    
if (!firstTime)                         // Do only once
    return;                             // This has already been done
firstTime = 0;    
    
//-------------------------------    
// Destroy HOT LINK
// HOT LINKS are destroyed based on their label.
// It is not necessary to specify the item; it will be ignored by TEMPOW and COBALT

sprintf(szRequest, "hot1");             // All we need to specify is the label

err = TempoDestroyHotLink(tg, 1000, szValue, sizeof(szValue), szRequest);
if (err)
    myprintf("ERROR %d %s = %s\n", err, szValue, szRequest);
else
    myprintf("SUCCESS!  %s = %s\n", szValue, szRequest);


//-------------------------------    
// STOP TEMPO's clock

sprintf(szRequest, "stop");
err = TempoCommandf(tg, 5000, "%s", szRequest);
if (err)
    myprintf("ERROR %d returned by Tempof(%s)\n", err, szRequest);
else
    myprintf("SUCCESS!  TEMPO executed the TEMPO command '%s'\n", szRequest);
    
}



//------------------------------------
// tgcbState - This function is called by TG when ELSIE changes the SS state.
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

currentState = flag;                    // Remember current state

// Branch to handle the state

switch (flag)
    {
    //-------------------------------
    case TGSRVPARAM_STATE_INVITE:
        {
        // Until this message is received, our NODE name is not assigned.
        // ELSIE uses the INVITE message to assign our NODE's name
        // (ie., from the NODE name specified in the .LC file).
        //
        // Here is how we learn what name we've been assigned to.
        // It is also at this point when ELSIE has "invited" us into the computation.
        
        (void) tgGetInfo(&rr->hTG, TGGI_GETMYNODENAME, myNodeName, sizeof(myNodeName));
        myLCID = rr->fromLCID;                      // LCID 
        
        myprintf("STATE INVITE: Our Node is '%s' LCID %I64u\n",
            myNodeName, myLCID);
        
        break;
        }
        
        
    //-------------------------------
    case TGSRVPARAM_STATE_START:
        {
        break;
        }
        

    //-------------------------------
    case TGSRVPARAM_STATE_STOP:
        {
        break;
        }
        

    //-------------------------------
    case TGSRVPARAM_STATE_BEFOREUNINIT:
        {
        // ELSIE is telling us that the computation is about to be over and it
        // will shut down the computation.  Let's destroy the hotlinks
        // that we created with TEMPOW.
        //
        // We want to do this before TEMPOW gets the UNINVITE
        // state message because it will refuse to talk to us after
        // that point (because the computation no longer exists).
        
        shutDown(&rr->hTG);
        
        break;
        }
        
    
    //-------------------------------
    case TGSRVPARAM_STATE_UNINVITE:
        {
        // Here is were we are removed from the computation.
        // We don't need to do anything except to wait for the EXIT state message.
        // The assumption here is that we've already received the BEFOREUNINIT
        // state which allowed us to destroy our hotlinks with TEMPOW.
         
        break;
        }
    
    
    //-------------------------------
    case TGSRVPARAM_STATE_EXIT:
        {
        // We can receive the UNINVITE or the EXIT state messages as ways to
        // tell us the computation is over.
        
        Sleep(100);                     // Give thread a chance to exit
        
        // Here is were we tell our MAIN thread to stop processing.
        
        SetEvent(hMainExitEvent);       // Tell main program we're quitting
        break;
        }
    
    
    //-------------------------------
    default:
        {
        // This is not an error.  It just means that we received
        // a state message that we didn't provide a case for.
        // It is not necessary that we process every state message - 
        // just the ones that we need to do our task.
        
        myprintf("NODE %s: STATE %d RECEIVED AND IGNORED.\n", myNodeName, flag);
        
        return(0);
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
// myprintf - Write a formatted message to stdout and to log
//
// IN
//      fmt             format specification (see printf)
//      ..              optional additional arguments
//
// OUT
//      nothing

static void
myprintf(const char *fmt, ...)
{
    long            n;                  // # bytes in buffer (including NULL)
    va_list         arg_ptr;            // for formatting
    char            buf[2048];
    

// Expand the format string and variable arguments into a string.

va_start(arg_ptr, fmt);
n = _vsnprintf(buf, sizeof(buf) - 1, fmt, arg_ptr);   // Important to use n-1!
va_end(arg_ptr);

if (n < 0 || n >= (long) sizeof(buf))
    n = sizeof(buf) - 1;
buf[n] = 0;                             // Guarantee NULL terminated

printf("%s", buf);
logf("%s", buf);
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



//------------------------------------------------------------------------
// tgcbRecv - Receive messages from other NODES.
// In particular, we expect messages from TEMPOW whenever a HOT LINK changes

static long
tgcbRecv(const TG_RQSTRESP *rr)
{
printf("--------------------------------\n");
printf("tgcbRecv %s: %s\n", rr->fromNodeName, rr->rqst);
printf("--------------------------------\n");
return(0);
}



//------------------------------------------------------------------------
// TempoCommandf - Execute a TEMPO command
//
// The fmt, ... specifies the TEMPO command to be executed.
//
//
// IN
//      Tg              Pointer to TG handle
//      msTimeout       timeout in ms
//      fmt, ...        Format string for TEMPO command
//
// OUT
//       0              Successful
//      -1              Error communicating with TEMPO
//      -2              TEMPO failed to understand our request
//      -3              TEMPO encountered a problem processing the command

long
TempoCommandf(const TG *Tg, long msTimeout, char *fmt, ...)
{
    TG_QUERY        tgquery;            // result from tgQueryf
    ULONG           seqNumber = 0;      // Our sequence number
    va_list         arg_ptr;            // for formatting
    char            tempoCommand[1024]; // TEMPO command to process
    char            response[1024];     // Response from TEMPO 
    long            n;                  // Length of TEMPO command
    char            label[64];          // Label we use to identify our request
    long            paramerr;           // A PARAM_xxx status
    char            value[256];         // TEMPO's response
    long            nFields;            // # of fields in TEMPO's response
    long            nValue;             // TEMPO's value for item
    long            nStatus;            // TEMPO's status code
    char            szText[256];        // TEMPO's text field

memset(tempoCommand, 0, sizeof(tempoCommand));

va_start(arg_ptr, fmt);
n = _vsnprintf(tempoCommand, sizeof(tempoCommand) - 1, fmt, arg_ptr);
va_end(arg_ptr);

// Guarantee NULL termination, which vsnprintf doesn't!

if (n < 0)
    n = sizeof(tempoCommand) - 1;
tempoCommand[n] = 0;

// Create a label that we use to identify this request

sprintf(label, "%s%u", myNodeName, seqNumber);


// Now send off our command

tgquery = tgQueryf(Tg,                  // TG handle
            LCID_UNKNOWN,               // Use default LCID
            SSTEMPO_NODENAME,           // Or SSCOBALT_NODENAME for COBALT
            response,                   // Place to put response
            sizeof(response),           // # of bytes in response buffer
            msTimeout,                  // Timeout in ms
            SSTEMPO_REQUEST "=" SSTEMPO_REQUEST_COMMAND "\n"
                "%s=%s\n",
                label, 
                tempoCommand); 

if (tgquery.tgerr)
    {
    myprintf("TempoCommandf - ERROR %d sending TEMPO command: %s\n", 
        tgquery.tgerr, tgErr(tgquery.tgerr));

    return(-1);                         // Communication failure
    }

// TEMPO got the request, processed it and returned its results to us
// without any problems.
// So now, we have a response from TEMPO.
// Let's check if TEMPO had any problems processing the request.

// TEMPO should have returned "label=#,#,text" in the response parameter list.
// If our label isn't there, then we didn't form our request properly.

// TEMPO got the request, processed it and returned its results to us
// without any problems.
// So now, we have a response from TEMPO.

paramerr = paramGetString(response, value, sizeof(value), "%s", label);
if (paramerr)
    {
    myprintf("xTempoCommandf - ERROR %d TEMPO failed to understand our request: %s\n",
        paramerr, paramErr(paramerr));
    myprintf("xTempoRequestf - '%s'\n", response);
    return(-2);                         // TEMPO failed to understand our request
    }
    
logf("xTempoCommandf - TEMPO Returned '%s=%s\n", label, value);
    
// Now we check if TEMPO had any problems processing the request.
//
// For each item, TEMPO returns:
//
//          #value , #status , text
//
// If the status is < 0, then TEMPO had a problem.

nFields = sscanf(value, " %d , %d , %s ",
                    &nValue,
                    &nStatus,
                    szText);

// Did TEMPO encounter an error processing the request?

if (nFields != 3 || nStatus < 0)        // Check status of request
    {
    return(-3);                         // Yes, TEMPO encountered and error processing the request
    }
        
            
return(0);                              // Successful execution
}



//------------------------------------------------------------------------
// TempoGetLongf - Get the value of a TEMPO object
// The object must be formatted in a string as follows:
//
//      label = topic , item
//
// For example, to get the current number of epochs in database nDb:
//
//      long    value;                  // Value of item
//      int     nDb = 1;                // Database to retrieve [1,2, ..]
//      TempoGetf(&Tg, 1000, &value, "db %d,epochcount", nDb);
//
// IN
//      Tg          A TG* pointer
//      msTimeout   Timeout value in ms
//      pValue      NULL or pointer to place to store topic,item value
//      fmt         Format string for topic,item
//
// OUT
//       0          Success - value is stored in pValue
//      -1          Communication failure talking to TEMPO
//      -2          TEMPO failed to understand our request

long
TempoGetLongf(const TG *Tg, long msTimeout, long *pValue, char *fmt, ...)
{
    va_list         arg_ptr;            // for formatting
    long            n;                  // Length of TEMPO command
    long            err;
    char            labelTopicItem[128];
    char            szValue[128];
    
if (pValue)
    *pValue = 0;                        // Start with clean slate
    
memset(labelTopicItem, 0, sizeof(labelTopicItem));

va_start(arg_ptr, fmt);
n = _vsnprintf(labelTopicItem, sizeof(labelTopicItem) - 1, fmt, arg_ptr);
va_end(arg_ptr);

// Guarantee NULL termination, which vsnprintf doesn't!

if (n < 0)
    n = sizeof(labelTopicItem) - 1;
labelTopicItem[n] = 0;


// Now send off our command

err = TempoGetf(Tg, msTimeout, szValue, sizeof(szValue), "%s", labelTopicItem);
if (err)
    {
    logf("TempoGetLongf - ERROR %d sending TEMPO GET request for '%s'\n", err, labelTopicItem);
    return(err);                         // Communication failure
    }

if (pValue)
    {
    long        value;
    char        *end;
    
    value = strtol(szValue, &end, 10);  // Convert string to long value
    
    *pValue = value;                    // Return value to caller
    }
            
return(0);                              // Successful execution
}


//------------------------------------------------------------------------
// TempoGetf - Get the string value of a TEMPO object
// The object must be formatted in a string as follows:
//
//      label = topic , item
//
// For example, to get the current number of epochs in database nDb:
//
//      long    value;                  // Value of item
//      int     nDb = 1;                // Database to retrieve [1,2, ..]
//      TempoGetf(&Tg, 1000, &value, "db %d,epochcount", nDb);
//
// IN
//      Tg          A TG* pointer
//      msTimeout   Timeout value in ms
//      pValue      NULL or pointer to place to store topic,item value
//      nValue      0 or # of bytes in pvalue
//      fmt         Format string for topic,item
//
// OUT
//       0          Success - value is stored in pValue
//      -1          Communication failure talking to TEMPO
//      -2          We failed to form our request properly; TEMPO failed to understand it
//      -3          Our request was formed correctly but TEMPO had an error processing it

long
TempoGetf(const TG *Tg, long msTimeout, char *pValue, long nValue, char *fmt, ...)
{
    va_list         arg_ptr;            // for formatting
    char            buf[1024];
    long            n;

if (pValue && nValue > 0)
    *pValue = 0;                        // Start with clean slate

memset(buf, 0, sizeof(buf));

va_start(arg_ptr, fmt);
n = _vsnprintf(buf, sizeof(buf) - 1, fmt, arg_ptr);
va_end(arg_ptr);

// Guarantee NULL termination, which vsnprintf doesn't!

if (n < 0)
    n = sizeof(buf) - 1;
buf[n] = 0;

return(xTempoRequestf(SSTEMPO_REQUEST_GET, Tg, msTimeout, pValue, nValue, "%s", buf));
}



//------------------------------------------------------------------------
// TempoCreateHotLink - Create a Hot Link to TEMPO
// The object must be formatted in a string as follows:
//
//      label = topic , item
//
// For example, to get the current number of epochs in database nDb:
//
//      long    value;                  // Value of item
//      int     nDb = 1;                // Database to retrieve [1,2, ..]
//      TempoCreateHotLinkf(&Tg, 1000, &value, "db %d,epochcount", nDb);
//
// IN
//      Tg          A TG* pointer
//      msTimeout   Timeout value in ms
//      pValue      NULL or pointer to place to store topic,item value
//      nValue      0 or # of bytes in pvalue
//      fmt         Format string for topic,item
//
// OUT
//       0          Success - value is stored in pValue
//      -1          Communication failure talking to TEMPO
//      -2          We failed to form our request properly; TEMPO failed to understand it
//      -3          Our request was formed correctly but TEMPO had an error processing it

long
TempoCreateHotLink(const TG *Tg, long msTimeout, char *pValue, long nValue, char *fmt, ...)
{
    va_list         arg_ptr;            // for formatting
    char            buf[1024];
    long            n;

if (pValue && nValue > 0)
    *pValue = 0;                        // Start with clean slate

memset(buf, 0, sizeof(buf));

va_start(arg_ptr, fmt);
n = _vsnprintf(buf, sizeof(buf) - 1, fmt, arg_ptr);
va_end(arg_ptr);

// Guarantee NULL termination, which vsnprintf doesn't!

if (n < 0)
    n = sizeof(buf) - 1;
buf[n] = 0;

return(xTempoRequestf(SSTEMPO_REQUEST_CREATEHOTLINK, Tg, msTimeout, pValue, nValue, "%s", buf));
}



//------------------------------------------------------------------------
// TempoDestroyHotLink - Destroy a Hot Link on TEMPO
// The object must be formatted in a string as follows:
//
//      label [= topic , item]
//
// For example, to get the current number of epochs in database nDb:
//
//      long    value;                  // Value of item
//      int     nDb = 1;                // Database to retrieve [1,2, ..]
//      TempoDestroyHotLinkf(&Tg, 1000, &value, "db %d,epochcount", nDb);
//
// IN
//      Tg          A TG* pointer
//      msTimeout   Timeout value in ms
//      pValue      NULL or pointer to place to store topic,item value
//      nValue      0 or # of bytes in pvalue
//      fmt         Format string for topic,item
//
// OUT
//       0          Success - value is stored in pValue
//      -1          Communication failure talking to TEMPO
//      -2          We failed to form our request properly; TEMPO failed to understand it
//      -3          Our request was formed correctly but TEMPO had an error processing it
long
TempoDestroyHotLink(const TG *Tg, long msTimeout, char *pValue, long nValue, char *fmt, ...)
{
    va_list         arg_ptr;            // for formatting
    char            buf[1024];
    long            n;

if (pValue && nValue > 0)
    *pValue = 0;                        // Start with clean slate

memset(buf, 0, sizeof(buf));

va_start(arg_ptr, fmt);
n = _vsnprintf(buf, sizeof(buf) - 1, fmt, arg_ptr);
va_end(arg_ptr);

// Guarantee NULL termination, which vsnprintf doesn't!

if (n < 0)
    n = sizeof(buf) - 1;
buf[n] = 0;

return(xTempoRequestf(SSTEMPO_REQUEST_DESTROYHOTLINK, Tg, msTimeout, pValue, nValue, "%s", buf));
}



//------------------------------------------------------------------------
// xTempoRequestf - Function used to send TEMPO a GET, CREATEHOTITEM or DESTROYHOTITEM request
//
// Formatted request should have the form:
//
//          label [= topic , item ]
//
// IN
//      sstempoRequestType  An SSTEMPO_REQUEST_xxx
//      Tg                  TG* pointer
//      msTimeout           0=infinite, timeout in ms to wait for response
//      pValue              NULL or Buffer to store TEMPO's response
//                              The pValue[] buffer contains TEMPO's response
//                              to the first label in the request (i.e., the
//                              text following "label=".)
//      nValue              0 or Max # of bytes in buffer
//      fmt, ...            Formatted request
//
// OUT
//       0          Successful
//      -1          Communication failure (a TG error was returned)
//      -2          TEMPO failed to understand request
//      -3          TEMPO encountered an error processing the request
//      -4          Missing label in request

long
xTempoRequestf(char *sstempoRequestType, const TG *Tg, long msTimeout, char *pValue, long nValue, char *fmt, ...)
{
    TG_QUERY        tgquery;            // result from tgQueryf
    va_list         arg_ptr;            // for formatting
    char            buf[1024];          // Caller's topic,item string
    char            response[1024];     // Response from TEMPO 
    long            n;                  // Length of TEMPO command
    long            paramerr;           // A PARAM_xxx status
    char            label[128];         // Caller's label
    
if (pValue && nValue > 0)
    *pValue = 0;                        // Start with clean slate

memset(buf, 0, sizeof(buf));

va_start(arg_ptr, fmt);
n = _vsnprintf(buf, sizeof(buf) - 1, fmt, arg_ptr);
va_end(arg_ptr);

// Guarantee NULL termination, which vsnprintf doesn't!

if (n < 0)
    n = sizeof(buf) - 1;
buf[n] = 0;

// Extract the label the caller is using so we can use it to
// parse TEMPO's response

paramerr = paramGetNext(buf, NULL, label, sizeof(label), NULL, 0);
if (paramerr)
    {
    myprintf("xTempoRequestf - Missing label in %s request %s\n", 
        sstempoRequestType,
        buf);
    return(-4);                         // Missing label
    }


// Now send off our command

tgquery = tgQueryf(Tg,                  // TG handle
            LCID_UNKNOWN,               // Use default LCID
            SSTEMPO_NODENAME,           // Or SSCOBALT_NODENAME for COBALT
            response,                   // Place to put response
            sizeof(response),           // # of bytes in response buffer
            msTimeout,                  // Timeout in ms
            SSTEMPO_REQUEST "=%s\n"     // Request line
                "%s\n",                 // label=.. line
                    sstempoRequestType, // type of request
                    buf);               // "LABEL=..."

if (tgquery.tgerr)
    {
    myprintf("xTempoRequestf - ERROR %d sending TEMPO command: %s\n", 
        tgquery.tgerr, tgErr(tgquery.tgerr));

    return(-1);                         // Communication failure
    }

// TEMPO got the request, processed it and returned its results to us
// without any problems.
// So now, we have a response from TEMPO.

if (pValue && nValue > 0)
    {
    long            nFields;            // # of fields in TEMPO's response
    long            nvalue;             // TEMPO's value
    long            nStatus;            // TEMPO's status
    char            szText[256];        // TEMPO's text field
    
    
    // TEMPO should have returned our label=# in the response parameter list.
    // If our label isn't there, then we didn't form our request properly.
    
    paramerr = paramGetString(response, pValue, nValue, "%s", label);
    if (paramerr)
        {
        myprintf("xTempoRequestf - ERROR %d TEMPO failed to understand our request: %s\n",
            paramerr, paramErr(paramerr));
        myprintf("xTempoRequestf - '%s'\n", response);
        return(-2);                         // TEMPO failed to understand our request
        }
        
    logf("xTempoRequestf - TEMPO Returned '%s=%s\n", label, pValue);
        
    // Now we check if TEMPO had any problems processing the request.
    //
    // For each item, TEMPO returns:
    //
    //          #value , #status , text
    //
    // If the status is < 0, then TEMPO had a problem.
    
    nFields = sscanf(pValue, " %d , %d , %s ",
                        &nvalue,
                        &nStatus,
                        szText);
    
    // Did TEMPO encounter an error processing the request?
    
    if (nFields != 3 || nStatus < 0)    // Check status of request
        {
        return(-3);                     // Yes, TEMPO encountered and error processing the request
        }
    }
            
return(0);                              // Successful execution
}


