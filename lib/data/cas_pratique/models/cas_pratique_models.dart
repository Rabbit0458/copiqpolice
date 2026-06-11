// ╔════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Cas Pratique — Modèles de données                            ║
// ║  Référence : docs/cas_pratique/10_API_SURFACE.md (section 2)            ║
// ║  Tâches     : CODE-010 + CODE-011                                       ║
// ╚════════════════════════════════════════════════════════════════════════╝

import 'dart:convert';

// ─── Helpers parsing ────────────────────────────────────────────────────────
DateTime? _asDate(dynamic v) =>
    v == null ? null : DateTime.tryParse(v.toString())?.toUtc();

double? _asDouble(dynamic v) {
  if (v == null) return null;
  if (v is num) return v.toDouble();
  return double.tryParse(v.toString());
}

int? _asInt(dynamic v) {
  if (v == null) return null;
  if (v is int) return v;
  if (v is num) return v.toInt();
  return int.tryParse(v.toString());
}

// ════════════════════════════════════════════════════════════════════════════
//  TAXONOMIE
// ════════════════════════════════════════════════════════════════════════════

class CpTheme {
  final String id;
  final String slug;
  final String label;
  final String colorHex;
  final String icon;
  final int sortOrder;

  const CpTheme({
    required this.id,
    required this.slug,
    required this.label,
    required this.colorHex,
    required this.icon,
    required this.sortOrder,
  });

  factory CpTheme.fromJson(Map<String, dynamic> j) => CpTheme(
        id: j['id'] as String,
        slug: j['slug'] as String,
        label: j['label'] as String,
        colorHex: (j['color_hex'] ?? '#1147D9') as String,
        icon: (j['icon'] ?? 'shield_rounded') as String,
        sortOrder: _asInt(j['sort_order']) ?? 100,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'slug': slug,
        'label': label,
        'color_hex': colorHex,
        'icon': icon,
        'sort_order': sortOrder,
      };
}

// ════════════════════════════════════════════════════════════════════════════
//  CAS
// ════════════════════════════════════════════════════════════════════════════

enum CpDifficulty { facile, moyen, difficile }

CpDifficulty _parseDifficulty(String? s) => switch (s) {
      'facile' => CpDifficulty.facile,
      'difficile' => CpDifficulty.difficile,
      _ => CpDifficulty.moyen,
    };

String difficultyToString(CpDifficulty d) => d.name;

class UserCaseProgress {
  final DateTime? lastAttemptAt;
  final double? lastScorePercent;
  final double? bestScorePercent;
  final int attemptsCount;

  const UserCaseProgress({
    required this.lastAttemptAt,
    required this.lastScorePercent,
    required this.bestScorePercent,
    required this.attemptsCount,
  });

  factory UserCaseProgress.fromRow(Map<String, dynamic> j) => UserCaseProgress(
        lastAttemptAt: _asDate(j['last_attempt_at']),
        lastScorePercent: _asDouble(j['last_score']),
        bestScorePercent: _asDouble(j['best_score']),
        attemptsCount: _asInt(j['attempts_count']) ?? 0,
      );
}

/// Vue résumée d'un cas pour la liste.
class CaseSummary {
  final String id;
  final String slug;
  final String title;
  final int year;
  final String? month;
  final CpTheme? theme;
  final CpDifficulty difficulty;
  final int totalPoints;
  final int estimatedMinutes;
  final DateTime? publishedAt;
  final UserCaseProgress? userProgress;
  final double? avgSuccessPercent;
  /// CODE-064 : cas démo accessible à tous (même free tier). Les autres
  /// nécessitent l'abonnement (paywall = CODE-084).
  final bool isFree;

  const CaseSummary({
    required this.id,
    required this.slug,
    required this.title,
    required this.year,
    required this.month,
    required this.theme,
    required this.difficulty,
    required this.totalPoints,
    required this.estimatedMinutes,
    required this.publishedAt,
    required this.userProgress,
    required this.avgSuccessPercent,
    this.isFree = false,
  });

