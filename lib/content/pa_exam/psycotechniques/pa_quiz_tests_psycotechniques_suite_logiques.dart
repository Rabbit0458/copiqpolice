// COP'IQ — Version PA (Policier Adjoint) du module Tests psychotechniques.
// Copie adaptée de lib/content/gpx_exam/psycotechniques/quiz_tests_psycotechniques_suite_logiques.dart
// Ne pas modifier le fichier GPX d'origine. Tracking séparé : identité PA.

// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vibration/vibration.dart';

import 'package:copiqpolice/core/widgets/app_notifier.dart'
    show AppNotifier, AppSettingsController;

Color _opa(Color c, double a) => c.withValues(alpha: a);

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
// DATA
// ============================================================================
class PaSuiteLogiqueQuestion {
  final String id;
  final String module;
  final String category;
  final String difficulty;
  final String question;
  final String? prompt;
  final List<String> options;
  final String answer;
  final String explanation;
  final String? hint;
  final bool isActive;
  final double randKey;

  const PaSuiteLogiqueQuestion({
    required this.id,
    required this.module,
    required this.category,
    required this.difficulty,
    required this.question,
    required this.prompt,
    required this.options,
    required this.answer,
    required this.explanation,
    required this.hint,
    required this.isActive,
    required this.randKey,
  });

  factory PaSuiteLogiqueQuestion.fromMap(Map<String, dynamic> map) {
    final rawOptions = map['options'];
    final options = (rawOptions is List)
        ? rawOptions
              .where((e) => e != null)
              .map((e) => e.toString().trim())
              .where((e) => e.isNotEmpty)
              .toList()
        : <String>[];

    return PaSuiteLogiqueQuestion(
      id: (map['id'] ?? '').toString(),
      module: (map['module'] ?? 'pa_psychotechnique').toString(),
      category: (map['category'] ?? 'Suites logiques').toString(),
      difficulty: _normalizeDifficultyStatic(
        (map['difficulty'] ?? 'Moyenne').toString(),
      ),
      question: (map['sequence_text'] ?? '').toString(),
      prompt: (map['prompt'] == null || map['prompt'].toString().trim().isEmpty)
          ? null
          : map['prompt'].toString(),
      options: options,
      answer: (map['answer'] ?? '').toString(),
      explanation: (map['explanation'] ?? '').toString(),
      hint: (map['hint'] == null || map['hint'].toString().trim().isEmpty)
          ? null
          : map['hint'].toString(),
      isActive: map['is_active'] == true,
      randKey: ((map['rand_key'] ?? 0) as num).toDouble(),
    );
  }

  static String _normalizeDifficultyStatic(String raw) {
    final s = raw.trim().toLowerCase();
    if (s.contains('fac')) return 'Facile';
    if (s.contains('dif')) return 'Difficile';
    if (s.contains('moy') || s.contains('med')) return 'Moyenne';
    return 'Moyenne';
  }
}

// ============================================================================
// PAGE
// ============================================================================
class PaQuizPsycotechniquesSuitesLogiques extends StatefulWidget {
  static const String routeName =
      '/pa_exam/concours/tests_psychotechniques/suites_logiques';

  final String uid;
  final String email;

  const PaQuizPsycotechniquesSuitesLogiques({
    super.key,
    required this.uid,
    required this.email,
  });

  @override
  State<PaQuizPsycotechniquesSuitesLogiques> createState() =>
      _PaQuizPsycotechniquesSuitesLogiquesState();
}

