/*  .title  EXAMPLE1.C - Illustrate tgcbLogf() and tgcbMessagef() callbacks
;+
; SYNOPSIS
;   EXAMPLE1 [destinationNodeName]
;
; DESCRIPTION
;   This sample program illustrates a simple NODE that sends a message
;   to ELSIE using tgPrintf().  If a destNodeName is specified on the
;   command line, it also sends a message to that NODE.  The destNodeName
;   can be any node in a logical computation or it can be 'ELSIE'.
;
;   The two TG logging functions are implemented, logf() and messagef().
;
;   When TG is having a problem, such as communicating with another NODE,
;   it will intermittently call the tgcbMessagef() function with a short,
;   one line message at a slow frequency, typically every 7-10 seconds.
;   These one line messages do not have a trailing newline ('\n') character.
;
;   Periodically, TG will call tgcbLogf() to send debugging messages to
;   your application.  These messages can generally be disregarded but
;   you may find them helpful when you have a problem with your application.
;
;   The tgcbLogf() and tgcbMessagef() callbacks are generally independent
;   of one another so you don't need to implement either one if you don't
;   want to.
;
;   We also show how to use the FIO functions to write text to a log file.
;   The FIO functions are particularly slow because they open, write and
;   close the file on each call.  The benefit is that if the program crashes,
;   the LOG file isn't open so all the results are saved.  (When a program
;   crashes, all open files are truncated to 0 bytes and all the data is
;   lost).  If you plan to write an extensive amount of text to a file,
;   it is recommended that you use fopen(), then write to the FILE id.
;   This will be much quicker than the FIO routines.
;
; ACKNOWLEDGEMENTS
;   Thanks to Mike Page for his help in reviewing and clarifying this code.
;
; EDIT HISTORY
;   26Oct06 sh  Initial edit
;-
*/
#include    <windows.h>
#include    <stdio.h>
#include    <io.h>                      // For _access
#include    <conio.h>                   // For getch()

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


static void tgcbMessage(const TG *hTg, const char *text);
static void tgcbLog(const TG *hTg, const char *text);
static void logf(const char *fmt, ...);             //lint -printf(1, logf)


TGCBFUNCTIONS Tgcb =
    {
    TG_VERSION, TG_SET, sizeof(TGCBFUNCTIONS),      // Required for all callback tables
    
    NULL,                               // Ask about HS SEND connection
    NULL,                               // Open HS SEND connection
    NULL,                               // Close HS SEND connection
    
    NULL,                               // Ask about HS RECV connection
    NULL,                               // Open HS RECV connection
    NULL,                               // Close HS RECV connection
    
    NULL,                               // Logical Computation state
    
    NULL,                               // query handler
    NULL,                               // message handler
    
    tgcbMessage,                        // Status messages from TG
    tgcbLog,                            // For TG debugging messages
    NULL                                // For Hyperstream and TG thread exceptions (including user's callback)
    };
    
//------------------------------------------------------------------------
// Other local variables

static char thisComputerName[MAX_COMPUTERNAME_LENGTH + 1];  // Name of this computer


//------------------------------------------------------------------------
void
main(int ac, char *av[])
{
    TG    Tg;                       // A TG handle
    long        tgerr;              // A TG_xxx status
    DWORD       nSize;
    TG_QUERY    tgquery;            // Return value from tgSendf/tgQueryf
    

// Open a log file

nSize = sizeof(thisComputerName);
(void) GetComputerName(thisComputerName, &nSize);  // Get name of this computer
    
if (_access(EXAMPLE_LOG, 0) == 0)
    remove(EXAMPLE_LOG);            // Delete previous log file
    
logf("%s - Opened LOG file '%s' on COMPUTER '%s'\n",
    av[0],
    EXAMPLE_LOG,
    thisComputerName);

    
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


// Wait for a key press to start

printf("Press ENTER key to send message to ELSIE using tgPrintf()..\n");
(void) getch();


// Send a message to the controller (ELSIE)

tgquery = tgSendf(&Tg, LCID_UNKNOWN, TGSRVNODENAME_ELSIE, "Hello, ELSIE from NODE EXAMPLE0 tgPrintf()\n");  // Send a message to the controller (ELSIE)
if (tgquery.tgerr)
    {
    printf("tgSendf - ERROR %d: %s\n", tgquery.tgerr, tgErr(tgquery.tgerr));
    goto EXIT;
    }
    
    
// If a NODE name was specified on the command line, we also send
// a message to that NODE.

if (ac > 1 && av[1])
    {
    // Send a message to the remote NODE

    printf("Press ENTER key to send message to NODE '%s' using tgSendf()..\n", av[1]);
    (void) getch();
    
    tgquery = tgSendf(&Tg,                          // TG
                     LCID_UNKNOWN,                  // Use default LCID
                     av[1],                         // Destination NODE name
                     "Hello from NODE EXAMPLE1\n"); // Message to send to NODE
    if (tgquery.tgerr)
        printf("tgSendf - ERROR %d: %s\n", tgquery.tgerr, tgErr(tgquery.tgerr));

    }
    

// Give user some instructions and wait for a key press.

printf("\nThank you.\n");

printf("Now, press the ESC key in ELSIE to exit ELSIE.\n");

printf("Once ELSIE has exited, Press ENTER key to exit this program.\n");

printf("\n");
printf("To learn how to get ELSIE to terminated a NODE, see EXAMPLE2.C\n");
(void) getch();

EXIT:;
               

// Handle exiting the program by destroying this application's TG node (MP).

tgerr = tgUninit(&Tg);
if (tgerr)
    {
    printf("tgUninit - ERROR %d: %s\n", tgerr, tgErr(tgerr));
    }
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

