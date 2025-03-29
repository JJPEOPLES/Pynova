#!/bin/bash

echo "PyNova Installer"
echo "==============="
echo

# Get the current directory (where PyNova is installed)
PYNOVA_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "Installing PyNova from: $PYNOVA_DIR"
echo

# Check if Python is installed
echo "Checking for Python installation..."
if ! command -v python3 &> /dev/null; then
    echo "Python 3 is not installed or not in PATH."

    # Determine the OS
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        echo "Detected Linux system."

        # Check for package manager
        if command -v apt-get &> /dev/null; then
            # Debian/Ubuntu
            echo "Installing Python 3.11 using apt..."
            sudo apt-get update
            sudo apt-get install -y software-properties-common
            sudo add-apt-repository -y ppa:deadsnakes/ppa
            sudo apt-get update
            sudo apt-get install -y python3.11 python3.11-venv python3.11-dev
        elif command -v dnf &> /dev/null; then
            # Fedora
            echo "Installing Python 3.11 using dnf..."
            sudo dnf install -y python3.11
        elif command -v yum &> /dev/null; then
            # CentOS/RHEL
            echo "Installing Python 3.11 using yum..."
            sudo yum install -y python3.11
        elif command -v pacman &> /dev/null; then
            # Arch Linux
            echo "Installing Python 3.11 using pacman..."
            sudo pacman -Sy python
        else
            echo "Could not determine package manager."
            echo "Please install Python 3.11 manually."
            read -p "Press Enter to continue..."
            exit 1
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        echo "Detected macOS system."

        # Check if Homebrew is installed
        if ! command -v brew &> /dev/null; then
            echo "Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi

        echo "Installing Python 3.11 using Homebrew..."
        brew install python@3.11

        # Create symlinks
        brew link python@3.11
    else
        echo "Unsupported operating system: $OSTYPE"
        echo "Please install Python 3.11 manually."
        read -p "Press Enter to continue..."
        exit 1
    fi

    echo "Python 3.11 installed successfully."
else
    # Check Python version
    PYTHON_VERSION=$(python3 --version 2>&1 | awk '{print $2}')
    echo "Found Python $PYTHON_VERSION"

    # Extract major and minor version
    PYTHON_MAJOR=$(echo $PYTHON_VERSION | cut -d. -f1)
    PYTHON_MINOR=$(echo $PYTHON_VERSION | cut -d. -f2)

    # Check if version is at least 3.6
    if [ "$PYTHON_MAJOR" -lt 3 ] || ([ "$PYTHON_MAJOR" -eq 3 ] && [ "$PYTHON_MINOR" -lt 6 ]); then
        echo "Warning: PyNova requires Python 3.6 or higher."
        echo "Current version: $PYTHON_VERSION"
        echo
        echo "Would you like to install Python 3.11? (y/n)"
        read -p "> " INSTALL_PYTHON
        if [[ "$INSTALL_PYTHON" =~ ^[Yy]$ ]]; then
            # Determine the OS
            if [[ "$OSTYPE" == "linux-gnu"* ]]; then
                # Linux
                echo "Detected Linux system."

                # Check for package manager
                if command -v apt-get &> /dev/null; then
                    # Debian/Ubuntu
                    echo "Installing Python 3.11 using apt..."
                    sudo apt-get update
                    sudo apt-get install -y software-properties-common
                    sudo add-apt-repository -y ppa:deadsnakes/ppa
                    sudo apt-get update
                    sudo apt-get install -y python3.11 python3.11-venv python3.11-dev
                elif command -v dnf &> /dev/null; then
                    # Fedora
                    echo "Installing Python 3.11 using dnf..."
                    sudo dnf install -y python3.11
                elif command -v yum &> /dev/null; then
                    # CentOS/RHEL
                    echo "Installing Python 3.11 using yum..."
                    sudo yum install -y python3.11
                elif command -v pacman &> /dev/null; then
                    # Arch Linux
                    echo "Installing Python 3.11 using pacman..."
                    sudo pacman -Sy python
                else
                    echo "Could not determine package manager."
                    echo "Please install Python 3.11 manually."
                    read -p "Press Enter to continue..."
                    exit 1
                fi
            elif [[ "$OSTYPE" == "darwin"* ]]; then
                # macOS
                echo "Detected macOS system."

                # Check if Homebrew is installed
                if ! command -v brew &> /dev/null; then
                    echo "Installing Homebrew..."
                    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
                fi

                echo "Installing Python 3.11 using Homebrew..."
                brew install python@3.11

                # Create symlinks
                brew link python@3.11
            else
                echo "Unsupported operating system: $OSTYPE"
                echo "Please install Python 3.11 manually."
                read -p "Press Enter to continue..."
                exit 1
            fi

            echo "Python 3.11 installed successfully."
        else
            echo "Continuing with existing Python installation..."
        fi
    fi
