@echo off
setlocal enabledelayedexpansion

set "PROJ=C:\Users\t_esq\Desktop\jarvis-android"
set "LOG=%PROJ%\build_direct_log.txt"

echo ============================================= > "%LOG%"
echo  JARVIS BUILD - Gradle Directo >> "%LOG%"
echo  %DATE% %TIME% >> "%LOG%"
echo ============================================= >> "%LOG%"

echo. >> "%LOG%"
echo [1] Buscando Java (JBR de Android Studio)... >> "%LOG%"

REM Buscar Java - probar rutas comunes de Android Studio
set "JAVA_HOME="
set "JAVA_CANDIDATES=C:\Program Files\Android\Android Studio\jbr C:\Program Files\Android\Android Studio\jre C:\Program Files\Android\Android Studio\plugins\kotlinc\jre C:\Program Files\Java\jdk-17 C:\Program Files\Java\jdk-21 C:\Program Files\Eclipse Adoptium\jdk-17.0.11.9-hotspot C:\Program Files\Microsoft\jdk-17.0.12.7-hotspot C:\Program Files\Java\jdk1.8.0_201"

for %%J in (%JAVA_CANDIDATES%) do (
    if exist "%%J\bin\java.exe" (
        if "!JAVA_HOME!"=="" (
            set "JAVA_HOME=%%J"
        )
    )
)

if "!JAVA_HOME!"=="" (
    echo Buscando Android Studio en AppData... >> "%LOG%"
    for /d %%D in ("C:\Users\t_esq\AppData\Local\Android Studio*") do (
        if exist "%%D\jbr\bin\java.exe" (
            if "!JAVA_HOME!"=="" set "JAVA_HOME=%%D\jbr"
        )
    )
)

if "!JAVA_HOME!"=="" (
    echo Buscando en Program Files... >> "%LOG%"
    for /r "C:\Program Files\Android" %%f in (java.exe) do (
        if "!JAVA_HOME!"=="" (
            for %%d in ("%%~dpf..") do set "JAVA_HOME=%%~fd"
        )
    )
)

if "!JAVA_HOME!"=="" (
    REM Intentar usar java del PATH
    where java >nul 2>&1
    if !ERRORLEVEL!==0 (
        for /f "delims=" %%i in ('where java') do (
            if "!JAVA_HOME!"=="" set "JAVA_BIN=%%i"
        )
        set "JAVA_HOME=!JAVA_BIN!\..\.."
    )
)

if "!JAVA_HOME!"=="" (
    echo ERROR: No se encontro Java >> "%LOG%"
    echo ERROR: No se encontro Java. Necesitas Android Studio o JDK 17+
    type "%LOG%"
    pause
    exit /b 1
)

echo   JAVA_HOME=!JAVA_HOME! >> "%LOG%"
set "PATH=!JAVA_HOME!\bin;%PATH%"
"!JAVA_HOME!\bin\java.exe" -version >> "%LOG%" 2>&1

echo. >> "%LOG%"
echo [2] Buscando Gradle en cache del sistema... >> "%LOG%"

REM Buscar Gradle descargado por Android Studio / wrapper anterior
set "GRADLE_EXE="
set "GRADLE_HOME_CACHE=C:\Users\t_esq\.gradle\wrapper\dists"

if exist "%GRADLE_HOME_CACHE%" (
    for /d %%G in ("%GRADLE_HOME_CACHE%\gradle-8.7-bin\*") do (
        if exist "%%G\gradle-8.7\bin\gradle.bat" (
            if "!GRADLE_EXE!"=="" (
                set "GRADLE_EXE=%%G\gradle-8.7\bin\gradle.bat"
                echo   Gradle encontrado: !GRADLE_EXE! >> "%LOG%"
            )
        )
    )
    REM Si no hay 8.7, buscar cualquier Gradle compatible
    if "!GRADLE_EXE!"=="" (
        for /d %%V in ("%GRADLE_HOME_CACHE%\gradle-8*") do (
            for /d %%H in ("%%V\*") do (
                for /d %%B in ("%%H\gradle-8*\bin") do (
                    if exist "%%B\gradle.bat" (
                        if "!GRADLE_EXE!"=="" (
                            set "GRADLE_EXE=%%B\gradle.bat"
                            echo   Gradle alternativo: !GRADLE_EXE! >> "%LOG%"
                        )
                    )
                )
            )
        )
    )
)

