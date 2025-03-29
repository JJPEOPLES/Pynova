# PyNova Standalone Interpreter (pyn.bat)

The `pyn.bat` script allows you to run PyNova code without installing the language. It's a standalone script that you can use to interpret PyNova files directly.

## Usage

```
pyn.bat [options] filename.pyn
```

### Options

- `--jit`: Enable JIT compilation for faster execution
- `--verbose`: Show detailed execution information
- `--help`: Display help message
- `--repl`: Start the interactive REPL mode

### Examples

Run a PyNova file:
```
pyn.bat hello_world.pyn
```

Run a PyNova file with JIT compilation:
```
pyn.bat --jit calculator.pyn
```

Start the interactive REPL mode:
```
pyn.bat --repl
```

## How It Works

The `pyn.bat` script:

1. Checks if Python is installed
2. Sets up the environment to find the PyNova modules
3. Runs the PyNova interpreter on the specified file

## No Installation Required

The beauty of `pyn.bat` is that it doesn't require you to install PyNova. It works directly from the directory where you have the PyNova source code.

## Requirements

- Python 3.6 or higher
- The PyNova source code directory

## Example Files

Try running these example files:

- `examples/hello_world.pyn`: A simple "Hello World" program
- `examples/calculator.pyn`: A command-line calculator
- `examples/simple_gui.pyn`: A simple GUI calculator (requires PyQt5)

## Troubleshooting

If you encounter any issues:

1. Make sure Python 3.6+ is installed and in your PATH
2. Check that you're running the script from the PyNova directory
3. Try running with the `--verbose` flag for more detailed error information

If you need to install Python, you can run the `install.bat` script which will install Python 3.11 automatically.