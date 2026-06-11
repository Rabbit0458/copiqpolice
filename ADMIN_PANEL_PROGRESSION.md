# 📋 PROGRESSION — Panel Administrateur CopiqPolice

> Fichier de référence vivant. Mettre à jour au fur et à mesure des implémentations.
> Dernière mise à jour : 2026-06-09

---

## 🗂️ SOMMAIRE DES MODULES

| # | Module | Statut |
|---|--------|--------|
| 1 | Authentification Admin | ⬜ À faire |
| 2 | Dashboard / Vue d'ensemble | ⬜ À faire |
| 3 | Gestion des signalements quiz | ⬜ À faire |
| 4 | Gestion des bugs & contacts | ⬜ À faire |
| 5 | Gestion des signalements forum | ⬜ À faire |
| 6 | Gestion des utilisateurs | ⬜ À faire |
| 7 | Gestion des abonnements & facturation | ⬜ À faire |
| 8 | Gestion des questions quiz (BDD) | ⬜ À faire |
| 9 | Gestion du forum | ⬜ À faire |
| 10 | Gestion des notes de patch | ⬜ À faire |
| 11 | Logs & audit | ⬜ À faire |
| 12 | Gestion des admins | ⬜ À faire |

---

## ═══════════════════════════════════════════
## MODULE 1 — AUTHENTIFICATION ADMIN
## ═══════════════════════════════════════════

### Tables utilisées
- `admin_users` — comptes admins
- `admin_audit_logs` — trace de toutes les actions admin

### Structure de `admin_users`
```
id                       uuid         PK
email                    text         UNIQUE
password_hash            text
role                     text         'superadmin' | 'admin' | 'moderator'
first_name               text
last_name                text
username                 text
permissions              jsonb        granularité fine des droits
second_factor_enabled    boolean      2FA obligatoire
admin_code               text         code PIN additionnel (en clair ou hashé)
admin_code_hash          text
failed_admin_code_attempts integer    lockout après N tentatives
locked_until             timestamptz  compte verrouillé jusqu'à cette date
last_admin_login_at      timestamptz
last_admin_login_ip      text
disabled                 boolean
expires_at               timestamptz  compte temporaire
created_at / updated_at
created_by               uuid         qui a créé ce compte admin
notes                    text
auth_uid                 uuid         lien vers auth.users Supabase
```

### Tâches
- [ ] **AUTH-01** — Page de login admin (email + mot de passe)
- [ ] **AUTH-02** — Double facteur : saisie du code PIN admin (`admin_code`)
- [ ] **AUTH-03** — Gestion du lockout après N tentatives (`failed_admin_code_attempts`, `locked_until`)
- [ ] **AUTH-04** — Session JWT admin avec refresh token sécurisé
- [ ] **AUTH-05** — Middleware de protection de toutes les routes admin
- [ ] **AUTH-06** — Déconnexion + nettoyage session
- [ ] **AUTH-07** — Page "compte expiré" si `expires_at` dépassé
- [ ] **AUTH-08** — Enregistrer chaque login dans `admin_audit_logs`

---

## ═══════════════════════════════════════════
## MODULE 2 — DASHBOARD
## ═══════════════════════════════════════════

### Tables utilisées
- `user_profiles`, `user_registry`
- `billing_subscriptions`
- `report_question`, `report_culture_generale`, `tests_psycotechnique_report`
- `bug_reports`, `contact_messages`, `forum_reports`
- `quiz_history`

### Tâches
- [ ] **DASH-01** — Compteurs en temps réel :
  - Total utilisateurs inscrits
  - Abonnements actifs (`billing_subscriptions.status = 'active'`)
  - Abonnements résiliés / expirés
  - Nouveaux inscrits aujourd'hui / 7j / 30j
- [ ] **DASH-02** — Alertes signalements non traités :
  - `report_question` où `status = 'new'`
  - `report_culture_generale` où `status = 'new'`
  - `tests_psycotechnique_report` où `status = 'new'`
  - `bug_reports` où `status = 'new'`
  - `contact_messages` où `status = 'new'`
  - `forum_reports` où `status = 'open'`
