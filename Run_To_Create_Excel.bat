@echo off
cd /d "%~dp0"
echo Creating PakStyleBD_BrandAccounts.xlsx...
python build_accounts.py
if errorlevel 1 (
    echo.
    echo Python not found in PATH. Trying conda...
    call conda activate base 2>nul
    python build_accounts.py
)
