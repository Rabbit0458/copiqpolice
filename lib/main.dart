// lib/main.dart
//
// Bootstrap de l'application COP'IQ Police.
// Cette library est split en deux fichiers via `part`/`part of` :
//  - main.dart (ce fichier) : tous les imports + bootstrap + classes critiques
//  - routes/app_router.dart : AppAuthClientOptions + appOnGenerateRoute + RouteRegistry
// Les imports declares ici sont accessibles dans les deux fichiers (scope library partage).

library copiqpolice_app;

// ============================================================================
// IMPORTS (utilises a la fois dans main.dart et dans routes/app_router.dart)
// Tu peux folder cette section dans VS Code (Ctrl+K Ctrl+0 puis ouvrir region
// avec Ctrl+K Ctrl+J pour deplier). Pour ajouter une page : ajoute son import ici.
// ============================================================================
// region Imports
// lib/main.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'
    show kDebugMode, kIsWeb, defaultTargetPlatform, FlutterErrorDetails;
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:copiqpolice/features/home/home_bootstrap.dart';
import 'package:copiqpolice/features/home/abonnement_page.dart';
import 'package:copiqpolice/core/services/subscription_gate.dart';
import 'package:copiqpolice/core/services/subscription_service.dart';

// === Écrans (imports unifiés) ===
import 'package:copiqpolice/features/warning/warning_screen.dart';
import 'package:copiqpolice/features/onboarding/onboarding_screen.dart';
import 'package:copiqpolice/features/onboarding/discovery_tutorial.dart';
import 'package:copiqpolice/features/auth/signup.dart';
import 'package:copiqpolice/features/auth/signin.dart';
import 'package:copiqpolice/features/auth/reset_password.dart';
import 'package:copiqpolice/features/auth/confirm_email.dart';
import 'package:copiqpolice/features/placement/placement_test.dart';
import 'package:copiqpolice/features/placement/welcome_after_signup.dart';
import 'package:copiqpolice/features/placement/placement_intro.dart';
import 'package:copiqpolice/features/home/home_page.dart' show HomePage;
import 'package:copiqpolice/features/home/parametre_home.dart';
import 'package:copiqpolice/features/home/favoris_home.dart';
import 'package:copiqpolice/features/feedback/saving_screen.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/institution_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/procedure_penale_page.dart';
import 'package:copiqpolice/features/reserve/accueil_reserve.dart';
import 'package:copiqpolice/features/onboarding/gpx_school.dart'
    show GpxSchoolArt, GpxSchoolProgram;

// Pages
import 'package:copiqpolice/content/gpx_scolarite/shared/procedure_penale_page.dart';
import 'package:copiqpolice/features/onboarding/mode_picker.dart';

// GPX School
import 'package:copiqpolice/features/home/home_page_gpx_school.dart';
import 'package:copiqpolice/features/home/home_page_gpx_exam.dart';

//PA School
import 'package:copiqpolice/features/home/home_page_pa_school.dart';
import 'package:copiqpolice/features/home/home_page_pa_exam.dart';

//═══════════════════════════════════════════════════════════════════════
//  GPX — Scolarité | DPS & DPG
//═══════════════════════════════════════════════════════════════════════