- [ ] **DASH-03** — Graphique activité quiz (7 derniers jours depuis `quiz_history`)
- [ ] **DASH-04** — Top 5 quiz les plus joués (GROUP BY `quiz_name` sur `quiz_history`)
- [ ] **DASH-05** — Revenus du mois courant (depuis `billing_events` ou `billing_subscriptions`)
- [ ] **DASH-06** — Derniers logs d'erreur (`app_logs.level = 'error'`, 10 derniers)

---

## ═══════════════════════════════════════════
## MODULE 3 — SIGNALEMENTS QUIZ
## ═══════════════════════════════════════════

### Contexte
Il existe **3 tables distinctes** de signalement de questions selon leur origine :

| Table | Origine | Identifiant question |
|-------|---------|---------------------|
| `report_question` | Questions hardcodées (153 fichiers Dart) | `question_text` + `source_file` |
| `report_culture_generale` | Questions culture générale DB (`quiz_questions`) | `question_id` (bigint) |
| `tests_psycotechnique_report` | Questions psychotechnique DB | `question_id` (text/UUID) |

### Structure de `report_question` (hardcoded)
```
id                  uuid         PK
created_at          timestamptz
user_uid            text         uid de l'utilisateur
email               text
question_text       text         texte de la question (identifiant)
source_file         text         nom du fichier Dart sans .dart
question_category   text
question_difficulty text         'Facile' | 'Moyenne' | 'Difficile'
question_answer     text         réponse correcte
report_type         text         'bug' | 'probleme' | 'autre'
report_message      text         description libre de l'utilisateur
status              text         'new' | 'in_progress' | 'resolved' | 'rejected'
```

### Structure de `report_culture_generale` (DB-backed)
```
id                  bigint       PK
created_at          timestamptz
user_uid            text
email               text
question_id         bigint       → quiz_questions.id
module              text
category            text
difficulty          text
question            text         copie du texte au moment du report
options             jsonb        copie des options
answer              text
explanation         text
sub                 text
report_type         text
message             text
page                text         routeName de la page Flutter
status              text         'new' | 'in_progress' | 'resolved' | 'rejected'
tracking_token      uuid
updated_at          timestamptz
status_updated_at   timestamptz
archived            boolean
```

### Structure de `tests_psycotechnique_report`
```
id                  bigint       PK
created_at          timestamptz
user_uid            text
email               text
question_id         text         UUID ou ID de la question psychotechnique
module              text
category            text
difficulty          text
question            text
options             jsonb
answer              text
explanation         text
sub                 text
report_type         text
message             text
page                text
status              text
tracking_token      uuid
updated_at          timestamptz
status_updated_at   timestamptz
archived            boolean
```

### Tâches — Vue unifiée
- [ ] **REP-01** — Page "Signalements quiz" avec onglets :
  - Onglet "Questions hardcodées" → source `report_question`
  - Onglet "Culture générale" → source `report_culture_generale`
  - Onglet "Psychotechnique" → source `tests_psycotechnique_report`
  - Onglet "Tous" → vue unifiée des 3 tables (UNION)
- [ ] **REP-02** — Filtres par statut : `new` | `in_progress` | `resolved` | `rejected`
- [ ] **REP-03** — Filtres par type : `bug` | `probleme` | `autre`
- [ ] **REP-04** — Tri par date (plus récent en premier par défaut)
- [ ] **REP-05** — Recherche par texte (question_text, email, source_file)
- [ ] **REP-06** — Carte de détail d'un signalement :
  - Infos question (texte, catégorie, difficulté, réponse correcte)
  - Source (fichier Dart ou table BDD + ID)
  - Infos reporter (email, user_uid)
  - Type de problème + message libre
  - Date du signalement
- [ ] **REP-07** — Actions sur un signalement :
  - Changer le statut (`new` → `in_progress` → `resolved` / `rejected`)
  - Archiver (`archived = true`)
  - Lien direct vers la question dans `quiz_questions` si DB-backed
