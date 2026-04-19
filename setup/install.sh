#!/bin/bash

# --- 1. Detect OS ---
OS_TYPE="$(uname -s)"
ARCH_TYPE="$(uname -m)"

echo "Detected OS: $OS_TYPE ($ARCH_TYPE)"

# --- 2. Install Python Dependencies ---
echo "Installing Python libraries..."
pip3 install -r requirements.txt

# --- 3. AdvantageScope Auto-Install ---
REPO="Mechanical-Advantage/AdvantageScope"
API_URL="https://api.github.com/repos/$REPO/releases/latest"

echo "Fetching latest AdvantageScope release info..."
# Get the download URL for the current OS
if [ "$OS_TYPE" == "Darwin" ]; then
    # macOS: Look for .dmg
    DOWNLOAD_URL=$(curl -s $API_URL | grep "browser_download_url" | grep ".dmg" | cut -d '"' -f 4 | head -n 1)
    FILE_NAME="AdvantageScope_Installer.dmg"
elif [ "$OS_TYPE" == "Linux" ]; then
    # Linux: Look for .AppImage
    DOWNLOAD_URL=$(curl -s $API_URL | grep "browser_download_url" | grep ".AppImage" | cut -d '"' -f 4 | head -n 1)
    FILE_NAME="AdvantageScope.AppImage"
else
    echo "This script only supports macOS and Linux. Please use the .bat for Windows."
    exit 1
fi

if [ -z "$DOWNLOAD_URL" ]; then
    echo "Error: Could not find a download link for your OS."
    exit 1
fi

echo "Downloading from: $DOWNLOAD_URL"
curl -L -o "$FILE_NAME" "$DOWNLOAD_URL"

# --- 4. OS Specific Finalization ---
if [ "$OS_TYPE" == "Darwin" ]; then
    echo "Opening DMG... Please drag AdvantageScope to your Applications folder."
    open "$FILE_NAME"
elif [ "$OS_TYPE" == "Linux" ]; then
    echo "Setting permissions for AppImage..."
    chmod +x "$FILE_NAME"
    echo "AdvantageScope is ready! You can run it with ./$FILE_NAME"
    # Optional: Move to a standard bin location
    # sudo mv "$FILE_NAME" /usr/local/bin/advantagescope
fi

echo "--- Setup Complete ---"
