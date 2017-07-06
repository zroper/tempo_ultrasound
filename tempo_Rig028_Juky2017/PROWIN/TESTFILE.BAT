@echo off
REM Used by TESTFILE.PRO to test existence of a file
REM Usage: TESTFILE filename

if exist %1 goto EXISTS

echo fileExists=0 >TESTFILE.TPO
goto EXIT

:EXISTS
echo fileExists=1 >TESTFILE.TPO
:EXIT
