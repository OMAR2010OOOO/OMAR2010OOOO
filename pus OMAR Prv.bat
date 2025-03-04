@echo off
cls
color 0A
echo ==============================================
echo             [ LDplayer ]          
echo ==============================================
adb kill-server
adb start-server
adb wait-for-device
adb root
adb remount

:: التحقق من الروت
adb shell su -c "whoami" | findstr /C:"root" >nul
if %errorlevel% neq 0 (
    echo [!] Root access is not available!
    pause
    exit
)

:: اختيار إصدار اللعبة
echo.
echo [1] Global (GL)
echo [2] Taiwan (TW)
echo [3] Korea (KR)
echo [4] Vietnam (VN)
echo ==============================================
set /p version=Enter choice: 

if "%version%"=="1" set game_package=com.tencent.ig
if "%version%"=="2" set game_package=com.rekoo.pubgm
if "%version%"=="3" set game_package=com.pubg.krmobile
if "%version%"=="4" set game_package=com.vng.pubgmobile

:: تحديد مسار الملف
set lib_path="C:\Users\islam\Desktop\wait to fix\LIB 3.6\152DFSFS\libs\MARIO\libGVoicePlugin.so"

:: التحقق من وجود الملفات المطلوبة
if not exist %lib_path% (
    echo [!] Missing file: libGVoicePlugin.so
    pause
    exit
)



:: توليد ID عشوائي
set tool=34
Setlocal EnableDelayedExpansion
Set RNDtool=%tool%
Set Alphanumer=ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789
Set Noradin=%Alphanumer%987654321

:GenerateID
IF NOT "%Noradin:~18%"=="" SET Noradin=%Noradin:~9%& SET /A NII+=9& GOTO :GenerateID
SET UC=%Noradin:~9,1%
SET /A NII=NII+UC
Set Count=0
SET RndAlphaNum=

:GenerateLoop
Set /a Count+=1
SET RND=%Random%
Set /A RND=RND%%%NII%
SET RndAlphaNum=!RndAlphaNum!!Alphanumer:~%RND%,1!
If !Count! lss %RNDtool% goto GenerateLoop

:: تغيير الـ ID
cls
echo ==============================================
echo  [-] Your New Secure Device ID: %RndAlphaNum%
echo ==============================================

adb shell su -c "settings put secure android_id %RndAlphaNum%"
adb shell su -c "settings put secure Model %RndAlphaNum%"
adb shell su -c "settings put secure Manufacturer %RndAlphaNum%"

:: تنظيف البيانات
echo.
echo [<] Clearing Cache and Logs...
adb shell su -c "rm -rf /sdcard/Android/.system_android_l2"
adb shell su -c "rm -rf /data/data/%game_package%/cache/*"
adb shell su -c "rm -rf /data/data/%game_package%/code_cache/*"
adb shell su -c "rm -rf /data/data/%game_package%/shared_prefs/*"
adb shell su -c "rm -rf /data/data/%game_package%/databases/*"
adb shell su -c "rm -rf /data/data/%game_package%/files/.system_android_l2"

:: حقن الملف
echo.
echo [#] Injecting Secure VIP Plugin...
adb shell su -c "rm -rf /data/data/%game_package%/lib/libGVoicePlugin.so"
adb push %lib_path% /data/data/%game_package%/lib/
adb shell su -c "chmod 777 /data/data/%game_package%/lib/libGVoicePlugin.so"

:: تشغيل اللعبة
echo.
echo [-] Launching Game Securely...
adb shell su -c "am start -n %game_package%/com.epicgames.ue4.SplashActivity"
adb shell su -c "monkey -p %game_package% -c android.intent.category.LAUNCHER 1"

:: حقن ملفات أخرى
echo.
echo [#] Injecting Additional Data...
for /L %%i in (1,1,10) do (
    adb push ml /data/data/%game_package%/files/ano_tmp/ano_emu_c2.dat
    timeout /t 1 /nobreak >nul
)

echo.
echo ==============================================
echo   VIP TOOL READY - AUTHORIZED ACCESS ONLY  
echo ==============================================
echo[
adb logcat | findstr RISING
color F
