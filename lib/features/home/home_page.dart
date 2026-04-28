// lib/home/home_page.dart
// Home réécrite avec configuration centralisée

import 'dart:async';
import 'dart:ui' show PointerDeviceKind, ImageFilter;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
// Services / pages existants
import 'package:copiqpolice/core/widgets/app_notifier.dart';
import 'package:copiqpolice/core/services/favorites.dart';
import 'package:copiqpolice/features/home/favoris_home.dart';
import 'package:copiqpolice/features/home/journal_home.dart';
import 'package:copiqpolice/features/home/profil_page.dart';
import 'package:copiqpolice/core/widgets/app_notifier.dart' show AppSettingsController;

// Pages
import 'package:copiqpolice/content/gpx_scolarite/shared/procedure_penale_page.dart';
import 'package:copiqpolice/features/onboarding/mode_picker.dart';

// ========== GPX — generalite ==========
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/generalite_pages/classification_infractions/classification_infractions_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/generalite_pages/infraction/infraction_page.dart';

// ========== GPX — Cadres juridiques ==========
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/cadres_enquete_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_flagrant_delit_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/autres_cadres_enquete_page.dart';

// ========== GPX — Droit pénal général ==========
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/droit_p%C3%A9nale_g%C3%A9n%C3%A9ral_pages/responsabilite_penale_page.dart';

// ========== GPX — Sanction ==========
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/sanction_pages/classification_peines_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/sanction_pages/pluralite_infractions_page.dart';

// ========== GPX — Crimes & délits contre les biens ==========
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/vol_page.dart';

// ========================= CONFIGURATION CENTRALE (ALIGNÉE AUX DOSSIERS) =========================

