// lib/routes/app_router.dart
//
// Part-file de la library copiqpolice_app (declaree dans main.dart).
// Les 819 imports sont dans main.dart et sont automatiquement disponibles ici.
// Pour ajouter une nouvelle route : ajoute l'import dans main.dart, puis
// ajoute l'entree dans RouteRegistry.routes ci-dessous.

part of 'package:copiqpolice/main.dart';

// =============================================================================
//                       AppAuthClientOptions (Supabase compat)
// =============================================================================

class AppAuthClientOptions {
  final bool autoRefreshToken;
  final bool? persistSession;
  final bool? detectSessionInUrl;
  const AppAuthClientOptions({
    this.autoRefreshToken = true,
    this.persistSession,
    this.detectSessionInUrl,
  });

  FlutterAuthClientOptions toFlutter() {
    return FlutterAuthClientOptions(autoRefreshToken: autoRefreshToken);
  }
}

extension GoTrueRecoverCompat on GoTrueClient {
  Future<void> recoverSessionFromStorage() async {
    try {
      final dyn = this as dynamic;
      if (dyn.recoverSessionFromStorage is Function) {
        await dyn.recoverSessionFromStorage();
        return;
      }
    } catch (_) {}
  }
}

/// ================== HELPERS SESSION ==================
Future<User?> _waitForSessionUser({
  Duration timeout = const Duration(seconds: 6),
}) async {
  final sb = Supabase.instance.client;
  final sw = Stopwatch()..start();
  var delay = const Duration(milliseconds: 120);

  while (sw.elapsed < timeout) {
    try {
      final u = sb.auth.currentUser;
      if (u != null) return u;
    } catch (_) {}
    await Future.delayed(delay);
    if (delay.inMilliseconds < 600) {
      delay += const Duration(milliseconds: 120);
    }
  }
  return null;
}

Future<bool> _ensureSessionHydrated({String origin = ''}) async {
  final sb = Supabase.instance.client;

  var u = await _waitForSessionUser();
  if (u != null) {
    await AppConsoleLogger.debug(
      'auth:session_hydrated',
      context: {'origin': origin, 'user_id': u.id},
    );
    return true;
  }

  await AppConsoleLogger.warn(
    'auth:session_missing_try_recover',
    context: {'origin': origin},
  );
  await sb.auth.recoverSessionFromStorage();

  u = await _waitForSessionUser(timeout: const Duration(seconds: 6));
  final ok = u != null;
  await AppConsoleLogger.debug(
    'auth:session_recover_result',
    context: {'origin': origin, 'ok': ok, 'user_id': u?.id},
  );
  return ok;
}

/// ================== ROUTE REGISTRY ==================

// =============================================================================
//                  appOnGenerateRoute (logique de redirection)
// =============================================================================

Route<dynamic>? appOnGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/signup':
      return MaterialPageRoute(
        builder: (context) => SignUpPage(
          onSignedUp: (String email, String password) async {
            if (context.mounted) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                ConfirmEmailPage.routeName,
                (r) => false,
                arguments: {'email': email, 'password': password},
              );
            }
            await AppConsoleLogger.info('nav:push', message: '/confirm-email');
          },
        ),
        settings: settings,
      );

    case '/login':
    case '/signin':
      return MaterialPageRoute(
        builder: (context) => SignInPage(
          onSignedIn: () async {
            await _ensureSessionHydrated(origin: 'signin');
            if (context.mounted) {
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil('/picker', (r) => false);
            }
            AppConsoleLogger.info('nav:push', message: '/picker (post-login)');
          },
        ),
        settings: settings,
      );

    case SavingScreen.routeName:
      final args = settings.arguments;
      final Map<String, dynamic> payload = (args is Map<String, dynamic>)
          ? args
          : const <String, dynamic>{};
      return MaterialPageRoute(
        builder: (_) => SavingScreen(payload: payload),
        settings: settings,
      );

    default:
      final builder = RouteRegistry.routes[settings.name];
      if (builder != null) {
        return MaterialPageRoute(builder: builder, settings: settings);
      }
      return MaterialPageRoute(
        builder: (_) => _NotFoundScreen(path: settings.name ?? 'Unknown'),
        settings: settings,
      );
  }
}

// ======= Palette LIGHT par défaut (cohérente avec le splash natif) =======

// =============================================================================
//                          RouteRegistry (map des routes)
// =============================================================================

class RouteRegistry {
  static final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
    '/discovery': (context) => const DiscoveryTutorialScreen(),
    '/onboarding': (context) => const OnboardingScreen(),
    '/welcome': (context) => const WelcomeAfterSignupPage(),
    '/placement-intro': (context) => const PlacementIntro(),
    '/placement': (context) => PlacementTest(onFinished: () {}),
    '/favoris': (_) => const FavorisHomePage(),
    '/institutions': (_) => const InstitutionPage(),
    '/procedure_penale': (_) => const ProcedurePenalePage(),
    '/picker': (_) => const ModePickerScreen(),
    "/abonnement": (_) => const AbonnementPage(),