if "!GRADLE_EXE!"=="" (
    echo   No se encontro Gradle en cache, buscando en Android Studio... >> "%LOG%"
    for /r "C:\Program Files\Android\Android Studio" %%f in (gradle.bat) do (
        if "!GRADLE_EXE!"=="" set "GRADLE_EXE=%%f"
    )
)

if "!GRADLE_EXE!"=="" (
    echo ERROR: No se encontro Gradle instalado en el sistema >> "%LOG%"
    echo.
    echo ERROR: Gradle no encontrado.
    echo Opciones:
    echo   1. Abre Android Studio y sincroniza el proyecto (esto descarga Gradle)
    echo   2. Descarga Gradle 8.7 manualmente de https://gradle.org/releases/
    echo   3. Coloca gradle-wrapper.jar en gradle\wrapper\
    type "%LOG%"
    pause
    exit /b 1
)

echo   Usando Gradle: !GRADLE_EXE! >> "%LOG%"

echo. >> "%LOG%"
echo [3] Verificando Android SDK... >> "%LOG%"
set "ANDROID_HOME=D:\Android\Sdk"
if not exist "!ANDROID_HOME!" (
    for /d %%D in (D:\Android\* E:\Android\Sdk) do (
        if exist "%%D\platform-tools\adb.exe" (
            if "!ANDROID_HOME_FOUND!"=="" (
                set "ANDROID_HOME=%%D"
                set "ANDROID_HOME_FOUND=1"
            )
        )
    )
)
set "ANDROID_SDK_ROOT=!ANDROID_HOME!"
echo   ANDROID_HOME=!ANDROID_HOME! >> "%LOG%"

echo. >> "%LOG%"
echo [4] Escribiendo local.properties... >> "%LOG%"
echo sdk.dir=D\:\\Android\\Sdk> "%PROJ%\local.properties"

echo. >> "%LOG%"
echo [5] Ejecutando Gradle assembleDebug... >> "%LOG%"
echo    Usando: !GRADLE_EXE! >> "%LOG%"
echo. >> "%LOG%"

set "GRADLE_USER_HOME=C:\Users\t_esq\.gradle"
set "GRADLE_OPTS=-Xmx1024m"

cd /d "%PROJ%"

call "!GRADLE_EXE!" assembleDebug ^
    --no-daemon ^
    --stacktrace ^
    --project-dir "%PROJ%" ^
    -Dorg.gradle.user.home="C:\Users\t_esq\.gradle" ^
    >> "%LOG%" 2>&1

set BUILD_RESULT=%ERRORLEVEL%

echo. >> "%LOG%"
echo ======================================= >> "%LOG%"
echo RESULTADO: !BUILD_RESULT! >> "%LOG%"
echo ======================================= >> "%LOG%"

if !BUILD_RESULT!==0 (
    set "APK=%PROJ%\app\build\outputs\apk\debug\app-debug.apk"
    if exist "!APK!" (
        copy "!APK!" "C:\Users\t_esq\Desktop\JARVIS.apk" >nul
        echo APK COPIADO A: C:\Users\t_esq\Desktop\JARVIS.apk >> "%LOG%"
        echo.
        echo *** BUILD EXITOSO! APK: C:\Users\t_esq\Desktop\JARVIS.apk ***
    ) else (
        echo APK no encontrado en ruta esperada >> "%LOG%"
    )
) else (
    echo BUILD FALLO >> "%LOG%"
    echo.
    echo *** FALLO - Ultimas lineas del log: ***
    type "%LOG%" | findstr /i "error: warning: fail FAILURE exception"
)

echo.
echo Log completo: %LOG%
echo.
pause
