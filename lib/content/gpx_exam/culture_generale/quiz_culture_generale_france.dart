// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:math' as math;
import 'dart:convert';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:copiqpolice/core/widgets/app_notifier.dart'
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
    final bg = isDark ? const Color(0xFF000B36) : _Brand.bgLight;
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
              // `width: 360` fixe débordait sur un écran de 320 dp : avec les
              // marges de 22, il ne reste que 276 dp exploitables.
              constraints: const BoxConstraints(maxWidth: 360),
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
                    color: Colors.black.withValues(alpha: isDark ? .35 : .08),
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
  final String module; // ex: "France"
  final String category; // ex: "France"
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
    // options peut être stocké comme String JSON (double-encodé) ou List dans JSONB
    final _rawOpts = json['options'];
    final rawOptions = _rawOpts is String
        ? ((jsonDecode(_rawOpts) as List?) ?? const [])
        : ((_rawOpts as List?) ?? const []);
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

    dynamic base() {
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
    final first = await base()
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
    final second = await base()
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
    return data
        .cast<Map<String, dynamic>>()
        .map(QuizQuestion.fromJson)
        .toList();
  }
}

// ============================================================================
// PAGE
// ============================================================================
class QuizCultureGeneralFrance extends StatefulWidget {
  static const String routeName =
      '/gpx_exam/concours/culture_generale_francais';

  final String uid;
  final String email;

  const QuizCultureGeneralFrance({
    super.key,
    required this.uid,
    required this.email,
  });

  @override
  State<QuizCultureGeneralFrance> createState() =>
      _QuizCultureGeneralFranceState();
}