import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/generalite_pages/classification_infractions/classification_infractions_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/generalite_pages/classification_infractions/classification_infractions_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/generalite_pages/classification_infractions/classification_infractions_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/generalite_pages/classification_infractions/crime_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/generalite_pages/classification_infractions/delit_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/generalite_pages/classification_infractions/contravention_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/generalite_pages/infraction/infraction_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/generalite_pages/infraction/infraction_intro_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/generalite_pages/infraction/infraction_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/generalite_pages/infraction/element_moral_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/generalite_pages/infraction/element_materiel_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/generalite_pages/infraction/element_legal_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/generalite_pages/tentative/tentative_intro_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/generalite_pages/tentative/tentative_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/generalite_pages/tentative/condition_tentative_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/generalite_pages/tentative/repression_tentative_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/generalite_pages/tentative/infructueuse_tentative_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/generalite_pages/legitime_defense/ld_intro_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/generalite_pages/legitime_defense/ld_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/generalite_pages/legitime_defense/ld_personnes_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/generalite_pages/legitime_defense/ld_biens_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/generalite_pages/legitime_defense/ld_cas_presumes_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_intro_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_condition_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_participation_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_repression_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/usage_des_armes_intro_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/usage_des_armes_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/generalite_pages/libert%C3%A9s_publiques/liberte_publiques_intro_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/generalite_pages/libert%C3%A9s_publiques/liberte_publiques_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_locaux_intro.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_mesures_admin_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_mesures_judiciaires_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_principes_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_locaux_contenu.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/generalite_pages/hierarchie_police/hierarchie_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/generalite_pages/hierarchie_police/hierarchie_intro_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/generalite_pages/hierarchie_police/hierarchie_opj_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/generalite_pages/hierarchie_police/hierarchie_apj_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/generalite_pages/hierarchie_police/hierarchie_apja_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/generalite_pages/hierarchie_police/hierarchie_introduction_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/generalite_pages/hierarchie_police/hierarchie_assistants_enquete_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/generalite_pages/quizz_generalit%C3%A9/quiz_classification_infractions_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/generalite_pages/quizz_generalit%C3%A9/quiz_infraction_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/generalite_pages/quizz_generalit%C3%A9/quiz_tentative_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/generalite_pages/quizz_generalit%C3%A9/quiz_complicite_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/generalite_pages/quizz_generalit%C3%A9/quiz_legitime_defense_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/generalite_pages/quizz_generalit%C3%A9/quiz_usage_armes_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/generalite_pages/quizz_generalit%C3%A9/quiz_libertes_publiques_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/generalite_pages/quizz_generalit%C3%A9/quiz_libertes_publiques_garanties_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/generalite_pages/quizz_generalit%C3%A9/quiz_libertes_publiques_collectives_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/generalite_pages/quizz_generalit%C3%A9/quiz_libertes_publiques_individuelles_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/generalite_pages/quizz_generalit%C3%A9/quiz_retention_locaux_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/generalite_pages/quizz_generalit%C3%A9/quiz_hierarchie_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/generalite_pages/quizz_generalit%C3%A9/quiz_generalite_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/cadres_enquete/cadres_enquete_intro_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/cadres_enquete/cadres_enquete_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/flagrant_delit/flagrant_delit_intro_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/flagrant_delit/flagrant_delit_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/flagrant_delit/flagrant_delit_panorama_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/flagrant_delit/flagrant_delit_notion_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/flagrant_delit/flagrant_delit_domaine_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_intro_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_chapitre1_domaine_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_chapitre2_procedure_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_fouilles_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_prelim_saisie_comptes_bancaires_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_intro.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/saisies_scelles.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/mandat_recherche.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/violation_cj_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/personne_grievement_blessee/personne_intro.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/personne_grievement_blessee/personne_contenu.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_page_intro.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_page_contenu.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_intro_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_condition.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_enquete.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_delegues.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_juge_instruction.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_suites_enquete.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/criminalite_deliquance_intro_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/criminalite_organisee_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/infraction_criminalite_organisee.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/interceptions_gpx_school.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/lutte_financement_gpx_school.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/personnes_en_fuite/personnes_en_fuite_intro.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/personnes_en_fuite/personnes_en_fuite_contenu.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_condition_gpx_school.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_techniques_speciales_gpx_school.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/disparition/disparitions_inquietantes_contenu.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/disparition/disparitions_inquietantes_intro.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/disparition/disparition_inquietante_intro_gpx_school.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/disparition/disparition_inquietante_conditions_gpx_school.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/disparition/disparitions_inquietantes_enquete_gpx_school.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_intro_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_contenu_chap1_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_chap1_introduction_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_controles_preventifs_gpx_school_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_zone_frontiere_gpx_school_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_locaux_professionnels_gpx_school_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_distinction_identite_reglementation_gpx_school_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_sejour_etrangers_gpx_school_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_moyens_preuve_identite_gpx_school_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_intro_gpx_school_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/releve_identite_gpx_school_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_contenu_chap3_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/verification_identite_introduction_gpx_school.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/verification_identite_retention_gpx_school.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/verification_identite_recherche_gpx_school.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/verification_identite_procedure_gpx_school.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/verification_identite_proces_verbal_gpx_school.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_intro_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/eurojust_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/traite_prum_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/reseau_judiciaire_europeen_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/mae_definition_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/mae_mise_en_oeuvre_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/mae_mandat_par_juridictions_fr_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_simplifiee_ue_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/quiz_cadres_juridiques/quiz_flagrant_delit_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/quiz_cadres_juridiques/quiz_enquete_preliminaire_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/quiz_cadres_juridiques/quiz_commission_rogatoire_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/quiz_cadres_juridiques/quiz_mort_inconnue.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/quiz_cadres_juridiques/quiz_criminalite_organisee.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/quiz_cadres_juridiques/quiz_personnes_fuite.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/quiz_cadres_juridiques/quiz_disparitions_inquietantes.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/quiz_cadres_juridiques/quiz_controle_identite.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/quiz_cadres_juridiques/quiz_controle_identite.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/quiz_cadres_juridiques/quiz_page_cadres_juridique.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/proc%C3%A9dure_p%C3%A9nale_pages/pp_action_publique_autorites_pj_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/proc%C3%A9dure_p%C3%A9nale_pages/pp_action_publique_autorites_pj_intro_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/proc%C3%A9dure_p%C3%A9nale_pages/pp_action_publique_action_civile_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/proc%C3%A9dure_p%C3%A9nale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/proc%C3%A9dure_p%C3%A9nale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/proc%C3%A9dure_p%C3%A9nale_pages/pp_action_publique_action_civile_chapitre_3_exercice_action_publique_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/proc%C3%A9dure_p%C3%A9nale_pages/pp_action_publique_action_civile_chapitre_4_extinction_action_publique_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/proc%C3%A9dure_p%C3%A9nale_pages/pp_action_publique_action_civile_tableau_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/proc%C3%A9dure_p%C3%A9nale_pages/controle_mission_intro_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/proc%C3%A9dure_p%C3%A9nale_pages/controle_mission_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/proc%C3%A9dure_p%C3%A9nale_pages/pp_controle_mission_pj_role_procureur_general_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/proc%C3%A9dure_p%C3%A9nale_pages/pp_controle_mission_pj_inspection_generale_justice_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/proc%C3%A9dure_p%C3%A9nale_pages/pp_controle_mission_pj_chambre_instruction_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/proc%C3%A9dure_p%C3%A9nale_pages/autorites_investies_contenu.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/proc%C3%A9dure_p%C3%A9nale_pages/autorites_investies_intro.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/proc%C3%A9dure_p%C3%A9nale_pages/pp_autorites_investies_pj_habituelles_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/proc%C3%A9dure_p%C3%A9nale_pages/pp_autorites_investies_pj_occasionnelles_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/proc%C3%A9dure_p%C3%A9nale_pages/organisation_ministere_intro.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/proc%C3%A9dure_p%C3%A9nale_pages/pp_organisation_ministere_public_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/proc%C3%A9dure_p%C3%A9nale_pages/nullite_intro_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/proc%C3%A9dure_p%C3%A9nale_pages/nullite_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/proc%C3%A9dure_p%C3%A9nale_pages/pp_nullites_textuelles_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/proc%C3%A9dure_p%C3%A9nale_pages/pp_nullites_substantielles_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/proc%C3%A9dure_p%C3%A9nale_pages/pp_action_en_nullite_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/proc%C3%A9dure_p%C3%A9nale_pages/pp_effets_nullite_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/proc%C3%A9dure_p%C3%A9nale_pages/juridiction_intro_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/proc%C3%A9dure_p%C3%A9nale_pages/juridiction_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/proc%C3%A9dure_p%C3%A9nale_pages/juridictions_principes_generaux_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/proc%C3%A9dure_p%C3%A9nale_pages/juridictions_execution_decisions_justice_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/proc%C3%A9dure_p%C3%A9nale_pages/pp_juridictions_penales_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/proc%C3%A9dure_p%C3%A9nale_pages/instruction_preparatoire_intro.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/proc%C3%A9dure_p%C3%A9nale_pages/instruction_preparatoire_contenu.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/proc%C3%A9dure_p%C3%A9nale_pages/instruction_preparatoire_contenu_detail.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/proc%C3%A9dure_p%C3%A9nale_pages/pp_instruction_chapitre_1.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/proc%C3%A9dure_p%C3%A9nale_pages/pp_instruction_ouverture.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/proc%C3%A9dure_p%C3%A9nale_pages/pp_instruction_pouvoirs.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/proc%C3%A9dure_p%C3%A9nale_pages/pp_instruction_cloture.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/proc%C3%A9dure_p%C3%A9nale_pages/pp_chambre_instruction.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/proc%C3%A9dure_p%C3%A9nale_pages/pp_jld.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/proc%C3%A9dure_p%C3%A9nale_pages/detention_provisoire_intro.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/proc%C3%A9dure_p%C3%A9nale_pages/detention_provisoire_contenu.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/proc%C3%A9dure_p%C3%A9nale_pages/pp_placement_detention_provisoire.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/proc%C3%A9dure_p%C3%A9nale_pages/pp_deroulement_detention_provisoire.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/proc%C3%A9dure_p%C3%A9nale_pages/pp_fin_detention_provisoire.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/proc%C3%A9dure_p%C3%A9nale_pages/pp_reparation_detention_injustifiee.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/proc%C3%A9dure_p%C3%A9nale_pages/pp_detention_provisoire_tableau.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/proc%C3%A9dure_p%C3%A9nale_pages/controle_judiciaire_intro.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/proc%C3%A9dure_p%C3%A9nale_pages/controle_judiciaire_contenu.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/proc%C3%A9dure_p%C3%A9nale_pages/pp_controle_judiciaire_chapitre1.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/proc%C3%A9dure_p%C3%A9nale_pages/pp_controle_judiciaire_chapitre2.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/proc%C3%A9dure_p%C3%A9nale_pages/pp_controle_judiciaire_tableau.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/proc%C3%A9dure_p%C3%A9nale_pages/bracelet_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/proc%C3%A9dure_p%C3%A9nale_pages/pp_assignation_residence_conditions.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/proc%C3%A9dure_p%C3%A9nale_pages/pp_bracelet_modalites_placement.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/proc%C3%A9dure_p%C3%A9nale_pages/pp_bracelet_deroulement_mesure.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/proc%C3%A9dure_p%C3%A9nale_pages/mandats_justice_contenu.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/proc%C3%A9dure_p%C3%A9nale_pages/pp_mandats_principes_generaux.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/proc%C3%A9dure_p%C3%A9nale_pages/pp_mandats_types.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/proc%C3%A9dure_p%C3%A9nale_pages/pp_mandats_sanctions_irregularites.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/proc%C3%A9dure_p%C3%A9nale_pages/pp_dispositions_mineurs_instruction_contenu.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/proc%C3%A9dure_p%C3%A9nale_pages/pp_mineurs_principes_generaux.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/proc%C3%A9dure_p%C3%A9nale_pages/pp_mineurs_instruction_preparatoire.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/proc%C3%A9dure_p%C3%A9nale_pages/pp_mineurs_retention_mandats.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/proc%C3%A9dure_p%C3%A9nale_pages/quiz_procedure_penale/quiz_nullite_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/proc%C3%A9dure_p%C3%A9nale_pages/quiz_procedure_penale/quiz_action_publique_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/proc%C3%A9dure_p%C3%A9nale_pages/quiz_procedure_penale/quiz_juridiction_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/proc%C3%A9dure_p%C3%A9nale_pages/quiz_procedure_penale/quiz_instruction_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/proc%C3%A9dure_p%C3%A9nale_pages/quiz_procedure_penale/quiz_detention_provisoire_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/proc%C3%A9dure_p%C3%A9nale_pages/quiz_procedure_penale/quiz_controle_judiciaire.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/proc%C3%A9dure_p%C3%A9nale_pages/quiz_procedure_penale/quiz_bracelet_electronique.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/proc%C3%A9dure_p%C3%A9nale_pages/quiz_procedure_penale/quiz_mandats_justice.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/proc%C3%A9dure_p%C3%A9nale_pages/quiz_procedure_penale/quiz_dispositions_applicables_mineurs.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/droit_p%C3%A9nale_g%C3%A9n%C3%A9ral_pages/responsabilite_penale_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/droit_p%C3%A9nale_g%C3%A9n%C3%A9ral_pages/loi_penale_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/droit_p%C3%A9nale_g%C3%A9n%C3%A9ral_pages/classification_infractions_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/droit_p%C3%A9nale_g%C3%A9n%C3%A9ral_pages/classification_infractions_page_loi_penal.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/droit_p%C3%A9nale_g%C3%A9n%C3%A9ral_pages/gpx_school_etendue_application_lois_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/droit_p%C3%A9nale_g%C3%A9n%C3%A9ral_pages/gpx_school_generalites_legislation_penale_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/droit_p%C3%A9nale_g%C3%A9n%C3%A9ral_pages/gpx_school_elements_constitutifs_infraction_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/droit_p%C3%A9nale_g%C3%A9n%C3%A9ral_pages/responsabilite_penale_contenu.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/droit_p%C3%A9nale_g%C3%A9n%C3%A9ral_pages/gpx_school_responsabilite_penale_principes_generaux_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/droit_p%C3%A9nale_g%C3%A9n%C3%A9ral_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/droit_p%C3%A9nale_g%C3%A9n%C3%A9ral_pages/gpx_school_responsabilite_penale_personnes_morales_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/droit_p%C3%A9nale_g%C3%A9n%C3%A9ral_pages/gpx_school_responsabilite_penale_causes_irresponsabilite_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/droit_p%C3%A9nale_g%C3%A9n%C3%A9ral_pages/quiz_droit_penale/quiz_responsabilite_penal_general.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/droit_p%C3%A9nale_g%C3%A9n%C3%A9ral_pages/quiz_droit_penale/quiz_droit_penale.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/sanction_pages/classification_peines_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/sanction_pages/classification_peines_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/sanction_pages/classification_mesures_surete_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/sanction_pages/classification_legale_peines_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/sanction_pages/pluralite_infractions_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/sanction_pages/quiz_sanction/quiz_sanction_classification.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/sanction_pages/quiz_sanction/quiz_sanction_aggravation.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/sanction_pages/quiz_sanction/quiz_sanction_pluralite.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/sanction_pages/quiz_sanction/quiz_sanction.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/sanction_pages/pluralite_infractions_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/auteur_ivre_ou_stupefiants_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/utilisation_reseau_communication_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/etablissement_enseignement_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/minorite_quinze_ans_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/mort_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/mutilation_infirmit%C3%A9_permanente_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/vulnerabilite_victime_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/premeditation_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/qualite_conjoint_concubin_partenaire_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/caractere_homophobe_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/caractere_raciste_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/guet_apens_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/port_ou_usage_arme_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/effraction_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/circonstances_aggravantes_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/escalade_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/incapacite_totale_travail_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/moyen_cryptologie_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/auteur_abusant_autorite_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/auteur_ascendant_victime_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/auteur_depositaire_autorite_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/victime_ascendant_auteur_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/victime_chargee_mission_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/victime_depositaire_autorite_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/victime_prostitution_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/temoin_victime_partie_civile_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/victime_parente_personne_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/sanction_pages/pluralite_infractions/recidive_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/sanction_pages/pluralite_infractions/reiteration_infractions_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/sanction_pages/pluralite_infractions/concours_reel_infractions_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/quiz_crime_delit_personne/quiz_mise_en_danger.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/quiz_crime_delit_personne/quiz_viol_inceste_agressions.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/quiz_crime_delit_personne/quiz_enregistrement_diffusion_images.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/quiz_crime_delit_personne/quiz_dignite_personne.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/quiz_crime_delit_personne/quiz_atteinte_personnalite.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/quiz_crime_delit_personne/quiz_atteintes_involontaires.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/quiz_crime_delit_personne/quiz_atteintes_volontaires.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/quiz_crime_delit_personne/quiz_atteintes_integrite.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/quiz_crime_delit_personne/quiz_crimes_delits_personne.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/mise_en_danger/mise_en_danger_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/mise_en_danger/mise_en_danger_diffusion_informations_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/mise_en_danger/non_assistance_personne_peril_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/mise_en_danger/abus_frauduleux_ignorance_faiblesse_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/mise_en_danger/delaissement_personne_hors_etat_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/mise_en_danger/non_obstacle_commission_crime_delit_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/mise_en_danger/risque_cause_autrui_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/viol_inceste_agressions_avertissement_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/viol_inceste_agressions_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/administration_substances_nuisibles_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/substance_pour_viol_ou_agression_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/harcelement_sexuel_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/viol_majeur_mineur_15_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/viol_incestueux_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/viol_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agressions_sexuelles_autres_que_viol_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/mineur_15_violences_contrainte_menace_surprise_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/personne_vulnerable_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/exhibition_sexuelle_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/enlevement_sequestration_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/enregistrement_diffusion_images/enregistrement_diffusion_images_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/enregistrement_diffusion_images/enregistrement_images_violence_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/enregistrement_diffusion_images/diffusion_images_violence_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/dignite_personne_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/dissimulation_forcee_visage_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/violation_profanation_tombeaux_sepultures_urnes_monuments_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/atteinte_integrite_cadavre_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/proxenetisme_hotelier_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/proxenetisme_assimilation_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/proxenetisme_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/recours_prostitution_mineurs_personnes_vulnerables_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/discriminations_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_personnalite_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/denonciation_calomnieuse_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/diffusion_enregistrement_document_caractere_sexuel_sans_accord_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/violation_domicile_particulier_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/violation_correspondances_voie_electronique_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_representation_personne_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_personne.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_professionnel.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/participation_groupement_violent_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_conducteur_vtm_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_violation_manifestement_deliberee_obligation_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_volontaires_qualifiees_violences_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/violences_volontaires_arme_personne_depositaire_transport_pompier_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/homicide_involontaire_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_volontaire/atteintes_volontaires_vie_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_volontaire/meurtre_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_volontaire/empoisonnement_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/atteintes_volontaires_integrite_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/menace_sans_condition_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/embuscade_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/appels_messages_malveillants_agressions_sonores_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/menaces_avec_condition_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/tortures_actes_barbarie_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_couple_ex_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_mineur_vulnerable_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_sur_fsi_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/mise_en_peril_des_mineurs_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/violation_ordonnances_jaf/violation_ordonnances_jaf_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/autorite_parentale/autorite_parentale_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_famille_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/corruption_mineur_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/diffusion_message_violent_mineur_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/privation_aliments_soins_mineur_15_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_pedopornographie_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_directe_mineur_crime_delit_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_mineur_alcool_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_mineur_stupefiants_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/soustraction_parent_obligations_legales_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/atteintes_sexuelles_majeur_mineur_15_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/atteintes_sexuelles_majeur_mineur_plus_15_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/exploitation_image_porno_mineur_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/propositions_sexuelles_mineur_15_en_ligne_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/violation_ordonnances_jaf/defaut_notification_changement_domicile_creancier_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/violation_ordonnances_jaf/non_respect_obligations_interdictions_ordonnance_protection_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/autorite_parentale/non_representation_enfant_mineur_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/autorite_parentale/soustraction_enfant_mineur_par_ascendant_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/autorite_parentale/soustraction_enfant_mineur_sans_fraude_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/autorite_parentale/defaut_notification_transfert_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/quiz_mineurs_pages/quiz_mise_peril_mineurs.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/quiz_mineurs_pages/quiz_violation_ordonnances_jaf.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/quiz_mineurs_pages/quiz_autorite_parentale.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/quiz_mineurs_pages/quiz_abandon_famille.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/quiz_mineurs_pages/quiz_mineurs_famille.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/association_malfaiteurs_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/abus_autorite_particuliers_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/discriminations_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/atteintes_action_justice_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/non_denonciation_crime_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/atteintes_administration_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/provocation_directe_rebellion_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/rebellion_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/menaces_violences_intimidation_derogation_service_public_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/faux_usage_faux/faux_usage_faux_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/faux_usage_faux/delivrance_indue_document_administratif_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/faux_usage_faux/faux_document_administratif_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/faux_usage_faux/faux_ecriture_publique_ou_authentique_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/faux_usage_faux/faux_certificats_ou_attestations_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/faux_usage_faux/obtention_indue_document_administratif_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/probite_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/concussion_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/corruption_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/trafic_influence_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/quiz_delit_nation/quiz_abus_autorite.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/quiz_delit_nation/quiz_atteintes_action_justice.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/quiz_delit_nation/quiz_atteintes_administration.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/quiz_delit_nation/quiz_faux_usage_faux.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/quiz_delit_nation/quiz_probite.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/quiz_delit_nation/quiz_crimes_delits_nation.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/vol_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/recel_non_justification/recel_non_justification_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/recel_non_justification/non_justification_ressources.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/recel_non_justification/recel_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/stad/stad_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/stad/acces_maintien_frauduleux_stad_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/stad/association_malfaiteurs_informatique_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/stad/donnees_adaptees_commettre_infractions_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/stad/introduction_suppression_modification_donnees_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/contrefacons_falsifications/contrefacons_falsifications_cheques_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/destructions_degradations_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/detention_transport_substances_preparation_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/detention_transport_sans_motif_legitime_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/diffusion_procedes_fabrication_engins_destruction_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/dangereuses_personnes_intentionnelle_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/dangereuses_personnes_non_intentionnelle_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/sans_danger_dommage_important_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/sans_danger_dommage_leger_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/tags_inscriptions_signes_dessins_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/biens_culturels_publics_classes_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/fausses_alertes_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/menaces_avec_condition_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/menaces_sans_condition_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/voisines_du_vol_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/demande_fonds_sous_contrainte_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/chantage_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/filouteries_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/quiz_crime_delit_bien_pages/quiz_recel_non_justification.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/quiz_crime_delit_bien_pages/quiz_stad.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/quiz_crime_delit_bien_pages/quiz_voisines_du_vol.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/quiz_crime_delit_bien_pages/quiz_crimes_delits_bien.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/quiz_crime_delit_bien_pages/quiz_destructions_degradations.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/infraction_circulation_routi%C3%A8re_pages/conduite_stupefiants_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/infraction_circulation_routi%C3%A8re_pages/ivresse_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/infraction_circulation_routi%C3%A8re_pages/etat_alcoolique_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/infraction_circulation_routi%C3%A8re_pages/defaut_assurance_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/infraction_circulation_routi%C3%A8re_pages/defaut_permis_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/infraction_circulation_routi%C3%A8re_pages/delit_fuite_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/infraction_circulation_routi%C3%A8re_pages/grand_exces_vitesse_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/infraction_circulation_routi%C3%A8re_pages/refus_verifications_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/infraction_circulation_routi%C3%A8re_pages/refus_obtemperer_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/infraction_circulation_routi%C3%A8re_pages/rodeo_motorise_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/infraction_circulation_routi%C3%A8re_pages/plaques_inscriptions_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/infraction_circulation_routi%C3%A8re_pages/incitation_organisation_promotion_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/infraction_circulation_routi%C3%A8re_pages/quiz_circulation_routiere.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_classification_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_definitions_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_introduction_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_acquisition_detention_ab_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_port_transport_cd_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_regles_acquisition_detention_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_regles_port_transport_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/armes_munitions_pages/quiz_armes_munitions_pages.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/libert%C3%A9s_publiques_pages/libertes_publiques_introduction_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/libert%C3%A9s_publiques_pages/introduction/declaration_droits_homme_citoyen_1789_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/libert%C3%A9s_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/libert%C3%A9s_publiques_pages/introduction/sources_libertes_publiques_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/libert%C3%A9s_publiques_pages/introduction/notion_libertes_publiques_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/libert%C3%A9s_publiques_pages/quiz_libert%C3%A9s_publiques/quiz_introduction.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/stup%C3%A9fiants_pages/introduction_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/stup%C3%A9fiants_pages/cession_offre_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/stup%C3%A9fiants_pages/direction_organisation_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/stup%C3%A9fiants_pages/facilitation_usage_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/stup%C3%A9fiants_pages/production_fabrication_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/stup%C3%A9fiants_pages/provocation_majeur_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/stup%C3%A9fiants_pages/blanchiment_produit_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/stup%C3%A9fiants_pages/transport_detention_offre_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/stup%C3%A9fiants_pages/import_export_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/stup%C3%A9fiants_pages/usage_illicite_contenu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/stup%C3%A9fiants_pages/quiz_stup%C3%A9fiants.dart';
//═══════════════════════════════════════════════════════════════════════
//  GPX — Scolarité | Institutions & Valeurs
//═══════════════════════════════════════════════════════════════════════
import 'package:copiqpolice/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_formation_initiale_formation_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_memento_prise_de_note_methodologie_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/institutions_valeurs/deontologie/gpx_code_deontologie_commente_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/institutions_valeurs/deontologie/marques_exterieures_respect_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/institutions_valeurs/deontologie/droits_obligations_policiers_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/institutions_valeurs/deontologie/hors_service_amaris_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/institutions_valeurs/deontologie/sanctions_recompenses_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/institutions_valeurs/deontologie/enquete_administrative_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/institutions_valeurs/deontologie/reseaux_sociaux_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/institutions_valeurs/hierarchie_info/compte_rendu_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/institutions_valeurs/hierarchie_info/formalisme_rapport_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/institutions_valeurs/hierarchie_info/modeles_rapports_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/institutions_valeurs/accueil_public/charte_accueil_public_victimes_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/institutions_valeurs/accueil_public/referentiel_marianne_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/institutions_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/institutions_valeurs/accueil_public/demarches_administratives_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/institutions_valeurs/accueil_public/protection_locaux_police_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/institutions_valeurs/laicite/gpx_laicite_dlpaj_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/institutions_valeurs/laicite/charte_laicite_services_publics_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/institutions_valeurs/laicite/rites_cultes_france_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/institutions_valeurs/histoire/histoire_reperes_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/institutions_valeurs/quiz_institutions_valeurs/quiz_organisation_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/institutions_valeurs/quiz_institutions_valeurs/quiz_deontologie.dart';
import 'package:copiqpolice/content/gpx_scolarite/institutions_valeurs/quiz_institutions_valeurs/quiz_accueil_public.dart';
//═══════════════════════════════════════════════════════════════════════
//  GPX — Scolarité | Mémentos & Procédures
//═══════════════════════════════════════════════════════════════════════
import 'package:copiqpolice/content/gpx_scolarite/memento_circulation/procedures/amende_forfaitaire_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/memento_circulation/procedures/amende_forfaitaire_delictuelle_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/memento_circulation/procedures/consignation_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/memento_circulation/procedures/immobilisation_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/memento_circulation/procedures/conduite_apres_usage_stupefiants_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/memento_circulation/procedures/retention_permis_conduire_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/memento_circulation/procedures/permis_a_points_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/memento_circulation/controle_routier/bsr_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/memento_circulation/controle_routier/controle_technique_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/memento_circulation/controle_routier/assurance_obligatoire_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/memento_circulation/equipements/pneumatiques_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/memento_circulation/equipements/chargement_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/memento_circulation/equipements/plaques_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/memento_circulation/equipements/retroviseurs_vision_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/memento_circulation/equipements/essuie_glace_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/memento_circulation/equipements/casque_gants_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/memento_circulation/equipements/casque_cycliste_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/memento_circulation/equipements/gilet_haute_visibilite_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart';
//═══════════════════════════════════════════════════════════════════════
//  GPX — Scolarité | Policier en Intervention Initiale
//═══════════════════════════════════════════════════════════════════════
import 'package:copiqpolice/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_appel_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_registres_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_applications_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_fouille_integrale_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_risque_evasion_fuite_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/policier_intervention_initial/patrouille/patrouille_patrouille_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/policier_intervention_initial/patrouille/procedure_radio_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/policier_intervention_initial/patrouille/memo_tph_900_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/policier_intervention_initial/patrouille/interrogation_fpr_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/policier_intervention_initial/patrouille/camera_pieton_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/policier_intervention_initial/patrouille/utilite_camera_pieton_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/policier_intervention_initial/patrouille/equipements_securite_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/policier_intervention_initial/patrouille/conduite_vehicules_police_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/policier_intervention_initial/patrouille/signalement_descriptif_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/policier_intervention_initial/patrouille/menottage_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/policier_intervention_initial/patrouille/enregistrement_diffusion_images_paroles_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/policier_intervention_initial/accident_circulation/securite_trajet_lieux_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/policier_intervention_initial/accident_circulation/types_accidents_circulation_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/policier_intervention_initial/accident_circulation/regulation_circulation_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/policier_intervention_initial/domicile/violation_domicile_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/policier_intervention_initial/domicile/bruits_tapages_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/policier_intervention_initial/domicile/differend_familial_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/policier_intervention_initial/domicile/violences_conjugales_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/policier_intervention_initial/autres/primo_scene_infraction_amaris_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/policier_intervention_initial/autres/ivresse_publique_manifeste_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/policier_intervention_initial/autres/plans_orsec_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/policier_intervention_initial/formulaires_utiles/avis_retention_permis_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/policier_intervention_initial/formulaires_utiles/fiche_immobilisation_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/policier_intervention_initial/formulaires_utiles/fiche_descriptive_fourriere_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/policier_intervention_avance/etrangers/accord_schengen_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/policier_intervention_avance/etrangers/cooperation_ue_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/policier_intervention_avance/mineurs/statut_juridique_mineur_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/policier_intervention_avance/mineurs/protection_mineurs_voie_publique_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/policier_intervention_avance/accident_circulation/plan_lieux_technique_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/policier_intervention_avance/accident_circulation/modeles_plan_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/policier_intervention_avance/accident_circulation/tableau_synthese_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/policier_intervention_avance/accident_circulation/avis_famille_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/policier_intervention_avance/accident_circulation/annoncer_mauvaise_nouvelle_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/policier_intervention_avance/stupefiants/amende_forfaitaire_delictuelle_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/policier_intervention_avance/debit_boissons/intervention_debit_boissons_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/policier_intervention_avance/debit_boissons/controle_debits_boissons_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/policier_intervention_avance/malades_mentaux/intervenir_malades_mentaux_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/policier_intervention_avance/malades_mentaux/soins_sans_consentement_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/policier_intervention_avance/animal/chien_dangereux_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/policier_intervention_avance/animal/protocole_morsure_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/policier_intervention_avance/autres/sinistre_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/policier_intervention_avance/autres/incendie_primo_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/policier_intervention_avance/autres/alarme_etablissement_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/policier_intervention_avance/autres/levee_doute_agression_armee_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/policier_intervention_avance/autres/agression_armee_crapuleux_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/policier_intervention_avance/autres/violation_bar_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/policier_intervention_avance/autres/plan_vigipirate_page.dart';
//═════════════════════════════════════════════════════════════════════
//  GPX — Scolarité | Procédures & APJ 2.0
//═══════════════════════════════════════════════════════════════════════
import 'package:copiqpolice/content/gpx_scolarite/pv_apj20/introduction/preambule_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/pv_apj20/introduction/procedure_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/pv_apj20/introduction/proces_verbaux_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/pv_apj20/introduction/etat_civil_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/pv_apj20/plainte/plainte_generalites_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/pv_apj20/plainte/pv_saisine_cx_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/pv_apj20/plainte/pv_saisine_personne_inconnue_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/pv_apj20/plainte/pv_saisine_personne_denommee_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/pv_apj20/plainte/pv_saisine_personne_denommee_suite_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/pv_apj20/plainte/presentation_grille_danger_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/pv_apj20/plainte/document_info_synthetique_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/pv_apj20/plainte/pv_victime_violences_conjugales_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/pv_apj20/constatations/constatations_generalites_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/pv_apj20/constatations/canevas_pv_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/pv_apj20/temoignage/temoignage_generalites_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/pv_apj20/temoignage/enquete_voisinage_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/pv_apj20/temoignage/audition_temoins_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/pv_apj20/controle_identite/pv_controle_identite_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/pv_apj20/controle_identite/pv_ci_fiche_recherche_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/pv_apj20/interpellation/interpellation_generalites_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/pv_apj20/interpellation/pv_ci_decouverte_arme_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/pv_apj20/interpellation/pv_interpellation_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/pv_apj20/interpellation/conduite_au_poste_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/pv_apj20/interpellation/mandats_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/pv_apj20/interpellation/notification_mandat_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/pv_apj20/interpellation/recherches_infructueuses_mandat_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/pv_apj20/interpellation/compte_rendu_opj_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/pv_apj20/gav_suspect_libre/gav_generalites_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/pv_apj20/gav_suspect_libre/notification_gav_droits_apj_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/pv_apj20/gav_suspect_libre/notification_droits_suspect_majeur_emprisonnement_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/pv_apj20/gav_suspect_libre/notification_audition_libre_sans_emprisonnement_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/pv_apj20/gav_suspect_libre/notification_droits_article_65_cpp_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/pv_apj20/gav_suspect_libre/entretien_gav_avocat_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/pv_apj20/audition_suspect/audition_suspect_generalites_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/pv_apj20/audition_suspect/audition_gav_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/pv_apj20/audition_suspect/audition_suspect_libre_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/pv_apj20/audition_suspect/audition_libre_notification_droits_sans_emprisonnement_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/pv_apj20/audition_suspect/civilement_responsable_generalites_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/pv_apj20/audition_suspect/civilement_responsable_generalites__canevas_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/pv_apj20/perquisition_preliminaire/perquisition_preliminaire_generalites_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/pv_apj20/perquisition_preliminaire/perquisition_preliminaire_perquisition_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/pv_apj20/perquisition_preliminaire/fouille_vehicule_preliminaire_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/pv_apj20/requisitions/requisitions_generalites_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/pv_apj20/requisitions/requisition_personne_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/pv_apj20/requisitions/rapport_requisition_personne_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/pv_apj20/confrontation/confrontation_generalites_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/pv_apj20/confrontation/confrontation_victime_gav_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/pv_apj20/confrontation/confrontation_victime_suspect_libre_emprisonnement_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/ci_controle_sejour_circulation_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/controle_sejour_circulation_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/as_controle_alcoolemie_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/interpellation_etat_ivresse_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/tableau_taux_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/verification_notification_taux_ceea_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/verification_taux_cei_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/prelevement_sanguin_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/requisition_examen_clinique_prelevement_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/fiches_abc_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/stupefiants_generalites_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/conduite_poste_depistage_positif_ou_refus_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/formulaire_information_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/verifications_etablir_usage_stupefiants_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/fiche_suivi_salivaire_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/suite_prelevement_sanguin_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/prelevement_sanguin_etablir_usage_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/fiche_suivi_sanguine_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/requisition_examen_clinique_prelevement_expertise_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/conduite_poste_depistages_positifs_ou_refus_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/pv_apj20/circulation_routiere/contravention_5e/grand_exces_vitesse_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/pv_apj20/circulation_routiere/contravention_5e/tableau_vitesses_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/pv_apj20/ipm/ipm_generalites_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/pv_apj20/ipm/pv_ipm_examen_medical_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/pv_apj20/ipm/pv_ipm_remise_tiers_page.dart';
//═════════════════════════════════════════════════════════════════════
//  GPX — Concours | Organisation PN & Structure Concours
//═══════════════════════════════════════════════════════════════════════
import 'package:copiqpolice/content/gpx_exam/structure_gpx_concours/tableau_recapitulatif_epreuves_gpx_page.dart';
import 'package:copiqpolice/content/gpx_exam/structure_gpx_concours/gpx_admissibilite_page.dart';
import 'package:copiqpolice/content/gpx_exam/structure_gpx_concours/gpx_admission_page.dart';
import 'package:copiqpolice/content/gpx_exam/cas_pratique/cas_pratique_welcome_page.dart';
import 'package:copiqpolice/content/gpx_exam/cas_pratique/cas_pratique_onboarding.dart';
import 'package:copiqpolice/content/gpx_exam/cas_pratique/cas_pratique_list_confiug.dart';
import 'package:copiqpolice/content/gpx_exam/cas_pratique/cas_pratique_excercice/case_1_page.dart';
import 'package:copiqpolice/content/gpx_exam/cas_pratique/cas_pratique_excercice/case_2_page.dart';
import 'package:copiqpolice/content/gpx_exam/cas_pratique/cas_pratique_excercice/case_3_page.dart';
import 'package:copiqpolice/content/gpx_exam/cas_pratique/cas_pratique_excercice/case_4_page.dart';
import 'package:copiqpolice/content/gpx_exam/cas_pratique/cas_pratique_excercice/case_5_page.dart';
import 'package:copiqpolice/content/gpx_exam/cas_pratique/cas_pratique_excercice/case_6_page.dart';

