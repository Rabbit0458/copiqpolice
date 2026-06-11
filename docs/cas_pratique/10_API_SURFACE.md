# 🔌 COP'IQ — Cas Pratique — Contrat d'API (Repository ↔ Supabase)

> Définit la **surface d'API exacte** entre la couche Flutter (Repository) et Supabase. Toute requête future doit passer par ce contrat. Aucun appel direct à `Supabase.instance.client` depuis l'UI.

---

## 1. Principes

1. **Une seule classe** : `CasPratiqueRepository` (`lib/data/cas_pratique/cas_pratique_repository.dart`)
2. **Methods retournent des modèles typés**, jamais des `Map<String, dynamic>` bruts
3. **Erreurs converties** en `CasPratiqueException` avec un `code` exploitable côté UI
4. **Cache transparent** : le repository décide si fetch ou cache (Hive)
5. **Pas de logique métier** dans le repository : juste fetch + mapping

---

## 2. Modèles de surface (`cas_pratique_models.dart`)

### 2.1. `Theme`

```dart
class Theme {
  final String id;
  final String slug;
  final String label;
  final String colorHex;
  final String icon;
  final int sortOrder;
}
```

### 2.2. `CaseSummary` (pour la liste)

```dart
class CaseSummary {
  final String id;
  final String slug;
  final String title;
  final int year;
  final String? month;
  final Theme? theme;
  final String difficulty;            // facile|moyen|difficile
  final int totalPoints;              // 15
  final int estimatedMinutes;         // 15
  final DateTime? publishedAt;
  final UserCaseProgress? userProgress; // optional, last attempt summary
  final double? avgSuccessPercent;    // taux de réussite global anonymisé
}

class UserCaseProgress {
  final DateTime lastAttemptAt;
  final double lastScore;       // /15
  final double bestScore;       // /15
  final int attemptsCount;
}
```

### 2.3. `CaseDetail` (page cas dynamique)

```dart
class CaseDetail {
  final CaseSummary summary;
  final String situationText;
  final String? situationMd;
  final List<Question> questions;
}

class Question {
  final String id;
  final int position;
  final String label;
  final String? hint;
  final int maxPoints;
  final int charMin;
  final int charRecommended;
  final PerfectAnswer? perfectAnswer;     // chargée seulement après correction
  final List<RubricPoint>? rubricPoints;  // jamais envoyée au client en lecture
}

class PerfectAnswer {
  final String bodyMd;
  final List<LegalReference> referencesLegal;
}

class LegalReference {
  final String article;
  final String code; // 'penal', 'cpp', 'cesa', ...
  final String? label;
}
```

### 2.4. Tentative & Réponses

```dart
class Attempt {
  final String id;
  final String userId;
  final String caseId;
  final DateTime startedAt;
  final DateTime? finishedAt;
  final String status; // in_progress|completed|abandoned
  final double? totalScore;
  final double? totalMax;
  final double? percent;
  final int? timeSpentMs;
}

class Answer {
  final String id;
  final String attemptId;
  final String questionId;
  final int questionIndex; // legacy
  final String text;
  final int charCount;
  final String status; // draft|validated
  final DateTime updatedAt;
}
```

### 2.5. Correction

```dart
class Correction {
  final String id;
  final String attemptId;
  final double totalScore;
  final double totalMax;
  final double percent;
  final DateTime evaluatedAt;
  final String engineVersion;
  final List<CorrectionDetail> details;
}

class CorrectionDetail {
  final String id;
  final String questionId;
  final String pointId;
  final String pointLabel;
  final String pointKind; // core|bonus
  final String status; // covered|partial|missing
  final double score;
  final double weight;
  final String? explanationMd;
}
```

### 2.6. Appels

```dart
class Appeal {
  final String id;
  final String correctionDetailId;
  final String userId;
  final String? message;
  final String status; // pending|approved|rejected
  final String? adminResponse;
  final DateTime? processedAt;
  final DateTime createdAt;
}
```

---

## 3. Méthodes du Repository

### 3.1. Lecture

