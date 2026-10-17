@echo off
echo Descargando gradle-wrapper.jar...
echo.

set "DEST=C:\Users\t_esq\Desktop\jarvis-android\gradle\wrapper\gradle-wrapper.jar"
set "URL=https://github.com/gradle/gradle/raw/v8.7.0/gradle/wrapper/gradle-wrapper.jar"

REM Intentar con PowerShell
powershell -Command "try { $ProgressPreference='SilentlyContinue'; Invoke-WebRequest -Uri '%URL%' -OutFile '%DEST%' -UseBasicParsing; Write-Host 'DESCARGA OK' } catch { Write-Host 'ERROR:' $_.Exception.Message }"

if exist "%DEST%" (
    echo.
    echo EXITO: gradle-wrapper.jar descargado
    dir "%DEST%"
) else (
    echo ERROR: No se pudo descargar. Intentando con wget...
    where wget >nul 2>&1
    if %ERRORLEVEL%==0 (
        wget -O "%DEST%" "%URL%"
    ) else (
        echo wget no disponible.
        echo.
        echo Alternativa: buscando wrapper en el sistema...
        for /r "C:\Users\t_esq\.gradle" %%f in (gradle-wrapper.jar) do (
            echo Encontrado: %%f
            copy "%%f" "%DEST%"
            goto :found
        )
        for /r "C:\Program Files\Android" %%f in (gradle-wrapper.jar) do (
            echo Encontrado: %%f
            copy "%%f" "%DEST%"
            goto :found
        )
        echo No encontrado en el sistema.
        goto :end
        :found
        echo Copiado correctamente
    )
)

:end
echo.
pause
