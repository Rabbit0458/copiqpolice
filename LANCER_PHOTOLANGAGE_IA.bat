@echo off
title COP'IQ - Lot test photolangage IA (10 images)
color 0B
echo.
echo  ============================================================
echo   COP'IQ - Generation lot test photolangage (10 images IA)
echo  ============================================================
echo.

cd /d C:\Users\kaiso\Desktop\copiqpolice

echo [1/2] Verification de Python...
python --version >nul 2>&1
if errorlevel 1 (
    py --version >nul 2>&1
    if errorlevel 1 (
        echo ERREUR: Python non installe.
        pause
        exit /b 1
    )
    set PYTHON_CMD=py
) else (
    set PYTHON_CMD=python
)

echo [2/2] Lancement de la generation...
echo.
%PYTHON_CMD% generer_photolangage_ia.py

echo.
echo  ------------------------------------------------------------
echo   Fini. Les images sont dans le dossier apercu_photolangage_ia
echo  ------------------------------------------------------------
pause
