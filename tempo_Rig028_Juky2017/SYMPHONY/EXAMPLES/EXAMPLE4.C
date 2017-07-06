/*  .title  EXAMPLE4.C - Simple example of LC control program
;+
; SYNOPSIS
;   example4
;
; DESCRIPTION
;   This sample program illustrates how to programmatically create a Logical
;   Computation, start a NODE, monitor it and stop it.
;
;
;
;   The TRIM.H string manipulation utilies are used to do some simple
;   parsing of strings.
;
;   The PARAM.H parameter list utilities are used to retrieve values
;   from a string formatted as a list of parameters.
;
; SEE ALSO
;   For a more elaborate example, see the source code to the ELSIE program.
;
; EDIT HISTORY
;   27Oct06 sh  Initial edit
;-
*/
#include    <windows.h>
#include    <stdio.h>

#include    "fio.h"                     // logging utilities
#include    "tg.h"                      // TEMPO Computational Graph api
#include    "lc.h"                      // LC api definitions

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
    
    NULL,                               // Logical Computation state
    
    NULL,                               // query handler
    tgcbRecv,                           // Receive message from remote tgSendf
    
    tgcbMessage,                        // Status messages from TG
    tgcbLog,                            // For TG debugging messages
    NULL                                // For Hyperstream and TG thread exceptions (including user's callback)
    };
    
//------------------------------------------------------------------------
// Other local variables and function prototypes

static char thisComputerName[MAX_COMPUTERNAME_LENGTH + 1];  // Name of this computer

static void logf(const char *fmt, ...); // write formatted string to LOG file



//---------------------------------------------------------------------
//lint -esym(715, ac, av)   Not referenced

void
main(int ac, char *av[])
{
    LC      Lc;                         // LC handle
    LCERR   lcerr;
    DWORD   nSize;

nSize = sizeof(thisComputerName);
(void) GetComputerName(thisComputerName, &nSize);  // Get name of this computer

lcerr = lcInit(&Lc, &Tgcb, 0, 1);
if (lcerr.lcerr)
    {
    printf("lcInit ERROR %d: %s\n", lcerr.lcerr, lcErr(lcerr.lcerr));
    return;
    }


lcerr = lcUninit(&Lc);
if (lcerr.lcerr)
    {
    printf("lcUninit ERROR %d: %s\n", lcerr.lcerr, lcErr(lcerr.lcerr));
    return;
    }


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
printf("tgcbRecv - from NODE %s: '%s'\n",
    rr->fromNodeName,
    rr->rqst);
    
logf("tgcbRecv - from NODE %s: '%s'\n",
    rr->fromNodeName,
    rr->rqst);
    
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



