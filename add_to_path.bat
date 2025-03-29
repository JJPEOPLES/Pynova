@echo off
rem PyNova Path Setup - Add PyNova to your PATH

echo PyNova Path Setup
echo ================
echo.

rem Check for admin privileges
net session >nul 2>&1
if errorlevel 1 (
    echo Note: Not running with administrator privileges.
    echo The script will add PyNova to your user PATH instead of system PATH.
    echo.
    set "ADMIN=no"
) else (
    set "ADMIN=yes"
)

rem Get the current directory (where PyNova is installed)
set "PYNOVA_DIR=%~dp0"
set "PYNOVA_DIR=%PYNOVA_DIR:~0,-1%"
echo PyNova directory: %PYNOVA_DIR%
echo.

rem Create bin directory if it doesn't exist
set "BIN_DIR=%PYNOVA_DIR%\bin"
if not exist "%BIN_DIR%" (
    echo Creating bin directory...
    mkdir "%BIN_DIR%"
    echo.
)

rem Copy pyn.bat to bin directory
echo Copying pyn.bat to bin directory...
copy "%PYNOVA_DIR%\pyn.bat" "%BIN_DIR%\pyn.bat" >nul
echo.

rem Add to PATH
if "%ADMIN%"=="yes" (
    echo Adding PyNova to system PATH...
    setx PATH "%PATH%;%BIN_DIR%" /M
    set "PATH_TYPE=system"
) else (
    echo Adding PyNova to user PATH...
    setx PATH "%PATH%;%BIN_DIR%"
    set "PATH_TYPE=user"
)

if errorlevel 1 (
    echo.
    echo Warning: Failed to add PyNova to your PATH.
    echo You can manually add the following directory to your PATH:
    echo %BIN_DIR%
) else (
    echo.
    echo Successfully added PyNova to your %PATH_TYPE% PATH.
    echo You can now use the 'pyn' command from any directory.
)
echo.

echo To use PyNova, open a new command prompt and type:
echo   pyn --help
echo.

echo Note: You need to open a new command prompt for the PATH changes to take effect.
echo.

pause