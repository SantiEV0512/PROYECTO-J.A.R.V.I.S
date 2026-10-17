@echo off
chcp 65001 >nul
title Subir JARVIS a GitHub
cd /d "%~dp0"
echo.
echo ==============================================
echo   J.A.R.V.I.S. — SUBIDA A GITHUB
echo ==============================================
echo.
echo Antes de continuar:
echo   1. Entra a https://github.com/new
echo   2. Crea un repo nuevo llamado "jarvis-app"
echo      (marca "Private" si quieres que sea privado)
echo      NO marques README/gitignore/license — los traemos nosotros.
echo   3. Copia la URL que te muestra (algo como
echo      https://github.com/tu-usuario/jarvis-app.git)
echo.
set /p REPO_URL=Pega la URL del repo y presiona Enter:

if "%REPO_URL%"=="" (
  echo No diste URL. Cancelando.
  pause
  exit /b 1
)

echo.
echo Limpiando git anterior (si lo hay)...
if exist ".git" rmdir /s /q ".git"

echo.
echo Inicializando repo...
git init -b main
if errorlevel 1 (
  echo ERROR: ¿Está instalado Git? Descárgalo de https://git-scm.com/
  pause
  exit /b 1
)

git config user.email "santiago.esquivel0512@gmail.com"
git config user.name "Santiago Esquivel"

echo.
echo Agregando archivos al commit...
git add .
git commit -m "JARVIS · proyecto inicial (web + android + logo)"

echo.
echo Configurando remote...
git remote add origin %REPO_URL%

echo.
echo Subiendo...  (si pide login, usa tu usuario de GitHub y un
echo Personal Access Token como contraseña — NO tu password)
echo Crea uno en: https://github.com/settings/tokens
echo.
git push -u origin main

if errorlevel 1 (
  echo.
  echo Hubo un error al subir. Verifica:
  echo   - La URL del repo (debe terminar en .git)
  echo   - Tu Personal Access Token con permiso "repo"
  echo.
) else (
  echo.
  echo ==============================================
  echo   ✓ LISTO — tu codigo esta en GitHub
  echo ==============================================
  echo   Ve a: %REPO_URL:.git=%
  echo.
)
pause