import 'package:copiqpolice/content/gpx_exam/psycotechniques/attention_visuelle_page.dart';

//═════════════════════════════════════════════════════════════════════
//  GPX — Concours | Quiz Culture Générale & Langues Étrangères
//═══════════════════════════════════════════════════════════════════════
import 'package:copiqpolice/content/gpx_exam/culture_generale/quiz_culture_generale_histoire_france.dart';
import 'package:copiqpolice/content/gpx_exam/culture_generale/quiz_culture_generale_institutions_europeens.dart';
import 'package:copiqpolice/content/gpx_exam/culture_generale/quiz_culture_generale_geographie.dart';
import 'package:copiqpolice/content/gpx_exam/culture_generale/quiz_culture_generale_actualite.dart';
import 'package:copiqpolice/content/gpx_exam/culture_generale/quiz_culture_generale_france.dart';
import 'package:copiqpolice/content/gpx_exam/culture_generale/quiz_culture_generale_cinema.dart';
import 'package:copiqpolice/content/gpx_exam/culture_generale/quiz_culture_generale_musique.dart';
import 'package:copiqpolice/content/gpx_exam/culture_generale/quiz_culture_generale_sport.dart';
import 'package:copiqpolice/content/gpx_exam/culture_generale/quiz_culture_generale_sciences.dart';
import 'package:copiqpolice/content/gpx_exam/culture_generale/quiz_culture_generale_droit.dart';
import 'package:copiqpolice/content/gpx_exam/culture_generale/quiz_culture_generale_mythologie.dart';
import 'package:copiqpolice/content/gpx_exam/culture_generale/quiz_culture_generale_securite_routiere.dart';
import 'package:copiqpolice/content/gpx_exam/culture_generale/quiz_culture_generale_sante.dart';
import 'package:copiqpolice/content/gpx_exam/culture_generale/quiz_culture_generale_police.dart';
import 'package:copiqpolice/content/gpx_exam/langue_etrangere/quiz_langue_etrangere_anglais.dart';
import 'package:copiqpolice/content/gpx_exam/langue_etrangere/quiz_langue_etrangere_espagnol.dart';
import 'package:copiqpolice/content/gpx_exam/langue_etrangere/quiz_langue_etrangere_allemand.dart';
import 'package:copiqpolice/content/gpx_exam/psycotechniques/quiz_tests_psycotechniques_suite_logiques.dart';
import 'package:copiqpolice/content/gpx_exam/psycotechniques/quiz_tests_psycotechniques_concentration.dart';
import 'package:copiqpolice/content/gpx_exam/psycotechniques/quiz_tests_psycotechniques_calcul.dart';
import 'package:copiqpolice/content/gpx_exam/psycotechniques/quiz_tests_psycotechniques_suite_verbal.dart';

