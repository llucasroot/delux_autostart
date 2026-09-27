# DELUX Driver Autostart

A simple script to automatically start the DELUX Gaming Driver minimized on Windows logon using Task Scheduler.

By default, the DELUX Gaming Driver might not always start automatically with Windows, or it might open an annoying window every time you boot your PC. 

This repository provides a quick, automated solution. It includes a simple Batch script that creates a Windows Scheduled Task to **automatically launch the DELUX driver completely minimized (in the system tray)** every time you log in.

> **Prerequisite:** This script requires the official software to be installed on your system. You can download it from the [official DELUX drivers website](https://www.deluxworld.com/service.html).

### Features
- 🚀 **Silent Startup:** Runs the driver in the background (`/min` argument) without interrupting your desktop.
- 🛡️ **Auto-Admin:** The batch script automatically requests the necessary Administrator privileges to create the task.
- ⚡ **Lightweight:** Uses native Windows Task Scheduler instead of modifying the registry or placing shortcuts in the Startup folder.

## Installation

1. Download the files from this repository.
2. Double-click on `install_task.bat`.
3. If prompted by Windows (User Account Control), click **Yes** to allow it to run as Administrator.
4. A terminal window will open and confirm the task was created successfully.

*Note: If you have installed the DELUX driver in a custom folder, you will need to edit the script/XML with your custom path before running the installer.*
