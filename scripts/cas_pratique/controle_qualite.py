#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
COP'IQ — Contrôle qualité du catalogue de cas pratiques.

Ce script est le garde-fou de la montée à 500 cas. Il s'exécute sur un lot
AVANT import (mode fichier) ou sur le catalogue complet APRÈS import
(mode export SQL), et refuse un lot qui introduirait un doublon.

Pourquoi un script plutôt qu'une relecture humaine : à 500 cas, la mémoire
humaine ne détecte plus les collisions. Deux cas écrits à trois semaines
d'intervalle sur « victime de VIF qui refuse de porter plainte » passeront
inaperçus à la relecture mais sont un doublon pédagogique.

CONTRÔLES
  1. Unicité stricte    — slugs et titres normalisés.
  2. Similarité titre   — Jaccard sur tokens normalisés.
  3. Similarité scénario— Jaccard sur shingles de 4 mots. Détecte le
                          copier-coller avec changement de prénom/lieu/heure,
                          que la comparaison de titres laisse passer.
  4. Complétude         — champs obligatoires, longueurs minimales.
  5. Cohérence grille   — somme des points, nombre de critères.
  6. Répartition        — thème, difficulté, gratuit/premium.

USAGE
    python controle_qualite.py lot.json
    python controle_qualite.py lot.json --contre catalogue_existant.json
    python controle_qualite.py --strict lot.json    # code retour ≠ 0 si alerte

Le format JSON attendu est celui consommé par fn_cp_seed_legacy_case :
    [{ "slug": "...", "title": "...", "situation_text": "...",
       "theme_slug": "...", "difficulty": "...", "is_free": true,
       "questions": [ { "position":1, "label":"...", "perfect":"...",
                        "points": [...] } ] }]
"""

from __future__ import annotations

import argparse
import json
import re
import sys
import unicodedata
from collections import Counter, defaultdict
from pathlib import Path

# ─── Seuils ──────────────────────────────────────────────────────────────────
# Calibrage empirique sur les 22 cas d'origine, confronté à un doublon
# volontaire (même scénario VIF, prénoms/lieux/nombres changés) :
#
#                        max entre cas légitimes   doublon volontaire
#   shingles de 3 mots            0.050                  0.362
#   sac de mots                   0.136                  0.731
#   shingles de 4 mots            0.000                  0.243
#
# Les shingles de 4 laissaient passer le doublon sous un seuil raisonnable ;
# on descend à 3 et on ajoute une seconde mesure. Les deux sont complémentaires :
#   • les shingles détectent le copier-coller (l'ordre des mots est conservé) ;
#   • le sac de mots détecte la reformulation (mêmes ingrédients, phrases
#     réécrites), que les shingles manquent complètement.
# Un cas est signalé si l'UNE des deux mesures dépasse son seuil.
#
# Les seuils sont placés à ~3× le maximum légitime observé, soit encore ~2×
# sous le doublon volontaire : marge confortable des deux côtés.
SEUIL_TITRE = 0.55          # au-delà : titres trop proches
SEUIL_SCENARIO = 0.15       # shingles — copier-coller
SEUIL_SCENARIO_SAC = 0.35   # sac de mots — reformulation superficielle
SHINGLE = 3                 # taille des n-grammes de mots pour le scénario

LONGUEUR_MIN_SITUATION = 350    # une situation plus courte ne pose pas de vrai
                                # problème à résoudre
LONGUEUR_MIN_PERFECT = 250      # une réponse modèle plus courte n'est pas un
                                # modèle exploitable
MIN_QUESTIONS = 2
MIN_POINTS_PAR_QUESTION = 3

DIFFICULTES = {"facile", "moyen", "difficile", "expert"}

THEMES_VALIDES = {
    "deontologie", "procedure-penale", "controle-identite", "usage-force",
    "violences-conjugales", "mineurs", "circulation", "stupefiants",
    "secours-personnes", "accueil-public", "police-secours",
    "atteintes-biens", "numerique", "ordre-public", "gestion-conflits",
    "equipe-hierarchie", "personnes-vulnerables", "discriminations",
    "situations-sensibles", "situations-exceptionnelles",
}

# Mots vides : ils gonflent artificiellement la similarité. « Un policier
# adjoint intervient » et « Une policière intervient » partagent surtout des
# mots vides, pas du sens.
MOTS_VIDES = {
    "le", "la", "les", "un", "une", "des", "du", "de", "d", "l", "et", "ou",
    "a", "au", "aux", "en", "dans", "sur", "sous", "par", "pour", "avec",
    "sans", "vous", "il", "elle", "ils", "elles", "on", "se", "sa", "son",
    "ses", "que", "qui", "ne", "pas", "plus", "est", "sont", "etre", "avoir",
    "ce", "cet", "cette", "y", "vers", "chez", "lui", "leur", "leurs",
}

# Éléments cosmétiques : leur variation ne crée PAS un cas différent. On les
# neutralise avant comparaison, sinon changer « Léa, 12 ans » en « Tom,
# 14 ans » suffirait à faire passer un doublon pour un cas neuf.
RE_HEURE = re.compile(r"\b\d{1,2}\s*[h:]\s*\d{0,2}\b")
RE_NOMBRE = re.compile(r"\b\d+\b")


def sans_accents(texte: str) -> str:
    nfkd = unicodedata.normalize("NFKD", texte)
    return "".join(c for c in nfkd if not unicodedata.combining(c))


def normaliser(texte: str) -> str:
    """Réduit un texte à sa substance comparable."""
    t = sans_accents((texte or "").lower())
    t = RE_HEURE.sub(" ", t)
    t = RE_NOMBRE.sub(" ", t)
    t = re.sub(r"[^a-z\s]", " ", t)
    return re.sub(r"\s+", " ", t).strip()


def tokens(texte: str) -> list[str]:
    return [m for m in normaliser(texte).split() if m not in MOTS_VIDES and len(m) > 2]


def jaccard(a: set, b: set) -> float:
    if not a or not b:
        return 0.0
    return len(a & b) / len(a | b)


def shingles(texte: str, n: int = SHINGLE) -> set[tuple]:
    """N-grammes de mots : capture l'ordre, donc le copier-coller."""
    mots = tokens(texte)
    if len(mots) < n:
        return {tuple(mots)} if mots else set()
    return {tuple(mots[i:i + n]) for i in range(len(mots) - n + 1)}


