import 'dart:async';

import 'package:flutter/foundation.dart';

enum QuizEndState {
  inProgress,
  confirmationOpen,
  saving,
  saveFailed,
  resultsReady,
  resultsShown,
}

@immutable
class QuizEndSummary {
  const QuizEndSummary({
    required this.total,
    required this.correct,
    required this.wrong,
    required this.unanswered,
    required this.percentage,
    required this.endedEarly,
  });

  factory QuizEndSummary.calculate({
    required int total,
    required int correct,
    required int wrong,
    required bool endedEarly,
  }) {
    final safeTotal = total < 0 ? 0 : total;
    final safeCorrect = correct.clamp(0, safeTotal);
    final safeWrong = wrong.clamp(0, safeTotal - safeCorrect);
    return QuizEndSummary(
      total: safeTotal,
      correct: safeCorrect,
      wrong: safeWrong,
      unanswered: (safeTotal - safeCorrect - safeWrong).clamp(0, safeTotal),
      percentage: safeTotal == 0
          ? 0
          : ((safeCorrect / safeTotal) * 100).round(),
      endedEarly: endedEarly,
    );
  }

  final int total;
  final int correct;
  final int wrong;
  final int unanswered;
  final int percentage;
  final bool endedEarly;
}

/// État commun de fin de quiz. Une même instance doit être utilisée par la
/// croix, le bouton « Mettre fin » et le retour système.
class QuizEndController extends ChangeNotifier {
  QuizEndState _state = QuizEndState.inProgress;
  Future<bool>? _inFlight;
  Future<void> Function()? _lastSave;

  QuizEndState get state => _state;
  bool get isBusy => _state == QuizEndState.saving;
  bool get hasFinished =>
      _state == QuizEndState.resultsReady ||
      _state == QuizEndState.resultsShown;

  bool openConfirmation() {
    if (isBusy || hasFinished || _state == QuizEndState.confirmationOpen) {
      return false;
    }
    _setState(QuizEndState.confirmationOpen);
    return true;
  }

  void cancelConfirmation() {
    if (_state == QuizEndState.confirmationOpen) {
      _setState(QuizEndState.inProgress);
    }
  }

  Future<bool> save(Future<void> Function() operation) {
    if (_inFlight != null) return _inFlight!;
    if (hasFinished) return Future<bool>.value(true);
    _lastSave = operation;
    final completer = Completer<bool>();
    _inFlight = completer.future;
    _setState(QuizEndState.saving);
    () async {
      try {
        await operation();
        _setState(QuizEndState.resultsReady);
        completer.complete(true);
      } catch (error, stackTrace) {
        debugPrint('quiz_end: sauvegarde impossible: $error');
        debugPrintStack(stackTrace: stackTrace);
        _setState(QuizEndState.saveFailed);
        completer.complete(false);
      } finally {
        _inFlight = null;
      }
    }();
    return completer.future;
  }

  Future<bool> retry() {
    final operation = _lastSave;
    if (operation == null) return Future<bool>.value(false);
    return save(operation);
  }

  void markResultsShown() {
    if (_state == QuizEndState.resultsReady) {
      _setState(QuizEndState.resultsShown);
    }
  }

  void reset() {
    if (isBusy) return;
    _lastSave = null;
    _setState(QuizEndState.inProgress);
  }

  void _setState(QuizEndState value) {
    _state = value;
    notifyListeners();
  }
}