class _QuizCultureGeneralFranceState extends State<QuizCultureGeneralFrance>
    with TickerProviderStateMixin {
  // ===========================================================================
  // CONFIG QUIZ
  // ===========================================================================
  static const String _categoryNameDb = 'France';
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

  final int _startOffset = 0;
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
    // Le tap sur une option ne produisait aucun retour : seule la validation
    // vibrait. `selectionClick` est la vibration la plus légère du système,
    // faite exactement pour un changement de choix.
    HapticFeedback.selectionClick();
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
          // Aligné sur la durée d'un élément de la cascade : le glissement se
          // termine pendant que les options continuent d'apparaître, au lieu
          // d'être fini depuis longtemps.
          duration: const Duration(milliseconds: 420),
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

    // Confirmation obligatoire : l'action est irréversible — elle finalise
    // l'historique et ouvre le score. Le bouton étant voisin de « Suivant », un
    // appui accidenté à la question 18 coûtait tout le reste du quiz.
    final confirme = await _confirmerSortie(
      titre: 'Mettre fin au quiz ?',
      actionLabel: 'Mettre fin',
    );
    if (!confirme || !mounted) return;

    final int answered = _answers.length;
    final int totalForScore = answered <= 0 ? 1 : answered;

    await _updateHistoryOnFinish();
    if (!mounted) return;

    _openResultDialog(_score, totalForScore);
  }

  /// Garde de réentrance des sorties.
  ///
  /// Sans elle, deux dialogues de confirmation pouvaient se superposer (croix
  /// tapée deux fois, ou croix pendant un geste retour).
  bool _sortieEnCours = false;

  /// Ferme le quiz après confirmation, en enregistrant les réponses déjà
  /// données. Chemin unique de la croix et du geste retour système : sans ça, le
  /// geste contournerait la confirmation.
  Future<void> _fermerQuiz() async {
    // La croix et « Mettre fin » partagent strictement la même clôture :
    // confirmation, sauvegarde Supabase, calcul du score et écran de résultat.
    if (!_hasQuiz) {
      if (mounted) _quitterEcran();
      return;
    }
    await _endQuizNow();
  }

  /// Sortie effective de l'écran.
  ///
  /// **`pop()` et non `maybePop()`.** C'est la cause de l'ANR « COP'IQ isn't
  /// responding » : `maybePop` consulte les `PopScope` de la route avant de
  /// dépiler. Le `PopScope` de cette page étant à `canPop: false` pendant un
  /// quiz, il refusait le pop et rappelait `_fermerQuiz`, qui rappelait
  /// `maybePop`… boucle synchrone infinie sur le thread UI, donc gel de l'app.
  ///
  /// `pop()` dépile directement, sans repasser par les gardes — ce qui est
  /// exactement ce qu'on veut ici : la décision de sortir vient d'être prise et
  /// confirmée.
  void _quitterEcran() {
    final nav = Navigator.of(context);
    if (nav.canPop()) nav.pop();
  }

  /// Dialogue commun à « Mettre fin » et à la fermeture.
  ///
  /// Le message est calculé ici pour les deux : ce qui compte, dans les deux
  /// cas, c'est que l'utilisateur sache combien de questions il laisse et sur
  /// quelle base son score sera établi.
  Future<bool> _confirmerSortie({
    required String titre,
    required String actionLabel,
  }) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final restantes = _total - (_index + 1);
    final repondues = _answers.length;

    final message = [
      if (restantes > 0)
        'Il te reste $restantes question${restantes > 1 ? 's' : ''}.',
      if (repondues > 1)
        'Tes $repondues réponses sont enregistrées et ton score sera '
            'calculé sur cette base.'
      else if (repondues == 1)
        'Ta réponse est enregistrée et ton score sera calculé sur cette base.'
      else
        'Aucune réponse validée pour le moment : rien ne sera comptabilisé.',
    ].join(' ');

    // `showGeneralDialog` et non `showDialog` : on reprend exactement la mise en
    // scène de la carte de résultat — flou d'arrière-plan, fondu et léger
    // agrandissement — au lieu de l'`AlertDialog` Material par défaut, qui
    // détonnait avec le reste de l'écran.
    final reponse = await showGeneralDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Confirmation',
      barrierColor: Colors.black.withValues(alpha: 0.35),
      transitionDuration: const Duration(milliseconds: 260),
      pageBuilder: (ctx, __, ___) => Stack(
        children: [
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: const SizedBox.expand(),
            ),
          ),
          Center(
            child: _ConfirmCard(
              isDark: isDark,
              titre: titre,
              message: message,
              actionLabel: actionLabel,
              onConfirmer: () => Navigator.of(ctx).pop(true),
              onAnnuler: () => Navigator.of(ctx).pop(false),
            ),
          ),
        ],
      ),
      transitionBuilder: (_, anim, __, child) => FadeTransition(
        opacity: CurvedAnimation(parent: anim, curve: Curves.easeOutCubic),
        child: ScaleTransition(
          scale: Tween(
            begin: .96,
            end: 1.0,
          ).chain(CurveTween(curve: Curves.easeOutBack)).animate(anim),
          child: child,
        ),
      ),
    );

    return reponse ?? false;
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
        'quiz_name': 'Quiz culture générale France',

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
      // Rebuild nécessaire : `canPop` du `PopScope` dépend de ce drapeau. Sans
      // ce `setState`, le geste retour restait bloqué après la clôture.
      if (mounted) setState(() {});

      debugPrint('✅ quiz_history (finish) updated id=$_historyRowId');
    } catch (e) {
      debugPrint('❌ quiz_history (finish) update failed: $e');
    }
  }

  // `_updateHistoryOnAbandon` a été supprimée.
  //
  // Elle écrivait `score: 0, correct_count: 0, total_questions: 0` : répondre à
  // cinq questions puis fermer effaçait donc les cinq résultats de l'historique.
  // Les réponses individuelles étaient bien en base — `_saveAnswer` les insère à
  // chaque validation — mais l'agrégat affiché à l'utilisateur repartait à zéro.
  //
  // Une sortie et un « Mettre fin » sont la même chose du point de vue des
  // données : on comptabilise ce qui a été répondu. Tous les chemins de sortie
  // passent donc par `_updateHistoryOnFinish`. Le cas « fermé sans aucune
  // réponse » est déjà couvert : `_answers` étant vide, l'agrégat vaut 0/0.

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

      await _sb.from('quiz_culture_generale_france_pages').insert(payload);
    } catch (e, st) {
      debugPrint('❌ quiz_culture_generale_france_pages insert failed: $e');
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
      'page': QuizCultureGeneralFrance.routeName,
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
                      initialValue: type,
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

        final bg = isDark ? const Color(0xFF000B36) : _Brand.bgLight;
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
        const double bottomBarReserved = kButtonHeight + kButtonVPad + 8;

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
            // `PopScope` remplace `WillPopScope`, déprécié.
            //
            // Le geste retour est bloqué pendant un quiz en cours et renvoyé
            // vers `_fermerQuiz` : sans ça il contournerait la confirmation que
            // la croix impose, et l'utilisateur pourrait sortir d'un balayage
            // involontaire.
            child: PopScope<Object?>(
              canPop: !_hasQuiz || _historyFinished,
              onPopInvokedWithResult: (didPop, _) {
                if (!didPop) unawaited(_fermerQuiz());
              },
              // Le fond est peint sous le Scaffold, et non par lui : ainsi il
              // couvre aussi les zones système (status bar, barre de gestes) que
              // le `SafeArea` du body laisserait au noir.
              child: Stack(
                children: [
                  Positioned.fill(child: _QuizBackdrop(isDark: isDark)),
                  Scaffold(
                    backgroundColor: Colors.transparent,
                    extendBody: true,
                    extendBodyBehindAppBar: true,
                    appBar: AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      scrolledUnderElevation: 0,
                      leading: IconButton(
                        icon: Icon(Icons.close_rounded, color: textCol),
                        onPressed: _fermerQuiz,
                        tooltip: 'Fermer',
                      ),
                      actions: [
                        // Masqué hors quiz plutôt que grisé : sur l'écran de choix
                        // de difficulté il n'y a rien à signaler, et un bouton
                        // visible mais inerte n'est qu'une question sans réponse
                        // posée à l'utilisateur.
                        if (_hasQuiz && !_showSplash)
                          IconButton(
                            tooltip: 'Signaler',
                            onPressed: () => _openReportDialog(isDark: isDark),
                            icon: Icon(Icons.flag_outlined, color: textCol),
                          ),
                        const SizedBox(width: 6),
                      ],
                    ),

                    // ✅ ton UI inchangé dessous
                    body: SafeArea(
                      top: false,
                      child: LayoutBuilder(
                        builder: (context, _) {
                          return Stack(
                            clipBehavior: Clip.none,
                            children: [
                              // L'interface de quiz n'est construite qu'une fois le
                              // niveau choisi.
                              //
                              // Elle était auparavant toujours présente et se
                              // trouvait simplement *cachée* par le fond opaque du
                              // splash. En rendant celui-ci transparent pour unifier
                              // les fonds, la barre « Question 1 / 1 », le texte de
                              // repli et le bouton « Valider » désactivé sont
                              // devenus visibles à travers. Les masquer à la source
                              // est plus juste que de les recouvrir : on ne construit
                              // pas une interface pour la dissimuler.
                              if (!_showSplash)
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
                                        accent: isDark
                                            ? _Brand.white
                                            : _Brand.accent,
                                      ),
                                    ),
                                    Expanded(
                                      child: PageView.builder(
                                        controller: _page,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
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

                                          // L'ancienne réserve ajoutait jusqu'à 240 px
                                          // de vide sous la carte pour loger la grosse
                                          // croix flottante. Le feedback vivant
                                          // désormais dans le bandeau lui-même, on ne
                                          // réserve plus que la barre de boutons.
                                          const double bottomInsetForThisPage =
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
                                                      color: textCol.withAlpha(
                                                        200,
                                                      ),
                                                      fontWeight:
                                                          FontWeight.w600,
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
                                            // Clé sur le seul index de la page.
                                            //
                                            // Elle intégrait auparavant le choix
                                            // courant et le résultat : le sous-arbre
                                            // était donc **détruit et recréé à chaque
                                            // tap sur une option**. Deux conséquences
                                            // — la cascade d'apparition rejouerait à
                                            // chaque sélection, et les `AnimatedContainer`
                                            // des options ne pouvaient pas animer leur
                                            // changement de couleur, faute d'état
                                            // conservé. Un `StatelessWidget` se
                                            // reconstruit de toute façon quand son
                                            // parent change : cette clé composite
                                            // n'apportait rien.
                                            child: KeyedSubtree(
                                              key: ValueKey('page_$i'),
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
                                                pulse: _pulseCtrl,
                                                estActive: i == _index,
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
                                                          ? (_currentChoice ==
                                                                    null
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

                              // Plus d'overlay de feedback ici : il se superposait au
                              // bandeau d'explication dès que la question était
                              // longue. L'animation a été déplacée dans
                              // `_OutcomeCard`, autour de son icône.
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
                                      unawaited(
                                        _ensureBatchForQuizIndex(_index),
                                      );
                                    },
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ],
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
      barrierColor: Colors.black.withValues(alpha: 0.25),
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
                  // Ferme la carte de résultat, puis l'écran. `pop()` et non
                  // `maybePop()` : sous le `PopScope` de la page, `maybePop`
                  // relançait la confirmation de sortie en boucle.
                  Navigator.of(context).pop();
                  _quitterEcran();
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

/// Carte de confirmation avant une sortie.
///
/// Sert la croix comme le bouton « Mettre fin » : même mise en page, seuls le
/// titre et le libellé de l'action changent.
///
/// Hiérarchie assumée — l'action sûre (« Continuer le quiz ») est en bas, pleine
/// et dans l'accent de l'app : c'est la plus atteignable au pouce et la plus
/// visible. L'action destructive est au-dessus, en contour rouge : identifiable,
/// jamais tentante.
class _ConfirmCard extends StatelessWidget {
  const _ConfirmCard({
    required this.isDark,
    required this.titre,
    required this.message,
    required this.actionLabel,
    required this.onConfirmer,
    required this.onAnnuler,
  });

  final bool isDark;
  final String titre;
  final String message;
  final String actionLabel;
  final VoidCallback onConfirmer;
  final VoidCallback onAnnuler;

  @override
  Widget build(BuildContext context) {
    final fond = isDark ? const Color(0xFF11131A) : Colors.white;
    final texte = isDark ? Colors.white : _Brand.textDark;
    final secondaire = _opa(texte, .70);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 380),
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.fromLTRB(22, 24, 22, 18),
            decoration: BoxDecoration(
              color: fond,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: isDark
                    ? _opa(Colors.white, .10)
                    : _opa(Colors.black, .06),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? .45 : .12),
                  blurRadius: 34,
                  offset: const Offset(0, 16),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Pastille d'avertissement : donne un point d'entrée au regard
                // et annonce la nature de l'action avant même la lecture.
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _opa(_Brand.bad, .12),
                    border: Border.all(color: _opa(_Brand.bad, .30)),
                  ),
                  child: const Icon(
                    Icons.logout_rounded,
                    color: _Brand.bad,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  titre,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'InstrumentSans',
                    color: texte,
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                    height: 1.2,
                    decoration: TextDecoration.none,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'InstrumentSans',
                    color: secondaire,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    height: 1.45,
                    decoration: TextDecoration.none,
                  ),
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton(
                    onPressed: onConfirmer,
                    style: OutlinedButton.styleFrom(
                      backgroundColor: _opa(_Brand.bad, .10),
                      foregroundColor: _Brand.bad,
                      side: BorderSide(
                        color: _opa(_Brand.bad, .55),
                        width: 1.4,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26),
                      ),
                      textStyle: const TextStyle(
                        fontFamily: 'InstrumentSans',
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                    child: Text(actionLabel),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: onAnnuler,
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: _Brand.accent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26),
                      ),
                      textStyle: const TextStyle(
                        fontFamily: 'InstrumentSans',
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                    child: const Text('Continuer le quiz'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Fond du quiz.
///
/// Le noir plat précédent (`Colors.black`) était le seul écran du parcours sans
/// aucune matière : le splash de difficulté, lui, avait déjà son dégradé et ses
/// halos. On reprend donc ici le vocabulaire visuel du module Cas pratiques —
/// navy COP'IQ, halo haut, masses colorées dérivantes — pour que les deux
/// parcours se ressemblent.
///
/// Trois précautions de performance, parce que ce fond vit sous un `PageView` :
///  * `RepaintBoundary` isole la couche : son repaint ne touche pas les
///    questions ni les options au-dessus.
///  * un seul `AnimationController` de 26 s pour les trois halos, à très basse
///    fréquence visuelle.
///  * aucun flou (`BackdropFilter`, `ImageFiltered`) — coûteux sur mobile
///    d'entrée de gamme. Les halos sont des `RadialGradient`, déjà diffus.
class _QuizBackdrop extends StatefulWidget {
  const _QuizBackdrop({required this.isDark});

  final bool isDark;

  @override
  State<_QuizBackdrop> createState() => _QuizBackdropState();
}

class _QuizBackdropState extends State<_QuizBackdrop>
    with SingleTickerProviderStateMixin {
  // Navy COP'IQ, aligné sur CpTokens.darkNavy / darkNavyMid / darkNavyDeep.
  // Valeurs recopiées plutôt qu'importées : ce fichier de quiz n'a aucune
  // dépendance au module Cas pratiques, et n'a pas à en gagner une.
  static const Color _navyTop = Color(0xFF000B36);
  static const Color _navyMid = Color(0xFF000A33);
  static const Color _navyBot = Color(0xFF00082D);

  // Pendant clair : même construction, valeurs inversées. Le texte du quiz est
  // sombre en thème clair, le fond doit donc rester très lumineux — un bleu
  // lavé, jamais le bleu brand saturé, qui rendrait la question illisible.
  static const Color _clairTop = Color(0xFFF8FAFF);
  static const Color _clairMid = Color(0xFFEFF3FD);
  static const Color _clairBot = Color(0xFFE6ECFB);

  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 26),
  );

  @override
  void initState() {
    super.initState();
    // Respecte « Réduire les animations » du système : le dégradé reste, la
    // dérive s'arrête.
    final reduit = WidgetsBinding
        .instance
        .platformDispatcher
        .accessibilityFeatures
        .disableAnimations;
    if (!reduit) _ctrl.repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sombre = widget.isDark;

    // Même construction dans les deux thèmes — dégradé, halo de lumière, masses
    // dérivantes, vignette — seules les valeurs changent. Le thème clair n'est
    // donc pas un fond « au rabais » : il a la même matière, en lumineux.
    final degrade = sombre
        ? const [_navyTop, _navyMid, _navyBot]
        : const [_clairTop, _clairMid, _clairBot];

    // En clair, un halo blanc serait invisible sur un fond déjà blanc : la
    // lumière vient donc du bleu brand, en très faible densité.
    final halo = sombre ? Colors.white : _Brand.accent;
    final haloFort = sombre ? 0.10 : 0.07;
    final haloFaible = sombre ? 0.035 : 0.025;

    // La vignette assombrit en sombre, mais doit *aussi* fonctionner en clair :
    // du noir y salirait le fond, on referme donc avec un bleu très dilué.
    final vignette = sombre
        ? Colors.black.withValues(alpha: 0.42)
        : _Brand.accent.withValues(alpha: 0.10);

    return RepaintBoundary(
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 1) Dégradé de base
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: degrade,
              ),
            ),
          ),

          // 2) Halo haut : donne un point de lumière derrière la question.
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0.0, -0.72),
                radius: 1.15,
                colors: [
                  halo.withValues(alpha: haloFort),
                  halo.withValues(alpha: haloFaible),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.55, 1.0],
              ),
            ),
          ),

          // 3) Masses colorées dérivantes. Réutilise le `_Halo` du splash de
          //    difficulté : même mouvement, donc continuité entre les écrans.
          //    En clair elles sont deux fois plus discrètes — sur fond lumineux,
          //    la même densité donnerait des taches franches.
          _Halo(
            color: _Brand.accent,
            size: 300,
            dx: -130,
            dy: -180,
            ctrl: _ctrl,
            strength: sombre ? 0.16 : 0.09,
          ),
          _Halo(
            color: const Color(0xFF1A55E6),
            size: 260,
            dx: 140,
            dy: 200,
            ctrl: _ctrl,
            strength: sombre ? 0.14 : 0.08,
          ),
          _Halo(
            color: _Brand.good,
            size: 200,
            dx: 30,
            dy: 420,
            ctrl: _ctrl,
            strength: sombre ? 0.08 : 0.05,
          ),

          // 4) Vignette : referme les bords et empêche les halos de baver dans
          //    les coins.
          IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0.0, -0.15),
                  radius: 1.10,
                  colors: [Colors.transparent, vignette],
                  stops: const [0.55, 1.0],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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
          // Le total était déjà disponible ici : l'afficher situe l'effort
          // restant, ce qu'une barre seule ne dit pas précisément.
          'Question ${index + 1} / $totalSafe',
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

/// Action destructive, volontairement en retrait.
///
/// En rouge plein, ce bouton pesait autant que « Suivant » alors qu'il n'est
/// utilisé qu'exceptionnellement : deux aplats saturés côte à côte, aucune
/// hiérarchie. Il passe en contour, ce qui le laisse identifiable comme
/// dangereux — la couleur reste — sans attirer le pouce.
class _DangerButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  const _DangerButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isEnabled = onTap != null;
    final couleur = isEnabled ? _Brand.bad : _opa(_Brand.bad, .35);

    return SizedBox(
      height: 56,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          elevation: 0,
          backgroundColor: _opa(_Brand.bad, .10),
          foregroundColor: couleur,
          side: BorderSide(color: _opa(couleur, .55), width: 1.4),
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

class _QuestionCard extends StatefulWidget {
  final QuizQuestion question;
  final List<String> options;
  final String? selected;
  final ValueChanged<String> onSelect;
  final bool locked;
  final bool showOutcome;
  final bool isCorrect;

  /// Contrôleur du feedback, relancé à chaque validation par `_validate`.
  /// Piloté depuis la page plutôt que recréé ici : l'animation doit partir au
  /// moment exact de la validation, pas à la construction du bandeau.
  final AnimationController pulse;

  /// `true` quand cette page est celle que l'utilisateur regarde.
  ///
  /// Indispensable : `PageView.builder` construit aussi les pages voisines à
  /// l'avance. Sans ce garde-fou, la cascade de la question suivante se jouerait
  /// hors écran et serait déjà terminée à l'arrivée — l'utilisateur ne verrait
  /// jamais l'animation.
  final bool estActive;

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
    required this.pulse,
    required this.estActive,
    this.bottomSafeInset = 0,
  });

  @override
  State<_QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<_QuestionCard>
    with SingleTickerProviderStateMixin {
  // ─── Cascade d'apparition ────────────────────────────────────────────────
  //
  // Un seul `AnimationController` pilote toute la séquence ; chaque élément lit
  // une fenêtre différente de sa progression via un `Interval`. L'alternative —
  // un contrôleur et un `Timer` par élément — multiplierait les tickers par le
  // nombre d'options, sur chaque page vivante du `PageView`.
  // Les deux seuls réglages du rythme.
  //   `_msElement`  : durée du fondu d'un élément.
  //   `_msDecalage` : écart entre le départ de deux éléments consécutifs.
  // Total = _msDecalage × (nombre d'éléments − 1) + _msElement.
  // Sur un QCM à 4 choix : 3 × 130 + 420 = 940 ms.
  static const int _msElement = 420;
  static const int _msDecalage = 130;

  /// Titre + sous-titre éventuel + options.
  int get _nbElements =>
      1 + (_shouldShowSub(widget.question.sub) ? 1 : 0) + widget.options.length;

  int get _msTotal => _msDecalage * (_nbElements - 1) + _msElement;

  late final AnimationController _cascade = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: _msTotal),
  );

  bool get _mouvementReduit => WidgetsBinding
      .instance
      .platformDispatcher
      .accessibilityFeatures
      .disableAnimations;

  @override
  void initState() {
    super.initState();
    if (_mouvementReduit) {
      // Accessibilité : on saute directement à l'état final, jamais à un état
      // invisible.
      _cascade.value = 1;
    } else if (widget.estActive) {
      _cascade.forward();
    }
  }

  @override
  void didUpdateWidget(_QuestionCard old) {
    super.didUpdateWidget(old);

    // Le nombre d'options peut changer si la question est remplacée sur le même
    // index : la durée totale doit suivre, sinon les intervalles se décalent.
    final duree = Duration(milliseconds: _msTotal);
    if (_cascade.duration != duree) _cascade.duration = duree;

    if (_mouvementReduit) {
      _cascade.value = 1;
      return;
    }

    // La page vient de devenir celle qu'on regarde : la cascade démarre en même
    // temps que le glissement horizontal du PageView, puisque `_index` est mis à
    // jour avant l'appel à `nextPage`.
    if (!old.estActive && widget.estActive) {
      _cascade
        ..reset()
        ..forward();
    }

    // Le bandeau vient d'apparaître sur la page qu'on regarde.
    if (!old.showOutcome && widget.showOutcome && widget.estActive) {
      _revelerBandeau();
    }
  }

  @override
  void dispose() {
    _cascade.dispose();
    _colonne.dispose();
    super.dispose();
  }

  /// Contrôleur de la colonne, pour amener le bandeau de correction dans le
  /// champ de vision. Sans lui, sur un énoncé long, l'explication naissait sous
  /// le pli : l'utilisateur devait scroller au moment précis où il veut savoir
  /// pourquoi il s'est trompé.
  final ScrollController _colonne = ScrollController();

  /// Ancre posée sur le bandeau, cible du défilement.
  final GlobalKey _ancreBandeau = GlobalKey();

  void _revelerBandeau() {
    // Après la frame qui vient d'insérer le bandeau : avant, sa position
    // n'existe pas encore.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = _ancreBandeau.currentContext;
      if (ctx == null || !_colonne.hasClients) return;
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOutCubic,
        // 0.9 plutôt que 1.0 : le bandeau se cale vers le bas de la zone
        // visible, en gardant les options au-dessus dans le champ. L'utilisateur
        // voit sa réponse et l'explication d'un même coup d'œil.
        alignment: 0.9,
      );
    });
  }

  /// Fenêtre d'animation du n-ième élément de la séquence.
  Animation<double> _fenetre(int rang) {
    final total = _msTotal;
    final debut = (_msDecalage * rang) / total;
    final fin = (_msDecalage * rang + _msElement) / total;
    return CurvedAnimation(
      parent: _cascade,
      curve: Interval(
        debut.clamp(0.0, 1.0),
        fin.clamp(0.0, 1.0),
        curve: Curves.easeOutCubic,
      ),
    );
  }

  /// Énoncé nettoyé de l'énumération des options.
  ///
  /// Beaucoup de questions générées répètent les réponses dans leur libellé :
  /// « Quelle région est réputée pour les vins de Bordeaux : Auvergne-Rhône-Alpes,
  /// Centre-Val de Loire, Martinique ou Nouvelle-Aquitaine ? » — puis les quatre
  /// mêmes options s'affichent juste en dessous. Le titre double de hauteur et la
  /// question perd sa force.
  ///
  /// La coupe est **conservatrice**, parce qu'on touche à du contenu :
  ///  * il faut un `:` et du texte après ;
  ///  * **toutes** les options doivent apparaître dans ce qui suit le `:` ;
  ///  * la partie conservée doit rester une vraie question (≥ 15 caractères) ;
  ///  * aucune option ne doit faire moins de 4 caractères — « oui », « non »,
  ///    « 12 » se retrouvent par hasard dans n'importe quelle phrase, et une
  ///    correspondance fortuite couperait un énoncé légitime.
  /// Si une seule condition manque, le libellé est rendu intact.
  String get _enonceAffiche {
    final brut = widget.question.question.trim();
    final coupe = brut.lastIndexOf(':');
    if (coupe <= 0 || coupe >= brut.length - 1) return brut;

    final avant = brut.substring(0, coupe).trim();
    final apres = brut.substring(coupe + 1).toLowerCase();
    if (avant.length < 15) return brut;

    for (final o in widget.options) {
      final option = o.trim();
      if (option.length < 4) return brut;
      if (!apres.contains(option.toLowerCase())) return brut;
    }

    // On restitue la ponctuation interrogative, que la coupe vient d'emporter.
    return avant.endsWith('?') ? avant : '$avant ?';
  }

  /// Taille du titre, réduite quand l'énoncé s'allonge.
  ///
  /// `_Brand.h1` impose 28 px. Combiné à un énoncé long et à un réglage système
  /// de texte à 130 %, les options passaient sous le pli, voire hors écran. On
  /// dégrade par palier plutôt que d'autoriser un débordement.
  double _tailleTitre(String enonce) {
    if (enonce.length > 150) return 21;
    if (enonce.length > 110) return 23;
    if (enonce.length > 75) return 25;
    return 28;
  }

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
    // Rang dans la cascade : le titre ouvre, le sous-titre suit s'il
    // existe, puis les options dans l'ordre d'affichage.
    var rangCascade = 0;
    final textCol = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : _Brand.textDark;

    final sub = widget.question.sub?.trim();
    final afficheSub = _shouldShowSub(sub);
    final enonce = _enonceAffiche;

    // Rang dans la cascade : le titre ouvre, le sous-titre suit s'il existe,
    // puis les widget.options dans l'ordre d'affichage.
    var rang = 0;

    return SingleChildScrollView(
      controller: _colonne,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.only(top: 8, bottom: 12 + widget.bottomSafeInset),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ElementCascade(
            animation: _fenetre(rang++),
            child: Text(
              enonce,
              style: _Brand.h1(
                context,
              ).copyWith(color: textCol, fontSize: _tailleTitre(enonce)),
            ),
          ),

          // ✅ Sous-titre uniquement si pertinent (et pas un tag technique)
          if (afficheSub) ...[
            const SizedBox(height: 6),
            _ElementCascade(
              animation: _fenetre(rang++),
              child: Text(
                sub!, // safe car _shouldShowSub(sub) => sub non null & non vide
                style: TextStyle(
                  color: textCol.withAlpha(180),
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ],

          const SizedBox(height: 16),

          ...widget.options.map((o) {
            final isSel = widget.selected == o;
            final correctShown =
                widget.showOutcome && o == widget.question.answer;
            final wrongShown =
                widget.showOutcome && isSel && o != widget.question.answer;

            return _ElementCascade(
              animation: _fenetre(rang++),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _OptionTile(
                  label: o,
                  selected: isSel,
                  locked: widget.locked,
                  correct: correctShown,
                  wrong: wrongShown,
                  onTap: () => widget.onSelect(o),
                ),
              ),
            );
          }),

          // Hors cascade : le bandeau appartient au moment de la validation, pas
          // à l'arrivée de la widget.question. Il garde son fondu propre et son icône
          // qui rebondit.
          AnimatedSwitcher(
            key: _ancreBandeau,
            duration: const Duration(milliseconds: 280),
            switchInCurve: Curves.easeOutCubic,
            layoutBuilder: (currentChild, previousChildren) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (currentChild != null) currentChild,
                ...previousChildren,
              ],
            ),
            child: widget.showOutcome
                ? _OutcomeCard(
                    key: ValueKey<bool>(widget.isCorrect),
                    good: widget.isCorrect,
                    explanation: widget.question.explanation,
                    pulse: widget.pulse,
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

/// Un élément de la cascade : fondu simultané d'une montée de 10 px.
///
/// `FadeTransition` gère l'opacité sans reconstruire quoi que ce soit, et
/// l'`AnimatedBuilder` reçoit son enfant via `child:` — seul le `Transform` est
/// rebâti à chaque frame, jamais l'option ni son texte.
///
/// Le décalage est en pixels et non en fraction de hauteur (ce que ferait un
/// `SlideTransition`) : le titre et une option n'ont pas la même hauteur, et une
/// fraction commune produirait des amplitudes différentes.
class _ElementCascade extends StatelessWidget {
  const _ElementCascade({required this.animation, required this.child});

  final Animation<double> animation;
  final Widget child;

  static const double _monteeDepart = 10.0;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: AnimatedBuilder(
        animation: animation,
        child: child,
        builder: (_, enfant) => Transform.translate(
          offset: Offset(0, _monteeDepart * (1 - animation.value)),
          child: enfant,
        ),
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

  /// Animation du feedback, partagée avec la page : elle doit partir au
  /// moment exact de la validation, pas à la construction du bandeau.
  final AnimationController pulse;

  /// Animation du feedback (0 → 1 sur 700 ms), partagée avec la page.

  const _OutcomeCard({
    super.key,
    required this.good,
    required this.explanation,
    required this.pulse,
  });

  @override
  Widget build(BuildContext context) {
    final color = good ? _Brand.good : _Brand.bad;
    final icon = good ? Icons.check_circle_rounded : Icons.cancel_rounded;

    // Dimensionnement adaptatif demandé, sur deux axes :
    //  * la largeur d'écran — 28 px fixes paraissaient gros sur un petit
    //    téléphone et perdus sur une tablette ;
    //  * le réglage de taille de texte du système — l'icône doit grandir avec
    //    l'explication qu'elle accompagne, sinon elle décroche visuellement.
    // Les deux bornes évitent qu'un réglage extrême ne casse la mise en page.
    final largeur = MediaQuery.sizeOf(context).width;
    final scaler = MediaQuery.textScalerOf(context);
    final double tailleIcone = scaler
        .scale((largeur / 13.5).clamp(24.0, 34.0))
        .clamp(24.0, 52.0);

    // La zone du feedback est carrée et un peu plus large que l'icône : les
    // étincelles s'y déploient sans jamais empiéter sur le texte, puisqu'elles
    // sont bornées par ce `SizedBox` et non posées en overlay.
    final zone = tailleIcone * 1.7;

    // Alignement optique du texte sur l'icône.
    //
    // L'icône est centrée dans une zone de `zone` px ; son centre est donc à
    // `zone / 2`. Pour que la **première ligne** du texte soit à la même
    // hauteur, on la décale de ce centre moins sa demi-hauteur de ligne
    // (`fontSize × height`). `fontSize` est déclaré explicitement plus bas au
    // lieu d'être hérité, sans quoi ce calcul reposerait sur une valeur de
    // thème invisible ici.
    const double tailleTexte = 14.0;
    const double hauteurLigne = 1.32;
    final double demiLigne = scaler.scale(tailleTexte) * hauteurLigne / 2;
    final double decalageTexte = (zone / 2 - demiLigne).clamp(0.0, 24.0);

    // Un seul objet peint, une seule boîte.
    //
    // Avant, le contour venait du `shape` d'un `Material` et le fond d'un
    // `Container` enfant portant `margin: top 10`. Deux boîtes différentes,
    // décalées de 10 px : le `Material` dessinait donc son bord *autour de la
    // marge*, ce qui produisait un liseré vide au-dessus de la carte colorée —
    // le « bandeau hors de la carte ». La marge est maintenant à l'extérieur du
    // widget bordé, et bord + fond partagent la même `BoxDecoration`.
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _opa(color, .10),
          // 22 comme `_OptionTile` : le bandeau est collé sous la dernière
          // option, à largeur identique. Avec 16, la rupture de rayon se voyait
          // sur les quatre coins.
          borderRadius: BorderRadius.circular(22),
          // Contour strictement uniforme : indispensable avec un borderRadius.
          border: Border.all(color: _opa(color, .55), width: 1.2),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: zone,
              height: zone,
              child: _OutcomeIcon(
                controller: pulse,
                icon: icon,
                color: color,
                tailleIcone: tailleIcone,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: decalageTexte),
                child: Text(
                  explanation,
                  softWrap: true,
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : _Brand.textDark,
                    fontWeight: FontWeight.w600,
                    fontSize: tailleTexte,
                    height: hauteurLigne,
                    decoration: TextDecoration.none,
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

/// Icône de résultat animée : rebond à l'apparition, puis étincelles qui
/// s'écartent et s'effacent. Remplace l'ancienne croix flottante de 240 px, qui
/// se posait en overlay au-dessus de la page et chevauchait l'explication.
class _OutcomeIcon extends StatelessWidget {
  const _OutcomeIcon({
    required this.controller,
    required this.icon,
    required this.color,
    required this.tailleIcone,
  });

  final AnimationController controller;
  final IconData icon;
  final Color color;
  final double tailleIcone;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: controller,
        builder: (_, __) {
          final t = controller.value.clamp(0.0, 1.0);

          const n = 6;
          final rayonMax = tailleIcone * 0.72;
          final etincelles = <Widget>[];

          // Au repos (animation terminée) on ne peint plus que l'icône : aucune
          // couche inutile ne subsiste dans l'arbre de rendu.
          if (t < 0.999) {
            for (var i = 0; i < n; i++) {
              final angle = (i / n) * 2 * math.pi;
              final r = rayonMax * t;
              etincelles.add(
                Transform.translate(
                  offset: Offset(r * math.cos(angle), r * math.sin(angle)),
                  child: Transform.scale(
                    scale: 0.3 + t * 0.7,
                    child: Opacity(
                      opacity: (1 - t).clamp(0.0, 1.0),
                      child: _Star(color: color, size: tailleIcone * 0.22),
                    ),
                  ),
                ),
              );
            }
          }

          // Rebond : dépassement à ~1,18 puis retour à 1. `Curves.elasticOut`
          // serait trop remuant à côté d'un texte qu'on veut lire.
          final echelle = 0.7 + Curves.easeOutBack.transform(t) * 0.3;

          return Stack(
            alignment: Alignment.center,
            children: [
              ...etincelles,
              Transform.scale(
                scale: echelle,
                child: Icon(icon, color: color, size: tailleIcone),
              ),
            ],
          );
        },
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

// `_FeedbackStrip` et `_FeedbackSparkles` ont été supprimés : l'animation de
// résultat vit désormais dans `_OutcomeIcon`, à l'intérieur du bandeau
// d'explication. `_Star` est conservé, il sert aux étincelles.
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
    with SingleTickerProviderStateMixin {
  // ─── Cascade d'ouverture ─────────────────────────────────────────────────
  //
  // Même mécanique et même widget (`_ElementCascade`) que l'arrivée d'une
  // question : un seul contrôleur, chaque élément lisant une fenêtre différente
  // de sa progression via un `Interval`. Les deux écrans partagent donc
  // exactement le même geste — fondu plus montée de 10 px.
  //
  // Rythme légèrement plus serré qu'en question (380/90 contre 420/130) : ici la
  // séquence compte sept éléments, et une ouverture d'écran ne doit pas se faire
  // attendre.
  static const int _msElement = 380;
  static const int _msDecalage = 90;

  // Rangs explicites plutôt qu'un compteur incrémenté pendant le build : le
  // `LayoutBuilder` des cartes peut être rappelé à chaque relayout, et un
  // compteur mutable y dériverait à chaque passe.
  static const int _rangTitre = 0;
  static const int _rangSousTitre = 1;
  static const int _rangFacile = 2;
  static const int _rangMoyen = 3;
  static const int _rangDifficile = 4;
  static const int _rangCommencer = 5;
  static const int _rangMelanger = 6;
  static const int _nbElements = 7;

  late final AnimationController _entree = AnimationController(
    vsync: this,
    duration: const Duration(
      milliseconds: _msDecalage * (_nbElements - 1) + _msElement,
    ),
  );

  @override
  void initState() {
    super.initState();
    final reduit = WidgetsBinding
        .instance
        .platformDispatcher
        .accessibilityFeatures
        .disableAnimations;
    // Comme ailleurs : on saute à l'état final, jamais à un écran vide.
    if (reduit) {
      _entree.value = 1;
    } else {
      _entree.forward();
    }
  }

  @override
  void dispose() {
    _entree.dispose();
    super.dispose();
  }

  Animation<double> _fenetre(int rang) {
    final total = _msDecalage * (_nbElements - 1) + _msElement;
    final debut = (_msDecalage * rang) / total;
    final fin = (_msDecalage * rang + _msElement) / total;
    return CurvedAnimation(
      parent: _entree,
      curve: Interval(
        debut.clamp(0.0, 1.0),
        fin.clamp(0.0, 1.0),
        curve: Curves.easeOutCubic,
      ),
    );
  }

  // Deux contrôleurs ont été supprimés de cet écran.
  //
  // `_bgCtrl` pilotait le dégradé et les halos propres au splash, remplacés par
  // le `_QuizBackdrop` de la page : plus aucun widget ne l'écoutait, mais il
  // restait en `repeat()` et planifiait un tick à chaque frame pour repeindre
  // zéro pixel.
  //
  // `_floatCtrl` faisait osciller les trois cartes de ±2 px en continu. Un
  // mouvement permanent sur des éléments qu'on doit comparer avant de choisir :
  // les écarts entre cartes variaient en permanence, et rien n'était jamais
  // aligné. Les cartes sont désormais fixes, à espacement constant.
  //
  // Conséquence directe : plus aucun ticker ne tourne sur cet écran une fois le
  // fondu d'entrée terminé.

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
            // Aucun fond propre : le splash laisse voir le `_QuizBackdrop` de la
            // page, qu'il recouvre.
            //
            // Il empilait auparavant son propre dégradé anthracite
            // (`#0B0C10 → #11131A`) et trois halos, par-dessus le navy du quiz :
            // deux systèmes d'animation de fond superposés, et une rupture de
            // teinte au démarrage du quiz. Un seul fond pour tout l'écran, donc
            // aucune transition de couleur — et trois `AnimatedBuilder` de moins
            // qui repeignent en continu.
            //
            // Un voile très léger détache malgré tout le contenu du fond.
            Positioned.fill(
              child: IgnorePointer(
                child: ColoredBox(
                  color: Colors.black.withValues(alpha: isDark ? .28 : .04),
                ),
              ),
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
                        _ElementCascade(
                          animation: _fenetre(_rangTitre),
                          child: Text(
                            'Sélectionne le niveau de difficulté',
                            textAlign: TextAlign.center,
                            style: _Brand.h1(
                              context,
                            ).copyWith(color: textMain, fontSize: 24),
                          ),
                        ),
                        const SizedBox(height: 8),
                        _ElementCascade(
                          animation: _fenetre(_rangSousTitre),
                          child: Text(
                            // L'ancien sous-titre énumérait « Facile, Moyen ou
                            // Difficile » juste au-dessus des trois cartes qui
                            // portent ces mêmes mots. On dit maintenant ce que les
                            // cartes ne disent pas : la banque est immense, donc
                            // les questions ne se répètent pas d'une partie à
                            // l'autre.
                            'Nouvelles questions à chaque partie.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: sub,
                              fontWeight: FontWeight.w600,
                              height: 1.3,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        LayoutBuilder(
                          builder: (ctx, c) {
                            final wide = c.maxWidth >= 420;
                            const spacing = 12.0;
                            final itemW = wide
                                ? (c.maxWidth - spacing * 2) / 3
                                : c.maxWidth;

                            final children = [
                              // Teintes franches, et surtout **les mêmes que
                              // celles des cas pratiques** (`_difficultyStyle`) :
                              // vert #22C55E, ambre #F59E0B, rouge #EF4444. Un
                              // niveau « Difficile » a désormais la même couleur
                              // dans tout COP'IQ, quiz comme cas pratiques.
                              //
                              // Les pastels précédents (#B7F0C1, #FCE7B2,
                              // #F8C2BE) étaient trop lavés pour distinguer les
                              // trois cartes d'un coup d'œil sur fond navy.
                              _ElementCascade(
                                animation: _fenetre(_rangFacile),
                                child: _LevelCard(
                                  label: 'Facile',
                                  icon: Icons.eco_rounded,
                                  tint: const Color(0xFF22C55E),
                                  active: widget.selected == 'Facile',
                                  onTap: () => widget.onSelect('Facile'),
                                  isDark: isDark,
                                ),
                              ),
                              _ElementCascade(
                                animation: _fenetre(_rangMoyen),
                                child: _LevelCard(
                                  label: 'Moyen',
                                  icon: Icons.military_tech_rounded,
                                  tint: const Color(0xFFF59E0B),
                                  active: widget.selected == 'Moyenne',
                                  onTap: () => widget.onSelect('Moyenne'),
                                  isDark: isDark,
                                ),
                              ),
                              _ElementCascade(
                                animation: _fenetre(_rangDifficile),
                                child: _LevelCard(
                                  label: 'Difficile',
                                  icon: Icons.emoji_events_rounded,
                                  tint: const Color(0xFFEF4444),
                                  active: widget.selected == 'Difficile',
                                  onTap: () => widget.onSelect('Difficile'),
                                  isDark: isDark,
                                ),
                              ),
                            ];

                            if (wide) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(width: itemW, child: children[0]),
                                  const SizedBox(width: spacing),
                                  SizedBox(width: itemW, child: children[1]),
                                  const SizedBox(width: spacing),
                                  SizedBox(width: itemW, child: children[2]),
                                ],
                              );
                            } else {
                              return Column(
                                children: [
                                  // 12 comme `spacing` du mode large et comme
                                  // l'écart entre les options du quiz : un seul
                                  // pas d'espacement sur tout l'écran.
                                  children[0],
                                  const SizedBox(height: spacing),
                                  children[1],
                                  const SizedBox(height: spacing),
                                  children[2],
                                ],
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                        _ElementCascade(
                          animation: _fenetre(_rangCommencer),
                          child: SizedBox(
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
                              // Le verrou reste : pas de départ sans niveau. Mais
                              // un bouton gris muet laissait croire à un écran
                              // cassé — il énonce désormais ce qu'il attend, et
                              // devient « Commencer » dès qu'un niveau est choisi.
                              child: Text(
                                widget.selected == null
                                    ? 'Choisis un niveau'
                                    : 'Commencer',
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        _ElementCascade(
                          animation: _fenetre(_rangMelanger),
                          child: _ElementCascade(
                            animation: _fenetre(_rangMelanger),
                            child: SizedBox(
                              // 56 comme « Commencer ».
                              //
                              // Le bouton mesurait 52 de haut pour un rayon de 26, et
                              // son voisin 56 pour un rayon de 28. Deux pilules aux
                              // courbures différentes, empilées et de même largeur :
                              // les arcs ne se répondaient pas, ce qui donnait ce
                              // contour « faux » à l'œil. Hauteur et rayon sont
                              // maintenant identiques, 56 et 28 — exactement la
                              // moitié de la hauteur, donc une pilule parfaite.
                              height: 56,
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed: widget.onStartRandom,
                                icon: const Icon(
                                  Icons.shuffle_rounded,
                                  size: 20,
                                ),
                                // « Aléatoire » ne disait pas ce qui était tiré au
                                // hasard : les questions, ou les niveaux ?
                                label: const Text('Mélanger les 3 niveaux'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: isDark
                                      ? Colors.white
                                      : _Brand.textDark,
                                  // Léger fond : sans lui, le bouton n'était qu'un
                                  // trait posé sur le dégradé, et son contour
                                  // paraissait sale là où un halo passait derrière.
                                  backgroundColor: isDark
                                      ? _opa(Colors.white, .06)
                                      : _opa(_Brand.textDark, .03),
                                  // Contour affaibli et épaissi : à 63 % d'opacité il
                                  // pesait autant que le bouton principal alors qu'il
                                  // est l'action secondaire. À 32 % sur 1,4 px il se
                                  // lit franchement sans concurrencer « Commencer »,
                                  // et reprend l'épaisseur des autres contours du
                                  // fichier.
                                  side: BorderSide(
                                    color: isDark
                                        ? _opa(Colors.white, .32)
                                        : _opa(_Brand.textDark, .28),
                                    width: 1.4,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(28),
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

// `_AnimatedBackground` a été supprimé : c'était le dégradé anthracite propre au
// splash de difficulté, devenu inutile depuis que celui-ci laisse voir le
// `_QuizBackdrop` de la page. Un seul fond pour tout l'écran.

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

  /// Icône du niveau.
  ///
  /// Remplace un emoji (🌱 🏅 🏆) : celui-ci se rend avec la police du système,
  /// donc avec un dessin différent sur Samsung, Pixel ou iOS, sans aucun
  /// contrôle sur sa couleur ni sur son poids optique. Il jurait par ailleurs
  /// avec l'icône Material `shuffle` du bouton juste en dessous.
  final IconData icon;

  final Color tint;
  final bool active;
  final bool isDark;
  final VoidCallback onTap;

  const _LevelCard({
    required this.label,
    required this.icon,
    required this.tint,
    required this.active,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final track = _Brand.radioTrack(context);

    // Carte fixe. Le `AnimatedBuilder` + `Transform.translate` qui la faisait
    // osciller de ±2 px a été retiré : sur trois cartes à comparer, ce
    // balancement désalignait les bords en permanence.
    //
    // L'agrandissement au clic est conservé — lui répond à une action de
    // l'utilisateur, il n'est pas gratuit.
    return AnimatedScale(
      duration: const Duration(milliseconds: 180),
      scale: active ? 1.02 : 1.0,
      curve: Curves.easeOutCubic,
      // Les trois cartes forment un groupe à choix unique : un lecteur
      // d'écran annonce désormais « Facile, bouton radio, non sélectionné »
      // au lieu du seul mot « Facile », sans indication d'état.
      child: Semantics(
        inMutuallyExclusiveGroup: true,
        selected: active,
        button: true,
        label: label,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            height: 112,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              // Densité revue à la baisse : avec des teintes franches, les
              // 18 % d'origine donnaient trois aplats criards. La carte
              // sélectionnée monte en revanche à 22 % pour se détacher
              // nettement des deux autres — la bordure de 2 px ne suffisait
              // pas à porter seule l'état actif.
              color: _opa(
                tint,
                isDark ? (active ? .22 : .13) : (active ? .18 : .10),
              ),
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
                    color: _opa(tint, isDark ? .22 : .18),
                    border: Border.all(color: active ? tint : _opa(tint, .45)),
                  ),
                  child: Center(
                    child: Icon(
                      icon,
                      size: 24,
                      // Teinte pleine : sur la pastille translucide, une
                      // icône blanche perdrait l'identité du niveau. Les
                      // teintes étant désormais franches, l'assombrissement
                      // en thème clair n'a plus qu'à corriger le contraste.
                      color: isDark ? tint : _assombrir(tint, .22),
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
                    border: Border.all(color: active ? tint : track, width: 2),
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
  }
}

/// Assombrit une teinte pâle pour qu'elle reste lisible sur fond clair.
///
/// Les trois teintes de niveau sont des pastels (`#B7F0C1`, `#FCE7B2`,
/// `#F8C2BE`) : parfaites sur le navy, illisibles en thème clair où elles
/// disparaissent dans le blanc. On les rabat vers le noir plutôt que d'entretenir
/// une seconde palette à maintenir en parallèle.
Color _assombrir(Color c, [double facteur = .45]) =>
    Color.lerp(c, Colors.black, facteur)!;
