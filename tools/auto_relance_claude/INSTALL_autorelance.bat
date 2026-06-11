@echo off
title INSTALL AUTO-RELANCE CLAUDE
cd /d "%~dp0"

echo ============================================================
echo  INSTALLATION AUTO-RELANCE CLAUDE
echo  -----------------------------------------------------------
echo  1. Installe les dependances Python (pip)
echo  2. Verifie Tesseract OCR
echo  3. Cree un raccourci dans Startup Windows
echo     pour demarrer automatiquement au boot
echo ============================================================
echo.

echo [1/3] Installation des dependances Python...
echo.
pip install --upgrade pyautogui pillow pytesseract pygetwindow pyperclip
if errorlevel 1 (
    echo.
    echo ECHEC pip install. Verifie que Python est installe.
    pause
    exit /b 1
)

echo.
echo [2/3] Verification Tesseract OCR...
if exist "C:\Program Files\Tesseract-OCR\tesseract.exe" (
    echo OK : Tesseract trouve.
) else (
    echo.
    echo ATTENTION : Tesseract OCR n'est pas installe.
    echo Telecharge-le ici : https://github.com/UB-Mannheim/tesseract/wiki
    echo Sans Tesseract, le script tourne en mode "blind heartbeat" seulement
    echo (envoie auto toutes les 5h30, sans detection precise).
    echo.
)

echo.
echo [3/3] Creation du raccourci de demarrage automatique...
echo.

set "STARTUP=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
set "SHORTCUT=%STARTUP%\AutoRelanceClaude.lnk"
set "TARGET=%~dp0start_relance_claude.bat"

powershell -NoProfile -Command ^
  "$ws = New-Object -ComObject WScript.Shell;" ^
  "$sc = $ws.CreateShortcut('%SHORTCUT%');" ^
  "$sc.TargetPath = '%TARGET%';" ^
  "$sc.WorkingDirectory = '%~dp0';" ^
  "$sc.WindowStyle = 7;" ^
  "$sc.Description = 'Auto-relance Claude pour codage continu';" ^
  "$sc.Save();"

if exist "%SHORTCUT%" (
    echo OK : raccourci cree dans Startup.
    echo Le script demarrera automatiquement au prochain boot.
) else (
    echo ECHEC : raccourci non cree.
)

echo.
echo ============================================================
echo  INSTALLATION TERMINEE
echo ============================================================
echo.
echo Etapes suivantes :
echo.
echo  1. Connecte-toi a Claude.ai dans son app desktop ou navigateur
echo  2. Lance start_relance_claude.bat pour demarrer MAINTENANT
echo     (ou redemarre Windows pour le test du startup auto)
echo  3. Desactive la mise en veille Windows :
echo     Parametres ^> Systeme ^> Alimentation ^> Jamais
echo  4. Verifie le log auto_relance.log pour suivre l'activite
echo.
pause
