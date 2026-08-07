import 'package:copiqpolice/features/home/pa_exam_progress_models.dart';
import 'package:copiqpolice/features/home/pa_exam_progress_page.dart';
import 'package:copiqpolice/features/home/pa_exam_progress_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeProgressSource implements PaExamProgressDataSource {
  _FakeProgressSource(this.result);
  final PaProgressLoadResult result;
  @override
  Future<PaProgressLoadResult> load() async => result;
  @override
  Future<void> saveDailyGoal(int value) async {}
}

void main() {
  Widget app(PaProgressLoadResult result) => MaterialApp(
    home: Scaffold(
      body: PaExamProgressPage(
        onStart: () {},
        dataSource: _FakeProgressSource(result),
      ),
    ),
  );

  testWidgets('affiche un état déconnecté explicite', (tester) async {
    await tester.pumpWidget(app(const PaProgressSignedOut()));
    await tester.pumpAndSettle();
    expect(
      find.text('Connecte-toi pour suivre ta progression'),
      findsOneWidget,
    );
  });

  testWidgets('distingue une erreur de l’absence de données', (tester) async {
    await tester.pumpWidget(app(const PaProgressLoadFailure('Erreur de test')));
    await tester.pumpAndSettle();
    expect(find.text('Progression indisponible'), findsOneWidget);
    expect(find.text('Erreur de test'), findsOneWidget);
  });

  testWidgets('affiche un appel à commencer lorsque l’historique est vide', (
    tester,
  ) async {
    final now = DateTime(2026, 8, 1);
    final snapshot = PaProgressSnapshot(
      activities: const [],
      subjects: const [],
      days: List.generate(
        28,
        (index) => PaProgressDay(
          day: now.subtract(Duration(days: 27 - index)),
          activityCount: 0,
        ),
      ),
      trend: const [],
      errors: const [],
      dailyGoal: 3,
      streakDays: 0,
      doneToday: 0,
      doneThisWeek: 0,
      globalPercent: 0,
      totalQuestions: 0,
      totalCorrect: 0,
      totalDurationSeconds: 0,
      recommendation: null,
      placement: null,
      loadedAt: now,
    );
    await tester.pumpWidget(app(PaProgressLoaded(snapshot)));
    await tester.pumpAndSettle();
    expect(find.text('Commence ta progression'), findsOneWidget);
    expect(find.text('Commencer un entraînement'), findsOneWidget);
  });

  testWidgets('la page chargée tient sur un écran de 320 pixels', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final now = DateTime(2026, 8, 1, 12);
    final activity = PaProgressActivity(
      id: 'quiz:1',
      source: PaProgressSource.quiz,
      moduleKey: 'culture_generale',
      moduleLabel: 'Culture générale',
      title: 'Culture générale',
      correct: 8,
      total: 10,
      finishedAt: now,
    );
    final subject = PaProgressSubject(
      key: 'culture_generale',
      label: 'Culture générale',
      activities: 1,
      correct: 8,
      total: 10,
      bestPercent: 80,
      lastPercent: 80,
      lastActivityAt: now,
      route: null,
    );
    final snapshot = PaProgressSnapshot(
      activities: [activity],
      subjects: [subject],
      days: List.generate(
        28,
        (index) => PaProgressDay(
          day: now.subtract(Duration(days: 27 - index)),
          activityCount: index == 27 ? 1 : 0,
        ),
      ),
      trend: [PaProgressTrendPoint(date: now, percent: 80)],
      errors: const [],
      dailyGoal: 3,
      streakDays: 1,
      doneToday: 1,
      doneThisWeek: 1,
      globalPercent: 80,
      totalQuestions: 10,
      totalCorrect: 8,
      totalDurationSeconds: 0,
      recommendation: PaProgressRecommendation(
        subject: subject,
        reason: 'Continue cet entraînement.',
      ),
      placement: null,
      loadedAt: now,
    );
    await tester.pumpWidget(app(PaProgressLoaded(snapshot)));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('Mon suivi'), findsOneWidget);
    expect(find.text('Progression générale'), findsOneWidget);
  });
}
