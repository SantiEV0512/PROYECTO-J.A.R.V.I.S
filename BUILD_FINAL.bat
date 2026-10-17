@echo off
setlocal enabledelayedexpansion

set "PROJ=C:\Users\t_esq\Desktop\jarvis-android"
set "LOG=%PROJ%\BUILD_FINAL_LOG.txt"

echo ============================================= > "%LOG%"
echo  JARVIS APK - BUILD FINAL >> "%LOG%"
echo  %DATE% %TIME% >> "%LOG%"
echo ============================================= >> "%LOG%"
echo. >> "%LOG%"

REM === RUTAS CONFIRMADAS ===
set "JAVA_HOME=C:\Program Files\Android\Android Studio\jbr"
set "GRADLE_EXE=C:\Users\t_esq\.gradle\wrapper\dists\gradle-8.7-bin\bhs2wmbdwecv87pi65oeuq5iu\gradle-8.7\bin\gradle.bat"
set "ANDROID_HOME=D:\Android\Sdk"
set "GRADLE_USER_HOME=C:\Users\t_esq\.gradle"

echo JAVA_HOME: %JAVA_HOME% >> "%LOG%"
echo GRADLE_EXE: %GRADLE_EXE% >> "%LOG%"
echo ANDROID_HOME: %ANDROID_HOME% >> "%LOG%"
echo. >> "%LOG%"

REM === VERIFICACIONES ===
echo [VERIFY] Comprobando Java... >> "%LOG%"
if not exist "%JAVA_HOME%\bin\java.exe" (
    echo ERROR: Java no encontrado en: %JAVA_HOME% >> "%LOG%"
    echo ERROR: Java no encontrado.
    pause
    exit /b 1
)
echo   OK - Java encontrado >> "%LOG%"

echo [VERIFY] Comprobando Gradle... >> "%LOG%"
if not exist "%GRADLE_EXE%" (
    echo ERROR: Gradle no encontrado en: %GRADLE_EXE% >> "%LOG%"
    echo ERROR: Gradle no encontrado.
    pause
    exit /b 1
)
echo   OK - Gradle 8.7 encontrado >> "%LOG%"

echo [VERIFY] Comprobando Android SDK... >> "%LOG%"
if not exist "%ANDROID_HOME%\platform-tools\adb.exe" (
    echo WARNING: SDK puede no estar completo >> "%LOG%"
) else (
    echo   OK - SDK encontrado >> "%LOG%"
)
echo. >> "%LOG%"

REM === CONFIGURAR ENTORNO ===
set "PATH=%JAVA_HOME%\bin;%PATH%"
set "ANDROID_SDK_ROOT=%ANDROID_HOME%"

echo [ENV] Configurando local.properties... >> "%LOG%"
echo sdk.dir=D\:\\Android\\Sdk> "%PROJ%\local.properties"
echo   OK >> "%LOG%"
echo. >> "%LOG%"

REM === LIMPIAR LOCK FILES ===
echo [CLEAN] Eliminando lock files... >> "%LOG%"
del /q "%PROJ%\.gradle\*.lock" 2>nul
del /q "%PROJ%\.gradle\8.7\*.lock" 2>nul
del /q "%GRADLE_USER_HOME%\*.lock" 2>nul
echo   OK >> "%LOG%"
echo. >> "%LOG%"

REM === EJECUTAR BUILD ===
echo [BUILD] Ejecutando Gradle assembleDebug... >> "%LOG%"
echo   Esto puede tardar 5-15 minutos la primera vez... >> "%LOG%"
echo. >> "%LOG%"

cd /d "%PROJ%"

call "%GRADLE_EXE%" assembleDebug ^
    --no-daemon ^
    --project-dir "%PROJ%" ^
    -Dorg.gradle.user.home="%GRADLE_USER_HOME%" ^
    -Dandroid.aapt2FromMavenOverride="" ^
    >> "%LOG%" 2>&1

set BUILD_CODE=%ERRORLEVEL%

echo. >> "%LOG%"
echo ============================================= >> "%LOG%"
echo  RESULTADO FINAL: %BUILD_CODE% >> "%LOG%"
echo ============================================= >> "%LOG%"

if %BUILD_CODE% == 0 (
    echo BUILD EXITOSO! >> "%LOG%"
    set "APK_SRC=%PROJ%\app\build\outputs\apk\debug\app-debug.apk"
    if exist "!APK_SRC!" (
        copy "!APK_SRC!" "C:\Users\t_esq\Desktop\JARVIS.apk" >nul 2>&1
        echo APK copiado a: C:\Users\t_esq\Desktop\JARVIS.apk >> "%LOG%"
        echo.
        echo *******************************************
        echo  BUILD EXITOSO!
        echo  APK listo en: C:\Users\t_esq\Desktop\JARVIS.apk
        echo *******************************************
    ) else (
        echo WARNING: APK no encontrado en ruta esperada >> "%LOG%"
        echo WARNING: APK no encontrado en la ruta esperada
    )
) else (
    echo BUILD FALLO con codigo: %BUILD_CODE% >> "%LOG%"
    echo.
    echo *** BUILD FALLO (codigo %BUILD_CODE%) ***
    echo Ultimas lineas relevantes del log:
    echo.
    type "%LOG%" | findstr /i "error: ERROR FAILURE exception Could not"
)

echo.
echo Log completo guardado en:
echo   %LOG%
echo.
pause