    // ================== GPX : Généralités ==================
    '/gpx/generalites/classification_infractions': (_) =>
        const ClassificationInfractionsPage(),
    '/gpx/generalites/infraction': (_) => const InfractionPage(),
    // ================== GPX : School ==================
    '/home_pa_school': (_) => const HomePagePaSchool(),
    '/home-pa-exam': (_) => const HomePagePaExam(),
    '/home-gpx-exam': (_) => const HomePagePaExam(),
    '/home-bootstrap': (_) => const HomeBootstrap(),
    '/gpx/generalites/infraction_intro': (_) => const InfractionIntroPage(),
    '/gpx/generalites/infraction/contenu': (_) => const InfractionContenuPage(),
    '/gpx/generalites/infraction/element-legal': (_) =>
        const ElementLegalPage(),
    '/gpx/generalites/infraction/element-materiel': (_) =>
        const ElementMaterielPage(),
    '/gpx/generalites/infraction/element-moral': (_) =>
        const ElementMoralPage(),
    '/gpx/generalites/complicite/conditions': (_) =>
        const CompliciteConditionPage(),
    '/gpx/generalites/complicite/participation': (_) =>
        const CompliciteParticipationPage(),
    '/gpx/generalites/complicite/repression': (_) =>
        const CompliciteRepressionPage(),
    GpxExamCultureGeneralePage.routeName: (_) =>
        const GpxExamCultureGeneralePage(),
    ResetPasswordPage.routeName: (_) => const ResetPasswordPage(),
    AttentionVisuellePage.routeName: (_) => const AttentionVisuellePage(),
    GpxExamConcoursHomePage.routeName: (_) => const GpxExamConcoursHomePage(),
    GpxCasPratiqueCase6Page.routeName: (_) => const GpxCasPratiqueCase6Page(),
    GpxCasPratiqueCase5Page.routeName: (_) => const GpxCasPratiqueCase5Page(),
    GpxCasPratiqueCase4Page.routeName: (_) => const GpxCasPratiqueCase4Page(),
    GpxCasPratiqueCase3Page.routeName: (_) => const GpxCasPratiqueCase3Page(),
    GpxCasPratiqueCase1Page.routeName: (_) => const GpxCasPratiqueCase1Page(),
    GpxCasPratiqueListPage.routeName: (_) => const GpxCasPratiqueListPage(),
    GpxCasPratiqueEtapesReussitePage.routeName: (_) =>
        const GpxCasPratiqueEtapesReussitePage(),
    GpxCasPratiqueEntrainementWelcomePage.routeName: (_) =>
        const GpxCasPratiqueEntrainementWelcomePage(),
    GPXAdmissionPage.routeName: (_) => const GPXAdmissionPage(),
    GPXAdmissibilitePage.routeName: (_) => const GPXAdmissibilitePage(),
    TableauRecapitulatifEpreuvesGPXPage.routeName: (_) =>
        const TableauRecapitulatifEpreuvesGPXPage(),
    PvIpmRemiseTiersPage.routeName: (_) => const PvIpmRemiseTiersPage(),
    PvIpmExamenMedicalPage.routeName: (_) => const PvIpmExamenMedicalPage(),
    IpmGeneralitesPage.routeName: (_) => const IpmGeneralitesPage(),
    TableauVitessesPage.routeName: (_) => const TableauVitessesPage(),
    GrandExcesVitesseGPXPage.routeName: (_) => const GrandExcesVitesseGPXPage(),
    RefusVerificationsGPXPage.routeName: (_) =>
        const RefusVerificationsGPXPage(),
    ConduitePosteDepistagesPositifsOuRefusPage.routeName: (_) =>
        const ConduitePosteDepistagesPositifsOuRefusPage(),
    RequisitionExamenCliniquePrelevementExpertisePage.routeName: (_) =>
        const RequisitionExamenCliniquePrelevementExpertisePage(),
    FicheSuiviSanguinePage.routeName: (_) => const FicheSuiviSanguinePage(),
    PrelevementSanguinEtablirUsagePage.routeName: (_) =>
        const PrelevementSanguinEtablirUsagePage(),
    SuitePrelevementSanguinPage.routeName: (_) =>
        const SuitePrelevementSanguinPage(),
    FormulaireInformationPage.routeName: (_) =>
        const FormulaireInformationPage(),
    FicheSuiviSalivairePage.routeName: (_) => const FicheSuiviSalivairePage(),
    VerificationsEtablirUsageStupefiantsPage.routeName: (_) =>
        const VerificationsEtablirUsageStupefiantsPage(),
    ConduitePosteDepistagePositifOuRefusPage.routeName: (_) =>
        const ConduitePosteDepistagePositifOuRefusPage(),
    StupefiantsGeneralitesPage.routeName: (_) =>
        const StupefiantsGeneralitesPage(),
    FichesAbcPage.routeName: (_) => const FichesAbcPage(),
    RequisitionExamenCliniquePrelevementPage.routeName: (_) =>
        const RequisitionExamenCliniquePrelevementPage(),
    PrelevementSanguinPage.routeName: (_) => const PrelevementSanguinPage(),
    VerificationTauxCeiPage.routeName: (_) => const VerificationTauxCeiPage(),
    VerificationNotificationTauxCeeaPage.routeName: (_) =>
        const VerificationNotificationTauxCeeaPage(),
    TableauTauxPage.routeName: (_) => const TableauTauxPage(),
    InterpellationEtatIvressePage.routeName: (_) =>
        const InterpellationEtatIvressePage(),
    ConduitePosteCeeaPositifOuRefusPage.routeName: (_) =>
        const ConduitePosteCeeaPositifOuRefusPage(),
    AsControleAlcoolemiePage.routeName: (_) => const AsControleAlcoolemiePage(),
    CIControleSejourCirculationPage.routeName: (_) =>
        const CIControleSejourCirculationPage(),
    ControleSejourCirculationPage.routeName: (_) =>
        const ControleSejourCirculationPage(),
    EtrangersGeneralitesPage.routeName: (_) => const EtrangersGeneralitesPage(),
    ConfrontationVictimeSuspectLibreEmprisonnementPage.routeName: (_) =>
        const ConfrontationVictimeSuspectLibreEmprisonnementPage(),
    ConfrontationVictimeGavPage.routeName: (_) =>
        const ConfrontationVictimeGavPage(),
    ConfrontationGeneralitesPage.routeName: (_) =>
        const ConfrontationGeneralitesPage(),
    RapportRequisitionPersonnePage.routeName: (_) =>
        const RapportRequisitionPersonnePage(),
    RequisitionPersonnePage.routeName: (_) => const RequisitionPersonnePage(),
    RequisitionsGeneralitesPage.routeName: (_) =>
        const RequisitionsGeneralitesPage(),
    FouilleVehiculePreliminairePage.routeName: (_) =>
        const FouilleVehiculePreliminairePage(),
    PerquisitionPreliminairePerquisitionPage.routeName: (_) =>
        const PerquisitionPreliminairePerquisitionPage(),
    PerquisitionPreliminaireGeneralitesPage.routeName: (_) =>
        const PerquisitionPreliminaireGeneralitesPage(),
    CivilementResponsableGeneralitesCanevasPage.routeName: (_) =>
        const CivilementResponsableGeneralitesCanevasPage(),
    CivilementResponsableGeneralitesPage.routeName: (_) =>
        const CivilementResponsableGeneralitesPage(),
    AuditionLibreNotificationDroitsSansEmprisonnementPage.routeName: (_) =>
        const AuditionLibreNotificationDroitsSansEmprisonnementPage(),
    AuditionSuspectLibrePage.routeName: (_) => const AuditionSuspectLibrePage(),
    AuditionGavPage.routeName: (_) => const AuditionGavPage(),
    AuditionSuspectGeneralitesPage.routeName: (_) =>
        const AuditionSuspectGeneralitesPage(),
    EntretienGavAvocatPage.routeName: (_) => const EntretienGavAvocatPage(),
    AvocatGeneralitesPage.routeName: (_) => const AvocatGeneralitesPage(),
    NotificationDroitsArticle65CPPPage.routeName: (_) =>
        const NotificationDroitsArticle65CPPPage(),
    NotificationAuditionLibreSansEmprisonnementPage.routeName: (_) =>
        const NotificationAuditionLibreSansEmprisonnementPage(),
    RecherchesInfructueusesMandatPage.routeName: (_) =>
        const RecherchesInfructueusesMandatPage(),
    NotificationGavDroitsApjPage.routeName: (_) =>
        const NotificationGavDroitsApjPage(),
    SuspectLibreGeneralitesPage.routeName: (_) =>
        const SuspectLibreGeneralitesPage(),
    NotificationDroitsSuspectMajeurEmprisonnementPage.routeName: (_) =>
        const NotificationDroitsSuspectMajeurEmprisonnementPage(),
    GavGeneralitesPage.routeName: (_) => const GavGeneralitesPage(),
    CompteRenduOPJPage.routeName: (_) => const CompteRenduOPJPage(),
    NotificationMandatPage.routeName: (_) => const NotificationMandatPage(),
    MandatsPage.routeName: (_) => const MandatsPage(),
    ConduiteAuPostePage.routeName: (_) => const ConduiteAuPostePage(),
    PVInterpellationPage.routeName: (_) => const PVInterpellationPage(),
    PVCIDecouverteArmePage.routeName: (_) => const PVCIDecouverteArmePage(),
    InterpellationGeneralitesPage.routeName: (_) =>
        const InterpellationGeneralitesPage(),
    PvCiFicheRecherchePage.routeName: (_) => const PvCiFicheRecherchePage(),
    PvControleIdentitePage.routeName: (_) => const PvControleIdentitePage(),
    ControleIdentiteGeneralitesPage.routeName: (_) =>
        const ControleIdentiteGeneralitesPage(),
    AuditionTemoinsPage.routeName: (_) => const AuditionTemoinsPage(),
    EnqueteVoisinagePage.routeName: (_) => const EnqueteVoisinagePage(),
    TemoignageGeneralitesPage.routeName: (_) =>
        const TemoignageGeneralitesPage(),
    DocumentInfoSynthetiquePage.routeName: (_) =>
        const DocumentInfoSynthetiquePage(),
    LeveeDouteAgressionArmeePage.routeName: (_) =>
        const LeveeDouteAgressionArmeePage(),
    AgressionArmeeCrapuleuxPage.routeName: (_) =>
        const AgressionArmeeCrapuleuxPage(),
    PVPvSaisinePersonneInconnuePage.routeName: (_) =>
        const PVPvSaisinePersonneInconnuePage(),
    PVPvSaisinePersonneDenommeePage.routeName: (_) =>
        const PVPvSaisinePersonneDenommeePage(),
    PVPvSaisinePersonneDenommeeSuitePage.routeName: (_) =>
        const PVPvSaisinePersonneDenommeeSuitePage(),
    PresentationGrilleDangerPage.routeName: (_) =>
        const PresentationGrilleDangerPage(),
    PVVictimeViolencesConjugalesPage.routeName: (_) =>
        const PVVictimeViolencesConjugalesPage(),
    ConstatationsGeneralitesPage.routeName: (_) =>
        const ConstatationsGeneralitesPage(),
    CanevasPVConstatationsPage.routeName: (_) =>
        const CanevasPVConstatationsPage(),
    PVPvSaisineCxPage.routeName: (_) => const PVPvSaisineCxPage(),
    PVPlainteGeneralitesPage.routeName: (_) => const PVPlainteGeneralitesPage(),
    PVEtatCivilPage.routeName: (_) => const PVEtatCivilPage(),
    PVProcesVerbauxPage.routeName: (_) => const PVProcesVerbauxPage(),
    PVProcedurePage.routeName: (_) => const PVProcedurePage(),
    PVPreambulePage.routeName: (_) => const PVPreambulePage(),
    PlanVigipiratePage.routeName: (_) => const PlanVigipiratePage(),
    ViolationBarPage.routeName: (_) => const ViolationBarPage(),
    AlarmeEtablissementPage.routeName: (_) => const AlarmeEtablissementPage(),
    IncendiePrimoPage.routeName: (_) => const IncendiePrimoPage(),
    SinistrePage.routeName: (_) => const SinistrePage(),
    ChiensCategoriesPage.routeName: (_) => const ChiensCategoriesPage(),
    ProtocoleMorsurePage.routeName: (_) => const ProtocoleMorsurePage(),
    ChienDangereuxPage.routeName: (_) => const ChienDangereuxPage(),
    MaltraitanceAnimalePage.routeName: (_) => const MaltraitanceAnimalePage(),
    SoinsSansConsentementPage.routeName: (_) =>
        const SoinsSansConsentementPage(),
    IntervenirMaladesMentauxPage.routeName: (_) =>
        const IntervenirMaladesMentauxPage(),
    ControleDebitsBoissonsPage.routeName: (_) =>
        const ControleDebitsBoissonsPage(),
    InterventionDebitBoissonsPage.routeName: (_) =>
        const InterventionDebitBoissonsPage(),
    AmendeForfaitaireDelictuelleStupPage.routeName: (_) =>
        const AmendeForfaitaireDelictuelleStupPage(),
    AnnoncerMauvaiseNouvellePage.routeName: (_) =>
        const AnnoncerMauvaiseNouvellePage(),
    AvisFamillePage.routeName: (_) => const AvisFamillePage(),
    TableauSynthesePage.routeName: (_) => const TableauSynthesePage(),
    RenseignementsARecueillirPage.routeName: (_) =>
        const RenseignementsARecueillirPage(),
    ModelesPlanPage.routeName: (_) => const ModelesPlanPage(),
    PlanLieuxTechniquePage.routeName: (_) => const PlanLieuxTechniquePage(),
    ProtectionMineursVoiePubliquePage.routeName: (_) =>
        const ProtectionMineursVoiePubliquePage(),
    StatutJuridiqueMineurPage.routeName: (_) =>
        const StatutJuridiqueMineurPage(),
    FicheDescriptiveFourrierePage.routeName: (_) =>
        const FicheDescriptiveFourrierePage(),
    TitresSejourPage.routeName: (_) => const TitresSejourPage(),
    CooperationUEPage.routeName: (_) => const CooperationUEPage(),
    AccordSchengenPage.routeName: (_) => const AccordSchengenPage(),
    FicheImmobilisationPage.routeName: (_) => const FicheImmobilisationPage(),
    AvisRetentionPermisPage.routeName: (_) => const AvisRetentionPermisPage(),
    PlansOrsecPage.routeName: (_) => const PlansOrsecPage(),
    IvressePubliqueManifestePage.routeName: (_) =>
        const IvressePubliqueManifestePage(),
    IdentificationDetectionProduitsSuspectsPage.routeName: (_) =>
        const IdentificationDetectionProduitsSuspectsPage(),
    AlertesALaBombePage.routeName: (_) => const AlertesALaBombePage(),
    ViolencesConjugalesPage.routeName: (_) => const ViolencesConjugalesPage(),
    BruitsTapagesPage.routeName: (_) => const BruitsTapagesPage(),
    ConduiteVehiculesPolicePage.routeName: (_) =>
        const ConduiteVehiculesPolicePage(),
    PrimoSceneInfractionAmarisPage.routeName: (_) =>
        const PrimoSceneInfractionAmarisPage(),
    SignauxSonoresLumineuxPage.routeName: (_) =>
        const SignauxSonoresLumineuxPage(),
    SignalementDescriptifPage.routeName: (_) =>
        const SignalementDescriptifPage(),
    DifferendFamilialPage.routeName: (_) => const DifferendFamilialPage(),
    EnregistrementDiffusionImagesParolesPage.routeName: (_) =>
        const EnregistrementDiffusionImagesParolesPage(),
    SyntheseIndicateursBasculementPage.routeName: (_) =>
        const SyntheseIndicateursBasculementPage(),
    TypesAccidentsCirculationPage.routeName: (_) =>
        const TypesAccidentsCirculationPage(),
    RegulationCirculationPage.routeName: (_) =>
        const RegulationCirculationPage(),
    ViolationDomicilePage.routeName: (_) => const ViolationDomicilePage(),
    SecuriteTrajetLieuxPage.routeName: (_) => const SecuriteTrajetLieuxPage(),
    MenottagePage.routeName: (_) => const MenottagePage(),
    PalpationSecuritePage.routeName: (_) => const PalpationSecuritePage(),
    EquipementsSecuritePage.routeName: (_) => const EquipementsSecuritePage(),
    UtiliteCameraPietonPage.routeName: (_) => const UtiliteCameraPietonPage(),
    CameraPietonPage.routeName: (_) => const CameraPietonPage(),
    InterrogationFprPage.routeName: (_) => const InterrogationFprPage(),
    PrincipauxFichiersPage.routeName: (_) => const PrincipauxFichiersPage(),
    MemoTph900Page.routeName: (_) => const MemoTph900Page(),
    ProcedureRadioPage.routeName: (_) => const ProcedureRadioPage(),
    CommunicationRadioPage.routeName: (_) => const CommunicationRadioPage(),
    PatrouillePatrouillePage.routeName: (_) => const PatrouillePatrouillePage(),
    PriseServiceRisqueEvasionFuitePage.routeName: (_) =>
        const PriseServiceRisqueEvasionFuitePage(),
    PriseServiceGardeAVuePage.routeName: (_) =>
        const PriseServiceGardeAVuePage(),
    PriseServiceFouilleIntegralePage.routeName: (_) =>
        const PriseServiceFouilleIntegralePage(),
    PriseServiceApplicationsPage.routeName: (_) =>
        const PriseServiceApplicationsPage(),
    PriseServiceRegistresPage.routeName: (_) =>
        const PriseServiceRegistresPage(),
    PriseServiceAppelPage.routeName: (_) => const PriseServiceAppelPage(),
    EssuieGlacePage.routeName: (_) => const EssuieGlacePage(),
    PrincipesGenerauxCirculationPage.routeName: (_) =>
        const PrincipesGenerauxCirculationPage(),
    GiletHauteVisibilitePage.routeName: (_) => const GiletHauteVisibilitePage(),
    CasqueGantsPage.routeName: (_) => const CasqueGantsPage(),
    CasqueCyclistePage.routeName: (_) => const CasqueCyclistePage(),
    CeintureRetenueEnfantPage.routeName: (_) =>
        const CeintureRetenueEnfantPage(),
    NuisancesVehiculesPage.routeName: (_) => const NuisancesVehiculesPage(),
    RetroviseursVisionPage.routeName: (_) => const RetroviseursVisionPage(),
    ControleTechniquePage.routeName: (_) => const ControleTechniquePage(),
    PneumatiquesPage.routeName: (_) => const PneumatiquesPage(),
    PlaquesPage.routeName: (_) => const PlaquesPage(),
    ChargementPage.routeName: (_) => const ChargementPage(),
    BsrPage.routeName: (_) => const BsrPage(),
    EclairageSignalisationPage.routeName: (_) =>
        const EclairageSignalisationPage(),
    AssuranceObligatoirePage.routeName: (_) => const AssuranceObligatoirePage(),
    CertificatImmatriculationPage.routeName: (_) =>
        const CertificatImmatriculationPage(),
    PermisConduirePage.routeName: (_) => const PermisConduirePage(),
    CadreLegalControleRoutierPage.routeName: (_) =>
        const CadreLegalControleRoutierPage(),
    PermisAPointsPage.routeName: (_) => const PermisAPointsPage(),
    RetentionPermisConduirePage.routeName: (_) =>
        const RetentionPermisConduirePage(),
    ConduiteApresUsageStupefiantsPage.routeName: (_) =>
        const ConduiteApresUsageStupefiantsPage(),
    ConduiteAlcoolPage.routeName: (_) => const ConduiteAlcoolPage(),
    MiseEnFourrierePage.routeName: (_) => const MiseEnFourrierePage(),
    ImmobilisationPage.routeName: (_) => const ImmobilisationPage(),
    ConsignationPage.routeName: (_) => const ConsignationPage(),
    AmendeForfaitairePage.routeName: (_) => const AmendeForfaitairePage(),
    AmendeForfaitaireDelictuellePage.routeName: (_) =>
        const AmendeForfaitaireDelictuellePage(),
    HistoireReperesPage.routeName: (_) => const HistoireReperesPage(),
    RitesCultesFrancePage.routeName: (_) => const RitesCultesFrancePage(),
    CharteLaiciteServicesPublicsPage.routeName: (_) =>
        const CharteLaiciteServicesPublicsPage(),
    GpxLaiciteDlpajPage.routeName: (_) => const GpxLaiciteDlpajPage(),
    ProtectionLocauxPolicePage.routeName: (_) =>
        const ProtectionLocauxPolicePage(),
    DemarchesAdministrativesPage.routeName: (_) =>
        const DemarchesAdministrativesPage(),
    GpxDoctrineAccueilVictimesVcPage.routeName: (_) =>
        const GpxDoctrineAccueilVictimesVcPage(),
    ReferentielMariannePage.routeName: (_) => const ReferentielMariannePage(),
    CharteAccueilPublicVictimesPage.routeName: (_) =>
        const CharteAccueilPublicVictimesPage(),
    ModelesRapportsPage.routeName: (_) => const ModelesRapportsPage(),
    CompteRenduPage.routeName: (_) => const CompteRenduPage(),
    FormalismeRapportPage.routeName: (_) => const FormalismeRapportPage(),
    EnqueteAdministrativePage.routeName: (_) =>
        const EnqueteAdministrativePage(),
    ReseauxSociauxPage.routeName: (_) => const ReseauxSociauxPage(),
    SanctionsRecompensesPage.routeName: (_) => const SanctionsRecompensesPage(),
    HorsServiceAmarisPage.routeName: (_) => const HorsServiceAmarisPage(),
    HomePage.routeName: (context) => const HomePage(),
    HomePageGpxSchool.routeName: (context) => const HomePageGpxSchool(),
    HomePagePaSchool.routeName: (context) => const HomePagePaSchool(),
    HomePagePaExam.routeName: (context) => const HomePagePaExam(),
    HomePageGpxExam.routeName: (context) => const HomePageGpxExam(),
    GpxSchoolArt.routeName: (_) => const GpxSchoolArt(),
    DroitsObligationsPoliciersPage.routeName: (_) =>
        const DroitsObligationsPoliciersPage(),
    MarquesExterieuresRespectPage.routeName: (_) =>
        const MarquesExterieuresRespectPage(),
    ParametreHomePage.routeName: (context) => const ParametreHomePage(),
    ReserveAccueilPage.routeName: (context) => const ReserveAccueilPage(),
    TentativeIntroPage.routeName: (_) => const TentativeIntroPage(),
    RepressionTentativePage.routeName: (_) => const RepressionTentativePage(),
    InfructueuseTentativePage.routeName: (_) =>
        const InfructueuseTentativePage(),
    TentativeContenuPage.routeName: (_) => const TentativeContenuPage(),
    CompliciteIntroPage.routeName: (_) => const CompliciteIntroPage(),
    CompliciteContenuPage.routeName: (_) => const CompliciteContenuPage(),
    CompliciteConditionPage.routeName: (_) => const CompliciteConditionPage(),
    ConditionTentativePage.routeName: (_) => const ConditionTentativePage(),
    LegitimeDefenseIntroPage.routeName: (_) => const LegitimeDefenseIntroPage(),
    LdContenuPage.routeName: (_) => const LdContenuPage(),
    UsageArmesIntroPage.routeName: (_) => const UsageArmesIntroPage(),
    UsageArmesPage.routeName: (_) => const UsageArmesPage(),
    LibertesPubliquesIntroPage.routeName: (_) =>
        const LibertesPubliquesIntroPage(),
    LibertesPubliquesContenuPage.routeName: (_) =>
        const LibertesPubliquesContenuPage(),
    AgentsVerbalisateursCirculationPage.routeName: (_) =>
        const AgentsVerbalisateursCirculationPage(),

