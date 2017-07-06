@echo off
REM VSTART.BAT Batch file for starting/restarting VideoSYNC
REM 09Feb03 sh Initial edit
REM 22Jun03 sh change name to VSSTAT.TXT

REM vdosync vs.cfg >vsstat.txt
vdosync vs.cfg

echo ----------------------------------------
echo Timing information stored in  VSSTAT.TXT
echo To test video modes, type     VTIME
echo To rerun VideoSYNC, type      VSTART
echo ----------------------------------------