- [ ] **REP-08** — Pour questions hardcodées : afficher le chemin exact
  ```
  Fichier : gpx_quiz_abandon_famille.dart
  Chercher : "Quelle est la durée de garde à vue ?"
  ```
  Avec bouton copier le texte de la question pour faire Ctrl+F dans VS Code
- [ ] **REP-09** — Compteurs de résumé en haut de page :
  - 🔴 N nouveaux | 🟡 N en cours | ✅ N résolus | total
- [ ] **REP-10** — Pagination (20 par page)
- [ ] **REP-11** — Export CSV des signalements filtrés
- [ ] **REP-12** — Notification badge dans le menu si signalements `new` > 0

---

## ═══════════════════════════════════════════
## MODULE 4 — BUGS & MESSAGES DE CONTACT
## ═══════════════════════════════════════════

### Structure de `bug_reports`
```
id           uuid
created_at   timestamptz
user_id      uuid
email        text
first_name   text
last_name    text
category     text         'Autre' par défaut
title        text
message      text
app_version  text
device       text
os           text
severity     text         'low' | 'medium' | 'high' | 'critical'
status       text         'new' | 'in_progress' | 'resolved'
attachments  jsonb        liens vers fichiers/captures
```

### Structure de `contact_messages`
```
id           uuid
created_at   timestamptz
user_id      uuid
email        text
subject      text
message      text
app_version  text
device       text
os           text
status       text         'new' | 'read' | 'replied'
```

### Tâches
- [ ] **BUG-01** — Liste des bugs avec filtres : sévérité, statut, catégorie
- [ ] **BUG-02** — Détail bug : toutes les infos + device/OS/version
- [ ] **BUG-03** — Changement de statut + sévérité
- [ ] **BUG-04** — Liste des messages de contact
- [ ] **BUG-05** — Marquer contact comme "lu" / "répondu"
- [ ] **BUG-06** — Bouton mailto: pour répondre directement par email

---

## ═══════════════════════════════════════════
## MODULE 5 — SIGNALEMENTS FORUM
## ═══════════════════════════════════════════

### Structure de `forum_reports`
```
id           uuid
post_id      uuid         → forum_posts_exam_gpx.id
reporter_id  uuid         → auth.users
reason       text
created_at   timestamptz
status       text         'open' | 'resolved' | 'dismissed'
```

### Tâches
- [ ] **FORUM-REP-01** — Liste signalements forum avec statut
- [ ] **FORUM-REP-02** — Afficher le post signalé (contenu, auteur, date)
- [ ] **FORUM-REP-03** — Actions : résoudre, ignorer, supprimer le post
- [ ] **FORUM-REP-04** — Bannir l'auteur du post (`forum_bans`)

---

## ═══════════════════════════════════════════
## MODULE 6 — GESTION DES UTILISATEURS
## ═══════════════════════════════════════════

### Tables utilisées
- `user_profiles` — profil complet
- `user_registry` — registre d'inscription
- `billing_subscriptions` — plan actif
- `quiz_history` — activité quiz
- `bug_reports`, `contact_messages` — historique support

### Structure de `user_profiles`
```
user_id          uuid         PK (= auth.uid)
email            text
first_name       text
last_name        text
username         text
city             text
phone            text
birthday         date
avatar_index     integer
user_mode        text         'exam' | 'scolarite'
user_track       text         'gpx' | 'pa'
has_passed_exam  boolean
role             user_role    'active' | 'banned' | 'suspended' | ...
cgv_accepted     boolean
cgv_accepted_at  timestamptz
created_at / updated_at
```

### Tâches
- [ ] **USER-01** — Liste utilisateurs avec recherche (email, nom, prénom, username)
- [ ] **USER-02** — Filtres : rôle, mode (exam/scolarite), track (gpx/pa), date inscription
- [ ] **USER-03** — Fiche utilisateur complète :
  - Informations profil (nom, email, ville, téléphone, anniversaire)
  - Plan d'abonnement actif
  - Historique quiz (dernières sessions, scores)
  - Historique signalements soumis
  - Historique bugs soumis
  - Historique messages contact
