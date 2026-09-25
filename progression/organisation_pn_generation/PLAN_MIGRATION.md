# Plan de migration additive et réversible

## Principes

- aucune suppression physique de question, historique ou signalement ;
- aucune modification de production avant contrôles finaux et confirmation explicite ;
- schéma canonique nouveau, puis pont de compatibilité avec l'existant ;
- toutes les nouvelles données commencent en staging/draft ;
- activation unique dans une transaction protégée par verrou advisory.

## Séquence prévue

1. Créer avec la CLI une migration additive après vérification de sa version et de son aide intégrée.
2. Ajouter les tables de versions, questions canoniques, affectations, runs, staging, validations, doublons, archives et déploiements.
3. Activer RLS partout, révoquer `public`/`anon`, limiter `authenticated` à la lecture publiée nécessaire et conserver les mutations côté serveur.
4. Créer la RPC de session en `security invoker` si les politiques suffisent ; sinon placer l'aide privilégiée dans `private`, avec `search_path=''`, noms qualifiés, garde utilisateur et grants minimaux.
5. Étendre les RPC admin existantes avec une liste blanche statique de la banque canonique, contrôle rôle/MFA et audit avant/après.
6. Charger le JSONL validé dans le staging uniquement.
7. Exécuter les contraintes SQL, validateurs locaux, déduplication globale et contrôles de sources.
8. Importer en draft/review/validated, jamais directement en published.
9. Archiver logiquement l'ancienne banque Organisation et conserver son mapping historique.
10. Basculer la version validée sous verrou advisory ; enregistrer versions avant/après et compteurs.
11. Tester le rollback vers le pointeur de version précédent, sans effacer la nouvelle version.

## Traitement des migrations locales préexistantes

Les migrations `20260828120000` à `20260828123000` ne seront pas rejouées. Comme elles sont non suivies par Git et potentiellement déjà testées dans un environnement inconnu, le plan correctif doit :

- détecter idempotemment leurs objets éventuels ;
- ne jamais supposer leurs données officielles ;
- désactiver l'accès à la RPC non conforme avant d'exposer la nouvelle ;
- importer les ids historiques uniquement comme références d'archive ;
- éviter toute collision de noms ou d'historique de migration.

## Contrôle pré-production obligatoire

Avant toute base distante, le rapport affichera : identifiant exact du projet, environnement, version précédente/nouvelle, créations, affectations, archives, rejets, doublons, état RLS/grants/RPC, conservation des historiques/signalements, tests Flutter/panel, test de rollback et empreinte des exports. L'exécution attendra ensuite une confirmation explicite du propriétaire.