class Rapport:
    def __init__(self) -> None:
        self.erreurs: list[str] = []
        self.alertes: list[str] = []
        self.infos: list[str] = []

    def erreur(self, msg: str) -> None:
        self.erreurs.append(msg)

    def alerte(self, msg: str) -> None:
        self.alertes.append(msg)

    def info(self, msg: str) -> None:
        self.infos.append(msg)

    @property
    def ok(self) -> bool:
        return not self.erreurs


def controler_completude(cas: dict, rap: Rapport) -> None:
    slug = cas.get("slug", "<sans slug>")

    for champ in ("slug", "title", "situation_text", "theme_slug", "difficulty"):
        if not (cas.get(champ) or "").strip():
            rap.erreur(f"[{slug}] champ obligatoire vide : {champ}")

    if cas.get("difficulty") not in DIFFICULTES:
        rap.erreur(f"[{slug}] difficulté invalide : {cas.get('difficulty')!r}")

    if cas.get("theme_slug") not in THEMES_VALIDES:
        rap.erreur(f"[{slug}] thème inconnu : {cas.get('theme_slug')!r}")

    situation = cas.get("situation_text") or ""
    if len(situation) < LONGUEUR_MIN_SITUATION:
        rap.alerte(
            f"[{slug}] situation courte ({len(situation)} car., "
            f"minimum conseillé {LONGUEUR_MIN_SITUATION})"
        )

    questions = cas.get("questions") or []
    if len(questions) < MIN_QUESTIONS:
        rap.erreur(f"[{slug}] {len(questions)} question(s), minimum {MIN_QUESTIONS}")

    total_declare = cas.get("total_points")
    total_calcule = 0

    for q in questions:
        pos = q.get("position", "?")
        if not (q.get("label") or "").strip():
            rap.erreur(f"[{slug}] question {pos} sans intitulé")

        perfect = q.get("perfect") or ""
        if len(perfect) < LONGUEUR_MIN_PERFECT:
            rap.alerte(
                f"[{slug}] Q{pos} réponse modèle courte ({len(perfect)} car.)"
            )

        points = q.get("points") or []
        if len(points) < MIN_POINTS_PAR_QUESTION:
            rap.alerte(
                f"[{slug}] Q{pos} seulement {len(points)} critère(s) de grille"
            )

        total_calcule += q.get("max_points", 5)

        for p in points:
            if not (p.get("label") or "").strip():
                rap.erreur(f"[{slug}] Q{pos} critère de grille sans libellé")
            if not (p.get("groups") or []):
                rap.erreur(
                    f"[{slug}] Q{pos} critère « {p.get('label', '?')[:40]} » "
                    f"sans groupe de mots-clés : il ne pourra jamais être validé"
                )

    if total_declare is not None and total_calcule != total_declare:
        rap.alerte(
            f"[{slug}] total_points déclaré {total_declare} ≠ "
            f"somme des questions {total_calcule}"
        )


