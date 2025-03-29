@echo off
setlocal enabledelayedexpansion

:: Set title and colors
title PyNova IDE Launcher
color 0B

:: Clear screen and show header
cls
echo ===================================
echo       PyNova IDE Launcher
echo ===================================
echo.

:: Check if Python is installed
echo Checking Python installation...
python --version >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    color 0C
    echo ERROR: Python is not installed or not in your PATH.
    echo Please install Python 3.6 or higher and try again.
    echo.
    echo Press any key to exit...
    pause >nul
    exit /b 1
) else (
    for /f "tokens=2" %%i in ('python --version 2^>^&1') do set PYTHON_VERSION=%%i
    echo Found Python !PYTHON_VERSION!
)

:: Create virtual environment if it doesn't exist
if not exist "venv" (
    echo Creating virtual environment...
    python -m venv venv
    if %ERRORLEVEL% NEQ 0 (
        color 0C
        echo ERROR: Failed to create virtual environment.
        echo.
        echo Press any key to exit...
        pause >nul
        exit /b 1
    )
)

:: Activate virtual environment
echo Activating virtual environment...
call venv\Scripts\activate.bat

:: Check if required packages are installed
echo Checking required packages...

:: Check PyQt5
python -c "import PyQt5" >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo Installing PyQt5...
    pip install PyQt5
    if %ERRORLEVEL% NEQ 0 (
        color 0C
        echo ERROR: Failed to install PyQt5.
        echo.
        echo Press any key to exit...
        pause >nul
        exit /b 1
    )
)

:: Install any other required packages
echo Installing other required packages...
pip install -r requirements.txt 2>nul

:: Set the current directory to the script directory
cd /d "%~dp0"

:: Create desktop shortcut
echo Creating desktop shortcut...
set SCRIPT_PATH=%~f0
set DESKTOP_PATH=%USERPROFILE%\Desktop
set SHORTCUT_PATH=%DESKTOP_PATH%\PyNova IDE.lnk

if not exist "%SHORTCUT_PATH%" (
    echo Set oWS = WScript.CreateObject("WScript.Shell") > CreateShortcut.vbs
    echo sLinkFile = "%SHORTCUT_PATH%" >> CreateShortcut.vbs
    echo Set oLink = oWS.CreateShortcut(sLinkFile) >> CreateShortcut.vbs
    echo oLink.TargetPath = "%SCRIPT_PATH%" >> CreateShortcut.vbs
    echo oLink.WorkingDirectory = "%~dp0" >> CreateShortcut.vbs
    echo oLink.Description = "PyNova IDE" >> CreateShortcut.vbs
    echo oLink.IconLocation = "%SystemRoot%\System32\SHELL32.dll,41" >> CreateShortcut.vbs
    echo oLink.Save >> CreateShortcut.vbs
    cscript //nologo CreateShortcut.vbs
    del CreateShortcut.vbs
    echo Desktop shortcut created.
) else (
    echo Desktop shortcut already exists.
)

:: Show menu
:menu
cls
echo ===================================
echo       PyNova IDE Launcher
echo ===================================
echo.
echo [1] Launch PyNova IDE
echo [2] Install/Update Dependencies
echo [3] Open Examples Folder
echo [4] Create New PyNova Project
echo [5] Exit
echo.
set /p CHOICE="Enter your choice (1-5): "

if "%CHOICE%"=="1" goto launch_ide
if "%CHOICE%"=="2" goto install_deps
if "%CHOICE%"=="3" goto open_examples
if "%CHOICE%"=="4" goto create_project
if "%CHOICE%"=="5" goto end

echo Invalid choice. Please try again.
timeout /t 2 >nul
goto menu

:launch_ide
cls
echo ===================================
echo       Launching PyNova IDE
echo ===================================
echo.
python pynova_ide/main.py

:: If the IDE crashes, show an error
if %ERRORLEVEL% NEQ 0 (
    color 0C
    echo.
    echo ERROR: PyNova IDE exited with an error (code %ERRORLEVEL%).
    echo.
    pause
)
goto menu

:install_deps
cls
echo ===================================
echo    Installing Dependencies
echo ===================================
echo.
pip install -r requirements.txt
echo.
echo Dependencies installed/updated.
echo.
pause
goto menu

:open_examples
cls
echo ===================================
echo    Opening Examples Folder
echo ===================================
echo.
start "" "examples"
goto menu

:create_project
cls
echo ===================================
echo    Create New PyNova Project
echo ===================================
echo.
set /p PROJECT_NAME="Enter project name: "
if not exist "projects" mkdir projects
if not exist "projects\%PROJECT_NAME%" (
    mkdir "projects\%PROJECT_NAME%"
    echo # %PROJECT_NAME% > "projects\%PROJECT_NAME%\main.pyn"
    echo # Created with PyNova IDE >> "projects\%PROJECT_NAME%\main.pyn"
    echo. >> "projects\%PROJECT_NAME%\main.pyn"
    echo def main(): >> "projects\%PROJECT_NAME%\main.pyn"
    echo     print("Hello from %PROJECT_NAME%!") >> "projects\%PROJECT_NAME%\main.pyn"
    echo. >> "projects\%PROJECT_NAME%\main.pyn"
    echo if __name__ == "__main__": >> "projects\%PROJECT_NAME%\main.pyn"
    echo     main() >> "projects\%PROJECT_NAME%\main.pyn"
    
    echo Project created successfully.
    echo.
    set /p OPEN_IDE="Open project in IDE? (Y/N): "
    if /i "%OPEN_IDE%"=="Y" (
        start "" "%~f0" "projects\%PROJECT_NAME%\main.pyn"
    )
) else (
    echo Project already exists.
)
echo.
pause
goto menu

:end
echo.
echo Thank you for using PyNova IDE!
echo.
endlocal