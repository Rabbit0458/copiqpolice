# Progression — Migration complète des contenus PA/GPX

## Point de livraison technique certifié — 16 août 2026

### Réalisé et vérifié

- [x] **1 409/1 409 fichiers** lus, classés et enregistrés dans Supabase (759 GPX, 650 PA).
- [x] **1 232 cours et introductions** importés dans `cours_scolarite`.
- [x] **85 125 fragments de texte exacts** importés depuis 1 199 pages éditoriales.
- [x] **84 287 fragments exacts branchés dans Flutter**, répartis sur 1 198 pages, via `ScolariteText.value`, avec le texte Dart original comme secours hors ligne.
- [x] **838 fragments d’audit non branchés** conservés en base mais masqués du panneau ; aucun champ d’interpolation illisible n’est exposé.
- [x] Les **1 409 fichiers Dart passent le formateur** sans erreur de syntaxe.
- [x] L’**analyse Flutter complète passe sans erreur** après la conversion.
- [x] **422 paires GPX/PA identiques** détectées et liées ; aucune clé de texte liée ne manque dans la version jumelle.
- [x] Panneau : édition libre caractère par caractère, regroupement en panneaux, comparaison GPX/PA côte à côte, confirmation obligatoire et action « Séparer les versions ».
- [x] Panneau : création d’un nouveau cours vierge ou par copie d’un cours existant.
- [x] Panneau : éditeur visuel par blocs et éditeur Markdown disponibles.
- [x] Quiz : **48 755 questions uniques** importées depuis 176 fichiers, catalogue de 195 modules et routes Flutter dynamiques.
- [x] **155/155 tests Flutter** et **6/6 tests de validation éditoriale web** réussis.
- [x] Analyse Flutter, TypeScript et build de production Next.js validés après ajout de l’éditeur exact.
- [x] Dossier statique `fae16dc1` régénéré et ses six routes critiques contrôlées.
- [x] Registre final fichier par fichier : [VERIFICATION_FINALE_1409_FICHIERS_SCOLARITE.md](./VERIFICATION_FINALE_1409_FICHIERS_SCOLARITE.md).
- [x] JSON cinéma exclu de cette migration, conformément à la décision du propriétaire.

### Contrôles de base au point de reprise

| Contrôle | Résultat |
|---|---:|
| Fragments dans Supabase | 85 125 |
| Fichiers sources avec fragments connectés | 1 198 |
| Champs connectés au rendu Flutter | 84 287 |
| Fragments conservés uniquement pour audit | 838 |
| Paires GPX/PA liées | 422 |
| Clés liées manquantes dans la version jumelle | 0 |
| Cours avec chemin source | 1 232 |
| Pages non éditoriales | 34 stubs/redirections techniques |
| Erreurs Flutter | 0 |
| Erreurs build panneau | 0 |

### Contrôles encore humains avant mise en production publique

- [ ] Ouvrir dans le simulateur un cours GPX et un cours PA avec une session utilisateur réelle, modifier un caractère depuis le panneau, puis confirmer visuellement le rendu sur les deux pages.
- [ ] Tester depuis deux comptes réels : administrateur AAL2 autorisé et utilisateur standard refusé par les RPC administratives.
- [ ] Envoyer le contenu régénéré de `fae16dc1` chez l’hébergeur après ce contrôle de recette.

Ces trois contrôles nécessitent des sessions et une validation visuelle humaines. Le code, la base, les tests automatisés et le paquet web sont terminés.

### Sauvegarde de sécurité de la transformation

- Archive avant rétablissement du premier transformateur : `progression/backups/avant-retablissement-transformateur-20260816.tar.gz`
- SHA-256 : `24651cde637f5e2934ebc18988ba757f5de3004d8e6e9d5763668f6cf6d065d1`

### Sauvegarde de livraison technique

- Archive : `progression/backups/livraison-technique-scolarite-20260816.tar.gz`
- Taille : **48 Mo**
- SHA-256 : `5119bc6af8cb6b48969d91f71fdd94390740923bf8bfab0898ad9d6104e955d2`

Dernière mise à jour automatique : `2026-08-14T17:01:19.850765`

## Objectif

Rendre administrables depuis `copiq.fr/admin` tous les cours de PA Scolarité et GPX Scolarité, ainsi que leurs quiz et les quiz PA/GPX Exam, sans modifier l’identité visuelle existante et sans supprimer de table Supabase.

## Périmètre mesuré

- **1409 fichiers Dart** suivis dans le registre exhaustif.
- **759 fichiers GPX Scolarité**.
- **650 fichiers PA Scolarité**.
- Registre détaillé : [AUDIT_MIGRATION_1409_FICHIERS_SCOLARITE.md](./AUDIT_MIGRATION_1409_FICHIERS_SCOLARITE.md)
- Audit structurel fichier par fichier : [AUDIT_DETAILLE_1409_FICHIERS_SCOLARITE.md](./AUDIT_DETAILLE_1409_FICHIERS_SCOLARITE.md)

