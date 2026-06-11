# 🔐 COP'IQ — Cas Pratique — Audit sécurité (CODE-055)

> Date de l'audit initial : **2026-05-17**
> Périmètre : module Cas Pratique (Phases A → J)
> Standard : **OWASP Mobile Top 10 (2024)** + RGPD + checklist interne

**Légende statut :**
- ✅ **OK** — implémenté et testé
- 🟡 **PARTIAL** — partiellement implémenté, à compléter avant la release v1.0
- 🔴 **TODO** — non implémenté, prioritaire
- ⚪ **N/A** — non applicable au périmètre

---

## 1. OWASP Mobile Top 10

### M1 — Improper Credential Usage

| Item                                                | Statut | Détail                                                                                                |
|-----------------------------------------------------|--------|-------------------------------------------------------------------------------------------------------|
| Pas de mot de passe / secret hard-codé              | ✅     | DSN Sentry via `--dart-define` (CODE-053), service role key Supabase uniquement côté edge fn         |
| Tokens stockés en `flutter_secure_storage`           | 🟡     | Auth Supabase utilise déjà son storage chiffré ; vérifier qu'aucun token JWT n'est mis dans shared_preferences |
| Rotation des secrets documentée                      | 🔴     | TODO : ajouter procédure dans `docs/SECRETS_ROTATION.md` (DSN, service role, Stripe webhook secret)  |

### M2 — Inadequate Supply Chain Security

| Item                                                | Statut | Détail                                                                                                |
|-----------------------------------------------------|--------|-------------------------------------------------------------------------------------------------------|
| `pubspec.lock` commité                              | ✅     | Pinning des versions transitives                                                                       |
| Audit dépendances automatique                        | 🟡     | À ajouter : `dart pub outdated --mode=null-safety` + `flutter pub audit` dans la CI (CODE-097)        |
| Pas de dépendances non-officielles                   | ✅     | Toutes les deps proviennent de pub.dev ou de packages Supabase officiels                              |

### M3 — Insecure Authentication / Authorization

| Item                                                | Statut | Détail                                                                                                |
|-----------------------------------------------------|--------|-------------------------------------------------------------------------------------------------------|
| Auth via Supabase Auth (JWT)                         | ✅     | OAuth + email/password gérés par Supabase, JWT signé avec secret côté serveur                          |
| RLS activée sur toutes les tables sensibles         | ✅     | CODE-008 : 15 tables couvertes (themes, cases, questions, attempts, answers, corrections, details, appeals, user_progress, audit, etc.) |
| Filtre `user_id` côté client en plus de RLS         | ✅     | Defense in depth dans `watchMyAppeals`, `createAppeal`, `listMyAppeals` (CODE-042/044)                 |
| Vérification ownership avant écriture critique       | ✅     | Edge fn correction (CODE-051) check `attempt.user_id === auth.uid()` avant tout traitement            |
| Sessions auto-refresh + recover from storage        | ✅     | `recoverSessionFromStorage` + retry pattern dans `_ensureSessionHydrated` (main.dart)                  |
| Pas d'autorisation admin via client                  | ✅     | Fonction `fn_cp_is_admin` côté DB lit user_metadata.role, jamais exposée au client                    |

### M4 — Insufficient Input/Output Validation

