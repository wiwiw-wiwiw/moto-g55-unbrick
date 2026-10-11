@echo off
echo Enable the Google services that ship DISABLED in the China firmware.
echo Phone: booted normally, USB debugging ON, connected, debugging prompt allowed.
set ADB=C:\platform-tools\adb.exe
%ADB% wait-for-device
%ADB% shell pm enable com.google.android.gsf
%ADB% shell pm enable com.google.android.gms
%ADB% shell pm enable com.android.vending
%ADB% shell pm enable com.google.android.configupdater
echo.
echo Each line above must end with "new state: enabled". Rebooting phone...
%ADB% reboot
pause
