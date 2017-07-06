/*  .title  TEMPOCMD - Send a TEMPO command to TEMPO for execution
;+
; SYNOPSIS
;       TEMPOCMD ...tempo command...
;
; DESCRIPTION
;   This little C program illustrates how to send a TEMPO command
;   to TEMPO's DDE server.
;
;   On the command line, you specify the TEMPO command.
;
;   This program does not perform much
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
;   04Dec02 sh  Improve HELP page.
;   30Mar04 sh  Display DDE error code and message when a failure occurs.
;-
*/
#include    <windows.h>
#include    <stdio.h>

#include    "tempodde.h"                // TEMPO dde routines
#include    "ddeerr.h"                  // TEMPO dde error messages

static char *help[] = {
"ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿",
"³TEMPOCMD - Execute a TEMPO comamnd.                                  ³",
"³The TEMPO command is sent to TEMPOW via DDE for execution.           ³",
"ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´",
"³Usage: TEMPOCMD \"tempoCommand\"                                       ³",
"³                                                                     ³",
"³This program is intended to illustrate how to use TEMPO's DDE server ³",
"³                                                                     ³",
"³There is no return code.                                             ³",
"³                                                                     ³",
"³The TEMPOW.EXE client program must be running on this computer.      ³",
"³                                                                     ³",
"³Depending on the TEMPO command, you may not need to enclose it       ³",
"³in double quotes but doing so avoids the DOS command line parser     ³",
"³changing it.                                                         ³",
"³                                                                     ³",
"ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄCopyright 2004 Reflective ComputingÄÙ",
0};


//--------------------------------------------------------------------
short
main(short ac, char *av[])
{
    DWORD   hInst = 0;                  // DDEML application instance
    HCONV   hConv = 0;                  // DDEML conversation for Topic COMMAND
    UINT    err;
    long    arg;                        // Index to a command line argument
    char    tempoCommand[512];          // TEMPO command to execute
    char    *p;
    long    ddeErr;                     // A DMLERR_xxx status
    
if (ac <= 1)
    {
    char    **hlp;
    
    for (hlp = help; *hlp; hlp++)
        fprintf(stderr, "%s\n", *hlp);
    return(0);
    }
    
// BUILD TEMPO COMMAND FROM COMMAND LINE ARGUMENTS

for (arg = 1, p = tempoCommand; arg < ac; arg++)
    {
    if (arg > 1)
        *p++ = ' ';                     // Separate args with space
    p += sprintf(p, "%s", av[arg]);
    }
    
// INITIALIZE DDEML AND GET INSTANCE

err = TempoInit(&hInst);                // Open DDEML application instance
if (err != DMLERR_NO_ERROR)
     {
     fprintf(stderr, "Failed to initialize TEMPO DDE client! %s", ddeerr(err));
     goto EXIT;
     }
     
hConv = TempoOpenConv(hInst, "TEMPO", "COMMAND");
if (!hConv)
    {
    fprintf(stderr, "Failed to connect to Service TEMPO Topic COMMAND\n");
    fprintf(stderr, "Make sure TEMPOW.EXE is running on this computer.\n");
    goto EXIT;
    }

ddeErr = TempoExecute(hInst, hConv, tempoCommand, DDE_TIMEOUT);
if (ddeErr)
    {
    printf("Error 0x%X sending command to TEMPO: '%s': %s\n", ddeErr, tempoCommand, ddeerr(ddeErr));
    
    fprintf(stderr, "TEMPO command failed to execute correctly.\n");
    fprintf(stderr, "See TEMPOW's message window for information\n");
    fprintf(stderr, "Command='%s'\n", tempoCommand);
    
    goto EXIT;
    }

EXIT:;

if (hConv)
    (void) TempoCloseConv(hConv);
    
if (hInst)
    (void) TempoUnInit(hInst);
return(0);
}
