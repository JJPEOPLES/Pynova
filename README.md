# PyNova Syntax Extensions

PyNova is a programming language that extends Python with additional syntax and features while maintaining compatibility with the Python interpreter. This means you can run PyNova code directly with Python, but you get additional features when using the PyNova interpreter.

## Key Features

1. **Python Compatibility**: All PyNova code is valid Python code
2. **Extended Syntax**: PyNova adds new syntax elements that are ignored by Python
3. **Special Decorators**: PyNova has special decorators for optimization and safety
4. **Enhanced Type System**: PyNova extends Python's type annotations
5. **Documentation Features**: PyNova has additional comment styles for documentation

## Example Files

This repository includes two example files that demonstrate PyNova syntax:

1. **pynova_features.pyn**: Basic PyNova syntax features
2. **pynova_advanced.pyn**: Advanced PyNova features implemented as Python code

You can run these files with either Python or the PyNova interpreter:

```bash
# Run with Python
python pynova_features.pyn

# Run with PyNova
pyn3 pynova_features.pyn
```

## PyNova Syntax Elements

### Comments

PyNova supports Python-style comments plus additional comment styles:

```python
# Standard Python comment

## PyNova double-hash comment

#! PyNova warning comment

#> PyNova documentation comment
```

### Decorators

PyNova has special function decorators (shown here as comments for Python compatibility):

```python
# @pyn:fast  # In actual PyNova code, this would be uncommented
def optimized_function():
    # This function will be optimized by the PyNova JIT compiler
    pass

# @pyn:safe
def safe_function():
    # This function will have additional runtime checks
    pass

# @pyn:export
def api_function():
    # This function will be exposed in the module's public API
    pass
```

When using the PyNova interpreter, you can uncomment these decorators. For Python compatibility, we keep them commented and use regular Python decorators instead.

### Type Annotations

PyNova extends Python's type annotations:

```python
def calculate(x: num, y: num) -> num:
    return x + y

def process_text(text: str!) -> str:
    # The ! indicates non-nullable
    return text.upper()

def get_items() -> list<str>:
    # PyNova supports generic syntax with angle brackets
    return ["item1", "item2"]
```

### Special Imports

PyNova has a special import syntax:

```python
from @std import math
# The @ symbol indicates a built-in PyNova module

use math.advanced
# 'use' is an alternative to 'import'
```

## How It Works

When you run PyNova code with Python, the PyNova-specific syntax is either:

1. **Ignored**: Comments and string-based type annotations are ignored
2. **Interpreted as Python**: Decorators are treated as variable references or function calls
3. **Implemented as Python**: Special features are implemented as regular Python code

When you run PyNova code with the PyNova interpreter, the special syntax is recognized and provides additional features like optimization, safety checks, and enhanced type checking.

## Creating Your Own PyNova Code

To create PyNova code that works with both Python and the PyNova interpreter:

1. Use the `.pyn` file extension
2. Make sure all PyNova-specific syntax is compatible with Python
3. Implement PyNova features as regular Python code when needed
4. Use string-based type annotations for PyNova types

This approach gives you the best of both worlds: your code will run with Python, but it will have additional features when run with the PyNova interpreter.







# Section 2




# PyNova Programming Language
A modern Python extension language that adds powerful features while maintaining full compatibility with standard Python.

### Features
Python Compatibility: All PyNova code runs with standard Python
Extended Syntax: Additional language constructs for cleaner code
Enhanced Type System: More expressive type annotations
Performance Optimizations: Special decorators for faster execution
Safety Features: Built-in checks and validations
System Integration: Better access to system-level functionality
Installation Guide
Prerequisites
Python 3.6 or higher
pip (Python package manager)
Installation Steps
Install PyNova using pip:

pip install pynova
Verify installation:

pyn3 --version
Add PyNova to your PATH (optional but recommended):

Download add_pynova_to_path_robust.bat from the repository
Run it to add PyNova to your user PATH environment variable
No administrator privileges required
Important Note About PyNova Launchers
⚠️ Known Issues: The pyn.bat and pyn2.bat launchers have known bugs:

## Character encoding problems with non-ASCII text
Issues with command-line arguments
Path resolution errors
Elevation privilege problems
✅ Recommended: Use the pyn3.bat launcher which has been fixed and properly handles:

## File encoding
Command-line arguments
Path resolution
Automatic privilege elevation when needed
Getting Started
Create Your First PyNova Script
Create a file named hello.pyn with the following content:


"""
My first PyNova script
"""

## Standard Python code works perfectly
print("Hello from PyNova!")

## PyNova-specific features
def calculate(x: num, y: num) -> num:
    """Calculate the sum of two numbers using PyNova's num type"""
    return x + y

## Use PyNova's special syntax (commented for Python compatibility)
# @pyn:fast
def optimized_function():
    """This function will be optimized by PyNova"""
    result = 0
    for i in range(1000000):
        result += i
    return result

## Run the code
if __name__ == "__main__":
    print(f"5 + 10 = {calculate(5, 10)}")
    print(f"Optimized result: {optimized_function()}")
Run Your Script
# Using PyNova interpreter (recommended)
pyn3 hello.pyn

# Using standard Python (also works)
python hello.pyn
PyNova Tools and Examples
The PyNova package includes several example applications:

Calculator: Multi-functional calculator with standard, scientific, and unit conversion features
Bluetooth Emulator: Virtual Bluetooth environment for testing and development
File Explorer: Enhanced file management with PyNova features
Web Server: Simple HTTP server with PyNova optimizations
File Extensions
.pyn: Standard PyNova script files
.pynb: PyNova notebook files (similar to Jupyter notebooks)
.pyni: PyNova interface definition files
Troubleshooting
Common Issues
Encoding Errors: If you see errors like 'charmap' codec can't decode byte..., use pyn3 instead of pyn or pyn2
Path Issues: If PyNova commands aren't recognized, run add_pynova_to_path_robust.bat
Permission Errors: For scripts that need system access, use pyn3 --admin your_script.pyn
Fixing Launcher Issues
If you're experiencing issues with the launchers:

Use pyn3.bat instead of pyn.bat or pyn2.bat
For scripts that never need admin privileges, use pyn3_simple.bat
If you need to run with admin privileges, use pyn3 --admin your_script.pyn
Documentation
Full documentation is available at https://pynova.readthedocs.io/

##Community and Support
GitHub: https://github.com/JJPEOPLES/Pynova
Discord:Currently dont have
Stack Overflow: Tag your questions with pynova
##License
PyNova is released under the MIT License. See LICENSE file for details
