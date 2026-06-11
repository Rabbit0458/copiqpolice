@echo off
title UNINSTALL AUTO-RELANCE CLAUDE

echo ============================================================
echo  DESINSTALLATION du demarrage automatique
echo ============================================================
echo.

set "SHORTCUT=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\AutoRelanceClaude.lnk"

if exist "%SHORTCUT%" (
    del "%SHORTCUT%"
    echo OK : raccourci de demarrage supprime.
) else (
    echo Aucun raccourci de demarrage trouve.
)

echo.
echo Le script ne demarrera plus automatiquement au boot.
echo Tu peux toujours le lancer manuellement avec start_relance_claude.bat.
echo.
pause
