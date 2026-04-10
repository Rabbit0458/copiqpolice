// lib/home/gpx_school_config.dart

import 'package:copiqpolice/home/home_page.dart'
    show CategoryConfig, SubCategoryConfig;

import 'package:copiqpolice/onboarding/gpx_school.dart' show GpxSchoolProgram;

// lib/home/gpx_school_config.dart

import 'package:flutter/material.dart';
import 'package:copiqpolice/home/home_page.dart'
    show CategoryConfig, SubCategoryConfig;
import 'package:copiqpolice/onboarding/gpx_school.dart' show GpxSchoolProgram;

/// =======================================================
///  GPX SCHOOL — CONFIG CENTRALISÉE
/// =======================================================
///
/// - 1 seule source de vérité pour la Home
/// - routes, labels, badges, images, sous-catégories
/// - + helpers imageFor/subtitleFor pour tes cards
///
class GpxSchoolConfig {
  const GpxSchoolConfig._();

  // -------- Images par thème (heuristiques simples) --------
  static String imageFor(String label) {
    final l = label.toLowerCase().trim();

    if (l.startsWith('quiz')) return 'assets/images/quiz.jpeg';

    if (l.contains('quiz generalite') || l.contains('quiz generalite')) {
      return 'assets/images/quiz.jpeg';
    }
    if (l.contains('classification'))
      return 'assets/images/classification.jpeg';
    if (l.contains('infraction'))
      return 'assets/images/infraction_materiel.jpeg';
    if (l.contains('tentative')) return 'assets/images/infraction_legal.jpeg';
    if (l.contains('complic')) return 'assets/images/complicite.jpeg';
    if (l.contains('légitime') || l.contains('legitime')) {
      return 'assets/images/legitime_defense.jpeg';
    }
    if (l.contains('arme') || l.contains('cadre légal')) {
      return 'assets/images/armes_munitions.jpeg';
    }
    if (l.contains('libert')) return 'assets/images/libertes_publiques.jpeg';
    if (l.contains('rétention') || l.contains('retention')) {
      return 'assets/images/retention.jpeg';
    }
    if (l.contains('hierarchie') || l.contains('hierarchie')) {
      return 'assets/images/libertes_intro.jpeg';
    }

    // ============================
    // Cadres juridiques — IMAGES
    // ============================
    if (l.contains('quiz cadres') || l.contains('quiz cadres')) {
      return 'assets/images/quiz.jpeg';
    }

    if (l.contains('cadres d\'enquête') || l.contains('cadres d’enquête')) {
      return 'assets/images/cadres_enquete.jpeg';
    }

    if (l.contains('flagrant')) {
      return 'assets/images/enquete_flagrant.jpeg';
    }

    if (l.contains('préliminaire') || l.contains('preliminaire')) {
      return 'assets/images/enquete_preliminaire.jpeg';
    }

    if (l.contains('commission') && l.contains('rogatoire')) {
      return 'assets/images/commission_rogatoire.jpeg';
    }

    if (l.contains('découverte') && l.contains('blessée')) {
      return 'assets/images/personne_blessee.jpeg';
    }

    if (l.contains('mort') ||
        l.contains('cause inconnue') ||
        l.contains('suspecte')) {
      return 'assets/images/mort_suspecte.jpeg';
    }

    if (l.contains('délinquance') || l.contains('criminalité')) {
      return 'assets/images/criminalite_organisee.jpeg';
    }

    if (l.contains('personnes') && l.contains('fuite')) {
      return 'assets/images/recherche_fuite.jpeg';
    }

    if (l.contains('disparitions') || l.contains('inquiétantes')) {
      return 'assets/images/abandon_famille.jpeg';
    }

    if (l.contains('contrôles') ||
        l.contains('vérifications') ||
        l.contains('identité')) {
      return 'assets/images/controle_identite.jpeg';
    }

    if (l.contains('entraide') || l.contains('internationale')) {
      return 'assets/images/libertes_expression.jpeg';
    }

    // Procédure pénale — nouvelles catégories
    if (l.contains('action publique') ||
        l.contains('autorités') ||
        l.contains('police judiciaire') ||
        l.contains('mission de police')) {
      return 'assets/images/pp_action_publique_autorites_pj.jpeg';
    }

    if (l.contains('nullité') || l.contains('actes de procédure')) {
      return 'assets/images/pp_nullite_actes.jpeg';
    }

    if (l.contains('juridictions') ||
        l.contains('jugement') ||
        l.contains('exécution des décisions')) {
      return 'assets/images/pp_juridictions_execution.jpeg';
    }

    if (l.contains('quiz instruction préparatoire') ||
        l.contains('quiz instruction preparatoire')) {
      return 'assets/images/quiz.jpeg';
    }

    if (l.contains('instruction préparatoire') ||
        l.contains('instruction preparatoire') ||
        l.contains('mandats de justice') ||
        l.contains('contrôle judiciaire') ||
        l.contains('controle judiciaire') ||
        l.contains('détention provisoire') ||
        l.contains('detention provisoire')) {
      return 'assets/images/pp_instruction_mandats_detention.jpeg';
    }

    // Droit pénal général
    if (l.contains('loi pénale') || l.contains('loi penale')) {
      return 'assets/images/droit_penal_general.jpeg';
    }
    if (l.contains('responsabilité pénale') ||
        l.contains('responsabilite penale')) {
      return 'assets/images/droit_penal_general_2.jpeg';
    }

    // Sanction
    if (l.contains('peines') || l.contains('sûreté') || l.contains('surete')) {
      return 'assets/images/sanction.jpeg';
    }
    if (l.contains('aggravation')) return 'assets/images/aggravations.jpeg';
    if (l.contains('pluralité') || l.contains('pluralite')) {
      return 'assets/images/pluralite_infractions.jpeg';
    }
    if ((l.contains('quiz') && l.contains('sanction')) ||
        l.contains('sanction')) {
      return 'assets/images/quiz.jpeg';
    }

    // Contre la personne
    if (l.contains('mise en danger'))
      return 'assets/images/mise_en_danger.jpeg';
    if (l.contains('viol') || l.contains('agressions sexuelles')) {
      return 'assets/images/viol_agressions.jpeg';
    }
    if (l.contains('enlèvement') || l.contains('enlevement')) {
      return 'assets/images/enlevement.jpeg';
    }
    if (l.contains('diffusion d’images') || l.contains('diffusion d\'images')) {
      return 'assets/images/diffusion_images.jpeg';
    }
    if (l.contains('dignité') || l.contains('dignite')) {
      return 'assets/images/dignite.jpeg';
    }
    if (l.contains('personnalité') || l.contains('personnalite')) {
      return 'assets/images/personnalite.jpeg';
    }
    if (l.contains('involontaires')) {
      return 'assets/images/atteintes_involontaires.jpeg';
    }
    if (l.contains('volontaires à la vie') ||
        l.contains('volontaires a la vie')) {
      return 'assets/images/atteintes_vie.jpeg';
    }
    if (l.contains('volontaires à l’intégrité') ||
        l.contains('volontaires a l’integrite') ||
        l.contains('integrite')) {
      return 'assets/images/atteintes_integrite.jpeg';
    }

    // Mineurs & famille
    if (l.contains('mineurs')) return 'assets/images/mineurs_famille.jpeg';
    if (l.contains('jaf')) return 'assets/images/ordonnances_jaf.jpeg';
    if (l.contains('autorité parentale') || l.contains('autorite parentale')) {
      return 'assets/images/autorite_parentale.jpeg';
    }
    if (l.contains('abandon de famille')) {
      return 'assets/images/abandon_famille.jpeg';
    }

    // Contre la nation
    if (l.contains('association de malfaiteurs')) {
      return 'assets/images/association_malfaiteurs.jpeg';
    }
    if (l.contains('abus d’autorité') || l.contains('abus d\'autorite')) {
      return 'assets/images/abus_autorite.jpeg';
    }
    if (l.contains('action de la justice')) {
      return 'assets/images/action_justice.jpeg';
    }
    if (l.contains('administration par des particuliers')) {
      return 'assets/images/administration_particuliers.jpeg';
    }
    if (l.contains('faux') && l.contains('usage')) {
      return 'assets/images/faux_usage_faux.jpeg';
    }
    if (l.contains('probité') || l.contains('probite')) {
      return 'assets/images/probite.jpeg';
    }

    // Contre les biens
    if (l.contains('recel')) return 'assets/images/recel.jpeg';
    if (l.contains('vol')) return 'assets/images/vol.jpeg';
    if (l.contains('stad')) return 'assets/images/stad.jpeg';
    if (l.contains('chèques') ||
        l.contains('cheques') ||
        l.contains('contrefa')) {
      return 'assets/images/contrefacons.jpeg';
    }
    if (l.contains('destructions') ||
        l.contains('dégradations') ||
        l.contains('degradations')) {
      return 'assets/images/destructions.jpeg';
    }
    if (l.contains('voisines du vol')) {
      return 'assets/images/voisines_vol.jpeg';
    }

    // Circulation
    if (l.contains('stupéfiants') || l.contains('stupefiants')) {
      return 'assets/images/conduite_stupefiants.jpeg';
    }
    if (l.contains('ivresse')) return 'assets/images/ivresse.jpeg';
    if (l.contains('état alcoolique') || l.contains('etat alcoolique')) {
      return 'assets/images/etat_alcoolique.jpeg';
    }
    if (l.contains('assurance')) return 'assets/images/defaut_assurance.jpeg';
    if (l.contains('permis')) return 'assets/images/defaut_permis.jpeg';
    if (l.contains('délit de fuite') || l.contains('delit de fuite')) {
      return 'assets/images/delit_fuite.jpeg';
    }
    if (l.contains('excès de vitesse') || l.contains('exces de vitesse')) {
      return 'assets/images/grand_exces_vitesse.jpeg';
    }
    if (l.contains('vérifications') || l.contains('verifications')) {
      return 'assets/images/refus_verifications.jpeg';
    }
    if (l.contains('obtempérer') || l.contains('obtemperer')) {
      return 'assets/images/refus_obtemperer.jpeg';
    }
    if (l.contains('rodéo') || l.contains('rodeo')) {
      return 'assets/images/rodeo_motorise.jpeg';
    }
    if (l.contains('plaques') || l.contains('inscriptions')) {
      return 'assets/images/plaques_inscriptions.jpeg';
    }
    if (l.contains('incitation') ||
        l.contains('organisation') ||
        l.contains('promotion')) {
      return 'assets/images/image4.jpeg';
    }

    // Armes
    if (l.contains('classification des armes')) {
      return 'assets/images/armes_munitions.jpeg';
    }
    if (l.contains('définitions') || l.contains('definitions')) {
      return 'assets/images/armes_definitions.jpeg';
    }
    if (l.contains('introduction')) return 'assets/images/armes_intro.jpeg';
    if (l.contains('cat. a') ||
        l.contains('cat. b') ||
        l.contains('cat a') ||
        l.contains('cat b')) {
      return 'assets/images/armes_cat_ab.jpeg';
    }
    if (l.contains('cat. c') ||
        l.contains('cat. d') ||
        l.contains('cat c') ||
        l.contains('cat d')) {
      return 'assets/images/armes_cat_cd.jpeg';
    }
    if (l.contains('matériels de guerre') ||
        l.contains('materiels de guerre')) {
      return 'assets/images/armes_materiels_guerre.jpeg';
    }
    if (l.contains('acquisition') ||
        l.contains('détention') ||
        l.contains('detention')) {
      return 'assets/images/armes_acquisition_detention.jpeg';
    }
    if (l.contains('port') || l.contains('transport')) {
      return 'assets/images/armes_port_transport.jpeg';
    }

    // Libertés publiques
    if (l.contains('introduction générale') ||
        l.contains('introduction generale')) {
      return 'assets/images/libertes_intro.jpeg';
    }
    if (l.contains('garanties')) return 'assets/images/libertes_garanties.jpeg';
    if (l.contains('expression collectives')) {
      return 'assets/images/libertes_expression.jpeg';
    }
    if (l.contains('vie privée') || l.contains('vie privee')) {
      return 'assets/images/libertes_vie_privee.jpeg';
    }

    // Stups
    if (l.contains('stupéfiants') || l.contains('stupefiants')) {
      return 'assets/images/stupefiants.jpeg';
    }
    if (l.contains('cession') || l.contains('offre illicite')) {
      return 'assets/images/stup_cession_offre.jpeg';
    }
    if (l.contains('direction') || l.contains('organisation')) {
      return 'assets/images/stup_direction_org.jpeg';
    }
    if (l.contains('facilitation'))
      return 'assets/images/stup_facilitation.jpeg';
    if (l.contains('production') || l.contains('fabrication')) {
      return 'assets/images/stup_production.jpeg';
    }
    if (l.contains('provocation d’un majeur') ||
        l.contains('provocation d\'un majeur')) {
      return 'assets/images/stup_provocation.jpeg';
    }
    if (l.contains('blanchiment')) return 'assets/images/stup_blanchiment.jpeg';
    if (l.contains('transport') ||
        l.contains('détention') ||
        l.contains('detention')) {
      return 'assets/images/stup_transport_detention.jpeg';
    }
    if (l.contains('importation') || l.contains('exportation')) {
      return 'assets/images/stup_import_export.jpeg';
    }
    if (l.contains('usage illicite')) return 'assets/images/stup_usage.jpeg';

    return 'assets/images/generalite.jpeg';
  }

