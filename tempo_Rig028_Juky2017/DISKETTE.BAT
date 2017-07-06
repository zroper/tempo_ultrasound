@echo off
REM DISKETTE.BAT - Create a bootable MS DOS diskette
REM
REM This batch file creates a bootable diskette for TEMPONET.
REM It must be run on a computer Windows 95 or Windows 98.
REM
REM It can be run in a DOS window or after booting to DOS mode.
REM
REM In some circumstances, you may have to set the WINBOOTDIR environment
REM variable to the Windows directory, if it is not already set.
REM 
REM For example:
REM
REM     SET WINBOOTDIR=C:\WINDOWS
REM     DISKETTE
REM
REM EDIT HISTORY
REM     16Sep03 sh  Initial edit
REM     18Sep03 sh  Add HIMEM.SYS

set ERROR=

echo ------------------------------------------------------------
echo DISKETTE - Creating a bootable DOS diskette ..
echo Note: This must be run on a computer with Windows 95/98/98se
ver
echo ------------------------------------------------------------

REM Check to see if the files we need are in the expected places.

if "%winbootdir%"==""                           goto NOWINBOOT

if not exist %winbootdir%\command.com           set ERROR=Missing file %winbootdir%\command.com       
if not exist %winbootdir%\emm386.exe            set ERROR=Missing file %winbootdir%\emm386.exe        
if not exist %winbootdir%\himem.sys             set ERROR=Missing file %winbootdir%\himem.sys
if not exist %winbootdir%\ramdrive.sys          set ERROR=Missing file %winbootdir%\ramdrive.sys      
if not exist %winbootdir%\command\mscdex.exe    set ERROR=Missing file %winbootdir%\command\mscdex.exe
if not exist %winbootdir%\command\edit.com      set ERROR=Missing file %winbootdir%\command\edit.com  
if not exist %winbootdir%\command\edit.hlp      set ERROR=Missing file %winbootdir%\command\edit.hlp  
if not exist %winbootdir%\command\chkdsk.exe    set ERROR=Missing file %winbootdir%\command\chkdsk.exe
if not exist %winbootdir%\command\mem.exe       set ERROR=Missing file %winbootdir%\command\mem.exe   
if not exist %winbootdir%\command\more.com      set ERROR=Missing file %winbootdir%\command\more.com  
if not "%ERROR%"=="" goto ERROR

echo Please insert a blank diskette into A: drive for reformatting.


echo WARNING: All files will be erased on the diskette!
echo .
echo Type CTRL-C to CANCEL reformatting diskette in A: drive ...
pause

%winbootdir%\command\format a: /s /v:temponet
if errorlevel 1 set ERROR=Error formatting A:
if errorlevel 1 goto ERROR

ver >a:\ver.txt

copy %winbootdir%\command.com               a:\
if errorlevel 1 set ERROR=Error copying %winbootdir%\command.com
if errorlevel 1 goto ERROR

copy %winbootdir%\emm386.exe                a:\
if errorlevel 1 set ERROR=Error copying %winbootdir%\emm386.exe
if errorlevel 1 goto ERROR

copy %winbootdir%\himem.sys                 a:\
if errorlevel 1 set ERROR=Error copying %winbootdir%\himem.sys 
if errorlevel 1 goto ERROR

copy %winbootdir%\ramdrive.sys              a:\
if errorlevel 1 set ERROR=Error copying %winbootdir%\ramdrive.sys
if errorlevel 1 goto ERROR

copy %winbootdir%\command\mscdex.exe        a:\
if errorlevel 1 set ERROR=Error copying %winbootdir%\command\mscdex.exe
if errorlevel 1 goto ERROR

copy %winbootdir%\command\edit.com          a:\
if errorlevel 1 set ERROR=Error copying %winbootdir%\command\edit.com
if errorlevel 1 goto ERROR

copy %winbootdir%\command\edit.hlp          a:\
if errorlevel 1 set ERROR=Error copying %winbootdir%\command\edit.hlp
if errorlevel 1 goto ERROR

copy %winbootdir%\command\chkdsk.exe        a:\
if errorlevel 1 set ERROR=Error copying %winbootdir%\command\chkdsk.exe
if errorlevel 1 goto ERROR

copy %winbootdir%\command\mem.exe           a:\
if errorlevel 1 set ERROR=Error copying %winbootdir%\command\mem.exe
if errorlevel 1 goto ERROR

copy %winbootdir%\command\more.com          a:\
if errorlevel 1 set ERROR=Error copying %winbootdir%\command\more.com
if errorlevel 1 goto ERROR

echo -------------------------------------------------
echo The diskette was created successfully.
echo -------------------------------------------------
goto EXIT

:NOWINBOOT
echo -------------------------------------------------
echo The WINBOOTDIR environment variable is not set.
echo This is typically set when running in a DOS COMMAND WINDOW
echo in Windows 95/98/98se. If you booted the computer in DOS mode,
echo set the WINBOOTDIR to the Windows directory and rerun DISKETTE.
echo For example:
echo .
echo    set winbootdir=c:\windows
echo    diskette
echo -------------------------------------------------
goto EXIT


:ERROR
echo -------------------------------------------------
echo ERROR - %ERROR%
echo .
echo WARNING: An error occurred creating the diskette.
echo The diskette may not be usable.
echo -------------------------------------------------
goto EXIT

:EXIT
