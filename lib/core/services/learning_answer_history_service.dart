import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

/// Point d'entrée unique de l'historique pédagogique COP'IQ.
///
/// Tous les quiz GPX/PA, scolarité/examen doivent passer par ce service. Le
/// serveur déduit lui-même l'utilisateur connecté et refuse toute tentative
/// appartenant à un autre compte.
class LearningAnswerHistoryService {
  LearningAnswerHistoryService({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;
  static const _uuid = Uuid();
  static const _queueKey = 'copiq_learning_answer_offline_queue_v1';

  Future<String?> record({
    required String track,
    required String mode,
    required String moduleKey,
    required String quizKey,
    required String question,
    required String userAnswer,
    required String correctAnswer,
    required bool isCorrect,
    int? historyId,
    String? questionId,
    List<String>? options,
    String? explanation,
    String? difficulty,
    int? responseTimeMs,
    int? questionPosition,
    String? questionVersion,
    String? clientEventId,
    String? confidence,
    String? perceivedCause,
  }) async {
    if (_client.auth.currentUser == null) return null;
    final params = <String, dynamic>{
      'p_history_id': historyId,
      'p_track': track,
      'p_mode': mode,
      'p_module_key': moduleKey,
      'p_quiz_key': quizKey,
      'p_question_id': questionId,
      'p_question_text': question,
      'p_options': options,
      'p_user_answer': userAnswer,
      'p_correct_answer': correctAnswer,
      'p_is_correct': isCorrect,
      'p_explanation': explanation,
      'p_difficulty': difficulty,
      'p_response_time_ms': responseTimeMs,
      'p_question_position': questionPosition,
      'p_client_event_id': clientEventId ?? _uuid.v4(),
      'p_question_version': questionVersion,
    };
    await flushPending();
    try {
      final value = await _client.rpc('record_learning_answer', params: params);
      final answerId = value?.toString();
      if (answerId != null && confidence != null) {
        await saveReflection(
          answerId: answerId,
          confidence: confidence,
          perceivedCause: perceivedCause,
        );
      }
      return answerId;
    } catch (_) {
      await _enqueue(params);
      return null;
    }
  }

  Future<void> saveReflection({
    required String answerId,
    required String confidence,
    String? perceivedCause,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) return;
    await _client.from('coach_answer_reflections').upsert({
      'user_id': user.id,
      'answer_id': answerId,
      'confidence': confidence,
      'perceived_cause': perceivedCause,
      'updated_at': DateTime.now().toUtc().toIso8601String(),
    }, onConflict: 'user_id,answer_id');
  }

  Future<void> flushPending() async {
    if (_client.auth.currentUser == null) return;
    final preferences = await SharedPreferences.getInstance();
    final raw = preferences.getStringList(_queueKey) ?? const [];
    if (raw.isEmpty) return;
    final remaining = <String>[];
    for (final item in raw) {
      try {
        final params = Map<String, dynamic>.from(jsonDecode(item) as Map);
        await _client.rpc('record_learning_answer', params: params);
      } catch (_) {
        remaining.add(item);
      }
    }
    await preferences.setStringList(_queueKey, remaining.take(500).toList());
  }

  Future<void> _enqueue(Map<String, dynamic> params) async {
    final preferences = await SharedPreferences.getInstance();
    final queue = preferences.getStringList(_queueKey) ?? <String>[];
    final eventId = params['p_client_event_id']?.toString();
    if (queue.any((item) => item.contains(eventId ?? ''))) return;
    queue.add(jsonEncode(params));
    await preferences.setStringList(
      _queueKey,
      queue.length <= 500 ? queue : queue.sublist(queue.length - 500),
    );
  }
}