## Sauvegarde de référence

- Archive : `/private/tmp/copiqpolice-before-content-migration-20260814-161850.tar.gz`
- Taille : **2,8 Go**
- SHA-256 : `cdae106a848bb0f894c76fcdb0981c9a2f0244a89c63b1787896fa1ce9d19e15`

## Décisions validées

- [x] Lire tous les fichiers Dart de `gpx_scolarite` et `pa_scolarite`.
- [x] Migrer l’intégralité du contenu éditorial, pas uniquement les paragraphes simples.
- [x] Conserver les designs, routes et moteurs Flutter existants.
- [x] Permettre la création de nouveaux cours sans republication sur les stores.
- [x] Conserver le design actuel du panneau administrateur.
- [x] Fournir un éditeur visuel par blocs et un mode Markdown avancé synchronisé.
- [x] Gérer images, PDF, vidéos, audio et schémas via Supabase Storage.
- [x] Appliquer les migrations Supabase après sauvegarde et contrôle RLS.
- [x] Ne supprimer aucune table Supabase existante.

## État actuel

| Lot | État | Détail |
|---|---|---|
| Sauvegarde initiale | Terminé | Archive complète et SHA-256 vérifiés |
| Audit Supabase distant | Terminé | Projet, tables, RLS, politiques, fonctions, Storage et conseillers contrôlés en lecture seule |
| Sauvegarde Supabase distante | Terminé | Backup physique du 14 août 2026 à 03:25:44 UTC, restauration disponible |
| Sauvegarde Supabase Storage | Terminé | 22 médias archivés et vérifiés ; JSON cinéma exclu pour future table dédiée |
| Inventaire filesystem | Terminé | 1409 fichiers Dart recensés |
| Fondation Supabase existante | Audit initial terminé | `cours_scolarite`, quiz dynamiques et cycle éditorial repérés |
| Panneau existant | Audit initial terminé | Liste, Markdown, aperçu, publication et RPC sécurisées repérés |
| Classification structurelle fichier par fichier | Terminé | 1 409/1 409 fichiers lus et classifiés avec contenu, médias, dépendances et risque |
| Validation éditoriale automatisée | Terminé | 1 409 preuves finales, correspondance exacte des 84 287 clés connectées |
| Extraction complète | Terminé | 85 125 fragments conservés sans perte pour l’audit |
| Import Supabase | Terminé | Import idempotent, registre et preuves par fichier |
| Moteur Flutter universel | Terminé | Chargement distant, cache et secours local sans changement de design |
| Création de cours dans le panneau | Terminé | Création vierge ou depuis un modèle existant |
| Éditeur visuel par blocs | Terminé | Éditeur exact par panneaux + éditeur visuel/Markdown pour nouveaux cours |
| Supabase Storage | Terminé pour le périmètre existant | Médias sauvegardés ; JSON cinéma exclu selon décision propriétaire |
| Quiz School et Exam | Terminé | 48 755 questions uniques, 195 modules, panneau et routes dynamiques |
| Validation technique finale | Terminé | Tests, analyse, RLS, conseillers et build statique validés |

## Plan de développement

### Phase 1 — Audit exhaustif

- [x] Générer le registre des fichiers.
- [x] Lire intégralement et classifier automatiquement chaque fichier.
- [x] Associer chaque page à sa route dans `main.dart` et `app_router.dart`.
- [x] Identifier les pages orphelines, doublons et redirections.
- [x] Recenser tous les assets et composants spéciaux.
- [x] Marquer les fichiers sans contenu éditorial comme `Non éditorial`.

### Phase 2 — Modèle Supabase

- [x] Auditer `cours_scolarite`, `quiz_scolarite_questions`, leurs politiques et leurs volumes.
- [x] Auditer globalement les tables publiques, la RLS, les fonctions privilégiées et Storage.
- [x] Certifier une sauvegarde physique restaurable de la base distante.
- [x] Sauvegarder séparément les médias Storage, hors JSON cinéma destiné à une table dédiée.
- [x] Ajouter uniquement les colonnes/tables manquantes.
- [x] Modéliser hiérarchie, blocs, versions, médias et liens quiz.
- [x] Créer les RPC administratives avec garde d’autorisation et audit.
- [x] Créer les politiques RLS de lecture publiée et d’administration.
- [x] Contrôler statiquement les droits `anon`, `authenticated`, les gardes admin et la RLS.
- [ ] Recette finale avec deux comptes réels : admin AAL2 et utilisateur standard.

