# 🎯 COP'IQ — PROGRESSION GLOBALE DU PROJET (A → Z)

> **Source de vérité unique** pour tout le projet COP'IQ : app mobile Flutter, site web, panel admin web.
> Audit initial le 2026-06-08 — **corrigé et revérifié le 2026-07-26** (voir encadré ci-dessous).
> Pour l'état détaillé du module Cas Pratique et la checklist de release, voir `RESTE_A_FAIRE.md` à la racine (document le plus à jour).

---

## 🔎 CORRECTIF D'AUDIT — 26 juillet 2026

L'audit du 8 juin ci-dessous est **daté de 7 semaines** et plusieurs de ses constats sont
devenus faux entre-temps. Avant d'utiliser un chiffre de ce document, vérifie qu'il n'est
pas contredit ici. Constats vérifiés aujourd'hui par lecture directe du code / de la base :

| Constat du 8 juin | Réalité vérifiée le 26/07 |
|---|---|
| **Phase K — Site web : 0/50, « à démarrer »** | **Faux.** `copiq-web/` existe déjà : ~45 pages Next.js — vitrine publique (accueil, tarifs, blog, CGU, contact, mentions légales, beta) **et** un tableau de bord authentifié quasi complet qui reprend la plupart des modules mobiles (profil, abonnement + facture + annulation, notes, mémos, concours blanc, forum, progression, historique, notifications, paramètres, cas pratiques, quiz GPX/PA, cours GPX/PA, culture générale, langues, psychotechniques). Reste réellement ouvert : SEO/blog éditorial (K-16 à K-24), performance/Lighthouse (K-41 à K-50), et la véracité du rendu visuel (non testable ici, pas de navigateur). |
| **Phase L — Panel admin : 12/66, cf. `ADMIN_PANEL_PROGRESSION.md`** | **Trompeur.** Ce fichier décrit une architecture (table `admin_users`, JWT custom, colonnes `password_hash`/`admin_code`) qui **n'a jamais été construite** — remplacée par Supabase Auth + TOTP (AAL2) + code staff, une conception différente documentée dans `copiq-web/src/app/admin/README.md`. Le panel réel a **13 pages actives** (dashboard, cas-pratiques, quiz, cours, abonnements, utilisateurs, appels, forum, patch-notes, administrateurs, journal, signalements, santé) adossées à des dizaines de RPC `SECURITY DEFINER`. Le vrai reliquat : pas de vue unifiée des signalements legacy 3-tables (module 3 du fichier), pas d'éditeur `quiz_questions` (questions hardcodées historiques). `ADMIN_PANEL_PROGRESSION.md` a été annoté en conséquence — ne pas utiliser son tableau récapitulatif (0/81) tel quel. |
| **Phase E — Edge functions : 8 `cas_pratique_*` listées « ✅ existe »** | **Faux : jamais déployées.** `supabase/functions/cas_pratique_*` (9 dossiers) ne sont que du code source local, absents de la liste réelle des fonctions déployées. Les **8 fonctions réellement actives** en production portent d'autres noms et une autre conception : `delete-user-cascade`, `unified-logs`, `send-report-received`, `stripe-create-checkout`, `stripe-cancel-subscription`, `stripe-portal`, `stripe-webhook`, `photolangage-correct`. Le paiement Stripe et la suppression de compte RGPD sont **bien en production**, juste pas sous les noms documentés ici. |
| **A-06 Sign in with Google : non coché** | **Fait.** `lib/features/auth/oauth_buttons.dart` contient un bouton Google entièrement dessiné à la main (logo quadrichrome, charte respectée), à côté du bouton Apple. |
| **I-08 Page abonnement utilisateur : non coché** | **Fait.** `lib/features/home/abonnement_page.dart` + `facture_page.dart` + `annulation_conditions_page.dart` existent et gèrent statut, facture, annulation. |
| **I-06 Wiring checkout côté app : non coché** | **Fait.** `lib/core/services/stripe_payment_service.dart` appelle directement les fonctions déployées `stripe-create-checkout` / `stripe-cancel-subscription` / `stripe-portal`. |
| **G — Gamification (streaks/XP/badges) : ✅ coché** | **Était faux, corrigé aujourd'hui.** Le code existait mais la table `cas_pratique_user_progress` (prérequis des 3 systèmes) n'avait jamais été créée en base : les triggers auraient planté à la première correction soumise. Corrigé le 26/07 (migration `cas_pratique_user_progress` + fix `fn_cp_is_admin`→`is_admin` + cast `case_id` + triggers exception-safe), testé en simulation RLS complète. Voir `RESTE_A_FAIRE.md`. |
| **C-07 Concours blanc : timer à compléter, multi-épreuves manquant** | **Timer déjà fait** (compte à rebours, auto-submit, autosave). **Multi-épreuves complété le 26/07** : la page charge désormais tous les cas attachés au mock exam via `cas_pratique_mock_exam_cases` (au lieu d'un seul cas en dur) et enchaîne les questions cas par cas. |
| **Module Cas Pratique : 100/100** | Ce score date d'avant la découverte que les migrations n'avaient jamais été appliquées en base (voir `RESTE_A_FAIRE.md` partie 1). Le module a été **réellement réparé depuis**, avec vérification SQL sous RLS — mais ne te fie plus au chiffre « 100/100 » de ce document, il ne voulait rien dire. |

**Non revérifié aujourd'hui** (statuts ci-dessous non garantis, à confirmer avant de s'y fier) :
tout le détail des Phases A, B, C (audits de contenu C-08→C-30), D, F, H, M, N — ces phases
n'ont pas été relues ligne à ligne dans cette passe ; leurs cases à cocher reflètent encore
l'audit du 8 juin.

