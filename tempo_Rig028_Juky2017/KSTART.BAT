@echo off
REM KSTART.BAT - This file is used to load the KERNEL and run the SERVER
REM 20Dec02 (c) 2002 Reflective Computing.  All Rights Reserved.
REM 01Feb03 (c) 2003 Reflective Computing.  All Rights Reserved.
REM
REM -----------------------------------------------------------------------
REM -----------------------------------------------------------------------
REM Before you can use this batch file, you must edit KSET.BAT and
REM configure it for your particular server.
REM
REM Do not change this file.  In future releases, it may be updated.
REM -----------------------------------------------------------------------
REM -----------------------------------------------------------------------
REM 02Oct01 sh Updated to process KSRV return codes; enhanced messages
REM 13May02 sh Add hardware key not installed message
REM 25Sep02 sh Set default values for some environment variables used by TEMPONET
REM 07Feb03 sh If MOUSE==NO, do not load mouse driver
REM 09Apr03 sh set NET=yes, MOUSE=no after loading the drivers to prevent reloading
REM            if WAIT==yes, pause before removing KERNEL from memory
REM 26Aug03 sh Different help displays for LOADKEY, KSRV and KERNEL for pw failure
REM 03Jun04 sh To load mouse driver, if LOADMOUS.BAT exists, call it.  Otherwise do LH MOUSE
REM 23Aug04 sh Add 3rd arg (CFG file) to  KSRV/CSRV command line
REM            Pass %KERNEL%.CFG to %KSRV%
REM 15Nov04 sh Add support for TCP
REM 07Aug06 sh Reduce length of labels (KERNELBADPW -> KBADPW): DOS was getting confused!
REM 05May07 sh Display KSRV error numbers
REM 17Jun07 sh If KSRV won't load (Program Won't Fit In Memory), suggest user reduce TEMPOServer/Protocol parameters
REM            Tell user when we begin loading of KERNEL and KSRV and display command lines
REM            Enhance error message when ksrv fails to load network

REM SET ENVIRONMENT VARIABLES TO USER'S CONFIGURATION
REM SET DEFAULTS

IF "%SERVERNAME%"   == ""   SET SERVERNAME=TEMPO1
IF "%LANA%"         == ""   SET LANA=255
IF "%ETHERNET%"     == ""   SET ETHERNET=EL90X
IF "%KSRV%"         == ""   SET KSRV=KSRV
IF "%NWPROTOCOL%"   == ""   SET NWPROTOCOL=NETBEUI

REM We don't set KERNEL to anything here because we will use this to
REM determine if KSET.BAT has been customized.

SET KERNEL=

if not exist KSET.BAT copy CFG\KSET.BAT

call KSET

if "%WAIT%" == "yes" echo Beginning load sequence for Server ..
if "%WAIT%" == "yes" pause

if "%kernel%" == "" goto NOKERNEL
if not exist %kernel%.cfg goto NOKCFG
if not exist %kernel%.exe goto NOKEXE
if not exist %ksrv%.exe   goto NOKSRVEXE

REM START THE NETWORK JUST ONCE PER BOOT.  USE THE NET ENVIRcdONMENT VARIABLE
REM TO INDICATE THAT THE NETWORK HAS BEEN STARTED.

if "%NET%" == "yes" goto KERNEL

    if "%WAIT%" == "yes" echo Loading NETWORK driver ..
    
    if     "%NWPROTOCOL%" == "TCP"   netbind
    
    REM 17Jun07 Sadly, NETBIND fails to return an errorlevel
    REM     when it fails to bind (ie: cable is unplugged from E1000)
    REM     It beeps and prints out:
    REM
    REM         BIND failed
    REM         ERROR: 36 Unable to bind.  Hardware Failure.
    REM
    REM if errorlevel 4 echo ERROR 4 LOADING NETWORK DRIVER
    REM if errorlevel 3 echo ERROR 3 LOADING NETWORK DRIVER
    REM if errorlevel 2 echo ERROR 2 LOADING NETWORK DRIVER
    REM if errorlevel 1 echo ERROR 1 LOADING NETWORK DRIVER
    
    if NOT "%NWPROTOCOL%" == "TCP"   lh net start netbeui
    
    if "%WAIT%" == "yes" pause
    set NET=yes
    
    if "%MOUSE%" == "no" goto NOMOUSE
    
        if "%WAIT%" == "yes" echo Loading MOUSE driver ..
        
        if not exist LOADMOUS.BAT lh mouse
        if     exist LOADMOUS.BAT call LOADMOUS
        
        if "%WAIT%" == "yes" pause
        set MOUSE=no
    
    :NOMOUSE
    
:KERNEL

REM If we are using KSRV, this is a TEMPO/Win system
REM which does not use KEY files.

if "%KSRV%" == "KSRV" goto LOADKERNEL

REM IF THERE IS A LICENSE.KEY FILE, LOAD IT ONTO THE HARDWARE KEY

