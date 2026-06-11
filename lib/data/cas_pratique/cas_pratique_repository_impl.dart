// ╔════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Cas Pratique — Repository (implémentation Supabase)          ║
// ║  Référence : docs/cas_pratique/10_API_SURFACE.md                        ║
// ║  Tâches     : CODE-014, CODE-015, CODE-016 (les suivantes complèteront)║
// ╚════════════════════════════════════════════════════════════════════════╝

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:copiqpolice/data/cas_pratique/cas_pratique_repository.dart';
import 'package:copiqpolice/data/cas_pratique/cas_pratique_exception.dart';
import 'package:copiqpolice/data/cas_pratique/cas_pratique_cache.dart';
import 'package:copiqpolice/data/cas_pratique/models/cas_pratique_models.dart';

/// Implémentation Supabase du repository Cas Pratique.
///
/// Toutes les méthodes :
/// - utilisent `Supabase.instance.client`
/// - exigent un user authentifié pour les opérations sur les attempts/answers
/// - convertissent les erreurs Postgres en `CasPratiqueException`
class CasPratiqueRepositoryImpl implements CasPratiqueRepository {
  CasPratiqueRepositoryImpl({SupabaseClient? client, CasPratiqueCache? cache})
      : _sb = client ?? Supabase.instance.client,
        _cache = cache ?? CasPratiqueCache.instance;

  final SupabaseClient _sb;
  final CasPratiqueCache _cache;

  // Flag pour forcer un re-fetch ignoring le cache (set par refreshCache)
  bool _bustCache = false;

  // ═══════════════════════════════════════════════════════════════════════
  //  HELPERS
  // ═══════════════════════════════════════════════════════════════════════

  String _requireUserId() {
    final u = _sb.auth.currentUser;
    if (u == null) {
      throw CasPratiqueException.notAuthenticated();
    }
    return u.id;
  }

  Never _rethrow(Object e, StackTrace st, {String? context}) {
    if (kDebugMode) {
      debugPrint('[CasPratiqueRepository] ${context ?? ''} error: $e');
    }
    if (e is PostgrestException) {
      throw CasPratiqueException(
        code: _mapPgError(e),
        message: e.message,
        cause: e,
        stackTrace: st,
      );
    }
    if (e is AuthException) {
      throw CasPratiqueException.notAuthenticated();
    }
    throw CasPratiqueException.unknown(e, st);
  }

