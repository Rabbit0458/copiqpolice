// placement_engine.dart

import 'package:copiqpolice/features/placement/placement_questions.dart';

enum Difficulty { easy, medium, hard }

class PlacementEngine {
  final Map<PlacementDomain, List<PlacementQuestion>> _questions;
  final Map<PlacementDomain, Difficulty> _currentDifficulty = {};
  final Map<PlacementDomain, int> _askedCount = {};

  int totalScore = 0;
  int maxScore = 0;

  PlacementEngine(this._questions) {
    for (var domain in PlacementDomain.values) {
      _currentDifficulty[domain] = Difficulty.medium;
      _askedCount[domain] = 0;
    }
  }

  PlacementQuestion? nextQuestion() {
    for (var domain in PlacementDomain.values) {
      if (_askedCount[domain]! < 6) {
        final difficulty = _currentDifficulty[domain]!;
        final candidates = _questions[domain]!
            .where((q) => q.difficulty == difficulty)
            .toList();

        if (candidates.isEmpty) return null;

        final question = candidates[_askedCount[domain]! % candidates.length];
        _askedCount[domain] = _askedCount[domain]! + 1;
        maxScore += question.weight;
        return question;
      }
    }
    return null;
  }

  void submitAnswer(PlacementQuestion question, int selectedIndex) {
    final correct = selectedIndex == question.correctIndex;
    if (correct) totalScore += question.weight;

    final current = _currentDifficulty[question.domain]!;

    if (correct) {
      if (current == Difficulty.easy) {
        _currentDifficulty[question.domain] = Difficulty.medium;
      } else if (current == Difficulty.medium) {
        _currentDifficulty[question.domain] = Difficulty.hard;
      }
    } else {
      if (current == Difficulty.hard) {
        _currentDifficulty[question.domain] = Difficulty.medium;
      } else if (current == Difficulty.medium) {
        _currentDifficulty[question.domain] = Difficulty.easy;
      }
    }
  }

  double get percentage => maxScore == 0 ? 0 : (totalScore / maxScore) * 100;

  String get level {
    final pct = percentage;
    if (pct < 40) return "Fondamentaux insuffisants";
    if (pct < 60) return "Niveau intermédiaire";
    if (pct < 80) return "Bon niveau";
    return "Niveau avancé";
  }
}
