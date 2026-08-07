import 'package:copiqpolice/features/home/pa_exam_progress_calculator.dart';
import 'package:copiqpolice/features/home/pa_exam_progress_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const calculator = PaExamProgressCalculator();
  final now = DateTime(2026, 8, 1, 12);

  PaProgressActivity activity({
    required String id,
    required DateTime date,
    required int correct,
    required int total,
    String module = 'culture_generale',
  }) => PaProgressActivity(
    id: id,
    source: PaProgressSource.quiz,
    moduleKey: module,
    moduleLabel: module,
    title: id,
    correct: correct,
    total: total,
    finishedAt: date,
  );

  test('calcule une moyenne globale pondérée par le nombre de questions', () {
    final snapshot = calculator.build(
      activities: [
        activity(id: 'court', date: now, correct: 5, total: 5),
        activity(id: 'long', date: now, correct: 10, total: 20),
      ],
      errors: const [],
      dailyGoal: 3,
      now: now,
    );

    expect(snapshot.globalPercent, 60);
    expect(snapshot.totalCorrect, 15);
    expect(snapshot.totalQuestions, 25);
  });

  test('ignore les activités sans question dans la moyenne', () {
    final snapshot = calculator.build(
      activities: [
        activity(id: 'vide', date: now, correct: 0, total: 0),
        activity(id: 'valide', date: now, correct: 8, total: 10),
      ],
      errors: const [],
      dailyGoal: 3,
      now: now,
    );

    expect(snapshot.globalPercent, 80);
    expect(snapshot.activities, hasLength(2));
  });

  test('calcule le streak depuis aujourd’hui', () {
    final snapshot = calculator.build(
      activities: [
        activity(id: '1', date: now, correct: 1, total: 1),
        activity(
          id: '2',
          date: now.subtract(const Duration(days: 1)),
          correct: 1,
          total: 1,
        ),
        activity(
          id: '3',
          date: now.subtract(const Duration(days: 2)),
          correct: 1,
          total: 1,
        ),
      ],
      errors: const [],
      dailyGoal: 3,
      now: now,
    );

    expect(snapshot.streakDays, 3);
    expect(snapshot.doneToday, 1);
  });

  test(
    'préserve le streak pendant la journée si la dernière activité est hier',
    () {
      final snapshot = calculator.build(
        activities: [
          activity(
            id: '1',
            date: now.subtract(const Duration(days: 1)),
            correct: 1,
            total: 1,
          ),
          activity(
            id: '2',
            date: now.subtract(const Duration(days: 2)),
            correct: 1,
            total: 1,
          ),
        ],
        errors: const [],
        dailyGoal: 3,
        now: now,
      );

      expect(snapshot.streakDays, 2);
      expect(snapshot.doneToday, 0);
    },
  );

  test('rompt le streak après plus d’un jour sans activité', () {
    final snapshot = calculator.build(
      activities: [
        activity(
          id: '1',
          date: now.subtract(const Duration(days: 2)),
          correct: 1,
          total: 1,
        ),
      ],
      errors: const [],
      dailyGoal: 3,
      now: now,
    );

    expect(snapshot.streakDays, 0);
  });

  test('le positionnement reste séparé des statistiques quotidiennes', () {
    final snapshot = calculator.build(
      activities: [activity(id: 'quiz', date: now, correct: 8, total: 10)],
      errors: const [],
      dailyGoal: 3,
      now: now,
      placement: PaPlacementBaseline(
        percent: 20,
        createdAt: now.subtract(const Duration(days: 30)),
      ),
    );

    expect(snapshot.globalPercent, 80);
    expect(snapshot.activities, hasLength(1));
    expect(snapshot.placement?.percent, 20);
  });

  test('recommande en priorité la matière fiable la plus faible', () {
    final snapshot = calculator.build(
      activities: [
        activity(
          id: 'culture',
          date: now,
          correct: 5,
          total: 20,
          module: 'culture_generale',
        ),
        activity(
          id: 'psy',
          date: now,
          correct: 18,
          total: 20,
          module: 'psychotechnique',
        ),
      ],
      errors: const [],
      dailyGoal: 3,
      now: now,
    );

    expect(snapshot.recommendation?.subject.key, 'culture_generale');
  });
}