```dart
abstract class CasPratiqueRepository {
  // ── THEMES ───────────────────────────────────────────────
  Future<List<Theme>> listThemes();

  // ── CASES (LIST + DETAIL) ────────────────────────────────
  Future<List<CaseSummary>> listCases({
    Set<String>? themeSlugs,
    Set<int>? years,
    Set<String>? difficulties, // facile|moyen|difficile
    String? searchQuery,
    CaseSortBy sortBy = CaseSortBy.recent,
    int limit = 50,
    int offset = 0,
  });

  Future<CaseDetail> getCaseDetail(String slug);

  // ── ATTEMPTS ─────────────────────────────────────────────
  Future<Attempt> startAttempt(String caseId);
  Future<Attempt> getAttempt(String attemptId);
  Future<Attempt?> getActiveAttempt(String caseId); // si in_progress, on reprend

  // ── ANSWERS ──────────────────────────────────────────────
  Future<void> saveDraftAnswer({
    required String attemptId,
    required String questionId,
    required int questionIndex,
    required String text,
  });

  Future<void> validateAnswer({
    required String attemptId,
    required String questionId,
    required int questionIndex,
    required String text,
  });

  Future<List<Answer>> listAnswersForAttempt(String attemptId);

  // ── CORRECTION (compute + persist) ───────────────────────
  Future<Correction> finishAttemptAndCorrect({
    required String attemptId,
    required CaseDetail fullCase,
    required Map<String, String> answersByQuestionId,
    required int timeSpentMs,
  });

  Future<Correction> getCorrection(String attemptId);

  // ── APPEALS ──────────────────────────────────────────────
  Future<Appeal> createAppeal({
    required String correctionDetailId,
    required String message,
  });

  Future<List<Appeal>> listMyAppeals();

  // ── PROGRESSION ──────────────────────────────────────────
  Future<UserGlobalProgress> getMyProgress();

  // ── REALTIME (T074) ──────────────────────────────────────
  Stream<Appeal> appealUpdatesStream(); // user reçoit ses appeals approved/rejected
}

enum CaseSortBy { recent, scoreAsc, scoreDesc, durationAsc, durationDesc, alphabetical }
```

### 3.2. Erreurs typées

```dart
class CasPratiqueException implements Exception {
  final CasPratiqueErrorCode code;
  final String message;
  final Object? cause;
  final StackTrace? stackTrace;
}

enum CasPratiqueErrorCode {
  notAuthenticated,
  rlsForbidden,
  caseNotFound,
  caseNotPublished,
  attemptNotFound,
  attemptAlreadyFinished,
  attemptNotOwned,
  questionNotFound,
  answerEmpty,
  answerTooShort,
  saveFailed,
  correctionEngineCrashed,
  networkOffline,
  serverError,
  unknown,
}
```

L'UI mappe ces codes en messages friendly via un dictionnaire centralisé.

---

## 4. Implémentation : requêtes SQL prévues

### 4.1. `listCases`

```sql
SELECT
  c.id, c.slug, c.title, c.year, c.month,
  c.difficulty, c.total_points, c.estimated_minutes, c.published_at,
  t.id AS theme_id, t.slug AS theme_slug, t.label AS theme_label,
  t.color_hex AS theme_color, t.icon AS theme_icon, t.sort_order AS theme_sort,
  -- last attempt for current user
  (SELECT a.percent
     FROM cas_pratique_attempts a
    WHERE a.user_id = auth.uid()
      AND a.case_id = c.id
      AND a.status = 'completed'
    ORDER BY a.finished_at DESC LIMIT 1) AS last_score,
  (SELECT MAX(a.percent)
     FROM cas_pratique_attempts a
    WHERE a.user_id = auth.uid()
      AND a.case_id = c.id) AS best_score,
  (SELECT MAX(a.finished_at)
     FROM cas_pratique_attempts a
    WHERE a.user_id = auth.uid()
      AND a.case_id = c.id) AS last_attempt_at,
  -- success rate global
  (SELECT AVG(co.percent)
     FROM cas_pratique_corrections co
     JOIN cas_pratique_attempts a2 ON a2.id = co.attempt_id
    WHERE a2.case_id = c.id) AS avg_success_percent
FROM cas_pratique_cases c
LEFT JOIN cas_pratique_themes t ON t.id = c.theme_id
WHERE c.status = 'published'
  AND ($1::text[] IS NULL OR t.slug = ANY($1))
  AND ($2::int[]  IS NULL OR c.year = ANY($2))
  AND ($3::text[] IS NULL OR c.difficulty = ANY($3))
  AND ($4::text   IS NULL OR c.title ILIKE '%' || $4 || '%' OR c.situation_text ILIKE '%' || $4 || '%')
ORDER BY
  CASE WHEN $5 = 'recent'       THEN c.published_at END DESC,
  CASE WHEN $5 = 'alphabetical' THEN c.title END ASC
LIMIT $6 OFFSET $7;
```

> En pratique on encapsule ça dans une fonction SQL `cas_pratique_list_cases(...)` pour ne pas avoir cette query monstre dans le client.

### 4.2. `getCaseDetail`

```sql
-- Cas + questions (PAS la rubric, jamais envoyée au client)
SELECT c.*, q.*
FROM cas_pratique_cases c
JOIN cas_pratique_questions q ON q.case_id = c.id
WHERE c.slug = $1
  AND c.status = 'published'
ORDER BY q.position;
```

