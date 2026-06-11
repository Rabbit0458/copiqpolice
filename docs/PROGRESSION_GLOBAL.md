# 🎯 COP'IQ — PROGRESSION GLOBALE DU PROJET (A → Z)

> **Source de vérité unique** pour tout le projet COP'IQ : app mobile Flutter, site web futur, panel admin web.
> Audité le 2026-06-08 — 1087 fichiers Dart, 32 migrations SQL, 10 edge functions.

---

## 📊 Métriques globales

| Périmètre | Score | État |
|---|---|---|
| **🎯 Module Cas Pratique** | 100/100 | ✅ Complet (cf. `docs/cas_pratique/PROGRESSION_CODE.md`) |
| **📱 App Flutter mobile (reste)** | ~/180 | 🟡 Voir Phases A→J ci-dessous |
| **🌐 Site internet copiq.fr** | 0/50 | 🔴 À démarrer (Phase K) |
| **🛡️ Panel admin web** | 12/66 | 🟡 Voir `admin/docs/PROGRESSION.md` |
| **🔐 Sécurité transverse** | À auditer | 🟡 Voir Phase D |

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
- [ ] **A-05** **Sign in with Apple** (obligatoire pour App Store si on a déjà Google/email)
- [ ] **A-06** **Sign in with Google** (boutons natifs iOS/Android)
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
- [ ] **C-07** **Concours blanc** — page créée, à compléter avec timer + multi-épreuves

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

### Edge Functions (10 existantes) — Compléter
- [ ] **E-06** `cas_pratique_correct_attempt` ✅ existe
- [ ] **E-07** `cas_pratique_stripe_webhook` ✅ existe
- [ ] **E-08** `cas_pratique_create_checkout` ✅ existe
- [ ] **E-09** `cas_pratique_redeem_promo` ✅ existe
- [ ] **E-10** `cas_pratique_export_user_data` ✅ existe
- [ ] **E-11** `cas_pratique_delete_user_data` ✅ existe
- [ ] **E-12** `cas_pratique_business_notify` ✅ existe
- [ ] **E-13** `cas_pratique_health` ✅ existe
- [ ] **E-14** À créer : **`copiq_admin_check`** (validation rôle admin côté serveur — ADMIN-014)
- [ ] **E-15** À créer : **`copiq_global_search`** (recherche fuzzy multi-modules transverse)

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

- [x] **G-01** Streaks ✅ (CODE-056)
- [x] **G-02** XP + niveaux ✅ (CODE-057)
- [x] **G-03** Badges (20 badges) ✅ (CODE-058)
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
- [x] **I-02** Stripe + RevenueCat ✅ (CODE-085)
- [x] **I-03** Tarification 3 plans ✅ (CODE-086)
- [x] **I-04** Codes promo ✅ (CODE-087)
- [x] **I-05** Dashboard business ✅ (CODE-088)
- [ ] **I-06** **Wiring final côté app** : tester checkout en sandbox Stripe puis Live
- [ ] **I-07** **Tests RevenueCat sandbox iOS + Android** avant submission stores
- [ ] **I-08** **Page abonnement utilisateur** : voir son statut, annuler, changer de plan
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

## 🌐 PHASE K — Site internet copiq.fr (0/50 — À DÉMARRER)

> Le site web sera **public-facing**, en Next.js 14 ou Astro. Pas une copie de l'app mobile, plutôt vitrine + SEO + accès gratuit à du contenu d'appel.

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

## 🛡️ PHASE L — Panel admin web (12/66 — voir `admin/docs/PROGRESSION.md`)

Cf. `admin/docs/PROGRESSION.md` qui détaille 66 tâches (ADMIN-001 → ADMIN-066) en 6 sous-phases :

- ✅ **L-A** Bootstrap & shell SPA (12/12) — fait
- 🔴 **L-B** Sécurité & rôles (0/9) — **bloquant pour prod**
- 🔴 **L-C** UX premium (0/12)
- 🔴 **L-D** Features avancées (0/15)
- 🔴 **L-E** Polish (0/10)
- 🔴 **L-F** Ops (0/8)

→ Au minimum faire **ADMIN-013/014/015** (sécurité is_admin côté serveur) avant utilisation en prod.

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

### 🥇 TOP 10 immédiat (à faire dans l'ordre)

1. **L-B (ADMIN-013/014/015)** — Sécurité admin → bloquant prod du panel
2. **D-07** — Audit RLS toutes les 32 tables → bloquant prod app
3. **J-05 + J-06** — Soumissions App Store + Google Play → débloque la release
4. **I-06 + I-07** — Tests checkout Stripe + RevenueCat sandbox → débloque la monétisation
5. **F-01** — Inventaire visuel des écrans → identifier les écrans qui font tâche
6. **C-31 + C-32** — Compléter Réserve + PA Exam → tracks aujourd'hui vides
7. **K-01 → K-05** — Démarrer le site web (spec + setup)
8. **M-09** — Smoke test sur 10 devices physiques
9. **A-05 + A-06** — Sign in with Apple + Google → obligatoire App Store
10. **B-04** — Refonte bottom bar PA exam → cohérence avec GPX

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

- `docs/cas_pratique/PROGRESSION_CODE.md` → Roadmap module Cas Pratique (✅ 100/100)
- `docs/cas_pratique/07_STATE.json` → État machine-readable cas pratique
- `admin/docs/PROGRESSION.md` → Roadmap panel admin web (12/66)
- `admin/docs/ADMIN_STATE.json` → État machine-readable panel admin
- `docs/cas_pratique/01_MASTER_PLAN.md` → Plan stratégique cas pratique
- `docs/cas_pratique/06_ADMIN_PANEL_SPEC.md` → Spec panel admin

---

*Document maintenu en synchronisation avec l'avancement.*
*Dernière mise à jour : 2026-06-08 — Audit complet du projet.*
