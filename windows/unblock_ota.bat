@echo off
C:\platform-tools\adb.exe wait-for-device
C:\platform-tools\adb.exe shell cmd appops reset com.motorola.ccc.ota
echo Motorola updater restrictions removed.
pause
