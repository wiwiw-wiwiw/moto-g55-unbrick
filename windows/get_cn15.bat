@echo off
echo Download + unpack CN Android 15 firmware (7 GB) into C:\g55\fw
if not exist C:\g55 mkdir C:\g55
cd /d C:\g55
curl.exe -L -C - -o fw.zip https://mirrors.lolinet.com/firmware/lenomola/2024/taipei_retcn/official/RETCN/XT2435-3_TAIPEI_CMCC_15_V1UTC35H.45-32-8_subsidy-DEFAULT_regulatory-DEFAULT_CFC.xml.zip
if errorlevel 1 (echo DOWNLOAD FAILED - run get_cn15.bat again, it will resume & pause & exit /b 1)
if not exist fw mkdir fw
tar -xf fw.zip -C fw
if exist fw\flashfile.xml (echo OK: C:\g55\fw ready) else (echo UNPACK FAILED)
pause
