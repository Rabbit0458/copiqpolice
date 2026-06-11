// COP'IQ — Page générique d'exercice psychotechnique.
//
// C'est le moteur partagé : choisit la difficulté, affiche l'intro,
// charge les questions Supabase, affiche le quiz, sauvegarde l'historique.
// Les pages spécifiques (calcul_mental, logique_verbale...) instancient
// simplement cette page avec leur configuration.

import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/psycho_question.dart';
import '../services/psycho_history_service.dart';
import '../services/psycho_question_service.dart';
import '../widgets/psycho_brand.dart';
import '../widgets/psycho_dialogs.dart';
import '../widgets/psycho_difficulty_screen.dart';
import '../widgets/psycho_intro_screen.dart';
import '../widgets/psycho_quiz_widgets.dart';
import '../widgets/psycho_result_screen.dart';
import '../widgets/psycho_states.dart';

class PsychoQuizConfig {
  final String exerciseTitle;
  final String exerciseSubtitle;
  final IconData exerciseIcon;
  final Color exerciseColor;
  final String routeName; // ex: '/gpx_exam/concours/tests_psychotechniques/calcul_mental'
  final String category; // ex: PsychoCategory.calculMental
  final String tableName; // ex: PsychoTable.calculMental — pour le compteur
  final String introHidePrefKey; // unique par exercice
  final int questionDuration; // secondes par question
  final int sessionLength; // nombre de questions
  final String objectiveText;
  final String howToText;
  final String? exampleText;
  final String? tipText;
  final String timerText;

  const PsychoQuizConfig({
    required this.exerciseTitle,
    required this.exerciseSubtitle,
    required this.exerciseIcon,
    required this.exerciseColor,
    required this.routeName,
    required this.category,
    required this.tableName,
    required this.introHidePrefKey,
    required this.objectiveText,
    required this.howToText,
    required this.timerText,
    this.exampleText,
    this.tipText,
    this.questionDuration = 30,
    this.sessionLength = 10,
  });
}

enum _Phase { difficulty, intro, loading, quiz, result, error }

class PsychoQuizPage extends StatefulWidget {
  final PsychoQuizConfig config;
  const PsychoQuizPage({super.key, required this.config});

  @override
  State<PsychoQuizPage> createState() => _PsychoQuizPageState();
}

