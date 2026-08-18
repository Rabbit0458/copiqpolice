import 'dart:async';

import 'package:copiqpolice/core/quiz/quiz_end_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('QuizEndSummary', () {
    test('calcule une tentative partielle sans division incorrecte', () {
      final summary = QuizEndSummary.calculate(
        total: 10,
        correct: 3,
        wrong: 2,
        endedEarly: true,
      );

      expect(summary.percentage, 30);
      expect(summary.unanswered, 5);
      expect(summary.endedEarly, isTrue);
    });

    test('gère un quiz vide', () {
      final summary = QuizEndSummary.calculate(
        total: 0,
        correct: 0,
        wrong: 0,
        endedEarly: true,
      );
      expect(summary.percentage, 0);
      expect(summary.unanswered, 0);
    });
  });

  group('QuizEndController', () {
    test('annule la confirmation et reprend le quiz', () {
      final controller = QuizEndController();
      expect(controller.openConfirmation(), isTrue);
      controller.cancelConfirmation();
      expect(controller.state, QuizEndState.inProgress);
    });

    test('une seule sauvegarde est lancée malgré plusieurs clics', () async {
      final controller = QuizEndController();
      final gate = Completer<void>();
      var calls = 0;
      Future<void> save() async {
        calls++;
        await gate.future;
      }

      final first = controller.save(save);
      final second = controller.save(save);
      expect(controller.state, QuizEndState.saving);
      expect(calls, 1);
      gate.complete();
      expect(await first, isTrue);
      expect(await second, isTrue);
      expect(calls, 1);
    });

    test('expose l’échec puis permet un retry', () async {
      final controller = QuizEndController();
      var calls = 0;
      Future<void> save() async {
        calls++;
        if (calls == 1) throw Exception('offline');
      }

      expect(await controller.save(save), isFalse);
      expect(controller.state, QuizEndState.saveFailed);
      expect(await controller.retry(), isTrue);
      expect(controller.state, QuizEndState.resultsReady);
      expect(calls, 2);
    });

    test(
      'une tentative terminée ne peut pas être sauvegardée deux fois',
      () async {
        final controller = QuizEndController();
        var calls = 0;
        Future<void> save() async => calls++;

        expect(await controller.save(save), isTrue);
        expect(await controller.save(save), isTrue);
        expect(calls, 1);
      },
    );
  });
}