### Phase 3 — Extraction et import

- [x] Extraire titres, textes, RichText, listes, cartes, tableaux et références.
- [x] Conserver l’ordre exact des blocs extraits.
- [x] Associer routes, classes, catégories et modules.
- [x] Importer de façon idempotente dans Supabase.
- [x] Enregistrer dans le registre l’identifiant et la preuve Supabase.
- [x] Comparer automatiquement chaque clé connectée au fichier Dart source.

### Phase 4 — Application Flutter

- [x] Créer le chargement de contenu distant et son cache hors ligne.
- [x] Conserver le rendu des widgets existants et remplacer uniquement leurs valeurs textuelles.
- [x] Préserver toutes les routes actuelles.
- [x] Ajouter une route et un catalogue pour les nouveaux cours du panneau.
- [x] Ajouter un contenu en cache de secours hors ligne.
- [x] Vérifier automatiquement les routes, la navigation et les liens quiz.

### Phase 5 — Panneau administrateur

- [x] Ajouter « Nouveau cours ».
- [x] Ajouter l’éditeur visuel par blocs existants.
- [x] Synchroniser éditeur visuel et Markdown.
- [ ] Ajouter glisser-déposer et réorganisation des blocs.
- [ ] Ajouter upload et bibliothèque Supabase Storage.
- [x] Conserver brouillon, aperçu, programmation, publication et archivage existants.
- [x] Étendre le panneau aux quiz PA/GPX School et Exam importés.

### Phase 6 — Vérification et livraison

- [x] Tests unitaires et contrôles d’intégration Supabase.
- [x] Analyse Flutter complète.
- [x] Build statique du panneau.
- [ ] Recette visuelle humaine GPX/PA avec modification distante réelle.
- [x] Contrôle de complétude : 1 409/1 409 fichiers avec statut final.
- [x] Générer `fae16dc1/admin` prêt à déposer.
- [x] Créer la sauvegarde finale et son SHA-256.

## Journal de développement

### 2026-08-14T17:01:19.850765

- Périmètre fonctionnel confirmé avec le propriétaire.
- Sauvegarde complète créée et vérifiée.
- 1 409 fichiers Dart recensés dans PA/GPX Scolarité.
- Architecture existante du panneau, du moteur dynamique et du cycle éditorial identifiée.
- Registre exhaustif et document de progression générés.

### 2026-08-14 — Audit Supabase avant migration

- Projet distant `nuoonagnkhbeeymtvrcn` identifié actif et sain, offre Pro, région Paris.
- Audit SQL effectué en lecture seule : 202 tables publiques, toutes avec RLS activée, et 676 politiques.
- `cours_scolarite` contient 14 cours ; `quiz_scolarite_questions` contient 228 questions.
- Trois buckets publics observés, dont `assets`, sans politique Storage personnalisée.
- Conseillers Supabase analysés : 694 avis de sécurité et 276 avis de performance hérités.
- Rapport créé : [AUDIT_SUPABASE_AVANT_MIGRATION.md](./AUDIT_SUPABASE_AVANT_MIGRATION.md).
- La certification avait d'abord été bloquée par la reconnexion au tableau de bord ; elle a été finalisée dans l'entrée suivante.

### 2026-08-14 — Certification des sauvegardes

- Connexion au tableau de bord Supabase confirmée dans le panneau Codex.
- Backup physique quotidien du 14 août 2026 à 03:25:44 UTC vérifié comme restaurable.
- Copie complémentaire de 22 objets médias Storage créée dans `/private/tmp/copiq-supabase-storage-20260814.tar.gz`.
- Empreinte de l'archive Storage : `7e58a609348aa6151ff63c2ff84b5f4a51b0f7b1f417acfe383dc1d399dcd173`.
- `quiz_cinema_merged.jsonl` explicitement exclu ; sa copie locale a été supprimée et l'objet distant conservé pour traitement ultérieur.

### 2026-08-14 — Audit structurel exhaustif des fichiers de scolarité

- Les 1 409 fichiers Dart ont été ouverts et analysés intégralement par `tool/audit_scolarite_files.dart`.
- Contrôle conforme : 759 fichiers GPX, 650 fichiers PA et 1 409 chemins uniques.
- 1 928 024 lignes et 72 027 070 octets de code ont été analysés.
- Classification détectée : 1 142 cours/contenus, 177 quiz/QCM et 90 introductions.
- Chaque ligne contient la hiérarchie du cours, la route, la classe, le titre, les composants textuels, les médias, la navigation, les dépendances, Supabase et le risque de migration.
- Le document [AUDIT_DETAILLE_1409_FICHIERS_SCOLARITE.md](./AUDIT_DETAILLE_1409_FICHIERS_SCOLARITE.md) contient exactement 1 409 lignes de suivi.