if not exist LICENSE.KEY goto NOKEYFILE
if "%WAIT%" == "yes" echo Loading LICENSE ..
if "%WAIT%" == "yes" pause
loadkey license.key
if errorlevel 3 goto LOADKEYERR


REM  NOW LOAD THE KERNEL.
:LOADKERNEL
if "%WAIT%" == "yes" echo Loading HARD REAL-TIME KERNEL (%kernel%) ...
if "%WAIT%" == "yes" pause

echo ддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд
ECHO KSTART - Loading the kernel:  %KERNEL% %kernel%.cfg

%KERNEL% %KERNEL%.cfg

if errorlevel 7  goto KBADPW
if errorlevel 5  goto KNOAPROC
if errorlevel 4  goto KBADCOMMAND
if errorlevel 3  goto KCANTREMOVE
if errorlevel 2  goto KCANTINSTALL
if errorlevel 1  goto KALREADYIN

REM   NOW RUN THE KERNEL SERVER

if "%WAIT%" == "yes" echo Starting NETWORK SERVER (%KSRV% %LANA% %SERVERNAME% %KERNEL%.CFG) ...
if "%WAIT%" == "yes" pause

echo ддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд
ECHO KSTART - Loading the kernel server:  %KSRV% %lana% %servername% %kernel%.cfg
ECHO (If 'Program too big to fit in memory', reduce Server/Protocol/.. parameters)

%KSRV% %lana%  %servername% %KERNEL%.CFG

if errorlevel 13 goto KSCTRLBREAK
if errorlevel 12 goto KSNOHARDKEY
if errorlevel 11 goto KSABEND
if errorlevel 10 goto KSOPENKERNEL
if errorlevel 9  goto KSCLOSEKERNEL
if errorlevel 8  goto KSCLOSENETWORK
if errorlevel 7  goto KSOPENNETWORK
if errorlevel 6  goto KSFUNERR
if errorlevel 5  goto KSWRONGKERNEL
if errorlevel 4  goto KSXMA
if errorlevel 3  goto KSNOEMM
if errorlevel 2  goto KSBADSIZE
if errorlevel 1  goto KSBADPW

REM   Normal exit.  When KSRV exits, remove the KERNEL from memory

if "%WAIT%" == "yes" echo Removing KERNEL from memory ...
if "%WAIT%" == "yes" pause

kinfo -r
goto EXIT

:KSNOHARDKEY
echo KSRV ERROR 12 KSNOHARDKEY
echo зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
echo Ё%KSRV% has not detected the hardware licensing key.                    Ё
echo ЁPlease install the hardware key and rerun %KSRV%.                      Ё
echo юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

if "%WAIT%" == "yes" echo Removing KERNEL from memory ...
if "%WAIT%" == "yes" pause

kinfo -r
goto EXIT

:KSABEND
    echo KSRV ERROR 11 KSABEND
    goto GENERAL
:KSOPENKERNEL
    echo KSRV ERROR 10 KSOPENKERNEL
    goto GENERAL
:KSCLOSEKERNEL
    echo KSRV ERROR  9 KSCLOSEKERNEL
    goto GENERAL
:KSCLOSENETWORK
    echo KSRV ERROR  8 KSCLOSENETWORK
    goto GENERAL
:KSOPENNETWORK
    echo KSRV ERROR  7 KSOPENNETWORK
    goto GENERAL
:KSFUNERR
    echo KSRV ERROR  6 KSFUNERR     
    goto GENERAL
:KSWRONGKERNEL
    echo KSRV ERROR  5 KSWRONGKERNEL
    goto GENERAL
:KSXMA
    echo KSRV ERROR  4 KSXMA        
    goto GENERAL
:KSNOEMM
    echo KSRV ERROR  3 KSNOEMM      
    goto GENERAL
:KSBADSIZE
    echo KSRV ERROR  2 KSBADSIZE    
    goto GENERAL

:GENERAL
echo зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
echo ЁAn error occurred starting %KSRV%, the network server program.                Ё
echo Ё                                                                             Ё
echo Ё. CONNECTIVITY: Make sure the network cable to is securely connected. Verify Ё
echo Ё   the Switch or Router is working.  Boot to Windows and verify you see      Ё
echo Ё   other computers in the Network Neighborhood.                              Ё
echo Ё                                                                             Ё
echo Ё. DRIVER:  Verify ..Server/Network/ETHERNET= matches the network interface   Ё
echo Ё   controller (NIC) on this computer. Check SETUPTN Network Parameters.      Ё
echo Ё                                                                             Ё
echo ЁAfter correcting the problem, you must reboot with the Server diskette.      Ё
echo юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

pause

if "%WAIT%" == "yes" echo Removing KERNEL from memory ...
if "%WAIT%" == "yes" pause

kinfo -r
goto EXIT

:KSCTRLBREAK
echo зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
echo ЁCrash dump written to KSRV.DMP.                                      Ё
echo ЁPlease email KSRV.DMP to Reflective Computing.                       Ё
echo ЁYou must reboot your computer.                                       Ё
echo юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

