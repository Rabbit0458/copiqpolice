# 🧪 COP'IQ — Cas Pratique — Plan de tests & QA

> Plan de tests ultra-complet pour garantir que le module Cas Pratique est fiable, robuste et qualité production. Couvre tests unitaires, intégration, E2E, performance, et tests utilisateurs.

---

## 1. Pyramide des tests

```
                     ┌──────────────────┐
                     │   E2E (5 %)       │   ~10 scénarios critiques
                     │   Patrol / Maestro│
                     └──────────────────┘
                  ┌──────────────────────┐
                  │  Intégration (15 %)   │   ~30 tests
                  │  Repository, Supabase │
                  └──────────────────────┘
              ┌──────────────────────────┐
              │   Widget tests (20 %)     │   ~50 tests
              │   Composants UI isolés    │
              └──────────────────────────┘
       ┌────────────────────────────────┐
       │   Unit tests (60 %)             │   ~150 tests
       │   Engine, Models, Helpers       │
       └────────────────────────────────┘
```

---

## 2. Tests unitaires obligatoires

### 2.1. Engine (`test/cas_pratique/engine/`)

| Fichier              | Tests                                                             | Coverage cible |
|----------------------|-------------------------------------------------------------------|----------------|
| `normalizer_test.dart` | NFD, accents, ligatures, ponctuation, NBSP, casse, longueurs limites | 100 %          |
| `tokenizer_test.dart`  | tokens vides, unigrams, bigrams, trigrams, tokens à 1 char         | 100 %          |
| `lemmatizer_test.dart` | suffixes courants, mots courts, mots irréguliers (acceptables)     | 95 %           |
| `levenshtein_test.dart`| distance 0/1/2, perfo early exit, mots vides                       | 100 %          |
| `keyword_matcher_test.dart` | exact, fuzzy, phrase, négation, dictionnaire                | 95 %           |
| `synonym_resolver_test.dart` | dict valide, dict manquant, fallback                       | 100 %          |
| `negation_detector_test.dart` | "ne pas X", "pas X", "jamais X", fenêtre 5 tokens         | 100 %          |
| `point_evaluator_test.dart` | covered/partial/missing, groupes optionnels, weights         | 95 %           |
| `question_scorer_test.dart` | normalisation à max_points, somme pondérée                  | 100 %          |
| `attempt_scorer_test.dart` | persist correction + details, errors                         | 90 %           |

### 2.2. Cas de figure clés (snapshot tests)

Pour chaque cas legacy (case_1 à case_6), un fixture par scénario :

| Fixture                          | Score attendu | Notes                                  |
|----------------------------------|---------------|----------------------------------------|
| `case_1_perfect.json`             | 15/15         | Réponse parfaite copiée                |
| `case_1_good.json`                | 12-13/15      | Bonne réponse, formulation libre       |
| `case_1_partial_q1.json`          | 8-10/15       | Q1 partielle, Q2/Q3 OK                 |
| `case_1_no_keywords.json`         | 0/15          | Réponse hors-sujet                     |
| `case_1_empty.json`               | 0/15          | Toutes réponses vides                  |
| `case_1_typos.json`               | 12-13/15      | Bonnes réponses avec fautes de frappe  |
| `case_1_negation_trap.json`       | 8-10/15       | "je ne dégrade pas" ne match pas       |
| `case_1_synonym_dict_used.json`   | 13-14/15      | User utilise des termes du dict        |

---

## 3. Tests widget (`test/cas_pratique/widgets/`)

| Composant              | Scénarios                                                        |
|------------------------|------------------------------------------------------------------|
| `AnswerTextArea`       | Vide / rempli / max length / focus state / autosave indicator     |
| `ScoreReveal`          | 0/15, 7/15, 12/15, 15/15, animation respecte reduceMotion         |
| `PointPill`            | covered, partial, missing, expand/collapse                        |
| `AppealSheet`          | Open, send, cancel, validation message vide                       |
| `ThemeBadge`           | Chaque thème avec sa couleur                                      |
| `DifficultyChip`       | Facile, Moyen, Difficile                                          |
| `CasPratiqueCard`      | Light/Dark, locked/done/ready                                     |

---

## 4. Tests d'intégration (`integration_test/`)

### 4.1. Repository ↔ Supabase

