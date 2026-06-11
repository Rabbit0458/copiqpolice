// lib/core/notifications/cp_push_service.dart
//
// Service de notifications push intelligentes — Cas Pratique COP'IQ.
//
// Responsabilités :
//   1. Gestion des topics FCM (abonnement / désabonnement) par catégorie.
//   2. Opt-in granulaire stocké dans SharedPreferences + synchro Supabase.
//   3. Quiet hours : plage horaire silencieuse respectée côté client
//      (les notifs reçues pendant la plage silencieuse sont ignorées/différées).
//   4. Sauvegarde du token FCM dans Supabase pour le backend.
//
// Topics FCM :
//   • `cp_new_case`       — nouveau cas publié
//   • `cp_streak_risk`    — streak en danger (< 2h)
//   • `cp_appeal_result`  — appel traité
//   • `cp_leaderboard`    — classement hebdo (lundi matin)
//
// Utilisation :
//   await CpPushService.I.init();  // dans main.dart après NotificationsService
//   CpPushService.I.setTopicEnabled(CpNotifTopic.newCase, true);
//
// ⚠️  Ce service ne touche pas lib/core/services/notifications_service.dart.
//     Il est complémentaire (focus cas pratique / topics FCM).

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// ---------------------------------------------------------------------------
// Enum des topics
// ---------------------------------------------------------------------------

enum CpNotifTopic {
  newCase('cp_new_case', 'Nouveaux cas',
      'Reçois une notification dès qu\'un nouveau cas est publié.'),
  streakRisk('cp_streak_risk', 'Alerte streak',
      'Sois prévenu si ta série quotidienne risque de se couper.'),
  appealResult('cp_appeal_result', 'Résultat de tes appels',
      'Sache immédiatement si ton appel a été approuvé ou rejeté.'),
  leaderboard('cp_leaderboard', 'Classement hebdo',
      'Reçois ton classement chaque lundi matin.');

  const CpNotifTopic(this.topicId, this.label, this.description);

  /// Identifiant FCM (ex. "cp_new_case").
  final String topicId;

  /// Label affiché dans l'UI opt-in.
  final String label;

  /// Description courte pour l'UI.
  final String description;

  /// Clé SharedPreferences.
  String get prefKey => '_cp_notif_${topicId}_enabled';

  /// Valeur activée par défaut.
  bool get defaultEnabled => this != CpNotifTopic.leaderboard;
}

// ---------------------------------------------------------------------------
// Modèle Préférences
// ---------------------------------------------------------------------------

class CpNotifPrefs {
  final Map<CpNotifTopic, bool> topics;
  final int quietStartHour; // heure locale (0-23)
  final int quietEndHour;   // heure locale (0-23)
  final String userTimezone;

  const CpNotifPrefs({
    required this.topics,
    this.quietStartHour = 22,
    this.quietEndHour = 8,
    this.userTimezone = 'Europe/Paris',
  });

  bool isEnabled(CpNotifTopic topic) => topics[topic] ?? topic.defaultEnabled;

  CpNotifPrefs copyWith({
    Map<CpNotifTopic, bool>? topics,
    int? quietStartHour,
    int? quietEndHour,
    String? userTimezone,
  }) {
    return CpNotifPrefs(
      topics: topics ?? Map.from(this.topics),
      quietStartHour: quietStartHour ?? this.quietStartHour,
      quietEndHour: quietEndHour ?? this.quietEndHour,
      userTimezone: userTimezone ?? this.userTimezone,
    );
  }
}

// ---------------------------------------------------------------------------
// Service principal
// ---------------------------------------------------------------------------

class CpPushService {
  CpPushService._();
  static final CpPushService instance = CpPushService._();
  static CpPushService get I => instance;

  bool _initialized = false;
  CpNotifPrefs _prefs = const CpNotifPrefs(topics: {});
  final _prefsController = StreamController<CpNotifPrefs>.broadcast();

