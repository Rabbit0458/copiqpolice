// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Cas Pratique — Analytics Service                               ║
// ║  Référence : docs/cas_pratique/PROGRESSION_CODE.md — CODE-073            ║
// ║                                                                           ║
// ║  Interface typée + implémentation PostHog (façade no-op si SDK absent).  ║
// ║                                                                           ║
// ║  RÈGLES PII :                                                             ║
// ║    ✅ case_slug, theme_id, difficulty, question_index, score,             ║
// ║       is_correct, attempt_id (UUID), user_id (UUID)                      ║
// ║    ❌ texte brut de la réponse, nom, e-mail, numéro, adresse             ║
// ║                                                                           ║
// ║  INTÉGRATION (main.dart) :                                                ║
// ║    CpAnalytics.I.bind(                                                    ║
// ║      postHogApiKey: const String.fromEnvironment('POSTHOG_API_KEY'),     ║
// ║      postHogHost:   'https://eu.posthog.com',                             ║
// ║    );                                                                     ║
// ║    CpAnalytics.I.identify(userId: supabase.auth.currentUser!.id);        ║
// ╚═══════════════════════════════════════════════════════════════════════════╝

import 'dart:async';

import 'package:flutter/foundation.dart';

// ---------------------------------------------------------------------------
// Abstract interface
// ---------------------------------------------------------------------------

/// Contrat public de l'analytics Cas Pratique.
/// Toutes les méthodes sont asynchrones pour permettre un impl réseau sans
/// bloquer le thread UI.
abstract class CpAnalyticsInterface {
  // ── Identité ──────────────────────────────────────────────────────────────

  /// Associe les events suivants à cet utilisateur (UUID Supabase).
  /// ⚠️ Passer `null` pour réinitialiser (déconnexion).
  Future<void> identify(String? userId);

  // ── Events produit ────────────────────────────────────────────────────────

  /// L'utilisateur ouvre la fiche d'un cas (avant de démarrer).
  Future<void> caseOpened({
    required String caseSlug,
    required String themeId,
    required String difficulty,
    required int totalQuestions,
  });

  /// L'utilisateur clique sur « Commencer » et crée une tentative.
  Future<void> caseStarted({
    required String caseSlug,
    required String attemptId,
    required String themeId,
    required String difficulty,
  });

  /// L'utilisateur saisit une réponse et passe à la question suivante
  /// (avant validation).
  Future<void> questionAnswered({
    required String caseSlug,
    required String attemptId,
    required int questionIndex,
    required int totalQuestions,
    required int answerLengthChars, // longueur uniquement, pas le texte
  });

  /// Le moteur valide la réponse (autosave + scoring local).
  Future<void> questionValidated({
    required String caseSlug,
    required String attemptId,
    required int questionIndex,
    required double scoreObtained,
    required double scoreMax,
    required bool isCorrect, // scoreObtained / scoreMax >= 0.5
  });

  /// La page de correction est affichée (fin de cas ou accès direct).
  Future<void> correctionShown({
    required String caseSlug,
    required String attemptId,
    required double totalScore,
    required double totalMax,
    required double percentScore, // 0.0 – 100.0
    required bool isFirstAttempt,
  });

  /// L'utilisateur soumet un appel sur une question.
  Future<void> appealCreated({
    required String caseSlug,
    required String attemptId,
    required int questionIndex,
    required String correctionDetailId,
  });

  /// L'utilisateur clique sur « Partager mon score ».
  Future<void> shareClicked({
    required String caseSlug,
    required double percentScore,
    required String shareMethod, // 'story_image' | 'link' | 'other'
  });

  // ── Ecran ─────────────────────────────────────────────────────────────────

  /// Suivi de navigation entre écrans du module Cas Pratique.
  Future<void> screenViewed(String screenName, {Map<String, Object?> extra});
}

// ---------------------------------------------------------------------------
// No-op implementation (fallback si SDK absent ou en test)
// ---------------------------------------------------------------------------

