# Prompt — Raisonnement logique

## Rôle
Tu es expert en psychométrie et logique formelle, créateur de tests pour le concours de Gardien de la Paix (COP'IQ).

## Contexte
L'exercice **Raisonnement logique** évalue la capacité à déduire, comparer, classer, identifier des conditions, repérer des pièges. Le candidat lit un énoncé puis choisit la bonne conclusion parmi 4 options.

## Tâche
Génère **50 questions** au total, réparties :
- 17 niveau **Facile** (déductions à 2 prémisses, ordres simples)
- 17 niveau **Moyenne** (3 prémisses, ordres comparatifs, conditions)
- 16 niveau **Difficile** (pièges classiques, énigmes, conditions multiples)

Distribue les sous-types ainsi (sur 50) :
- 13 syllogismes (Tous les A sont B, X est A, donc X est B)
- 10 ordres / classements (Pierre > Paul > Jacques)
- 10 conditions (Si A alors B)
- 9 énigmes / problèmes de vie courante (équations cachées)
- 8 pièges classiques (course, frères, traversée, miroir)

## Explanations — RÈGLE ABSOLUE
Chaque `explanation` doit faire **au moins 3 phrases** (60+ caractères) et :
1. nommer la structure logique (« syllogisme par transitivité », « modus ponens »),
2. **dérouler chaque étape** du raisonnement formel,
3. mettre en garde sur le piège classique (négation mal comprise, faux contre-exemple, ordre inversé).
Une explication type « Réponse évidente » est rejetée.

## Schéma cible (table `tests_psyco_raisonnement_logique`)

| Colonne | Type | Notes |
|---|---|---|
| `difficulty` | text NOT NULL | `Facile` / `Moyenne` / `Difficile` |
| `question` | text NOT NULL | La question finale (ex : "Qui est le plus grand ?") |
| `prompt` | text | Les prémisses, l'énoncé contextuel |
| `options` | text[] NOT NULL | 4 propositions, dont la bonne |
| `answer` | text NOT NULL | Strictement présente dans `options` |
| `explanation` | text | Justification logique étape par étape |
| `hint` | text | (optionnel) astuce de méthode |

## Règles de qualité absolues

1. **Une seule conclusion logique correcte**.
2. **Énoncé sans ambiguïté** — toutes les informations nécessaires sont fournies.
3. **Pas d'hypothèses cachées** : le candidat ne doit pas avoir besoin d'inférer une donnée externe.
4. **Distracteurs cohérents** : reflètent les erreurs de raisonnement classiques (oubli de la transitivité, inversion d'implication).
5. **Pas plus de 2 énigmes du même piège classique** sur les 30.
6. **Réponse présente dans `options`**.
7. **Explication pas-à-pas** : recopie le raisonnement formel.

## Catalogue des sous-types

### Syllogismes (8 questions)
- Forme : `Toutes les voitures rouges sont rapides. Cette Ferrari est rouge. Donc...`
- Variantes : avec négation (`Aucun A n'est B`), avec quantificateur particulier (`Quelques A sont B`).
- Pièges : conclusion non valide ("on ne peut pas savoir").

### Ordres / classements (6 questions)
- Forme : `Pierre est plus grand que Paul. Paul est plus grand que Jacques. Qui est le plus grand ?`
- Variantes : âges, vitesses, prix, tailles. À 3, 4 ou 5 sujets.

### Conditions (6 questions)
- Forme : `Si Pierre va au cinéma, alors Paul reste à la maison. Pierre est au cinéma. Donc...`
- Pièges : contraposition, négation maladroite.

### Énigmes / vie courante (5 questions)
- Forme : `Marie a 3 fois l'âge de son fils. Dans 10 ans, elle aura le double. Quel âge a-t-elle ?`
- Petits problèmes verbaux à transformer en équations.

### Pièges classiques (5 questions)
- Course : "Vous doublez le 2e, quelle est votre position ?"
- Réponse contre-intuitive.
- Frères et sœurs : "Combien de sœurs a chaque frère ?"
- Énigmes de traversée, de balance, de bouteille.

## Calibration par niveau

### Niveau Facile
- 2 prémisses maximum.
- Vocabulaire simple.
- Réponse calculable en moins de 30 secondes.

### Niveau Moyenne
- 3-4 prémisses.
- Calcul ou inférence en 2 étapes.
- Conditions inversées possibles.

### Niveau Difficile
- 4-5 prémisses ou énigme nécessitant une équation.
- Pièges classiques.
- Conditions imbriquées.
- Conclusions du type "On ne peut pas savoir".

## Format de sortie EXIGÉ

Renvoie **strictement** un tableau JSON valide (UTF-8). Pas de texte hors du JSON.

```json
[
  {
    "difficulty": "Facile",
    "question": "Que peut-on en déduire ?",
    "prompt": "Tous les chats sont des animaux. Minou est un chat.",
    "options": [
      "Minou est un chien",
      "Minou est un animal",
      "Minou n'est pas un animal",
      "On ne peut pas savoir"
    ],
    "answer": "Minou est un animal",
    "explanation": "Syllogisme classique : si tous les chats sont des animaux et que Minou est un chat, alors par transitivité Minou est un animal.",
    "hint": "Applique la propriété de transitivité."
  },
  {
    "difficulty": "Moyenne",
    "question": "Qui est le plus grand ?",
    "prompt": "Pierre est plus grand que Paul. Paul est plus grand que Jacques. Marc est plus grand que Pierre.",
    "options": ["Pierre", "Paul", "Jacques", "Marc"],
    "answer": "Marc",
    "explanation": "On classe : Marc > Pierre > Paul > Jacques. Marc est donc le plus grand.",
    "hint": "Construis la chaîne d'inégalités."
  },
  {
    "difficulty": "Difficile",
    "question": "Quelle est votre position ?",
    "prompt": "Dans une course, vous doublez le 2e coureur juste avant la ligne d'arrivée.",
    "options": ["1ère", "2ème", "3ème", "4ème"],
    "answer": "2ème",
    "explanation": "En doublant le 2e, vous prenez sa place : vous êtes 2ème, pas 1er. Le coureur qui était 1er ne change pas de place.",
    "hint": "Piège classique : tu ne deviens pas 1er en doublant le 2e."
  },
  {
    "difficulty": "Difficile",
    "question": "Quel âge a Marie aujourd'hui ?",
    "prompt": "Marie a actuellement 3 fois l'âge de son fils. Dans 10 ans, elle aura le double de l'âge de son fils.",
    "options": ["20 ans", "25 ans", "30 ans", "35 ans"],
    "answer": "30 ans",
    "explanation": "Soit f l'âge du fils. Marie = 3f. Dans 10 ans : 3f + 10 = 2(f + 10), donc 3f + 10 = 2f + 20, soit f = 10. Marie a donc 30 ans.",
    "hint": "Pose une équation avec l'âge du fils comme inconnue."
  }
]
```

## Anti-patterns à éviter

- ❌ Énoncé incomplet exigeant des suppositions externes.
- ❌ Conclusion ambiguë (deux réponses valides).
- ❌ Distracteur "On ne peut pas savoir" si on peut clairement savoir.
- ❌ Plus de 2 syllogismes structurellement identiques.
- ❌ Réponse hors `options`.
- ❌ Énigme tirée par les cheveux ou nécessitant une connaissance externe.

## Sortie attendue

Démarre directement par `[`. Aucune phrase d'introduction.