const Map<UserMode, Map<Track, List<CategoryConfig>>> categoriesConfig = {
  UserMode.school: {
    Track.gpx: [
      // 1) generalite_pages/*
      CategoryConfig(
        label: 'Généralités',
        badge: 'Concepts de base',
        image: 'assets/images/generalite.jpeg',
        route: '/gpx_scolarite_pages/generalite_pages',
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
            route: '/gpx/generalites/tentative_punissable',
          ),
          SubCategoryConfig(
            label: 'La complicité',
            route: '/gpx/generalites/complicite',
          ),
          SubCategoryConfig(
            label: 'La légitime défense',
            route: '/gpx/generalites/legitime_defense',
          ),
          SubCategoryConfig(
            label: 'Cadre légal d\'usage des armes',
            route: '/gpx/generalites/cadre_legal_armes',
          ),
          SubCategoryConfig(
            label: 'Les libertés publiques',
            route: '/gpx/generalites/libertes_publiques',
          ),
          SubCategoryConfig(
            label: 'Cas de rétention dans les locaux de police',
            route: '/gpx/generalites/retention_locaux_police',
          ),
        ],
      ),

      // 2) cadres_juridiques_pages/*
      CategoryConfig(
        label: 'Cadres juridiques',
        badge: 'Cadres d\'enquête',
        image: 'assets/images/cadres_juridiques.jpeg',
        route: '/gpx_scolarite_pages/cadres_juridiques_pages',
        subcategories: [
          SubCategoryConfig(
            label: 'Les cadres d\'enquête',
            route: '/gpx/cadres_juridiques/cadres_enquete',
          ),
          SubCategoryConfig(
            label: 'L\'enquête de flagrant délit',
            route: '/gpx/cadres_juridiques/enquete_flagrant_delit',
          ),
          SubCategoryConfig(
            label: 'L\'enquête préliminaire',
            route: '/gpx/cadres_juridiques/enquete_preliminaire',
          ),
          SubCategoryConfig(
            label: 'Les autres cadres d\'enquête',
            route: '/gpx/cadres_juridiques/autres_cadres_enquete',
          ),
        ],
      ),

      // 3) procédure_pénale_pages/*
      CategoryConfig(
        label: 'Procédure Pénale',
        badge: 'Cours & cas pratiques',
        image: 'assets/images/procedure_penale.jpg',
        route: '/gpx_scolarite_pages/procédure_pénale_pages',
        subcategories: [
          SubCategoryConfig(
            label: 'Garde à vue',
            route: '/gpx_scolarite_pages/procédure_pénale_pages/pp_gav',
          ),
          SubCategoryConfig(
            label: 'Perquisitions',
            route:
                '/gpx_scolarite_pages/procédure_pénale_pages/pp_perquisitions',
          ),
          SubCategoryConfig(
            label: 'Auditions et PV',
            route:
                '/gpx_scolarite_pages/procédure_pénale_pages/pp_auditions_pv',
          ),
          SubCategoryConfig(
            label: 'Mesures de contrainte',
            route:
                '/gpx_scolarite_pages/procédure_pénale_pages/pp_mesures_contrainte',
          ),
          SubCategoryConfig(
            label: 'Saisies et scellés',
            route:
                '/gpx_scolarite_pages/procédure_pénale_pages/pp_saisies_scelles',
          ),
          SubCategoryConfig(
            label: 'Contrôles d’identité',
            route:
                '/gpx_scolarite_pages/procédure_pénale_pages/pp_controle_identite',
          ),
          SubCategoryConfig(
            label: 'Infractions spécifiques (stup., armes, roulage)',
            route:
                '/gpx_scolarite_pages/procédure_pénale_pages/pp_infractions_specifiques',
          ),
          SubCategoryConfig(
            label: 'Procès-verbal — Structure et règles',
            route: '/gpx_scolarite_pages/procédure_pénale_pages/pp_pv_regles',
          ),
        ],
      ),

      // 4) droit_pénale_général_pages/*
      CategoryConfig(
        label: 'Droit pénal général',
        badge: 'Loi & responsabilité',
        image: 'assets/images/droit_penal_general.jpeg',
        route: '/gpx_scolarite_pages/droit_pénale_général_pages',
        subcategories: [
          SubCategoryConfig(
            label: 'De la loi pénale',
            route: '/gpx_scolarite_pages/droit_pénale_général_pages/loi_penale',
          ),
          SubCategoryConfig(
            label: 'De la responsabilité pénale',
            route:
                '/gpx_scolarite_pages/droit_pénale_général_pages/responsabilite_penale',
          ),
        ],
      ),

      // 5) sanction_pages/*
      CategoryConfig(
        label: 'La sanction',
        badge: 'Peines & sûreté',
        image: 'assets/images/sanction.jpeg',
        route: '/gpx_scolarite_pages/sanction_pages',
        subcategories: [
          SubCategoryConfig(
            label: 'Classification des peines et mesures de sûreté',
            route: '/gpx_scolarite_pages/sanction_pages/classification_peines',
          ),
          SubCategoryConfig(
            label: 'Causes d’aggravation de la sanction',
            route: '/gpx_scolarite_pages/sanction_pages/causes_aggravation',
          ),
          SubCategoryConfig(
            label: 'Règles en cas de pluralité d’infractions',
            route: '/gpx_scolarite_pages/sanction_pages/pluralite_infractions',
          ),
        ],
      ),

      // 6) crime_delit_contre_personne_pages/*
      CategoryConfig(
        label: 'Crimes & délits contre la personne',
        badge: 'Atteintes aux personnes',
        image: 'assets/images/contre_personne.jpeg',
        route: '/gpx_scolarite_pages/crime_delit_contre_personne_pages',
        subcategories: [
          SubCategoryConfig(
            label: 'La mise en danger de la personne',
            route:
                '/gpx_scolarite_pages/crime_delit_contre_personne_pages/mise_en_danger',
          ),
          SubCategoryConfig(
            label: 'Le viol, l’inceste et autres agressions sexuelles',
            route:
                '/gpx_scolarite_pages/crime_delit_contre_personne_pages/viol_inceste_agressions',
          ),
          SubCategoryConfig(
            label: 'L’enlèvement et la séquestration',
            route:
                '/gpx_scolarite_pages/crime_delit_contre_personne_pages/enlevement_sequestration',
          ),
          SubCategoryConfig(
            label: 'Enregistrement & diffusion d’images',
            route:
                '/gpx_scolarite_pages/crime_delit_contre_personne_pages/enregistrement_diffusion_images',
          ),
          SubCategoryConfig(
            label: 'Atteintes à la dignité de la personne',
            route:
                '/gpx_scolarite_pages/crime_delit_contre_personne_pages/dignite_personne',
          ),
          SubCategoryConfig(
            label: 'Atteintes à la personnalité',
            route:
                '/gpx_scolarite_pages/crime_delit_contre_personne_pages/personnalite',
          ),
          SubCategoryConfig(
            label: 'Atteintes involontaires à la vie et à l’intégrité',
            route:
                '/gpx_scolarite_pages/crime_delit_contre_personne_pages/atteintes_involontaires',
          ),
          SubCategoryConfig(
            label: 'Atteintes volontaires à la vie',
            route:
                '/gpx_scolarite_pages/crime_delit_contre_personne_pages/atteintes_volontaires_vie',
          ),
          SubCategoryConfig(
            label: 'Atteintes volontaires à l’intégrité physique',
            route:
                '/gpx_scolarite_pages/crime_delit_contre_personne_pages/atteintes_volontaires_integrite',
          ),
        ],
      ),

      // 7) mineurs_famille_pages/*
      CategoryConfig(
        label: 'Atteintes aux mineurs & à la famille',
        badge: 'Protection des mineurs',
        image: 'assets/images/mineurs_famille.jpeg',
        route: '/gpx_scolarite_pages/mineurs_famille_pages',
        subcategories: [
          SubCategoryConfig(
            label: 'La mise en péril des mineurs',
            route: '/gpx_scolarite_pages/mineurs_famille_pages/mise_en_peril',
          ),
          SubCategoryConfig(
            label: 'Violation d’ordonnances JAF (violences)',
            route:
                '/gpx_scolarite_pages/mineurs_famille_pages/violation_ordonnances_jaf',
          ),
          SubCategoryConfig(
            label: 'Atteintes à l’exercice de l’autorité parentale',
            route:
                '/gpx_scolarite_pages/mineurs_famille_pages/autorite_parentale',
          ),
          SubCategoryConfig(
            label: 'L’abandon de famille',
            route: '/gpx_scolarite_pages/mineurs_famille_pages/abandon_famille',
          ),
        ],
      ),

      // 8) crime_delit_nation_pages/*
      CategoryConfig(
        label: 'Crimes & délits contre la nation',
        badge: 'Institutions & justice',
        image: 'assets/images/contre_nation.jpeg',
        route: '/gpx_scolarite_pages/crime_delit_nation_pages',
        subcategories: [
          SubCategoryConfig(
            label: 'Association de malfaiteurs',
            route:
                '/gpx_scolarite_pages/crime_delit_nation_pages/association_malfaiteurs',
          ),
          SubCategoryConfig(
            label: 'Abus d’autorité contre les particuliers',
            route:
                '/gpx_scolarite_pages/crime_delit_nation_pages/abus_autorite',
          ),
          SubCategoryConfig(
            label: 'Atteintes à l’action de la justice',
            route:
                '/gpx_scolarite_pages/crime_delit_nation_pages/atteintes_action_justice',
          ),
          SubCategoryConfig(
            label: 'Atteintes à l’administration par des particuliers',
            route:
                '/gpx_scolarite_pages/crime_delit_nation_pages/atteintes_administration',
          ),
          SubCategoryConfig(
            label: 'Faux et usage de faux',
            route:
                '/gpx_scolarite_pages/crime_delit_nation_pages/faux_usage_faux',
          ),
          SubCategoryConfig(
            label: 'Manquements au devoir de probité',
            route: '/gpx_scolarite_pages/crime_delit_nation_pages/probite',
          ),
        ],
      ),

      // 9) crime_delit_bien_pages/*
      CategoryConfig(
        label: 'Crimes & délits contre les biens',
        badge: 'Atteintes aux biens',
        image: 'assets/images/contre_biens.jpeg',
        route: '/gpx_scolarite_pages/crime_delit_bien_pages',
        subcategories: [
          SubCategoryConfig(
            label: 'Recel & non-justification de ressources',
            route:
                '/gpx_scolarite_pages/crime_delit_bien_pages/recel_non_justification',
          ),
          SubCategoryConfig(
            label: 'Le vol',
            route: '/gpx_scolarite_pages/crime_delit_bien_pages/vol',
          ),
          SubCategoryConfig(
            label: 'Atteintes aux STAD (informatique)',
            route: '/gpx_scolarite_pages/crime_delit_bien_pages/stad',
          ),
          SubCategoryConfig(
            label: 'Contrefaçons & falsifications de chèques',
            route:
                '/gpx_scolarite_pages/crime_delit_bien_pages/contrefacons_falsifications',
          ),
          SubCategoryConfig(
            label: 'Destructions, dégradations, détériorations',
            route:
                '/gpx_scolarite_pages/crime_delit_bien_pages/destructions_degradations',
          ),
          SubCategoryConfig(
            label: 'Infractions voisines du vol',
            route:
                '/gpx_scolarite_pages/crime_delit_bien_pages/voisines_du_vol',
          ),
        ],
      ),

      // 10) infraction_circulation_routière_pages/*
      CategoryConfig(
        label: 'Infractions à la circulation routière',
        badge: 'Code de la route',
        image: 'assets/images/circulation_routiere.jpeg',
        route: '/gpx_scolarite_pages/infraction_circulation_routière_pages',
        subcategories: [
          SubCategoryConfig(
            label: 'Conduite après usage de stupéfiants',
            route:
                '/gpx_scolarite_pages/infraction_circulation_routière_pages/conduite_stupefiants',
          ),
          SubCategoryConfig(
            label: 'Conduite en état d’ivresse',
            route:
                '/gpx_scolarite_pages/infraction_circulation_routière_pages/ivresse',
          ),
          SubCategoryConfig(
            label: 'Conduite sous l’empire d’un état alcoolique',
            route:
                '/gpx_scolarite_pages/infraction_circulation_routière_pages/etat_alcoolique',
          ),
          SubCategoryConfig(
            label: 'Défaut d’assurance',
            route:
                '/gpx_scolarite_pages/infraction_circulation_routière_pages/defaut_assurance',
          ),
          SubCategoryConfig(
            label: 'Défaut de permis de conduire',
            route:
                '/gpx_scolarite_pages/infraction_circulation_routière_pages/defaut_permis',
          ),
          SubCategoryConfig(
            label: 'Délit de fuite',
            route:
                '/gpx_scolarite_pages/infraction_circulation_routière_pages/delit_fuite',
          ),
          SubCategoryConfig(
            label: 'Grand excès de vitesse',
            route:
                '/gpx_scolarite_pages/infraction_circulation_routière_pages/grand_exces_vitesse',
          ),
          SubCategoryConfig(
            label: 'Refus de vérifications',
            route:
                '/gpx_scolarite_pages/infraction_circulation_routière_pages/refus_verifications',
          ),
          SubCategoryConfig(
            label: 'Refus d’obtempérer',
            route:
                '/gpx_scolarite_pages/infraction_circulation_routière_pages/refus_obtemperer',
          ),
          SubCategoryConfig(
            label: 'Rodéo motorisé',
            route:
                '/gpx_scolarite_pages/infraction_circulation_routière_pages/rodeo_motorise',
          ),
          SubCategoryConfig(
            label: 'Plaques & inscriptions (délits liés)',
            route:
                '/gpx_scolarite_pages/infraction_circulation_routière_pages/plaques_inscriptions',
          ),
          SubCategoryConfig(
            label: 'Incitation / organisation / promotion',
            route:
                '/gpx_scolarite_pages/infraction_circulation_routière_pages/incitation_organisation_promotion',
          ),
        ],
      ),

      // 11) armes_munitions_pages/*
      CategoryConfig(
        label: 'Armes & munitions',
        badge: 'Régimes spéciaux',
        image: 'assets/images/armes_munitions.jpeg',
        route: '/gpx_scolarite_pages/armes_munitions_pages',
        subcategories: [
          SubCategoryConfig(
            label: 'Classification des armes et des munitions',
            route:
                '/gpx_scolarite_pages/armes_munitions_pages/armes_classification',
          ),
          SubCategoryConfig(
            label: 'Définitions',
            route:
                '/gpx_scolarite_pages/armes_munitions_pages/armes_definitions',
          ),
          SubCategoryConfig(
            label: 'Introduction',
            route:
                '/gpx_scolarite_pages/armes_munitions_pages/armes_introduction',
          ),
          SubCategoryConfig(
            label: 'Acquisition/détention cat. A ou B sans autorisation',
            route:
                '/gpx_scolarite_pages/armes_munitions_pages/armes_acquisition_detention_ab',
          ),
          SubCategoryConfig(
            label: 'Port/transport sans motif légitime (cat. C ou D)',
            route:
                '/gpx_scolarite_pages/armes_munitions_pages/armes_port_transport_cd',
          ),
          SubCategoryConfig(
            label: 'Régimes matériels de guerre / éléments d’arme',
            route:
                '/gpx_scolarite_pages/armes_munitions_pages/armes_materiels_guerre_elements',
          ),
          SubCategoryConfig(
            label: 'Règles d’acquisition & détention',
            route:
                '/gpx_scolarite_pages/armes_munitions_pages/armes_regles_acquisition_detention',
          ),
          SubCategoryConfig(
            label: 'Règles de port & transport',
            route:
                '/gpx_scolarite_pages/armes_munitions_pages/armes_regles_port_transport',
          ),
        ],
      ),

      // 12) libertés_publiques_pages/*
      CategoryConfig(
        label: 'Libertés publiques',
        badge: 'Droits & garanties',
        image: 'assets/images/libertes_publiques.jpeg',
        route: '/gpx_scolarite_pages/libertés_publiques_pages',
        subcategories: [
          SubCategoryConfig(
            label: 'Introduction générale',
            route: '/gpx_scolarite_pages/libertés_publiques_pages/introduction',
          ),
          SubCategoryConfig(
            label: 'Garanties & protection',
            route:
                '/gpx_scolarite_pages/libertés_publiques_pages/garanties_protection',
          ),
          SubCategoryConfig(
            label: 'Libertés d’expression collectives',
            route:
                '/gpx_scolarite_pages/libertés_publiques_pages/expression_collectives',
          ),
          SubCategoryConfig(
            label: 'Libertés individuelles & vie privée',
            route:
                '/gpx_scolarite_pages/libertés_publiques_pages/individuelles_vie_privee',
          ),
        ],
      ),

      // 13) stupéfiants_pages/*
      CategoryConfig(
        label: 'Stupéfiants — usage & trafic',
        badge: 'Stups',
        image: 'assets/images/stupefiants.jpeg',
        route: '/gpx_scolarite_pages/stupéfiants_pages',
        subcategories: [
          SubCategoryConfig(
            label: 'Introduction',
            route: '/gpx_scolarite_pages/stupéfiants_pages/introduction',
          ),
          SubCategoryConfig(
            label: 'Cession/offre illicites pour consommation personnelle',
            route: '/gpx_scolarite_pages/stupéfiants_pages/cession_offre',
          ),
          SubCategoryConfig(
            label: 'Direction/organisation d’un trafic',
            route:
                '/gpx_scolarite_pages/stupéfiants_pages/direction_organisation',
          ),
          SubCategoryConfig(
            label: 'Facilitation à l’usage illicite',
            route: '/gpx_scolarite_pages/stupéfiants_pages/facilitation_usage',
          ),
          SubCategoryConfig(
            label: 'Production/fabrication illicites',
            route:
                '/gpx_scolarite_pages/stupéfiants_pages/production_fabrication',
          ),
          SubCategoryConfig(
            label: 'Provocation d’un majeur à l’usage ou au trafic',
            route: '/gpx_scolarite_pages/stupéfiants_pages/provocation_majeur',
          ),
          SubCategoryConfig(
            label: 'Blanchiment du produit du trafic',
            route: '/gpx_scolarite_pages/stupéfiants_pages/blanchiment_produit',
          ),
          SubCategoryConfig(
            label: 'Transport/détention/offre/cession/acquisition/emploi',
            route:
                '/gpx_scolarite_pages/stupéfiants_pages/transport_detention_offre',
          ),
          SubCategoryConfig(
            label: 'Importation/exportation illicites',
            route: '/gpx_scolarite_pages/stupéfiants_pages/import_export',
          ),
          SubCategoryConfig(
            label: 'Usage illicite de stupéfiants',
            route: '/gpx_scolarite_pages/stupéfiants_pages/usage_illicite',
          ),
        ],
      ),
    ],
  },
};

