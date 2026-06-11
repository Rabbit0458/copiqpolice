// lib/core/services/notifications_service.dart
//
// Service de notifications COP'IQ — locales et push.
//
// LOCAL :
//   - Notifications planifiées via `flutter_local_notifications`.
//   - Rappel quotidien (par défaut 19h) pour relancer l'utilisateur sur ses
//     quiz du jour.
//
// PUSH :
//   - Setup Firebase Cloud Messaging pour les notifs serveur.
//   - Le token FCM est sauvegardé dans `user_devices` côté Supabase pour
//     pouvoir cibler un utilisateur (côté backend).
//
// Initialisation : appeler `NotificationsService.I.init()` après Supabase
// dans main.dart.

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

class NotificationsService {
  NotificationsService._();
  static final NotificationsService instance = NotificationsService._();
  static NotificationsService get I => instance;

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  // ---------------------------------------------------------------------------
  // Channels
  // ---------------------------------------------------------------------------

  static const _dailyChannelId = 'copiq_daily_reminder';
  static const _dailyChannelName = 'Rappel quotidien';
  static const _dailyChannelDesc =
      'Rappel pour ne pas oublier ton quiz du jour.';

  static const _quizFeedbackChannelId = 'copiq_quiz_feedback';
  static const _quizFeedbackChannelName = 'Retour quiz';

  // ---------------------------------------------------------------------------
  // Init
  // ---------------------------------------------------------------------------

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    // Timezone (requis pour les notifs schedulées).
    tz_data.initializeTimeZones();
    try {
      // On utilise la timezone du device. Sur Android < 8.0 et iOS, c'est
      // automatique. Sur iOS plus récent et Android moderne, on doit set
      // explicitement.
      final localName = DateTime.now().timeZoneName;
      tz.setLocalLocation(tz.getLocation(_mapTzName(localName)));
    } catch (_) {
      // Fallback Paris.
      tz.setLocalLocation(tz.getLocation('Europe/Paris'));
    }

    // Init plugin (Android + iOS).
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    await _plugin.initialize(
      const InitializationSettings(android: androidInit, iOS: iosInit),
    );

    // Channels Android.
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      await android.createNotificationChannel(
        const AndroidNotificationChannel(
          _dailyChannelId,
          _dailyChannelName,
          description: _dailyChannelDesc,
          importance: Importance.high,
        ),
      );
      await android.createNotificationChannel(
        const AndroidNotificationChannel(
          _quizFeedbackChannelId,
          _quizFeedbackChannelName,
          importance: Importance.defaultImportance,
        ),
      );
    }
  }

  /// Demande la permission notif sur iOS / Android 13+.
  Future<bool> requestPermissions() async {
    if (!_initialized) await init();

    final ios = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    if (ios != null) {
      final ok = await ios.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return ok ?? false;
    }

    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      final ok = await android.requestNotificationsPermission();
      return ok ?? true;
    }

    return true;
  }

  // ---------------------------------------------------------------------------
  // Rappel quotidien
  // ---------------------------------------------------------------------------

  /// Planifie un rappel quotidien à l'heure donnée (par défaut 19h).
  ///
  /// La notif récurrente est identifiée par l'id 1000. Replanifier appelle
  /// d'abord `cancel(1000)` puis re-schedule, donc c'est idempotent.
  Future<void> scheduleDailyReminder({
    int hour = 19,
    int minute = 0,
    String title = 'Ton quiz du jour t’attend',
    String body = 'Prends 5 minutes pour progresser vers le concours.',
  }) async {
    if (!_initialized) await init();

    const id = 1000;
    await _plugin.cancel(id);

    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      scheduled,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _dailyChannelId,
          _dailyChannelName,
          channelDescription: _dailyChannelDesc,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // récurrence quotidienne
    );

    final sp = await SharedPreferences.getInstance();
    await sp.setInt('daily_reminder_hour', hour);
    await sp.setInt('daily_reminder_minute', minute);
    await sp.setBool('daily_reminder_enabled', true);
  }

  /// Annule le rappel quotidien.
  Future<void> cancelDailyReminder() async {
    await _plugin.cancel(1000);
    final sp = await SharedPreferences.getInstance();
    await sp.setBool('daily_reminder_enabled', false);
  }

  Future<({bool enabled, int hour, int minute})> getDailyReminderConfig() async {
    final sp = await SharedPreferences.getInstance();
    return (
      enabled: sp.getBool('daily_reminder_enabled') ?? false,
      hour: sp.getInt('daily_reminder_hour') ?? 19,
      minute: sp.getInt('daily_reminder_minute') ?? 0,
    );
  }

  // ---------------------------------------------------------------------------
  // Quiz feedback (one-shot)
  // ---------------------------------------------------------------------------

  Future<void> notifyQuizFinished({
    required String title,
    required String body,
  }) async {
    if (!_initialized) await init();
    await _plugin.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _quizFeedbackChannelId,
          _quizFeedbackChannelName,
          importance: Importance.defaultImportance,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Push token sync (Firebase Messaging branché ailleurs ; cette méthode
  // permet de sauvegarder le token côté Supabase).
  // ---------------------------------------------------------------------------

  Future<void> savePushToken(String token) async {
    try {
      final sb = Supabase.instance.client;
      final user = sb.auth.currentUser;
      if (user == null) return;
      await sb.from('user_devices').upsert({
        'user_id': user.id,
        'fcm_token': token,
        'updated_at': DateTime.now().toIso8601String(),
      }, onConflict: 'user_id,fcm_token');
    } catch (e) {
      debugPrint('[Notifications] savePushToken failed: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  String _mapTzName(String raw) {
    // tz package attend des noms IANA ; le device retourne souvent un short
    // name. On mappe les plus courants en France.
    switch (raw) {
      case 'CEST':
      case 'CET':
        return 'Europe/Paris';
      case 'WEST':
      case 'WET':
        return 'Europe/Lisbon';
      case 'EEST':
      case 'EET':
        return 'Europe/Athens';
    }
    // Tentative directe (si le device donne déjà un nom IANA, ex Linux/macOS).
    try {
      tz.getLocation(raw);
      return raw;
    } catch (_) {
      return 'Europe/Paris';
    }
  }
}