- [ ] **USER-04** — Actions admin sur un utilisateur :
  - Bannir / suspendre (`role` dans `user_profiles`)
  - Réactiver
  - Supprimer le compte (cascade)
- [ ] **USER-05** — Statistiques utilisateur :
  - Total quiz joués
  - Score moyen
  - Dernière connexion
- [ ] **USER-06** — Pagination + export CSV

---

## ═══════════════════════════════════════════
## MODULE 7 — ABONNEMENTS & FACTURATION
## ═══════════════════════════════════════════

### Tables utilisées
- `billing_subscriptions` — abonnements actifs/résiliés
- `billing_profiles` — profils de facturation
- `billing_events` — événements de paiement
- `billing_invoices` — factures
- `billing_payment_methods` — méthodes de paiement
- `stripe_customers` — mapping Stripe

### Structure de `billing_subscriptions`
```
id                   uuid
user_id              uuid
plan                 text         ex: 'monthly' | 'yearly' | 'premium'
status               text         'active' | 'canceled' | 'past_due' | 'trialing'
current_period_start timestamptz
current_period_end   timestamptz
created_at / updated_at
```

### Structure de `stripe_customers`
```
user_id            uuid
stripe_customer_id text         identifiant Stripe (cus_...)
email              text
created_at / updated_at
```

### Tâches
- [ ] **BILL-01** — Vue d'ensemble abonnements :
  - Total abonnés actifs
  - Total résiliations du mois
  - Répartition par plan (monthly/yearly)
  - MRR estimé (Monthly Recurring Revenue)
- [ ] **BILL-02** — Liste abonnements avec filtres : statut, plan, date
- [ ] **BILL-03** — Fiche abonnement utilisateur :
  - Plan, statut, période en cours
  - ID client Stripe (`stripe_customer_id`)
  - Lien direct vers le dashboard Stripe
- [ ] **BILL-04** — Historique des événements (`billing_events`) par utilisateur
- [ ] **BILL-05** — Liste des factures (`billing_invoices`) avec téléchargement PDF
- [ ] **BILL-06** — Graphique revenus par mois (30/90/365 jours)
- [ ] **BILL-07** — Churn rate (taux de résiliation)

---

## ═══════════════════════════════════════════
## MODULE 8 — GESTION DES QUESTIONS QUIZ (BDD)
## ═══════════════════════════════════════════

### Tables utilisées
- `quiz_questions` — questions culture générale
- `tests_psyco_suite_logique` — questions suite logique
- `tests_psyco_calcul_mental`, `tests_psyco_raisonnement_logique`, etc.
- `report_culture_generale`, `tests_psycotechnique_report` — signalements liés

### Structure de `quiz_questions`
```
id          bigint       PK (auto-increment)
module      text         ex: 'culture_generale_droit'
category    text
difficulty  text         'Facile' | 'Moyenne' | 'Difficile' | 'Expert'
question    text
options     jsonb        tableau de strings
answer      text
explanation text
sub         text         sous-catégorie optionnelle
rand_key    float        pour randomisation
```

### Tâches
- [ ] **QUIZ-01** — Liste des questions avec filtres (module, catégorie, difficulté)
- [ ] **QUIZ-02** — Recherche plein texte dans les questions
- [ ] **QUIZ-03** — Éditer une question (texte, options, réponse, explication)
- [ ] **QUIZ-04** — Ajouter une nouvelle question
- [ ] **QUIZ-05** — Supprimer une question (avec confirmation)
- [ ] **QUIZ-06** — Depuis un signalement résolu → lien direct vers la question à corriger
- [ ] **QUIZ-07** — Indicateur : "X signalements ouverts sur cette question"
- [ ] **QUIZ-08** — Import CSV / JSON de questions en masse
- [ ] **QUIZ-09** — Statistiques par question :
  - Taux de bonne réponse (si loggé)
  - Nombre de fois jouée

---

## ═══════════════════════════════════════════
## MODULE 9 — GESTION DU FORUM
## ═══════════════════════════════════════════

