# 🧠 COP'IQ — Cas Pratique — Moteur de Correction v2.0

> Spec **complète** du moteur de correction nouvelle génération.
> Cible : remplacer le système hardcodé actuel par un moteur **déterministe**, **rapide**, **scalable**, et **auto-améliorant** via le système d'appels.

---

## 0. Mission & contraintes

**Mission** : pour une réponse libre d'un utilisateur, attribuer un score sur N points en se basant sur une grille de correction (rubric) stockée en DB, avec une qualité approchant celle d'un correcteur humain.

**Contraintes non-négociables** :
- ❌ Pas d'appel LLM en ligne (ni OpenAI, ni Claude, ni équivalent)
- ✅ 100 % offline-capable (le moteur doit pouvoir tourner sans connexion)
- ✅ Déterministe (mêmes entrées ⇒ mêmes sorties, toujours)
- ✅ < 100 ms par cas complet sur mobile entry-level
- ✅ Capacité à scaler à 1000+ cas sans dégradation
- ✅ Capacité à s'auto-améliorer via le système d'appels (T076)

---

## 1. Vue d'ensemble du pipeline

```
┌─────────────────────────────────────────────────────────────────────┐
│  Réponse utilisateur (texte brut, ex: 2000 caractères)              │
└──────────────────────────────┬──────────────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────────────┐
│  1. NORMALIZER                                                      │
│     Unicode NFD → strip diacritics → lowercase → strip ponctuation  │
│     → collapse whitespace                                           │
└──────────────────────────────┬──────────────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────────────┐
│  2. TOKENIZER                                                       │
│     Split sur whitespace → tokens                                   │
│     Génération bigrams + trigrams                                   │
└──────────────────────────────┬──────────────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────────────┐
│  3. LEMMATIZER (léger)                                              │
│     Retrait suffixes courants (-er, -ait, -ée, -aux, ...)           │
└──────────────────────────────┬──────────────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────────────┐
│  4. NEGATION INDEX                                                  │
│     Pré-calcul : positions des négations (ne, pas, jamais, aucun)   │
└──────────────────────────────┬──────────────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────────────┐
│  5. KEYWORD MATCHER (par point)                                     │
│     Pour chaque RubricPoint :                                       │
│       Pour chaque KeywordGroup :                                    │
│         Pour chaque Keyword (résolu via dict si syn_dict_id) :      │
│           - Match exact dans tokens/ngrams                          │
│           - Sinon, fuzzy Levenshtein si activé                      │
│         Group OK si au moins 1 keyword match                        │
│       Point status :                                                │
│         covered = TOUS groupes match                                │
│         partial = ≥ 50% groupes match                               │
│         missing = sinon                                             │
└──────────────────────────────┬──────────────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────────────┐
│  6. SCORER                                                          │
│     Score point = weight × (1.0 si covered, 0.5 si partial, 0)      │
│     Score question = clamp(somme points, 0, max_points)             │
│     Score total = somme questions                                   │
└──────────────────────────────┬──────────────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────────────┐
│  7. PERSIST                                                         │
│     INSERT cas_pratique_corrections                                 │
│     INSERT cas_pratique_correction_details (1 par point)            │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 2. Modules en détail

### 2.1. Normalizer (`lib/core/cas_pratique/engine/normalizer.dart`)

```dart
class Normalizer {
  /// Pipeline complet de normalisation pour le matching
  String normalize(String input, {NormalizerOptions opts = const NormalizerOptions()}) {
    var s = input;
    s = _toNfd(s);                 // décomposition Unicode
    s = _stripDiacritics(s);        // retrait accents
    s = s.toLowerCase();
    if (opts.stripPunctuation) s = _stripPunctuation(s);
    s = _collapseWhitespace(s);
    return s.trim();
  }

  /// Variante légère qui PRÉSERVE les accents (utile en affichage)
  String softNormalize(String input) {
    return input.replaceAll(' ', ' ').trim().toLowerCase();
  }
}