//═════════════════════════════════════════════════════════════════════
//  PA — Scolarité | Organisation PN & Formation Initiale & Circulation
//═══════════════════════════════════════════════════════════════════════
import 'package:copiqpolice/content/pa_scolarite/circulation_pages/agents_verbalisateurs_circulation_page.dart';
import 'package:copiqpolice/content/pa_scolarite/formation_initiale/formation_initiale_policier_adjoint_page.dart';
import 'package:copiqpolice/content/pa_scolarite/formation_initiale/memento_prise_de_notes_methodologie_page.dart';
import 'package:copiqpolice/content/pa_scolarite/organisation_pn/organigramme_mi_page.dart';
import 'package:copiqpolice/content/pa_scolarite/organisation_pn/organisation_page.dart';
import 'package:copiqpolice/content/pa_scolarite/organisation_pn/dgsi_page.dart';
import 'package:copiqpolice/content/pa_scolarite/organisation_pn/prefecture_police_page.dart';
import 'package:copiqpolice/content/pa_scolarite/organisation_pn/organigrammes_pn_page.dart';
import 'package:copiqpolice/content/pa_scolarite/organisation_pn/hierarchie_pn_page.dart';
import 'package:copiqpolice/content/pa_scolarite/organisation_pn/regles_emploi_pa_page.dart';
import 'package:copiqpolice/content/pa_scolarite/organisation_pn/horaires_service_sp_page.dart';

