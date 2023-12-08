@echo off
setlocal enabledelayedexpansion
title Voicemeeter audio fixer
set PID=
set "PROCESS=audiodg.exe"
set "AFFINITY=1"

set "COLOR_SUCCESS=2"  REM Green
set "COLOR_ERROR=4"    REM Red
set "COLOR_INFO=6"     REM Cyan

net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Error: Administrative privileges required.
    color %COLOR_ERROR%
    pause
    exit /b 1
)

echo Searching for the process %PROCESS%...
timeout /nobreak /t 2 >nul
for /f "tokens=2 delims= " %%a in ('tasklist /fi "imagename eq %PROCESS%" ^| find "%PROCESS%"') do set PID=%%a

if not defined PID (
    echo The process %PROCESS% was not found.
    pause
    exit /b 1
)
cls
echo Process %PROCESS% found with PID: %PID%
echo Setting affinity to %PROCESS%...

timeout /nobreak /t 3 >nul

powershell -Command "& {Get-Process -Id %PID% | ForEach-Object { $_.ProcessorAffinity = %AFFINITY% }}"
if %errorLevel% neq 0 (
    echo Error: Unable to set affinity. Affinity not set.
    color %COLOR_ERROR%
    pause
    exit /b 1
)

echo Affinity set successfully.
timeout /nobreak /t 1 >nul

color %COLOR_SUCCESS%
for /l %%i in (3,-1,1) do (
    echo Exiting in %%i...
    timeout /nobreak /t 1 >nul
)

color
endlocal
exit /b 0
