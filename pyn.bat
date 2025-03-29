@echo off
rem PyNova Interpreter - Run PyNova programs without installation
rem Usage: pyn.bat [options] filename.pyn

rem Get the directory where this batch file is located
set "PYNOVA_DIR=%~dp0"
set "PYNOVA_DIR=%PYNOVA_DIR:~0,-1%"

rem Check if Python is installed
python --version >nul 2>&1
if errorlevel 1 (
    echo Error: Python is not installed or not in PATH.
    echo Please install Python 3.6 or higher to use PyNova.
    pause
    exit /b 1
)

rem Run the standalone Python script with all arguments
python "%PYNOVA_DIR%\pyn_standalone.py" %*
exit /b %errorlevel%