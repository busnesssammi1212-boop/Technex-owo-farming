@echo off
setlocal EnableExtensions
title Technex Installer
cd /d "%~dp0"
chcp 65001 >nul
color 0B

echo.
echo  [SYSTEM] Technex Installer

rem ---------- find Python 3.10+ ----------
set "PY_CMD="
py -c "import sys; sys.exit(0 if sys.version_info>=(3,10) else 1)" >nul 2>&1 && set "PY_CMD=py"
if not defined PY_CMD python -c "import sys; sys.exit(0 if sys.version_info>=(3,10) else 1)" >nul 2>&1 && set "PY_CMD=python"
if not defined PY_CMD python3 -c "import sys; sys.exit(0 if sys.version_info>=(3,10) else 1)" >nul 2>&1 && set "PY_CMD=python3"

if not defined PY_CMD (
    echo.
    echo  [X] Python 3.10+ not found.
    echo  Install it from https://www.python.org/downloads/
    echo  ^(tick "Add Python to PATH"^) and run this file again.
    pause
    exit /b 1
)

echo  [OK] Using Python: %PY_CMD%

rem ---------- install requirements (first run only) ----------
if not exist ".technex_deps_ok" (
    echo.
    echo  [#] Installing requirements, please wait...
    %PY_CMD% -m pip install -r requirements.txt
    if errorlevel 1 (
        echo.
        echo  [X] Requirements install failed.
        pause
        exit /b 1
    )
    echo ok> ".technex_deps_ok"
)

rem ---------- first-time setup (creates config\auth.json) ----------
if not exist "config\auth.json" (
    echo.
    echo  [#] First-time setup...
    %PY_CMD% technex_setup.py --quick
    if errorlevel 1 (
        echo.
        echo  [X] Setup failed.
        pause
        exit /b 1
    )
)

rem ---------- start ----------
echo.
echo  [#] Starting Technex...
echo.
%PY_CMD% technex.py

echo.
echo  [Technex stopped]
pause