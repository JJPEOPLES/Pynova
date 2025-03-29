@echo off
echo ===================================
echo       PyNova IDE Launcher
echo ===================================
echo.

:: Check if Python is installed
python --version >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Python is not installed or not in your PATH.
    echo Please install Python 3.6 or higher and try again.
    echo.
    pause
    exit /b 1
)

:: Set the current directory to the script directory
cd /d "%~dp0"

:: Check if required packages are installed
echo Checking required packages...

:: Check PyQt5
python -c "import PyQt5" >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo Installing PyQt5...
    pip install PyQt5
    if %ERRORLEVEL% NEQ 0 (
        echo ERROR: Failed to install PyQt5.
        pause
        exit /b 1
    )
)

:: Check numba (optional, for JIT compilation)
python -c "import numba" >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo NOTE: Numba is not installed. JIT compilation will be disabled.
    echo If you want to enable JIT compilation, install Numba with:
    echo pip install numba
    echo.
)

:: Launch the IDE
echo.
echo Launching PyNova IDE...
echo.
python pynova_ide/main.py

:: If the IDE crashes, show an error
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ERROR: PyNova IDE exited with an error (code %ERRORLEVEL%).
    echo Please check the error message above.
    echo.
    pause
)