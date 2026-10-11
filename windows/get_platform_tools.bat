@echo off
echo Download Google platform-tools (adb + fastboot) into C:\platform-tools
if not exist C:\g55 mkdir C:\g55
cd /d C:\g55
curl.exe -L -o pt.zip https://dl.google.com/android/repository/platform-tools-latest-windows.zip
if errorlevel 1 (echo DOWNLOAD FAILED & pause & exit /b 1)
tar -xf pt.zip -C C:\
if exist C:\platform-tools\fastboot.exe (echo OK: C:\platform-tools ready) else (echo UNPACK FAILED)
pause
