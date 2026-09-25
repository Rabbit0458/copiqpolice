"""Canonical subtopic taxonomy for category='Histoire' generation.

Derived directly from the périmètre lists in the spec (Histoire de France +
Institutions françaises). Used to:
  - assign each generation request a subtopic (stored as generation_subtopic)
  - let the scheduler balance coverage across subtopics instead of letting the
    model drift toward a handful of "easy" recurring facts (the failure mode
    already observed in the existing 750k-row bank).

Quotas are NOT hardcoded here — the scheduler (pipeline/scheduler.py, Phase 3)
reads current per-subtopic/per-difficulty counts from the staging table at
runtime and always fills whichever (subtopic, difficulty) pair is furthest
below its even share of the 50,000 target for that difficulty. This file only
defines the fixed vocabulary of valid subtopics.
"""

HISTOIRE_SUBTOPICS = [
    "gaule_conquete_romaine",
    "periode_gallo_romaine",
    "royaumes_francs_merovingiens",
    "carolingiens_charlemagne",
    "capetiens_monarchie_feodale",
    "guerre_de_cent_ans_jeanne_darc",
    "renaissance_francaise",
    "guerres_de_religion",
    "monarchie_absolue_louis_xiii_richelieu",
    "louis_xiv_ancien_regime",
    "siecle_des_lumieres",
    "revolution_francaise_etats_generaux",
    "declaration_droits_homme_citoyen",
    "monarchie_constitutionnelle_convention_terreur",
    "directoire_consulat",
    "napoleon_premier_empire",
    "restauration_monarchie_de_juillet",
    "revolution_1848_deuxieme_republique",
    "second_empire_napoleon_iii",
    "guerre_franco_prussienne_commune_de_paris",
    "troisieme_republique",
    "premiere_guerre_mondiale",
    "entre_deux_guerres",
    "seconde_guerre_mondiale_regime_de_vichy",
    "resistance_france_libre_liberation",
    "quatrieme_republique_decolonisation",
    "guerre_indochine_guerre_algerie",
    "naissance_cinquieme_republique",
    "mai_1968",
    "evolution_politique_contemporaine",
    "grandes_lois_et_reformes",
    "grands_personnages_historiques",
    "grandes_crises_politiques",
    "histoire_administrative_et_constitutionnelle",
    "evolution_territoriale",
    "grandes_dates_evenements_fondateurs",
]

INSTITUTIONS_FR_SUBTOPICS = [
    "constitution_1958_principes_et_revisions",
    "bloc_de_constitutionnalite_hierarchie_des_normes",
    "president_election_pouvoirs",
    "president_dissolution_referendum_pouvoirs_exceptionnels",
    "gouvernement_premier_ministre_conseil_des_ministres",
    "article_49_49_3_ordonnances",
    "parlement_assemblee_nationale_senat",
    "procedure_legislative_navette_amendements",
    "conseil_constitutionnel_qpc",
    "autorite_judiciaire_csm_juridictions",
    "conseil_detat",
    "cour_de_cassation",
    "cour_des_comptes",
    "collectivites_territoriales_decentralisation",
    "administration_francaise_fonction_publique",
]

ALL_SUBTOPICS = HISTOIRE_SUBTOPICS + INSTITUTIONS_FR_SUBTOPICS

# Subtopics whose correct answer can change over time (current officeholders,
# current composition of a body, current headcounts...). These get routed
# through the web_search fact-check pass and MUST carry reference_date /
# verified_at / source_name / source_url before reaching READY_FOR_IMPORT.
TIME_SENSITIVE_SUBTOPICS = {
    "president_election_pouvoirs",
    "gouvernement_premier_ministre_conseil_des_ministres",
    "parlement_assemblee_nationale_senat",
    "conseil_constitutionnel_qpc",
    "collectivites_territoriales_decentralisation",
    "evolution_politique_contemporaine",
}
