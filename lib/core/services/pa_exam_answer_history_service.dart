import 'package:supabase_flutter/supabase_flutter.dart';

class PaExamAnswerHistoryService {
  PaExamAnswerHistoryService._();

  static Future<void> record({
    required SupabaseClient client,
    required String moduleKey,
    required String quizKey,
    required String question,
    required String userAnswer,
    required String correctAnswer,
    required bool isCorrect,
    String? difficulty,
    int? historyId,
    String? questionId,
    int? responseTimeMs,
  }) async {
    final user = client.auth.currentUser;
    if (user == null) return;
    await client.from('quiz_answer_history').insert({
      'user_id': user.id,
      'history_id': historyId,
      'track': 'pa',
      'mode': 'exam',
      'module_key': moduleKey,
      'quiz_key': quizKey,
      'question_id': questionId,
      'question_text': question,
      'user_answer': userAnswer,
      'correct_answer': correctAnswer,
      'is_correct': isCorrect,
      'difficulty': difficulty,
      'response_time_ms': responseTimeMs,
      'answered_at': DateTime.now().toUtc().toIso8601String(),
    });
  }
}
