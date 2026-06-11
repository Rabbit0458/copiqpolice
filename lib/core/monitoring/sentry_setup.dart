// ╔════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Monitoring : Sentry wrapper (no-op safe par défaut)          ║
// ║  Tâche      : CODE-053                                                  ║
// ║                                                                         ║
// ║  ⚠️ NOTE D'IMPLÉMENTATION                                                ║
// ║  ────────────────────────                                               ║
// ║  Tant que `sentry_flutter` n'est PAS ajouté à pubspec.yaml, ce fichier ║
// ║  est volontairement un NO-OP TOTAL : il expose le même contrat public   ║
// ║  (`AppMonitoring.captureException`, `captureMessage`, etc.) mais aucune║
// ║  méthode ne fait quoi que ce soit. Aucun import externe — le projet    ║
// ║  compile dans tous les cas.                                             ║
// ║                                                                         ║
// ║  Quand tu veux activer Sentry pour de vrai :                            ║
// ║    1. Ajouter `sentry_flutter: ^8.10.0` à pubspec.yaml                   ║
// ║    2. `flutter pub get`                                                  ║
// ║    3. Remplacer ce fichier par la version "active" décrite dans         ║
// ║       `docs/cas_pratique/SENTRY_SETUP.md` (section "Wiring main.dart")  ║
// ║                                                                         ║
// ║  Les call-sites (`AppMonitoring.captureException(...)`, etc.) n'ont    ║
// ║  PAS à changer — c'est tout l'intérêt de cette façade.                  ║
// ╚════════════════════════════════════════════════════════════════════════╝

import 'package:flutter/foundation.dart';

/// Niveau de log compatible avec l'API Sentry — défini en local pour ne pas
/// dépendre du package tant qu'il n'est pas ajouté à pubspec.
enum AppLogLevel { debug, info, warning, error, fatal }

/// Façade de monitoring stable (no-op tant que `sentry_flutter` n'est pas
/// ajouté à pubspec). Les call-sites peuvent l'utiliser dès maintenant sans
/// risquer un import cassé.
class AppMonitoring {
  AppMonitoring._();

  static bool _initialized = false;
  static bool get isEnabled => _initialized;

  /// Initialise le monitoring. NO-OP tant que `sentry_flutter` n'est pas
  /// branché. Exécute `appRunner` si fourni.
  static Future<bool> init({
    Future<void> Function()? appRunner,
  }) async {
    _initialized = false;
    if (appRunner != null) await appRunner();
    if (kDebugMode) {
      debugPrint(
        '[AppMonitoring] no-op (sentry_flutter pas branché — voir '
        'docs/cas_pratique/SENTRY_SETUP.md)',
      );
    }
    return false;
  }

  static Future<void> captureException(
    Object error,
    StackTrace? stack, {
    String? hint,
    Map<String, String>? tags,
    String? screen,
  }) async {
    if (kDebugMode) {
      debugPrint('[AppMonitoring] noop captureException: $error');
    }
  }

  static Future<void> captureMessage(
    String message, {
    AppLogLevel level = AppLogLevel.info,
    Map<String, String>? tags,
  }) async {
    if (kDebugMode) {
      debugPrint('[AppMonitoring] noop captureMessage [$level]: $message');
    }
  }

  static void addBreadcrumb({
    required String category,
    required String message,
    AppLogLevel level = AppLogLevel.info,
    Map<String, dynamic>? data,
  }) {
    // no-op
  }

  static Future<void> setUserId({
    required String id,
    String? email,
    String? username,
  }) async {
    // no-op
  }

  static Future<void> clearUser() async {
    // no-op
  }
}

/// Helper d'enrobage `runApp(...)`. NO-OP : exécute simplement `appRunner`.
Future<void> runAppWithMonitoring(Future<void> Function() appRunner) async {
  await AppMonitoring.init(appRunner: appRunner);
}
