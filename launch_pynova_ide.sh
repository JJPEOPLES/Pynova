#!/bin/bash

# Set colors
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Clear screen and show header
clear
echo -e "${BLUE}==================================="
echo "       PyNova IDE Launcher"
echo -e "===================================${NC}"
echo ""

# Check if Python is installed
echo "Checking Python installation..."
if command -v python3 &>/dev/null; then
    PYTHON_CMD="python3"
elif command -v python &>/dev/null; then
    PYTHON_CMD="python"
else
    echo -e "${RED}ERROR: Python is not installed."
    echo "Please install Python 3.6 or higher and try again.${NC}"
    echo ""
    read -p "Press Enter to exit..."
    exit 1
fi

# Get Python version
PYTHON_VERSION=$($PYTHON_CMD --version 2>&1 | cut -d' ' -f2)
echo -e "${GREEN}Found $PYTHON_CMD version $PYTHON_VERSION${NC}"

# Check if required packages are installed
echo "Checking required packages..."

# Check PyQt5
if ! $PYTHON_CMD -c "import PyQt5" &>/dev/null; then
    echo "Installing PyQt5..."
    pip3 install PyQt5 || pip install PyQt5
    if [ $? -ne 0 ]; then
        echo -e "${RED}ERROR: Failed to install PyQt5.${NC}"
        echo ""
        read -p "Press Enter to exit..."
        exit 1
    fi
fi

# Set the current directory to the script directory
cd "$(dirname "$0")"

# Launch the IDE
echo ""
echo -e "${GREEN}Launching PyNova IDE...${NC}"
echo ""
$PYTHON_CMD pynova_ide/main.py

# If the IDE crashes, show an error
if [ $? -ne 0 ]; then
    echo ""
    echo -e "${RED}ERROR: PyNova IDE exited with an error (code $?).${NC}"
    echo ""
    read -p "Press Enter to exit..."
fi