- `repository_list_cases_test.dart` : pull cases, vérifier filtre `published`
- `repository_start_attempt_test.dart` : crée une attempt, vérifie row
- `repository_save_answer_test.dart` : insert + update (draft → validated)
- `repository_finish_attempt_test.dart` : engine + persist, vérifier corrections + details
- `repository_create_appeal_test.dart` : insert avec FK valide
- `repository_admin_approve_appeal_test.dart` : admin → keyword auto-added

### 4.2. RLS

- `rls_user_cant_read_others_data_test.dart`
- `rls_user_cant_modify_admin_tables_test.dart`
- `rls_admin_full_access_test.dart`
- `rls_draft_case_invisible_to_user_test.dart`

### 4.3. Trigger update_user_progress

- Insérer correction → vérifier que `cas_pratique_user_progress.avg_score_percent` est mis à jour
- Insérer 2 corrections → vérifier moyenne correcte
- Cas où user_id n'existe pas → trigger ne crashe pas

---

## 5. Tests E2E (`integration_test/e2e/`)

Outil : `patrol` ou `flutter_driver` ou `maestro`.

### Scénarios critiques

1. **Happy path complet** : login → liste cas → cas n°1 → 3 questions → correction → score affiché
2. **Lock après validation** : valider Q2 → tenter de revenir à Q1 → snackbar warning
3. **Auto-save** : taper du texte → fermer l'app → rouvrir → texte préservé
4. **Mode offline** : couper le wifi → faire un cas en cache → reconnecter → sync OK
5. **Faire appel** : finir un cas avec un point manqué → faire appel → message envoyé
6. **Filtres liste** : appliquer filtre thème → liste se met à jour
7. **Recherche** : taper "cambriolage" → cas pertinents apparaissent
8. **Dark mode** : switcher en dark → toutes les pages OK
9. **Light mode** : switcher en light → toutes les pages OK
10. **Reduce motion** : activer dans iOS settings → aucune animation joue

---

## 6. Tests performance

### 6.1. Engine

| Mesure                                 | Cible          |
|----------------------------------------|----------------|
| 1 cas (3 Q, 9 points, 250 keywords)    | < 80 ms        |
| 100 corrections en série               | < 8 s          |
| Mémoire pendant correction             | < 50 MB        |

### 6.2. UI

| Mesure                                  | Cible          |
|-----------------------------------------|----------------|
| Frame rate liste (scroll)               | ≥ 60 fps       |
| Frame rate page question (typing)       | ≥ 60 fps       |
| Frame rate page correction (animation)  | ≥ 55 fps       |
| Time to interactive (cold start)        | < 2.5 s        |
| Page transition                         | ≤ 320 ms       |

### 6.3. Réseau

| Mesure                                  | Cible          |
|-----------------------------------------|----------------|
| Pull liste 50 cas                       | < 800 ms (4G)  |
| Pull détail cas + rubrics complète      | < 600 ms (4G)  |
| Save answer                             | < 400 ms       |
| Finish + correction                     | < 1.5 s total  |

---

## 7. Matrice de compatibilité

| Device                | OS         | Test prioritaire ?                              |
|-----------------------|------------|-------------------------------------------------|
| iPhone SE 2020        | iOS 16+    | ✅ (petit écran)                                 |
| iPhone 14 Pro         | iOS 17+    | ✅                                               |
| iPhone 15             | iOS 17+    | ✅                                               |
| iPad Pro 11"          | iPadOS 17+ | ⚠️ (acceptable si fonctionnel)                  |
| Pixel 4a              | Android 13 | ✅ (entry-level)                                 |
| Pixel 8               | Android 14 | ✅                                               |
| Galaxy A52            | Android 13 | ✅ (gros marché)                                 |
| Galaxy S23            | Android 14 | ⚠️                                              |
| Foldable              | Android 14 | ❌ (post-MVP)                                    |

---

## 8. Tests utilisateurs (UAT)

### 8.1. Avant publication d'un cas

Sur chaque cas créé via le panel admin, le mode Preview (T089) permet de tester comme un user. Vérifier :
- [ ] Le texte de la mise en situation est lisible (pas de coupure bizarre)
- [ ] Les questions sont claires et actionnables
- [ ] Les `char_recommended` sont réalistes
- [ ] La rubric matche bien sur 3-5 réponses fictives variées (Kaïs en tape 5 dans le panel preview)
- [ ] Le score final paraît juste

