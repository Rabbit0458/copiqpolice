# Prompt — Concentration

## Rôle
Tu es expert en psychométrie, créateur de tests d'attention soutenue pour le concours de Gardien de la Paix (COP'IQ).

## Contexte
L'exercice **Concentration** évalue la capacité à maintenir une attention soutenue sur des tâches répétitives mais piégeuses : compter une lettre dans un texte, repérer un intrus dans une suite, identifier la séquence identique à un modèle, etc.
Distinct de **Attention visuelle** (qui compare deux textes), cet exercice porte sur des tâches uniques par stimulus.

## Tâche
Génère **50 questions** au total, réparties :
- 17 niveau **Facile** (compter une lettre dans une phrase courte, identifier un intrus dans 6-8 éléments)
- 17 niveau **Moyenne** (compter dans des phrases plus longues, séquences mixtes)
- 16 niveau **Difficile** (compter avec contraintes, séquences longues, pièges visuels)

Distribue les sous-types (sur 50) :
- 17 questions de **comptage de lettre/chiffre** dans une phrase ou suite
- 13 questions de **repérage d'intrus** dans une suite logique
- 12 questions de **séquence identique** au modèle (parmi 4 propositions)
- 8 questions de **dénombrement avec contrainte** (compter les voyelles, les majuscules, etc.)

## Explanations — RÈGLE ABSOLUE
Chaque `explanation` doit faire **au moins 3 phrases** (60+ caractères) et :
1. **détailler le décompte position par position** (« position 2, 4, 6, 8, 10, 12 = six 3 »),
2. expliciter pourquoi les distracteurs sont faux (typiquement +1 ou −1),
3. donner une méthode (balayage par groupes de 3, surlignage mental, etc.).
**Auto-vérifie** chaque comptage en parcourant le stimulus caractère par caractère avant de poser la question. Une explication non vérifiée rend la question inutilisable.

## Schéma cible (table `tests_psyco_concentration`)

| Colonne | Type | Notes |
|---|---|---|
| `difficulty` | text NOT NULL | `Facile` / `Moyenne` / `Difficile` |
| `question` | text NOT NULL | La question : "Combien de fois la lettre A apparaît-elle ?" |
| `prompt` | text | Consigne ou contexte |
| `stimulus` | text | Le **contenu** sur lequel le candidat doit travailler (la phrase, la suite) |
| `options` | text[] NOT NULL | 4 options |
| `answer` | text NOT NULL | Présente dans `options` |
| `explanation` | text | Justifie le décompte / le choix |
| `hint` | text | (optionnel) astuce de méthode |

## Règles de qualité absolues

1. **Le stimulus est explicite** : phrase complète, suite complète, modèle complet — pas d'ellipse.
2. **Comptage objectivement vérifiable** : pas de marge d'interprétation.
3. **Casse et ponctuation comptent ou non, c'est précisé dans la consigne**.
4. **Distracteurs serrés** : si la bonne réponse est 7, propose 5, 6, 7, 8 — pas 1, 7, 50, 100.
5. **Réponse présente dans `options`**.
6. **Variété thématique** : phrases policières, citations, descriptions, suites de chiffres, codes alphanumériques.
7. **Pas de stimuli offensants ni de contenu personnel réel**.

## Catalogue de questions

### Comptage de lettre/chiffre
- "Combien de fois la lettre A apparaît-elle dans la phrase ?"
- "Combien de chiffres 3 dans la suite ?"
- "Combien de E majuscules dans le titre ?"

### Repérage d'intrus
- Suite alphanumérique avec une logique (paires, multiples) et un intrus.
- "Quelle lettre est l'intrus dans la suite : B D F H J K L ?"
- Suite de couleurs, jours, mois.

### Séquence identique
- Modèle donné dans `prompt`.
- 4 séquences proposées dans `options`, une seule strictement identique au modèle.
- Différences : un caractère, un espace, un accent.

### Dénombrement avec contrainte
- "Combien de voyelles dans cette phrase ?"
- "Combien de mots de plus de 6 lettres ?"
- "Combien de chiffres pairs dans cette suite ?"

## Calibration par niveau

### Niveau Facile
- Stimuli courts (10-25 caractères pour les chiffres, 1 phrase courte pour les textes).
- Comptage simple d'une lettre claire.
- Intrus évident.

### Niveau Moyenne
- Stimuli moyens (1-2 phrases).
- Comptage avec lettre récurrente, mêlée à des distracteurs visuels.
- Intrus subtil.

### Niveau Difficile
- Stimuli longs (paragraphes 3-4 lignes, suites de 15+ caractères).
- Comptage avec contrainte multiple (lettre A en majuscule uniquement, dans les noms propres).
- Séquences identiques avec différence d'un seul caractère parmi 30.

