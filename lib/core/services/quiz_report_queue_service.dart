import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Envoie les signalements et les conserve localement si le réseau est absent.
class QuizReportQueueService {
  QuizReportQueueService({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;
  static const _queueKey = 'copiq_quiz_report_offline_queue_v1';

  Future<bool> send(Map<String, dynamic> snapshot) async {
    await flushPending();
    try {
      await _client.from('report_question').insert(snapshot);
      return true;
    } catch (_) {
      final preferences = await SharedPreferences.getInstance();
      final queue = preferences.getStringList(_queueKey) ?? <String>[];
      queue.add(jsonEncode(snapshot));
      await preferences.setStringList(
        _queueKey,
        queue.length <= 100 ? queue : queue.sublist(queue.length - 100),
      );
      return false;
    }
  }

  Future<void> flushPending() async {
    if (_client.auth.currentUser == null) return;
    final preferences = await SharedPreferences.getInstance();
    final queue = preferences.getStringList(_queueKey) ?? const <String>[];
    if (queue.isEmpty) return;
    final remaining = <String>[];
    for (final raw in queue) {
      try {
        await _client
            .from('report_question')
            .insert(Map<String, dynamic>.from(jsonDecode(raw) as Map));
      } catch (_) {
        remaining.add(raw);
      }
    }
    await preferences.setStringList(_queueKey, remaining);
  }
}
