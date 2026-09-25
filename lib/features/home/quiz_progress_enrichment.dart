import 'package:supabase_flutter/supabase_flutter.dart';

import 'pa_exam_progress_models.dart';

/// Rattache les réponses détaillées aux lignes de `quiz_history`.
/// Une tentative sans aucune réponse reste visible, mais ne devient jamais un
/// score de 0 % dans les statistiques de progression.
Future<List<PaProgressActivity>> enrichQuizProgress({
  required SupabaseClient client,
  required String userId,
  required String track,
  required String mode,
  required List<PaProgressActivity> activities,
}) async {
  if (activities.isEmpty) return activities;
  dynamic rows;
  try {
    rows = await client
        .from('quiz_answer_history')
        .select(
          'id, history_id, question_id, question_text, options_snapshot, '
          'user_answer, correct_answer, is_correct, explanation_snapshot, '
          'difficulty, response_time_ms, answered_at',
        )
        .eq('user_id', userId)
        .eq('track', track)
        .eq('mode', mode)
        .order('answered_at', ascending: true)
        .limit(10000);
  } on PostgrestException catch (error) {
    // Compatibilité pendant le déploiement progressif de la migration.
    if (error.code != '42703') rethrow;
    rows = await client
        .from('quiz_answer_history')
        .select(
          'id, history_id, question_id, question_text, user_answer, '
          'correct_answer, is_correct, difficulty, response_time_ms, '
          'answered_at',
        )
        .eq('user_id', userId)
        .eq('track', track)
        .eq('mode', mode)
        .order('answered_at', ascending: true)
        .limit(10000);
  }

  final grouped = <String, List<PaProgressAnswerDetail>>{};
  for (final row in List<Map<String, dynamic>>.from(rows as List)) {
    final historyId = row['history_id']?.toString();
    if (historyId == null) continue;
    grouped
        .putIfAbsent(historyId, () => [])
        .add(
          PaProgressAnswerDetail(
            question: (row['question_text'] ?? 'Question').toString(),
            userAnswer: (row['user_answer'] ?? 'Aucune réponse').toString(),
            correctAnswer: (row['correct_answer'] ?? 'Non renseignée')
                .toString(),
            isCorrect: row['is_correct'] == true,
            explanation: row['explanation_snapshot']?.toString(),
            options: _strings(row['options_snapshot']),
            questionId: row['question_id']?.toString(),
            difficulty: row['difficulty']?.toString(),
            responseTimeMs: _integerOrNull(row['response_time_ms']),
            answeredAt: DateTime.tryParse(
              row['answered_at']?.toString() ?? '',
            )?.toLocal(),
            answerId: row['id']?.toString(),
          ),
        );
  }

  return activities
      .map((activity) {
        final historyId = activity.id.split(':').last;
        final answers = grouped[historyId] ?? const <PaProgressAnswerDetail>[];
        final hasEvidence = answers.isNotEmpty;
        final answered = answers.length;
        final correct = hasEvidence
            ? answers.where((answer) => answer.isCorrect).length
            : activity.correct;
        // Les anciens résultats réellement scorés restent compatibles. Une ligne
        // à 0 sans aucune réponse enregistrée est considérée comme abandonnée.
        final legacyScored = !hasEvidence && activity.correct > 0;
        return PaProgressActivity(
          id: activity.id,
          source: activity.source,
          moduleKey: activity.moduleKey,
          moduleLabel: activity.moduleLabel,
          title: activity.title,
          correct: correct,
          total: hasEvidence ? answered : (legacyScored ? activity.total : 0),
          availableQuestions: activity.total,
          answeredCount: hasEvidence
              ? answered
              : (legacyScored ? activity.total : 0),
          answers: answers,
          finishedAt: activity.finishedAt,
          durationSeconds: activity.durationSeconds,
          route: activity.route,
        );
      })
      .toList(growable: false);
}

List<String> _strings(dynamic value) {
  if (value is! List) return const [];
  return value.map((item) => item.toString()).toList(growable: false);
}

int? _integerOrNull(dynamic value) {
  if (value == null) return null;
  return value is num ? value.round() : int.tryParse(value.toString());
}