    CrimePage.routeName: (_) => const CrimePage(),
    DelitPage.routeName: (_) => const DelitPage(),
    ContraventionPage.routeName: (_) => const ContraventionPage(),
    RetentionLocauxIntroPage.routeName: (_) => const RetentionLocauxIntroPage(),
    RetentionLocauxContenuPage.routeName: (_) =>
        const RetentionLocauxContenuPage(),
    RetentionPrincipesPage.routeName: (_) => const RetentionPrincipesPage(),
    RetentionMesuresAdminPage.routeName: (_) =>
        const RetentionMesuresAdminPage(),
    ClassificationInfractionsPage.routeName: (_) =>
        const ClassificationInfractionsPage(),
    HierarchieIntroPage.routeName: (_) => const HierarchieIntroPage(),
    HierarchieContenuPage.routeName: (_) => const HierarchieContenuPage(),
    HierarchieOpjPage.routeName: (_) => const HierarchieOpjPage(),
    HierarchieApjPage.routeName: (_) => const HierarchieApjPage(),
    HierarchieApjaPage.routeName: (_) => const HierarchieApjaPage(),
    HierarchieIntroStructurePage.routeName: (_) =>
        const HierarchieIntroStructurePage(),
    HierarchieAssistantsEnquetePage.routeName: (_) =>
        const HierarchieAssistantsEnquetePage(),
    JuridictionIntroPage.routeName: (_) => const JuridictionIntroPage(),
    JuridictionContenuPage.routeName: (_) => const JuridictionContenuPage(),
    JuridictionsPrincipesGenerauxPage.routeName: (_) =>
        const JuridictionsPrincipesGenerauxPage(),
    EmbuscadePage.routeName: (_) => const EmbuscadePage(),
    AppelsMessagesMalveillantsAgressionsSonoresPage.routeName: (_) =>
        const AppelsMessagesMalveillantsAgressionsSonoresPage(),
    MenacesAvecConditionPage.routeName: (_) => const MenacesAvecConditionPage(),
    TorturesActesBarbariePage.routeName: (_) =>
        const TorturesActesBarbariePage(),
    ViolencesHabituellesCoupleExPage.routeName: (_) =>
        const ViolencesHabituellesCoupleExPage(),
    ViolencesHabituellesMineurVulnerablePage.routeName: (_) =>
        const ViolencesHabituellesMineurVulnerablePage(),
    ViolencesSurFsiPage.routeName: (_) => const ViolencesSurFsiPage(),
    AutoriteParentalePage.routeName: (_) => const AutoriteParentalePage(),
    AbandonFamillePage.routeName: (_) => const AbandonFamillePage(),
    CorruptionMineurPage.routeName: (_) => const CorruptionMineurPage(),
    DiffusionMessageViolentMineurPage.routeName: (_) =>
        const DiffusionMessageViolentMineurPage(),
    PrivationAlimentsSoinsMineur15Page.routeName: (_) =>
        const PrivationAlimentsSoinsMineur15Page(),
    ProvocationPedopornographiePage.routeName: (_) =>
        const ProvocationPedopornographiePage(),
    ProvocationDirecteMineurCrimeDelitPage.routeName: (_) =>
        const ProvocationDirecteMineurCrimeDelitPage(),
    ProvocationMineurAlcoolPage.routeName: (_) =>
        const ProvocationMineurAlcoolPage(),
    ProvocationMineurStupefiantsPage.routeName: (_) =>
        const ProvocationMineurStupefiantsPage(),
    SoustractionParentObligationsLegalesPage.routeName: (_) =>
        const SoustractionParentObligationsLegalesPage(),
    AtteintesSexuellesMajeurMineur15Page.routeName: (_) =>
        const AtteintesSexuellesMajeurMineur15Page(),
    AtteintesSexuellesMajeurMineurPlus15Page.routeName: (_) =>
        const AtteintesSexuellesMajeurMineurPlus15Page(),
    ExploitationImagePornoMineurPage.routeName: (_) =>
        const ExploitationImagePornoMineurPage(),
    PropositionsSexuellesMineur15EnLignePage.routeName: (_) =>
        const PropositionsSexuellesMineur15EnLignePage(),
    NonRespectObligationsInterdictionsOrdonnanceProtectionPage.routeName: (_) =>
        const NonRespectObligationsInterdictionsOrdonnanceProtectionPage(),
    SoustractionEnfantMineurParAscendantPage.routeName: (_) =>
        const SoustractionEnfantMineurParAscendantPage(),
    SoustractionEnfantMineurSansFraudePage.routeName: (_) =>
        const SoustractionEnfantMineurSansFraudePage(),
    DefautNotificationTransfertPage.routeName: (_) =>
        const DefautNotificationTransfertPage(),
    AbandonDeFamillePage.routeName: (_) => const AbandonDeFamillePage(),
    AssociationMalfaiteursPage.routeName: (_) =>
        const AssociationMalfaiteursPage(),
    AtteintesSecretCorrespondancesPage.routeName: (_) =>
        const AtteintesSecretCorrespondancesPage(),
    DiscriminationsAbusAutoritePage.routeName: (_) =>
        const DiscriminationsAbusAutoritePage(),
    NonDenonciationCrimePage.routeName: (_) => const NonDenonciationCrimePage(),
    TemoignageMensongerContenuPage.routeName: (_) =>
        const TemoignageMensongerContenuPage(),
    AtteintesAdministrationContenuPage.routeName: (_) =>
        const AtteintesAdministrationContenuPage(),
    ProvocationDirecteRebellionPage.routeName: (_) =>
        const ProvocationDirecteRebellionPage(),
    RebellionPage.routeName: (_) => const RebellionPage(),
    MenacesEnversDepositaireAutoritePage.routeName: (_) =>
        const MenacesEnversDepositaireAutoritePage(),
    MenacesViolencesIntimidationDerogationServicePublicPage.routeName: (_) =>
        const MenacesViolencesIntimidationDerogationServicePublicPage(),
    FauxUsageFauxContenuPage.routeName: (_) => const FauxUsageFauxContenuPage(),
    DelivranceIndueDocumentAdministratifPage.routeName: (_) =>
        const DelivranceIndueDocumentAdministratifPage(),
    FauxDocumentAdministratifPage.routeName: (_) =>
        const FauxDocumentAdministratifPage(),
    FauxEcriturePubliqueOuAuthentiquePage.routeName: (_) =>
        const FauxEcriturePubliqueOuAuthentiquePage(),
    FauxCertificatsOuAttestationsPage.routeName: (_) =>
        const FauxCertificatsOuAttestationsPage(),
    FauxEtUsageDeFauxPage.routeName: (_) => const FauxEtUsageDeFauxPage(),
    ObtentionIndueDocumentAdministratifPage.routeName: (_) =>
        const ObtentionIndueDocumentAdministratifPage(),
    ConcussionPage.routeName: (_) => const ConcussionPage(),
    CorruptionPage.routeName: (_) => const CorruptionPage(),
    TraficInfluencePage.routeName: (_) => const TraficInfluencePage(),
    StadContenuPage.routeName: (_) => const StadContenuPage(),
    AccesMaintienFrauduleuxStadPage.routeName: (_) =>
        const AccesMaintienFrauduleuxStadPage(),
    AssociationMalfaiteursInformatiquePage.routeName: (_) =>
        const AssociationMalfaiteursInformatiquePage(),
    DonneesAdapteesCommettreInfractionsPage.routeName: (_) =>
        const DonneesAdapteesCommettreInfractionsPage(),
    IntroductionSuppressionModificationDonneesPage.routeName: (_) =>
        const IntroductionSuppressionModificationDonneesPage(),
    ContrefaconsFalsificationsChequesPage.routeName: (_) =>
        const ContrefaconsFalsificationsChequesPage(),
    DestructionsDegradationsContenuPage.routeName: (_) =>
        const DestructionsDegradationsContenuPage(),
    DetentionTransportSubstancesPreparationPage.routeName: (_) =>
        const DetentionTransportSubstancesPreparationPage(),
    DetentionTransportSansMotifLegitimePage.routeName: (_) =>
        const DetentionTransportSansMotifLegitimePage(),
    DiffusionProcedesFabricationEnginsDestructionPage.routeName: (_) =>
        const DiffusionProcedesFabricationEnginsDestructionPage(),
    DestructionsDangereusesPersonnesIntentionnellePage.routeName: (_) =>
        const DestructionsDangereusesPersonnesIntentionnellePage(),
    DestructionsDangereusesPersonnesNonIntentionnellePage.routeName: (_) =>
        const DestructionsDangereusesPersonnesNonIntentionnellePage(),
    SansDangerDommageImportantPage.routeName: (_) =>
        const SansDangerDommageImportantPage(),
    SansDangerDommageLegerPage.routeName: (_) =>
        const SansDangerDommageLegerPage(),
    TagsInscriptionsSignesDessinsPage.routeName: (_) =>
        const TagsInscriptionsSignesDessinsPage(),
    BiensCulturelsPublicsClassesPage.routeName: (_) =>
        const BiensCulturelsPublicsClassesPage(),
    FaussesAlertesPage.routeName: (_) => const FaussesAlertesPage(),
    MenacesAvecConditionPageGPXSchool.routeName: (_) =>
        const MenacesAvecConditionPageGPXSchool(),
    MenacesSansConditionPage.routeName: (_) => const MenacesSansConditionPage(),
    VoisinesDuVolContenuPage.routeName: (_) => const VoisinesDuVolContenuPage(),
    DemandeFondsSousContraintePage.routeName: (_) =>
        const DemandeFondsSousContraintePage(),
    AbusDeConfiancePage.routeName: (_) => const AbusDeConfiancePage(),
    ChantagePage.routeName: (_) => const ChantagePage(),
    FilouteriesPage.routeName: (_) => const FilouteriesPage(),
    EscroqueriePage.routeName: (_) => const EscroqueriePage(),
    ExtorsionPage.routeName: (_) => const ExtorsionPage(),
    ConduiteStupefiantsPage.routeName: (_) => const ConduiteStupefiantsPage(),
    IvressePage.routeName: (_) => const IvressePage(),
    EtatAlcooliquePage.routeName: (_) => const EtatAlcooliquePage(),
    DefautAssurancePage.routeName: (_) => const DefautAssurancePage(),
    DefautPermisPage.routeName: (_) => const DefautPermisPage(),
    DelitFuitePage.routeName: (_) => const DelitFuitePage(),
    GrandExcesVitessePage.routeName: (_) => const GrandExcesVitessePage(),
    RefusVerificationsPage.routeName: (_) => const RefusVerificationsPage(),
    RefusObtempererPage.routeName: (_) => const RefusObtempererPage(),
    RodeoMotorisePage.routeName: (_) => const RodeoMotorisePage(),
    PlaquesInscriptionsPage.routeName: (_) => const PlaquesInscriptionsPage(),
    IncitationOrganisationPromotionPage.routeName: (_) =>
        const IncitationOrganisationPromotionPage(),
    ArmesIntroductionPage.routeName: (_) => const ArmesIntroductionPage(),
    FormationInitialePolicierAdjointPage.routeName: (_) =>
        const FormationInitialePolicierAdjointPage(),
    MementoPriseDeNotesMethodologiePage.routeName: (_) =>
        const MementoPriseDeNotesMethodologiePage(),
    OrganigrammeMinistereInterieurPage.routeName: (_) =>
        const OrganigrammeMinistereInterieurPage(),
    OrganisationPoliceNationalePage.routeName: (_) =>
        const OrganisationPoliceNationalePage(),
    DgsiPage.routeName: (_) => const DgsiPage(),
    PrefecturePolicePage.routeName: (_) => const PrefecturePolicePage(),
    OrganigrammesPnPage.routeName: (_) => const OrganigrammesPnPage(),
    HierarchiePnPage.routeName: (_) => const HierarchiePnPage(),
    ReglesEmploiPaPage.routeName: (_) => const ReglesEmploiPaPage(),
    HorairesServiceSpPage.routeName: (_) => const HorairesServiceSpPage(),
    CrimePage.routeName: (_) => const CrimePage(),
    DelitPage.routeName: (_) => const DelitPage(),
    ContraventionPage.routeName: (_) => const ContraventionPage(),
    CodeDeontologieCodeCommentePage.routeName: (_) =>
        const CodeDeontologieCodeCommentePage(),
    ClassificationInfractionsContenuPage.routeName: (_) =>
        const ClassificationInfractionsContenuPage(),
    CadresEnqueteIntroPage.routeName: (_) => const CadresEnqueteIntroPage(),
    CadresEnqueteContenuPage.routeName: (_) => const CadresEnqueteContenuPage(),
    FlagrantDelitIntroPage.routeName: (_) => const FlagrantDelitIntroPage(),
    FlagrantDelitContenuPage.routeName: (_) => const FlagrantDelitContenuPage(),
    FlagrantDelitPanoramaPage.routeName: (_) =>
        const FlagrantDelitPanoramaPage(),
    FlagrantDelitNotionPage.routeName: (_) => const FlagrantDelitNotionPage(),
    FlagrantDelitDomainePage.routeName: (_) => const FlagrantDelitDomainePage(),
    FlagrantDelitProcedurePage.routeName: (_) =>
        const FlagrantDelitProcedurePage(),
    EnquetePreliminaireIntroPage.routeName: (_) =>
        const EnquetePreliminaireIntroPage(),
    EnquetePreliminaireContenuPage.routeName: (_) =>
        const EnquetePreliminaireContenuPage(),
    EnquetePreliminaireChapitre1DomainePage.routeName: (_) =>
        const EnquetePreliminaireChapitre1DomainePage(),
    EnquetePreliminaireChapitre2ProcedurePage.routeName: (_) =>
        const EnquetePreliminaireChapitre2ProcedurePage(),
    EnquetePreliminaireConstatationsRequisitionsPage.routeName: (_) =>
        const EnquetePreliminaireConstatationsRequisitionsPage(),
    EnquetePreliminaireFouillesPage.routeName: (_) =>
        const EnquetePreliminaireFouillesPage(),
    EnquetePrelimGardeAVuePage.routeName: (_) =>
        const EnquetePrelimGardeAVuePage(),
    EnquetePrelimSaisieComptesBancairesPage.routeName: (_) =>
        const EnquetePrelimSaisieComptesBancairesPage(),
    CommissionRogatoireIntroPage.routeName: (_) =>
        const CommissionRogatoireIntroPage(),
    CommissionRogatoireContenuPage.routeName: (_) =>
        const CommissionRogatoireContenuPage(),
    CommissionRogatoireChapitre1Page.routeName: (_) =>
        const CommissionRogatoireChapitre1Page(),
    CommissionRogatoireChapitre2Page.routeName: (_) =>
        const CommissionRogatoireChapitre2Page(),
    CommissionRogatoireChapitre3Page.routeName: (_) =>
        const CommissionRogatoireChapitre3Page(),
    PerquisitionsFouillesPage.routeName: (_) =>
        const PerquisitionsFouillesPage(),
    SaisiesScellesPage.routeName: (_) => const SaisiesScellesPage(),
    MandatRecherchePage.routeName: (_) => const MandatRecherchePage(),
    GardeAVuePage.routeName: (_) => const GardeAVuePage(),
    RequisitionsPage.routeName: (_) => const RequisitionsPage(),
    ViolationControleJudiciairePage.routeName: (_) =>
        const ViolationControleJudiciairePage(),
    PersonneBlesseGrievementntroPage.routeName: (_) =>
        const PersonneBlesseGrievementntroPage(),
    PersonneBlesseGrievementContenuPage.routeName: (_) =>
        const PersonneBlesseGrievementContenuPage(),
    MortInconnueIntroductionPage.routeName: (_) =>
        const MortInconnueIntroductionPage(),
    MortInconnueContenuPage.routeName: (_) => const MortInconnueContenuPage(),
    MortInconnueIntroPage.routeName: (_) => const MortInconnueIntroPage(),
    MortInconnueConditionPage.routeName: (_) =>
        const MortInconnueConditionPage(),
    MortInconnueProcedurePage.routeName: (_) =>
        const MortInconnueProcedurePage(),
    MortInconnueActesEnquetePage.routeName: (_) =>
        const MortInconnueActesEnquetePage(),
    MortInconnueActesDeleguesPage.routeName: (_) =>
        const MortInconnueActesDeleguesPage(),
    MortInconnueActesJugeInstructionPage.routeName: (_) =>
        const MortInconnueActesJugeInstructionPage(),
    MortInconnueSuitesEnquetePage.routeName: (_) =>
        const MortInconnueSuitesEnquetePage(),
    CriminaliteDeliquanceIntroPage.routeName: (_) =>
        const CriminaliteDeliquanceIntroPage(),
    CriminaliteOrganiseeContenuPage.routeName: (_) =>
        const CriminaliteOrganiseeContenuPage(),
    InfractionCriminaliteOrganiseePage.routeName: (_) =>
        const InfractionCriminaliteOrganiseePage(),
    ReglesDerogatoiresCriminaliteOrganiseePage.routeName: (_) =>
        const ReglesDerogatoiresCriminaliteOrganiseePage(),
    GardeAVuePageGpxSchool.routeName: (_) => const GardeAVuePageGpxSchool(),
    PerquisitionGpxSchool.routeName: (_) => const PerquisitionGpxSchool(),
    InterceptionsGpxSchool.routeName: (_) => const InterceptionsGpxSchool(),
    AutresTechniquesGpxSchool.routeName: (_) =>
        const AutresTechniquesGpxSchool(),
    EnquetePreliminaireGpxSchool.routeName: (_) =>
        const EnquetePreliminaireGpxSchool(),
    AuditionEnquetePreliminaireGpxSchool.routeName: (_) =>
        const AuditionEnquetePreliminaireGpxSchool(),
    CommissionRogatoireGpxSchool.routeName: (_) =>
        const CommissionRogatoireGpxSchool(),
    LutteFinancementGpxSchool.routeName: (_) =>
        const LutteFinancementGpxSchool(),
    PersonnesFuiteIntroPage.routeName: (_) => const PersonnesFuiteIntroPage(),
    PersonnesFuiteContenuPage.routeName: (_) =>
        const PersonnesFuiteContenuPage(),
    PersonnesFuiteIntroGpxSchool.routeName: (_) =>
        const PersonnesFuiteIntroGpxSchool(),
    PersonnesFuiteConditionGpxSchool.routeName: (_) =>
        const PersonnesFuiteConditionGpxSchool(),
    PersonnesFuiteProcedureGpxSchool.routeName: (_) =>
        const PersonnesFuiteProcedureGpxSchool(),
    PersonnesFuiteTechniqueSpecialesGpxSchool.routeName: (_) =>
        const PersonnesFuiteTechniqueSpecialesGpxSchool(),
    DisparitionIntroPage.routeName: (_) => const DisparitionIntroPage(),
    DisparitionContenuPage.routeName: (_) => const DisparitionContenuPage(),
    DisparitionInquietanteIntroGpxSchool.routeName: (_) =>
        const DisparitionInquietanteIntroGpxSchool(),
    DisparitionInquietanteConditionsGpxSchool.routeName: (_) =>
        const DisparitionInquietanteConditionsGpxSchool(),
    DisparitionInquietanteProcedureGpxSchool.routeName: (_) =>
        const DisparitionInquietanteProcedureGpxSchool(),
    DisparitionInquietanteEnqueteGpxSchool.routeName: (_) =>
        const DisparitionInquietanteEnqueteGpxSchool(),
    ControleIdentiteIntroPage.routeName: (_) =>
        const ControleIdentiteIntroPage(),
    ControleIdentiteContenuPage.routeName: (_) =>
        const ControleIdentiteContenuPage(),
    ControleIdentiteChap1ContenuPage.routeName: (_) =>
        const ControleIdentiteChap1ContenuPage(),
    ConntroleIdentiteIntroductionGpxSchool.routeName: (_) =>
        const ConntroleIdentiteIntroductionGpxSchool(),
    ConntroleIdentiteCadreGpxSchool.routeName: (_) =>
        const ConntroleIdentiteCadreGpxSchool(),
    ConntroleIdentitePreventionGpxSchool.routeName: (_) =>
        const ConntroleIdentitePreventionGpxSchool(),
    ConntroleIdentiteFrontiereGpxSchool.routeName: (_) =>
        const ConntroleIdentiteFrontiereGpxSchool(),
    ConntroleIdentiteLocauxGpxSchool.routeName: (_) =>
        const ConntroleIdentiteLocauxGpxSchool(),
    ConntroleIdentiteVisiteGpxSchool.routeName: (_) =>
        const ConntroleIdentiteVisiteGpxSchool(),
    ConntroleIdentiteReglementationGpxSchool.routeName: (_) =>
        const ConntroleIdentiteReglementationGpxSchool(),
    ConntroleIdentiteSejourGpxSchool.routeName: (_) =>
        const ConntroleIdentiteSejourGpxSchool(),
    ConntroleIdentiteDocumentGpxSchool.routeName: (_) =>
        const ConntroleIdentiteDocumentGpxSchool(),
    ConntroleIdentiteIntroGpxSchool.routeName: (_) =>
        const ConntroleIdentiteIntroGpxSchool(),
    ReleveIdentiteGpxSchool.routeName: (_) => const ReleveIdentiteGpxSchool(),
    ControleIdentiteChap3ContenuPage.routeName: (_) =>
        const ControleIdentiteChap3ContenuPage(),
    VerificationIdentiteIntroductionGpxSchool.routeName: (_) =>
        const VerificationIdentiteIntroductionGpxSchool(),
    VerificationIdentiteRetentionGpxSchool.routeName: (_) =>
        const VerificationIdentiteRetentionGpxSchool(),
    VerificationIdentiteRechercheGpxSchool.routeName: (_) =>
        const VerificationIdentiteRechercheGpxSchool(),
    VerificationIdentiteProcedureGpxSchool.routeName: (_) =>
        const VerificationIdentiteProcedureGpxSchool(),
    VerificationIdentiteProcesVerbalGpxSchool.routeName: (_) =>
        const VerificationIdentiteProcesVerbalGpxSchool(),
    EntraideJudiciaireIntroPage.routeName: (_) =>
        const EntraideJudiciaireIntroPage(),
    EntraideJudiciaireContenuPage.routeName: (_) =>
        const EntraideJudiciaireContenuPage(),
    EurojustPage.routeName: (_) => const EurojustPage(),
    TraitePrumPage.routeName: (_) => const TraitePrumPage(),
    ReseauJudiciaireEuropeenPage.routeName: (_) =>
        const ReseauJudiciaireEuropeenPage(),
    EntraideJudiciaireInternationalePage.routeName: (_) =>
        const EntraideJudiciaireInternationalePage(),
    MaeDefinitionPage.routeName: (_) => const MaeDefinitionPage(),
    MaeMiseEnOeuvrePage.routeName: (_) => const MaeMiseEnOeuvrePage(),
    MaeMandatParJuridictionsFrPage.routeName: (_) =>
        const MaeMandatParJuridictionsFrPage(),
    MaeExecutionParJuridictionsFrPage.routeName: (_) =>
        const MaeExecutionParJuridictionsFrPage(),
    ExtraditionDroitCommunPage.routeName: (_) =>
        const ExtraditionDroitCommunPage(),
    ExtraditionSimplifieeUEPage.routeName: (_) =>
        const ExtraditionSimplifieeUEPage(),
    ExtraditionModalitesTransmissionPage.routeName: (_) =>
        const ExtraditionModalitesTransmissionPage(),

