@echo off
REM DIAGNOSE.BAT - Unpacks Utility diskette and runs a diagnostic program.
REM The TEMPO Diagnostic is the default, if no other program is specified.
REM
REM Syntax:     DIAGNOSE [ program [args ..] ]
REM
REM
REM     1. boot the server computer with SERVER diskette
REM     2. insert DIAGNOSTIC diskette for that server into A:
REM     3. Type at the DOS prompt:
REM
REM             DIAGNOSE                    (default, runs TEMPO diagnostic)
REM
REM             DIAGNOSE BONG SEND          Send BONG messages to Client
REM             DIAGNOSE BONG RECV          Receive BONG messages from Client
REM             DIAGNOSE BONG STATUS        Display network status
REM             DIAGNOSE PCITEST            Display PCI board info
REM             DIAGNOSE T8255 ...          See T8255 help page
REM             DIAGNOSE DDX ...            See DDX help page
REM             DIAGNOSE %DIAGNOSTIC% ...   Run TEMPO diagnostic with switches
REM
REM
REM The actual TEMPO diagnostic program (V*.EXE) depends on which kernel is used.
REM This information is configured in the KSET.BAT file, which sets the
REM DIAGNOSE environment variable to the diagnostic EXE.
REM
REM You can add parameters to the DIAGNOSE command line.  The first parameter
REM is the name of the program.  Subsequent parameters are passed to the program.
REM For example, with the KPED kernel, you would use the VPED diagnostic:
REM
REM         DIAGNOSE VPED TEMPONET nomou
REM
REM ----------------------------------------------------------------------
REM 27Jan05 If the TEMPO Diagnostic Program CRASHES on a TEMPONET server:
REM
REM     The diagnostic program normally produces the TEMPONET.LOG file on the.
REM     RAM drive.  When the diagnostic program completes, this BAT file writes
REM     The TEMPONET.LOG file from the RAM drive to the A: (diskette) drive.
REM
REM     If the diagnostic program crashes the computer (ie due to a serious
REM     hardware failure), the TEMPONET.LOG results on the RAM drive are lost.
REM
REM     In this case, you can run
REM
REM             DIAGNOSE VPED TEMPONET -dA:
REM
REM     This tells the diagnostic program to write its results to the A:
REM     drive instead of using the RAM drive.  If/when the diagnostic program
REM     crashes the computer, the results up to that point will be preserved
REM     in the TEMPONET.LOG file on the A: drive.
REM
REM     Caveat: The diagnostic program has to open/append/close the LOG
REM     file on each time it writes to it (to avoid losing the results
REM     if the program crashes).  When run on the RAM drive or on a hard
REM     drive, this is fast enough.  But when saving the results with -dA: to a
REM     diskette, this causes the diagnostic program to take a LONG TIME
REM     TO RUN.
REM
REM     In general, as long as you hear the diskette drive buzzing,
REM     the diagnostic program is probably working OK.  If it stops buzzing and
REM     the diagnostic program is not asking you a question, it has
REM     probably crashed (leaving the results in the TEMPONET.LOG on the A: drive).
REM
REM     It can take an hour (or longer) to run the diagnostic program
REM     when using -dA: (instead of 60 seconds for the RAM/hard drive)!
REM     If a hard drive is available on the TEMPONET server, (ie the C:
REM     drive is the hard drive), then you can save the results to the
REM     hard drive instead of the A: diskette with:
REM
REM         DIAGNOSE VPED TEMPONET -dC:
REM         
REM     This is MUCH faster than saving to the A: drive.
REM        
REM
REM EDIT HISTORY
REM  27Jan05 sh Copy LOG file to A: drive only if it exists
REM  07Dec05 sh Major reworking to allow user to type args on DIAGNOSE command line
REM  13Dec05 sh Minor changes to documentation
REM ----------------------------------------------------------------------

REM We only need to call KSET.BAT if the DIAGNOSTIC environment
REM variable is not set.

if "%1" == "?" goto HELP
if "%1" == "help" goto HELP
if "%1" == "HELP" goto HELP
if "%1" == "Help" goto HELP

if "%DIAGNOSTIC%" == "" if exist KSET.BAT call KSET.BAT

REM We need to know the name of the TEMPO Diagnostic Program
REM It is the same name as the KERNEL but it starts with a V instead of K
REM ie: VPED is the diagnostic program for KPED

if "%DIAGNOSTIC%" == "" goto NOPROGRAM

REM Is the DIAGNOSTIC diskette already unzipped?
REM If the diagnostic program is present, then we don't unzip.
REM Also note that for TEMPO/Win Server, the user doesn't use
REM a diagnostic diskette and the diagnostic program should be
REM in the TEMPO directory.

if exist %DIAGNOSTIC%.EXE goto FOUNDIT



REM -------------------------------------------------------------------------
:ASK
echo Please insert the DIAGNOSTIC diskette for this server in the A: drive.
echo To EXIT, type CTRL-C.
echo For HELP, type CTRL-C to return to DOS prompt then type DIAGNOSE ?
pause

cls
echo Checking diskette..

