@echo off
set ADB=C:\platform-tools\adb.exe
set OUT=C:\g55\diag.txt
echo Phone: booted normally, USB debugging ON, connected. Allow the "USB debugging" prompt on the phone.
%ADB% kill-server >nul 2>&1
%ADB% wait-for-device
echo === props > %OUT%
for %%p in (ro.product.model ro.build.fingerprint ro.build.version.security_patch ro.boot.flash.locked ro.boot.verifiedbootstate ro.oem_unlock_supported sys.oem_unlock_allowed ro.frp.pst ro.carrier ro.boot.hwc persist.sys.locale) do (
  echo %%p:>> %OUT%
  %ADB% shell getprop %%p >> %OUT% 2>&1
)
echo === oem_unlock settings >> %OUT%
%ADB% shell settings get global oem_unlock_allowed >> %OUT% 2>&1
%ADB% shell dumpsys persistent_data_block >> %OUT% 2>&1
%ADB% shell dumpsys device_policy ^| head -40 >> %OUT% 2>&1
%ADB% shell dumpsys lock_settings ^| head -40 >> %OUT% 2>&1
%ADB% shell pm list users >> %OUT% 2>&1
%ADB% logcat -c
echo.
echo NOW on the phone: try to set the PIN and try the OEM unlock switch (2-3 times).
echo Then come back here and press a key.
pause
%ADB% logcat -d -v time > C:\g55\logcat.txt
echo Done. Send C:\g55\diag.txt and C:\g55\logcat.txt
pause
