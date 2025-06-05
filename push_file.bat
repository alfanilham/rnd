@echo off
setlocal enabledelayedexpansion

echo.
echo ==========================================================
echo            UPLOAD TO ALL DEVICES BOXPHONE                          
echo ----------------------------------------------------------
echo      Upload file ke semua device simple gesss :D     
echo ==========================================================
echo                                           by Analyst Team
echo.
echo.
echo.

set /p FILE_TO_PUSH=Masukkan nama file yang akan diupload: 

if not exist "%FILE_TO_PUSH%" (
    echo File "%FILE_TO_PUSH%" tidak ada!
    pause
    exit /b
)

for %%F in ("%FILE_TO_PUSH%") do set FILE_NAME=%%~nxF
set "DEST_PATH=/sdcard/Download/"

echo.
echo ==== Mengupload file "%FILE_TO_PUSH%" ke semua android ====

for /f "skip=1 tokens=1" %%D in ('adb devices') do (
    if not "%%D"=="offline" if not "%%D"=="unauthorized" if not "%%D"=="" (
        echo.
        echo Device: %%D
        adb -s %%D push "%FILE_TO_PUSH%" "!DEST_PATH!"
        echo Scanning file so it appears in Gallery...
        adb -s %%D shell am broadcast -a android.intent.action.MEDIA_SCANNER_SCAN_FILE -d file:///sdcard/Download/!FILE_NAME!
    )
)

echo.
echo.
echo Done. File selesai diupload dan sudah ada di gallery di semua devices.
echo.
pause