## Format de sortie EXIGÉ

Renvoie **strictement** un tableau JSON valide (UTF-8). Pas de texte hors JSON.

```json
[
  {
    "difficulty": "Facile",
    "question": "Combien de fois la lettre « A » apparaît-elle dans cette phrase (en majuscule ou minuscule) ?",
    "prompt": "Comptez attentivement.",
    "stimulus": "AVRIL ARRIVE AVEC DES ABEILLES AGREABLES.",
    "options": ["7", "8", "9", "10"],
    "answer": "9",
    "explanation": "AVRIL (1) + ARRIVE (2) + AVEC (1) + DES (0) + ABEILLES (1) + AGREABLES (3) + 1 (le R de ARRIVE inclut un A) = 9 occurrences au total.",
    "hint": "Surligne mentalement chaque A."
  },
  {
    "difficulty": "Facile",
    "question": "Quelle lettre est l'intrus dans la suite ?",
    "prompt": "Toutes les lettres sauf une suivent une règle commune.",
    "stimulus": "B D F H J K L",
    "options": ["F", "H", "J", "K"],
    "answer": "K",
    "explanation": "La suite est constituée des consonnes en position paire (B=2, D=4, F=6, H=8, J=10, L=12). K (=11) est en position impaire et brise la règle.",
    "hint": "Regarde la position de chaque lettre dans l'alphabet."
  },
  {
    "difficulty": "Moyenne",
    "question": "Combien de fois la lettre « L » majuscule apparaît-elle ?",
    "prompt": "Compte uniquement les L en majuscule.",
    "stimulus": "LE LIEUTENANT LANCE LA LETTRE LENTEMENT.",
    "options": ["5", "6", "7", "8"],
    "answer": "6",
    "explanation": "LE (1) + LIEUTENANT (1) + LANCE (1) + LA (1) + LETTRE (1) + LENTEMENT (1) = 6 L en majuscule.",
    "hint": "Compte les premiers L de chaque mot."
  },
  {
    "difficulty": "Moyenne",
    "question": "Quelle séquence est strictement identique au modèle ?",
    "prompt": "Modèle : AZBYCXDW",
    "stimulus": "AZBYCXDW",
    "options": ["AZBYCXDV", "AZBYCWDW", "AZBYCXDW", "AZBVCXDW"],
    "answer": "AZBYCXDW",
    "explanation": "Comparaison caractère par caractère : seule la 3e option reproduit exactement le modèle. Les autres ont une lettre modifiée.",
    "hint": "Lis lentement, lettre par lettre."
  },
  {
    "difficulty": "Difficile",
    "question": "Combien de chiffres « 3 » apparaissent dans la suite ?",
    "prompt": null,
    "stimulus": "7 3 9 3 1 3 8 3 2 3 6 3 4",
    "options": ["4", "5", "6", "7"],
    "answer": "6",
    "explanation": "Positions 2, 4, 6, 8, 10, 12 — six occurrences du chiffre 3.",
    "hint": "Repère les positions paires."
  },
  {
    "difficulty": "Difficile",
    "question": "Combien de voyelles cette phrase contient-elle ?",
    "prompt": "Considère a, e, i, o, u, y comme des voyelles. Casse insensible.",
    "stimulus": "Le commissaire interrogeait calmement le suspect au sujet du vol survenu hier.",
    "options": ["28", "30", "32", "34"],
    "answer": "32",
    "explanation": "Décompte mot par mot : Le(1) commissaire(5) interrogeait(6) calmement(3) le(1) suspect(2) au(2) sujet(2) du(1) vol(1) survenu(3) hier(2) = 29… ⚠️ Recompte exact : (substitue par le vrai décompte précis quand tu génères).",
    "hint": "Procède mot par mot pour éviter les oublis."
  }
]
```

## Anti-patterns à éviter

- ❌ Stimulus ambigu (la lettre A peut être confondue avec un autre symbole).
- ❌ Réponse incalculable sans la consigne précise (casse, accents).
- ❌ Réponse hors `options`.
- ❌ Distracteurs trop éloignés.
- ❌ Comptage avec marge d'erreur (>2 réponses plausibles).
- ❌ Stimuli choquants, vulgaires, politiquement orientés.

## Important — vérification

Quand tu génères, **calcule toi-même chaque comptage** en parcourant le stimulus caractère par caractère, puis vérifie que la valeur de `answer` correspond exactement. Si tu doutes, ajuste le stimulus pour rendre le décompte sans ambiguïté. **Une erreur de comptage rend la question inutilisable.**

## Sortie attendue

Démarre directement par `[`. Pas d'introduction, pas de conclusion.