  static String subtitleFor(String label) {
    final l = label.toLowerCase();

    // Généralités
    if (l.contains('classification')) return 'Concepts de base';
    if (l.contains('infraction')) return 'Éléments légal, matériel & moral';
    if (l.contains('tentative')) return 'Actes non consommés mais punissables';
    if (l.contains('complic')) return 'Participation punissable à l’infraction';
    if (l.contains('légitime') || l.contains('legitime')) {
      return 'Protection immédiate et nécessaire';
    }
    if (l.contains('armes')) return 'Usage et régimes applicables';
    if (l.contains('libert')) return 'Droits fondamentaux et garanties';
    if (l.contains('rétention') || l.contains('retention')) {
      return 'Mesures temporaires en locaux de police';
    }
    if (l.contains('quiz generalites')) {
      return 'Testez vos connaissances sur les généralités';
    }

    // Cadres juridiques
    if (l.contains('cadres d\'enquête') || l.contains('cadres d’enquête')) {
      return 'Vue d’ensemble des différents cadres prévus par le code de procédure pénale';
    }
    if (l.contains('flagrant')) {
      return 'Enquête de police sur infraction flagrante (art. 53 à 73 du code de procédure pénale)';
    }
    if (l.contains('préliminaire') || l.contains('preliminaire')) {
      return 'Cadre d’enquête hors flagrance (art. 75 à 78 du code de procédure pénale)';
    }
    if (l.contains('commission') && l.contains('rogatoire')) {
      return 'Instruction déléguée par le juge (art. 81 et 151 à 154-2 du code de procédure pénale)';
    }
    if (l.contains('découverte') && l.contains('blessée')) {
      return 'Premiers actes en cas de blessé grave (art. 74 al. 6 du code de procédure pénale)';
    }
    if (l.contains('mort') ||
        l.contains('cause inconnue') ||
        l.contains('suspecte')) {
      return 'Constat, enquête et saisines (art. 74 et 80-4 du code de procédure pénale)';
    }
    if (l.contains('délinquance') || l.contains('criminalité')) {
      return 'Procédure renforcée pour la délinquance et la criminalité organisées';
    }
    if (l.contains('personnes') && l.contains('fuite')) {
      return 'Cadre juridique de la recherche des personnes recherchées (art. 74-2 du code de procédure pénale)';
    }
    if (l.contains('disparitions') || l.contains('inquiétantes')) {
      return 'Disparition de cause inconnue ou suspecte (art. 74-1 et 80-4 du code de procédure pénale)';
    }
    if (l.contains('contrôles') ||
        l.contains('vérifications') ||
        l.contains('identité')) {
      return 'Contrôles, relevés signalétiques et vérifications d’identité';
    }
    if (l.contains('entraide') || l.contains('internationale')) {
      return 'Coopération entre autorités judiciaires françaises et étrangères';
    }
    if (l.contains('quiz cadres')) {
      return 'Testez vos connaissances sur la procédure pénale';
    }

    // Procédure pénale
    if (l.contains('action publique') ||
        l.contains('autorités') ||
        l.contains('police judiciaire') ||
        l.contains('mission de police')) {
      return 'Action civile/pénale, organisation, compétences, contrôle PJ';
    }
    if (l.contains('nullité') || l.contains('actes de procédure')) {
      return 'Causes, effets et régime juridique des nullités';
    }
    if (l.contains('juridictions') ||
        l.contains('jugement') ||
        l.contains('exécution des décisions')) {
      return 'Organisation, compétences, voies de recours, exécution';
    }
    if (l.contains('instruction préparatoire') ||
        l.contains('mandats de justice') ||
        l.contains('contrôle judiciaire') ||
        l.contains('détention provisoire') ||
        l.contains('detention provisoire')) {
      return 'Instruction, mandats, CJ, détention provisoire';
    }
    if (l.contains('quiz instruction')) {
      return 'Testez vos connaissances sur la procédure pénale';
    }

    return 'Module';
  }
}

