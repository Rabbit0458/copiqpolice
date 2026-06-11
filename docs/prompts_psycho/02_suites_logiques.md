# Prompt — Suites logiques

## Rôle
Tu es expert en psychométrie et créateur de tests d'aptitude pour le concours de Gardien de la Paix. Tu écris pour l'application COP'IQ.

## Contexte
L'exercice **Suites logiques** présente une suite de nombres (ou parfois de lettres) avec un terme manquant marqué `?`. Le candidat doit identifier la **règle de progression** et trouver la valeur manquante.
Cet exercice évalue le raisonnement numérique, la détection de patterns et la capacité d'abstraction.

## Tâche
Génère **50 questions** au total, réparties :
- 17 niveau **Facile** (1 opération récurrente)
- 17 niveau **Moyenne** (2 règles combinées ou alternance)
- 16 niveau **Difficile** (règles imbriquées, suites de Fibonacci, suites quadratiques, lettres décalées, etc.)

## Explanations — RÈGLE ABSOLUE
Chaque `explanation` doit faire **au moins 3 phrases** (60+ caractères) et :
1. nommer la règle (« progression arithmétique +3 », « Fibonacci », etc.),
2. **détailler le calcul** du terme manquant (`8 + 5 = 13`),
3. signaler le piège typique (confusion avec une autre suite, mauvaise différence, etc.).
Une explication type « Suite +3 » est inacceptable.

## Schéma cible (table `tests_psyco_suite_logique`)

| Colonne | Type | Notes |
|---|---|---|
| `difficulty` | text NOT NULL | `Facile` / `Moyenne` / `Difficile` |
| `sequence_text` | text NOT NULL | La suite avec un `?` à la place du terme manquant. Ex: `2, 4, 8, 16, ?` |
| `prompt` | text | Énoncé court, par défaut `"Quel terme manque ?"` |
| `options` | text[] NOT NULL | 4 propositions, dont la bonne |
| `answer` | text NOT NULL | La bonne réponse, **doit être présente dans options** |
| `explanation` | text | Explique la règle de progression |
| `hint` | text | (facultatif) Indice : nom de la règle ou indication |

## Règles de qualité absolues

1. **Une seule règle valable** : la suite ne doit pas admettre deux règles concurrentes qui mènent à des réponses différentes.
2. **Le terme manquant doit être dans la suite à des positions variées** (parfois début, milieu, fin — pas toujours à la fin).
3. **Les distracteurs (mauvaises options) doivent être plausibles** : résultats d'erreurs typiques (ex : oubli du +1, mauvaise multiplication).
4. **Réponse présente dans options** : la chaîne `answer` est strictement identique à un élément du tableau `options`.
5. **4 options exactement** par question.
6. **Variété des règles** sur les 30 questions : ne répète jamais le même type plus de 3 fois.
7. **Explication pédagogique** : expose la règle (`+3 à chaque terme`), donne le calcul du terme manquant.

## Catalogue des règles autorisées

### Niveau Facile
- Progression arithmétique : `+1, +2, +3, +4, +5, +10, +12`
- Suite multiplicative simple : `×2, ×3, ×5`
- Soustraction constante : `-3, -5`
- Carrés simples : `1, 4, 9, 16, 25, 36`
- Multiples : table de 7, table de 8
- Pairs/impairs alternés

### Niveau Moyenne
- Progression de progression : `+2, +4, +6, +8...`
- Multiplication puis addition : `×2 +1`
- Alternance de deux règles : `+2, ×2, +2, ×2`
- Carrés moins 1 ou plus 1
- Suite de différences : `1, 3, 6, 10, 15, ?` (différences `+2, +3, +4, +5, +6`)
- Multiples de 11, 13, 17
- Lettres en saut de N positions (`A, C, E, G, ?`)

### Niveau Difficile
- Suite de Fibonacci ou variantes
- Suite des nombres premiers
- Suites quadratiques `n² + n`, `n² - 1`
- Suites combinées (somme + multiplication imbriquées)
- Alternance lettres/chiffres
- Cubes (1, 8, 27, 64, ?)
- Suite avec règle implicite (somme des chiffres, position alphabétique)
- Lettres avec décalage croissant : `A, C, F, J, O, ?` (+2, +3, +4, +5, +6)

## Format de sortie EXIGÉ

Renvoie **strictement** un tableau JSON valide (UTF-8). Pas de texte avant ou après. Pas de markdown.

```json
[
  {
    "difficulty": "Facile",
    "sequence_text": "2, 4, 8, 16, ?",
    "prompt": "Quel terme manque ?",
    "options": ["24", "32", "30", "20"],
    "answer": "32",
    "explanation": "Chaque terme est multiplié par 2. Le terme manquant est 16 × 2 = 32.",
    "hint": "Cherche le coefficient multiplicateur."
  },
  {
    "difficulty": "Moyenne",
    "sequence_text": "1, 3, 6, 10, ?, 21",
    "prompt": "Quel nombre complète la suite ?",
    "options": ["13", "14", "15", "16"],
    "answer": "15",
    "explanation": "Les différences augmentent de 1 : +2, +3, +4, +5, +6. Donc 10 + 5 = 15.",
    "hint": "Étudie la suite des différences."
  },
  {
    "difficulty": "Difficile",
    "sequence_text": "1, 1, 2, 3, 5, 8, ?, 21",
    "prompt": "Quel terme manque ?",
    "options": ["11", "12", "13", "14"],
    "answer": "13",
    "explanation": "Suite de Fibonacci : chaque terme est la somme des deux précédents. 5 + 8 = 13.",
    "hint": "Pense à une suite célèbre où chaque terme dépend des précédents."
  }
]
```

## Anti-patterns à éviter

- ❌ Suite avec deux règles également valides (ambiguïté).
- ❌ Réponse absente du tableau `options`.
- ❌ Distracteurs trop éloignés (réponse 32, distracteurs 100, 1000) — préfère des erreurs proches.
- ❌ Toujours mettre le `?` à la dernière position.
- ❌ Sequence_text vide ou sans `?`.
- ❌ Plus de 3 occurrences du même type de règle dans les 30 questions.

## Variantes de positions du `?`

- `?, 4, 6, 8, 10` (en début)
- `2, ?, 6, 8, 10` (en deuxième)
- `2, 4, ?, 8, 10` (au milieu)
- `2, 4, 6, ?, 10` (avant-dernier)
- `2, 4, 6, 8, ?` (à la fin)

Distribue ces positions équitablement sur l'ensemble des 30 questions.

## Sortie attendue

Démarre directement par `[` et termine par `]`. Aucune phrase d'introduction, aucune conclusion.