  static CasPratiqueErrorCode _mapPgError(PostgrestException e) {
    final c = e.code ?? '';
    switch (c) {
      case 'PGRST301':
      case '42501':
        return CasPratiqueErrorCode.rlsForbidden;
      case 'PGRST116':
        return CasPratiqueErrorCode.caseNotFound;
      default:
        return CasPratiqueErrorCode.serverError;
    }
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  CODE-014 — THEMES + LIST CASES
  // ═══════════════════════════════════════════════════════════════════════

  @override
  Future<List<CpTheme>> listThemes() async {
    // 1) Tentative depuis le cache
    if (!_bustCache) {
      final cached = await _cache.getFreshJson('themes', ttl: CacheTtl.themes);
      if (cached is List) {
        return cached
            .whereType<Map<String, dynamic>>()
            .map(CpTheme.fromJson)
            .toList();
      }
    }
    try {
      final rows = await _sb
          .from('cas_pratique_themes')
          .select()
          .order('sort_order', ascending: true);
      final list = (rows as List).whereType<Map<String, dynamic>>().toList();
      // 2) Mise en cache
      await _cache.putJson('themes', list);
      return list.map(CpTheme.fromJson).toList();
    } catch (e, st) {
      _rethrow(e, st, context: 'listThemes');
    }
  }

  @override
  Future<List<CaseSummary>> listCases({
    Set<String>? themeSlugs,
    Set<int>? years,
    Set<CpDifficulty>? difficulties,
    String? searchQuery,
    CaseSortBy sortBy = CaseSortBy.recent,
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      // 1) Requête principale : cases + theme joint
      var query = _sb
          .from('cas_pratique_cases')
          .select('''
            id, slug, title, year, month, difficulty,
            total_points, estimated_minutes, published_at, status, is_free,
            theme:cas_pratique_themes(id, slug, label, color_hex, icon, sort_order)
          ''')
          .eq('status', 'published');

      if (themeSlugs != null && themeSlugs.isNotEmpty) {
        // Filtrer côté DB via jointure : on filtre les rows dont theme.slug ∈ ...
        // PostgREST n'autorise pas un filter direct sur un join chain ; on
        // fait un sous-query manuel via in_('theme_id', ...) après lookup.
        final themeIds = await _resolveThemeIds(themeSlugs);
        if (themeIds.isEmpty) return const [];
        query = query.inFilter('theme_id', themeIds);
      }
      if (years != null && years.isNotEmpty) {
        query = query.inFilter('year', years.toList());
      }
      if (difficulties != null && difficulties.isNotEmpty) {
        query = query.inFilter(
          'difficulty',
          difficulties.map(difficultyToString).toList(),
        );
      }
      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        final q = searchQuery.trim();
        // Recherche : title ILIKE OR situation_text ILIKE
        query = query.or('title.ilike.%$q%,situation_text.ilike.%$q%');
      }

      // Tri
      final ordered = switch (sortBy) {
        CaseSortBy.recent =>
          query.order('published_at', ascending: false, nullsFirst: false),
        CaseSortBy.alphabetical => query.order('title', ascending: true),
        CaseSortBy.durationAsc =>
          query.order('estimated_minutes', ascending: true),
        CaseSortBy.durationDesc =>
          query.order('estimated_minutes', ascending: false),
        // Le tri par score nécessite un join avec attempts, on retombe sur recent
        _ => query.order('published_at', ascending: false, nullsFirst: false),
      };

      final rows = await ordered.range(offset, offset + limit - 1);

      final cases = (rows as List)
          .whereType<Map<String, dynamic>>()
          .map(CaseSummary.fromJson)
          .toList();

      // 2) Si user connecté, on enrichit avec user_progress par cas
      final userId = _sb.auth.currentUser?.id;
      if (userId == null || cases.isEmpty) return cases;

      final progressByCase = await _fetchProgressForCases(
        userId: userId,
        caseIds: cases.map((c) => c.id).toList(),
      );

      // 3) Rebind avec les user_progress (CaseSummary est immutable → on recrée)
      return [
        for (final c in cases)
          CaseSummary(
            id: c.id,
            slug: c.slug,
            title: c.title,
            year: c.year,
            month: c.month,
            theme: c.theme,
            difficulty: c.difficulty,
            totalPoints: c.totalPoints,
            estimatedMinutes: c.estimatedMinutes,
            publishedAt: c.publishedAt,
            userProgress: progressByCase[c.id],
            avgSuccessPercent: c.avgSuccessPercent,
            isFree: c.isFree,
          ),
      ];
    } catch (e, st) {
      _rethrow(e, st, context: 'listCases');
    }
  }

  Future<List<String>> _resolveThemeIds(Set<String> slugs) async {
    final rows = await _sb
        .from('cas_pratique_themes')
        .select('id, slug')
        .inFilter('slug', slugs.toList());
    return (rows as List)
        .whereType<Map<String, dynamic>>()
        .map((r) => r['id'] as String)
        .toList();
  }

