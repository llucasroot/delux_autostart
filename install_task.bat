@echo off
title DELUX Task Installer

:: ----------------------------------------------------------
:: 1. Check for Administrator privileges and auto-elevate
:: ----------------------------------------------------------
net session >nul 2>&1
if %errorLevel% == 0 (
    goto :isAdmin
) else (
    echo Requesting administrative privileges...
    :: Relaunches the script as Administrator
    powershell -Command "Start-Process -FilePath '%~dpnx0' -Verb RunAs"
    exit /b
)

:isAdmin
:: ----------------------------------------------------------
:: 2. Execute the installation command
:: ----------------------------------------------------------
echo ===================================================
echo Installing the DELUX Driver Scheduled Task...
echo ===================================================
echo.

:: Creates the task directly via command line
schtasks /create /tn "Delux" /tr "\"C:\Program Files (x86)\DELUX Gaming Driver\DELUX.exe\" /min" /sc onlogon /rl highest /f

echo.
if %errorlevel% equ 0 (
    echo [SUCCESS] Scheduled task installed successfully!
) else (
    echo [ERROR] Failed to install the scheduled task.
)
echo.
pause