// ========================= CONFIG DES REDIRECTIONS =========================

const Map<String, String> redirectConfig = {
  // Généralités
  '/generalite': '/gpx_scolarite_pages/generalite_pages',
  '/classification_infractions': '/gpx/generalites/classification_infractions',
  '/infraction': '/gpx/generalites/infraction',
  '/infraction_intro': '/gpx/generalites/infraction_intro',
  '/tentative_punissable': '/gpx/generalites/tentative_punissable',
  '/complicite': '/gpx/generalites/complicite',
  '/legitime_defense': '/gpx/generalites/legitime_defense',
  '/cadre_legal_armes': '/gpx/generalites/cadre_legal_armes',
  '/libertes_publiques': '/gpx/generalites/libertes_publiques',
  '/retention_locaux_police': '/gpx/generalites/retention_locaux_police',

  // Cadres juridiques
  '/cadres_juridiques': '/gpx_scolarite_pages/cadres_juridiques_pages',
  '/cadres_enquete':
      '/gpx_scolarite_pages/cadres_juridiques_pages/cadres_enquete',
  '/enquete_flagrant_delit':
      '/gpx_scolarite_pages/cadres_juridiques_pages/enquete_flagrant_delit',
  '/enquete_preliminaire':
      '/gpx_scolarite_pages/cadres_juridiques_pages/enquete_preliminaire',
  '/autres_cadres_enquete':
      '/gpx_scolarite_pages/cadres_juridiques_pages/autres_cadres_enquete',

  // Procédure pénale (compat /pp/*)
  '/pp/gav': '/gpx_scolarite_pages/procédure_pénale_pages/pp_gav',
  '/pp/perquisitions':
      '/gpx_scolarite_pages/procédure_pénale_pages/pp_perquisitions',
  '/pp/auditions_pv':
      '/gpx_scolarite_pages/procédure_pénale_pages/pp_auditions_pv',
  '/pp/mesures_contrainte':
      '/gpx_scolarite_pages/procédure_pénale_pages/pp_mesures_contrainte',
  '/pp/saisies_scelles':
      '/gpx_scolarite_pages/procédure_pénale_pages/pp_saisies_scelles',
  '/pp/controle_identite':
      '/gpx_scolarite_pages/procédure_pénale_pages/pp_controle_identite',
  '/pp/infractions_specifiques':
      '/gpx_scolarite_pages/procédure_pénale_pages/pp_infractions_specifiques',
  '/pp/pv_regles': '/gpx_scolarite_pages/procédure_pénale_pages/pp_pv_regles',

  // Droit pénal général
  '/dpg': '/gpx_scolarite_pages/droit_pénale_général_pages',
  '/dpg/loi_penale':
      '/gpx_scolarite_pages/droit_pénale_général_pages/loi_penale',
  '/dpg/responsabilite_penale':
      '/gpx_scolarite_pages/droit_pénale_général_pages/responsabilite_penale',

  // Sanction
  '/sanction': '/gpx_scolarite_pages/sanction_pages',
  '/sanction/classification_peines':
      '/gpx_scolarite_pages/sanction_pages/classification_peines',
  '/sanction/causes_aggravation':
      '/gpx_scolarite_pages/sanction_pages/causes_aggravation',
  '/sanction/pluralite_infractions':
      '/gpx_scolarite_pages/sanction_pages/pluralite_infractions',

  // Contre la personne
  '/crimes_personne': '/gpx_scolarite_pages/crime_delit_contre_personne_pages',
  '/crimes_personne/mise_en_danger':
      '/gpx_scolarite_pages/crime_delit_contre_personne_pages/mise_en_danger',
  '/crimes_personne/viol_inceste_agressions':
      '/gpx_scolarite_pages/crime_delit_contre_personne_pages/viol_inceste_agressions',
  '/crimes_personne/enlevement_sequestration':
      '/gpx_scolarite_pages/crime_delit_contre_personne_pages/enlevement_sequestration',
  '/crimes_personne/enregistrement_diffusion_images':
      '/gpx_scolarite_pages/crime_delit_contre_personne_pages/enregistrement_diffusion_images',
  '/crimes_personne/dignite_personne':
      '/gpx_scolarite_pages/crime_delit_contre_personne_pages/dignite_personne',
  '/crimes_personne/personnalite':
      '/gpx_scolarite_pages/crime_delit_contre_personne_pages/personnalite',
  '/crimes_personne/atteintes_involontaires':
      '/gpx_scolarite_pages/crime_delit_contre_personne_pages/atteintes_involontaires',
  '/crimes_personne/atteintes_volontaires_vie':
      '/gpx_scolarite_pages/crime_delit_contre_personne_pages/atteintes_volontaires_vie',
  '/crimes_personne/atteintes_volontaires_integrite':
      '/gpx_scolarite_pages/crime_delit_contre_personne_pages/atteintes_volontaires_integrite',

  // Mineurs & famille
  '/mineurs_famille': '/gpx_scolarite_pages/mineurs_famille_pages',
  '/mineurs_famille/mise_en_peril':
      '/gpx_scolarite_pages/mineurs_famille_pages/mise_en_peril',
  '/mineurs_famille/violation_ordonnances_jaf':
      '/gpx_scolarite_pages/mineurs_famille_pages/violation_ordonnances_jaf',
  '/mineurs_famille/autorite_parentale':
      '/gpx_scolarite_pages/mineurs_famille_pages/autorite_parentale',
  '/mineurs_famille/abandon_famille':
      '/gpx_scolarite_pages/mineurs_famille_pages/abandon_famille',

  // Contre la nation
  '/crimes_nation': '/gpx_scolarite_pages/crime_delit_nation_pages',
  '/crimes_nation/association_malfaiteurs':
      '/gpx_scolarite_pages/crime_delit_nation_pages/association_malfaiteurs',
  '/crimes_nation/abus_autorite':
      '/gpx_scolarite_pages/crime_delit_nation_pages/abus_autorite',
  '/crimes_nation/atteintes_action_justice':
      '/gpx_scolarite_pages/crime_delit_nation_pages/atteintes_action_justice',
  '/crimes_nation/atteintes_administration':
      '/gpx_scolarite_pages/crime_delit_nation_pages/atteintes_administration',
  '/crimes_nation/faux_usage_faux':
      '/gpx_scolarite_pages/crime_delit_nation_pages/faux_usage_faux',
  '/crimes_nation/probite':
      '/gpx_scolarite_pages/crime_delit_nation_pages/probite',

  // Contre les biens
  '/crimes_biens': '/gpx_scolarite_pages/crime_delit_bien_pages',
  '/crimes_biens/recel_non_justification':
      '/gpx_scolarite_pages/crime_delit_bien_pages/recel_non_justification',
  '/crimes_biens/vol': '/gpx_scolarite_pages/crime_delit_bien_pages/vol',
  '/crimes_biens/stad': '/gpx_scolarite_pages/crime_delit_bien_pages/stad',
  '/crimes_biens/contrefacons_falsifications':
      '/gpx_scolarite_pages/crime_delit_bien_pages/contrefacons_falsifications',
  '/crimes_biens/destructions_degradations':
      '/gpx_scolarite_pages/crime_delit_bien_pages/destructions_degradations',
  '/crimes_biens/voisines_du_vol':
      '/gpx_scolarite_pages/crime_delit_bien_pages/voisines_du_vol',

  // Circulation
  '/circulation': '/gpx_scolarite_pages/infraction_circulation_routière_pages',
  '/circulation/conduite_stupefiants':
      '/gpx_scolarite_pages/infraction_circulation_routière_pages/conduite_stupefiants',
  '/circulation/ivresse':
      '/gpx_scolarite_pages/infraction_circulation_routière_pages/ivresse',
  '/circulation/etat_alcoolique':
      '/gpx_scolarite_pages/infraction_circulation_routière_pages/etat_alcoolique',
  '/circulation/defaut_assurance':
      '/gpx_scolarite_pages/infraction_circulation_routière_pages/defaut_assurance',
  '/circulation/defaut_permis':
      '/gpx_scolarite_pages/infraction_circulation_routière_pages/defaut_permis',
  '/circulation/delit_fuite':
      '/gpx_scolarite_pages/infraction_circulation_routière_pages/delit_fuite',
  '/circulation/grand_exces_vitesse':
      '/gpx_scolarite_pages/infraction_circulation_routière_pages/grand_exces_vitesse',
  '/circulation/refus_verifications':
      '/gpx_scolarite_pages/infraction_circulation_routière_pages/refus_verifications',
  '/circulation/refus_obtemperer':
      '/gpx_scolarite_pages/infraction_circulation_routière_pages/refus_obtemperer',
  '/circulation/rodeo_motorise':
      '/gpx_scolarite_pages/infraction_circulation_routière_pages/rodeo_motorise',
  '/circulation/plaques_inscriptions':
      '/gpx_scolarite_pages/infraction_circulation_routière_pages/plaques_inscriptions',
  '/circulation/incitation_organisation_promotion':
      '/gpx_scolarite_pages/infraction_circulation_routière_pages/incitation_organisation_promotion',

  // Armes
  '/armes': '/gpx_scolarite_pages/armes_munitions_pages',
  '/armes/classification':
      '/gpx_scolarite_pages/armes_munitions_pages/armes_classification',
  '/armes/definitions':
      '/gpx_scolarite_pages/armes_munitions_pages/armes_definitions',
  '/armes/introduction':
      '/gpx_scolarite_pages/armes_munitions_pages/armes_introduction',
  '/armes/acquisition_detention_ab':
      '/gpx_scolarite_pages/armes_munitions_pages/armes_acquisition_detention_ab',
  '/armes/port_transport_cd':
      '/gpx_scolarite_pages/armes_munitions_pages/armes_port_transport_cd',
  '/armes/materiels_guerre_elements':
      '/gpx_scolarite_pages/armes_munitions_pages/armes_materiels_guerre_elements',
  '/armes/regles_acquisition_detention':
      '/gpx_scolarite_pages/armes_munitions_pages/armes_regles_acquisition_detention',
  '/armes/regles_port_transport':
      '/gpx_scolarite_pages/armes_munitions_pages/armes_regles_port_transport',

  // Libertés publiques
  '/libertes': '/gpx_scolarite_pages/libertés_publiques_pages',
  '/libertes/introduction':
      '/gpx_scolarite_pages/libertés_publiques_pages/introduction',
  '/libertes/garanties_protection':
      '/gpx_scolarite_pages/libertés_publiques_pages/garanties_protection',
  '/libertes/expression_collectives':
      '/gpx_scolarite_pages/libertés_publiques_pages/expression_collectives',
  '/libertes/individuelles_vie_privee':
      '/gpx_scolarite_pages/libertés_publiques_pages/individuelles_vie_privee',

  // Stups
  '/stup': '/gpx_scolarite_pages/stupéfiants_pages',
  '/stup/introduction': '/gpx_scolarite_pages/stupéfiants_pages/introduction',
  '/stup/cession_offre': '/gpx_scolarite_pages/stupéfiants_pages/cession_offre',
  '/stup/direction_organisation':
      '/gpx_scolarite_pages/stupéfiants_pages/direction_organisation',
  '/stup/facilitation_usage':
      '/gpx_scolarite_pages/stupéfiants_pages/facilitation_usage',
  '/stup/production_fabrication':
      '/gpx_scolarite_pages/stupéfiants_pages/production_fabrication',
  '/stup/provocation_majeur':
      '/gpx_scolarite_pages/stupéfiants_pages/provocation_majeur',
  '/stup/blanchiment_produit':
      '/gpx_scolarite_pages/stupéfiants_pages/blanchiment_produit',
  '/stup/transport_detention_offre':
      '/gpx_scolarite_pages/stupéfiants_pages/transport_detention_offre',
  '/stup/import_export': '/gpx_scolarite_pages/stupéfiants_pages/import_export',
  '/stup/usage_illicite':
      '/gpx_scolarite_pages/stupéfiants_pages/usage_illicite',
};

