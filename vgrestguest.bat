@echo off
title @YASSEN
color 03
(Set LF=^
%Null%
)
SetLocal EnableExtensions EnableDelayedExpansion
set "string=abcdefghijklmnopqrstuvwxyz0123456789"
adb kill-server
adb start-server

:Menu
cls
CHOICE /C 12345 /N /T 30 /D 5 /M "1. Guest Reset!LF!2. Android ID Reset!LF!3. Push Library & Start!LF!4. Logout ID!LF!5. Exit!LF!%1
IF ERRORLEVEL 5 goto End
IF ERRORLEVEL 4 goto Logout
IF ERRORLEVEL 3 goto StartNew
IF ERRORLEVEL 2 goto IDR
IF ERRORLEVEL 1 goto MenuGuest

:MenuGuest
cls
CHOICE /C 12345 /N /T 30 /D 5 /M "1. GL Guest Reset!LF!2. VN Guest Reset!LF!3. KR Guest Reset!LF!4. TW Guest Reset!LF!5. Go Back!LF!%1
IF ERRORLEVEL 5 goto Menu
IF ERRORLEVEL 4 goto TWPackage
IF ERRORLEVEL 3 goto KRPackage
IF ERRORLEVEL 2 goto VNPackage
IF ERRORLEVEL 1 goto GlobalPackage

:Logout
adb.exe shell rm -rf /data/data/com.tencent.ig/databases
goto Menu
:IDR
cls
CHOICE /C 123 /N /T 30 /D 3 /M "1. Insert New ID!LF!2. Insert Old ID!LF!3. Go Back!LF!%1
IF ERRORLEVEL 3 goto MenuGuest
IF ERRORLEVEL 2 goto OldIDR
IF ERRORLEVEL 1 goto NewIDR

:OldIDR
cls
echo Insert one of your old Android ID
echo (stored in OldDeviceID.txt)
set /P boldid=Write ID and press Enter:
echo Your Input = %boldid%
echo "Your Current Device ID:"
FOR /F "delims=" %%i IN ('adb shell settings get secure android_id') DO set OldID=%%i
echo %OldID%
echo Now Applying %boldid%

adb shell settings put secure android_id %boldid%
adb shell content insert --uri content://settings/secure --bind name:s:android_id --bind value:s:%boldid%
set h=%TIME:~0,2%
set m=%TIME:~3,2%
set s=%TIME:~6,2%
set time=%h%_%m%_%s%
SET DMY=%DATE%
echo %DMY% %time%>OldDeviceID.tmp
echo Previous ID : %OldID%>>OldDeviceID.tmp
echo Reapplied ID : %boldid%>>OldDeviceID.tmp
echo =====================================================>>OldDeviceID.tmp
If exist OldDeviceID.txt Ren OldDeviceID.txt OldDeviceID.txtx
Copy OldDeviceID.tmp+OldDeviceID.txtx OldDeviceID.txt > nul
if exist OldDeviceID.txtx Del OldDeviceID.txtx
Del OldDeviceID.tmp

adb shell setprop ro.mac_address %boldid%
adb shell setprop ro.product.device %boldid%
adb shell setprop ro.product.brand %boldid%
adb shell setprop ro.product.model %boldid%
adb shell setprop ro.product.name %boldid%
adb shell setprop ro.product.manufacturer %boldid%
adb shell setprop ro.android_id %boldid%
adb shell setprop net.hostname %boldid%
adb shell setprop gaid %boldid%
adb shell setprop android.device.id %boldid%
adb shell setprop ro.serialno %boldid%
adb shell setprop ro.runtime.firstboot %boldid%

timeout /t 3 /nobreak
goto Menu

:NewIDR
cls
::Handle AndroidID here, Change
echo "Your Old Device ID :"
FOR /F "delims=" %%i IN ('adb shell settings get secure android_id') DO set OldID=%%i
echo %OldID%
set "IDD="
for /L %%i in (1,1,16) do call :Pseudo
adb shell settings put secure android_id %IDD%
adb shell content insert --uri content://settings/secure --bind name:s:android_id --bind value:s:%IDD%
echo "Your New Device ID :"
echo %IDD%
set h=%TIME:~0,2%
set m=%TIME:~3,2%
set s=%TIME:~6,2%
set time=%h%_%m%_%s%
SET DMY=%DATE%
echo %DMY% %time%>OldDeviceID.tmp
echo Previous ID : %OldID%>>OldDeviceID.tmp
echo New ID : %IDD%>>OldDeviceID.tmp
echo =====================================================>>OldDeviceID.tmp
If exist OldDeviceID.txt Ren OldDeviceID.txt OldDeviceID.txtx
Copy OldDeviceID.tmp+OldDeviceID.txtx OldDeviceID.txt > nul
if exist OldDeviceID.txtx Del OldDeviceID.txtx
Del OldDeviceID.tmp

