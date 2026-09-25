import 'pa_exam_progress_models.dart';

enum CopiqMasteryLevel { discovery, fragile, progressing, mastered }

enum CopiqErrorCause {
  unknownConcept,
  confusion,
  inattention,
  tooSlow,
  forgotten,
}

class CopiqReadiness {
  const CopiqReadiness({
    required this.score,
    required this.knowledge,
    required this.regularity,
    required this.durability,
    required this.speed,
    required this.coverage,
  });
  final int score;
  final int knowledge;
  final int regularity;
  final int durability;
  final int speed;
  final int coverage;
}

class CopiqWeeklySummary {
  const CopiqWeeklySummary({
    required this.questions,
    required this.correctedErrors,
    required this.activeDays,
    required this.delta,
  });
  final int questions;
  final int correctedErrors;
  final int activeDays;
  final int delta;
}

class CopiqBadge {
  const CopiqBadge(this.title, this.description, this.unlocked);
  final String title;
  final String description;
  final bool unlocked;
}

class CopiqCoachPlan {
  const CopiqCoachPlan({
    required this.headline,
    required this.message,
    required this.priority,
    required this.dueErrors,
    required this.recurringErrors,
    required this.minutes,
    required this.readiness,
    required this.weekly,
    required this.causes,
    required this.forgettingRisks,
    required this.badges,
    required this.recurringQuestions,
  });

  final String headline;
  final String message;
  final PaProgressSubject? priority;
  final List<PaProgressAnswerDetail> dueErrors;
  final int recurringErrors;
  final int minutes;
  final CopiqReadiness readiness;
  final CopiqWeeklySummary weekly;
  final Map<CopiqErrorCause, int> causes;
  final List<PaProgressAnswerDetail> forgettingRisks;
  final List<CopiqBadge> badges;
  final List<PaProgressAnswerDetail> recurringQuestions;
}

/// Moteur pédagogique déterministe : les conseils restent vérifiables et sont
/// recalculés à partir de l'historique Supabase de l'utilisateur.
class CopiqCoachEngine {
  const CopiqCoachEngine();

  CopiqCoachPlan build(PaProgressSnapshot snapshot, DateTime now) {
    final wrong = snapshot.wrongAnswerHistory;
    final grouped = <String, List<PaProgressAnswerDetail>>{};
    for (final answer in wrong) {
      grouped.putIfAbsent(_key(answer), () => []).add(answer);
    }
    final due = <PaProgressAnswerDetail>[];
    var recurring = 0;
    for (final answers in grouped.values) {
      answers.sort((a, b) => _date(b).compareTo(_date(a)));
      if (answers.length >= 2) recurring++;
      final last = answers.first;
      final delay = _reviewDelay(answers.length);
      if (!_date(last).add(delay).isAfter(now)) due.add(last);
    }
    due.sort((a, b) => _date(a).compareTo(_date(b)));
    final priority = snapshot.recommendation?.subject;
    final label = priority?.label ?? 'tes fondamentaux';
    final readiness = _readiness(snapshot, now);
    final weekly = _weekly(snapshot, now);
    final causes = <CopiqErrorCause, int>{};
    for (final answer in wrong) {
      final cause = diagnose(answer, now);
      causes[cause] = (causes[cause] ?? 0) + 1;
    }
    final forgetting =
        snapshot.answerHistory
            .where((a) => a.isCorrect && now.difference(_date(a)).inDays >= 21)
            .toList()
          ..sort((a, b) => _date(a).compareTo(_date(b)));
    return CopiqCoachPlan(
      headline: due.isEmpty ? 'Consolide tes acquis' : 'Révisions prêtes',
      message: due.isEmpty
          ? 'Ton coach te conseille de travailler $label aujourd’hui.'
          : '${due.length} erreur${due.length > 1 ? 's' : ''} à revoir aujourd’hui, puis un entraînement en $label.',
      priority: priority,
      dueErrors: due,
      recurringErrors: recurring,
      minutes: (8 + due.length * 2).clamp(8, 25),
      readiness: readiness,
      weekly: weekly,
      causes: causes,
      forgettingRisks: forgetting.take(10).toList(),
      recurringQuestions: grouped.values
          .where((answers) => answers.length >= 2)
          .map((answers) => answers.first)
          .take(10)
          .toList(),
      badges: [
        CopiqBadge('Régulier', '7 jours actifs', snapshot.streakDays >= 7),
        CopiqBadge(
          'Correcteur',
          '10 erreurs retravaillées',
          wrong.length >= 10,
        ),
        CopiqBadge(
          'Matière maîtrisée',
          'Une matière au-dessus de 80 %',
          snapshot.subjects.any(
            (s) => mastery(s) == CopiqMasteryLevel.mastered,
          ),
        ),
        CopiqBadge(
          'Progression',
          'Gain récent de 15 points',
          weekly.delta >= 15,
        ),
      ],
    );
  }