  /// Stream des préférences (écoutable par l'UI).
  Stream<CpNotifPrefs> get prefsStream => _prefsController.stream;

  /// Préférences courantes (snapshot synchrone).
  CpNotifPrefs get prefs => _prefs;

  // -------------------------------------------------------------------------
  // Init
  // -------------------------------------------------------------------------

  /// À appeler une fois après Firebase.initializeApp() dans main.dart.
  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    try {
      await _hydrateFromPrefs();
      await _applyFcmSubscriptions();
      await _refreshTokenAndSync();
      _listenForegroundMessages();
    } catch (e) {
      debugPrint('[CpPushService] init error: $e');
    }
  }

  // -------------------------------------------------------------------------
  // Opt-in granulaire
  // -------------------------------------------------------------------------

  /// Active ou désactive un topic donné.
  Future<void> setTopicEnabled(CpNotifTopic topic, bool enabled) async {
    final updated = Map<CpNotifTopic, bool>.from(_prefs.topics)
      ..[topic] = enabled;
    _prefs = _prefs.copyWith(topics: updated);
    _prefsController.add(_prefs);

    // FCM subscribe / unsubscribe
    try {
      if (enabled) {
        await FirebaseMessaging.instance.subscribeToTopic(topic.topicId);
      } else {
        await FirebaseMessaging.instance.unsubscribeFromTopic(topic.topicId);
      }
    } catch (e) {
      debugPrint('[CpPushService] FCM topic toggle error: $e');
    }

    // Persist local
    final sp = await SharedPreferences.getInstance();
    await sp.setBool(topic.prefKey, enabled);

    // Sync Supabase (best-effort)
    _syncPrefsToSupabase();
  }

  /// Met à jour les quiet hours (heures locales user).
  Future<void> setQuietHours({
    required int startHour,
    required int endHour,
  }) async {
    _prefs = _prefs.copyWith(
      quietStartHour: startHour,
      quietEndHour: endHour,
    );
    _prefsController.add(_prefs);

    final sp = await SharedPreferences.getInstance();
    await sp.setInt('_cp_notif_quiet_start', startHour);
    await sp.setInt('_cp_notif_quiet_end', endHour);

    _syncPrefsToSupabase();
  }

  /// Met à jour la timezone IANA de l'utilisateur.
  Future<void> setUserTimezone(String iana) async {
    _prefs = _prefs.copyWith(userTimezone: iana);
    _prefsController.add(_prefs);

    final sp = await SharedPreferences.getInstance();
    await sp.setString('_cp_notif_timezone', iana);
    _syncPrefsToSupabase();
  }

  // -------------------------------------------------------------------------
  // Quiet hours — vérification côté client
  // -------------------------------------------------------------------------

  /// Retourne true si l'heure actuelle est dans la plage silencieuse.
  /// Gère le chevauchement minuit (ex. 22h → 08h).
  bool isCurrentlyInQuietHours() {
    final now = DateTime.now();
    final h = now.hour;
    final start = _prefs.quietStartHour;
    final end = _prefs.quietEndHour;

    if (start <= end) {
      // Ex. 10 → 20 : simple range
      return h >= start && h < end;
    } else {
      // Chevauchement minuit : ex. 22 → 08
      return h >= start || h < end;
    }
  }

  // -------------------------------------------------------------------------
  // Token FCM
  // -------------------------------------------------------------------------

  /// Récupère le token FCM actuel et le sauvegarde dans Supabase.
  Future<void> _refreshTokenAndSync() async {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        await _saveTokenToSupabase(token);
      }
    } catch (e) {
      debugPrint('[CpPushService] token refresh error: $e');
    }

    // Écouter les renouvellements de token.
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      _saveTokenToSupabase(newToken);
    });
  }

  Future<void> _saveTokenToSupabase(String token) async {
    try {
      final sb = Supabase.instance.client;
      final user = sb.auth.currentUser;
      if (user == null) return;

      await sb.from('cp_user_notification_prefs').upsert(
        {
          'user_id': user.id,
          'fcm_token': token,
        },
        onConflict: 'user_id',
      );
    } catch (e) {
      debugPrint('[CpPushService] saveToken error: $e');
    }
  }

  // -------------------------------------------------------------------------
  // Messages au premier plan
  // -------------------------------------------------------------------------

  void _listenForegroundMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Si l'app est au premier plan et dans les quiet hours → ignorer.
      if (isCurrentlyInQuietHours()) {
        debugPrint('[CpPushService] Foreground message suppressed (quiet hours)');
        return;
      }
      // Sinon on laisse passer : le titre/body sont affichés par le système
      // ou par flutter_local_notifications (géré par NotificationsService).
      debugPrint(
          '[CpPushService] Foreground message: ${message.notification?.title}');
    });
  }

  // -------------------------------------------------------------------------
  // Hydratation & sync
  // -------------------------------------------------------------------------

  Future<void> _hydrateFromPrefs() async {
    final sp = await SharedPreferences.getInstance();
    final topics = <CpNotifTopic, bool>{};
    for (final t in CpNotifTopic.values) {
      topics[t] = sp.getBool(t.prefKey) ?? t.defaultEnabled;
    }
    _prefs = CpNotifPrefs(
      topics: topics,
      quietStartHour: sp.getInt('_cp_notif_quiet_start') ?? 22,
      quietEndHour: sp.getInt('_cp_notif_quiet_end') ?? 8,
      userTimezone:
          sp.getString('_cp_notif_timezone') ?? 'Europe/Paris',
    );
    _prefsController.add(_prefs);
  }

  Future<void> _applyFcmSubscriptions() async {
    for (final topic in CpNotifTopic.values) {
      final enabled = _prefs.isEnabled(topic);
      try {
        if (enabled) {
          await FirebaseMessaging.instance.subscribeToTopic(topic.topicId);
        } else {
          await FirebaseMessaging.instance.unsubscribeFromTopic(topic.topicId);
        }
      } catch (e) {
        debugPrint('[CpPushService] subscribe ${topic.topicId} error: $e');
      }
    }
  }

  Future<void> _syncPrefsToSupabase() async {
    try {
      final sb = Supabase.instance.client;
      final user = sb.auth.currentUser;
      if (user == null) return;

      await sb.from('cp_user_notification_prefs').upsert(
        {
          'user_id': user.id,
          'topic_new_case':
              _prefs.isEnabled(CpNotifTopic.newCase),
          'topic_streak_risk':
              _prefs.isEnabled(CpNotifTopic.streakRisk),
          'topic_appeal_result':
              _prefs.isEnabled(CpNotifTopic.appealResult),
          'topic_leaderboard':
              _prefs.isEnabled(CpNotifTopic.leaderboard),
          'quiet_start_hour': _prefs.quietStartHour,
          'quiet_end_hour': _prefs.quietEndHour,
          'user_timezone': _prefs.userTimezone,
        },
        onConflict: 'user_id',
      );
    } catch (e) {
      debugPrint('[CpPushService] syncPrefs error: $e');
    }
  }

  /// Réinitialise les abonnements après sign-in (appel depuis main.dart).
  Future<void> onUserSignedIn() async {
    await _hydrateFromPrefs();
    await _applyFcmSubscriptions();
    await _refreshTokenAndSync();
    _syncPrefsToSupabase();
  }

  /// Nettoie les souscriptions FCM après sign-out.
  Future<void> onUserSignedOut() async {
    for (final topic in CpNotifTopic.values) {
      try {
        await FirebaseMessaging.instance.unsubscribeFromTopic(topic.topicId);
      } catch (_) {}
    }
    try {
      await FirebaseMessaging.instance.deleteToken();
    } catch (_) {}
  }

  void dispose() {
    _prefsController.close();

  }
}