// ========================= CONFIG DEV =========================
const bool kDevForceModePicker = false;

// ============================ MODÈLES DE CONFIGURATION =============================

class CategoryConfig {
  final String label;
  final String badge;
  final String image;
  final String route;
  final List<SubCategoryConfig>? subcategories;

  const CategoryConfig({
    required this.label,
    required this.badge,
    required this.image,
    required this.route,
    this.subcategories,
  });
}

class SubCategoryConfig {
  final String label;
  final String route;

  // ✅ Ajout pour image par sous-module
  final String? image;

  const SubCategoryConfig({
    required this.label,
    required this.route,
    this.image,
  });
}

enum Track { gpx, pa }

String trackPrefix(Track t) => t == Track.gpx ? 'gpx' : 'pa';

String flagKey(Track t, String base) => '${trackPrefix(t)}_${base}_locked';

enum UserMode { exam, school }

String userModeToText(UserMode m) => m == UserMode.school ? 'school' : 'exam';
UserMode userModeFromText(String? s) =>
    (s == 'school') ? UserMode.school : UserMode.exam;

// =============================== THÈME =================================

class _T {
  static const Color ink = Color(0xFF212529);
  static const Color bg = Color(0xFFF7F8FA);
  static const Color white = Color(0xFFFFFFFF);

  static const Color g300 = Color(0xFFCBD5E1);
  static const Color g400 = Color(0xFF9CA3AF);
  static const Color g500 = Color(0xFF6B7280);
  static const Color g600 = Color(0xFF4B5563);
  static const Color g700 = Color(0xFF374151);

  static const Duration fast = Duration(milliseconds: 220);
  static const Duration med = Duration(milliseconds: 420);

  static const double r12 = 12,
      r14 = 14,
      r16 = 16,
      r18 = 18,
      r20 = 20,
      r24 = 24,
      r28 = 28;

  static BoxShadow get shadow => BoxShadow(
    color: Colors.black.withOpacity(.08),
    blurRadius: 20,
    offset: const Offset(0, 10),
  );
}

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

class _DesktopScrollBehavior extends MaterialScrollBehavior {
  const _DesktopScrollBehavior();
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
    PointerDeviceKind.stylus,
    PointerDeviceKind.invertedStylus,
  };
}

Color _muted(BuildContext context, [double a = .72]) {
  final base =
      Theme.of(context).textTheme.bodySmall?.color ??
      (Theme.of(context).brightness == Brightness.dark ? Colors.white : _T.ink);
  return base.withOpacity(a);
}

// =========================== LOGGING ADMIN ===========================

Future<void> _log(String type, Map<String, dynamic> payload) async {
  try {
    final sb = Supabase.instance.client;
    final uid = sb.auth.currentUser?.id;
    await sb.from('app_logs').insert({
      'user_id': uid,
      'type': type,
      'payload': payload,
      'created_at': DateTime.now().toIso8601String(),
    });
  } catch (_) {
    // Pas critique : on ignore si la table n'existe pas / RLS bloque
  }
}

// =========================== REMOTE FLAGS (app_meta) ===========================

class RemoteFlagsController {
  RemoteFlagsController._();
  static final RemoteFlagsController I = RemoteFlagsController._();

  static const _kLocalPrefix = 'remote_flag_';

  final Map<String, ValueNotifier<bool>> _flags = {};
  StreamSubscription<List<Map<String, dynamic>>>? _sub;
  bool _initialized = false;

  SupabaseClient? get _sb {
    try {
      return Supabase.instance.client;
    } catch (_) {
      return null;
    }
  }

  // Flags générés dynamiquement depuis la configuration
  List<String> get _bootKeys {
    final keys = <String>['paywall_enabled'];

    // Parcourir toute la configuration pour extraire les flagKeys
    for (final modeMap in categoriesConfig.values) {
      for (final trackList in modeMap.values) {
        for (final category in trackList) {
          // Générer le flagKey basé sur le nom de la catégorie
          final flagKey = _generateFlagKey(category.label);
          keys.add(flagKey);
        }
      }
    }

    return keys.toSet().toList(); // Supprimer les doublons
  }

  String _generateFlagKey(String categoryLabel) {
    // Convertir le label en format snake_case pour le flag
    final snakeCase = categoryLabel
        .toLowerCase()
        .replaceAll(' ', '_')
        .replaceAll('—', '')
        .replaceAll('é', 'e')
        .replaceAll('è', 'e')
        .replaceAll('à', 'a')
        .replaceAll('ù', 'u')
        .replaceAll('\'', '');
    return '${snakeCase}_locked';
  }

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    final sp = await SharedPreferences.getInstance();
    for (final k in _bootKeys) {
      _flags[k] = ValueNotifier<bool>(sp.getBool('$_kLocalPrefix$k') ?? false);
    }

