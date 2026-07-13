@echo off
cd /d "C:\Users\kaiso\Desktop\copiqpolice"
echo Lancement flutter analyze v2...
flutter analyze --no-pub > erreurs_v2.txt 2>&1
echo Termine ! Resultat dans erreurs_v2.txt
