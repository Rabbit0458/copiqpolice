# COP'IQ — AI Generation Pipeline v2

## Objectif

Ce système permet de générer automatiquement des milliers de questions psychotechniques pour COP'IQ via plusieurs intelligences artificielles :

* OpenAI GPT
* DeepSeek
* Claude Anthropic
* Gemini (prévu plus tard)

Les questions sont :

* validées
* normalisées
* dédoublonnées
* insérées automatiquement dans Supabase

---

# Architecture du pipeline

Le système fonctionne ainsi :

1. Lecture du prompt `.md`
2. Envoi à plusieurs IA
3. Extraction du JSON
4. Validation du schéma
5. Dédoublonnage intelligent
6. Normalisation du payload
7. Insertion batch dans Supabase
8. Sauvegarde des réponses brutes dans `/out`

---

# IA supportées

| Provider   | Usage recommandé             |
| ---------- | ---------------------------- |
| OpenAI GPT | Qualité générale / stabilité |
| DeepSeek   | Génération massive low-cost  |
| Claude     | Raisonnement complexe        |
| Gemini     | Futur support                |

---

# Installation

## Dépendances

```bash
pip install openai anthropic supabase python-dotenv
```

---

# Variables d'environnement

Créer un fichier `.env` :

```env
# IA
OPENAI_API_KEY=
DEEPSEEK_API_KEY=
ANTHROPIC_API_KEY=

# Supabase
SUPABASE_URL=https://nuoonagnkhbeeymtvrcn.supabase.co
SUPABASE_SERVICE_KEY=
```

⚠️ Ne jamais commit le `.env`
⚠️ Ne jamais partager la service_role key

---

# Structure des fichiers

```text
docs/prompts_psycho/
│
├── generate_and_insert.py
├── .env
├── README.md
│
├── 01_attention_visuelle.md
├── 02_suites_logiques.md
├── 03_calcul_mental.md
├── 04_logique_verbale.md
├── 05_raisonnement_logique.md
├── 06_raisonnement_spatial.md
├── 07_rotations_symetries.md
├── 08_concentration.md
│
└── out/
```

---

# Génération simple

## OpenAI

```bash
python generate_and_insert.py 03_calcul_mental.md --provider openai --runs 1
```

## DeepSeek

```bash
python generate_and_insert.py 03_calcul_mental.md --provider deepseek --runs 1
```

## Claude

```bash
python generate_and_insert.py 03_calcul_mental.md --provider claude --runs 1
```

---

# Génération massive

## Toutes les catégories

```bash
python generate_and_insert.py --all --provider deepseek --runs 5
```

Exemple :

* 8 exercices
* 30 questions par run
* 5 runs

≈ 1200 questions générées automatiquement.

---

# Génération hybride multi-IA

Le pipeline peut être lancé plusieurs fois avec différents providers :

```bash
python generate_and_insert.py --all --provider openai --runs 2

python generate_and_insert.py --all --provider deepseek --runs 5
```

Le système :

* dédoublonne automatiquement
* évite les collisions
* enrichit la variété des questions

---

# Tables Supabase utilisées

| Exercice              | Table                            |
| --------------------- | -------------------------------- |
| Attention visuelle    | tests_psyco_attention_visuelle   |
| Suites logiques       | tests_psyco_suite_logique        |
| Calcul mental         | tests_psyco_calcul_mental        |
| Logique verbale       | tests_psyco_logique_verbale      |
| Raisonnement logique  | tests_psyco_raisonnement_logique |
| Raisonnement spatial  | tests_psyco_raisonnement_spatial |
| Rotations & symétries | tests_psyco_rotations_symetries  |
| Concentration         | tests_psyco_concentration        |

---

# Dédoublonnage intelligent

Le pipeline génère une empreinte SHA256 :

* Attention visuelle :
  (text_a + text_b)

* Autres exercices :
  (question + answer)

Les doublons ne sont jamais réinsérés.

---

# Sauvegarde des réponses IA

Toutes les réponses brutes sont sauvegardées dans :

```text
/out/
```

Cela permet :

* audit qualité
* debugging
* comparaison IA
* fine tuning futur

---

# Workflow recommandé

## Étape 1

Créer les tables Supabase.

## Étape 2

Tester chaque exercice individuellement.

## Étape 3

Vérifier la qualité.

## Étape 4

Lancer génération massive.

## Étape 5

Désactiver les mauvaises questions via :
`is_active = false`

---

# Conseils COP'IQ

## OpenAI

Excellent équilibre qualité/coût.

## DeepSeek

Parfait pour générer des milliers de questions.

## Claude

À utiliser pour :

* raisonnement spatial
* logique complexe
* pièges subtils

---

# Objectif final

Créer une base psychotechnique ultra massive :

* plusieurs dizaines de milliers de questions
* entièrement hébergées sur Supabase
* sans JSON local dans Flutter
* chargement dynamique
* système scalable
* panel admin COP'IQ compatible
