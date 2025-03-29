@echo off
setlocal enabledelayedexpansion

echo PyNova Installer
echo ===============
echo.

:: Check for admin privileges
net session >nul 2>&1
if %errorLevel% == 0 (
    set "ADMIN=yes"
) else (
    set "ADMIN=no"
    echo Note: Not running with administrator privileges.
    echo Some features may require administrator rights.
    echo.
)

:: Get the current directory (where PyNova is installed)
set "PYNOVA_DIR=%~dp0"
set "PYNOVA_DIR=%PYNOVA_DIR:~0,-1%"
echo Installing PyNova from: %PYNOVA_DIR%
echo.

:: Check if Python is installed
echo Checking for Python installation...
python --version >nul 2>&1
if %errorLevel% NEQ 0 (
    goto INSTALL_PYTHON
)

:: Python is installed, check version
for /f "tokens=2" %%V in ('python --version 2^>^&1') do set "PYTHON_VERSION=%%V"
echo Found Python %PYTHON_VERSION%

:: Check if it's Python 3.x
echo %PYTHON_VERSION% | findstr /B /C:"3." >nul
if %errorLevel% NEQ 0 (
    echo Warning: PyNova requires Python 3.6 or higher.
    echo Current version: %PYTHON_VERSION%
    echo.
    echo Would you like to install Python 3.11? (Y/N)
    set /p INSTALL_PYTHON=
    if /i "!INSTALL_PYTHON!"=="Y" (
        goto INSTALL_PYTHON
    )
) else (
    :: Check if it's less than 3.6
    echo %PYTHON_VERSION% | findstr /B /C:"3.0" /C:"3.1" /C:"3.2" /C:"3.3" /C:"3.4" /C:"3.5" >nul
    if %errorLevel% EQU 0 (
        echo Warning: PyNova requires Python 3.6 or higher.
        echo Current version: %PYTHON_VERSION%
        echo.
        echo Would you like to install Python 3.11? (Y/N)
        set /p INSTALL_PYTHON=
        if /i "!INSTALL_PYTHON!"=="Y" (
            goto INSTALL_PYTHON
        )
    )
)

:: Check if pip is installed
echo Checking for pip installation...
pip --version >nul 2>&1
if %errorLevel% NEQ 0 (
    goto INSTALL_PIP
)

echo pip is already installed.
goto INSTALL_PACKAGES

:INSTALL_PYTHON
echo Python is not installed or needs to be updated.
echo Installing Python 3.11...

:: Create a temporary directory for downloads
set "TEMP_DIR=%TEMP%\pynova_install"
mkdir "%TEMP_DIR%" 2>nul

:: Download Python 3.11 installer
echo Downloading Python 3.11 installer...
powershell -Command "& {Invoke-WebRequest -Uri 'https://www.python.org/ftp/python/3.11.0/python-3.11.0-amd64.exe' -OutFile '%TEMP_DIR%\python_installer.exe'}"

if %errorLevel% NEQ 0 (
    echo Failed to download Python installer.
    echo Please install Python 3.11 manually from https://www.python.org/downloads/
    pause
    exit /b 1
)

:: Install Python
echo Installing Python 3.11...
if "%ADMIN%"=="yes" (
    :: Install for all users if we have admin rights
    "%TEMP_DIR%\python_installer.exe" /quiet InstallAllUsers=1 PrependPath=1 Include_test=0
) else (
    :: Install for current user only
    "%TEMP_DIR%\python_installer.exe" /quiet InstallAllUsers=0 PrependPath=1 Include_test=0
)

if %errorLevel% NEQ 0 (
    echo Failed to install Python.
    echo Please install Python 3.11 manually from https://www.python.org/downloads/
    pause
    exit /b 1
)

echo Python 3.11 installed successfully.

:: Clean up
rmdir /s /q "%TEMP_DIR%" 2>nul

:: Update PATH for the current session
set "PATH=%PATH%;%LOCALAPPDATA%\Programs\Python\Python311;%LOCALAPPDATA%\Programs\Python\Python311\Scripts"

goto CHECK_PIP

:CHECK_PIP
:: Check if pip is installed
echo Checking for pip installation...
pip --version >nul 2>&1
if %errorLevel% NEQ 0 (
    goto INSTALL_PIP
)

echo pip is already installed.
goto INSTALL_PACKAGES

:INSTALL_PIP
echo pip is not installed or not in PATH.
echo Installing pip...

:: Download get-pip.py
echo Downloading pip installer...
powershell -Command "& {Invoke-WebRequest -Uri 'https://bootstrap.pypa.io/get-pip.py' -OutFile '%TEMP%\get-pip.py'}"

if %errorLevel% NEQ 0 (
    echo Failed to download pip installer.
    echo Please install pip manually.
    pause
    exit /b 1
)

:: Install pip
echo Installing pip...
python "%TEMP%\get-pip.py"

if %errorLevel% NEQ 0 (
    echo Failed to install pip.
    echo Please install pip manually.
    pause
    exit /b 1
)

echo pip installed successfully.

:: Clean up
del "%TEMP%\get-pip.py" 2>nul

goto INSTALL_PACKAGES

:INSTALL_PACKAGES
:: Install required packages
echo Installing required packages...
pip install numba PyQt5 ply

:: Install the PyNova package
echo Installing PyNova Python package...
pip install -e "%PYNOVA_DIR%"
if %errorLevel% NEQ 0 (
    echo Error: Failed to install the PyNova package.
    echo Please check the error message above and try again.
    pause
    exit /b 1
)
echo Package installation successful.
echo.

goto SETUP_COMMANDS

:SETUP_COMMANDS
:: Create batch files for easy access
echo Creating command shortcuts...
set "BATCH_DIR=%PYNOVA_DIR%\bin"
if not exist "%BATCH_DIR%" mkdir "%BATCH_DIR%"

:: Create pynova.bat
echo @echo off > "%BATCH_DIR%\pynova.bat"
echo python -m pynova_core.cli %%* >> "%BATCH_DIR%\pynova.bat"

:: Create pynova-ide.bat
echo @echo off > "%BATCH_DIR%\pynova-ide.bat"
echo python -m pynova_ide.main %%* >> "%BATCH_DIR%\pynova-ide.bat"

:: Create pynova-publish.bat
echo @echo off > "%BATCH_DIR%\pynova-publish.bat"
echo python -m pynova_publisher.cli %%* >> "%BATCH_DIR%\pynova-publish.bat"

echo Command shortcuts created in %BATCH_DIR%
echo.

:: Add to PATH
if "%ADMIN%"=="yes" (
    echo Adding PyNova to system PATH...
    setx PATH "%PATH%;%BATCH_DIR%" /M
    set "PATH_TYPE=system"
) else (
    echo Adding PyNova to user PATH...
    setx PATH "%PATH%;%BATCH_DIR%"
    set "PATH_TYPE=user"
)

if %errorLevel% == 0 (
    echo Successfully added PyNova to your %PATH_TYPE% PATH.
) else (
    echo Warning: Failed to add PyNova to your PATH.
    echo You can manually add the following directory to your PATH:
    echo %BATCH_DIR%
)
echo.

echo Installation complete!
echo.
echo You may need to restart your command prompt for the PATH changes to take effect.
echo.
echo You can now use the following commands:
echo   pynova - Run the PyNova interpreter or execute PyNova files
echo   pynova-ide - Launch the PyNova IDE
echo   pynova-publish - Use the PyNova Publisher to package your applications
echo.

pause