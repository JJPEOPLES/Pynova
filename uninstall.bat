@echo off
setlocal enabledelayedexpansion

echo PyNova Uninstaller
echo =================
echo.

:: Get the current directory (where PyNova is installed)
set "PYNOVA_DIR=%~dp0"
set "PYNOVA_DIR=%PYNOVA_DIR:~0,-1%"
set "BATCH_DIR=%PYNOVA_DIR%\bin"

echo Uninstalling PyNova from: %PYNOVA_DIR%
echo.

:: Uninstall the Python package
echo Uninstalling PyNova Python package...
pip uninstall -y pynova
echo Package uninstallation complete.
echo.

:: Remove from PATH
echo Removing PyNova from PATH...
echo This may require administrator privileges to modify the system PATH.
echo.

:: Check for admin privileges
net session >nul 2>&1
if %errorLevel% == 0 (
    set "ADMIN=yes"
) else (
    set "ADMIN=no"
    echo Note: Not running with administrator privileges.
    echo The uninstaller will only modify your user PATH.
    echo.
)

:: Get current PATH
if "%ADMIN%"=="yes" (
    for /f "tokens=2*" %%A in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v PATH') do set "CURRENT_PATH=%%B"
    set "PATH_TYPE=system"
) else (
    for /f "tokens=2*" %%A in ('reg query "HKCU\Environment" /v PATH') do set "CURRENT_PATH=%%B"
    set "PATH_TYPE=user"
)

:: Remove the batch directory from PATH
set "NEW_PATH=!CURRENT_PATH:%BATCH_DIR%;=!"
set "NEW_PATH=!NEW_PATH:;%BATCH_DIR%=!"

:: Update PATH
if "%ADMIN%"=="yes" (
    setx PATH "%NEW_PATH%" /M
) else (
    setx PATH "%NEW_PATH%"
)

if %errorLevel% == 0 (
    echo Successfully removed PyNova from your %PATH_TYPE% PATH.
) else (
    echo Warning: Failed to remove PyNova from your PATH.
    echo You may need to manually remove the following directory from your PATH:
    echo %BATCH_DIR%
)
echo.

echo Uninstallation complete!
echo.
echo You may need to restart your command prompt for the PATH changes to take effect.
echo.

pause