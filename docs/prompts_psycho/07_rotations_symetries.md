# Prompt — Rotations & symétries

## Rôle
Tu es expert en psychométrie et géométrie des transformations, créateur de tests pour le concours de Gardien de la Paix (COP'IQ).

## Contexte
L'exercice **Rotations & symétries** est un test **VISUEL** : on présente un patron de cube déplié et on demande quel cube plié on obtient **après une rotation** ou **une symétrie** appliquée au patron. Inspiration directe : tests Selor / Gardien de la Paix.

**Format des questions** (impératif) :
- L'énoncé décrit la transformation (rotation 90°, symétrie axiale verticale, etc.).
- `figure_data` décrit le patron déplié de départ.
- Chaque option contient un sous-objet `folded` qui décrit les **3 faces visibles** du cube après pliage et transformation.
- `transformation_type` indique la transformation appliquée (`rotation`, `symetrie_axiale`, `symetrie_centrale`, `combinee`).

## Tâche
Génère **50 questions** au total, réparties :
- 17 niveau **Facile** (axes de symétrie de figures usuelles, rotations 90°/180°/360°)
- 17 niveau **Moyenne** (composition rotation + symétrie, lettres centro-symétriques)
- 16 niveau **Difficile** (rotations dans l'espace 3D, transformations imbriquées, axes obliques)

Distribue les sous-types (sur 50) :
- 17 questions sur les **axes de symétrie** (lettres, polygones, signes)
- 17 questions sur les **rotations** (angles, équivalences, conservation)
- 16 questions sur les **transformations combinées** ou **identités** (180° = symétrie centrale, etc.)

## Explanations — RÈGLE ABSOLUE
Chaque `explanation` doit faire **au moins 3 phrases** (60+ caractères) et :
1. nommer la transformation (rotation N°, symétrie axiale/centrale),
2. **décrire visuellement** ce qui se passe (« le 8 a deux axes de symétrie internes »),
3. donner la propriété mathématique sous-jacente (n côtés = n axes pour un polygone régulier, etc.).
Une explication type « C'est 4 » est rejetée.

## Schéma cible (table `tests_psyco_rotations_symetries`)

| Colonne | Type | Notes |
|---|---|---|
| `difficulty` | text NOT NULL | `Facile` / `Moyenne` / `Difficile` |
| `question` | text NOT NULL | La question |
| `prompt` | text | Description textuelle de la figure / contexte |
| `image_url` | text | null pour cette phase |
| `figure_data` | jsonb | null pour cette phase |
| `transformation_type` | text | `rotation` / `symétrie axiale` / `symétrie centrale` / `combinée` |
| `options` | jsonb NOT NULL | **Tableau d'objets `{key, label}`** |
| `answer` | text NOT NULL | La clé `"A"`, `"B"`, `"C"` ou `"D"` |
| `explanation` | text | Justification |
| `hint` | text | (optionnel) |

## Règles de qualité absolues

1. **Pas besoin d'image** : description textuelle suffisante.
2. **Options sous forme `{key, label}`** : 4 options A-D.
3. **`answer` = la clé** (pas le label).
4. **`transformation_type`** rempli pour chaque question.
5. **Précision géométrique** : les angles, axes, et termes sont rigoureux.
6. **Distracteurs plausibles** : erreurs courantes sur axes ou angles.
7. **Réponse incontestable**.

## Catalogue de questions

### Axes de symétrie de figures usuelles
- "Combien d'axes de symétrie possède un carré / un rectangle / un triangle équilatéral / un cercle / un hexagone régulier ?"
- "Laquelle de ces lettres a un axe de symétrie horizontal ? (B, A, M, R)"
- "Quel pictogramme routier n'a pas d'axe de symétrie ?"

### Rotations
- "Une rotation de 360° autour d'un point donne quelle figure ?"
- "Quel chiffre reste identique après une rotation de 180° ? (6, 8, 5, 3)"
- "Combien de rotations distinctes laissent un carré invariant ?"

### Transformations combinées / identités
- "Une rotation de 180° autour d'un point équivaut à quelle autre transformation ?"
- "Combiner deux symétries axiales d'axes parallèles équivaut à quoi ?"
- "Quelle est la lettre centro-symétrique parmi : N, M, X, R ?"

## Calibration par niveau

### Niveau Facile
- Axes de symétrie de polygones réguliers évidents.
- Rotations directes : 90°, 180°, 360°.
- Lettres avec un seul axe de symétrie clair.

### Niveau Moyenne
- Symétrie centrale = rotation 180°.
- Lettres centro-symétriques : H, I, N, O, S, X, Z.
- Axes obliques.
- Distinction symétrie axiale / centrale.

### Niveau Difficile
- Compositions de transformations.
- Rotations 3D : axe vertical d'une lettre 3D.
- Conservation des chiralités.
- Sens horaire / anti-horaire et conséquences.

## Format de sortie EXIGÉ — cube + transformation (PRIORITAIRE)

Renvoie **strictement** un tableau JSON valide (UTF-8). Pas de texte hors JSON.
La majorité des questions doivent suivre ce format **cube + transformation** :

```json
[
  {
    "difficulty": "Moyenne",
    "question": "Quel cube obtient-on après rotation de 90° du patron autour de son axe vertical, puis pliage ?",
    "prompt": "Patron de départ : croix latine, 6 symboles distincts.",
    "transformation_type": "rotation",
    "figure_data": {
      "type": "cube_net",
      "layout": "cross",
      "faces": {
        "top":    "★",
        "bottom": "●",
        "left":   "◆",
        "right":  "■",
        "front":  "▲",
        "back":   "▼"
      }
    },
    "options": [
      {"key": "A", "label": "Cube A", "folded": {"top": "★", "front": "■", "right": "▼"}},
      {"key": "B", "label": "Cube B", "folded": {"top": "★", "front": "▲", "right": "■"}},
      {"key": "C", "label": "Cube C", "folded": {"top": "●", "front": "▲", "right": "■"}},
      {"key": "D", "label": "Cube D", "folded": {"top": "★", "front": "◆", "right": "▼"}}
    ],
    "answer": "A",
    "explanation": "Une rotation de 90° (sens horaire vu du dessus) déplace : front → right → back → left → front. Donc front=▲ devient right, right=■ devient back, back=▼ devient left, left=◆ devient front. Une fois plié, on voit top=★, front=■ (ancien right), right=▼ (ancien back). Seul le cube A correspond. B = sans rotation, C = top inversé, D = symétrie au lieu de rotation.",
    "hint": "Visualise la rotation avant le pliage."
  },
  {
    "difficulty": "Facile",
    "question": "Combien d'axes de symétrie possède un carré ?",
    "prompt": null,
    "transformation_type": "symetrie_axiale",
    "options": [
      {"key": "A", "label": "2"},
      {"key": "B", "label": "3"},
      {"key": "C", "label": "4"},
      {"key": "D", "label": "8"}
    ],
    "answer": "C",
    "explanation": "Un carré possède 4 axes de symétrie : 2 médianes (horizontale et verticale) et 2 diagonales.",
    "hint": "Pense aux médianes ET aux diagonales."
  },
  {
    "difficulty": "Facile",
    "question": "Une rotation de 360° autour d'un point donne :",
    "prompt": null,
    "transformation_type": "rotation",
    "options": [
      {"key": "A", "label": "La figure de départ"},
      {"key": "B", "label": "Une figure inversée"},
      {"key": "C", "label": "Une figure agrandie"},
      {"key": "D", "label": "Une figure déplacée"}
    ],
    "answer": "A",
    "explanation": "Un tour complet (360°) ramène toujours la figure à sa position initiale.",
    "hint": null
  },
  {
    "difficulty": "Moyenne",
    "question": "Une rotation de 180° autour d'un point équivaut à quelle autre transformation ?",
    "prompt": null,
    "transformation_type": "combinée",
    "options": [
      {"key": "A", "label": "Une symétrie centrale"},
      {"key": "B", "label": "Une translation"},
      {"key": "C", "label": "Une homothétie"},
      {"key": "D", "label": "Une symétrie axiale"}
    ],
    "answer": "A",
    "explanation": "La rotation de 180° autour d'un point O et la symétrie centrale par rapport à O produisent exactement la même image.",
    "hint": "Une rotation d'un demi-tour..."
  },
  {
    "difficulty": "Moyenne",
    "question": "Quel chiffre reste identique après une rotation de 180° autour de son centre ?",
    "prompt": "On considère les chiffres dessinés en typographie standard.",
    "transformation_type": "rotation",
    "options": [
      {"key": "A", "label": "6"},
      {"key": "B", "label": "8"},
      {"key": "C", "label": "5"},
      {"key": "D", "label": "3"}
    ],
    "answer": "B",
    "explanation": "Le 8 est centro-symétrique : retourné de 180°, il reste identique. Le 6 devient 9 ; le 5 et le 3 ne sont pas symétriques.",
    "hint": "Cherche le chiffre qui se lit pareil à l'envers."
  },
  {
    "difficulty": "Difficile",
    "question": "Combien d'axes de symétrie possède un hexagone régulier ?",
    "prompt": null,
    "transformation_type": "symétrie axiale",
    "options": [
      {"key": "A", "label": "3"},
      {"key": "B", "label": "6"},
      {"key": "C", "label": "8"},
      {"key": "D", "label": "12"}
    ],
    "answer": "B",
    "explanation": "Un polygone régulier à n côtés possède exactement n axes de symétrie. Pour un hexagone régulier (n = 6) : 6 axes (3 passant par les sommets opposés, 3 par les milieux des côtés opposés).",
    "hint": "n côtés = n axes."
  }
]
```

## Règles cube + transformation

- `layout` ∈ `cross`, `T`, `L`, `Z`, `line`. `cross` reste majoritaire.
- `faces` : exactement 6 clés (`top`, `bottom`, `left`, `right`, `front`, `back`), symboles tous différents.
- `transformation_type` ∈ `rotation`, `symetrie_axiale`, `symetrie_centrale`, `combinee` (sans accent ni espace).
- Chaque option a `key` (A-D), `label`, `folded` (top/front/right). Une seule cohérente.
- Mix recommandé sur 50 :
  - 35 questions cube + transformation (visuelles)
  - 10 questions axes de symétrie / propriétés théoriques (texte simple)
  - 5 questions hybrides (analyse de transformation + raisonnement)

## Anti-patterns à éviter

- ❌ Question visuelle sans `figure_data` valable.
- ❌ `answer` qui ne correspond pas à une clé du tableau.
- ❌ `transformation_type` absent ou incohérent.
- ❌ `folded` qui contredit toutes les rotations valides du patron.
- ❌ Symboles dupliqués entre faces (rend la réponse ambiguë).

## Sortie attendue

Démarre directement par `[`. Pas d'introduction, pas de conclusion.