class _PaQuizPsycotechniquesSuitesLogiquesState
    extends State<PaQuizPsycotechniquesSuitesLogiques>
    with TickerProviderStateMixin {
  final SupabaseClient supabase = Supabase.instance.client;
  final math.Random _random = math.Random();

  static const int questionDuration = 30;
  static const int afkStopLimit = 10;
  static const String _introHiddenKey =
      'pa_suite_logique_intro_hidden_forever_v3';

  List<PaSuiteLogiqueQuestion> allQuestions = [];
  List<PaSuiteLogiqueQuestion> filteredQuestions = [];
  List<int> shuffledIndexes = [];
  int shuffledCursor = 0;
  int? lastQuestionIndex;

  PaSuiteLogiqueQuestion? currentQuestion;
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
  bool loadFailed = false;

  String? selectedDifficulty;
  bool randomMode = false;
  bool showDifficultyScreen = true;
  bool showIntroScreen = false;

  bool answerLocked = false;
  String? selectedAnswer;

  DateTime? startTime;
  final List<double> responseTimes = [];

  late AnimationController timerController;
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
          if (status == AnimationStatus.completed &&
              !showResult &&
              currentQuestion != null) {
            answer('', timeout: true);
          }
        });

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
    setState(() => hideIntroForever = value);
  }

  bool _isDark(BuildContext context) {
    final mode = AppSettingsController.I.themeMode.value;
    if (mode == ThemeMode.dark) return true;
    if (mode == ThemeMode.light) return false;
    return MediaQuery.platformBrightnessOf(context) == Brightness.dark;
  }

  Color _pageBg(BuildContext context) =>
      _isDark(context) ? const Color(0xFF08111D) : const Color(0xFFF4F7FB);

  Color _surfaceAlt(BuildContext context) =>
      _isDark(context) ? const Color(0xFF121D2E) : const Color(0xFFF8FAFF);

  Color _textPrimary(BuildContext context) =>
      _isDark(context) ? const Color(0xFFF5F7FA) : const Color(0xFF18202F);

  Color _textSecondary(BuildContext context) =>
      _isDark(context) ? const Color(0xFFA9B5C7) : const Color(0xFF667085);

  Color _border(BuildContext context) =>
      _isDark(context) ? const Color(0xFF253247) : const Color(0xFFE3EAF5);

  Color _dialogBg(BuildContext context) =>
      _isDark(context) ? const Color(0xFF101826) : Colors.white;

  Color _accent(BuildContext context) =>
      _isDark(context) ? const Color(0xFF8C93FF) : const Color(0xFF5E6CFF);

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
    } catch (_) {}
  }

  Future<void> loadQuestions() async {
    try {
      final data = await supabase
          .from('tests_psyco_suite_logique')
          .select()
          .eq('is_active', true);

      allQuestions = List<Map<String, dynamic>>.from(data)
          .map(PaSuiteLogiqueQuestion.fromMap)
          .where(
            (q) =>
                q.question.trim().isNotEmpty &&
                q.answer.trim().isNotEmpty &&
                q.options.length >= 2,
          )
          .toList();

      totalQuestions = allQuestions.length;
      _recalculateAvailableCount();

      if (!mounted) return;
      setState(() {
        isLoading = false;
        loadFailed = allQuestions.isEmpty;

        // état de sécurité pour éviter l'écran blanc
        currentQuestion = null;
        currentQuestionIndex = null;
        showIntroScreen = false;
        showDifficultyScreen = allQuestions.isNotEmpty;
      });
    } catch (e, st) {
      debugPrint('❌ loadQuestions error: $e');
      debugPrint('$st');

      if (!mounted) return;
      setState(() {
        isLoading = false;
        loadFailed = true;
        currentQuestion = null;
        currentQuestionIndex = null;
        showIntroScreen = false;
        showDifficultyScreen = false;
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
        .where((q) => _normalizedDifficulty(q.difficulty) == selectedDifficulty)
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
      filteredQuestions = List<PaSuiteLogiqueQuestion>.from(allQuestions);
    } else {
      filteredQuestions = allQuestions
          .where(
            (q) => _normalizedDifficulty(q.difficulty) == selectedDifficulty,
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

  Future<void> answer(String userAnswer, {bool timeout = false}) async {
    if (showResult || currentQuestion == null || isSaving || answerLocked) {
      return;
    }

    timerController.stop();
    answerLocked = true;
    selectedAnswer = timeout ? null : userAnswer;

    final correct = currentQuestion!.answer;
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

  Future<void> _closeQuiz() async {
    // Aucun résultat à sauvegarder tant que la série n'a pas démarré.
    if (showDifficultyScreen || showIntroScreen || currentQuestion == null) {
      if (mounted) Navigator.maybePop(context);
      return;
    }
    await stopSeries();
  }

  Future<void> _reportCurrentQuestion() async {
    if (currentQuestion == null || isSaving) return;

    final controller = TextEditingController();
    final sent = await showDialog<bool>(
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
                Row(
                  children: [
                    const Icon(Icons.flag_rounded, color: _Brand.bad),
                    const SizedBox(width: 10),
                    Text(
                      'Signaler la question',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w900,
                        color: _textPrimary(context),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: controller,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Explique le problème rencontré…',
                    filled: true,
                    fillColor: _surfaceAlt(context),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: _border(context)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: _border(context)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: _accent(context),
                        width: 1.4,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Annuler'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: FilledButton.styleFrom(
                          backgroundColor: _Brand.bad,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Envoyer'),
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

    if (sent != true) return;

    try {
      await supabase.from('tests_psycotechnique_report').insert({
        'user_uid': widget.uid,
        'email': widget.email,
        'question_id': currentQuestion!.id,
        'module': 'pa_psychotechnique',
        'category': 'suites_logiques',
        'difficulty': randomMode
            ? (_normalizedDifficulty(currentQuestion!.difficulty).isEmpty
                  ? 'Aléatoire'
                  : _normalizedDifficulty(currentQuestion!.difficulty))
            : (selectedDifficulty ??
                  _normalizedDifficulty(currentQuestion!.difficulty)),
        'question': currentQuestion!.question,
        'options': currentQuestion!.options,
        'answer': currentQuestion!.answer,
        'explanation': currentQuestion!.explanation,
        'sub': currentQuestion!.prompt,
        'report_type': 'question',
        'message': controller.text.trim(),
        'page': PaQuizPsycotechniquesSuitesLogiques.routeName,
        'status': 'pending',
      });

      if (!mounted) return;
      AppNotifier.success(
        context,
        title: 'Signalement envoyé',
        message: 'Merci, la question sera vérifiée.',
      );
    } catch (e, st) {
      debugPrint('❌ report error: $e');
      debugPrint('$st');
      if (!mounted) return;
      AppNotifier.error(
        context,
        title: 'Erreur',
        message: 'Impossible d’envoyer le signalement.',
      );
    }
  }

  Future<void> endGame({
    bool stoppedByUser = false,
    bool autoStoppedByAfk = false,
  }) async {
    if (isSaving) return;

    isSaving = true;
    timerController.stop();

    final totalDuration = responseTimes.fold(0.0, (a, b) => a + b);
    final avgTime = responseTimes.isEmpty
        ? 0.0
        : totalDuration / responseTimes.length;
    final totalAnsweredSafe = totalAnswers <= 0 ? 1 : totalAnswers;

    try {
      final payload = {
        'user_id': widget.uid,
        'exercise_type': 'suite_logique',
        'module': 'pa_psychotechnique',
        'score': correctAnswers,
        'correct_answers': correctAnswers,
        'wrong_answers': totalAnswers - correctAnswers,
        'total_questions': totalAnswers,
        'duration_seconds': totalDuration.round(),
        'avg_response_time': avgTime,
        'mode': 'concours',
        'created_at': DateTime.now().toIso8601String(),
      };

      debugPrint('📦 HISTORY PAYLOAD: $payload');

      final inserted = await supabase
          .from('tests_psychotechnique_history')
          .insert(payload)
          .select();

      debugPrint('✅ HISTORY INSERT OK: $inserted');
    } catch (e, st) {
      debugPrint('❌ history insert error: $e');
      debugPrint('$st');

      if (mounted) {
        AppNotifier.error(
          context,
          title: 'Erreur sauvegarde',
          message: e.toString(),
        );
      }
    }

    if (!mounted) return;
    setState(() {
      isSaving = false;
    });

    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'Résultats',
      barrierColor: Colors.black.withValues(alpha: .35),
      transitionDuration: const Duration(milliseconds: 280),
      pageBuilder: (_, __, ___) {
        final totalSafe = totalAnswers <= 0 ? 1 : totalAnswers;
        final pct = ((correctAnswers / totalSafe) * 100).round();

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
              accuracy: pct,
              autoStoppedByAfk: autoStoppedByAfk,
              stoppedByUser: stoppedByUser,
              accent: pct >= 80
                  ? const Color(0xFF22C55E)
                  : pct >= 50
                  ? const Color(0xFFF59E0B)
                  : const Color(0xFFEF4444),
              accentSoft: pct >= 80
                  ? const Color(0xFFDCFCE7)
                  : pct >= 50
                  ? const Color(0xFFFEF3C7)
                  : const Color(0xFFFEE2E2),
              heroIcon: autoStoppedByAfk
                  ? Icons.pause_rounded
                  : pct >= 80
                  ? Icons.emoji_events_rounded
                  : pct >= 50
                  ? Icons.auto_graph_rounded
                  : Icons.refresh_rounded,
              title: autoStoppedByAfk
                  ? 'Série arrêtée automatiquement'
                  : stoppedByUser
                  ? 'Série arrêtée'
                  : pct >= 80
                  ? 'Excellent rythme'
                  : pct >= 50
                  ? 'Tu progresses'
                  : 'Relance une série',
              subtitle: autoStoppedByAfk
                  ? 'Plusieurs questions sans réponse ont été détectées.'
                  : pct >= 80
                  ? 'Très bon niveau de logique et de rapidité.'
                  : pct >= 50
                  ? 'Tu es sur la bonne voie. Une nouvelle série peut faire grimper ton score.'
                  : 'Ce n’est pas grave. Repars tout de suite plus concentré.',
              onBack: () {
                Navigator.of(context).pop();
                Navigator.of(context).maybePop();
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
                  selectedAnswer = null;
                  answerLocked = false;
                  isTimedOut = false;
                  selectedDifficulty = null;
                  randomMode = false;
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
        final bg = _pageBg(context);
        final textCol = _textPrimary(context);

        final shouldForceDifficultySplash =
            !isLoading &&
            !loadFailed &&
            currentQuestion == null &&
            !showIntroScreen;

        const double kButtonHeight = 56;
        const double kButtonVPad = 16;
        const double kBottomReportHeight = 34;
        const double bottomBarReserved =
            kButtonHeight + kButtonVPad + kBottomReportHeight + 22;

        debugPrint(
          'allQuestions=${allQuestions.length} filteredQuestions=${filteredQuestions.length}',
        );
        debugPrint(
          'isLoading=$isLoading loadFailed=$loadFailed showDifficultyScreen=$showDifficultyScreen showIntroScreen=$showIntroScreen currentQuestion=${currentQuestion?.id}',
        );

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: isDark
              ? SystemUiOverlayStyle.light
              : SystemUiOverlayStyle.dark,
          child: Theme(
            data: (isDark ? ThemeData.dark() : ThemeData.light()).copyWith(
              scaffoldBackgroundColor: bg,
              textTheme: (isDark ? ThemeData.dark() : ThemeData.light())
                  .textTheme
                  .apply(displayColor: textCol, bodyColor: textCol),
              colorScheme: (isDark ? ThemeData.dark() : ThemeData.light())
                  .colorScheme
                  .copyWith(primary: _Brand.accent, surface: bg),
            ),
            child: Stack(
              children: [
                Positioned.fill(child: _QuizBackdrop(isDark: isDark)),
                Scaffold(
                  backgroundColor: Colors.transparent,
                  appBar: AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    scrolledUnderElevation: 0,
                    leading: IconButton(
                      icon: Icon(Icons.close_rounded, color: textCol),
                      onPressed: _closeQuiz,
                      tooltip: 'Fermer',
                    ),
                    actions: [
                      if (!showDifficultyScreen && !showIntroScreen)
                        Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: _TimerRing(
                            timer: timerController,
                            durationSeconds: questionDuration,
                            timerColorBuilder: _getTimerColor,
                            border: _border(context),
                          ),
                        ),
                    ],
                  ),
                  body: SafeArea(
                    top: false,
                    child: isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : loadFailed
                        ? _FatalState(
                            isDark: isDark,
                            title: 'Aucune question chargée',
                            message:
                                'Vérifie la table tests_psyco_suite_logique, les policies et les colonnes sequence_text / options / answer.',
                            onRetry: () async {
                              setState(() {
                                isLoading = true;
                                loadFailed = false;
                              });
                              await loadQuestions();
                            },
                          )
                        : LayoutBuilder(
                            builder: (context, _) {
                              return Stack(
                                fit: StackFit.expand,
                                clipBehavior: Clip.none,
                                children: [
                                  SizedBox.expand(
                                    child: Column(
                                      children: [
                                        if (!showDifficultyScreen &&
                                            !showIntroScreen)
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                              20,
                                              0,
                                              20,
                                              12,
                                            ),
                                            child: _TopProgressBar(
                                              index: currentIndex <= 0
                                                  ? 0
                                                  : currentIndex - 1,
                                              total:
                                                  availableForSelectedDifficulty <=
                                                      0
                                                  ? 1
                                                  : availableForSelectedDifficulty,
                                              accent: isDark
                                                  ? _Brand.white
                                                  : _Brand.accent,
                                            ),
                                          ),
                                        Expanded(
                                          child: AnimatedSwitcher(
                                            duration: const Duration(
                                              milliseconds: 250,
                                            ),
                                            child:
                                                (!showDifficultyScreen &&
                                                    !showIntroScreen &&
                                                    currentQuestion != null)
                                                ? Padding(
                                                    key: ValueKey(
                                                      currentQuestion!.id,
                                                    ),
                                                    padding:
                                                        const EdgeInsets.fromLTRB(
                                                          20,
                                                          8,
                                                          20,
                                                          0,
                                                        ),
                                                    child: _QuestionCard(
                                                      question:
                                                          currentQuestion!,
                                                      options: currentQuestion!
                                                          .options,
                                                      selected: selectedAnswer,
                                                      onSelect: (value) {
                                                        if (answerLocked)
                                                          return;
                                                        setState(
                                                          () => selectedAnswer =
                                                              value,
                                                        );
                                                      },
                                                      locked: answerLocked,
                                                      showOutcome: showResult,
                                                      isCorrect: isCorrect,
                                                      // Cet écran n'a qu'une page à
                                                      // la fois : la question
                                                      // affichée est donc toujours
                                                      // celle qu'on regarde.
                                                      estActive: true,
                                                      pulse: pulseController,
                                                      // La réserve ajoutait jusqu'à
                                                      // 240 px de vide sous la carte
                                                      // pour loger la croix
                                                      // flottante. Seule la barre de
                                                      // boutons est à compenser.
                                                      bottomSafeInset:
                                                          bottomBarReserved,
                                                    ),
                                                  )
                                                : const SizedBox.shrink(),
                                          ),
                                        ),
                                        if (!showDifficultyScreen &&
                                            !showIntroScreen)
                                          SafeArea(
                                            top: false,
                                            minimum: const EdgeInsets.fromLTRB(
                                              20,
                                              8,
                                              20,
                                              16,
                                            ),
                                            child: Column(
                                              children: [
                                                Center(
                                                  child: TextButton.icon(
                                                    onPressed:
                                                        currentQuestion == null
                                                        ? null
                                                        : _reportCurrentQuestion,
                                                    icon: Icon(
                                                      Icons.flag_outlined,
                                                      size: 16,
                                                      color: _textSecondary(
                                                        context,
                                                      ),
                                                    ),
                                                    label: Text(
                                                      'Signaler la question',
                                                      style: TextStyle(
                                                        color: _textSecondary(
                                                          context,
                                                        ),
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        decoration:
                                                            TextDecoration.none,
                                                      ),
                                                    ),
                                                    style: TextButton.styleFrom(
                                                      minimumSize:
                                                          const Size.fromHeight(
                                                            kBottomReportHeight,
                                                          ),
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 12,
                                                            vertical: 4,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: SizedBox(
                                                        height: kButtonHeight,
                                                        child: _PrimaryButton(
                                                          label: !showResult
                                                              ? 'Valider'
                                                              : 'Suivant',
                                                          onTap: !showResult
                                                              ? (selectedAnswer ==
                                                                        null
                                                                    ? null
                                                                    : () => answer(
                                                                        selectedAnswer!,
                                                                      ))
                                                              : () {
                                                                  if (consecutiveAfkTimeouts >=
                                                                      afkStopLimit) {
                                                                    endGame(
                                                                      autoStoppedByAfk:
                                                                          true,
                                                                    );
                                                                    return;
                                                                  }
                                                                  currentIndex =
                                                                      totalAnswers +
                                                                      1;
                                                                  questionSwapController
                                                                      .reverse(
                                                                        from: 1,
                                                                      );
                                                                  Future.delayed(
                                                                    const Duration(
                                                                      milliseconds:
                                                                          90,
                                                                    ),
                                                                    () {
                                                                      if (!mounted) {
                                                                        return;
                                                                      }
                                                                      nextQuestion();
                                                                    },
                                                                  );
                                                                },
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 12),
                                                    SizedBox(
                                                      height: kButtonHeight,
                                                      child: _DangerButton(
                                                        label: 'Mettre fin',
                                                        onTap: stopSeries,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  // L'overlay de feedback a été retiré : il se
                                  // superposait au bandeau d'explication dès que
                                  // l'énoncé était long. L'animation vit maintenant
                                  // dans `_OutcomeIcon`, bornée par le bandeau.
                                  if (showDifficultyScreen ||
                                      shouldForceDifficultySplash)
                                    _DifficultySplash(
                                      fade: _difficultySplashFade,
                                      isDark: isDark,
                                      selected: selectedDifficulty,
                                      onSelect: (d) => setState(() {
                                        selectedDifficulty = d;
                                        randomMode = false;
                                        _recalculateAvailableCount();
                                      }),
                                      onStart: _startExercise,
                                      onStartRandom: () {
                                        setState(() {
                                          randomMode = true;
                                          selectedDifficulty = null;
                                          _recalculateAvailableCount();
                                        });
                                        _startExercise();
                                      },
                                    ),
                                  if (showIntroScreen)
                                    _IntroSplash(
                                      isDark: isDark,
                                      hideForever: hideIntroForever,
                                      onChangedHideForever:
                                          _saveIntroPreference,
                                      onStart: _beginSessionNow,
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
        );
      },
    );
  }
}

// ============================================================================
// SUPPORT WIDGETS
// ============================================================================
class _FatalState extends StatelessWidget {
  final bool isDark;
  final String title;
  final String message;
  final VoidCallback onRetry;

  const _FatalState({
    required this.isDark,
    required this.title,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final textMain = isDark ? Colors.white : _Brand.textDark;
    final sub = isDark
        ? Colors.white.withAlpha(210)
        : _Brand.textDark.withAlpha(210);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 460),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF101826) : Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isDark
                    ? const Color(0xFF253247)
                    : const Color(0xFFE3EAF5),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline_rounded,
                  color: _Brand.bad,
                  size: 42,
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: _Brand.h1(
                    context,
                  ).copyWith(color: textMain, fontSize: 22),
                ),
                const SizedBox(height: 10),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: sub,
                    height: 1.45,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.none,
                  ),
                ),
                const SizedBox(height: 18),
                ElevatedButton(
                  onPressed: onRetry,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark ? Colors.white : _Brand.textDark,
                    foregroundColor: isDark ? Colors.black : Colors.white,
                  ),
                  child: const Text('Réessayer'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TimerRing extends StatelessWidget {
  final AnimationController timer;
  final int durationSeconds;
  final Color Function(double progress) timerColorBuilder;
  final Color border;

  const _TimerRing({
    required this.timer,
    required this.durationSeconds,
    required this.timerColorBuilder,
    required this.border,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: timer,
      builder: (_, __) {
        final progress = timer.value;
        final remaining = math.max(
          0,
          (durationSeconds * (1 - progress)).ceil(),
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
          backgroundColor: _opa(_Brand.bad, .10),
          foregroundColor: isEnabled ? _Brand.bad : _opa(_Brand.bad, .35),
          side: BorderSide(
            color: _opa(isEnabled ? _Brand.bad : _opa(_Brand.bad, .35), .55),
            width: 1.4,
          ),
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
  final PaSuiteLogiqueQuestion question;
  final List<String> options;
  final String? selected;
  final ValueChanged<String> onSelect;
  final bool locked;
  final bool showOutcome;
  final bool isCorrect;

  /// `true` quand cette page est celle que l'utilisateur regarde.
  ///
  /// Indispensable : `PageView.builder` construit aussi les pages voisines
  /// à l'avance. Sans ce garde-fou, la cascade de la question suivante se
  /// jouerait hors écran et serait déjà terminée à l'arrivée.
  final bool estActive;

  /// Contrôleur du feedback, relancé à chaque validation par `_validate`.
  final AnimationController pulse;

  final double bottomSafeInset;

  const _QuestionCard({
    required this.question,
    required this.options,
    required this.selected,
    required this.onSelect,
    required this.locked,
    required this.showOutcome,
    required this.isCorrect,
    required this.estActive,
    required this.pulse,
    this.bottomSafeInset = 0,
  });

  @override
  State<_QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<_QuestionCard>
    with SingleTickerProviderStateMixin {
  // ─── Cascade d'apparition ────────────────────────────────────────────────
  //
  // Un seul `AnimationController` pilote la séquence ; chaque élément lit une
  // fenêtre différente de sa progression via un `Interval`. L'alternative — un
  // contrôleur et un `Timer` par élément — multiplierait les tickers par le
  // nombre d'options, sur chaque page vivante du `PageView`.
  static const int _msElement = 420;
  static const int _msDecalage = 130;

  int get _nbElements =>
      1 + (_afficheSousTitre ? 1 : 0) + widget.options.length;

  /// Le sous-titre compte comme un élément de la séquence quand il est affiché.
  /// Ce modèle de question n'a pas de champ `sub` : la séquence ne compte donc
  /// que le titre et les options.
  bool get _afficheSousTitre => false;

  int get _msTotal => _msDecalage * (_nbElements - 1) + _msElement;

  late final AnimationController _cascade = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: _msTotal),
  );

  /// Contrôleur de la colonne, pour amener le bandeau de correction dans le champ
  /// de vision : sur un énoncé long, l'explication naissait sous le pli.
  final ScrollController _colonne = ScrollController();

  /// Ancre posée sur le bandeau, cible du défilement.
  final GlobalKey _ancreBandeau = GlobalKey();

  bool get _mouvementReduit => WidgetsBinding
      .instance
      .platformDispatcher
      .accessibilityFeatures
      .disableAnimations;

  @override
  void initState() {
    super.initState();
    // Accessibilité : on saute à l'état final, jamais à un état invisible.
    if (_mouvementReduit) {
      _cascade.value = 1;
    } else if (widget.estActive) {
      _cascade.forward();
    }
  }

  @override
  void didUpdateWidget(_QuestionCard old) {
    super.didUpdateWidget(old);

    final duree = Duration(milliseconds: _msTotal);
    if (_cascade.duration != duree) _cascade.duration = duree;

    if (_mouvementReduit) {
      _cascade.value = 1;
      return;
    }

    // La page vient de devenir celle qu'on regarde : la cascade démarre en même
    // temps que le glissement du `PageView`, `_index` étant mis à jour avant
    // l'appel à `nextPage`.
    if (!old.estActive && widget.estActive) {
      _cascade
        ..reset()
        ..forward();
    }

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

  void _revelerBandeau() {
    // Après la frame qui insère le bandeau : avant, sa position n'existe pas.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = _ancreBandeau.currentContext;
      if (ctx == null || !_colonne.hasClients) return;
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOutCubic,
        // 0.9 plutôt que 1.0 : le bandeau se cale vers le bas de la zone visible
        // en gardant les options au-dessus dans le champ.
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
  /// Beaucoup de questions répètent les réponses dans leur libellé, puis les
  /// mêmes options s'affichent juste en dessous : le titre double de hauteur et
  /// la question perd sa force. La coupe est conservatrice — il faut un `:` suivi
  /// de texte, **toutes** les options retrouvées après lui, une partie conservée
  /// d'au moins 15 caractères, et aucune option de moins de 4 caractères, qui se
  /// retrouverait par hasard dans n'importe quelle phrase.
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
    return avant.endsWith('?') ? avant : '$avant ?';
  }

  /// Taille du titre, réduite par palier quand l'énoncé s'allonge : à 28 px fixes
  /// et avec un réglage de texte système élevé, les options passaient sous le pli.
  double _tailleTitre(String enonce) {
    if (enonce.length > 150) return 21;
    if (enonce.length > 110) return 23;
    if (enonce.length > 75) return 25;
    return 28;
  }

  @override
  Widget build(BuildContext context) {
    // Rang dans la cascade : le titre ouvre, le sous-titre suit s'il
    // existe, puis les options dans l'ordre d'affichage.
    var rangCascade = 0;
    final enonce = _enonceAffiche;
    final textCol = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : _Brand.textDark;

    return SingleChildScrollView(
      controller: _colonne,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.only(top: 8, bottom: 12 + widget.bottomSafeInset),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.question.category.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _SoftPill(label: widget.question.category),
            ),
          _ElementCascade(
            animation: _fenetre(rangCascade++),
            child: Text(
              enonce,
              style: _Brand.h1(
                context,
              ).copyWith(color: textCol, fontSize: _tailleTitre(enonce)),
            ),
          ),
          if (widget.question.prompt != null &&
              widget.question.prompt!.trim().isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              widget.question.prompt!,
              style: TextStyle(
                color: textCol.withAlpha(180),
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.none,
              ),
            ),
          ],
          const SizedBox(height: 16),
          ...widget.options.where((o) => o.trim().isNotEmpty).map((o) {
            final isSel = widget.selected == o;
            final correctShown =
                widget.showOutcome && o == widget.question.answer;
            final wrongShown =
                widget.showOutcome && isSel && o != widget.question.answer;

            return _ElementCascade(
              animation: _fenetre(rangCascade++),
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

class _SoftPill extends StatelessWidget {
  final String label;
  const _SoftPill({required this.label});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? _opa(Colors.white, .06) : const Color(0xFFF3F5FA),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: isDark ? _opa(Colors.white, .12) : const Color(0xFFE6EBF5),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isDark ? Colors.white : _Brand.textDark,
          fontWeight: FontWeight.w800,
          fontSize: 12,
          decoration: TextDecoration.none,
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

    // Dimensionnement adaptatif, sur deux axes : la largeur d'écran — 28 px
    // fixes paraissaient gros sur un petit téléphone et perdus sur une tablette
    // — et le réglage de taille de texte du système, l'icône devant grandir avec
    // l'explication qu'elle accompagne.
    final largeur = MediaQuery.sizeOf(context).width;
    final scaler = MediaQuery.textScalerOf(context);
    final double tailleIcone = scaler
        .scale((largeur / 13.5).clamp(24.0, 34.0))
        .clamp(24.0, 52.0);

    // Zone carrée un peu plus large que l'icône : les étincelles s'y déploient
    // sans empiéter sur le texte, puisqu'elles sont bornées ici et non posées en
    // overlay au-dessus de la page.
    final zone = tailleIcone * 1.7;

    // Alignement optique : l'icône est centrée dans `zone`, son centre est donc
    // à `zone / 2`. La première ligne du texte s'y cale, moins sa demi-hauteur.
    const double tailleTexte = 14.0;
    const double hauteurLigne = 1.32;
    final double demiLigne = scaler.scale(tailleTexte) * hauteurLigne / 2;
    final double decalageTexte = (zone / 2 - demiLigne).clamp(0.0, 24.0);

    // Une seule boîte peinte : bord et fond partagent la même `BoxDecoration`,
    // et la marge est passée à l'extérieur du widget bordé.
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _opa(color, .10),
          // 22 comme les options : le bandeau est collé sous la dernière, à
          // largeur identique — une rupture de rayon se verrait.
          borderRadius: BorderRadius.circular(22),
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

// `_FeedbackStrip` et `_FeedbackSparkles` supprimés : l'animation de résultat
// vit désormais dans `_OutcomeIcon`, à l'intérieur du bandeau d'explication.
// `_Star` est conservé, il sert aux étincelles.

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
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.fromLTRB(22, 22, 22, 18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .12),
                    blurRadius: 26,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 82,
                    height: 82,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: accentSoft,
                    ),
                    child: Icon(heroIcon, color: accent, size: 42),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w900,
                      color: _Brand.textDark,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.45,
                      color: _Brand.textDark.withValues(alpha: .76),
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF6F8FC),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _ResultMetric(
                                label: 'Bonnes réponses',
                                value: '$correctAnswers/$totalAnswers',
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _ResultMetric(
                                label: 'Précision',
                                value: '$accuracy%',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: _ResultMetric(
                                label: 'Temps total',
                                value: '${totalDuration.round()} s',
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _ResultMetric(
                                label: 'Temps moyen',
                                value: '${avgTime.toStringAsFixed(1)} s',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: onBack,
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(52),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: const Text(
                            'Quitter',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton(
                          onPressed: onRestart,
                          style: FilledButton.styleFrom(
                            minimumSize: const Size.fromHeight(52),
                            backgroundColor: _Brand.accent,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: const Text(
                            'Recommencer',
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
          ),
        ),
      ),
    );
  }
}

class _ResultMetric extends StatelessWidget {
  final String label;
  final String value;

  const _ResultMetric({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: _Brand.textDark,
              fontSize: 18,
              fontWeight: FontWeight.w900,
              decoration: TextDecoration.none,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _Brand.textDark.withValues(alpha: .72),
              fontSize: 12,
              fontWeight: FontWeight.w700,
              decoration: TextDecoration.none,
            ),
          ),
        ],
      ),
    );
  }
}

class _IntroSplash extends StatelessWidget {
  final bool isDark;
  final bool hideForever;
  final ValueChanged<bool> onChangedHideForever;
  final VoidCallback onStart;

  const _IntroSplash({
    required this.isDark,
    required this.hideForever,
    required this.onChangedHideForever,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    final textMain = isDark ? Colors.white : _Brand.textDark;
    final sub = isDark
        ? Colors.white.withAlpha(210)
        : _Brand.textDark.withAlpha(210);

    return Positioned.fill(
      child: Container(
        color: isDark ? const Color(0xFF08111D) : const Color(0xFFF4F7FB),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF101826) : Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF253247)
                          : const Color(0xFFE3EAF5),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha: isDark ? .22 : .08,
                        ),
                        blurRadius: 18,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.hub_rounded,
                        size: 48,
                        color: _Brand.accent,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Comment ça marche ?',
                        textAlign: TextAlign.center,
                        style: _Brand.h1(
                          context,
                        ).copyWith(color: textMain, fontSize: 24),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Observe la suite, trouve la logique, puis sélectionne la bonne réponse avant la fin du temps. L’explication reste visible jusqu’à ce que tu appuies sur “Suivant”.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: sub,
                          fontWeight: FontWeight.w600,
                          height: 1.45,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          const Icon(
                            Icons.timer_outlined,
                            color: _Brand.accent,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '30 secondes par question',
                              style: TextStyle(
                                color: textMain,
                                fontWeight: FontWeight.w700,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(
                            Icons.auto_graph_rounded,
                            color: _Brand.good,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Série illimitée avec sauvegarde de l’historique',
                              style: TextStyle(
                                color: textMain,
                                fontWeight: FontWeight.w700,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        controlAffinity: ListTileControlAffinity.leading,
                        value: hideForever,
                        onChanged: (v) => onChangedHideForever(v ?? false),
                        title: Text(
                          'Ne plus afficher cet écran',
                          style: TextStyle(
                            color: textMain,
                            fontWeight: FontWeight.w700,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 56,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: onStart,
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: isDark
                                ? Colors.white
                                : _Brand.textDark,
                            foregroundColor: isDark
                                ? Colors.black
                                : Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                          ),
                          child: const Text(
                            'Commencer la série',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
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
          ),
        ),
      ),
    );
  }
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
    with SingleTickerProviderStateMixin {
  // ─── Cascade d'ouverture ─────────────────────────────────────────────────
  //
  // Même mécanique et même widget (`_ElementCascade`) que l'arrivée d'une
  // question : un seul contrôleur, chaque élément lisant une fenêtre différente
  // de sa progression via un `Interval`. Les deux écrans partagent donc le même
  // geste — fondu plus montée de 10 px.
  //
  // Rangs explicites plutôt qu'un compteur incrémenté pendant le build : le
  // `LayoutBuilder` des cartes peut être rappelé à chaque relayout, et un
  // compteur mutable y dériverait à chaque passe.
  static const int _msElement = 380;
  static const int _msDecalage = 90;
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
    // On saute à l'état final, jamais à un écran vide.
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
    const total = _msDecalage * (_nbElements - 1) + _msElement;
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
            // page. Il empilait auparavant son dégradé et ses halos par-dessus
            // celui du quiz — deux systèmes d'animation superposés, et une
            // rupture de teinte au démarrage. Un voile suffit à détacher le
            // contenu du fond.
            Positioned.fill(
              child: IgnorePointer(
                child: ColoredBox(
                  color: Colors.black.withValues(alpha: isDark ? .28 : .04),
                ),
              ),
            ),
            SafeArea(
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
                        Text(
                          'Choisis Facile, Moyenne ou Difficile pour adapter les questions à ton niveau.',
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
                            const spacing = 12.0;
                            final itemW = wide
                                ? (c.maxWidth - spacing * 2) / 3
                                : c.maxWidth;

                            final children = [
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
                              _LevelCard(
                                label: 'Moyenne',
                                icon: Icons.military_tech_rounded,
                                tint: const Color(0xFFF59E0B),
                                active: widget.selected == 'Moyenne',
                                onTap: () => widget.onSelect('Moyenne'),
                                isDark: isDark,
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
                            }

                            return Column(
                              children: [
                                children[0],
                                const SizedBox(height: 10),
                                children[1],
                                const SizedBox(height: 10),
                                children[2],
                              ],
                            );
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
                            child: Text(
                              widget.selected == null
                                  ? 'Choisis un niveau'
                                  : 'Commencer',
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        _ElementCascade(
                          animation: _fenetre(_rangMelanger),
                          child: SizedBox(
                            height: 56,
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: widget.onStartRandom,
                              icon: const Icon(Icons.shuffle_rounded, size: 20),
                              label: const Text('Mélanger les 3 niveaux'),
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

// `_AnimatedBackground` supprimé : dégradé propre au splash, remplacé par le
// `_QuizBackdrop` de la page. Un seul fond pour tout l'écran.

class _Halo extends StatelessWidget {
  final Color color;
  final double size;
  final double dx;
  final double dy;
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

  /// Icône du niveau. Remplace un emoji, dont le dessin dépend de la police
  /// système et dont la couleur n'est pas contrôlable.
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

    // Carte fixe. Le `AnimatedBuilder` + `Transform.translate` qui la
    // faisait osciller de ±2 px a été retiré : sur trois cartes à
    // comparer, ce balancement désalignait les bords en permanence.
    return AnimatedScale(
      duration: const Duration(milliseconds: 180),
      scale: active ? 1.02 : 1.0,
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
    );
  }
}

/// Assombrit une teinte pour qu'elle reste lisible sur fond clair.
///
/// Les teintes de niveau sont vives (#22C55E, #F59E0B, #EF4444) : parfaites sur
/// fond sombre, trop claires en thème clair. On les rabat vers le noir plutôt
/// que d'entretenir une seconde palette en parallèle.
Color _assombrir(Color c, [double facteur = .45]) =>
    Color.lerp(c, Colors.black, facteur)!;

/// Fond du quiz, dans les deux thèmes.
///
/// Remplace un aplat (noir pur ou gris #2C2C2E) par la matière du module Cas
/// pratiques : dégradé navy, halo de lumière derrière la question, masses
/// colorées dérivantes, vignette. Le thème clair a la même construction en
/// lumineux — ce n'est pas un fond au rabais.
///
/// Trois précautions, ce fond vivant sous un `PageView` :
///  * `RepaintBoundary` isole la couche du reste de l'écran ;
///  * un seul contrôleur de 26 s pour les trois halos ;
///  * aucun flou, coûteux sur mobile d'entrée de gamme — les halos sont des
///    `RadialGradient`, déjà diffus.
class _QuizBackdrop extends StatefulWidget {
  const _QuizBackdrop({required this.isDark});
  final bool isDark;
  @override
  State<_QuizBackdrop> createState() => _QuizBackdropState();
}

class _QuizBackdropState extends State<_QuizBackdrop>
    with SingleTickerProviderStateMixin {
  static const Color _navyTop = Color(0xFF000B36);
  static const Color _navyMid = Color(0xFF000A33);
  static const Color _navyBot = Color(0xFF00082D);

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
    final degrade = sombre
        ? const [_navyTop, _navyMid, _navyBot]
        : const [_clairTop, _clairMid, _clairBot];
    // Un halo blanc serait invisible sur un fond clair : la lumière vient alors
    // du bleu brand, en très faible densité.
    final halo = sombre ? Colors.white : _Brand.accent;
    final haloFort = sombre ? 0.10 : 0.07;
    final haloFaible = sombre ? 0.035 : 0.025;
    // Du noir salirait le thème clair : on referme au bleu dilué.
    final vignette = sombre
        ? Colors.black.withValues(alpha: 0.42)
        : _Brand.accent.withValues(alpha: 0.10);

    return RepaintBoundary(
      child: Stack(
        fit: StackFit.expand,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: degrade,
              ),
            ),
          ),
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

/// Un élément d'une cascade d'apparition : fondu et montée de 10 px.
///
/// `FadeTransition` gère l'opacité sans rien reconstruire, et l'enfant est passé
/// à `AnimatedBuilder` via `child:` — seul le `Transform` est rebâti à chaque
/// frame, jamais le contenu.
///
/// Le décalage est en pixels et non en fraction de hauteur (ce que ferait un
/// `SlideTransition`) : un titre et une option n'ont pas la même hauteur, et une
/// fraction commune donnerait des amplitudes différentes.
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

/// Icône de résultat animée : rebond à l'apparition, puis étincelles qui
/// s'écartent et s'effacent.
///
/// Remplace une croix flottante de 240 px posée en overlay au-dessus de la page,
/// qui chevauchait l'explication dès que l'énoncé était long. Bornée par le
/// `SizedBox` du bandeau, elle ne peut plus rien recouvrir.
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

          // Une fois l'animation finie, on ne peint plus que l'icône : aucune
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

          // `Curves.elasticOut` serait trop remuant à côté d'un texte qu'on veut
          // lire : un simple dépassement suffit.
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

/// Carte de confirmation avant une sortie de quiz.
///
/// Sert la croix comme le bouton « Mettre fin » : même mise en page, seuls le
/// titre et le libellé de l'action changent. Remplace un `AlertDialog` Material,
/// qui détonnait avec le reste de l'écran.
///
/// Hiérarchie assumée — l'action sûre est en bas, pleine et dans l'accent de
/// l'app : la plus atteignable au pouce et la plus visible. L'action destructive
/// est au-dessus, en contour rouge : identifiable, jamais tentante.
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
                // Pastille d'avertissement : donne un point d'entrée au regard et
                // annonce la nature de l'action avant même la lecture.
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
                    color: _opa(texte, .70),
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