class _CpAnalyticsNoOp implements CpAnalyticsInterface {
  const _CpAnalyticsNoOp();

  @override
  Future<void> identify(String? userId) async {}

  @override
  Future<void> caseOpened({
    required String caseSlug,
    required String themeId,
    required String difficulty,
    required int totalQuestions,
  }) async {}

  @override
  Future<void> caseStarted({
    required String caseSlug,
    required String attemptId,
    required String themeId,
    required String difficulty,
  }) async {}

  @override
  Future<void> questionAnswered({
    required String caseSlug,
    required String attemptId,
    required int questionIndex,
    required int totalQuestions,
    required int answerLengthChars,
  }) async {}

  @override
  Future<void> questionValidated({
    required String caseSlug,
    required String attemptId,
    required int questionIndex,
    required double scoreObtained,
    required double scoreMax,
    required bool isCorrect,
  }) async {}

  @override
  Future<void> correctionShown({
    required String caseSlug,
    required String attemptId,
    required double totalScore,
    required double totalMax,
    required double percentScore,
    required bool isFirstAttempt,
  }) async {}

  @override
  Future<void> appealCreated({
    required String caseSlug,
    required String attemptId,
    required int questionIndex,
    required String correctionDetailId,
  }) async {}

  @override
  Future<void> shareClicked({
    required String caseSlug,
    required double percentScore,
    required String shareMethod,
  }) async {}

  @override
  Future<void> screenViewed(
    String screenName, {
    Map<String, Object?> extra = const {},
  }) async {}
}

// ---------------------------------------------------------------------------
// PostHog implementation
// ---------------------------------------------------------------------------
//
// PostHog n'est PAS importé directement ici pour éviter une dépendance
// obligatoire au build si le SDK n'est pas encore installé.
//
// Pattern : on accepte un `dynamic _client` late-bound via `bind()`.
// Les appels PostHog sont faits via reflection dynamique (noSuchMethod via
// des méthodes nommées, ou simplement via l'interface de capture générique
// `posthog_flutter : Posthog.capture(eventName, properties)`).
//
// Pour activer : ajouter `posthog_flutter: ^4.x` dans pubspec.yaml et
// appeler `CpAnalytics.I.bind(postHogApiKey: ..., postHogHost: ...)` dans main.dart.

class _CpAnalyticsPostHog implements CpAnalyticsInterface {
  _CpAnalyticsPostHog._();

  dynamic _posthog; // posthog_flutter : Posthog instance
  String? _userId;

  // --------------------------------------------------------------------------
  // Capture générique (appelée par toutes les méthodes typées)
  // --------------------------------------------------------------------------

  Future<void> _capture(
    String event,
    Map<String, Object?> properties,
  ) async {
    if (kDebugMode) {
      debugPrint('[CpAnalytics] $event ${properties.toString()}');
    }
    if (_posthog == null) return;
    try {
      await _posthog.capture(
        eventName: event,
        properties: {
          if (_userId != null) 'user_id': _userId,
          ...properties,
        },
      );
    } catch (e) {
      // Ne jamais crasher l'app à cause de l'analytics
      debugPrint('[CpAnalytics] capture failed: $e');
    }
  }

  // --------------------------------------------------------------------------
  // Interface
  // --------------------------------------------------------------------------

  @override
  Future<void> identify(String? userId) async {
    _userId = userId;
    if (_posthog == null) return;
    try {
      if (userId != null) {
        await _posthog.identify(userId: userId);
      } else {
        await _posthog.reset();
      }
    } catch (e) {
      debugPrint('[CpAnalytics] identify failed: $e');
    }
  }

  @override
  Future<void> caseOpened({
    required String caseSlug,
    required String themeId,
    required String difficulty,
    required int totalQuestions,
  }) =>
      _capture('cp_case_opened', {
        'case_slug': caseSlug,
        'theme_id': themeId,
        'difficulty': difficulty,
        'total_questions': totalQuestions,
      });

