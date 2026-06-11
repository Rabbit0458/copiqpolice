#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
COP'IQ — Générateur psychotechnique 100% OFFLINE
================================================
Aucune API. Aucune clé OpenAI / Claude / DeepSeek.
Génère en continu des exercices psychotechniques pour les tables COP'IQ
et exporte des CSV prêts à importer dans Supabase.

Usage :
  python generate_offline_forever.py --all --runs 1
  python generate_offline_forever.py --forever --batch-size 50
  python generate_offline_forever.py 03_calcul_mental --runs 5
  python generate_offline_forever.py 01_attention_visuelle --insert-supabase

Option Supabase :
  - Par défaut le script écrit seulement dans /out/csv
  - Avec --insert-supabase il insère directement en BDD si SUPABASE_URL et SUPABASE_SERVICE_KEY sont dans .env

Dépendances minimales :
  pip install python-dotenv colorama
Option Supabase :
  pip install supabase
"""

from __future__ import annotations

import argparse
import csv
import hashlib
import json
import os
import random
import string
import sys
import time
from dataclasses import dataclass
from pathlib import Path
from typing import Any

try:
    from dotenv import load_dotenv
    load_dotenv()
except Exception:
    pass

try:
    import colorama
    colorama.just_fix_windows_console()
except Exception:
    pass


ROOT = Path(__file__).resolve().parent
OUT_DIR = ROOT / "out"
CSV_DIR = OUT_DIR / "csv"
LOG_DIR = ROOT / "logs"
CSV_DIR.mkdir(parents=True, exist_ok=True)
LOG_DIR.mkdir(parents=True, exist_ok=True)

EXERCISE_TO_TABLE = {
    "01_attention_visuelle": "tests_psyco_attention_visuelle",
    "02_suites_logiques": "tests_psyco_suite_logique",
    "03_calcul_mental": "tests_psyco_calcul_mental",
    "04_logique_verbale": "tests_psyco_logique_verbale",
    "05_raisonnement_logique": "tests_psyco_raisonnement_logique",
    "06_raisonnement_spatial": "tests_psyco_raisonnement_spatial",
    "07_rotations_symetries": "tests_psyco_rotations_symetries",
    "08_concentration": "tests_psyco_concentration",
}

CSV_COLUMNS_BY_TABLE = {
    "tests_psyco_attention_visuelle": [
        "text_a", "text_b", "is_true", "explanation", "difficulty", "is_active",
    ],
    "tests_psyco_suite_logique": [
        "module", "category", "difficulty", "sequence_text", "prompt", "options",
        "answer", "explanation", "hint", "is_active",
    ],
    "tests_psyco_calcul_mental": [
        "module", "category", "difficulty", "question", "expression", "options",
        "answer", "explanation", "hint", "is_active",
    ],
    "tests_psyco_concentration": [
        "module", "category", "difficulty", "question", "prompt", "stimulus", "options",
        "answer", "explanation", "hint", "is_active",
    ],
    "tests_psyco_logique_verbale": [
        "module", "category", "difficulty", "question", "prompt", "options",
        "answer", "explanation", "hint", "is_active",
    ],
    "tests_psyco_raisonnement_logique": [
        "module", "category", "difficulty", "question", "prompt", "options",
        "answer", "explanation", "hint", "is_active",
    ],
    "tests_psyco_raisonnement_spatial": [
        "module", "category", "difficulty", "question", "prompt", "image_url",
        "figure_data", "options", "answer", "explanation", "hint", "is_active",
    ],
    "tests_psyco_rotations_symetries": [
        "module", "category", "difficulty", "question", "prompt", "image_url",
        "figure_data", "transformation_type", "options", "answer",
        "explanation", "hint", "is_active",
    ],
}

SLUG_BY_STEM = {
    "01_attention_visuelle": "attention_visuelle",
    "02_suites_logiques": "suites_logiques",
    "03_calcul_mental": "calcul_mental",
    "04_logique_verbale": "logique_verbale",
    "05_raisonnement_logique": "raisonnement_logique",
    "06_raisonnement_spatial": "raisonnement_spatial",
    "07_rotations_symetries": "rotations_symetries",
    "08_concentration": "concentration",
}

DIFFS = ["Facile", "Moyenne", "Difficile"]
ATT_DIFFS = ["easy", "medium", "hard"]


# ═══════════════════════════════════════════════════════════════════════════
# Console
# ═══════════════════════════════════════════════════════════════════════════

def stamp() -> str:
    return time.strftime("%H:%M:%S")


# Couleurs PowerShell / Windows Terminal
NO_COLOR = bool(os.getenv("NO_COLOR")) or not sys.stdout.isatty()

class COL:
    RESET = "\033[0m"
    BOLD = "\033[1m"
    GREEN = "\033[92m"
    ORANGE = "\033[93m"
    RED = "\033[91m"
    CYAN = "\033[96m"
    BLUE = "\033[94m"
    MAGENTA = "\033[95m"
    WHITE = "\033[97m"
    DIM = "\033[2m"


def paint(text: str, color: str) -> str:
    if NO_COLOR:
        return text
    return f"{color}{text}{COL.RESET}"


def log(msg: str, color: str | None = None) -> None:
    line = f"[{stamp()}] {msg}"
    print(paint(line, color) if color else line, flush=True)
    # Jamais de codes couleur dans le fichier log
    with open(LOG_DIR / "offline_generator.log", "a", encoding="utf-8") as f:
        f.write(line + "\n")


def shuffle_options(options: list[str], answer: str) -> tuple[list[str], str]:
    """
    Mélange 4 options en garantissant que la réponse est présente.
    Corrige le crash rencontré sur les suites alphabétiques : avant, le script
    faisait int(answer), donc une réponse comme "Y" plantait avec ValueError.
    """
    answer = str(answer)
    options = list(dict.fromkeys(str(x) for x in options))

    def make_candidate() -> str:
        # Cas numérique : distracteurs proches
        try:
            return str(int(answer) + random.choice([-5, -3, -2, -1, 1, 2, 3, 5]))
        except (TypeError, ValueError):
            pass

        # Cas lettre unique : lettres voisines dans l'alphabet
        if len(answer) == 1 and answer.upper() in string.ascii_uppercase:
            pos = string.ascii_uppercase.index(answer.upper())
            delta = random.choice([-3, -2, -1, 1, 2, 3])
            new_pos = max(0, min(25, pos + delta))
            return string.ascii_uppercase[new_pos]

        # Cas texte : variantes plausibles
        suffix = random.choice([" A", " B", " C", " D", " bis", " autre"])
        return f"{answer}{suffix}"

    while len(options) < 4:
        candidate = make_candidate()
        if candidate not in options:
            options.append(candidate)

    options = options[:4] if answer in options[:4] else options[:3] + [answer]
    random.shuffle(options)
    return options, answer


def key_options(labels: list[str], correct_label: str) -> tuple[list[dict[str, str]], str]:
    random.shuffle(labels)
    keys = ["A", "B", "C", "D"]
    opts = [{"key": k, "label": label} for k, label in zip(keys, labels[:4])]
    answer_key = next(o["key"] for o in opts if o["label"] == correct_label)
    return opts, answer_key


def json_for_csv(value: Any) -> str:
    if isinstance(value, (list, dict)):
        return json.dumps(value, ensure_ascii=False)
    if value is None:
        return ""
    if isinstance(value, bool):
        return "true" if value else "false"
    return str(value)


def fingerprint(row: dict[str, Any]) -> str:
    # Empreinte plus large que l'ancienne version : cela évite de bloquer trop vite
    # des exercices valides lorsque seule la disposition des options, le prompt ou
    # les données visuelles changent.
    raw = json.dumps(row, ensure_ascii=False, sort_keys=True, default=str)
    return hashlib.sha256(raw.encode("utf-8")).hexdigest()


class Deduper:
    def __init__(self, reset: bool = False, disabled: bool = False) -> None:
        self.cache_file = OUT_DIR / "offline_seen_hashes.txt"
        self.disabled = disabled
        if reset and self.cache_file.exists():
            self.cache_file.unlink()
        self.seen: set[str] = set()
        if self.cache_file.exists():
            self.seen = set(x.strip() for x in self.cache_file.read_text(encoding="utf-8").splitlines() if x.strip())

    def accept(self, row: dict[str, Any]) -> bool:
        # Mode spécial : utile si tu veux absolument remplir les CSV même quand
        # les générateurs à règles retombent sur des exercices déjà vus.
        if self.disabled:
            return True

        fp = fingerprint(row)
        if fp in self.seen:
            return False
        self.seen.add(fp)
        with open(self.cache_file, "a", encoding="utf-8") as f:
            f.write(fp + "\n")
        return True


# ═══════════════════════════════════════════════════════════════════════════
# 1. Attention visuelle
# ═══════════════════════════════════════════════════════════════════════════

NOMS = ["Martin", "Bernier", "Roche", "Lemoine", "Valette", "Moreau", "Garnier", "Dumas", "Perrin", "Blanc"]
PRENOMS = ["Lucas", "Nora", "Yanis", "Élise", "Hugo", "Sarah", "Noam", "Lina", "Mehdi", "Clara"]
RUES = ["rue des Acacias", "avenue Victor-Hugo", "boulevard Carnot", "impasse du Moulin", "allée des Pins"]
VILLES = ["Draguignan", "Fréjus", "Toulon", "Nîmes", "Vidauban", "Les Arcs"]
VEHICULES = ["Peugeot 308", "Renault Clio", "Citroën C3", "Ford Focus", "Dacia Duster", "Toyota Yaris"]


def mutate_text(text: str, difficulty: str) -> tuple[str, str]:
    if difficulty == "easy":
        replacements = [("rue", "avenue"), ("gris", "noir"), ("Nord", "Sud"), ("12", "21"), ("Clio", "Mégane")]
    elif difficulty == "medium":
        replacements = [("é", "e"), ("è", "e"), ("0", "O"), ("1", "I"), (",", "."), ("34", "43")]
    else:
        replacements = [(" l", "  l"), ("O", "0"), ("m", "rn"), ("i", "l"), (";", ","), ("é", "è")]
    random.shuffle(replacements)
    for a, b in replacements:
        if a in text:
            return text.replace(a, b, 1), f"Différence localisée : « {a} » a été remplacé par « {b} »."
    idx = max(0, min(len(text) - 1, random.randrange(len(text))))
    old = text[idx]
    new = random.choice([c for c in "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ" if c != old])
    return text[:idx] + new + text[idx + 1:], f"Différence localisée au caractère {idx + 1} : « {old} » devient « {new} »."


def gen_attention_one(i: int, difficulty: str) -> dict[str, Any]:
    plaque = f"{random.choice(string.ascii_uppercase)}{random.choice(string.ascii_uppercase)}-{random.randint(100,999)}-{random.choice(string.ascii_uppercase)}{random.choice(string.ascii_uppercase)}"
    base_short = f"{random.choice(PRENOMS)} {random.choice(NOMS)}, {plaque}, {random.randint(1,99)} {random.choice(RUES)}"
    base_medium = (
        f"Signalement : {random.choice(VEHICULES)} {random.choice(['gris','noir','blanc','bleu'])}, "
        f"plaque {plaque}, vu le {random.randint(10,28)}/0{random.randint(1,9)}/2026 à {random.randint(7,22)}h{random.choice(['05','15','30','45'])}."
    )
    base_hard = (
        f"Procès-verbal : le témoin indique avoir vu un individu quitter le secteur {random.choice(RUES)} "
        f"à {random.choice(VILLES)}, en direction du Nord, avec un sac sombre et une démarche rapide ; "
        f"la déclaration a été relue puis signée sans réserve."
    )
    base = {"easy": base_short, "medium": base_medium, "hard": base_hard}[difficulty]
    is_true = (i % 2 == 0)
    if is_true:
        text_b = base
        explanation = (
            "Les deux textes sont strictement identiques. Aucun mot, chiffre, accent, espace ou signe de ponctuation ne change entre la colonne de gauche et celle de droite. "
            "Le piège vient de la fatigue visuelle : la présence de chiffres, de noms propres et de ponctuation pousse souvent le candidat à imaginer une différence."
        )
    else:
        text_b, diff = mutate_text(base, difficulty)
        explanation = (
            "Les deux textes ne sont pas strictement identiques. "
            f"{diff} Cette variation est volontairement proche visuellement du texte source. "
            "Un candidat peut se tromper en lisant trop vite, surtout lorsque l’œil se concentre sur le sens général au lieu de comparer caractère par caractère."
        )
    return {
        "text_a": base,
        "text_b": text_b,
        "is_true": is_true,
        "explanation": explanation,
        "difficulty": difficulty,
        "is_active": True,
    }


# ═══════════════════════════════════════════════════════════════════════════
# 2. Suites logiques
# ═══════════════════════════════════════════════════════════════════════════

def gen_suite_one(difficulty: str) -> dict[str, Any]:
    prompt = "Quel terme manque ?"
    if difficulty == "Facile":
        kind = random.choice(["add", "mul", "sub", "squares"])
        if kind == "add":
            start, step = random.randint(1, 20), random.choice([2, 3, 4, 5, 10, 12])
            seq = [start + step * n for n in range(6)]
            hint = f"Progression arithmétique +{step}"
            expl_rule = f"La règle est une progression arithmétique de +{step}."
        elif kind == "mul":
            start, step = random.randint(1, 5), random.choice([2, 3, 5])
            seq = [start * (step ** n) for n in range(6)]
            hint = f"Multiplication par {step}"
            expl_rule = f"La règle est une multiplication par {step} à chaque étape."
        elif kind == "sub":
            start, step = random.randint(40, 90), random.choice([3, 5])
            seq = [start - step * n for n in range(6)]
            hint = f"Soustraction constante -{step}"
            expl_rule = f"La règle est une soustraction constante de {step}."
        else:
            seq = [n*n for n in range(1, 7)]
            hint = "Carrés parfaits"
            expl_rule = "La règle est la suite des carrés parfaits."
    elif difficulty == "Moyenne":
        kind = random.choice(["diffinc", "alt", "muladd", "letters"])
        if kind == "diffinc":
            seq = [random.randint(1, 8)]
            diff = random.randint(2, 4)
            for n in range(5):
                seq.append(seq[-1] + diff + n * 2)
            hint = "Différences croissantes"
            expl_rule = "La règle repose sur des différences qui augmentent progressivement."
        elif kind == "alt":
            a = random.randint(2, 9)
            seq = [a]
            for n in range(5):
                seq.append(seq[-1] + 2 if n % 2 == 0 else seq[-1] * 2)
            hint = "Alternance +2 puis ×2"
            expl_rule = "La règle alterne une addition de 2 puis une multiplication par 2."
        elif kind == "muladd":
            a = random.randint(2, 8)
            seq = [a]
            for _ in range(5):
                seq.append(seq[-1] * 2 + 1)
            hint = "×2 puis +1"
            expl_rule = "La règle est : multiplier par 2 puis ajouter 1."
        else:
            start = random.randint(1, 8)
            step = random.choice([2, 3, 4])
            seq = [chr(64 + start + step*n) for n in range(6)]
            hint = f"Lettres avec saut de {step}"
            expl_rule = f"La règle décale chaque lettre de {step} positions dans l'alphabet."
    else:
        kind = random.choice(["fib", "primes", "cubes", "quad", "letters_inc"])
        if kind == "fib":
            a, b = random.randint(1, 4), random.randint(3, 8)
            seq = [a, b]
            for _ in range(4):
                seq.append(seq[-1] + seq[-2])
            hint = "Fibonacci variante"
            expl_rule = "La règle est une variante de Fibonacci : chaque terme est la somme des deux précédents."
        elif kind == "primes":
            seq = [2, 3, 5, 7, 11, 13]
            hint = "Nombres premiers"
            expl_rule = "La règle est la suite des nombres premiers."
        elif kind == "cubes":
            seq = [n**3 for n in range(1, 7)]
            hint = "Cubes parfaits"
            expl_rule = "La règle est la suite des cubes parfaits."
        elif kind == "quad":
            seq = [n*n + n for n in range(1, 7)]
            hint = "n² + n"
            expl_rule = "La règle est la formule n² + n."
        else:
            nums = [1]
            step = 2
            for _ in range(5):
                nums.append(nums[-1] + step)
                step += 1
            seq = [chr(64 + n) for n in nums]
            hint = "Décalage alphabétique croissant"
            expl_rule = "La règle applique un décalage alphabétique croissant : +2, +3, +4, puis ainsi de suite."
    miss = random.randint(1, 5)
    answer = str(seq[miss])
    visible = [str(x) for x in seq]
    before = visible[miss - 1] if miss > 0 else visible[miss + 1]
    visible[miss] = "?"
    distractors = [answer]
    if answer.lstrip("-").isdigit():
        val = int(answer)
        distractors += [str(val + 1), str(val - 1), str(val + random.choice([2, 3, 5]))]
    else:
        pos = ord(answer) - 64
        distractors += [chr(64 + max(1, min(26, pos + d))) for d in [-1, 1, 2]]
    options, answer = shuffle_options(distractors, answer)
    return {
        "module": "psychotechnique",
        "category": "suites_logiques",
        "difficulty": difficulty,
        "sequence_text": ", ".join(visible),
        "prompt": prompt,
        "options": options,
        "answer": answer,
        "explanation": (
            f"{expl_rule} Le terme manquant est donc {answer}, car on applique la même règle au voisinage du point d'interrogation. "
            f"On peut vérifier la cohérence autour du terme précédent « {before} ». Le piège classique consiste à ne regarder qu'une différence locale et à oublier la règle globale de la suite."
        ),
        "hint": hint,
        "is_active": True,
    }


# ═══════════════════════════════════════════════════════════════════════════
# 3. Calcul mental
# ═══════════════════════════════════════════════════════════════════════════

def gen_calcul_one(difficulty: str) -> dict[str, Any]:
    if difficulty == "Facile":
        kind = random.choice(["add", "sub", "mul", "div", "pct"])
        if kind == "add":
            a, b = random.randint(11, 59), random.randint(11, 39)
            ans, expr = a + b, f"{a} + {b}"
            q = f"Combien font {a} + {b} ?"
            hint = "Arrondir puis ajuster"
        elif kind == "sub":
            a, b = random.randint(40, 99), random.randint(10, 39)
            ans, expr = a - b, f"{a} - {b}"
            q = f"Combien font {a} - {b} ?"
            hint = "Décomposer dizaines et unités"
        elif kind == "mul":
            a, b = random.randint(2, 10), random.randint(2, 10)
            ans, expr = a * b, f"{a} × {b}"
            q = f"Combien font {a} × {b} ?"
            hint = "Utiliser les tables"
        elif kind == "div":
            b = random.randint(2, 10)
            ans = random.randint(3, 12)
            a = ans * b
            expr = f"{a} / {b}"
            q = f"Combien font {a} / {b} ?"
            hint = "Retrouver la multiplication inverse"
        else:
            pct = random.choice([10, 25, 50])
            a = random.choice([40, 60, 80, 100, 120, 200])
            ans, expr = int(a * pct / 100), f"{pct} % de {a}"
            q = f"Combien font {pct} % de {a} ?"
            hint = "Utiliser moitié, quart ou dixième"
    elif difficulty == "Moyenne":
        kind = random.choice(["add3", "sub3", "mul12", "pct", "square"])
        if kind == "add3":
            a, b = random.randint(120, 499), random.randint(120, 499)
            ans, expr = a + b, f"{a} + {b}"
            q = f"Combien font {a} + {b} ?"
            hint = "Additionner centaines, dizaines, unités"
        elif kind == "sub3":
            a, b = random.randint(500, 999), random.randint(120, 499)
            ans, expr = a - b, f"{a} - {b}"
            q = f"Combien font {a} - {b} ?"
            hint = "Soustraction par compensation"
        elif kind == "mul12":
            a, b = random.randint(11, 29), random.choice([11, 12, 13, 14, 15])
            ans, expr = a * b, f"{a} × {b}"
            q = f"Combien font {a} × {b} ?"
            hint = "Distributivité"
        elif kind == "pct":
            pct = random.choice([15, 20, 30, 75])
            a = random.choice([80, 100, 120, 160, 180, 200, 240])
            ans, expr = int(a * pct / 100), f"{pct} % de {a}"
            q = f"Combien font {pct} % de {a} ?"
            hint = "Décomposer le pourcentage"
        else:
            a = random.randint(11, 19)
            ans, expr = a*a, f"{a}²"
            q = f"Combien font {a}² ?"
            hint = "Utiliser (10+n)²"
    else:
        kind = random.choice(["combo", "mul2", "frac", "pow", "root"])
        if kind == "combo":
            a, b, c = random.randint(20, 60), random.randint(3, 9), random.randint(30, 90)
            ans, expr = a*b - c, f"({a} × {b}) - {c}"
            q = f"Combien font ({a} × {b}) - {c} ?"
            hint = "Respecter les priorités"
        elif kind == "mul2":
            a, b = random.randint(21, 49), random.randint(16, 29)
            ans, expr = a*b, f"{a} × {b}"
            q = f"Combien font {a} × {b} ?"
            hint = "Décomposer le second facteur"
        elif kind == "frac":
            den = random.choice([3, 4, 5, 8])
            num = random.randint(2, den-1)
            base = den * random.randint(10, 40)
            ans, expr = base * num // den, f"{num}/{den} de {base}"
            q = f"Combien font {num}/{den} de {base} ?"
            hint = "Diviser puis multiplier"
        elif kind == "pow":
            a, p = random.choice([(2, 7), (3, 4), (5, 3), (4, 3)])
            ans, expr = a**p, f"{a}^{p}"
            q = f"Combien font {a}^{p} ?"
            hint = "Multiplier étape par étape"
        else:
            r = random.choice([12, 15, 17, 18, 20])
            ans, expr = r, f"√{r*r}"
            q = f"Combien vaut √{r*r} ?"
            hint = "Chercher le carré parfait"
    options, answer = shuffle_options([str(ans), str(ans+1), str(ans-1), str(ans+10)], str(ans))
    return {
        "module": "psychotechnique",
        "category": "calcul_mental",
        "difficulty": difficulty,
        "question": q,
        "expression": expr,
        "options": options,
        "answer": answer,
        "explanation": (
            f"Le calcul à effectuer est {expr}, ce qui donne {answer}. On peut le résoudre mentalement en décomposant les nombres et en gardant les priorités d'opérations. "
            "Le piège classique est d'aller trop vite : oubli d'une retenue, confusion entre multiplication et addition, ou mauvaise lecture du pourcentage."
        ),
        "hint": hint,
        "is_active": True,
    }


# ═══════════════════════════════════════════════════════════════════════════
# 4. Logique verbale
# ═══════════════════════════════════════════════════════════════════════════

SYNONYMS = [
    ("rapide", "prompt", ["lent", "bruyant", "fragile"]),
    ("méticuleux", "soigneux", ["négligent", "violent", "impatient"]),
    ("prolixe", "bavard", ["silencieux", "bref", "discret"]),
    ("cohérent", "logique", ["confus", "isolé", "fuyant"]),
    ("exhaustif", "complet", ["partiel", "rapide", "oral"]),
]
ANTONYMS = [
    ("généreux", "égoïste", ["aimable", "doux", "large"]),
    ("opaque", "transparent", ["sombre", "épais", "fermé"]),
    ("stable", "instable", ["fixe", "solide", "calme"]),
    ("prudent", "imprudent", ["attentif", "posé", "réfléchi"]),
    ("rare", "fréquent", ["unique", "ancien", "discret"]),
]
ANALOGIES = [
    ("Voiture est à route comme bateau est à ___", "mer", ["gare", "ciel", "forêt"]),
    ("Médecin est à stéthoscope comme policier est à ___", "radio", ["marteau", "pinceau", "boussole"]),
    ("Oiseau est à nid comme abeille est à ___", "ruche", ["terrier", "étable", "aquarium"]),
    ("Livre est à lire comme procès-verbal est à ___", "relater", ["peindre", "courir", "chanter"]),
]
INTRUS = [
    (["pomme", "poire", "carotte", "banane"], "carotte", "La carotte est un légume alors que les autres sont des fruits."),
    (["cuivre", "fer", "violon", "zinc"], "violon", "Le violon est un instrument alors que les autres sont des métaux."),
    (["lundi", "mardi", "janvier", "jeudi"], "janvier", "Janvier est un mois alors que les autres sont des jours."),
]
COMPLETIONS = [
    ("Malgré la pluie, il a ___ son chemin.", "poursuivi", ["abandonné", "éteint", "rangé"]),
    ("Le témoin donne une version ___ des faits.", "cohérente", ["liquide", "carrée", "bruyante"]),
]
CONTEXT = [
    ("Dans « la pièce était jointe au dossier », le mot pièce signifie :", "document", ["salle", "monnaie", "morceau"]),
    ("Dans « il a relevé la plaque », le mot relevé signifie :", "noté", ["soulevé", "augmenté", "corrigé"]),
]


def gen_verbale_one(difficulty: str) -> dict[str, Any]:
    kind = random.choice(["syn", "ant", "ana", "intrus", "comp", "ctx"])
    if kind == "syn":
        pivot, ans, bad = random.choice(SYNONYMS)
        q = f"Quel est le synonyme de « {pivot} » ?"
        prompt = ""
        hint = "Chercher un mot de sens proche."
    elif kind == "ant":
        pivot, ans, bad = random.choice(ANTONYMS)
        q = f"Quel est l'antonyme de « {pivot} » ?"
        prompt = ""
        hint = "Chercher le sens opposé."
    elif kind == "ana":
        q, ans, bad = random.choice(ANALOGIES)
        prompt = "Complète l'analogie."
        hint = "Identifier la relation entre les deux premiers termes."
    elif kind == "intrus":
        words, ans, why = random.choice(INTRUS)
        q = "Lequel de ces mots est l'intrus ?"
        prompt = ", ".join(words)
        bad = [w for w in words if w != ans]
        hint = "Chercher la catégorie commune."
    elif kind == "comp":
        q, ans, bad = random.choice(COMPLETIONS)
        prompt = "Complète la phrase avec le mot le plus juste."
        hint = "Vérifier le sens et la grammaire."
    else:
        q, ans, bad = random.choice(CONTEXT)
        prompt = "Sens contextuel."
        hint = "Lire la phrase avant de choisir."
    options, answer = shuffle_options([ans] + bad, ans)
    return {
        "module": "psychotechnique",
        "category": "logique_verbale",
        "difficulty": difficulty,
        "question": q,
        "prompt": prompt,
        "options": options,
        "answer": answer,
        "explanation": (
            f"La bonne réponse est « {answer} », car c'est le seul choix qui respecte exactement la relation demandée par l'énoncé. "
            f"Les autres propositions ({', '.join([o for o in options if o != answer])}) sont proches ou plausibles, mais elles ne conviennent pas au sens précis de la question. "
            "Le bon réflexe est d'identifier d'abord le type de relation : synonyme, contraire, catégorie, analogie ou contexte."
        ),
        "hint": hint,
        "is_active": True,
    }


# ═══════════════════════════════════════════════════════════════════════════
# 5. Raisonnement logique
# ═══════════════════════════════════════════════════════════════════════════

def gen_raisonnement_logique_one(difficulty: str) -> dict[str, Any]:
    kind = random.choice(["syllogism", "order", "condition", "age", "trap"])
    if kind == "syllogism":
        obj = random.choice(["véhicules de service", "rapports validés", "agents habilités"])
        cls = random.choice(["contrôlés", "archivés", "autorisés"])
        item = random.choice(["ce véhicule", "ce rapport", "cet agent"])
        prompt = f"Tous les {obj} sont {cls}. {item.capitalize()} appartient à la catégorie « {obj} »."
        q = "Quelle conclusion est forcément vraie ?"
        ans = f"{item.capitalize()} est {cls}."
        bad = ["On ne peut rien conclure.", f"{item.capitalize()} n'est pas {cls}.", f"Tous les éléments {cls} sont des {obj}."]
        structure = "syllogisme par appartenance"
    elif kind == "order":
        names = random.sample(["Nora", "Lucas", "Sarah", "Yanis", "Clara"], 4)
        prompt = f"{names[0]} est plus rapide que {names[1]}. {names[1]} est plus rapide que {names[2]}. {names[2]} est plus rapide que {names[3]}."
        q = "Qui est le plus rapide ?"
        ans = names[0]
        bad = names[1:]
        structure = "transitivité d'ordre"
    elif kind == "condition":
        prompt = "Si le dossier est complet, alors il est transmis. Le dossier est complet."
        q = "Que peut-on conclure ?"
        ans = "Le dossier est transmis."
        bad = ["Le dossier est incomplet.", "Le dossier n'est pas transmis.", "On ne peut pas savoir."]
        structure = "modus ponens"
    elif kind == "age":
        x = random.randint(8, 18)
        mother = 3*x
        prompt = f"Une personne a actuellement trois fois l'âge de son fils. Le fils a {x} ans."
        q = "Quel âge a cette personne ?"
        ans = str(mother)
        bad = [str(mother + 3), str(mother - 3), str(x + 3)]
        structure = "équation multiplicative simple"
    else:
        prompt = "Vous participez à une course. Vous doublez le deuxième."
        q = "Quelle est maintenant votre position ?"
        ans = "Deuxième"
        bad = ["Premier", "Troisième", "Dernier"]
        structure = "piège classique de position"
    options, answer = shuffle_options([ans] + bad, ans)
    return {
        "module": "psychotechnique",
        "category": "raisonnement_logique",
        "difficulty": difficulty,
        "question": q,
        "prompt": prompt,
        "options": options,
        "answer": answer,
        "explanation": (
            f"La structure logique est un {structure}. On part des prémisses données, puis on applique uniquement ce qui est explicitement autorisé par l'énoncé. "
            f"La conclusion correcte est donc « {answer} ». Le piège consiste à inverser la relation, à ajouter une hypothèse cachée ou à répondre intuitivement sans dérouler les étapes."
        ),
        "hint": "Réécris les informations sous forme de flèches ou d'ordre.",
        "is_active": True,
    }


# ═══════════════════════════════════════════════════════════════════════════
# 6. Spatial
# ═══════════════════════════════════════════════════════════════════════════

SYMBOL_SETS = [
    ["★", "●", "◆", "■", "▲", "▼"],
    ["A", "B", "C", "D", "E", "F"],
    ["⚑", "✚", "☐", "◇", "○", "△"],
]

def cube_figure() -> dict[str, Any]:
    s = random.choice(SYMBOL_SETS)
    return {
        "type": "cube_net",
        "layout": random.choice(["cross", "T", "L"]),
        "faces": {
            "top": s[0], "bottom": s[1], "left": s[2],
            "right": s[3], "front": s[4], "back": s[5],
        }
    }

def gen_spatial_one(difficulty: str) -> dict[str, Any]:
    kind = random.choice(["cube", "solid", "painted", "view"])
    if kind == "cube":
        fig = cube_figure()
        faces = fig["faces"]
        correct = {"top": faces["top"], "front": faces["front"], "right": faces["right"]}
        labels = [
            f"Dessus {correct['top']} / face {correct['front']} / droite {correct['right']}",
            f"Dessus {faces['bottom']} / face {faces['front']} / droite {faces['right']}",
            f"Dessus {faces['top']} / face {faces['back']} / droite {faces['right']}",
            f"Dessus {faces['top']} / face {faces['front']} / droite {faces['left']}",
        ]
        opts, ans_key = key_options(labels, labels[0])
        for o in opts:
            parts = o["label"]
            o["folded"] = {"description": parts}
        q = "Quel cube obtient-on en pliant ce patron ?"
        prompt = "Le patron de cube est décrit par six faces distinctes."
        expl = "Il faut plier mentalement le patron en conservant les oppositions de faces. Les faces visibles retenues sont le dessus, la face avant et la face droite. Le piège consiste à confondre une face opposée avec une face adjacente."
        hint = "Repérer d'abord les faces opposées."
    elif kind == "solid":
        solid, ans, bad = random.choice([
            ("cube", "6 faces", ["8 faces", "12 faces", "4 faces"]),
            ("tétraèdre régulier", "4 faces", ["6 faces", "8 faces", "12 faces"]),
            ("prisme triangulaire", "5 faces", ["4 faces", "6 faces", "8 faces"]),
        ])
        opts, ans_key = key_options([ans] + bad, ans)
        fig = None
        q = f"Combien de faces possède un {solid} ?"
        prompt = "Question de propriétés géométriques des solides."
        expl = f"On compte les faces planes du solide {solid}. La bonne réponse est {ans}, car chaque face correspond à une surface plane visible ou cachée. Le piège est de confondre faces, arêtes et sommets."
        hint = "Distinguer face, arête et sommet."
    elif kind == "painted":
        n = random.choice([3, 4, 5])
        ans = str(12 * (n - 2))
        bad = [str(8), str(6*(n-2)*(n-2)), str(n*n*n)]
        opts, ans_key = key_options([ans] + bad, ans)
        fig = {"type": "painted_cube", "size": n}
        q = f"Un cube {n}×{n}×{n} est peint puis découpé. Combien de petits cubes ont exactement 2 faces peintes ?"
        prompt = "Les petits cubes avec exactement deux faces peintes sont sur les arêtes, hors sommets."
        expl = f"Un cube possède 12 arêtes. Sur chaque arête d'un cube {n}×{n}×{n}, les cubes avec exactement deux faces peintes sont les {n-2} cubes hors sommets. On calcule donc 12 × ({n}-2) = {ans}."
        hint = "Compter les cubes d'arête sans les coins."
    else:
        solid, ans, bad = random.choice([
            ("cylindre droit vu de face", "rectangle", ["cercle", "triangle", "hexagone"]),
            ("cône vu de face", "triangle", ["carré", "rectangle", "losange"]),
            ("pyramide à base carrée vue de dessus", "carré", ["cercle", "rectangle seul", "pentagone"]),
        ])
        opts, ans_key = key_options([ans] + bad, ans)
        fig = {"type": "view", "solid": solid}
        q = f"Quelle forme principale observe-t-on pour un {solid} ?"
        prompt = "Il faut imaginer la projection du solide selon l'angle indiqué."
        expl = f"La transformation mentale demandée est une projection visuelle. Pour un {solid}, la forme principale obtenue est « {ans} ». Le piège est de répondre avec la forme de la base alors que la question précise l'angle de vue."
        hint = "Identifier l'angle de vue."
    return {
        "module": "psychotechnique",
        "category": "raisonnement_spatial",
        "difficulty": difficulty,
        "question": q,
        "prompt": prompt,
        "image_url": None,
        "figure_data": fig,
        "options": opts,
        "answer": ans_key,
        "explanation": expl,
        "hint": hint,
        "is_active": True,
    }


# ═══════════════════════════════════════════════════════════════════════════
# 7. Rotations symétries
# ═══════════════════════════════════════════════════════════════════════════

def gen_rotation_one(difficulty: str) -> dict[str, Any]:
    kind = random.choice(["axes", "rotation", "identity", "cube"])
    if kind == "axes":
        fig, ans, bad = random.choice([
            ("carré", "4", ["2", "1", "0"]),
            ("rectangle non carré", "2", ["4", "1", "0"]),
            ("triangle équilatéral", "3", ["1", "2", "4"]),
            ("hexagone régulier", "6", ["3", "4", "8"]),
        ])
        q = f"Combien d'axes de symétrie possède un {fig} ?"
        prompt = "On compte les axes qui superposent exactement la figure sur elle-même."
        ttype = "symétrie axiale"
        correct = ans
        labels = [ans] + bad
        expl = f"La transformation étudiée est la symétrie axiale. Un {fig} possède {ans} axe(s) de symétrie car seuls ces axes partagent la figure en deux parties superposables. Le piège est de compter des diagonales ou des médianes qui ne conservent pas toujours la figure."
    elif kind == "rotation":
        fig, ans, bad = random.choice([
            ("un carré", "4 rotations", ["2 rotations", "1 rotation", "8 rotations"]),
            ("le chiffre 8", "il reste identique", ["il devient 6", "il devient 3", "il disparaît"]),
            ("une rotation de 360°", "la figure initiale", ["une symétrie verticale", "une figure inversée", "un quart de tour"]),
        ])
        q = f"Que donne la rotation indiquée pour {fig} ?"
        prompt = "Analyse d'une rotation autour du centre de la figure."
        ttype = "rotation"
        correct = ans
        labels = [ans] + bad
        expl = f"La transformation est une rotation. Pour {fig}, la réponse correcte est « {ans} » car la figure conserve ou retrouve cette configuration après l'angle indiqué. Le piège est de confondre rotation et symétrie miroir."
    elif kind == "identity":
        q = "Une rotation de 180° autour d'un point équivaut à quelle transformation ?"
        prompt = "On compare deux transformations géométriques classiques."
        ttype = "symétrie centrale"
        correct = "symétrie centrale"
        labels = ["symétrie centrale", "symétrie axiale", "translation simple", "homothétie"]
        expl = "La transformation est une rotation de 180°. En géométrie plane, une rotation de 180° autour d'un centre correspond à une symétrie centrale. Le piège est de répondre symétrie axiale, qui inverse par rapport à une droite et non par rapport à un point."
    else:
        fig = cube_figure()
        faces = fig["faces"]
        q = "Quel cube obtient-on après rotation de 90° du patron autour de son axe vertical, puis pliage ?"
        prompt = "Patron de départ : six symboles distincts sur une croix de cube."
        ttype = "rotation"
        labels = [
            f"Dessus {faces['top']} / face {faces['right']} / droite {faces['back']}",
            f"Dessus {faces['top']} / face {faces['front']} / droite {faces['right']}",
            f"Dessus {faces['bottom']} / face {faces['right']} / droite {faces['front']}",
            f"Dessus {faces['top']} / face {faces['left']} / droite {faces['front']}",
        ]
        correct = labels[0]
        expl = "La transformation est une rotation de 90° avant le pliage. La face du haut reste prise comme repère, tandis que les faces latérales tournent autour de l'axe vertical. Le piège est de plier d'abord le cube puis d'appliquer une rotation mentale dans le mauvais sens."
        opts, ans_key = key_options(labels, correct)
        for o in opts:
            o["folded"] = {"description": o["label"]}
        return {
            "module": "psychotechnique",
            "category": "rotations_symetries",
            "difficulty": difficulty,
            "question": q,
            "prompt": prompt,
            "image_url": None,
            "figure_data": fig,
            "transformation_type": ttype,
            "options": opts,
            "answer": ans_key,
            "explanation": expl,
            "hint": "Fixer la face du haut puis tourner les faces autour d'elle.",
            "is_active": True,
        }
    opts, ans_key = key_options(labels, correct)
    return {
        "module": "psychotechnique",
        "category": "rotations_symetries",
        "difficulty": difficulty,
        "question": q,
        "prompt": prompt,
        "image_url": None,
        "figure_data": None,
        "transformation_type": ttype,
        "options": opts,
        "answer": ans_key,
        "explanation": expl,
        "hint": "Identifier d'abord le type de transformation.",
        "is_active": True,
    }


# ═══════════════════════════════════════════════════════════════════════════
# 8. Concentration
# ═══════════════════════════════════════════════════════════════════════════

def positions_of(stimulus: str, target: str, ignore_case: bool = True) -> list[int]:
    s = stimulus.lower() if ignore_case else stimulus
    t = target.lower() if ignore_case else target
    return [i + 1 for i, ch in enumerate(s) if ch == t]

def gen_concentration_one(difficulty: str) -> dict[str, Any]:
    kind = random.choice(["count_letter", "count_digit", "intrus", "same", "constraint"])
    if kind == "count_letter":
        stimulus = random.choice([
            "ALERTE AU PARC ARAGON AVANT ARRIVEE APPUI.",
            "Le rapport relate rapidement la remarque relevée par la patrouille.",
            "Aucune anomalie apparente avant appel au standard administratif.",
        ])
        target = random.choice(["a", "e", "r"])
        pos = positions_of(stimulus, target, True)
        ans = str(len(pos))
        options, answer = shuffle_options([ans, str(len(pos)+1), str(max(0, len(pos)-1)), str(len(pos)+2)], ans)
        q = f"Combien de fois la lettre « {target.upper()} » apparaît-elle dans cette phrase, majuscule ou minuscule ?"
        prompt = "Comptez attentivement chaque occurrence."
        expl = f"La lettre « {target.upper()} » apparaît aux positions {pos}, soit {ans} occurrence(s). Les distracteurs correspondent à un oubli ou à un comptage en trop. La bonne méthode consiste à balayer la phrase par petits groupes de mots."
        hint = "Balayer lentement de gauche à droite."
    elif kind == "count_digit":
        digits = "".join(random.choice("123456789") for _ in range(random.randint(18, 32)))
        target = random.choice("123456789")
        pos = positions_of(digits, target, False)
        ans = str(len(pos))
        options, answer = shuffle_options([ans, str(len(pos)+1), str(max(0, len(pos)-1)), str(len(pos)+2)], ans)
        q = f"Combien de chiffres « {target} » contient la suite ?"
        prompt = "Comptez uniquement le chiffre demandé."
        stimulus = digits
        expl = f"Le chiffre « {target} » apparaît aux positions {pos}, soit {ans} occurrence(s). Les autres réponses sont des erreurs typiques de +1 ou -1. La méthode fiable est de regrouper mentalement la suite par paquets de trois caractères."
        hint = "Faire des groupes de trois."
    elif kind == "intrus":
        seq = ["B", "D", "F", "H", "J", "L"]
        intr = random.choice(["K", "M", "P"])
        insert = random.randint(1, len(seq)-1)
        seq.insert(insert, intr)
        ans = intr
        options, answer = shuffle_options([ans, "B", "D", "L"], ans)
        q = "Quelle lettre est l'intrus dans la suite ?"
        prompt = "La suite suit normalement les lettres paires de l'alphabet."
        stimulus = " ".join(seq)
        expl = f"L'intrus est « {ans} » car la suite attend des lettres placées une position sur deux dans l'alphabet. Les autres lettres respectent la progression régulière. Le piège consiste à regarder seulement l'ordre alphabétique sans vérifier le saut constant."
        hint = "Convertir les lettres en positions alphabétiques."
    elif kind == "same":
        model = f"PV-{random.randint(100,999)}-{random.choice(['AB','AC','BA','CA'])}-{random.randint(10,99)}"
        variants = [model, model.replace("-", " ", 1), model[:-1] + str((int(model[-1]) + 1) % 10), model.replace("PV", "VP")]
        options, answer = shuffle_options(variants, model)
        q = "Quelle séquence est strictement identique au modèle ?"
        prompt = f"Modèle : {model}"
        stimulus = "Comparez les propositions au modèle."
        expl = f"La séquence correcte est « {answer} » car elle reprend exactement tous les caractères du modèle. Les autres propositions changent un tiret, un chiffre ou l'ordre des lettres. Le piège est de lire le code globalement au lieu de vérifier chaque caractère."
        hint = "Comparer caractère par caractère."
    else:
        stimulus = "PV URGENT : ALEX NOTE 48 CODES ET 12 AVIS."
        vowels = [i+1 for i, ch in enumerate(stimulus) if ch in "AEIOUY"]
        ans = str(len(vowels))
        options, answer = shuffle_options([ans, str(len(vowels)+1), str(max(0, len(vowels)-1)), str(len(vowels)+2)], ans)
        q = "Combien de voyelles majuscules contient cette phrase ?"
        prompt = "Comptez uniquement A, E, I, O, U, Y en majuscule."
        expl = f"Les voyelles majuscules sont aux positions {vowels}, soit {ans} au total. Les chiffres et consonnes ne doivent pas être comptés. Le piège est d'inclure les lettres minuscules ou de compter les espaces et la ponctuation."
        hint = "Ne compter que les voyelles majuscules."
    return {
        "module": "psychotechnique",
        "category": "concentration",
        "difficulty": difficulty,
        "question": q,
        "prompt": prompt,
        "stimulus": stimulus,
        "options": options,
        "answer": answer,
        "explanation": expl,
        "hint": hint,
        "is_active": True,
    }


GENERATORS = {
    "01_attention_visuelle": lambda diff, i: gen_attention_one(i, diff),
    "02_suites_logiques": lambda diff, i: gen_suite_one(diff),
    "03_calcul_mental": lambda diff, i: gen_calcul_one(diff),
    "04_logique_verbale": lambda diff, i: gen_verbale_one(diff),
    "05_raisonnement_logique": lambda diff, i: gen_raisonnement_logique_one(diff),
    "06_raisonnement_spatial": lambda diff, i: gen_spatial_one(diff),
    "07_rotations_symetries": lambda diff, i: gen_rotation_one(diff),
    "08_concentration": lambda diff, i: gen_concentration_one(diff),
}


def difficulties_for(stem: str, batch_size: int) -> list[str]:
    if stem == "01_attention_visuelle":
        base = ATT_DIFFS
        result = []
        for i in range(batch_size):
            result.append(base[i % 3])
        return result
    result = []
    for i in range(batch_size):
        result.append(DIFFS[i % 3])
    return result


def normalize_row(row: dict[str, Any], table: str) -> dict[str, Any]:
    cols = CSV_COLUMNS_BY_TABLE[table]
    clean = {}
    for col in cols:
        clean[col] = row.get(col)
    return clean


def validate_row(row: dict[str, Any], table: str) -> tuple[bool, str]:
    if len(str(row.get("explanation", ""))) < 60:
        return False, "explication trop courte"
    if table == "tests_psyco_attention_visuelle":
        if not row.get("text_a") or not row.get("text_b"):
            return False, "text_a/text_b manquant"
        if not isinstance(row.get("is_true"), bool):
            return False, "is_true invalide"
        return True, ""
    if table == "tests_psyco_suite_logique" and not row.get("sequence_text"):
        return False, "sequence_text manquant"
    if table != "tests_psyco_suite_logique" and not row.get("question"):
        return False, "question manquante"
    options = row.get("options")
    answer = row.get("answer")
    if not isinstance(options, list) or len(options) != 4:
        return False, "options doit contenir 4 choix"
    if table in ("tests_psyco_raisonnement_spatial", "tests_psyco_rotations_symetries"):
        keys = [o.get("key") for o in options if isinstance(o, dict)]
        if answer not in keys:
            return False, "answer absente des clés A-D"
    else:
        if answer not in [str(o) for o in options]:
            return False, "answer absente des options"
    return True, ""


def csv_path_for(stem: str) -> Path:
    """
    Sauvegarde dans un sous-dossier par exercice :
      out/csv/calcul_mental/calcul_mental_20260508.csv

    C'est volontairement un fichier par jour et par exercice :
    - il est simple à importer dans Supabase ;
    - il grossit en continu pendant la boucle ;
    - sa date de modification bouge à chaque écriture.
    """
    slug = SLUG_BY_STEM[stem]
    day = time.strftime("%Y%m%d")
    folder = CSV_DIR / slug
    folder.mkdir(parents=True, exist_ok=True)
    return folder / f"{slug}_{day}.csv"


def append_csv(stem: str, rows: list[dict[str, Any]]) -> Path | None:
    if not rows:
        return None
    table = EXERCISE_TO_TABLE[stem]
    cols = CSV_COLUMNS_BY_TABLE[table]
    path = csv_path_for(stem)
    new_file = not path.exists()

    with open(path, "a", newline="", encoding="utf-8-sig") as f:
        writer = csv.DictWriter(f, fieldnames=cols, delimiter=";")
        if new_file:
            writer.writeheader()
        for row in rows:
            writer.writerow({c: json_for_csv(row.get(c)) for c in cols})

    return path


def insert_supabase(table: str, rows: list[dict[str, Any]]) -> int:
    if not rows:
        return 0
    try:
        from supabase import create_client
    except Exception as e:
        log(f"SUPABASE ignoré : package manquant ({e})")
        return 0

    url = os.getenv("SUPABASE_URL")
    key = os.getenv("SUPABASE_SERVICE_KEY")
    if not url or not key:
        log("SUPABASE ignoré : SUPABASE_URL ou SUPABASE_SERVICE_KEY manquant dans .env")
        return 0

    sb = create_client(url, key)
    # Pour insertion directe, il faut garder list/dict en natif, pas les JSON strings CSV.
    sb.table(table).insert(rows).execute()
    return len(rows)


def run_once(stem: str, batch_size: int, deduper: Deduper, insert: bool, strict_dedup: bool = False) -> tuple[int, int, int]:
    table = EXERCISE_TO_TABLE[stem]
    generated: list[dict[str, Any]] = []
    rejected = 0
    duplicates = 0
    errors = 0
    duplicate_written = 0

    diffs = difficulties_for(stem, batch_size)
    for i, diff in enumerate(diffs):
        accepted = False
        last_valid_row: dict[str, Any] | None = None

        # Beaucoup plus de tentatives : les générateurs offline à règles ont
        # naturellement moins de variété qu'une IA.
        for _ in range(80):
            try:
                row = GENERATORS[stem](diff, i)
            except Exception as e:
                errors += 1
                rejected += 1
                # On ne laisse jamais une catégorie faire tomber la génération de nuit.
                continue

            ok_row, reason = validate_row(row, table)
            if not ok_row:
                rejected += 1
                continue

            row = normalize_row(row, table)
            last_valid_row = row

            if not deduper.accept(row):
                duplicates += 1
                continue

            generated.append(row)
            accepted = True
            break

        # Mode nuit : si on a une question valide mais déjà vue, on l'écrit quand
        # même pour garantir que le CSV avance et éviter les lignes à 0 toute la nuit.
        # Pour un anti-doublon strict, lancer avec --strict-dedup.
        if not accepted:
            if last_valid_row is not None and not strict_dedup:
                generated.append(last_valid_row)
                duplicate_written += 1
            else:
                rejected += 1

    saved_path = append_csv(stem, generated)
    inserted = insert_supabase(table, generated) if insert else 0

    # Code couleur demandé :
    # - vert si 50 ou + générées
    # - orange si entre 1 et 49
    # - rouge si 0
    if len(generated) >= batch_size:
        color = COL.GREEN
        status = "OK"
    elif len(generated) > 0:
        color = COL.ORANGE
        status = "PARTIEL"
    else:
        color = COL.RED
        status = "ZERO"

    extra = f" | doublons écrits={duplicate_written}" if duplicate_written else ""
    extra += f" | erreurs protégées={errors}" if errors else ""

    if saved_path:
        log(
            f"{status} | {stem} → générées CSV={len(generated)} | insérées Supabase={inserted} | "
            f"doublons={duplicates} | rejetées={rejected}{extra} | fichier={saved_path}",
            color,
        )
    else:
        log(
            f"{status} | {stem} → générées CSV=0 | insérées Supabase={inserted} | "
            f"doublons={duplicates} | rejetées={rejected}{extra} | aucun fichier écrit",
            color,
        )
    return len(generated), duplicates, rejected

def parse_args() -> argparse.Namespace:
    p = argparse.ArgumentParser(description="COP'IQ — générateur psychotechnique 100% offline")
    p.add_argument("exercise", nargs="?", help="Ex: 03_calcul_mental ou 03_calcul_mental.md")
    p.add_argument("--all", action="store_true", help="Générer une fois toutes les catégories")
    p.add_argument("--forever", action="store_true", help="Boucle infinie jusqu'à Ctrl+C")
    p.add_argument("--runs", type=int, default=1, help="Nombre de cycles en mode non-forever")
    p.add_argument("--batch-size", type=int, default=50, help="Nombre de questions par catégorie et par cycle")
    p.add_argument("--pause", type=float, default=1.0, help="Pause entre catégories")
    p.add_argument("--cycle-pause", type=float, default=5.0, help="Pause entre cycles complets")
    p.add_argument("--insert-supabase", action="store_true", help="Insérer directement dans Supabase en plus du CSV")
    p.add_argument("--seed", type=int, default=None, help="Seed aléatoire optionnelle")
    p.add_argument("--reset-dedup", action="store_true", help="Vide le cache anti-doublons avant de commencer")
    p.add_argument("--allow-duplicates", action="store_true", help="Désactive l'anti-doublons et écrit tout dans les CSV")
    p.add_argument("--strict-dedup", action="store_true", help="N'écrit jamais une question déjà vue, même si cela donne moins de 50 lignes")
    return p.parse_args()


def main() -> None:
    args = parse_args()
    if args.seed is not None:
        random.seed(args.seed)

    if args.all or args.forever:
        targets = list(EXERCISE_TO_TABLE.keys())
    else:
        if not args.exercise:
            log("Erreur : indique un exercice, --all ou --forever")
            sys.exit(2)
        stem = args.exercise.replace(".md", "")
        if stem not in EXERCISE_TO_TABLE:
            log(f"Exercice inconnu : {stem}")
            sys.exit(2)
        targets = [stem]

    deduper = Deduper(reset=args.reset_dedup, disabled=args.allow_duplicates)
    if args.reset_dedup:
        log("Cache anti-doublons vidé avant démarrage.", COL.CYAN)
    if args.allow_duplicates:
        log("Anti-doublons désactivé : toutes les questions valides seront écrites.", COL.ORANGE)
    log("COP'IQ OFFLINE — aucune API utilisée, aucune clé IA nécessaire.", COL.MAGENTA)
    log(f"Cibles : {', '.join(targets)}")
    log(f"CSV : {CSV_DIR}")

    cycle = 0
    try:
        while True:
            cycle += 1
            total = dup = rej = 0
            log(f"===== CYCLE {cycle} =====", COL.BLUE)
            random.shuffle(targets)
            for stem in targets:
                a, b, c = run_once(stem, args.batch_size, deduper, args.insert_supabase, args.strict_dedup)
                total += a
                dup += b
                rej += c
                time.sleep(args.pause)
            log(f"BILAN CYCLE {cycle} → CSV={total} | doublons={dup} | rejetées={rej}", COL.BOLD + COL.WHITE)

            if not args.forever and cycle >= args.runs:
                break
            time.sleep(args.cycle_pause)
    except KeyboardInterrupt:
        log("Arrêt demandé par Ctrl+C. Les CSV déjà créés restent dans /out/csv.")


if __name__ == "__main__":
    main()
