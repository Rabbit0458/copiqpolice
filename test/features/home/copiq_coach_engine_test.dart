import 'package:copiqpolice/features/home/copiq_coach_engine.dart';
import 'package:copiqpolice/features/home/pa_exam_progress_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('programme une erreur pour le lendemain', () {
    final now = DateTime(2026, 8, 27, 12);
    final plan = const CopiqCoachEngine().build(
      _snapshot([
        _activity(
          PaProgressAnswerDetail(
            question: 'Question A',
            userAnswer: 'A',
            correctAnswer: 'B',
            isCorrect: false,
            answeredAt: now.subtract(const Duration(days: 2)),
          ),
        ),
      ]),
      now,
    );
    expect(plan.dueErrors, hasLength(1));
    expect(plan.headline, 'Révisions prêtes');
  });

  test('détecte une erreur récurrente sans inventer une notion', () {
    final now = DateTime(2026, 8, 27, 12);
    final answers = [
      for (var day in [2, 5])
        PaProgressAnswerDetail(
          question: 'Même question',
          questionId: 'stable-id',
          userAnswer: 'A',
          correctAnswer: 'B',
          isCorrect: false,
          answeredAt: now.subtract(Duration(days: day)),
        ),
    ];
    final plan = const CopiqCoachEngine().build(
      _snapshot(answers.map(_activity).toList()),
      now,
    );
    expect(plan.recurringErrors, 1);
  });
}

PaProgressActivity _activity(PaProgressAnswerDetail answer) =>
    PaProgressActivity(
      id: 'quiz:${answer.answeredAt?.millisecondsSinceEpoch}',
      source: PaProgressSource.quiz,
      moduleKey: 'fondamentaux',
      moduleLabel: 'Fondamentaux',
      title: 'Quiz',
      correct: 0,
      total: 1,
      finishedAt: answer.answeredAt!,
      answers: [answer],
    );

PaProgressSnapshot _snapshot(List<PaProgressActivity> activities) =>
    PaProgressSnapshot(
      activities: activities,
      subjects: const [],
      days: const [],
      trend: const [],
      errors: const [],
      dailyGoal: 3,
      streakDays: 0,
      doneToday: 0,
      doneThisWeek: 0,
      globalPercent: 0,
      totalQuestions: activities.length,
      totalCorrect: 0,
      totalDurationSeconds: 0,
      recommendation: null,
      placement: null,
      loadedAt: DateTime(2026, 8, 27),
    );
