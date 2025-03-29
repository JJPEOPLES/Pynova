#!/usr/bin/env python3
"""
PyNova Interpreter - Cross-platform script to run PyNova programs.

This script allows you to run PyNova code without installing the language.
It works on Windows, macOS, and Linux.

Usage:
    python pyn.py [options] filename.pyn
    
Options:
    --jit       Enable JIT compilation for faster execution
    --verbose   Show detailed execution information
    --repl      Start interactive REPL mode
    --help      Display help message
"""

import sys
import os
import argparse

def main():
    """Main entry point for the PyNova interpreter."""
    # Add the current directory to the Python path
    script_dir = os.path.dirname(os.path.abspath(__file__))
    sys.path.insert(0, script_dir)
    
    # Parse command line arguments
    parser = argparse.ArgumentParser(description='PyNova Programming Language')
    parser.add_argument('file', nargs='?', help='PyNova file to execute')
    parser.add_argument('--jit', action='store_true', help='Enable JIT compilation')
    parser.add_argument('--verbose', action='store_true', help='Show detailed execution information')
    parser.add_argument('--repl', action='store_true', help='Start interactive REPL mode')
    
    args = parser.parse_args()
    
    # If no file is provided and --repl is not specified, start REPL
    if args.file is None and not args.repl:
        args.repl = True
    
    try:
        # Check if pynova_core exists
        if not os.path.exists(os.path.join(script_dir, 'pynova_core')):
            # Try to find it in parent directories
            parent_dir = os.path.dirname(script_dir)
            if os.path.exists(os.path.join(parent_dir, 'pynova_core')):
                sys.path.insert(0, parent_dir)
        
        # Import the PyNova CLI module
        try:
            from pynova_core.cli import start_repl, execute_file
        except ImportError:
            # If we can't import directly, try to run the module files directly
            print("Note: Using direct module execution mode.")
            
            # Define the execute_file function
            def execute_file(file_path, jit=False, verbose=False):
                if not os.path.exists(file_path):
                    print(f"Error: File not found: {file_path}")
                    return 1
                
                with open(file_path, 'r') as f:
                    code = f.read()
                
                # Execute the code directly
                try:
                    exec(code, {'__name__': '__main__'})
                    return 0
                except Exception as e:
                    print(f"Error executing file: {e}")
                    if verbose:
                        import traceback
                        traceback.print_exc()
                    return 1
            
            # Define the start_repl function
            def start_repl(jit=False, verbose=False):
                print("PyNova REPL (Interactive Mode)")
                print("Type 'exit()' to quit")
                print()
                
                while True:
                    try:
                        # Get user input
                        code = input(">>> ")
                        
                        # Check if user wants to exit
                        if code.strip() == 'exit()':
                            break
                        
                        # Execute the code
                        try:
                            result = eval(code)
                            if result is not None:
                                print(result)
                        except:
                            try:
                                exec(code)
                            except Exception as e:
                                print(f"Error: {e}")
                                if verbose:
                                    import traceback
                                    traceback.print_exc()
                    
                    except KeyboardInterrupt:
                        print("\nKeyboardInterrupt")
                    
                    except EOFError:
                        print("\nExiting...")
                        break
                
                return 0
        
        # Start REPL if requested
        if args.repl:
            return start_repl(jit=args.jit, verbose=args.verbose)
        
        # Execute file
        return execute_file(args.file, jit=args.jit, verbose=args.verbose)
    
    except ImportError as e:
        print(f"Error: Could not import PyNova modules. {e}")
        print("Make sure you're running this script from the PyNova directory.")
        return 1
    
    except Exception as e:
        print(f"Error: {e}")
        if args.verbose:
            import traceback
            traceback.print_exc()
        return 1

if __name__ == "__main__":
    sys.exit(main())