  factory CaseSummary.fromJson(Map<String, dynamic> j) {
    final themeJson = j['theme'] as Map<String, dynamic>?;
    return CaseSummary(
      id: j['id'] as String,
      slug: j['slug'] as String,
      title: j['title'] as String,
      year: _asInt(j['year']) ?? 0,
      month: j['month'] as String?,
      theme: themeJson != null ? CpTheme.fromJson(themeJson) : null,
      difficulty: _parseDifficulty(j['difficulty'] as String?),
      totalPoints: _asInt(j['total_points']) ?? 15,
      estimatedMinutes: _asInt(j['estimated_minutes']) ?? 15,
      publishedAt: _asDate(j['published_at']),
      userProgress: j['user_progress'] is Map<String, dynamic>
          ? UserCaseProgress.fromRow(j['user_progress'] as Map<String, dynamic>)
          : null,
      avgSuccessPercent: _asDouble(j['avg_success_percent']),
      isFree: j['is_free'] == true,
    );
  }

  bool get isNew {
    final p = publishedAt;
    if (p == null) return false;
    return DateTime.now().toUtc().difference(p).inDays < 7;
  }
}

class LegalReference {
  final String article;
  final String code;
  final String? label;

  const LegalReference({
    required this.article,
    required this.code,
    this.label,
  });

  factory LegalReference.fromJson(Map<String, dynamic> j) => LegalReference(
        article: (j['article'] ?? '').toString(),
        code: (j['code'] ?? 'penal').toString(),
        label: j['label'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'article': article,
        'code': code,
        if (label != null) 'label': label,
      };
}

class PerfectAnswer {
  final String bodyMd;
  final List<LegalReference> referencesLegal;

  const PerfectAnswer({
    required this.bodyMd,
    required this.referencesLegal,
  });

  factory PerfectAnswer.fromJson(Map<String, dynamic> j) => PerfectAnswer(
        bodyMd: (j['body_md'] ?? '') as String,
        referencesLegal: (j['references_legal'] as List? ?? const [])
            .whereType<Map<String, dynamic>>()
            .map(LegalReference.fromJson)
            .toList(),
      );
}

class Question {
  final String id;
  final int position;
  final String label;
  final String? hint;
  final int maxPoints;
  final int charMin;
  final int charRecommended;
  final PerfectAnswer? perfectAnswer;

  const Question({
    required this.id,
    required this.position,
    required this.label,
    required this.hint,
    required this.maxPoints,
    required this.charMin,
    required this.charRecommended,
    required this.perfectAnswer,
  });

  factory Question.fromJson(Map<String, dynamic> j) => Question(
        id: j['id'] as String,
        position: _asInt(j['position']) ?? 0,
        label: j['label'] as String,
        hint: j['hint'] as String?,
        maxPoints: _asInt(j['max_points']) ?? 5,
        charMin: _asInt(j['char_min']) ?? 50,
        charRecommended: _asInt(j['char_recommended']) ?? 400,
        perfectAnswer: j['perfect_answer'] is Map<String, dynamic>
            ? PerfectAnswer.fromJson(j['perfect_answer'] as Map<String, dynamic>)
            : null,
      );
}

class CaseDetail {
  final CaseSummary summary;
  final String situationText;
  final String? situationMd;
  final List<Question> questions;

  const CaseDetail({
    required this.summary,
    required this.situationText,
    required this.situationMd,
    required this.questions,
  });

  factory CaseDetail.fromJson(Map<String, dynamic> j) => CaseDetail(
        summary: CaseSummary.fromJson(j),
        situationText: (j['situation_text'] ?? '') as String,
        situationMd: j['situation_md'] as String?,
        questions: (j['questions'] as List? ?? const [])
            .whereType<Map<String, dynamic>>()
            .map(Question.fromJson)
            .toList()
          ..sort((a, b) => a.position.compareTo(b.position)),
      );
}

// ════════════════════════════════════════════════════════════════════════════
//  TENTATIVES / RÉPONSES / CORRECTION
// ════════════════════════════════════════════════════════════════════════════

enum AttemptStatus { inProgress, completed, abandoned }

AttemptStatus _parseAttemptStatus(String? s) => switch (s) {
      'completed' => AttemptStatus.completed,
      'abandoned' => AttemptStatus.abandoned,
      _ => AttemptStatus.inProgress,
    };

String attemptStatusToString(AttemptStatus s) => switch (s) {
      AttemptStatus.inProgress => 'in_progress',
      AttemptStatus.completed => 'completed',
      AttemptStatus.abandoned => 'abandoned',
    };

class Attempt {
  final String id;
  final String userId;
  final String caseId;
  final DateTime startedAt;
  final DateTime? finishedAt;
  final AttemptStatus status;
  final double? totalScore;
  final double? totalMax;
  final double? percent;
  final int? timeSpentMs;

