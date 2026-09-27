@echo off
setlocal EnableExtensions
title DELUX Task Installer

rem ==========================================================
rem  DELUX Gaming Driver - Scheduled Task Installer
rem
rem  Creates a task named "Delux" that starts DELUX.exe
rem  minimized whenever the user logs on, with the highest
rem  privileges available. Works on any Windows 10/11 PC and
rem  any user account. Nothing is hardcoded to one machine.
rem ==========================================================

set "TASK_NAME=Delux"
set "FOLDER_NAME=DELUX Gaming Driver"
set "EXE_NAME=DELUX.exe"
set "EXE_ARGS=/min"

rem ----------------------------------------------------------
rem  The task is created for the user who launched this script.
rem  When the script relaunches itself elevated, that user is
rem  passed as the first argument so it is not lost.
rem ----------------------------------------------------------
set "TARGET_USER=%USERDOMAIN%\%USERNAME%"
if not "%~1"=="" set "TARGET_USER=%~1"

rem ----------------------------------------------------------
rem  1. Check for administrator rights and auto-elevate
rem ----------------------------------------------------------
fltmc >nul 2>&1
if %errorlevel% == 0 goto :isAdmin

echo Requesting administrative privileges...
set "SELF=%~f0"
powershell -NoProfile -Command "Start-Process -FilePath $env:SELF -ArgumentList ([char]34 + $env:TARGET_USER + [char]34) -Verb RunAs"
if errorlevel 1 goto :elevationFailed
exit /b 0

:elevationFailed
echo.
echo [ERROR] Administrator permission was denied or could not be requested.
echo         Right-click this file and choose "Run as administrator".
echo.
pause
exit /b 1

:isAdmin
echo ===================================================
echo  Installing the DELUX Driver scheduled task
echo ===================================================
echo.
echo Task name : %TASK_NAME%
echo Runs for  : %TARGET_USER%
echo.

rem ----------------------------------------------------------
rem  2. Locate DELUX.exe in the default install folders
rem ----------------------------------------------------------
set "EXE_DIR="
if exist "%ProgramFiles(x86)%\%FOLDER_NAME%\%EXE_NAME%" set "EXE_DIR=%ProgramFiles(x86)%\%FOLDER_NAME%"
if not defined EXE_DIR if exist "%ProgramW6432%\%FOLDER_NAME%\%EXE_NAME%" set "EXE_DIR=%ProgramW6432%\%FOLDER_NAME%"
if not defined EXE_DIR if exist "%ProgramFiles%\%FOLDER_NAME%\%EXE_NAME%" set "EXE_DIR=%ProgramFiles%\%FOLDER_NAME%"
if not defined EXE_DIR goto :notFound

set "EXE_PATH=%EXE_DIR%\%EXE_NAME%"
echo Found: %EXE_PATH%
echo.

rem ----------------------------------------------------------
rem  3. Create the task
rem     - runs at logon, highest privileges, current user
rem     - allowed to start and keep running on battery power
rem     - no execution time limit (default is 72 hours)
rem ----------------------------------------------------------
powershell -NoProfile -ExecutionPolicy Bypass -Command "try { $q=[char]34; $a=New-ScheduledTaskAction -Execute ($q+$env:EXE_PATH+$q) -Argument $env:EXE_ARGS -WorkingDirectory $env:EXE_DIR; $t=New-ScheduledTaskTrigger -AtLogOn -User $env:TARGET_USER; $p=New-ScheduledTaskPrincipal -UserId $env:TARGET_USER -LogonType Interactive -RunLevel Highest; $s=New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -ExecutionTimeLimit ([TimeSpan]::Zero); Register-ScheduledTask -TaskName $env:TASK_NAME -Action $a -Trigger $t -Principal $p -Settings $s -Force -ErrorAction Stop | Out-Null; exit 0 } catch { Write-Host $_.Exception.Message; exit 1 }"
if errorlevel 1 goto :failed

rem ----------------------------------------------------------
rem  4. Confirm the task really exists
rem ----------------------------------------------------------
schtasks /query /tn "%TASK_NAME%" >nul 2>&1
if errorlevel 1 goto :failed

echo.
echo [SUCCESS] Scheduled task installed successfully!
echo           DELUX will start minimized at your next logon.
echo.
pause
exit /b 0

:notFound
echo [ERROR] %EXE_NAME% was not found in the default install folder:
echo         %ProgramFiles%\%FOLDER_NAME%
echo         Install the DELUX Gaming Driver first, then run this file again.
echo.
pause
exit /b 1

:failed
echo.
echo [ERROR] Failed to install the scheduled task.
echo.
pause
exit /b 1