adb shell setprop ro.mac_address %IDD%
adb shell setprop ro.product.device %IDD%
adb shell setprop ro.product.brand %IDD%
adb shell setprop ro.product.model %IDD%
adb shell setprop ro.product.name %IDD%
adb shell setprop ro.product.manufacturer %IDD%
adb shell setprop ro.android_id %IDD%
adb shell setprop net.hostname %IDD%
adb shell setprop gaid %IDD%
adb shell setprop android.device.id %IDD%
adb shell setprop ro.serialno %IDD%
adb shell setprop ro.runtime.firstboot %IDD%

timeout /t 3 /nobreak
goto Menu

:StartNew
cls
CHOICE /C 12345 /N /T 30 /D 5 /M "1. START GLOBAL (GL)!LF!2. START VIETNAMESE (VNG)!LF!3. START KOREAN (KR)!LF!4. START TAIWANESE (TW)!LF!5. GO BACK!LF!%1
IF ERRORLEVEL 5 goto Menu
IF ERRORLEVEL 4 goto TWPKG
IF ERRORLEVEL 3 goto KRPKG
IF ERRORLEVEL 2 goto VNPKG
IF ERRORLEVEL 1 goto GLPKG

:GLPKG
set PackageName=com.tencent.ig
goto Completo

:KRPKG
set PackageName=com.pubg.krmobile
goto Completo

:VNPKG
set PackageName=com.vng.pubgmobile
goto Completo

:TWPKG
set PackageName=com.rekoo.pubgm
goto Completo

:Completo

REM copy D:\Android\UNITYPRIV\libc++_shared.so C:\Temp\TxGameDownload\MobileGamePCShared /Y
adb logcat -c
adb shell logcat -c

REM adb push libc++_shared.so /data/share1
adb shell rm /data/app/%PackageName%-1/lib/arm/libc++_shared.so
adb shell cp /data/share1/libc++_shared.so /data/app/%PackageName%-1/lib/arm
adb shell am start -n %PackageName%/com.epicgames.ue4.SplashActivity
adb shell logcat -s UNITY
goto Menu

:KRPackage
set PackageName=com.pubg.krmobile
goto RestOfProcess
:VNPackage
set PackageName=com.vng.pubgmobile
goto RestOfProcess
:TWPackage
set PackageName=com.rekoo.pubgm
goto RestOfProcess
:GlobalPackage
set PackageName=com.tencent.ig
:RestOfProcess
adb shell am force-stop %PackageName%
goto RoutineX
:resume1
adb push %TEMP%\device_id.xml /data/data/%PackageName%/shared_prefs
::Handle AndroidID here, Change
echo "Your Old Device ID :"
adb shell settings get secure android_id
set "IDD="
for /L %%i in (1,1,16) do call :Pseudo
adb shell settings put secure android_id %IDD%
adb shell content insert --uri content://settings/secure --bind name:s:android_id --bind value:s:%IDD%
set h=%TIME:~0,2%
set m=%TIME:~3,2%
set s=%TIME:~6,2%
set time=%h%_%m%_%s%
SET DMY=%DATE%
echo %DMY% %time%>OldDeviceID.tmp
echo %OldID%>>OldDeviceID.tmp
echo =====================================================>>OldDeviceID.tmp
If exist OldDeviceID.txt Ren OldDeviceID.txt OldDeviceID.txtx
Copy OldDeviceID.tmp+OldDeviceID.txtx OldDeviceID.txt > nul
if exist OldDeviceID.txtx Del OldDeviceID.txtx
Del OldDeviceID.tmp

