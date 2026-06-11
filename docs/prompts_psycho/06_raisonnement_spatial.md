# Prompt — Raisonnement spatial

## Rôle
Tu es expert en psychométrie et géométrie, créateur de tests pour le concours de Gardien de la Paix (COP'IQ).

## Contexte
L'exercice **Raisonnement spatial** est un test **VISUEL** au format Selor / concours Gardien de la Paix. On affiche un **patron de cube déplié** (6 carrés étalés en croix, T, L, Z ou ligne) avec un symbole sur chaque face, et l'utilisateur doit choisir parmi 4 cubes pliés isométriques celui qui correspond.

**Format des questions** (impératif) :
- L'énoncé invite à plier mentalement le patron.
- `figure_data` décrit le patron déplié (6 faces).
- Chaque option contient un sous-objet `folded` qui décrit les **3 faces visibles** (top, front, right) du cube plié correspondant.
- Une seule des 4 options est cohérente avec le patron.

## Tâche
Génère **50 questions** au total, réparties :
- 17 niveau **Facile** (cube, cube déplié, faces, propriétés simples)
- 17 niveau **Moyenne** (pliages, vues, dénombrement de cubes empilés)
- 16 niveau **Difficile** (cubes peints découpés, intersections, projections)

Sous-types à distribuer (sur 50) :
- 13 questions sur les solides simples (cube, pyramide, cylindre, cône)
- 13 questions sur les patrons et pliages
- 10 questions sur les vues (face, profil, dessus)
- 14 questions sur les empilements et découpages (cube N×N×N)

## Explanations — RÈGLE ABSOLUE
Chaque `explanation` doit faire **au moins 3 phrases** (60+ caractères) et :
1. décrire mentalement la transformation (pliage, dépliage, découpage),
2. **donner les chiffres clés** (12 arêtes × 1 cube par arête = 12),
3. rappeler la règle géométrique mobilisée (formule, symétrie, propriété).
Une explication type « 6 faces » est rejetée.

## Schéma cible (table `tests_psyco_raisonnement_spatial`)

| Colonne | Type | Notes |
|---|---|---|
| `difficulty` | text NOT NULL | `Facile` / `Moyenne` / `Difficile` |
| `question` | text NOT NULL | La question principale |
| `prompt` | text | Description textuelle de la figure / situation (peut remplacer une image) |
| `image_url` | text | null pour cette phase, à remplir plus tard |
| `figure_data` | jsonb | null pour cette phase |
| `options` | jsonb NOT NULL | **Tableau d'objets `{key, label}`** : `[{"key":"A","label":"6"}, ...]` |
| `answer` | text NOT NULL | La **clé** (`"A"`, `"B"`, `"C"` ou `"D"`) de la bonne réponse |
| `explanation` | text | Justification |
| `hint` | text | (optionnel) |

## Règles de qualité absolues

1. **Pas besoin d'image** : la description textuelle dans `prompt` doit suffire à comprendre.
2. **Options sous forme `{key, label}`** : 4 options A, B, C, D.
3. **`answer` = la clé**, pas le label : `"A"`, `"B"`, `"C"` ou `"D"`.
4. **Une seule réponse correcte**.
5. **Distracteurs réalistes** : les 3 mauvais labels sont des erreurs typiques.
6. **Variété de solides** : cube majoritaire mais aussi tétraèdre, prisme, cylindre.
7. **Vocabulaire géométrique correct** : face, arête, sommet, axe, patron.

## Catalogue de questions

### Solides simples
- "Combien de faces possède un cube ?"
- "Combien d'arêtes un tétraèdre régulier possède-t-il ?"
- "Combien de sommets a un prisme triangulaire ?"

### Patrons et pliages
- "Lequel de ces patrons ne forme pas un cube une fois plié ?"
- "Si je plie un carré sur sa diagonale, quelle figure obtient-on ?"
- "Sur le patron du cube en croix, quelle face est en face de la face notée 1 ?"

### Vues
- "Quelle est la vue de face d'un cylindre droit ?"
- "Vu de dessus, à quoi ressemble une pyramide à base carrée ?"

### Empilements et découpages
- "Si on coupe un cube 3×3×3 en cubes unitaires, combien ont 2 faces peintes ?"
- "Combien de petits cubes faut-il pour construire un cube de 4 d'arête ?"
- "Combien de cubes ne sont pas peints au centre d'un cube 4×4×4 peint ?"

## Calibration par niveau

### Niveau Facile
- Propriétés directement mémorisables : nombres de faces/arêtes/sommets des solides courants.
- Patrons élémentaires : "patron en croix latine = cube".

### Niveau Moyenne
- Pliages avec choix multiples (4 patrons, lequel ne forme pas un cube ?).
- Vues simples (de face/dessus/profil) d'un solide standard.
- Empilements 3×3×3.

### Niveau Difficile
- Empilements 4×4×4 ou 5×5×5.
- Comptage de cubes 0/1/2/3 faces peintes.
- Reconnaissance d'un patron complexe (T renversé, escalier).
- Intersections de plans, sections.

## Format de sortie EXIGÉ — pliage de cube (PRIORITAIRE)

Renvoie **strictement** un tableau JSON valide (UTF-8). Pas de texte hors JSON.
La majorité des questions doivent suivre ce format **cube net** :

```json
[
  {
    "difficulty": "Facile",
    "question": "Quel cube obtient-on en pliant ce patron ?",
    "prompt": "Le patron ci-dessus est plié pour former un cube.",
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
      {"key": "A", "label": "Cube A", "folded": {"top": "★", "front": "▲", "right": "■"}},
      {"key": "B", "label": "Cube B", "folded": {"top": "▲", "front": "★", "right": "■"}},
      {"key": "C", "label": "Cube C", "folded": {"top": "★", "front": "▼", "right": "■"}},
      {"key": "D", "label": "Cube D", "folded": {"top": "★", "front": "▲", "right": "◆"}}
    ],
    "answer": "A",
    "explanation": "En pliant le patron en croix : la face « top » garde son symbole ★, la face « front » porte ▲ (collée à la base de la croix), et la face droite porte ■. Seul le cube A respecte cette configuration ; B intervertit top/front, C utilise back au lieu de front, D met left au lieu de right.",
    "hint": null
  },
  {
    "difficulty": "Moyenne",
    "question": "Lequel de ces patrons ne peut pas former un cube une fois plié ?",
    "prompt": "Considère 4 patrons composés de 6 carrés assemblés.",
    "options": [
      {"key": "A", "label": "Croix latine"},
      {"key": "B", "label": "T renversé"},
      {"key": "C", "label": "Ligne droite de 6 carrés"},
      {"key": "D", "label": "Z de 6 carrés"}
    ],
    "answer": "C",
    "explanation": "Une bande linéaire de 6 carrés ne forme jamais un cube car elle ne peut pas se replier sur elle-même pour fermer un volume.",
    "hint": "Imagine le pliage : la bande reste plane."
  },
  {
    "difficulty": "Difficile",
    "question": "Combien de petits cubes ont exactement 2 faces peintes ?",
    "prompt": "Un cube 3×3×3 est entièrement peint en rouge sur l'extérieur, puis découpé en 27 petits cubes unitaires.",
    "options": [
      {"key": "A", "label": "8"},
      {"key": "B", "label": "12"},
      {"key": "C", "label": "24"},
      {"key": "D", "label": "27"}
    ],
    "answer": "B",
    "explanation": "Les cubes à 2 faces peintes sont sur les arêtes (sans inclure les coins). Un cube possède 12 arêtes ; sur un 3×3×3, il y a 1 cube par arête (les 2 extrémités sont les coins, à 3 faces peintes). Donc 12 cubes à 2 faces peintes.",
    "hint": "Compte les arêtes du cube et exclus les coins."
  },
  {
    "difficulty": "Difficile",
    "question": "Quelle figure obtient-on en pliant un carré ABCD sur sa diagonale AC ?",
    "prompt": "Un carré de côté unique est plié de telle sorte que le sommet B se rabatte sur le sommet D.",
    "options": [
      {"key": "A", "label": "Triangle rectangle isocèle"},
      {"key": "B", "label": "Triangle équilatéral"},
      {"key": "C", "label": "Trapèze"},
      {"key": "D", "label": "Losange"}
    ],
    "answer": "A",
    "explanation": "Plier le carré sur sa diagonale donne deux triangles rectangles isocèles superposés. Le résultat visible est un triangle rectangle isocèle.",
    "hint": "La diagonale d'un carré coupe le carré en deux triangles identiques."
  }
]
```

## Règles patron de cube

- `layout` ∈ `cross`, `T`, `L`, `Z`, `line` (cross = patron en croix latine, le plus classique).
- `faces` doit définir EXACTEMENT 6 clés : `top`, `bottom`, `left`, `right`, `front`, `back`. Chaque valeur est un seul caractère / symbole (lettre, chiffre ou ★ ◆ ■ ▲ ▼ ● ▢ ✚).
- Chaque option a obligatoirement `key` (A/B/C/D), `label` (texte court), et `folded` avec exactement `top`, `front`, `right`.
- **Une seule option** doit être cohérente avec le patron (= `answer` est sa clé).
- Les 3 distracteurs doivent être plausibles : intervertir 2 faces, utiliser `back` à la place de `front`, etc.
- Symboles autorisés (utilise-les en variant) : ★ ● ◆ ■ ▲ ▼ ✚ ✦ ◯ ▢ A B C D 1 2 3 4 5 6.

Tu peux ponctuellement (max 5 sur 50) garder l'ancien format texte pour des questions de pure connaissance (« combien de faces a un cube ? ») mais le format **cube net** doit dominer.

## Anti-patterns à éviter

- ❌ Question nécessitant absolument une image pour être comprise (hors patron).
- ❌ `answer` qui n'est pas une clé (`"A"`, `"B"`, `"C"`, `"D"`).
- ❌ Plus d'un patron correct (les distracteurs doivent être faux sans ambiguïté).
- ❌ `faces` incomplètes (moins de 6 clés).
- ❌ Symbole identique sur 2 faces (rend la vérification impossible).
- ❌ `folded` manquant sur une option de type cube_net.

## Sortie attendue

Démarre directement par `[`. Pas d'introduction, pas de conclusion.
