@echo off
cd /d "C:\Users\kaiso\Desktop\copiqpolice"
echo Lancement flutter analyze...
flutter analyze --no-pub > erreurs_frais.txt 2>&1
echo Termine ! Resultat dans erreurs_frais.txt
