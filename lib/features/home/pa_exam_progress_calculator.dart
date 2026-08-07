import 'pa_exam_progress_models.dart';
import 'pa_exam_progress_source_registry.dart';

class PaExamProgressCalculator {
  const PaExamProgressCalculator({this.moduleMetaResolver = paModuleMeta});

  final PaProgressModuleMeta Function(String key) moduleMetaResolver;

  PaProgressSnapshot build({
    required List<PaProgressActivity> activities,
    required List<PaProgressErrorSummary> errors,
    required int dailyGoal,
    required DateTime now,
    PaPlacementBaseline? placement,
    String? partialWarning,
  }) {
    final sorted = [...activities]
      ..sort((a, b) => b.finishedAt.compareTo(a.finishedAt));
    var total = 0;
    var correct = 0;
    var duration = 0;
    for (final activity in sorted) {
      if (activity.total > 0) {
        total += activity.total;
        correct += activity.correct.clamp(0, activity.total);
      }
      duration += (activity.durationSeconds ?? 0).clamp(0, 86400);
    }

    final today = _day(now);
    final counts = <DateTime, int>{};
    for (final activity in sorted) {
      final day = _day(activity.finishedAt.toLocal());
      counts[day] = (counts[day] ?? 0) + 1;
    }
    final days = List.generate(28, (index) {
      final day = today.subtract(Duration(days: 27 - index));
      return PaProgressDay(day: day, activityCount: counts[day] ?? 0);
    });

    final startOfWeek = today.subtract(Duration(days: today.weekday - 1));
    final doneThisWeek = sorted
        .where((a) => !a.finishedAt.toLocal().isBefore(startOfWeek))
        .length;
    final subjects = _subjects(sorted);

    return PaProgressSnapshot(
      activities: sorted,
      subjects: subjects,
      days: days,
      trend: sorted
          .where((a) => a.hasScore)
          .map(
            (a) => PaProgressTrendPoint(date: a.finishedAt, percent: a.percent),
          )
          .toList()
          .reversed
          .toList(),
      errors: errors,
      dailyGoal: dailyGoal.clamp(1, 10),
      streakDays: computeStreak(counts.keys.toSet(), today),
      doneToday: counts[today] ?? 0,
      doneThisWeek: doneThisWeek,
      globalPercent: total == 0
          ? 0
          : ((correct / total) * 100).round().clamp(0, 100),
      totalQuestions: total,
      totalCorrect: correct,
      totalDurationSeconds: duration,
      recommendation: recommend(subjects),
      placement: placement,
      loadedAt: now,
      partialWarning: partialWarning,
    );
  }

  int computeStreak(Set<DateTime> days, DateTime today) {
    if (days.isEmpty) return 0;
    var cursor = _day(today);
    if (!days.contains(cursor)) {
      cursor = cursor.subtract(const Duration(days: 1));
      if (!days.contains(cursor)) return 0;
    }
    var streak = 0;
    while (days.contains(cursor)) {
      streak++;
      cursor = cursor.subtract(const Duration(days: 1));
    }
    return streak;
  }

  List<PaProgressSubject> _subjects(List<PaProgressActivity> activities) {
    final grouped = <String, List<PaProgressActivity>>{};
    for (final activity in activities.where((a) => a.hasScore)) {
      grouped.putIfAbsent(activity.moduleKey, () => []).add(activity);
    }
    final result = grouped.entries.map((entry) {
      final list = entry.value
        ..sort((a, b) => b.finishedAt.compareTo(a.finishedAt));
      final meta = moduleMetaResolver(entry.key);
      var total = 0;
      var correct = 0;
      var best = 0;
      for (final activity in list) {
        total += activity.total;
        correct += activity.correct.clamp(0, activity.total);
        if (activity.percent > best) best = activity.percent;
      }
      return PaProgressSubject(
        key: entry.key,
        label: meta.label,
        activities: list.length,
        correct: correct,
        total: total,
        bestPercent: best,
        lastPercent: list.first.percent,
        lastActivityAt: list.first.finishedAt,
        route: meta.route,
      );
    }).toList();
    result.sort((a, b) => a.averagePercent.compareTo(b.averagePercent));
    return result;
  }

  PaProgressRecommendation? recommend(List<PaProgressSubject> subjects) {
    if (subjects.isEmpty) return null;
    final reliable = subjects.where((s) => s.total >= 10).toList();
    final pool = reliable.isEmpty ? subjects : reliable;
    pool.sort((a, b) {
      final score = a.averagePercent.compareTo(b.averagePercent);
      if (score != 0) return score;
      return a.lastActivityAt.compareTo(b.lastActivityAt);
    });
    final subject = pool.first;
    final reason = subject.total < 10
        ? 'Encore peu de données : quelques exercices supplémentaires permettront de préciser ton niveau.'
        : subject.averagePercent < 60
        ? 'C’est actuellement ta matière la moins maîtrisée (${subject.averagePercent} % de moyenne).'
        : 'C’est la matière qui offre aujourd’hui la meilleure marge de progression.';
    return PaProgressRecommendation(subject: subject, reason: reason);
  }

  List<PaProgressTrendPoint> trendForPeriod(
    List<PaProgressTrendPoint> points,
    PaProgressPeriod period,
    DateTime now,
  ) {
    if (period == PaProgressPeriod.all) return points;
    final days = period == PaProgressPeriod.sevenDays ? 7 : 30;
    final from = now.subtract(Duration(days: days));
    return points.where((p) => !p.date.isBefore(from)).toList();
  }

  String trendMessage(List<PaProgressTrendPoint> points) {
    if (points.length < 2) {
      return 'Termine encore quelques quiz pour obtenir une tendance fiable.';
    }
    final split = points.length ~/ 2;
    final before =
        points.take(split).map((e) => e.percent).reduce((a, b) => a + b) /
        split;
    final afterList = points.skip(split).toList();
    final after =
        afterList.map((e) => e.percent).reduce((a, b) => a + b) /
        afterList.length;
    final delta = after - before;
    if (delta >= 4) return 'Tes résultats progressent sur cette période.';
    if (delta <= -4)
      return 'Une baisse récente apparaît : cible en priorité les matières les moins maîtrisées.';
    return 'Tes résultats sont stables. La régularité fera la différence.';
  }

  DateTime _day(DateTime value) => DateTime(value.year, value.month, value.day);
}
