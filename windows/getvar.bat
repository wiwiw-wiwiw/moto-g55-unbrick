@echo off
echo Phone must be in fastboot mode (Power + Volume Down) and connected.
C:\platform-tools\fastboot.exe devices
C:\platform-tools\fastboot.exe getvar all 2> C:\g55\getvar.txt
type C:\g55\getvar.txt
echo.
echo Saved to C:\g55\getvar.txt  (contains IMEI and serial - do not post it publicly)
pause
