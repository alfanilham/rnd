@echo off
setlocal enabledelayedexpansion

set /p FILE_TO_PUSH=Masukkan nama file yang akan diupload: 

if not exist "%FILE_TO_PUSH%" (
    echo File "%FILE_TO_PUSH%" tidak ada!
    pause
    exit /b
)

set "DEST_PATH=/sdcard/Download/"

echo.
echo ==== Mengupload file "%FILE_TO_PUSH%" ke semua android ====

for /f "skip=1 tokens=1" %%D in ('adb devices') do (
    if not "%%D"=="offline" if not "%%D"=="unauthorized" if not "%%D"=="" (
        echo.
        echo ► Device: %%D
        adb -s %%D push "%FILE_TO_PUSH%" "!DEST_PATH!"
    )
)

echo.
echo ==== Done pushing to all devices ====
pause
