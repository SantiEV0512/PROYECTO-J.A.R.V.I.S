@echo off
setlocal enabledelayedexpansion

set "PROJ=C:\Users\t_esq\Desktop\jarvis-android"
set "LOG=%PROJ%\build_log_v2.txt"

echo ============================================= > "%LOG%"
echo  JARVIS BUILD v2 >> "%LOG%"
echo  %DATE% %TIME% >> "%LOG%"
echo ============================================= >> "%LOG%"
echo. >> "%LOG%"

REM =========================================================
REM 1. DETECTAR JAVA
REM =========================================================
echo [1] Buscando Java... >> "%LOG%"

REM Candidatos en orden de preferencia
set "JAVA_CANDIDATES=C:\Program Files\Android\Android Studio\jbr C:\Program Files\Android\Android Studio\jre C:\Program Files\Java\jdk-17 C:\Program Files\Java\jdk-21 C:\Program Files\Eclipse Adoptium\jdk-17.0.11.9-hotspot C:\Program Files\Microsoft\jdk-17.0.12.7-hotspot"

set "JAVA_HOME="
for %%J in (%JAVA_CANDIDATES%) do (
    if exist "%%J\bin\java.exe" (
        if "!JAVA_HOME!"=="" (
            set "JAVA_HOME=%%J"
            echo   JAVA_HOME=%%J >> "%LOG%"
        )
    )
)

REM Si no encontramos, buscar en PATH
if "!JAVA_HOME!"=="" (
    for /f "delims=" %%i in ('where java 2^>nul') do (
        if "!JAVA_HOME!"=="" (
            set "JAVA_EXE=%%i"
            for %%d in ("%%~dpi..") do set "JAVA_HOME=%%~fd"
            echo   JAVA desde PATH: !JAVA_HOME! >> "%LOG%"
        )
    )
)

if "!JAVA_HOME!"=="" (
    echo ERROR: No se encontro Java. Instala Android Studio o JDK. >> "%LOG%"
    echo ERROR: No se encontro Java.
    type "%LOG%"
    pause
    exit /b 1
)

echo   Usando JAVA_HOME=!JAVA_HOME! >> "%LOG%"
set "PATH=!JAVA_HOME!\bin;%PATH%"

REM Verificar version de java
echo   Java version: >> "%LOG%"
"!JAVA_HOME!\bin\java.exe" -version >> "%LOG%" 2>&1

echo. >> "%LOG%"

REM =========================================================
REM 2. CONFIGURAR GRADLE_USER_HOME EN C:
REM =========================================================
echo [2] Configurando Gradle home en C:... >> "%LOG%"
set "GRADLE_USER_HOME=C:\Users\t_esq\.gradle"
if not exist "%GRADLE_USER_HOME%" mkdir "%GRADLE_USER_HOME%"
echo   GRADLE_USER_HOME=!GRADLE_USER_HOME! >> "%LOG%"
echo. >> "%LOG%"

REM =========================================================
REM 3. VERIFICAR SDK
REM =========================================================
echo [3] Verificando Android SDK... >> "%LOG%"
set "ANDROID_HOME=D:\Android\Sdk"
if not exist "!ANDROID_HOME!" (
    echo   D:\Android\Sdk no existe, buscando... >> "%LOG%"
    for /d %%D in (D:\Android\* D:\* E:\Android\Sdk C:\Android\Sdk) do (
        if exist "%%D\platform-tools\adb.exe" (
            if "!ANDROID_HOME_FOUND!"=="" (
                set "ANDROID_HOME=%%D"
                set "ANDROID_HOME_FOUND=1"
                echo   Encontrado SDK en: %%D >> "%LOG%"
            )
        )
    )
)
echo   ANDROID_HOME=!ANDROID_HOME! >> "%LOG%"
set "ANDROID_SDK_ROOT=!ANDROID_HOME!"
echo. >> "%LOG%"

REM =========================================================
REM 4. VERIFICAR local.properties
REM =========================================================
echo [4] Verificando local.properties... >> "%LOG%"
set "LP=%PROJ%\local.properties"
echo sdk.dir=D\:\\Android\\Sdk> "%LP%"
echo   Escrito local.properties con D:\\Android\\Sdk >> "%LOG%"
echo. >> "%LOG%"

REM =========================================================
REM 5. LIMPIAR CACHE DE GRADLE (por si acaso hay lock files)
REM =========================================================
echo [5] Limpiando lock files de Gradle... >> "%LOG%"
del /q "%GRADLE_USER_HOME%\*.lock" 2>nul
del /q "%PROJ%\.gradle\*.lock" 2>nul
echo   Lock files eliminados >> "%LOG%"
echo. >> "%LOG%"

REM =========================================================
REM 6. CORRER GRADLE
REM =========================================================
echo [6] Ejecutando Gradle assembleDebug... >> "%LOG%"
echo   Esto puede tomar 5-15 minutos la primera vez... >> "%LOG%"
echo. >> "%LOG%"

cd /d "%PROJ%"

REM Flags importantes:
REM --no-daemon: evita problemas de permisos con el daemon
REM --stacktrace: muestra error completo
REM -Dorg.gradle.user.home: fuerza el home a C:
REM -Pandroid.injected.testOnly=false: evita flags de debug restrictivos

set "GRADLE_OPTS=-Xmx1024m"
set "JAVA_TOOL_OPTIONS="

call gradlew.bat assembleDebug ^
    --no-daemon ^
    --stacktrace ^
    --info ^
    -Dorg.gradle.user.home="C:\Users\t_esq\.gradle" ^
    >> "%LOG%" 2>&1

set BUILD_RESULT=%ERRORLEVEL%

echo. >> "%LOG%"
echo ============================================= >> "%LOG%"
echo  BUILD RESULT: !BUILD_RESULT! >> "%LOG%"
echo ============================================= >> "%LOG%"

if !BUILD_RESULT! == 0 (
    echo. >> "%LOG%"
    echo BUILD EXITOSO! >> "%LOG%"
    set "APK_SRC=%PROJ%\app\build\outputs\apk\debug\app-debug.apk"
    if exist "!APK_SRC!" (
        copy "!APK_SRC!" "C:\Users\t_esq\Desktop\JARVIS.apk" >> "%LOG%" 2>&1
        echo APK copiado a C:\Users\t_esq\Desktop\JARVIS.apk >> "%LOG%"
        echo.
        echo *** BUILD EXITOSO! APK en C:\Users\t_esq\Desktop\JARVIS.apk ***
    ) else (
        echo APK no encontrado en ruta esperada >> "%LOG%"
        echo WARNING: APK no encontrado
    )
) else (
    echo BUILD FALLO con codigo: !BUILD_RESULT! >> "%LOG%"
    echo.
    echo *** BUILD FALLO - revisa build_log_v2.txt en el proyecto ***
)

echo. >> "%LOG%"
echo Finished at %DATE% %TIME% >> "%LOG%"

echo.
echo Log guardado en: %LOG%
echo.
type "%LOG%" | findstr /i "error warning fail success apk BUILD"
echo.
pause