---

## 📊 Métriques globales

| Périmètre | Score (8 juin) | Réalité vérifiée le 26/07 |
|---|---|---|
| **🎯 Module Cas Pratique** | 100/100 | Le score ne voulait rien dire (migrations jamais appliquées) — module réellement réparé et vérifié depuis, cf. `RESTE_A_FAIRE.md` |
| **📱 App Flutter mobile (reste)** | ~/180 | Non revérifié en détail — voir corrections ponctuelles ci-dessus (auth, gamification, concours blanc) |
| **🌐 Site internet copiq.fr** | 0/50 | **Faux : le site existe déjà**, ~45 pages (vitrine + dashboard complet). Reste surtout : SEO/blog éditorial, perf/Lighthouse |
| **🛡️ Panel admin web** | 12/66 | **Trompeur** : mesurait une architecture jamais construite. Le panel réel a 13 pages fonctionnelles sur une architecture différente |
| **🔐 Sécurité transverse** | À auditer | Largement traité depuis (fuite RGPD refermée, grille de correction protégée, `search_path` figé sur 87 fonctions) — cf. `RESTE_A_FAIRE.md` |

---

## 🏗️ Architecture du projet

```
copiqpolice/
├── lib/                         ← 1087 fichiers Dart
│   ├── main.dart                (133 KB — entry point)
│   ├── features/
│   │   ├── home/                ← 7 home pages (gpx_exam, gpx_school, pa_exam, pa_school, reserve_exam, reserve_school, home)
│   │   ├── auth/                ← signin, signup, confirm_email, reset_password
│   │   ├── onboarding/          ← discovery, mode_picker, grade_picker, 4 onboardings spécifiques
│   │   ├── placement/           ← test de placement post-signup
│   │   ├── forum/               ← forum communautaire
│   │   ├── notes/               ← annotations privées (CODE-091)
│   │   ├── memos/               ← fiches mémo (CODE-090)
│   │   └── reserve, warning, …
│   ├── content/
│   │   ├── gpx_exam/            ← 45 fichiers — concours GPX (cas pratique ✅, quiz, etc.)
│   │   ├── gpx_scolarite/       ← 722 fichiers — école GPX (énorme)
│   │   ├── pa_scolarite/        ← 161 fichiers — école PA
│   │   └── paywall/             ← CODE-084
│   ├── core/
│   │   ├── cas_pratique/        ← module ✅ 100/100
│   │   ├── services/            ← analytics, monitoring, payments, etc.
│   │   ├── feature_flags/       ← CODE-075/076
│   │   ├── notifications/       ← CODE-053 partial
│   │   └── widgets/
│   ├── data/
│   ├── routes/                  ← app_router.dart
│   └── l10n/                    ← FR + EN (CODE-082)
├── supabase/                    ← 32 migrations + 10 edge functions
├── web/                         ← coque Flutter Web (vide hors splash)
├── android/, ios/, macos/, linux/, windows/
├── assets/, test/, tests/, tools/
└── docs/                        ← 41 docs spec
```

---

## 🔵 PHASE A — Authentification & Onboarding (15 tâches)

### Auth (`lib/features/auth/`)
- [ ] **A-01** Audit `signin.dart` : gestion erreurs (réseau / mauvais MDP / compte non vérifié), états loading, accessibilité TalkBack
- [ ] **A-02** Audit `signup.dart` : validation email RFC, force MDP (min 8 + 1 majuscule + 1 chiffre), CGV checkbox obligatoire
- [ ] **A-03** Audit `confirm_email.dart` : renvoi automatique 60s, deep link `copiqpolice://confirm-email?token=…`
- [ ] **A-04** Audit `reset_password.dart` : workflow OTP 6 chiffres, ré-init MDP avec confirmation
- [x] **A-05** **Sign in with Apple** ✅ vérifié 26/07 — `lib/features/auth/oauth_service.dart` + `oauth_buttons.dart`
- [x] **A-06** **Sign in with Google** ✅ vérifié 26/07 — bouton dans `oauth_buttons.dart`
- [ ] **A-07** Page **"Compte bloqué"** après 5 tentatives MDP échouées (rate limit auth Supabase)
- [ ] **A-08** **Migration de compte** (changer email avec confirmation des 2 adresses)

