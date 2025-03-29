#!/bin/bash

echo "PyNova Uninstaller"
echo "================="
echo

# Get the current directory (where PyNova is installed)
PYNOVA_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SCRIPT_DIR="$PYNOVA_DIR/bin"

echo "Uninstalling PyNova from: $PYNOVA_DIR"
echo

# Uninstall the Python package
echo "Uninstalling PyNova Python package..."
pip uninstall -y pynova
echo "Package uninstallation complete."
echo

# Determine shell configuration file
if [[ "$SHELL" == *"zsh"* ]]; then
    SHELL_CONFIG="$HOME/.zshrc"
elif [[ "$SHELL" == *"bash"* ]]; then
    if [[ "$OSTYPE" == "darwin"* ]]; then
        SHELL_CONFIG="$HOME/.bash_profile"
    else
        SHELL_CONFIG="$HOME/.bashrc"
    fi
else
    SHELL_CONFIG="$HOME/.profile"
fi

# Remove from PATH
echo "Removing PyNova from your PATH in $SHELL_CONFIG..."

# Create a temporary file
TEMP_FILE=$(mktemp)

# Filter out PyNova PATH entries
grep -v "export PATH=.*$SCRIPT_DIR" "$SHELL_CONFIG" | grep -v "# PyNova Path" > "$TEMP_FILE"

# Replace the original file
mv "$TEMP_FILE" "$SHELL_CONFIG"

echo "Successfully removed PyNova from your PATH."
echo

echo "Uninstallation complete!"
echo
echo "You may need to restart your terminal or run 'source $SHELL_CONFIG' for the PATH changes to take effect."
echo

read -p "Press Enter to continue..."