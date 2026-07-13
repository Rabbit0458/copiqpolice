@echo off
title CoPiQ - Generation 9M+ Questions - NE PAS FERMER
color 0A
echo.
echo  ============================================================
echo   CoPiQ Police - Generateur autonome overnight
echo   9 000 000+ questions de culture generale
echo   NE PAS FERMER CETTE FENETRE !
echo  ============================================================
echo.

cd /d C:\Users\kaiso\Desktop\copiqpolice

echo [1/3] Verification de Python...
python --version
if errorlevel 1 (
    py --version
    if errorlevel 1 (
        echo ERREUR: Python non installe.
        pause
        exit /b 1
    )
    set PYTHON_CMD=py
) else (
    set PYTHON_CMD=python
)

echo [2/3] Installation des dependances...
%PYTHON_CMD% -m pip install aiohttp -q 2>nul

echo [3/3] Lancement de la generation en boucle...
echo  Objectif : 500 executions x ~20 000 lignes = 10 000 000+ lignes
echo  ============================================================

set /a TOTAL_RUNS=0
for /L %%i in (1, 1, 600) do (
    echo.
    echo  [Run %%i/600] - %TIME%
    %PYTHON_CMD% generate_local.py
    if errorlevel 1 (
        echo  ERREUR run %%i - pause 15s...
        timeout /t 15 /nobreak > nul
    )
    set /a TOTAL_RUNS=%%i
    echo  Cumul : %%i runs termines.
)

echo.
echo  ============================================================
echo   GENERATION TERMINEE ! %TOTAL_RUNS% runs effectues.
echo   Voir generation_local_log.txt pour les details.
echo  ============================================================
pause