class NormalizerOptions {
  final bool stripPunctuation;
  final bool keepApostrophes;
  const NormalizerOptions({
    this.stripPunctuation = true,
    this.keepApostrophes = false,
  });
}
```

**Tests unitaires obligatoires** :
- `"À l'École"` → `"a l ecole"`
- `"Pneus crevés ; vitre brisée!"` → `"pneus creves vitre brisee"`
- `"M. BRAVO"` → `"m bravo"`
- `"Œuf cœur"` → `"oeuf coeur"`

### 2.2. Tokenizer + N-grams (`tokenizer.dart`)

```dart
class Tokenizer {
  List<String> tokenize(String normalized) {
    if (normalized.isEmpty) return const [];
    return normalized.split(RegExp(r'\s+'));
  }

  /// Génère uni + bi + trigrams jointed par '_'
  Set<String> ngramSet(List<String> tokens) {
    final out = <String>{...tokens};
    for (var i = 0; i + 1 < tokens.length; i++) {
      out.add('${tokens[i]}_${tokens[i + 1]}');
    }
    for (var i = 0; i + 2 < tokens.length; i++) {
      out.add('${tokens[i]}_${tokens[i + 1]}_${tokens[i + 2]}');
    }
    return out;
  }
}
```

**Tests** :
- `"degradation volontaire bien"` → uni `{degradation, volontaire, bien}`, bi `{degradation_volontaire, volontaire_bien}`, tri `{degradation_volontaire_bien}`

### 2.3. Lemmatizer (`lemmatizer.dart`)

Pas un vrai lemmatiseur (trop lourd pour mobile). Juste un **stemmer FR** par retrait de suffixes courants.

```dart
class FrLemmatizer {
  static const _suffixes = [
    'aient', 'ions', 'iez', 'ait', 'ais', 'ant', 'ent', 'ons', 'ez',
    'ées', 'ée', 'és', 'er', 'ir', 'ré', 're', 'aux', 'eux',
    'ses', 'eur', 'ation',  's', 'x'
  ]; // ordre du plus long au plus court

  String stem(String token) {
    if (token.length < 5) return token;
    for (final suf in _suffixes) {
      if (token.length - suf.length >= 4 && token.endsWith(suf)) {
        return token.substring(0, token.length - suf.length);
      }
    }
    return token;
  }
}
```

**Tests** :
- `dégradait` → `degrad`
- `dégrader` → `degrad`
- `dégradations` → `degrad`
- `volontairement` → `volontair`
- `respecter` → `respect`

### 2.4. Levenshtein (`levenshtein.dart`)

```dart
class Levenshtein {
  /// Distance d'édition optimisée (matrice 2 lignes au lieu de 2D pleine)
  static int distance(String a, String b, {int? maxDist}) {
    if (a == b) return 0;
    if (a.isEmpty) return b.length;
    if (b.isEmpty) return a.length;
    if ((a.length - b.length).abs() > (maxDist ?? a.length)) {
      return (maxDist ?? a.length) + 1; // early exit
    }

    final m = a.length, n = b.length;
    var prev = List<int>.generate(n + 1, (j) => j);
    var curr = List<int>.filled(n + 1, 0);

    for (var i = 1; i <= m; i++) {
      curr[0] = i;
      var rowMin = i;
      for (var j = 1; j <= n; j++) {
        final cost = (a.codeUnitAt(i - 1) == b.codeUnitAt(j - 1)) ? 0 : 1;
        curr[j] = [
          curr[j - 1] + 1,
          prev[j] + 1,
          prev[j - 1] + cost,
        ].reduce((x, y) => x < y ? x : y);
        if (curr[j] < rowMin) rowMin = curr[j];
      }
      // Early termination: si même la meilleure cellule de la ligne dépasse le max,
      // pas la peine de continuer.
      if (maxDist != null && rowMin > maxDist) {
        return maxDist + 1;
      }
      final tmp = prev; prev = curr; curr = tmp;
    }
    return prev[n];
  }
}
```

### 2.5. Keyword Matcher (`keyword_matcher.dart`)

```dart
class KeywordMatchContext {
  final String normalizedAnswer;
  final List<String> tokens;
  final Set<String> ngramSet;
  final List<int> negationPositions;
  // ...
}

