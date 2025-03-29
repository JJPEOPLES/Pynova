@echo off
setlocal enabledelayedexpansion

:: Get the current directory where the script is located
set "SCRIPT_DIR=%~dp0"
set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"

echo PyNova Path Setup Utility
echo ========================
echo.
echo This script will add PyNova to your user PATH environment variable.
echo No administrator privileges required.
echo.

:: Check if PyNova is already in the PATH
set "PATH_CONTAINS_PYNOVA=0"
echo Checking if PyNova is already in your PATH...

:: Directly check if SCRIPT_DIR is in PATH without using for loop
echo %PATH%|findstr /C:"%SCRIPT_DIR%" >nul
if %errorlevel% equ 0 (
    set "PATH_CONTAINS_PYNOVA=1"
)

if "%PATH_CONTAINS_PYNOVA%" == "1" (
    echo.
    echo PyNova is already in your PATH.
    echo Current location: %SCRIPT_DIR%
    goto :end
)

:: Add PyNova to the user PATH
echo.
echo Adding PyNova to your user PATH...

:: Try to get the user PATH from registry
set "USER_PATH="
reg query "HKCU\Environment" /v PATH >nul 2>&1
if %errorlevel% equ 0 (
    for /f "skip=2 tokens=2*" %%a in ('reg query "HKCU\Environment" /v PATH 2^>nul') do set "USER_PATH=%%b"
)

:: If user PATH doesn't exist or couldn't be retrieved, create it
if not defined USER_PATH (
    echo Creating new user PATH with PyNova...
    setx PATH "%SCRIPT_DIR%"
) else (
    :: Check if PATH ends with a semicolon
    if "%USER_PATH:~-1%" == ";" (
        setx PATH "%USER_PATH%%SCRIPT_DIR%"
    ) else (
        setx PATH "%USER_PATH%;%SCRIPT_DIR%"
    )
)

if %ERRORLEVEL% EQU 0 (
    echo.
    echo Success! PyNova has been added to your user PATH.
    echo Location: %SCRIPT_DIR%
    echo.
    echo Please restart any open command prompts or applications
    echo for the new PATH to take effect.
) else (
    echo.
    echo Error: Failed to update PATH environment variable.
    echo Please try running this script again.
)

:end
echo.
echo Creating pyn3.bat launcher...

:: Create the pyn3.bat file if it doesn't exist
if not exist "%SCRIPT_DIR%\pyn3.bat" (
    (
        echo @echo off
        echo setlocal
        echo.
        echo :: Get the directory where this batch file is located
        echo set "SCRIPT_DIR=%%~dp0"
        echo.
        echo :: Run PyNova with elevated privileges if needed
        echo if "%%1" == "--admin" ^(
        echo     shift
        echo     powershell -Command "Start-Process -FilePath 'python' -ArgumentList '%%SCRIPT_DIR%%pynova.py %%*' -Verb RunAs"
        echo ^) else ^(
        echo     python "%%SCRIPT_DIR%%pynova.py" %%*
        echo ^)
        echo.
        echo endlocal
    ) > "%SCRIPT_DIR%\pyn3.bat"
    echo pyn3.bat created successfully.
) else (
    echo pyn3.bat already exists.
)

echo.
echo You can now run PyNova from any directory using:
echo   pyn3 your_script.pyn
echo.
echo To run with administrator privileges (when needed):
echo   pyn3 --admin your_script.pyn
echo.
echo Press any key to exit...
pause > nul

endlocal