    final sb = _sb;
    if (sb != null) {
      try {
        final rows = await sb
            .from('app_meta')
            .select('key, value')
            .inFilter('key', _bootKeys);
        for (final row in rows) {
          final key = row['key'] as String;
          final val = _parseBool(row['value']) ?? false;
          final vn = _flags.putIfAbsent(key, () => ValueNotifier<bool>(false));
          vn.value = val;
          await sp.setBool('$_kLocalPrefix$key', val);
        }
      } catch (_) {}

      _sub = sb
          .from('app_meta')
          .stream(primaryKey: ['key'])
          .inFilter('key', _bootKeys)
          .listen((rows) async {
            for (final r in rows) {
              final key = r['key'] as String;
              final val = _parseBool(r['value']) ?? false;
              final vn = _flags.putIfAbsent(
                key,
                () => ValueNotifier<bool>(false),
              );
              if (vn.value != val) {
                vn.value = val;
                final sp = await SharedPreferences.getInstance();
                await sp.setBool('$_kLocalPrefix$key', val);
              }
            }
          });
    }
  }

  ValueNotifier<bool> flag(String key, {bool defaultValue = false}) {
    return _flags.putIfAbsent(key, () => ValueNotifier<bool>(defaultValue));
  }

  bool get(String key, {bool defaultValue = false}) =>
      _flags[key]?.value ?? defaultValue;

  void dispose() {
    _sub?.cancel();
    _sub = null;
  }
}

bool? _parseBool(dynamic v) {
  if (v == null) return null;
  if (v is bool) return v;
  final s = v.toString().trim().toLowerCase();
  if (['true', '1', 'yes', 'on'].contains(s)) return true;
  if (['false', '0', 'no', 'off'].contains(s)) return false;
  return null;
}

// ============================== USER MODE CTRL ===============================

class UserModeController {
  UserModeController._();
  static final UserModeController I = UserModeController._();

  static const _kLocalKey = 'user_mode';
  static const _kHasPassedKey = 'has_passed_exam';

  /// Valeurs réactives consommées par la Home
  final ValueNotifier<UserMode> mode = ValueNotifier<UserMode>(UserMode.exam);
  final ValueNotifier<bool> hasPassedExam = ValueNotifier<bool>(false);

  StreamSubscription<List<Map<String, dynamic>>>? _sub;
  bool _initialized = false;

  SupabaseClient? get _sb {
    try {
      return Supabase.instance.client;
    } catch (_) {
      return null;
    }
  }

  // ---------------------------------------------------------------------------
  // INIT
  // ---------------------------------------------------------------------------
  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    // 1) Lecture locale (rapide et fiable juste après les pickers)
    final sp = await SharedPreferences.getInstance();
    mode.value = userModeFromText(sp.getString(_kLocalKey));
    hasPassedExam.value = sp.getBool(_kHasPassedKey) ?? false;

    // 2) Pull Supabase si connecté -> écrase le local si disponible
    final sb = _sb;
    final user = sb?.auth.currentUser;
    if (sb != null && user != null) {
      try {
        final data = await sb
            .from('user_profiles')
            .select('user_mode, has_passed_exam')
            .eq('user_id', user.id)
            .maybeSingle(); // ✅ pas d'erreur si aucune ligne

        if (data != null) {
          final m = userModeFromText(data['user_mode'] as String?);
          final p = (data['has_passed_exam'] as bool?) ?? false;

          if (mode.value != m) mode.value = m;
          if (hasPassedExam.value != p) hasPassedExam.value = p;

          await sp.setString(_kLocalKey, userModeToText(m));
          await sp.setBool(_kHasPassedKey, p);
        }
      } catch (e, st) {
        _log('init_pull_supabase_failed', {'error': e.toString()});
        // Pas bloquant : on garde les valeurs locales
      }

      // 3) Realtime : garde les homes à jour si un autre écran modifie le profil
      try {
        _sub = sb
            .from('user_profiles')
            .stream(primaryKey: ['user_id'])
            .eq('user_id', user.id)
            .listen((rows) async {
              if (rows.isEmpty) return;
              final r = rows.first;

              final m = userModeFromText(r['user_mode'] as String?);
              final p = (r['has_passed_exam'] as bool?) ?? false;

              if (mode.value != m) mode.value = m;
              if (hasPassedExam.value != p) hasPassedExam.value = p;

              final sp = await SharedPreferences.getInstance();
              await sp.setString(_kLocalKey, userModeToText(m));
              await sp.setBool(_kHasPassedKey, p);
            });
      } catch (e, st) {
        _log('init_realtime_failed', {'error': e.toString()});
      }
    }
  }

  // ---------------------------------------------------------------------------
  // SET MODE
  // ---------------------------------------------------------------------------
  Future<void> setMode(UserMode newMode) async {
    if (mode.value == newMode) return;
    mode.value = newMode;

    // Cache local
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_kLocalKey, userModeToText(newMode));

    // Synchro Supabase
    final sb = _sb;
    final user = sb?.auth.currentUser;
    if (sb != null && user != null) {
      try {
        await sb.from('user_profiles').upsert({
          'user_id': user.id, // ✅ clé correcte
          'user_mode': userModeToText(newMode),
          'updated_at': DateTime.now().toIso8601String(),
        }, onConflict: 'user_id'); // ✅ pas 'id'
      } catch (e, st) {
        _log('set_mode_upsert_failed', {'error': e.toString()});
      }
    }

    _log('mode_changed', {'mode': userModeToText(newMode)});
  }

  // ---------------------------------------------------------------------------
  // PASSAGE AUTOMATIQUE EN SCOLARITÉ (après réussite concours)
  // ---------------------------------------------------------------------------
  Future<void> markPassedAndSwitchToSchool(BuildContext context) async {
    hasPassedExam.value = true;
    mode.value = UserMode.school;

    // Cache local
    final sp = await SharedPreferences.getInstance();
    await sp.setBool(_kHasPassedKey, true);
    await sp.setString(_kLocalKey, userModeToText(UserMode.school));

    // Synchro Supabase
    final sb = _sb;
    final user = sb?.auth.currentUser;
    if (sb != null && user != null) {
      try {
        await sb.from('user_profiles').upsert({
          'user_id': user.id, // ✅
          'has_passed_exam': true,
          'user_mode': 'school',
          'updated_at': DateTime.now().toIso8601String(),
        }, onConflict: 'user_id'); // ✅
      } catch (e, st) {
        _log('mark_passed_upsert_failed', {'error': e.toString()});
      }
    }

    // UX
    AppNotifier.show(
      context,
      title: "Bienvenue en scolarité 🎓",
      message: "Nous avons ajusté les contenus à ton nouveau statut.",
    );
    _log('mode_changed', {'mode': 'school', 'reason': 'passed_exam_banner'});
  }

  // ---------------------------------------------------------------------------
  void dispose() {
    _sub?.cancel();
    _sub = null;
  }

  void _log(String event, Map<String, dynamic> data) {
    // Remplace par ton système d’analytics si besoin
    // ignore: avoid_print
    print("[UserModeController][$event] $data");
  }
}
// =========================== HOME SHELL (root) ===========================

class HomePage extends StatefulWidget {
  static const routeName = '/home';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _rootCtrl = PageController(initialPage: 0);
  int _rootIndex = 0;

  @override
  void initState() {
    super.initState();
    AppSettingsController.I.init();
    RemoteFlagsController.I.init();
    UserModeController.I.init().then((_) => _ensureUserModeSelected());
  }

  @override
  void dispose() {
    RemoteFlagsController.I.dispose();
    UserModeController.I.dispose();
    super.dispose();
  }

  Future<void> _ensureUserModeSelected() async {
    // DEV override ?
    if (kDevForceModePicker) {
      await _openModePicker(force: true);
      return;
    }

    final sb = Supabase.instance.client;
    final user = sb.auth.currentUser;
    if (user == null) return;

    try {
      // si onboarding déjà marqué -> rien à faire
      final rows = await sb
          .from('user_settings')
          .select('onboarding_done_at')
          .eq('user_id', user.id)
          .limit(1);
      final doneAt = rows.isNotEmpty ? rows.first['onboarding_done_at'] : null;

      if (doneAt == null) {
        await _openModePicker(force: false);
      }
    } catch (_) {
      // si la table n'existe pas, on affiche au premier run uniquement (via local)
      final sp = await SharedPreferences.getInstance();
      final shown = sp.getBool('onboarding_done_local') ?? false;
      if (!shown) await _openModePicker(force: false);
    }
  }

  Future<void> _markOnboardingDone() async {
    final sb = Supabase.instance.client;
    final user = sb.auth.currentUser;
    final now = DateTime.now().toIso8601String();

    try {
      if (user != null) {
        await sb.from('user_settings').upsert({
          'user_id': user.id,
          'onboarding_done_at': now,
          'updated_at': now,
        }, onConflict: 'user_id');
      }
    } catch (_) {}
    final sp = await SharedPreferences.getInstance();
    await sp.setBool('onboarding_done_local', true);

    _log('onboarding_done', {'at': now});
  }

  Future<void> _openModePicker({required bool force}) async {
    final selected = await Navigator.of(context).push<UserMode>(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const ModePickerScreen(),
        transitionsBuilder: (_, a, __, child) =>
            FadeTransition(opacity: a, child: child),
      ),
    );

