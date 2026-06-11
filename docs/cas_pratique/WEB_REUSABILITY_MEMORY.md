# 🌐 COP'IQ — Mémoire portable vers le site web

> **Pourquoi ce fichier existe**
> COP'IQ est actuellement une app **mobile Flutter**. Plus tard, Kaïs veut construire le **site internet** (HTML / CSS / JS) qui reprendra **tout** : Cas pratique + Culture générale + Langue étrangère + Psychotechniques, etc.
>
> Ce document est la **mémoire portable** : il capture toute la logique, les modèles de données, les algorithmes, le design system, les flows utilisateurs — de manière **indépendante du langage Flutter/Dart** — pour qu'un futur Claude (ou Kaïs, ou un dev humain) puisse coder le site web sans repartir de zéro.
>
> **Mis à jour à chaque tâche** du protocole `PROGRESSION_CODE.md`. Le futur site sera construit principalement à partir de ce fichier + des fichiers de spec 01-10.

---

## 📐 1. Architecture globale (portable web)

```
┌─────────────────────────────────────────────────────────────┐
│  Frontend Web (Next.js / SvelteKit / Astro recommandé)      │
│  - Pages SSR/SSG pour SEO                                    │
│  - State : Zustand / Pinia / Context React                   │
│  - Style : Tailwind + tokens portés depuis 05_DESIGN_SYSTEM  │
│  - Auth : Supabase Auth (mêmes flows que mobile)             │
└────────────────────────┬────────────────────────────────────┘
                         │ (HTTPS / supabase-js)
┌────────────────────────▼────────────────────────────────────┐
│  Supabase Postgres (DÉJÀ EN PLACE — mobile + web partagent)  │
│  - Même schéma (cas_pratique_* tables)                       │
│  - Mêmes RLS policies                                        │
│  - Mêmes edge functions de correction (port TS du Dart)      │
└─────────────────────────────────────────────────────────────┘
```

**Décision clé** : **mobile et web partagent la même base Supabase**. Pas de duplication, pas de sync. Un user qui fait un cas sur mobile, retrouve son score sur le web (et inversement).

---

## 🎨 2. Design system portable (Tailwind config)

À mettre dans `tailwind.config.js` côté web :

```js
// tailwind.config.js
module.exports = {
  theme: {
    extend: {
      colors: {
        // Brand
        brand: {
          DEFAULT:   '#1147D9',
          midLight:  '#1A55E6',
          deepLight: '#0E2F9E',
        },
        navy: {
          DEFAULT: '#000B36',
          mid:     '#000A33',
          deep:    '#00082D',
        },
        // Sémantique correction
        success:   { DEFAULT: '#22C55E', dark: '#34D399', soft: '#DCFCE7', softDark: '#022C22' },
        warning:   { DEFAULT: '#F59E0B', dark: '#FBBF24', soft: '#FEF3C7', softDark: '#451A03' },
        danger:    { DEFAULT: '#EF4444', dark: '#F87171', soft: '#FEE2E2', softDark: '#450A0A' },
        info:      { DEFAULT: '#0EA5E9', dark: '#38BDF8', soft: '#E0F2FE', softDark: '#082F49' },
        // Thèmes Cas Pratique
        theme: {
          accueil:           '#1147D9',
          deontologie:       '#0EA5E9',
          cadreLegal:        '#22C55E',
          securitePublique:  '#F59E0B',
          intervention:      '#EF4444',
          familleMineur:     '#A855F7',
          routier:           '#06B6D4',
        },
      },
      fontFamily: {
        sans: ['Montserrat', 'system-ui', 'sans-serif'],
      },
      borderRadius: {
        'pill': '999px',
      },
    },
  },
};
```

**Typo** : Montserrat (chargée via `next/font` ou Google Fonts CSS).

**Dark mode** : `class` strategy. Sélecteur `dark:` sur la `<html>`.

---