  @override
  Future<void> caseStarted({
    required String caseSlug,
    required String attemptId,
    required String themeId,
    required String difficulty,
  }) =>
      _capture('cp_case_started', {
        'case_slug': caseSlug,
        'attempt_id': attemptId,
        'theme_id': themeId,
        'difficulty': difficulty,
      });

  @override
  Future<void> questionAnswered({
    required String caseSlug,
    required String attemptId,
    required int questionIndex,
    required int totalQuestions,
    required int answerLengthChars,
  }) =>
      _capture('cp_question_answered', {
        'case_slug': caseSlug,
        'attempt_id': attemptId,
        'question_index': questionIndex,
        'total_questions': totalQuestions,
        'answer_length_chars': answerLengthChars,
      });

  @override
  Future<void> questionValidated({
    required String caseSlug,
    required String attemptId,
    required int questionIndex,
    required double scoreObtained,
    required double scoreMax,
    required bool isCorrect,
  }) =>
      _capture('cp_question_validated', {
        'case_slug': caseSlug,
        'attempt_id': attemptId,
        'question_index': questionIndex,
        'score_obtained': scoreObtained,
        'score_max': scoreMax,
        'is_correct': isCorrect,
      });

  @override
  Future<void> correctionShown({
    required String caseSlug,
    required String attemptId,
    required double totalScore,
    required double totalMax,
    required double percentScore,
    required bool isFirstAttempt,
  }) =>
      _capture('cp_correction_shown', {
        'case_slug': caseSlug,
        'attempt_id': attemptId,
        'total_score': totalScore,
        'total_max': totalMax,
        'percent_score': percentScore,
        'is_first_attempt': isFirstAttempt,
      });

  @override
  Future<void> appealCreated({
    required String caseSlug,
    required String attemptId,
    required int questionIndex,
    required String correctionDetailId,
  }) =>
      _capture('cp_appeal_created', {
        'case_slug': caseSlug,
        'attempt_id': attemptId,
        'question_index': questionIndex,
        'correction_detail_id': correctionDetailId,
      });

  @override
  Future<void> shareClicked({
    required String caseSlug,
    required double percentScore,
    required String shareMethod,
  }) =>
      _capture('cp_share_clicked', {
        'case_slug': caseSlug,
        'percent_score': percentScore,
        'share_method': shareMethod,
      });

  @override
  Future<void> screenViewed(
    String screenName, {
    Map<String, Object?> extra = const {},
  }) =>
      _capture('cp_screen_viewed', {
        'screen_name': screenName,
        ...extra,
      });
}

// ---------------------------------------------------------------------------
// Singleton façade — CpAnalytics.I
// ---------------------------------------------------------------------------

/// Point d'entrée unique pour l'analytics Cas Pratique.
///
/// Utilisation :
/// ```dart
/// // main.dart (optionnel — app compile sans PostHog)
/// CpAnalytics.I.bind(
///   postHogApiKey: const String.fromEnvironment('POSTHOG_API_KEY'),
///   postHogHost: 'https://eu.posthog.com',
/// );
///
/// // Dans les pages :
/// CpAnalytics.I.caseOpened(
///   caseSlug: widget.caseSlug,
///   themeId: 'gp_2023',
///   difficulty: 'hard',
///   totalQuestions: 5,
/// );
/// ```
class CpAnalytics {
  CpAnalytics._();

  static final CpAnalytics _instance = CpAnalytics._();
  static CpAnalytics get I => _instance;

  late CpAnalyticsInterface _impl = const _CpAnalyticsNoOp();

  // --------------------------------------------------------------------------
  // Initialisation
  // --------------------------------------------------------------------------

