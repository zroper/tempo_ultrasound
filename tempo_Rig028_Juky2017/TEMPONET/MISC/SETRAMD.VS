set RAMD=
REM Error code from FINDRAMD.EXE is the drive letter of the MS-RAMDISK
REM The reason why we have to go through this is because MS's RAMDRIVE.SYS
REM doesn't let us specify a drive letter the way MSCDEX does.
REM Note that the ERRORLEVEL test is TRUE if greater-than-or-equal to
REM
REM Note: On computers with no FAT partitions (eg: only NTFS), the RAMDRIVE
REM appears as the C: drive!

REM XMSDSK creates a RAM drive.  We can give it any letter we want
REM (or no letter and it will pick one).
REM It is a replacement for MS's RAMDRIVE.SYS, which has to go into
REM CONFIG.SYS.  XMSDSK is also resizable and load/unloadable.
REM It supports up to 2 Gb of ram.
REM Finally, the /t switch tells it to use "high" XMS memory.
REM This is important for SoundBlaster sound drivers, which
REM seem to require low XMS memory.
REM
REM If /t causes a problem, it can be removed.  But without the /t
REM switch, the SBLIVE PCI 5.1 board drivers must be loaded before XMSDSK.

xmsdsk 6144 R: /y /t

a:\findramd
if errorlevel 255 goto NORAMD
if errorlevel 27  goto NORAMD
if not errorlevel 3 goto NORAMD
if errorlevel  3 set RAMD=C
if errorlevel  4 set RAMD=D
if errorlevel  5 set RAMD=E
if errorlevel  6 set RAMD=F
if errorlevel  7 set RAMD=G
if errorlevel  8 set RAMD=H
if errorlevel  9 set RAMD=I
if errorlevel 10 set RAMD=J
if errorlevel 11 set RAMD=K
if errorlevel 12 set RAMD=L
if errorlevel 13 set RAMD=M
if errorlevel 14 set RAMD=N
if errorlevel 15 set RAMD=O
if errorlevel 16 set RAMD=P
if errorlevel 17 set RAMD=Q
if errorlevel 18 set RAMD=R
if errorlevel 19 set RAMD=S
if errorlevel 20 set RAMD=T
if errorlevel 21 set RAMD=U
if errorlevel 22 set RAMD=V
if errorlevel 23 set RAMD=W
if errorlevel 24 set RAMD=X
if errorlevel 25 set RAMD=Y
if errorlevel 26 set RAMD=Z
goto EXIT

:NORAMD
set RAMD=
echo No RAMDRIVE was detected!

:EXIT
REM if not "%RAMD%"=="" echo RAMDRIVE is %RAMD%