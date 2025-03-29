
"""
PyNova Direct Runner v3.1 - Run PyNova programs directly with Python.

This script allows you to run PyNova code as if it were Python code.
It's useful when the PyNova interpreter is having issues with syntax.

Usage:
    python run_pynova_direct.py filename.pyn
    or
    pyn3 filename.pyn

Options:
    --verbose   Show detailed execution information
    --help      Display help message
"""

import sys
import os
import argparse
import traceback

def execute_file(file_path, verbose=False):
    """
    Execute a PyNova file directly with Python.
    
    Args:
        file_path: Path to the PyNova file.
        verbose: Whether to show detailed execution information.
    
    Returns:
        The exit code.
    """
    try:
        # Check if file exists
        if not os.path.exists(file_path):
            print(f"Error: File not found: {file_path}")
            return 1
        
        # Check file extension
        if not file_path.endswith('.pyn'):
            print(f"Warning: File does not have .pyn extension: {file_path}")
        
        # Read the file
        with open(file_path, 'r') as f:
            source = f.read()
        
        # Set up the globals dictionary
        globals_dict = {
            '__name__': '__main__',
            '__file__': file_path,
        }
        
        # Execute the source
        if verbose:
            print(f"PyNova Direct Runner v3.1")
            print(f"Executing file: {file_path}")
        else:
            print(f"PyNova v3.1")

        exec(source, globals_dict)

        if verbose:
            print(f"Execution completed successfully.")
        
        return 0
    
    except Exception as e:
        print(f"Error: {e}")
        if verbose:
            traceback.print_exc()
        return 1

def main():
    """Main entry point for the PyNova direct runner."""
    # Parse command line arguments
    parser = argparse.ArgumentParser(description='PyNova Direct Runner v3.1 - Run PyNova programs directly with Python')
    parser.add_argument('file', nargs='?', help='PyNova file to execute')
    parser.add_argument('--verbose', action='store_true', help='Show detailed execution information')
    parser.add_argument('--version', action='store_true', help='Show version information')

    args = parser.parse_args()

    # Show version information if requested
    if args.version:
        print("PyNova Direct Runner v3.1")
        print("Run PyNova programs directly with Python")
        return 0

    # Check if a file was provided
    if args.file is None:
        parser.print_help()
        return 1

    # Execute the file
    return execute_file(args.file, verbose=args.verbose)

if __name__ == "__main__":
    sys.exit(main())