import 'package:copiqpolice/features/home/gpx_exam_concours_home_page.dart';
import 'package:copiqpolice/features/home/gpx_exam_culture_generale_page.dart';

// === Services ===
import 'package:copiqpolice/core/services/app_console_logger.dart';
import 'package:copiqpolice/core/widgets/app_notifier.dart'
    show AppSettingsController;
// endregion Imports

// === Le routing (RouteRegistry, appOnGenerateRoute) est dans app_router.dart ===
part 'routes/app_router.dart';

/// ====== CONFIG SUPABASE ======
const String kSupabaseUrl = 'https://nuoonagnkhbeeymtvrcn.supabase.co';
const String kSupabaseAnonKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im51b29uYWdua2hiZWV5bXR2cmNuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTYwNjE0NDUsImV4cCI6MjA3MTYzNzQ0NX0.7MRDtIcYRMwO8bykUiqhhRcdxMPjtOajbYy1SVW4PHw';

const bool kDeveloperMode = true;
const String _kWarningAckKey = 'warning_ack';
const String _kOnboardingDoneKey = 'onboarding_done';

final GlobalKey<NavigatorState> _navKey = GlobalKey<NavigatorState>();

// ===== ANSI helpers =====
const _rst = '\x1B[0m';
const _green = '\x1B[32m';
const _red = '\x1B[31m';
const _yellow = '\x1B[33m';
const _cyan = '\x1B[36m';
String _mask(String s, {int keepEnd = 6}) {
  if (s.isEmpty) return s;
  if (s.length <= keepEnd) return s;
  return '${'*' * (s.length - keepEnd)}${s.substring(s.length - keepEnd)}';
}

