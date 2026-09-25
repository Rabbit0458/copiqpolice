import 'package:supabase_flutter/supabase_flutter.dart';

import 'learning_answer_history_service.dart';

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
    await LearningAnswerHistoryService(client: client).record(
      historyId: historyId,
      track: 'pa',
      mode: 'exam',
      moduleKey: moduleKey,
      quizKey: quizKey,
      questionId: questionId,
      question: question,
      userAnswer: userAnswer,
      correctAnswer: correctAnswer,
      isCorrect: isCorrect,
      difficulty: difficulty,
      responseTimeMs: responseTimeMs,
    );
  }
}