### 2026-08-15 — Point de pause demandé par le propriétaire

- Développement volontairement mis en pause avant l’application de la migration vide `20260814233457_scolarite_imported_quiz_modules.sql`.
- Deux migrations additives ont été appliquées avec succès à Supabase : plateforme éditoriale et registre des sources. Aucune table existante n’a été supprimée.
- Registre Supabase vérifié : **1 409/1 409**, dont 759 GPX et 650 PA, 72 027 070 octets et 1 928 024 lignes.
- **1 232** cours/introductions sont présents dans `cours_scolarite` avec Markdown et blocs.
- **52 405** questions ont été extraites ; **48 755** questions uniques migrées sont présentes, réparties sur 176 fichiers contenant des questions. Le 177e fichier classé quiz ne contient aucune question normalisable.
- Les doublons internes exacts sont consolidés par la contrainte `(module, md5(question))`, sans perte de fichier dans le registre.
- Flutter : cache hors ligne, catalogue dynamique et résolution des routes de nouveaux cours ajoutés ; analyse ciblée sans erreur.
- Panneau : bouton de création et éditeur visuel/Markdown codés ; ESLint ciblé sans erreur.
- **Dernière opération non appliquée** : création locale du fichier vide `supabase/migrations/20260814233457_scolarite_imported_quiz_modules.sql`.
- **Reprise exacte** : remplir/appliquer cette migration pour créer les modules des quiz importés, puis terminer médias/versions, tests complets et build `fae16dc1/admin`.

## Règles de mise à jour du suivi

### 2026-08-17 — Quiz Flagrant délit, niveau moyen

- Sauvegarde distante créée avant écriture : lot `2026-08-17-flagrant-medium-before-150`, **501 questions** instantanées dans `private.quiz_scolarite_questions_backups`.
- Écrans réellement routés GPX et PA branchés sur `quiz_scolarite_questions`, avec conservation du contenu Dart uniquement comme secours hors connexion.
- Niveau **Moyenne** porté à exactement **150 questions publiées et actives** sur le module GPX actif, son doublon historique et le module PA.
- Lot enrichi avec éléments légaux et procéduraux, mises en situation, QCM et questions pièges ; chaque nouvelle question possède réponse, explication, référence et métadonnées éditoriales.
- Bouton **Mettre fin** et calcul du résultat ajoutés au quiz GPX Flagrant délit ; la version PA possédait déjà cette logique et a été conservée.
- Moteur dynamique Supabase complété avec la même commande de fin de quiz.
- Audit transversal : **213 fichiers quiz contrôlés, 0 fichier sans marqueur de fin de quiz**.
- Contrôle Supabase : **150/150** questions moyennes publiées par module, 0 option invalide, 0 réponse absente des propositions et 150 questions distinctes.
- `flutter analyze` global : **aucune erreur**.

### 2026-08-17 — Clôture universelle des quiz par la croix

- Audit transversal de **211 écrans de quiz** possédant une croix de fermeture dans les parcours GPX, PA et Exam.
- La croix et le bouton **Mettre fin** appellent désormais strictement la même procédure de clôture.
- Les **8 anciennes variantes** qui ne possédaient pas encore de procédure `_endQuizNow` ont été complétées.
- Pour les 211 écrans : confirmation, enregistrement Supabase via `_updateHistoryOnFinish`, calcul sur les réponses réellement données et affichage du résultat via `_openResultDialog` sont garantis.
- Avant le choix du niveau, la croix continue de quitter directement puisqu'aucune partie n'est engagée.
- Audit automatique final : **0 divergence**, **0 sauvegarde absente**, **0 écran de résultat absent**.
- `flutter analyze` global : **aucune erreur**.

### 2026-08-17 — Boutons de fin des huit anciens quiz

- Bouton **Mettre fin** ajouté au quiz Criminalité organisée réellement routé et aux sept pages partageant son ancien moteur : enquête préliminaire, commission rogatoire, personnes en fuite, disparitions inquiétantes, mort inconnue, contrôle d’identité et hiérarchie.
- Chaque bouton appelle la même méthode `_endQuizNow` que la croix : confirmation, sauvegarde Supabase, score et résultat.
- Audit de présence transversal : aucune méthode de fin sans déclencheur d’interface restant.
- `flutter analyze` global : **aucune erreur**.

1. Mettre à jour le statut de chaque ligne du registre après chaque étape.
2. Ne marquer `Importé` qu’après retour positif de Supabase.
3. Ne marquer `Vérifié` qu’après comparaison avec le fichier source et contrôle du rendu.
4. Ajouter chaque changement important au journal ci-dessus.
5. Régénérer le registre après ajout, déplacement ou suppression autorisée d’un fichier Dart.
