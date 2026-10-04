# COP’IQ — lancer la version 1.1.0, build 7, sur Mac

## Dossier à transférer

Utiliser **C:\Users\kaiso\Desktop\COPIQPOLICEAPP\copiqpolice** : c’est la copie modifiée pour les paiements et publicités. Le dossier **C:\Users\kaiso\Desktop\copiqpolice** est une autre copie, ne pas les confondre.

Transférer les sources, notamment `lib`, `ios`, `assets`, `config`, `scripts`, `pubspec.yaml` et `pubspec.lock`. Les dossiers générés `build`, `.dart_tool`, `ios/Pods` et `node_modules` peuvent être exclus. Ne pas ajouter de clé Apple privée, de JSON Google de compte de service ou de mot de passe dans l’application.

## Préparer puis ouvrir Xcode

Sur le Mac, installer Flutter (version utilisée ici : 3.47.5), Xcode et CocoaPods, ouvrir Xcode une première fois et terminer son installation. Dans le Terminal, depuis le dossier du projet :

```bash
bash scripts/prepare-mac-ios.sh
```

Le script régénère les chemins Flutter pour le Mac, installe les dépendances iOS et ouvre **ios/Runner.xcworkspace**. Il s’arrête en cas d’erreur. Ne pas ouvrir seulement Runner.xcodeproj.

Dans Xcode, choisir Runner, l’équipe **W2S6S626U9** dans Signing & Capabilities et la signature automatique. Conserver l’identifiant **fr.copiq.app**. Connecter et sélectionner l’iPhone, puis lancer Run. Le compte Apple connecté à Xcode doit appartenir à cette équipe. La version provient du pubspec : **1.1.0+7**, soit version 1.1.0 et numéro de build 7.

## Paiements et validation

Les clés publiques SDK RevenueCat sont incluses dans `config/revenuecat.public.json`, aussi chargé par l’application sans paramètres de compilation. Un paramètre `--dart-define` explicite reste prioritaire et doit correspondre à la plateforme. Les clés secrètes et clés de test RevenueCat sont refusées par cette configuration.

La connexion aux services de production ne transforme pas une installation de développement en achat réel : tester avec l’environnement sandbox Apple ou TestFlight. Avant la publication, vérifier achat mensuel et annuel, restauration, annulation, changement de compte et synchronisation des droits RevenueCat/Supabase. Les publicités doivent disparaître pour Premium et respecter les réglages administrateur pour les utilisateurs gratuits. Contrôler Scolarité GPX, Scolarité PA, Exam GPX et Exam PA.

Pour TestFlight : sélectionner une destination iOS générique, Product > Archive, puis Distribute App dans Organizer. Vérifier la version 1.1.0 (7). Si le build 7 a déjà été envoyé, augmenter le numéro dans pubspec puis relancer le script. La fiche de version App Store Connect doit correspondre à 1.1.0 avant soumission.

## État réel

- Configuration locale préparée, sans compilation Xcode ni signature vérifiées sur Windows.
- Notifications Google vers RevenueCat et webhook RevenueCat vers Supabase testés ; cela ne valide pas encore un achat.
- Le dernier build TestFlight consulté était 1.0.0 (5), antérieur aux changements.
- Google : catalogue d’abonnements à terminer après import d’un AAB compatible, signature Android encore à retrouver/configurer.
- Export administrateur dans `fae16dc1`, à déployer avec ses ressources `_next`.
- Aucune publication publique effectuée.
