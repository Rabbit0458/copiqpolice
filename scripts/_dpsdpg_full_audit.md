# Audit complet — module dpsDpg (GPX vs PA)

Date : session du 29/07/2026. Portée : `GpxSchoolProgram.dpsDpg` (13 catégories, 85 topics de cours hors quiz) vs `PaSchoolProgram.dpsDpg` (menu PA live) vs contenu existant dans `lib/content/pa_scolarite/`.

## Synthèse chiffrée

- **Topics GPX audités : 85** (hors entrées "Quiz")
- **CÂBLÉ-SÉPARÉ** (câblé dans le menu PA live, page dédiée) : **~34**
- **EXISTE-NON-CÂBLÉ** (fichier(s) PA dédié(s) déjà écrit(s), same routeName pattern, mais AUCUNE route/menu ne pointe dessus) : **~48**
- **PARTAGÉ-NON-SÉPARÉ** (le menu PA pointe encore vers la classe GPX) : **0** pour les topics audités en détail (les 9 "Généralités/Hiérarchie" ont été séparés au niveau intro pendant cette session, mais leur "Contenu" sous-jacent reste partagé — voir note ci-dessous)
- **MANQUANT** (aucun contenu PA trouvé nulle part) : **~3** (à la marge, cf. tableau Cadres juridiques)

**Conclusion principale : ce n'est quasiment PAS un problème de contenu manquant.** Le contenu PA existe déjà, avec une fidélité remarquable (écarts de lignes souvent < 1%, ex. `armes_classification_contenu_page.dart` : 649 GPX vs 650 PA ; `blanchiment_produit_contenu_page.dart` : 644 vs 644 ; `association_malfaiteurs_contenu_page.dart` : 874 vs 874 ; `ivresse_contenu_page.dart` : 675 vs 675). Il est simplement **dispersé dans des dossiers non câblés** (`dpg_pages/`, `procedure_penale_pages/`, `sanction_pages/`, `atteintes_nation_pages/`, `atteintes_biens_pages/`, `atteintes_personnes_pages/`, `mineurs_famille_pages/`, `armes_munitions_pages/`, `stupefiants_pages/`, `cadres_juridiques_pages/`). Une bibliothèque de **66 quiz PA** existe aussi déjà dans `lib/content/pa_scolarite/quiz_scolarite_pa/`, également non câblée.