  CopiqErrorCause diagnose(PaProgressAnswerDetail answer, DateTime now) {
    if ((answer.responseTimeMs ?? 0) >= 45000) return CopiqErrorCause.tooSlow;
    if (now.difference(_date(answer)).inDays >= 21) {
      return CopiqErrorCause.forgotten;
    }
    if (answer.options.contains(answer.userAnswer) &&
        answer.userAnswer.isNotEmpty) {
      return CopiqErrorCause.confusion;
    }
    if (answer.responseTimeMs != null && answer.responseTimeMs! < 2500) {
      return CopiqErrorCause.inattention;
    }
    return CopiqErrorCause.unknownConcept;
  }

  CopiqMasteryLevel mastery(PaProgressSubject subject) {
    if (subject.total < 5) return CopiqMasteryLevel.discovery;
    if (subject.averagePercent < 55) return CopiqMasteryLevel.fragile;
    if (subject.averagePercent < 80) return CopiqMasteryLevel.progressing;
    return CopiqMasteryLevel.mastered;
  }

  Duration _reviewDelay(int failures) => switch (failures) {
    <= 1 => const Duration(days: 1),
    2 => const Duration(days: 3),
    3 => const Duration(days: 7),
    _ => const Duration(days: 30),
  };

  String _key(PaProgressAnswerDetail answer) =>
      answer.questionId?.trim().isNotEmpty == true
      ? answer.questionId!.trim()
      : answer.question.trim().toLowerCase();

  DateTime _date(PaProgressAnswerDetail answer) =>
      answer.answeredAt ?? DateTime.fromMillisecondsSinceEpoch(0);

  CopiqReadiness _readiness(PaProgressSnapshot snapshot, DateTime now) {
    final knowledge = snapshot.globalPercent;
    final regularity = (snapshot.doneThisWeek * 14).clamp(0, 100);
    final mastered = snapshot.subjects
        .where((s) => mastery(s) == CopiqMasteryLevel.mastered)
        .length;
    final durability = snapshot.subjects.isEmpty
        ? 0
        : (mastered * 100 / snapshot.subjects.length).round();
    final timed = snapshot.answerHistory.where((a) => a.responseTimeMs != null);
    final speed = timed.isEmpty
        ? 50
        : (100 -
                  timed
                          .map(
                            (a) => ((a.responseTimeMs! / 60000) * 100).clamp(
                              0,
                              100,
                            ),
                          )
                          .reduce((a, b) => a + b) /
                      timed.length)
              .round()
              .clamp(0, 100);
    final coverage = (snapshot.subjects.length * 20).clamp(0, 100);
    final score =
        (knowledge * .4 +
                regularity * .2 +
                durability * .2 +
                speed * .1 +
                coverage * .1)
            .round()
            .clamp(0, 100);
    return CopiqReadiness(
      score: score,
      knowledge: knowledge,
      regularity: regularity,
      durability: durability,
      speed: speed,
      coverage: coverage,
    );
  }

  CopiqWeeklySummary _weekly(PaProgressSnapshot snapshot, DateTime now) {
    final recent = snapshot.activities
        .where((a) => now.difference(a.finishedAt).inDays < 7 && a.hasScore)
        .toList();
    final previous = snapshot.activities.where((a) {
      final days = now.difference(a.finishedAt).inDays;
      return days >= 7 && days < 14 && a.hasScore;
    }).toList();
    int average(List<PaProgressActivity> list) => list.isEmpty
        ? 0
        : (list.map((a) => a.percent).reduce((a, b) => a + b) / list.length)
              .round();
    return CopiqWeeklySummary(
      questions: recent.fold(0, (sum, a) => sum + a.effectiveAnsweredCount),
      correctedErrors: recent
          .expand((a) => a.answers)
          .where((a) => a.isCorrect)
          .length,
      activeDays: recent
          .map(
            (a) => DateTime(
              a.finishedAt.year,
              a.finishedAt.month,
              a.finishedAt.day,
            ),
          )
          .toSet()
          .length,
      delta: average(recent) - average(previous),
    );
  }
}
