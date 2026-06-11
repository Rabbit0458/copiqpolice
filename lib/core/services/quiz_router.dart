// lib/core/services/quiz_router.dart
//
// Helper centralisé pour résoudre une route de quiz selon le `user_track`
// courant (source de vérité : `UserContextService`).
//
// Pourquoi ?
//   - Les pages de cours GPX sont mutualisées (réutilisées par PA via le
//     `home_page_pa_school.dart`). Quand ces pages poussent un quiz, elles
//     utilisent une route `/gpx/.../quiz/...` codée en dur.
//   - Avant ce refactor, un user PA finissait sur le quiz GPX. Ce helper
//     permet à `appOnGenerateRoute` (dans `app_router.dart`) de réécrire
//     proprement la cible en `/pa/.../quiz/...` quand le track est PA.
//
// Architecture évolutive :
//   - Réserve : pour l'instant, aucun quiz Réserve. On bloque proprement
//     avec une snackbar "Bientôt disponible" via `ensureCanLaunchQuiz`.
//   - Quand les quiz Réserve seront codés, il suffira de remplacer le
//     `case 'reserve'` par la réécriture appropriée.

import 'package:flutter/material.dart';

import 'package:copiqpolice/core/services/user_context_service.dart';

/// Résultat d'une résolution de route quiz.
enum QuizRouteResolution {
  /// La route doit être empruntée telle quelle.
  keep,

  /// La route a été réécrite vers une cible différente (track-aware).
  rewrite,

  /// L'utilisateur n'a pas accès à ce quiz pour le moment (ex: reserve sans
  /// quiz disponibles). L'appelant doit afficher une UI de fallback.
  blocked,
}

class QuizRouteDecision {
  final QuizRouteResolution resolution;
  final String? rewrittenRoute;
  final String? blockedReason;

  const QuizRouteDecision._({
    required this.resolution,
    this.rewrittenRoute,
    this.blockedReason,
  });

  factory QuizRouteDecision.keep() =>
      const QuizRouteDecision._(resolution: QuizRouteResolution.keep);

  factory QuizRouteDecision.rewrite(String to) => QuizRouteDecision._(
    resolution: QuizRouteResolution.rewrite,
    rewrittenRoute: to,
  );

  factory QuizRouteDecision.blocked(String reason) => QuizRouteDecision._(
    resolution: QuizRouteResolution.blocked,
    blockedReason: reason,
  );
}

class QuizRouter {
  QuizRouter._();

  /// Pattern de détection d'une route de quiz scolarité.
  /// Match `/gpx/.../quiz/...` ou `/pa/.../quiz/...`.
  static final RegExp _quizRoutePattern = RegExp(
    r'^/(gpx|pa|reserve)(/.+)?/quiz/.+',
  );

  /// Indique si une route correspond à un quiz scolarité.
  static bool isQuizRoute(String? routeName) {
    if (routeName == null || routeName.isEmpty) return false;
    return _quizRoutePattern.hasMatch(routeName);
  }

  /// Coeur de la logique : étant donné une route quiz et le track courant,
  /// retourne la décision à prendre.
  ///
  /// Règles :
  ///   - track == 'gpx'    -> on garde la route /gpx/...
  ///   - track == 'pa'     -> on réécrit /gpx/... en /pa/...
  ///                          (et inversement si jamais une page PA pointe
  ///                           vers une route /pa/... que l'utilisateur GPX
  ///                           visite, on réécrit en /gpx/...).
  ///   - track == 'reserve'-> blocked (quiz Réserve pas encore codés).
  ///   - track inconnu     -> on garde la route telle quelle (fallback safe).
  static QuizRouteDecision resolve(String routeName, {String? trackOverride}) {
    final track = trackOverride ?? UserContextService.I.trackOrDefault;

    // Pas une route de quiz : on touche à rien.
    if (!isQuizRoute(routeName)) {
      return QuizRouteDecision.keep();
    }

    switch (track) {
      case UserTracks.gpx:
        if (routeName.startsWith('/pa/')) {
          // Cas peu probable mais on protège : un user GPX a déclenché
          // une route /pa/... — on réécrit en /gpx/...
          return QuizRouteDecision.rewrite(
            routeName.replaceFirst('/pa/', '/gpx/'),
          );
        }
        return QuizRouteDecision.keep();

      case UserTracks.pa:
        if (routeName.startsWith('/gpx/')) {
          return QuizRouteDecision.rewrite(
            routeName.replaceFirst('/gpx/', '/pa/'),
          );
        }
        return QuizRouteDecision.keep();

      case UserTracks.reserve:
        // TODO(reserve): quand les quiz Réserve seront codés, remplacer
        // ce fallback par une réécriture vers '/reserve/.../quiz/...'.
        //
        // En attendant : on route les utilisateurs Réserve vers les quiz PA
        // (programme le plus proche), de manière à ne pas bloquer la formation.
        // Le `grade` enregistré côté Supabase reste bien 'reserve' grâce à
        // UserContextService.I.trackOrDefault, donc les statistiques sont
        // correctement attribuées à l'utilisateur Réserve.
        if (routeName.startsWith('/gpx/')) {
          return QuizRouteDecision.rewrite(
            routeName.replaceFirst('/gpx/', '/pa/'),
          );
        }
        if (routeName.startsWith('/pa/')) {
          return QuizRouteDecision.keep();
        }
        // Cas inattendu : route reserve sans implémentation -> snackbar.
        return QuizRouteDecision.blocked(
          'Les quiz Réserve seront bientôt disponibles.',
        );

      default:
        return QuizRouteDecision.keep();
    }
  }

  /// Wrapper pratique pour pousser un quiz depuis n'importe où.
  /// Affiche une snackbar si le track ne permet pas le quiz.
  static Future<T?> pushQuiz<T>(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) async {
    final decision = resolve(routeName);

    switch (decision.resolution) {
      case QuizRouteResolution.keep:
        return Navigator.of(context).pushNamed<T>(
          routeName,
          arguments: arguments,
        );
      case QuizRouteResolution.rewrite:
        return Navigator.of(context).pushNamed<T>(
          decision.rewrittenRoute!,
          arguments: arguments,
        );
      case QuizRouteResolution.blocked:
        showQuizUnavailableSnack(context, decision.blockedReason);
        return null;
    }
  }

  /// Affiche la snackbar "Bientôt disponible".
  static void showQuizUnavailableSnack(BuildContext context, [String? message]) {
    final txt = message ?? 'Quiz bientôt disponible pour ton parcours.';
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(txt),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