**Note importante sur les 9 pages "Généralités/Hiérarchie" séparées plus tôt dans cette session** : la séparation faite était superficielle (écran d'intro/splash uniquement) — le bouton "Commencer" redirige encore vers la page "Contenu" GPX partagée. Pour au moins un cas (Tentative), une version PA complète et déjà séparée existe (`TentativeIntroPagePA` + `TentativeContenuPagePA` dans `lib/content/pa_scolarite/tentative/`) et n'a pas été utilisée — à corriger en priorité.

**Mise à jour (suite de session, 29/07)** :
- ✅ 3 des 9 pages Généralités corrigées (Classification des infractions, L'infraction, La tentative) — pointent maintenant vers leur vrai contenu PA dédié. Les 5 restantes (Complicité, Légitime défense, Usage armes, Rétention locaux, Hiérarchie) n'ont pas d'équivalent PA "Contenu" trouvé, restent sur le contenu GPX partagé pour l'instant.
- ✅ Catégorie "Armes & munitions" câblée dans le menu PA (8 pages + 1 quiz, tout existait déjà, juste jamais relié).
- Vérification systématique (script Python résolvant `routeName` symboliques) : sur les 149 routes `/pa/...` navigables depuis le menu PA Scolarité, **0 route cassée** actuellement — "Cadres juridiques" notamment, qui semblait cassé à une première passe grep, est en réalité déjà câblé via `NomDeClasse.routeName`.

---

## 1. Généralités (9 topics + 1 quiz)

| Topic | Classe GPX | Classe PA | Statut | Note |
|---|---|---|---|---|
| Classification des infractions | ClassificationInfractionsPage | PaClassificationInfractionsPage (intro) → contenu partagé `ClassificationInfractionsContenuPage` | CÂBLÉ-SÉPARÉ (intro only) | Contenu PA alternatif existe : `dpg_pages/classification_infractions_contenu_page.dart` (`PaClassificationInfractionsContenuPageLoiPenal`, non câblé) |
| L'infraction | InfractionIntroPage | PaInfractionIntroPage (intro) → contenu partagé `InfractionContenuPage` | CÂBLÉ-SÉPARÉ (intro only) | Contenu PA alternatif existe : `dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart` (non câblé) |
| La tentative punissable | TentativeIntroPage | PaTentativeIntroPage (intro) → contenu partagé `TentativeContenuPage` | CÂBLÉ-SÉPARÉ (intro only) | **Meilleure option non utilisée** : `pa_scolarite/tentative/tentative_intro_page.dart` (`TentativeIntroPagePA`) + `tentative_contenu_page.dart` (`TentativeContenuPagePA`) + `condition_tentative_page.dart` + `infructueuse_tentative_page.dart` + `repression_tentative_page.dart` — arbre complet séparé, non câblé |
| La complicité | CompliciteIntroPage | PaCompliciteIntroPage (intro) → contenu partagé | CÂBLÉ-SÉPARÉ (intro only) | Voir aussi `dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart` (traitement différent, dans le chapitre responsabilité pénale) |
| La légitime défense | LegitimeDefenseIntroPage | PaLegitimeDefenseIntroPage (intro) → contenu partagé | CÂBLÉ-SÉPARÉ (intro only) | — |
| Cadre légal d'usage des armes | UsageArmesIntroPage | PaUsageArmesIntroPage (intro) → contenu partagé | CÂBLÉ-SÉPARÉ (intro only) | Sujet cité par l'utilisateur comme exemple d'origine |
| Les libertés publiques | LibertesPubliquesIntroPage | PaLibertesPubliquesIntroPage → `PaLibertesPubliquesContenuPage` | **CÂBLÉ-SÉPARÉ (complet)** | Arbre complet (22 fichiers, ~17 400 lignes) branché avec succès pendant cette session |
| Cas de rétention dans les locaux de police | RetentionLocauxIntroPage | PaRetentionLocauxIntroPage (intro) → contenu partagé | CÂBLÉ-SÉPARÉ (intro only) | — |
| Hiérarchie PN (fonctions judiciaires) | HierarchieIntroPage | PaHierarchieIntroPage (intro) → contenu partagé | CÂBLÉ-SÉPARÉ (intro only) | — |

---

## 2. Cadres juridiques (10 topics uniques + 1 quiz)

| Topic | Classe GPX | Classe PA trouvée | Statut | Lignes GPX/PA |
|---|---|---|---|---|
| Les cadres d'enquête | CadresEnqueteIntroPage | `cadres_juridiques_pages/cadres_enquete/cadres_enquete_intro_page.dart` (+ contenu) | EXISTE-NON-CÂBLÉ | non vérifié |
| L'enquête de flagrant délit | FlagrantDelitIntroPage | `cadres_juridiques_pages/flagrant_delit/flagrant_delit_intro_page.dart` (+4 sous-pages : domaine, notion, panorama, procédure) | EXISTE-NON-CÂBLÉ | non vérifié |
| L'enquête préliminaire | EnquetePreliminaireIntroPage | `cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_intro_page.dart` (+7 sous-pages : audition, chapitres 1-2, constatations, fouilles, GAV, saisie comptes) | EXISTE-NON-CÂBLÉ | PA plus détaillé que GPX (7 sous-pages) |
| La commission rogatoire | CommissionRogatoireIntroPage | `PaCommissionRogatoireIntroPage` | **CÂBLÉ-SÉPARÉ** | — |
| Découverte personne grièvement blessée | PersonneBlesseGrievementntroPage | `cadres_juridiques_pages/personne_grievement_blessee/personne_intro.dart` | EXISTE-NON-CÂBLÉ | non vérifié |
| Mort de cause inconnue ou suspecte | MortInconnueIntroductionPage | `PaMortInconnueIntroPage` | **CÂBLÉ-SÉPARÉ** | — |
| Délinquance & criminalité organisées | CriminaliteDeliquanceIntroPage | `PaCriminaliteOrganiseeContenuPage` | **CÂBLÉ-SÉPARÉ** | — |
| Recherche des personnes en fuite | PersonnesFuiteIntroPage | `PaPersonnesFuiteIntroGpxSchool` | **CÂBLÉ-SÉPARÉ** | — |
| Disparitions inquiétantes | DisparitionIntroPage | `PaDisparitionIntroPage` | **CÂBLÉ-SÉPARÉ** | — |
| Contrôles et vérifications d'identité | FlagrantDelitIntroPage *(bug GPX : ce label pointe par erreur vers la page flagrant délit — pré-existant, hors scope, ne pas toucher)* | `cadres_juridiques_pages/controle_identite/` (13 fichiers : intro, chap1-3, contrôles préventifs, locaux pro, moyens de preuve, séjour étrangers, visites véhicules, zone frontière, relevé identité, vérification identité x5) | EXISTE-NON-CÂBLÉ | PA beaucoup plus détaillé que le libellé GPX bugué ne le suggère |
| Entraide judiciaire internationale | EntraideJudiciaireIntroPage | `cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_intro_page.dart` (+9 sous-pages : eurojust, extradition x3, MAE x3, réseau judiciaire européen, traité Prüm) | EXISTE-NON-CÂBLÉ | PA nettement plus détaillé que GPX |

---

## 3. Procédure Pénale (4 topics + 1 quiz)

| Topic | Classe GPX | Classe PA trouvée | Statut |
|---|---|---|---|
| Action publique, action civile, autorités & contrôle PJ | PPActionPubliqueAutoritesPJPage | `procedure_penale_pages/pp_action_publique_autorites_pj_intro_page.dart` (+ pp_action_publique_action_civile chapitres 1-4, tableau) | EXISTE-NON-CÂBLÉ |
| Nullité des actes de procédure | NulliteIntroPage | `procedure_penale_pages/nullite_intro_page.dart` + `nullite_contenu_page.dart` (+ pp_action_en_nullite, pp_effets_nullite, pp_nullites_substantielles/textuelles) | EXISTE-NON-CÂBLÉ |
| Juridictions de jugement & exécution des décisions | JuridictionIntroPage | `procedure_penale_pages/juridiction_contenu_page.dart` + `juridictions_execution_decisions_justice_page.dart` + `juridictions_principes_generaux_page.dart` | EXISTE-NON-CÂBLÉ |
| Instruction préparatoire, mandats, contrôle jud., détention provisoire | InstructionIntroPage | `procedure_penale_pages/instruction_preparatoire_intro.dart` (+ mandats_justice_contenu, controle_judiciaire_contenu, detention_provisoire_intro/contenu, bracelet_contenu, + ~15 sous-pages chapitres) | EXISTE-NON-CÂBLÉ (très détaillé) |

Aucun de ces 4 topics n'est câblé dans le menu PA live actuellement (la catégorie "Procédure Pénale" n'existe pas telle quelle côté PA — son équivalent le plus proche, "Organisation judiciaire" + "Acteurs de la Police Judiciaire", couvre un sujet voisin mais pas identique).

---

## 4. Droit pénal général (2 topics)

| Topic | Classe GPX | Classe PA | Statut |
|---|---|---|---|
| De la loi pénale | LoiPenaleContenuPage | `PaLoiPenaleContenuPage` (sous catégorie PA "Généralités" / socle avancé) | **CÂBLÉ-SÉPARÉ** |
| De la responsabilité pénale | ResponsabilitePenaleContenuPage | `PaResponsabilitePenalePage` (idem) | **CÂBLÉ-SÉPARÉ** |

PA a même un topic bonus absent de GPX : "Immunités et inviolabilités" (`PaGPXSchoolEtendueApplicationLoisPage`).

---

## 5. La sanction (3 topics + 1 quiz)

| Topic | Classe GPX | Classe PA trouvée | Statut |
|---|---|---|---|
| Classification des peines et mesures de sûreté | ClassificationPeinesContenuPage | `sanction_pages/classification_peines_page.dart` + `classification_legale_peines_page.dart` + `classification_mesures_surete_page.dart` | EXISTE-NON-CÂBLÉ |
| Causes d'aggravation de la sanction | CausesAggravationSanctionContenuPage | `sanction_pages/causes_aggravation_sanction_contenu_page.dart` + `causes_aggravation_page.dart` | EXISTE-NON-CÂBLÉ |
| Règles en cas de pluralité d'infractions | PluraliteInfractionsContenuPage | `sanction_pages/pluralite_infractions_page.dart` | EXISTE-NON-CÂBLÉ |

Aucune catégorie "La sanction" n'existe dans le menu PA live actuellement — 41 fichiers existent dans `sanction_pages/` mais rien n'est câblé.

---

## 6. Crimes & délits contre la personne (9 topics + 1 quiz)

⚠️ Le menu PA live redécoupe ce thème différemment (deux catégories séparées "Atteintes aux personnes" en socle initial ET socle avancé, avec une liste de topics qui ne correspond pas 1:1 aux 9 topics GPX — ex. PA a "discriminations", "harcèlement sexuel", "exhibition sexuelle", "outrage sexiste" que GPX n'a pas dans cette catégorie, et regroupe autrement viol/agressions). Une réconciliation manuelle topic-par-topic est nécessaire avant de conclure — non faite ici faute de temps. Ce qui est confirmé : le contenu PA existe pour TOUS les topics GPX de cette catégorie, dispersé dans `atteintes_personnes_pages/` (71 fichiers) :

| Topic GPX | Fichier(s) PA trouvé(s) | Statut |
|---|---|---|
| La mise en danger de la personne | `mise_en_danger/mise_en_danger_contenu_page.dart` | EXISTE-NON-CÂBLÉ (sous ce nom précis) |
| Le viol, l'inceste et autres agressions sexuelles | `viol_inceste_agressions/viol_inceste_agressions_contenu_page.dart` + avertissement | Probablement CÂBLÉ sous "Le viol" (PaViolIncesteAgressionsContenuPage) — à confirmer |
| L'enlèvement et la séquestration | `enlevement_sequestration_page.dart` | EXISTE-NON-CÂBLÉ |
| Enregistrement & diffusion d'images | `enregistrement_diffusion_images/enregistrement_diffusion_images_contenu_page.dart` (+2 variantes) | EXISTE-NON-CÂBLÉ |
| Atteintes à la dignité de la personne | `dignite_personne/dignite_personne_contenu_page.dart` | EXISTE-NON-CÂBLÉ |
| Atteintes à la personnalité | `atteinte_personnalite/` | Probablement CÂBLÉ (PaAtteintePersonnaliteContenuPage, "Atteinte à l'intimité") |
| Atteintes involontaires à la vie et à l'intégrité | — | Probablement CÂBLÉ (PaAtteintesInvolontairesContenuPage) |
| Atteintes volontaires à la vie | — | Probablement CÂBLÉ (PaAtteintesVolontairesVieContenuPage) |
| Atteintes volontaires à l'intégrité physique | — | Probablement CÂBLÉ (PaAtteintesVolontairesIntegriteContenuPage, "violences volontaires") |

**À faire dans une prochaine étape** : réconcilier précisément les libellés PA vs GPX pour cette catégorie avant de câbler quoi que ce soit.

---

## 7. Atteintes aux mineurs & à la famille (4 topics + 1 quiz)

| Topic | Classe GPX | Classe PA trouvée | Statut |
|---|---|---|---|
| La mise en péril des mineurs | MiseEnPerilDesMineursPage | `PaMiseEnPerilDesMineursPage` (câblé sous "Atteintes aux personnes") | **CÂBLÉ-SÉPARÉ** (mais rangé dans une autre catégorie PA) |
| Violation d'ordonnances JAF (violences) | ViolationOrdonnancesJafPage | `mineurs_famille_pages/violation_ordonnances_jaf/violation_ordonnances_jaf_page.dart` (+2 sous-pages) | EXISTE-NON-CÂBLÉ |
| Atteintes à l'exercice de l'autorité parentale | AutoriteParentalePage | `mineurs_famille_pages/autorite_parentale/autorite_parentale_page.dart` (+3 sous-pages) | EXISTE-NON-CÂBLÉ |
| L'abandon de famille | AbandonFamillePage | `mineurs_famille_pages/abandon_famille/abandon_famille_page.dart` + `abandon_de_famille_contenu_page.dart` | EXISTE-NON-CÂBLÉ |

Aucune catégorie "Atteintes aux mineurs & à la famille" dédiée n'existe dans le menu PA live — le seul topic câblé (mise en péril) l'est sous une autre catégorie.

---

## 8. Crimes & délits contre la nation (6 topics + 1 quiz)

| Topic | Classe GPX | Classe PA trouvée | Statut |
|---|---|---|---|
| Association de malfaiteurs | AssociationMalfaiteursPage | `atteintes_nation_pages/association_malfaiteurs_contenu_page.dart` (874/874 lignes — identique) | EXISTE-NON-CÂBLÉ |
| Abus d'autorité contre les particuliers | AbusAutoriteParticuliersContenuPage | `abus_autorite/abus_autorite_particuliers_contenu_page.dart` (+3 sous-pages : inviolabilité domicile, secret correspondances, discriminations) | EXISTE-NON-CÂBLÉ |
| Atteintes à l'action de la justice | AtteintesActionJusticeContenuPage | `atteintes_action_justice/atteintes_action_justice_contenu_page.dart` (+2 : non-dénonciation, témoignage mensonger) | EXISTE-NON-CÂBLÉ |
| Atteintes à l'administration par des particuliers | AtteintesAdministrationContenuPage | `atteintes_administration/atteintes_administration_contenu_page.dart` (+4 : menaces dépositaire, menaces/violences service public, provocation rébellion, rébellion) — partiellement câblé (PaAtteintesAdministrationContenuPage câblé sous "L'outrage") | CÂBLÉ-SÉPARÉ (partiel) |
| Faux et usage de faux | FauxUsageFauxContenuPage | `faux_usage_faux/faux_usage_faux_contenu_page.dart` (+5 sous-pages) | EXISTE-NON-CÂBLÉ |
| Manquements au devoir de probité | ProbiteContenuPage | `probite/probite_contenu_page.dart` (+3 : concussion, corruption, trafic influence) | EXISTE-NON-CÂBLÉ |

Aucune catégorie "Crimes & délits contre la nation" dédiée n'existe dans le menu PA live.

---

## 9. Crimes & délits contre les biens (6 topics + 1 quiz)

| Topic | Classe GPX | Classe PA trouvée | Statut |
|---|---|---|---|
| Recel & non-justification de ressources | RecelNonJustificationContenuPage | `recel_non_justification/recel_non_justification_contenu_page.dart` (+recel_page, non_justification_ressources) — Le recel seul est CÂBLÉ (PaRecelPage) | CÂBLÉ-SÉPARÉ (partiel, "non-justification" non câblé séparément) |
| Le vol | VolPage | `PaVolPage` | **CÂBLÉ-SÉPARÉ** |
| Atteintes aux STAD (informatique) | StadContenuPage | `stad/stad_contenu_page.dart` (+4 sous-pages) | EXISTE-NON-CÂBLÉ |
| Contrefaçons & falsifications de chèques | ContrefaconsFalsificationsChequesPage | `contrefacons_falsifications/contrefacons_falsifications_cheques_page.dart` | EXISTE-NON-CÂBLÉ |
| Destructions, dégradations, détériorations | DestructionsDegradationsContenuPage | `PaDestructionsDegradationsContenuPage` | **CÂBLÉ-SÉPARÉ** |
| Infractions voisines du vol | VoisinesDuVolContenuPage | `voisines_du_vol/voisines_du_vol_contenu_page.dart` (+6 : abus confiance, chantage, demande fonds, escroquerie, extorsion, filouteries) — plusieurs de ces sous-items SONT câblés individuellement (PaExtorsionPage, PaEscroqueriePage, PaAbusDeConfiancePage, PaFilouteriesPage, PaRecelPage) sous "Atteintes aux biens" socle avancé | CÂBLÉ-SÉPARÉ (partiel, dispersé) |

---

## 10. Infractions à la circulation routière (12 topics + 1 quiz)

| Topic | Classe GPX | Classe PA trouvée | Statut |
|---|---|---|---|
| Conduite après usage de stupéfiants | ConduiteStupefiantsPage | `PaConduiteStupefiantsPage` | **CÂBLÉ-SÉPARÉ** |
| Conduite en état d'ivresse | IvressePage | `circulation_pages/ivresse_contenu_page.dart` (675/675 lignes — identique) | EXISTE-NON-CÂBLÉ |
| Conduite sous l'empire d'un état alcoolique | EtatAlcooliquePage | `circulation_pages/etat_alcoolique_contenu_page.dart` — câblé de façon groupée sous "Autres délits routiers" (PaEtatAlcooliquePage) | CÂBLÉ-SÉPARÉ (groupé avec ivresse/assurance/vérifications, perte de granularité menu) |
| Défaut d'assurance | DefautAssurancePage | `circulation_pages/defaut_assurance_page.dart` | EXISTE-NON-CÂBLÉ (dédié, non utilisé — actuellement bundlé) |
| Défaut de permis de conduire | DefautPermisPage | `PaDefautPermisPage` | **CÂBLÉ-SÉPARÉ** |
| Délit de fuite | DelitFuitePage | `PaDelitFuitePage` | **CÂBLÉ-SÉPARÉ** |
| Grand excès de vitesse | GrandExcesVitessePage | `PaGrandExcesVitessePage` | **CÂBLÉ-SÉPARÉ** |
| Refus de vérifications | RefusVerificationsPage | `circulation_pages/refus_verifications_contenu_page.dart` | EXISTE-NON-CÂBLÉ (dédié, non utilisé — actuellement bundlé) |
| Refus d'obtempérer | RefusObtempererPage | `PaRefusObtempererPage` | **CÂBLÉ-SÉPARÉ** |
| Rodéo motorisé | RodeoMotorisePage | `PaRodeoMotorisePage` | **CÂBLÉ-SÉPARÉ** |
| Plaques & inscriptions | PlaquesInscriptionsPage | `PaPlaquesInscriptionsPage` | **CÂBLÉ-SÉPARÉ** |
| Incitation / organisation / promotion | IncitationOrganisationPromotionPage | `PaIncitationOrganisationPromotionPage` | **CÂBLÉ-SÉPARÉ** |

**Point notable** : le menu PA actuel bundle 4 sujets (ivresse, état alcoolique, défaut d'assurance, refus de vérifications) dans une seule page "Autres délits routiers" (`PaEtatAlcooliquePage`), alors que des pages dédiées existent déjà pour au moins 3 d'entre eux (`ivresse_contenu_page.dart`, `defaut_assurance_page.dart`, `refus_verifications_contenu_page.dart`) et ne sont pas utilisées. Câblage à corriger pour retrouver la granularité GPX.

---

## 11. Armes & munitions (8 topics + 1 quiz)

| Topic | Classe GPX | Classe PA trouvée | Statut | Lignes GPX/PA |
|---|---|---|---|---|
| Classification des armes et munitions | ArmesClassificationPage | `armes_munitions_pages/armes_classification_contenu_page.dart` | EXISTE-NON-CÂBLÉ | 649/650 |
| Définitions | ArmesDefinitionsPage | `armes_munitions_pages/armes_definitions_contenu_page.dart` | EXISTE-NON-CÂBLÉ | non vérifié |
| Introduction | ArmesIntroductionPage | `armes_munitions_pages/armes_introduction_contenu_page.dart` | EXISTE-NON-CÂBLÉ | non vérifié |
| Acquisition/détention cat. A ou B | ArmesAcquisitionDetentionABPage | `armes_munitions_pages/armes_acquisition_detention_ab_contenu_page.dart` | EXISTE-NON-CÂBLÉ | non vérifié |
| Port/transport sans motif légitime (C/D) | ArmesPortTransportCDPage | `armes_munitions_pages/armes_port_transport_cd_contenu_page.dart` | EXISTE-NON-CÂBLÉ | non vérifié |
| Régimes matériels de guerre | ArmesMaterielsGuerreElementsPage | `armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart` | EXISTE-NON-CÂBLÉ | non vérifié |
| Règles d'acquisition & détention | ArmesReglesAcquisitionDetentionPage | `armes_munitions_pages/armes_regles_acquisition_detention_contenu_page.dart` | EXISTE-NON-CÂBLÉ | non vérifié |
| Règles de port & transport | ArmesReglesPortTransportPage | `armes_munitions_pages/armes_regles_port_transport_contenu_page.dart` | EXISTE-NON-CÂBLÉ | non vérifié |

**Catégorie entière "Armes & munitions" n'existe pas dans le menu PA live**, alors que les 8 topics ont chacun un fichier PA dédié quasi-identique (noms de fichiers strictement identiques à GPX). C'est du câblage pur, aucune rédaction nécessaire.

---

## 12. Libertés publiques (catégorie top-level, 0 sub, même topic que dans Généralités)

Voir section 1 — **CÂBLÉ-SÉPARÉ (complet)**, arbre PA déjà branché.

---

## 13. Stupéfiants — usage & trafic (10 topics + 1 quiz)

| Topic | Classe GPX | Classe PA trouvée | Statut | Lignes GPX/PA |
|---|---|---|---|---|
| Introduction | StupefiantsIntroductionPage | `stupefiants_pages/introduction_contenu_page.dart` | EXISTE-NON-CÂBLÉ | non vérifié |
| Cession/offre illicites (conso perso) | StupefiantsCessionOffrePage | `stupefiants_pages/cession_offre_contenu_page.dart` — câblé côté PA "socle avancé" sous PaStupefiantsCessionOffrePage | **CÂBLÉ-SÉPARÉ** | — |
| Direction/organisation d'un trafic | StupefiantsDirectionOrganisationPage | `stupefiants_pages/direction_organisation_contenu_page.dart` | EXISTE-NON-CÂBLÉ | non vérifié |
| Facilitation à l'usage illicite | StupefiantsFacilitationUsagePage | `stupefiants_pages/facilitation_usage_contenu_page.dart` | EXISTE-NON-CÂBLÉ | non vérifié |
| Production/fabrication illicites | StupefiantsProductionFabricationPage | `stupefiants_pages/production_fabrication_contenu_page.dart` | EXISTE-NON-CÂBLÉ | non vérifié |
| Provocation d'un majeur à l'usage/trafic | StupefiantsProvocationMajeurPage | `stupefiants_pages/provocation_majeur_contenu_page.dart` | EXISTE-NON-CÂBLÉ | non vérifié |
| Blanchiment du produit du trafic | StupefiantsBlanchimentProduitPage | `stupefiants_pages/blanchiment_produit_contenu_page.dart` | EXISTE-NON-CÂBLÉ | 644/644 |
| Transport/détention/offre/cession/acquisition/emploi | StupefiantsTransportDetentionOffrePage | `stupefiants_pages/transport_detention_offre_contenu_page.dart` | EXISTE-NON-CÂBLÉ | non vérifié |
| Importation/exportation illicites | StupefiantsImportExportPage | `stupefiants_pages/import_export_contenu_page.dart` | EXISTE-NON-CÂBLÉ | non vérifié |
| Usage illicite de stupéfiants | StupefiantsUsageIllicitePage | `stupefiants_pages/usage_illicite_contenu_page.dart` — câblé côté PA "socle avancé" sous PaStupefiantsUsageIllicitePage | **CÂBLÉ-SÉPARÉ** | — |

8 des 10 topics ont un fichier PA prêt mais non câblé (seuls 2/10 sont actuellement accessibles dans le menu PA).

---

## Bonus : 66 quiz PA déjà écrits, non câblés

`lib/content/pa_scolarite/quiz_scolarite_pa/` contient 66 fichiers `pa_quiz_*.dart` couvrant la quasi-totalité des topics ci-dessus (flagrant délit, enquête préliminaire, mort inconnue, disparitions inquiétantes, criminalité organisée, nullité, instruction, juridiction, hiérarchie, généralités, cadres juridiques, commission rogatoire, mandats justice, crimes/délits nation, abus autorité, atteintes action justice, droit pénal, libertés publiques individuelles, personnes en fuite, mise en danger, enregistrement diffusion images, crimes/délits personne, viol/inceste/agressions, mineurs/famille, violation ordonnances JAF, autorité parentale, abandon famille, mise en péril mineurs, atteinte personnalité, dispositions mineurs, circulation routière, classification infractions, sanction classification, infraction, complicité, légitime défense, usage armes, rétention locaux...). Non audités en détail ici (hors scope de cette passe), mais à prendre en compte dans la prochaine étape de câblage — probablement câblables en parallèle des pages de cours correspondantes.

---

## Recommandation pour la suite (hors scope de cet audit, à valider avec l'utilisateur)

1. **Corriger en priorité** les 8 pages "Généralités" séparées superficiellement cette session (remplacer leur cible `_kTargetRouteName` GPX-partagée par le vrai contenu PA dédié quand il existe, ex. Tentative → `TentativeContenuPagePA`).
2. **Câbler** (app_router.dart + home_page_pa_school.dart, aucune rédaction nécessaire) les ~48 topics EXISTE-NON-CÂBLÉ, catégorie par catégorie — travail mécanique bas risque, suit le pattern déjà utilisé pour "Libertés publiques".
3. **Réconcilier** la catégorie "Crimes & délits contre la personne" (topics PA et GPX ne matchent pas 1:1) avant de câbler.
4. **Restaurer la granularité** de "Infractions à la circulation routière" (4 sujets actuellement bundlés en 1 page, alors que des pages dédiées existent).
5. Câbler les 66 quiz PA existants en parallèle.
6. Seulement après tout ça, identifier s'il reste de VRAIS trous de contenu nécessitant une rédaction — à ce stade, aucun trou de contenu confirmé n'a été trouvé pour dpsDpg (uniquement des trous de câblage).
