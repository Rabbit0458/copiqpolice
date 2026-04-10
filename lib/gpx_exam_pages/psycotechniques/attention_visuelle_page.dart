import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vibration/vibration.dart';

import 'package:copiqpolice/ui/app_notifier.dart'
    show AppNotifier, AppSettingsController;

Color _opa(Color c, double a) => c.withValues(alpha: a);

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

class AttentionVisuellePage extends StatefulWidget {
  const AttentionVisuellePage({super.key});

  static const String routeName =
      '/gpx_exam/concours/tests_psychotechniques/attention_visuelle';

  @override
  State<AttentionVisuellePage> createState() => _AttentionVisuellePageState();
}

class _AttentionVisuellePageState extends State<AttentionVisuellePage>
    with TickerProviderStateMixin {
  final SupabaseClient supabase = Supabase.instance.client;
  final Random _random = Random();

  static const int questionDuration = 5;
  static const int afkStopLimit = 10;
  static const String _introHiddenKey =
      'attention_visuelle_intro_hidden_forever_v3';

  List<Map<String, dynamic>> allQuestions = [];
  List<Map<String, dynamic>> filteredQuestions = [];
  List<int> shuffledIndexes = [];
  int shuffledCursor = 0;
  int? lastQuestionIndex;

  Map<String, dynamic>? currentQuestion;
  int? currentQuestionIndex;

  int currentIndex = 1;
  int totalQuestions = 0;
  int availableForSelectedDifficulty = 0;

  int correctAnswers = 0;
  int totalAnswers = 0;
  int consecutiveAfkTimeouts = 0;

  bool isLoading = true;
  bool showResult = false;
  bool isCorrect = false;
  bool isTimedOut = false;
  bool isSaving = false;
  bool hideIntroForever = false;

  String? selectedDifficulty;
  bool randomMode = false;
  bool showDifficultyScreen = true;
  bool showIntroScreen = false;

  bool answerLocked = false;
  bool? selectedAnswer;

  DateTime? startTime;
  DateTime? sessionStartedAt;
  final List<double> responseTimes = [];

  late AnimationController timerController;
  late AnimationController ambientController;
  late AnimationController resultController;
  late AnimationController pulseController;
  late AnimationController questionSwapController;
  late final AnimationController _difficultySplashCtrl;
  late final Animation<double> _difficultySplashFade;

  late final AudioPlayer _goodSfx;
  late final AudioPlayer _badSfx;

  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    timerController =
        AnimationController(
          vsync: this,
          duration: const Duration(seconds: questionDuration),
        )..addStatusListener((status) {
          if (status == AnimationStatus.completed && !showResult) {
            answer(false, timeout: true);
          }
        });

    ambientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..repeat();

    resultController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );

    pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );

    questionSwapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    )..forward();

    _difficultySplashCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
    _difficultySplashFade = CurvedAnimation(
      parent: _difficultySplashCtrl,
      curve: Curves.easeOutCubic,
    );

    _goodSfx = AudioPlayer()
      ..setReleaseMode(ReleaseMode.stop)
      ..setPlayerMode(PlayerMode.lowLatency);
    _badSfx = AudioPlayer()
      ..setReleaseMode(ReleaseMode.stop)
      ..setPlayerMode(PlayerMode.lowLatency);

    unawaited(_bootstrap());
  }

  @override
  void dispose() {
    timerController.dispose();
    ambientController.dispose();
    resultController.dispose();
    pulseController.dispose();
    questionSwapController.dispose();
    _difficultySplashCtrl.dispose();
    _goodSfx.dispose();
    _badSfx.dispose();
    super.dispose();
  }

  Future<void> _bootstrap() async {
    await _loadIntroPreference();
    await loadQuestions();
  }

  Future<void> _loadIntroPreference() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      hideIntroForever = prefs.getBool(_introHiddenKey) ?? false;
    });
  }

  Future<void> _saveIntroPreference(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_introHiddenKey, value);
    if (!mounted) return;
    setState(() {
      hideIntroForever = value;
    });
  }

  bool _isDark(BuildContext context) {
    final mode = AppSettingsController.I.themeMode.value;
    if (mode == ThemeMode.dark) return true;
    if (mode == ThemeMode.light) return false;
    return MediaQuery.platformBrightnessOf(context) == Brightness.dark;
  }

  Color _pageBg(BuildContext context) =>
      _isDark(context) ? const Color(0xFF08111D) : const Color(0xFFF4F7FB);

  Color _surface(BuildContext context) =>
      _isDark(context) ? const Color(0xFF101826) : Colors.white;

  Color _surfaceAlt(BuildContext context) =>
      _isDark(context) ? const Color(0xFF121D2E) : const Color(0xFFF8FAFF);

  Color _textPrimary(BuildContext context) =>
      _isDark(context) ? const Color(0xFFF5F7FA) : const Color(0xFF18202F);

  Color _textSecondary(BuildContext context) =>
      _isDark(context) ? const Color(0xFFA9B5C7) : const Color(0xFF667085);

  Color _border(BuildContext context) =>
      _isDark(context) ? const Color(0xFF253247) : const Color(0xFFE3EAF5);

  Color _shadow(BuildContext context) => _isDark(context)
      ? Colors.black.withValues(alpha: 0.34)
      : Colors.black.withValues(alpha: 0.08);

  Color _dialogBg(BuildContext context) =>
      _isDark(context) ? const Color(0xFF101826) : Colors.white;

  Color _accent(BuildContext context) =>
      _isDark(context) ? const Color(0xFF8C93FF) : const Color(0xFF5E6CFF);

  Color _accentSecondary(BuildContext context) =>
      _isDark(context) ? const Color(0xFF7AE3FF) : const Color(0xFF59A6FF);

  Color _difficultyColor(String difficulty) {
    switch (difficulty) {
      case 'Facile':
        return const Color(0xFF22C55E);
      case 'Moyenne':
        return const Color(0xFFF59E0B);
      case 'Difficile':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF5E6CFF);
    }
  }

  Color _getTimerColor(double progress) {
    if (progress < 0.34) {
      return Color.lerp(
        const Color(0xFF22C55E),
        const Color(0xFFEAB308),
        progress / 0.34,
      )!;
    }
    if (progress < 0.67) {
      return Color.lerp(
        const Color(0xFFEAB308),
        const Color(0xFFF97316),
        (progress - 0.34) / 0.33,
      )!;
    }
    return Color.lerp(
      const Color(0xFFF97316),
      const Color(0xFFEF4444),
      (progress - 0.67) / 0.33,
    )!;
  }

  String _normalizedDifficulty(dynamic raw) {
    final value = (raw ?? '').toString().trim().toLowerCase();
    if (value.startsWith('fac')) return 'Facile';
    if (value.startsWith('moy')) return 'Moyenne';
    if (value.startsWith('dif')) return 'Difficile';
    return '';
  }

  Future<void> _playAnswerSfx(bool good) async {
    try {
      final p = good ? _goodSfx : _badSfx;
      final asset = good ? 'sfx/correct_answer.mp3' : 'sfx/wrong_answer.mp3';
      unawaited(p.stop());
      unawaited(p.play(AssetSource(asset), mode: PlayerMode.lowLatency));
      debugPrint('🔊 SFX queued -> $asset');
    } catch (e, st) {
      debugPrint('❌ SFX error: $e');
      debugPrint('$st');
    }
  }

  Future<void> loadQuestions() async {
    try {
      final data = await supabase
          .from('tests_psyco_attention_visuelle')
          .select()
          .eq('is_active', true);

      allQuestions = List<Map<String, dynamic>>.from(data);
      totalQuestions = allQuestions.length;
      _recalculateAvailableCount();

      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    } catch (e, st) {
      debugPrint('❌ loadQuestions error: $e');
      debugPrint('$st');
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      AppNotifier.error(
        context,
        title: 'Erreur de chargement',
        message: 'Impossible de récupérer les questions.',
      );
    }
  }

  void _recalculateAvailableCount() {
    if (randomMode || selectedDifficulty == null) {
      availableForSelectedDifficulty = totalQuestions;
      return;
    }
    availableForSelectedDifficulty = allQuestions
        .where(
          (q) => _normalizedDifficulty(q['difficulty']) == selectedDifficulty,
        )
        .length;
  }

  void _buildNewShuffle() {
    shuffledIndexes = List<int>.generate(filteredQuestions.length, (i) => i);
    shuffledIndexes.shuffle(_random);

    if (lastQuestionIndex != null &&
        shuffledIndexes.isNotEmpty &&
        shuffledIndexes.first == lastQuestionIndex &&
        shuffledIndexes.length > 1) {
      final swapWith = 1 + _random.nextInt(shuffledIndexes.length - 1);
      final temp = shuffledIndexes[0];
      shuffledIndexes[0] = shuffledIndexes[swapWith];
      shuffledIndexes[swapWith] = temp;
    }
    shuffledCursor = 0;
  }

  int _getNextQuestionIndex() {
    if (shuffledIndexes.isEmpty) {
      throw Exception('Aucune question disponible');
    }
    if (shuffledCursor >= shuffledIndexes.length) {
      _buildNewShuffle();
    }

    int nextIndex = shuffledIndexes[shuffledCursor];
    shuffledCursor++;

    if (lastQuestionIndex != null &&
        nextIndex == lastQuestionIndex &&
        shuffledCursor < shuffledIndexes.length) {
      final altIndex = shuffledIndexes[shuffledCursor];
      shuffledIndexes[shuffledCursor - 1] = altIndex;
      shuffledIndexes[shuffledCursor] = nextIndex;
      nextIndex = altIndex;
      shuffledCursor++;
    }
    return nextIndex;
  }

  void _prepareQuestionsForSession() {
    if (randomMode || selectedDifficulty == null) {
      filteredQuestions = List<Map<String, dynamic>>.from(allQuestions);
    } else {
      filteredQuestions = allQuestions
          .where(
            (q) => _normalizedDifficulty(q['difficulty']) == selectedDifficulty,
          )
          .toList();
    }
    availableForSelectedDifficulty = filteredQuestions.length;
    _buildNewShuffle();
  }

  Future<void> _startExercise() async {
    if (!randomMode && selectedDifficulty == null) {
      AppNotifier.info(
        context,
        title: 'Choisis un niveau',
        message: 'Sélectionne une difficulté pour commencer.',
      );
      return;
    }

    _prepareQuestionsForSession();
    if (filteredQuestions.isEmpty) {
      AppNotifier.warning(
        context,
        title: 'Aucune question',
        message: 'Aucune question disponible pour ce niveau.',
      );
      return;
    }

    if (hideIntroForever) {
      _beginSessionNow();
    } else {
      setState(() {
        showDifficultyScreen = false;
        showIntroScreen = true;
      });
    }
  }

  void _beginSessionNow() {
    sessionStartedAt = DateTime.now();
    correctAnswers = 0;
    totalAnswers = 0;
    consecutiveAfkTimeouts = 0;
    currentIndex = 1;
    responseTimes.clear();
    showResult = false;
    isCorrect = false;
    isTimedOut = false;
    isSaving = false;
    answerLocked = false;
    selectedAnswer = null;
    showIntroScreen = false;
    showDifficultyScreen = false;
    nextQuestion();
    if (mounted) setState(() {});
  }

  void nextQuestion() {
    if (filteredQuestions.isEmpty) return;

    currentQuestionIndex = _getNextQuestionIndex();
    currentQuestion = filteredQuestions[currentQuestionIndex!];
    lastQuestionIndex = currentQuestionIndex;

    showResult = false;
    isTimedOut = false;
    answerLocked = false;
    selectedAnswer = null;
    startTime = DateTime.now();

    resultController.reset();
    pulseController.reset();
    questionSwapController.forward(from: 0);
    timerController
      ..reset()
      ..forward();

    if (mounted) setState(() {});
  }

  Future<void> answer(bool userAnswer, {bool timeout = false}) async {
    if (showResult || currentQuestion == null || isSaving || answerLocked)
      return;

    timerController.stop();
    answerLocked = true;
    selectedAnswer = timeout ? null : userAnswer;

    final correct = currentQuestion!['is_true'] == true;
    final responseTime =
        DateTime.now().difference(startTime!).inMilliseconds / 1000;
    responseTimes.add(responseTime);

    isTimedOut = timeout;
    isCorrect = !timeout && userAnswer == correct;

    if (timeout) {
      consecutiveAfkTimeouts++;
    } else {
      consecutiveAfkTimeouts = 0;
    }

    HapticFeedback.selectionClick();
    unawaited(_playAnswerSfx(isCorrect));
    if (await Vibration.hasVibrator() == true) {
      Vibration.vibrate(duration: isCorrect ? 35 : 100);
    }

    if (isCorrect) {
      correctAnswers++;
    }
    totalAnswers++;

    if (!mounted) return;
    setState(() {
      showResult = true;
    });

    resultController.forward(from: 0);
    pulseController.forward(from: 0);

    final bool shouldAutoStopAfk = consecutiveAfkTimeouts >= afkStopLimit;
    if (shouldAutoStopAfk) {
      debugPrint(
        '🛑 Série arrêtée automatiquement après $consecutiveAfkTimeouts timeouts consécutifs.',
      );
    }

    Future.delayed(const Duration(milliseconds: 720), () async {
      if (!mounted) return;
      if (shouldAutoStopAfk) {
        await endGame(autoStoppedByAfk: true);
        return;
      }
      currentIndex = totalAnswers + 1;
      questionSwapController.reverse(from: 1);
      Future.delayed(const Duration(milliseconds: 90), () {
        if (!mounted) return;
        nextQuestion();
      });
    });
  }

  Future<void> stopSeries() async {
    if (isSaving) return;

    timerController.stop();

    final shouldStop = await showDialog<bool>(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: _dialogBg(context),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 54,
                  width: 54,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _surfaceAlt(context),
                    border: Border.all(color: _border(context)),
                  ),
                  child: Icon(
                    Icons.pause_circle_outline_rounded,
                    color: _textPrimary(context),
                    size: 28,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Arrêter la série ?',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: _textPrimary(context),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Votre progression actuelle sera sauvegardée.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.45,
                    color: _textSecondary(context),
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.none,
                  ),
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context, false),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(52),
                          side: BorderSide(color: _border(context)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          'Continuer',
                          style: TextStyle(
                            color: _textPrimary(context),
                            fontWeight: FontWeight.w700,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: FilledButton.styleFrom(
                          backgroundColor: _accent(context),
                          foregroundColor: Colors.white,
                          minimumSize: const Size.fromHeight(52),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Arrêter',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    if (shouldStop == true) {
      await endGame(stoppedByUser: true);
    } else if (!showResult) {
      timerController.forward();
    }
  }

  Future<void> endGame({
    bool stoppedByUser = false,
    bool autoStoppedByAfk = false,
  }) async {
    if (isSaving) return;

    isSaving = true;
    timerController.stop();

    final user = supabase.auth.currentUser;
    final totalDuration = responseTimes.fold(0.0, (a, b) => a + b);
    final avgTime = responseTimes.isEmpty
        ? 0.0
        : totalDuration / responseTimes.length;

    try {
      final payload = {
        'user_id': user?.id,
        'exercise_type': 'attention_visuelle',
        'module': 'psychotechnique',
        'score': correctAnswers,
        'correct_answers': correctAnswers,
        'wrong_answers': totalAnswers - correctAnswers,
        'total_questions': totalAnswers,
        'duration_seconds': totalDuration.round(),
        'avg_response_time': double.parse(avgTime.toStringAsFixed(2)),
        'mode': 'concours',
      };

      await supabase.from('tests_psychotechnique_history').insert(payload);
    } catch (e, st) {
      debugPrint('❌ Erreur sauvegarde tests_psychotechnique_history: $e');
      debugPrint('$st');
      if (mounted) {
        AppNotifier.error(
          context,
          title: 'Erreur de sauvegarde',
          message: '$e',
        );
      }
    }

    if (!mounted) return;

    final int accuracyRounded = totalAnswers == 0
        ? 0
        : ((correctAnswers / totalAnswers) * 100).round();

    final bool great = accuracyRounded >= 80;
    final bool medium = accuracyRounded >= 50 && accuracyRounded < 80;

    final Color accent = great
        ? const Color(0xFF22C55E)
        : medium
        ? const Color(0xFFF59E0B)
        : const Color(0xFFEF4444);

    final Color accentSoft = great
        ? const Color(0xFFDCFCE7)
        : medium
        ? const Color(0xFFFEF3C7)
        : const Color(0xFFFEE2E2);

    final IconData heroIcon = autoStoppedByAfk
        ? Icons.pause_rounded
        : great
        ? Icons.emoji_events_rounded
        : medium
        ? Icons.trending_up_rounded
        : Icons.refresh_rounded;

    final String title = autoStoppedByAfk
        ? 'Série arrêtée automatiquement'
        : stoppedByUser
        ? 'Série arrêtée'
        : great
        ? 'Excellent rythme'
        : medium
        ? 'Tu progresses'
        : 'Relance une série';

    final String subtitle = autoStoppedByAfk
        ? '10 questions sans réponse d’affilée ont été détectées.'
        : great
        ? 'Très bon niveau d’attention et de rapidité.'
        : medium
        ? 'Tu es sur la bonne voie. Une nouvelle série peut faire grimper ton score.'
        : 'Ce n’est pas grave. Repars tout de suite plus concentré.';

    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'Résultats',
      barrierColor: Colors.black.withValues(alpha: .35),
      transitionDuration: const Duration(milliseconds: 280),
      pageBuilder: (_, __, ___) {
        return Stack(
          children: [
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                child: const SizedBox.expand(),
              ),
            ),
            _CopiqResultDialog(
              correctAnswers: correctAnswers,
              totalAnswers: totalAnswers,
              totalDuration: totalDuration,
              avgTime: avgTime,
              accuracy: accuracyRounded,
              autoStoppedByAfk: autoStoppedByAfk,
              stoppedByUser: stoppedByUser,
              accent: accent,
              accentSoft: accentSoft,
              heroIcon: heroIcon,
              title: title,
              subtitle: subtitle,
              onBack: () {
                Navigator.of(context).pop();
                Navigator.of(this.context).maybePop();
              },
              onRestart: () {
                Navigator.of(context).pop();
                setState(() {
                  showDifficultyScreen = true;
                  showIntroScreen = false;
                  currentQuestion = null;
                  currentQuestionIndex = null;
                  isSaving = false;
                  showResult = false;
                });
              },
            ),
          ],
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut),
          child: ScaleTransition(
            scale: Tween<double>(
              begin: .96,
              end: 1.0,
            ).chain(CurveTween(curve: Curves.easeOutBack)).animate(anim),
            child: child,
          ),
        );
      },
    );
  }

  Map<String, dynamic>? get _reportQuestion => currentQuestion;

  Future<void> _insertReportAttentionVisuelle({
    required Map<String, dynamic> q,
    required String reportType,
    required String message,
  }) async {
    final user = supabase.auth.currentUser;
    final textA = (q['text_a'] ?? '').toString();
    final textB = (q['text_b'] ?? '').toString();
    final diff = randomMode
        ? (_normalizedDifficulty(q['difficulty']).isEmpty
              ? 'Aléatoire'
              : _normalizedDifficulty(q['difficulty']))
        : (selectedDifficulty ?? _normalizedDifficulty(q['difficulty']));

    final payload = <String, dynamic>{
      'user_uid': user?.id,
      'email': user?.email,
      'question_id': (q['id'] ?? '').toString(),
      'module': (q['module'] ?? 'psychotechnique').toString(),
      'category': (q['category'] ?? 'attention_visuelle').toString(),
      'difficulty': diff,
      'question': '$textA | $textB',
      'options': [textA, textB],
      'answer': (q['is_true'] == true) ? 'VRAI' : 'FAUX',
      'explanation': (q['explanation'] ?? '').toString(),
      'sub': (q['sub'] ?? '').toString().trim().isEmpty
          ? null
          : q['sub'].toString(),
      'report_type': reportType,
      'message': message,
      'page': AttentionVisuellePage.routeName,
      'status': 'new',
    };

    try {
      debugPrint('📤 REPORT insert payload => $payload');
      await supabase.from('tests_psycotechnique_report').insert(payload);
      debugPrint('✅ REPORT insert ok');
    } catch (e, st) {
      debugPrint('❌ tests_psycotechnique_report full insert failed: $e');
      debugPrint('$st');
      debugPrint('payload=$payload');

      final fallbackPayload = <String, dynamic>{
        'user_uid': user?.id,
        'email': user?.email,
        'question_id': (q['id'] ?? '').toString(),
        'module': 'psychotechnique',
        'category': 'attention_visuelle',
        'difficulty': diff,
        'question': '$textA | $textB',
        'answer': (q['is_true'] == true) ? 'VRAI' : 'FAUX',
        'report_type': reportType,
        'message': message,
        'page': AttentionVisuellePage.routeName,
        'status': 'new',
      };

      debugPrint('📤 REPORT fallback payload => $fallbackPayload');
      await supabase
          .from('tests_psycotechnique_report')
          .insert(fallbackPayload);
      debugPrint('✅ REPORT fallback insert ok');
    }
  }

  Future<void> _openReportDialog() async {
    final q = _reportQuestion;
    if (q == null) {
      AppNotifier.warning(
        context,
        title: 'Question indisponible',
        message: 'Question indisponible pour le moment.',
      );
      return;
    }

    final isDark = _isDark(context);
    final textCol = _textPrimary(context);
    final subCol = _textSecondary(context);
    final card = isDark
        ? Colors.white.withValues(alpha: .08)
        : _surface(context);
    final border = _border(context);

    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        String? type;
        final msgCtrl = TextEditingController();
        bool sending = false;

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
            await _insertReportAttentionVisuelle(
              q: q,
              reportType: t,
              message: m,
            );
            if (!ctx.mounted) return;
            Navigator.of(ctx).pop();
            if (!mounted) return;
            AppNotifier.success(
              context,
              title: 'Signalement envoyé',
              message: 'Merci !',
            );
          } catch (e) {
            setState(() => sending = false);
            debugPrint('❌ tests_psycotechnique_report insert failed: $e');
            if (!mounted) return;
            AppNotifier.error(
              context,
              title: 'Erreur lors de l\'envoi',
              message: '$e',
            );
          }
        }

        InputDecoration deco(String label) => InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: subCol, fontWeight: FontWeight.w700),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: isDark ? Colors.white : _accent(context),
            ),
          ),
          filled: true,
          fillColor: isDark
              ? Colors.white.withValues(alpha: .06)
              : Colors.black.withValues(alpha: .03),
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
                          color: _accent(context),
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Signaler cette question',
                            style: TextStyle(
                              color: textCol,
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(ctx).pop(),
                          icon: Icon(Icons.close_rounded, color: subCol),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _ReadOnlyField(
                            label: 'ID question',
                            value: (q['id'] ?? '').toString(),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _ReadOnlyField(
                            label: 'Difficulté',
                            value: randomMode
                                ? (_normalizedDifficulty(
                                        q['difficulty'],
                                      ).isEmpty
                                      ? 'Aléatoire'
                                      : _normalizedDifficulty(q['difficulty']))
                                : (selectedDifficulty ??
                                      _normalizedDifficulty(q['difficulty'])),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _ReadOnlyField(
                      label: 'Catégorie',
                      value: (q['category'] ?? 'attention_visuelle').toString(),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: type,
                      decoration: deco('Type de signalement'),
                      items: const [
                        DropdownMenuItem(value: 'bug', child: Text('Bug')),
                        DropdownMenuItem(
                          value: 'probleme',
                          child: Text('Problème'),
                        ),
                        DropdownMenuItem(value: 'autre', child: Text('Autre')),
                      ],
                      onChanged: sending
                          ? null
                          : (v) => setState(() => type = v),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: msgCtrl,
                      minLines: 4,
                      maxLines: 6,
                      decoration: deco('Explique le souci'),
                      style: TextStyle(
                        color: textCol,
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    const SizedBox(height: 14),
                    FilledButton(
                      onPressed: sending ? null : () => onSend(setState),
                      style: FilledButton.styleFrom(
                        backgroundColor: _accent(context),
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(54),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        sending ? 'Envoi...' : 'Envoyer',
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          decoration: TextDecoration.none,
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

  Widget _buildDifficultyScreen(BuildContext context) {
    final isDark = _isDark(context);
    final textMain = isDark ? Colors.white : _Brand.textDark;
    final sub = isDark
        ? Colors.white.withAlpha(210)
        : _Brand.textDark.withAlpha(210);

    Widget levelCard({
      required String label,
      required String emoji,
      required Color tint,
      required bool active,
      required VoidCallback onTap,
    }) {
      return _LevelCard(
        label: label,
        emoji: emoji,
        tint: tint,
        active: active,
        onTap: onTap,
        isDark: isDark,
        floatCtrl: ambientController,
      );
    }

    return Stack(
      children: [
        Positioned.fill(
          child: _AnimatedBackground(ctrl: ambientController, isDark: isDark),
        ),
        _Halo(
          color: _Brand.accent,
          size: 260,
          dx: -140,
          dy: -160,
          ctrl: ambientController,
          strength: isDark ? .18 : .14,
        ),
        _Halo(
          color: _Brand.good,
          size: 220,
          dx: 120,
          dy: 260,
          ctrl: ambientController,
          strength: isDark ? .15 : .12,
        ),
        _Halo(
          color: _Brand.bad,
          size: 180,
          dx: -10,
          dy: 120,
          ctrl: ambientController,
          strength: isDark ? .12 : .10,
        ),
        SafeArea(
          bottom: false,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 2, right: 8),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: Icon(
                        Icons.close_rounded,
                        color: isDark ? Colors.white : _Brand.textDark,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.flag_outlined,
                        size: 20,
                        color: isDark
                            ? Colors.white.withValues(alpha: .72)
                            : _Brand.textDark.withValues(alpha: .55),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 460),
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
                                levelCard(
                                  label: 'Facile',
                                  emoji: '🌱',
                                  tint: const Color(0xFFB7F0C1),
                                  active:
                                      selectedDifficulty == 'Facile' &&
                                      !randomMode,
                                  onTap: () {
                                    setState(() {
                                      selectedDifficulty = 'Facile';
                                      randomMode = false;
                                    });
                                    _recalculateAvailableCount();
                                  },
                                ),
                                levelCard(
                                  label: 'Moyen',
                                  emoji: '🏅',
                                  tint: const Color(0xFFFCE7B2),
                                  active:
                                      selectedDifficulty == 'Moyenne' &&
                                      !randomMode,
                                  onTap: () {
                                    setState(() {
                                      selectedDifficulty = 'Moyenne';
                                      randomMode = false;
                                    });
                                    _recalculateAvailableCount();
                                  },
                                ),
                                levelCard(
                                  label: 'Difficile',
                                  emoji: '🏆',
                                  tint: const Color(0xFFF8C2BE),
                                  active:
                                      selectedDifficulty == 'Difficile' &&
                                      !randomMode,
                                  onTap: () {
                                    setState(() {
                                      selectedDifficulty = 'Difficile';
                                      randomMode = false;
                                    });
                                    _recalculateAvailableCount();
                                  },
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
                              onPressed:
                                  selectedDifficulty == null && !randomMode
                                  ? null
                                  : _startExercise,
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor:
                                    (selectedDifficulty == null && !randomMode)
                                    ? _Brand.radioTrack(context)
                                    : (isDark ? Colors.white : _Brand.textDark),
                                foregroundColor:
                                    (selectedDifficulty == null && !randomMode)
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
                              onPressed: () {
                                setState(() {
                                  randomMode = true;
                                  selectedDifficulty = null;
                                });
                                _recalculateAvailableCount();
                                _startExercise();
                              },
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
      ],
    );
  }

  Widget _buildIntroScreen(BuildContext context) {
    final titleColor = _textPrimary(context);
    final subColor = _textSecondary(context);
    final isDark = _isDark(context);

    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 540),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        showIntroScreen = false;
                        showDifficultyScreen = true;
                      });
                    },
                    icon: Icon(Icons.arrow_back_rounded, color: titleColor),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 84,
                  height: 84,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [_accent(context), _accentSecondary(context)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: _accent(context).withValues(alpha: .24),
                        blurRadius: 24,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.bolt_rounded,
                    color: Colors.white,
                    size: 42,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'Test de rapidité visuelle',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: titleColor,
                    decoration: TextDecoration.none,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'L’objectif est simple : déterminer le plus vite possible si les deux mots ou chiffres affichés sont identiques ou différents.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.5,
                    fontWeight: FontWeight.w600,
                    color: subColor,
                    decoration: TextDecoration.none,
                  ),
                ),
                const SizedBox(height: 20),
                _IntroInfoCard(
                  icon: Icons.timer_outlined,
                  title: '5 secondes par question',
                  subtitle:
                      'Le chrono démarre immédiatement à l’apparition de la paire.',
                  color: const Color(0xFF22C55E),
                  isDark: isDark,
                ),
                const SizedBox(height: 10),
                _IntroInfoCard(
                  icon: Icons.visibility_outlined,
                  title: 'Concentration maximale',
                  subtitle: 'Réponds vite sans perdre en précision.',
                  color: const Color(0xFFF59E0B),
                  isDark: isDark,
                ),
                const SizedBox(height: 10),
                _IntroInfoCard(
                  icon: Icons.psychology_alt_outlined,
                  title: 'Exercice psychotechnique',
                  subtitle:
                      'Travaille ton attention, ta vitesse et ta régularité.',
                  color: const Color(0xFF5E6CFF),
                  isDark: isDark,
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Checkbox(
                      value: hideIntroForever,
                      onChanged: (v) => _saveIntroPreference(v ?? false),
                    ),
                    Expanded(
                      child: Text(
                        'Ne plus afficher cette introduction',
                        style: TextStyle(
                          color: subColor,
                          fontWeight: FontWeight.w700,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: FilledButton(
                    onPressed: _beginSessionNow,
                    style: FilledButton.styleFrom(
                      backgroundColor: isDark ? Colors.white : _accent(context),
                      foregroundColor: isDark ? Colors.black : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: const Text(
                      'Commencer',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 17,
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
    );
  }

  Widget _buildExerciseScreen(BuildContext context) {
    final titleColor = _textPrimary(context);
    final subColor = _textSecondary(context);
    final border = _border(context);

    final textA = (currentQuestion?['text_a'] ?? '').toString();
    final textB = (currentQuestion?['text_b'] ?? '').toString();

    return SafeArea(
      child: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: _TopBar(
                  onClose: stopSeries,
                  currentIndex: currentIndex,
                  totalQuestions: max(totalAnswers + 1, 1),
                  timer: timerController,
                  titleColor: titleColor,
                  subtitleColor: subColor,
                  border: border,
                  timerColorBuilder: _getTimerColor,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: FadeTransition(
                  opacity: CurvedAnimation(
                    parent: questionSwapController,
                    curve: Curves.easeOut,
                  ),
                  child: SlideTransition(
                    position:
                        Tween<Offset>(
                          begin: const Offset(.02, 0),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: questionSwapController,
                            curve: Curves.easeOutCubic,
                          ),
                        ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 740),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _QuestionPairCard(
                                left: textA,
                                right: textB,
                                isDark: _isDark(context),
                                border: border,
                                background: _surface(context),
                                shadow: _shadow(context),
                                textColor: titleColor,
                              ),
                              const SizedBox(height: 24),
                              AnimatedBuilder(
                                animation: pulseController,
                                builder: (_, child) {
                                  final scale = showResult
                                      ? 1 + (0.02 * (1 - pulseController.value))
                                      : 1.0;
                                  return Transform.scale(
                                    scale: scale,
                                    child: child,
                                  );
                                },
                                child: _ResultBanner(
                                  visible: showResult,
                                  isCorrect: isCorrect,
                                  isTimedOut: isTimedOut,
                                  successBg: _isDark(context)
                                      ? const Color(0xFF10261B)
                                      : const Color(0xFFF6FFF9),
                                  successBorder: const Color(0xFF39C27A),
                                  errorBg: _isDark(context)
                                      ? const Color(0xFF2A171B)
                                      : const Color(0xFFFFF7F8),
                                  errorBorder: const Color(0xFFE05A67),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 6, 20, 86),
                child: Column(
                  children: [
                    _AnswerButton(
                      label: 'VRAI',
                      onTap: answerLocked ? null : () => answer(true),
                      isSelected: selectedAnswer == true,
                      isLocked: answerLocked,
                      isCorrectState: showResult
                          ? isCorrect && selectedAnswer == true
                          : null,
                      baseColor: const Color(0xFF22C55E),
                      isDark: _isDark(context),
                    ),
                    const SizedBox(height: 12),
                    _AnswerButton(
                      label: 'FAUX',
                      onTap: answerLocked ? null : () => answer(false),
                      isSelected: selectedAnswer == false,
                      isLocked: answerLocked,
                      isCorrectState: showResult
                          ? isCorrect && selectedAnswer == false
                          : null,
                      baseColor: const Color(0xFFEF4444),
                      isDark: _isDark(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 18,
            left: 0,
            right: 0,
            child: Center(
              child: _BottomReportButton(
                onTap: _openReportDialog,
                color: _textSecondary(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bg = _pageBg(context);

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppSettingsController.I.themeMode,
      builder: (_, __, ___) {
        return Scaffold(
          backgroundColor: bg,
          body: Stack(
            children: [
              Positioned.fill(
                child: _AnimatedBackdrop(
                  controller: ambientController,
                  isDark: _isDark(context),
                ),
              ),
              if (isLoading)
                const Center(child: CircularProgressIndicator())
              else if (showDifficultyScreen)
                _buildDifficultyScreen(context)
              else if (showIntroScreen)
                _buildIntroScreen(context)
              else
                _buildExerciseScreen(context),
            ],
          ),
        );
      },
    );
  }
}

class _AnimatedBackdrop extends StatelessWidget {
  final AnimationController controller;
  final bool isDark;

  const _AnimatedBackdrop({required this.controller, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        final t = controller.value;
        final align1 = Alignment(-1 + (t * 2), -0.8);
        final align2 = Alignment(0.9 - (t * 1.8), 0.8);
        return Stack(
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: isDark
                        ? const [Color(0xFF08111D), Color(0xFF0B1626)]
                        : const [Color(0xFFF4F7FB), Color(0xFFEFF4FF)],
                  ),
                ),
              ),
            ),
            Align(
              alignment: align1,
              child: const _GlowOrb(size: 280, color: Color(0x225E6CFF)),
            ),
            Align(
              alignment: align2,
              child: const _GlowOrb(size: 220, color: Color(0x2248C78E)),
            ),
            if (isDark) const _NoiseOverlay(),
          ],
        );
      },
    );
  }
}

class _GlowOrb extends StatelessWidget {
  final double size;
  final Color color;

  const _GlowOrb({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color,
              blurRadius: size * .52,
              spreadRadius: size * .03,
            ),
          ],
        ),
      ),
    );
  }
}

class _NoiseOverlay extends StatelessWidget {
  const _NoiseOverlay();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Opacity(
        opacity: .05,
        child: CustomPaint(painter: _NoisePainter(), size: Size.infinite),
      ),
    );
  }
}

class _NoisePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final random = Random(12);
    final paint = Paint()..style = PaintingStyle.fill;
    for (double x = 0; x < size.width; x += 6) {
      for (double y = 0; y < size.height; y += 6) {
        final v = random.nextDouble();
        if (v > .85) {
          paint.color = Colors.white.withValues(
            alpha: .14 + random.nextDouble() * .08,
          );
          canvas.drawRect(Rect.fromLTWH(x, y, 2, 2), paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _DifficultySplash extends StatefulWidget {
  final Animation<double> fade;
  final bool isDark;
  final String? selected;
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
            SafeArea(
              bottom: false,
              child: Align(
                alignment: Alignment.topCenter,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 72, 20, 24),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 460),
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
    return AnimatedBuilder(
      animation: ctrl,
      builder: (_, __) {
        final t = ctrl.value;
        return DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(-1 + (t * .25), -1),
              end: Alignment(1 - (t * .2), 1),
              colors: isDark
                  ? const [Color(0xFF08111D), Color(0xFF0B1626)]
                  : const [Color(0xFFF4F7FB), Color(0xFFEFF4FF)],
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
  final double dx;
  final double dy;
  final AnimationController ctrl;
  final double strength;

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
        return Positioned(
          left: dx + (sin(t * 2 * pi) * 18),
          top: dy + (cos(t * 2 * pi) * 18),
          child: IgnorePointer(
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: strength),
                    blurRadius: size * .55,
                    spreadRadius: size * .03,
                  ),
                ],
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
  final VoidCallback onTap;
  final bool isDark;
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
    this.floatDelay = 0,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: floatCtrl,
      builder: (_, __) {
        final v = sin((floatCtrl.value + floatDelay) * 2 * pi) * 2;
        return Transform.translate(
          offset: Offset(0, v),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: onTap,
              child: Ink(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 18,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: .05)
                      : tint.withValues(alpha: .22),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: active
                        ? tint.withValues(alpha: .95)
                        : (isDark
                              ? Colors.white.withValues(alpha: .10)
                              : Colors.black.withValues(alpha: .06)),
                    width: active ? 1.6 : 1.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: active
                          ? tint.withValues(alpha: .28)
                          : Colors.black.withValues(alpha: isDark ? .18 : .05),
                      blurRadius: active ? 24 : 14,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: tint.withValues(alpha: .32),
                      ),
                      alignment: Alignment.center,
                      child: Text(emoji, style: const TextStyle(fontSize: 22)),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        label,
                        style: TextStyle(
                          color: isDark ? Colors.white : _Brand.textDark,
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                    Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: active
                              ? tint.withValues(alpha: .95)
                              : (isDark
                                    ? Colors.white.withValues(alpha: .16)
                                    : Colors.black.withValues(alpha: .10)),
                          width: 1.3,
                        ),
                      ),
                      child: active
                          ? Center(
                              child: Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: tint.withValues(alpha: .95),
                                ),
                              ),
                            )
                          : null,
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

class _DifficultyTile extends StatelessWidget {
  final String label;
  final String subtitle;
  final bool selected;
  final Color color;
  final bool isDark;
  final VoidCallback onTap;

  const _DifficultyTile({
    required this.label,
    required this.subtitle,
    required this.selected,
    required this.color,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? const Color(0xFF101826) : Colors.white;
    final text = isDark ? Colors.white : const Color(0xFF18202F);
    final sub = isDark ? const Color(0xFFA9B5C7) : const Color(0xFF667085);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Ink(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: selected
                  ? color
                  : (isDark
                        ? const Color(0xFF253247)
                        : const Color(0xFFE3EAF5)),
              width: selected ? 2.2 : 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: selected
                    ? color.withValues(alpha: .18)
                    : Colors.black.withValues(alpha: isDark ? .18 : .06),
                blurRadius: selected ? 22 : 16,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        color: text,
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: sub,
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: selected ? color : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(color: color, width: 2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IntroInfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final bool isDark;

  const _IntroInfoCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF101826) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? const Color(0xFF253247) : const Color(0xFFE3EAF5),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xFF18202F),
                    fontWeight: FontWeight.w900,
                    decoration: TextDecoration.none,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: isDark
                        ? const Color(0xFFA9B5C7)
                        : const Color(0xFF667085),
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.none,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final VoidCallback onClose;
  final int currentIndex;
  final int totalQuestions;
  final AnimationController timer;
  final Color titleColor;
  final Color subtitleColor;
  final Color border;
  final Color Function(double progress) timerColorBuilder;

  const _TopBar({
    required this.onClose,
    required this.currentIndex,
    required this.totalQuestions,
    required this.timer,
    required this.titleColor,
    required this.subtitleColor,
    required this.border,
    required this.timerColorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: onClose,
          icon: Icon(Icons.close_rounded, color: titleColor),
        ),
        Expanded(
          child: Column(
            children: [
              Text(
                'Attention visuelle',
                style: TextStyle(
                  color: titleColor,
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                  decoration: TextDecoration.none,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Question $currentIndex',
                style: TextStyle(
                  color: subtitleColor,
                  fontWeight: FontWeight.w700,
                  decoration: TextDecoration.none,
                ),
              ),
            ],
          ),
        ),
        AnimatedBuilder(
          animation: timer,
          builder: (_, __) {
            final progress = timer.value;
            final remaining = max(
              0,
              (_AttentionVisuellePageState.questionDuration * (1 - progress))
                  .ceil(),
            );
            final color = timerColorBuilder(progress);
            return Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(color: border),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 42,
                    height: 42,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 4,
                      backgroundColor: color.withValues(alpha: .15),
                      valueColor: AlwaysStoppedAnimation(color),
                    ),
                  ),
                  Text(
                    '$remaining',
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _QuestionPairCard extends StatelessWidget {
  final String left;
  final String right;
  final bool isDark;
  final Color border;
  final Color background;
  final Color shadow;
  final Color textColor;

  const _QuestionPairCard({
    required this.left,
    required this.right,
    required this.isDark,
    required this.border,
    required this.background,
    required this.shadow,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    Widget box(String text) {
      return Expanded(
        child: Container(
          constraints: const BoxConstraints(minHeight: 104),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: border),
            boxShadow: [
              BoxShadow(
                color: shadow,
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                text,
                maxLines: 1,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textColor,
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Row(children: [box(left), const SizedBox(width: 12), box(right)]);
  }
}

class _AnswerButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool isSelected;
  final bool isLocked;
  final bool? isCorrectState;
  final Color baseColor;
  final bool isDark;

  const _AnswerButton({
    required this.label,
    required this.onTap,
    required this.isSelected,
    required this.isLocked,
    required this.isCorrectState,
    required this.baseColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final Color bg = isCorrectState == true
        ? baseColor.withValues(alpha: .15)
        : isSelected
        ? baseColor.withValues(alpha: .10)
        : (isDark ? const Color(0xFF101826) : Colors.white);

    final Color border = isCorrectState == true
        ? baseColor
        : isSelected
        ? baseColor.withValues(alpha: .60)
        : (isDark ? const Color(0xFF253247) : const Color(0xFFE3EAF5));

    final Color text = isCorrectState == true
        ? baseColor
        : (isDark ? Colors.white : const Color(0xFF18202F));

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOutCubic,
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: border, width: isSelected ? 1.8 : 1.2),
          boxShadow: [
            if (isSelected || isCorrectState == true)
              BoxShadow(
                color: baseColor.withValues(alpha: .18),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: text,
              fontSize: 17,
              fontWeight: FontWeight.w900,
              decoration: TextDecoration.none,
            ),
          ),
        ),
      ),
    );
  }
}

class _ResultBanner extends StatelessWidget {
  final bool visible;
  final bool isCorrect;
  final bool isTimedOut;
  final Color successBg;
  final Color successBorder;
  final Color errorBg;
  final Color errorBorder;

  const _ResultBanner({
    required this.visible,
    required this.isCorrect,
    required this.isTimedOut,
    required this.successBg,
    required this.successBorder,
    required this.errorBg,
    required this.errorBorder,
  });

  @override
  Widget build(BuildContext context) {
    final bool ok = isCorrect;
    final Color bg = ok ? successBg : errorBg;
    final Color border = ok ? successBorder : errorBorder;
    final String text = !visible
        ? ''
        : ok
        ? 'Bonne réponse'
        : isTimedOut
        ? 'Temps écoulé'
        : 'Mauvaise réponse';

    return AnimatedOpacity(
      opacity: visible ? 1 : 0,
      duration: const Duration(milliseconds: 140),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: border),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: border,
            fontWeight: FontWeight.w900,
            fontSize: 15,
            decoration: TextDecoration.none,
          ),
        ),
      ),
    );
  }
}

class _CopiqResultDialog extends StatelessWidget {
  final int correctAnswers;
  final int totalAnswers;
  final double totalDuration;
  final double avgTime;
  final int accuracy;
  final bool autoStoppedByAfk;
  final bool stoppedByUser;
  final Color accent;
  final Color accentSoft;
  final IconData heroIcon;
  final String title;
  final String subtitle;
  final VoidCallback onBack;
  final VoidCallback onRestart;

  const _CopiqResultDialog({
    required this.correctAnswers,
    required this.totalAnswers,
    required this.totalDuration,
    required this.avgTime,
    required this.accuracy,
    required this.autoStoppedByAfk,
    required this.stoppedByUser,
    required this.accent,
    required this.accentSoft,
    required this.heroIcon,
    required this.title,
    required this.subtitle,
    required this.onBack,
    required this.onRestart,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: .96, end: 1),
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOutBack,
          builder: (_, scale, child) =>
              Transform.scale(scale: scale, child: child),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 390),
            padding: const EdgeInsets.fromLTRB(22, 22, 22, 18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: accent.withValues(alpha: .16)),
              boxShadow: [
                BoxShadow(
                  color: accent.withValues(alpha: .16),
                  blurRadius: 26,
                  offset: const Offset(0, 14),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 74,
                  height: 74,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [accent, Color.lerp(accent, Colors.white, .22)!],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: accent.withValues(alpha: .22),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Icon(heroIcon, color: Colors.white, size: 34),
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF18202F),
                    decoration: TextDecoration.none,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.42,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF667085),
                    decoration: TextDecoration.none,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '$correctAnswers / $totalAnswers',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                    color: accent,
                    decoration: TextDecoration.none,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: accentSoft,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: accent.withValues(alpha: .18)),
                  ),
                  child: Text(
                    '$accuracy% de réussite',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: accent,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _CopiqMiniMetric(
                          label: 'Durée',
                          value: '${totalDuration.round()} sec',
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 34,
                        color: const Color(0xFFE2E8F0),
                      ),
                      Expanded(
                        child: _CopiqMiniMetric(
                          label: 'Moyenne',
                          value: '${avgTime.toStringAsFixed(2)} s',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onBack,
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          side: const BorderSide(color: Color(0xFFE2E8F0)),
                          foregroundColor: const Color(0xFF18202F),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Retour',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: FilledButton(
                        onPressed: onRestart,
                        style: FilledButton.styleFrom(
                          backgroundColor: accent,
                          foregroundColor: Colors.white,
                          minimumSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Recommencer',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CopiqMiniMetric extends StatelessWidget {
  final String label;
  final String value;

  const _CopiqMiniMetric({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Color(0xFF667085),
            decoration: TextDecoration.none,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: Color(0xFF18202F),
            decoration: TextDecoration.none,
          ),
        ),
      ],
    );
  }
}

class _BottomReportButton extends StatelessWidget {
  final VoidCallback onTap;
  final Color color;

  const _BottomReportButton({required this.onTap, required this.color});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Icon(Icons.flag_outlined, color: color, size: 22),
        ),
      ),
    );
  }
}

class _ResultMetric extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final Color secondary;

  const _ResultMetric({
    required this.label,
    required this.value,
    required this.color,
    required this.secondary,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: secondary,
            fontWeight: FontWeight.w700,
            decoration: TextDecoration.none,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w900,
            fontSize: 17,
            decoration: TextDecoration.none,
          ),
        ),
      ],
    );
  }
}

class _ReadOnlyField extends StatelessWidget {
  final String label;
  final String value;

  const _ReadOnlyField({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextFormField(
      initialValue: value,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: isDark
            ? Colors.white.withValues(alpha: .06)
            : Colors.black.withValues(alpha: .03),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}