    if (selected != null) {
      await UserModeController.I.setMode(selected);
      await _markOnboardingDone();
      AppNotifier.success(
        context,
        title: selected == UserMode.exam
            ? 'Mode concours sélectionné'
            : 'Mode scolarité sélectionné',
        message: 'Tu peux modifier ce choix dans "Mon compte".',
      );
    } else if (force) {
      // Pas de sélection en mode DEV : on laisse tel quel.
    }
  }

  void _goRootTab(int i) {
    setState(() => _rootIndex = i);
    _rootCtrl.animateToPage(
      i,
      duration: const Duration(milliseconds: 360),
      curve: Curves.easeOutCubic,
    );
  }

  void _goJournalFromHome() => _goRootTab(1);

  Future<void> _onRefresh() async {
    HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    AppNotifier.show(
      context,
      title: "Actualisation",
      message: "Contenu de la page d'accueil mis à jour",
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppSettingsController.I.themeMode,
      builder: (_, mode, __) {
        final theme = (mode == ThemeMode.dark) ? _darkTheme() : _lightTheme();
        return Theme(
          data: theme,
          child: Scaffold(
            extendBody: true,
            body: SafeArea(
              child: PageView(
                controller: _rootCtrl,
                physics: const BouncingScrollPhysics(),
                onPageChanged: (i) => setState(() => _rootIndex = i),
                children: [
                  RefreshIndicator.adaptive(
                    onRefresh: _onRefresh,
                    child: Builder(
                      builder: (_) => ScrollConfiguration(
                        behavior: const _DesktopScrollBehavior(),
                        child: _HomeContentWrapper(
                          onSeeAll: _goJournalFromHome,
                        ),
                      ),
                    ),
                  ),
                  const JournalHomePage(),
                  const _StubPage(title: 'QR'),
                  const FavorisHomePage(),
                  const ProfilPage(),
                ],
              ),
            ),
            bottomNavigationBar: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // SUPPRIMÉ : Le message "Locks désactivés (DEV)" a été retiré comme demandé
                ValueListenableBuilder<double>(
                  valueListenable: AppSettingsController.I.bottomBarHeight,
                  builder: (_, barH, __) => _SlidingPillNavBar(
                    height: barH,
                    currentIndex: _rootIndex,
                    onTap: _goRootTab,
                    icons: const [
                      Icons.home_rounded,
                      Icons.article_rounded,
                      Icons.qr_code_rounded,
                      Icons.favorite_rounded,
                      Icons.person_rounded,
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// -------------------------------- TRACK CONTROLLER (GPX / PA) --------------------------------

enum UserTrack { gpx, pa }

class UserTrackController {
  UserTrackController._();
  static final UserTrackController I = UserTrackController._();

  static const _kKey = 'selected_track';
  final ValueNotifier<UserTrack> track = ValueNotifier<UserTrack>(
    UserTrack.gpx,
  );
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;
    final sp = await SharedPreferences.getInstance();
    final raw = sp.getString(_kKey);
    track.value = (raw == 'pa') ? UserTrack.pa : UserTrack.gpx;
  }

  Future<void> setTrack(UserTrack t) async {
    if (track.value == t) return;
    track.value = t;
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_kKey, t == UserTrack.pa ? 'pa' : 'gpx');
  }
}

// ===================== HOME CONTENT WRAPPER =====================

class _HomeContentWrapper extends StatefulWidget {
  final VoidCallback onSeeAll;
  const _HomeContentWrapper({required this.onSeeAll});

  @override
  State<_HomeContentWrapper> createState() => _HomeContentWrapperState();
}

class _HomeContentWrapperState extends State<_HomeContentWrapper> {
  final PageController _pageCtrl = PageController();
  final PageController _deckGP = PageController(viewportFraction: .78);
  final PageController _deckPA = PageController(viewportFraction: .78);

  // 0 = GPX, 1 = PA
  int _segment = 0;

  @override
  void initState() {
    super.initState();
    _restoreTrack();
  }

  Future<void> _restoreTrack() async {
    final sp = await SharedPreferences.getInstance();
    final raw = sp.getString('selected_track'); // 'gpx' | 'pa'
    final idx = (raw == 'pa') ? 1 : 0;

    setState(() => _segment = idx);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if ((_pageCtrl.page ?? 0).round() != idx) {
        _pageCtrl.jumpToPage(idx);
      }
      JournalBridge.selectedKey.value = (idx == 1) ? 'pa' : 'gpx';
    });
  }

  Future<void> _onSegmentChange(int i) async {
    setState(() => _segment = i);
    _pageCtrl.animateToPage(i, duration: _T.med, curve: Curves.easeInOut);
    JournalBridge.selectedKey.value = (i == 1) ? 'pa' : 'gpx';
    final sp = await SharedPreferences.getInstance();
    await sp.setString('selected_track', (i == 1) ? 'pa' : 'gpx');
  }

  @override
  Widget build(BuildContext context) {
    return _HomeContent(
      pageCtrl: _pageCtrl,
      deckGP: _deckGP,
      deckPA: _deckPA,
      segment: _segment,
      onSegmentChange: _onSegmentChange,
      onSeeAll: widget.onSeeAll,
    );
  }
}

// =========================== HOME INNER CONTENT ===========================

class _HomeContent extends StatelessWidget {
  final PageController pageCtrl;
  final PageController deckGP;
  final PageController deckPA;
  final int segment;
  final ValueChanged<int> onSegmentChange;
  final VoidCallback onSeeAll;

  const _HomeContent({
    required this.pageCtrl,
    required this.deckGP,
    required this.deckPA,
    required this.segment,
    required this.onSegmentChange,
    required this.onSeeAll,
  });

  // Récupère les catégories depuis la configuration centrale
  List<_DeckItem> _getCategories(UserMode mode, Track track) {
    final modeConfig = categoriesConfig[mode];
    if (modeConfig == null) return [];

    final trackCategories = modeConfig[track];
    if (trackCategories == null) return [];

    return trackCategories.map((category) {
      return _DeckItem(
        label: category.label,
        badge: category.badge,
        image: category.image,
        rating: 4.8, // Valeur par défaut, peut être customisée
        reviews: 100, // Valeur par défaut, peut être customisée
        route: category.route,
        flagKey: _generateFlagKey(category.label),
        subcategories: category.subcategories,
      );
    }).toList();
  }

  String _generateFlagKey(String categoryLabel) {
    // Convertir le label en format snake_case pour le flag
    return categoryLabel
            .toLowerCase()
            .replaceAll(' ', '_')
            .replaceAll('—', '')
            .replaceAll('é', 'e')
            .replaceAll('è', 'e')
            .replaceAll('à', 'a')
            .replaceAll('ù', 'u')
            .replaceAll('\'', '')
            .replaceAll(',', '') +
        '_locked';
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final heroHeight = (h * 0.46).clamp(300.0, 420.0);
    final upcomingRowHeight = 232.0;
    final pageHeight = heroHeight + upcomingRowHeight + 18 + 44;

    return ValueListenableBuilder<UserMode>(
      valueListenable: UserModeController.I.mode,
      builder: (_, mode, __) {
        final gpItems = _getCategories(mode, Track.gpx);
        final paItems = _getCategories(mode, Track.pa);

        return ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            // Header avec icône de mode
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Bonjour 👋',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Bienvenue sur COP\'IQ',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: _muted(context, .8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Icône du mode avec animation
                  _ModeIcon(mode: mode),
                ],
              ),
            ),

            // Search + Settings
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 2),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(_T.r16),
                        boxShadow: [_T.shadow],
                        color: Theme.of(context).cardColor,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          const Icon(Icons.search_rounded, color: _T.g600),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Rechercher',
                              style: TextStyle(
                                color: _muted(context, .75),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  InkWell(
                    borderRadius: BorderRadius.circular(_T.r16),
                    onTap: () =>
                        Navigator.of(context).pushNamed('/parametre_home'),
                    child: Ink(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(_T.r16),
                        boxShadow: [_T.shadow],
                        color: _T.ink,
                      ),
                      child: const Icon(
                        Icons.tune_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // SUPPRIMÉ : Le sélecteur de mode a été retiré comme demandé

            // Bannière "Félicitations" (switch -> school)
            ValueListenableBuilder<bool>(
              valueListenable: UserModeController.I.hasPassedExam,
              builder: (_, passed, __) {
                if (!passed || mode != UserMode.exam) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
                  child: _CongratsBanner(
                    onConfirm: () => UserModeController.I
                        .markPassedAndSwitchToSchool(context),
                  ),
                );
              },
            ),

            const SizedBox(height: 8),

            // Track chips
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: Text(
                (mode == UserMode.exam)
                    ? 'Sélectionne ton parcours'
                    : 'Sélectionne ton contenu',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            _TrackChipsAndPages(
              pageCtrl: pageCtrl,
              deckGP: deckGP,
              deckPA: deckPA,
              pageHeight: pageHeight,
              upcomingRowHeight: upcomingRowHeight,
              gpItems: gpItems,
              paItems: paItems,
              onSeeAll: onSeeAll,
              segment: segment,
              onSegmentChange: onSegmentChange,
            ),
          ],
        );
      },
    );
  }
}

// ========================== ICÔNE DE MODE ANIMÉE ==========================

class _ModeIcon extends StatefulWidget {
  final UserMode mode;

  const _ModeIcon({required this.mode});

  @override
  State<_ModeIcon> createState() => _ModeIconState();
}

class _ModeIconState extends State<_ModeIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: 1.0 + (_controller.value * 0.2), // Animation de scale
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [_T.shadow],
            ),
            child: Icon(
              widget.mode == UserMode.exam
                  ? Icons
                        .menu_book_rounded // Icône cahiers pour concours
                  : Icons.school_rounded, // Icône école pour scolarité
              color: _T.ink,
              size: 24,
            ),
          ),
        );
      },
    );
  }
}

