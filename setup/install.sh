#!/bin/bash
echo "Installing dependencies for dslog2csvandsql..."

# Install Python requirements
pip3 install pandas sqlalchemy pyautogui pydirectinput

# Linux needs extra system packages for pyautogui to control the mouse/keyboard
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "Installing Linux-specific UI libraries..."
    sudo apt-get update
    sudo apt-get install -y python3-tk python3-dev scrot
fi
