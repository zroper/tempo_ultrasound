@echo off
REM .title  MSCLIENT.BAT - Get MSCLIENT files from internet
REM This batch file downloads the MSCLIENT files from the Microsoft
REM web site then unpacks them into the \MSCLIENT directory.
REM
REM Before using this software, you must read and agree to the
REM terms of the Microsoft MSCLIENT 3.0 license agreement.  This
REM can be found in TEMPO\TEMPONET\MISC\MSCLIENT.TXT file.
REM 
REM
REM The needed files are:
REM
REM     DSK3-1.EXE      MSCLIENT 3.0 disk 1     864,723 bytes
REM     DKS3-2.EXE      MSCLIENT 3.0 disk 2     288,142 bytes
REM
REM These files are required by TEMPONET to be in the \MSCLIENT
REM directory.
REM
REM If your client computer is connected to the internet, you should
REM use the SETUPTN.EXE program to automatically download and
REM unpack these files.
REM 
REM If your TEMPONET client computer is not connected to the internet,
REM you can not use SETUPTN.EXE to download the  follow
REM these steps.
REM
REM  1. On a computer connected to the internet, create the \MSCLIENT
REM     directory:
REM
REM         mkdir c:\msclient
REM
REM     Then copy this file (MSCLIENT.BAT) and PKUNZIP.EXE into that
REM     directory.  Both of these files are in the TEMPO directory on
REM     your client computer.
REM
REM  2. Execute the MSCLIENT.BAT file.
REM
REM         cd \msclient
REM         msclient
REM
REM     It will download the needed files into \MSCLIENT directory.
REM
REM  3. After the needed files are in the \MSCLIENT directory, copy
REM     the \MSCLIENT directory to the TEMPONET client computer.
REM
REM ----------------------------------------------------------------
REM You should not need to change anything in this file.
REM ----------------------------------------------------------------
REM These files are PKZIP compressed.
REM
REM NOTE: With slow internet connections (ie dialup), it can take several
REM minutes to download these two files.
REM
REM We assume:
REM     the current directory is the TEMPO directory
REM     This computer is connected to the internet (so we can download files)
REM     PKUNZIP.EXE is available on this computer
REM
REM Most browsers are able to download these files using the URL:
REM
REM     ftp://ftp.microsoft.com/bussys/Clients/MSCLIENT/
REM
REM Note: These files are also available at many other web sites.
REM Use GOOGLE to look up MSCLIENT.  Another site is:
REM
REM         ftp://ftp.unicomp.br/pub/apoio/dos/msclient
REM
REM             At this site, the files are named DISK1.ZIP and DISK2.ZIP
REM             Unzip these manually with PKUNZIP into the \MSCLIENT
REM             directory.
REM
REM WARNING: This batch file leaves the current directory set to \MSCLIENT
REM
REM EDIT HISTORY
REM     03Sep03 sh Initial edit
REM     09Sep03 sh Improved documentation

if not exist \msclient\dsk3-1.exe mkdir \msclient

cd \msclient
if exist \msclient\dsk3-1.exe if exist \msclient\dsk3-1.exe GOTO ALREADYHERE

REM CREATE THE MSCLIENT.FTP BATCH FILE FOR THE FTP PROGRAM

echo prompt                         >msclient.ftp
echo open ftp.microsoft.com         >>msclient.ftp
echo user anonymous guest@ms        >>msclient.ftp
echo cd bussys\Clients\MSCLIENT     >>msclient.ftp
echo binary                         >>msclient.ftp
echo mget DSK3-1.EXE                >>msclient.ftp
echo mget DSK3-2.EXE                >>msclient.ftp
echo quit                           >>msclient.ftp

REM DOWNLOAD TWO FILES, IF THEY DON'T ALREADY EXIST

echo DOWNLOADING MSCLIENT FROM INTERNET ...

FTP -n -s:msclient.ftp

REM SEE THAT WE GOT THEM CORRECTLY

if not exist dsk3-1.exe GOTO NOEXE
if not exist dsk3-2.exe GOTO NOEXE

:ALREADYHERE
REM AT THIS POINT, WE SHOULD HAVE THE THE FILES IN THE \MSCLIENT DIRECTORY
REM CHECK TO SEE IF THEY HAVE ALREADY BEEN EXPANDED. IF NOT, EXPAND THEM.

if not exist AM2100.DO_  echo UNZIPPING DSK3-1.EXE ...
if not exist AM2100.DO_  PKUNZIP -D -O DSK3-1.EXE >NUL
if not exist AM2100.DO_  GOTO PKUNZIPERR

if not exist ADDNAME.EX_ echo UNZIPPING DKS3-2.EXE ...
if not exist ADDNAME.EX_ PKUNZIP -D -O DSK3-2.EXE >NUL
if not exist ADDNAME.EX_ GOTO PKUNZIPERR

REM NOW EXPAND THE FILES, IF NECESSARY

if not exist AM2100.DOS goto EXPAND
if not exist ADDNAME.EX goto EXPAND
goto EXPANDED

:EXPAND

echo EXPANDING FILES ..

for %%f in (*.??_) do expand -r %%f >NUL

REM CHECK TO MAKE SURE THEY GOT UNPACKED CORRECTLY

:EXPANDED

if not exist AM2100.DOS goto EXPANDERR  
if not exist ADDNAME.EX goto EXPANDERR  

echo MSCLIENT FILES LOADED SUCCESSFULLY.
goto EXIT

:EXPANDERR
echo -----------------------------------------------
echo ERROR expanding MSCLIENT files.
echo Please contact Reflective Computing Technical Support.
echo -----------------------------------------------
goto EXIT

:NOEXE
echo -----------------------------------------------
echo You are missing one of the two MSCLIENT 3.0 FILES:
echo    DSK3-1.EXE      MSCLIENT 3.0 disk 1
echo    DSK3-2.EXE      MSCLIENT 3.0 disk 2
echo -----------------------------------------------
goto EXIT

:PKUNZIPERR
echo -----------------------------------------------
echo Error unzipping one of two MSCLIENT 3.0 FILES:
echo    DSK3-1.EXE      MSCLIENT 3.0 disk 1
echo    DSK3-2.EXE      MSCLIENT 3.0 disk 2
echo -----------------------------------------------
goto EXIT

:EXIT