// Séparé pour alléger le build ci-dessus
class _TrackChipsAndPages extends StatelessWidget {
  final PageController pageCtrl, deckGP, deckPA;
  final double pageHeight, upcomingRowHeight;
  final List<_DeckItem> gpItems, paItems;
  final VoidCallback onSeeAll;
  final int segment;
  final ValueChanged<int> onSegmentChange;

  const _TrackChipsAndPages({
    required this.pageCtrl,
    required this.deckGP,
    required this.deckPA,
    required this.pageHeight,
    required this.upcomingRowHeight,
    required this.gpItems,
    required this.paItems,
    required this.onSeeAll,
    required this.segment,
    required this.onSegmentChange,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: _SegmentedChips(
            items: const ['Gardien de la paix', 'Policier adjoint'],
            index: segment,
            onChanged: onSegmentChange,
          ),
        ),
        SizedBox(
          height: pageHeight,
          child: PageView(
            controller: pageCtrl,
            physics: const BouncingScrollPhysics(),
            onPageChanged: onSegmentChange,
            children: [
              _TrackView(
                hero: _HeroDeck(
                  controller: deckGP,
                  height: pageHeight - upcomingRowHeight - 18 - 44,
                  items: gpItems,
                ),
                upcoming: _upcomingFor(
                  UserModeController.I.mode.value,
                  Track.gpx,
                  context,
                ),
                upcomingRowHeight: upcomingRowHeight,
                onSeeAll: onSeeAll,
              ),
              _TrackView(
                hero: _HeroDeck(
                  controller: deckPA,
                  height: pageHeight - upcomingRowHeight - 18 - 44,
                  items: paItems,
                ),
                upcoming: _upcomingFor(
                  UserModeController.I.mode.value,
                  Track.pa,
                  context,
                ),
                upcomingRowHeight: upcomingRowHeight,
                onSeeAll: onSeeAll,
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _upcomingFor(UserMode mode, Track t, BuildContext context) {
    // Utilise les 2 premières catégories comme "À venir"
    final categories = mode == UserMode.exam
        ? (t == Track.gpx ? gpItems : paItems)
        : (t == Track.gpx ? gpItems : paItems);

    final upcomingItems = categories.take(2).toList();

    return upcomingItems.map((item) {
      return _MiniCard(
        title: item.label,
        subtitle: item.badge,
        image: item.image,
        rating: item.rating,
        flagKey: item.flagKey,
        onTap: () => _handleCategoryTap(context, item),
      );
    }).toList();
  }

  void _handleCategoryTap(BuildContext context, _DeckItem item) {
    // Gestion des redirections
    final redirectRoute = redirectConfig[item.route];
    final targetRoute = redirectRoute ?? item.route;

    if (item.subcategories != null && item.subcategories!.isNotEmpty) {
      // Si la catégorie a des sous-catégories, naviguer vers une page de détail
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => _CategoryDetailPage(
            title: item.label,
            subcategories: item.subcategories!,
          ),
        ),
      );
    } else {
      // Sinon, naviguer directement vers la route
      Navigator.of(context).pushNamed(targetRoute);
    }
  }
}

// ========================= PAGE DE DÉTAIL DES CATÉGORIES =========================

class _CategoryDetailPage extends StatelessWidget {
  final String title;
  final List<SubCategoryConfig> subcategories;

  const _CategoryDetailPage({required this.title, required this.subcategories});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: subcategories.length,
        itemBuilder: (context, index) {
          final subcategory = subcategories[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _T.ink.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.article_rounded, color: _T.ink),
              ),
              title: Text(
                subcategory.label,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: _T.g500,
              ),
              onTap: () {
                Navigator.of(context).pushNamed(subcategory.route);
              },
            ),
          );
        },
      ),
    );
  }
}

// ========================= SEGMENTED CHIPS (GPX / PA) =========================

class _SegmentedChips extends StatelessWidget {
  final List<String> items;
  final int index;
  final ValueChanged<int> onChanged;

  const _SegmentedChips({
    required this.items,
    required this.index,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [_T.shadow],
      ),
      child: Row(
        children: List.generate(items.length, (i) {
          final selected = i == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(i),
              child: AnimatedContainer(
                duration: _T.fast,
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 8,
                ),
                decoration: BoxDecoration(
                  color: selected
                      ? (isDark ? Colors.white : _T.ink)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(18),
                ),
                alignment: Alignment.center,
                child: Text(
                  items[i],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: selected
                        ? (isDark ? Colors.black : Colors.white)
                        : _muted(context, .85),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ========================== CONGRATS BANNER ===========================

class _CongratsBanner extends StatelessWidget {
  final VoidCallback onConfirm;
  const _CongratsBanner({required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(.06) : Colors.white,
        borderRadius: BorderRadius.circular(_T.r20),
        boxShadow: [_T.shadow],
        border: Border.all(
          color: isDark ? Colors.white24 : Colors.black.withOpacity(.06),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: const BoxDecoration(
              color: Color(0xFF10B981),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_rounded, color: Colors.white),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Félicitations ! Tu as réussi le concours.\nPasser en "Scolarité" ?',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: onConfirm,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              backgroundColor: isDark ? Colors.white : _T.ink,
              foregroundColor: isDark ? Colors.black : Colors.white,
            ),
            child: const Text('Passer en scolarité'),
          ),
        ],
      ),
    );
  }
}

// =========================== TRACK VIEW / DECK ===========================

class _TrackView extends StatelessWidget {
  final Widget hero;
  final List<Widget> upcoming;
  final double upcomingRowHeight;
  final VoidCallback onSeeAll;
  const _TrackView({
    required this.hero,
    required this.upcoming,
    required this.upcomingRowHeight,
    required this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: hero,
        ),
        const SizedBox(height: 18),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'À venir',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: onSeeAll,
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Text(
                    'Tout voir',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: _muted(context, .7),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: upcomingRowHeight,
          child: ScrollConfiguration(
            behavior: const _DesktopScrollBehavior(),
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: upcoming.length,
              separatorBuilder: (_, __) => const SizedBox(width: 14),
              itemBuilder: (_, i) => upcoming[i],
            ),
          ),
        ),
      ],
    );
  }
}

class _DeckItem {
  final String label, badge, image, route;
  final double rating;
  final int reviews;
  final String? flagKey;
  final List<SubCategoryConfig>? subcategories;

  const _DeckItem({
    required this.label,
    required this.badge,
    required this.image,
    required this.rating,
    required this.reviews,
    required this.route,
    this.flagKey,
    this.subcategories,
  });
}

class _HeroDeck extends StatefulWidget {
  final PageController controller;
  final double height;
  final List<_DeckItem> items;
  const _HeroDeck({
    required this.controller,
    required this.height,
    required this.items,
  });
  @override
  State<_HeroDeck> createState() => _HeroDeckState();
}

class _HeroDeckState extends State<_HeroDeck> {
  double _page = 0;
  late final VoidCallback _listener;

