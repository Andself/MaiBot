@echo off
cd /d "%~dp0instance"
"%~dp0.venv\Scripts\maibot.exe" run
pause