adb shell setprop ro.mac_address %IDD%
adb shell setprop ro.product.device %IDD%
adb shell setprop ro.product.brand %IDD%
adb shell setprop ro.product.model %IDD%
adb shell setprop ro.product.name %IDD%
adb shell setprop ro.product.manufacturer %IDD%
adb shell setprop ro.android_id %IDD%
adb shell setprop net.hostname %IDD%
adb shell setprop gaid %IDD%
adb shell setprop android.device.id %IDD%
adb shell setprop ro.serialno %IDD%
adb shell setprop ro.runtime.firstboot %IDD%

echo "Your New Device ID :"
echo %IDD%
goto EmptyRecords
:resume2
echo Done
taskkill /IM "adb.exe" /T /F
timeout /t 3

REM goto :eof
goto Menu
:EmptyRecords
echo Cleaning ID related files please wait 2 minutes
adb shell rm -rf /data/data/com.activision.callofduty.shooter/files/itop_login.txt
adb shell rm -rf /data/data/com.activision.callofduty.shooter/shared_prefs/itop.xml
adb shell rm -rf /storage/emulated/0/com.activision.callofduty.shooter
adb shell rm -rf /storage/emulated/0/Android/data/%PackageName%/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/Saved/Logs
adb shell rm -rf /storage/emulated/0/Android/data/%PackageName%/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/Saved/UpdateInfo
adb shell rm -rf /storage/emulated/0/Android/data/%PackageName%/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/Saved/TableDatas
adb shell rm -rf /storage/emulated/0/Android/data/%PackageName%/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/Saved/conversation.ini
adb shell rm -rf /storage/emulated/0/Android/data/%PackageName%/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/Saved/GameErrorNoRecords
adb shell rm -rf /storage/emulated/0/Android/data/%PackageName%/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/Saved/StatEventReportedFlag
adb shell rm -rf /storage/emulated/0/Android/data/%PackageName%/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/Saved/ImageDownload
adb shell rm -rf /storage/emulated/0/Android/data/%PackageName%/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/Saved/MMKV
adb shell rm -rf /storage/emulated/0/Android/data/%PackageName%/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/Saved/rawdata
adb shell rm -rf /storage/emulated/0/Android/data/%PackageName%/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/Saved/SaveGames
adb shell rm -rf /storage/emulated/0/Android/data/%PackageName%/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/Saved/logs
adb shell rm -rf /storage/emulated/0/Android/data/%PackageName%/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/Saved/Pandora
adb shell rm -rf /storage/emulated/0/Android/data/%PackageName%/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/Saved/PufferEifs1
adb shell rm -rf /storage/emulated/0/Android/data/%PackageName%/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/Saved/PufferEifs0
adb shell rm -rf /storage/emulated/0/Android/data/%PackageName%/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/Saved/PufferTmpDir
adb shell rm -rf /storage/emulated/0/Android/data/%PackageName%/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/Saved/RoleInfo
adb shell rm -rf /data/data/%PackageName%/databases
adb shell rm -rf /storage/emulated/0/Android/.system_android_l2
adb shell rm -rf /data/data/%PackageName%/files/.system_android_l2
adb shell rm -rf /storage/emulated/0/Android/data/%PackageName%/files/.system_android_l2
adb shell rm -rf /storage/emulated/0/Android/data/%PackageName%/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/Intermediate
adb shell rm -rf /storage/emulated/0/Android/data/%PackageName%/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/SaveGames
adb shell rm -rf /data/data/%PackageName%/shared_prefs
adb shell mkdir /data/data/%PackageName%/shared_prefs
adb shell chmod -R 777 /data/data/%PackageName%/shared_prefs
adb shell rm -rf /data/data/%PackageName%/databases/*
adb shell mv /data/data/%PackageName%/shared_prefs/device_id3.xml /data/data/%PackageName%/shared_prefs/device_id.xml
adb shell touch /storage/emulated/0/Android/data/%PackageName%/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/Intermediate
adb shell touch /storage/emulated/0/Android/data/%PackageName%/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/SaveGames
adb shell rm -rf /data/data/%PackageName%/code_cache
adb shell rm -rf /data/data/%PackageName%/app_bugly
adb shell rm -rf /data/data/%PackageName%/app_crashrecord
adb shell rm -rf /data/data/%PackageName%/app_databases
adb shell rm -rf /data/data/%PackageName%/app_webview
adb shell rm -rf /data/data/%PackageName%/cache
::adb shell rm -rf /data/data/%PackageName%/files
::adb shell rm -rf /data/data/%PackageName%/lib
adb shell rm -rf /data/data/%PackageName%/no_backup
adb shell rm -rf /storage/emulated/0/Android/data/%PackageName%/cache
adb shell rm -f /storage/emulated/0/Android/data/%PackageName%/files/.fff
adb shell rm -rf /storage/emulated/0/Android/data/%PackageName%/files/*.fff
adb shell rm -f /storage/emulated/0/Android/data/%PackageName%/files/ca-bundle.pem
adb shell rm -rf "/storage/emulated/0/Android/data/%PackageName%/files/UE4Game/ShadowTrackerExtra/Epic Games"
adb shell rm -rf /storage/emulated/0/Android/data/%PackageName%/files/login-identifier.txt
adb shell rm -rf /storage/emulated/0/Android/data/%PackageName%/files/TGPA
adb shell rm -rf /data/data/%PackageName%/app_textures
adb shell rm -f /data/app/%PackageName%-1/lib/arm/libhelpshiftlistener.so
adb shell rm -rf /storage/emulated/0/.backups/%PackageName%
adb shell rm -rf /storage/emulated/0/.backups/%PackageName%-1
adb shell rm -f /sdcard/.zzz
adb shell rm -f /storage/emulated/0/Android/.system_android_12
adb shell rm -f /storage/emulated/0/Android/.system_android_l2
adb shell rm -f "/storage/emulated/0/Android/data/%PackageName%/files/UE4Game/ShadowTrackerExtra/Epic Games/KeyValueStore.ini"

adb shell rm -rf /storage/emulated/0/Android/.system_android_l2
adb shell rm -rf /data/data/%PackageName%/cache/*
adb shell rm -rf /data/data/%PackageName%/code_cache/*
adb shell rm -rf /data/data/%PackageName%/shared_prefs/*
adb shell rm -rf /data/data/%PackageName%/databases/*
adb shell rm -rf /data/data/%PackageName%/files/.system_android_l2
adb shell rm -rf /storage/emulated/0/Android/data/%PackageName%/cache/*
adb shell rm -rf /storage/emulated/0/Android/data/%PackageName%/files/.system_android_l2
adb shell rm -rf /storage/emulated/0/Android/data/%PackageName%/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/Saved/SaveGames/*.json


REM New
adb shell rm -rf /storage/emulated/0/Android/data/%PackageName%/files/ProgramBinaryCache/*
adb shell rm -rf /storage/emulated/0/Android/data/%PackageName%/files/AsyncCompile/*
adb shell rm -rf /storage/emulated/0/Android/data/%PackageName%/files/cacheFile.txt
adb shell rm -rf /storage/emulated/0/.userReturn
adb shell rm -rf /storage/emulated/0/centauri
adb shell rm -rf /storage/emulated/0/CentauriOversea
adb shell rm -rf /storage/emulated/0/.userReturn
adb shell rm -rf /storage/emulated/0/centauri
adb shell rm -rf /storage/emulated/0/CentauriOversea
adb shell rm -rf /storage/emulated/0/ASD
adb shell rm -rf /storage/emulated/0/FT
adb shell rm -rf /storage/emulated/0/data
adb shell rm -rf /storage/emulated/0/backups
adb shell rm -rf /storage/emulated/0/.backups
adb shell rm -rf /storage/emulated/0/Android/*.dat
adb shell rm -rf /storage/emulated/0/*.dat
adb shell rm -rf /storage/emulated/0/tencent
adb shell rm -rf /storage/emulated/0/Download
adb shell rm -rf /t.txt
adb shell rm -rf /data/data/%PackageName%/files/Persisted*


REM --------------------------------------------------
adb shell rm -rf /data/data/com.activision.callofduty.shooter/files/itop_login.txt
adb shell rm -rf /data/data/com.activision.callofduty.shooter/shared_prefs/itop.xml
adb shell rm -rf /sdcard/com.activision.callofduty.shooter
adb shell rm -rf /sdcard/Android/data/%PackageName%/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/Saved/Logs
adb shell rm -rf /sdcard/Android/data/%PackageName%/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/Saved/UpdateInfo
adb shell rm -rf /sdcard/Android/data/%PackageName%/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/Saved/TableDatas
adb shell rm -rf /sdcard/Android/data/%PackageName%/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/Saved/conversation.ini
adb shell rm -rf /sdcard/Android/data/%PackageName%/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/Saved/GameErrorNoRecords
adb shell rm -rf /sdcard/Android/data/%PackageName%/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/Saved/StatEventReportedFlag
adb shell rm -rf /sdcard/Android/data/%PackageName%/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/Saved/ImageDownload
adb shell rm -rf /sdcard/Android/data/%PackageName%/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/Saved/MMKV
adb shell rm -rf /sdcard/Android/data/%PackageName%/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/Saved/rawdata
adb shell rm -rf /sdcard/Android/data/%PackageName%/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/Saved/SaveGames
adb shell rm -rf /sdcard/Android/data/%PackageName%/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/Saved/logs
adb shell rm -rf /sdcard/Android/data/%PackageName%/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/Saved/Pandora
adb shell rm -rf /sdcard/Android/data/%PackageName%/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/Saved/PufferEifs1
adb shell rm -rf /sdcard/Android/data/%PackageName%/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/Saved/PufferEifs0
adb shell rm -rf /sdcard/Android/data/%PackageName%/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/Saved/PufferTmpDir
adb shell rm -rf /sdcard/Android/data/%PackageName%/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/Saved/RoleInfo
adb shell rm -rf /data/data/%PackageName%/databases
adb shell rm -rf /sdcard/Android/.system_android_l2
adb shell rm -rf /data/data/%PackageName%/files/.system_android_l2
adb shell rm -rf /sdcard/Android/data/%PackageName%/files/.system_android_l2
adb shell rm -rf /sdcard/Android/data/%PackageName%/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/Intermediate
adb shell rm -rf /sdcard/Android/data/%PackageName%/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/SaveGames
adb shell rm -rf /data/data/%PackageName%/shared_prefs
adb shell mkdir /data/data/%PackageName%/shared_prefs
adb shell chmod -R 777 /data/data/%PackageName%/shared_prefs
adb shell rm -rf /data/data/%PackageName%/databases/*
adb shell mv /data/data/%PackageName%/shared_prefs/device_id3.xml /data/data/%PackageName%/shared_prefs/device_id.xml
adb shell touch /sdcard/Android/data/%PackageName%/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/Intermediate
adb shell touch /sdcard/Android/data/%PackageName%/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/SaveGames
adb shell rm -rf /data/data/%PackageName%/code_cache
adb shell rm -rf /data/data/%PackageName%/app_bugly
adb shell rm -rf /data/data/%PackageName%/app_crashrecord
adb shell rm -rf /data/data/%PackageName%/app_databases
adb shell rm -rf /data/data/%PackageName%/app_webview
adb shell rm -rf /data/data/%PackageName%/cache
::adb shell rm -rf /data/data/%PackageName%/files
::adb shell rm -rf /data/data/%PackageName%/lib
adb shell rm -rf /data/data/%PackageName%/no_backup
adb shell rm -rf /sdcard/Android/data/%PackageName%/cache
adb shell rm -f /sdcard/Android/data/%PackageName%/files/.fff
adb shell rm -rf /sdcard/Android/data/%PackageName%/files/*.fff
adb shell rm -f /sdcard/Android/data/%PackageName%/files/ca-bundle.pem
adb shell rm -rf "/sdcard/Android/data/%PackageName%/files/UE4Game/ShadowTrackerExtra/Epic Games"
adb shell rm -rf /sdcard/Android/data/%PackageName%/files/login-identifier.txt
adb shell rm -rf /sdcard/Android/data/%PackageName%/files/TGPA
adb shell rm -rf /data/data/%PackageName%/app_textures
adb shell rm -f /data/app/%PackageName%-1/lib/arm/libhelpshiftlistener.so
adb shell rm -rf /sdcard/.backups/%PackageName%
adb shell rm -rf /sdcard/.backups/%PackageName%-1
adb shell rm -f /sdcard/.zzz
adb shell rm -f /sdcard/Android/.system_android_12
adb shell rm -f /sdcard/Android/.system_android_l2
adb shell rm -f "/sdcard/Android/data/%PackageName%/files/UE4Game/ShadowTrackerExtra/Epic Games/KeyValueStore.ini"

adb shell rm -rf /sdcard/Android/.system_android_l2
adb shell rm -rf /data/data/%PackageName%/cache/*
adb shell rm -rf /data/data/%PackageName%/code_cache/*
adb shell rm -rf /data/data/%PackageName%/shared_prefs/*
adb shell rm -rf /data/data/%PackageName%/databases/*
adb shell rm -rf /data/data/%PackageName%/files/.system_android_l2
adb shell rm -rf /sdcard/Android/data/%PackageName%/cache/*
adb shell rm -rf /sdcard/Android/data/%PackageName%/files/.system_android_l2
adb shell rm -rf /sdcard/Android/data/%PackageName%/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/Saved/SaveGames/*.json


REM New
adb shell rm -rf /sdcard/Android/data/%PackageName%/files/ProgramBinaryCache/*
adb shell rm -rf /sdcard/Android/data/%PackageName%/files/AsyncCompile/*
adb shell rm -rf /sdcard/Android/data/%PackageName%/files/cacheFile.txt
adb shell rm -rf /sdcard/.userReturn
adb shell rm -rf /sdcard/centauri
adb shell rm -rf /sdcard/CentauriOversea
adb shell rm -rf /sdcard/.userReturn
adb shell rm -rf /sdcard/centauri
adb shell rm -rf /sdcard/CentauriOversea
adb shell rm -rf /sdcard/ASD
adb shell rm -rf /sdcard/FT
adb shell rm -rf /sdcard/data
adb shell rm -rf /sdcard/backups
adb shell rm -rf /sdcard/.backups
adb shell rm -rf /sdcard/Android/*.dat
adb shell rm -rf /sdcard/*.dat
adb shell rm -rf /sdcard/tencent
adb shell rm -rf /sdcard/Download
adb shell rm -rf /t.txt
adb shell rm -rf /data/data/%PackageName%/files/Persisted*


goto resume2

:Pseudo
set /a x=%random% %% 22 
set IDD=%IDD%!string:~%x%,1!
goto :eof

:RoutineX
set "string=abcdefABCDEF0123456789"
set "rr="
for /L %%i in (1,1,4) do call :Pseudorr
set "ss="
for /L %%i in (1,1,4) do call :Pseudoss
set "tt="
for /L %%i in (1,1,4) do call :Pseudott
set "uu="
for /L %%i in (1,1,4) do call :Pseudouu
set "vv="
for /L %%i in (1,1,4) do call :Pseudovv
set "ww="
for /L %%i in (1,1,4) do call :Pseudoww
set "xx="
for /L %%i in (1,1,4) do call :Pseudoxx
set "yy="
for /L %%i in (1,1,4) do call :Pseudoyy
set "h1=^<?xml version='1.0' encoding='utf-8' standalone='yes' ?^>"
set "h2=^<map^>"
set "h3=    ^<string name="install"^>%rr%%ss%-%tt%-%uu%-%vv%-%ww%%xx%%yy%^</string^>"
set "h4=    ^<string name="uuid"^>%yy%%xx%%ww%%vv%%uu%%tt%%ss%%rr%^</string^>"
set "h5=    ^<string name="random"^>^</string^>"
set "h6=^</map^>"
DEL %TEMP%\device_id.xml
echo %h1%>>%TEMP%\device_id.xml
echo %h2%>>%TEMP%\device_id.xml
echo %h3%>>%TEMP%\device_id.xml
echo %h4%>>%TEMP%\device_id.xml
echo %h5%>>%TEMP%\device_id.xml
echo %h6%>>%TEMP%\device_id.xml
goto resume1

:Pseudorr
set /a x=%random% %% 22 
set rr=%rr%!string:~%x%,1!
goto :eof

:Pseudoss
set /a x=%random% %% 22 
set ss=%ss%!string:~%x%,1!
goto :eof

:Pseudott
set /a x=%random% %% 22 
set tt=%tt%!string:~%x%,1!
goto :eof

:Pseudouu
set /a x=%random% %% 22 
set uu=%uu%!string:~%x%,1!
goto :eof

:Pseudovv
set /a x=%random% %% 22 
set vv=%vv%!string:~%x%,1!
goto :eof

:Pseudoww
set /a x=%random% %% 22 
set ww=%ww%!string:~%x%,1!
goto :eof

:Pseudoxx
set /a x=%random% %% 22 
set xx=%xx%!string:~%x%,1!
goto :eof

:Pseudoyy
set /a x=%random% %% 22 
set yy=%yy%!string:~%x%,1!
goto :eof

:End
cls
CHOICE /M "Do yo really want to quit?"
IF ERRORLEVEL 2 goto Menu
IF ERRORLEVEL 1 EXIT /B