if exist A:UTIL.ZIP goto COPYIT
if exist A:UTIL1.ZIP goto COPYIT
if exist A:UTIL2.ZIP goto COPYIT
if exist A:UTIL3.ZIP goto COPYIT
if exist A:UTIL4.ZIP goto COPYIT
if exist A:UTIL5.ZIP goto COPYIT
if exist A:UTIL6.ZIP goto COPYIT
if exist A:UTIL7.ZIP goto COPYIT
if exist A:UTIL8.ZIP goto COPYIT


echo Oops! The diskette does not contain UTIL*.ZIP
goto ASK



REM -------------------------------------------------------------------------
:COPYIT
echo Unpacking DIAGNOSTIC diskette..

pkunzip -d -o a:\*.zip

if exist %DIAGNOSTIC%.EXE goto FOUNDIT

echo Oops!  %DIAGNOSTIC%.EXE was not found on the DIAGNOSTIC diskette.
echo Please insert the correct DIAGNOSTIC diskette into A: and try again.
goto ASK



REM -------------------------------------------------------------------------
:FOUNDIT
REM The DIAGNOSTIC diskette is already unzipped or this is a TEMPO/Win server
REM
REM Determine DIAGLOG, the argument to the diagnostic program.
REM This is also used by the diagnostic program to name the LOG file.
REM Valid settings are:
REM
REM DIAGLOG=SERVER      (TEMPO/Win server)  (default)
REM DIAGLOG=TEMPONET    (TEMPONET server)
REM DIAGLOG=COBALTS     (COBALT server)
REM
REM If DIAGLOG isn't set, then we're on a TEMPO/Win server.
REM If it is set, then we're on a TEMPONET server

if "%DIAGLOGFILE%" == "" set DIAGLOGFILE=SERVER

REM START THE NETWORK JUST ONCE PER BOOT.  USE THE NET ENVIRONMENT VARIABLE
REM TO INDICATE THAT THE NETWORK HAS BEEN STARTED.

if "%NET%" == "yes" goto NETLOADED
    lh net start netbeui
    pause
    cls
    echo Network drivers loaded.
    set NET=yes
:NETLOADED
    
if "%MOUSE%"=="no" goto NOMOUSE
    lh mouse
    set MOUSE=no
:NOMOUSE
    

REM -------------------------------------------------------------------------
if "%1" == "" goto DEFAULT

echo Running %1 %2 %3 %4 %5 %6 %7 %8 %9 ...

%1 %2 %3 %4 %5 %6 %7 %8 %9
goto EXIT

    
    
    
REM -------------------------------------------------------------------------
:DEFAULT
echo For HELP, type CTRL-C to return to DOS prompt then type DIAGNOSE ?
echo To run another diagnostic program, you can type CTRL-C now and
echo run it from the DOS prompt.
echo .
echo To run the TEMPO diagnostic program %DIAGNOSTIC% %DIAGLOG%
pause
cls

echo Running TEMPO Diagnostic program for %DIAGLOG% ... 

%DIAGNOSTIC% %DIAGLOG% %1 %2 %3 %4 %5 %6 %7 %8 %9

echo -------------------------------------------------------------------------
echo copying %DIAGLOG%.LOG to A: drive ...
if not exist %DIAGLOG%.LOG The %DIAGLOG%.LOG file was not found.
if     exist %DIAGLOG%.LOG copy %DIAGLOG%.LOG A:
echo .
echo The %DIAGLOG%.LOG file contains the results of these tests.
echo Please email A:\%DIAGLOG%.LOG to Support@ReflectiveComputing.com for analysis.
echo -------------------------------------------------------------------------
goto EXIT



:HELP
cls
echo -------------------------------------------------------------------------
echo DIAGNOSE.BAT - Unpacks Utility diskette and runs a diagnostic program.
echo The TEMPO Diagnostic is the default, if no other program is specified.
echo .
echo SYNTAX:     DIAGNOSE [ program [args ..] ]
echo .
echo     DIAGNOSE                    (default, runs TEMPO diagnostic)
echo .
echo EXAMPLES:
echo     DIAGNOSE help               Display this help page
echo     DIAGNOSE ?                  Display this help page
echo     DIAGNOSE HELP               Display this help page
echo     DIAGNOSE BONG SEND          Send BONG messages to Client
echo     DIAGNOSE BONG RECV          Receive BONG messages from Client
echo     DIAGNOSE BONG STATUS        Display network status
echo     DIAGNOSE PCITEST            Display PCI board info
echo     DIAGNOSE T8255 ...          See T8255 help page
echo     DIAGNOSE DDX ...            See DDX help page
echo     DIAGNOSE %DIAGNOSTIC% %DIAGLOG% ...   Run TEMPO diagnostic with parameters
echo -------------------------------------------------------------------------
goto EXIT

:NOPROGRAM
echo -------------------------------------------------------------------------
echo DIAGNOSE.BAT - The DIAGNOSTIC environment variable is not defined.
echo .
echo KSET.BAT should set DIAGNOSTIC to the name of the TEMPO diagnostic program.
echo Your SERVER or DIAGNOSTIC diskette may not be prepared properly.
echo Please contact Reflective Computing for assistance.
echo -------------------------------------------------------------------------
goto EXIT

:EXIT