/// ==== SUPABASE COMPAT SHIMS ====

class _T {
  // Mets ici exactement ton bleu de marque pour le light.
  static const Color bg = Color(0xFFF5F6F8);
  static const Color ink = Color(0xFF212529);
  static const Color brandLightSurface = Color(
    0xFF0B2A4A,
  ); // <- si tu utilises un splash Flutter
}

// ================== ROUTE OBSERVER → logs ==================
class _LoggerRouteObserver extends NavigatorObserver {
  void _sync(Route<dynamic>? route) {
    final n = route?.settings.name ?? '';
    AppConsoleLogger.setScreenContext(
      screenName: n.isEmpty ? 'Unknown' : n,
      routeName: n,
    );
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _sync(route);

    // ✅ D: auto-consume quand une route quiz est push
    final name = route.settings.name;
    SubscriptionService.instance.onRoutePushed(name);

    AppConsoleLogger.debug('nav:push', message: name);
    super.didPush(route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    _sync(newRoute);

    // ✅ D: couvre pushReplacement / replace
    final name = newRoute?.settings.name;
    SubscriptionService.instance.onRoutePushed(name);

    AppConsoleLogger.debug('nav:replace', message: name);
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _sync(previousRoute);
    AppConsoleLogger.debug('nav:pop', message: previousRoute?.settings.name);
    super.didPop(route, previousRoute);
  }
}

// --- 1️⃣ Fonction loader : à garder ---
Future<void> _installUsernameLoader() async {
  HomePageGpxSchool.usernameLoader = () async {
    final supa = Supabase.instance.client;
    final user = supa.auth.currentUser;
    if (user == null) return null;
    final uid = user.id;
    Future<String?> _try(String table, String idCol) async {
      final row = await supa
          .from(table)
          .select('username')
          .eq(idCol, uid)
          .maybeSingle();
      final name = (row?['username'] as String?)?.trim();
      return (name == null || name.isEmpty) ? null : name;
    }

    String? name;
    name ??= await _try('user_profies', 'user_id');
    name ??= await _try('user_profies', 'id');
    name ??= await _try('user_profiles', 'user_id');
    name ??= await _try('user_profiles', 'id');

    final meta = (user.userMetadata?['username'] as String?)?.trim();
    if (meta != null && meta.isNotEmpty) return meta;
    return name;
  };
  await AppConsoleLogger.success('username_loader:installed');
}

/// ================== APP BOOTSTRAP ==================
Future<void> main() async {
  await runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      // 2) Logger Flutter
      FlutterError.onError = (FlutterErrorDetails details) async {
        FlutterError.dumpErrorToConsole(details);
        await AppConsoleLogger.error(
          'flutter_error: ${details.exceptionAsString()}',
        );
        await AppConsoleLogger.debug('flutter_stack: ${details.stack}');
      };

      // 3) Supabase
      try {
        await Supabase.initialize(
          url: kSupabaseUrl,
          anonKey: kSupabaseAnonKey,
          authOptions: const AppAuthClientOptions(
            autoRefreshToken: true,
            persistSession: true,
            detectSessionInUrl: true,
          ).toFlutter(),
        );

        await Supabase.instance.client.auth.recoverSessionFromStorage();

        print(
          '$_green[COP’IQ] [SUCCESS] Supabase correctement initialisé ✅$_rst',
        );

        // 👇👇 AJOUTE CETTE LIGNE APRÈS L’INIT SUPABASE
        await _installUsernameLoader();

        await AppConsoleLogger.init(
          env: kDeveloperMode ? 'development' : 'production',
          initHooks: true,
          batchSize: 25,
          flushEvery: const Duration(seconds: 5),
        );

        final supa = Supabase.instance.client;
        final token = supa.auth.currentSession?.accessToken ?? '';
        final platform = kIsWeb
            ? 'web'
            : defaultTargetPlatform.toString().split('.').last;

        if (kDebugMode) {
          // ignore: avoid_print
          print('$_cyan[COP’IQ] [INFO]  Supabase URL: $kSupabaseUrl$_rst');
          // ignore: avoid_print
          print(
            '$_cyan[COP’IQ] [INFO]  Anon key: ${_mask(kSupabaseAnonKey)}$_rst',
          );
          if (token.isNotEmpty) {
            // ignore: avoid_print
            print('$_cyan[COP’IQ] [INFO]  Access token: ${_mask(token)}$_rst');
          }
          // ignore: avoid_print
          print(
            '$_cyan[COP’IQ] [BOOT]  Platform=$platform  Debug=$kDebugMode  DevMode=$kDeveloperMode$_rst',
          );
          // ignore: avoid_print
          print(
            '$_cyan[COP’IQ] [ROUTES] ${RouteRegistry.routes.keys.toList()}$_rst',
          );
        }
      } catch (e) {
        await AppConsoleLogger.error('supabase:init_failed: $e');
        if (kDebugMode) {
          // ignore: avoid_print
          print('$_red[COP’IQ] [ERROR] Échec initialisation Supabase: $e$_rst');
        }
      }

      // 4) **Charge les préférences UI (thème) avant runApp** -> défaut LIGHT
      await AppSettingsController.I.load();

      // 5) Lisse le premier frame (facultatif)
      await Future.delayed(const Duration(milliseconds: 60));

      // 6) Lance l’app : le ThemeMode vient du contrôleur (LIGHT par défaut)
      runApp(const MyApp());
    },
    (error, stack) async {
      await AppConsoleLogger.error('zone_uncaught: $error');
      await AppConsoleLogger.debug('zone_uncaught_stack: $stack');
      if (kDebugMode) {
        // ignore: avoid_print
        print('$_red[COP’IQ] [FATAL] $error$_rst');
      }
    },
  );
}