### Tables utilisées
- `forum_posts_exam_gpx` — posts du forum GPX
- `forum_post_comments_exam_gpx` — commentaires
- `forum_messages_exam_gpx` — messages
- `forum_rooms`, `forum_room_members` — salles
- `forum_bans`, `forum_blocks` — modération

### Tâches
- [ ] **FORUM-01** — Liste des posts récents avec auteur et date
- [ ] **FORUM-02** — Recherche dans les posts
- [ ] **FORUM-03** — Supprimer un post / commentaire
- [ ] **FORUM-04** — Gérer les bans (`forum_bans`) : liste + créer + lever
- [ ] **FORUM-05** — Statistiques : posts aujourd'hui, utilisateurs actifs

---

## ═══════════════════════════════════════════
## MODULE 10 — NOTES DE PATCH
## ═══════════════════════════════════════════

### Table : `patch_notes`
(colonnes à vérifier — probablement : id, version, title, content, created_at, published)

### Tâches
- [ ] **PATCH-01** — Lister les notes de patch existantes
- [ ] **PATCH-02** — Créer une nouvelle note de patch (titre, contenu markdown, version)
- [ ] **PATCH-03** — Publier / dépublier une note
- [ ] **PATCH-04** — Modifier / supprimer une note
- [ ] **PATCH-05** — Prévisualisation rendu markdown

---

## ═══════════════════════════════════════════
## MODULE 11 — LOGS & AUDIT
## ═══════════════════════════════════════════

### Tables utilisées
- `app_logs` — logs de l'application mobile
- `admin_audit_logs` — toutes les actions des admins
- `app_events` — événements applicatifs

### Structure de `app_logs`
```
id            uuid
created_at    timestamptz
level         text         'debug' | 'info' | 'warning' | 'error' | 'critical'
message       text
context       text
event         text
route         text
screen        text
user_id       uuid
device_model  text
platform      text
os_version    text
app_version   text
build_number  text
```

### Structure de `admin_audit_logs`
```
id               bigint
created_at       timestamptz
actor_admin_id   uuid
actor_email      text
actor_role       text
target_table     text
target_id        text
target_user_id   uuid
action           text
severity         text         'info' | 'warning' | 'critical'
success          boolean
old_value        jsonb
new_value        jsonb
ip               text
user_agent       text
comment          text
meta             jsonb
```

### Tâches
- [ ] **LOG-01** — Logs app : liste filtrée par niveau, date, user, screen
- [ ] **LOG-02** — Logs app : focus sur les erreurs/critiques
- [ ] **LOG-03** — Audit admin : liste de toutes les actions admin
- [ ] **LOG-04** — Audit admin : filtres par acteur, action, sévérité
- [ ] **LOG-05** — Audit admin : détail avec `old_value` / `new_value` JSON diff
- [ ] **LOG-06** — Auto-enregistrement de toutes les actions du panel dans `admin_audit_logs`

---

## ═══════════════════════════════════════════
## MODULE 12 — GESTION DES ADMINS
## ═══════════════════════════════════════════

### Table : `admin_users`

### Tâches
- [ ] **ADMIN-01** — Liste des comptes admin (rôle, statut, dernière connexion)
- [ ] **ADMIN-02** — Créer un nouveau compte admin (email, rôle, permissions granulaires)
- [ ] **ADMIN-03** — Modifier les permissions d'un admin (`permissions` jsonb)
- [ ] **ADMIN-04** — Activer / désactiver un compte (`disabled`)
- [ ] **ADMIN-05** — Définir une expiration (`expires_at`) pour comptes temporaires
- [ ] **ADMIN-06** — Déverrouiller un compte locké (`locked_until`)
- [ ] **ADMIN-07** — Historique des connexions et actions (via `admin_audit_logs`)

---

## ═══════════════════════════════════════════
## ARCHITECTURE TECHNIQUE RECOMMANDÉE
## ═══════════════════════════════════════════

