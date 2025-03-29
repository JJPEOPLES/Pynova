@echo off
rem PyNova Direct Runner v3.1 - Run PyNova programs directly with Python
rem Usage: pyn3 filename.pyn

python "%~dp0run_pynova_direct.py" %*
exit /b %errorlevel%