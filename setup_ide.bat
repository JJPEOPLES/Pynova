@echo off
echo Setting up PyNova IDE...

:: Create dummy numba module
python create_dummy_numba.py

echo Setup complete!
echo.
echo You can now run the IDE by double-clicking launch_pynova_ide.bat
echo.
pause