### Stack suggérée
- **Framework** : Next.js (App Router) ou Nuxt.js
- **UI** : Tailwind CSS + shadcn/ui
- **Auth admin** : JWT personnalisé (PAS Supabase Auth — admin_users est indépendant)
- **API** : Supabase service_role key côté serveur uniquement (jamais exposée au client)
- **Graphiques** : Recharts ou Chart.js

### Règles de sécurité
- Toutes les requêtes Supabase se font avec `service_role` key **côté serveur uniquement**
- Jamais de `anon` key dans les pages admin
- Chaque action admin doit écrire dans `admin_audit_logs`
- HTTPS obligatoire, headers sécurisés (CSP, HSTS)

### Structure de routes suggérée
```
/admin/login                  → AUTH-01 à 04
/admin/dashboard              → DASH-01 à 06
/admin/reports/questions      → REP-01 à 12
/admin/reports/bugs           → BUG-01 à 06
/admin/reports/forum          → FORUM-REP-01 à 04
/admin/users                  → USER-01 à 06
/admin/users/[id]             → USER-03 à 05
/admin/billing                → BILL-01 à 07
/admin/billing/[userId]       → BILL-03 à 05
/admin/quiz/questions         → QUIZ-01 à 09
/admin/forum                  → FORUM-01 à 05
/admin/patch-notes            → PATCH-01 à 05
/admin/logs                   → LOG-01 à 06
/admin/admins                 → ADMIN-01 à 07
```

---

## ═══════════════════════════════════════════
## REQUÊTES SQL UTILES (référence rapide)
## ═══════════════════════════════════════════

### Signalements quiz non traités (toutes sources)
```sql
-- report_question (hardcoded)
SELECT 'hardcoded' AS source, id, created_at, question_text AS question,
       source_file, question_category AS category, report_type, status
FROM report_question WHERE status = 'new'

UNION ALL

-- report_culture_generale (DB-backed)
SELECT 'culture_generale' AS source, id::text, created_at, question, 
       module AS source_file, category, report_type, status
FROM report_culture_generale WHERE status = 'new' AND archived = false

UNION ALL

-- tests_psycotechnique_report
SELECT 'psychotechnique' AS source, id::text, created_at, question,
       module AS source_file, category, report_type, status
FROM tests_psycotechnique_report WHERE status = 'new' AND archived = false

ORDER BY created_at DESC;
```

### Abonnés actifs par plan
```sql
SELECT plan, COUNT(*) as total
FROM billing_subscriptions
WHERE status = 'active'
GROUP BY plan;
```

### Top 10 quiz les plus joués
```sql
SELECT quiz_name, COUNT(*) AS sessions, AVG(score::float / NULLIF(total_questions,0)) AS avg_score
FROM quiz_history
GROUP BY quiz_name
ORDER BY sessions DESC
LIMIT 10;
```

### Nouveaux inscrits par jour (30 derniers jours)
```sql
SELECT DATE(created_at) AS day, COUNT(*) AS new_users
FROM user_profiles
WHERE created_at >= NOW() - INTERVAL '30 days'
GROUP BY day
ORDER BY day;
```

---

## ═══════════════════════════════════════════
## SUIVI D'AVANCEMENT
## ═══════════════════════════════════════════

### Légende
- ⬜ À faire
- 🔄 En cours
- ✅ Fait
- ⏸️ Bloqué

### Récapitulatif
| Module | Tâches totales | Faites | % |
|--------|---------------|--------|---|
| 1. Auth admin | 8 | 0 | 0% |
| 2. Dashboard | 6 | 0 | 0% |
| 3. Signalements quiz | 12 | 0 | 0% |
| 4. Bugs & contacts | 6 | 0 | 0% |
| 5. Signalements forum | 4 | 0 | 0% |
| 6. Utilisateurs | 6 | 0 | 0% |
| 7. Facturation | 7 | 0 | 0% |
| 8. Questions quiz | 9 | 0 | 0% |
| 9. Forum | 5 | 0 | 0% |
| 10. Patch notes | 5 | 0 | 0% |
| 11. Logs & audit | 6 | 0 | 0% |
| 12. Gestion admins | 7 | 0 | 0% |
| **TOTAL** | **81** | **0** | **0%** |
