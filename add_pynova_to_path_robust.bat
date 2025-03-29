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

:: Check if PyNova is already in the PATH using a simpler method
echo Checking if PyNova is already in your PATH...
set "PATH_CONTAINS_PYNOVA=0"

:: Use findstr to search for the path in the PATH variable
echo %PATH%|findstr /C:"%SCRIPT_DIR%" >nul 2>&1
if %errorlevel% equ 0 (
    set "PATH_CONTAINS_PYNOVA=1"
    echo.
    echo PyNova is already in your PATH.
    echo Current location: %SCRIPT_DIR%
    goto :create_launcher
)

:: Add PyNova to the user PATH
echo.
echo Adding PyNova to your user PATH...

:: Create a temporary file to store the PowerShell command
set "TEMP_PS_FILE=%TEMP%\add_to_path.ps1"

:: Create a PowerShell script to safely modify the PATH
(
    echo $currentPath = [Environment]::GetEnvironmentVariable('PATH', 'User'^)
    echo $pynovaPath = '%SCRIPT_DIR%'
    echo.
    echo # Check if the path is already in the PATH
    echo if ($currentPath -notlike "*$pynovaPath*"^) {
    echo     # Add the path
    echo     if ($currentPath.EndsWith(';'^)^) {
    echo         $newPath = $currentPath + $pynovaPath
    echo     } else {
    echo         $newPath = $currentPath + ';' + $pynovaPath
    echo     }
    echo     [Environment]::SetEnvironmentVariable('PATH', $newPath, 'User'^)
    echo     Write-Host "PyNova added to PATH successfully."
    echo } else {
    echo     Write-Host "PyNova is already in PATH."
    echo }
) > "%TEMP_PS_FILE%"

:: Execute the PowerShell script
powershell -ExecutionPolicy Bypass -File "%TEMP_PS_FILE%"

:: Check if the operation was successful
if %errorlevel% equ 0 (
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

:: Clean up the temporary file
del "%TEMP_PS_FILE%" >nul 2>&1

:create_launcher
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
        echo :: Check if we need to run with admin privileges
        echo set "NEED_ADMIN=0"
        echo.
        echo :: Check for explicit admin flag
        echo if "%%1" == "--admin" (
        echo     set "NEED_ADMIN=1"
        echo     shift
        echo ^)
        echo.
        echo :: Run with appropriate privileges
        echo if "%%NEED_ADMIN%%" == "1" (
        echo     echo Running with administrator privileges...
        echo     powershell -Command "Start-Process -FilePath 'python' -ArgumentList '%%SCRIPT_DIR%%pynova.py %%*' -Verb RunAs"
        echo ^) else (
        echo     python "%%SCRIPT_DIR%%pynova.py" %%*
        echo ^)
        echo.
        echo endlocal
    ) > "%SCRIPT_DIR%\pyn3.bat"
    echo pyn3.bat created successfully.
) else (
    echo pyn3.bat already exists.
)

:: Create a simple version that never requires admin privileges
if not exist "%SCRIPT_DIR%\pyn3_simple.bat" (
    (
        echo @echo off
        echo setlocal
        echo.
        echo :: Get the directory where this batch file is located
        echo set "SCRIPT_DIR=%%~dp0"
        echo.
        echo :: Run PyNova with the Python interpreter
        echo python "%%SCRIPT_DIR%%pynova.py" %%*
        echo.
        echo endlocal
    ) > "%SCRIPT_DIR%\pyn3_simple.bat"
    echo pyn3_simple.bat created successfully.
)

echo.
echo You can now run PyNova from any directory using:
echo   pyn3 your_script.pyn
echo.
echo To run with administrator privileges (when needed):
echo   pyn3 --admin your_script.pyn
echo.
echo For scripts that never need admin privileges:
echo   pyn3_simple your_script.pyn
echo.
echo Press any key to exit...
pause > nul

endlocal