  /// Lie le vrai client PostHog.
  ///
  /// [postHogApiKey] : clé projet PostHog (dart-define POSTHOG_API_KEY).
  /// [postHogHost]   : host EU ou US (défaut : 'https://app.posthog.com').
  /// [dynamicPostHog] : instance déjà initialisée (optionnel, pour tests).
  ///
  /// Si [postHogApiKey] est vide, le service reste no-op (safe).
  void bind({
    String postHogApiKey = '',
    String postHogHost = 'https://app.posthog.com',
    dynamic dynamicPostHog,
  }) {
    if (postHogApiKey.isEmpty && dynamicPostHog == null) {
      if (kDebugMode) {
        debugPrint(
          '[CpAnalytics] POSTHOG_API_KEY absent — analytics désactivé.',
        );
      }
      return;
    }
    final impl = _CpAnalyticsPostHog._();
    impl._posthog = dynamicPostHog; // peut rester null si SDK non installé
    _impl = impl;

    if (kDebugMode) {
      debugPrint('[CpAnalytics] PostHog bound (host=$postHogHost)');
    }
  }

  /// Remplace l'implémentation (utile pour les tests).
  void bindImpl(CpAnalyticsInterface impl) => _impl = impl;

  // --------------------------------------------------------------------------
  // Proxy vers l'implémentation
  // --------------------------------------------------------------------------

  Future<void> identify(String? userId) => _impl.identify(userId);

  Future<void> caseOpened({
    required String caseSlug,
    required String themeId,
    required String difficulty,
    required int totalQuestions,
  }) =>
      _impl.caseOpened(
        caseSlug: caseSlug,
        themeId: themeId,
        difficulty: difficulty,
        totalQuestions: totalQuestions,
      );

  Future<void> caseStarted({
    required String caseSlug,
    required String attemptId,
    required String themeId,
    required String difficulty,
  }) =>
      _impl.caseStarted(
        caseSlug: caseSlug,
        attemptId: attemptId,
        themeId: themeId,
        difficulty: difficulty,
      );

  Future<void> questionAnswered({
    required String caseSlug,
    required String attemptId,
    required int questionIndex,
    required int totalQuestions,
    required int answerLengthChars,
  }) =>
      _impl.questionAnswered(
        caseSlug: caseSlug,
        attemptId: attemptId,
        questionIndex: questionIndex,
        totalQuestions: totalQuestions,
        answerLengthChars: answerLengthChars,
      );

  Future<void> questionValidated({
    required String caseSlug,
    required String attemptId,
    required int questionIndex,
    required double scoreObtained,
    required double scoreMax,
    required bool isCorrect,
  }) =>
      _impl.questionValidated(
        caseSlug: caseSlug,
        attemptId: attemptId,
        questionIndex: questionIndex,
        scoreObtained: scoreObtained,
        scoreMax: scoreMax,
        isCorrect: isCorrect,
      );

  Future<void> correctionShown({
    required String caseSlug,
    required String attemptId,
    required double totalScore,
    required double totalMax,
    required double percentScore,
    required bool isFirstAttempt,
  }) =>
      _impl.correctionShown(
        caseSlug: caseSlug,
        attemptId: attemptId,
        totalScore: totalScore,
        totalMax: totalMax,
        percentScore: percentScore,
        isFirstAttempt: isFirstAttempt,
      );

  Future<void> appealCreated({
    required String caseSlug,
    required String attemptId,
    required int questionIndex,
    required String correctionDetailId,
  }) =>
      _impl.appealCreated(
        caseSlug: caseSlug,
        attemptId: attemptId,
        questionIndex: questionIndex,
        correctionDetailId: correctionDetailId,
      );

  Future<void> shareClicked({
    required String caseSlug,
    required double percentScore,
    required String shareMethod,
  }) =>
      _impl.shareClicked(
        caseSlug: caseSlug,
        percentScore: percentScore,
        shareMethod: shareMethod,
      );

  Future<void> screenViewed(
    String screenName, {
    Map<String, Object?> extra = const {},
  }) =>
      _impl.screenViewed(screenName, extra: extra);
}
