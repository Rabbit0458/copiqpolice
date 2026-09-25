# [REFONTE QCM] Organisation de la Police nationale — 30 000 questions uniques, vérifiées et administrables

## Cadre

- Refonte majeure, priorité haute.
- Flutter iOS/Android + Supabase PostgreSQL.
- Parcours communs : Gardien de la paix (`gpx`) et Policier adjoint (`pa`).
- Mode obligatoire : `school`.
- Panel existant : `fae16dc1/admin`.
- Plafond : 30 000 questions validées, idéalement 10 000 faciles, 10 000 moyennes et 10 000 difficiles.

La qualité prime sur le volume. Le programme doit s’arrêter avant le plafond si l’unicité, la fiabilité factuelle ou la valeur pédagogique ne peuvent plus être garanties. Il doit alors expliquer précisément le volume réellement atteignable et les motifs de l’arrêt.

## Mission

Auditer COP’IQ puis créer une banque QCM centralisée sur l’organisation de la Police nationale. Elle doit alimenter les quiz de scolarité GPX et PA, enregistrer les réponses dans Supabase, nourrir « Mon suivi » et « Corriger mes erreurs », et être entièrement administrable depuis le centre de signalements existant.

Ne jamais supposer un nom de table, de colonne, de route ou de catégorie : retrouver toutes les valeurs dans le code, les migrations et Supabase avant de proposer le schéma final.

## Sources pédagogiques

Lire intégralement les contenus réels du projet, notamment :

- `lib/content/pa_scolarite/institution_valeurs_pages/dgpn_dgsi_pp/dgpn_dgsi_pp_page.dart`
- `lib/content/pa_scolarite/institution_valeurs_pages/histoire_police/histoire_police_page.dart`
- `lib/content/pa_scolarite/institution_valeurs_pages/hierarchie_personnels/hierarchie_personnels_page.dart`
- `lib/content/pa_scolarite/institution_valeurs_pages/formation_initiale/formation_initiale_page.dart`
- `lib/content/pa_scolarite/institution_valeurs_pages/egalite_diversite_protections/egalite_diversite_protections_page.dart`
- `lib/content/pa_scolarite/institution_valeurs_pages/droits_obligations/droits_obligations_page.dart`
- `lib/content/pa_scolarite/institution_valeurs_pages/deontologie_code_commente/deontologie_code_commente_page.dart`
- `lib/content/pa_scolarite/institution_valeurs_pages/horaires_service_sp/horaires_service_sp_page.dart`

Compléter uniquement avec des sources officielles actuelles : ministère de l’Intérieur, Police nationale, Légifrance, Service public, Vie-publique et publications institutionnelles pertinentes. Ne jamais utiliser un forum comme source factuelle.

Les lignes de questions ne doivent pas afficher ou livrer d’URL aux utilisateurs. Les données internes de vérification peuvent conserver `source_name`, `verified_at`, `reference_date`, un extrait/preuve et un niveau de volatilité.

## Périmètre

- ministère de l’Intérieur et organigramme ;
- DGPN, directions nationales, services centraux et territoriaux ;
- DGSI ;
- préfecture de Police ;
- missions, compétences et articulation des services ;
- histoire et évolution de la Police nationale ;
- corps, grades, emplois, statuts, hiérarchie et insignes ;
- formation initiale ;
- règles d’emploi des PA et GPX ;
- horaires et cycles de service en sécurité publique ;
- droits, obligations, déontologie, égalité, diversité et protections ;
- acronymes et sigles ;
- mises en situation strictement fondées sur les contenus et textes vérifiés.

## Banque commune GPX/PA

Créer une seule banque logique. Chaque question doit être ciblée par `mode = school` et par `track = gpx`, `pa` ou `both`, ou par la représentation équivalente retenue après audit. Une connaissance commune ne doit pas être dupliquée en deux lignes pour les deux parcours.

## Contrat d’une question

Chaque question doit posséder :

- un ID stable et unique ;
- une formulation claire et autonome ;
- 3 ou 4 choix, jamais moins et jamais plus ;
- exactement une bonne réponse ;
- des distracteurs proches, plausibles et de même nature ;
- une explication individuelle, précise et pédagogique ;
- un thème, un sous-thème et un objectif de connaissance atomique ;
- une difficulté justifiée ;
- le ciblage `track` et `mode` ;
- un fingerprint sémantique stable ;
- les métadonnées de vérification ;
- un statut de modération et un statut actif/inactif ;
- les dates de création, mise à jour et dernière vérification.

Interdire les distracteurs absurdes, les indices grammaticaux, les réponses trouvables par élimination grossière et toute question ayant plusieurs réponses défendables.

## Difficulté

- **Facile** : fondamentaux indispensables, structures et missions majeures, sigles courants, corps et grades principaux.
- **Moyen** : compétences précises, articulation entre services, règles d’emploi, position hiérarchique et distinctions proches.
- **Difficile** : mécanismes détaillés, exceptions vérifiées, organigrammes complexes, distinctions fines et mises en situation mobilisant plusieurs connaissances.

