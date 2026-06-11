# Prompt — Logique verbale

## Rôle
Tu es expert en psychométrie et linguistique, créateur de tests pour le concours de Gardien de la Paix (COP'IQ).

## Contexte
L'exercice **Logique verbale** évalue la maîtrise de la langue française : sens des mots, relations sémantiques, vocabulaire, analogies, nuances.
Le candidat lit un énoncé court et choisit la bonne réponse parmi 4 options.

## Tâche
Génère **50 questions** au total, réparties :
- 17 niveau **Facile** (vocabulaire courant, distinctions évidentes)
- 17 niveau **Moyenne** (vocabulaire scolaire, analogies à plusieurs degrés)
- 16 niveau **Difficile** (vocabulaire soutenu, nuances fines, expressions idiomatiques)

Sur les 50 questions, distribue les sous-types :
- 10 synonymes
- 10 antonymes
- 10 analogies (`A est à B comme C est à ?`)
- 8 intrus (un mot ne va pas avec les autres)
- 7 complétions de phrase
- 5 sens contextuel (le mot X dans cette phrase signifie ?)

## Explanations — RÈGLE ABSOLUE
Chaque `explanation` doit faire **au moins 3 phrases** (60+ caractères) et :
1. justifier pourquoi la bonne réponse est correcte (définition, racine, registre),
2. **disqualifier explicitement chaque distracteur** (« X n'est pas synonyme car… »),
3. donner un moyen mnémotechnique ou un repère étymologique quand c'est possible.
Une explication type « C'est le bon synonyme » est rejetée.

## Schéma cible (table `tests_psyco_logique_verbale`)

| Colonne | Type | Notes |
|---|---|---|
| `difficulty` | text NOT NULL | `Facile` / `Moyenne` / `Difficile` |
| `question` | text NOT NULL | L'énoncé : "Quel est le synonyme de…" |
| `prompt` | text | Optionnel : liste de mots si l'énoncé en a besoin (ex : "Pomme, poire, carotte, banane") |
| `options` | text[] NOT NULL | 4 propositions (3 minimum) |
| `answer` | text NOT NULL | Présente dans `options` |
| `explanation` | text | Justifie pourquoi c'est la bonne réponse + pourquoi les autres sont fausses ou moins bonnes |
| `hint` | text | (optionnel) astuce |

## Règles de qualité absolues

1. **Une seule bonne réponse incontestable** par question.
2. **Distracteurs sémantiquement proches** mais pas équivalents.
3. **Pas de pièges grammaticaux trompeurs** sauf si l'exercice porte explicitement sur la grammaire.
4. **Vocabulaire français standard** ou soutenu — pas d'argot, pas de régionalismes.
5. **Aucun anglicisme** sauf si pertinent et marqué.
6. **Variété** : pas plus de 2 questions sur le même mot pivot dans les 30.
7. **Réponse strictement présente dans `options`**.
8. **Énoncé précis** : la consigne doit clairement indiquer le sous-type (synonyme, antonyme, intrus, etc.).

## Catalogue des sous-types

### Synonymes
- Énoncé : "Quel est le synonyme de \"rapide\" ?"
- Distracteurs : antonymes, mots de famille proche mais sens différent.

### Antonymes
- Énoncé : "Quel est l'antonyme de \"généreux\" ?"
- Distracteurs : synonymes, mots associés mais pas opposés.

### Analogies
- Énoncé : "Voiture est à route comme bateau est à ___"
- Format de relations : objet/lieu, profession/outil, animal/cri, partie/tout, cause/conséquence.

### Intrus
- Prompt : liste 4 mots, dont un n'appartient pas à la même catégorie.
- Énoncé : "Lequel de ces mots est l'intrus ?"
- Catégories : fruits/légumes, métaux/minéraux, instruments à vent/à corde, etc.

### Complétion de phrase
- Énoncé : "Complète la phrase : \"Malgré la pluie, il a ___ son chemin.\""
- Choisir le mot le plus juste sémantiquement et grammaticalement.

### Sens contextuel
- Prompt : phrase contenant un mot polysémique.
- Énoncé : "Dans cette phrase, le mot \"X\" signifie…"

## Calibration par niveau

### Niveau Facile
- Vocabulaire de tous les jours : rapide/lent, grand/petit, chat/chien.
- Analogies évidentes : voiture/route, oiseau/ciel.
- Intrus visibles : 3 fruits + 1 légume.

### Niveau Moyenne
- Vocabulaire scolaire / professionnel : cohérent/incohérent, exhaustif, méticuleux.
- Analogies à 2 niveaux : médecin/hôpital, professeur/école.
- Intrus avec 2 critères possibles.
- Sens contextuel sur mots polysémiques courants : carton, pièce, glace.

### Niveau Difficile
- Vocabulaire soutenu : pléthorique, prolixe, sibyllin, atavique, contrit.
- Analogies à 3 niveaux ou inversées.
- Expressions idiomatiques : "tirer le diable par la queue".
- Intrus subtil (3 termes médicaux + 1 juridique presque indiscernable).
- Faux amis : altérer ≠ alterner, infliger ≠ infester.

## Format de sortie EXIGÉ

Renvoie **strictement** un tableau JSON valide (UTF-8). Pas de texte hors JSON.

```json
[
  {
    "difficulty": "Facile",
    "question": "Quel est le synonyme de « rapide » ?",
    "prompt": null,
    "options": ["Lent", "Vif", "Calme", "Lourd"],
    "answer": "Vif",
    "explanation": "« Vif » désigne ce qui agit avec rapidité. « Lent » est l'antonyme. « Calme » et « lourd » ne sont pas synonymes de « rapide ».",
    "hint": null
  },
  {
    "difficulty": "Moyenne",
    "question": "Complète l'analogie : Voiture est à route comme bateau est à ___",
    "prompt": null,
    "options": ["Mer", "Quai", "Vague", "Voile"],
    "answer": "Mer",
    "explanation": "La voiture circule sur la route, le bateau circule sur la mer (relation moyen de transport / surface de circulation). Le quai est un lieu d'accostage, la vague et la voile sont des éléments associés mais pas la surface de circulation.",
    "hint": "Pense à la surface sur laquelle l'objet se déplace."
  },
  {
    "difficulty": "Moyenne",
    "question": "Lequel de ces mots est l'intrus ?",
    "prompt": "Pomme, poire, carotte, banane",
    "options": ["Pomme", "Poire", "Carotte", "Banane"],
    "answer": "Carotte",
    "explanation": "La carotte est un légume-racine. Les trois autres sont des fruits.",
    "hint": null
  },
  {
    "difficulty": "Difficile",
    "question": "Quel est l'antonyme de « pléthorique » ?",
    "prompt": null,
    "options": ["Abondant", "Indigent", "Foisonnant", "Surabondant"],
    "answer": "Indigent",
    "explanation": "« Pléthorique » = en très grande quantité. Son antonyme est « indigent » (pauvre, insuffisant). Les trois autres sont synonymes de pléthorique.",
    "hint": "« Pléthorique » signifie excessif en quantité."
  }
]
```

## Anti-patterns à éviter

- ❌ Mots tabous, vulgaires, racistes, sexistes ou politiquement orientés.
- ❌ Réponse hors tableau `options`.
- ❌ Plus d'une bonne réponse plausible.
- ❌ Distracteurs absurdes (mot inventé).
- ❌ Énoncé ambigu sans contexte.
- ❌ Plus de 6 questions du même sous-type sur les 30.

## Sortie attendue

Démarre directement par `[`. Pas d'introduction, pas de conclusion.
