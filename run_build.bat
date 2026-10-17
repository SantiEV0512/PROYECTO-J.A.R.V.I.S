@echo off
echo Iniciando build JARVIS...
cd /d "C:\Users\t_esq\Desktop\jarvis-android"
set JAVA_HOME=C:\Program Files\Android\Android Studio\jbr
set ANDROID_HOME=D:\Android\Sdk
set PATH=%JAVA_HOME%\bin;%PATH%
echo Corriendo: gradlew assembleDebug --no-daemon
call gradlew.bat assembleDebug --no-daemon
echo Codigo de salida: %ERRORLEVEL%
if exist "app\build\outputs\apk\debug\app-debug.apk" (
    echo BUILD EXITOSO! Copiando APK al Escritorio...
    copy "app\build\outputs\apk\debug\app-debug.apk" "%USERPROFILE%\Desktop\JARVIS.apk"
    echo JARVIS.apk listo en el Escritorio!
) else (
    echo BUILD FALLO - APK no encontrado
)
pause