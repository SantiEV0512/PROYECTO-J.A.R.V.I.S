@echo off
setlocal enabledelayedexpansion

set "PROJECT_DIR=C:\Users\t_esq\Desktop\jarvis-android"
set "JAVA_HOME=C:\Program Files\Android\Android Studio\jbr"
set "ANDROID_SDK_ROOT=D:\Android\Sdk"
set "LOG=%PROJECT_DIR%\build_output.txt"
set "JAVA_EXE=%JAVA_HOME%\bin\java.exe"
set "WRAPPER_JAR=%PROJECT_DIR%\gradle\wrapper\gradle-wrapper.jar"

echo ============================================= > "%LOG%"
echo  JARVIS APK BUILD SCRIPT >> "%LOG%"
echo  %DATE% %TIME% >> "%LOG%"
echo ============================================= >> "%LOG%"
echo. >> "%LOG%"

echo Checking Java... >> "%LOG%"
if not exist "%JAVA_EXE%" (
    echo ERROR: Java not found at %JAVA_EXE% >> "%LOG%"
    echo Trying system java... >> "%LOG%"
    set "JAVA_EXE=java"
)
echo Java: %JAVA_EXE% >> "%LOG%"
echo. >> "%LOG%"

echo Checking gradle-wrapper.jar... >> "%LOG%"
if not exist "%WRAPPER_JAR%" (
    echo ERROR: gradle-wrapper.jar NOT FOUND at %WRAPPER_JAR% >> "%LOG%"
    echo Cannot build without gradle wrapper! >> "%LOG%"
    goto :done
)
echo Found: %WRAPPER_JAR% >> "%LOG%"
echo. >> "%LOG%"

cd /d "%PROJECT_DIR%"
echo Changed to project directory >> "%LOG%"
echo. >> "%LOG%"

echo Running: gradle assembleDebug >> "%LOG%"
echo ---- Gradle output below ---- >> "%LOG%"

set "JAVA_OPTS=-Xmx2g -Xms512m"
"%JAVA_EXE%" %JAVA_OPTS% -classpath "%WRAPPER_JAR%" org.gradle.wrapper.GradleWrapperMain assembleDebug >> "%LOG%" 2>&1
set BUILD_RESULT=%ERRORLEVEL%

echo. >> "%LOG%"
echo ---- Gradle output end ---- >> "%LOG%"
echo. >> "%LOG%"

if %BUILD_RESULT% == 0 (
    echo BUILD SUCCESSFUL! >> "%LOG%"
    echo. >> "%LOG%"
    if exist "%PROJECT_DIR%\app\build\outputs\apk\debug\app-debug.apk" (
        echo APK found at: >> "%LOG%"
        echo   %PROJECT_DIR%\app\build\outputs\apk\debug\app-debug.apk >> "%LOG%"
    )
) else (
    echo BUILD FAILED with error code %BUILD_RESULT% >> "%LOG%"
)

:done
echo. >> "%LOG%"
echo ============================================= >> "%LOG%"
echo Finished at %DATE% %TIME% >> "%LOG%"

type "%LOG%"
echo.
echo =============================================
echo Script complete. Check build_output.txt
pause