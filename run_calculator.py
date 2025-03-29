"""
Simple script to run the calculator directly.
"""

import subprocess
import sys
import os

def main():
    print("Running Calculator...")
    
    # Get the path to the calculator.py file
    calculator_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "calculator.py")
    
    # Run the calculator using the system's Python interpreter
    try:
        subprocess.run([sys.executable, calculator_path], check=True)
    except subprocess.CalledProcessError as e:
        print(f"Error running calculator: {e}")
        input("Press Enter to exit...")
    except Exception as e:
        print(f"Unexpected error: {e}")
        input("Press Enter to exit...")

if __name__ == "__main__":
    main()