// COP'IQ — Sauvegarde des résultats de session psychotechnique.
// Utilise la table existante public.tests_psychotechnique_history.
//
// La colonne `accuracy` est calculée automatiquement côté DB (generated column).
// On envoie : score, correct, wrong, total, duration_seconds, avg_response_time, mode.

import 'package:supabase_flutter/supabase_flutter.dart';

class PsychoHistoryService {
  PsychoHistoryService({SupabaseClient? client})
    : _supabase = client ?? Supabase.instance.client;

  final SupabaseClient _supabase;

  Future<void> saveSession({
    required String exerciseType,
    required int score,
    required int correctAnswers,
    required int wrongAnswers,
    required int totalQuestions,
    required int durationSeconds,
    required double avgResponseTime,
    String mode = 'concours',
    String module = 'psychotechnique',
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;
    try {
      await _supabase.from('tests_psychotechnique_history').insert({
        'user_id': user.id,
        'exercise_type': exerciseType,
        'module': module,
        'score': score,
        'correct_answers': correctAnswers,
        'wrong_answers': wrongAnswers,
        'total_questions': totalQuestions,
        'duration_seconds': durationSeconds,
        'avg_response_time': avgResponseTime,
        'mode': mode,
      });
    } catch (_) {
      // Silencieux : la sauvegarde ne doit pas casser la fin d'exercice.
    }
  }
}
