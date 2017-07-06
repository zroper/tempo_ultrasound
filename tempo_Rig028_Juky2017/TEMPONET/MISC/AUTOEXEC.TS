@ECHO OFF
REM AUTOEXEC.BAT for SERVER
REM 20Dec02 (c) 2002 Reflective Computing
REM 17Nov04 Use pkunzip *.zip format
REM         If no MAKESYSI.BAT, bypass it
REM 20Dec04 Add COPYCMD setting to environment.

REM ------------------------------------------------------
REM Set environment variables

set COPYCMD=/Y

REM ------------------------------------------------------
REM SET UP CUSTOMIZATIONS FOR THIS SERVER

if "%WAIT%" == "yes" echo Calling KSET.BAT ..
if "%WAIT%" == "yes" pause
if exist KSET.BAT call KSET.BAT

REM ------------------------------------------------------
REM Determine the RAMDRIVE letter and set RAMD to it.
if "%WAIT%" == "yes" echo Determining RAMDRIVE letter ..
if "%WAIT%" == "yes" pause
call setramd.bat

if not "%RAMD%" == "" PATH=%RAMD%:\

if "%CONFIG%" == "" set CONFIG=NOCD
goto %CONFIG%

REM ------------------------------------------------------
:CD
set CDROM=X
REM PATH=%PATH;%CDROM%:\
if "%WAIT%" == "yes" echo Loading MSCDEX CDROM driver ..
if "%WAIT%" == "yes" pause
LOADHIGH MSCDEX /D:MSCD001 /M:8 /L:%CDROM%
goto COMMON

REM ------------------------------------------------------
:NOCD
goto COMMON

REM ------------------------------------------------------
:COMMON
if "%RAMD%" == "" goto NORAMDRIVE
%RAMD%:
if "%WAIT%" == "yes" echo About to configure Server %SERVERNAME% ..
if "%WAIT%" == "yes" pause

echo Configuring server on %RAMD%: ... Please wait..
copy a:*.* >NUL
set COMSPEC=%RAMD%:\command.com

pkunzip -o -n *.zip >NUL 

:NORAMDRIVE
REM Create SYSTEM.INI file

if not exist MAKESYSI.BAT goto NOMAKESYSI
    if "%WAIT%" == "yes" echo Creating SYSTEM.INI for %NWPROTOCOL%/%ETHERNET% ..
    if "%WAIT%" == "yes" pause
    call MAKESYSI.BAT %RAMD%: %ETHERNET%.DOS K%SERVERNAME%
:NOMAKESYSI

echo Starting Server on %RAMD%:
if "%WAIT%" == "yes" pause

REM Chain to the KSTART.BAT file
KSTART