    // Procédure Pénale
    PPActionPubliqueAutoritesPJPage.routeName: (_) =>
        const PPActionPubliqueAutoritesPJPage(),
    ActionPubliqueIntroPage.routeName: (_) => const ActionPubliqueIntroPage(),
    PPActionPubliqueActionCivilePage.routeName: (_) =>
        const PPActionPubliqueActionCivilePage(),
    PPActionPubliqueChapitre1TitrePreliminairePage.routeName: (_) =>
        const PPActionPubliqueChapitre1TitrePreliminairePage(),
    PPActionPubliqueChapitre2SujetsActionPubliquePage.routeName: (_) =>
        const PPActionPubliqueChapitre2SujetsActionPubliquePage(),
    PPActionPubliqueChapitre3ExerciceActionPubliquePage.routeName: (_) =>
        const PPActionPubliqueChapitre3ExerciceActionPubliquePage(),
    PPActionPubliqueChapitre4ExtinctionActionPubliquePage.routeName: (_) =>
        const PPActionPubliqueChapitre4ExtinctionActionPubliquePage(),
    PPActionPubliqueActionCivileTableauPage.routeName: (_) =>
        const PPActionPubliqueActionCivileTableauPage(),
    ControleMissionJudiciaireIntroPage.routeName: (_) =>
        const ControleMissionJudiciaireIntroPage(),
    ControleMissionJudiciairePage.routeName: (_) =>
        const ControleMissionJudiciairePage(),
    PPControleMissionPJRoleProcureurGeneralPage.routeName: (_) =>
        const PPControleMissionPJRoleProcureurGeneralPage(),
    PPControleMissionPJInspectionGeneraleJusticePage.routeName: (_) =>
        const PPControleMissionPJInspectionGeneraleJusticePage(),
    PPControleMissionPJChambreInstructionPage.routeName: (_) =>
        const PPControleMissionPJChambreInstructionPage(),
    AutoriteInvestiesLoiPage.routeName: (_) => const AutoriteInvestiesLoiPage(),
    AutoriteInvestiesLoiIntroPage.routeName: (_) =>
        const AutoriteInvestiesLoiIntroPage(),
    PPAutoritesInvestiesPJHabituellesPage.routeName: (_) =>
        const PPAutoritesInvestiesPJHabituellesPage(),
    PPAutoritesInvestiesPJOccasionnellesPage.routeName: (_) =>
        const PPAutoritesInvestiesPJOccasionnellesPage(),
    OrganisationHierarchiqueIntroPage.routeName: (_) =>
        const OrganisationHierarchiqueIntroPage(),
    PPOrganisationMinisterePublicContenuPage.routeName: (_) =>
        const PPOrganisationMinisterePublicContenuPage(),
    NulliteIntroPage.routeName: (_) => const NulliteIntroPage(),
    PPNulliteActesProcedureContenuPage.routeName: (_) =>
        const PPNulliteActesProcedureContenuPage(),
    PPNullitesTextuellesPage.routeName: (_) => const PPNullitesTextuellesPage(),
    PPNullitesSubstantiellesPage.routeName: (_) =>
        const PPNullitesSubstantiellesPage(),
    PPActionEnNullitePage.routeName: (_) => const PPActionEnNullitePage(),
    PPEffetsNullitePage.routeName: (_) => const PPEffetsNullitePage(),
    JuridictionsExecutionDecisionsJusticePage.routeName: (_) =>
        const JuridictionsExecutionDecisionsJusticePage(),
    PpJuridictionsPenalesPage.routeName: (_) =>
        const PpJuridictionsPenalesPage(),
    InstructionIntroPage.routeName: (_) => const InstructionIntroPage(),
    InstructionContenuPage.routeName: (_) => const InstructionContenuPage(),
    PPInstructionPreparatoireContenuPage.routeName: (_) =>
        const PPInstructionPreparatoireContenuPage(),
    PPInstructionCh1Page.routeName: (_) => const PPInstructionCh1Page(),
    PPInstructionOuverturePage.routeName: (_) =>
        const PPInstructionOuverturePage(),
    PPInstructionPouvoirsPage.routeName: (_) =>
        const PPInstructionPouvoirsPage(),
    PPInstructionCloturePage.routeName: (_) => const PPInstructionCloturePage(),
    PPChambreInstructionPage.routeName: (_) => const PPChambreInstructionPage(),
    PPJLDPage.routeName: (_) => const PPJLDPage(),
    DetentionIntroPage.routeName: (_) => const DetentionIntroPage(),
    PPDetentionProvisoireContenuPage.routeName: (_) =>
        const PPDetentionProvisoireContenuPage(),
    PPPlacementDetentionProvisoirePage.routeName: (_) =>
        const PPPlacementDetentionProvisoirePage(),
    PPDeroulementDetentionProvisoirePage.routeName: (_) =>
        const PPDeroulementDetentionProvisoirePage(),
    PPFinDetentionProvisoirePage.routeName: (_) =>
        const PPFinDetentionProvisoirePage(),
    PPReparationDetentionInjustifieePage.routeName: (_) =>
        const PPReparationDetentionInjustifieePage(),
    PPDetentionProvisoireTableauPage.routeName: (_) =>
        const PPDetentionProvisoireTableauPage(),
    ControleJudiciaireIntro.routeName: (_) => const ControleJudiciaireIntro(),
    ControleJudiciaireContenu.routeName: (_) =>
        const ControleJudiciaireContenu(),
    PPControleJudiciaireChapitre1Page.routeName: (_) =>
        const PPControleJudiciaireChapitre1Page(),
    PPControleJudiciaireChapitre2Page.routeName: (_) =>
        const PPControleJudiciaireChapitre2Page(),
    PPControleJudiciaireTableauPage.routeName: (_) =>
        const PPControleJudiciaireTableauPage(),
    BraceletMaisonContenuPage.routeName: (_) =>
        const BraceletMaisonContenuPage(),
    PpAssignationResidenceConditionsPage.routeName: (_) =>
        const PpAssignationResidenceConditionsPage(),
    PpBraceletModalitesPlacementPage.routeName: (_) =>
        const PpBraceletModalitesPlacementPage(),
    PpBraceletDeroulementMesurePage.routeName: (_) =>
        const PpBraceletDeroulementMesurePage(),
    MandatsJusticeContenuPage.routeName: (_) =>
        const MandatsJusticeContenuPage(),
    PpMandatsPrincipesGenerauxPage.routeName: (_) =>
        const PpMandatsPrincipesGenerauxPage(),
    PPMandatsTypesPage.routeName: (_) => const PPMandatsTypesPage(),
    PPMandatsSanctionsIrregularitesPage.routeName: (_) =>
        const PPMandatsSanctionsIrregularitesPage(),
    DispositionsMineursContenuPage.routeName: (_) =>
        const DispositionsMineursContenuPage(),
    PPMineursPrincipesGenerauxPage.routeName: (_) =>
        const PPMineursPrincipesGenerauxPage(),
    PPMineursInstructionPreparatoirePage.routeName: (_) =>
        const PPMineursInstructionPreparatoirePage(),
    PPMineursRetentionMandatsPage.routeName: (_) =>
        const PPMineursRetentionMandatsPage(),
    LoiPenaleContenuPage.routeName: (_) => const LoiPenaleContenuPage(),
    ClassificationInfractionsContenuPageLoiPenal.routeName: (_) =>
        const ClassificationInfractionsContenuPageLoiPenal(),
    ClassificationInfractionsGPXSchoolPageLoiPenal.routeName: (_) =>
        const ClassificationInfractionsGPXSchoolPageLoiPenal(),
    GPXSchoolEtendueApplicationLoisPage.routeName: (_) =>
        const GPXSchoolEtendueApplicationLoisPage(),
    GPXSchoolGeneralitesLegislationPenalePage.routeName: (_) =>
        const GPXSchoolGeneralitesLegislationPenalePage(),
    GPXSchoolElementsConstitutifsInfractionPage.routeName: (_) =>
        const GPXSchoolElementsConstitutifsInfractionPage(),
    ResponsabilitePenaleContenuPage.routeName: (_) =>
        const ResponsabilitePenaleContenuPage(),
    GPXSchoolResponsabilitePenalePrincipesGenerauxPage.routeName: (_) =>
        const GPXSchoolResponsabilitePenalePrincipesGenerauxPage(),
    GPXSchoolResponsabilitePenaleCompliciteCoactionPage.routeName: (_) =>
        const GPXSchoolResponsabilitePenaleCompliciteCoactionPage(),
    GPXSchoolResponsabilitePenalePersonnesMoralesPage.routeName: (_) =>
        const GPXSchoolResponsabilitePenalePersonnesMoralesPage(),
    GPXSchoolResponsabilitePenaleCausesIrresponsabilitePage.routeName: (_) =>
        const GPXSchoolResponsabilitePenaleCausesIrresponsabilitePage(),
    ClassificationPeinesContenuPage.routeName: (_) =>
        const ClassificationPeinesContenuPage(),
    ClassificationMesuresSuretePage.routeName: (_) =>
        const ClassificationMesuresSuretePage(),
    ClassificationLegalePeinesPage.routeName: (_) =>
        const ClassificationLegalePeinesPage(),
    CausesAggravationSanctionContenuPage.routeName: (_) =>
        const CausesAggravationSanctionContenuPage(),
    AuteurIvreOuStupefiantsPage.routeName: (_) =>
        const AuteurIvreOuStupefiantsPage(),
    UtilisationReseauCommunicationPage.routeName: (_) =>
        const UtilisationReseauCommunicationPage(),
    EtablissementEnseignementPage.routeName: (_) =>
        const EtablissementEnseignementPage(),
    BandeOrganiseePage.routeName: (_) => const BandeOrganiseePage(),
    MinoriteQuinzeAnsPage.routeName: (_) => const MinoriteQuinzeAnsPage(),
    MortPage.routeName: (_) => const MortPage(),
    MutilationInfirmitePermanentePage.routeName: (_) =>
        const MutilationInfirmitePermanentePage(),
    VulnerabiliteVictimePage.routeName: (_) => const VulnerabiliteVictimePage(),
    PremeditationPage.routeName: (_) => const PremeditationPage(),
    QualiteConjointConcubinPartenairePage.routeName: (_) =>
        const QualiteConjointConcubinPartenairePage(),
    CaractereHomophobePage.routeName: (_) => const CaractereHomophobePage(),
    CaractereRacistePage.routeName: (_) => const CaractereRacistePage(),
    GuetApensPage.routeName: (_) => const GuetApensPage(),
    PortOuUsageArmePage.routeName: (_) => const PortOuUsageArmePage(),
    EffractionPage.routeName: (_) => const EffractionPage(),
    CirconstancesAggravantesPage.routeName: (_) =>
        const CirconstancesAggravantesPage(),
    EscaladePage.routeName: (_) => const EscaladePage(),
    IncapaciteTotaleTravailPage.routeName: (_) =>
        const IncapaciteTotaleTravailPage(),
    MoyenCryptologiePage.routeName: (_) => const MoyenCryptologiePage(),
    AuteurAbusantAutoritePage.routeName: (_) =>
        const AuteurAbusantAutoritePage(),
    AuteurAscendantVictimePage.routeName: (_) =>
        const AuteurAscendantVictimePage(),
    AuteurDepositaireAutoritePage.routeName: (_) =>
        const AuteurDepositaireAutoritePage(),
    VictimeAscendantAuteurPage.routeName: (_) =>
        const VictimeAscendantAuteurPage(),
    VictimeChargeeMissionPage.routeName: (_) =>
        const VictimeChargeeMissionPage(),
    VictimeDepositaireAutoritePage.routeName: (_) =>
        const VictimeDepositaireAutoritePage(),
    VictimeProstitutionPage.routeName: (_) => const VictimeProstitutionPage(),
    TemoinVictimePartieCivilePage.routeName: (_) =>
        const TemoinVictimePartieCivilePage(),
    VictimeParentePersonneDepositaireAutoritePage.routeName: (_) =>
        const VictimeParentePersonneDepositaireAutoritePage(),
    PluraliteInfractionsContenuPage.routeName: (_) =>
        const PluraliteInfractionsContenuPage(),
    RecidivePage.routeName: (_) => const RecidivePage(),
    ReiterationInfractionsPage.routeName: (_) =>
        const ReiterationInfractionsPage(),
    ConcoursReelInfractionsPage.routeName: (_) =>
        const ConcoursReelInfractionsPage(),
    MiseEnDangerContenuPage.routeName: (_) => const MiseEnDangerContenuPage(),
    MiseEnDangerDiffusionInformationsPage.routeName: (_) =>
        const MiseEnDangerDiffusionInformationsPage(),
    NonAssistancePersonnePerilPage.routeName: (_) =>
        const NonAssistancePersonnePerilPage(),
    AbusFrauduleuxIgnoranceFaiblessePage.routeName: (_) =>
        const AbusFrauduleuxIgnoranceFaiblessePage(),
    DelaissementPersonneHorsEtatPage.routeName: (_) =>
        const DelaissementPersonneHorsEtatPage(),
    NonObstacleCommissionCrimeDelitPage.routeName: (_) =>
        const NonObstacleCommissionCrimeDelitPage(),
    RisqueCauseAutruiPage.routeName: (_) => const RisqueCauseAutruiPage(),
    ViolIncesteAgressionsContenuPage.routeName: (_) =>
        const ViolIncesteAgressionsContenuPage(),
    ViolIncesteAgressionsAvertissementPage.routeName: (_) =>
        const ViolIncesteAgressionsAvertissementPage(),
    ContrainteAtteinteSexuelleTiersPage.routeName: (_) =>
        const ContrainteAtteinteSexuelleTiersPage(),
    AdministrationSubstancesNuisiblesPage.routeName: (_) =>
        const AdministrationSubstancesNuisiblesPage(),
    SubstancePourViolOuAgressionPage.routeName: (_) =>
        const SubstancePourViolOuAgressionPage(),
    AgressionMajeurMineur15Page.routeName: (_) =>
        const AgressionMajeurMineur15Page(),
    AgressionSexuelleIncestueusePage.routeName: (_) =>
        const AgressionSexuelleIncestueusePage(),
    HarcelementSexuelPage.routeName: (_) => const HarcelementSexuelPage(),
    ViolMajeurMineur15Page.routeName: (_) => const ViolMajeurMineur15Page(),
    ViolIncestueuxPage.routeName: (_) => const ViolIncestueuxPage(),
    ViolPage.routeName: (_) => const ViolPage(),
    AgressionsSexuellesAutresQueViolPage.routeName: (_) =>
        const AgressionsSexuellesAutresQueViolPage(),
    Mineur15ViolencesContrainteMenaceSurprisePage.routeName: (_) =>
        const Mineur15ViolencesContrainteMenaceSurprisePage(),
    PersonneVulnerablePage.routeName: (_) => const PersonneVulnerablePage(),
    ExhibitionSexuellePage.routeName: (_) => const ExhibitionSexuellePage(),
    EnlevementSequestrationPage.routeName: (_) =>
        const EnlevementSequestrationPage(),
    EnregistrementDiffusionImagesContenuPage.routeName: (_) =>
        const EnregistrementDiffusionImagesContenuPage(),
    EnregistrementImagesViolencePage.routeName: (_) =>
        const EnregistrementImagesViolencePage(),
    DiffusionImagesViolenceContenuPage.routeName: (_) =>
        const DiffusionImagesViolenceContenuPage(),
    DignitePersonneContenuPage.routeName: (_) =>
        const DignitePersonneContenuPage(),
    DissimulationForceeVisagePage.routeName: (_) =>
        const DissimulationForceeVisagePage(),
    RetributionInexistanteInsuffisantePersonneVulnerableDependantePage
        .routeName: (_) =>
        const RetributionInexistanteInsuffisantePersonneVulnerableDependantePage(),
    SoumissionConditionsTravailHebergementIncompatiblesDignitePage
        .routeName: (_) =>
        const SoumissionConditionsTravailHebergementIncompatiblesDignitePage(),
    TraiteEtresHumainsPage.routeName: (_) => const TraiteEtresHumainsPage(),
    ViolationProfanationTombeauxSepulturesUrnesMonumentsPage.routeName: (_) =>
        const ViolationProfanationTombeauxSepulturesUrnesMonumentsPage(),
    AtteinteIntegriteCadavrePage.routeName: (_) =>
        const AtteinteIntegriteCadavrePage(),
    ProxenetismeHotelierPage.routeName: (_) => const ProxenetismeHotelierPage(),
    ProxenetismeAssimilationPage.routeName: (_) =>
        const ProxenetismeAssimilationPage(),
    ProxenetismePage.routeName: (_) => const ProxenetismePage(),
    RecoursProstitutionMineursPersonnesVulnerablesPage.routeName: (_) =>
        const RecoursProstitutionMineursPersonnesVulnerablesPage(),
    DiscriminationsPage.routeName: (_) => const DiscriminationsPage(),
    AtteintePersonnaliteContenuPage.routeName: (_) =>
        const AtteintePersonnaliteContenuPage(),
    DenonciationCalomnieusePage.routeName: (_) =>
        const DenonciationCalomnieusePage(),
    DiffusionEnregistrementCaractereSexuelSansAccordPage.routeName: (_) =>
        const DiffusionEnregistrementCaractereSexuelSansAccordPage(),
    ViolationDomicileParticulierPage.routeName: (_) =>
        const ViolationDomicileParticulierPage(),
    ViolationCorrespondancesVoieElectroniquePage.routeName: (_) =>
        const ViolationCorrespondancesVoieElectroniquePage(),
    AtteinteRepresentationPersonnePage.routeName: (_) =>
        const AtteinteRepresentationPersonnePage(),
    AtteinteIntimiteViePriveePage.routeName: (_) =>
        const AtteinteIntimiteViePriveePage(),
    AtteinteIntimitePersonnePage.routeName: (_) =>
        const AtteinteIntimitePersonnePage(),
    AtteinteSecretCorrespondancesParticulierPage.routeName: (_) =>
        const AtteinteSecretCorrespondancesParticulierPage(),
    AtteinteSecretProfessionnelPage.routeName: (_) =>
        const AtteinteSecretProfessionnelPage(),
    AtteintesInvolontairesContenuPage.routeName: (_) =>
        const AtteintesInvolontairesContenuPage(),
    ParticipationGroupementViolentPage.routeName: (_) =>
        const ParticipationGroupementViolentPage(),
    AtteintesInvolontairesConducteurVtmPage.routeName: (_) =>
        const AtteintesInvolontairesConducteurVtmPage(),
    AtteintesInvolontairesIttInferieure3MoisPage.routeName: (_) =>
        const AtteintesInvolontairesIttInferieure3MoisPage(),
    AtteintesInvolontairesIttSuperieure3MoisPage.routeName: (_) =>
        const AtteintesInvolontairesIttSuperieure3MoisPage(),
    AtteintesInvolontairesViolationManifestementDelibereeObligationPage
        .routeName: (_) =>
        const AtteintesInvolontairesViolationManifestementDelibereeObligationPage(),
    AtteintesVolontairesQualifieesViolencesPage.routeName: (_) =>
        const AtteintesVolontairesQualifieesViolencesPage(),
    ViolencesVolontairesArmePersonneDepositaireTransportPompierPage
        .routeName: (_) =>
        const ViolencesVolontairesArmePersonneDepositaireTransportPompierPage(),
    HomicideInvolontairePage.routeName: (_) => const HomicideInvolontairePage(),
    AtteintesVolontairesVieContenuPage.routeName: (_) =>
        const AtteintesVolontairesVieContenuPage(),
    MeurtrePage.routeName: (_) => const MeurtrePage(),
    EmpoisonnementPage.routeName: (_) => const EmpoisonnementPage(),
    AtteintesVolontairesIntegriteContenuPage.routeName: (_) =>
        const AtteintesVolontairesIntegriteContenuPage(),
    MenaceSansConditionPage.routeName: (_) => const MenaceSansConditionPage(),
    MiseEnPerilDesMineursPage.routeName: (_) =>
        const MiseEnPerilDesMineursPage(),
    ViolationOrdonnancesJafPage.routeName: (_) =>
        const ViolationOrdonnancesJafPage(),
    DefautNotificationChangementDomicileCreancierPage.routeName: (_) =>
        const DefautNotificationChangementDomicileCreancierPage(),
    NonRepresentationEnfantMineurPage.routeName: (_) =>
        const NonRepresentationEnfantMineurPage(),
    AbusAutoriteParticuliersContenuPage.routeName: (_) =>
        const AbusAutoriteParticuliersContenuPage(),
    AtteintesInviolabiliteDomicilePage.routeName: (_) =>
        const AtteintesInviolabiliteDomicilePage(),
    AtteintesActionJusticeContenuPage.routeName: (_) =>
        const AtteintesActionJusticeContenuPage(),
    ProbiteContenuPage.routeName: (_) => const ProbiteContenuPage(),
    NonJustificationRessources.routeName: (_) =>
        const NonJustificationRessources(),
    RecelPage.routeName: (_) => const RecelPage(),
    GpxFormationInitialeFormationPage.routeName: (_) =>
        const GpxFormationInitialeFormationPage(),
    GpxMementoPriseDeNoteMethodologiePage.routeName: (_) =>
        const GpxMementoPriseDeNoteMethodologiePage(),
    GpxCasPratiqueCase2Page.routeName: (_) => const GpxCasPratiqueCase2Page(),