| Item                                                | Statut | Détail                                                                                                |
|-----------------------------------------------------|--------|-------------------------------------------------------------------------------------------------------|
| Contraintes CHECK SQL                                | ✅     | CODE-002/003/004 : difficulty IN ('facile','moyen','difficile'), status IN ('draft','published','archived'), kind, etc. |
| Validation client : char_min / char_max sur réponses | ✅     | `AnswerTextArea` compteur, validation pré-validation, refus si trim().isEmpty                          |
| Validation edge fn : body JSON + types stricts       | ✅     | CODE-051 : checks `attempt_id`, `case_id`, mismatch, `attempt_already_finished`                       |
| Sanitization HTML / XSS (situation_md, perfect)      | 🟡     | Markdown rendu en clair (pas de HTML user-controlled aujourd'hui). À durcir si on accepte du contenu user-généré (post-MVP) |

### M5 — Insecure Communication

| Item                                                | Statut | Détail                                                                                                |
|-----------------------------------------------------|--------|-------------------------------------------------------------------------------------------------------|
| HTTPS only                                          | ✅     | Supabase impose HTTPS par défaut, certificate validé par l'OS                                          |
| Certificate pinning                                  | 🔴     | TODO post-MVP : ajouter via `http_certificate_pinning` ou implémentation native. À évaluer vs maintenance |
| ATS (App Transport Security) iOS strict             | ✅     | Pas de `NSAllowsArbitraryLoads = YES` dans Info.plist                                                  |
| Pas d'API auth en GET (CSRF safe)                    | ✅     | Tous les writes Supabase passent en POST/PUT avec JWT bearer                                          |

### M6 — Inadequate Privacy Controls (RGPD)

| Item                                                | Statut | Détail                                                                                                |
|-----------------------------------------------------|--------|-------------------------------------------------------------------------------------------------------|
| Sentry `sendDefaultPii = false`                      | ✅     | CODE-053 : pas d'IP / UA / cookies envoyés                                                             |
| Export des données user (RGPD art. 20)              | 🔴     | TODO : CODE-079 prévu                                                                                  |
| Suppression du compte (RGPD art. 17)                 | 🔴     | TODO : CODE-079 prévu (cascade RLS-safe)                                                                |
| Cookies / consent (web futur)                       | ⚪     | N/A côté app mobile ; CODE-080 prévu pour le web                                                       |
| Logs analytics sans PII (réponses utilisateur)       | ✅     | Aucune réponse en clair envoyée aux outils tiers ; tagging Sentry = uuid uniquement                    |
| Encryption at rest (Postgres + storage)             | ✅     | Supabase chiffre les données au repos par défaut                                                       |

### M7 — Insufficient Binary Protections

| Item                                                | Statut | Détail                                                                                                |
|-----------------------------------------------------|--------|-------------------------------------------------------------------------------------------------------|
| Obfuscation Android (R8) en release                  | 🟡     | À activer dans `android/app/build.gradle` (`minifyEnabled true` + proguard rules — partiel CODE-053)  |
| `--obfuscate --split-debug-info=…` Flutter           | 🔴     | À brancher dans la pipeline CI release (CODE-097)                                                       |
| Root / jailbreak detection                          | 🔴     | TODO post-MVP : `flutter_jailbreak_detection` ; refuser actions sensibles (paiement)                  |
| Anti-tampering signature                             | 🟡     | Play Integrity API à évaluer (Android) ; iOS = App Attest natif                                       |

### M8 — Security Misconfiguration

| Item                                                | Statut | Détail                                                                                                |
|-----------------------------------------------------|--------|-------------------------------------------------------------------------------------------------------|
| RLS jamais désactivée                                | ✅     | `ALTER TABLE … ENABLE ROW LEVEL SECURITY` sur toutes les tables sensibles                              |
| Pas de `service_role` côté client                    | ✅     | Service role uniquement dans les edge fns, lue depuis `Deno.env`                                       |
| Tables admin protégées par `fn_cp_is_admin`          | ✅     | CODE-008 + rubric/keywords admin-only                                                                  |
| Mode debug désactivé en release                      | ✅     | `kDebugMode` gate tous les `debugPrint`                                                                |
| Backups automatiques DB                              | ✅     | Supabase backups daily + PITR                                                                          |

### M9 — Insecure Data Storage

| Item                                                | Statut | Détail                                                                                                |
|-----------------------------------------------------|--------|-------------------------------------------------------------------------------------------------------|
| Tokens auth dans secure storage                      | 🟡     | Supabase Flutter SDK utilise déjà `flutter_secure_storage` quand dispo ; vérifier configuration       |
| Cache cas_pratique = données non-sensibles uniquement | ✅     | CODE-017 : `shared_preferences` ne contient que themes/cases/drafts (pas de réponses validées ni rubric) |
| Drafts (autosave) = local uniquement, encryptés ?    | 🟡     | Aujourd'hui en clair dans `shared_preferences`. À évaluer : risque faible (texte de réponse perso, pas de donnée perso tierce) |
| Pas de PII dans les logs                            | ✅     | Tous les `debugPrint`/`AppConsoleLogger` n'envoient que user_id (uuid)                                  |

### M10 — Insufficient Cryptography

| Item                                                | Statut | Détail                                                                                                |
|-----------------------------------------------------|--------|-------------------------------------------------------------------------------------------------------|
| TLS 1.2+ partout                                     | ✅     | Imposé par Supabase + ATS iOS                                                                          |
| JWT signature côté serveur                          | ✅     | Supabase Auth                                                                                          |
| Pas de crypto maison                                 | ✅     | Aucun chiffrement custom — uniquement primitives standard via SDK                                       |
| Hashing mots de passe                                | ✅     | bcrypt côté Supabase                                                                                   |

---

## 2. Checklist COP'IQ spécifique

| #  | Item                                                                         | Statut |
|----|------------------------------------------------------------------------------|--------|
|  1 | **Rubric admin-only** — la rubric ne fuit JAMAIS au client (CODE-008 + 051)  | ✅     |
|  2 | **Edge function correction** verrouille la rubric (CODE-051)                  | ✅     |
|  3 | **Parité Dart↔TS** garantie par tests automatiques (CODE-052)                | ✅     |
|  4 | **Rate limiting** sur endpoints critiques (CODE-054)                          | ✅     |
|  5 | **Sentry** + alerting Slack/email pour les crashs prod (CODE-053)             | ✅     |
|  6 | **Realtime appeals** filtrés côté client + RLS (CODE-044 defense in depth)    | ✅     |
|  7 | **Migrations SQL idempotentes** (toutes en `IF NOT EXISTS` / `ON CONFLICT`)   | ✅     |
|  8 | **Ownership check** sur attempt avant scoring (CODE-051)                       | ✅     |
|  9 | **Pas de `service_role`** dans le bundle client                               | ✅     |
| 10 | **`.well-known/security.txt`** publié sur le domaine                          | 🔴     |
| 11 | **HSTS preload** sur le domaine principal                                     | 🔴     |
| 12 | **Deep links validés** (App Links Android / Universal Links iOS)              | 🔴     |
| 13 | **Penetration testing externe** avant release v1.0                            | 🔴     |
| 14 | **Bug bounty program** ouvert (HackerOne / YesWeHack)                          | 🔴     |
| 15 | **Audit logs** pour les actions admin (CODE-008 a la table prête)              | 🟡     |

---

## 3. `.well-known/security.txt` à publier

Modèle à déposer sur `https://api.copiqpolice.fr/.well-known/security.txt` :

```
Contact: mailto:security@copiqpolice.fr
Expires: 2027-05-17T00:00:00Z
Encryption: https://copiqpolice.fr/pgp-key.txt
Acknowledgments: https://copiqpolice.fr/hall-of-fame
Preferred-Languages: fr, en
Canonical: https://api.copiqpolice.fr/.well-known/security.txt
Policy: https://copiqpolice.fr/security-policy
Hiring: https://copiqpolice.fr/jobs
```

Signer le fichier avec une clé PGP (recommandé par RFC 9116).

---

## 4. Recommandations prioritaires avant la release v1.0

### P0 — Bloquant

1. **CODE-079** RGPD : export + suppression de compte
2. **CODE-097** CI release avec `--obfuscate --split-debug-info=…`
3. **Penetration testing externe** (1 semaine, équipe spécialisée)

### P1 — Important

4. **Certificate pinning** sur le client Flutter (M5)
5. **Root / jailbreak detection** sur les flux paiement (M7)
6. **`.well-known/security.txt`** publié
7. **Rotation des secrets** documentée (M1)

### P2 — Nice to have

8. **Bug bounty** ouvert post-launch
9. **Audit logs admin** branchés (CODE-008 a la table prête)
10. **Play Integrity / App Attest** pour anti-tampering

---

## 5. Procédure d'audit récurrente

À répéter tous les 6 mois (ou à chaque release majeure) :

1. Relire ce document et mettre à jour les statuts
2. `flutter pub outdated` + audit CVE des dépendances
3. `dart analyze` + `flutter test` doivent rester verts
4. Tests E2E Maestro (CODE-099) sur les flux critiques
5. Vérifier qu'aucune nouvelle table n'a été créée sans RLS
6. Vérifier qu'aucun nouveau endpoint n'est sans rate limit
7. Vérifier que Sentry ingest toujours les events (test manuel)
8. Mettre à jour `Expires` de `security.txt`

---

## 6. Contact sécurité

Tout chercheur en sécurité peut nous remonter une vulnérabilité à :

- **Email** : `security@copiqpolice.fr`
- **PGP key** : (à publier)
- **Délai de réponse** : sous 72h
- **Disclosure** : 90 jours (responsible disclosure)

---

**Phase J complète — la sécurité production est audited et tracée. 🔐**
