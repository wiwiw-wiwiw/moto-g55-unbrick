@echo off
echo Stop the Motorola updater (com.motorola.ccc.ota) from running in background.
echo Reversible with unblock_ota.bat. Phone: booted, USB debugging ON, connected.
set ADB=C:\platform-tools\adb.exe
%ADB% wait-for-device
%ADB% shell cmd appops set com.motorola.ccc.ota RUN_IN_BACKGROUND ignore
%ADB% shell cmd appops set com.motorola.ccc.ota RUN_ANY_IN_BACKGROUND ignore
%ADB% shell cmd appops get com.motorola.ccc.ota | findstr BACKGROUND
echo.
echo Expect: RUN_IN_BACKGROUND: ignore  and  RUN_ANY_IN_BACKGROUND: ignore
echo Also turn off auto-download in Settings - System - System updates.
pause
