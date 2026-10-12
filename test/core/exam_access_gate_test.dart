import 'dart:async';

import 'package:copiqpolice/core/services/subscription_service.dart';
import 'package:copiqpolice/core/widgets/exam_access_gate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('exam menus, history and school routes do not consume quota', () {
    for (final route in [
      '/gpx_exam',
      '/pa_exam/concours/tests_psychotechniques',
      '/gpx_exam/concours/tests_psychotechniques/comprendre_epreuve',
      '/gpx_exam/concours/cas_pratique/list',
      '/gpx_exam/concours/cas_pratique/privacy',
      '/pa_exam/concours/tests_psy/raisonnement_logique',
      '/pa_exam/concours/connaissances_generales',
      '/gpx/generalites/quiz/infraction',
      '/pa/generalites/quiz/infraction',
    ]) {
      expect(isQuotaExerciseRoute(route), isFalse, reason: route);
    }
  });

  test('both exam tracks and their legacy exercise aliases are gated', () {
    for (final track in ['gpx', 'pa']) {
      for (final leaf in [
        'culture_generale_droit',
        'tests_psychotechniques/calcul_rapide',
        'tests_psychotechniques/attention_concentration',
        'tests_psychotechniques/suites_logiques',
      ]) {
        expect(isQuotaExerciseRoute('/${track}_exam/concours/$leaf'), isTrue);
      }
    }
    expect(
      isQuotaExerciseRoute('/gpx_exam/concours/cas_pratique/case_dynamic'),
      isTrue,
    );
    expect(
      isQuotaExerciseRoute('/pa_exam/concours/tests_psy/aptitude_verbale'),
      isTrue,
    );
  });

  testWidgets('one authorization per route lifetime, content stays lazy', (
    tester,
  ) async {
    final pending = Completer<ConsumeResult>();
    var calls = 0;
    var builds = 0;
    final gate = ExamAccessGate(
      authorize: () {
        calls++;
        return pending.future;
      },
      builder: (_) {
        builds++;
        return const Text('exercise');
      },
    );
    await tester.pumpWidget(MaterialApp(home: gate));
    await tester.pump();
    expect(calls, 1);
    expect(builds, 0);
    pending.complete(const ConsumeResult(allowed: true, premium: false));
    await tester.pumpAndSettle();
    expect(find.text('exercise'), findsOneWidget);
    await tester.pumpWidget(MaterialApp(theme: ThemeData.dark(), home: gate));
    await tester.pump();
    expect(calls, 1);
  });

  testWidgets('server refusal never constructs exercise', (tester) async {
    var builds = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: ExamAccessGate(
          authorize: () async =>
              const ConsumeResult(allowed: false, premium: false),
          builder: (_) {
            builds++;
            return const Text('exercise');
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(builds, 0);
    expect(find.byIcon(Icons.lock_outline), findsOneWidget);
  });
}