if "%WAIT%" == "yes" echo Removing KERNEL from memory ...
if "%WAIT%" == "yes" pause

kinfo -r
goto EXIT

:KBADPW
copy \*.sno a:\*.snx
echo зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
echo ЁThe KERNEL password is not valid.                                    Ё
echo Ё                                                                     Ё
echo ЁThe KERNEL Serial Numbers have been written to the A: drive.         Ё
echo Ё                                                                     Ё
echo ЁPlease email all A:*.SNX files to Reflective Computing.   Thank you. Ё
echo юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
pause
goto KSBADPW

:KSBADPW
echo Generating KSRV Serial number file ..
pause

kinfo -r

REM Generate C:\KSRV.SNO.  KSRV will not run because the KERNEL is not in memory

if exist C:\%KSRV%.SNO goto KSRVSNO
    echo Running KSRV (%KSRV% %lana% %servername%) TO GET SERIAL NUMBER...
    pause
    %KSRV% %lana%  %servername% >nul
:KSSNO

REM If user doesn't have a PASSWORD.CFG file, use our template.

if exist PASSWORD.CFG goto PWEXISTS
if exist CFG\PASSWORD.XXX copy CFG\PASSWORD.XXX PASSWORD.CFG >nul
:PWEXISTS

echo зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
echo ЁYou must obtain valid license and passwords for this computer.       Ё
echo ЁPlease follow the directions in the Installation chapter of the      Ё
echo ЁTEMPO Manual to license this computer.                               Ё
echo юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
goto EXIT

:KNOAPROC
:KBADCOMMAND
:KCANTREMOVE
:KCANTINSTALL
:KALREADYIN
echo зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
echo Ё  Unable to load kernel.  Please correct problem and try again.      Ё
echo юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
goto EXIT


:NOKERNEL
echo зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
echo Ё The KSTART.BAT file is useful for starting the server. It           Ё
echo Ё loads the network and other drivers, loads your kernel and runs     Ё
echo Ё KSRV.  When you exit KSRV, it removes your kernel from memory.      Ё
echo Ё                                                                     Ё
echo Ё Before you can use KSTART.BAT, you must customize KSET.BAT.         Ё
echo Ё Directions for customizing KSET.BAT can be found at the beginning   Ё
echo Ё of the file.                                                        Ё
echo Ё                                                                     Ё
echo Ё For TEMPONET, use the TEMPONET setup program to customize KSET.BAT. Ё
echo юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
goto EXIT

:NOKCFG
:NOKEXE
:NOKSRVEXE
echo ддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд
echo You are missing one or more of the following files in this directory:
if not exist %kernel%.cfg echo %kernel%.cfg
if not exist %kernel%.exe echo %kernel%.exe
if not exist %KSRV%.exe   echo %KSRV%.exe      
echo ддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд
goto EXIT

:LOADKEYERR
REM Try loading the kernel.  It may not load because it does not have the
REM right password.  But it generates KERNEL.SNO which is needed for the
REM licensing.

%kernel% %kernel%.cfg
kinfo -r
echo ддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд
echo There is a problem loading the hardware key on the server.
echo Here are some things you can check.
echo .
echo 1. Make sure you have the correct hardware key installed.
echo 2. If you are installing this server for the first time,
if     "%KSRV%"=="ksrvb" echo    Run DIAGNOSE and send A:\TEMPONET.LOG file to Reflective Computing.
if not "%KSRV%"=="ksrvb" echo    Run DIAGNOSE and send A:\SERVER.LOG file to Reflective Computing.
echo 3. Make sure you specified the correct .KEY file for this server.
echo .  The KEY file is unique to each computer.
echo 4. Follow the procedure in the Installation chapter of the TEMPO
echo .  Manual to license this computer.
echo 5. Send all error messages to Reflective Computing for assistance.
echo ддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд
goto EXIT

REM ----------------------------------------------------------------------
REM No KEY file was found.  The user did not specify a KEY file in their
REM TEMPONET configuration.  This can happen because they user may be running
REM this for the first time.
REM
REM At this point, the network and mouse drivers are loaded.
REM
REM Load the kernel in order to generate the .SNO file.
REM The kernel will not load because there is no password.  So ignore
REM any errors it might produce.
:NOKEYFILE
echo ддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд
%kernel% %kernel%.cfg >%kernel%.txt
%kernel% -t
if errorlevel 1 kinfo -r

REM Call DIAGNOSE.BAT to generate TEMPONET.LOG which the customer
REM emails to Reflective Computing for analysis.

echo The KEY file was not found.  Running the Diagnostic program ...
echo ддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд

call DIAGNOSE
goto EXIT2


:EXIT
echo ддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд
echo To restart the server, type KSTART
if not "%DIAGNOSTIC%" == "" echo To run the Diagnostic, type DIAGNOSE

:EXIT2
echo ддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд
