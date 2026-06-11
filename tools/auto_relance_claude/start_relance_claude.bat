@echo off
title AUTO-RELANCE CLAUDE [autonome]
cd /d "%~dp0"

REM ============================================================
REM  Boucle infinie : si Python crashe, on relance dans 30s.
REM  Garantit que le script ne s'arrete JAMAIS sans intervention.
REM ============================================================

:LOOP
echo.
echo [%date% %time%] Lancement du script Python...
echo.

python auto_relance_claude.py

echo.
echo [%date% %time%] Le script Python s'est arrete. Restart dans 30s...
echo Pour stopper DEFINITIVEMENT : ferme cette fenetre.
echo.

timeout /t 30 /nobreak >nul

goto LOOP