class MyApp extends StatefulWidget {
  const MyApp();
  @override
  State<MyApp> createState() => _MyAppState();
}

enum _Route { loading, warning, onboarding, home }

class _MyAppState extends State<MyApp> {
  _Route _route = _Route.loading;
  StreamSubscription<AuthState>? _authSub;

  @override
  void initState() {
    super.initState();
    SubscriptionService.instance.startAutoSync(); // ✅

    _authSub = Supabase.instance.client.auth.onAuthStateChange.listen((
      event,
    ) async {
      final e = event.event;
      final u = event.session?.user;

      switch (e) {
        case AuthChangeEvent.signedIn:
          // ignore: avoid_print
          print(
            '$_green[COP’IQ] [AUTH] signedIn — user=${u?.id} email=${u?.email}$_rst',
          );
          await AppConsoleLogger.info(
            'auth:signed_in',
            context: {'user_id': u?.id, 'email': u?.email},
          );
          break;
        case AuthChangeEvent.signedOut:
          // ignore: avoid_print
          print('$_yellow[COP’IQ] [AUTH] signedOut$_rst');
          await AppConsoleLogger.info('auth:signed_out');
          break;
        case AuthChangeEvent.tokenRefreshed:
          // ignore: avoid_print
          print('$_green[COP’IQ] [AUTH] tokenRefreshed$_rst');
          await AppConsoleLogger.debug('auth:token_refreshed');
          break;
        case AuthChangeEvent.userUpdated:
          // ignore: avoid_print
          print('$_cyan[COP’IQ] [AUTH] userUpdated — user=${u?.id}$_rst');
          await AppConsoleLogger.debug(
            'auth:user_updated',
            context: {'user_id': u?.id},
          );
          break;
        default:
          // ignore: avoid_print
          print('$_cyan[COP’IQ] [AUTH] ${e.name}$_rst');
          await AppConsoleLogger.debug('auth:${e.name}');
      }
    });

    _bootstrap();
  }