const Map<GpxSchoolProgram, List<CategoryConfig>> gpxSchoolCategoriesConfig = {
  // =========================================================
  // 1) INSTITUTIONS & VALEURS
  // =========================================================
  GpxSchoolProgram.institutionValeurs: [
    CategoryConfig(
      label: 'Institutions & valeurs',
      badge: 'Socle',
      image: 'assets/images/background.jpeg',
      route: '/gpx/institutions_valeurs',
      subcategories: [
        SubCategoryConfig(
          label: 'À configurer — Organisation & institutions',
          route: '/gpx/institutions_valeurs/orga',
        ),
        SubCategoryConfig(
          label: 'À configurer — Déontologie',
          route: '/gpx/institutions_valeurs/deontologie',
        ),
        SubCategoryConfig(
          label: 'À configurer — Valeurs & éthique',
          route: '/gpx/institutions_valeurs/valeurs',
        ),
      ],
    ),
    CategoryConfig(
      label: 'Textes & références',
      badge: 'Ressources',
      image: 'assets/images/generalite.jpeg',
      route: '/gpx/institutions_valeurs/textes',
      subcategories: [
        SubCategoryConfig(
          label: 'À configurer — Code de déontologie',
          route: '/gpx/institutions_valeurs/textes/deonto',
        ),
        SubCategoryConfig(
          label: 'À configurer — Référentiels',
          route: '/gpx/institutions_valeurs/textes/ref',
        ),
      ],
    ),
    CategoryConfig(
      label: 'Quiz',
      badge: 'S\'entraîner',
      image: 'assets/images/quiz.jpeg',
      route: '/gpx/institutions_valeurs/quiz',
    ),
  ],

  // =========================================================
  // 2) DPS / DPG
  // =========================================================
  GpxSchoolProgram.dpsDpg: [
    CategoryConfig(
      label: 'Généralités',
      badge: 'Concepts de base',
      image: 'assets/images/generalite.jpeg',
      route: '/gpx_scolarité_pages/generalite_pages',
      subcategories: [
        SubCategoryConfig(
          label: 'Classification des infractions',
          route: '/gpx/generalites/classification_infractions',
        ),
        SubCategoryConfig(
          label: 'L\'infraction',
          route: '/gpx/generalites/infraction_intro',
        ),
        SubCategoryConfig(
          label: 'La tentative punissable',
          route: '/gpx/generalites/tentative_intro',
        ),
        SubCategoryConfig(
          label: 'La complicité',
          route: '/gpx/generalites/complicite_intro',
        ),
        SubCategoryConfig(
          label: 'La légitime défense',
          route: '/gpx/generalites/legitimedefense_intro',
        ),
        SubCategoryConfig(
          label: 'Cadre légal d\'usage des armes',
          route: '/gpx/generalites/usagedesarmes_intro',
        ),
        SubCategoryConfig(
          label: 'Les libertés publiques',
          route: '/gpx/generalites/libertespubliques_intro',
        ),
        SubCategoryConfig(
          label: 'Cas de rétention dans les locaux de police',
          route: '/gpx/generalites/retention_locaux_police_intro',
        ),
        SubCategoryConfig(
          label:
              'La hiérarchie des personnels de la Police Nationale : Fonctions judiciaires',
          route: '/gpx/generalites/hierarchie_intro',
        ),
        SubCategoryConfig(
          label:
              'Quiz généralités, classification des infractions, infraction, tentative punissable etc..',
          route: '/gpx/procedure_penale/quiz/generalité_principales',
        ),
      ],
    ),
    CategoryConfig(
      label: 'Cadres juridiques',
      badge: 'Cadres d\'enquête',
      image: 'assets/images/cadres_juridiques.jpeg',
      route: '/gpx_scolarité_pages/cadres_juridiques_pages',
      subcategories: [
        SubCategoryConfig(
          label: 'Les cadres d\'enquête',
          route: '/gpx/generalites/cadres_enquete_intro',
        ),
        SubCategoryConfig(
          label: 'L’enquête de flagrant délit',
          route: '/gpx/generalites/flagrant_delit_intro',
        ),
        SubCategoryConfig(
          label: 'L’enquête préliminaire',
          route: '/gpx/generalites/enquete_preliminaire_intro',
        ),
        SubCategoryConfig(
          label: 'La commission rogatoire',
          route: '/gpx/generalites/commission_rogatoire_intro',
        ),
        SubCategoryConfig(
          label: 'Découverte d’une personne grièvement blessée',
          route: '/gpx/generalites/personne_blessee_intro',
        ),
        SubCategoryConfig(
          label: 'Mort de cause inconnue ou suspecte',
          route: '/gpx/generalites/mort_inconnue_intro',
        ),
        SubCategoryConfig(
          label: 'Délinquance & criminalité organisées',
          route: '/gpx/generalites/criminalite_deliquance_intro',
        ),
        SubCategoryConfig(
          label: 'Recherche des personnes en fuite',
          route: '/gpx/generalites/personnes_fuite_intro',
        ),
        SubCategoryConfig(
          label: 'Disparitions inquiétantes',
          route: '/gpx/cadres_juridiques/disparitions_inquietantes_intro',
        ),
        SubCategoryConfig(
          label: 'Contrôles et vérifications d’identité',
          route: '/gpx/generalites/flagrant_delit_intro',
        ),
        SubCategoryConfig(
          label: 'Entraide judiciaire internationale',
          route: '/gpx/generalites/entraide_judiciaire_intro',
        ),
        SubCategoryConfig(
          label:
              'Quiz cadres juridiques, les cadres d\'enquête, l\'enquête de flagrant délit etc..',
          route: '/gpx/procedure_penale/quiz/cadres_juridiques_principales',
        ),
      ],
    ),
    CategoryConfig(
      label: 'Procédure Pénale',
      badge: 'Cours & cas pratiques',
      image: 'assets/images/procedure_penale.jpg',
      route: '/gpx_scolarité_pages/procédure_pénale_pages',
      subcategories: [
        SubCategoryConfig(
          label:
              'Action publique, action civile, autorités & contrôle de la PJ',
          route:
              '/gpx_scolarité_pages/procédure_pénale_pages/pp_action_publique_autorites_pj',
        ),
        SubCategoryConfig(
          label: 'Nullité des actes de procédure',
          route:
              '/gpx_scolarité_pages/procédure_pénale_pages/nullite_intro_page',
        ),
        SubCategoryConfig(
          label: 'Juridictions de jugement & exécution des décisions',
          route:
              '/gpx_scolarité_pages/procédure_pénale_pages/juridictions_intro',
        ),
        SubCategoryConfig(
          label:
              'Instruction préparatoire, mandats, contrôle jud., détention provisoire',
          route:
              '/gpx_scolarité_pages/procédure_pénale_pages/pp_instruction_mandats_controle_detention',
        ),
        SubCategoryConfig(
          label:
              'Quiz instruction préparatoire, mandats & détention provisoire',
          route: '/gpx/procedure_penale/quiz/instruction_preparatoire',
        ),
      ],
    ),
    CategoryConfig(
      label: 'Droit pénal général',
      badge: 'Loi & responsabilité',
      image: 'assets/images/droit_penal_general.jpeg',
      route: '/gpx_scolarité_pages/droit_pénale_général_pages',
      subcategories: [
        SubCategoryConfig(
          label: 'De la loi pénale',
          route: '/gpx_scolarité_pages/droit_pénale_général_pages/loi_penale',
        ),
        SubCategoryConfig(
          label: 'De la responsabilité pénale',
          route:
              '/gpx_scolarité_pages/droit_pénale_général_pages/responsabilite_penale',
        ),
      ],
    ),
    CategoryConfig(
      label: 'La sanction',
      badge: 'Peines & sûreté',
      image: 'assets/images/sanction.jpeg',
      route: '/gpx_scolarité_pages/sanction_pages',
      subcategories: [
        SubCategoryConfig(
          label: 'Classification des peines et mesures de sûreté',
          route: '/gpx_scolarité_pages/sanction_pages/classification_peines',
        ),
        SubCategoryConfig(
          label: 'Causes d’aggravation de la sanction',
          route:
              '/gpx_scolarité_pages/sanction_pages/causes_aggravation_sanction',
        ),
        SubCategoryConfig(
          label: 'Règles en cas de pluralité d’infractions',
          route: '/gpx_scolarité_pages/sanction_pages/pluralite_infractions',
        ),
        SubCategoryConfig(
          label: 'Quiz — Sanction  (récidive, réitération, concours réel)',
          route: '/gpx/sanction/quiz/sanction_page',
        ),
      ],
    ),
    CategoryConfig(
      label: 'Crimes & délits contre la personne',
      badge: 'Atteintes aux personnes',
      image: 'assets/images/contre_personne.jpeg',
      route: '/gpx_scolarité_pages/crime_delit_contre_personne_pages',
      subcategories: [
        SubCategoryConfig(
          label: 'La mise en danger de la personne',
          route:
              '/gpx_scolarité_pages/crime_delit_contre_personne_pages/mise_en_danger',
        ),
        SubCategoryConfig(
          label: 'Le viol, l’inceste et autres agressions sexuelles',
          route:
              '/gpx_scolarité_pages/crime_delit_contre_personne_pages/viol_inceste_agressions/avertissement',
        ),
        SubCategoryConfig(
          label: 'L’enlèvement et la séquestration',
          route:
              '/gpx_scolarité_pages/crime_delit_contre_personne_pages/enlevement_sequestration',
        ),
        SubCategoryConfig(
          label: 'Enregistrement & diffusion d’images',
          route:
              '/gpx_scolarité_pages/crime_delit_contre_personne_pages/enregistrement_diffusion_images',
        ),
        SubCategoryConfig(
          label: 'Atteintes à la dignité de la personne',
          route:
              '/gpx_scolarité_pages/crime_delit_contre_personne_pages/dignite_personne',
        ),
        SubCategoryConfig(
          label: 'Atteintes à la personnalité',
          route:
              '/gpx_scolarité_pages/crime_delit_contre_personne_pages/personnalite',
        ),
        SubCategoryConfig(
          label: 'Atteintes involontaires à la vie et à l’intégrité',
          route:
              '/gpx_scolarité_pages/crime_delit_contre_personne_pages/atteintes_involontaires',
        ),
        SubCategoryConfig(
          label: 'Atteintes volontaires à la vie',
          route:
              '/gpx_scolarité_pages/crime_delit_contre_personne_pages/atteintes_volontaires_vie',
        ),
        SubCategoryConfig(
          label: 'Atteintes volontaires à l’intégrité physique',
          route:
              '/gpx_scolarité_pages/crime_delit_contre_personne_pages/atteintes_volontaires_integrite',
        ),
        SubCategoryConfig(
          label: 'Quiz — Crimes & délits contre la personne',
          route: '/gpx/crimes_personne/quiz/crimes_delits_personne',
        ),
      ],
    ),
    CategoryConfig(
      label: 'Atteintes aux mineurs & à la famille',
      badge: 'Protection des mineurs',
      image: 'assets/images/mineurs_famille.jpeg',
      route: '/gpx_scolarité_pages/mineurs_famille_pages',
      subcategories: [
        SubCategoryConfig(
          label: 'La mise en péril des mineurs',
          route: '/gpx_scolarité_pages/mineurs_famille_pages/mise_en_peril',
        ),
        SubCategoryConfig(
          label: 'Violation d’ordonnances JAF (violences)',
          route:
              '/gpx_scolarité_pages/mineurs_famille_pages/violation_ordonnances_jaf',
        ),
        SubCategoryConfig(
          label: 'Atteintes à l’exercice de l’autorité parentale',
          route:
              '/gpx_scolarité_pages/mineurs_famille_pages/autorite_parentale',
        ),
        SubCategoryConfig(
          label: 'L’abandon de famille',
          route: '/gpx_scolarité_pages/mineurs_famille_pages/abandon_famille',
        ),
        SubCategoryConfig(
          label: 'Quiz — L’abandon de famille',
          route: '/gpx/mineurs_famille_pages/quiz/quiz_mineurs_famille',
        ),
      ],
    ),
    CategoryConfig(
      label: 'Crimes & délits contre la nation',
      badge: 'Institutions & justice',
      image: 'assets/images/contre_nation.jpeg',
      route: '/gpx_scolarité_pages/crime_delit_nation_pages',
      subcategories: [
        SubCategoryConfig(
          label: 'Association de malfaiteurs',
          route:
              '/gpx_scolarité_pages/crime_delit_nation_pages/association_malfaiteurs',
        ),
        SubCategoryConfig(
          label: 'Abus d’autorité contre les particuliers',
          route: '/gpx_scolarité_pages/crime_delit_nation_pages/abus_autorite',
        ),
        SubCategoryConfig(
          label: 'Atteintes à l’action de la justice',
          route:
              '/gpx_scolarité_pages/crime_delit_nation_pages/atteintes_action_justice',
        ),
        SubCategoryConfig(
          label: 'Atteintes à l’administration par des particuliers',
          route:
              '/gpx_scolarité_pages/crime_delit_nation_pages/atteintes_administration',
        ),
        SubCategoryConfig(
          label: 'Faux et usage de faux',
          route:
              '/gpx_scolarité_pages/crime_delit_nation_pages/faux_usage_faux',
        ),
        SubCategoryConfig(
          label: 'Manquements au devoir de probité',
          route: '/gpx_scolarité_pages/crime_delit_nation_pages/probite',
        ),
        SubCategoryConfig(
          label: 'Quiz — Crimes & délits contre la nation',
          route: '/gpx/crime_delit_nation_pages/quiz/quiz_crimes_delits_nation',
        ),
      ],
    ),
    CategoryConfig(
      label: 'Crimes & délits contre les biens',
      badge: 'Atteintes aux biens',
      image: 'assets/images/contre_biens.jpeg',
      route: '/gpx_scolarité_pages/crime_delit_bien_pages',
      subcategories: [
        SubCategoryConfig(
          label: 'Recel & non-justification de ressources',
          route:
              '/gpx_scolarité_pages/crime_delit_bien_pages/recel_non_justification',
        ),
        SubCategoryConfig(
          label: 'Le vol',
          route: '/gpx_scolarité_pages/crime_delit_bien_pages/vol',
        ),
        SubCategoryConfig(
          label: 'Atteintes aux STAD (informatique)',
          route: '/gpx_scolarité_pages/crime_delit_bien_pages/stad',
        ),
        SubCategoryConfig(
          label: 'Contrefaçons & falsifications de chèques',
          route:
              '/gpx_scolarité_pages/crime_delit_bien_pages/contrefacons_falsifications',
        ),
        SubCategoryConfig(
          label: 'Destructions, dégradations, détériorations',
          route:
              '/gpx_scolarité_pages/crime_delit_bien_pages/destructions_degradations',
        ),
        SubCategoryConfig(
          label: 'Infractions voisines du vol',
          route: '/gpx_scolarité_pages/crime_delit_bien_pages/voisines_du_vol',
        ),
        SubCategoryConfig(
          label: 'Quiz — Crimes & délits contre les biens',
          route: '/gpx/crime_delit_nation_pages/quiz/quiz_crimes_delits_bien',
        ),
      ],
    ),
    CategoryConfig(
      label: 'Infractions à la circulation routière',
      badge: 'Code de la route',
      image: 'assets/images/circulation_routiere.jpeg',
      route: '/gpx_scolarité_pages/infraction_circulation_routière_pages',
      subcategories: [
        SubCategoryConfig(
          label: 'Conduite après usage de stupéfiants',
          route:
              '/gpx_scolarité_pages/infraction_circulation_routière_pages/conduite_stupefiants',
        ),
        SubCategoryConfig(
          label: 'Conduite en état d’ivresse',
          route:
              '/gpx_scolarité_pages/infraction_circulation_routière_pages/ivresse',
        ),
        SubCategoryConfig(
          label: 'Conduite sous l’empire d’un état alcoolique',
          route:
              '/gpx_scolarité_pages/infraction_circulation_routière_pages/etat_alcoolique',
        ),
        SubCategoryConfig(
          label: 'Défaut d’assurance',
          route:
              '/gpx_scolarité_pages/infraction_circulation_routière_pages/defaut_assurance',
        ),
        SubCategoryConfig(
          label: 'Défaut de permis de conduire',
          route:
              '/gpx_scolarité_pages/infraction_circulation_routière_pages/defaut_permis',
        ),
        SubCategoryConfig(
          label: 'Délit de fuite',
          route:
              '/gpx_scolarité_pages/infraction_circulation_routière_pages/delit_fuite',
        ),
        SubCategoryConfig(
          label: 'Grand excès de vitesse',
          route:
              '/gpx_scolarité_pages/infraction_circulation_routière_pages/grand_exces_vitesse',
        ),
        SubCategoryConfig(
          label: 'Refus de vérifications',
          route:
              '/gpx_scolarité_pages/infraction_circulation_routière_pages/refus_verifications',
        ),
        SubCategoryConfig(
          label: 'Refus d’obtempérer',
          route:
              '/gpx_scolarité_pages/infraction_circulation_routière_pages/refus_obtemperer',
        ),
        SubCategoryConfig(
          label: 'Rodéo motorisé',
          route:
              '/gpx_scolarité_pages/infraction_circulation_routière_pages/rodeo_motorise',
        ),
        SubCategoryConfig(
          label: 'Plaques & inscriptions (délits liés)',
          route:
              '/gpx_scolarité_pages/infraction_circulation_routière_pages/plaques_inscriptions',
        ),
        SubCategoryConfig(
          label: 'Incitation / organisation / promotion',
          route:
              '/gpx_scolarité_pages/infraction_circulation_routière_pages/incitation_organisation_promotion',
        ),
        SubCategoryConfig(
          label: 'Quiz — Infractions à la circulation routière',
          route:
              '/gpx/infraction_circulation_routière_pages/quiz/quiz_circulation_routiere',
        ),
      ],
    ),
    CategoryConfig(
      label: 'Armes & munitions',
      badge: 'Régimes spéciaux',
      image: 'assets/images/armes_munitions.jpeg',
      route: '/gpx_scolarité_pages/armes_munitions_pages',
      subcategories: [
        SubCategoryConfig(
          label: 'Classification des armes et des munitions',
          route:
              '/gpx_scolarité_pages/armes_munitions_pages/armes_classification',
        ),
        SubCategoryConfig(
          label: 'Définitions',
          route: '/gpx_scolarité_pages/armes_munitions_pages/armes_definitions',
        ),
        SubCategoryConfig(
          label: 'Introduction',
          route:
              '/gpx_scolarité_pages/armes_munitions_pages/armes_introduction',
        ),
        SubCategoryConfig(
          label: 'Acquisition/détention cat. A ou B sans autorisation',
          route:
              '/gpx_scolarité_pages/armes_munitions_pages/armes_acquisition_detention_ab',
        ),
        SubCategoryConfig(
          label: 'Port/transport sans motif légitime (cat. C ou D)',
          route:
              '/gpx_scolarité_pages/armes_munitions_pages/armes_port_transport_cd',
        ),
        SubCategoryConfig(
          label: 'Régimes matériels de guerre / éléments d’arme',
          route:
              '/gpx_scolarité_pages/armes_munitions_pages/armes_materiels_guerre_elements',
        ),
        SubCategoryConfig(
          label: 'Règles d’acquisition & détention',
          route:
              '/gpx_scolarité_pages/armes_munitions_pages/armes_regles_acquisition_detention',
        ),
        SubCategoryConfig(
          label: 'Règles de port & transport',
          route:
              '/gpx_scolarité_pages/armes_munitions_pages/armes_regles_port_transport',
        ),
        SubCategoryConfig(
          label: 'Quiz — Classification des armes et des munitions',
          route: '/gpx/armes_munitions_pages/quiz/quiz_armes_munitions_pages',
        ),
      ],
    ),
    CategoryConfig(
      label: 'Libertés publiques',
      badge: 'Droits & garanties',
      image: 'assets/images/libertes_publiques.jpeg',
      route: '/gpx/generalites/libertespubliques_intro',
    ),
    CategoryConfig(
      label: 'Stupéfiants — usage & trafic',
      badge: 'Stups',
      image: 'assets/images/stupefiants.jpeg',
      route: '/gpx_scolarité_pages/stupéfiants_pages',
      subcategories: [
        SubCategoryConfig(
          label: 'Introduction',
          route: '/gpx_scolarité_pages/stupéfiants_pages/introduction',
        ),
        SubCategoryConfig(
          label: 'Cession/offre illicites pour consommation personnelle',
          route: '/gpx_scolarité_pages/stupéfiants_pages/cession_offre',
        ),
        SubCategoryConfig(
          label: 'Direction/organisation d’un trafic',
          route:
              '/gpx_scolarité_pages/stupéfiants_pages/direction_organisation',
        ),
        SubCategoryConfig(
          label: 'Facilitation à l’usage illicite',
          route: '/gpx_scolarité_pages/stupéfiants_pages/facilitation_usage',
        ),
        SubCategoryConfig(
          label: 'Production/fabrication illicites',
          route:
              '/gpx_scolarité_pages/stupéfiants_pages/production_fabrication',
        ),
        SubCategoryConfig(
          label: 'Provocation d’un majeur à l’usage ou au trafic',
          route: '/gpx_scolarité_pages/stupéfiants_pages/provocation_majeur',
        ),
        SubCategoryConfig(
          label: 'Blanchiment du produit du trafic',
          route: '/gpx_scolarité_pages/stupéfiants_pages/blanchiment_produit',
        ),
        SubCategoryConfig(
          label: 'Transport/détention/offre/cession/acquisition/emploi',
          route:
              '/gpx_scolarité_pages/stupéfiants_pages/transport_detention_offre',
        ),
        SubCategoryConfig(
          label: 'Importation/exportation illicites',
          route: '/gpx_scolarité_pages/stupéfiants_pages/import_export',
        ),
        SubCategoryConfig(
          label: 'Usage illicite de stupéfiants',
          route: '/gpx_scolarité_pages/stupéfiants_pages/usage_illicite',
        ),
        SubCategoryConfig(
          label: 'Quiz — Stupéfiants — usage & trafic',
          route: '/gpx/stupéfiants_pages/quiz/quiz_stupéfiants',
        ),
      ],
    ),
  ],

  // =========================================================
  // 3) MÉMENTO CIRCULATION ROUTIÈRE
  // =========================================================
  GpxSchoolProgram.mememtoCirculationRoutiere: [
    CategoryConfig(
      label: 'Mémento — Alcool',
      badge: 'Circulation',
      image: 'assets/images/ivresse.jpeg',
      route: '/gpx/memento_circulation/alcool',
      subcategories: [
        SubCategoryConfig(
          label: 'À configurer — Procédure',
          route: '/gpx/memento_circulation/alcool/procedure',
        ),
      ],
    ),
    CategoryConfig(
      label: 'Mémento — Stupéfiants',
      badge: 'Circulation',
      image: 'assets/images/conduite_stupefiants.jpeg',
      route: '/gpx/memento_circulation/stupefiants',
      subcategories: [
        SubCategoryConfig(
          label: 'À configurer — Dépistage & vérifs',
          route: '/gpx/memento_circulation/stupefiants/depistage',
        ),
      ],
    ),
    CategoryConfig(
      label: 'Mémento — PV & formulaires',
      badge: 'Outils',
      image: 'assets/images/pv_regles_gpx.jpg',
      route: '/gpx/memento_circulation/pv',
      subcategories: [
        SubCategoryConfig(
          label: 'À configurer — Trames',
          route: '/gpx/memento_circulation/pv/trames',
        ),
        SubCategoryConfig(
          label: 'À configurer — Formulaires',
          route: '/gpx/memento_circulation/pv/formulaires',
        ),
      ],
    ),
  ],

  // =========================================================
  // 4) POLICIER EN INTERVENTION
  // =========================================================
  GpxSchoolProgram.policierEnIntervention: [
    CategoryConfig(
      label: 'Cadre d\'intervention',
      badge: 'Sécurité',
      image: 'assets/images/contre_personne.jpeg',
      route: '/gpx/intervention/cadre',
      subcategories: [
        SubCategoryConfig(
          label: 'À configurer — Usage de la force',
          route: '/gpx/intervention/cadre/force',
        ),
        SubCategoryConfig(
          label: 'À configurer — Contrôle & palpation',
          route: '/gpx/intervention/cadre/controle',
        ),
      ],
    ),
    CategoryConfig(
      label: 'Techniques & communication',
      badge: 'Terrain',
      image: 'assets/images/libertes_publiques.jpeg',
      route: '/gpx/intervention/techniques',
      subcategories: [
        SubCategoryConfig(
          label: 'À configurer — Communication opérationnelle',
          route: '/gpx/intervention/techniques/comm',
        ),
        SubCategoryConfig(
          label: 'À configurer — Gestion de conflit',
          route: '/gpx/intervention/techniques/conflit',
        ),
      ],
    ),
    CategoryConfig(
      label: 'Quiz intervention',
      badge: 'S\'entraîner',
      image: 'assets/images/quiz.jpeg',
      route: '/gpx/intervention/quiz',
    ),
  ],

  // =========================================================
  // 5) RECUEIL PV (APJ 20)
  // =========================================================
  GpxSchoolProgram.recueilPvApj20: [
    CategoryConfig(
      label: 'Recueil PV — Bases',
      badge: 'Canevas',
      image: 'assets/images/pv_regles_gpx.jpg',
      route: '/gpx/pv_apj20/bases',
      subcategories: [
        SubCategoryConfig(
          label: 'À configurer — Introduction',
          route: '/gpx/pv_apj20/bases/intro',
        ),
        SubCategoryConfig(
          label: 'À configurer — Trames essentielles',
          route: '/gpx/pv_apj20/bases/trames',
        ),
      ],
    ),
    CategoryConfig(
      label: 'Recueil PV — Circulation',
      badge: 'Alcool / Stups',
      image: 'assets/images/circulation_routiere.jpeg',
      route: '/gpx/pv_apj20/circulation',
      subcategories: [
        SubCategoryConfig(
          label: 'À configurer — Alcool',
          route: '/gpx/pv_apj20/circulation/alcool',
        ),
        SubCategoryConfig(
          label: 'À configurer — Stupéfiants',
          route: '/gpx/pv_apj20/circulation/stupefiants',
        ),
      ],
    ),
    CategoryConfig(
      label: 'Quiz PV',
      badge: 'S\'entraîner',
      image: 'assets/images/quiz.jpeg',
      route: '/gpx/pv_apj20/quiz',
    ),
  ],

  // =========================================================
  // 6) DIMENSION HUMAINE
  // =========================================================
  GpxSchoolProgram.dimensionHumaine: [
    CategoryConfig(
      label: 'Communication & posture',
      badge: 'Relationnel',
      image: 'assets/images/libertes_vie_privee.jpeg',
      route: '/gpx/dimension_humaine/communication',
      subcategories: [
        SubCategoryConfig(
          label: 'À configurer — Accueil & écoute',
          route: '/gpx/dimension_humaine/communication/ecoute',
        ),
        SubCategoryConfig(
          label: 'À configurer — Annonces difficiles',
          route: '/gpx/dimension_humaine/communication/annonces',
        ),
      ],
    ),
    CategoryConfig(
      label: 'Stress & gestion émotionnelle',
      badge: 'Bien-être',
      image: 'assets/images/dignite.jpeg',
      route: '/gpx/dimension_humaine/stress',
      subcategories: [
        SubCategoryConfig(
          label: 'À configurer — Respiration',
          route: '/gpx/dimension_humaine/stress/respiration',
        ),
        SubCategoryConfig(
          label: 'À configurer — Routines',
          route: '/gpx/dimension_humaine/stress/routines',
        ),
      ],
    ),
    CategoryConfig(
      label: 'Éthique au quotidien',
      badge: 'Valeurs',
      image: 'assets/images/probite.jpeg',
      route: '/gpx/dimension_humaine/ethique',
      subcategories: [
        SubCategoryConfig(
          label: 'À configurer — Exemples terrain',
          route: '/gpx/dimension_humaine/ethique/exemples',
        ),
      ],
    ),
  ],
};

const Map<String, String> redirectConfig = {
  // '/gpx/placeholder': '/gpx/ton_vrai_module',
};
