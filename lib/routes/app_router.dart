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
  if (settings.name?.startsWith('/forum/') == true) {
    final postId = settings.name!.substring('/forum/'.length);
    final arguments = settings.arguments is Map
        ? settings.arguments as Map
        : const <dynamic, dynamic>{};
    final initialCommentId = arguments['commentId'] as String?;
    return MaterialPageRoute(
      settings: settings,
      builder: (_) => FutureBuilder(
        future: CommunityRepository().post(postId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (!snapshot.hasData) {
            return const Scaffold(
              body: Center(child: Text('Publication indisponible')),
            );
          }
          return CommunityPostPage(
            post: snapshot.data!,
            repository: CommunityRepository(),
            initialCommentId: initialCommentId,
          );
        },
      ),
    );
  }
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
      // Les écrans PA les plus sensibles (quiz, écrans avec arguments, etc.)
      // restent prioritaires dans le registre principal. Le registre généré
      // couvre ensuite toutes les fiches et sous-fiches de la scolarité PA.
      final builder =
          RouteRegistry.routes[settings.name] ??
          PaSchoolRouteRegistry.routes[settings.name];
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
    '/onboarding': (context) => const OnboardingScreen(),
    '/welcome': (context) => const WelcomeAfterSignupPage(),
    '/placement-intro': (context) => const PlacementIntro(),
    '/placement': (context) => PlacementTest(onFinished: () {}),
    '/favoris': (_) => const FavorisHomePage(),
    '/institutions': (_) => const InstitutionPage(),
    '/procedure_penale': (_) => const ProcedurePenalePage(),
    '/picker': (_) => const ModePickerScreen(),
    // ⚠️ CORRECTIF CRITIQUE (audit 2026-07-26)
    // HomeBootstrap redirige vers '/mode_picker' et '/grade_picker' quand le
    // profil de l'utilisateur est incomplet. Ces deux routes n'existaient PAS :
    // l'utilisateur tombait sur _NotFoundScreen, et comme l'appel se fait en
    // pushNamedAndRemoveUntil la pile était vidée — il restait bloqué sur le
    // 404 sans aucun moyen de revenir. Tout nouveau compte était concerné.
    '/mode_picker': (_) => const ModePickerScreen(),
    '/grade_picker': (_) => const GradePickerScreen(),
    "/abonnement": (_) => const AbonnementPage(),
    // Alias historique : plusieurs écrans poussent encore '/subscription'.
    '/subscription': (_) => const AbonnementPage(),
    "/premium-required": (_) => const PremiumRequiredPage(),
    // Retour de paiement Stripe Checkout (deep links copiqpolice://paywall/success
    // et copiqpolice://paywall/cancel — voir deep_links_service.dart). Donne accès
    // à toute l'app (PA/GPX exam & school) une fois l'utilisateur passé par cet écran.
    PaymentResultPage.routeNameSuccess: (_) =>
        const PaymentResultPage(status: PaymentResultStatus.success),
    PaymentResultPage.routeNameCancel: (_) =>
        const PaymentResultPage(status: PaymentResultStatus.cancel),

    // ================== GPX : Généralités ==================
    '/gpx/generalites/classification_infractions': (_) =>
        const ClassificationInfractionsPage(),
    '/gpx/generalites/infraction': (_) => const InfractionPage(),
    // ================== GPX : School ==================
    '/home_pa_school': (_) => const HomePagePaSchool(),
    '/home-bootstrap': (_) => const HomeBootstrap(),
    '/gpx/generalites/infraction_intro': (_) => const InfractionIntroPage(),
    '/gpx/generalites/infraction/contenu': (_) => const InfractionContenuPage(),
    '/gpx/generalites/infraction/element-legal': (_) =>
        const ElementLegalPage(),
    '/gpx/generalites/infraction/element-materiel': (_) =>
        const ElementMaterielPage(),
    '/gpx/generalites/infraction/element-moral': (_) =>
        const ElementMoralPage(),
    '/gpx/generalites/complicite/participation': (_) =>
        const CompliciteParticipationPage(),
    '/gpx/generalites/complicite/repression': (_) =>
        const CompliciteRepressionPage(),
    // ===== ROUTES PA MÉMENTO CIRCULATION ROUTIÈRE =====
    '/pa/memento_circulation/procedures/amende_forfaitaire': (_) =>
        const AmendeForfaitairePage(),
    '/pa/memento_circulation/procedures/amende_forfaitaire_delictuelle': (_) =>
        const AmendeForfaitaireDelictuellePage(),
    '/pa/memento_circulation/procedures/consignation': (_) =>
        const ConsignationPage(),
    '/pa/memento_circulation/procedures/immobilisation': (_) =>
        const ImmobilisationPage(),
    '/pa/memento_circulation/procedures/mise_en_fourriere': (_) =>
        const MiseEnFourrierePage(),
    '/pa/memento_circulation/procedures/conduite_alcool': (_) =>
        const ConduiteAlcoolPage(),
    '/pa/memento_circulation/procedures/conduite_stupefiants': (_) =>
        const ConduiteApresUsageStupefiantsPage(),
    '/pa/memento_circulation/procedures/retention_permis': (_) =>
        const RetentionPermisConduirePage(),
    '/pa/memento_circulation/procedures/permis_a_points': (_) =>
        const PermisAPointsPage(),
    '/pa/memento_circulation/controle_routier/cadre_legal': (_) =>
        const CadreLegalControleRoutierPage(),
    '/pa/memento_circulation/controle_routier/permis_conduire': (_) =>
        const PermisConduirePage(),
    '/pa/memento_circulation/controle_routier/bsr': (_) => const BsrPage(),
    '/pa/memento_circulation/controle_routier/certificat_immatriculation':
        (_) => const CertificatImmatriculationPage(),
    '/pa/memento_circulation/controle_routier/controle_technique': (_) =>
        const ControleTechniquePage(),
    '/pa/memento_circulation/controle_routier/assurance_obligatoire': (_) =>
        const AssuranceObligatoirePage(),
    '/pa/memento_circulation/equipements/pneumatiques': (_) =>
        const PneumatiquesPage(),
    '/pa/memento_circulation/equipements/eclairage_signalisation': (_) =>
        const EclairageSignalisationPage(),
    '/pa/memento_circulation/equipements/chargement': (_) =>
        const ChargementPage(),
    '/pa/memento_circulation/equipements/plaques': (_) => const PlaquesPage(),
    '/pa/memento_circulation/equipements/retroviseurs_vision': (_) =>
        const RetroviseursVisionPage(),
    '/pa/memento_circulation/equipements/essuie_glace': (_) =>
        const EssuieGlacePage(),
    '/pa/memento_circulation/equipements/nuisances': (_) =>
        const NuisancesVehiculesPage(),
    '/pa/memento_circulation/equipements/ceinture_retenue_enfant': (_) =>
        const CeintureRetenueEnfantPage(),
    '/pa/memento_circulation/equipements/casque_gants': (_) =>
        const CasqueGantsPage(),
    '/pa/memento_circulation/equipements/casque_cycliste': (_) =>
        const CasqueCyclistePage(),
    '/pa/memento_circulation/equipements/gilet_haute_visibilite': (_) =>
        const GiletHauteVisibilitePage(),
    '/gpx/pv_apj20/ipm/pv_ipm_remise_tiers': (_) =>
        const PvIpmRemiseTiersPage(),
    GpxExamCultureGeneralePage.routeName: (_) =>
        const GpxExamCultureGeneralePage(),
    ResetPasswordPage.routeName: (_) => const ResetPasswordPage(),
    // NOTE : AttentionVisuellePage (lib/content/gpx_exam/psycotechniques/)
    // portait le meme routeName que AttentionVisuellePageNew
    // (lib/features/gpx_exam/psychotechniques/, alimentee par Supabase).
    // C'est cette derniere qui est enregistree plus bas ; l'ancienne entree
    // a ete retiree pour supprimer le doublon de cle.
    GpxExamConcoursHomePage.routeName: (_) => const GpxExamConcoursHomePage(),
    GpxCasPratiqueCase6Page.routeName: (_) => const GpxCasPratiqueCase6Page(),
    GpxCasPratiqueCase5Page.routeName: (_) => const GpxCasPratiqueCase5Page(),
    GpxCasPratiqueCase4Page.routeName: (_) => const GpxCasPratiqueCase4Page(),
    GpxCasPratiqueCase3Page.routeName: (_) => const GpxCasPratiqueCase3Page(),
    GpxCasPratiqueCase1Page.routeName: (_) => const GpxCasPratiqueCase1Page(),
    GpxCasPratiqueListPage.routeName: (_) => const GpxCasPratiqueListPage(),
    CasPratiqueDynamicPage.routeName: (_) => const CasPratiqueDynamicPage(),
    GpxCasPratiqueEtapesReussitePage.routeName: (_) =>
        const GpxCasPratiqueEtapesReussitePage(),
    GpxCasPratiqueEntrainementWelcomePage.routeName: (_) =>
        const GpxCasPratiqueEntrainementWelcomePage(),

    // ─────────────────────────────────────────────────────────────────────
    //  GPX EXAM — CAS PRATIQUE : pages annexes
    //  (elles existaient dans lib/ mais n'etaient pas enregistrees ici,
    //   ce qui renvoyait l'utilisateur sur l'ecran 404 _NotFoundScreen)
    // ─────────────────────────────────────────────────────────────────────
    // ═══════════════════════════════════════════════════════════════════
    //  GPX SCOLARITE — Quiz de fin de module (moteur generique Supabase)
    //
    //  Ces 12 quiz etaient references dans les menus mais n'existaient pas :
    //  l'utilisateur tombait sur l'ecran 404.
    //
    //  Ils sont servis par QuizScolariteDynamiquePage, qui lit ses questions
    //  dans la table `quiz_scolarite_questions`. Aucune question n'est ecrite
    //  en dur : tout se corrige depuis le panel admin, sans republier
    //  l'application sur les stores.
    // ═══════════════════════════════════════════════════════════════════
    QuizScolariteDynamiquePage.routeName: (_) =>
        const QuizScolariteDynamiquePage(),

    '/gpx/institution/laicite/quiz': (_) =>
        const QuizScolariteDynamiquePage(module: 'gpx_institution_laicite'),
    '/gpx/intervention/accident-circulation/quiz': (_) =>
        const QuizScolariteDynamiquePage(
          module: 'gpx_intervention_accident_circulation',
        ),
    '/gpx/intervention/animal/quiz': (_) =>
        const QuizScolariteDynamiquePage(module: 'gpx_intervention_animal'),
    '/gpx/intervention/debit-boissons/quiz': (_) =>
        const QuizScolariteDynamiquePage(
          module: 'gpx_intervention_debit_boissons',
        ),
    '/gpx/intervention/etrangers/quiz': (_) =>
        const QuizScolariteDynamiquePage(module: 'gpx_intervention_etrangers'),
    '/gpx/intervention/malades-mentaux/quiz': (_) =>
        const QuizScolariteDynamiquePage(
          module: 'gpx_intervention_malades_mentaux',
        ),
    '/gpx/intervention/mineurs/quiz': (_) =>
        const QuizScolariteDynamiquePage(module: 'gpx_intervention_mineurs'),
    '/gpx/intervention/stupefiants/quiz': (_) =>
        const QuizScolariteDynamiquePage(
          module: 'gpx_intervention_stupefiants',
        ),
    '/gpx/intervention/autres/quiz': (_) =>
        const QuizScolariteDynamiquePage(module: 'gpx_intervention_autres'),
    '/gpx/memento_circulation/controle_routier/quiz': (_) =>
        const QuizScolariteDynamiquePage(
          module: 'gpx_circulation_controle_routier',
        ),
    '/gpx/memento_circulation/equipements/quiz': (_) =>
        const QuizScolariteDynamiquePage(module: 'gpx_circulation_equipements'),
    '/gpx/memento_circulation/procedures/quiz': (_) =>
        const QuizScolariteDynamiquePage(module: 'gpx_circulation_procedures'),

    // ═══════════════════════════════════════════════════════════════════
    //  PA SCOLARITE — Quiz de parité avec GPX (audit du 29/07/2026)
    //
    //  Ces 4 sujets ont un cours PA identique au cours GPX mais n'avaient
    //  aucun quiz PA dédié — le quiz GPX existait, pas son équivalent PA.
    //  Contenu dupliqué depuis les modules gpx_* correspondants (décision
    //  utilisateur : cours identiques, retour utilisateur/quiz doivent
    //  rester séparés par piste pour un suivi de progression correct).
    // ═══════════════════════════════════════════════════════════════════
    '/pa/institution/laicite/quiz': (_) =>
        const QuizScolariteDynamiquePage(module: 'pa_institution_laicite'),
    '/pa/memento_circulation/controle_routier/quiz': (_) =>
        const QuizScolariteDynamiquePage(
          module: 'pa_circulation_controle_routier',
        ),
    '/pa/memento_circulation/equipements/quiz': (_) =>
        const QuizScolariteDynamiquePage(module: 'pa_circulation_equipements'),
    '/pa/memento_circulation/procedures/quiz': (_) =>
        const QuizScolariteDynamiquePage(module: 'pa_circulation_procedures'),

    // ═══════════════════════════════════════════════════════════════════
    //  GPX SCOLARITE — MODULE « DIMENSION HUMAINE »
    //
    //  Le module figurait dans le menu mais n'avait jamais ete code :
    //  15 entrees renvoyaient sur l'ecran 404.
    //
    //  Les 12 fiches de cours sont servies par CoursScolaritePage, qui lit
    //  son contenu (Markdown, points cles, references legales) dans la
    //  table `cours_scolarite`. Les 3 quiz utilisent le moteur generique.
    // ═══════════════════════════════════════════════════════════════════
    CoursScolaritePage.routeName: (_) => const CoursScolaritePage(),

    // Communication & posture
    '/gpx/dimension_humaine/communication/dh1_fonctionnement': (_) =>
        const CoursScolaritePage(
          courseRoute:
              '/gpx/dimension_humaine/communication/dh1_fonctionnement',
        ),
    '/gpx/dimension_humaine/communication/dh3_strategies_public': (_) =>
        const CoursScolaritePage(
          courseRoute:
              '/gpx/dimension_humaine/communication/dh3_strategies_public',
        ),
    '/gpx/dimension_humaine/communication/dh4_coordination_equipes': (_) =>
        const CoursScolaritePage(
          courseRoute:
              '/gpx/dimension_humaine/communication/dh4_coordination_equipes',
        ),
    '/gpx/dimension_humaine/communication/adh2_posture_victime': (_) =>
        const CoursScolaritePage(
          courseRoute:
              '/gpx/dimension_humaine/communication/adh2_posture_victime',
        ),
    '/gpx/dimension_humaine/communication/s3_2_violences_intrafamiliales':
        (_) => const CoursScolaritePage(
          courseRoute:
              '/gpx/dimension_humaine/communication/s3_2_violences_intrafamiliales',
        ),
    '/gpx/dimension_humaine/communication/quiz': (_) =>
        const QuizScolariteDynamiquePage(module: 'gpx_dh_communication'),

    // Stress & gestion emotionnelle
    '/gpx/dimension_humaine/stress/dh2_stress': (_) => const CoursScolaritePage(
      courseRoute: '/gpx/dimension_humaine/stress/dh2_stress',
    ),
    '/gpx/dimension_humaine/stress/dh2_carnet_ressources': (_) =>
        const CoursScolaritePage(
          courseRoute: '/gpx/dimension_humaine/stress/dh2_carnet_ressources',
        ),
    '/gpx/dimension_humaine/stress/adh9_agressivite': (_) =>
        const CoursScolaritePage(
          courseRoute: '/gpx/dimension_humaine/stress/adh9_agressivite',
        ),
    '/gpx/dimension_humaine/stress/ac6_conduites_suicidaires': (_) =>
        const CoursScolaritePage(
          courseRoute:
              '/gpx/dimension_humaine/stress/ac6_conduites_suicidaires',
        ),
    '/gpx/dimension_humaine/stress/quiz': (_) =>
        const QuizScolariteDynamiquePage(module: 'gpx_dh_stress'),

    // Ethique au quotidien
    '/gpx/dimension_humaine/ethique/adh1_facultes_mentales': (_) =>
        const CoursScolaritePage(
          courseRoute: '/gpx/dimension_humaine/ethique/adh1_facultes_mentales',
        ),
    '/gpx/dimension_humaine/ethique/adh4_violences_sexuelles_sexistes': (_) =>
        const CoursScolaritePage(
          courseRoute:
              '/gpx/dimension_humaine/ethique/adh4_violences_sexuelles_sexistes',
        ),
    '/gpx/dimension_humaine/ethique/adh6_confrontation_mort': (_) =>
        const CoursScolaritePage(
          courseRoute: '/gpx/dimension_humaine/ethique/adh6_confrontation_mort',
        ),
    '/gpx/dimension_humaine/ethique/quiz': (_) =>
        const QuizScolariteDynamiquePage(module: 'gpx_dh_ethique'),

    // ═══════════════════════════════════════════════════════════════════
    //  DERNIERS LIENS DE MENU SANS PAGE (audit 2026-07-26)
    // ═══════════════════════════════════════════════════════════════════

    // PA EXAM — structure du concours (fiches redigees, servies par
    // CoursScolaritePage). L'equivalent GPX existait deja.
    '/pa_exam/concours/epreuves/tableau': (_) => const CoursScolaritePage(
      courseRoute: '/pa_exam/concours/epreuves/tableau',
    ),
    '/pa_exam/concours/epreuves/visite_medicale_enquete': (_) =>
        const CoursScolaritePage(
          courseRoute: '/pa_exam/concours/epreuves/visite_medicale_enquete',
        ),

    // GPX EXAM — « Langue & culture generale » pointait vers une route
    // inexistante ; le quiz correspondant est celui de francais.
    '/gpx_exam/concours/culture_generale_langue': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return const SignInPage();
      return QuizCultureGeneralFrance(uid: user.id, email: user.email ?? '');
    },

    // PA SCOLARITE — le quiz existait sous un autre chemin.
    '/pa/dps_dpg/quiz/quiz_circulation_routiere': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return const SignInPage();
      return QuizCirculationRoutierePA(uid: user.id, email: user.email ?? '');
    },

    // ─────────────────────────────────────────────────────────────────────
    //  GPX SCOLARITE — Libertes publiques
    //  Les 3 pages de cours existaient et etaient importees dans main.dart,
    //  mais aucune n'etait enregistree : le menu renvoyait sur le 404.
    // ─────────────────────────────────────────────────────────────────────
    LibertesExpressionCollectivesPage.routeName: (_) =>
        const LibertesExpressionCollectivesPage(),
    GarantiesProtectionLibertesPage.routeName: (_) =>
        const GarantiesProtectionLibertesPage(),
    LibertesIndividuellesViePriveePage.routeName: (_) =>
        const LibertesIndividuellesViePriveePage(),

    // PlaintePage etait poussee par nom depuis procedure_penale_page.dart
    // sans etre enregistree.
    PlaintePage.routeName: (_) => const PlaintePage(),

    // Alias : la page declare `/gpx/dps/generalites/quiz/libertes_publiques`
    // alors que le routeur ne connaissait que `/gpx/generalites/quiz/...`.
    QuizLibertesPubliquesPage.routeName: (_) {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return const SignInPage();
      return QuizLibertesPubliquesPage(uid: user.id, email: user.email ?? '');
    },

    CasPratiqueMyAppealsPage.routeName: (_) => const CasPratiqueMyAppealsPage(),
    CpMemosListPage.routeName: (_) => const CpMemosListPage(),
    CpMemoReaderPage.routeName: (context) {
      final args = ModalRoute.of(context)?.settings.arguments;
      final slug = (args is String)
          ? args
          : (args is Map && args['slug'] is String)
          ? args['slug'] as String
          : '';
      return CpMemoReaderPage(slug: slug);
    },
    CpNotifPrefsPage.routeName: (_) => const CpNotifPrefsPage(),
    CpPaywallPage.routeName: (context) {
      final args = ModalRoute.of(context)?.settings.arguments;
      final trigger = (args is String)
          ? args
          : (args is Map && args['trigger'] is String)
          ? args['trigger'] as String
          : null;
      return CpPaywallPage(trigger: trigger);
    },
    CasPratiqueLeaderboardPage.routeName: (_) =>
        const CasPratiqueLeaderboardPage(),
    CasPratiqueReferralPage.routeName: (_) => const CasPratiqueReferralPage(),
    CpPrivacyPage.routeName: (_) => const CpPrivacyPage(),
    CasPratiqueOnboardingPremiumPage.routeName: (context) {
      final args = ModalRoute.of(context)?.settings.arguments;
      String? next;
      if (args is String) {
        next = args;
      } else if (args is Map && args['nextRoute'] is String) {
        next = args['nextRoute'] as String;
      }
      return CasPratiqueOnboardingPremiumPage(nextRoute: next);
    },
    CasPratiqueConcoursBlancPage.routeName: (context) {
      final args = ModalRoute.of(context)?.settings.arguments;
      String? mockExamId;
      if (args is String) {
        mockExamId = args;
      } else if (args is Map && args['mockExamId'] is String) {
        mockExamId = args['mockExamId'] as String;
      }
      return CasPratiqueConcoursBlancPage(mockExamId: mockExamId);
    },
    CasPratiqueShareScorePage.routeName: (context) {
      final args = ModalRoute.of(context)?.settings.arguments;
      final map = (args is Map) ? args : const <String, dynamic>{};
      return CasPratiqueShareScorePage(args: ShareScoreArgs.fromMap(map));
    },

    // ─────────────────────────────────────────────────────────────────────
    //  GPX EXAM — TESTS PSYCHOTECHNIQUES (module features/gpx_exam)
    //  Les 10 pages existaient mais aucune n'etait routee.
    // ─────────────────────────────────────────────────────────────────────
    ComprendreEpreuvePsychoPage.routeName: (_) =>
        const ComprendreEpreuvePsychoPage(),
    ModeConcoursPsychoPage.routeName: (_) => const ModeConcoursPsychoPage(),
    CalculMentalPage.routeName: (_) => const CalculMentalPage(),
    LogiqueVerbalePage.routeName: (_) => const LogiqueVerbalePage(),
    RaisonnementLogiquePage.routeName: (_) => const RaisonnementLogiquePage(),
    RaisonnementSpatialPage.routeName: (_) => const RaisonnementSpatialPage(),
    RotationsSymetriesPage.routeName: (_) => const RotationsSymetriesPage(),
    ConcentrationPage.routeName: (_) => const ConcentrationPage(),
    AttentionVisuellePageNew.routeName: (_) => const AttentionVisuellePageNew(),
    SuitesLogiquesPageNew.routeName: (_) => const SuitesLogiquesPageNew(),

    // ═══════════════════════════════════════════════════════════════
    //  ROUTES RETABLIES — audit 2026-07-26
    //  64 pages existantes qui n'etaient pas enregistrees.
    // ═══════════════════════════════════════════════════════════════
    // ── GPX SCOLARITE — pages existantes qui n'etaient pas routees (23) ──
    AutresCadresEnquetePage.routeName: (_) => const AutresCadresEnquetePage(),
    CadresEnquetePage.routeName: (_) => const CadresEnquetePage(),
    EnquetePreliminairePage.routeName: (_) => const EnquetePreliminairePage(),
    ArmesAcquisitionDetentionABPage.routeName: (_) =>
        const ArmesAcquisitionDetentionABPage(),
    ArmesClassificationPage.routeName: (_) => const ArmesClassificationPage(),
    ArmesDefinitionsPage.routeName: (_) => const ArmesDefinitionsPage(),
    ArmesMaterielsGuerreElementsPage.routeName: (_) =>
        const ArmesMaterielsGuerreElementsPage(),
    ArmesPortTransportCDPage.routeName: (_) => const ArmesPortTransportCDPage(),
    ArmesReglesAcquisitionDetentionPage.routeName: (_) =>
        const ArmesReglesAcquisitionDetentionPage(),
    ArmesReglesPortTransportPage.routeName: (_) =>
        const ArmesReglesPortTransportPage(),
    // PA — Armes & munitions (catégorie dédiée, câblée le 29/07/2026,
    // séparation stricte PA/GPX)
    PaArmesAcquisitionDetentionABPage.routeName: (_) =>
        const PaArmesAcquisitionDetentionABPage(),
    PaArmesClassificationPage.routeName: (_) =>
        const PaArmesClassificationPage(),
    PaArmesDefinitionsPage.routeName: (_) => const PaArmesDefinitionsPage(),
    PaArmesIntroductionPage.routeName: (_) => const PaArmesIntroductionPage(),
    PaArmesMaterielsGuerreElementsPage.routeName: (_) =>
        const PaArmesMaterielsGuerreElementsPage(),
    PaArmesPortTransportCDPage.routeName: (_) =>
        const PaArmesPortTransportCDPage(),
    PaArmesReglesAcquisitionDetentionPage.routeName: (_) =>
        const PaArmesReglesAcquisitionDetentionPage(),
    PaArmesReglesPortTransportPage.routeName: (_) =>
        const PaArmesReglesPortTransportPage(),
    RecelNonJustificationContenuPage.routeName: (_) =>
        const RecelNonJustificationContenuPage(),
    VolPage.routeName: (_) => const VolPage(),
    LibertesPubliquesIntroductionContenuPage.routeName: (_) =>
        const LibertesPubliquesIntroductionContenuPage(),
    StupefiantsBlanchimentProduitPage.routeName: (_) =>
        const StupefiantsBlanchimentProduitPage(),
    StupefiantsCessionOffrePage.routeName: (_) =>
        const StupefiantsCessionOffrePage(),
    StupefiantsDirectionOrganisationPage.routeName: (_) =>
        const StupefiantsDirectionOrganisationPage(),
    StupefiantsFacilitationUsagePage.routeName: (_) =>
        const StupefiantsFacilitationUsagePage(),
    StupefiantsImportExportPage.routeName: (_) =>
        const StupefiantsImportExportPage(),
    StupefiantsIntroductionPage.routeName: (_) =>
        const StupefiantsIntroductionPage(),
    StupefiantsProductionFabricationPage.routeName: (_) =>
        const StupefiantsProductionFabricationPage(),
    StupefiantsProvocationMajeurPage.routeName: (_) =>
        const StupefiantsProvocationMajeurPage(),
    StupefiantsTransportDetentionOffrePage.routeName: (_) =>
        const StupefiantsTransportDetentionOffrePage(),
    StupefiantsUsageIllicitePage.routeName: (_) =>
        const StupefiantsUsageIllicitePage(),

    // ── PA SCOLARITE — pages existantes qui n'etaient pas routees (41) ──
    PaCadresEnqueteIntroPage.routeName: (_) => const PaCadresEnqueteIntroPage(),
    PaCommissionRogatoireIntroPage.routeName: (_) =>
        const PaCommissionRogatoireIntroPage(),
    PaControleIdentiteContenuPage.routeName: (_) =>
        const PaControleIdentiteContenuPage(),
    PaCriminaliteOrganiseeContenuPage.routeName: (_) =>
        const PaCriminaliteOrganiseeContenuPage(),
    PaDisparitionIntroPage.routeName: (_) => const PaDisparitionIntroPage(),
    PaEnquetePreliminaireIntroPage.routeName: (_) =>
        const PaEnquetePreliminaireIntroPage(),
    PaFlagrantDelitIntroPage.routeName: (_) => const PaFlagrantDelitIntroPage(),
    PaMortInconnueIntroPage.routeName: (_) => const PaMortInconnueIntroPage(),
    PaPersonneBlesseGrievementntroPage.routeName: (_) =>
        const PaPersonneBlesseGrievementntroPage(),
    PaPersonnesFuiteIntroGpxSchool.routeName: (_) =>
        const PaPersonnesFuiteIntroGpxSchool(),
    PaConduiteStupefiantsPage.routeName: (_) =>
        const PaConduiteStupefiantsPage(),
    PaDefautAssurancePage.routeName: (_) => const PaDefautAssurancePage(),
    PaDefautPermisPage.routeName: (_) => const PaDefautPermisPage(),
    PaDelitFuitePage.routeName: (_) => const PaDelitFuitePage(),
    PaEtatAlcooliquePage.routeName: (_) => const PaEtatAlcooliquePage(),
    PaGrandExcesVitessePage.routeName: (_) => const PaGrandExcesVitessePage(),
    PaIncitationOrganisationPromotionPage.routeName: (_) =>
        const PaIncitationOrganisationPromotionPage(),
    PaIvressePage.routeName: (_) => const PaIvressePage(),
    PaPlaquesInscriptionsPage.routeName: (_) =>
        const PaPlaquesInscriptionsPage(),
    PaRefusObtempererPage.routeName: (_) => const PaRefusObtempererPage(),
    PaRefusVerificationsPage.routeName: (_) => const PaRefusVerificationsPage(),
    PaRodeoMotorisePage.routeName: (_) => const PaRodeoMotorisePage(),
    PaCharteAccueilPublicVictimesPage.routeName: (_) =>
        const PaCharteAccueilPublicVictimesPage(),
    PaDemarchesAdministrativesPage.routeName: (_) =>
        const PaDemarchesAdministrativesPage(),
    PaGpxDoctrineAccueilVictimesVcPage.routeName: (_) =>
        const PaGpxDoctrineAccueilVictimesVcPage(),
    PaReferentielMariannePage.routeName: (_) =>
        const PaReferentielMariannePage(),
    PaProtectionLocauxPolicePage.routeName: (_) =>
        const PaProtectionLocauxPolicePage(),
    PaCodeDeontologieCodeCommentePage.routeName: (_) =>
        const PaCodeDeontologieCodeCommentePage(),
    PaDroitsObligationsPoliciersPage.routeName: (_) =>
        const PaDroitsObligationsPoliciersPage(),
    PaEnqueteAdministrativePage.routeName: (_) =>
        const PaEnqueteAdministrativePage(),
    PaHorsServiceAmarisPage.routeName: (_) => const PaHorsServiceAmarisPage(),
    PaMarquesExterieuresRespectPage.routeName: (_) =>
        const PaMarquesExterieuresRespectPage(),
    PaReseauxSociauxPage.routeName: (_) => const PaReseauxSociauxPage(),
    PaSanctionsRecompensesPage.routeName: (_) =>
        const PaSanctionsRecompensesPage(),
    PaCompteRenduPage.routeName: (_) => const PaCompteRenduPage(),
    PaFormalismeRapportPage.routeName: (_) => const PaFormalismeRapportPage(),
    PaModelesRapportsPage.routeName: (_) => const PaModelesRapportsPage(),
    PaHistoireReperesPage.routeName: (_) => const PaHistoireReperesPage(),
    PaCharteLaiciteServicesPublicsPage.routeName: (_) =>
        const PaCharteLaiciteServicesPublicsPage(),
    PaGpxLaiciteDlpajPage.routeName: (_) => const PaGpxLaiciteDlpajPage(),
    PaRitesCultesFrancePage.routeName: (_) => const PaRitesCultesFrancePage(),

    GPXAdmissionPage.routeName: (_) => const GPXAdmissionPage(),
    GPXAdmissibilitePage.routeName: (_) => const GPXAdmissibilitePage(),
    TableauRecapitulatifEpreuvesGPXPage.routeName: (_) =>
        const TableauRecapitulatifEpreuvesGPXPage(),
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
    InfructueuseTentativePage.routeName: (_) =>
        const InfructueuseTentativePage(),
    TentativeContenuPage.routeName: (_) => const TentativeContenuPage(),
    CompliciteIntroPage.routeName: (_) => const CompliciteIntroPage(),
    CompliciteContenuPage.routeName: (_) => const CompliciteContenuPage(),
    CompliciteConditionPage.routeName: (_) => const CompliciteConditionPage(),
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
    // PA — pages dédiées "Généralités" / "Hiérarchie" (séparation stricte PA/GPX)
    PaClassificationInfractionsPage.routeName: (_) =>
        const PaClassificationInfractionsPage(),
    PaInfractionIntroPage.routeName: (_) => const PaInfractionIntroPage(),
    PaTentativeIntroPage.routeName: (_) => const PaTentativeIntroPage(),
    PaCompliciteIntroPage.routeName: (_) => const PaCompliciteIntroPage(),
    PaLegitimeDefenseIntroPage.routeName: (_) =>
        const PaLegitimeDefenseIntroPage(),
    PaUsageArmesIntroPage.routeName: (_) => const PaUsageArmesIntroPage(),
    PaLibertesPubliquesIntroPage.routeName: (_) =>
        const PaLibertesPubliquesIntroPage(),
    PaRetentionLocauxIntroPage.routeName: (_) =>
        const PaRetentionLocauxIntroPage(),
    PaHierarchieIntroPage.routeName: (_) => const PaHierarchieIntroPage(),
    // PA — pages "Contenu" dédiées, câblées comme cibles des intro pages
    // ci-dessus (audit du 29/07/2026 : ces intro pages redirigeaient encore
    // vers le contenu GPX partagé au lieu de leur contenu PA existant)
    PaClassificationInfractionsContenuPageLoiPenal.routeName: (_) =>
        const PaClassificationInfractionsContenuPageLoiPenal(),
    PaGPXSchoolElementsConstitutifsInfractionPage.routeName: (_) =>
        const PaGPXSchoolElementsConstitutifsInfractionPage(),
    TentativeContenuPagePA.routeName: (_) => const TentativeContenuPagePA(),
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
    // PA — Procédure Pénale (catégorie dédiée, câblée le 29/07/2026,
    // séparation stricte PA/GPX)
    PaJuridictionContenuPage.routeName: (_) => const PaJuridictionContenuPage(),
    PaActionPubliqueIntroPage.routeName: (_) =>
        const PaActionPubliqueIntroPage(),
    PaPPActionPubliqueActionCivilePage.routeName: (_) =>
        const PaPPActionPubliqueActionCivilePage(),
    PaNulliteIntroPage.routeName: (_) => const PaNulliteIntroPage(),
    PaPPNulliteActesProcedureContenuPage.routeName: (_) =>
        const PaPPNulliteActesProcedureContenuPage(),
    PaInstructionIntroPage.routeName: (_) => const PaInstructionIntroPage(),
    PaInstructionContenuPage.routeName: (_) => const PaInstructionContenuPage(),
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
    // PA — Atteintes aux mineurs & à la famille (catégorie dédiée, câblée le
    // 29/07/2026, séparation stricte PA/GPX)
    PaAutoriteParentalePage.routeName: (_) => const PaAutoriteParentalePage(),
    PaAbandonFamillePage.routeName: (_) => const PaAbandonFamillePage(),
    PaViolationOrdonnancesJafPage.routeName: (_) =>
        const PaViolationOrdonnancesJafPage(),
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
    // PA — Crimes & délits contre la nation (catégorie dédiée, câblée le
    // 29/07/2026, séparation stricte PA/GPX)
    PaAssociationMalfaiteursPage.routeName: (_) =>
        const PaAssociationMalfaiteursPage(),
    PaAbusAutoriteParticuliersContenuPage.routeName: (_) =>
        const PaAbusAutoriteParticuliersContenuPage(),
    PaAtteintesActionJusticeContenuPage.routeName: (_) =>
        const PaAtteintesActionJusticeContenuPage(),
    PaFauxUsageFauxContenuPage.routeName: (_) =>
        const PaFauxUsageFauxContenuPage(),
    PaProbiteContenuPage.routeName: (_) => const PaProbiteContenuPage(),
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
    // GPX — pages dédiées "Organisation de la Police Nationale"
    // (anciennement partagées avec PA ; séparation stricte PA/GPX)
    '/gpx/institution/organisation_pn/organigramme_mi': (_) =>
        const OrganigrammeMinistereInterieurPage(),
    '/gpx/institution/organisation_pn/organisation': (_) =>
        const OrganisationPoliceNationalePage(),
    '/gpx/institution/organisation_pn/dgsi': (_) => const DgsiPage(),
    '/gpx/institution/organisation_pn/prefecture_police': (_) =>
        const PrefecturePolicePage(),
    '/gpx/institution/organisation_pn/organigrammes': (_) =>
        const OrganigrammesPnPage(),
    '/gpx/institution/organisation_pn/hierarchie': (_) =>
        const HierarchiePnPage(),
    '/gpx/institution/organisation_pn/regles_emploi_pa': (_) =>
        const ReglesEmploiPaPage(),
    '/gpx/institution/organisation_pn/horaires_service_sp': (_) =>
        const HorairesServiceSpPage(),
    // PA — pages dédiées "Organisation de la Police Nationale"
    PaOrganigrammeMinistereInterieurPage.routeName: (_) =>
        const PaOrganigrammeMinistereInterieurPage(),
    PaOrganisationPoliceNationalePage.routeName: (_) =>
        const PaOrganisationPoliceNationalePage(),
    PaDgsiPage.routeName: (_) => const PaDgsiPage(),
    PaPrefecturePolicePage.routeName: (_) => const PaPrefecturePolicePage(),
    PaOrganigrammesPnPage.routeName: (_) => const PaOrganigrammesPnPage(),
    PaHierarchiePnPage.routeName: (_) => const PaHierarchiePnPage(),
    PaReglesEmploiPaPage.routeName: (_) => const PaReglesEmploiPaPage(),
    PaHorairesServiceSpPage.routeName: (_) => const PaHorairesServiceSpPage(),
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
    // PA — La sanction (catégorie dédiée, câblée le 29/07/2026,
    // séparation stricte PA/GPX)
    PaClassificationPeinesPage.routeName: (_) =>
        const PaClassificationPeinesPage(),
    PaCausesAggravationSanctionContenuPage.routeName: (_) =>
        const PaCausesAggravationSanctionContenuPage(),
    PaPluraliteInfractionsPage.routeName: (_) =>
        const PaPluraliteInfractionsPage(),
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

    // ══════════════════════════════════════════════════════════════════
    //  GPX EXAM — Tests psychotechniques : ANCIENNES ROUTES (legacy)
    //
    //  Ces 4 routes pointaient vers les quiz hardcodes de
    //  lib/content/gpx_exam/psycotechniques/. Elles faisaient DOUBLON avec
    //  le module lib/features/gpx_exam/psychotechniques/ (alimente par
    //  Supabase : 283 000 questions) vers lequel pointe le menu GPX Exam.
    //  Comme elles etaient declarees APRES dans la map, elles ecrasaient
    //  silencieusement les bonnes routes.
    //
    //  Elles crashaient en outre lorsque l'utilisateur n'etait pas
    //  connecte (`user!.id` sur un `currentUser` null).
    //
    //  -> `logique_verbale` et `suites_logiques` sont desormais servies par
    //     le module features. `calcul_rapide` et `attention_concentration`
    //     sont redirigees vers leurs equivalents features.
    // ══════════════════════════════════════════════════════════════════
    '/gpx_exam/concours/tests_psychotechniques/calcul_rapide': (_) =>
        const CalculMentalPage(),
    '/gpx_exam/concours/tests_psychotechniques/attention_concentration': (_) =>
        const ConcentrationPage(),

    // ══════════════════════════════════════════════════════════════════
    //  PA — Concours | Tests psychotechniques (module indépendant du GPX,
    //  tracking séparé : track='pa' / module='pa_psychotechnique')
    // ══════════════════════════════════════════════════════════════════
    PaTestsPsyHomePage.routeName: (_) => const PaTestsPsyHomePage(),
    PaTestsPsyAnalysePage.routeName: (_) => const PaTestsPsyAnalysePage(),
    PaTestsPsyPersonnalitePage.routeName: (_) =>
        const PaTestsPsyPersonnalitePage(),
    PaTestsPsyRaisonnementHubPage.routeName: (_) =>
        const PaTestsPsyRaisonnementHubPage(),
    PaTestsPsyObservationHubPage.routeName: (_) =>
        const PaTestsPsyObservationHubPage(),
    PaTestsPsyQcmHubPage.routeName: (_) => const PaTestsPsyQcmHubPage(),
    PaTestsPsyExercicesHubPage.routeName: (_) =>
        const PaTestsPsyExercicesHubPage(),
    PaTestsPsyCorrigesPage.routeName: (_) => const PaTestsPsyCorrigesPage(),
    PaTestsPsyRoutes.aptitudeVerbale: (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return PaQuizPsycotechniquesVerbal(uid: user!.id, email: user.email!);
    },
    PaAttentionVisuellePage.routeName: (_) => const PaAttentionVisuellePage(),
    PaTestsPsyRoutes.exSuitesLogiques: (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return PaQuizPsycotechniquesSuitesLogiques(
        uid: user!.id,
        email: user.email!,
      );
    },
    PaTestsPsyRoutes.exLogiqueVerbale: (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return PaQuizPsycotechniquesVerbal(uid: user!.id, email: user.email!);
    },
    PaTestsPsyRoutes.exConcentration: (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return PaQuizPsycotechniquesConcentration(
        uid: user!.id,
        email: user.email!,
      );
    },
    PaTestsPsyRoutes.exCalcul: (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return PaQuizPsycotechniquesCalcul(uid: user!.id, email: user.email!);
    },
    PaTestsPsyRoutes.exRaisonnement: (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return PaQuizPsycotechniquesRaisonnement(
        uid: user!.id,
        email: user.email!,
      );
    },

    // ══════════════════════════════════════════════════════════════════
    //  PA — Concours | Connaissances générales (module indépendant du GPX,
    //  tracking séparé : track='pa' / quiz_name préfixé 'PA - ')
    // ══════════════════════════════════════════════════════════════════
    PaConnaissancesGeneralesHomePage.routeName: (_) =>
        const PaConnaissancesGeneralesHomePage(),
    PaCgFichesPage.routeName: (_) => const PaCgFichesPage(),
    PaCgQcmHubPage.routeName: (_) => const PaCgQcmHubPage(),
    PaCgExercicesHubPage.routeName: (_) => const PaCgExercicesHubPage(),
    PaCgCorrigesPage.routeName: (_) => const PaCgCorrigesPage(),
    PaCgRoutes.exHistoire: (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return PaQuizCultureGeneraleHistoireFrance(
        uid: user!.id,
        email: user.email!,
      );
    },
    PaCgRoutes.exInstitutions: (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return PaQuizCultureGeneralInstitutionsEuropeenes(
        uid: user!.id,
        email: user.email!,
      );
    },
    PaCgRoutes.exActualite: (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return PaQuizCultureGeneraleActualite(uid: user!.id, email: user.email!);
    },
    PaCgRoutes.exGeographie: (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return PaQuizCultureGeneraleGeographie(uid: user!.id, email: user.email!);
    },
    PaCgRoutes.exFrancais: (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return PaQuizCultureGeneralFrance(uid: user!.id, email: user.email!);
    },
    PaCgRoutes.exSport: (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return PaQuizCultureGeneraleSport(uid: user!.id, email: user.email!);
    },
    PaCgRoutes.exSciences: (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return PaQuizCultureGeneraleSciences(uid: user!.id, email: user.email!);
    },
    PaCgRoutes.exSante: (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return PaQuizCultureGeneraleSante(uid: user!.id, email: user.email!);
    },
    PaCgRoutes.exPolice: (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return PaQuizCultureGeneralePolice(uid: user!.id, email: user.email!);
    },
    PaCgRoutes.exMythologie: (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return PaQuizCultureGeneraleMythologie(uid: user!.id, email: user.email!);
    },
    PaCgRoutes.exMusique: (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return PaQuizCultureGeneraleMusique(uid: user!.id, email: user.email!);
    },
    PaCgRoutes.exCinema: (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return PaQuizCultureGeneraleCinema(uid: user!.id, email: user.email!);
    },
    PaCgRoutes.exDroit: (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return PaQuizCultureGeneraleDroit(uid: user!.id, email: user.email!);
    },
    PaCgRoutes.exSecuriteRoutiere: (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return PaQuizCultureGeneraleSecuriteRoutiere(
        uid: user!.id,
        email: user.email!,
      );
    },

    // ══════════════════════════════════════════════════════════════════
    //  PA — Concours | Épreuve de photolangage
    // ══════════════════════════════════════════════════════════════════
    PaPhotolangageHubPage.routeName: (_) => const PaPhotolangageHubPage(),
    PaPhotolangageAnalysePage.routeName: (_) =>
        const PaPhotolangageAnalysePage(),
    PaPhotolangageEtapesPage.routeName: (_) => const PaPhotolangageEtapesPage(),
    PaPhotolangageTrainingListPage.routeName: (_) =>
        const PaPhotolangageTrainingListPage(),
    PaPhotolangageHistoryPage.routeName: (_) =>
        const PaPhotolangageHistoryPage(),
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
    '/pa/institution/accueil_public/quiz': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return PaQuizAccueilPublicPage(uid: user!.id, email: user.email!);
    },
    '/gpx/institution/organisation_pn/quiz': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizOrganisationPnGPX(uid: user!.id, email: user.email!);
    },
    '/pa/institution/organisation_pn/quiz': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return PaQuizOrganisationPnPage(uid: user!.id, email: user.email!);
    },
    '/gpx/institution/deontologie/quiz': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizDeontologieGPX(uid: user!.id, email: user.email!);
    },
    '/pa/institution/deontologie/quiz': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return PaQuizDeontologiePage(uid: user!.id, email: user.email!);
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
    // ===== QUIZ PA =====
    '/pa/nation/quiz/abus_autorite_particuliers': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizAbusAutoritePA(uid: user!.id, email: user.email!);
    },
    '/pa/procedure_penale/quiz/action_publique': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizActionPubliquePagePA(uid: user!.id, email: user.email!);
    },
    '/pa/armes_munitions_pages/quiz/pa_quiz_armes_munitions_pages': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizArmesMunitionsPA(uid: user!.id, email: user.email!);
    },
    '/pa/crimes_personne/quiz/atteinte_personnalite': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizAtteintePersonnalitePA(uid: user!.id, email: user.email!);
    },
    '/pa/nation/quiz/atteintes_action_justice': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizAtteinteActionJusticePA(uid: user!.id, email: user.email!);
    },
    '/pa/nation/quiz/atteintes_administration': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizAtteinteAdministrationPA(uid: user!.id, email: user.email!);
    },
    '/pa/crimes_personne/quiz/atteintes_volontaires_integrite': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizAtteinteIntegritePA(uid: user!.id, email: user.email!);
    },
    '/pa/crimes_personne/quiz/atteintes_involontaires': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizAtteinteInvolontairePA(uid: user!.id, email: user.email!);
    },
    '/pa/crimes_personne/quiz/atteintes_volontaires_vie': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizAtteinteVolontairePA(uid: user!.id, email: user.email!);
    },
    '/pa/procedure_penale/quiz/bracelet_electronique': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizBraceletElectroniquePagePA(uid: user!.id, email: user.email!);
    },
    '/pa/infraction_circulation_routière_pages/quiz/pa_quiz_circulation_routiere':
        (_) {
          final user = Supabase.instance.client.auth.currentUser;
          return QuizCirculationRoutierePA(uid: user!.id, email: user.email!);
        },
    '/pa/generalites/quiz/classification_infractions': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizClassificationInfractionsPagePA(
        uid: user!.id,
        email: user.email!,
      );
    },
    '/pa/generalites/quiz/commission_rogatoire': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizCommissionRogatoirePagePA(uid: user!.id, email: user.email!);
    },
    '/pa/complicite/quiz/complicite': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizComplicitePagePA(uid: user!.id, email: user.email!);
    },
    '/pa/generalites/quiz/controle_identite': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizControleIdentitePagePA(uid: user!.id, email: user.email!);
    },
    '/pa/procedure_penale/quiz/controle_judiciaire': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizControleJudiciairePagePA(uid: user!.id, email: user.email!);
    },
    '/pa/crime_delit_nation_pages/quiz/pa_quiz_crimes_delits_bien': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizCrimesDelitsBiensPA(uid: user!.id, email: user.email!);
    },
    '/pa/crime_delit_nation_pages/quiz/pa_quiz_crimes_delits_nation': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizCrimesDelitsNationPA(uid: user!.id, email: user.email!);
    },
    '/pa/crimes_personne/quiz/crimes_delits_personne': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizCrimeDelitsPersonnePA(uid: user!.id, email: user.email!);
    },
    '/pa/generalites/quiz/criminalite_organisee': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizCriminaliteOrganiseePagePA(uid: user!.id, email: user.email!);
    },
    '/pa/crimes_biens/quiz/destructions_degradations': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizDDDPA(uid: user!.id, email: user.email!);
    },
    '/pa/procedure_penale/quiz/detention_provisoire': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizDetentionProvisoirePagePA(uid: user!.id, email: user.email!);
    },
    '/pa/crimes_personne/quiz/dignite_personne': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizDiginitePersonnePA(uid: user!.id, email: user.email!);
    },
    '/pa/generalites/quiz/disparitions_inquietantes': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizDisparitionPagePA(uid: user!.id, email: user.email!);
    },
    '/pa/procedure_penale/quiz/dispositions_applicables_mineurs': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizDispositionsApplicablesMineursPA(
        uid: user!.id,
        email: user.email!,
      );
    },
    '/pa/droit_penal/quiz/droit_penal_general': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizDroitPenalePagePA(uid: user!.id, email: user.email!);
    },
    '/pa/generalites/quiz/enquete_preliminaire': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizEnquetePreliminairePagePA(uid: user!.id, email: user.email!);
    },
    '/pa/crimes_personne/quiz/enregistrement_diffusion_images': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizEnregistrementDiffusionImagesPA(
        uid: user!.id,
        email: user.email!,
      );
    },
    '/pa/nation/quiz/faux_usage_faux': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizFauxUsageFauxPA(uid: user!.id, email: user.email!);
    },
    '/pa/generalites/quiz/flagrant_delit': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizFlagrantDelitPagePA(uid: user!.id, email: user.email!);
    },
    '/pa/procedure_penale/quiz/generalité_principales': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizGeneralitePagePA(uid: user!.id, email: user.email!);
    },
    '/pa/generalites/quiz/hierarchie': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizHierarchiePagePA(uid: user!.id, email: user.email!);
    },
    '/pa/infractions/quiz/infractions': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizInfractionsPagePA(uid: user!.id, email: user.email!);
    },
    '/pa/procedure_penale/quiz/instruction_preparatoire': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizInstructionPagePA(uid: user!.id, email: user.email!);
    },
    '/pa/libertes_publiques/quiz/introduction': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizIntroductionPA(uid: user!.id, email: user.email!);
    },
    '/pa/procedure_penale/quiz/juridictions_penales': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizJuridictionsPagePA(uid: user!.id, email: user.email!);
    },
    '/pa/generalites/quiz/legitimedefense': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizLegitimeDefensePagePA(uid: user!.id, email: user.email!);
    },
    '/pa/generalites/quiz/libertes_publiques_collectives': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizLibertesPubliquesCollectivesPagePA(
        uid: user!.id,
        email: user.email!,
      );
    },
    '/pa/generalites/quiz/garanties_libertes_publiques': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizGarantiesLibertesPagePA(uid: user!.id, email: user.email!);
    },
    '/pa/generalites/quiz/libertes_publiques_individuelles': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizLibertesPubliquesIndividuellesPagePA(
        uid: user!.id,
        email: user.email!,
      );
    },
    '/pa/generalites/quiz/libertes_publiques': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizLibertesPubliquesPagePA(uid: user!.id, email: user.email!);
    },
    '/pa/procedure_penale/quiz/mandats_justice': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizMandatsPagePA(uid: user!.id, email: user.email!);
    },
    '/pa/mineurs_famille_pages/quiz/pa_quiz_mineurs_famille': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizMineursFamillePA(uid: user!.id, email: user.email!);
    },
    '/pa/crimes_personne/quiz/mise_en_danger': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizMiseEnDangerPA(uid: user!.id, email: user.email!);
    },
    '/pa/generalites/quiz/mort_inconnue': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizMortInconnuePagePA(uid: user!.id, email: user.email!);
    },
    '/pa/procedure_penale/quiz/nullite': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizNullitePagePA(uid: user!.id, email: user.email!);
    },
    '/pa/procedure_penale/quiz/cadres_juridiques_principales': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizCadresPrincipalesPagePA(uid: user!.id, email: user.email!);
    },
    '/pa/generalites/quiz/personnes_fuite': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizPersonnesFuitePagePA(uid: user!.id, email: user.email!);
    },
    '/pa/nation/quiz/probite': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizProbitePA(uid: user!.id, email: user.email!);
    },
    '/pa/crimes_biens/quiz/recel_non_justification': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizRecelNonJustificationPA(uid: user!.id, email: user.email!);
    },
    '/pa/droit_penal/quiz/responsabilite_penal_general': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizResponsabilitePenalePagePA(uid: user!.id, email: user.email!);
    },
    '/pa/generalites/quiz/retention_locaux_police': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizRetentionLocauxPagePA(uid: user!.id, email: user.email!);
    },
    '/pa/sanction/quiz/sanction_page': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizSanctionPA(uid: user!.id, email: user.email!);
    },
    '/pa/sanction/quiz/sanction_causes_aggravation': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizSanctionAggravationPA(uid: user!.id, email: user.email!);
    },
    '/pa/sanction/quiz/sanction_classification_peine': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizSanctionClassificationPA(uid: user!.id, email: user.email!);
    },
    '/pa/sanction/quiz/sanction_pluralite_infractions': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizSanctionPluralitePA(uid: user!.id, email: user.email!);
    },
    '/pa/crimes_biens/quiz/stad': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizStadPA(uid: user!.id, email: user.email!);
    },
    '/pa/stupéfiants_pages/quiz/pa_quiz_stupéfiants': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizStupefiantPA(uid: user!.id, email: user.email!);
    },
    '/pa/generalites/quiz/tentative': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizTentativePagePA(uid: user!.id, email: user.email!);
    },
    '/pa/generalites/quiz/usagearmes': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizUsageArmesPagePA(uid: user!.id, email: user.email!);
    },
    '/pa/crimes_personne/quiz/viol_inceste_agressions': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizViolIncestePA(uid: user!.id, email: user.email!);
    },
    '/pa/crimes_biens/quiz/voisines_du_vol': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizVoisinesDuVolPA(uid: user!.id, email: user.email!);
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
    // GPX quiz mineurs/famille (routes GPX canoniques)
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
    // PA quiz mineurs/famille (routes /pa_scolarite_pages/...)
    '/pa_scolarite_pages/mineurs_famille_pages/abandon_famille/quiz_abandon_famille':
        (_) {
          final user = Supabase.instance.client.auth.currentUser;
          return QuizAbandonFamillePA(uid: user!.id, email: user.email!);
        },
    '/pa_scolarite_pages/mineurs_famille_pages/autorite_parentale/quiz_autorite_parentale':
        (_) {
          final user = Supabase.instance.client.auth.currentUser;
          return QuizAutoriteParentalePA(uid: user!.id, email: user.email!);
        },
    '/pa_scolarite_pages/mineurs_famille_pages/violation_ordonnances_jaf/quiz_ordonnances_jaf':
        (_) {
          final user = Supabase.instance.client.auth.currentUser;
          return QuizViolationOrdonnancesJafPA(
            uid: user!.id,
            email: user.email!,
          );
        },
    '/pa_scolarite_pages/mineurs_famille_pages/mise_en_peril/quiz_mise_en_peril':
        (_) {
          final user = Supabase.instance.client.auth.currentUser;
          return QuizMisePerilMineurPA(uid: user!.id, email: user.email!);
        },
    // Alias canoniques utilisés par les cartes de cours PA. Les anciens
    // chemins /pa_scolarite_pages restent disponibles pour compatibilité.
    '/pa/dps_dpg/mineurs_famille_pages/abandon_famille/quiz_abandon_famille':
        (_) {
          final user = Supabase.instance.client.auth.currentUser;
          return QuizAbandonFamillePA(uid: user!.id, email: user.email!);
        },
    '/pa/dps_dpg/mineurs_famille_pages/autorite_parentale/quiz_autorite_parentale':
        (_) {
          final user = Supabase.instance.client.auth.currentUser;
          return QuizAutoriteParentalePA(uid: user!.id, email: user.email!);
        },
    '/pa/dps_dpg/mineurs_famille_pages/violation_ordonnances_jaf/quiz_ordonnances_jaf':
        (_) {
          final user = Supabase.instance.client.auth.currentUser;
          return QuizViolationOrdonnancesJafPA(
            uid: user!.id,
            email: user.email!,
          );
        },
    '/pa/dps_dpg/mineurs_famille_pages/mise_en_peril/quiz_mise_en_peril': (_) {
      final user = Supabase.instance.client.auth.currentUser;
      return QuizMisePerilMineurPA(uid: user!.id, email: user.email!);
    },
    // GPX sanction pages standalone (routes /gpx/sanction/...)
    CausesAggravationPage.routeName: (_) => const CausesAggravationPage(),
    ClassificationPeinesPage.routeName: (_) => const ClassificationPeinesPage(),
    PluraliteInfractionsPage.routeName: (_) => const PluraliteInfractionsPage(),
    ResponsabilitePenalePage.routeName: (_) => const ResponsabilitePenalePage(),
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

    // Socle initial : Organisation judiciaire
    '/pa/dps_dpg/socle_initial/organisation_judiciaire/organisation': (_) =>
        const PaOrganisationJudiciaireHubPage(),
    '/pa/dps_dpg/socle_initial/organisation_judiciaire/magistrature': (_) =>
        const JuridictionsPenalesPage(),
    // Socle initial : Atteintes aux biens
    '/pa/dps_dpg/socle_initial/atteintes_biens/vol': (_) => const PaVolPage(),
    '/pa/dps_dpg/socle_initial/atteintes_biens/destructions': (_) =>
        const PaDestructionsDegradationsContenuPage(),
    '/pa/dps_dpg/socle_initial/atteintes_biens/sans_danger_personnes': (_) =>
        const PaSansDangerDommageLegerPage(),
    '/pa/dps_dpg/socle_initial/atteintes_biens/dangereuses_personnes': (_) =>
        const PaDestructionsDangereusesPersonnesIntentionnellePage(),
    '/pa/dps_dpg/socle_initial/atteintes_biens/tags_graffitis': (_) =>
        const PaTagsInscriptionsSignesDessinsPage(),
    // Socle initial : Atteintes aux personnes
    '/pa/dps_dpg/socle_initial/atteintes_personnes/discriminations': (_) =>
        const PaDiscriminationsPage(),
    '/pa/dps_dpg/socle_initial/atteintes_personnes/violences_volontaires':
        (_) => const PaAtteintesVolontairesIntegriteContenuPage(),
    '/pa/dps_dpg/socle_initial/atteintes_personnes/violences_habituelles':
        (_) => const PaViolencesHabituellesCoupleExPage(),
    '/pa/dps_dpg/socle_initial/atteintes_personnes/violences_fsi': (_) =>
        const PaViolencesSurFsiPage(),
    '/pa/dps_dpg/socle_initial/atteintes_personnes/atteintes_vie': (_) =>
        const PaAtteintesVolontairesVieContenuPage(),
    '/pa/dps_dpg/socle_initial/atteintes_personnes/viol': (_) =>
        const PaViolIncesteAgressionsContenuPage(),
    '/pa/dps_dpg/socle_initial/atteintes_personnes/agressions_sexuelles': (_) =>
        const PaAgressionsSexuellesAutresQueViolPage(),
    '/pa/dps_dpg/socle_initial/atteintes_personnes/harcelement_sexuel': (_) =>
        const PaHarcelementSexuelPage(),
    '/pa/dps_dpg/socle_initial/atteintes_personnes/exhibition': (_) =>
        const PaExhibitionSexuellePage(),
    '/pa/dps_dpg/socle_initial/atteintes_personnes/mineurs_mise_en_peril':
        (_) => const PaMiseEnPerilDesMineursPage(),
    '/pa/dps_dpg/socle_initial/atteintes_personnes/atteinte_intimite': (_) =>
        const PaAtteintePersonnaliteContenuPage(),
    '/pa/dps_dpg/socle_initial/atteintes_personnes/outrage_sexiste': (_) =>
        const PaOutrageSexistePage(),
    // Socle initial : Autorite de l'Etat
    '/pa/dps_dpg/socle_initial/autorite_etat/refus_obtemperer': (_) =>
        const PaRefusObtempererPage(),
    '/pa/dps_dpg/socle_initial/autorite_etat/outrage': (_) =>
        const PaAtteintesAdministrationContenuPage(),
    '/pa/dps_dpg/socle_initial/autorite_etat/rebellion': (_) =>
        const PaRebellionPage(),
    '/pa/dps_dpg/socle_initial/autorite_etat/provocation_rebellion': (_) =>
        const PaProvocationDirecteRebellionPage(),
    // Socle avance : Generalites
    '/pa/dps_dpg/socle_avance/generalites/droit_penal': (_) =>
        const PaLoiPenaleContenuPage(),
    '/pa/dps_dpg/socle_avance/generalites/immunites_inviolabilites': (_) =>
        const PaGPXSchoolEtendueApplicationLoisPage(),
    '/pa/dps_dpg/socle_avance/generalites/responsabilite_penale': (_) =>
        const PaResponsabilitePenalePage(),
    // Socle avance : Acteurs de la Police Judiciaire
    '/pa/dps_dpg/socle_avance/acteurs_pj/opj': (_) => const HierarchieOpjPage(),
    '/pa/dps_dpg/socle_avance/acteurs_pj/apj': (_) => const HierarchieApjPage(),
    '/pa/dps_dpg/socle_avance/acteurs_pj/assistants_enquete': (_) =>
        const HierarchieAssistantsEnquetePage(),
    '/pa/dps_dpg/socle_avance/acteurs_pj/prerogatives': (_) =>
        const PaAutoriteInvestiesLoiPage(),
    '/pa/dps_dpg/socle_avance/acteurs_pj/procureur': (_) =>
        const PaPPOrganisationMinisterePublicContenuPage(),
    '/pa/dps_dpg/socle_avance/acteurs_pj/juge_instruction': (_) =>
        const JugeInstructionPage(),
    // Socle avance : Atteintes aux biens
    '/pa/dps_dpg/socle_avance/atteintes_biens/extorsion': (_) =>
        const PaExtorsionPage(),
    '/pa/dps_dpg/socle_avance/atteintes_biens/escroquerie': (_) =>
        const PaEscroqueriePage(),
    '/pa/dps_dpg/socle_avance/atteintes_biens/abus_confiance': (_) =>
        const PaAbusDeConfiancePage(),
    '/pa/dps_dpg/socle_avance/atteintes_biens/filouterie': (_) =>
        const PaFilouteriesPage(),
    '/pa/dps_dpg/socle_avance/atteintes_biens/recel': (_) =>
        const PaRecelPage(),
    '/pa/dps_dpg/socle_avance/atteintes_biens/abstention_sinistre': (_) =>
        const PaAtteintesVolontairesIntegriteContenuPage(),
    // Socle avance : Atteintes aux personnes
    // Socle avance : Atteintes aux personnes
    '/pa/dps_dpg/socle_avance/atteintes_personnes/involontaires': (_) =>
        const PaAtteintesInvolontairesContenuPage(),
    '/pa/dps_dpg/socle_avance/atteintes_personnes/menaces': (_) =>
        const PaMenaceSansConditionPage(),
    '/pa/dps_dpg/socle_avance/atteintes_personnes/entrave_secours': (_) =>
        const PaMiseEnDangerContenuPage(),
    '/pa/dps_dpg/socle_avance/atteintes_personnes/non_obstacle': (_) =>
        const PaNonObstacleCommissionCrimeDelitPage(),
    '/pa/dps_dpg/socle_avance/atteintes_personnes/non_assistance': (_) =>
        const PaNonAssistancePersonnePerilPage(),
    '/pa/dps_dpg/socle_avance/atteintes_personnes/appels_malveillants': (_) =>
        const PaAppelsMessagesMalveillantsAgressionsSonoresPage(),
    '/pa/dps_dpg/socle_avance/atteintes_personnes/risque_autrui': (_) =>
        const PaRisqueCauseAutruiPage(),
    // Socle avance : Delits routiers
    '/pa/dps_dpg/socle_avance/delits_routiers/rodeo': (_) =>
        const PaRodeoMotorisePage(),
    '/pa/dps_dpg/socle_avance/delits_routiers/incitation': (_) =>
        const PaIncitationOrganisationPromotionPage(),
    '/pa/dps_dpg/socle_avance/delits_routiers/delit_fuite': (_) =>
        const PaDelitFuitePage(),
    '/pa/dps_dpg/socle_avance/delits_routiers/refus_obtemperer': (_) =>
        const PaRefusObtempererPage(),
    '/pa/dps_dpg/socle_avance/delits_routiers/autres': (_) =>
        const PaEtatAlcooliquePage(),
    // Socle avance : Autorite de l'Etat
    '/pa/dps_dpg/socle_avance/autorite_etat/menaces': (_) =>
        const PaMenacesEnversDepositaireAutoritePage(),
    '/pa/dps_dpg/socle_avance/autorite_etat/corruption_passive': (_) =>
        const PaCorruptionPage(),
    '/pa/dps_dpg/socle_avance/autorite_etat/corruption_active': (_) =>
        const PaCorruptionPage(),
    // Socle avance : Stupefiants
    '/pa/dps_dpg/socle_avance/stupefiants/usage_illicite': (_) =>
        const PaStupefiantsUsageIllicitePage(),
    '/pa/dps_dpg/socle_avance/stupefiants/cession_offre': (_) =>
        const PaStupefiantsCessionOffrePage(),

    // Confirm email avec args
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
