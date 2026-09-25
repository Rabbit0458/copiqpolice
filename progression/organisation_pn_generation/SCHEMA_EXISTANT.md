# Schéma existant et écarts au modèle cible

## Objets existants

### `quiz_scolarite_modules`

Catalogue de modules par `module` et `track`. Les deux clés Organisation requises existent dans les migrations d'import.

### `quiz_scolarite_questions`

Table historique de questions par module et track. Elle porte notamment `id`, `module`, `track`, `category`, `difficulty`, `question`, `options`, `answer`, `explanation`, `legal_ref`, état de publication, source, métadonnées et révision. Sa contrainte d'unicité `(source_path, source_question_key)` impose aujourd'hui une copie par page/track.

Cette table doit rester disponible pour préserver les références historiques, mais elle ne satisfait pas le modèle canonique partagé demandé.

### Historique

`quiz_history` représente une tentative. `quiz_answer_history` est l'historique détaillé canonique. La RPC `record_learning_answer` dérive l'utilisateur de `auth.uid()`, valide `track/mode`, enregistre texte/options/réponse/explication/difficulté/temps/version et accepte un identifiant client idempotent.

### Signalements

`report_question` est la file historique. La migration locale `20260828121000` prévoit un identifiant, une version et un snapshot JSON. Le centre admin sait supprimer exactement un signalement, mais son résolveur et ses mutations ne connaissent pas encore la future banque canonique.

### Administration et audit

Le dépôt contient des permissions `quiz.write`, `reports.manage`, des gardes de rôle, un cycle éditorial et `admin_audit_logs`. Les mutations sont réalisées par RPC serveur. Le modèle doit ajouter la banque à cette liste blanche et exiger le niveau MFA déjà appliqué par la garde du projet.

## Objets manquants

- version de banque et pointeur de version active ;
- question canonique unique ;
- affectation séparée `(question, track, mode, module)` ;
- session de génération et candidats de staging ;
- résultats de validation, doublons et décisions ;
- archive/snapshot de bascule et journal de déploiement ;
- RPC de session filtrée par track sans module arbitraire ;
- RPC admin de correction, suspension, republication et archivage logique de la banque ;
- rollback transactionnel testé.

## Risques de compatibilité

- les ids bigint historiques ne doivent jamais être réutilisés ni supprimés ;
- `question_id` est textuel dans l'historique et les signalements : le `stable_key` canonique peut y être stocké sans rupture, accompagné de la version/révision ;
- les pages locales emploient `Moyen`, à normaliser vers `Moyenne` dans le dépôt central sans modifier le libellé visuel attendu ;
- la lecture directe de `quiz_scolarite_questions` accordée à `authenticated` doit être réévaluée avec ses politiques RLS, indépendamment des grants.
