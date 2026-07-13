@echo off
title CoPiQ - Generateur 10M Questions

echo.
echo ===================================================
echo   CoPiQ - Generateur v5 (10 000 000 questions)
echo   Objectif : 750 000 questions x 14 categories
echo ===================================================
echo.

cd /d "%~dp0"

python --version >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [ERREUR] Python n'est pas installe ou pas dans le PATH.
    pause
    exit /b 1
)

python -c "import aiohttp" >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [INFO] Installation de aiohttp...
    pip install aiohttp --quiet
)

echo [INFO] Demarrage de la generation...
echo [INFO] Logs enregistres dans gen_v2.log
echo [INFO] Duree estimee : 30 a 60 minutes.
echo.

python generate_v2.py

echo.
echo ===================================================
echo   Termine ! Consultez gen_v2.log pour le bilan.
echo ===================================================
pause
