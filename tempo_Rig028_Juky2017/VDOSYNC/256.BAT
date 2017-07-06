@echo off
REM TEST 1024x768x256 color mode
REM Requires 1 Mb of video RAM
REM Should display a series of screens containing
REM boxes of varying color intensities

vdosync vs.cfg VIDEO=261 MODE=256.WPL WAIT=NO