> La rubric n'est **jamais** envoyée au client : elle reste côté serveur. La correction se fait côté serveur via une edge function `cas_pratique_correct_attempt`.

### 4.3. `finishAttemptAndCorrect` — Edge Function

**Pourquoi côté serveur ?**
- La rubric ne doit pas être leakée (un user pourrait reverse-engineer le scoring)
- Le moteur s'exécute en isolation, déterministe
- Les permissions (RLS) sont mieux gérées
- Le client peut être offline sans bloquer la correction

**Path** : `supabase/functions/cas_pratique_correct_attempt/index.ts`

**Input** :
```ts
{
  attempt_id: string,
  answers: { question_id: string, text: string }[],
  time_spent_ms: number
}
```

**Output** :
```ts
{
  correction: {
    id, total_score, total_max, percent, engine_version,
    details: [
      { question_id, point_id, point_label, point_kind,
        status, score, weight, explanation_md }
    ]
  }
}
```

**Étapes** :
1. Récup attempt + check ownership
2. Récup case + questions + rubric_points + groups + keywords + dict
3. Pour chaque question, exécuter le moteur de correction (port TS du Dart)
4. INSERT corrections + correction_details
5. UPDATE attempts (finished_at, total_score, etc.)
6. Retourner le payload

> NOTE : il faudra **2 implémentations du moteur** — une en Dart (offline mode) et une en TypeScript (edge function). Tests croisés pour s'assurer qu'elles donnent les mêmes scores.

### 4.4. Mode offline

Si pas de connexion :
1. Le moteur Dart local fait la correction (la rubric a été cachée localement avec le cas via Hive)
2. Stockage local de la correction "tentative" (`pending_sync = true`)
3. À la reconnexion, on appelle quand même l'edge function pour recalculer côté serveur (source de vérité)
4. Si écart : on prend la valeur serveur

> ⚠️ Cette fonctionnalité offline implique que la rubric DOIT être cachée localement. Cela contrevient au principe "rubric jamais leak". **Décision** : on accepte le compromis pour l'offline (UX > strict security), mais on chiffre le cache Hive avec une clé dérivée de l'auth.

---

## 5. Cache strategy (Hive)

### 5.1. Boxes Hive

| Box                          | Clé                | Valeur                  | TTL    |
|------------------------------|--------------------|-------------------------|--------|
| `cp_themes`                  | `'all'`            | `List<Theme>`           | 24 h   |
| `cp_cases_list`              | `filter_hash`      | `List<CaseSummary>`     | 1 h    |
| `cp_case_detail`             | `slug`             | `CaseDetail` (encrypted)| 7 jours|
| `cp_active_attempt`          | `case_id`          | `Attempt`               | session|
| `cp_drafts`                  | `attempt_id+q_id`  | `String text`           | jusqu'à validation |
| `cp_my_progress`             | `user_id`          | `UserGlobalProgress`    | 5 min  |
| `cp_pending_corrections`     | `attempt_id`       | local correction        | jusqu'à sync |

### 5.2. Invalidation

- Pull-to-refresh sur la liste → invalide `cp_cases_list`
- Submit answer ou correction → invalide `cp_my_progress`
- Logout → flush toutes les boxes

---

## 6. Realtime (T074)

Subscription Supabase Realtime sur `cas_pratique_appeals` filtrée par `user_id = auth.uid()` :

```dart
final stream = supabase
  .from('cas_pratique_appeals')
  .stream(primaryKey: ['id'])
  .eq('user_id', userId)
  .order('created_at');
```

L'UI écoute et notifie l'user :
- "Ton appel sur Q1 du cas X a été approuvé. Score mis à jour : 12/15."
- "Ton appel sur Q2 du cas Y a été rejeté. Voir explication."

---

## 7. Versioning du contrat

- Chaque **breaking change** du contrat bump la version `cas_pratique_repo_version`
- Le client envoie sa version dans un header custom : `X-Cp-Repo-Version: 2.0.0`
- L'edge function refuse les versions trop anciennes avec `426 Upgrade Required`
- Cas particulier : versions `2.0.x` sont rétrocompatibles, `3.0.0` ne l'est pas

---

## 8. Quotas & rate limits

| Action                              | Limite                       |
|-------------------------------------|------------------------------|
| `listCases`                         | 60 / min / user              |
| `getCaseDetail`                     | 30 / min / user              |
| `saveDraftAnswer`                   | 600 / min / user (autosave)  |
| `validateAnswer`                    | 30 / min / user              |
| `finishAttemptAndCorrect`           | 10 / min / user              |
| `createAppeal`                      | 20 / jour / user             |

Implémentation : Cloudflare ou Supabase rate limit (column `last_call_at` + count).
