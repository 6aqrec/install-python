@echo off
setlocal enabledelayedexpansion

REM --- Look for real Python installation, ignoring WindowsApps alias ---
for /f "delims=" %%i in ('where python 2^>nul') do (
    echo %%i | findstr /i "WindowsApps" >nul
    if errorlevel 1 (
        set PYTHON_EXE=%%i
        goto found_python
    )
)

REM If no real Python found, install it
echo Real Python not found. Installing Python...
powershell -Command "Invoke-WebRequest -Uri https://www.python.org/ftp/python/3.12.2/python-3.12.2-amd64.exe -OutFile %temp%\python_installer.exe"
%temp%\python_installer.exe /quiet InstallAllUsers=1 PrependPath=1 Include_pip=1
timeout /t 10 /nobreak >nul

REM Find Python again after installation
for /f "delims=" %%i in ('where python 2^>nul') do (
    echo %%i | findstr /i "WindowsApps" >nul
    if errorlevel 1 (
        set PYTHON_EXE=%%i
        goto found_python
    )
)

echo Failed to locate Python executable. Exiting.
exit /b 1

:found_python
echo Found Python at: %PYTHON_EXE%

REM --- Check if pip is installed ---
%PYTHON_EXE% -m pip --version >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo pip not found. Installing pip...
    %PYTHON_EXE% -m ensurepip --upgrade
) ELSE (
    echo pip is installed.
)

REM --- Continue with the rest of your script ---
echo Python and pip are ready. Continuing script...
%PYTHON_EXE% -m pip install requests
PAUSE
