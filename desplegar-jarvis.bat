@echo off
title Desplegar JARVIS
cd /d "%~dp0"
echo.
echo =========================================
echo   J.A.R.V.I.S. - DESPLIEGUE A FIREBASE
echo =========================================
echo.
echo Subiendo la nueva version del HTML a:
echo   https://proyecto-jarvis-05s12ev.web.app
echo.
firebase deploy --only hosting
echo.
echo =========================================
echo   LISTO - Presiona cualquier tecla para cerrar
echo =========================================
pause >nul