  @override
  void initState() {
    super.initState();
    _page = widget.controller.initialPage.toDouble();
    _listener = () {
      if (!mounted) return;
      setState(() => _page = widget.controller.page ?? 0);
    };
    widget.controller.addListener(_listener);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_listener);
    super.dispose();
  }

  void _next() {
    HapticFeedback.selectionClick();
    final last = widget.items.length - 1;
    final current = widget.controller.page?.round() ?? 0;
    (current >= last)
        ? widget.controller.animateToPage(
            0,
            duration: _T.med,
            curve: Curves.easeInOut,
          )
        : widget.controller.nextPage(duration: _T.med, curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      height: widget.height,
      child: Stack(
        children: [
          const ScrollConfiguration(
            behavior: _DesktopScrollBehavior(),
            child: SizedBox.shrink(),
          ),
          PageView.builder(
            controller: widget.controller,
            physics: const BouncingScrollPhysics(),
            itemCount: widget.items.length,
            onPageChanged: (_) => HapticFeedback.selectionClick(),
            itemBuilder: (context, i) {
              final it = widget.items[i];
              final d = (_page - i).abs().clamp(0.0, 1.0);
              final s = 1 - (0.06 * d);
              final tx = 8 * (i - _page);
              final ty = 10 * d;
              return Transform.translate(
                offset: Offset(tx, ty),
                child: Transform.scale(
                  scale: s,
                  alignment: Alignment.center,
                  child: _HeroCard(item: it, isDark: isDark),
                ),
              );
            },
          ),
          Positioned(
            right: 26,
            bottom: 26,
            child: GestureDetector(
              onTap: _next,
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [_T.shadow],
                ),
                child: Icon(
                  Icons.arrow_forward_rounded,
                  color: isDark ? Colors.white : _T.ink,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroCard extends StatefulWidget {
  final _DeckItem item;
  final bool isDark;
  const _HeroCard({required this.item, required this.isDark});
  @override
  State<_HeroCard> createState() => _HeroCardState();
}

class _HeroCardState extends State<_HeroCard> with TickerProviderStateMixin {
  bool _isFav = false;
  late final AnimationController _popCtrl;
  late final AnimationController _haloCtrl;
  late final Animation<double> _popScale;
  late final Animation<double> _haloScale;
  late final Animation<double> _haloOpacity;
  late final VoidCallback _favListener;

  @override
  void initState() {
    super.initState();
    FavoritesStore.I.isFavorite(widget.item.route).then((v) {
      if (mounted) setState(() => _isFav = v);
    });
    _favListener = () {
      final nowFav = FavoritesStore.I.favorites.value.any(
        (e) => e.route == widget.item.route,
      );
      if (nowFav != _isFav && mounted) setState(() => _isFav = nowFav);
    };
    FavoritesStore.I.favorites.addListener(_favListener);

    _popCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _haloCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );

    _popScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 1.0,
          end: 1.25,
        ).chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 60,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.25,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 40,
      ),
    ]).animate(_popCtrl);

    _haloScale = Tween<double>(
      begin: 0.6,
      end: 1.6,
    ).chain(CurveTween(curve: Curves.easeOutCubic)).animate(_haloCtrl);
    _haloOpacity = Tween<double>(
      begin: .35,
      end: 0,
    ).chain(CurveTween(curve: Curves.easeOut)).animate(_haloCtrl);
  }

  @override
  void dispose() {
    FavoritesStore.I.favorites.removeListener(_favListener);
    _popCtrl.dispose();
    _haloCtrl.dispose();
    super.dispose();
  }

  Future<void> _toggleFavorite() async {
    HapticFeedback.selectionClick();
    setState(() => _isFav = !_isFav);
    if (_isFav) {
      _haloCtrl
        ..reset()
        ..forward();
      _popCtrl
        ..reset()
        ..forward();
    } else {
      _popCtrl
        ..reset()
        ..forward();
    }
    await FavoritesStore.I.toggle(
      FavoriteItem(
        route: widget.item.route,
        title: widget.item.label,
        subtitle: widget.item.badge,
        image: widget.item.image,
        rating: widget.item.rating,
        reviews: widget.item.reviews,
      ),
    );
  }

  void _openOrNotifyLock(bool lockedActive) {
    if (lockedActive) {
      HapticFeedback.selectionClick();
      AppNotifier.subscriptionRequired(context);
      return;
    }

    // Gestion des redirections
    final redirectRoute = redirectConfig[widget.item.route];
    final targetRoute = redirectRoute ?? widget.item.route;

    if (widget.item.subcategories != null &&
        widget.item.subcategories!.isNotEmpty) {
      // Si la catégorie a des sous-catégories, naviguer vers une page de détail
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => _CategoryDetailPage(
            title: widget.item.label,
            subcategories: widget.item.subcategories!,
          ),
        ),
      );
    } else {
      // Sinon, naviguer directement vers la route
      Navigator.of(context).pushNamed(targetRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final isDark = widget.isDark;

    Widget img;
    try {
      img = Image.asset(item.image, fit: BoxFit.cover);
    } catch (_) {
      img = Container(color: _T.g400.withOpacity(.25));
    }

    final overlay = isDark
        ? [Colors.black.withOpacity(.55), Colors.transparent]
        : [Colors.black.withOpacity(.45), Colors.transparent];

    final String listenKey = item.flagKey ?? 'paywall_enabled';

    return ValueListenableBuilder<bool>(
      valueListenable: RemoteFlagsController.I.flag(listenKey),
      builder: (_, moduleOrGlobal, __) {
        final bool lockedActive = moduleOrGlobal;

        return GestureDetector(
          onTap: () => _openOrNotifyLock(lockedActive),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(_T.r24),
              boxShadow: [_T.shadow],
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Positioned.fill(child: img),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.center,
                        colors: overlay,
                      ),
                    ),
                  ),
                ),

                // Cœur animé
                Positioned(
                  top: 12,
                  right: 12,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      AnimatedBuilder(
                        animation: _haloCtrl,
                        builder: (_, __) => Transform.scale(
                          scale: _haloScale.value,
                          child: Opacity(
                            opacity: _haloOpacity.value,
                            child: Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(.25),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Material(
                        color: Theme.of(context).cardColor.withOpacity(.95),
                        shape: const CircleBorder(),
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: _toggleFavorite,
                          child: AnimatedBuilder(
                            animation: _popCtrl,
                            builder: (_, child) => Transform.scale(
                              scale: _popScale.value,
                              child: child,
                            ),
                            child: SizedBox(
                              width: 40,
                              height: 40,
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 180),
                                transitionBuilder: (child, anim) =>
                                    ScaleTransition(
                                      scale: CurvedAnimation(
                                        parent: anim,
                                        curve: Curves.easeOutBack,
                                      ),
                                      child: child,
                                    ),
                                child: Icon(
                                  _isFav
                                      ? Icons.favorite_rounded
                                      : Icons.favorite_border_rounded,
                                  key: ValueKey<bool>(_isFav),
                                  color: _isFav ? Colors.redAccent : null,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Overlay lock
                if (lockedActive)
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(_T.r24),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 2.6, sigmaY: 2.6),
                            child: Container(
                              color: Colors.black.withOpacity(.10),
                            ),
                          ),
                          Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(.55),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.lock_rounded,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Abonnement requis',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Bas de carte
                Positioned(
                  left: 14,
                  right: 14,
                  bottom: 14,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.badge,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: const [
                          Icon(
                            Icons.star_rounded,
                            color: Colors.amber,
                            size: 18,
                          ),
                          SizedBox(width: 4),
                        ],
                      ),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: () => _openOrNotifyLock(lockedActive),
                        child: Container(
                          height: 46,
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            color: _T.ink.withOpacity(.92),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Expanded(
                                child: Center(
                                  child: Text(
                                    'Découvrir',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              CircleAvatar(
                                radius: 14,
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 18,
                                  color: _T.ink,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ============================ MINI CARDS + NAV BAR ============================

class _MiniCard extends StatelessWidget {
  final String title, subtitle, image;
  final double rating;
  final VoidCallback onTap;
  final String? flagKey;

  const _MiniCard({
    required this.title,
    required this.subtitle,
    required this.image,
    required this.rating,
    required this.onTap,
    this.flagKey,
  });

  void _openOrNotifyLock(BuildContext context, bool lockedActive) {
    if (lockedActive) {
      HapticFeedback.selectionClick();
      AppNotifier.subscriptionRequired(context);
      return;
    }
    onTap();
  }

  @override
  Widget build(BuildContext context) {
    Widget img;
    try {
      img = Image.asset(image, fit: BoxFit.cover);
    } catch (_) {
      img = Container(color: _T.g400.withOpacity(.25));
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final listenKey = flagKey ?? 'paywall_enabled';

    return ValueListenableBuilder<bool>(
      valueListenable: RemoteFlagsController.I.flag(listenKey),
      builder: (_, moduleOrGlobal, __) {
        final bool lockedActive = moduleOrGlobal;

        return InkWell(
          onTap: () => _openOrNotifyLock(context, lockedActive),
          borderRadius: BorderRadius.circular(_T.r20),
          child: Container(
            width: 240,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(_T.r20),
              boxShadow: [_T.shadow],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Positioned.fill(child: img),
                        if (lockedActive)
                          Positioned.fill(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  BackdropFilter(
                                    filter: ImageFilter.blur(
                                      sigmaX: 2.6,
                                      sigmaY: 2.6,
                                    ),
                                    child: Container(
                                      color: Colors.black.withOpacity(.10),
                                    ),
                                  ),
                                  Center(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 6,
                                        horizontal: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(.55),
                                        borderRadius: BorderRadius.circular(
                                          999,
                                        ),
                                      ),
                                      child: const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.lock_rounded,
                                            size: 18,
                                            color: Colors.white,
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            'Abonnement requis',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w800,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : _T.ink,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: _muted(context, .7),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: Colors.amber,
                            size: 18,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '$rating',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.color,
                              fontSize: 12,
                            ),
                          ),
                          const Spacer(),
                          Icon(
                            Icons.arrow_forward_rounded,
                            size: 20,
                            color: _muted(context, .8),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SlidingPillNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final double height;
  final List<IconData> icons;

  const _SlidingPillNavBar({
    required this.currentIndex,
    required this.onTap,
    required this.height,
    required this.icons,
  });

  @override
  Widget build(BuildContext context) {
    final pad = MediaQuery.of(context).padding.bottom;
    final h = height;
    final iconSize = (h * 0.42).clamp(18.0, 26.0);
    final dotSize = (h * 0.62).clamp(30.0, 44.0);

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final barColor = isDark ? Colors.white.withOpacity(.08) : _T.ink;

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 8, 16, pad > 0 ? pad : 8),
        child: LayoutBuilder(
          builder: (context, c) {
            final innerPadX = (dotSize / 2) + 10;
            final outerRadius = h / 2;

            final totalW = c.maxWidth;
            final usableW = totalW - (innerPadX * 2);
            final slots = icons.length;
            final slotW = usableW / slots;

            final centerX = innerPadX + slotW * (currentIndex + 0.5);
            final dotLeft = centerX - (dotSize / 2);
            final dotTop = (h - dotSize) / 2;

            return Container(
              height: h,
              decoration: BoxDecoration(
                color: barColor,
                borderRadius: BorderRadius.circular(outerRadius),
                boxShadow: [_T.shadow],
              ),
              child: Stack(
                children: [
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 260),
                    curve: Curves.easeOutCubic,
                    left: dotLeft,
                    top: dotTop,
                    width: dotSize,
                    height: dotSize,
                    child: const DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: innerPadX),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: List.generate(slots, (i) {
                        final selected = i == currentIndex;
                        final activeColor = isDark ? Colors.black : _T.ink;
                        return Expanded(
                          child: Center(
                            child: InkResponse(
                              onTap: () => onTap(i),
                              radius: dotSize,
                              highlightShape: BoxShape.circle,
                              child: Icon(
                                icons[i],
                                size: iconSize,
                                color: selected ? activeColor : Colors.white,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// =============================== STUB =================================

class _StubPage extends StatelessWidget {
  final String title;
  const _StubPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
      ),
    );
  }
}
