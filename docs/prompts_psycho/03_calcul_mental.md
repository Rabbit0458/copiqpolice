# Prompt — Calcul mental

## Rôle
Tu es expert en psychométrie et créateur de tests d'aptitude pour le concours de Gardien de la Paix (COP'IQ).

## Contexte
L'exercice **Calcul mental** présente une opération arithmétique à résoudre rapidement de tête, sans calculatrice ni papier. Le candidat doit choisir la bonne réponse parmi 4 propositions.
Cet exercice évalue la rapidité, la précision arithmétique et l'aisance avec les nombres.

## Tâche
Génère **50 questions** au total, réparties :
- 17 niveau **Facile** (calculs en 5-10 secondes)
- 17 niveau **Moyenne** (calculs en 15-25 secondes)
- 16 niveau **Difficile** (calculs en 25-40 secondes, opérations combinées)

## Explanations — RÈGLE ABSOLUE
Chaque `explanation` doit faire **au moins 3 phrases** (60+ caractères) et :
1. **poser le calcul intermédiaire** (`17 + 28 = (17+30) - 2 = 47 - 2 = 45`),
2. expliciter l'astuce mentale utilisée (arrondi à la dizaine, distributivité, etc.),
3. mentionner le piège classique (oubli de retenue, mauvaise priorité d'opérations, % mal interprété).
Une explication type `45 = 17+28` est insuffisante.

## Schéma cible (table `tests_psyco_calcul_mental`)

| Colonne | Type | Notes |
|---|---|---|
| `difficulty` | text NOT NULL | `Facile` / `Moyenne` / `Difficile` |
| `question` | text NOT NULL | Énoncé en français : "Combien font 17 + 28 ?" |
| `expression` | text | Forme symbolique : `17 + 28` (peut être null) |
| `options` | text[] NOT NULL | **Exactement 4 options**. La bonne réponse doit y être présente. |
| `answer` | text NOT NULL | Doit être strictement identique à un élément de `options` |
| `explanation` | text | Justification : étapes du calcul ou astuce mentale |
| `hint` | text | Indice / astuce pour calculer plus vite |

## Règles de qualité absolues

1. **Réponse unique et exacte** : un seul résultat correct par question.
2. **Distracteurs réalistes** : les 3 mauvaises options correspondent à des erreurs typiques (oubli de retenue, signe inversé, mauvaise table de multiplication).
3. **Réponse présente dans `options`** : `answer` est strictement égale à une chaîne du tableau.
4. **Pas de calculs absurdes** : reste sur des nombres et résultats accessibles à un candidat de niveau bac.
5. **Variété des opérations** sur 30 questions : équilibre entre additions, soustractions, multiplications, divisions, pourcentages, fractions simples.
6. **Format des nombres** : utilise les conventions françaises (`,` comme séparateur décimal si besoin). Pas de notation anglo-saxonne.
7. **Explication pédagogique** : montre l'astuce (ex : arrondir aux dizaines puis ajuster).

## Calibration par niveau

### Niveau Facile (5-10 sec)
- Additions à deux chiffres sans retenue : `23 + 41`
- Soustractions à deux chiffres simples : `48 - 23`
- Tables de multiplication 1-10 : `7 × 8`, `9 × 6`
- Divisions exactes simples : `48 / 6`, `81 / 9`
- Pourcentages "ronds" : 10 %, 25 %, 50 %, 100 % de 80
- Doublements ou moitiés : `34 × 2`, `66 / 2`

### Niveau Moyenne (15-25 sec)
- Additions à 3 chiffres avec retenue : `347 + 286`
- Soustractions à 3 chiffres : `812 - 347`
- Multiplications par 11, 12, 13, 14, 15
- Multiplications nombre × dizaine : `27 × 30`
- Divisions à reste : `145 / 5`
- Pourcentages : 15 %, 20 %, 30 %, 75 % de nombres ronds
- Carrés des nombres < 20 : `13², 17², 19²`
- Conversions simples : minutes/heures, mètres/km

### Niveau Difficile (25-40 sec)
- Opérations combinées : `(47 × 8) - 76`, `12 × 9 + 25`
- Multiplications à 2 chiffres : `23 × 17`, `48 × 25`
- Pourcentages composés : `8 % de 250`, `35 % de 180`
- Fractions : `2/3 de 81`, `5/8 de 240`
- Puissances simples : `2^7`, `3^4`
- Racines exactes : `√144`, `√225`, `√289`
- Suites d'opérations en chaîne : `(35 + 17) × 2 - 14`
- Conversions complexes : km/h ↔ m/s

## Format de sortie EXIGÉ

Renvoie **strictement** un tableau JSON valide (UTF-8). Pas de texte hors du JSON.

```json
[
  {
    "difficulty": "Facile",
    "question": "Combien font 17 + 28 ?",
    "expression": "17 + 28",
    "options": ["43", "45", "47", "55"],
    "answer": "45",
    "explanation": "17 + 28 = (17 + 30) − 2 = 47 − 2 = 45.",
    "hint": "Arrondis 28 à 30 puis ajuste."
  },
  {
    "difficulty": "Moyenne",
    "question": "Combien font 25 % de 480 ?",
    "expression": "0,25 × 480",
    "options": ["110", "115", "120", "125"],
    "answer": "120",
    "explanation": "25 % = 1/4. Donc 480 / 4 = 120.",
    "hint": "25 % d'un nombre = ce nombre divisé par 4."
  },
  {
    "difficulty": "Difficile",
    "question": "Combien font (47 × 8) − 76 ?",
    "expression": "(47 × 8) − 76",
    "options": ["276", "290", "300", "312"],
    "answer": "300",
    "explanation": "47 × 8 = 376 ; 376 − 76 = 300.",
    "hint": "Calcule d'abord la multiplication puis soustrais."
  }
]
```

## Anti-patterns à éviter

- ❌ Réponse non-entière sauf si l'énoncé précise `valeur décimale`.
- ❌ Distracteurs très éloignés (45 vs 1000).
- ❌ Multiplications obligeant à poser la division (ex : `347 × 89` est trop dur de tête).
- ❌ Pourcentages "non ronds" (`23 %`, `41 %`) sauf en `Difficile`.
- ❌ Plus de 4 questions du même type d'opération sur les 30.
- ❌ Réponse absente de `options`.

## Distribution suggérée des opérations (sur 30 questions)

| Type | Facile | Moyenne | Difficile | Total |
|---|---|---|---|---|
| Addition | 2 | 2 | 1 | 5 |
| Soustraction | 2 | 2 | 1 | 5 |
| Multiplication | 2 | 2 | 2 | 6 |
| Division | 2 | 1 | 1 | 4 |
| Pourcentage | 1 | 1 | 1 | 3 |
| Carré / racine | 1 | 1 | 1 | 3 |
| Combinées | 0 | 1 | 3 | 4 |

## Sortie attendue

Démarre directement par `[`. Aucune introduction, aucune conclusion.
