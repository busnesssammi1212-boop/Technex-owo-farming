@echo off
setlocal EnableExtensions
title Technex GitHub Upload
cd /d "%~dp0"
chcp 65001 >nul
color 0B

echo.
echo  [SYSTEM] Technex GitHub Upload
echo.

where git >nul 2>&1
if errorlevel 1 (
    echo  [X] Git is not installed. Get it from https://git-scm.com/download/win
    pause
    exit /b 1
)

rem ---------- keep private files out of the upload ----------
if not exist ".gitignore" type nul > ".gitignore"
echo.>> ".gitignore"
for %%L in (config/accounts.json config/auth.json data/ __pycache__/ *.pyc .technex_deps_ok login_search.txt find_login.bat fix_technex.bat) do (
    findstr /x /c:"%%L" ".gitignore" >nul 2>&1 || echo %%L>> ".gitignore"
)
echo  [OK] Private files are ignored ^(accounts.json, auth.json, data, caches^).

if not exist ".git" git init >nul 2>&1
git config user.name >nul 2>&1 || git config user.name "Technex"
git config user.email >nul 2>&1 || git config user.email "technex@users.noreply.github.com"

git add -A
echo.
echo  [#] Files that will be uploaded:
echo  ----------------------------------------
git status --short
echo  ----------------------------------------

rem ---------- stop if a Discord token is found in any file ----------
git grep --cached -n -I -E "[A-Za-z0-9_-]{24}\.[A-Za-z0-9_-]{6}\.[A-Za-z0-9_-]{27,}|mfa\.[A-Za-z0-9_-]{60,}" >nul 2>&1
if not errorlevel 1 (
    echo.
    echo  [X] STOPPED: something that looks like a Discord token was found:
    git grep --cached -n -I -l -E "[A-Za-z0-9_-]{24}\.[A-Za-z0-9_-]{6}\.[A-Za-z0-9_-]{27,}|mfa\.[A-Za-z0-9_-]{60,}"
    echo  Remove the token from that file, then run this again.
    pause
    exit /b 1
)
echo  [OK] No Discord token found in the files above.

echo.
echo  Create an EMPTY repository on github.com first ^(no README^).
echo  Then paste its link, for example:
echo  https://github.com/YOURNAME/technex.git
echo.
set "REPO="
set /p "REPO=Repository link: "
if "%REPO%"=="" (
    echo  [X] No link entered.
    pause
    exit /b 1
)

set "OK="
set /p "OK=Look at the file list above. Type YES to upload: "
if /i not "%OK%"=="YES" (
    echo  Cancelled. Nothing was uploaded.
    pause
    exit /b 0
)

git commit -m "Technex" >nul 2>&1
git branch -M main
git remote remove origin >nul 2>&1
git remote add origin "%REPO%"
git push -u origin main

if errorlevel 1 (
    echo.
    echo  [X] Upload failed. Send a screenshot of this window.
    pause
    exit /b 1
)

echo.
echo  [OK] Uploaded.
pause
