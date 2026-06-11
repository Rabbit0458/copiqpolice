// lib/core/services/analytics_service.dart
//
// Service centralisé pour les events produit (Firebase Analytics) et le
// crash reporting (Firebase Crashlytics).
//
// ⚠️ Avant d'utiliser, exécuter `flutterfire configure` côté machine de dev
// pour générer `firebase_options.dart`. Voir aussi PHASE 3.
//
// Utilisation :
//   AnalyticsService.I.trackEvent('quiz_started', {'topic': 'tentative'});
//   AnalyticsService.I.trackScreen('home_gpx_school');
//   AnalyticsService.I.setUserId('uuid');
//   AnalyticsService.I.recordError(error, stack);
//
// Les events sont aussi loggés dans la console en debug pour faciliter le
// pilotage produit local.

import 'dart:async';

import 'package:flutter/foundation.dart';

class AnalyticsService {
  AnalyticsService._();
  static final AnalyticsService instance = AnalyticsService._();
  static AnalyticsService get I => instance;

  bool _firebaseAvailable = false;

  // Late-bound : on évite l'import direct de firebase_analytics ici pour que
  // l'app puisse compiler même si Firebase n'est pas encore configuré.
  // Le `bind()` ci-dessous sera appelé depuis `main.dart` une fois Firebase
  // initialisé. En attendant, tous les calls sont no-op (avec log debug).
  dynamic _analytics; // FirebaseAnalytics
  dynamic _crashlytics; // FirebaseCrashlytics

  /// À appeler depuis main.dart APRÈS `Firebase.initializeApp()`.
  ///
  /// Exemple :
  /// ```dart
  /// await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  /// AnalyticsService.I.bind(
  ///   analytics: FirebaseAnalytics.instance,
  ///   crashlytics: FirebaseCrashlytics.instance,
  /// );
  /// ```
  void bind({required dynamic analytics, required dynamic crashlytics}) {
    _analytics = analytics;
    _crashlytics = crashlytics;
    _firebaseAvailable = true;
  }

  // ---------------------------------------------------------------------------
  // Events
  // ---------------------------------------------------------------------------

  Future<void> trackEvent(
    String name, [
    Map<String, Object?> params = const {},
  ]) async {
    if (kDebugMode) {
      debugPrint('[Analytics] event=$name params=$params');
    }
    if (!_firebaseAvailable || _analytics == null) return;
    try {
      // Firebase Analytics n'accepte que des types primitifs (String, num, bool).
      final sanitized = <String, Object>{};
      params.forEach((k, v) {
        if (v == null) return;
        if (v is String || v is num || v is bool) {
          sanitized[k] = v;
        } else {
          sanitized[k] = v.toString();
        }
      });
      await _analytics.logEvent(name: name, parameters: sanitized);
    } catch (e) {
      debugPrint('[Analytics] trackEvent failed: $e');
    }
  }

  Future<void> trackScreen(String screenName, {String? screenClass}) async {
    await trackEvent('screen_view', {
      'screen_name': screenName,
      if (screenClass != null) 'screen_class': screenClass,
    });
  }

  // ---------------------------------------------------------------------------
  // User ID
  // ---------------------------------------------------------------------------

  Future<void> setUserId(String? uid) async {
    if (kDebugMode) debugPrint('[Analytics] setUserId=$uid');
    if (!_firebaseAvailable) return;
    try {
      await _analytics?.setUserId(id: uid);
      await _crashlytics?.setUserIdentifier(uid ?? '');
    } catch (e) {
      debugPrint('[Analytics] setUserId failed: $e');
    }
  }

  Future<void> setUserProperty(String key, String? value) async {
    if (kDebugMode) debugPrint('[Analytics] setUserProperty $key=$value');
    if (!_firebaseAvailable) return;
    try {
      await _analytics?.setUserProperty(name: key, value: value);
    } catch (_) {}
  }

  // ---------------------------------------------------------------------------
  // Crashlytics
  // ---------------------------------------------------------------------------

  Future<void> recordError(
    Object error,
    StackTrace? stack, {
    bool fatal = false,
    Map<String, Object?> context = const {},
  }) async {
    if (kDebugMode) {
      debugPrint('[Crashlytics] error: $error');
      if (stack != null) debugPrint(stack.toString());
    }
    if (!_firebaseAvailable || _crashlytics == null) return;
    try {
      for (final entry in context.entries) {
        await _crashlytics.setCustomKey(entry.key, entry.value.toString());
      }
      await _crashlytics.recordError(error, stack, fatal: fatal);
    } catch (e) {
      debugPrint('[Crashlytics] recordError failed: $e');
    }
  }

  Future<void> log(String message) async {
    if (kDebugMode) debugPrint('[Crashlytics-log] $message');
    if (!_firebaseAvailable) return;
    try {
      await _crashlytics?.log(message);
    } catch (_) {}
  }

  // ---------------------------------------------------------------------------
  // Helpers domain-specific
  // ---------------------------------------------------------------------------

  Future<void> quizStarted({
    required String moduleName,
    required String quizName,
    required String? track,
    required String? mode,
  }) async {
    await trackEvent('quiz_started', {
      'module_name': moduleName,
      'quiz_name': quizName,
      if (track != null) 'track': track,
      if (mode != null) 'mode': mode,
    });
  }

  Future<void> quizCompleted({
    required String moduleName,
    required String quizName,
    required int score,
    required int totalQuestions,
    required String? track,
    required String? mode,
  }) async {
    await trackEvent('quiz_completed', {
      'module_name': moduleName,
      'quiz_name': quizName,
      'score': score,
      'total_questions': totalQuestions,
      if (track != null) 'track': track,
      if (mode != null) 'mode': mode,
    });
  }

  Future<void> subscriptionPurchased({
    required String plan,
    required double price,
    required String currency,
  }) async {
    await trackEvent('subscription_purchased', {
      'plan': plan,
      'price': price,
      'currency': currency,
    });
  }
}
