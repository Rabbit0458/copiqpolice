enum PaProgressSource { quiz, psychotechnique, photolangage, casePractical }

enum PaProgressPeriod { sevenDays, thirtyDays, all }

enum PaProgressHistorySort { recent, best, weakest }

class PaProgressActivity {
  const PaProgressActivity({
    required this.id,
    required this.source,
    required this.moduleKey,
    required this.moduleLabel,
    required this.title,
    required this.correct,
    required this.total,
    required this.finishedAt,
    this.durationSeconds,
    this.route,
  });

  final String id;
  final PaProgressSource source;
  final String moduleKey;
  final String moduleLabel;
  final String title;
  final int correct;
  final int total;
  final DateTime finishedAt;
  final int? durationSeconds;
  final String? route;

  bool get hasScore => total > 0;
  int get percent =>
      total <= 0 ? 0 : ((correct / total) * 100).round().clamp(0, 100);
}

class PaProgressDay {
  const PaProgressDay({required this.day, required this.activityCount});
  final DateTime day;
  final int activityCount;
}

class PaProgressSubject {
  const PaProgressSubject({
    required this.key,
    required this.label,
    required this.activities,
    required this.correct,
    required this.total,
    required this.bestPercent,
    required this.lastPercent,
    required this.lastActivityAt,
    required this.route,
  });

  final String key;
  final String label;
  final int activities;
  final int correct;
  final int total;
  final int bestPercent;
  final int lastPercent;
  final DateTime lastActivityAt;
  final String? route;

  int get averagePercent =>
      total <= 0 ? 0 : ((correct / total) * 100).round().clamp(0, 100);
}

class PaProgressTrendPoint {
  const PaProgressTrendPoint({required this.date, required this.percent});
  final DateTime date;
  final int percent;
}

class PaProgressRecommendation {
  const PaProgressRecommendation({required this.subject, required this.reason});
  final PaProgressSubject subject;
  final String reason;
}

class PaProgressErrorSummary {
  const PaProgressErrorSummary({
    required this.moduleKey,
    required this.moduleLabel,
    required this.wrongCount,
    required this.totalCount,
  });
  final String moduleKey;
  final String moduleLabel;
  final int wrongCount;
  final int totalCount;
}

class PaPlacementBaseline {
  const PaPlacementBaseline({required this.percent, required this.createdAt});
  final int percent;
  final DateTime createdAt;
}

class PaProgressSnapshot {
  const PaProgressSnapshot({
    required this.activities,
    required this.subjects,
    required this.days,
    required this.trend,
    required this.errors,
    required this.dailyGoal,
    required this.streakDays,
    required this.doneToday,
    required this.doneThisWeek,
    required this.globalPercent,
    required this.totalQuestions,
    required this.totalCorrect,
    required this.totalDurationSeconds,
    required this.recommendation,
    required this.placement,
    required this.loadedAt,
    this.partialWarning,
  });

  final List<PaProgressActivity> activities;
  final List<PaProgressSubject> subjects;
  final List<PaProgressDay> days;
  final List<PaProgressTrendPoint> trend;
  final List<PaProgressErrorSummary> errors;
  final int dailyGoal;
  final int streakDays;
  final int doneToday;
  final int doneThisWeek;
  final int globalPercent;
  final int totalQuestions;
  final int totalCorrect;
  final int totalDurationSeconds;
  final PaProgressRecommendation? recommendation;
  final PaPlacementBaseline? placement;
  final DateTime loadedAt;
  final String? partialWarning;

  bool get isEmpty => activities.isEmpty;
}

sealed class PaProgressLoadResult {
  const PaProgressLoadResult();
}

class PaProgressLoaded extends PaProgressLoadResult {
  const PaProgressLoaded(this.snapshot);
  final PaProgressSnapshot snapshot;
}

class PaProgressSignedOut extends PaProgressLoadResult {
  const PaProgressSignedOut();
}

class PaProgressLoadFailure extends PaProgressLoadResult {
  const PaProgressLoadFailure(this.message);
  final String message;
}
