#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
COP'IQ — Génère une migration SQL d'import à partir des lots JSON.

Chaîne de production complète d'un lot :

    1.  écrire  scripts/cas_pratique/lots/lot_NN.json
    2.  python scripts/cas_pratique/controle_qualite.py \
            scripts/cas_pratique/lots/lot_NN.json \
            --contre scripts/cas_pratique/catalogue_existant.json
    3.  corriger jusqu'à « Aucune erreur bloquante »
    4.  python scripts/cas_pratique/generer_migration.py --lot lot_NN
    5.  supabase db push
    6.  python scripts/cas_pratique/generer_migration.py --verifier

La migration produite est idempotente : elle repose sur fn_cp_import_case,
qui upsert sur le `slug`. La rejouer ne crée pas de doublon et ne touche pas
aux tentatives utilisateur (celles-ci référencent le cas, pas les questions).

⚠️ Ne jamais éditer le .sql généré à la main : il serait écrasé au prochain
lancement. La source de vérité est le JSON.
"""

from __future__ import annotations

import argparse
import json
import sys
from datetime import date
from pathlib import Path

RACINE = Path(__file__).resolve().parents[2]
DOSSIER_LOTS = Path(__file__).resolve().parent / "lots"
DOSSIER_MIGRATIONS = RACINE / "supabase" / "migrations"

ENTETE = """-- ════════════════════════════════════════════════════════════════════════════
--  COP'IQ — Cas Pratique — Import de lot (catalogue 500)
--
--  Généré par scripts/cas_pratique/generer_migration.py à partir des fichiers
--  scripts/cas_pratique/lots/*.json, après passage au contrôle qualité
--  (scripts/cas_pratique/controle_qualite.py) sans erreur bloquante.
--
--  IDEMPOTENT : chaque appel à fn_cp_import_case upsert sur le slug. Rejouer
--  cette migration ne crée aucun doublon et ne touche aucune tentative
--  utilisateur existante.
--
--  Ne pas éditer ce fichier à la main : modifier le JSON source et régénérer.
-- ════════════════════════════════════════════════════════════════════════════

BEGIN;
"""

REQUETE_VERIFICATION = """
-- À exécuter après « supabase db push » pour contrôler l'état du catalogue.
SELECT
  (SELECT count(*) FROM public.cas_pratique_cases)                          AS total,
  (SELECT count(*) FROM public.cas_pratique_cases WHERE status='published') AS publies,
  (SELECT count(*) FROM public.cas_pratique_cases WHERE is_free)            AS gratuits,
  (SELECT count(*) FROM public.cas_pratique_questions)                      AS questions,
  (SELECT count(*) FROM public.cas_pratique_rubric_points)                  AS criteres,
  (SELECT count(*) FROM public.cas_pratique_keywords)                       AS mots_cles;

-- Cas sans question : anomalie d'import, à traiter avant publication.
SELECT c.slug
FROM public.cas_pratique_cases c
LEFT JOIN public.cas_pratique_questions q ON q.case_id = c.id
GROUP BY c.slug HAVING count(q.id) = 0;

-- Critères de grille sans aucun mot-clé : ils ne pourront jamais être validés
-- par le moteur de correction, l'étudiant perdrait les points quoi qu'il écrive.
SELECT c.slug, rp.label
FROM public.cas_pratique_rubric_points rp
JOIN public.cas_pratique_questions q ON q.id = rp.question_id
JOIN public.cas_pratique_cases c     ON c.id = q.case_id
LEFT JOIN public.cas_pratique_keyword_groups kg ON kg.point_id = rp.id
LEFT JOIN public.cas_pratique_keywords k        ON k.group_id  = kg.id
GROUP BY c.slug, rp.label HAVING count(k.id) = 0;
"""


def echapper(valeur: str) -> str:
    """Échappe une chaîne pour un littéral SQL simple."""
    return valeur.replace("'", "''")


def charger_lots(motif: str) -> list[tuple[Path, list[dict]]]:
    fichiers = sorted(DOSSIER_LOTS.glob(f"{motif}.json"))
    if not fichiers:
        print(f"Aucun lot ne correspond à « {motif} » dans {DOSSIER_LOTS}", file=sys.stderr)
        sys.exit(1)
    return [(f, json.loads(f.read_text(encoding="utf-8"))) for f in fichiers]


def generer(motif: str, nom_migration: str | None) -> Path:
    lots = charger_lots(motif)

    corps: list[str] = []
    total = 0
    for chemin, cas_du_lot in lots:
        corps.append(f"-- ─── Source : {chemin.name} ───")
        for cas in cas_du_lot:
            slug = cas.get("slug")
            if not slug:
                print(f"Cas sans slug dans {chemin.name}", file=sys.stderr)
                sys.exit(1)
            charge = echapper(json.dumps(cas, ensure_ascii=False))
            corps.append(
                f"-- {slug} — {cas.get('title', '')}\n"
                f"SELECT public.fn_cp_import_case('{echapper(slug)}', '{charge}'::jsonb);\n"
            )
            total += 1

    horodatage = date.today().strftime("%Y%m%d")
    nom = nom_migration or f"{horodatage}000000_cas_pratique_{motif.replace('*', 'lots')}.sql"
    sortie = DOSSIER_MIGRATIONS / nom
    sortie.write_text(ENTETE + "\n" + "\n".join(corps) + "\nCOMMIT;\n", encoding="utf-8")

    print(f"Migration générée : {sortie.name}")
    print(f"  {total} cas, {sortie.stat().st_size} octets")
    print("  Appliquer avec : supabase db push")
    return sortie


def main() -> int:
    ap = argparse.ArgumentParser(description="Génère la migration d'import d'un lot de cas pratiques")
    ap.add_argument("--lot", default="lot_*", help="motif de fichier, ex. lot_pilote_a (défaut : tous)")
    ap.add_argument("--nom", default=None, help="nom du fichier de migration à produire")
    ap.add_argument("--verifier", action="store_true",
                    help="affiche les requêtes de vérification post-import")
    args = ap.parse_args()

    if args.verifier:
        print(REQUETE_VERIFICATION)
        return 0

    generer(args.lot, args.nom)
    return 0


if __name__ == "__main__":
    sys.exit(main())
