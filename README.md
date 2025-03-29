# PyNova Programming Language

PyNova is a Python-like programming language designed for simplicity, performance, and modern development practices.

## Quick Start

### Windows

1. Run `add_to_path.bat` to add PyNova to your PATH
2. Open a new command prompt
3. Run `pyn --help` to see available commands
4. Try an example: `pyn examples/hello_world.pyn`

### macOS/Linux

1. Run `chmod +x add_to_path.sh` to make the script executable
2. Run `./add_to_path.sh` to add PyNova to your PATH
3. Open a new terminal
4. Run `pyn --help` to see available commands
5. Try an example: `pyn examples/hello_world.pyn`

### Cross-platform (Python)

If you prefer a cross-platform solution:

1. Navigate to the PyNova directory
2. Run `python pyn.py examples/hello_world.pyn`

## Installation

### Full Installation

To install PyNova with all its components:

#### Windows

```
install.bat
```

#### macOS/Linux

```
chmod +x install.sh
./install.sh
```

### No Installation Required

You can use PyNova without installing it:

#### Windows

```
pyn.bat examples/hello_world.pyn
```

#### macOS/Linux

```
python3 pyn.py examples/hello_world.pyn
```

## Features

- Python-like syntax for ease of learning
- Dynamic typing
- Object-oriented programming with classes and inheritance
- Functional programming capabilities
- Exception handling
- File I/O operations
- GUI programming with PyQt5
- Package management system
- JIT compilation for improved performance

## Examples

### Hello World

```python
# Hello World example in PyNova
def main():
    print("Hello, World!")
    return 0

if __name__ == "__main__":
    main()
```

### Simple Calculator

```python
# Simple calculator in PyNova
def add(a, b):
    return a + b

def subtract(a, b):
    return a - b

def main():
    print("PyNova Calculator")
    print("================")
    
    a = float(input("Enter first number: "))
    b = float(input("Enter second number: "))
    
    print(f"{a} + {b} = {add(a, b)}")
    print(f"{a} - {b} = {subtract(a, b)}")
    
    return 0

if __name__ == "__main__":
    main()
```

## Documentation

- [Language Reference](docs/language_reference.md) - Complete language syntax and features
- [Getting Started Guide](docs/getting_started.md) - Tutorial for beginners
- [Installation Guide](docs/installation.md) - Detailed installation instructions

## IDE

PyNova comes with a full-featured IDE:

```
pynova-ide
```

Features include:
- Syntax highlighting
- Code completion
- Project management
- Integrated debugger
- Run and test within the IDE

## Package Management

PyNova includes a built-in package manager:

```
pynova-pm install package-name
```

## Publishing Applications

Package and distribute your PyNova applications:

```
pynova-publish myapp
```

## System Requirements

- Python 3.6 or higher (Python 3.11 recommended)
- 64-bit operating system (Windows, macOS, or Linux)
- 4GB RAM minimum (8GB recommended)
- 500MB disk space

## License

PyNova is released under the MIT License. See the LICENSE file for details.