def controler_doublons(lot: list[dict], reference: list[dict], rap: Rapport) -> None:
    """Compare le lot à lui-même ET au catalogue de référence."""
    univers = reference + lot

    vus_slug: dict[str, str] = {}
    vus_titre: dict[str, str] = {}

    for cas in univers:
        slug = cas.get("slug", "")
        if slug in vus_slug:
            rap.erreur(f"slug dupliqué : {slug}")
        vus_slug[slug] = slug

        titre_norm = normaliser(cas.get("title", ""))
        if titre_norm and titre_norm in vus_titre:
            rap.erreur(
                f"titre identique après normalisation : "
                f"« {cas.get('title')} » ≈ « {vus_titre[titre_norm]} »"
            )
        vus_titre[titre_norm] = cas.get("title", "")

    # Pré-calcul : évite de re-tokeniser à chaque couple.
    empreintes = [
        {
            "slug": c.get("slug", ""),
            "titre": c.get("title", ""),
            "tok_titre": set(tokens(c.get("title", ""))),
            "sh_scenario": shingles(c.get("situation_text", "")),
            "sac_scenario": set(tokens(c.get("situation_text", ""))),
            "nouveau": c in lot,
        }
        for c in univers
    ]

    for i, a in enumerate(empreintes):
        for b in empreintes[i + 1:]:
            # Un couple de deux cas déjà en base n'est pas actionnable ici.
            if not a["nouveau"] and not b["nouveau"]:
                continue

            st = jaccard(a["tok_titre"], b["tok_titre"])
            if st >= SEUIL_TITRE:
                rap.alerte(
                    f"titres proches ({st:.0%}) : "
                    f"{a['slug']} « {a['titre']} » ↔ {b['slug']} « {b['titre']} »"
                )

            ss = jaccard(a["sh_scenario"], b["sh_scenario"])
            sac = jaccard(a["sac_scenario"], b["sac_scenario"])

            if ss >= SEUIL_SCENARIO or sac >= SEUIL_SCENARIO_SAC:
                cause = []
                if ss >= SEUIL_SCENARIO:
                    cause.append(f"enchaînement de mots {ss:.0%}")
                if sac >= SEUIL_SCENARIO_SAC:
                    cause.append(f"vocabulaire {sac:.0%}")
                rap.erreur(
                    f"scénarios trop proches ({', '.join(cause)}) : "
                    f"{a['slug']} ↔ {b['slug']} — changer la problématique, "
                    f"pas seulement les noms, lieux et horaires"
                )


def controler_repartition(lot: list[dict], reference: list[dict], rap: Rapport) -> None:
    total = reference + lot

    par_theme = Counter(c.get("theme_slug") for c in total)
    par_diff = Counter(c.get("difficulty") for c in total)
    par_acces = Counter("gratuit" if c.get("is_free", True) else "premium" for c in total)

    rap.info(f"Catalogue : {len(total)} cas ({len(reference)} existants + {len(lot)} nouveaux)")

    rap.info("Répartition par difficulté :")
    for d in ("facile", "moyen", "difficile", "expert"):
        n = par_diff.get(d, 0)
        pct = (n / len(total) * 100) if total else 0
        rap.info(f"    {d:<10} {n:>4}  ({pct:4.1f} %)")

    rap.info("Répartition par accès :")
    for a, n in par_acces.most_common():
        rap.info(f"    {a:<10} {n:>4}")

    rap.info("Répartition par thème :")
    for t, n in sorted(par_theme.items(), key=lambda kv: -kv[1]):
        rap.info(f"    {t:<28} {n:>4}")

    manquants = THEMES_VALIDES - set(par_theme)
    if manquants:
        rap.info(f"Thèmes encore vides : {', '.join(sorted(manquants))}")


def charger(chemin: Path) -> list[dict]:
    with chemin.open(encoding="utf-8") as f:
        data = json.load(f)
    return data if isinstance(data, list) else [data]


def main() -> int:
    ap = argparse.ArgumentParser(description="Contrôle qualité des cas pratiques COP'IQ")
    ap.add_argument("lot", type=Path, help="fichier JSON du lot à contrôler")
    ap.add_argument("--contre", type=Path, default=None,
                    help="catalogue existant à comparer (JSON)")
    ap.add_argument("--strict", action="store_true",
                    help="retourne un code d'erreur même sur simple alerte")
    args = ap.parse_args()

    lot = charger(args.lot)
    reference = charger(args.contre) if args.contre else []

    rap = Rapport()
    for cas in lot:
        controler_completude(cas, rap)
    controler_doublons(lot, reference, rap)
    controler_repartition(lot, reference, rap)

    print("═" * 74)
    print(f"  CONTRÔLE QUALITÉ — {args.lot.name}")
    print("═" * 74)

    for i in rap.infos:
        print(f"  {i}")

    if rap.alertes:
        print(f"\n  ── {len(rap.alertes)} alerte(s) ──")
        for a in rap.alertes:
            print(f"  ⚠  {a}")

    if rap.erreurs:
        print(f"\n  ── {len(rap.erreurs)} erreur(s) bloquante(s) ──")
        for e in rap.erreurs:
            print(f"  ✗  {e}")
    else:
        print("\n  ✓  Aucune erreur bloquante.")

    print("═" * 74)

    if rap.erreurs:
        return 1
    if args.strict and rap.alertes:
        return 2
    return 0


if __name__ == "__main__":
    sys.exit(main())