class KeywordMatcher {
  bool matches(Keyword kw, KeywordMatchContext ctx, SynDict? dict) {
    final candidates = _resolveCandidates(kw, dict);

    for (final cand in candidates) {
      // 1. Match phrase (multi-mots) → recherche dans normalizedAnswer
      if (kw.isPhrase) {
        if (ctx.normalizedAnswer.contains(cand)) {
          if (_isNegated(ctx, cand)) {
            if (kw.isNegation) return true; // négation attendue
            continue;                       // négation indésirable
          }
          return !kw.isNegation;
        }
      } else {
        // 2. Match exact dans ngramSet (uni + bi + tri grams)
        final candKey = cand.replaceAll(' ', '_');
        if (ctx.ngramSet.contains(candKey)) {
          if (_isNegatedToken(ctx, candKey)) {
            if (kw.isNegation) return true;
            continue;
          }
          return !kw.isNegation;
        }

        // 3. Fuzzy match si activé et token long
        if (kw.fuzzyMaxDist > 0 && cand.length >= 6) {
          for (final t in ctx.tokens) {
            if ((t.length - cand.length).abs() > kw.fuzzyMaxDist) continue;
            final d = Levenshtein.distance(t, cand, maxDist: kw.fuzzyMaxDist);
            if (d <= kw.fuzzyMaxDist) {
              return !kw.isNegation;
            }
          }
        }
      }
    }
    // Aucun match
    return kw.isNegation; // si keyword est une négation et pas trouvé → "ok"
  }

  List<String> _resolveCandidates(Keyword kw, SynDict? dict) {
    if (kw.synDictId != null && dict != null) {
      return dict.terms;
    }
    return [kw.value!];
  }

  bool _isNegated(KeywordMatchContext ctx, String phrase) {
    // Cherche position de la phrase, puis vérifie 5 tokens avant
    final idx = ctx.normalizedAnswer.indexOf(phrase);
    if (idx < 0) return false;
    final preWindow = ctx.normalizedAnswer.substring(0, idx);
    final preTokens = preWindow.split(' ');
    final last5 = preTokens.length > 5
        ? preTokens.sublist(preTokens.length - 5)
        : preTokens;
    return last5.any(_isNegationToken);
  }

  bool _isNegatedToken(KeywordMatchContext ctx, String token) {
    final pos = ctx.tokens.indexOf(token.replaceAll('_', ' ').split(' ').first);
    if (pos < 0) return false;
    for (var i = pos - 1; i >= 0 && i >= pos - 5; i--) {
      if (_isNegationToken(ctx.tokens[i])) return true;
    }
    return false;
  }

  static const _negationWords = {
    'ne', 'n', 'pas', 'plus', 'jamais', 'aucun', 'aucune',
    'rien', 'sans', 'non', 'ni', 'nulle'
  };
  bool _isNegationToken(String t) => _negationWords.contains(t);
}
```

### 2.6. Point Evaluator (`point_evaluator.dart`)

```dart
class PointEvaluator {
  PointEvalResult evaluate(
    RubricPoint point,
    List<KeywordGroup> groups,
    Map<String, List<Keyword>> keywordsByGroup,
    Map<String, SynDict> synDictById,
    KeywordMatchContext ctx,
  ) {
    if (groups.isEmpty) {
      return PointEvalResult(
        status: PointStatus.missing,
        score: 0,
        weight: point.weight,
        groupMatches: const [],
      );
    }

    var groupHits = 0;
    var requiredGroups = 0;
    final groupResults = <GroupMatch>[];

    for (final g in groups) {
      final kws = keywordsByGroup[g.id] ?? const <Keyword>[];
      final matched = <String>[];
      var groupOk = false;

      for (final kw in kws) {
        final dict = kw.synDictId != null ? synDictById[kw.synDictId!] : null;
        if (matcher.matches(kw, ctx, dict)) {
          matched.add(kw.value ?? dict?.slug ?? '?');
          groupOk = true;
          break; // OR : un seul keyword suffit
        }
      }
      if (!g.isOptional) requiredGroups++;
      if (groupOk) groupHits++;

      groupResults.add(GroupMatch(groupId: g.id, matched: matched));
    }

    final ratio = requiredGroups == 0
        ? 1.0
        : groupHits / requiredGroups;

    PointStatus status;
    double scoreFactor;
    if (ratio >= 1.0) {
      status = PointStatus.covered;
      scoreFactor = 1.0;
    } else if (ratio >= 0.5) {
      status = PointStatus.partial;
      scoreFactor = 0.5;
    } else {
      status = PointStatus.missing;
      scoreFactor = 0.0;
    }

    return PointEvalResult(
      status: status,
      score: point.weight * scoreFactor,
      weight: point.weight,
      groupMatches: groupResults,
    );
  }
}

