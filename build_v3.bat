@echo off
echo ====================================
echo Iniciando build JARVIS (v2)...
echo ====================================
cd /d "C:\Users\t_esq\Desktop\jarvis-android"
set JAVA_HOME=C:\Program Files\Android\Android Studio\jbr
set ANDROID_HOME=D:\Android\Sdk
set ANDROID_SDK_ROOT=D:\Android\Sdk
set GRADLE_HOME=C:\Users\t_esq\.gradle\wrapper\dists\gradle-8.7-bin\bhs2wmbdwecv87pi65oeuq5iu\gradle-8.7
set PATH=%JAVA_HOME%\bin;%GRADLE_HOME%\bin;%PATH%
echo JAVA_HOME: %JAVA_HOME%
echo ANDROID_HOME: %ANDROID_HOME%
echo GRADLE: %GRADLE_HOME%\bin\gradle.bat
echo.
echo Corriendo: gradle assembleDebug --no-daemon
call "%GRADLE_HOME%\bin\gradle.bat" assembleDebug --no-daemon
echo.
echo Codigo de salida: %ERRORLEVEL%
if exist "app\build\outputs\apk\debug\app-debug.apk" (
    echo BUILD EXITOSO! Copiando APK al Escritorio...
    copy "app\build\outputs\apk\debug\app-debug.apk" "%USERPROFILE%\Desktop\JARVIS.apk"
    echo JARVIS.apk listo en el Escritorio!
) else (
    echo BUILD FALLO - APK no encontrado
)
pause