## 🗄️ 3. Schéma base de données (déjà en place)

Le schéma SQL complet est dans **`03_SCHEMA.sql`**. Le web utilise les **15 tables existantes** sans modification :

- `cas_pratique_themes` — taxonomie
- `cas_pratique_cases` — cas avec mise en situation
- `cas_pratique_questions` — questions liées
- `cas_pratique_perfect_answers` — réponses modèles
- `cas_pratique_rubric_points` — grille de correction (admin only via RLS)
- `cas_pratique_keyword_groups` — groupes de keywords (admin only)
- `cas_pratique_keywords` — mots-clés (admin only)
- `cas_pratique_synonyms_dictionary` — dictionnaire mutualisé (admin only)
- `cas_pratique_attempts` — tentatives user
- `cas_pratique_answers` — réponses user
- `cas_pratique_corrections` — résultats de correction
- `cas_pratique_correction_details` — détails point par point
- `cas_pratique_appeals` — signalements user
- `cas_pratique_user_progress` — progression agrégée
- `cas_pratique_admin_audit` — audit log

**Conclusion** : côté web, aucune migration à faire. Juste `supabase.from('cas_pratique_cases').select()`.

---

## 🧠 4. Moteur de correction — portage TypeScript

Le moteur Dart vit dans `lib/core/cas_pratique/engine/` (CODE-019 → CODE-028).

**Pour le web**, deux options :

### Option A : Port TypeScript exécuté côté Edge Function Supabase (recommandé)
- 1 seule source de vérité (le user ne peut pas reverse-engineer le scoring)
- Le client web POST l'attempt à `/functions/v1/cas_pratique_correct_attempt`
- L'edge function fait la correction et insert dans `corrections` + `correction_details`
- Algorithme identique au Dart, ligne pour ligne

### Option B : Port TypeScript exécuté côté navigateur (offline)
- Pour PWA offline
- Risque sécurité : rubric chargée côté client
- Acceptable car les mots-clés ne sont pas si secrets (le user les devinerait via les corrections de toute façon)

**Pseudocode portable** (à transcrire en Dart + TS identiquement) :

```ts
// 1. Normalize
function normalize(s: string): string {
  return s.normalize('NFD')
    .replace(/[̀-ͯ]/g, '')   // diacritics
    .toLowerCase()
    .replace(/[^a-z0-9\s]/g, ' ')
    .replace(/\s+/g, ' ')
    .trim();
}

// 2. Tokenize + n-grams
function ngramSet(tokens: string[]): Set<string> {
  const out = new Set(tokens);
  for (let i = 0; i + 1 < tokens.length; i++) out.add(`${tokens[i]}_${tokens[i+1]}`);
  for (let i = 0; i + 2 < tokens.length; i++) out.add(`${tokens[i]}_${tokens[i+1]}_${tokens[i+2]}`);
  return out;
}

// 3. Levenshtein (2 lignes)
function levenshtein(a: string, b: string, maxDist: number): number { /* ... */ }

// 4. Keyword match (exact + fuzzy + phrase + négation)
function keywordMatches(kw: Keyword, ctx: MatchContext, dict: SynDict): boolean { /* ... */ }

// 5. Point evaluator (groupes ET, keywords OR)
function evaluatePoint(point: RubricPoint, groups: KeywordGroup[], ctx: MatchContext): PointResult {
  let hits = 0, required = 0;
  for (const g of groups) {
    if (!g.is_optional) required++;
    const groupOk = g.keywords.some(kw => keywordMatches(kw, ctx, dict));
    if (groupOk) hits++;
  }
  const ratio = required === 0 ? 1 : hits / required;
  if (ratio >= 1.0) return { status: 'covered', score: point.weight };
  if (ratio >= 0.5) return { status: 'partial', score: point.weight * 0.5 };
  return { status: 'missing', score: 0 };
}
```

**Spec complète** : `04_CORRECTION_ENGINE_SPEC.md`.