### Onboarding (`lib/features/onboarding/`)
- [ ] **A-09** Audit `discovery_tutorial.dart` : skipable, persistance "déjà fait"
- [ ] **A-10** Audit `mode_picker.dart` : visualisation claire des 4 tracks (GPX scolarité, GPX exam, PA scolarité, PA exam)
- [ ] **A-11** Audit `grade_picker.dart` : sélection grade (élève / gardien / brigadier / …)
- [ ] **A-12** Audit `gpx_school.dart`, `pa_school.dart`, `reserve_school.dart` : welcome spécifique par track

### Placement (`lib/features/placement/`)
- [ ] **A-13** `placement_test.dart` : algo qui pose 10-15 questions adaptatives pour évaluer le niveau initial
- [ ] **A-14** `placement_engine.dart` : moteur de scoring + recommandations de modules à attaquer
- [ ] **A-15** `welcome_after_signup.dart` : éviter les écrans trop longs après signup (taux de drop élevé)

---

## 🟢 PHASE B — Home Pages & Navigation (12 tâches)

### Les 7 home pages
- [ ] **B-01** `home_page.dart` (104 KB) : audit complet, factoriser code dupliqué entre les 4 home tracks
- [ ] **B-02** `home_page_gpx_exam.dart` (80 KB) : ✅ Bottom bar fait — vérifier que Annales + Concours blanc + Favoris + Profil fonctionnent
- [ ] **B-03** `home_page_gpx_school.dart` (210 KB) : auditer les 722 fichiers d'exercices liés
- [ ] **B-04** `home_page_pa_exam.dart` (47 KB) : refonte bottom bar comme GPX exam (Concours blanc / Annales)
- [ ] **B-05** `home_page_pa_school.dart` (142 KB) : auditer les 161 fichiers d'exercices liés
- [ ] **B-06** `home_page_reserve_exam.dart` + `home_page_reserve_school.dart` : compléter le track Réserve (3-10 KB seulement, manque du contenu)

