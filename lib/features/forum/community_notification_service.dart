import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/services/notifications_service.dart';
import 'community_repository.dart';

/// Pont temps réel entre les notifications Supabase et les alertes locales.
/// La base conserve le centre d'activité ; les préférences décident seulement
/// si une bannière/son doit être présenté sur l'appareil.
class CommunityNotificationService {
  CommunityNotificationService._();
  static final CommunityNotificationService I =
      CommunityNotificationService._();

  RealtimeChannel? _channel;
  StreamSubscription<AuthState>? _authSubscription;
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;
    await NotificationsService.I.init();
    await _subscribeForCurrentUser();
    _authSubscription = Supabase.instance.client.auth.onAuthStateChange.listen(
      (_) => _subscribeForCurrentUser(),
    );
  }

  Future<bool> requestPermission() =>
      NotificationsService.I.requestPermissions();

  Future<void> _subscribeForCurrentUser() async {
    final client = Supabase.instance.client;
    if (_channel != null) {
      await client.removeChannel(_channel!);
      _channel = null;
    }
    final userId = client.auth.currentUser?.id;
    if (userId == null) return;

    _channel = client
        .channel('community-alerts:$userId')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'community_notifications',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'recipient_id',
            value: userId,
          ),
          callback: (payload) => _present(payload.newRecord),
        )
        .subscribe();
  }

  Future<void> _present(Map<String, dynamic> record) async {
    try {
      final repository = CommunityRepository();
      final preferences = await repository.notificationPreferences();
      final type = record['type'] as String? ?? '';
      final allowed =
          preferences.enabled &&
          (type == 'message'
              ? preferences.messagesEnabled
              : preferences.forumEnabled);
      if (!allowed) return;

      final id = record['id'] as String?;
      final rows = await repository.notifications();
      final item = rows.where((row) => row.id == id).firstOrNull;
      final actor = item?.actorDisplayName.trim() ?? '';
      final title = switch (type) {
        'message' => actor.isEmpty ? 'Nouveau message' : actor,
        'reaction' => 'Nouvelle réaction',
        'post_reply' || 'followed_post_reply' => 'Nouvelle réponse',
        _ => 'Nouvelle activité COP’IQ',
      };
      final body = switch (type) {
        'message' =>
          actor.isEmpty
              ? 'Tu as reçu un nouveau message privé.'
              : '$actor t’a envoyé un message.',
        'reaction' =>
          actor.isEmpty
              ? 'Quelqu’un a réagi à ta publication.'
              : '$actor a réagi à ta publication.',
        'post_reply' || 'followed_post_reply' =>
          actor.isEmpty
              ? 'Quelqu’un a répondu à une discussion.'
              : '$actor a répondu à une discussion.',
        _ => 'Une nouvelle activité est disponible.',
      };
      await NotificationsService.I.notifyCommunityActivity(
        title: title,
        body: body,
        payload: record['target_id'] as String?,
      );
    } catch (error) {
      debugPrint('[CommunityNotifications] alert failed: $error');
    }
  }

  Future<void> dispose() async {
    await _authSubscription?.cancel();
    if (_channel != null) {
      await Supabase.instance.client.removeChannel(_channel!);
    }
    _initialized = false;
  }
}