### 8.2. Beta testing

Avant de pousser en prod 50+ cas, faire tester par 10-15 candidats :
- Recruter sur Discord ou réseau direct
- Donner accès à 5 cas pratiques
- Récolter feedback : score juste ? formulation claire ? bug ? idée ?
- Itérer 2 cycles avant d'ouvrir au grand public

### 8.3. KPIs à monitorer post-launch

| KPI                                  | Source                                  |
|--------------------------------------|-----------------------------------------|
| Taux de complétion par cas           | corrections / attempts                  |
| Score moyen par cas                  | avg(corrections.percent) by case        |
| Taux d'appel par cas                 | appeals / corrections                   |
| Temps moyen par question             | derived from answers timestamps         |
| Drop-off par question                | answers count by question_id            |
| Taux d'approbation des appels        | approved / total appeals                |
| Crashes / erreurs                    | Sentry / Crashlytics                    |

---

## 9. Checklist de validation par tâche

### T029 — Test de régression cas legacy

```
Pour chaque cas (case_1 à case_6) :
  - [ ] Charger le cas depuis la DB
  - [ ] Coller la "réponse parfaite" du fichier Dart legacy
  - [ ] Lancer le moteur v2.0.0
  - [ ] Score doit être >= ce qu'aurait donné l'engine v1 (toujours)
  - [ ] Tolérance : ±1 point maximum
  - [ ] Si écart, identifier la cause et corriger les keywords AVANT de continuer
```

### T045 — Benchmark perfo

```
- [ ] Pixel 4a : < 80 ms
- [ ] iPhone SE : < 60 ms
- [ ] iPhone 14 : < 25 ms
- [ ] Si dépassé : profiler, optimiser cache, indexation tokens
```

### T060 — Suppression définitive des fichiers legacy

```
- [ ] Tous les cas affichés et corrigés via case_dynamic_page
- [ ] Test E2E happy path passe
- [ ] Aucune référence à case_1_page.dart ... case_6_page.dart dans le code
- [ ] flutter analyze 0 issue
- [ ] flutter build android / ios passe sans erreur
```

---

## 10. Outils & CI

### 10.1. CI workflow GitHub Actions

```yaml
# .github/workflows/cas-pratique-tests.yml (à créer en T044)
name: Cas Pratique Tests
on: [push, pull_request]
jobs:
  unit:
    runs-on: ubuntu-latest
    steps:
      - uses: subosito/flutter-action@v2
      - run: flutter test test/cas_pratique/ --coverage
      - run: bash <(curl -s https://codecov.io/bash)
  widget:
    runs-on: ubuntu-latest
    steps:
      - uses: subosito/flutter-action@v2
      - run: flutter test test/cas_pratique/widgets/
  integration:
    runs-on: macos-latest
    steps:
      - uses: subosito/flutter-action@v2
      - run: flutter test integration_test/cas_pratique/ -d macos
```

### 10.2. Local checks avant commit

```bash
flutter analyze
flutter test
flutter format lib/ test/ --set-exit-if-changed
```

---

## 11. Acceptance criteria globaux du module

Avant de considérer le module **Cas Pratique v2.0** "ready for production" :

- [ ] 110 / 110 tâches `[x]`
- [ ] Coverage tests unit ≥ 80 %
- [ ] Aucune erreur `flutter analyze`
- [ ] Tous les tests E2E passent sur 3 devices (iPhone SE, Pixel 4a, iPhone 14)
- [ ] 6 cas legacy migrés et fonctionnels (T029 OK)
- [ ] Au moins 5 nouveaux cas créés via le panel admin (validation du flow admin)
- [ ] Au moins 10 utilisateurs beta testers ayant complété ≥ 3 cas chacun
- [ ] Score moyen beta ≥ 60 % (signe que le moteur n'est pas trop sévère)
- [ ] Taux d'appel < 10 % (signe que le moteur n'est pas aberrant)
- [ ] Dashboard admin opérationnel (KPIs visibles)
- [ ] Documentation à jour (les 7 fichiers de référence)
- [ ] Roadmap post-MVP rédigée