---

## 🔄 5. Flow utilisateur du Cas Pratique (identique mobile/web)

```
1. Liste des cas         GET cas_pratique_cases WHERE status='published'
   ├─ filtres            ?theme=X&year=Y&difficulty=Z&search=Q
   ├─ tri                ORDER BY published_at DESC
   └─ pagination         LIMIT 50 OFFSET N

2. Détail cas            GET cas_pratique_cases (+ questions + perfect_answers)
   - rubric NON envoyée  (RLS admin only)

3. Démarrer tentative    INSERT cas_pratique_attempts (user_id, case_id, status='in_progress')
   - Si une in_progress existe → la reprendre (UX : "Tu reprends ?")

4. Sauvegarde draft      UPSERT cas_pratique_answers (attempt_id, question_id, status='draft')
   - Auto-save toutes les 1.5s côté client (debounced)

5. Validation question   UPSERT cas_pratique_answers (..., status='validated')
   - Lock back navigation (UX)

6. Finir tentative       POST /functions/v1/cas_pratique_correct_attempt
   - Le serveur : load rubric + run engine + INSERT corrections + correction_details
   - Update attempts.status='completed', total_score, percent, time_spent_ms

7. Page correction       GET cas_pratique_corrections WHERE attempt_id=X
   + GET cas_pratique_correction_details JOIN points pour les labels
   - Affichage accordion par question
   - Boutons "Faire appel" sur les points 'missing'

8. Appel                 INSERT cas_pratique_appeals
   - Realtime stream sur cas_pratique_appeals WHERE user_id=auth.uid()
   - Quand admin approuve : keyword auto-ajouté, recalcul score, notif user
```

**Spec complète** : `10_API_SURFACE.md` + `04_CORRECTION_ENGINE_SPEC.md`.

---

## 🎬 6. Pages du site web (proposition)

| Route                                 | Équivalent mobile                          |
|---------------------------------------|--------------------------------------------|
| `/`                                   | Splash + onboarding marketing              |
| `/login`                              | Connexion Supabase                          |
| `/dashboard`                          | Home (raccourcis vers tous les modules)    |
| `/cas-pratique`                       | Liste cas (filtres, recherche, tri)        |
| `/cas-pratique/[slug]`                | Détail cas (multi-étapes)                  |
| `/cas-pratique/[slug]/correction`     | Page correction (post-soumission)          |
| `/cas-pratique/mes-appels`            | Liste des appels du user                   |
| `/profil`                             | Stats user (progression, badges)           |
| `/admin`                              | Panel admin (cf. `06_ADMIN_PANEL_SPEC.md`) |
| `/admin/cas`                          | Liste cas admin                            |
| `/admin/cas/new`                      | Création cas                               |
| `/admin/cas/[id]`                     | Édition cas                                |
| `/admin/synonymes`                    | Dictionnaire de synonymes                  |
| `/admin/appels`                       | Modération des appels                      |
| `/culture-generale`                   | Module culture G (à venir, voir mobile)    |
| `/langue-etrangere`                   | Module langue (à venir, voir mobile)       |
| `/psychotechniques`                   | Module psy (à venir, voir mobile)          |

---

## 🧩 7. Composants UI réutilisables (web)

À implémenter une fois, à utiliser partout :

| Composant React/Vue          | Description                                       |
|------------------------------|---------------------------------------------------|
| `<ThemeBadge slug=... />`    | Pill thème avec couleur + icône                   |
| `<DifficultyChip val=... />` | Pill facile/moyen/difficile                       |
| `<CaseCard data={summary} />`| Card cas dans la liste                            |
| `<AnswerTextArea />`         | Textarea premium avec compteur + autosave indicator|
| `<ScoreReveal pct=... />`    | Score révélé en cercle + confettis si ≥ 80 %      |
| `<PointPill status=... />`   | Item de correction avec status covered/partial/missing |
| `<AppealModal />`            | Modal "Faire appel"                               |
| `<RubricTreeEditor />` (admin)| Arborescence édition rubric                      |
| `<KeywordMatchPreview />` (admin)| Test live d'une réponse contre une rubric    |