class _PsychoQuizPageState extends State<PsychoQuizPage>
    with TickerProviderStateMixin {
  // Services
  final PsychoQuestionService _service = PsychoQuestionService();
  final PsychoHistoryService _history = PsychoHistoryService();

  // État global
  _Phase _phase = _Phase.difficulty;
  String? _selectedDifficulty;
  bool _hideIntroForever = false;
  String? _errorMessage;

  // Compteurs disponibles par niveau (pour difficulty screen)
  Map<String, int> _availableByLevel = {};

  // Quiz
  List<PsychoQuestion> _questions = [];
  int _index = 0;
  PsychoOption? _picked;
  bool _answerLocked = false;
  bool _isCorrect = false;
  int _correct = 0;
  int _wrong = 0;
  bool _isSavingResult = false;

  // Timing
  late AnimationController _timerCtrl;
  DateTime? _questionStartedAt;
  DateTime? _sessionStartedAt;
  final List<double> _responseTimes = [];

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _timerCtrl = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.config.questionDuration),
    )..addStatusListener((s) {
      if (s == AnimationStatus.completed && !_answerLocked) {
        _onTimeout();
      }
    });
    _loadIntroPref();
    _refreshAvailableCounts();
  }

  @override
  void dispose() {
    _timerCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadIntroPref() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _hideIntroForever = prefs.getBool(widget.config.introHidePrefKey) ?? false;
    });
  }

  Future<void> _refreshAvailableCounts() async {
    // En cas d'erreur réseau, on garde silencieusement les compteurs vides.
    final levels = ['Facile', 'Moyenne', 'Difficile'];
    final results = await Future.wait(
      levels.map(
        (l) => _service.countAvailable(
          table: widget.config.tableName,
          difficulty: l,
        ),
      ),
    );
    if (!mounted) return;
    setState(() {
      _availableByLevel = {
        for (var i = 0; i < levels.length; i++) levels[i]: results[i],
      };
    });
  }

  // ==========================================================================
  // FLOW
  // ==========================================================================
  Future<void> _chooseDifficulty(String d) async {
    setState(() {
      _selectedDifficulty = d;
      _phase = _hideIntroForever ? _Phase.loading : _Phase.intro;
    });
    if (_hideIntroForever) {
      await _startQuiz();
    }
  }

  Future<void> _startQuiz() async {
    setState(() {
      _phase = _Phase.loading;
      _errorMessage = null;
    });
    try {
      final list = await _service.loadByCategory(
        category: widget.config.category,
        difficulty: _selectedDifficulty!,
        limit: widget.config.sessionLength,
      );
      if (!mounted) return;
      if (list.isEmpty) {
        setState(() {
          _phase = _Phase.error;
          _errorMessage =
              'Aucune question disponible pour ce niveau. '
              'Reviens plus tard ou choisis un autre niveau.';
        });
        return;
      }
      setState(() {
        _questions = list;
        _index = 0;
        _correct = 0;
        _wrong = 0;
        _picked = null;
        _answerLocked = false;
        _responseTimes.clear();
        _sessionStartedAt = DateTime.now();
        _phase = _Phase.quiz;
      });
      _startQuestionTimer();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _phase = _Phase.error;
        _errorMessage =
            'Impossible de charger les questions. Vérifie ta connexion.';
      });
    }
  }

  void _startQuestionTimer() {
    _questionStartedAt = DateTime.now();
    _timerCtrl
      ..stop()
      ..reset();
    _timerCtrl.forward();
  }

  void _onPick(PsychoOption opt) {
    if (_answerLocked) return;
    final q = _questions[_index];
    final isCorrect = q.isCorrect(opt);
    final elapsed =
        DateTime.now().difference(_questionStartedAt!).inMilliseconds / 1000.0;

    setState(() {
      _picked = opt;
      _answerLocked = true;
      _isCorrect = isCorrect;
      _responseTimes.add(elapsed);
      if (isCorrect) {
        _correct++;
      } else {
        _wrong++;
      }
    });
    _timerCtrl.stop();
    HapticFeedback.lightImpact();
  }

  void _onTimeout() {
    if (_answerLocked || !mounted) return;
    setState(() {
      _picked = null;
      _answerLocked = true;
      _isCorrect = false;
      _wrong++;
      _responseTimes.add(widget.config.questionDuration.toDouble());
    });
    HapticFeedback.mediumImpact();
    // La bonne réponse est mise en surbrillance via PsychoAnswerButton
    // grâce à isLocked + answer (pas besoin d'état supplémentaire ici).
  }

  void _next() {
    if (_index + 1 >= _questions.length) {
      _finishSession();
      return;
    }
    setState(() {
      _index++;
      _picked = null;
      _answerLocked = false;
      _isCorrect = false;
    });
    _startQuestionTimer();
  }

  Future<void> _finishSession() async {
    final total = _questions.length;
    final score = total == 0 ? 0 : ((_correct / total) * 100).round();
    final duration =
        _sessionStartedAt == null
            ? 0
            : DateTime.now().difference(_sessionStartedAt!).inSeconds;
    final avg = _responseTimes.isEmpty
        ? 0.0
        : _responseTimes.reduce((a, b) => a + b) / _responseTimes.length;

    setState(() {
      _phase = _Phase.result;
      _isSavingResult = true;
    });
    await _history.saveSession(
      exerciseType: widget.config.category,
      score: score,
      correctAnswers: _correct,
      wrongAnswers: _wrong,
      totalQuestions: total,
      durationSeconds: duration,
      avgResponseTime: avg,
      mode: 'concours',
    );
    if (!mounted) return;
    setState(() {
      _isSavingResult = false;
    });
  }

  // Route home utilisée pour le retour propre lorsqu'on quitte un exercice.
  static const String _kHomeRouteName = '/home-gpx-exam';

  /// Met le chrono en pause et capture le timestamp pour pouvoir reprendre
  /// proprement à la même position si l'utilisateur annule la sortie ou le
  /// signalement.
  ({double timerValue, DateTime? pauseStart}) _pauseTimer() {
    final wasInQuiz = _phase == _Phase.quiz && !_answerLocked;
    final v = _timerCtrl.value;
    if (wasInQuiz) {
      _timerCtrl.stop();
      return (timerValue: v, pauseStart: DateTime.now());
    }
    return (timerValue: v, pauseStart: null);
  }

  /// Reprend le chrono là où il s'était arrêté et recale [_questionStartedAt]
  /// pour que les statistiques de temps de réponse restent justes.
  void _resumeTimer(({double timerValue, DateTime? pauseStart}) state) {
    if (state.pauseStart == null) return;
    if (_phase != _Phase.quiz || _answerLocked) return;
    final pausedFor = DateTime.now().difference(state.pauseStart!);
    if (_questionStartedAt != null) {
      _questionStartedAt = _questionStartedAt!.add(pausedFor);
    }
    _timerCtrl.forward(from: state.timerValue);
  }

  Future<void> _confirmExit() async {
    final pauseState = _pauseTimer();
    final ok = await showPsychoExitDialog(context);
    if (!mounted) return;

    if (ok) {
      _timerCtrl.stop();
      // Retour à la home des exercices Gardien de la paix : on remonte la
      // pile jusqu'à HomePageGpxExam (ou jusqu'à la racine si elle ne s'y
      // trouve pas, par sécurité).
      Navigator.of(context).popUntil(
        (route) => route.settings.name == _kHomeRouteName || route.isFirst,
      );
      return;
    }

    // L'utilisateur a choisi « Continuer » → on reprend là où on en était.
    _resumeTimer(pauseState);
  }

  Future<void> _openReportSheet() async {
    final q = _questions[_index];
    final pauseState = _pauseTimer();
    await showPsychoReportSheet(
      context: context,
      question: q,
      pageRouteName: widget.config.routeName,
    );
    if (!mounted) return;
    // showPsychoReportSheet déclenche déjà AppNotifier en cas de succès.
    _resumeTimer(pauseState);
  }

  // ==========================================================================
  // BUILDERS
  // ==========================================================================
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _phase == _Phase.difficulty,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (_phase == _Phase.quiz) {
          await _confirmExit();
        } else {
          if (mounted) Navigator.maybePop(context);
        }
      },
      child: Scaffold(
        backgroundColor: PsychoBrand.bg(context),
        body: _buildPhase(context),
      ),
    );
  }

  Widget _buildPhase(BuildContext context) {
    switch (_phase) {
      case _Phase.difficulty:
        return _buildDifficulty();
      case _Phase.intro:
        return _buildIntro();
      case _Phase.loading:
        return const SafeArea(
          child: Center(
            child: PsychoLoadingState(
              message: 'Préparation de tes questions…',
            ),
          ),
        );
      case _Phase.quiz:
        return SafeArea(child: _buildQuiz());
      case _Phase.result:
        return _buildResult();
      case _Phase.error:
        return SafeArea(
          child: PsychoErrorState(
            message: _errorMessage ?? 'Une erreur est survenue.',
            onRetry: () => setState(() => _phase = _Phase.difficulty),
          ),
        );
    }
  }

  Widget _buildDifficulty() {
    final color = widget.config.exerciseColor;
    return PsychoDifficultyScreen(
      exerciseTitle: widget.config.exerciseTitle,
      exerciseSubtitle: widget.config.exerciseSubtitle,
      exerciseIcon: widget.config.exerciseIcon,
      exerciseColor: color,
      onBack: () => Navigator.maybePop(context),
      onChoose: _chooseDifficulty,
      options: [
        PsychoDifficultyOption(
          label: 'Facile',
          description: 'Pour découvrir et prendre confiance.',
          icon: Icons.sentiment_satisfied_rounded,
          color: PsychoBrand.good,
          availableQuestions: _availableByLevel['Facile'],
        ),
        PsychoDifficultyOption(
          label: 'Moyenne',
          description: 'Niveau de référence du concours.',
          icon: Icons.shield_moon_outlined,
          color: PsychoBrand.warn,
          availableQuestions: _availableByLevel['Moyenne'],
        ),
        PsychoDifficultyOption(
          label: 'Difficile',
          description: 'Pour aller plus loin et te dépasser.',
          icon: Icons.local_fire_department_rounded,
          color: PsychoBrand.bad,
          availableQuestions: _availableByLevel['Difficile'],
        ),
      ],
    );
  }

  Widget _buildIntro() {
    return PsychoIntroScreen(
      title: widget.config.exerciseTitle,
      subtitle: widget.config.exerciseSubtitle,
      objective: widget.config.objectiveText,
      howTo: widget.config.howToText,
      example: widget.config.exampleText,
      tip: widget.config.tipText,
      timerText: widget.config.timerText,
      icon: widget.config.exerciseIcon,
      color: widget.config.exerciseColor,
      initialHideForever: _hideIntroForever,
      onHideForeverChanged: (v) async {
        setState(() => _hideIntroForever = v);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool(widget.config.introHidePrefKey, v);
      },
      onBack: () => setState(() => _phase = _Phase.difficulty),
      onStart: _startQuiz,
    );
  }

  Widget _buildQuiz() {
    final q = _questions[_index];
    final remaining = math.max(
      0,
      widget.config.questionDuration -
          (_questionStartedAt == null
              ? 0
              : DateTime.now().difference(_questionStartedAt!).inSeconds),
    );

    return AnimatedBuilder(
      animation: _timerCtrl,
      builder: (_, __) {
        final progress = 1 - _timerCtrl.value;
        final secs = math.max(
          0,
          widget.config.questionDuration -
              (_timerCtrl.value * widget.config.questionDuration).round(),
        );
        return Column(
          children: [
            PsychoTimerHeader(
              currentIndex: _index + 1,
              totalQuestions: _questions.length,
              progressTimer: progress,
              remainingSeconds: _answerLocked ? remaining : secs,
              onExit: _confirmExit,
              onReport: _openReportSheet,
              color: widget.config.exerciseColor,
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    PsychoQuestionCard(
                      question: q,
                      color: widget.config.exerciseColor,
                      icon: widget.config.exerciseIcon,
                    ),
                    const SizedBox(height: 14),
                    ...q.options.asMap().entries.map((entry) {
                      final i = entry.key;
                      final o = entry.value;
                      final isPicked = _picked?.key == o.key;
                      final isCorrectOpt =
                          o.key == q.answer || o.label == q.answer;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: PsychoAnswerButton(
                          option: o,
                          index: i,
                          isSelected: isPicked,
                          isLocked: _answerLocked,
                          isCorrect: isCorrectOpt,
                          isWrongPicked: isPicked && !isCorrectOpt,
                          color: widget.config.exerciseColor,
                          cubeNetContext: q,
                          onTap: _answerLocked ? null : () => _onPick(o),
                        ),
                      );
                    }),
                    if (_answerLocked) ...[
                      const SizedBox(height: 8),
                      PsychoExplanationCard(
                        isCorrect: _isCorrect,
                        explanation: q.explanation,
                        correctAnswerLabel:
                            q.findCorrectOption()?.label ?? q.answer,
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        height: 52,
                        child: FilledButton.icon(
                          onPressed: _next,
                          icon: const Icon(Icons.arrow_forward_rounded),
                          label: Text(
                            _index + 1 >= _questions.length
                                ? 'Voir les résultats'
                                : 'Question suivante',
                          ),
                          style: FilledButton.styleFrom(
                            backgroundColor:
                                widget.config.exerciseColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            textStyle: const TextStyle(
                              fontFamily: 'InstrumentSans',
                              fontWeight: FontWeight.w800,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildResult() {
    final total = _questions.length;
    final duration =
        _sessionStartedAt == null
            ? 0
            : DateTime.now().difference(_sessionStartedAt!).inSeconds;
    final avg = _responseTimes.isEmpty
        ? 0.0
        : _responseTimes.reduce((a, b) => a + b) / _responseTimes.length;
    return PsychoResultScreen(
      exerciseTitle: widget.config.exerciseTitle,
      difficulty: _selectedDifficulty ?? '—',
      icon: widget.config.exerciseIcon,
      color: widget.config.exerciseColor,
      correct: _correct,
      wrong: _wrong,
      total: total,
      durationSeconds: duration,
      avgResponseTime: avg,
      isSaving: _isSavingResult,
      onRestart: _startQuiz,
      onChangeLevel: () => setState(() => _phase = _Phase.difficulty),
      // « Retour aux exercices » → on remonte jusqu'à la home GPX.
      onBack: () => Navigator.of(context).popUntil(
        (route) => route.settings.name == _kHomeRouteName || route.isFirst,
      ),
    );

  }
}
