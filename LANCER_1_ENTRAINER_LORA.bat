@echo off
title COP'IQ - Etape 1 : entrainement du LoRA Police Nationale
color 0E
echo.
echo  ============================================================
echo   COP'IQ - Entrainement du modele "Police Nationale" (LoRA)
echo   Duree ~2-3 min, cout < 2 dollars
echo  ============================================================
echo.

cd /d C:\Users\kaiso\Desktop\copiqpolice

echo [1/2] Verification de Python + Pillow...
python --version >nul 2>&1
if errorlevel 1 (
    set PYTHON_CMD=py
) else (
    set PYTHON_CMD=python
)
%PYTHON_CMD% -m pip install pillow -q 2>nul

echo [2/2] Lancement de l'entrainement...
echo.
%PYTHON_CMD% entrainer_lora.py

echo.
pause
