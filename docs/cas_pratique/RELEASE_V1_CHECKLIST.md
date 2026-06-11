# 🚀 COP'IQ — Release v1.0 — Checklist Finale

> Référence : `docs/cas_pratique/PROGRESSION_CODE.md — CODE-100`
> **Règle** : Quand 100 % des items sont cochés → **LAUNCH**.

---

## 📊 Avancement

| Domaine | Coché | Total |
|---------|-------|-------|
| Stores & Distribution | 0 | 10 |
| Backend & Infra | 0 | 8 |
| Sécurité | 0 | 6 |
| Qualité & Tests | 0 | 8 |
| Accessibilité & Compliance | 0 | 5 |
| Content & ASO | 0 | 7 |
| Monitoring & Ops | 0 | 6 |
| **TOTAL** | **0** | **50** |

---

## 🏪 Stores & Distribution (10 items)

- [ ] **S-01** — Compte Google Play Console actif + app créée (fr.copiq.app)
- [ ] **S-02** — Compte App Store Connect actif + app créée + bundle ID `fr.copiq.app`
- [ ] **S-03** — Keystore Android sécurisé (JKS) + stocké dans 1Password + backup
- [ ] **S-04** — Certificats iOS (Distribution + Push) valides dans Apple Developer Portal
- [ ] **S-05** — Fastlane Match initialisé (`fastlane match appstore`) — certs synchro Git privé
- [ ] **S-06** — Screenshots Android (Phone 6.7") : 8 captures haute qualité dans 3 langues
- [ ] **S-07** — Screenshots iOS (iPhone 6.7") : 8 captures haute qualité dans 3 langues
- [ ] **S-08** — Icône app 1024×1024 sans transparence (iOS) + 512×512 (Android) livrée
- [ ] **S-09** — Feature graphic Google Play (1024×500 px) créé
- [ ] **S-10** — App Review notes rédigées (Login test credentials + notes reviewer)

---

## 🛠️ Backend & Infra (8 items)

- [ ] **B-01** — Toutes les migrations Supabase appliquées en production (`supabase db push`)
- [ ] **B-02** — Toutes les Edge Functions déployées (`supabase functions deploy --all`)
- [ ] **B-03** — Variables d'environnement Edge Functions configurées (STRIPE_SECRET, SLACK_WEBHOOK, etc.)
- [ ] **B-04** — Force update edge function `app_minimum_version` déployée et testée
- [ ] **B-05** — Page de statut `status.copiq.fr` live (Uptime Kuma ou équivalent)
- [ ] **B-06** — 10 endpoints Uptime Kuma actifs + webhooks Slack `#alerts-prod` configurés
- [ ] **B-07** — Backup Supabase activé (plan Pro ou via `pg_dump` planifié)
- [ ] **B-08** — Domain `app.copiq.fr` configuré + SSL Let's Encrypt valide

---

## 🔒 Sécurité (6 items)

- [ ] **SEC-01** — Audit OWASP Mobile Top 10 complété (cf. `docs/cas_pratique/SECURITY_AUDIT.md`)
- [ ] **SEC-02** — `security.txt` publié sur `https://copiq.fr/.well-known/security.txt`
- [ ] **SEC-03** — Toutes les RLS policies vérifiées en prod (test avec compte non-admin)
- [ ] **SEC-04** — Sentry DSN configuré + alertes P0/P1 actives (cf. `SENTRY_SETUP.md`)
- [ ] **SEC-05** — Rate limiting edge functions actif + testé avec `k6` ou Postman
- [ ] **SEC-06** — Stripe webhook secret configuré (`STRIPE_WEBHOOK_SECRET` en prod)

---

## 🧪 Qualité & Tests (8 items)

- [ ] **Q-01** — `flutter analyze` → 0 erreur, 0 warning critique
- [ ] **Q-02** — `flutter test` → 100 % passent (60+ tests unitaires engine)
- [ ] **Q-03** — Tests de parité Dart↔TS passent (`dart_vs_ts.test.ts`)
- [ ] **Q-04** — Maestro E2E flows 01–09 passent sur device physique Android
- [ ] **Q-05** — Maestro E2E flows 01–09 passent sur simulateur iOS
- [ ] **Q-06** — APK release < 25 MB (vérifier avec `audit_bundle_size.py`)
- [ ] **Q-07** — IPA release < 50 MB
- [ ] **Q-08** — 60 fps constants sur Pixel 6 (mode Profile) + 60 fps sur iPhone 14

---

## ♿ Accessibilité & Compliance (5 items)

- [ ] **A-01** — Audit WCAG 2.1 AA P0 tous résolus (cf. `docs/cas_pratique/A11Y_AUDIT.md`)
- [ ] **A-02** — VoiceOver iOS testé sur les 10 flows critiques
- [ ] **A-03** — TalkBack Android testé sur les 10 flows critiques
- [ ] **A-04** — `flutter gen-l10n` exécuté + FR/EN strings compilées sans erreur
- [ ] **A-05** — RGPD : Politique de confidentialité publiée + lien dans les deux stores

---

## 📝 Content & ASO (7 items)

- [ ] **C-01** — Titre store FR : "COP'IQ — Concours Gardien de la Paix" (≤ 30 chars Google, ≤ 30 Apple)
- [ ] **C-02** — Sous-titre Apple (≤ 30 chars) : "Annales + Correction IA"
- [ ] **C-03** — Description courte Google (≤ 80 chars) : "Prépare le concours GPX avec des annales corrigées par IA"
- [ ] **C-04** — Description longue FR rédigée (4000 chars max) — avec mots-clés ASO ciblés
- [ ] **C-05** — Email support `support@copiq.fr` actif + répondant sous 48h
- [ ] **C-06** — CGV + Conditions d'utilisation publiées sur `https://copiq.fr/cgu`
- [ ] **C-07** — Mentions légales publiées (nom éditeur, hébergeur Supabase, DPD contact)

---

## 📊 Monitoring & Ops (6 items)

- [ ] **M-01** — Runbook incident écrit (`docs/cas_pratique/RUNBOOK_INCIDENT.md`) — template post-mortem inclus
- [ ] **M-02** — Alerte Slack P0 testée (simuler crash Sentry → notification dans #alerts-prod)
- [ ] **M-03** — pg_cron configuré pour `cas_pratique_business_notify` (toutes les 5 min)
- [ ] **M-04** — Materialized view leaderboard refresh planifiée (`CONCURRENTLY` horaire via pg_cron)
- [ ] **M-05** — Beta testeurs (≥ 5) ont testé l'app + feedbacks critiques résolus
- [ ] **M-06** — Première release créée sur GitHub (tag `v1.0.0`) + release notes rédigées

---

## 🗓️ Procédure de release

```bash
# 1. Mettre à jour la version dans pubspec.yaml
#    version: 1.0.0+1

# 2. Bumper min_version dans Supabase (si besoin de force update)
#    UPDATE cp_app_version_config SET min_version = '1.0.0' WHERE platform IN ('android','ios');

# 3. Lancer le pipeline release
git tag v1.0.0
git push origin v1.0.0
# → déclenche flutter-release.yml automatiquement

# 4. Vérifier les artifacts GitHub Actions
#    - copiq-android-release/ (AAB + APK)
#    - copiq-ios-release/ (IPA)
#    - Sentry source maps uploadées

# 5. Promouvoir depuis Play Console (Internal → Production)
#    et depuis App Store Connect (TestFlight → App Store)

# 6. Mettre à jour la status page + poster dans Slack #general
```

---

## 📌 Décisions post-launch à documenter

| Item | Décision | Date |
|------|----------|------|
| Plan de montée en charge (DBU Supabase) | À définir après J+7 | — |
| Fréquence des concours blancs | 1 par semaine initialement | — |
| Prix lifetime (149€ ↔ révision possible) | À revoir après 500 achats | — |
| Feature flag `cp_edge_correction` rollout | 0% → 10% → 100% sur 2 semaines | — |

---

*Dernière mise à jour : 2026-06-06 — CODE-100 créé*
