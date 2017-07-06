/*  .title  EXAMPLE0.C - NODE that sends a message to ELSIE
;+
; SYNOPSIS
;   EXAMPLE0 [destNodeName]
;
; DESCRIPTION
;   This sample program illustrates a simple NODE that sends a message
;   to ELSIE using tgPrintf().  If a destNodeName is specified on the
;   command line, it also sends a message to that NODE.  The destNodeName
;   can be any node in a logical computation or it can be 'ELSIE'.
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
#include    <conio.h>                   // For getch()

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
    
    NULL,                               // Unknown query handler
    NULL,                               // Receive message from remote tgSendf
    
    NULL,                               // Status messages from TG
    NULL,                               // For TG debugging messages
    NULL                                // For Hyperstream and TG thread exceptions (including user's callback)
    };
    

//------------------------------------------------------------------------
//lint -esym(715, ac, av)   Not referenced

void
main(int ac, char *av[])
{
    TG          Tg;                 // A TG handle
    long        tgerr;              // A TG_xxx status
    TG_QUERY    tgquery;            // Return value from tgSendf
    

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


// Wait for user to press a key.

printf("Press ENTER key to send message to ELSIE..\n");
(void) getch();


// Send a message to the controller (ELSIE).

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
    // Wait for user to press a key.

    printf("Press ENTER key to send message to NODE '%s'..\n", av[1]);
    (void) getch();
    
    
    // Send message to the node.
    
    tgquery = tgSendf(&Tg,                  // TG
                      LCID_UNKNOWN,         // Use default Logical Computation ID
                      av[1],                // Destination NODE name
                      "Hello from NODE EXAMPLE0 tgSendf()\n");    // Message to send to NODE
    if (tgquery.tgerr)
        printf("tgSendf - ERROR %d: %s\n", tgquery.tgerr, tgErr(tgquery.tgerr));

    }


// Wait for key press to exit.

printf("Press ENTER key to exit..\n");
(void) getch();

EXIT:;
               


// Destroy this application's TG node.

tgerr = tgUninit(&Tg);
if (tgerr)
    {
    printf("tgUninit - ERROR %d: %s\n", tgerr, tgErr(tgerr));
    }
}