### Navigation transverse
- [ ] **B-07** **Audit `app_router.dart`** : compter et vérifier toutes les routes nommées, factoriser route guards
- [ ] **B-08** **Deep links** : tester chaque deep link (CODE-071 fait mais à valider sur device)
- [ ] **B-09** **Back navigation** : système-back Android, swipe-back iOS, gérer la pile sur les modals
- [ ] **B-10** **Restoration state** : quand l'app est tuée par OS, retrouver l'écran d'origine
- [ ] **B-11** **Indicateurs de progression dans la sidebar** : badge "Nouveau" sur les modules récemment ajoutés
- [ ] **B-12** **Recherche globale** (page d'accueil — par modules, par mots-clés)

---

## 🟡 PHASE C — Contenu pédagogique (30 tâches)

### GPX EXAM (concours — `lib/content/gpx_exam/`)
- [x] **C-01** Cas pratique ✅ 100/100 (cf. docs/cas_pratique/PROGRESSION_CODE.md)
- [ ] **C-02** **Quiz culture générale** — 11 modules (cinéma, droit, France, géo, histoire, institutions, musique, etc.) → audit cohérence, refonte design system, tracking complétion
- [ ] **C-03** **Psychotechniques** : tests d'attention visuelle, raisonnement, suites logiques. Audit `attention_visuelle_page.dart`
- [ ] **C-04** **Langue étrangère** : compréhension écrite + audio FR/EN. Audit `langue_etrangere/`
- [ ] **C-05** **Structure GPX concours** : page récap des épreuves admissibilité + admission (`gpx_admissibilite_page.dart`, `gpx_admission_page.dart`)
- [ ] **C-06** **Annales** — module créé en placeholder, à coder (cf. `docs/cas_pratique/ANNALES_DEV_PROGRESSION.md`)
- [x] **C-07** **Concours blanc** ✅ vérifié/complété 26/07 — timer + autosave + auto-submit déjà présents, multi-épreuves (enchaînement de plusieurs cas via `cas_pratique_mock_exam_cases`) ajouté aujourd'hui dans `concours_blanc_page.dart`. Reste à faire : correction automatique du mock (actuellement affichée comme "en attente de l'équipe")

### GPX SCOLARITÉ (école — `lib/content/gpx_scolarite/`)
- [ ] **C-08** Audit **dps_dpg** (Défense Personnelle Simulée + Défense Personnelle Gendarmerie)
- [ ] **C-09** Audit **institutions_valeurs**
- [ ] **C-10** Audit **memento_circulation** (Code de la route + procédures)
- [ ] **C-11** Audit **policier_intervention_avance** + **_initial**
- [ ] **C-12** Audit **pv_apj20** (Procès-verbaux + APJ20)
- [ ] **C-13** Audit **quiz_scolarite_gpx** — vérifier sync avec Supabase
- [ ] **C-14** Audit **shared/** — composants partagés entre modules scolarité

### PA SCOLARITÉ (`lib/content/pa_scolarite/`)

#### ✅ Contenu ajouté (2026-06-10)
- [x] **C-PA-01** Créé `institution_valeurs/deontologie/` — 7 cours copiés depuis GPX (routes `/pa/institution/deontologie/…`)
- [x] **C-PA-02** Créé `institution_valeurs/hierarchie_info/` — 3 cours (compte_rendu, formalisme_rapport, modeles_rapports)
- [x] **C-PA-03** Créé `institution_valeurs/accueil_public/` — 5 cours
- [x] **C-PA-04** Créé `institution_valeurs/laicite/` — 3 cours
- [x] **C-PA-05** Créé `institution_valeurs/histoire/` — histoire_reperes_page
- [x] **C-PA-06** Ajouté 12 cours circulation routière dans `circulation_pages/` (routes `/pa/dps_dpg/socle_initial/circulation/…`)
- [x] **C-PA-07** Ajouté 30 cours atteintes aux biens dans `atteintes_biens_pages/` avec sous-dossiers (vol, contrefaçons, destructions, recel, STAD, voisines du vol)

#### ✅ Complété (2026-06-11)
- [x] **C-PA-09** Routes organisation_pn enregistrées dans app_router.dart (8 pages)
- [x] **C-PA-10** Hub pages IV (institution_valeurs_pages) — 19 pages mises à jour avec vrais _LinkTile

#### 🔴 À coder manuellement
- [x] **C-PA-08** Créé organisation_judiciaire PA — 5 cours (structure judiciaire, ministère public, juge instruction, juridictions pénales, voies de recours) + hub page + routes

#### Audits restants
- [ ] **C-15** Audit **armes_munitions_pages**
- [ ] **C-16** Audit **atteintes_biens_pages** + **atteintes_nation_pages** + **atteintes_personnes_pages**
- [ ] **C-17** Audit **cadres_juridiques_pages**
- [ ] **C-18** Audit **circulation_pages**
- [ ] **C-19** Audit **dpg_pages** (Défense Personnelle)
- [ ] **C-20** Audit **formation_initiale**
- [ ] **C-21** Audit **institution_valeurs_pages**
- [ ] **C-22** Audit **libertes_publiques_pages**
- [ ] **C-23** Audit **mineurs_famille_pages**
- [ ] **C-24** Audit **organisation_pn** (Police Nationale)
- [ ] **C-25** Audit **policier_intervention_pages**
- [ ] **C-26** Audit **procedure_penale_pages**
- [ ] **C-27** Audit **quiz_scolarite_pa**
- [ ] **C-28** Audit **sanction_pages**
- [ ] **C-29** Audit **stupefiants_pages**
- [ ] **C-30** Audit **tentative** (logique tentative d'infraction)

### Réserve & PA Exam (à compléter)
- [ ] **C-31** Compléter le track **Réserve** (3-10 KB seulement actuellement — content quasi vide)
- [ ] **C-32** Refonte modules **PA Exam** (concours PA — symétrique au concours GPX)

---

## 🔴 PHASE D — Sécurité & RGPD (12 tâches)

### Authentification
- [ ] **D-01** **MFA / 2FA** (TOTP) optionnel pour l'utilisateur, **obligatoire pour les admins**
- [ ] **D-02** **Détection login suspect** (ville/IP différente → email d'alerte)
- [ ] **D-03** **Politique MDP forte** + check Have I Been Pwned (k-anonymity API)
- [ ] **D-04** **Session timeout** auto après 24h d'inactivité

### Données
- [x] **D-05** RGPD export + delete user data ✅ (CODE-079)
- [ ] **D-06** **Chiffrement at-rest** des champs sensibles (`auth.users.email` est déjà OK Supabase, mais les notes utilisateur à chiffrer)
- [ ] **D-07** **Audit RLS** sur **toutes** les 32 tables — checklist signed-only / scope auth.uid()
- [ ] **D-08** **Anonymisation** des leaderboards (déjà fait CODE-059) — étendre aux stats publiques

### Surface attaque
- [x] **D-09** OWASP Mobile Top 10 ✅ (CODE-055)
- [ ] **D-10** **Pentest externe** avant release publique (budget ~3-5k€ pour un audit pro)
- [ ] **D-11** **Bug bounty program** sur HackerOne (premier mois public, payer en commentaires uniquement)
- [ ] **D-12** **Headers de sécurité** sur futur site web (CSP, HSTS, X-Frame-Options)

---

## 🟣 PHASE E — Backend & Base de données (15 tâches)

### Tables existantes (32 migrations) — Audit RLS + performance
- [ ] **E-01** Audit perf de toutes les requêtes principales (EXPLAIN ANALYZE) — viser < 50ms p95
- [ ] **E-02** Index manquants : `cas_pratique_attempts.user_id + status`, `cas_pratique_user_notes.attempt_id`, etc.
- [ ] **E-03** Partitionnement de `cas_pratique_attempts` par année (si > 1M lignes prévues)
- [ ] **E-04** Audit triggers : éviter les cascades silencieuses qui ralentissent les inserts
- [ ] **E-05** **Sauvegarde automatique** : config PITR Supabase + export quotidien S3 (CODE-021 admin TODO)

### Edge Functions — corrigé 26/07 (liste réelle vs documentée)

> Les 8 lignes ci-dessous (`cas_pratique_*`) sont **du code source jamais déployé**
> (dossiers présents dans `supabase/functions/` mais absents de la liste réelle des
> fonctions actives sur le projet Supabase). Conservées à titre d'historique.

- [ ] **E-06** `cas_pratique_correct_attempt` ❌ code source seulement, jamais déployée
- [ ] **E-07** `cas_pratique_stripe_webhook` ❌ code source seulement — remplacée en prod par `stripe-webhook`
- [ ] **E-08** `cas_pratique_create_checkout` ❌ code source seulement — remplacée en prod par `stripe-create-checkout`
- [ ] **E-09** `cas_pratique_redeem_promo` ❌ code source seulement, jamais déployée
- [ ] **E-10** `cas_pratique_export_user_data` ❌ code source seulement
- [ ] **E-11** `cas_pratique_delete_user_data` ❌ code source seulement — remplacée en prod par `delete-user-cascade`
- [ ] **E-12** `cas_pratique_business_notify` ❌ code source seulement, cron jamais activé (secrets manquants)
- [ ] **E-13** `cas_pratique_health` ❌ code source seulement, jamais déployée
- [ ] **E-14** À créer : **`copiq_admin_check`** (validation rôle admin côté serveur — ADMIN-014)
- [ ] **E-15** À créer : **`copiq_global_search`** (recherche fuzzy multi-modules transverse)

**Les 8 fonctions réellement déployées et actives** (vérifié 26/07 via l'API Supabase) :
`delete-user-cascade`, `unified-logs`, `send-report-received`, `stripe-create-checkout`,
`stripe-cancel-subscription`, `stripe-portal`, `stripe-webhook`, `photolangage-correct`.
Le paiement Stripe et la suppression RGPD sont donc **bien en production**, sous ces noms.

---

## 🟠 PHASE F — Design System & Cohérence visuelle (10 tâches)

- [ ] **F-01** **Inventaire visuel** : screenshots des 50 écrans principaux → tableau comparatif des incohérences
- [ ] **F-02** **Cohérence des boutons** : audit que tous utilisent `FilledButton`/`OutlinedButton` du theme, pas de couleurs hardcodées
- [ ] **F-03** **Cohérence des cartes** : radius (14/18/20px), shadows, padding — tout doit utiliser `CpTokens`
- [ ] **F-04** **Cohérence des inputs** : tous les `TextField` doivent partager le même style
- [ ] **F-05** **Typo cohérente** : Montserrat partout, tailles standardisées (12/13/14/16/20/24px)
- [ ] **F-06** **Dark mode** ✅ AMOLED (CODE-068) — vérifier sur **chaque écran** que le contraste passe WCAG AA
- [ ] **F-07** **Accessibilité** ✅ audit (CODE-081 doc) — appliquer effectivement (semantic labels partout)
- [ ] **F-08** **Animations** : 200-250ms ease-out partout, respect `reduceMotion`
- [ ] **F-09** **Icônes** : un seul set (Material Icons OU custom SVG) — éviter le mix
- [ ] **F-10** **Empty states + Error states** unifiés (créer un widget `CpEmptyState` global)

---

## 🟦 PHASE G — Engagement & Gamification (déjà très avancé)

> ⚠️ **G-01/G-02/G-03 étaient cochés à tort** : le code existait mais sa table prérequise
> (`cas_pratique_user_progress`) n'avait jamais été créée en base — les triggers auraient
> planté à la première correction soumise par un élève. **Réparé et testé le 26/07** (voir
> encadré d'audit en haut de ce document et `RESTE_A_FAIRE.md`).

- [x] **G-01** Streaks ✅ (CODE-056) — réparé + testé 26/07
- [x] **G-02** XP + niveaux ✅ (CODE-057) — réparé + testé 26/07
- [x] **G-03** Badges (20 badges) ✅ (CODE-058) — réparé + testé 26/07
- [x] **G-04** Leaderboard hebdo ✅ (CODE-059)
- [x] **G-05** Parrainage ✅ (CODE-060)
- [x] **G-06** Concours blanc ✅ (CODE-061)
- [x] **G-07** Reco "à toi de jouer" ✅ (CODE-062)
- [ ] **G-08** **Push notifications intelligentes** (CODE-093 fait, à valider en prod)
- [ ] **G-09** **Quêtes hebdomadaires** : "Fais 5 cas cette semaine → 100 XP bonus"
- [ ] **G-10** **Évènements thématiques** : "Semaine spéciale procédure pénale" + leaderboard dédié

---

## 🟫 PHASE H — Performance & Bundle (5 tâches)

- [x] **H-01** Performance utils ✅ (CODE-077)
- [x] **H-02** Bundle size audit ✅ (CODE-078)
- [ ] **H-03** **Appliquer les fixes du bundle audit** : conversion PNG → WebP, polices subsets
- [ ] **H-04** **Tester sur low-end Android** (Samsung Galaxy A03, 2 GB RAM, Android 11) → cible 60fps sur cas pratique
- [ ] **H-05** **Précachage intelligent** : précharger les images des 3 prochains cas en background

---

## 💰 PHASE I — Monétisation & Business (très avancé)

- [x] **I-01** Paywall + tiers ✅ (CODE-084)
- [x] **I-02** Stripe ✅ (CODE-085) — provider unique, RevenueCat retiré du repo le 18/08/2026
- [x] **I-03** Tarification 3 plans ✅ (CODE-086)
- [x] **I-04** Codes promo ✅ (CODE-087)
- [x] **I-05** Dashboard business ✅ (CODE-088)
- [x] **I-06** **Wiring final côté app** ✅ vérifié 26/07 — `stripe_payment_service.dart` appelle bien les edge functions Stripe déployées. Reste : test réel en sandbox (nécessite un device, non faisable ici)
- [ ] **I-07** **Arbitrer la conformité stores** (Apple 3.1.1 / Google Play Payments) avant submission — Stripe Checkout en navigateur externe peut motiver un rejet. Options dans `docs/cas_pratique/STRIPE_SETUP.md` §5
- [x] **I-08** **Page abonnement utilisateur** ✅ vérifié 26/07 — `abonnement_page.dart` + `facture_page.dart` + `annulation_conditions_page.dart`
- [ ] **I-09** **Webhook Slack new-sub** ✅ existe — vérifier que ça part bien en prod

---

## 📦 PHASE J — Release & CI/CD

- [x] **J-01** Pipeline CI/CD GitHub Actions ✅ (CODE-097)
- [x] **J-02** Force update si breaking change ✅ (CODE-098)
- [x] **J-03** Tests E2E Maestro ✅ (CODE-099)
- [x] **J-04** Release v1.0 checklist ✅ (CODE-100)
- [ ] **J-05** **Soumission App Store Connect** : screenshots iPhone 15 Pro Max + iPad Pro, vidéo preview, ASO (mots-clés)
- [ ] **J-06** **Soumission Google Play Console** : feature graphic 1024×500, fiche listing FR + EN, beta testing
- [ ] **J-07** **Smoke test final** sur 10 devices physiques (iPhone 12/14/15, Pixel 6/8, Samsung S22/S24, etc.)
- [ ] **J-08** **Page d'accueil / landing temporaire** sur copiq.fr (avant le vrai site Phase K)
- [ ] **J-09** **Release notes** publiées + email d'annonce aux beta-testers

---

## 🌐 PHASE K — Site internet copiq.fr

> ⚠️ **Corrigé 26/07 : ce n'est plus « 0/50 à démarrer », le site existe déjà.**
> `copiq-web/` (Next.js, export statique) compte ~45 pages : vitrine publique (accueil,
> tarifs, blog + `[slug]`, CGU, contact, mentions légales, page beta) **et** un tableau de
> bord authentifié qui reprend une bonne partie des modules mobiles (profil, abonnement,
> facture, annulation, notes, mémos, concours blanc, forum + posts, progression, historique,
> notifications, paramètres, cas pratiques, quiz GPX/PA + `[moduleId]`, cours GPX/PA,
> culture générale, langues, psychotechniques). Les sous-tâches K-06 à K-15, K-26 à K-40
> ci-dessous sont donc **très probablement déjà largement couvertes** — à confirmer page par
> page (non fait dans cette passe, faute de navigateur pour un contrôle visuel). Ce qui
> reste très probablement un vrai reliquat : le blog éditorial (K-16 à K-19, contenu SEO à
> rédiger), et toute la partie performance/Lighthouse/analytics (K-41 à K-50, nécessite un
> vrai déploiement pour mesurer).

### Spec & architecture (5)
- [ ] **K-01** **Spec produit** : vitrine + blog + accès gratuit à 3 cas pratiques + paywall pour le reste
- [ ] **K-02** **Choix techno final** : Next.js 14 App Router (recommandé) vs Astro
- [ ] **K-03** **Setup Vercel** + domaine copiq.fr
- [ ] **K-04** **Design système web** : reprendre tokens COP'IQ en CSS variables
- [ ] **K-05** **Stratégie SEO** : keywords ("concours gardien de la paix", "préparation police nationale", "cas pratique GPX", etc.)

### Pages publiques (10)
- [ ] **K-06** Landing page : hero + 3 piliers (cas pratique, gamification, business)
- [ ] **K-07** Page **Cas pratique** (démo gratuite × 3, paywall × N)
- [ ] **K-08** Page **Tarifs** (3 plans + comparatif)
- [ ] **K-09** Page **Témoignages** (preuves sociales)
- [ ] **K-10** Page **À propos** (équipe, mission)
- [ ] **K-11** Page **Contact** + formulaire
- [ ] **K-12** Page **FAQ**
- [ ] **K-13** Pages **CGV** + **CGU** + **Politique de confidentialité** (RGPD)
- [ ] **K-14** Page **Cookies** (banner consent CODE-080 spec)
- [ ] **K-15** Page **status.copiq.fr** (CODE-083 Uptime Kuma)

### Blog & contenu SEO (10)
- [ ] **K-16** **CMS** : Contentlayer / Notion / Strapi / direct MDX
- [ ] **K-17** **15 articles seed** : "Comment réussir le concours GPX en 6 mois", "Méthodologie cas pratique", etc.
- [ ] **K-18** **Calendrier éditorial** : 2 articles/semaine pendant 6 mois (couvre 1ère page Google sur ~80 keywords)
- [ ] **K-19** **Newsletter** : intégration Resend + page d'archive
- [ ] **K-20** **Open Graph / Twitter Cards** ✅ spec faite (CODE-072) — implémenter
- [ ] **K-21** **Sitemap.xml** dynamique
- [ ] **K-22** **Schema.org** Course + Article + Organization
- [ ] **K-23** **Robots.txt** + canonical
- [ ] **K-24** **AMP** ou **pages statiques ultra-rapides** (Lighthouse 100/100/100/100)
- [ ] **K-25** **Sharing pages** /c/{slug} (CODE-071 deep links) → page web qui ouvre l'app ou affiche le cas en lecture

### Compte utilisateur web (15)
- [ ] **K-26** **Auth Supabase** côté web (login/signup même base de comptes que l'app mobile)
- [ ] **K-27** **Page Mon compte** : statut abonnement, factures Stripe, paramètres
- [ ] **K-28** **Page Mes cas** (synchro avec l'app)
- [ ] **K-29** **Page Mes statistiques** : graphiques de progression, comparaison à la moyenne
- [ ] **K-30** **Page Mes badges**
- [ ] **K-31** **Page Mes appels** (synchro)
- [ ] **K-32** **Page Mes notes** (CODE-091)
- [ ] **K-33** **Page Annales** + téléchargement PDF
- [ ] **K-34** **Page Mémo** (CODE-090 — lecteur markdown web)
- [ ] **K-35** **Page Cas pratique COMPLET sur web** (pour ceux qui préfèrent taper au clavier)
- [ ] **K-36** **Page Concours blanc** (timer + plein écran web)
- [ ] **K-37** **Page Forum** ou Discord embed
- [ ] **K-38** **Page Paywall** + Stripe Checkout (déjà branché edge fn)
- [ ] **K-39** **Page de partage** publique d'un score (Open Graph CODE-072)
- [ ] **K-40** **Mode hors-ligne** PWA (offline-first pour la lecture)

### Performance & ops (10)
- [ ] **K-41** Lighthouse 95+ sur les 4 axes (Performance, Accessibility, Best Practices, SEO)
- [ ] **K-42** Core Web Vitals : LCP < 2.5s, FID < 100ms, CLS < 0.1
- [ ] **K-43** Images Next/Image avec lazy + AVIF
- [ ] **K-44** Analytics : PostHog côté web (consent-aware)
- [ ] **K-45** Sentry web (browser SDK)
- [ ] **K-46** A/B testing (réutilise CODE-075/076)
- [ ] **K-47** ISR + revalidation on-demand
- [ ] **K-48** Cache CDN long terme pour les statics
- [ ] **K-49** Sitemap submitted Google Search Console + Bing
- [ ] **K-50** Tests E2E Playwright sur les flows publics critiques

---

## 🛡️ PHASE L — Panel admin web

> ⚠️ **Corrigé 26/07 : le fichier `admin/docs/PROGRESSION.md` référencé ci-dessous n'existe
> pas** (le vrai fichier est `ADMIN_PANEL_PROGRESSION.md` à la racine, et il décrit une
> architecture jamais construite — voir le bandeau ajouté en tête de ce fichier). Le panel
> réel vit dans `copiq-web/src/app/admin/` (13 pages, voir son `README.md`), utilise Supabase
> Auth + TOTP (AAL2) + code staff — la sécurité serveur (équivalent ADMIN-013/014/015) est
> **déjà en place** via `cp_admin_guard()` / `forum_admin_guard()` / `quiz_admin_guard()`,
> ce n'est donc plus bloquant. Reliquats réels identifiés : vue unifiée des signalements
> quiz sur les 3 tables legacy, éditeur de `quiz_questions` hardcodées (RPC
> `admin_upsert_quiz_question` existe, aucune page ne l'utilise).

---

## 🧪 PHASE M — Tests & qualité (à compléter)

- [x] **M-01** Tests engine cas pratique ✅ (CODE-049)
- [x] **M-02** Tests parité Dart↔TS ✅ (CODE-052)
- [x] **M-03** Tests E2E Maestro ✅ (CODE-099)
- [ ] **M-04** **Coverage Dart** > 60% sur le `core/` et `data/`
- [ ] **M-05** **Tests widget** sur les 20 écrans les plus critiques
- [ ] **M-06** **Golden tests** sur les widgets de design system (PointPill, ScoreReveal, CasPratiqueScaffold)
- [ ] **M-07** **Tests d'intégration auth** (signup → confirm → login → logout)
- [ ] **M-08** **Tests de monétisation** (paywall → checkout → webhook → unlock)
- [ ] **M-09** **Smoke test physique** sur 10 devices avant chaque release majeure
- [ ] **M-10** **Tests d'accessibilité** automatisés (Flutter a11y_test_helper)

---

## 🚀 PHASE N — Post-release & croissance (à planifier)

- [ ] **N-01** **Plan marketing lancement** : pre-launch list, ProductHunt, communautés Discord/Facebook concours police
- [ ] **N-02** **Partenariats** : écoles de prépa privées, écoles de police (potentiellement B2B)
- [ ] **N-03** **Influenceurs** : YouTubers concours police, TikTok #concourspolice
- [ ] **N-04** **App Store Optimization** : titre, sous-titre, captures d'écran A/B tests
- [ ] **N-05** **Plan de contenu YouTube** : 1 vidéo/semaine "Méthodologie cas pratique", "Découvrir le concours GPX 2026", etc.
- [ ] **N-06** **Programme parrainage** ✅ (CODE-060) — campagne de lancement
- [ ] **N-07** **Cohorte beta-testers** : 100 candidats GPX 2026 avant ouverture publique
- [ ] **N-08** **Roadmap publique** sur le site (notion / GitHub Projects public)
- [ ] **N-09** **Newsletter mensuelle** : statistiques d'avancement, nouvelles features, success stories
- [ ] **N-10** **Mesure KPIs** : DAU, MAU, MRR, churn, NPS — dashboard Metabase ou superset

---

## 🎯 Priorisation suggérée

> ⚠️ Liste du 8 juin, partiellement obsolète. Items **déjà traités** (vérifié 26/07 ou
> RESTE_A_FAIRE.md) : ~~L-B~~, ~~D-07~~ (RLS largement auditée/corrigée), ~~I-06~~,
~~A-05 + A-06~~, ~~K-01→K-05~~ (site déjà démarré et très avancé). Ce qui reste
> réellement d'actualité :

### 🥇 Reste réellement prioritaire (2026-07-26)

1. **`flutter analyze` + `flutter test` + device réel** — non exécutable dans cet environnement, à faire par Kaïs
2. **J-05 + J-06** — Soumissions App Store + Google Play → débloque la release
3. **I-07** — Arbitrer la conformité stores (Apple 3.1.1 / Google Play Payments) → cf. `docs/cas_pratique/STRIPE_SETUP.md` §5
4. **M-09** — Smoke test sur 10 devices physiques
5. **C-31 + C-32** — Compléter Réserve + PA Exam → tracks encore quasi vides
6. **C-06** — Module Annales (placeholder non codé)
7. **K-16 → K-19** — Blog éditorial SEO (contenu à rédiger, rien de technique bloquant)
8. Compléter les mentions légales (SIREN, adresse, médiateur) — voir `RESTE_A_FAIRE.md`
9. Activer Apple/Google côté portails (Apple Developer + Supabase) — voir `docs/AUTH_OAUTH_SETUP.md`
10. **F-01** — Inventaire visuel des écrans (toujours pertinent, jamais fait)

---

## 📈 Effort estimé global

| Phase | Tâches | Effort solo (jours) |
|---|---|---|
| A — Auth & Onboarding | 15 | 8 |
| B — Home & Navigation | 12 | 10 |
| C — Contenu pédagogique | 32 | **30-40** (très gros) |
| D — Sécurité & RGPD | 12 | 8 |
| E — Backend & DB | 15 | 6 |
| F — Design system | 10 | 7 |
| G — Gamification | 10 | 3 (mostly done) |
| H — Performance | 5 | 4 |
| I — Monétisation | 9 | 3 (mostly done) |
| J — Release & CI/CD | 9 | 5 |
| K — Site web | 50 | **25-30** |
| L — Panel admin web | 54 restants | 20 |
| M — Tests & qualité | 10 | 8 |
| N — Post-release | 10 | continu |
| **TOTAL** | **~250** | **~140-160 jours solo** |

→ En équipe de 2 : ~80 jours. En équipe de 3 : ~55 jours.

---

## 📐 Légende

| Symbole | Signification |
|---|---|
| ✅ | Tâche terminée |
| 🟡 | En cours / partiellement fait |
| 🔴 | À faire |
| 🔥 | Bloquant pour la prod |
| ⏰ | Sensible au temps (deadline concours) |

---

## 🔗 Documents référence

> ⚠️ Corrigé 26/07 : `docs/cas_pratique/PROGRESSION_CODE.md` et `docs/cas_pratique/07_STATE.json`
> ont été archivés (`_archive/`) — ils annonçaient « 100/100, terminé » alors que les
> migrations n'avaient jamais été appliquées en base. `admin/docs/PROGRESSION.md` et
> `admin/docs/ADMIN_STATE.json` n'ont jamais existé (le dossier `admin/` n'existe pas — le
> panel vit dans `copiq-web/src/app/admin/`).

- **`RESTE_A_FAIRE.md`** (racine) → **document le plus à jour**, audit du 26/07, état réel module par module et checklist de ce qui reste avant les stores
- `copiq-web/src/app/admin/README.md` → architecture réelle du panel admin
- `docs/cas_pratique/01_MASTER_PLAN.md` → Plan stratégique cas pratique (historique)
- `docs/cas_pratique/06_ADMIN_PANEL_SPEC.md` → Spec panel admin (historique, partiellement obsolète)

---

*Document maintenu en synchronisation avec l'avancement.*
*Audit initial : 2026-06-08. Corrections d'audit : 2026-07-26.*
