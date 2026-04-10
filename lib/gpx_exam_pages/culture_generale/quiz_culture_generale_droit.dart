// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:copiqpolice/ui/app_notifier.dart'
    show AppNotifier, AppSettingsController;

// Utilitaire alpha (évite withOpacity déprécié)
Color _opa(Color c, double a) => c.withValues(alpha: a);

String _fmtInt(int v) {
  final s = v.toString();
  final b = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    final idxFromEnd = s.length - i;
    b.write(s[i]);
    if (idxFromEnd > 1 && idxFromEnd % 3 == 1) {
      b.write(' ');
    }
  }
  return b.toString();
}

class _LoadingOverlay extends StatelessWidget {
  final bool isDark;
  final int total;
  final int animated;
  final int loaded;
  final int readyTarget;
  final VoidCallback onRetry;

  const _LoadingOverlay({
    required this.isDark,
    required this.total,
    required this.animated,
    required this.loaded,
    required this.readyTarget,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? Colors.black : _Brand.bgLight;
    final card = isDark ? _opa(Colors.white, .08) : _Brand.white;
    final text = isDark ? _opa(Colors.white, .92) : _Brand.textDark;
    final sub = isDark ? _opa(Colors.white, .70) : _opa(_Brand.textDark, .72);

    final safeTotal = total <= 0 ? null : total;
    final shownTotal = safeTotal == null ? '…' : _fmtInt(safeTotal);
    final shownAnimated = safeTotal == null ? '…' : _fmtInt(animated);

    final readyPct = safeTotal == null || readyTarget <= 0
        ? null
        : (loaded / readyTarget).clamp(0.0, 1.0);

    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(color: _opa(bg, .62)),
            ),
          ),
          Center(
            child: Container(
              width: 360,
              padding: const EdgeInsets.all(18),
              margin: const EdgeInsets.symmetric(horizontal: 22),
              decoration: BoxDecoration(
                color: card,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: isDark
                      ? _opa(Colors.white, .10)
                      : _opa(Colors.black, .06),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? .35 : .08),
                    blurRadius: 30,
                    offset: const Offset(0, 14),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 4),
                  const CircularProgressIndicator(),
                  const SizedBox(height: 14),
                  Text(
                    'Chargement des questions…',
                    textAlign: TextAlign.center,
                    style: _Brand.option(context).copyWith(color: text),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    safeTotal == null
                        ? 'Connexion à la base…'
                        : 'Questions disponibles : $shownTotal',
                    textAlign: TextAlign.center,
                    style: _Brand.small(context).copyWith(color: sub),
                  ),
                  const SizedBox(height: 10),
                  if (safeTotal != null)
                    Column(
                      children: [
                        Text(
                          'Indexation : $shownAnimated / $shownTotal',
                          textAlign: TextAlign.center,
                          style: _Brand.small(context).copyWith(color: sub),
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(999),
                          child: LinearProgressIndicator(
                            value: readyPct,
                            minHeight: 8,
                            backgroundColor: isDark
                                ? _opa(Colors.white, .12)
                                : _opa(Colors.black, .06),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Questions prêtes : ${_fmtInt(loaded)} / ${_fmtInt(readyTarget)}',
                          textAlign: TextAlign.center,
                          style: _Brand.small(context).copyWith(color: sub),
                        ),
                      ],
                    ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: onRetry,
                      child: Text(
                        'Réessayer',
                        style: _Brand.option(context).copyWith(
                          color: isDark ? _Brand.white : _Brand.accent,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// THEME
// ============================================================================
class _Brand {
  static const textDark = Color(0xFF212529);
  static const bgLight = Color(0xFFF5F6F7);
  static const white = Color(0xFFFFFFFF);

  static const accent = Color(0xFF6C63FF);
  static const good = Color(0xFF27C93F);
  static const bad = Color(0xFFFF3B30);

  static TextStyle h1(BuildContext c) => const TextStyle(
    fontFamily: 'InstrumentSans',
    fontWeight: FontWeight.w800,
    fontSize: 28,
    height: 1.25,
    letterSpacing: .2,
    decoration: TextDecoration.none,
  );

  static TextStyle option(BuildContext c) => const TextStyle(
    fontFamily: 'InstrumentSans',
    fontWeight: FontWeight.w700,
    fontSize: 18,
    height: 1.2,
    decoration: TextDecoration.none,
  );

  static TextStyle small(BuildContext c) => const TextStyle(
    fontFamily: 'InstrumentSans',
    fontWeight: FontWeight.w700,
    fontSize: 12,
    letterSpacing: .2,
    decoration: TextDecoration.none,
  );

  static Color radioTrack(BuildContext c) =>
      Theme.of(c).brightness == Brightness.dark
      ? _opa(Colors.white, .18)
      : const Color(0xFFE7E9ED);
}

// ============================================================================
// DATA MODEL
// ============================================================================
class QuizQuestion {
  final int id; // id unique en BDD
  final String module; //
  final String category; //
  final String question;
  final List<String> options;
  final String answer;
  final String explanation;
  final String difficulty; // "Facile" | "Moyenne" | "Difficile"
  final String? sub;

  const QuizQuestion({
    required this.id,
    required this.module,
    required this.category,
    required this.question,
    required this.options,
    required this.answer,
    required this.explanation,
    required this.difficulty,
    this.sub,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    final rawOptions = (json['options'] as List?) ?? const [];
    final answer = (json['answer'] ?? '') as String;

    // Normalise options: trim, remove empty/null strings, remove duplicates.
    final seen = <String>{};
    final opts = <String>[];
    for (final e in rawOptions) {
      final s = e.toString().trim();
      if (s.isEmpty) continue;
      if (s.toLowerCase() == 'null') continue;
      if (seen.add(s)) opts.add(s);
    }

    // S'assure que la bonne réponse est présente dans les options (sinon ajout).
    final ans = answer.trim();
    if (ans.isNotEmpty && !seen.contains(ans)) {
      opts.add(ans);
    }

    // Supabase renvoie les bigint en int (Dart 64-bit). Si un jour ça arrive en String, on fallback.
    final dynamic rawId = json['id'];
    final int id = rawId is int
        ? rawId
        : int.tryParse(rawId?.toString() ?? '') ?? 0;

    return QuizQuestion(
      id: id,
      module: (json['module'] ?? '') as String,
      category: (json['category'] ?? '') as String,
      question: (json['question'] ?? '') as String,
      options: opts,
      answer: answer,
      explanation: (json['explanation'] ?? '') as String,
      difficulty: (json['difficulty'] ?? '') as String,
      sub: json['sub'] as String?,
    );
  }
}

// ============================================================================
// SUPABASE REPO (lazy-load / pagination / 1M+ friendly)
// ============================================================================

class QuizQuestionsRepository {
  final SupabaseClient sb;
  QuizQuestionsRepository(this.sb);

  static const _fields =
      'id,module,category,question,options,answer,explanation,difficulty,sub,rand_key';

  /// Récupère un lot de questions "pseudo-aléatoires" SANS ORDER BY random()
  /// pour éviter les timeouts sur de grosses tables.
  ///
  /// Principe:
  /// - on génère un seed [0..1[
  /// - on prend les lignes avec rand_key >= seed triées par rand_key
  /// - si on n'a pas assez, on "wrap" avec rand_key < seed
  ///
  /// ✅ Rapide si un index existe sur (category, difficulty, rand_key)
  Future<List<QuizQuestion>> fetchRandomSet({
    required String category,
    String? difficulty,
    required int limit,
    double? seed,
  }) async {
    final s = seed ?? math.Random().nextDouble();

    dynamic _base() {
      var q = sb
          .from('quiz_questions')
          .select(_fields)
          .eq('category', category);

      if (difficulty != null) {
        q = q.eq('difficulty', difficulty);
      }
      return q;
    }

    // 1) rand_key >= seed
    final first = await _base()
        .gte('rand_key', s)
        .order('rand_key', ascending: true)
        .limit(limit);

    final firstList = (first is List)
        ? first.cast<Map<String, dynamic>>()
        : <Map<String, dynamic>>[];
    if (firstList.length >= limit) {
      return firstList.map(QuizQuestion.fromJson).toList();
    }

    // 2) wrap rand_key < seed
    final remaining = limit - firstList.length;
    final second = await _base()
        .lt('rand_key', s)
        .order('rand_key', ascending: true)
        .limit(remaining);

    final secondList = (second is List)
        ? second.cast<Map<String, dynamic>>()
        : <Map<String, dynamic>>[];

    final combined = <Map<String, dynamic>>[...firstList, ...secondList];

    return combined.map(QuizQuestion.fromJson).toList();
  }

  /// Fetch paginé (batch) — conservé si besoin plus tard.
  Future<List<QuizQuestion>> fetchBatch({
    required String category,
    String? difficulty,
    required int fromInclusive,
    required int toInclusive,
  }) async {
    var query = sb
        .from('quiz_questions')
        .select(
          'id,module,category,question,options,answer,explanation,difficulty,sub',
        )
        .eq('category', category);

    if (difficulty != null) {
      query = query.eq('difficulty', difficulty);
    }

    final data = await query.range(fromInclusive, toInclusive);

    if (data is! List) return const [];
    return data
        .cast<Map<String, dynamic>>()
        .map(QuizQuestion.fromJson)
        .toList();
  }
}

// ============================================================================
// PAGE
// ============================================================================
class QuizCultureGeneraleDroit extends StatefulWidget {
  static const String routeName = '/gpx_exam/concours/culture_generale_droit';

  final String uid;
  final String email;

  const QuizCultureGeneraleDroit({
    super.key,
    required this.uid,
    required this.email,
  });

  @override
  State<QuizCultureGeneraleDroit> createState() =>
      _QuizCultureGeneraleDroitState();
}

class _QuizCultureGeneraleDroitState extends State<QuizCultureGeneraleDroit>
    with TickerProviderStateMixin {
  // ===========================================================================
  // CONFIG QUIZ
  // ===========================================================================
  static const String _categoryNameDb = 'Droit';
  static const int _pageSize = 500;

  SupabaseClient get _sb => Supabase.instance.client;
  late final QuizQuestionsRepository _repo = QuizQuestionsRepository(_sb);

  late final PageController _page;
  late math.Random _rng;

  // Questions cache: index -> question
  final Map<int, QuizQuestion> _cache = {};
  final Map<int, List<String>> _optsCache = {};

  // Answers (map) to avoid allocating 1M entries
  final Map<int, String> _answers = {};

  // Progress / state
  bool _showSplash = true;
  bool _loading = false;
  bool _hasQuiz = false;

  int _index = 0;
  int _score = 0;
  int _total = 0;

  // Loading UX counters
  int _loadedCount = 0;
  int _animatedCount = 0;
  Timer? _counterTimer;

  int _startOffset = 0;
  int _loadedUntilVirtualIndex = -1;

  final Set<int> _pendingEnsure = <int>{};
  final Map<int, Future<void>> _inFlightBatches = <int, Future<void>>{};

  // Sélection & validation
  String? _currentChoice;
  bool _validated = false;
  bool _isCorrect = false;

  // Splash / difficulté
  String? _selectedDifficulty; // "Facile" | "Moyenne" | "Difficile" | null
  bool _mixMode = false; // true si clic sur "Aléatoire"

  // Historique
  int? _historyRowId;
  bool _historyFinished = false; // ✅ évite double finish/abandon

  // Audio (✓ / ✕)
  late final AudioPlayer _goodSfx;
  late final AudioPlayer _badSfx;

  // Splash animation
  late final AnimationController _splashCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 800),
  )..forward();
  late final Animation<double> _splashFade = CurvedAnimation(
    parent: _splashCtrl,
    curve: Curves.easeOutCubic,
  );

  // Feedback animation
  late final AnimationController _pulseCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
  );

  // ===========================================================================
  // INIT / DISPOSE
  // ===========================================================================
  @override
  void initState() {
    super.initState();

    // ✅ Edge-to-edge = pas de bandes noires système en haut/bas
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    _page = PageController(initialPage: 0);
    _rng = math.Random(DateTime.now().millisecondsSinceEpoch);

    _goodSfx = AudioPlayer()..setReleaseMode(ReleaseMode.stop);
    _badSfx = AudioPlayer()..setReleaseMode(ReleaseMode.stop);
    unawaited(_goodSfx.setSource(AssetSource('sfx/correct_answer.mp3')));
    unawaited(_badSfx.setSource(AssetSource('sfx/wrong_answer.mp3')));

    // ❌ IMPORTANT : PAS D’HISTORIQUE ICI
    // L’historique se crée uniquement quand l’utilisateur appuie sur "Commencer".
  }

  @override
  void dispose() {
    _counterTimer?.cancel();
    _page.dispose();
    _splashCtrl.dispose();
    _pulseCtrl.dispose();
    _goodSfx.dispose();
    _badSfx.dispose();
    super.dispose();
  }

  // ===========================================================================
  // SAFE SETSTATE
  // ===========================================================================
  void _safeSetState(VoidCallback fn) {
    if (!mounted) return;
    final phase = SchedulerBinding.instance.schedulerPhase;
    final shouldDefer =
        phase == SchedulerPhase.persistentCallbacks ||
        phase == SchedulerPhase.transientCallbacks;
    if (shouldDefer) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        setState(fn);
      });
    } else {
      setState(fn);
    }
  }

  // ===========================================================================
  // DB HELPERS
  // ===========================================================================
  String? get _difficultyFilter => _mixMode ? null : _selectedDifficulty;

  int _quizIndexToDbOffset(int quizIndex) {
    if (_total <= 0) return 0;
    return (_startOffset + quizIndex) % _total;
  }

  Future<void> _ensureBatchForQuizIndex(int quizIndex) async {
    if (!_hasQuiz) return;
    if (_total <= 0) return;
    if (quizIndex <= _loadedUntilVirtualIndex) return;

    final batchStartQuiz = (quizIndex ~/ _pageSize) * _pageSize;
    final batchEndQuiz = math.min(batchStartQuiz + _pageSize - 1, _total - 1);

    final inFlight = _inFlightBatches[batchStartQuiz];
    if (inFlight != null) {
      await inFlight;
      return;
    }

    final startDb = _quizIndexToDbOffset(batchStartQuiz);
    final endDb = _quizIndexToDbOffset(batchEndQuiz);

    Future<void> doFetch() async {
      _safeSetState(() => _loading = true);

      const maxAttempts = 3;
      final delays = <Duration>[
        const Duration(milliseconds: 350),
        const Duration(milliseconds: 900),
      ];

      for (int attempt = 1; attempt <= maxAttempts; attempt++) {
        try {
          if (startDb <= endDb) {
            final list = await _repo.fetchBatch(
              category: _categoryNameDb,
              difficulty: _difficultyFilter,
              fromInclusive: startDb,
              toInclusive: endDb,
            );
            _mapBatchToCache(batchStartQuiz: batchStartQuiz, questions: list);
          } else {
            final seg1 = await _repo.fetchBatch(
              category: _categoryNameDb,
              difficulty: _difficultyFilter,
              fromInclusive: startDb,
              toInclusive: _total - 1,
            );
            final seg2 = await _repo.fetchBatch(
              category: _categoryNameDb,
              difficulty: _difficultyFilter,
              fromInclusive: 0,
              toInclusive: endDb,
            );
            final merged = <QuizQuestion>[...seg1, ...seg2];
            _mapBatchToCache(batchStartQuiz: batchStartQuiz, questions: merged);
          }

          _loadedUntilVirtualIndex = batchEndQuiz;
          return;
        } catch (e) {
          debugPrint('❌ fetchBatch failed (attempt $attempt/$maxAttempts): $e');
          if (attempt < maxAttempts) {
            await Future<void>.delayed(
              delays[math.min(attempt - 1, delays.length - 1)],
            );
            continue;
          }
          if (mounted) {
            AppNotifier.error(
              context,
              title: 'Chargement en cours…',
              message:
                  "La base répond lentement. Attends quelques secondes, ou réessaie.",
            );
          }
        }
      }
    }

    final f = doFetch().whenComplete(() {
      _inFlightBatches.remove(batchStartQuiz);
      _safeSetState(() => _loading = false);
    });

    _inFlightBatches[batchStartQuiz] = f;
    await f;
  }

  void _mapBatchToCache({
    required int batchStartQuiz,
    required List<QuizQuestion> questions,
  }) {
    final shuffled = List<QuizQuestion>.from(questions);
    shuffled.shuffle(_rng);

    for (int i = 0; i < shuffled.length; i++) {
      final quizIdx = batchStartQuiz + i;
      if (quizIdx >= _total) break;

      final q = shuffled[i];
      final isNew = !_cache.containsKey(quizIdx);
      _cache[quizIdx] = q;
      if (isNew) {
        _loadedCount = math.min(_total, _loadedCount + 1);
      }

      final opts = List<String>.from(q.options);
      opts.shuffle(_rng);
      _optsCache[quizIdx] = opts;
    }
  }

  // ===========================================================================
  // PREFETCH
  // ===========================================================================
  void _requestEnsure(int quizIndex) {
    if (!_hasQuiz || _total <= 0) return;
    if (_pendingEnsure.contains(quizIndex)) return;
    _pendingEnsure.add(quizIndex);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pendingEnsure.remove(quizIndex);
      unawaited(_ensureBatchForQuizIndex(quizIndex));
    });
  }

  // ===========================================================================
  // QUIZ FLOW
  // ===========================================================================
  Future<void> _startQuiz({bool mix = false}) async {
    _mixMode = mix;

    if (!mix && _selectedDifficulty == null) {
      AppNotifier.info(
        context,
        title: 'Choisis un niveau',
        message: 'Sélectionne une difficulté pour commencer.',
      );
      return;
    }

    setState(() {
      _loading = true;
      _hasQuiz = false;

      _cache.clear();
      _optsCache.clear();
      _answers.clear();

      _index = 0;
      _score = 0;

      _validated = false;
      _isCorrect = false;
      _currentChoice = null;

      _loadedCount = 0;
      _animatedCount = 0;
      _total = 0;

      // ✅ reset historique
      _historyRowId = null;
      _historyFinished = false;
    });

    try {
      const int quizLength = 50;
      final seed = _rng.nextDouble();

      final questions = await _repo.fetchRandomSet(
        category: _categoryNameDb,
        difficulty: _difficultyFilter,
        limit: quizLength,
        seed: seed,
      );

      if (questions.isEmpty) {
        setState(() {
          _total = 0;
          _hasQuiz = false;
          _loading = false;
        });
        AppNotifier.warning(
          context,
          title: 'Aucune question',
          message: 'Aucune question trouvée pour ce filtre.',
        );
        return;
      }

      // ✅ on a les questions -> on connaît le total
      for (var i = 0; i < questions.length; i++) {
        final q = questions[i];
        _cache[i] = q;
        final opts = List<String>.from(q.options);
        opts.shuffle(_rng);
        _optsCache[i] = opts;
      }

      setState(() {
        _total = questions.length;
        _loadedCount = questions.length;
        _animatedCount = questions.length;
        _hasQuiz = true;
        _showSplash = false;
        _loading = false;
      });

      // ✅ CRÉE L’HISTORIQUE ICI (comme ta page grammaire)
      await _createHistoryOnStart();
    } catch (e) {
      debugPrint('❌ startQuiz failed: $e');
      setState(() => _loading = false);
      AppNotifier.error(
        context,
        title: 'Erreur',
        message: 'Impossible de démarrer le quiz.',
      );
    }
  }

  void _select(String v) {
    if (_validated) return;
    setState(() => _currentChoice = v);
  }

  Future<void> _validate() async {
    if (_currentChoice == null) {
      AppNotifier.error(
        context,
        title: 'Réponse requise',
        message: 'Sélectionne une option pour valider.',
      );
      return;
    }

    final q = _cache[_index];
    if (q == null) {
      AppNotifier.info(
        context,
        title: 'Chargement…',
        message: 'La question arrive, réessaie dans 1 seconde.',
      );
      return;
    }

    final ok = _currentChoice == q.answer;

    setState(() {
      _validated = true;
      _isCorrect = ok;
      _answers[_index] = _currentChoice!;
      if (ok) _score++;
    });

    _pulseCtrl
      ..reset()
      ..forward();

    unawaited(_playAnswerSfx(ok));

    unawaited(
      _saveAnswer(
        question: q.question,
        userAnswer: _currentChoice!,
        correctAnswer: q.answer,
        isCorrect: ok,
        difficulty: q.difficulty,
      ),
    );
  }

  Future<void> _next() async {
    if (!_validated) return;

    if (_index < _total - 1) {
      final nextIndex = _index + 1;

      setState(() {
        _index = nextIndex;
        _validated = false;
        _isCorrect = false;
        _currentChoice = null;
      });

      if (mounted && _page.hasClients) {
        await _page.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
        );
      }
    } else {
      // ✅ fin “naturelle”
      final answered = _answers.length;
      final totalForDialog = answered <= 0 ? 1 : answered;

      await _updateHistoryOnFinish();
      if (!mounted) return;
      _openResultDialog(_score, totalForDialog);
    }
  }

  void _restart() {
    setState(() {
      _index = 0;
      _score = 0;
      _validated = false;
      _isCorrect = false;
      _currentChoice = null;
      _showSplash = true;
      _selectedDifficulty = null;
      _mixMode = false;
      _hasQuiz = false;
      _total = 0;
      _cache.clear();
      _optsCache.clear();
      _answers.clear();

      _historyRowId = null;
      _historyFinished = false;
    });
    _page.jumpToPage(0);
  }

  Future<void> _endQuizNow() async {
    if (!_hasQuiz) return;

    final int answered = _answers.length;
    final int totalForScore = answered <= 0 ? 1 : answered;

    await _updateHistoryOnFinish();
    if (!mounted) return;

    _openResultDialog(_score, totalForScore);
  }

  // ===========================================================================
  // SUPABASE HISTORY / ANSWERS
  // ===========================================================================
  Future<void> _createHistoryOnStart() async {
    if (_historyRowId != null) {
      debugPrint('⚠️ quiz_history already created: id=$_historyRowId');
      return;
    }

    try {
      final nowUtc = DateTime.now().toUtc().toIso8601String();

      final payload = <String, dynamic>{
        'uid': widget.uid,
        'email': widget.email,
        'module_name': 'Culture générale',
        'quiz_name': 'Quiz culture générale droit',

        // 🔥 LIVE : 0 / 50 affiché immédiatement
        'score': 0,
        'correct_count': 0,
        'total_questions': 500,

        'mode': 'exam',
        'track': 'gpx',

        'started_at': nowUtc,

        // ⚠️ si ta colonne finished_at est NOT NULL → obligé de mettre une valeur
        'finished_at': nowUtc,

        // doit être NULL tant que pas terminé
        'completed_at': null,
      };

      final res = await _sb
          .from('quiz_history')
          .insert(payload)
          .select('id')
          .single();

      _historyRowId = (res['id'] as num).toInt();
      _historyFinished = false;

      debugPrint('✅ quiz_history START created id=$_historyRowId');
    } catch (e, st) {
      debugPrint('❌ quiz_history (start) insert failed: $e');
      debugPrint('STACK: $st');
    }
  }

  Future<void> _updateHistoryOnFinish() async {
    if (_historyFinished) return; // ✅ anti double
    if (_historyRowId == null) return;

    try {
      final int answered = _answers.length;
      final int totalForScore = answered <= 0 ? 1 : answered;
      final int percent = ((_score / totalForScore) * 100).round();

      final nowUtc = DateTime.now().toUtc().toIso8601String();

      await _sb
          .from('quiz_history')
          .update({
            'score': percent,
            'correct_count': _score,
            'total_questions':
                answered, // 🔥 comme grammaire: questions traitées
            'finished_at': nowUtc,
            'completed_at': nowUtc,

            'mode': 'exam',
            'track': 'gpx',
          })
          .eq('id', _historyRowId!)
          .eq('uid', widget.uid);

      _historyFinished = true;

      debugPrint('✅ quiz_history (finish) updated id=$_historyRowId');
    } catch (e) {
      debugPrint('❌ quiz_history (finish) update failed: $e');
    }
  }

  Future<void> _updateHistoryOnAbandon() async {
    if (_historyFinished) return;
    if (_historyRowId == null) return;

    try {
      final nowUtc = DateTime.now().toUtc().toIso8601String();

      await _sb
          .from('quiz_history')
          .update({
            'score': 0,
            'correct_count': 0,
            'total_questions': 0, // ✅ ton repère 0/0
            'finished_at': nowUtc,
            'completed_at': nowUtc,

            'mode': 'exam',
            'track': 'gpx',
          })
          .eq('id', _historyRowId!)
          .eq('uid', widget.uid);

      _historyFinished = true;
      debugPrint('✅ quiz_history (abandon) updated id=$_historyRowId');
    } catch (e) {
      debugPrint('❌ quiz_history (abandon) update failed: $e');
    }
  }

  Future<void> _saveAnswer({
    required String question,
    required String userAnswer,
    required String correctAnswer,
    required bool isCorrect,
    required String difficulty,
  }) async {
    try {
      final payload = <String, dynamic>{
        'user_uid': widget.uid,
        'email': widget.email,
        'question': question,
        'user_answer': userAnswer,
        'correct_answer': correctAnswer,
        'is_correct': isCorrect,
        'score': _score,
        'difficulty': difficulty,
        'created_at': DateTime.now().toUtc().toIso8601String(),

        // 🔥 si tu ajoutes cette colonne dans la table :
        // 'history_id': _historyRowId,
      };

      await _sb.from('quiz_culture_generale_droit_pages').insert(payload);
    } catch (e, st) {
      debugPrint('❌ quiz_culture_generale_droit_pages insert failed: $e');
      debugPrint('STACK: $st');
    }
  }

  Future<void> _playAnswerSfx(bool good) async {
    try {
      HapticFeedback.mediumImpact();
      final AudioPlayer p = good ? _goodSfx : _badSfx;
      await p.stop();
      await p.setSource(
        AssetSource(good ? 'sfx/correct_answer.mp3' : 'sfx/wrong_answer.mp3'),
      );
      await p.resume();
    } catch (_) {}
  }

  // ===========================================================================
  // REPORT (signalement question)
  // ===========================================================================

  QuizQuestion? get _currentQuestion => _cache[_index];

  Future<void> _insertReportCultureGenerale({
    required QuizQuestion q,
    required String reportType, // 'bug' | 'probleme' | 'autre'
    required String message,
  }) async {
    final payload = <String, dynamic>{
      'created_at': DateTime.now().toUtc().toIso8601String(),
      'user_uid': widget.uid,
      'email': widget.email,
      'question_id': q.id,
      'module': q.module,
      'category': q.category,
      'difficulty': q.difficulty,
      'question': q.question,
      'options': q.options,
      'answer': q.answer,
      'explanation': q.explanation,
      'sub': q.sub,
      'report_type': reportType,
      'message': message,
      'page': QuizCultureGeneraleDroit.routeName,
      'status': 'new',
    };

    await _sb.from('report_culture_generale').insert(payload);
  }

  Future<void> _openReportDialog({required bool isDark}) async {
    final q = _currentQuestion;
    if (!_hasQuiz || q == null) {
      if (!mounted) return;
      AppNotifier.warning(
        context,
        title: 'Question indisponible',
        message: 'Question indisponible pour le moment.',
      );
      return;
    }

    final textCol = isDark ? _opa(Colors.white, .92) : _Brand.textDark;
    final subCol = isDark
        ? _opa(Colors.white, .72)
        : _opa(_Brand.textDark, .72);
    final card = isDark ? _opa(Colors.white, .08) : _Brand.white;
    final border = isDark ? _opa(Colors.white, .12) : _opa(Colors.black, .08);

    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        String? type; // bug/probleme/autre
        final msgCtrl = TextEditingController();
        bool sending = false;
        bool sent = false;

        Future<void> onSend(StateSetter setState) async {
          final t = type;
          final m = msgCtrl.text.trim();
          if (t == null) {
            AppNotifier.warning(
              context,
              title: 'Type de signalement requis',
              message: 'Choisis un type de signalement.',
            );
            return;
          }
          if (m.isEmpty) {
            AppNotifier.warning(
              context,
              title: 'Description requise',
              message: 'Explique rapidement le problème.',
            );
            return;
          }

          setState(() => sending = true);
          try {
            await _insertReportCultureGenerale(q: q, reportType: t, message: m);
            setState(() {
              sending = false;
              sent = true;
            });
            HapticFeedback.lightImpact();
            await Future<void>.delayed(const Duration(milliseconds: 700));
            if (Navigator.of(ctx).canPop()) Navigator.of(ctx).pop();
            if (!mounted) return;
            AppNotifier.success(
              context,
              title: 'Signalement envoyé',
              message: 'Merci !',
            );
          } catch (e) {
            setState(() => sending = false);
            debugPrint('❌ report insert failed: $e');
            if (!mounted) return;
            AppNotifier.error(
              context,
              title: 'Erreur lors de l\'envoi',
              message: 'Réessaie plus tard.',
            );
          }
        }

        InputDecoration deco(String label, {String? hint}) => InputDecoration(
          labelText: label,
          hintText: hint,
          labelStyle: TextStyle(color: subCol, fontWeight: FontWeight.w700),
          hintStyle: TextStyle(color: subCol),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: isDark ? _Brand.white : _Brand.accent,
            ),
          ),
          filled: true,
          fillColor: isDark ? _opa(Colors.white, .06) : _opa(Colors.black, .03),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 12,
          ),
        );

        return StatefulBuilder(
          builder: (ctx, setState) {
            return Dialog(
              backgroundColor: card,
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 18,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: border),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.flag_rounded,
                          color: isDark ? _Brand.white : _Brand.accent,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Signaler cette question',
                            style: _Brand.option(
                              context,
                            ).copyWith(color: textCol),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(ctx).pop(),
                          icon: Icon(Icons.close_rounded, color: subCol),
                          tooltip: 'Fermer',
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Champs pré-remplis (read-only)
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            initialValue: q.id.toString(),
                            readOnly: true,
                            decoration: deco('ID question'),
                            style: TextStyle(
                              color: textCol,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            initialValue: q.difficulty,
                            readOnly: true,
                            decoration: deco('Difficulté'),
                            style: TextStyle(
                              color: textCol,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      initialValue: q.category,
                      readOnly: true,
                      decoration: deco('Catégorie'),
                      style: TextStyle(
                        color: textCol,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),

                    DropdownButtonFormField<String>(
                      value: type,
                      decoration: deco('Type de signalement', hint: 'Choisir…'),
                      dropdownColor: card,
                      iconEnabledColor: subCol,
                      items: const [
                        DropdownMenuItem(value: 'bug', child: Text('Bug')),
                        DropdownMenuItem(
                          value: 'probleme',
                          child: Text('Problème'),
                        ),
                        DropdownMenuItem(value: 'autre', child: Text('Autre')),
                      ],
                      onChanged: (v) => setState(() => type = v),
                    ),

                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 180),
                      child: (type == null)
                          ? const SizedBox(height: 0, key: ValueKey('no_msg'))
                          : Padding(
                              key: const ValueKey('msg'),
                              padding: const EdgeInsets.only(top: 10),
                              child: TextField(
                                controller: msgCtrl,
                                minLines: 3,
                                maxLines: 6,
                                decoration: deco(
                                  'Explique le souci',
                                  hint:
                                      'Ex: faute, réponse incorrecte, doublon…',
                                ),
                                style: TextStyle(
                                  color: textCol,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                    ),

                    const SizedBox(height: 14),
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: sending || sent
                            ? null
                            : () => onSend(setState),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDark
                              ? _Brand.white
                              : _Brand.accent,
                          foregroundColor: isDark ? Colors.black : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: sent
                              ? const Icon(
                                  Icons.check_rounded,
                                  key: ValueKey('ok'),
                                )
                              : sending
                              ? const SizedBox(
                                  key: ValueKey('loading'),
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  'Envoyer',
                                  key: const ValueKey('send'),
                                  style: _Brand.option(context).copyWith(
                                    color: isDark ? Colors.black : Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ===========================================================================
  // UI
  // ===========================================================================
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppSettingsController.I.themeMode,
      builder: (_, mode, __) {
        final sysDark = Theme.of(context).brightness == Brightness.dark;
        final isDark = switch (mode) {
          ThemeMode.dark => true,
          ThemeMode.light => false,
          ThemeMode.system => sysDark,
        };

        final bg = isDark ? Colors.black : _Brand.bgLight;
        final textCol = isDark ? Colors.white : _Brand.textDark;
        final base = isDark ? ThemeData.dark() : ThemeData.light();

        final overlay = SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarDividerColor: Colors.transparent,
          statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
          systemNavigationBarIconBrightness: isDark
              ? Brightness.light
              : Brightness.dark,
          statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
        );

        const double kButtonHeight = 56;
        const double kButtonVPad = 16;
        final double bottomBarReserved = kButtonHeight + kButtonVPad + 8;

        final totalSafe = _total <= 0 ? 1 : _total;
        final double topInset =
            MediaQuery.of(context).padding.top + kToolbarHeight;

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: overlay,
          child: Theme(
            data: base.copyWith(
              scaffoldBackgroundColor: bg,
              textTheme: base.textTheme.apply(
                displayColor: textCol,
                bodyColor: textCol,
              ),
              colorScheme: base.colorScheme.copyWith(
                primary: _Brand.accent,
                surface: bg,
              ),
            ),
            child: WillPopScope(
              onWillPop: () async {
                if (_hasQuiz && !_historyFinished) {
                  await _updateHistoryOnAbandon();
                }
                return true;
              },
              child: Scaffold(
                backgroundColor: bg,
                extendBody: true,
                extendBodyBehindAppBar: true,
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  scrolledUnderElevation: 0,
                  leading: IconButton(
                    icon: Icon(Icons.close_rounded, color: textCol),
                    onPressed: () async {
                      if (_hasQuiz && !_historyFinished) {
                        await _updateHistoryOnAbandon();
                      }
                      if (mounted) Navigator.maybePop(context);
                    },
                    tooltip: 'Fermer',
                  ),
                  actions: [
                    IconButton(
                      tooltip: 'Signaler',
                      onPressed: _hasQuiz
                          ? () => _openReportDialog(isDark: isDark)
                          : null,
                      icon: Icon(
                        Icons.flag_outlined,
                        color: _hasQuiz ? textCol : _opa(textCol, .35),
                      ),
                    ),
                    const SizedBox(width: 6),
                  ],
                ),

                // ✅ ton UI inchangé dessous
                body: SafeArea(
                  top: false,
                  child: LayoutBuilder(
                    builder: (context, viewport) {
                      final double animSize = (viewport.maxWidth * 0.56).clamp(
                        140.0,
                        240.0,
                      );

                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Column(
                            children: [
                              SizedBox(height: topInset),

                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  20,
                                  0,
                                  20,
                                  8,
                                ),
                                child: _TopProgressBar(
                                  index: _hasQuiz ? _index : 0,
                                  total: totalSafe,
                                  accent: isDark ? _Brand.white : _Brand.accent,
                                ),
                              ),
                              Expanded(
                                child: PageView.builder(
                                  controller: _page,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: _hasQuiz ? totalSafe : 1,
                                  itemBuilder: (_, i) {
                                    if (!_hasQuiz) {
                                      return Center(
                                        child: _loading
                                            ? const CircularProgressIndicator()
                                            : const Text(
                                                'Sélectionne une difficulté pour commencer.',
                                              ),
                                      );
                                    }

                                    final q = _cache[i];
                                    final opts = _optsCache[i];

                                    final bool animVisible =
                                        i == _index && _validated;

                                    final double bottomInsetForThisPage =
                                        (animVisible ? animSize : 0) +
                                        bottomBarReserved;

                                    if (q == null || opts == null) {
                                      _requestEnsure(i);
                                      return Center(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const CircularProgressIndicator(),
                                            const SizedBox(height: 12),
                                            Text(
                                              'Chargement des questions…',
                                              style: TextStyle(
                                                color: textCol.withAlpha(200),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }

                                    return Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                        20,
                                        8,
                                        20,
                                        0,
                                      ),
                                      child: KeyedSubtree(
                                        key: ValueKey(
                                          'page_${i}_${animVisible}_${_isCorrect}_${_currentChoice ?? ''}',
                                        ),
                                        child: _QuestionCard(
                                          question: q,
                                          options: opts,
                                          selected: i == _index
                                              ? _currentChoice
                                              : null,
                                          onSelect: _select,
                                          locked: _validated,
                                          showOutcome: animVisible,
                                          isCorrect: _isCorrect,
                                          bottomSafeInset:
                                              bottomInsetForThisPage,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SafeArea(
                                top: false,
                                minimum: const EdgeInsets.fromLTRB(
                                  20,
                                  8,
                                  20,
                                  16,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: SizedBox(
                                        height: kButtonHeight,
                                        child: _PrimaryButton(
                                          label: !_validated
                                              ? 'Valider'
                                              : (_index == totalSafe - 1
                                                    ? 'Terminer'
                                                    : 'Suivant'),
                                          onTap: !_hasQuiz
                                              ? null
                                              : (!_validated
                                                    ? (_currentChoice == null
                                                          ? null
                                                          : _validate)
                                                    : _next),
                                        ),
                                      ),
                                    ),
                                    if (_hasQuiz) ...[
                                      const SizedBox(width: 12),
                                      SizedBox(
                                        height: kButtonHeight,
                                        child: _DangerButton(
                                          label: 'Mettre fin',
                                          onTap: _endQuizNow,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),

                          if (_validated)
                            Positioned(
                              left: 0,
                              right: 0,
                              bottom: bottomBarReserved,
                              child: IgnorePointer(
                                child: SizedBox(
                                  height: animSize,
                                  child: Center(
                                    child: _FeedbackStrip(
                                      controller: _pulseCtrl,
                                      good: _isCorrect,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                          if (_showSplash)
                            _DifficultySplash(
                              fade: _splashFade,
                              isDark: isDark,
                              selected: _selectedDifficulty,
                              onSelect: (d) => setState(() {
                                _selectedDifficulty = d;
                                _mixMode = false;
                              }),
                              onStart: () => _startQuiz(mix: false),
                              onStartRandom: () => _startQuiz(mix: true),
                            ),

                          if (_loading)
                            Positioned.fill(
                              child: _LoadingOverlay(
                                isDark: isDark,
                                total: _total,
                                animated: _animatedCount,
                                loaded: _loadedCount,
                                readyTarget: math.min(
                                  23,
                                  (_total <= 0 ? 23 : _total),
                                ),
                                onRetry: () {
                                  if (!_hasQuiz) {
                                    unawaited(_startQuiz(mix: _mixMode));
                                    return;
                                  }
                                  unawaited(_ensureBatchForQuizIndex(_index));
                                },
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ===========================================================================
  // RESULT DIALOG (inchangé)
  // ===========================================================================
  void _openResultDialog(int score, int total) {
    final pct = (score / total * 100).round();

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Résultat',
      barrierColor: Colors.black.withOpacity(0.25),
      transitionDuration: const Duration(milliseconds: 260),
      pageBuilder: (_, __, ___) {
        return Stack(
          children: [
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                child: const SizedBox.expand(),
              ),
            ),
            Center(
              child: _ResultCard(
                score: score,
                total: total,
                percent: pct,
                onRestart: () {
                  Navigator.of(context).pop();
                  _restart();
                },
                onQuit: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).maybePop();
                },
              ),
            ),
          ],
        );
      },
      transitionBuilder: (_, anim, __, child) => FadeTransition(
        opacity: CurvedAnimation(parent: anim, curve: Curves.easeOutCubic),
        child: ScaleTransition(
          scale: Tween(
            begin: .98,
            end: 1.0,
          ).chain(CurveTween(curve: Curves.easeOutBack)).animate(anim),
          child: child,
        ),
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (pct >= 80) {
        AppNotifier.success(
          context,
          title: 'Excellent !',
          message: 'Tu maîtrises 💪',
        );
      } else if (pct >= 50) {
        AppNotifier.info(
          context,
          title: 'Bien joué',
          message: 'Relis et retente 📈',
        );
      } else {
        AppNotifier.warning(
          context,
          title: 'À retravailler',
          message: 'Reprends les fiches.',
        );
      }
    });
  }
}

// ============================================================================
// WIDGETS (UI inchangée)
// ============================================================================

class _TopProgressBar extends StatelessWidget {
  final int index, total;
  final Color accent;
  const _TopProgressBar({
    required this.index,
    required this.total,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final totalSafe = total <= 0 ? 1 : total;
    final value = ((index + 1) / totalSafe).clamp(0.0, 1.0);
    final track = _Brand.radioTrack(context);
    final labelColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white.withAlpha(200)
        : _Brand.textDark.withAlpha(230);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Question ${index + 1}',
          style: _Brand.small(
            context,
          ).copyWith(color: labelColor, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 12,
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: value,
                  minHeight: 6,
                  backgroundColor: track,
                  valueColor: AlwaysStoppedAnimation<Color>(accent),
                ),
              ),
              FractionallySizedBox(
                widthFactor: value,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: accent,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: _opa(accent, .35),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DangerButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  const _DangerButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isEnabled = onTap != null;
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: isEnabled ? _Brand.bad : _Brand.radioTrack(context),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          textStyle: const TextStyle(
            fontFamily: 'InstrumentSans',
            fontWeight: FontWeight.w800,
            fontSize: 16,
          ),
        ),
        child: Text(label),
      ),
    );
  }
}

class _QuestionCard extends StatelessWidget {
  final QuizQuestion question;
  final List<String> options;
  final String? selected;
  final ValueChanged<String> onSelect;
  final bool locked;
  final bool showOutcome;
  final bool isCorrect;
  final double bottomSafeInset;

  const _QuestionCard({
    super.key,
    required this.question,
    required this.options,
    required this.selected,
    required this.onSelect,
    required this.locked,
    required this.showOutcome,
    required this.isCorrect,
    this.bottomSafeInset = 0,
  });

  bool _shouldShowSub(String? raw) {
    final s = raw?.trim();
    if (s == null || s.isEmpty) return false;

    // Filtre les valeurs techniques/import JSON (ex: droit_justice_fr_quiz_json)
    final lower = s.toLowerCase();
    if (lower.contains('_quiz_json')) return false;
    if (lower.endsWith('.json')) return false;

    // Si tu veux être ultra strict et virer tout ce qui ressemble à un slug technique :
    // if (s.contains('_')) return false;

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final textCol = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : _Brand.textDark;

    final sub = question.sub?.trim();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.only(top: 8, bottom: 12 + bottomSafeInset),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            question.question,
            style: _Brand.h1(context).copyWith(color: textCol),
          ),

          // ✅ Sous-titre uniquement si pertinent (et pas un tag technique)
          if (_shouldShowSub(sub)) ...[
            const SizedBox(height: 6),
            Text(
              sub!, // safe car _shouldShowSub(sub) => sub non null & non vide
              style: TextStyle(
                color: textCol.withAlpha(180),
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.none,
              ),
            ),
          ],

          const SizedBox(height: 16),

          ...options.map((o) {
            final isSel = selected == o;
            final correctShown = showOutcome && o == question.answer;
            final wrongShown = showOutcome && isSel && o != question.answer;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _OptionTile(
                label: o,
                selected: isSel,
                locked: locked,
                correct: correctShown,
                wrong: wrongShown,
                onTap: () => onSelect(o),
              ),
            );
          }),

          AnimatedSwitcher(
            duration: const Duration(milliseconds: 280),
            switchInCurve: Curves.easeOutCubic,
            layoutBuilder: (currentChild, previousChildren) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (currentChild != null) currentChild,
                ...previousChildren,
              ],
            ),
            child: showOutcome
                ? _OutcomeCard(
                    key: ValueKey<bool>(isCorrect),
                    good: isCorrect,
                    explanation: question.explanation,
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final String label;
  final bool selected;
  final bool locked;
  final bool correct;
  final bool wrong;
  final VoidCallback onTap;

  const _OptionTile({
    required this.label,
    required this.selected,
    required this.locked,
    required this.correct,
    required this.wrong,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color bg() {
      if (correct) return _opa(_Brand.good, .14);
      if (wrong) return _opa(_Brand.bad, .12);
      return isDark ? _opa(Colors.white, .06) : Colors.white;
    }

    Color border() {
      if (correct) return _opa(_Brand.good, .85);
      if (wrong) return _opa(_Brand.bad, .85);
      return isDark
          ? _opa(Colors.white, selected ? .55 : .22)
          : const Color(0xFFE8E8ED);
    }

    Widget dot(bool filled) => Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: correct
              ? _Brand.good
              : wrong
              ? _Brand.bad
              : selected
              ? _Brand.accent
              : _Brand.radioTrack(context),
          width: 2,
        ),
      ),
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: filled ? 10 : 0,
          height: filled ? 10 : 0,
          decoration: BoxDecoration(
            color: correct
                ? _Brand.good
                : wrong
                ? _Brand.bad
                : _Brand.accent,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      constraints: const BoxConstraints(minHeight: 64),
      decoration: BoxDecoration(
        color: bg(),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: border()),
        boxShadow: [
          if (!isDark)
            const BoxShadow(
              color: Color(0x11000000),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
        ],
      ),
      child: InkWell(
        onTap: locked ? null : onTap,
        borderRadius: BorderRadius.circular(22),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              dot(selected || correct || wrong),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  softWrap: true,
                  overflow: TextOverflow.visible,
                  style: _Brand.option(context).copyWith(
                    color: isDark ? Colors.white : _Brand.textDark,
                    fontWeight: selected ? FontWeight.w800 : FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OutcomeCard extends StatelessWidget {
  final bool good;
  final String explanation;
  const _OutcomeCard({
    super.key,
    required this.good,
    required this.explanation,
  });

  @override
  Widget build(BuildContext context) {
    final color = good ? _Brand.good : _Brand.bad;
    final icon = good ? Icons.check_circle_rounded : Icons.cancel_rounded;

    return Material(
      type: MaterialType.transparency,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: _opa(color, .55), width: 1.2),
      ),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _opa(color, .10),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                explanation,
                softWrap: true,
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : _Brand.textDark,
                  fontWeight: FontWeight.w600,
                  height: 1.32,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  const _PrimaryButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isEnabled = onTap != null;
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: isEnabled
              ? _Brand.accent
              : _Brand.radioTrack(context),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          textStyle: const TextStyle(
            fontFamily: 'InstrumentSans',
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
        child: Text(label),
      ),
    );
  }
}

// Feedback widgets (identiques à ton fichier)
class _FeedbackStrip extends StatelessWidget {
  final AnimationController controller;
  final bool good;

  const _FeedbackStrip({required this.controller, required this.good});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        final maxW = constraints.maxWidth;
        final size = (maxW * 0.4).clamp(80.0, 160.0);

        return SizedBox(
          height: size * 1.1,
          child: Center(
            child: _FeedbackSparkles(
              controller: controller,
              good: good,
              size: size,
            ),
          ),
        );
      },
    );
  }
}

class _FeedbackSparkles extends StatelessWidget {
  final AnimationController controller;
  final bool good;
  final double size;

  const _FeedbackSparkles({
    required this.controller,
    required this.good,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final base = good ? _Brand.good : _Brand.bad;

    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        final t = controller.value.clamp(0.0, 1.0);
        final icon = good ? Icons.check_rounded : Icons.close_rounded;
        final iconSize = size * .30;

        const n = 8;
        final maxR = size * .58;
        final showStars = t < 0.999;

        final kids = <Widget>[];
        if (showStars) {
          for (var i = 0; i < n; i++) {
            final ang = (i / n) * 2 * math.pi;
            final r = maxR * t;
            final dx = r * math.cos(ang);
            final dy = r * math.sin(ang);

            final scale = 0.2 + t * 0.8;
            final op = (1 - t * 0.9).clamp(0.0, 1.0);

            kids.add(
              Transform.translate(
                offset: Offset(dx, dy),
                child: Transform.scale(
                  scale: scale,
                  child: Opacity(
                    opacity: op,
                    child: _Star(color: base, size: size * .10),
                  ),
                ),
              ),
            );
          }
        }

        return Stack(
          alignment: Alignment.center,
          children: [
            ...kids,
            Transform.scale(
              scale: 0.86 + t * 0.24,
              child: Icon(icon, size: iconSize, color: base),
            ),
          ],
        );
      },
    );
  }
}

class _Star extends StatelessWidget {
  final Color color;
  final double size;
  const _Star({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: Size.square(size), painter: _StarPainter(color));
  }
}

class _StarPainter extends CustomPainter {
  final Color color;
  _StarPainter(this.color);

  @override
  void paint(Canvas canvas, Size s) {
    final p = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final cx = s.width / 2, cy = s.height / 2;
    final r1 = s.width * .5, r2 = s.width * .22;
    final path = Path();
    for (int i = 0; i < 10; i++) {
      final r = i.isEven ? r1 : r2;
      final a = (math.pi / 5) * i - math.pi / 2;
      final x = cx + r * math.cos(a);
      final y = cy + r * math.sin(a);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, p);
  }

  @override
  bool shouldRepaint(covariant _StarPainter old) => old.color != color;
}

// Result card (identique à ton fichier)
class _ResultCard extends StatefulWidget {
  final int score;
  final int total;
  final int percent;
  final VoidCallback onRestart;
  final VoidCallback onQuit;
  const _ResultCard({
    required this.score,
    required this.total,
    required this.percent,
    required this.onRestart,
    required this.onQuit,
  });

  @override
  State<_ResultCard> createState() => _ResultCardState();
}

class _ResultCardState extends State<_ResultCard>
    with TickerProviderStateMixin {
  late final AnimationController a = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..forward();

  late final Animation<double> fade = CurvedAnimation(
    parent: a,
    curve: Curves.easeOutCubic,
  );

  late final Animation<double> pop = Tween(
    begin: .94,
    end: 1.0,
  ).chain(CurveTween(curve: Curves.easeOutBack)).animate(a);

  late final AnimationController spinCtrl = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  )..repeat();

  (Color color, IconData icon, String headline, String subline) _style() {
    final pct = (widget.score / widget.total) * 100.0;
    if (pct >= 80) {
      return (
        _Brand.good,
        Icons.emoji_events_rounded,
        'Excellent !',
        'Tu maîtrises parfaitement le sujet ✨',
      );
    }
    if (pct >= 50) {
      return (
        _Brand.accent,
        Icons.auto_graph_rounded,
        'Bon travail',
        'Encore un petit effort 💪',
      );
    }
    return (
      _Brand.bad,
      Icons.refresh_rounded,
      'À retravailler',
      'Revois la leçon et retente',
    );
  }

  @override
  void dispose() {
    spinCtrl.dispose();
    a.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final (accent, icon, headline, subline) = _style();
    final pct = ((widget.score / widget.total) * 100).round().clamp(0, 100);

    return ScaleTransition(
      scale: pop,
      child: FadeTransition(
        opacity: fade,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
              width: 340,
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(26),
                border: Border.all(color: Colors.white.withAlpha(64)),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: accent.withValues(alpha: .18),
                    blurRadius: 28,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 96,
                          height: 96,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: accent.withValues(alpha: .12),
                          ),
                        ),
                        Icon(icon, color: accent, size: 44),
                        AnimatedBuilder(
                          animation: spinCtrl,
                          builder: (_, __) => Transform.rotate(
                            angle: spinCtrl.value * 2 * math.pi,
                            child: SizedBox(
                              width: 108,
                              height: 108,
                              child: CircularProgressIndicator(
                                strokeWidth: 8,
                                value: null,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  accent,
                                ),
                                backgroundColor: Colors.white.withValues(
                                  alpha: .15,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    headline,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'InstrumentSans',
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                      height: 1.2,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subline,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'InstrumentSans',
                      color: Colors.white.withAlpha(235),
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${widget.score}/${widget.total} bonnes réponses • $pct%',
                    style: TextStyle(
                      fontFamily: 'InstrumentSans',
                      color: accent.withValues(alpha: .95),
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: widget.onQuit,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: BorderSide(
                              color: Colors.white.withAlpha(190),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(26),
                            ),
                            textStyle: const TextStyle(
                              fontFamily: 'InstrumentSans',
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          child: const Text('Quitter'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: widget.onRestart,
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Colors.white,
                            foregroundColor: _Brand.textDark,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(26),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            textStyle: const TextStyle(
                              fontFamily: 'InstrumentSans',
                              fontWeight: FontWeight.w800,
                              fontSize: 15,
                              letterSpacing: .2,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          child: const Text('Recommencer'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// SPLASH (copié de ton fichier, inchangé)
// ============================================================================
class _DifficultySplash extends StatefulWidget {
  final Animation<double> fade;
  final bool isDark;
  final String? selected; // Facile | Moyenne | Difficile
  final ValueChanged<String> onSelect;
  final VoidCallback onStart;
  final VoidCallback onStartRandom;

  const _DifficultySplash({
    required this.fade,
    required this.isDark,
    required this.selected,
    required this.onSelect,
    required this.onStart,
    required this.onStartRandom,
  });

  @override
  State<_DifficultySplash> createState() => _DifficultySplashState();
}

class _DifficultySplashState extends State<_DifficultySplash>
    with TickerProviderStateMixin {
  late final AnimationController _bgCtrl = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 10),
  )..repeat(reverse: true);

  late final AnimationController _floatCtrl = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 5),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _bgCtrl.dispose();
    _floatCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final textMain = isDark ? Colors.white : _Brand.textDark;
    final sub = isDark
        ? Colors.white.withAlpha(210)
        : _Brand.textDark.withAlpha(210);

    return Positioned.fill(
      child: FadeTransition(
        opacity: widget.fade,
        child: Stack(
          children: [
            Positioned.fill(
              child: _AnimatedBackground(ctrl: _bgCtrl, isDark: isDark),
            ),
            _Halo(
              color: _Brand.accent,
              size: 260,
              dx: -140,
              dy: -160,
              ctrl: _bgCtrl,
              strength: isDark ? .18 : .14,
            ),
            _Halo(
              color: _Brand.good,
              size: 220,
              dx: 120,
              dy: 260,
              ctrl: _bgCtrl,
              strength: isDark ? .15 : .12,
            ),
            _Halo(
              color: _Brand.bad,
              size: 180,
              dx: -10,
              dy: 120,
              ctrl: _bgCtrl,
              strength: isDark ? .12 : .10,
            ),

            // ✅ MODIF: on ne protège plus le bas (zone geste),
            // sinon ça crée un "padding" qui ressemble à une bande en bas.
            SafeArea(
              bottom: false,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 460),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Sélectionne le niveau de difficulté',
                          textAlign: TextAlign.center,
                          style: _Brand.h1(
                            context,
                          ).copyWith(color: textMain, fontSize: 24),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Choisis Facile, Moyen ou Difficile pour adapter les questions à ton niveau.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: sub,
                            fontWeight: FontWeight.w600,
                            height: 1.3,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        const SizedBox(height: 20),
                        LayoutBuilder(
                          builder: (ctx, c) {
                            final wide = c.maxWidth >= 420;
                            final spacing = 12.0;
                            final itemW = wide
                                ? (c.maxWidth - spacing * 2) / 3
                                : c.maxWidth;

                            final children = [
                              _LevelCard(
                                label: 'Facile',
                                emoji: '🌱',
                                tint: const Color(0xFFB7F0C1),
                                active: widget.selected == 'Facile',
                                onTap: () => widget.onSelect('Facile'),
                                isDark: isDark,
                                floatCtrl: _floatCtrl,
                              ),
                              _LevelCard(
                                label: 'Moyen',
                                emoji: '🏅',
                                tint: const Color(0xFFFCE7B2),
                                active: widget.selected == 'Moyenne',
                                onTap: () => widget.onSelect('Moyenne'),
                                isDark: isDark,
                                floatCtrl: _floatCtrl,
                                floatDelay: .15,
                              ),
                              _LevelCard(
                                label: 'Difficile',
                                emoji: '🏆',
                                tint: const Color(0xFFF8C2BE),
                                active: widget.selected == 'Difficile',
                                onTap: () => widget.onSelect('Difficile'),
                                isDark: isDark,
                                floatCtrl: _floatCtrl,
                                floatDelay: .30,
                              ),
                            ];

                            if (wide) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(width: itemW, child: children[0]),
                                  SizedBox(width: spacing),
                                  SizedBox(width: itemW, child: children[1]),
                                  SizedBox(width: spacing),
                                  SizedBox(width: itemW, child: children[2]),
                                ],
                              );
                            } else {
                              return Column(
                                children: [
                                  children[0],
                                  const SizedBox(height: 10),
                                  children[1],
                                  const SizedBox(height: 10),
                                  children[2],
                                ],
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 56,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: widget.selected == null
                                ? null
                                : widget.onStart,
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: widget.selected == null
                                  ? _Brand.radioTrack(context)
                                  : (isDark ? Colors.white : _Brand.textDark),
                              foregroundColor: widget.selected == null
                                  ? (isDark
                                        ? Colors.white.withAlpha(180)
                                        : _Brand.textDark.withAlpha(180))
                                  : (isDark ? Colors.black : Colors.white),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                              textStyle: const TextStyle(
                                fontFamily: 'InstrumentSans',
                                fontWeight: FontWeight.w800,
                                fontSize: 18,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            child: const Text('Commencer'),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 52,
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: widget.onStartRandom,
                            icon: const Icon(Icons.shuffle_rounded, size: 20),
                            label: const Text('Aléatoire'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: isDark
                                  ? Colors.white
                                  : _Brand.textDark,
                              side: BorderSide(
                                color: isDark
                                    ? Colors.white.withAlpha(160)
                                    : _Brand.textDark.withAlpha(160),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(26),
                              ),
                              textStyle: const TextStyle(
                                fontFamily: 'InstrumentSans',
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedBackground extends StatelessWidget {
  final AnimationController ctrl;
  final bool isDark;
  const _AnimatedBackground({required this.ctrl, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final base1 = isDark ? const Color(0xFF0B0C10) : const Color(0xFFF7F8FA);
    final base2 = isDark ? const Color(0xFF11131A) : const Color(0xFFFFFFFF);

    return AnimatedBuilder(
      animation: ctrl,
      builder: (_, __) {
        final t = ctrl.value;
        final a1 = Alignment.lerp(
          const Alignment(-0.9, -1.0),
          const Alignment(0.6, -0.6),
          t,
        )!;
        final a2 = Alignment.lerp(
          const Alignment(0.9, 1.0),
          const Alignment(-0.6, 0.6),
          t,
        )!;

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: a1,
              end: a2,
              colors: [base1, base2],
            ),
          ),
        );
      },
    );
  }
}

class _Halo extends StatelessWidget {
  final Color color;
  final double size;
  final double dx, dy;
  final double strength;
  final AnimationController ctrl;
  const _Halo({
    required this.color,
    required this.size,
    required this.dx,
    required this.dy,
    required this.ctrl,
    required this.strength,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: ctrl,
      builder: (_, __) {
        final t = ctrl.value;
        final shiftX = dx + 8 * math.sin(2 * math.pi * t);
        final shiftY = dy + 8 * math.cos(2 * math.pi * t);
        return IgnorePointer(
          child: Align(
            alignment: Alignment.center,
            child: Transform.translate(
              offset: Offset(shiftX, shiftY),
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      color.withValues(alpha: strength),
                      color.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _LevelCard extends StatelessWidget {
  final String label;
  final String emoji;
  final Color tint;
  final bool active;
  final bool isDark;
  final VoidCallback onTap;
  final AnimationController floatCtrl;
  final double floatDelay;

  const _LevelCard({
    required this.label,
    required this.emoji,
    required this.tint,
    required this.active,
    required this.onTap,
    required this.isDark,
    required this.floatCtrl,
    this.floatDelay = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    final track = _Brand.radioTrack(context);

    return AnimatedBuilder(
      animation: floatCtrl,
      builder: (_, __) {
        final t = ((floatCtrl.value + floatDelay) % 1.0);
        final y = 2.0 * math.sin(2 * math.pi * t);
        final scale = active ? 1.02 : 1.0;

        return Transform.translate(
          offset: Offset(0, y),
          child: AnimatedScale(
            duration: const Duration(milliseconds: 180),
            scale: scale,
            curve: Curves.easeOutCubic,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(20),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                height: 112,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: _opa(tint, isDark ? .18 : .16),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: active ? tint : track,
                    width: active ? 2 : 1,
                  ),
                  boxShadow: [
                    if (!isDark)
                      BoxShadow(
                        color: tint.withValues(alpha: .18),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _opa(tint, isDark ? .35 : .32),
                        border: Border.all(
                          color: active ? tint : _opa(Colors.white, .25),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          emoji,
                          style: const TextStyle(fontSize: 26),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        label,
                        style: _Brand.option(context).copyWith(
                          color: isDark ? Colors.white : _Brand.textDark,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: active ? tint : track,
                          width: 2,
                        ),
                      ),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: active ? tint : Colors.transparent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
