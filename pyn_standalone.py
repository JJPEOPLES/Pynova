#!/usr/bin/env python3
"""
PyNova Standalone Interpreter - Run PyNova programs without any dependencies.

This script allows you to run PyNova code without installing the language.
It works on Windows, macOS, and Linux, and doesn't require any PyNova modules.

Usage:
    python pyn_standalone.py [options] filename.pyn
    
Options:
    --verbose   Show detailed execution information
    --repl      Start interactive REPL mode
    --help      Display help message
"""

import sys
import os
import argparse
import traceback

def execute_file(file_path, verbose=False):
    """
    Execute a PyNova file.
    
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
            print(f"Executing file: {file_path}")
        
        exec(source, globals_dict)
        
        if verbose:
            print(f"Execution completed successfully.")
        
        return 0
    
    except Exception as e:
        print(f"Error: {e}")
        if verbose:
            traceback.print_exc()
        return 1

def start_repl(verbose=False):
    """
    Start the PyNova REPL (Read-Eval-Print Loop).
    
    Args:
        verbose: Whether to show detailed execution information.
    
    Returns:
        The exit code.
    """
    print("PyNova REPL (Interactive Mode)")
    print("Type 'exit()' to quit")
    print()
    
    # Set up the globals dictionary
    globals_dict = {
        '__name__': '__main__',
    }
    
    while True:
        try:
            # Get user input
            source = input(">>> ")
            
            # Check if user wants to exit
            if source.strip() == 'exit()':
                break
            
            # Execute the source
            try:
                # Try to evaluate the expression
                result = eval(source, globals_dict)
                if result is not None:
                    print(result)
            except SyntaxError:
                # If it's not an expression, execute it as a statement
                try:
                    exec(source, globals_dict)
                except Exception as e:
                    print(f"Error: {e}")
                    if verbose:
                        traceback.print_exc()
            except Exception as e:
                print(f"Error: {e}")
                if verbose:
                    traceback.print_exc()
        
        except KeyboardInterrupt:
            print("\nKeyboardInterrupt")
        
        except EOFError:
            print("\nExiting...")
            break
    
    return 0

def main():
    """Main entry point for the PyNova interpreter."""
    # Parse command line arguments
    parser = argparse.ArgumentParser(description='PyNova Programming Language')
    parser.add_argument('file', nargs='?', help='PyNova file to execute')
    parser.add_argument('--verbose', action='store_true', help='Show detailed execution information')
    parser.add_argument('--repl', action='store_true', help='Start interactive REPL mode')
    
    args = parser.parse_args()
    
    # If no file is provided and --repl is not specified, start REPL
    if args.file is None and not args.repl:
        args.repl = True
    
    try:
        # Start REPL if requested
        if args.repl:
            return start_repl(verbose=args.verbose)
        
        # Execute file
        return execute_file(args.file, verbose=args.verbose)
    
    except Exception as e:
        print(f"Error: {e}")
        if args.verbose:
            traceback.print_exc()
        return 1

if __name__ == "__main__":
    sys.exit(main())