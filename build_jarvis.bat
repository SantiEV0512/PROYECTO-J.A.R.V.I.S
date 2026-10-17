@echo off
setlocal enabledelayedexpansion

set "PROJECT_DIR=C:\Users\t_esq\Desktop\jarvis-android"
set "JAVA_HOME=C:\Program Files\Android\Android Studio\jbr"
set "ANDROID_SDK_ROOT=D:\Android\Sdk"
set "GRADLE_HOME=C:\Users\t_esq\.gradle\wrapper\dists\gradle-8.7-bin\bhs2wmbdwecv87pi65oeuq5iu\gradle-8.7"
set "GRADLE_EXE=%GRADLE_HOME%\bin\gradle.bat"
set "LOG=%PROJECT_DIR%\build_output.txt"

echo ============================================= > "%LOG%"
echo  JARVIS APK BUILD SCRIPT >> "%LOG%"
echo  %DATE% %TIME% >> "%LOG%"
echo ============================================= >> "%LOG%"
echo. >> "%LOG%"

echo JAVA_HOME: %JAVA_HOME% >> "%LOG%"
echo ANDROID_SDK_ROOT: %ANDROID_SDK_ROOT% >> "%LOG%"
echo GRADLE: %GRADLE_EXE% >> "%LOG%"
echo. >> "%LOG%"

if not exist "%GRADLE_EXE%" (
    echo ERROR: gradle.bat NOT FOUND at: >> "%LOG%"
    echo   %GRADLE_EXE% >> "%LOG%"
    goto :done
)
echo Gradle OK >> "%LOG%"

if not exist "%JAVA_HOME%\bin\java.exe" (
    echo WARNING: JAVA_HOME not found, using system Java >> "%LOG%"
    set "JAVA_HOME="
) else (
    echo Java OK >> "%LOG%"
)
echo. >> "%LOG%"

cd /d "%PROJECT_DIR%"
echo Changed to: %CD% >> "%LOG%"
echo. >> "%LOG%"

echo Running: gradle assembleDebug >> "%LOG%"
echo ---- Gradle output ---- >> "%LOG%"

set "PATH=%JAVA_HOME%\bin;%PATH%"
call "%GRADLE_EXE%" assembleDebug -p "%PROJECT_DIR%" >> "%LOG%" 2>&1
set BUILD_RESULT=!ERRORLEVEL!

echo ---- End of output ---- >> "%LOG%"
echo. >> "%LOG%"

if !BUILD_RESULT! == 0 (
    echo BUILD SUCCESSFUL! >> "%LOG%"
    echo. >> "%LOG%"
    set "APK=%PROJECT_DIR%\app\build\outputs\apk\debug\app-debug.apk"
    if exist "!APK!" (
        echo APK found: >> "%LOG%"
        echo   !APK! >> "%LOG%"
    ) else (
        echo WARNING: APK not found at expected path >> "%LOG%"
    )
) else (
    echo BUILD FAILED - error code: !BUILD_RESULT! >> "%LOG%"
)

:done
echo. >> "%LOG%"
echo ============================================= >> "%LOG%"
echo Finished at %DATE% %TIME% >> "%LOG%"
echo =============================================

type "%LOG%"
echo.
echo Build complete! Log saved to: %LOG%
pause
