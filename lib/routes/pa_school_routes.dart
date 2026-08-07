// GENERATED FILE - DO NOT EDIT BY HAND.
// Generated from the routeName constants of lib/content/pa_scolarite.
// The primary RouteRegistry keeps priority for routes with custom logic.

part of 'package:copiqpolice/main.dart';

class PaSchoolRouteRegistry {
  PaSchoolRouteRegistry._();

  static final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
    "/pa/armes_munitions_pages/quiz/pa_quiz_armes_munitions_pages": (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizArmesMunitionsPA(
        uid: user?.id ?? '',
        email: user?.email ?? '',
      );
    },
    "/pa/complicite/quiz/complicite": (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizComplicitePagePA(
        uid: user?.id ?? '',
        email: user?.email ?? '',
      );
    },
    "/pa/crime_delit_nation_pages/quiz/pa_quiz_crimes_delits_bien": (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizCrimesDelitsBiensPA(
        uid: user?.id ?? '',
        email: user?.email ?? '',
      );
    },
    "/pa/crime_delit_nation_pages/quiz/pa_quiz_crimes_delits_nation": (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizCrimesDelitsNationPA(
        uid: user?.id ?? '',
        email: user?.email ?? '',
      );
    },
    "/pa/crimes_biens/quiz/destructions_degradations": (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizDDDPA(uid: user?.id ?? '', email: user?.email ?? '');
    },
    "/pa/crimes_biens/quiz/recel_non_justification": (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizRecelNonJustificationPA(
        uid: user?.id ?? '',
        email: user?.email ?? '',
      );
    },
    "/pa/crimes_biens/quiz/stad": (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizStadPA(uid: user?.id ?? '', email: user?.email ?? '');
    },
    "/pa/crimes_biens/quiz/voisines_du_vol": (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizVoisinesDuVolPA(uid: user?.id ?? '', email: user?.email ?? '');
    },
    "/pa/crimes_personne/quiz/atteinte_personnalite": (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizAtteintePersonnalitePA(
        uid: user?.id ?? '',
        email: user?.email ?? '',
      );
    },
    "/pa/crimes_personne/quiz/atteintes_involontaires": (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizAtteinteInvolontairePA(
        uid: user?.id ?? '',
        email: user?.email ?? '',
      );
    },
    "/pa/crimes_personne/quiz/atteintes_volontaires_integrite": (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizAtteinteIntegritePA(
        uid: user?.id ?? '',
        email: user?.email ?? '',
      );
    },
    "/pa/crimes_personne/quiz/atteintes_volontaires_vie": (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizAtteinteVolontairePA(
        uid: user?.id ?? '',
        email: user?.email ?? '',
      );
    },
    "/pa/crimes_personne/quiz/crimes_delits_personne": (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizCrimeDelitsPersonnePA(
        uid: user?.id ?? '',
        email: user?.email ?? '',
      );
    },
    "/pa/crimes_personne/quiz/dignite_personne": (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizDiginitePersonnePA(
        uid: user?.id ?? '',
        email: user?.email ?? '',
      );
    },
    "/pa/crimes_personne/quiz/enregistrement_diffusion_images": (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizEnregistrementDiffusionImagesPA(
        uid: user?.id ?? '',
        email: user?.email ?? '',
      );
    },
    "/pa/crimes_personne/quiz/mise_en_danger": (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizMiseEnDangerPA(uid: user?.id ?? '', email: user?.email ?? '');
    },
    "/pa/crimes_personne/quiz/viol_inceste_agressions": (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizViolIncestePA(uid: user?.id ?? '', email: user?.email ?? '');
    },
    "/pa/dps_dpg/armes_munitions_pages/armes_acquisition_detention_ab": (_) =>
        PaArmesAcquisitionDetentionABPage(),
    "/pa/dps_dpg/armes_munitions_pages/armes_classification": (_) =>
        PaArmesClassificationPage(),
    "/pa/dps_dpg/armes_munitions_pages/armes_definitions": (_) =>
        PaArmesDefinitionsPage(),
    "/pa/dps_dpg/armes_munitions_pages/armes_introduction": (_) =>
        PaArmesIntroductionPage(),
    "/pa/dps_dpg/armes_munitions_pages/armes_materiels_guerre_elements": (_) =>
        PaArmesMaterielsGuerreElementsPage(),
    "/pa/dps_dpg/armes_munitions_pages/armes_port_transport_cd": (_) =>
        PaArmesPortTransportCDPage(),
    "/pa/dps_dpg/armes_munitions_pages/armes_regles_acquisition_detention":
        (_) => PaArmesReglesAcquisitionDetentionPage(),
    "/pa/dps_dpg/armes_munitions_pages/armes_regles_port_transport": (_) =>
        PaArmesReglesPortTransportPage(),
    "/pa/dps_dpg/atteintes_biens/contrefacons_falsifications": (_) =>
        PaContrefaconsFalsificationsChequesPage(),
    "/pa/dps_dpg/atteintes_biens/destructions_degradations": (_) =>
        PaDestructionsDegradationsContenuPage(),
    "/pa/dps_dpg/atteintes_biens/destructions_degradations/biens_culturels_publics_classes":
        (_) => PaBiensCulturelsPublicsClassesPage(),
    "/pa/dps_dpg/atteintes_biens/destructions_degradations/dangereuses_personnes_intentionnelle":
        (_) => PaDestructionsDangereusesPersonnesIntentionnellePage(),
    "/pa/dps_dpg/atteintes_biens/destructions_degradations/dangereuses_personnes_non_intentionnelle":
        (_) => PaDestructionsDangereusesPersonnesNonIntentionnellePage(),
    "/pa/dps_dpg/atteintes_biens/destructions_degradations/detention_transport_sans_motif_legitime":
        (_) => PaDetentionTransportSansMotifLegitimePage(),
    "/pa/dps_dpg/atteintes_biens/destructions_degradations/detention_transport_substances_preparation":
        (_) => PaDetentionTransportSubstancesPreparationPage(),
    "/pa/dps_dpg/atteintes_biens/destructions_degradations/diffusion_procedes_fabrication_engins":
        (_) => PaDiffusionProcedesFabricationEnginsDestructionPage(),
    "/pa/dps_dpg/atteintes_biens/destructions_degradations/fausses_alertes":
        (_) => PaFaussesAlertesPage(),
    "/pa/dps_dpg/atteintes_biens/destructions_degradations/menaces_avec_condition":
        (_) => PaMenacesAvecConditionPageGPXSchool(),
    "/pa/dps_dpg/atteintes_biens/destructions_degradations/menaces_sans_condition":
        (_) => PaMenacesSansConditionPage(),
    "/pa/dps_dpg/atteintes_biens/destructions_degradations/sans_danger_dommage_important":
        (_) => PaSansDangerDommageImportantPage(),
    "/pa/dps_dpg/atteintes_biens/destructions_degradations/sans_danger_dommage_leger":
        (_) => PaSansDangerDommageLegerPage(),
    "/pa/dps_dpg/atteintes_biens/destructions_degradations/tags_inscriptions_signes_dessins":
        (_) => PaTagsInscriptionsSignesDessinsPage(),
    "/pa/dps_dpg/atteintes_biens/recel_non_justification": (_) =>
        PaRecelNonJustificationContenuPage(),
    "/pa/dps_dpg/atteintes_biens/recel_non_justification/non_justification_ressources":
        (_) => PaNonJustificationRessources(),
    "/pa/dps_dpg/atteintes_biens/recel_non_justification/recel": (_) =>
        PaRecelPage(),
    "/pa/dps_dpg/atteintes_biens/stad": (_) => PaStadContenuPage(),
    "/pa/dps_dpg/atteintes_biens/stad/acces_maintien_frauduleux": (_) =>
        PaAccesMaintienFrauduleuxStadPage(),
    "/pa/dps_dpg/atteintes_biens/stad/association_malfaiteurs_informatique":
        (_) => PaAssociationMalfaiteursInformatiquePage(),
    "/pa/dps_dpg/atteintes_biens/stad/donnees_adaptees_commettre_infractions":
        (_) => PaDonneesAdapteesCommettreInfractionsPage(),
    "/pa/dps_dpg/atteintes_biens/stad/introduction_suppression_modification_donnees":
        (_) => PaIntroductionSuppressionModificationDonneesPage(),
    "/pa/dps_dpg/atteintes_biens/voisines_du_vol": (_) =>
        PaVoisinesDuVolContenuPage(),
    "/pa/dps_dpg/atteintes_biens/voisines_du_vol/abus_de_confiance": (_) =>
        PaAbusDeConfiancePage(),
    "/pa/dps_dpg/atteintes_biens/voisines_du_vol/chantage": (_) =>
        PaChantagePage(),
    "/pa/dps_dpg/atteintes_biens/voisines_du_vol/demande_fonds_sous_contrainte":
        (_) => PaDemandeFondsSousContraintePage(),
    "/pa/dps_dpg/atteintes_biens/voisines_du_vol/escroquerie": (_) =>
        PaEscroqueriePage(),
    "/pa/dps_dpg/atteintes_biens/voisines_du_vol/extorsion": (_) =>
        PaExtorsionPage(),
    "/pa/dps_dpg/atteintes_biens/voisines_du_vol/filouteries": (_) =>
        PaFilouteriesPage(),
    "/pa/dps_dpg/atteintes_biens/vol": (_) => PaVolPage(),
    "/pa/dps_dpg/atteintes_nation_pages/abus_autorite": (_) =>
        PaAbusAutoriteParticuliersContenuPage(),
    "/pa/dps_dpg/atteintes_nation_pages/abus_autorite_particuliers/atteintes_inviolabilite_domicile":
        (_) => PaAtteintesInviolabiliteDomicilePage(),
    "/pa/dps_dpg/atteintes_nation_pages/abus_autorite_particuliers/atteintes_secret_correspondances":
        (_) => PaAtteintesSecretCorrespondancesPage(),
    "/pa/dps_dpg/atteintes_nation_pages/abus_autorite_particuliers/discriminations":
        (_) => PaDiscriminationsAbusAutoritePage(),
    "/pa/dps_dpg/atteintes_nation_pages/association_malfaiteurs": (_) =>
        PaAssociationMalfaiteursPage(),
    "/pa/dps_dpg/atteintes_nation_pages/atteintes_action_justice": (_) =>
        PaAtteintesActionJusticeContenuPage(),
    "/pa/dps_dpg/atteintes_nation_pages/atteintes_action_justice/non_denonciation_crime":
        (_) => PaNonDenonciationCrimePage(),
    "/pa/dps_dpg/atteintes_nation_pages/atteintes_action_justice/temoignage_mensonger":
        (_) => PaTemoignageMensongerContenuPage(),
    "/pa/dps_dpg/atteintes_nation_pages/atteintes_administration": (_) =>
        PaAtteintesAdministrationContenuPage(),
    "/pa/dps_dpg/atteintes_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite":
        (_) => PaMenacesEnversDepositaireAutoritePage(),
    "/pa/dps_dpg/atteintes_nation_pages/atteintes_administration/menaces_violences_intimidation_derogation_service_public":
        (_) => PaMenacesViolencesIntimidationDerogationServicePublicPage(),
    "/pa/dps_dpg/atteintes_nation_pages/atteintes_administration/provocation_directe_rebellion":
        (_) => PaProvocationDirecteRebellionPage(),
    "/pa/dps_dpg/atteintes_nation_pages/atteintes_administration/rebellion":
        (_) => PaRebellionPage(),
    "/pa/dps_dpg/atteintes_nation_pages/faux_usage_faux": (_) =>
        PaFauxUsageFauxContenuPage(),
    "/pa/dps_dpg/atteintes_nation_pages/faux_usage_faux/delivrance_indue_document_administratif":
        (_) => PaDelivranceIndueDocumentAdministratifPage(),
    "/pa/dps_dpg/atteintes_nation_pages/faux_usage_faux/faux_certificats_ou_attestations":
        (_) => PaFauxCertificatsOuAttestationsPage(),
    "/pa/dps_dpg/atteintes_nation_pages/faux_usage_faux/faux_document_administratif":
        (_) => PaFauxDocumentAdministratifPage(),
    "/pa/dps_dpg/atteintes_nation_pages/faux_usage_faux/faux_ecriture_publique_ou_authentique":
        (_) => PaFauxEcriturePubliqueOuAuthentiquePage(),
    "/pa/dps_dpg/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux":
        (_) => PaFauxEtUsageDeFauxPage(),
    "/pa/dps_dpg/atteintes_nation_pages/faux_usage_faux/obtention_indue_document_administratif":
        (_) => PaObtentionIndueDocumentAdministratifPage(),
    "/pa/dps_dpg/atteintes_nation_pages/probite": (_) => PaProbiteContenuPage(),
    "/pa/dps_dpg/atteintes_nation_pages/probite/concussion": (_) =>
        PaConcussionPage(),
    "/pa/dps_dpg/atteintes_nation_pages/probite/corruption": (_) =>
        PaCorruptionPage(),
    "/pa/dps_dpg/atteintes_nation_pages/probite/trafic_influence": (_) =>
        PaTraficInfluencePage(),
    "/pa/dps_dpg/atteintes_personnes": (_) => PAAtteintesPersonnesPage(),
    "/pa/dps_dpg/atteintes_personnes/atteinte_personnalite/atteinte_intimite_personne":
        (_) => PaAtteinteIntimitePersonnePage(),
    "/pa/dps_dpg/atteintes_personnes/atteinte_personnalite/atteinte_intimite_vie_privee":
        (_) => PaAtteinteIntimiteViePriveePage(),
    "/pa/dps_dpg/atteintes_personnes/atteinte_personnalite/atteinte_representation_personne":
        (_) => PaAtteinteRepresentationPersonnePage(),
    "/pa/dps_dpg/atteintes_personnes/atteinte_personnalite/atteinte_secret_correspondances_particulier":
        (_) => PaAtteinteSecretCorrespondancesParticulierPage(),
    "/pa/dps_dpg/atteintes_personnes/atteinte_personnalite/atteinte_secret_professionnel":
        (_) => PaAtteinteSecretProfessionnelPage(),
    "/pa/dps_dpg/atteintes_personnes/atteinte_personnalite/denonciation_calomnieuse":
        (_) => PaDenonciationCalomnieusePage(),
    "/pa/dps_dpg/atteintes_personnes/atteinte_personnalite/diffusion_enregistrement_document_caractere_sexuel_sans_accord":
        (_) => PaDiffusionEnregistrementCaractereSexuelSansAccordPage(),
    "/pa/dps_dpg/atteintes_personnes/atteinte_personnalite/violation_correspondances_voie_electronique":
        (_) => PaViolationCorrespondancesVoieElectroniquePage(),
    "/pa/dps_dpg/atteintes_personnes/atteinte_personnalite/violation_domicile_particulier":
        (_) => PaViolationDomicileParticulierPage(),
    "/pa/dps_dpg/atteintes_personnes/atteintes_involontaires": (_) =>
        PaAtteintesInvolontairesContenuPage(),
    "/pa/dps_dpg/atteintes_personnes/atteintes_involontaires/atteintes_involontaires_conducteur_vtm":
        (_) => PaAtteintesInvolontairesConducteurVtmPage(),
    "/pa/dps_dpg/atteintes_personnes/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois":
        (_) => PaAtteintesInvolontairesIttInferieure3MoisPage(),
    "/pa/dps_dpg/atteintes_personnes/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois":
        (_) => PaAtteintesInvolontairesIttSuperieure3MoisPage(),
    "/pa/dps_dpg/atteintes_personnes/atteintes_involontaires/atteintes_involontaires_violation_manifestement_deliberee_obligation":
        (_) =>
            PaAtteintesInvolontairesViolationManifestementDelibereeObligationPage(),
    "/pa/dps_dpg/atteintes_personnes/atteintes_involontaires/atteintes_volontaires_qualifiees_violences":
        (_) => PaAtteintesVolontairesQualifieesViolencesPage(),
    "/pa/dps_dpg/atteintes_personnes/atteintes_involontaires/homicide_involontaire":
        (_) => PaHomicideInvolontairePage(),
    "/pa/dps_dpg/atteintes_personnes/atteintes_involontaires/participation_groupement_violent":
        (_) => PaParticipationGroupementViolentPage(),
    "/pa/dps_dpg/atteintes_personnes/atteintes_involontaires/violences_volontaires_arme_personne_depositaire_transport_pompier":
        (_) =>
            PaViolencesVolontairesArmePersonneDepositaireTransportPompierPage(),
    "/pa/dps_dpg/atteintes_personnes/atteintes_volontaires_integrite": (_) =>
        PaAtteintesVolontairesIntegriteContenuPage(),
    "/pa/dps_dpg/atteintes_personnes/atteintes_volontaires_integrite/appels_messages_malveillants_agressions_sonores":
        (_) => PaAppelsMessagesMalveillantsAgressionsSonoresPage(),
    "/pa/dps_dpg/atteintes_personnes/atteintes_volontaires_integrite/embuscade":
        (_) => PaEmbuscadePage(),
    "/pa/dps_dpg/atteintes_personnes/atteintes_volontaires_integrite/menace_sans_condition":
        (_) => PaMenaceSansConditionPage(),
    "/pa/dps_dpg/atteintes_personnes/atteintes_volontaires_integrite/menaces_avec_condition":
        (_) => PaMenacesAvecConditionPage(),
    "/pa/dps_dpg/atteintes_personnes/atteintes_volontaires_integrite/outrage_sexiste":
        (_) => PaOutrageSexistePage(),
    "/pa/dps_dpg/atteintes_personnes/atteintes_volontaires_integrite/tortures_actes_barbarie":
        (_) => PaTorturesActesBarbariePage(),
    "/pa/dps_dpg/atteintes_personnes/atteintes_volontaires_integrite/violences_habituelles_couple_ex":
        (_) => PaViolencesHabituellesCoupleExPage(),
    "/pa/dps_dpg/atteintes_personnes/atteintes_volontaires_integrite/violences_habituelles_mineur_vulnerable":
        (_) => PaViolencesHabituellesMineurVulnerablePage(),
    "/pa/dps_dpg/atteintes_personnes/atteintes_volontaires_integrite/violences_sur_fsi":
        (_) => PaViolencesSurFsiPage(),
    "/pa/dps_dpg/atteintes_personnes/atteintes_volontaires_vie": (_) =>
        PaAtteintesVolontairesVieContenuPage(),
    "/pa/dps_dpg/atteintes_personnes/atteintes_volontaires_vie/empoisonnement":
        (_) => PaEmpoisonnementPage(),
    "/pa/dps_dpg/atteintes_personnes/atteintes_volontaires_vie/meurtre": (_) =>
        PaMeurtrePage(),
    "/pa/dps_dpg/atteintes_personnes/dignite_personne": (_) =>
        PaDignitePersonneContenuPage(),
    "/pa/dps_dpg/atteintes_personnes/dignite_personne/atteinte_integrite_cadavre":
        (_) => PaAtteinteIntegriteCadavrePage(),
    "/pa/dps_dpg/atteintes_personnes/dignite_personne/discriminations": (_) =>
        PaDiscriminationsPage(),
    "/pa/dps_dpg/atteintes_personnes/dignite_personne/dissimulation_forcee_visage":
        (_) => PaDissimulationForceeVisagePage(),
    "/pa/dps_dpg/atteintes_personnes/dignite_personne/proxenetisme": (_) =>
        PaProxenetismePage(),
    "/pa/dps_dpg/atteintes_personnes/dignite_personne/proxenetisme_assimilation":
        (_) => PaProxenetismeAssimilationPage(),
    "/pa/dps_dpg/atteintes_personnes/dignite_personne/proxenetisme_hotelier":
        (_) => PaProxenetismeHotelierPage(),
    "/pa/dps_dpg/atteintes_personnes/dignite_personne/recours_prostitution_mineurs_personnes_vulnerables":
        (_) => PaRecoursProstitutionMineursPersonnesVulnerablesPage(),
    "/pa/dps_dpg/atteintes_personnes/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante":
        (_) =>
            PaRetributionInexistanteInsuffisantePersonneVulnerableDependantePage(),
    "/pa/dps_dpg/atteintes_personnes/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite":
        (_) =>
            PaSoumissionConditionsTravailHebergementIncompatiblesDignitePage(),
    "/pa/dps_dpg/atteintes_personnes/dignite_personne/traite_etres_humains":
        (_) => PaTraiteEtresHumainsPage(),
    "/pa/dps_dpg/atteintes_personnes/dignite_personne/violation_profanation_tombeaux_sepultures_urnes_monuments":
        (_) => PaViolationProfanationTombeauxSepulturesUrnesMonumentsPage(),
    "/pa/dps_dpg/atteintes_personnes/enlevement_sequestration": (_) =>
        PaEnlevementSequestrationPage(),
    "/pa/dps_dpg/atteintes_personnes/enregistrement_diffusion_images": (_) =>
        PaEnregistrementDiffusionImagesContenuPage(),
    "/pa/dps_dpg/atteintes_personnes/enregistrement_diffusion_images/diffusion":
        (_) => PaDiffusionImagesViolenceContenuPage(),
    "/pa/dps_dpg/atteintes_personnes/enregistrement_diffusion_images/enregistrement":
        (_) => PaEnregistrementImagesViolencePage(),
    "/pa/dps_dpg/atteintes_personnes/mise_en_danger": (_) =>
        PaMiseEnDangerContenuPage(),
    "/pa/dps_dpg/atteintes_personnes/mise_en_danger/abus_frauduleux_ignorance_faiblesse":
        (_) => PaAbusFrauduleuxIgnoranceFaiblessePage(),
    "/pa/dps_dpg/atteintes_personnes/mise_en_danger/delaissement_personne_hors_etat":
        (_) => PaDelaissementPersonneHorsEtatPage(),
    "/pa/dps_dpg/atteintes_personnes/mise_en_danger/mise_en_danger_diffusion_informations":
        (_) => PaMiseEnDangerDiffusionInformationsPage(),
    "/pa/dps_dpg/atteintes_personnes/mise_en_danger/non_assistance_personne_peril":
        (_) => PaNonAssistancePersonnePerilPage(),
    "/pa/dps_dpg/atteintes_personnes/mise_en_danger/non_obstacle_commission_crime_delit":
        (_) => PaNonObstacleCommissionCrimeDelitPage(),
    "/pa/dps_dpg/atteintes_personnes/mise_en_danger/risque_cause_autrui": (_) =>
        PaRisqueCauseAutruiPage(),
    "/pa/dps_dpg/atteintes_personnes/personnalite": (_) =>
        PaAtteintePersonnaliteContenuPage(),
    "/pa/dps_dpg/atteintes_personnes/viol_inceste_agressions": (_) =>
        PaViolIncesteAgressionsContenuPage(),
    "/pa/dps_dpg/atteintes_personnes/viol_inceste_agressions/administration_substances_nuisibles":
        (_) => PaAdministrationSubstancesNuisiblesPage(),
    "/pa/dps_dpg/atteintes_personnes/viol_inceste_agressions/agression_majeur_mineur_15":
        (_) => PaAgressionMajeurMineur15Page(),
    "/pa/dps_dpg/atteintes_personnes/viol_inceste_agressions/agression_sexuelle_incestueuse":
        (_) => PaAgressionSexuelleIncestueusePage(),
    "/pa/dps_dpg/atteintes_personnes/viol_inceste_agressions/agressions_sexuelles_autres_que_viol":
        (_) => PaAgressionsSexuellesAutresQueViolPage(),
    "/pa/dps_dpg/atteintes_personnes/viol_inceste_agressions/avertissement":
        (_) => PaViolIncesteAgressionsAvertissementPage(),
    "/pa/dps_dpg/atteintes_personnes/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers":
        (_) => PaContrainteAtteinteSexuelleTiersPage(),
    "/pa/dps_dpg/atteintes_personnes/viol_inceste_agressions/exhibition_sexuelle":
        (_) => PaExhibitionSexuellePage(),
    "/pa/dps_dpg/atteintes_personnes/viol_inceste_agressions/harcelement_sexuel":
        (_) => PaHarcelementSexuelPage(),
    "/pa/dps_dpg/atteintes_personnes/viol_inceste_agressions/mineur_15_violences_contrainte_menace_surprise":
        (_) => PaMineur15ViolencesContrainteMenaceSurprisePage(),
    "/pa/dps_dpg/atteintes_personnes/viol_inceste_agressions/personne_vulnerable":
        (_) => PaPersonneVulnerablePage(),
    "/pa/dps_dpg/atteintes_personnes/viol_inceste_agressions/substance_pour_viol_ou_agression":
        (_) => PaSubstancePourViolOuAgressionPage(),
    "/pa/dps_dpg/atteintes_personnes/viol_inceste_agressions/viol": (_) =>
        PaViolPage(),
    "/pa/dps_dpg/atteintes_personnes/viol_inceste_agressions/viol_incestueux":
        (_) => PaViolIncestueuxPage(),
    "/pa/dps_dpg/atteintes_personnes/viol_inceste_agressions/viol_majeur_mineur_15":
        (_) => PaViolMajeurMineur15Page(),
    "/pa/dps_dpg/cadres_juridiques/autres_cadres_enquete": (_) =>
        PaAutresCadresEnquetePage(),
    "/pa/dps_dpg/cadres_juridiques/cadres_enquete": (_) =>
        PaCadresEnquetePage(),
    "/pa/dps_dpg/cadres_juridiques/cadres_enquete/contenu": (_) =>
        PaCadresEnqueteContenuPage(),
    "/pa/dps_dpg/cadres_juridiques/cadres_enquete_intro": (_) =>
        PaCadresEnqueteIntroPage(),
    "/pa/dps_dpg/cadres_juridiques/commission_rogatoire/chapitre1": (_) =>
        PaCommissionRogatoireChapitre1Page(),
    "/pa/dps_dpg/cadres_juridiques/commission_rogatoire/chapitre2": (_) =>
        PaCommissionRogatoireChapitre2Page(),
    "/pa/dps_dpg/cadres_juridiques/commission_rogatoire/chapitre3": (_) =>
        PaCommissionRogatoireChapitre3Page(),
    "/pa/dps_dpg/cadres_juridiques/commission_rogatoire/garde_a_vue": (_) =>
        PaGardeAVuePage(),
    "/pa/dps_dpg/cadres_juridiques/commission_rogatoire/mandat_recherche":
        (_) => PaMandatRecherchePage(),
    "/pa/dps_dpg/cadres_juridiques/commission_rogatoire/perquisitions_fouilles":
        (_) => PaPerquisitionsFouillesPage(),
    "/pa/dps_dpg/cadres_juridiques/commission_rogatoire/requisitions": (_) =>
        PaRequisitionsPage(),
    "/pa/dps_dpg/cadres_juridiques/commission_rogatoire/saisies_scelles": (_) =>
        PaSaisiesScellesPage(),
    "/pa/dps_dpg/cadres_juridiques/commission_rogatoire/violation_cj": (_) =>
        PaViolationControleJudiciairePage(),
    "/pa/dps_dpg/cadres_juridiques/commission_rogatoire_contenu": (_) =>
        PaCommissionRogatoireContenuPage(),
    "/pa/dps_dpg/cadres_juridiques/commission_rogatoire_intro": (_) =>
        PaCommissionRogatoireIntroPage(),
    "/pa/dps_dpg/cadres_juridiques/controle_identite": (_) =>
        PaControleIdentiteContenuPage(),
    "/pa/dps_dpg/cadres_juridiques/controle_identite/chapitre1": (_) =>
        PaControleIdentiteChap1ContenuPage(),
    "/pa/dps_dpg/cadres_juridiques/controle_identite/chapitre1/cadre_general":
        (_) => PaConntroleIdentiteCadreGpxSchool(),
    "/pa/dps_dpg/cadres_juridiques/controle_identite/chapitre1/controles_preventifs":
        (_) => PaConntroleIdentitePreventionGpxSchool(),
    "/pa/dps_dpg/cadres_juridiques/controle_identite/chapitre1/distinction_identite_reglementation":
        (_) => PaConntroleIdentiteReglementationGpxSchool(),
    "/pa/dps_dpg/cadres_juridiques/controle_identite/chapitre1/introduction":
        (_) => PaConntroleIdentiteIntroductionGpxSchool(),
    "/pa/dps_dpg/cadres_juridiques/controle_identite/chapitre1/locaux_professionnels":
        (_) => PaConntroleIdentiteLocauxGpxSchool(),
    "/pa/dps_dpg/cadres_juridiques/controle_identite/chapitre1/moyens_preuve_identite":
        (_) => PaConntroleIdentiteDocumentGpxSchool(),
    "/pa/dps_dpg/cadres_juridiques/controle_identite/chapitre1/sejour_etrangers":
        (_) => PaConntroleIdentiteSejourGpxSchool(),
    "/pa/dps_dpg/cadres_juridiques/controle_identite/chapitre1/visites_vehicules_bagages_navires":
        (_) => PaConntroleIdentiteVisiteGpxSchool(),
    "/pa/dps_dpg/cadres_juridiques/controle_identite/chapitre1/zone_frontiere":
        (_) => PaConntroleIdentiteFrontiereGpxSchool(),
    "/pa/dps_dpg/cadres_juridiques/controle_identite/chapitre2": (_) =>
        PaReleveIdentiteGpxSchool(),
    "/pa/dps_dpg/cadres_juridiques/controle_identite/chapitre3": (_) =>
        PaControleIdentiteChap3ContenuPage(),
    "/pa/dps_dpg/cadres_juridiques/controle_identite/chapitre3/introduction":
        (_) => PaVerificationIdentiteIntroductionGpxSchool(),
    "/pa/dps_dpg/cadres_juridiques/controle_identite/chapitre3/obligations_legales_procedure":
        (_) => PaVerificationIdentiteProcedureGpxSchool(),
    "/pa/dps_dpg/cadres_juridiques/controle_identite/chapitre3/pv_verification_identite":
        (_) => PaVerificationIdentiteProcesVerbalGpxSchool(),
    "/pa/dps_dpg/cadres_juridiques/controle_identite/chapitre3/recherche_identite":
        (_) => PaVerificationIdentiteRechercheGpxSchool(),
    "/pa/dps_dpg/cadres_juridiques/controle_identite/chapitre3/retention":
        (_) => PaVerificationIdentiteRetentionGpxSchool(),
    "/pa/dps_dpg/cadres_juridiques/controle_identite/intro": (_) =>
        PaConntroleIdentiteIntroGpxSchool(),
    "/pa/dps_dpg/cadres_juridiques/controle_identite_intro": (_) =>
        PaControleIdentiteIntroPage(),
    "/pa/dps_dpg/cadres_juridiques/criminalite_deliquance_intro": (_) =>
        PaCriminaliteDeliquanceIntroPage(),
    "/pa/dps_dpg/cadres_juridiques/criminalite_organisee/commission_rogatoire":
        (_) => PaCommissionRogatoireGpxSchool(),
    "/pa/dps_dpg/cadres_juridiques/criminalite_organisee/enquete_preliminaire":
        (_) => PaEnquetePreliminaireGpxSchool(),
    "/pa/dps_dpg/cadres_juridiques/criminalite_organisee/financement": (_) =>
        PaLutteFinancementGpxSchool(),
    "/pa/dps_dpg/cadres_juridiques/criminalite_organisee/garde_a_vue": (_) =>
        PaGardeAVuePageGpxSchool(),
    "/pa/dps_dpg/cadres_juridiques/criminalite_organisee/infractions": (_) =>
        PaInfractionCriminaliteOrganiseePage(),
    "/pa/dps_dpg/cadres_juridiques/criminalite_organisee/interceptions": (_) =>
        PaInterceptionsGpxSchool(),
    "/pa/dps_dpg/cadres_juridiques/criminalite_organisee/perquisitions": (_) =>
        PaPerquisitionGpxSchool(),
    "/pa/dps_dpg/cadres_juridiques/criminalite_organisee/regles_derogatoires":
        (_) => PaReglesDerogatoiresCriminaliteOrganiseePage(),
    "/pa/dps_dpg/cadres_juridiques/criminalite_organisee/techniques_speciales":
        (_) => PaAutresTechniquesGpxSchool(),
    "/pa/dps_dpg/cadres_juridiques/criminalite_organisee_contenu": (_) =>
        PaCriminaliteOrganiseeContenuPage(),
    "/pa/dps_dpg/cadres_juridiques/disparitions_inquietantes": (_) =>
        PaDisparitionContenuPage(),
    "/pa/dps_dpg/cadres_juridiques/disparitions_inquietantes/chapitre1": (_) =>
        PaDisparitionInquietanteConditionsGpxSchool(),
    "/pa/dps_dpg/cadres_juridiques/disparitions_inquietantes/chapitre2": (_) =>
        PaDisparitionInquietanteProcedureGpxSchool(),
    "/pa/dps_dpg/cadres_juridiques/disparitions_inquietantes/chapitre3": (_) =>
        PaDisparitionInquietanteEnqueteGpxSchool(),
    "/pa/dps_dpg/cadres_juridiques/disparitions_inquietantes/intro": (_) =>
        PaDisparitionInquietanteIntroGpxSchool(),
    "/pa/dps_dpg/cadres_juridiques/disparitions_inquietantes_intro": (_) =>
        PaDisparitionIntroPage(),
    "/pa/dps_dpg/cadres_juridiques/enquete_flagrant_delit": (_) =>
        PaFlagrantDelitContenuPage(),
    "/pa/dps_dpg/cadres_juridiques/enquete_flagrant_delit/chapitre1": (_) =>
        PaFlagrantDelitNotionPage(),
    "/pa/dps_dpg/cadres_juridiques/enquete_flagrant_delit/chapitre2": (_) =>
        PaFlagrantDelitDomainePage(),
    "/pa/dps_dpg/cadres_juridiques/enquete_flagrant_delit/chapitre3": (_) =>
        PaFlagrantDelitProcedurePage(),
    "/pa/dps_dpg/cadres_juridiques/enquete_flagrant_delit/intro": (_) =>
        PaFlagrantDelitPanoramaPage(),
    "/pa/dps_dpg/cadres_juridiques/enquete_preliminaire": (_) =>
        PaEnquetePreliminairePage(),
    "/pa/dps_dpg/cadres_juridiques/enquete_preliminaire/actes/auditions": (_) =>
        PaAuditionEnquetePreliminaireGpxSchool(),
    "/pa/dps_dpg/cadres_juridiques/enquete_preliminaire/actes/constatations_requisitions":
        (_) => PaEnquetePreliminaireConstatationsRequisitionsPage(),
    "/pa/dps_dpg/cadres_juridiques/enquete_preliminaire/actes/fouilles": (_) =>
        PaEnquetePreliminaireFouillesPage(),
    "/pa/dps_dpg/cadres_juridiques/enquete_preliminaire/actes/garde_a_vue":
        (_) => PaEnquetePrelimGardeAVuePage(),
    "/pa/dps_dpg/cadres_juridiques/enquete_preliminaire/actes/saisie_comptes_bancaires":
        (_) => PaEnquetePrelimSaisieComptesBancairesPage(),
    "/pa/dps_dpg/cadres_juridiques/enquete_preliminaire/chapitre1_domaine":
        (_) => PaEnquetePreliminaireChapitre1DomainePage(),
    "/pa/dps_dpg/cadres_juridiques/enquete_preliminaire/chapitre2_procedure":
        (_) => PaEnquetePreliminaireChapitre2ProcedurePage(),
    "/pa/dps_dpg/cadres_juridiques/enquete_preliminaire/contenu": (_) =>
        PaEnquetePreliminaireContenuPage(),
    "/pa/dps_dpg/cadres_juridiques/enquete_preliminaire_intro": (_) =>
        PaEnquetePreliminaireIntroPage(),
    "/pa/dps_dpg/cadres_juridiques/entraide_judiciaire/entraide_internationale":
        (_) => PaEntraideJudiciaireInternationalePage(),
    "/pa/dps_dpg/cadres_juridiques/entraide_judiciaire/eurojust": (_) =>
        PaEurojustPage(),
    "/pa/dps_dpg/cadres_juridiques/entraide_judiciaire/extradition_droit_commun":
        (_) => PaExtraditionDroitCommunPage(),
    "/pa/dps_dpg/cadres_juridiques/entraide_judiciaire/extradition_modalites_transmission":
        (_) => PaExtraditionModalitesTransmissionPage(),
    "/pa/dps_dpg/cadres_juridiques/entraide_judiciaire/extradition_simplifiee_ue":
        (_) => PaExtraditionSimplifieeUEPage(),
    "/pa/dps_dpg/cadres_juridiques/entraide_judiciaire/mae_definition": (_) =>
        PaMaeDefinitionPage(),
    "/pa/dps_dpg/cadres_juridiques/entraide_judiciaire/mae_execution_par_juridictions_fr":
        (_) => PaMaeExecutionParJuridictionsFrPage(),
    "/pa/dps_dpg/cadres_juridiques/entraide_judiciaire/mae_mandat_par_juridictions_fr":
        (_) => PaMaeMandatParJuridictionsFrPage(),
    "/pa/dps_dpg/cadres_juridiques/entraide_judiciaire/mae_mise_en_oeuvre":
        (_) => PaMaeMiseEnOeuvrePage(),
    "/pa/dps_dpg/cadres_juridiques/entraide_judiciaire/reseau_judiciaire_europeen":
        (_) => PaReseauJudiciaireEuropeenPage(),
    "/pa/dps_dpg/cadres_juridiques/entraide_judiciaire/traité_prum": (_) =>
        PaTraitePrumPage(),
    "/pa/dps_dpg/cadres_juridiques/entraide_judiciaire_contenu": (_) =>
        PaEntraideJudiciaireContenuPage(),
    "/pa/dps_dpg/cadres_juridiques/entraide_judiciaire_intro": (_) =>
        PaEntraideJudiciaireIntroPage(),
    "/pa/dps_dpg/cadres_juridiques/flagrant_delit_intro": (_) =>
        PaFlagrantDelitIntroPage(),
    "/pa/dps_dpg/cadres_juridiques/mort_inconnue/actes_delegues": (_) =>
        PaMortInconnueActesDeleguesPage(),
    "/pa/dps_dpg/cadres_juridiques/mort_inconnue/actes_enquete": (_) =>
        PaMortInconnueActesEnquetePage(),
    "/pa/dps_dpg/cadres_juridiques/mort_inconnue/actes_juge_instruction": (_) =>
        PaMortInconnueActesJugeInstructionPage(),
    "/pa/dps_dpg/cadres_juridiques/mort_inconnue/chapitre1": (_) =>
        PaMortInconnueConditionPage(),
    "/pa/dps_dpg/cadres_juridiques/mort_inconnue/chapitre2": (_) =>
        PaMortInconnueProcedurePage(),
    "/pa/dps_dpg/cadres_juridiques/mort_inconnue/intro": (_) =>
        PaMortInconnueIntroPage(),
    "/pa/dps_dpg/cadres_juridiques/mort_inconnue/suites_enquete": (_) =>
        PaMortInconnueSuitesEnquetePage(),
    "/pa/dps_dpg/cadres_juridiques/mort_inconnue_contenu": (_) =>
        PaMortInconnueContenuPage(),
    "/pa/dps_dpg/cadres_juridiques/mort_inconnue_intro": (_) =>
        PaMortInconnueIntroductionPage(),
    "/pa/dps_dpg/cadres_juridiques/personne_blesse_contenu": (_) =>
        PaPersonneBlesseGrievementContenuPage(),
    "/pa/dps_dpg/cadres_juridiques/personne_blessee_intro": (_) =>
        PaPersonneBlesseGrievementntroPage(),
    "/pa/dps_dpg/cadres_juridiques/personnes_fuite_contenu": (_) =>
        PaPersonnesFuiteContenuPage(),
    "/pa/dps_dpg/cadres_juridiques/personnes_fuite_intro": (_) =>
        PaPersonnesFuiteIntroPage(),
    "/pa/dps_dpg/cadres_juridiques/recherche_personnes_fuite/chapitre1": (_) =>
        PaPersonnesFuiteConditionGpxSchool(),
    "/pa/dps_dpg/cadres_juridiques/recherche_personnes_fuite/chapitre2": (_) =>
        PaPersonnesFuiteProcedureGpxSchool(),
    "/pa/dps_dpg/cadres_juridiques/recherche_personnes_fuite/chapitre3": (_) =>
        PaPersonnesFuiteTechniqueSpecialesGpxSchool(),
    "/pa/dps_dpg/cadres_juridiques/recherche_personnes_fuite/intro": (_) =>
        PaPersonnesFuiteIntroGpxSchool(),
    "/pa/dps_dpg/droit_penal_general/loi_penale": (_) =>
        PaLoiPenaleContenuPage(),
    "/pa/dps_dpg/droit_penal_general/loi_penale/classification_infractions":
        (_) => PaClassificationInfractionsContenuPageLoiPenal(),
    "/pa/dps_dpg/droit_penal_general/loi_penale/classification_infractions/classification":
        (_) => PaClassificationInfractionsGPXSchoolPageLoiPenal(),
    "/pa/dps_dpg/droit_penal_general/loi_penale/elements_constitutifs_infraction":
        (_) => PaGPXSchoolElementsConstitutifsInfractionPage(),
    "/pa/dps_dpg/droit_penal_general/loi_penale/etendue_application_lois":
        (_) => PaGPXSchoolEtendueApplicationLoisPage(),
    "/pa/dps_dpg/droit_penal_general/loi_penale/generalites_legislation_penale":
        (_) => PaGPXSchoolGeneralitesLegislationPenalePage(),
    "/pa/dps_dpg/droit_penal_general/responsabilite_penale": (_) =>
        PaResponsabilitePenalePage(),
    "/pa/dps_dpg/droit_penal_general/responsabilite_penale/causes_irresponsabilite":
        (_) => PaGPXSchoolResponsabilitePenaleCausesIrresponsabilitePage(),
    "/pa/dps_dpg/droit_penal_general/responsabilite_penale/complicite_coaction":
        (_) => PaGPXSchoolResponsabilitePenaleCompliciteCoactionPage(),
    "/pa/dps_dpg/droit_penal_general/responsabilite_penale/personnes_morales":
        (_) => PaGPXSchoolResponsabilitePenalePersonnesMoralesPage(),
    "/pa/dps_dpg/droit_penal_general/responsabilite_penale/principes_generaux":
        (_) => PaGPXSchoolResponsabilitePenalePrincipesGenerauxPage(),
    "/pa/dps_dpg/libertes_publiques/collectives/liberte_presse": (_) =>
        PaLibertePressePage(),
    "/pa/dps_dpg/libertes_publiques/collectives/regime_attroupements": (_) =>
        PaRegimeAttroupementsPage(),
    "/pa/dps_dpg/libertes_publiques/collectives/regime_manifestations": (_) =>
        PaRegimeManifestationsPage(),
    "/pa/dps_dpg/libertes_publiques/contenu": (_) =>
        PaLibertesPubliquesContenuPage(),
    "/pa/dps_dpg/libertes_publiques/garanties/controle_constitutionnalite_lois":
        (_) => PaControleConstitutionnaliteLoisPage(),
    "/pa/dps_dpg/libertes_publiques/garanties/recours_juridictionnels": (_) =>
        PaRecoursJuridictionnelsPage(),
    "/pa/dps_dpg/libertes_publiques/garanties/recours_non_juridictionnels":
        (_) => PaRecoursNonJuridictionnelsPage(),
    "/pa/dps_dpg/libertes_publiques/garanties/recours_organes_internationaux":
        (_) => PaRecoursOrganesInternationauxPage(),
    "/pa/dps_dpg/libertes_publiques/garanties_protection": (_) =>
        PaGarantiesProtectionLibertesPage(),
    "/pa/dps_dpg/libertes_publiques/individuelles/cnil_protection_donnees":
        (_) => PaCnilProtectionDonneesPage(),
    "/pa/dps_dpg/libertes_publiques/individuelles/droit_vie_privee": (_) =>
        PaDroitViePriveePage(),
    "/pa/dps_dpg/libertes_publiques/individuelles/liberte_aller_venir_detail":
        (_) => PaLiberteAllerVenirDetailPage(),
    "/pa/dps_dpg/libertes_publiques/individuelles/respect_personne_legislation":
        (_) => PaRespectPersonneLegislationPage(),
    "/pa/dps_dpg/libertes_publiques/individuelles/surete_liberte_individuelle":
        (_) => PaSureteLiberteIndividuellePage(),
    "/pa/dps_dpg/libertes_publiques/introduction": (_) =>
        PaIntroductionLibertesPubliquesPage(),
    "/pa/dps_dpg/libertes_publiques/introduction/declaration_droits_homme":
        (_) => PaDeclarationDroitsHommePage(),
    "/pa/dps_dpg/libertes_publiques/introduction/notion": (_) =>
        PaNotionLibertesPubliquesPage(),
    "/pa/dps_dpg/libertes_publiques/introduction/regime_juridique": (_) =>
        PaRegimeJuridiqueLibertesPubliquesPage(),
    "/pa/dps_dpg/libertes_publiques/introduction/sources": (_) =>
        PaSourcesLibertesPubliquesPage(),
    "/pa/dps_dpg/libertes_publiques/libertes_expression_collectives": (_) =>
        PaLibertesExpressionCollectivesPage(),
    "/pa/dps_dpg/libertes_publiques/libertes_individuelles_vie_privee": (_) =>
        PaLibertesIndividuellesViePriveePage(),
    "/pa/dps_dpg/libertes_publiques_intro": (_) =>
        PaLibertesPubliquesIntroPage(),
    "/pa/dps_dpg/mineurs_famille_pages/abandon_famille": (_) =>
        PaAbandonFamillePage(),
    "/pa/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille":
        (_) => PaAbandonDeFamillePage(),
    "/pa/dps_dpg/mineurs_famille_pages/autorite_parentale": (_) =>
        PaAutoriteParentalePage(),
    "/pa/dps_dpg/mineurs_famille_pages/autorite_parentale/defaut_notification_transfert":
        (_) => PaDefautNotificationTransfertPage(),
    "/pa/dps_dpg/mineurs_famille_pages/autorite_parentale/non_representation_enfant_mineur":
        (_) => PaNonRepresentationEnfantMineurPage(),
    "/pa/dps_dpg/mineurs_famille_pages/autorite_parentale/soustraction_enfant_mineur_par_ascendant":
        (_) => PaSoustractionEnfantMineurParAscendantPage(),
    "/pa/dps_dpg/mineurs_famille_pages/autorite_parentale/soustraction_enfant_mineur_sans_fraude":
        (_) => PaSoustractionEnfantMineurSansFraudePage(),
    "/pa/dps_dpg/mineurs_famille_pages/mise_en_peril": (_) =>
        PaMiseEnPerilDesMineursPage(),
    "/pa/dps_dpg/mineurs_famille_pages/mise_en_peril/atteintes_sexuelles_majeur_mineur_15":
        (_) => PaAtteintesSexuellesMajeurMineur15Page(),
    "/pa/dps_dpg/mineurs_famille_pages/mise_en_peril/atteintes_sexuelles_majeur_mineur_plus_15":
        (_) => PaAtteintesSexuellesMajeurMineurPlus15Page(),
    "/pa/dps_dpg/mineurs_famille_pages/mise_en_peril/corruption_mineur": (_) =>
        PaCorruptionMineurPage(),
    "/pa/dps_dpg/mineurs_famille_pages/mise_en_peril/diffusion_message_violent_mineur":
        (_) => PaDiffusionMessageViolentMineurPage(),
    "/pa/dps_dpg/mineurs_famille_pages/mise_en_peril/exploitation_image_porno_mineur":
        (_) => PaExploitationImagePornoMineurPage(),
    "/pa/dps_dpg/mineurs_famille_pages/mise_en_peril/privation_aliments_soins_mineur_15":
        (_) => PaPrivationAlimentsSoinsMineur15Page(),
    "/pa/dps_dpg/mineurs_famille_pages/mise_en_peril/propositions_sexuelles_mineur_15_en_ligne":
        (_) => PaPropositionsSexuellesMineur15EnLignePage(),
    "/pa/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_directe_mineur_crime_delit":
        (_) => PaProvocationDirecteMineurCrimeDelitPage(),
    "/pa/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_mineur_alcool":
        (_) => PaProvocationMineurAlcoolPage(),
    "/pa/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_mineur_stupefiants":
        (_) => PaProvocationMineurStupefiantsPage(),
    "/pa/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_pedopornographie":
        (_) => PaProvocationPedopornographiePage(),
    "/pa/dps_dpg/mineurs_famille_pages/mise_en_peril/soustraction_parent_obligations_legales":
        (_) => PaSoustractionParentObligationsLegalesPage(),
    "/pa/dps_dpg/mineurs_famille_pages/violation_ordonnances_jaf": (_) =>
        PaViolationOrdonnancesJafPage(),
    "/pa/dps_dpg/mineurs_famille_pages/violation_ordonnances_jaf/defaut_notification_changement":
        (_) => PaDefautNotificationChangementDomicileCreancierPage(),
    "/pa/dps_dpg/mineurs_famille_pages/violation_ordonnances_jaf/non_respect_obligations_interdictions":
        (_) => PaNonRespectObligationsInterdictionsOrdonnanceProtectionPage(),
    "/pa/dps_dpg/policier_intervention/accident-circulation/regulation-circulation":
        (_) => PaRegulationCirculationPage(),
    "/pa/dps_dpg/policier_intervention/accident-circulation/securite-trajet-lieux":
        (_) => PaSecuriteTrajetLieuxPage(),
    "/pa/dps_dpg/policier_intervention/accident-circulation/types-accidents":
        (_) => PaTypesAccidentsCirculationPage(),
    "/pa/dps_dpg/policier_intervention/autres/alertes-a-la-bombe": (_) =>
        PaAlertesALaBombePage(),
    "/pa/dps_dpg/policier_intervention/autres/identification-detection-produits-suspects":
        (_) => PaIdentificationDetectionProduitsSuspectsPage(),
    "/pa/dps_dpg/policier_intervention/autres/ipm": (_) =>
        PaIvressePubliqueManifestePage(),
    "/pa/dps_dpg/policier_intervention/autres/plans-orsec": (_) =>
        PaPlansOrsecPage(),
    "/pa/dps_dpg/policier_intervention/autres/primo-scene-infraction-amaris":
        (_) => PaPrimoSceneInfractionAmarisPage(),
    "/pa/dps_dpg/policier_intervention/domicile/bruits-tapages": (_) =>
        PaBruitsTapagesPage(),
    "/pa/dps_dpg/policier_intervention/domicile/differend-familial": (_) =>
        PaDifferendFamilialPage(),
    "/pa/dps_dpg/policier_intervention/domicile/violation-domicile": (_) =>
        PaViolationDomicilePage(),
    "/pa/dps_dpg/policier_intervention/domicile/violences-conjugales": (_) =>
        PaViolencesConjugalesPage(),
    "/pa/dps_dpg/policier_intervention/formulaires-utiles/avis-retention-permis":
        (_) => PaAvisRetentionPermisPage(),
    "/pa/dps_dpg/policier_intervention/formulaires-utiles/fiche-descriptive-fourriere":
        (_) => PaFicheDescriptiveFourrierePage(),
    "/pa/dps_dpg/policier_intervention/formulaires-utiles/fiche-immobilisation":
        (_) => PaFicheImmobilisationPage(),
    "/pa/dps_dpg/policier_intervention/patrouille/camera-pieton": (_) =>
        PaCameraPietonPage(),
    "/pa/dps_dpg/policier_intervention/patrouille/communication-radio": (_) =>
        PaCommunicationRadioPage(),
    "/pa/dps_dpg/policier_intervention/patrouille/conduite-vehicules": (_) =>
        PaConduiteVehiculesPolicePage(),
    "/pa/dps_dpg/policier_intervention/patrouille/enregistrement-diffusion-images-paroles":
        (_) => PaEnregistrementDiffusionImagesParolesPage(),
    "/pa/dps_dpg/policier_intervention/patrouille/equipements-securite": (_) =>
        PaEquipementsSecuritePage(),
    "/pa/dps_dpg/policier_intervention/patrouille/interrogation-fpr": (_) =>
        PaInterrogationFprPage(),
    "/pa/dps_dpg/policier_intervention/patrouille/memo-tph-900": (_) =>
        PaMemoTph900Page(),
    "/pa/dps_dpg/policier_intervention/patrouille/menottage": (_) =>
        PaMenottagePage(),
    "/pa/dps_dpg/policier_intervention/patrouille/palpation-securite": (_) =>
        PaPalpationSecuritePage(),
    "/pa/dps_dpg/policier_intervention/patrouille/patrouille": (_) =>
        PaPatrouillePatrouillePage(),
    "/pa/dps_dpg/policier_intervention/patrouille/principaux-fichiers": (_) =>
        PaPrincipauxFichiersPage(),
    "/pa/dps_dpg/policier_intervention/patrouille/procedure-radio": (_) =>
        PaProcedureRadioPage(),
    "/pa/dps_dpg/policier_intervention/patrouille/signalement-descriptif":
        (_) => PaSignalementDescriptifPage(),
    "/pa/dps_dpg/policier_intervention/patrouille/signaux-sonores-lumineux":
        (_) => PaSignauxSonoresLumineuxPage(),
    "/pa/dps_dpg/policier_intervention/patrouille/synthese-indicateurs-basculement":
        (_) => PaSyntheseIndicateursBasculementPage(),
    "/pa/dps_dpg/policier_intervention/patrouille/utilite-camera": (_) =>
        PaUtiliteCameraPietonPage(),
    "/pa/dps_dpg/policier_intervention/prise-service/appel": (_) =>
        PaPriseServiceAppelPage(),
    "/pa/dps_dpg/policier_intervention/prise-service/applications": (_) =>
        PaPriseServiceApplicationsPage(),
    "/pa/dps_dpg/policier_intervention/prise-service/fouille-integrale": (_) =>
        PaPriseServiceFouilleIntegralePage(),
    "/pa/dps_dpg/policier_intervention/prise-service/garde-a-vue": (_) =>
        PaPriseServiceGardeAVuePage(),
    "/pa/dps_dpg/policier_intervention/prise-service/registres": (_) =>
        PaPriseServiceRegistresPage(),
    "/pa/dps_dpg/policier_intervention/prise-service/risque-evasion-fuite":
        (_) => PaPriseServiceRisqueEvasionFuitePage(),
    "/pa/dps_dpg/procedure_penale/juridictions_contenu": (_) =>
        PaJuridictionContenuPage(),
    "/pa/dps_dpg/procedure_penale/juridictions_execution_decisions_justice":
        (_) => PaJuridictionsExecutionDecisionsJusticePage(),
    "/pa/dps_dpg/procedure_penale/juridictions_principes_generaux": (_) =>
        PaJuridictionsPrincipesGenerauxPage(),
    "/pa/dps_dpg/procedure_penale/mandats_sanctions_irregularites": (_) =>
        PaPPMandatsSanctionsIrregularitesPage(),
    "/pa/dps_dpg/procedure_penale/mandats_types": (_) => PaPPMandatsTypesPage(),
    "/pa/dps_dpg/procedure_penale/nullite_intro_page": (_) =>
        PaNulliteIntroPage(),
    "/pa/dps_dpg/procedure_penale/pp_action_en_nullite": (_) =>
        PaPPActionEnNullitePage(),
    "/pa/dps_dpg/procedure_penale/pp_action_publique_action_civile": (_) =>
        PaPPActionPubliqueActionCivilePage(),
    "/pa/dps_dpg/procedure_penale/pp_action_publique_action_civile/chapitre_1_titre_preliminaire":
        (_) => PaPPActionPubliqueChapitre1TitrePreliminairePage(),
    "/pa/dps_dpg/procedure_penale/pp_action_publique_action_civile/chapitre_2_sujets_action_publique":
        (_) => PaPPActionPubliqueChapitre2SujetsActionPubliquePage(),
    "/pa/dps_dpg/procedure_penale/pp_action_publique_action_civile/chapitre_3_exercice_action_publique":
        (_) => PaPPActionPubliqueChapitre3ExerciceActionPubliquePage(),
    "/pa/dps_dpg/procedure_penale/pp_action_publique_action_civile/chapitre_4_extinction_action_publique":
        (_) => PaPPActionPubliqueChapitre4ExtinctionActionPubliquePage(),
    "/pa/dps_dpg/procedure_penale/pp_action_publique_action_civile/tableau_actions_publique_civile":
        (_) => PaPPActionPubliqueActionCivileTableauPage(),
    "/pa/dps_dpg/procedure_penale/pp_action_publique_action_civile_intro":
        (_) => PaActionPubliqueIntroPage(),
    "/pa/dps_dpg/procedure_penale/pp_action_publique_autorites_pj": (_) =>
        PaPPActionPubliqueAutoritesPJPage(),
    "/pa/dps_dpg/procedure_penale/pp_assignation_residence_conditions": (_) =>
        PaPpAssignationResidenceConditionsPage(),
    "/pa/dps_dpg/procedure_penale/pp_assignation_residence_surveillance_contenu":
        (_) => PaBraceletMaisonContenuPage(),
    "/pa/dps_dpg/procedure_penale/pp_auditions_pv_regles": (_) =>
        PaPpAuditionsPvReglesPage(),
    "/pa/dps_dpg/procedure_penale/pp_autorites_investies_pj": (_) =>
        PaAutoriteInvestiesLoiPage(),
    "/pa/dps_dpg/procedure_penale/pp_autorites_investies_pj_habituelles": (_) =>
        PaPPAutoritesInvestiesPJHabituellesPage(),
    "/pa/dps_dpg/procedure_penale/pp_autorites_investies_pj_intro": (_) =>
        PaAutoriteInvestiesLoiIntroPage(),
    "/pa/dps_dpg/procedure_penale/pp_autorites_investies_pj_occasionnelles":
        (_) => PaPPAutoritesInvestiesPJOccasionnellesPage(),
    "/pa/dps_dpg/procedure_penale/pp_bracelet_deroulement_mesure": (_) =>
        PaPpBraceletDeroulementMesurePage(),
    "/pa/dps_dpg/procedure_penale/pp_bracelet_modalites_placement": (_) =>
        PaPpBraceletModalitesPlacementPage(),
    "/pa/dps_dpg/procedure_penale/pp_chambre_instruction": (_) =>
        PaPPChambreInstructionPage(),
    "/pa/dps_dpg/procedure_penale/pp_controle_judiciaire_chapitre1": (_) =>
        PaPPControleJudiciaireChapitre1Page(),
    "/pa/dps_dpg/procedure_penale/pp_controle_judiciaire_chapitre2": (_) =>
        PaPPControleJudiciaireChapitre2Page(),
    "/pa/dps_dpg/procedure_penale/pp_controle_judiciaire_contenu": (_) =>
        PaControleJudiciaireContenu(),
    "/pa/dps_dpg/procedure_penale/pp_controle_judiciaire_tableau": (_) =>
        PaPPControleJudiciaireTableauPage(),
    "/pa/dps_dpg/procedure_penale/pp_controle_mission_pj": (_) =>
        PaControleMissionJudiciaireIntroPage(),
    "/pa/dps_dpg/procedure_penale/pp_controle_mission_pj_chambre_instruction":
        (_) => PaPPControleMissionPJChambreInstructionPage(),
    "/pa/dps_dpg/procedure_penale/pp_controle_mission_pj_inspection_generale_justice":
        (_) => PaPPControleMissionPJInspectionGeneraleJusticePage(),
    "/pa/dps_dpg/procedure_penale/pp_controle_mission_pj_intro": (_) =>
        PaControleMissionJudiciairePage(),
    "/pa/dps_dpg/procedure_penale/pp_controle_mission_pj_role_procureur_general":
        (_) => PaPPControleMissionPJRoleProcureurGeneralPage(),
    "/pa/dps_dpg/procedure_penale/pp_deroulement_detention_provisoire": (_) =>
        PaPPDeroulementDetentionProvisoirePage(),
    "/pa/dps_dpg/procedure_penale/pp_detention_provisoire": (_) =>
        PaDetentionIntroPage(),
    "/pa/dps_dpg/procedure_penale/pp_detention_provisoire_contenu": (_) =>
        PaPPDetentionProvisoireContenuPage(),
    "/pa/dps_dpg/procedure_penale/pp_detention_provisoire_tableau": (_) =>
        PaPPDetentionProvisoireTableauPage(),
    "/pa/dps_dpg/procedure_penale/pp_dispositions_mineurs_instruction_contenu":
        (_) => PaDispositionsMineursContenuPage(),
    "/pa/dps_dpg/procedure_penale/pp_effets_nullite": (_) =>
        PaPPEffetsNullitePage(),
    "/pa/dps_dpg/procedure_penale/pp_fin_detention_provisoire": (_) =>
        PaPPFinDetentionProvisoirePage(),
    "/pa/dps_dpg/procedure_penale/pp_gav_conditions_placement": (_) =>
        PaPpGavConditionsPlacementPage(),
    "/pa/dps_dpg/procedure_penale/pp_gav_droits_personne_gardee": (_) =>
        PaPpGavDroitsPersonneGardeePage(),
    "/pa/dps_dpg/procedure_penale/pp_instruction_cloture": (_) =>
        PaPPInstructionCloturePage(),
    "/pa/dps_dpg/procedure_penale/pp_instruction_def": (_) =>
        PaPPInstructionCh1Page(),
    "/pa/dps_dpg/procedure_penale/pp_instruction_mandats_controle_detention":
        (_) => PaInstructionIntroPage(),
    "/pa/dps_dpg/procedure_penale/pp_instruction_ouverture": (_) =>
        PaPPInstructionOuverturePage(),
    "/pa/dps_dpg/procedure_penale/pp_instruction_pouvoirs": (_) =>
        PaPPInstructionPouvoirsPage(),
    "/pa/dps_dpg/procedure_penale/pp_instruction_preparatoire": (_) =>
        PaPPInstructionPreparatoireContenuPage(),
    "/pa/dps_dpg/procedure_penale/pp_instruction_preparatoire_contenu": (_) =>
        PaInstructionContenuPage(),
    "/pa/dps_dpg/procedure_penale/pp_jld": (_) => PaPPJLDPage(),
    "/pa/dps_dpg/procedure_penale/pp_juridictions_penales": (_) =>
        PaPpJuridictionsPenalesPage(),
    "/pa/dps_dpg/procedure_penale/pp_mandats_justice": (_) =>
        PaMandatsJusticeContenuPage(),
    "/pa/dps_dpg/procedure_penale/pp_mandats_principes_generaux": (_) =>
        PaPpMandatsPrincipesGenerauxPage(),
    "/pa/dps_dpg/procedure_penale/pp_mineurs_instruction_preparatoire": (_) =>
        PaPPMineursInstructionPreparatoirePage(),
    "/pa/dps_dpg/procedure_penale/pp_mineurs_principes_generaux": (_) =>
        PaPPMineursPrincipesGenerauxPage(),
    "/pa/dps_dpg/procedure_penale/pp_mineurs_retention_mandats": (_) =>
        PaPPMineursRetentionMandatsPage(),
    "/pa/dps_dpg/procedure_penale/pp_nullite_actes_procedure_contenu": (_) =>
        PaPPNulliteActesProcedureContenuPage(),
    "/pa/dps_dpg/procedure_penale/pp_nullites_substantielles": (_) =>
        PaPPNullitesSubstantiellesPage(),
    "/pa/dps_dpg/procedure_penale/pp_nullites_textuelles": (_) =>
        PaPPNullitesTextuellesPage(),
    "/pa/dps_dpg/procedure_penale/pp_organisation_ministere_public_contenu":
        (_) => PaPPOrganisationMinisterePublicContenuPage(),
    "/pa/dps_dpg/procedure_penale/pp_placement_detention_provisoire": (_) =>
        PaPPPlacementDetentionProvisoirePage(),
    "/pa/dps_dpg/procedure_penale/pp_reparation_detention_injustifiee": (_) =>
        PaPPReparationDetentionInjustifieePage(),
    "/pa/dps_dpg/sanctions/causes_aggravation": (_) =>
        PaCausesAggravationPage(),
    "/pa/dps_dpg/sanctions/causes_aggravation_sanction": (_) =>
        PaCausesAggravationSanctionContenuPage(),
    "/pa/dps_dpg/sanctions/causes_aggravation_sanction/auteur_abusant_autorite":
        (_) => PaAuteurAbusantAutoritePage(),
    "/pa/dps_dpg/sanctions/causes_aggravation_sanction/auteur_ascendant_victime":
        (_) => PaAuteurAscendantVictimePage(),
    "/pa/dps_dpg/sanctions/causes_aggravation_sanction/auteur_depositaire_autorite":
        (_) => PaAuteurDepositaireAutoritePage(),
    "/pa/dps_dpg/sanctions/causes_aggravation_sanction/auteur_ivre_ou_stupefiants":
        (_) => PaAuteurIvreOuStupefiantsPage(),
    "/pa/dps_dpg/sanctions/causes_aggravation_sanction/bande_organisee": (_) =>
        PaBandeOrganiseePage(),
    "/pa/dps_dpg/sanctions/causes_aggravation_sanction/caractere_homophobe":
        (_) => PaCaractereHomophobePage(),
    "/pa/dps_dpg/sanctions/causes_aggravation_sanction/caractere_raciste":
        (_) => PaCaractereRacistePage(),
    "/pa/dps_dpg/sanctions/causes_aggravation_sanction/circonstances_aggravantes":
        (_) => PaCirconstancesAggravantesPage(),
    "/pa/dps_dpg/sanctions/causes_aggravation_sanction/effraction": (_) =>
        PaEffractionPage(),
    "/pa/dps_dpg/sanctions/causes_aggravation_sanction/escalade": (_) =>
        PaEscaladePage(),
    "/pa/dps_dpg/sanctions/causes_aggravation_sanction/etablissement_enseignement":
        (_) => PaEtablissementEnseignementPage(),
    "/pa/dps_dpg/sanctions/causes_aggravation_sanction/guet_apens": (_) =>
        PaGuetApensPage(),
    "/pa/dps_dpg/sanctions/causes_aggravation_sanction/incapacite_totale_travail":
        (_) => PaIncapaciteTotaleTravailPage(),
    "/pa/dps_dpg/sanctions/causes_aggravation_sanction/minorite_quinze_ans":
        (_) => PaMinoriteQuinzeAnsPage(),
    "/pa/dps_dpg/sanctions/causes_aggravation_sanction/mort": (_) =>
        PaMortPage(),
    "/pa/dps_dpg/sanctions/causes_aggravation_sanction/moyen_cryptologie":
        (_) => PaMoyenCryptologiePage(),
    "/pa/dps_dpg/sanctions/causes_aggravation_sanction/mutilation_infirmité_permanente":
        (_) => PaMutilationInfirmitePermanentePage(),
    "/pa/dps_dpg/sanctions/causes_aggravation_sanction/port_ou_usage_arme":
        (_) => PaPortOuUsageArmePage(),
    "/pa/dps_dpg/sanctions/causes_aggravation_sanction/premeditation": (_) =>
        PaPremeditationPage(),
    "/pa/dps_dpg/sanctions/causes_aggravation_sanction/qualite_conjoint_concubin_partenaire":
        (_) => PaQualiteConjointConcubinPartenairePage(),
    "/pa/dps_dpg/sanctions/causes_aggravation_sanction/temoin_victime_partie_civile":
        (_) => PaTemoinVictimePartieCivilePage(),
    "/pa/dps_dpg/sanctions/causes_aggravation_sanction/utilisation_reseau_communication":
        (_) => PaUtilisationReseauCommunicationPage(),
    "/pa/dps_dpg/sanctions/causes_aggravation_sanction/victime_ascendant_auteur":
        (_) => PaVictimeAscendantAuteurPage(),
    "/pa/dps_dpg/sanctions/causes_aggravation_sanction/victime_chargee_mission":
        (_) => PaVictimeChargeeMissionPage(),
    "/pa/dps_dpg/sanctions/causes_aggravation_sanction/victime_depositaire_autorite":
        (_) => PaVictimeDepositaireAutoritePage(),
    "/pa/dps_dpg/sanctions/causes_aggravation_sanction/victime_parente_personne":
        (_) => PaVictimeParentePersonneDepositaireAutoritePage(),
    "/pa/dps_dpg/sanctions/causes_aggravation_sanction/victime_prostitution":
        (_) => PaVictimeProstitutionPage(),
    "/pa/dps_dpg/sanctions/causes_aggravation_sanction/vulnerabilite_victime":
        (_) => PaVulnerabiliteVictimePage(),
    "/pa/dps_dpg/sanctions/classification_peines": (_) =>
        PaClassificationPeinesPage(),
    "/pa/dps_dpg/sanctions/classification_peines/classification_legale_peines":
        (_) => PaClassificationLegalePeinesPage(),
    "/pa/dps_dpg/sanctions/classification_peines/classification_mesures_surete":
        (_) => PaClassificationMesuresSuretePage(),
    "/pa/dps_dpg/sanctions/pluralite_infractions": (_) =>
        PaPluraliteInfractionsPage(),
    "/pa/dps_dpg/sanctions/pluralite_infractions/concours_reel_infractions":
        (_) => PaConcoursReelInfractionsPage(),
    "/pa/dps_dpg/sanctions/pluralite_infractions/recidive": (_) =>
        PaRecidivePage(),
    "/pa/dps_dpg/sanctions/pluralite_infractions/reiteration_infractions":
        (_) => PaReiterationInfractionsPage(),
    "/pa/dps_dpg/socle_initial/circulation/agents_verbalisateurs": (_) =>
        AgentsVerbalisateursCirculationPage(),
    "/pa/dps_dpg/socle_initial/circulation/conduite_stupefiants": (_) =>
        PaConduiteStupefiantsPage(),
    "/pa/dps_dpg/socle_initial/circulation/defaut_assurance": (_) =>
        PaDefautAssurancePage(),
    "/pa/dps_dpg/socle_initial/circulation/defaut_permis": (_) =>
        PaDefautPermisPage(),
    "/pa/dps_dpg/socle_initial/circulation/delit_fuite": (_) =>
        PaDelitFuitePage(),
    "/pa/dps_dpg/socle_initial/circulation/etat_alcoolique": (_) =>
        PaEtatAlcooliquePage(),
    "/pa/dps_dpg/socle_initial/circulation/grand_exces_vitesse": (_) =>
        PaGrandExcesVitessePage(),
    "/pa/dps_dpg/socle_initial/circulation/incitation_organisation_promotion":
        (_) => PaIncitationOrganisationPromotionPage(),
    "/pa/dps_dpg/socle_initial/circulation/ivresse": (_) => PaIvressePage(),
    "/pa/dps_dpg/socle_initial/circulation/plaques_inscriptions": (_) =>
        PaPlaquesInscriptionsPage(),
    "/pa/dps_dpg/socle_initial/circulation/refus_obtemperer": (_) =>
        PaRefusObtempererPage(),
    "/pa/dps_dpg/socle_initial/circulation/refus_verifications": (_) =>
        PaRefusVerificationsPage(),
    "/pa/dps_dpg/socle_initial/circulation/rodeo_motorise": (_) =>
        PaRodeoMotorisePage(),
    "/pa/dps_dpg/socle_initial/generalites/classification_infractions": (_) =>
        PaClassificationInfractionsPage(),
    "/pa/dps_dpg/socle_initial/generalites/complicite_intro": (_) =>
        PaCompliciteIntroPage(),
    "/pa/dps_dpg/socle_initial/generalites/infraction_intro": (_) =>
        PaInfractionIntroPage(),
    "/pa/dps_dpg/socle_initial/generalites/legitimedefense_intro": (_) =>
        PaLegitimeDefenseIntroPage(),
    "/pa/dps_dpg/socle_initial/generalites/retention_locaux_police_intro":
        (_) => PaRetentionLocauxIntroPage(),
    "/pa/dps_dpg/socle_initial/generalites/tentative_intro": (_) =>
        PaTentativeIntroPage(),
    "/pa/dps_dpg/socle_initial/generalites/usagedesarmes_intro": (_) =>
        PaUsageArmesIntroPage(),
    "/pa/dps_dpg/socle_initial/hierarchie/hierarchie_intro": (_) =>
        PaHierarchieIntroPage(),
    "/pa/dps_dpg/stupefiants/blanchiment_produit": (_) =>
        PaStupefiantsBlanchimentProduitPage(),
    "/pa/dps_dpg/stupefiants/cession_offre": (_) =>
        PaStupefiantsCessionOffrePage(),
    "/pa/dps_dpg/stupefiants/direction_organisation": (_) =>
        PaStupefiantsDirectionOrganisationPage(),
    "/pa/dps_dpg/stupefiants/facilitation_usage": (_) =>
        PaStupefiantsFacilitationUsagePage(),
    "/pa/dps_dpg/stupefiants/import_export": (_) =>
        PaStupefiantsImportExportPage(),
    "/pa/dps_dpg/stupefiants/introduction": (_) =>
        PaStupefiantsIntroductionPage(),
    "/pa/dps_dpg/stupefiants/production_fabrication": (_) =>
        PaStupefiantsProductionFabricationPage(),
    "/pa/dps_dpg/stupefiants/provocation_majeur": (_) =>
        PaStupefiantsProvocationMajeurPage(),
    "/pa/dps_dpg/stupefiants/transport_detention_offre": (_) =>
        PaStupefiantsTransportDetentionOffrePage(),
    "/pa/dps_dpg/stupefiants/usage_illicite": (_) =>
        PaStupefiantsUsageIllicitePage(),
    "/pa/droit_penal/quiz/droit_penal_general": (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizDroitPenalePagePA(
        uid: user?.id ?? '',
        email: user?.email ?? '',
      );
    },
    "/pa/droit_penal/quiz/responsabilite_penal_general": (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizResponsabilitePenalePagePA(
        uid: user?.id ?? '',
        email: user?.email ?? '',
      );
    },
    "/pa/generalites/quiz/classification_infractions": (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizClassificationInfractionsPagePA(
        uid: user?.id ?? '',
        email: user?.email ?? '',
      );
    },
    "/pa/generalites/quiz/commission_rogatoire": (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizCommissionRogatoirePagePA(
        uid: user?.id ?? '',
        email: user?.email ?? '',
      );
    },
    "/pa/generalites/quiz/controle_identite": (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizControleIdentitePagePA(
        uid: user?.id ?? '',
        email: user?.email ?? '',
      );
    },
    "/pa/generalites/quiz/criminalite_organisee": (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizCriminaliteOrganiseePagePA(
        uid: user?.id ?? '',
        email: user?.email ?? '',
      );
    },
    "/pa/generalites/quiz/disparitions_inquietantes": (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizDisparitionPagePA(
        uid: user?.id ?? '',
        email: user?.email ?? '',
      );
    },
    "/pa/generalites/quiz/enquete_preliminaire": (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizEnquetePreliminairePagePA(
        uid: user?.id ?? '',
        email: user?.email ?? '',
      );
    },
    "/pa/generalites/quiz/flagrant_delit": (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizFlagrantDelitPagePA(
        uid: user?.id ?? '',
        email: user?.email ?? '',
      );
    },
    "/pa/generalites/quiz/garanties_libertes_publiques": (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizGarantiesLibertesPagePA(
        uid: user?.id ?? '',
        email: user?.email ?? '',
      );
    },
    "/pa/generalites/quiz/hierarchie": (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizHierarchiePagePA(
        uid: user?.id ?? '',
        email: user?.email ?? '',
      );
    },
    "/pa/generalites/quiz/legitimedefense": (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizLegitimeDefensePagePA(
        uid: user?.id ?? '',
        email: user?.email ?? '',
      );
    },
    "/pa/generalites/quiz/libertes_publiques": (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizLibertesPubliquesPagePA(
        uid: user?.id ?? '',
        email: user?.email ?? '',
      );
    },
    "/pa/generalites/quiz/libertes_publiques_collectives": (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizLibertesPubliquesCollectivesPagePA(
        uid: user?.id ?? '',
        email: user?.email ?? '',
      );
    },
    "/pa/generalites/quiz/libertes_publiques_individuelles": (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizLibertesPubliquesIndividuellesPagePA(
        uid: user?.id ?? '',
        email: user?.email ?? '',
      );
    },
    "/pa/generalites/quiz/mort_inconnue": (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizMortInconnuePagePA(
        uid: user?.id ?? '',
        email: user?.email ?? '',
      );
    },
    "/pa/generalites/quiz/personnes_fuite": (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizPersonnesFuitePagePA(
        uid: user?.id ?? '',
        email: user?.email ?? '',
      );
    },
    "/pa/generalites/quiz/retention_locaux_police": (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizRetentionLocauxPagePA(
        uid: user?.id ?? '',
        email: user?.email ?? '',
      );
    },
    "/pa/generalites/quiz/tentative": (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizTentativePagePA(uid: user?.id ?? '', email: user?.email ?? '');
    },
    "/pa/generalites/quiz/usagearmes": (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizUsageArmesPagePA(
        uid: user?.id ?? '',
        email: user?.email ?? '',
      );
    },
    "/pa/generalites/tentative/conditions_tentative": (_) =>
        ConditionTentativePage(),
    "/pa/generalites/tentative/contenu": (_) => TentativeContenuPagePA(),
    "/pa/generalites/tentative/infructueuse_tentative": (_) =>
        InfructueuseTentativePage(),
    "/pa/generalites/tentative/repression_tentative": (_) =>
        RepressionTentativePage(),
    "/pa/generalites/tentative_intro": (_) => TentativeIntroPagePA(),
    "/pa/hub/organisation_judiciaire": (_) => PaOrganisationJudiciaireHubPage(),
    "/pa/infraction_circulation_routière_pages/quiz/pa_quiz_circulation_routiere":
        (_) {
          final user = Supabase.instance.client.auth.currentUser;
          return QuizCirculationRoutierePA(
            uid: user?.id ?? '',
            email: user?.email ?? '',
          );
        },
    "/pa/infractions/quiz/infractions": (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizInfractionsPagePA(
        uid: user?.id ?? '',
        email: user?.email ?? '',
      );
    },
    "/pa/institution/accueil_public/charte": (_) =>
        PaCharteAccueilPublicVictimesPage(),
    "/pa/institution/accueil_public/demarches": (_) =>
        PaDemarchesAdministrativesPage(),
    "/pa/institution/accueil_public/doctrine": (_) =>
        PaGpxDoctrineAccueilVictimesVcPage(),
    "/pa/institution/accueil_public/marianne": (_) =>
        PaReferentielMariannePage(),
    "/pa/institution/accueil_public/protection_locaux": (_) =>
        PaProtectionLocauxPolicePage(),
    "/pa/institution/accueil_public/quiz": (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return PaQuizAccueilPublicPage(
        uid: user?.id ?? '',
        email: user?.email ?? '',
      );
    },
    "/pa/institution/deontologie/code_commente": (_) =>
        PaCodeDeontologieCodeCommentePage(),
    "/pa/institution/deontologie/droits_obligations": (_) =>
        PaDroitsObligationsPoliciersPage(),
    "/pa/institution/deontologie/enquete_administrative": (_) =>
        PaEnqueteAdministrativePage(),
    "/pa/institution/deontologie/hors_service_amaris": (_) =>
        PaHorsServiceAmarisPage(),
    "/pa/institution/deontologie/marques_respect": (_) =>
        PaMarquesExterieuresRespectPage(),
    "/pa/institution/deontologie/quiz": (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return PaQuizDeontologiePage(
        uid: user?.id ?? '',
        email: user?.email ?? '',
      );
    },
    "/pa/institution/deontologie/reseaux_sociaux": (_) =>
        PaReseauxSociauxPage(),
    "/pa/institution/deontologie/sanctions_recompenses": (_) =>
        PaSanctionsRecompensesPage(),
    "/pa/institution/formation_initiale/formation": (_) =>
        FormationInitialePolicierAdjointPage(),
    "/pa/institution/formation_initiale/memento_notes": (_) =>
        MementoPriseDeNotesMethodologiePage(),
    "/pa/institution/hierarchie_info/compte_rendu": (_) => PaCompteRenduPage(),
    "/pa/institution/hierarchie_info/formalisme_rapport": (_) =>
        PaFormalismeRapportPage(),
    "/pa/institution/hierarchie_info/modeles": (_) => PaModelesRapportsPage(),
    "/pa/institution/histoire/reperes": (_) => PaHistoireReperesPage(),
    "/pa/institution/laicite/charte": (_) =>
        PaCharteLaiciteServicesPublicsPage(),
    "/pa/institution/laicite/laicite_dlpaj": (_) => PaGpxLaiciteDlpajPage(),
    "/pa/institution/laicite/rites_cultes": (_) => PaRitesCultesFrancePage(),
    "/pa/institution/organisation_pn/dgsi": (_) => PaDgsiPage(),
    "/pa/institution/organisation_pn/hierarchie": (_) => PaHierarchiePnPage(),
    "/pa/institution/organisation_pn/horaires_service_sp": (_) =>
        PaHorairesServiceSpPage(),
    "/pa/institution/organisation_pn/organigramme_mi": (_) =>
        PaOrganigrammeMinistereInterieurPage(),
    "/pa/institution/organisation_pn/organigrammes": (_) =>
        PaOrganigrammesPnPage(),
    "/pa/institution/organisation_pn/organisation": (_) =>
        PaOrganisationPoliceNationalePage(),
    "/pa/institution/organisation_pn/prefecture_police": (_) =>
        PaPrefecturePolicePage(),
    "/pa/institution/organisation_pn/quiz": (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return PaQuizOrganisationPnPage(
        uid: user?.id ?? '',
        email: user?.email ?? '',
      );
    },
    "/pa/institution/organisation_pn/regles_emploi_pa": (_) =>
        PaReglesEmploiPaPage(),
    "/pa/libertes_publiques/quiz/introduction": (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizIntroductionPA(uid: user?.id ?? '', email: user?.email ?? '');
    },
    "/pa/mineurs_famille_pages/quiz/pa_quiz_mineurs_famille": (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizMineursFamillePA(
        uid: user?.id ?? '',
        email: user?.email ?? '',
      );
    },
    "/pa/nation/quiz/abus_autorite_particuliers": (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizAbusAutoritePA(uid: user?.id ?? '', email: user?.email ?? '');
    },
    "/pa/nation/quiz/atteintes_action_justice": (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizAtteinteActionJusticePA(
        uid: user?.id ?? '',
        email: user?.email ?? '',
      );
    },
    "/pa/nation/quiz/atteintes_administration": (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizAtteinteAdministrationPA(
        uid: user?.id ?? '',
        email: user?.email ?? '',
      );
    },
    "/pa/nation/quiz/faux_usage_faux": (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizFauxUsageFauxPA(uid: user?.id ?? '', email: user?.email ?? '');
    },
    "/pa/nation/quiz/probite": (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizProbitePA(uid: user?.id ?? '', email: user?.email ?? '');
    },
    "/pa/organisation_judiciaire/juge_instruction": (_) =>
        JugeInstructionPage(),
    "/pa/organisation_judiciaire/juridictions_penales": (_) =>
        JuridictionsPenalesPage(),
    "/pa/organisation_judiciaire/ministere_public": (_) =>
        MinisterePublicPage(),
    "/pa/organisation_judiciaire/structure": (_) => StructureJudiciairePage(),
    "/pa/organisation_judiciaire/voies_recours": (_) => VoiesRecoursPage(),
    "/pa/procedure_penale/quiz/action_publique": (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizActionPubliquePagePA(
        uid: user?.id ?? '',
        email: user?.email ?? '',
      );
    },
    "/pa/procedure_penale/quiz/bracelet_electronique": (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizBraceletElectroniquePagePA(
        uid: user?.id ?? '',
        email: user?.email ?? '',
      );
    },
    "/pa/procedure_penale/quiz/cadres_juridiques_principales": (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizCadresPrincipalesPagePA(
        uid: user?.id ?? '',
        email: user?.email ?? '',
      );
    },
    "/pa/procedure_penale/quiz/controle_judiciaire": (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizControleJudiciairePagePA(
        uid: user?.id ?? '',
        email: user?.email ?? '',
      );
    },
    "/pa/procedure_penale/quiz/detention_provisoire": (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizDetentionProvisoirePagePA(
        uid: user?.id ?? '',
        email: user?.email ?? '',
      );
    },
    "/pa/procedure_penale/quiz/dispositions_applicables_mineurs": (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizDispositionsApplicablesMineursPA(
        uid: user?.id ?? '',
        email: user?.email ?? '',
      );
    },
    "/pa/procedure_penale/quiz/generalité_principales": (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizGeneralitePagePA(
        uid: user?.id ?? '',
        email: user?.email ?? '',
      );
    },
    "/pa/procedure_penale/quiz/instruction_preparatoire": (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizInstructionPagePA(
        uid: user?.id ?? '',
        email: user?.email ?? '',
      );
    },
    "/pa/procedure_penale/quiz/juridictions_penales": (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizJuridictionsPagePA(
        uid: user?.id ?? '',
        email: user?.email ?? '',
      );
    },
    "/pa/procedure_penale/quiz/mandats_justice": (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizMandatsPagePA(uid: user?.id ?? '', email: user?.email ?? '');
    },
    "/pa/procedure_penale/quiz/nullite": (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizNullitePagePA(uid: user?.id ?? '', email: user?.email ?? '');
    },
    "/pa/sanction/quiz/sanction_causes_aggravation": (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizSanctionAggravationPA(
        uid: user?.id ?? '',
        email: user?.email ?? '',
      );
    },
    "/pa/sanction/quiz/sanction_classification_peine": (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizSanctionClassificationPA(
        uid: user?.id ?? '',
        email: user?.email ?? '',
      );
    },
    "/pa/sanction/quiz/sanction_page": (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizSanctionPA(uid: user?.id ?? '', email: user?.email ?? '');
    },
    "/pa/sanction/quiz/sanction_pluralite_infractions": (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizSanctionPluralitePA(
        uid: user?.id ?? '',
        email: user?.email ?? '',
      );
    },
    "/pa/stupéfiants_pages/quiz/pa_quiz_stupéfiants": (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizStupefiantPA(uid: user?.id ?? '', email: user?.email ?? '');
    },
  };
}