  Future<Map<String, UserCaseProgress>> _fetchProgressForCases({
    required String userId,
    required List<String> caseIds,
  }) async {
    if (caseIds.isEmpty) return const {};

    final rows = await _sb
        .from('cas_pratique_attempts')
        .select('case_id, percent, finished_at')
        .eq('user_id', userId)
        .inFilter('case_id', caseIds)
        .order('finished_at', ascending: false, nullsFirst: false);

    final acc = <String, _AggProgress>{};
    for (final r in (rows as List).whereType<Map<String, dynamic>>()) {
      final caseId = r['case_id'] as String;
      final pct = r['percent'] is num ? (r['percent'] as num).toDouble() : null;
      final finished = r['finished_at'] != null
          ? DateTime.tryParse(r['finished_at'].toString())
          : null;

      acc.update(
        caseId,
        (a) => a.add(pct, finished),
        ifAbsent: () => _AggProgress(pct, finished, 1),
      );
    }

    return acc.map(
      (caseId, a) => MapEntry(
        caseId,
        UserCaseProgress(
          lastAttemptAt: a.lastFinishedAt,
          lastScorePercent: a.lastPercent,
          bestScorePercent: a.bestPercent,
          attemptsCount: a.count,
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  CODE-015 — GET CASE DETAIL (cas + questions, sans rubric)
  // ═══════════════════════════════════════════════════════════════════════

  @override
  Future<CaseDetail> getCaseDetail(String slugOrId) async {
    final cacheKey = 'case_detail.$slugOrId';
    // 1) Lecture cache
    if (!_bustCache) {
      final cached = await _cache.getFreshJson(cacheKey, ttl: CacheTtl.caseDetail);
      if (cached is Map<String, dynamic>) {
        try {
          return CaseDetail.fromJson(cached);
        } catch (_) {/* fallback fetch */}
      }
    }
    try {
      // On accepte slug OU UUID. On détecte un UUID par sa forme.
      final isUuid = RegExp(
        r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$',
        caseSensitive: false,
      ).hasMatch(slugOrId);

      final caseQuery = _sb
          .from('cas_pratique_cases')
          .select('''
            id, slug, title, year, month, difficulty,
            total_points, estimated_minutes, published_at, status, is_free,
            situation_text, situation_md,
            theme:cas_pratique_themes(id, slug, label, color_hex, icon, sort_order)
          ''')
          .eq('status', 'published');

      final caseRow = await (isUuid
              ? caseQuery.eq('id', slugOrId)
              : caseQuery.eq('slug', slugOrId))
          .maybeSingle();

      if (caseRow == null) {
        throw CasPratiqueException.caseNotFound(slugOrId);
      }

      final caseId = caseRow['id'] as String;

      // Questions ordonnées (sans la rubric — RLS interdit la lecture côté user)
      // On charge la perfect_answer si publiée — utile pour le post-correction.
      final questionRows = await _sb
          .from('cas_pratique_questions')
          .select('''
            id, position, label, hint, max_points, char_min, char_recommended,
            perfect_answer:cas_pratique_perfect_answers(body_md, references_legal)
          ''')
          .eq('case_id', caseId)
          .order('position', ascending: true);

      // Assemble le payload final attendu par CaseDetail.fromJson
      final payload = <String, dynamic>{
        ...caseRow,
        'questions': (questionRows as List).map((q) {
          final m = Map<String, dynamic>.from(q as Map);
          // perfect_answer arrive comme Map ou List selon Postgrest → normalise
          final pa = m['perfect_answer'];
          if (pa is List && pa.isNotEmpty) {
            m['perfect_answer'] = pa.first;
          } else if (pa is Map) {
            // OK déjà
          } else {
            m['perfect_answer'] = null;
          }
          return m;
        }).toList(),
      };

      // 2) Mise en cache
      await _cache.putJson(cacheKey, payload);
      return CaseDetail.fromJson(payload);
    } on CasPratiqueException {
      rethrow;
    } catch (e, st) {
      _rethrow(e, st, context: 'getCaseDetail');
    }
  }

  @override
  Future<void> refreshCache() async {
    _bustCache = true;
    await _cache.clearAll();
    // Le flag est consumé après le prochain appel listThemes/listCases/getCaseDetail
    // (on le reset après ces appels en pratique, mais ici on garde un cycle simple)
    Future.delayed(const Duration(seconds: 2), () {
      _bustCache = false;
    });
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  CODE-016 — ATTEMPTS & ANSWERS
  // ═══════════════════════════════════════════════════════════════════════

  @override
  Future<Attempt> startAttempt(String caseId) async {
    final userId = _requireUserId();
    try {
      // Si une attempt in_progress existe pour ce cas, on la renvoie au lieu d'en
      // créer une nouvelle (reprise de session).
      final existing = await getActiveAttempt(caseId);
      if (existing != null) return existing;

      final inserted = await _sb
          .from('cas_pratique_attempts')
          .insert({
            'user_id': userId,
            'case_id': caseId,
            'status': 'in_progress',
          })
          .select()
          .single();
      return Attempt.fromJson(Map<String, dynamic>.from(inserted));
    } catch (e, st) {
      _rethrow(e, st, context: 'startAttempt');
    }
  }

  @override
  Future<Attempt> getAttempt(String attemptId) async {
    try {
      final row = await _sb
          .from('cas_pratique_attempts')
          .select()
          .eq('id', attemptId)
          .maybeSingle();
      if (row == null) {
        throw const CasPratiqueException(
          code: CasPratiqueErrorCode.attemptNotFound,
          message: 'Tentative introuvable.',
        );
      }
      return Attempt.fromJson(Map<String, dynamic>.from(row));
    } on CasPratiqueException {
      rethrow;
    } catch (e, st) {
      _rethrow(e, st, context: 'getAttempt');
    }
  }

  @override
  Future<Attempt?> getActiveAttempt(String caseId) async {
    final userId = _sb.auth.currentUser?.id;
    if (userId == null) return null;
    try {
      final row = await _sb
          .from('cas_pratique_attempts')
          .select()
          .eq('user_id', userId)
          .eq('case_id', caseId)
          .eq('status', 'in_progress')
          .order('started_at', ascending: false)
          .limit(1)
          .maybeSingle();
      if (row == null) return null;
      return Attempt.fromJson(Map<String, dynamic>.from(row));
    } catch (e, st) {
      _rethrow(e, st, context: 'getActiveAttempt');
    }
  }

  @override
  Future<void> saveDraftAnswer({
    required String attemptId,
    required String caseSlugLegacy,
    required String questionId,
    required int questionIndex,
    required String text,
  }) async {
    final userId = _requireUserId();
    try {
      // Upsert : si une réponse existe déjà pour (attempt, question), on l'écrase.
      await _sb.from('cas_pratique_answers').upsert(
        {
          'user_id': userId,
          'case_id': caseSlugLegacy,
          'attempt_id': attemptId,
          'question_id': questionId,
          'question_index': questionIndex,
          'answer': text,
          'char_count': text.length,
          'status': 'draft',
        },
        onConflict: 'attempt_id,question_id',
        ignoreDuplicates: false,
      );
    } catch (e, st) {
      _rethrow(e, st, context: 'saveDraftAnswer');
    }
  }

  @override
  Future<void> validateAnswer({
    required String attemptId,
    required String caseSlugLegacy,
    required String questionId,
    required int questionIndex,
    required String text,
  }) async {
    final userId = _requireUserId();
    final trimmed = text.replaceAll(' ', ' ').trim();
    if (trimmed.isEmpty) {
      throw const CasPratiqueException(
        code: CasPratiqueErrorCode.answerEmpty,
        message: 'Écris une réponse avant de valider.',
      );
    }
    try {
      await _sb.from('cas_pratique_answers').upsert(
        {
          'user_id': userId,
          'case_id': caseSlugLegacy,
          'attempt_id': attemptId,
          'question_id': questionId,
          'question_index': questionIndex,
          'answer': trimmed,
          'char_count': trimmed.length,
          'status': 'validated',
        },
        onConflict: 'attempt_id,question_id',
        ignoreDuplicates: false,
      );
    } catch (e, st) {
      _rethrow(e, st, context: 'validateAnswer');
    }
  }

  @override
  Future<List<Answer>> listAnswersForAttempt(String attemptId) async {
    try {
      final rows = await _sb
          .from('cas_pratique_answers')
          .select()
          .eq('attempt_id', attemptId)
          .order('question_index', ascending: true);
      return (rows as List)
          .whereType<Map<String, dynamic>>()
          .map(Answer.fromJson)
          .toList();
    } catch (e, st) {
      _rethrow(e, st, context: 'listAnswersForAttempt');
    }
  }

  @override
  Future<Correction> finishAttemptAndCorrect({
    required String attemptId,
    required CaseDetail fullCase,
    required Map<String, String> answersByQuestionId,
    required int timeSpentMs,
  }) =>
      throw UnimplementedError('CODE-028 / CODE-036 — à implémenter');

  @override
  Future<Correction> getCorrection(String attemptId) =>
      throw UnimplementedError('CODE-036 — à implémenter');

  // ═══════════════════════════════════════════════════════════════════════
  //  CODE-042 — APPEALS (createAppeal + listMyAppeals)
  // ═══════════════════════════════════════════════════════════════════════

  @override
  Future<Appeal> createAppeal({
    required String correctionDetailId,
    required String message,
  }) async {
    final userId = _requireUserId();
    final cleaned = message.trim();
    if (cleaned.isEmpty) {
      throw const CasPratiqueException(
        code: CasPratiqueErrorCode.answerEmpty,
        message: 'Écris un message d\'appel avant d\'envoyer.',
      );
    }
    try {
      // Insertion : status est `pending` par défaut côté SQL, on ne le passe
      // pas pour rester sûr que la RLS p_appeals_user_insert l'accepte.
      final inserted = await _sb
          .from('cas_pratique_appeals')
          .insert({
            'correction_detail_id': correctionDetailId,
            'user_id': userId,
            'message': cleaned,
          })
          .select()
          .single();
      return Appeal.fromJson(Map<String, dynamic>.from(inserted));
    } catch (e, st) {
      _rethrow(e, st, context: 'createAppeal');
    }
  }

  @override
  Future<List<Appeal>> listMyAppeals() async {
    final userId = _requireUserId();
    try {
      final rows = await _sb
          .from('cas_pratique_appeals')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);
      return (rows as List)
          .whereType<Map<String, dynamic>>()
          .map(Appeal.fromJson)
          .toList();
    } catch (e, st) {
      _rethrow(e, st, context: 'listMyAppeals');
    }
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  CODE-044 — REALTIME STREAM appeals
  // ═══════════════════════════════════════════════════════════════════════

  @override
  Stream<Appeal> watchMyAppeals() {
    final userId = _requireUserId();
    final controller = StreamController<Appeal>.broadcast();

    // Canal nommé pour garantir l'unicité par user → évite la double-souscription
    // si la stream est consommée plusieurs fois en parallèle.
    final channelName = 'cp_appeals_$userId';
    final channel = _sb.channel(channelName);

    void emit(Map<String, dynamic>? raw) {
      if (raw == null || raw.isEmpty) return;
      try {
        controller.add(Appeal.fromJson(Map<String, dynamic>.from(raw)));
      } catch (e) {
        if (kDebugMode) {
          debugPrint('[CasPratiqueRepo] appeal payload decode failed: $e');
        }
      }
    }

    channel.onPostgresChanges(
      event: PostgresChangeEvent.insert,
      schema: 'public',
      table: 'cas_pratique_appeals',
      filter: PostgresChangeFilter(
        type: PostgresChangeFilterType.eq,
        column: 'user_id',
        value: userId,
      ),
      callback: (payload) => emit(payload.newRecord),
    );

    channel.onPostgresChanges(
      event: PostgresChangeEvent.update,
      schema: 'public',
      table: 'cas_pratique_appeals',
      filter: PostgresChangeFilter(
        type: PostgresChangeFilterType.eq,
        column: 'user_id',
        value: userId,
      ),
      callback: (payload) => emit(payload.newRecord),
    );

    channel.subscribe();

    controller.onCancel = () async {
      try {
        await _sb.removeChannel(channel);
      } catch (_) {/* ignore */}
    };

    return controller.stream;
  }

  @override
  Future<UserGlobalProgress> getMyProgress() =>
      throw UnimplementedError('CODE-016 / CODE-018 — à implémenter');
}

/// Agrégateur interne pour `_fetchProgressForCases`.
class _AggProgress {
  double? lastPercent;
  double? bestPercent;
  DateTime? lastFinishedAt;
  int count;

  _AggProgress(double? pct, DateTime? finishedAt, this.count)
      : lastPercent = pct,
        bestPercent = pct,
        lastFinishedAt = finishedAt;

  _AggProgress add(double? pct, DateTime? finishedAt) {
    count++;
    if (pct != null) {
      if (bestPercent == null || pct > bestPercent!) bestPercent = pct;
    }
    if (finishedAt != null) {
      if (lastFinishedAt == null || finishedAt.isAfter(lastFinishedAt!)) {
        lastFinishedAt = finishedAt;
        lastPercent = pct ?? lastPercent;
      }
    }
    return this;
  }
}