enum PointStatus { covered, partial, missing }
```

### 2.7. Question Scorer

```dart
class QuestionScorer {
  QuestionScoreResult score(
    Question q,
    List<RubricPoint> points,
    String userAnswer,
    EngineDeps deps,
  ) {
    final ctx = deps.buildContext(userAnswer);
    final results = <PointEvalResult>[];

    var rawScore = 0.0;
    var maxPossible = 0.0;

    for (final p in points) {
      final groups = deps.groupsByPoint[p.id] ?? const [];
      final res = deps.evaluator.evaluate(
        p, groups, deps.keywordsByGroup, deps.synDictById, ctx,
      );
      results.add(res);
      rawScore += res.score;
      maxPossible += res.weight;
    }

    // Normalisation à max_points (typiquement 5)
    final normalized = maxPossible == 0
        ? 0.0
        : (rawScore / maxPossible) * q.maxPoints;
    final clamped = normalized.clamp(0.0, q.maxPoints.toDouble());

    return QuestionScoreResult(
      questionId: q.id,
      score: clamped,
      maxPoints: q.maxPoints.toDouble(),
      points: results,
    );
  }
}
```

### 2.8. Attempt Scorer (orchestration)

```dart
class AttemptScorer {
  Future<Correction> correctAttempt({
    required String attemptId,
    required CaseDetail fullCase,
    required Map<String, String> answersByQuestionId,
    required SupabaseClient sb,
  }) async {
    final deps = await _loadDeps(fullCase, sb);
    final scorer = QuestionScorer();
    final qResults = <QuestionScoreResult>[];

    for (final q in fullCase.questions) {
      final ans = answersByQuestionId[q.id] ?? '';
      final points = deps.pointsByQuestion[q.id] ?? const [];
      qResults.add(scorer.score(q, points, ans, deps));
    }

    final total = qResults.fold<double>(0, (a, r) => a + r.score);
    final max   = qResults.fold<double>(0, (a, r) => a + r.maxPoints);
    final pct   = max == 0 ? 0 : (total / max) * 100;

    // Persist
    final corrId = (await sb.from('cas_pratique_corrections').insert({
      'attempt_id': attemptId,
      'total_score': total,
      'total_max': max,
      'percent': pct,
      'engine_version': '2.0.0',
      'engine_settings': {
        'normalizer': 'v1', 'fuzzy': true, 'ngrams': true, 'lemma': true,
      },
    }).select('id').single())['id'];

    final detailsPayload = <Map<String, dynamic>>[];
    for (final qr in qResults) {
      for (var i = 0; i < qr.points.length; i++) {
        final pe = qr.points[i];
        final pId = deps.pointsByQuestion[qr.questionId]![i].id;
        detailsPayload.add({
          'correction_id': corrId,
          'question_id': qr.questionId,
          'point_id': pId,
          'status': pe.status.name,
          'score': pe.score,
          'weight': pe.weight,
          'group_matches': pe.groupMatches.map((g) => g.toJson()).toList(),
        });
      }
    }
    if (detailsPayload.isNotEmpty) {
      await sb.from('cas_pratique_correction_details').insert(detailsPayload);
    }

    return Correction(
      id: corrId,
      attemptId: attemptId,
      totalScore: total,
      totalMax: max,
      percent: pct,
      questionResults: qResults,
    );
  }
}
```

---

## 3. Tests & qualité

### 3.1. Suite de tests obligatoires (T044)

**50+ cas dans `test/cas_pratique/`** :

| Catégorie               | # tests | Exemples                                                  |
|-------------------------|---------|-----------------------------------------------------------|
| Normalisation           | 10      | accents, ponctuation, NBSP, casse, ligatures              |
| Tokenization            | 5       | unigrams, bigrams, trigrams                               |
| Lemmatisation           | 8       | conjugaisons régulières, pluriels, féminins               |
| Levenshtein             | 5       | distance 0/1/2, early exit, mots courts                   |
| Keyword exact           | 5       | match littéral, casse, ponctuation                        |
| Keyword fuzzy           | 5       | fautes de frappe acceptables vs refusées                  |
| Keyword phrase          | 3       | expressions multi-mots                                    |
| Keyword negation        | 3       | "ne pas faire X" vs "faire X"                             |
| Synonymes               | 3       | dict mutualisé, fallback                                  |
| Point evaluation        | 5       | covered/partial/missing avec groupes ET                   |
| Question scoring        | 3       | normalisation à max_points                                |
| Régression cas legacy   | 6       | un test par cas legacy (T029)                             |

### 3.2. Benchmark (T045)

| Hardware              | Cible       |
|-----------------------|-------------|
| Pixel 4a              | < 80 ms     |
| iPhone SE 2020        | < 60 ms     |
| Pixel 8 / iPhone 14   | < 25 ms     |

Mesure : 1 cas, 3 questions, 9 points, 25 groupes, 250 keywords résolus, réponse user 2000 caractères.

---

## 4. Versioning & migration

- `engine_version` est stocké dans chaque correction
- Si on change la logique du moteur (ex: changement seuil partial 50 → 60 %) → bump version
- L'admin peut **re-corriger** une attempt avec une nouvelle version (utile après ajout de keywords via appel)

---

## 5. Auto-amélioration via les appels (boucle T076)

```
User soumet réponse
   │
   ▼
