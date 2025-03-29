#!/bin/bash

echo "PyNova Path Setup"
echo "================="
echo

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "PyNova directory: $SCRIPT_DIR"
echo

# Create bin directory if it doesn't exist
BIN_DIR="$SCRIPT_DIR/bin"
if [ ! -d "$BIN_DIR" ]; then
    echo "Creating bin directory..."
    mkdir -p "$BIN_DIR"
    echo
fi

# Create pyn shell script
echo "Creating pyn shell script..."
cat > "$BIN_DIR/pyn" << 'EOF'
#!/bin/bash

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PYNOVA_DIR="$( dirname "$SCRIPT_DIR" )"

# Check if Python is installed
if ! command -v python3 &> /dev/null; then
    echo "Error: Python is not installed or not in PATH."
    echo "Please install Python 3.6 or higher to use PyNova."
    echo "You can run install.sh to install Python automatically."
    exit 1
fi

# Parse command line arguments
JIT_ENABLED=""
VERBOSE_MODE=""
REPL_MODE=""
FILENAME=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --jit)
            JIT_ENABLED="1"
            shift
            ;;
        --verbose)
            VERBOSE_MODE="1"
            shift
            ;;
        --repl)
            REPL_MODE="1"
            shift
            ;;
        --help)
            echo "PyNova Interpreter"
            echo "================="
            echo
            echo "Usage: pyn [options] filename.pyn"
            echo
            echo "Options:"
            echo "  --jit       Enable JIT compilation for faster execution"
            echo "  --verbose   Show detailed execution information"
            echo "  --help      Display this help message"
            echo
            echo "Examples:"
            echo "  pyn hello.pyn"
            echo "  pyn --jit examples/calculator.pyn"
            echo
            echo "To start the interactive REPL mode, run without a filename:"
            echo "  pyn --repl"
            echo
            exit 0
            ;;
        *)
            if [ -z "$FILENAME" ]; then
                FILENAME="$1"
            else
                echo "Warning: Multiple filenames provided. Only using $FILENAME."
            fi
            shift
            ;;
    esac
done

# If no filename and not in REPL mode, show help
if [ -z "$FILENAME" ] && [ -z "$REPL_MODE" ]; then
    REPL_MODE="1"
fi

# Set up the Python path to include the PyNova directory
export PYTHONPATH="$PYNOVA_DIR:$PYTHONPATH"

# Build the command based on options
CMD="python3 -m pynova_core.cli"
if [ -n "$JIT_ENABLED" ]; then
    CMD="$CMD --jit"
fi
if [ -n "$VERBOSE_MODE" ]; then
    CMD="$CMD --verbose"
fi
if [ -n "$REPL_MODE" ]; then
    CMD="$CMD --repl"
else
    # Check if the file exists
    if [ ! -f "$FILENAME" ]; then
        echo "Error: File not found: $FILENAME"
        exit 1
    fi
    
    echo "Running: $FILENAME"
    CMD="$CMD $FILENAME"
fi

# Run the interpreter
$CMD
exit $?
EOF

# Make the script executable
chmod +x "$BIN_DIR/pyn"
echo "Created executable script: $BIN_DIR/pyn"
echo

# Determine shell configuration file
SHELL_CONFIG=""
if [ -n "$ZSH_VERSION" ]; then
    SHELL_CONFIG="$HOME/.zshrc"
elif [ -n "$BASH_VERSION" ]; then
    if [ -f "$HOME/.bashrc" ]; then
        SHELL_CONFIG="$HOME/.bashrc"
    elif [ -f "$HOME/.bash_profile" ]; then
        SHELL_CONFIG="$HOME/.bash_profile"
    fi
else
    # Try to guess based on existing files
    if [ -f "$HOME/.zshrc" ]; then
        SHELL_CONFIG="$HOME/.zshrc"
    elif [ -f "$HOME/.bashrc" ]; then
        SHELL_CONFIG="$HOME/.bashrc"
    elif [ -f "$HOME/.bash_profile" ]; then
        SHELL_CONFIG="$HOME/.bash_profile"
    fi
fi

# Add to PATH
if [ -n "$SHELL_CONFIG" ]; then
    echo "Adding PyNova to PATH in $SHELL_CONFIG..."
    
    # Check if it's already in the PATH
    if grep -q "export PATH=\"\$PATH:$BIN_DIR\"" "$SHELL_CONFIG"; then
        echo "PyNova is already in your PATH."
    else
        echo "" >> "$SHELL_CONFIG"
        echo "# Add PyNova to PATH" >> "$SHELL_CONFIG"
        echo "export PATH=\"\$PATH:$BIN_DIR\"" >> "$SHELL_CONFIG"
        echo "Successfully added PyNova to your PATH."
    fi
else
    echo "Could not determine your shell configuration file."
    echo "Please add the following line to your shell configuration file:"
    echo "export PATH=\"\$PATH:$BIN_DIR\""
fi

echo
echo "To use PyNova, open a new terminal and type:"
echo "  pyn --help"
echo
echo "Note: You need to open a new terminal or run 'source $SHELL_CONFIG' for the PATH changes to take effect."
echo