---

## 📚 8. État de progression Cas Pratique (mis à jour en continu)

> Cette section est **mise à jour à chaque tâche** par Claude. Reflète ce qui est livré.

### Backend (Supabase)

| Élément                  | Statut    | Fichier                                                          |
|--------------------------|-----------|------------------------------------------------------------------|
| Schéma 15 tables         | ✅ Livré  | `supabase/migrations/20260508000001..8_*.sql`                    |
| RLS user                 | ✅ Livré  | migration 008                                                     |
| RLS admin (JWT claim)    | ✅ Livré  | migration 008                                                     |
| Indexes (16 + trgm)      | ✅ Livré  | migration 006                                                     |
| Triggers updated_at      | ✅ Livré  | migration 007                                                     |
| Trigger user_progress    | ✅ Livré  | migration 007                                                     |
| Seeds 7 thèmes           | ✅ Livré  | migration 008                                                     |
| Edge function correction | ⏳ TODO   | `supabase/functions/cas_pratique_correct_attempt/`                |
| Realtime appeals         | ⏳ TODO   | activation : `cas_pratique_appeals` dans Supabase dashboard      |

### Côté client (Dart — portable TS)

| Élément                  | Statut    | Fichier Dart                                                     |
|--------------------------|-----------|------------------------------------------------------------------|
| Tokens design            | ✅ Livré  | `lib/core/cas_pratique/theme/cp_tokens.dart`                     |
| Modèles                  | ✅ Livré  | `lib/data/cas_pratique/models/cas_pratique_models.dart`          |
| Exceptions typées        | ✅ Livré  | `lib/data/cas_pratique/cas_pratique_exception.dart`              |
| Repository abstract      | ✅ Livré  | `lib/data/cas_pratique/cas_pratique_repository.dart`             |
| Repository impl Supabase | ✅ Livré  | `lib/data/cas_pratique/cas_pratique_repository_impl.dart`        |
| Cache local              | ✅ Livré  | `lib/data/cas_pratique/cas_pratique_cache.dart`                  |
| Moteur Normalizer        | ⏳ TODO   | `lib/core/cas_pratique/engine/normalizer.dart`                   |
| Moteur Tokenizer/ngrams  | ⏳ TODO   | `lib/core/cas_pratique/engine/tokenizer.dart`                    |
| Moteur Lemmatizer FR     | ⏳ TODO   | `lib/core/cas_pratique/engine/lemmatizer.dart`                   |
| Moteur Levenshtein       | ⏳ TODO   | `lib/core/cas_pratique/engine/levenshtein.dart`                  |
| Moteur Keyword matcher   | ⏳ TODO   | `lib/core/cas_pratique/engine/keyword_matcher.dart`              |
| Moteur Point evaluator   | ⏳ TODO   | `lib/core/cas_pratique/engine/point_evaluator.dart`              |
| Moteur Scorer            | ⏳ TODO   | `lib/core/cas_pratique/engine/scorer.dart`                       |
| Façade engine            | ⏳ TODO   | `lib/core/cas_pratique/engine/correction_engine.dart`            |
| Page cas dynamique       | ⏳ TODO   | `lib/content/.../cas_pratique_excercice/case_dynamic_page.dart`  |
| Liste cas dynamique      | ⏳ TODO   | refonte `cas_pratique_list_confiug.dart`                          |
| Système d'appel          | ⏳ TODO   | repository createAppeal + watchMyAppeals                          |

---

## 🔁 9. Plan de portage Flutter → Web (futur)

Quand le moteur Dart sera fini (Phase D = CODE-019 → CODE-028), on génère un **port TypeScript ligne par ligne** :

