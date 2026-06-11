# Prompt — Attention visuelle

## Rôle
Tu es expert en psychométrie et tu rédiges des questions du concours de Gardien de la Paix pour l'application COP'IQ.

## Contexte
L'exercice **Attention visuelle** présente deux textes côte à côte. Le candidat doit dire si les deux textes sont **strictement identiques** (même casse, même ponctuation, mêmes espaces) ou s'il existe au moins une différence subtile (lettre changée, accent oublié, espace en plus, chiffre inversé, etc.).
Cet exercice évalue la concentration visuelle, la précision et la résistance à la fatigue oculaire — compétences clefs pour la lecture de procès-verbaux.

## Tâche
Génère **50 paires de textes au total**, réparties :
- 17 paires de niveau **easy** (textes courts, ~30-50 caractères, différence flagrante quand elle existe)
- 17 paires de niveau **medium** (textes moyens, ~80-130 caractères, différence d'une lettre/accent/chiffre)
- 16 paires de niveau **hard** (textes longs, ~150-250 caractères, différence très subtile : espace insécable, virgule manquante, lettre i/l/1, o/0)

Sur les 50 paires, **25 doivent être identiques** (`is_true: true`) et **25 doivent contenir une différence** (`is_true: false`). Équilibre vrai/faux à chaque niveau.

## Explanations — RÈGLE ABSOLUE
Le champ `explanation` doit faire **au moins 3 phrases** (60+ caractères) et toujours :
1. dire si les textes sont identiques ou non,
2. localiser précisément la différence si elle existe (mot, position, type : accent, chiffre, espace),
3. expliquer pourquoi un candidat se ferait piéger (lettre proche visuellement, fatigue oculaire, etc.).
Une `explanation` minimaliste type "Différents" est inacceptable — elle sera rejetée par le pipeline.

## Schéma cible (table Supabase `tests_psyco_attention_visuelle`)

| Colonne | Type | Notes |
|---|---|---|
| `text_a` | text NOT NULL | Premier texte |
| `text_b` | text NOT NULL | Second texte |
| `is_true` | boolean NOT NULL | true si textes identiques |
| `explanation` | text | Explique la différence (ou "Textes strictement identiques") |
| `difficulty` | text | `easy` / `medium` / `hard` (en anglais ici, contrairement aux autres exercices) |

## Règles de qualité absolues

1. **Variété thématique** : utilise des registres variés — extraits de PV, descriptions de personnes, plaques d'immatriculation, adresses, descriptions de véhicules, identités, dates et heures, références juridiques (articles du code pénal), citations.
2. **Réalisme** : les textes doivent ressembler à du contenu professionnel d'un policier (PV, signalement, déposition).
3. **Aucune information personnelle réelle** : invente des noms, adresses et numéros (jamais de vraies personnes).
4. **Différences crédibles** : quand `is_true=false`, la différence doit être plausible (faute de frappe réaliste, pas une faute énorme).
5. **Pas de différence sur la casse à `easy`** : réserve les pièges typographiques (majuscule/minuscule, accent é/è, virgule/point) au `medium` et `hard`.
6. **Aucune répétition** entre les 30 paires : chaque paire doit avoir un texte source unique.
7. **Explication précise** : pour `is_true=false`, indique exactement où se trouve la différence (`"medium" vs "moyen"` à la position du mot 4, par exemple). Pour `is_true=true`, écris simplement `"Textes strictement identiques"`.

## Calibration par niveau

### Niveau `easy` (textes courts, différences évidentes)
- Longueur : 30 à 50 caractères.
- Si différence : un mot remplacé par un autre clairement différent (ex : "rue" → "avenue").
- Exemples de sources : adresses simples, plaques, prénom + nom.

### Niveau `medium` (textes moyens, différences fines)
- Longueur : 80 à 130 caractères.
- Si différence : une lettre, un accent, un chiffre inversé, un signe de ponctuation.
- Exemples de sources : descriptions de véhicules, signalements brefs, dates+heures.

### Niveau `hard` (textes longs, différences très subtiles)
- Longueur : 150 à 250 caractères.
- Si différence : différence d'un seul caractère (espace, virgule, accent, lettre proche : `i/l`, `o/0`, `c/ç`, `e/é`, `O/0`, `m/n`, `rn/m`).
- Exemples de sources : extraits de procès-verbal, articles juridiques cités, paragraphes de rapport.

## Format de sortie EXIGÉ

Renvoie **strictement** un tableau JSON valide (UTF-8). Pas de texte avant, pas de texte après, pas de bloc markdown ```json. Juste le tableau.

```json
[
  {
    "difficulty": "easy",
    "text_a": "Avenue Charles de Gaulle, 75008 Paris",
    "text_b": "Avenue Charles de Gaulle, 75008 Paris",
    "is_true": true,
    "explanation": "Textes strictement identiques."
  },
  {
    "difficulty": "easy",
    "text_a": "Renault Clio grise immatriculée AB-123-CD",
    "text_b": "Renault Clio noire immatriculée AB-123-CD",
    "is_true": false,
    "explanation": "La couleur diffère : « grise » dans text_a, « noire » dans text_b."
  },
  {
    "difficulty": "medium",
    "text_a": "Le 12/03/2025 à 14h27, M. DUPONT Jean, né le 03/06/1982, déclare avoir été victime d'un vol.",
    "text_b": "Le 12/03/2025 à 14h27, M. DUPONT Jean, né le 03/06/1982, déclare avoir été victime d'un vol.",
    "is_true": true,
    "explanation": "Textes strictement identiques."
  },
  {
    "difficulty": "hard",
    "text_a": "Article 311-1 du code pénal : Le vol est la soustraction frauduleuse de la chose d'autrui.",
    "text_b": "Article 311-1 du code pénal : Le vol est la soustraction frauduleuse de la chose d'autrui.",
    "is_true": true,
    "explanation": "Textes strictement identiques."
  }
]
```

## Anti-patterns à éviter

- ❌ Mettre la différence systématiquement au même endroit (toujours au début ou à la fin).
- ❌ Différences évidentes en niveau `hard` (ex : un mot complet remplacé).
- ❌ Textes copiés/paraphrasés entre paires (chaque paire doit être unique).
- ❌ Mention d'une vraie personnalité, célébrité, ou personne réelle.
- ❌ Contenu offensant, raciste, sexiste, ou orienté politiquement.

## Liste de différences subtiles autorisées (niveau `hard`)

- Espace insécable vs espace normal (visible : aucune)
- Virgule remplacée par point ou inversement
- `é` vs `è`, `à` vs `a`, `ç` vs `c`
- `1` vs `l` vs `I`, `0` vs `O`, `5` vs `S`
- `rn` vs `m`, `cl` vs `d`
- Espace en plus ou en moins entre deux mots
- Trait d'union vs tiret long vs tiret court : `-`, `–`, `—`
- Apostrophe droite vs courbe : `'` vs `’`
- Numéros : `12345` vs `12354` (chiffre inversé)

## Sortie attendue

Démarre directement par `[` et termine par `]`. Pas d'introduction, pas de conclusion.