  const Attempt({
    required this.id,
    required this.userId,
    required this.caseId,
    required this.startedAt,
    required this.finishedAt,
    required this.status,
    required this.totalScore,
    required this.totalMax,
    required this.percent,
    required this.timeSpentMs,
  });

  factory Attempt.fromJson(Map<String, dynamic> j) => Attempt(
        id: j['id'] as String,
        userId: j['user_id'] as String,
        caseId: j['case_id'] as String,
        startedAt: _asDate(j['started_at']) ?? DateTime.now().toUtc(),
        finishedAt: _asDate(j['finished_at']),
        status: _parseAttemptStatus(j['status'] as String?),
        totalScore: _asDouble(j['total_score']),
        totalMax: _asDouble(j['total_max']),
        percent: _asDouble(j['percent']),
        timeSpentMs: _asInt(j['time_spent_ms']),
      );
}

enum AnswerStatus { draft, validated }

AnswerStatus _parseAnswerStatus(String? s) =>
    s == 'draft' ? AnswerStatus.draft : AnswerStatus.validated;

String answerStatusToString(AnswerStatus s) =>
    s == AnswerStatus.draft ? 'draft' : 'validated';

class Answer {
  final String id;
  final String? attemptId;
  final String? questionId;
  final int questionIndex;
  final String text;
  final int charCount;
  final AnswerStatus status;
  final DateTime updatedAt;

  const Answer({
    required this.id,
    required this.attemptId,
    required this.questionId,
    required this.questionIndex,
    required this.text,
    required this.charCount,
    required this.status,
    required this.updatedAt,
  });

  factory Answer.fromJson(Map<String, dynamic> j) => Answer(
        id: j['id'] as String,
        attemptId: j['attempt_id'] as String?,
        questionId: j['question_id'] as String?,
        questionIndex: _asInt(j['question_index']) ?? 0,
        text: (j['answer'] ?? '') as String,
        charCount: _asInt(j['char_count']) ?? ((j['answer'] ?? '') as String).length,
        status: _parseAnswerStatus(j['status'] as String?),
        updatedAt: _asDate(j['updated_at']) ?? DateTime.now().toUtc(),
      );
}

enum PointStatus { covered, partial, missing }

PointStatus _parsePointStatus(String? s) => switch (s) {
      'covered' => PointStatus.covered,
      'partial' => PointStatus.partial,
      _ => PointStatus.missing,
    };

String pointStatusToString(PointStatus s) => s.name;

enum PointKind { core, bonus }

PointKind _parsePointKind(String? s) =>
    s == 'bonus' ? PointKind.bonus : PointKind.core;

class CorrectionDetail {
  final String id;
  final String questionId;
  final String pointId;
  final String pointLabel;
  final PointKind pointKind;
  final PointStatus status;
  final double score;
  final double weight;
  final String? explanationMd;
  final List<Map<String, dynamic>> groupMatches;

  const CorrectionDetail({
    required this.id,
    required this.questionId,
    required this.pointId,
    required this.pointLabel,
    required this.pointKind,
    required this.status,
    required this.score,
    required this.weight,
    required this.explanationMd,
    required this.groupMatches,
  });

  factory CorrectionDetail.fromJson(Map<String, dynamic> j) => CorrectionDetail(
        id: (j['id'] ?? '') as String,
        questionId: (j['question_id'] ?? '') as String,
        pointId: (j['point_id'] ?? '') as String,
        pointLabel: (j['point_label'] ?? '') as String,
        pointKind: _parsePointKind(j['point_kind'] as String?),
        status: _parsePointStatus(j['status'] as String?),
        score: _asDouble(j['score']) ?? 0.0,
        weight: _asDouble(j['weight']) ?? 1.0,
        explanationMd: j['explanation_md'] as String?,
        groupMatches: (j['group_matches'] as List? ?? const [])
            .whereType<Map<String, dynamic>>()
            .toList(),
      );
}

class Correction {
  final String id;
  final String attemptId;
  final double totalScore;
  final double totalMax;
  final double percent;
  final DateTime evaluatedAt;
  final String engineVersion;
  final List<CorrectionDetail> details;