    '/gpx_exam/concours/tests_psychotechniques/logique_verbale': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizPsycotechniquesVerbal(uid: user!.id, email: user.email!);
    },
    '/gpx_exam/concours/tests_psychotechniques/attention_concentration': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizPsycotechniquesConcentration(
        uid: user!.id,
        email: user.email!,
      );
    },
    '/gpx_exam/concours/tests_psychotechniques/calcul_rapide': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizPsycotechniquesCalcul(uid: user!.id, email: user.email!);
    },
    '/gpx_exam/concours/tests_psychotechniques/suites_logiques': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizPsycotechniquesSuitesLogiques(
        uid: user!.id,
        email: user.email!,
      );
    },
    '/gpx_exam/concours/langue_etrangere/exemples_allemand': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizLangueEtrangereAllemand(uid: user!.id, email: user.email!);
    },
    '/gpx_exam/concours/langue_etrangere/exemples_espagnol': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizLangueEtrangereEspagnol(uid: user!.id, email: user.email!);
    },
    '/gpx_exam/concours/langue_etrangere/exemples_anglais': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizLangueEtrangereAnglais(uid: user!.id, email: user.email!);
    },
    '/gpx_exam/concours/culture_generale_police_securite': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizCultureGeneralePolice(uid: user!.id, email: user.email!);
    },
    '/gpx_exam/concours/culture_generale_sante': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizCultureGeneraleSante(uid: user!.id, email: user.email!);
    },
    '/gpx_exam/concours/culture_generale_securite_routiere': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizCultureGeneraleSecuriteRoutiere(
        uid: user!.id,
        email: user.email!,
      );
    },
    '/gpx_exam/concours/culture_generale_mythologie': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizCultureGeneraleMythologie(uid: user!.id, email: user.email!);
    },
    '/gpx_exam/concours/culture_generale_droit': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizCultureGeneraleDroit(uid: user!.id, email: user.email!);
    },
    '/gpx_exam/concours/culture_generale_sciences': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizCultureGeneraleSciences(uid: user!.id, email: user.email!);
    },
    '/gpx_exam/concours/culture_generale_sport': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizCultureGeneraleSport(uid: user!.id, email: user.email!);
    },
    '/gpx_exam/concours/culture_generale_francais': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizCultureGeneralFrance(uid: user!.id, email: user.email!);
    },
    '/gpx_exam/concours/culture_generale_musique': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizCultureGeneraleMusique(uid: user!.id, email: user.email!);
    },
    '/gpx_exam/concours/culture_generale_cinema': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizCultureGeneraleCinema(uid: user!.id, email: user.email!);
    },
    '/gpx_exam/concours/culture_generale_geographie': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizCultureGeneraleGeographie(uid: user!.id, email: user.email!);
    },
    '/gpx_exam/concours/culture_generale_actualite': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizCultureGeneraleActualite(uid: user!.id, email: user.email!);
    },
    '/gpx_exam/concours/culture_generale_institutions_europeennes': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizCultureGeneralInstitutionsEuropeenes(
        uid: user!.id,
        email: user.email!,
      );
    },
    '/gpx_exam/concours/culture_generale_histoire_france': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizCultureGeneraleHistoireFranceGPX(
        uid: user!.id,
        email: user.email!,
      );
    },
    '/gpx/institution/accueil_public/quiz': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuiAccueilGpx(uid: user!.id, email: user.email!);
    },
    '/gpx/institution/organisation_pn/quiz': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizOrganisationPnGPX(uid: user!.id, email: user.email!);
    },
    '/gpx/institution/deontologie/quiz': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizDeontologieGPX(uid: user!.id, email: user.email!);
    },
    '/gpx/stupéfiants_pages/quiz/quiz_stupéfiants': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizStupefiant(uid: user!.id, email: user.email!);
    },
    '/gpx/generalites/quiz/infraction': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizInfractionsPage(uid: user!.id, email: user.email!);
    },

    // ➜ TENTATIVE
    '/gpx/generalites/quiz/tentative': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizTentativePage(uid: user!.id, email: user.email!);
    },
    // ➜ COMPLIcITE
    '/gpx/complicite/quiz/complicite': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizComplicitePage(uid: user!.id, email: user.email!);
    },
    // ➜ Légitime Défense
    '/gpx/generalites/quiz/legitimedefense': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizLegitimeDefensePage(uid: user!.id, email: user.email!);
    },
    // ➜ Usage des Armes
    '/gpx/generalites/quiz/usagearmes': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizUsageArmesPage(uid: user!.id, email: user.email!);
    },
    // ➜ Libertés Publiques Intro
    '/gpx/generalites/quiz/libertes_publiques': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizLibertesPubliquesPage(uid: user!.id, email: user.email!);
    },
    // ➜ Libertés Publiques Garanties
    '/gpx/generalites/quiz/garanties_libertes_publiques': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizGarantiesLibertesPage(uid: user!.id, email: user.email!);
    },
    // ➜ Libertés Publiques Collectives
    '/gpx/generalites/quiz/libertes_publiques_collectives': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizLibertesPubliquesCollectivesPage(
        uid: user!.id,
        email: user.email!,
      );
    },
    // ➜ Libertés Publiques Individuelles
    '/gpx/generalites/quiz/libertes_publiques_individuelles': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizLibertesPubliquesIndividuellesPage(
        uid: user!.id,
        email: user.email!,
      );
    },
    // ➜ Rétention locaux police
    '/gpx/generalites/quiz/retention_locaux_police': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizRetentionLocauxPage(uid: user!.id, email: user.email!);
    },
    // ➜ Hiérarchie
    '/gpx/generalites/quiz/hierarchie': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizHierarchiePage(uid: user!.id, email: user.email!);
    },
    '/gpx/generalites/quiz/classification_infractions': (_) {
      final user = Supabase.instance.client.auth.currentUser;

      if (user == null) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }

      return QuizClassificationInfractionsPage(
        uid: user.id,
        email: user.email!,
      );
    },
    '/gpx/libertes_publiques/quiz/introduction': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizIntroduction(uid: user!.id, email: user.email!);
    },
    '/gpx/armes_munitions_pages/quiz/quiz_armes_munitions_pages': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizArmesMunitions(uid: user!.id, email: user.email!);
    },
    '/gpx/infraction_circulation_routière_pages/quiz/quiz_circulation_routiere':
        (_) {
          final user = Supabase.instance.client.auth.currentUser;
          return QuizCirculationRoutiere(uid: user!.id, email: user.email!);
        },
    '/gpx/crime_delit_nation_pages/quiz/quiz_crimes_delits_bien': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizCrimesDelitsBiens(uid: user!.id, email: user.email!);
    },
    '/gpx/crimes_biens/quiz/destructions_degradations': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizDDD(uid: user!.id, email: user.email!);
    },
    '/gpx/crimes_biens/quiz/voisines_du_vol': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizVoisinesDuVol(uid: user!.id, email: user.email!);
    },
    '/gpx/crimes_biens/quiz/stad': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizStad(uid: user!.id, email: user.email!);
    },
    '/gpx/crimes_biens/quiz/recel_non_justification': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizRecelNonJustification(uid: user!.id, email: user.email!);
    },
    '/gpx/crime_delit_nation_pages/quiz/quiz_crimes_delits_nation': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizCrimesDelitsNation(uid: user!.id, email: user.email!);
    },
    '/gpx/nation/quiz/probite': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizProbite(uid: user!.id, email: user.email!);
    },
    '/gpx/nation/quiz/faux_usage_faux': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizFauxUsageFaux(uid: user!.id, email: user.email!);
    },
    '/gpx/nation/quiz/atteintes_administration': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizAtteinteAdministrationGPXSchool(
        uid: user!.id,
        email: user.email!,
      );
    },
    '/gpx/nation/quiz/atteintes_action_justice': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizAtteinteActionJusticeGPXSchool(
        uid: user!.id,
        email: user.email!,
      );
    },
    '/gpx/nation/quiz/abus_autorite_particuliers': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizAbusAutoriteGPXSchool(uid: user!.id, email: user.email!);
    },
    '/gpx/mineurs_famille_pages/quiz/quiz_mineurs_famille': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizMineursFamille(uid: user!.id, email: user.email!);
    },
    '/gpx_scolarite_pages/mineurs_famille_pages/abandon_famille/quiz_abandon_famille':
        (_) {
          final user = Supabase.instance.client.auth.currentUser;
          return QuizAbandonFamille(uid: user!.id, email: user.email!);
        },
    '/gpx_scolarite_pages/mineurs_famille_pages/autorite_parentale/quiz_autorite_parentale':
        (_) {
          final user = Supabase.instance.client.auth.currentUser;
          return QuizAutoriteParentale(uid: user!.id, email: user.email!);
        },
    '/gpx_scolarite_pages/mineurs_famille_pages/violation_ordonnances_jaf/quiz_ordonnances_jaf':
        (_) {
          final user = Supabase.instance.client.auth.currentUser;
          return QuizViolationOrdonnancesJaf(uid: user!.id, email: user.email!);
        },
    '/gpx_scolarite_pages/mineurs_famille_pages/mise_en_peril/quiz_mise_en_peril':
        (_) {
          final user = Supabase.instance.client.auth.currentUser;
          return QuizMisePerilMineur(uid: user!.id, email: user.email!);
        },
    '/gpx/crimes_personne/quiz/crimes_delits_personne': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizCrimeDelitsPersonne(uid: user!.id, email: user.email!);
    },
    '/gpx/crimes_personne/quiz/atteintes_volontaires_integrite': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizAtteinteIntegrite(uid: user!.id, email: user.email!);
    },
    '/gpx/crimes_personne/quiz/atteintes_volontaires_vie': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizAtteinteVolontaire(uid: user!.id, email: user.email!);
    },
    '/gpx/crimes_personne/quiz/atteintes_involontaires': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizAtteinteInvolontaire(uid: user!.id, email: user.email!);
    },
    '/gpx/crimes_personne/quiz/atteinte_personnalite': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizAtteintePersonnalite(uid: user!.id, email: user.email!);
    },
    '/gpx/crimes_personne/quiz/dignite_personne': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizDiginitePersonne(uid: user!.id, email: user.email!);
    },
    '/gpx/crimes_personne/quiz/enregistrement_diffusion_images': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizEnregistrementDiffusionImages(
        uid: user!.id,
        email: user.email!,
      );
    },
    '/gpx/crimes_personne/quiz/viol_inceste_agressions': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizViolInceste(uid: user!.id, email: user.email!);
    },
    '/gpx/crimes_personne/quiz/mise_en_danger': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizMiseEnDanger(uid: user!.id, email: user.email!);
    },
    '/gpx/sanction/quiz/sanction_page': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizSanction(uid: user!.id, email: user.email!);
    },
    '/gpx/sanction/quiz/sanction_pluralite_infractions': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizSanctionPluralite(uid: user!.id, email: user.email!);
    },
    '/gpx/sanction/quiz/sanction_causes_aggravation': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizSanctionAggravation(uid: user!.id, email: user.email!);
    },
    '/gpx/sanction/quiz/sanction_classification_peine': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizSanctionClassification(uid: user!.id, email: user.email!);
    },
    '/gpx/droit_penal/quiz/responsabilite_penal_general': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizResponsabilitePenalePage(uid: user!.id, email: user.email!);
    },

    '/gpx/procedure_penale/quiz/generalité_principales': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizGeneralitePage(uid: user!.id, email: user.email!);
    },
    '/gpx/droit_penal/quiz/droit_penal_general': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizDroitPenalePage(uid: user!.id, email: user.email!);
    },
    '/gpx/procedure_penale/quiz/cadres_juridiques_principales': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizCadresPrincipalesPage(uid: user!.id, email: user.email!);
    },

    '/gpx/procedure_penale/quiz/juridictions_penales': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizJuridictionsPage(uid: user!.id, email: user.email!);
    },

    '/gpx/procedure_penale/quiz/dispositions_applicables_mineurs': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizDispositionsApplicablesMineurs(
        uid: user!.id,
        email: user.email!,
      );
    },

    '/gpx/procedure_penale/quiz/mandats_justice': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizMandatsPage(uid: user!.id, email: user.email!);
    },

    '/gpx/procedure_penale/quiz/controle_judiciaire': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizControleJudiciairePage(uid: user!.id, email: user.email!);
    },

    '/gpx/procedure_penale/quiz/bracelet_electronique': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizBraceletElectroniquePage(uid: user!.id, email: user.email!);
    },

    '/gpx/procedure_penale/quiz/detention_provisoire': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizDetentionProvisoirePage(uid: user!.id, email: user.email!);
    },

    '/gpx/procedure_penale/quiz/instruction_preparatoire': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizInstructionPage(uid: user!.id, email: user.email!);
    },

    '/gpx/procedure_penale/quiz/nullite': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizNullitePage(uid: user!.id, email: user.email!);
    },

    '/gpx/procedure_penale/quiz/action_publique': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizActionPubliquePage(uid: user!.id, email: user.email!);
    },

    '/gpx/generalites/quiz/flagrant_delit': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizFlagrantDelitPage(uid: user!.id, email: user.email!);
    },
    '/gpx/generalites/quiz/enquete_preliminaire': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizEnquetePreliminairePage(uid: user!.id, email: user.email!);
    },
    '/gpx/generalites/quiz/commission_rogatoire': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizCommissionRogatoirePage(uid: user!.id, email: user.email!);
    },
    '/gpx/generalites/quiz/mort_inconnue': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizMortInconnuePage(uid: user!.id, email: user.email!);
    },
    '/gpx/generalites/quiz/criminalite_organisee': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizCriminaliteOrganiseePage(uid: user!.id, email: user.email!);
    },
    '/gpx/generalites/quiz/personnes_fuite': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizPersonnesFuitePage(uid: user!.id, email: user.email!);
    },
    '/gpx/generalites/quiz/disparitions_inquietantes': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizDisparitionPage(uid: user!.id, email: user.email!);
    },
    '/gpx/generalites/quiz/controle_identite': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizControleIdentitePage(uid: user!.id, email: user.email!);
    },

    // ================== GPX : Procédure Pénale ==================
    '/gpx_scolarite_pages/procédure_pénale_pages/pp_action_publique_action_civile/tableau_actions_publique_civile':
        (_) => const PPActionPubliqueActionCivileTableauPage(),
    // ================== GPX : Droit pénal général ==================
    '/gpx_scolarite_pages/droit_pénale_général_pages/loi_penale/classification_infractions':
        (_) => const ClassificationInfractionsContenuPageLoiPenal(),
    '/dpg/responsabilite_penale': (_) => const ResponsabilitePenalePage(),

    // ================== GPX : Sanction ==================
    '/gpx_scolarite_pages/sanction_pages/causes_aggravation_sanction': (_) =>
        const CausesAggravationSanctionContenuPage(),
    '/sanction/classification_peines': (_) => const ClassificationPeinesPage(),
    '/sanction/causes_aggravation': (_) => const CausesAggravationPage(),
    '/sanction/pluralite_infractions': (_) => const PluraliteInfractionsPage(),

    // ================== GPX : Crimes & délits contre les biens ==================
    '/gpx_scolarite_pages/crime_delit_bien_pages/vol': (_) => const VolPage(),
    RecelNonJustificationContenuPage.routeName: (_) =>
        const RecelNonJustificationContenuPage(),
    RecelPage.routeName: (_) => const RecelPage(),

    // ================== GPX : Armes & munitions ==================
    ArmesClassificationPage.routeName: (_) => const ArmesClassificationPage(),
    ArmesDefinitionsPage.routeName: (_) => const ArmesDefinitionsPage(),
    ArmesAcquisitionDetentionABPage.routeName: (_) =>
        const ArmesAcquisitionDetentionABPage(),
    ArmesPortTransportCDPage.routeName: (_) => const ArmesPortTransportCDPage(),
    ArmesMaterielsGuerreElementsPage.routeName: (_) =>
        const ArmesMaterielsGuerreElementsPage(),
    ArmesReglesAcquisitionDetentionPage.routeName: (_) =>
        const ArmesReglesAcquisitionDetentionPage(),
    ArmesReglesPortTransportPage.routeName: (_) =>
        const ArmesReglesPortTransportPage(),

    // ================== GPX : Libertés publiques ==================
    LibertesPubliquesIntroductionContenuPage.routeName: (_) =>
        const LibertesPubliquesIntroductionContenuPage(),
    DeclarationDroitsHommeCitoyen1789Page.routeName: (_) =>
        const DeclarationDroitsHommeCitoyen1789Page(),
    RegimeJuridiqueReglementationAmenagementPage.routeName: (_) =>
        const RegimeJuridiqueReglementationAmenagementPage(),
    SourcesLibertesPubliquesPage.routeName: (_) =>
        const SourcesLibertesPubliquesPage(),
    NotionLibertesPubliquesPage.routeName: (_) =>
        const NotionLibertesPubliquesPage(),

    // ================== GPX : Stupéfiants ==================
    StupefiantsIntroductionPage.routeName: (_) =>
        const StupefiantsIntroductionPage(),
    StupefiantsCessionOffrePage.routeName: (_) =>
        const StupefiantsCessionOffrePage(),
    StupefiantsDirectionOrganisationPage.routeName: (_) =>
        const StupefiantsDirectionOrganisationPage(),
    StupefiantsFacilitationUsagePage.routeName: (_) =>
        const StupefiantsFacilitationUsagePage(),
    StupefiantsProductionFabricationPage.routeName: (_) =>
        const StupefiantsProductionFabricationPage(),
    StupefiantsProvocationMajeurPage.routeName: (_) =>
        const StupefiantsProvocationMajeurPage(),
    StupefiantsBlanchimentProduitPage.routeName: (_) =>
        const StupefiantsBlanchimentProduitPage(),
    StupefiantsTransportDetentionOffrePage.routeName: (_) =>
        const StupefiantsTransportDetentionOffrePage(),
    StupefiantsImportExportPage.routeName: (_) =>
        const StupefiantsImportExportPage(),
    StupefiantsUsageIllicitePage.routeName: (_) =>
        const StupefiantsUsageIllicitePage(),

    // ✅ Confirm email avec args
    ConfirmEmailPage.routeName: (context) {
      final args = ModalRoute.of(context)?.settings.arguments;
      String email = '';
      String password = '';
      if (args is Map) {
        email = (args['email'] as String?) ?? '';
        password = (args['password'] as String?) ?? '';
      }
      return ConfirmEmailPage(email: email, password: password);
    },
  };

  static void add(String path, WidgetBuilder builder) {
    routes[path] = builder;
  }
}