fi

# Check if pip is installed
echo "Checking for pip installation..."
if ! command -v pip3 &> /dev/null; then
    echo "pip is not installed or not in PATH."
    echo "Installing pip..."

    # Download get-pip.py
    echo "Downloading pip installer..."
    curl -o /tmp/get-pip.py https://bootstrap.pypa.io/get-pip.py

    # Install pip
    echo "Installing pip..."
    python3 /tmp/get-pip.py

    if [ $? -ne 0 ]; then
        echo "Failed to install pip."
        echo "Please install pip manually."
        read -p "Press Enter to continue..."
        exit 1
    fi

    echo "pip installed successfully."

    # Clean up
    rm /tmp/get-pip.py
else
    echo "pip is already installed."
fi

# Install required packages
echo "Installing required packages..."
pip3 install numba PyQt5 ply

# Install the PyNova package
echo "Installing PyNova Python package..."
pip3 install -e "$PYNOVA_DIR" || {
    echo "Error: Failed to install the PyNova package."
    echo "Please check the error message above and try again."
    read -p "Press Enter to continue..."
    exit 1
}
echo "Package installation successful."
echo

# Create shell scripts for easy access
echo "Creating command shortcuts..."
SCRIPT_DIR="$PYNOVA_DIR/bin"
mkdir -p "$SCRIPT_DIR"

# Create pynova script
cat > "$SCRIPT_DIR/pynova" << EOF
#!/bin/bash
python -m pynova_core.cli "\$@"
EOF

# Create pynova-ide script
cat > "$SCRIPT_DIR/pynova-ide" << EOF
#!/bin/bash
python -m pynova_ide.main "\$@"
EOF

# Create pynova-publish script
cat > "$SCRIPT_DIR/pynova-publish" << EOF
#!/bin/bash
python -m pynova_publisher.cli "\$@"
EOF

# Make the scripts executable
chmod +x "$SCRIPT_DIR/pynova"
chmod +x "$SCRIPT_DIR/pynova-ide"
chmod +x "$SCRIPT_DIR/pynova-publish"

echo "Command shortcuts created in $SCRIPT_DIR"
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

# Add to PATH
echo "Adding PyNova to your PATH in $SHELL_CONFIG..."

# Check if the PATH entry already exists
if grep -q "export PATH=.*$SCRIPT_DIR" "$SHELL_CONFIG"; then
    echo "PyNova is already in your PATH."
else
    echo "# PyNova Path" >> "$SHELL_CONFIG"
    echo "export PATH=\"\$PATH:$SCRIPT_DIR\"" >> "$SHELL_CONFIG"
    echo "Successfully added PyNova to your PATH."
fi
echo

echo "Installation complete!"
echo
echo "You may need to restart your terminal or run 'source $SHELL_CONFIG' for the PATH changes to take effect."
echo
echo "You can now use the following commands:"
echo "  pynova - Run the PyNova interpreter or execute PyNova files"
echo "  pynova-ide - Launch the PyNova IDE"
echo "  pynova-publish - Use the PyNova Publisher to package your applications"
echo

read -p "Press Enter to continue..."