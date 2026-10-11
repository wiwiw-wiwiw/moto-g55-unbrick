@echo off
echo Download + unpack GLOBAL firmware (4.9 GB) into C:\g55\fwg
cd /d C:\g55
curl.exe -L -C - -o fwg.zip https://mirrors.lolinet.com/firmware/lenomola/2024/taipei/official/RETAIL/TAIPEI_RETAIL_15_V1UTS35H.61-21-4-3-2-1_subsidy-DEFAULT_regulatory-DEFAULT_cid50_CFC.xml.zip
if errorlevel 1 (echo DOWNLOAD FAILED - run get_global.bat again, it will resume & pause & exit /b 1)
if not exist fwg mkdir fwg
tar -xf fwg.zip -C fwg
if exist fwg\flashfile.xml (echo OK: C:\g55\fwg ready) else (echo UNPACK FAILED)
pause
