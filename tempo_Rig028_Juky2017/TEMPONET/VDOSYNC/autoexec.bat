@ECHO OFF
REM AUTOEXEC.BAT for VDOSYNC DISKETTE
REM 06Dec02 (c) 2002 Reflective Computing
REM 05May04 Fixed minor bug when adding CDROM to PATH.
REM 05May04 Intel's E1000.DOS has a bug in it that causes it to
REM         fail (freeze or display a MATH 6111 error) depending on the
REM         operating system (PCDOS or WIN95/98) and the order
REM         in which it is loaded relative to the MSCDEX.
REM         See temponet/network/e1000.txt for details.
REM         AUTOEXEC.VS needs to:
REM             for win98, load mscdex  then net
REM             for pcdos, load net     then mscdex
REM 20Dec04 Add COPYCMD setting to environment.

REM ------------------------------------------------------
REM Set environment variables

set COPYCMD=/Y


REM ------------------------------------------------------
REM Set VideoSYNCs environment variables
REM VSET.BAT generally needs to be called only once after booting.

if "%WAIT%" == "yes" echo Setting Environment Variables (VSET.BAT)
if "%WAIT%" == "yes" pause

if exist VSET.BAT call VSET.BAT

REM ------------------------------------------------------
REM Determine the RAMDRIVE letter and set RAMD to it.

if "%WAIT%" == "yes" echo Locating RAMDRIVE letter (SETRAMD.BAT)
if "%WAIT%" == "yes" pause

call setramd.bat

if "%RAMD%" == "" goto NORAMDRIVE

PATH=%RAMD%:\
set COMSPEC=%RAMD%:\command.com

echo Configuring VideoSYNC on %RAMD%: ... Please wait..
%RAMD%:

if "%WAIT%" == "yes" pause
if "%WAIT%" == "yes" echo Copying files to RAMDRIVE

copy a:*.* >NUL

if "%WAIT%" == "yes" echo Unzipping ZIP files
if "%WAIT%" == "yes" pause

for %%f in (*.zip) do pkunzip -o -n %%f >NUL 

REM ------------------------------------------------------
REM E1000 bug: If PCDOS, load NET before MSCDEX

if "%VSOSDIRECTORY%"=="\PCDOS" goto NETFIRST

REM ------------------------------------------------------
REM The CDROM environment variable is either empty or set
REM to a drive letter (eg: X) by the user in SETUPTN
REM Note that the colon is omitted!

if "%CDROM%" == "" goto NOCD

    if "%WAIT%" == "yes" echo Loading CD-ROM driver
    if "%WAIT%" == "yes" pause

    SET PATH=%PATH%;%CDROM%:\
    LOADHIGH MSCDEX /D:MSCD001 /M:8 /L:%CDROM%
    set MSCDEXLOADED=YES

    if "%WAIT%" == "yes" echo Loaded CD-ROM driver
    if "%WAIT%" == "yes" pause

:NOCD
:NETFIRST

REM ------------------------------------------------------
REM If the user wants to start the network, we set that up now.
if "%ETHERNET%" == "" goto NONET

    if "%WAIT%" == "yes" echo Creating Network SYSTEM.INI ..
    if "%WAIT%" == "yes" pause
    
    call MAKESYSI.BAT %RAMD%: %ETHERNET%.DOS V%SERVERNAME%
    
    REM WE START THE NETWORK JUST ONCE PER BOOT.
    
    if "%WAIT%" == "yes" echo Loading NETWORK driver
    if "%WAIT%" == "yes" pause
    
    lh net start netbeui
    
    if "%WAIT%" == "yes" echo Loaded NETWORK driver
    if "%WAIT%" == "yes" pause
:NONET
    
REM ------------------------------------------------------
REM For PCDOS, we load MSCDEX _after_ NETWORK

if "%MSCDEXLOADED%"=="YES" goto CDLOADED

if "%CDROM%" == "" goto NOCD1

    if "%WAIT%" == "yes" echo Loading CD-ROM driver
    if "%WAIT%" == "yes" pause

    SET PATH=%PATH%;%CDROM%:\
    LOADHIGH MSCDEX /D:MSCD001 /M:8 /L:%CDROM%
    set MSCDEXLOADED=YES

    if "%WAIT%" == "yes" echo Loaded CD-ROM driver
    if "%WAIT%" == "yes" pause

:CDLOADED
:NOCD1

REM ------------------------------------------------------
if "%MOUSE%" == "no" goto NOMOUSE

    if "%WAIT%" == "yes" echo Loading MOUSE driver
    if "%WAIT%" == "yes" pause

    if not exist LOADMOUS.BAT lh mouse
    if     exist LOADMOUS.BAT call LOADMOUS
    
    if "%WAIT%" == "yes" echo Loaded MOUSE driver
    if "%WAIT%" == "yes" pause

:NOMOUSE

REM ------------------------------------------------------
REM Execute User defined BATCH file commands.
REM It allows the user to use NET LOGON and NET USE commands
REM that establish network connections.
REM This is normally done just once after the boot.
    
if "%WAIT%" == "yes" echo Calling User file (VSBAT.BAT)
if "%WAIT%" == "yes" pause

if exist VSBAT.BAT call VSBAT.BAT

if "%WAIT%" == "yes" echo Called User file (VSBAT.BAT)
if "%WAIT%" == "yes" pause
    
REM ------------------------------------------------------
:NONET
REM Chain to the VSTART.BAT file.
REM Control passes to VSTART.BAT and does not return

if "%WAIT%" == "yes" echo Starting VideoSYNC ..
if "%WAIT%" == "yes" pause

vstart

REM We should not get to this point!

if "%WAIT%" == "yes" echo VideoSYNC exited ..
if "%WAIT%" == "yes" pause

goto EXIT

REM ------------------------------------------------------
REM Unable to create a RAMDRIVE.  This is highly unusual and requires
REM Tech Support assistance.

:NORAMDRIVE
echo The RAMDRIVE was not found.
echo Please contact Reflective Computing for assistance.

:EXIT
