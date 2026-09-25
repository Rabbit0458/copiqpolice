# COP'IQ — Refonte web · PHASE A : audit

> Établi le 2026-09-25 par inspection du dépôt (aucune modification n'a été
> faite pendant cette phase). Chaque affirmation est traçable à un fichier.

---

## 1. Architecture réelle (ne pas la supposer — la voici)

### 1.1 Le site n'est pas une application serveur

`copiq-web/next.config.ts` :

```ts
output: "export"        // export 100 % statique
trailingSlash: true
images: { unoptimized: true }
```

Conséquences **structurantes**, vérifiées sur l'export réel (`copiq-web/out/`) :

| Fait | Preuve |
|---|---|
| Aucune route serveur n'est déployée | `copiq-web/out/api` **n'existe pas** alors que `src/app/api/` contient 4 routes |
| `src/middleware.ts` n'est **jamais exécuté** en production | `output: "export"` ignore le middleware ; le build l'annonce quand même (`ƒ Proxy (Middleware)`) |
| Toute logique serveur doit vivre dans Supabase Edge Functions | 15 fonctions existent déjà dans `supabase/functions/` |

**Code mort confirmé (à ne PAS supprimer, mais à ne PAS utiliser) :**

- `src/app/api/stripe/checkout/route.ts`
- `src/app/api/stripe/portal/route.ts`
- `src/app/api/stripe/webhook/route.ts`
- `src/app/api/user/delete/route.ts`
- `src/features/premium/abonnement-content.tsx` — n'est importé par aucun
  fichier (`grep -rn AbonnementContent src` ne renvoie que sa propre
  déclaration) et appelle `fetch("/api/stripe/checkout")`, c'est-à-dire une
  URL qui renvoie 404 en production.

### 1.2 Chaîne de livraison

```
copiq-web/src  ──npm run build──▶  copiq-web/out  ──publish-static.mjs──▶  fae16dc1/
```

`copiq-web/scripts/publish-static.mjs` :