Calculer un score interne fondé sur la notoriété, la précision, la rareté, le nombre de concepts, la proximité des distracteurs, la contextualisation et le niveau attendu. Un vocabulaire compliqué ne rend pas artificiellement une question difficile.

## Explications

Chaque explication doit rappeler la réponse, justifier pourquoi elle est correcte, apporter le contexte, lever les principales confusions et préciser la date de validité si nécessaire.

Sont interdits : explications génériques, phrases copiées, « la bonne réponse est B », conseils vagues d’élimination et références inventées.

## Images de grades

Conserver et réutiliser exclusivement les images de grades existantes. Vérifier chaque association image/réponse, proposer des grades proches comme distracteurs et empêcher qu’une même image visant la même connaissance crée plusieurs questions. Ne jamais générer ou inventer un insigne. Prévoir un affichage de repli propre et vérifier iOS/Android.

## Déduplication absolue

Deux questions sont des doublons dès qu’elles testent la même connaissance, même si la formulation, le sens, l’ordre ou les choix changent.

Construire pour chaque question :

```text
domain + topic + subtopic + entity + relation + correct_answer
+ scope + reference_period + knowledge_target
```

Puis produire un `semantic_fingerprint`. Rejeter : doublons exacts, paraphrases, questions inversées, permutations de choix, même image/même grade, même fait réparti artificiellement entre plusieurs difficultés et variations sans nouvel apprentissage.

Ajouter une mesure de similarité. Toute question suspecte doit être mise en quarantaine et ne jamais être importée automatiquement.

## Pipeline qualité

```text
Génération
→ Validation du schéma
→ Vérification factuelle
→ Validation de la réponse
→ Validation des distracteurs
→ Validation de l’explication
→ Classification de la difficulté
→ Déduplication exacte
→ Déduplication sémantique
→ Validation track/mode
→ Quarantaine ou READY_FOR_IMPORT
```

## Supabase et sécurité

Avant tout changement : cartographier les tables de questions, tentatives, réponses, suivi et signalements ; examiner migrations, contraintes, index, fonctions et RLS ; retrouver les requêtes Flutter et admin ; proposer sauvegarde et rollback.

Le modèle final doit permettre : lecture des questions actives, sauvegarde de chaque tentative et réponse, suivi complet, correction des erreurs, signalement par l’ID réel de la question, correction/modération admin, désactivation, suppression contrôlée et audit.

Aucune clé `service_role` dans Flutter ou le navigateur. Toute opération privilégiée doit passer côté serveur après contrôle du rôle administrateur et de la 2FA lorsque le projet l’exige.

## Suivi utilisateur

Pour toute tentative contenant au moins une réponse validée, enregistrer l’utilisateur, la question, la réponse choisie, la bonne réponse au moment de la tentative, le résultat, les informations utiles de la question, la difficulté, le thème, le track, le mode, la date, la durée, la session et la tentative.

Une session quittée sans réponse ne doit modifier aucune statistique. « Mon suivi » doit restituer activités, bonnes et mauvaises réponses, explications, thèmes faibles et sessions de correction, même si une question est ultérieurement corrigée.

## Signalements et panel

Le signalement transmet l’ID unique réel de la question. Le panel existant doit retrouver la ressource et permettre : examiner, corriger, enregistrer, traiter, archiver, noter, désactiver, supprimer uniquement le signalement, supprimer séparément la question après confirmation renforcée, et consulter l’audit.

Supprimer un signalement doit supprimer exactement sa ligne. Supprimer une question est une action distincte, protégée et journalisée.

## Uniformité Flutter

Respecter `AGENTS.md` et utiliser comme listes de contrôle :

- `progression/CARTOGRAPHIE_COMPLETE_SCOLARITE_GPX_PA.md`
- `progression/CARTOGRAPHIE_PYRAMIDALE_SCOLARITE_GPX_PA.png`
- `progression/migration_data/sources.jsonl`

Contrôler scolarité GPX, scolarité PA, Exam GPX, Exam PA, sous-pages, sélecteurs, quiz, résultats, suivi, signalements et redirections. N’activer ce nouveau quiz qu’aux emplacements prévus.

Ne modifier aucun design. Dupliquer fidèlement une page quiz existante et validée, puis adapter uniquement ses données et son branchement à l’organisation de la Police nationale.

## Migration et import

Ne jamais supprimer directement l’ancienne banque. Procéder ainsi : sauvegarde, nouvelle banque isolée, pilote, validation, import test, tests Flutter/panel, montée progressive, bascule contrôlée, rollback conservé.

Importer par lots mesurés, avec idempotence, transactions si adaptées, contrôle des volumes, journalisation et retries progressifs. Tester au minimum 100 lignes, puis 1 000, avant toute augmentation.

## Dashboard Terminal obligatoire

Créer une vraie CLI/TUI COP’IQ avec Rich, Textual ou équivalent. Elle doit rester stable plusieurs heures ou jours et afficher :

