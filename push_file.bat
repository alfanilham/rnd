@echo off
setlocal enabledelayedexpansion

set /p FILE_TO_PUSH=Masukkan nama file yang akan diupload: 

if not exist "%FILE_TO_PUSH%" (
    echo File "%FILE_TO_PUSH%" not found!
    pause
    exit /b
)

set /p DEST_PATH=/sdcard/Download/

echo.
echo ==== Mengupload "%FILE_TO_PUSH%" ke semua device ====

for /f "skip=1 tokens=1" %%D in ('adb devices') do (
    if not "%%D"=="offline" if not "%%D"=="unauthorized" if not "%%D"=="" (
        echo Pushing "%FILE_TO_PUSH%" to device %%D...
        adb -s %%D push "%FILE_TO_PUSH%" "%DEST_PATH%"
    )
)

echo.
echo ==== Done ====
pause