1. `normalizer.dart` → `normalizer.ts` (même API, même tests)
2. `tokenizer.dart` → `tokenizer.ts`
3. `lemmatizer.dart` → `lemmatizer.ts`
4. `levenshtein.dart` → `levenshtein.ts`
5. `keyword_matcher.dart` → `keyword_matcher.ts`
6. `point_evaluator.dart` → `point_evaluator.ts`
7. `scorer.dart` → `scorer.ts`
8. Tests : porter les fixtures JSON dans `test/cas_pratique/fixtures/` vers Jest/Vitest

**Validation** : pour chaque fixture, le score Dart doit être **exactement égal** au score TS. Si écart : bug.

Le port TS sert ensuite l'edge function Supabase **ET** la PWA offline.

---

## 🪪 10. Auth & sessions (partagées mobile/web)

- **Supabase Auth** : email + password (existant), pas de magic link pour MVP web
- **JWT** : valable 1h, refresh token automatique côté SDK
- **Cookie httpOnly** côté web pour le refresh token (sécurité XSS)
- **Claim `is_admin`** : custom JWT claim ajouté via SQL function `auth.set_admin_claim(user_id)`
- Le user qui crée un compte sur web peut se reconnecter sur mobile (et vice-versa) sans rien faire de spécial

---

## 📝 11. Contenu (cas pratiques) — réutilisé

Tous les cas pratiques créés via le **panel admin** sont stockés dans la base. Le site web les récupère via `supabase.from('cas_pratique_cases').select()`. **Aucune duplication de contenu.**

Un cas créé en juin 2026 est visible immédiatement sur les 2 plateformes.

---

## 🚀 12. Stack web recommandée (résumé)

| Layer         | Choix                              | Raison                                              |
|---------------|------------------------------------|-----------------------------------------------------|
| Framework     | **Next.js 15 App Router** (React)  | SSR/ISR pour SEO, écosystème mature                  |
| Style         | **Tailwind CSS**                   | Tokens cohérents avec Dart, productif                |
| State         | **Zustand** + **TanStack Query**   | Léger, async-first                                   |
| Auth          | **@supabase/ssr** + **@supabase/supabase-js** | Cookies httpOnly, refresh auto       |
| Realtime      | `supabase-js` Realtime channels    | Mêmes APIs que mobile                                |
| Markdown      | **react-markdown** + **remark-gfm**| Pour les mises en situation md                       |
| Animations    | **framer-motion**                  | Spring physics, reduce-motion respecté               |
| Charts admin  | **recharts** ou **tremor**         | Dashboards admin                                     |
| Confettis     | **canvas-confetti**                | Score reveal ≥ 80 %                                  |
| Tests         | **Vitest** + **Playwright**        | Unit + E2E                                           |
| Hosting       | **Vercel** ou **Cloudflare Pages** | Optimisé Next.js                                     |

---

## 🪛 13. Critères pour démarrer la version web (checklist)

- [ ] Phase D du protocole code finie (moteur Dart à 2.0.0)
- [ ] Au moins 10 cas pratiques en `published` dans la base
- [ ] Edge function `cas_pratique_correct_attempt` déployée (port TS du moteur)
- [ ] Domaine `app.copiq.fr` + `admin.copiq.fr` réservés
- [ ] Vercel/Cloudflare Pages configurés
- [ ] Cookies httpOnly testés en local

Quand ces 6 cases sont cochées, on peut lancer le squelette Next.js.

---

## 📌 14. Notes & décisions historiques (à conserver)

- **2026-05-08** : Architecture validée — mobile et web partagent Supabase + edge functions.
- **2026-05-08** : Décision de NE PAS utiliser un LLM externe pour la correction. Moteur déterministe + filet de sécurité (appels users).
- **2026-05-08** : Panel admin séparé en Flutter Web ou Next.js (à trancher au moment de la phase 7).
