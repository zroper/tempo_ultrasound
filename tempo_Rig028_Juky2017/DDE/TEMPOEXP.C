/*  .title  TEMPOEXP - Ask TEMPO to evaluate an expression
;+
; SYNOPSIS
;       TEMPOEXP "expression"
;
; DESCRIPTION
;   This little C program illustrates how to retrieve the value of
;   a TEMPO expression from TEMPO CLIENT's DDE server.
;
;   On the command line, you specify the TEMPO expression in double quotes.
;
;   This program does not perform much error checking; it is intended to
;   illustrate the basics on accessing TEMPO's DDE interface.
;
; NOTE
;   The DDEML interface works with both console applications like
;   this one as well as with Windows based applications such as
;   DDECLI.C.
;
; EDIT HISTORY
;   26Oct06 sh  Adapted from TEMPOCMD.C
;-
*/
#include    <windows.h>
#include    <stdio.h>

#include    "tempodde.h"                // TEMPO dde routines
#include    "ddeerr.h"                  // TEMPO dde error messages

static char *help[] = {
"ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿",
"³TEMPOEXP - Evaluate a TEMPO expression                               ³",
"³The TEMPO expresson is sent to TEMPOW via DDE for evaluation.        ³",
"ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´",
"³Usage: TEMPOEXP \"tempoExpression\"                                  ³",
"³                                                                     ³",
"³This program is intended to illustrate how to use TEMPO's DDE server ³",
"³                                                                     ³",
"³There is no return code.                                             ³",
"³                                                                     ³",
"³The TEMPOW.EXE client program must be running on this computer.      ³",
"³                                                                     ³",
"³Depending on the TEMPO expression, you may not need to enclose it    ³",
"³in double quotes but doing so avoids the DOS command line parser     ³",
"³changing it.                                                         ³",
"³                                                                     ³",
"ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄCopyright 2006 Reflective ComputingÄÙ",
0};


//--------------------------------------------------------------------
short
main(short ac, char *av[])
{
    DWORD   hInst = 0;                  // DDEML application instance
    HCONV   hConv = 0;                  // DDEML conversation for Topic COMMAND
    UINT    err;
    long    arg;                        // Index to a command line argument
    char    tempoExpression[512];       // TEMPO expression to evalute
    char    *p;
    HDDEDATA    hddedata;               // DDE return value (defined by win32)
    
if (ac <= 1)
    {
    char    **hlp;
    
    for (hlp = help; *hlp; hlp++)
        fprintf(stderr, "%s\n", *hlp);
    return(0);
    }
    
// BUILD TEMPO COMMAND FROM COMMAND LINE ARGUMENTS

for (arg = 1, p = tempoExpression; arg < ac; arg++)
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
     
hConv = TempoOpenConv(hInst, "TEMPO", "EXPR");
if (!hConv)
    {
    fprintf(stderr, "Failed to connect to Service TEMPO Topic EXPR\n");
    fprintf(stderr, "Make sure TEMPOW.EXE is running on this computer.\n");
    goto EXIT;
    }

hddedata = TempoGetItem(hInst, hConv, tempoExpression, CF_TEXT, DDE_TIMEOUT);
if (!hddedata)
    {
    printf("Error sending expression to TEMPO: '%s'\n",
        tempoExpression);
    
    fprintf(stderr, "TEMPO expression failed to evaluate correctly.\n");
    fprintf(stderr, "See TEMPOW's message window for information\n");
    fprintf(stderr, "Expression='%s'\n", tempoExpression);
    
    goto EXIT;
    }
else
    {
    char    *pdata;
    DWORD   len;                        // # of bytes of data in DDE object
    
    pdata = (char *) DdeAccessData(hddedata, &len);
    if (pdata)
        {
        // PARSE DATA AND STORE IN USER'S BUFFER

        printf("VALUE = %s\n", pdata);
        
        (void) DdeUnaccessData(hddedata);
        }
    else
        {
        fprintf(stderr, "Error accessing response from TEMPO.\n");
        }

    // WE MUST FREE THIS HANDLE

    (void) DdeFreeDataHandle(hddedata);
    }

EXIT:;

if (hConv)
    (void) TempoCloseConv(hConv);
    
if (hInst)
    (void) TempoUnInit(hInst);
return(0);
}