Engine v2.0.0 → score 10/15 (1 point manqué : "informer victime de Y")
   │
   ▼
User fait appel : "j'ai écrit 'la victime sera tenue informée' → ça veut dire la même chose"
   │
   ▼
Admin reçoit l'appel + voit la réponse user + voit le point attendu + voit les keywords actuels
   │
   ▼
Admin clique "Approuver" → ajoute keyword "tenue informee" (variation phrase) au bon group
   │
   ▼
Engine re-corrige l'attempt → score remonte à 11/15
   │
   ▼
Notification user : "Ton score est passé à 11/15"
   │
   ▼
La prochaine fois qu'un user écrit "tenue informée" → auto-match
```

**Effet réseau** : plus le système est utilisé, plus il devient précis. Sans coût marginal pour Kaïs (juste valider/rejeter).

---

## 6. Garde-fous & cas limites

| Cas limite                              | Comportement                                                |
|-----------------------------------------|-------------------------------------------------------------|
| Réponse vide                            | Score 0, status `missing` partout                           |
| Réponse copy-paste de la question       | Pas de match (les questions ne contiennent pas les keywords)|
| Réponse en MAJUSCULES                   | Normalisation s'en occupe                                   |
| Réponse avec emojis                     | Strip ponctuation s'en occupe                               |
| Réponse en anglais                      | Aucun match → score 0 (comportement attendu)                |
| Réponse de 50 000 caractères            | Limiter normalizer à 10 000 chars (perfo)                   |
| Keywords du dict mis à jour pendant tentative | OK, snapshot pris au moment de la correction          |
| 2 corrections en parallèle              | Trigger UNIQUE sur `attempt_id` empêche les doubles         |
