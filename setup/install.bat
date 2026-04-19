@echo off
setlocal enabledelayedexpansion
title DSLog Tool - Ultimate Installer

echo ======================================================
echo    DSLog2CSV and SQL - Auto Installer (Windows)
echo ======================================================
echo.

:: 1. CHECK FOR PYTHON
echo [Step 1/3] Checking for Python...
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Python is not installed or not in your PATH.
    echo Please install Python from python.org before running this.
    pause
    exit /b
)
echo Python found!

:: 2. INSTALL PYTHON LIBRARIES
echo.
echo [Step 2/3] Installing Python dependencies...
:: First, ensure pip is up to date
python -m pip install --upgrade pip >nul
:: Install requirements (using the list we discussed)
pip install -r requirements.txt
if %errorlevel% neq 0 (
    echo [WARNING] Some libraries failed to install. Check your internet connection.
)

:: 3. AUTO-INSTALL ADVANTAGESCOPE
echo.
echo [Step 3/3] Fetching AdvantageScope from GitHub...

:: This PowerShell command finds the latest .exe asset and downloads it
powershell -Command ^
    "$repo = 'Mechanical-Advantage/AdvantageScope';" ^
    "$api = 'https://api.github.com/repos/' + $repo + '/releases/latest';" ^
    "$val = Invoke-RestMethod -Uri $api;" ^
    "$asset = $val.assets | Where-Object { $_.name -like '*win64.exe' -or ($_.name -like '*.exe' -and $_.name -notlike '*setup*') } | Select-Object -First 1;" ^
    "$url = $asset.browser_download_url;" ^
    "echo ('Downloading: ' + $asset.name);" ^
    "Invoke-WebRequest -Uri $url -OutFile 'AdvantageScope_Installer.exe'"

if exist "AdvantageScope_Installer.exe" (
    echo.
    echo [SUCCESS] Installer downloaded.
    echo Launching AdvantageScope Setup...
    start "" "AdvantageScope_Installer.exe"
    echo.
    echo NOTE: Once AdvantageScope is installed, please update the 
    echo AS_PATH in your script if you installed it to a custom folder.
) else (
    echo [ERROR] Failed to download AdvantageScope. 
    echo Please download it manually: https://github.com/Mechanical-Advantage/AdvantageScope/releases
)

echo.
echo ======================================================
echo Setup Process Finished!
echo ======================================================
pause
