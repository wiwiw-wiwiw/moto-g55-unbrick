@echo off
echo Moto G55 XT2435-3: CN Android 15 V1UTC35H.45-32-8
cd /d C:\g55\fw
set FB=C:\platform-tools\fastboot.exe
set LOG=C:\g55\flash-log.txt
echo === flash start %DATE% %TIME% > %LOG%
if not exist flashfile.xml (echo flashfile.xml not found in C:\g55\fw & pause & exit /b 1)
call :f flash gpt PGPT
call :f getvar max-sparse-size
call :f oem fb_mode_set
call :f flash preloader preloader.img
call :f flash lk_a lk.img
call :f flash tee_a tee.img
call :f flash mcupm_a mcupm.img
call :f flash pi_img_a pi_img.img
call :f flash sspm_a sspm.img
call :f flash dtbo_a dtbo.img
call :f flash logo_a logo.img
call :f erase nvdata
call :f flash spmfw_a spmfw.img
call :f flash scp_a scp.img
call :f flash vbmeta_a vbmeta.img
call :f flash vbmeta_system_a vbmeta_system.img
call :f flash md1img_a md1img.img
call :f flash dpm_a dpm.img
call :f flash gz_a gz.img
call :f flash vcp_a vcp.img
call :f flash gpueb_a gpueb.img
call :f flash efuseBackup efuse.img
call :f flash boot_a boot.img
call :f flash vendor_boot_a vendor_boot.img
call :f flash super super.img_sparsechunk.0
call :f flash super super.img_sparsechunk.1
call :f flash super super.img_sparsechunk.2
call :f flash super super.img_sparsechunk.3
call :f flash super super.img_sparsechunk.4
call :f flash super super.img_sparsechunk.5
call :f flash super super.img_sparsechunk.6
call :f flash super super.img_sparsechunk.7
call :f flash super super.img_sparsechunk.8
call :f flash super super.img_sparsechunk.9
call :f flash super super.img_sparsechunk.10
call :f flash super super.img_sparsechunk.11
call :f flash super super.img_sparsechunk.12
call :f flash super super.img_sparsechunk.13
call :f flash super super.img_sparsechunk.14
call :f flash super super.img_sparsechunk.15
call :f flash super super.img_sparsechunk.16
call :f flash super super.img_sparsechunk.17
call :f flash super super.img_sparsechunk.18
call :f flash super super.img_sparsechunk.19
call :f flash super super.img_sparsechunk.20
call :f flash super super.img_sparsechunk.21
call :f flash super super.img_sparsechunk.22
call :f flash super super.img_sparsechunk.23
call :f flash super super.img_sparsechunk.24
call :f flash super super.img_sparsechunk.25
call :f flash super super.img_sparsechunk.26
call :f flash super super.img_sparsechunk.27
call :f flash super super.img_sparsechunk.28
call :f flash super super.img_sparsechunk.29
call :f erase userdata
call :f erase metadata
call :f erase debug_token
call :f oem fb_mode_clear
call :f oem config unset console
call :f oem config unset cmdl
echo.
echo === DONE. Log: C:\g55\flash-log.txt
echo === DONE >> %LOG%
findstr /c:"FAIL:" %LOG%
pause
goto :eof

:f
echo ^>^>^> fastboot %*
echo ^>^>^> fastboot %* >> %LOG%
%FB% %* >> %LOG% 2>&1
if errorlevel 1 (echo     FAIL: %* & echo FAIL: %* >> %LOG%)
goto :eof