  @override
  void dispose() {
    _authSub?.cancel();
    super.dispose();
  }

  Future<void> _bootstrap() async {
    await AppConsoleLogger.info('app:bootstrap:start');

    final prefs = await SharedPreferences.getInstance();
    bool ack = prefs.getBool(_kWarningAckKey) ?? false;
    bool obDone = prefs.getBool(_kOnboardingDoneKey) ?? false;

    if (!kDeveloperMode) {
      await prefs.remove(_kWarningAckKey);
      await prefs.remove(_kOnboardingDoneKey);
      ack = false;
      obDone = false;
      // ignore: avoid_print
      print(
        '$_yellow[COP’IQ] [BOOT] Mode production: reset des flags warning/onboarding$_rst',
      );
      await AppConsoleLogger.warn('app:bootstrap:reset_flags');
    }

    await Future.delayed(const Duration(milliseconds: 300));

    if (!ack) {
      setState(() => _route = _Route.warning);
      // ignore: avoid_print
      print('$_cyan[COP’IQ] [NAV] -> /warning$_rst');
      await AppConsoleLogger.info('nav:goto', message: '/warning');
    } else if (!obDone) {
      setState(() => _route = _Route.onboarding);
      // ignore: avoid_print
      print('$_cyan[COP’IQ] [NAV] -> /onboarding$_rst');
      await AppConsoleLogger.info('nav:goto', message: '/onboarding');
    } else {
      setState(() => _route = _Route.home);
      // ignore: avoid_print
      print('$_cyan[COP’IQ] [NAV] -> /home$_rst');
      await AppConsoleLogger.info('nav:goto', message: '/home');
    }

    await AppConsoleLogger.success(
      'app:bootstrap:done',
      context: {'route': _route.name},
    );
  }

  Future<void> _onWarningAccepted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kWarningAckKey, true);

    final obDone = prefs.getBool(_kOnboardingDoneKey) ?? false;
    setState(() => _route = obDone ? _Route.home : _Route.onboarding);

    await AppConsoleLogger.info(
      'warning:accepted',
      context: {'next': obDone ? '/home' : '/onboarding'},
    );
  }

  Future<void> _goToSignupAfterOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kOnboardingDoneKey, true);
    _navKey.currentState?.pushNamed('/signup');
    await AppConsoleLogger.info('nav:push', message: '/signup');
  }

  Future<void> _goToLoginAfterOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kOnboardingDoneKey, true);
    _navKey.currentState?.pushNamed('/login');
    await AppConsoleLogger.info('nav:push', message: '/login');
  }

  // ======= THÈMES =======
  ThemeData _lightTheme() {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: _T.bg,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _T.ink,
        brightness: Brightness.light,
        surface: _T.bg,
      ),
      textTheme: GoogleFonts.instrumentSansTextTheme(),
      splashFactory: InkRipple.splashFactory,
    );
  }

  ThemeData _darkTheme() {
    const darkBg = Color(0xFF0F1114);
    const card = Color(0xFF161A1E);
    const surface = Color(0xFF15181C);
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: darkBg,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blueGrey,
        brightness: Brightness.dark,
        surface: surface,
        primary: Colors.grey,
        onPrimary: Colors.black,
      ),
      cardColor: card,
      textTheme: GoogleFonts.instrumentSansTextTheme(
        ThemeData(brightness: Brightness.dark).textTheme,
      ),
      splashFactory: InkRipple.splashFactory,
    );
  }

  @override
  Widget build(BuildContext context) {
    // 🔗 Source unique (AppSettingsController) — LIGHT par défaut
    final settingsCtrl = AppSettingsController.I;

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: settingsCtrl.themeMode,
      builder: (_, mode, __) {
        return MaterialApp(
          title: 'COP’IQ',
          debugShowCheckedModeBanner: false,
          theme: _lightTheme(),
          darkTheme: _darkTheme(),
          themeMode: mode, // ← pilote tout : onboarding, login, home, etc.
          navigatorKey: _navKey,
          navigatorObservers: [_LoggerRouteObserver()],
          routes: RouteRegistry.routes,
          onGenerateRoute: appOnGenerateRoute,
          // Splash Flutter interne qui matche le thème courant
          home: switch (_route) {
            _Route.loading => const _BootSplash(),

            _Route.warning => WarningScreen(onAccepted: _onWarningAccepted),

            _Route.onboarding => OnboardingScreen(
              onSkip: _goToSignupAfterOnboarding,
              onFinish: _goToSignupAfterOnboarding,
              onLogin: _goToLoginAfterOnboarding,
            ),

            _Route.home => SubscriptionGate(child: const ModePickerScreen()),
          },
        );
      },
    );
  }
}

// Splash Flutter interne (couleur = thème courant)
// → garantit une continuité visuelle avec le splash natif light
class _BootSplash extends StatelessWidget {
  const _BootSplash();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: cs.surface,
      body: const Center(
        child: SizedBox(
          width: 48,
          height: 48,
          child: CircularProgressIndicator(strokeWidth: 4),
        ),
      ),
    );
  }
}

class _NotFoundScreen extends StatelessWidget {
  final String path;
  const _NotFoundScreen({required this.path});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page introuvable')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.search_off_rounded, size: 64),
              const SizedBox(height: 16),
              Text(
                'La route "$path" est introuvable.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil(HomePage.routeName, (r) => false),
                child: const Text('Retour à l’accueil'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