- phases et étape active ;
- progression totale et par difficulté ;
- générées, validées, rejetées, quarantaines et importées ;
- doublons exacts/sémantiques, paraphrases, erreurs factuelles, distracteurs et explications invalides ;
- couverture par thème ;
- durée, ETA, vitesse/minute et heure ;
- état Internet, générateur, validateur, Supabase et writer ;
- opération actuelle et derniers événements.

Couleurs : cyan informations, vert succès, jaune avertissement, rouge erreur, violet IA/analyse et gris secondaire. Limiter le rafraîchissement à 2–5 fois/seconde.

Contrôles : `P` pause, `R` reprise, `S` checkpoint, `L` logs et `Q` arrêt sécurisé.

Prévoir `--afk`. Après autorisation explicite de la génération massive, aucune question non critique ne doit bloquer le programme. Les erreurs non critiques vont en quarantaine ; une erreur critique déclenche checkpoint et arrêt sécurisé.

## Logs, checkpoint, reprise et watchdog

Créer :

```text
logs/run_<date_heure>/
  main.log
  errors.log
  warnings.log
  duplicates.log
  rejected_questions.jsonl
  quarantine.jsonl
  import.log
  statistics.json
  checkpoint.json
  final_report.json
```

Reprendre exactement après crash, coupure ou perte réseau. Ajouter watchdog de stagnation, backoff réseau, limite de retries, protection contre les boucles, fermeture propre et import idempotent.

## Tests obligatoires

1. Doublon exact, reformulation, inversion et permutation rejetés.
2. Même image de grade et même cible rejetées.
3. Exactement 3 ou 4 choix et une seule réponse correcte.
4. Distracteurs plausibles et difficultés réellement distinctes.
5. Explications uniques vérifiées sur un échantillon substantiel.
6. Mapping `school` + GPX/PA/commun vérifié.
7. Quiz accessible depuis les deux parcours attendus.
8. Tentatives et réponses sauvegardées dans Supabase.
9. Session sans réponse exclue des statistiques.
10. Erreur visible dans « Mon suivi » et « Corriger mes erreurs ».
11. Signalement relié à la bonne question centrale.
12. Correction, désactivation et suppressions distinctes testées depuis le panel.
13. Import progressif, charge, pagination, index et reprise testés.
14. Aucun secret privilégié côté client.
15. Tests iOS et Android.
16. Contrôle explicite de tout le périmètre imposé par `AGENTS.md`.

## Phases avec arrêt obligatoire

1. **Audit** : Flutter, Supabase, panel, données, images, suivi, signalements. Aucun changement de production.
2. **Architecture** : schéma, migrations, sécurité, pipeline, rollback. Aucun déploiement.
3. **Prototype local** : générateur, validateurs, déduplication, TUI, logs et tests.
4. **Génération pilote** : petit corpus hors production et rapport qualité.
5. **Intégration contrôlée** : migrations autorisées, échantillon et branchements Flutter/panel.
6. **Validation complète** : application, suivi, signalements, sécurité, performances, rollback.
7. **Génération étendue** : uniquement après autorisation ; arrêt dès que qualité/unicité déclinent.
8. **Import progressif** : uniquement les lignes `READY_FOR_IMPORT`.
9. **Bascule** : activation contrôlée, tests iOS/Android, rollback conservé.
10. **Rapport final** : volumes, rejets, couverture, migrations, tests et exceptions.

À la fin de chaque phase : afficher un rapport et attendre une autorisation explicite avant la suivante.

## Critères d’acceptation

La tâche est terminée seulement si la structure réelle a été auditée, la banque est sécurisée/indexée, GPX et PA lisent le corpus, les trois niveaux fonctionnent, les doublons sémantiques sont bloqués, les explications sont pédagogiques, les images de grades sont préservées, le suivi enregistre les réponses détaillées, les signalements retrouvent la question, le panel admin gère toutes les actions prévues, les écritures privilégiées sont serveur et auditées, la TUI/reprise/AFK fonctionnent, l’import est progressif et réversible, iOS/Android sont testés et aucun autre design, quiz ou module n’est cassé.

Le rapport final doit indiquer si 30 000 questions réellement fiables ont été atteintes ou pourquoi la génération s’est arrêtée avant.

## Instruction de lancement

```text
Lis intégralement progression/PROMPT_GENERATEUR_BANQUE_ORGANISATION_PN_30000.md et respecte toutes ses contraintes.

Exécute exclusivement la PHASE 1 — Audit. Inspecte le code Flutter, la cartographie, les migrations et schémas Supabase, le panel administrateur, les quiz GPX/PA, le suivi, les signalements et les images de grades.

Ne suppose aucun nom technique. Ne modifie pas le design. Ne lance aucune génération massive. Ne supprime aucune donnée et ne déploie rien en production.

À la fin, fournis l’architecture constatée, les écarts, les risques, la proposition de migration et la liste exacte des fichiers et tables concernés. Arrête-toi ensuite et attends mon autorisation explicite avant la phase 2.
```
