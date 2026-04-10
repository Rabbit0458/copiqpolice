import 'package:supabase_flutter/supabase_flutter.dart';

class QuizAttempt {
  final int id;
  final String uid;
  final String? email;

  final String moduleName;
  final String quizName;

  final int score; // souvent = percent, selon ta logique
  final int totalQuestions;
  final int correctCount;

  final DateTime? completedAt; // si utilisé
  final DateTime? startedAt;
  final DateTime? finishedAt;

  const QuizAttempt({
    required this.id,
    required this.uid,
    required this.email,
    required this.moduleName,
    required this.quizName,
    required this.score,
    required this.totalQuestions,
    required this.correctCount,
    required this.completedAt,
    required this.startedAt,
    required this.finishedAt,
  });

  /// % basé sur correct/total (plus fiable que score si jamais score = autre chose)
  int get percent {
    if (totalQuestions <= 0) return 0;
    final p = ((correctCount / totalQuestions) * 100).round();
    return p.clamp(0, 100);
  }

  /// “Thème” affiché (module en priorité)
  String get theme {
    final m = moduleName.trim();
    if (m.isNotEmpty) return m;
    final q = quizName.trim();
    return q.isNotEmpty ? q : 'Quiz';
  }

  static DateTime? _parse(dynamic v) {
    if (v == null) return null;
    return DateTime.tryParse(v.toString());
  }

  static int _asInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    return int.tryParse(v.toString()) ?? 0;
  }

  factory QuizAttempt.fromRow(Map<String, dynamic> r) {
    return QuizAttempt(
      id: _asInt(r['id']),
      uid: (r['uid'] ?? '').toString(),
      email: r['email']?.toString(),
      moduleName: (r['module_name'] ?? '').toString(),
      quizName: (r['quiz_name'] ?? '').toString(),
      score: _asInt(r['score']),
      totalQuestions: _asInt(r['total_questions']),
      correctCount: _asInt(r['correct_count']),
      completedAt: _parse(r['completed_at']),
      startedAt: _parse(r['started_at']),
      finishedAt: _parse(r['finished_at']),
    );
  }
}

class ThemeAggregate {
  final String theme;
  final int attemptsCount;
  final int totalQuestions;
  final int correctTotal;

  final int bestPercent;
  final int lastPercent;
  final DateTime? lastFinishedAt;

  const ThemeAggregate({
    required this.theme,
    required this.attemptsCount,
    required this.totalQuestions,
    required this.correctTotal,
    required this.bestPercent,
    required this.lastPercent,
    required this.lastFinishedAt,
  });

  /// moyenne pondérée par nb de questions
  int get averagePercent {
    if (totalQuestions <= 0) return 0;
    final p = ((correctTotal / totalQuestions) * 100).round();
    return p.clamp(0, 100);
  }
}

class QuizHistoryService {
  final SupabaseClient supabase;
  QuizHistoryService(this.supabase);

  Future<void> resetProgress({required String uid}) async {
    // ✅ Table principale
    await supabase.from('quiz_history').delete().eq('uid', uid);
  }

  /// Récupère toutes les tentatives terminées
  Future<List<QuizAttempt>> fetchAttempts({
    required String uid,
    int limit = 500,
  }) async {
    final rows = await supabase
        .from('quiz_history')
        .select(
          'id, uid, email, module_name, quiz_name, score, total_questions, correct_count, completed_at, started_at, finished_at',
        )
        .eq('uid', uid)
        .not('finished_at', 'is', null)
        .order('finished_at', ascending: false)
        .limit(limit);

    return (rows as List)
        .map((e) => QuizAttempt.fromRow(e as Map<String, dynamic>))
        .toList();
  }

  /// Agrégation par thème (module_name sinon quiz_name)
  List<ThemeAggregate> aggregateByTheme(List<QuizAttempt> attempts) {
    final map = <String, List<QuizAttempt>>{};
    for (final a in attempts) {
      map.putIfAbsent(a.theme, () => []).add(a);
    }

    final aggs = <ThemeAggregate>[];

    map.forEach((theme, list) {
      // list est déjà triée desc si elle vient de fetchAttempts
      int totalQ = 0;
      int correctT = 0;
      int best = 0;

      for (final a in list) {
        totalQ += a.totalQuestions;
        correctT += a.correctCount;
        if (a.percent > best) best = a.percent;
      }

      final last = list.isNotEmpty ? list.first : null;

      aggs.add(
        ThemeAggregate(
          theme: theme,
          attemptsCount: list.length,
          totalQuestions: totalQ,
          correctTotal: correctT,
          bestPercent: best,
          lastPercent: last?.percent ?? 0,
          lastFinishedAt: last?.finishedAt ?? last?.completedAt,
        ),
      );
    });

    // Tri: meilleurs thèmes d’abord (moyenne pondérée), puis nb d’essais
    aggs.sort((a, b) {
      final c = b.averagePercent.compareTo(a.averagePercent);
      if (c != 0) return c;
      return b.attemptsCount.compareTo(a.attemptsCount);
    });

    return aggs;
  }

  /// Note générale globale (pondérée)
  int globalPercent(List<QuizAttempt> attempts) {
    int tq = 0;
    int cc = 0;
    for (final a in attempts) {
      tq += a.totalQuestions;
      cc += a.correctCount;
    }
    if (tq <= 0) return 0;
    return (((cc / tq) * 100).round()).clamp(0, 100);
  }
}
