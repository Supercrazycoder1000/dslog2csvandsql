@echo off
title DSLog Tool Setup
echo [1/3] Checking for Python...
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Error: Python is not installed or not in PATH.
    pause
    exit
)

echo [2/3] Installing required Python libraries...
pip install -r requirements.txt

echo [3/3] Setup Complete!
echo --------------------------------------------------
echo IMPORTANT: 
echo 1. Ensure AdvantageScope is installed.
echo 2. Update the AS_PATH in dslog2csv.py to your installation path.
echo --------------------------------------------------
pause