  const Correction({
    required this.id,
    required this.attemptId,
    required this.totalScore,
    required this.totalMax,
    required this.percent,
    required this.evaluatedAt,
    required this.engineVersion,
    required this.details,
  });

  factory Correction.fromJson(Map<String, dynamic> j) => Correction(
        id: j['id'] as String,
        attemptId: j['attempt_id'] as String,
        totalScore: _asDouble(j['total_score']) ?? 0.0,
        totalMax: _asDouble(j['total_max']) ?? 0.0,
        percent: _asDouble(j['percent']) ?? 0.0,
        evaluatedAt: _asDate(j['evaluated_at']) ?? DateTime.now().toUtc(),
        engineVersion: (j['engine_version'] ?? '2.0.0') as String,
        details: (j['details'] as List? ?? const [])
            .whereType<Map<String, dynamic>>()
            .map(CorrectionDetail.fromJson)
            .toList(),
      );

  /// Détails groupés par question_id (pour l'affichage en accordion).
  Map<String, List<CorrectionDetail>> get detailsByQuestion {
    final m = <String, List<CorrectionDetail>>{};
    for (final d in details) {
      m.putIfAbsent(d.questionId, () => []).add(d);
    }
    return m;
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  APPELS (signalement user)
// ════════════════════════════════════════════════════════════════════════════

enum AppealStatus { pending, approved, rejected }

AppealStatus _parseAppealStatus(String? s) => switch (s) {
      'approved' => AppealStatus.approved,
      'rejected' => AppealStatus.rejected,
      _ => AppealStatus.pending,
    };

class Appeal {
  final String id;
  final String correctionDetailId;
  final String userId;
  final String? message;
  final AppealStatus status;
  final String? adminResponse;
  final DateTime? processedAt;
  final DateTime createdAt;

  const Appeal({
    required this.id,
    required this.correctionDetailId,
    required this.userId,
    required this.message,
    required this.status,
    required this.adminResponse,
    required this.processedAt,
    required this.createdAt,
  });

  factory Appeal.fromJson(Map<String, dynamic> j) => Appeal(
        id: j['id'] as String,
        correctionDetailId: j['correction_detail_id'] as String,
        userId: j['user_id'] as String,
        message: j['message'] as String?,
        status: _parseAppealStatus(j['status'] as String?),
        adminResponse: j['admin_response'] as String?,
        processedAt: _asDate(j['processed_at']),
        createdAt: _asDate(j['created_at']) ?? DateTime.now().toUtc(),
      );
}

// ════════════════════════════════════════════════════════════════════════════
//  PROGRESSION USER (globale)
// ════════════════════════════════════════════════════════════════════════════

class UserGlobalProgress {
  final int casesStarted;
  final int casesFinished;
  final int totalAttempts;
  final double? avgScorePercent;
  final double? bestScorePercent;
  final DateTime? lastAttemptAt;
  final int streakDays;

  const UserGlobalProgress({
    required this.casesStarted,
    required this.casesFinished,
    required this.totalAttempts,
    required this.avgScorePercent,
    required this.bestScorePercent,
    required this.lastAttemptAt,
    required this.streakDays,
  });

  factory UserGlobalProgress.fromJson(Map<String, dynamic> j) =>
      UserGlobalProgress(
        casesStarted: _asInt(j['cases_started']) ?? 0,
        casesFinished: _asInt(j['cases_finished']) ?? 0,
        totalAttempts: _asInt(j['total_attempts']) ?? 0,
        avgScorePercent: _asDouble(j['avg_score_percent']),
        bestScorePercent: _asDouble(j['best_score_percent']),
        lastAttemptAt: _asDate(j['last_attempt_at']),
        streakDays: _asInt(j['streak_days']) ?? 0,
      );

  static const empty = UserGlobalProgress(
    casesStarted: 0,
    casesFinished: 0,
    totalAttempts: 0,
    avgScorePercent: null,
    bestScorePercent: null,
    lastAttemptAt: null,
    streakDays: 0,
  );
}

// ════════════════════════════════════════════════════════════════════════════
//  Encodage utilitaire JSON (debug / cache)
// ════════════════════════════════════════════════════════════════════════════

String prettyJson(Object? o) => const JsonEncoder.withIndent('  ').convert(o);
