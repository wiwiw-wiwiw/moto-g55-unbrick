@echo off
set FB=C:\platform-tools\fastboot.exe
set LOG=C:\g55\unlock-log.txt
echo Phone must be in fastboot mode and connected.
%FB% devices
%FB% getvar securestate
echo.
set /p CODE=Paste Motorola unlock code and press Enter: 
echo === unlock %DATE% %TIME% > %LOG%
%FB% oem unlock %CODE% >> %LOG% 2>&1
type %LOG%
echo.
echo If the PHONE shows a confirm screen: Volume keys = choose UNLOCK, Power = confirm, then CLOSE this window.
echo Only if the text above asks to RE-RUN the command: press a key to send it once more.
pause
%FB% oem unlock %CODE% >> %LOG% 2>&1
type %LOG%
echo.
echo After the phone confirms and reboots, put it back to fastboot and check:
echo   %FB% getvar securestate   (must be: flashing_unlocked)
pause
