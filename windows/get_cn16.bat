@echo off
echo Download + unpack CN Android 16 firmware (8 GB) into C:\g55\fw16
cd /d C:\g55
curl.exe -L -C - -o fw16.zip https://mirrors.lolinet.com/firmware/lenomola/2024/taipei_retcn/official/RETCN/XT2435-3_TAIPEI_CMCC_16_W1UTC36.1-36_subsidy-DEFAULT_regulatory-DEFAULT_CFC.xml.zip
if errorlevel 1 (echo DOWNLOAD FAILED - run get_cn16.bat again, it will resume & pause & exit /b 1)
if not exist fw16 mkdir fw16
tar -xf fw16.zip -C fw16
if exist fw16\flashfile.xml (echo OK: C:\g55\fw16 ready) else (echo UNPACK FAILED)
pause