1. vérifie 10 routes critiques dans `out/` (dont `admin/`, `login/`, `auth/callback/`) ;
2. copie `deploy/.htaccess` ;
3. régénère `copiq-config.js` en reprenant `kSupabaseUrl` / `kSupabaseAnonKey`
   **depuis `lib/main.dart`** (l'app Flutter est la source de vérité de la config publique) ;
4. écrit `deployment-manifest.json` ;
5. `rename` l'ancien `fae16dc1/` en `fae16dc1-backup-<ISO>/` puis met le neuf en place.

> **Conséquence majeure pour la consigne §3 du cahier des charges.**
> `fae16dc1/` est un dossier **généré**. Tout fichier écrit à la main dedans est
> détruit à la publication suivante. La refonte doit donc être écrite dans
> `copiq-web/src/`, et `fae16dc1/` est produit par le script. Les documents de
> livraison (`DEPLOYMENT.md`, `CHANGELOG.md`, `SECURITY.md`, `README.md`) sont
> pour cette raison stockés dans `copiq-web/deploy/docs/` et recopiés par le
> script à chaque publication — ils se retrouvent bien dans `fae16dc1/`, sans
> risque d'être perdus.

### 1.3 Build de référence (avant toute modification)

`cd copiq-web && npm run build` → **succès**, 0 erreur.
Routes générées : 48 pages statiques + 4 groupes SSG
(`gpx/cours/[moduleId]`, `gpx/quiz/[moduleId]`, `pa/cours/[moduleId]`,
`pa/quiz/[moduleId]`, `psychotechniques/[type]`).

---

## 2. Routes publiques existantes (à préserver — §42)

| URL | Source |
|---|---|
| `/` | `src/app/page.tsx` → `features/landing/landing-page.tsx` |
| `/tarifs` | `src/app/(public)/tarifs/page.tsx` |
| `/blog`, `/blog/[slug]` | `(public)/blog/` + `src/data/blog.ts` |
| `/faq` | `(public)/faq/page.tsx` |
| `/contact` | `(public)/contact/page.tsx` |
| `/informations` | `(public)/informations/page.tsx` |
| `/notes-de-mise-a-jour` | `(public)/notes-de-mise-a-jour/page.tsx` |
| `/beta` | `(public)/beta/page.tsx` |
| `/cgu`, `/privacy`, `/mentions-legales` | `(public)/` |
| `/login`, `/signup`, `/forgot-password`, `/confirm` | `(auth)/` |
| `/auth/callback` | `src/app/auth/callback/page.tsx` |
| `/robots.txt`, `/sitemap.xml`, `/opengraph-image` | `src/app/robots.ts`, `sitemap.ts` |
| `/404` | export Next (`404.html`) |

## 3. Application web authentifiée existante (déjà opérationnelle)

`src/app/(dashboard)/` — 22 routes, protégées par `layout.tsx` :
`getUser()` → redirection `/login`, puis lecture `cas_pratique_subscriptions.tier`,
puis `PathwayProvider` → redirection `/choisir-parcours` si aucun parcours choisi.

`dashboard`, `choisir-parcours`, `progression`, `historique`, `favoris`,
`notes`, `memos`, `notifications`, `profil`, `parametres`, `abonnement`,
`forum` (+`/nouveau`, `/post`), `concours-blanc`, `culture-generale`,
`langues`, `psychotechniques` (+`[type]`), `gpx/{cours,quiz,scolarite,cas-pratiques}`,
`pa/{cours,quiz,scolarite}`.

> **Le site est déjà une application web.** L'objectif 2 du cahier des charges
> n'est donc pas un chantier à zéro : c'est une extension + une refonte d'UX.

## 4. Backend Supabase

### 4.1 Tables lues par le web

`cas_pratique_subscriptions` (15×), `cas_pratique_attempts`, `cas_pratique_xp_ledger`,
`free_weekly_usage`, `user_profiles`, `profiles`, `user_notes`, `user_memos`,
`user_favorites`, `quiz_attempts`, `notifications`, `information_contents`,
`forum_categories`, `forum_posts`, `forum_replies`.

### 4.2 RPC utilisées

`get_my_entitlement`, `list_public_patch_notes`, `submit_support_request`.

### 4.3 Edge Functions (15)

`cas_pratique_create_checkout`, `cas_pratique_customer_portal`,
`cas_pratique_stripe_webhook`, `cas_pratique_correct_attempt`,
`cas_pratique_redeem_promo`, `cas_pratique_export_user_data`,
`cas_pratique_delete_user_data`, `cas_pratique_business_notify`,
`cas_pratique_health`, `admin_contact_email`, `admin_delete_user_account`,
`admin_report_resolved_email`, `app_minimum_version`,
`sync_official_police_calendar`, `_shared/rate_limit.ts`.

### 4.4 Configuration publique côté navigateur

`src/lib/supabase/client.ts` lit `window.COPIQ_CONFIG` (injecté par
`/copiq-config.js`, chargé `beforeInteractive` dans `src/app/layout.tsx`),
avec repli sur `NEXT_PUBLIC_*`. **Aucune `service_role` n'est exposée** :
le script de publication ne copie que l'URL et la clé anon.

---

## 5. Paiement — état réel

### 5.1 Le chemin qui fonctionne

`src/app/(dashboard)/abonnement/page.tsx` appelle
`supabase.functions.invoke("cas_pratique_create_checkout")` puis
`...("cas_pratique_customer_portal")`. C'est le **bon** chemin, compatible
export statique.

Ce qui est déjà correct dans `supabase/functions/cas_pratique_create_checkout/index.ts` :

- JWT obligatoire (`Authorization: Bearer`), vérifié par `auth.getUser(jwt)` ;
- `plan` validé contre une liste blanche `["week","month","year"]` ;
- **aucune confiance au prix envoyé par le client** — le Price ID vient de
  `Deno.env` puis est revérifié auprès de Stripe (`active`, `recurring`, bon `interval`) ;
- URLs de retour passées dans une **allowlist d'hôtes et de chemins**
  (`sanitizeReturnUrl`) → pas de redirection ouverte (§31) ;
- `customer` retrouvé/creé côté serveur, `supabase_user_id` en metadata ;
- côté client, le bouton est verrouillé pendant l'appel (`busy`) → protection double-clic (§21).

### 5.2 Tarifs — source de vérité

| Canal | Semaine | Mois | An | Preuve |
|---|---|---|---|---|
| **Stripe / web** | 4,99 € | 8,99 € | 86,99 € | `abonnement/page.tsx` + repli `unit_amount === 8699` dans `create_checkout` |
| Pages légales | 4,99 € | 8,99 € | 86,99 € | `lib/legal/legal_content.dart:466` |
| App Store / Play | prix de la boutique | prix de la boutique | prix de la boutique | `lib/core/services/revenuecat_service.dart` — le prix affiché vient toujours de l'offering RevenueCat |

Essai : 7 jours, sur `month` et `year` uniquement
(`create_checkout` → `trial_period_days: body.trial_period_days ?? 7`).

**Incohérences trouvées — signalées, pas corrigées (§59) :**

1. `lib/core/services/subscription_plan.dart:36` affiche `79,99 € / an` en
   libellé de repli, alors que Stripe et les pages légales disent 86,99 €.
   Impact limité (le vrai prix vient de la boutique) mais le repli est visible
   pendant le chargement. **Décision du propriétaire requise.**
2. `lib/content/paywall/cp_pricing_plans.dart` propose 9,99 €/mois, 79 €/an et
   un plan « à vie » 149 € qui n'existe nulle part ailleurs. Ce widget n'est
   importé par aucun autre fichier. **Ne pas s'en servir comme référence.**
3. `/tarifs` n'affiche pas le plan `week` (4,99 €) qui est pourtant vendable.

---

## 6. Sécurité — constats

### Conforme

- `deploy/.htaccess` : HSTS, `X-Frame-Options`, `nosniff`, `Referrer-Policy`,
  `Permissions-Policy`, **CSP complète** (`object-src 'none'`, `base-uri 'self'`,
  `frame-ancestors 'self'`, `form-action` limité à Stripe Checkout),
  redirection HTTPS forcée, `Options -Indexes`.
- Aucun secret dans l'export : `copiq-config.js` ne contient qu'URL + clé anon.
- Admin : trois barrières (mot de passe, TOTP, code staff) imposées en PostgreSQL —
  hors périmètre, non touché.
- Helper de rate limiting déjà écrit (`supabase/functions/_shared/rate_limit.ts`,
  token bucket sur `fn_cp_consume_token`) avec un catalogue de profils.

### À corriger / à surveiller

| # | Constat | Gravité |
|---|---|---|
| S1 | `cas_pratique_create_checkout` **n'applique pas** `consumeRateLimit`, alors que le helper existe. Un JWT valide peut donc créer des sessions Checkout en boucle. | moyenne |
| S2 | Pas de clé d'idempotence Stripe sur la création de session. La protection est uniquement le verrou de bouton côté client. | moyenne |
| S3 | La CSP autorise `script-src 'unsafe-inline'`. Nécessaire pour l'hydratation Next actuelle, mais à documenter comme dette. | faible |
| S4 | `src/middleware.ts` existe et donne l'illusion d'une protection de routes qui n'est jamais exécutée. | faible (documentaire) |
| S5 | Aucun outil d'observabilité côté web (§34) : aucune erreur front n'est remontée. | moyenne |

Ces points sont repris dans `copiq-web/deploy/docs/SECURITY.md`.

---

## 7. Écarts au cahier des charges sur la vitrine actuelle

`src/features/landing/landing-page.tsx` (501 lignes) et
`src/app/(public)/layout.tsx` contreviennent directement au §8 et au §61 :

| Écart | Emplacement | Règle |
|---|---|---|
| Logo **recréé en CSS** (carré dégradé + lettre « C ») | `(public)/layout.tsx` | §61 — interdit |
| Logo pointé sur `logo_appstore.png`, pas sur le logo officiel fourni | `landing-page.tsx:18` | §61 |
| Dégradé **violet** SaaS sur la carte tarifaire mise en avant | `landing-page.tsx` `PLANS[1].style` | §8 |
| Emojis dans les titres et badges (`🎓 🚀 👑 ⭐`, `🚔` en pied de page) | `landing-page.tsx`, `(public)/layout.tsx` | §8 |
| Six flip-cards identiques + « Cliquer pour en savoir plus » | `FlipCard` | §8 |
| « ⭐ BEST SELLER », « 👑 MEILLEURE VALEUR » | `landing-page.tsx` | §8 |
| « 5 000+ questions classées » — chiffre non sourcé, et contredit par « Quiz de base (50 questions) » deux blocs plus bas | `landing-page.tsx` | §53 |
| Aucune mention d'indépendance vis-à-vis de la Police nationale | vitrine entière | **§45** |
| Liens publics vers `/pa/scolarite` et `/gpx/scolarite`, qui sont des routes authentifiées → l'internaute non connecté est renvoyé vers `/login` | pied de page `(public)/layout.tsx` | UX |
| Aucune page SEO dédiée (concours GPX, PA, psychotechniques, réserve…) | — | §40 |
| `/faq`, `/informations`, `/notes-de-mise-a-jour` absents du `sitemap.ts` | `src/app/sitemap.ts` | §42 |

---

## 8. Application Flutter — source de vérité produit (§4)

- Version : `1.1.0+7` (`pubspec.yaml`)
- Typographie embarquée : **InstrumentSans** (400→700 + italiques) — déjà la
  police du site (`Instrument_Sans` via `next/font/google`). Cohérence acquise.
- Abonnements boutiques : **RevenueCat** (`purchases_flutter: 10.13.1`),
  entitlement `premium`, packages `$rc_monthly` / `$rc_annual`,
  produits `copiq_premium_monthly` / `copiq_premium_yearly` (Android) et
  `fr.copiq.premium.monthly` / `.yearly` (iOS).
- Monétisation gratuit : `google_mobile_ads` (interstitiel fin de quiz + rewarded).
- 769 déclarations de routes nommées (`lib/routes/app_router.dart`).

### Nomenclature réelle des parcours et modules

| Parcours | Dossier | Modules |
|---|---|---|
| **GPX — École** | `lib/content/gpx_scolarite/` (760 fichiers) | `institutions_valeurs`, `dps_dpg`, `policier_intervention_initial`, `policier_intervention_avance`, `memento_circulation`, `pv_apj20` |
| **GPX — Concours** | `lib/content/gpx_exam/` (39) | `cas_pratique`, `culture_generale`, `langue_etrangere`, `structure_gpx_concours` |
| **PA — École** | `lib/content/pa_scolarite/` (650) | `procedure_penale_pages`, `cadres_juridiques_pages`, `atteintes_personnes_pages`, `atteintes_biens_pages`, `atteintes_nation_pages`, `armes_munitions_pages`, `circulation_pages`, `mineurs_famille_pages`, `stupefiants_pages`, `libertes_publiques_pages`, `organisation_judiciaire_pages`, `organisation_pn`, `institution_valeurs_pages`, `sanction_pages`, `dpg_pages`, `dps_dpg`, `formation_initiale`, `policier_intervention_pages` |
| **PA — Concours** | `lib/content/pa_exam/` (35) | `culture_generale`, `photolangage`, `psycotechniques` |
| **Réserve** | `lib/content/reserve_scolarite/` (1) | `introduction` seulement — **module embryonnaire, ne pas le survendre** |

### Volumétrie vérifiable (§53 — pour n'afficher que des faits)

Méthode reproductible :

```bash
grep -rho --include="*.dart" -F "QuizQuestion("  lib | wc -l   # 53 838
grep -rho --include="*.dart" -F "PaQuizQuestion(" lib | wc -l   # 13 509
```

Soit **67 347 occurrences de constructeurs de questions**, dont il faut
retirer ~1 déclaration de constructeur par fichier de quiz (≈1 500).
→ Affirmation retenue sur le site : **« plus de 60 000 questions »**.
C'est un plancher, il est vérifiable, il ne sera pas dépassé par la réalité.

Affirmations retenues, toutes vérifiables :

- 4 parcours : GPX concours, GPX école, Policier adjoint concours, Policier adjoint école ;
- plus de 60 000 questions ;
- plus de 1 400 fichiers de cours et de quiz (`760 + 650 + 39 + 35 = 1 484`) ;
- compte unique synchronisé mobile ↔ web (même projet Supabase, cf. §1.1 du script de publication) ;
- correction automatisée des cas pratiques (`supabase/functions/cas_pratique_correct_attempt`, moteur `lib/core/cas_pratique/engine/`).

Affirmations **interdites** faute de source : nombre d'utilisateurs, nombre de
téléchargements, taux de réussite, classement, témoignages nominatifs.
**Aucun témoignage n'a été trouvé dans le dépôt** → la section Témoignages est
préparée mais laissée vide, pilotée par un tableau dont le contenu doit être
fourni par le propriétaire (§44).

---

## 9. Assets officiels — analyse avant usage (§63)

Téléchargés et inspectés un par un.

| Fichier | Dim. | Poids | Sujet | Verdict d'emploi |
|---|---|---|---|---|
| `logo-png-copiq.png` | 1254×1254 | 586 ko | Tête de profil bleu nuit, cerveau bleu/rouge, virgule tricolore. **Fond noir opaque, pas de transparence.** | Logo officiel. **À poser sur fond sombre uniquement** (sinon carré noir visible sur surface claire). Jamais recréé, jamais déformé. Un `<img>` avec `width`/`height` et ratio 1:1. |
| `pv_intro.jpg` | 1280×853 | 92 ko | Policier de dos, brassard POLICE, véhicule sérigraphié gyrophares allumés. Netteté et cadrage forts. | **Meilleure photo du lot.** Bande éditoriale immersive pleine largeur (cas pratiques / terrain). |
| `pv_circulation_routiere.jpeg` | 1500×1100 | 363 ko | Moto police sous la pluie, gyrophares bleus, foule floue. Très cinématographique. **Bandes gris mort à droite et en bas** → recadrage obligatoire. | Bande immersive « conditions réelles » (concours blanc), desktop, `object-position` calé pour couper les bandes. |
| `gpx.jpg` | 1000×625 | 45 ko | Écusson Police nationale / Sécurité publique, faible profondeur de champ, sujet à gauche, bokeh à droite. | Section éditoriale **GPX** : texte posé sur la partie floue à droite. |
| `police.webp` | 657×431 | 21 ko | Brassards POLICE de dos, cadrage serré. **Basse résolution** — ne pas agrandir. | Carte de section **Policier adjoint**, taille ≤ 660 px de large. |
| `cas4.jpg` | 2048×1448 | 404 ko | Contrôle routier, motocyclistes. **Porte le filigrane officiel « POLICE NATIONALE »** et provient de `photolangage_pa/`. | **Contenu pédagogique** (§72). Employé uniquement pour illustrer l'épreuve de **photolangage**, avec une légende qui le dit. Jamais en visuel institutionnel ni en décor. |
| `cas2.jpg` | 885×500 | 116 ko | Photolangage PA | Idem — galerie de l'exercice photolangage, chargement paresseux. |
| `cas7.jpg` | 739×415 | 39 ko | Photolangage PA | Idem. |
| `cas8.jpg` | 1254×836 | 122 ko | Photolangage PA | Idem. |

**Décision §71 :** aucune copie locale. Les fichiers restent servis par le
bucket public Supabase `assets`, déjà autorisé par la CSP (`img-src https:`)
et déjà déclaré dans `next.config.ts` (`remotePatterns: **.supabase.co`).
Les originaux ne sont jamais modifiés ; tout le traitement (overlay bleu nuit,
vignettage, désaturation légère, masque, recadrage responsive) est fait en CSS.

**Couleurs relevées dans le logo** (pour aligner la DA, sans jamais retoucher
le fichier) : bleu électrique ≈ `#1B5CE0`, rouge vif ≈ `#E0162B`, bleu nuit du
visage ≈ `#0C1E4A`, fond `#000000`.

**Capture d'interface :** aucune capture d'écran de l'application n'existe dans
`assets/` (les 571 images sont des illustrations de contenu pédagogique).
Plutôt que de fabriquer de faux écrans, les compositions produit de la vitrine
sont construites **en DOM réel avec les composants et les tokens de
l'application web COP'IQ** — ce sont donc de vraies interfaces COP'IQ, pas des
mockups inventés.

---

## 10. Risques identifiés

| # | Risque | Mitigation appliquée |
|---|---|---|
| R1 | Écrire dans `fae16dc1/` à la main → perte à la publication suivante | Travail dans `copiq-web/src`, docs dans `copiq-web/deploy/docs/` recopiés par le script |
| R2 | Casser `/admin` | `src/app/admin/`, `src/components/admin/`, `src/lib/admin/` déclarés **zone interdite**, aucun fichier n'y est touché |
| R3 | Casser une URL indexée | Aucune route existante supprimée ni renommée ; uniquement des ajouts |
| R4 | Casser le paiement | Le chemin Edge Function n'est pas modifié ; les routes `/api` mortes sont laissées en place sans être appelées |
| R5 | Régression du build | `npm run build` exécuté avant et après chaque lot de modifications |
| R6 | Perte de la version actuelle de la vitrine | `landing-page.tsx` est **conservé intact** ; la nouvelle vitrine est un fichier distinct, le basculement tient en une ligne d'import dans `src/app/page.tsx` |
| R7 | Régression Supabase | Aucune migration, aucune table, aucune RLS modifiée |
