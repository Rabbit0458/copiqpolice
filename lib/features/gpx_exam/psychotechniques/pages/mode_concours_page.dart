// COP'IQ — Mode concours chronométré pour les tests psychotechniques.
//
// L'utilisateur choisit :
//   - une durée totale (2 / 5 / 10 minutes)
//   - une catégorie précise OU "toutes les catégories"
//
// Le mode tire des questions à la volée jusqu'à expiration du chrono global.
// Les bonnes/mauvaises réponses + temps moyen sont sauvegardés dans
// tests_psychotechnique_history avec mode = 'concours_global'.

import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/psycho_question.dart';
import '../services/psycho_history_service.dart';
import '../services/psycho_question_service.dart';
import '../widgets/psycho_brand.dart';
import '../widgets/psycho_dialogs.dart';
import '../widgets/psycho_quiz_widgets.dart';
import '../widgets/psycho_result_screen.dart';
import '../widgets/psycho_states.dart';

class ModeConcoursPsychoPage extends StatefulWidget {
  static const String routeName =
      '/gpx_exam/concours/tests_psychotechniques/mode_concours';

  const ModeConcoursPsychoPage({super.key});

  @override
  State<ModeConcoursPsychoPage> createState() => _ModeConcoursPsychoPageState();
}

enum _ConcoursPhase { setup, loading, running, result }

class _ModeConcoursPsychoPageState extends State<ModeConcoursPsychoPage> {
  final PsychoQuestionService _service = PsychoQuestionService();
  final PsychoHistoryService _history = PsychoHistoryService();
  final math.Random _random = math.Random();

  _ConcoursPhase _phase = _ConcoursPhase.setup;

  int _selectedDurationSec = 5 * 60;
  String? _selectedCategory; // null = toutes
  String _selectedDifficulty = 'Moyenne';

  List<PsychoQuestion> _pool = [];
  int _poolCursor = 0;
  PsychoQuestion? _current;
  PsychoOption? _picked;
  bool _answerLocked = false;
  bool _isCorrect = false;

  int _correct = 0;
  int _wrong = 0;
  final List<double> _responseTimes = [];

  Timer? _globalTimer;
  int _remainingSec = 0;
  DateTime? _sessionStart;
  DateTime? _questionStart;

  bool _isSavingResult = false;

  static const _categories = [
    {
      'key': PsychoCategory.attentionVisuelle,
      'label': 'Attention visuelle',
      'icon': Icons.visibility_rounded,
      'color': PsychoBrand.cAttention,
    },
    {
      'key': PsychoCategory.suiteLogique,
      'label': 'Suites logiques',
      'icon': Icons.timeline_rounded,
      'color': PsychoBrand.cSuiteLogique,
    },
    {
      'key': PsychoCategory.calculMental,
      'label': 'Calcul mental',
      'icon': Icons.calculate_rounded,
      'color': PsychoBrand.cCalcul,
    },
    {
      'key': PsychoCategory.logiqueVerbale,
      'label': 'Logique verbale',
      'icon': Icons.menu_book_rounded,
      'color': PsychoBrand.cVerbal,
    },
    {
      'key': PsychoCategory.raisonnementLogique,
      'label': 'Raisonnement logique',
      'icon': Icons.psychology_alt_rounded,
      'color': PsychoBrand.cRaisonnement,
    },
    {
      'key': PsychoCategory.raisonnementSpatial,
      'label': 'Raisonnement spatial',
      'icon': Icons.view_in_ar_rounded,
      'color': PsychoBrand.cSpatial,
    },
    {
      'key': PsychoCategory.rotationsSymetries,
      'label': 'Rotations & symétries',
      'icon': Icons.auto_awesome_motion_rounded,
      'color': PsychoBrand.cRotation,
    },
    {
      'key': PsychoCategory.concentration,
      'label': 'Concentration',
      'icon': Icons.center_focus_strong_rounded,
      'color': PsychoBrand.cConcentration,
    },
  ];

  @override
  void dispose() {
    _globalTimer?.cancel();
    super.dispose();
  }

  // ==========================================================================
  // FLOW
  // ==========================================================================
  Future<void> _startConcours() async {
    setState(() {
      _phase = _ConcoursPhase.loading;
      _correct = 0;
      _wrong = 0;
      _responseTimes.clear();
      _pool = [];
      _poolCursor = 0;
    });

    try {
      List<PsychoQuestion> all = [];
      if (_selectedCategory == null) {
        for (final cat in _categories) {
          final list = await _service.loadByCategory(
            category: cat['key'] as String,
            difficulty: _selectedDifficulty,
            limit: 30,
          );
          all.addAll(list);
        }
      } else {
        all = await _service.loadByCategory(
          category: _selectedCategory!,
          difficulty: _selectedDifficulty,
          limit: 60,
        );
      }
      all.shuffle(_random);

      if (all.isEmpty) {
        if (!mounted) return;
        setState(() => _phase = _ConcoursPhase.setup);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Aucune question disponible pour cette combinaison.',
              style: TextStyle(
                fontFamily: 'InstrumentSans',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        );
        return;
      }

      setState(() {
        _pool = all;
        _remainingSec = _selectedDurationSec;
        _sessionStart = DateTime.now();
        _phase = _ConcoursPhase.running;
      });
      _nextQuestion();
      _startGlobalTimer();
    } catch (e) {
      if (!mounted) return;
      setState(() => _phase = _ConcoursPhase.setup);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Impossible de charger les questions.'),
        ),
      );
    }
  }

  void _startGlobalTimer() {
    _globalTimer?.cancel();
    _globalTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() => _remainingSec--);
      if (_remainingSec <= 0) {
        t.cancel();
        _finishConcours();
      }
    });
  }

  void _nextQuestion() {
    if (_pool.isEmpty) return;
    if (_poolCursor >= _pool.length) {
      // On reboucle si jamais l'utilisateur dépasse le pool initial.
      _pool.shuffle(_random);
      _poolCursor = 0;
    }
    setState(() {
      _current = _pool[_poolCursor++];
      _picked = null;
      _answerLocked = false;
      _isCorrect = false;
      _questionStart = DateTime.now();
    });
  }

  void _onPick(PsychoOption opt) {
    if (_answerLocked || _current == null) return;
    final isCorrect = _current!.isCorrect(opt);
    final elapsed =
        DateTime.now().difference(_questionStart!).inMilliseconds / 1000.0;
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
    HapticFeedback.lightImpact();
  }

  Future<void> _finishConcours() async {
    _globalTimer?.cancel();
    final total = _correct + _wrong;
    final score = total == 0 ? 0 : ((_correct / total) * 100).round();
    final duration = _sessionStart == null
        ? 0
        : DateTime.now().difference(_sessionStart!).inSeconds;
    final avg = _responseTimes.isEmpty
        ? 0.0
        : _responseTimes.reduce((a, b) => a + b) / _responseTimes.length;
    setState(() {
      _phase = _ConcoursPhase.result;
      _isSavingResult = true;
    });
    await _history.saveSession(
      exerciseType: _selectedCategory ?? 'mode_concours_global',
      score: score,
      correctAnswers: _correct,
      wrongAnswers: _wrong,
      totalQuestions: total,
      durationSeconds: duration,
      avgResponseTime: avg,
      mode: 'concours_global',
    );
    if (!mounted) return;
    setState(() => _isSavingResult = false);
  }

  Future<void> _confirmExit() async {
    final ok = await showPsychoExitDialog(context);
    if (ok && mounted) {
      _globalTimer?.cancel();
      Navigator.maybePop(context);
    }
  }

  Future<void> _openReportSheet() async {
    if (_current == null) return;
    final ok = await showPsychoReportSheet(
      context: context,
      question: _current!,
      pageRouteName: ModeConcoursPsychoPage.routeName,
    );
    if (!mounted) return;
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: PsychoBrand.good,
          content: Text(
            'Signalement envoyé. Merci !',
            style: TextStyle(
              fontFamily: 'InstrumentSans',
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
    }
  }

  // ==========================================================================
  // BUILDERS
  // ==========================================================================
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _phase != _ConcoursPhase.running,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (_phase == _ConcoursPhase.running) {
          await _confirmExit();
        } else {
          if (mounted) Navigator.maybePop(context);
        }
      },
      child: Scaffold(
        backgroundColor: PsychoBrand.bg(context),
        body: switch (_phase) {
          _ConcoursPhase.setup => _buildSetup(),
          _ConcoursPhase.loading => const SafeArea(
            child: Center(
              child: PsychoLoadingState(
                message: 'Préparation du mode concours…',
              ),
            ),
          ),
          _ConcoursPhase.running => SafeArea(child: _buildRunning()),
          _ConcoursPhase.result => _buildResult(),
        },
      ),
    );
  }

  Widget _buildSetup() {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.maybePop(context),
                  icon: Icon(
                    Icons.arrow_back_rounded,
                    color: PsychoBrand.text(context),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: PsychoBrand.tinted(
                    context,
                    color: PsychoBrand.accent,
                    radius: 999,
                    alpha: .14,
                  ),
                  child: Text(
                    'Mode concours',
                    style: PsychoBrand.small(
                      context,
                    ).copyWith(color: PsychoBrand.accent),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Container(
              width: 64,
              height: 64,
              decoration: PsychoBrand.tinted(
                context,
                color: PsychoBrand.accent,
                radius: 22,
              ),
              child: const Icon(
                Icons.bolt_rounded,
                color: PsychoBrand.accent,
                size: 30,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Mode concours chronométré',
              style: PsychoBrand.h1(context),
            ),
            const SizedBox(height: 8),
            Text(
              'Réponds à un maximum de questions avant la fin du chrono.',
              style: PsychoBrand.body(context).copyWith(
                color: PsychoBrand.textMuted(context),
              ),
            ),
            const SizedBox(height: 22),
            Text('Durée', style: PsychoBrand.h3(context)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _Chip(
                  label: '2 minutes',
                  selected: _selectedDurationSec == 120,
                  onTap: () => setState(() => _selectedDurationSec = 120),
                ),
                _Chip(
                  label: '5 minutes',
                  selected: _selectedDurationSec == 300,
                  onTap: () => setState(() => _selectedDurationSec = 300),
                ),
                _Chip(
                  label: '10 minutes',
                  selected: _selectedDurationSec == 600,
                  onTap: () => setState(() => _selectedDurationSec = 600),
                ),
              ],
            ),
            const SizedBox(height: 22),
            Text('Difficulté', style: PsychoBrand.h3(context)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _Chip(
                  label: 'Facile',
                  selected: _selectedDifficulty == 'Facile',
                  onTap: () =>
                      setState(() => _selectedDifficulty = 'Facile'),
                ),
                _Chip(
                  label: 'Moyenne',
                  selected: _selectedDifficulty == 'Moyenne',
                  onTap: () =>
                      setState(() => _selectedDifficulty = 'Moyenne'),
                ),
                _Chip(
                  label: 'Difficile',
                  selected: _selectedDifficulty == 'Difficile',
                  onTap: () =>
                      setState(() => _selectedDifficulty = 'Difficile'),
                ),
              ],
            ),
            const SizedBox(height: 22),
            Text('Catégorie', style: PsychoBrand.h3(context)),
            const SizedBox(height: 10),
            _Chip(
              label: 'Toutes les catégories',
              icon: Icons.all_inclusive_rounded,
              selected: _selectedCategory == null,
              onTap: () => setState(() => _selectedCategory = null),
              fullWidth: true,
              color: PsychoBrand.accent,
            ),
            const SizedBox(height: 10),
            ..._categories.map(
              (c) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _Chip(
                  label: c['label'] as String,
                  icon: c['icon'] as IconData,
                  color: c['color'] as Color,
                  selected: _selectedCategory == c['key'],
                  onTap: () => setState(
                    () => _selectedCategory = c['key'] as String,
                  ),
                  fullWidth: true,
                ),
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: FilledButton.icon(
                onPressed: _startConcours,
                icon: const Icon(Icons.play_arrow_rounded),
                label: const Text('Démarrer le concours'),
                style: FilledButton.styleFrom(
                  backgroundColor: PsychoBrand.accent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  textStyle: const TextStyle(
                    fontFamily: 'InstrumentSans',
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRunning() {
    if (_current == null) {
      return const Center(child: PsychoLoadingState(message: 'Chargement…'));
    }
    final q = _current!;
    final progress = _selectedDurationSec == 0
        ? 0.0
        : _remainingSec / _selectedDurationSec;
    return Column(
      children: [
        PsychoTimerHeader(
          currentIndex: _correct + _wrong + 1,
          totalQuestions: _correct + _wrong + 1,
          progressTimer: progress.toDouble(),
          remainingSeconds: _remainingSec,
          onExit: _confirmExit,
          onReport: _openReportSheet,
          color: PsychoBrand.accent,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              _ScoreBadge(
                label: 'Bonnes',
                value: '$_correct',
                color: PsychoBrand.good,
              ),
              const SizedBox(width: 8),
              _ScoreBadge(
                label: 'Mauvaises',
                value: '$_wrong',
                color: PsychoBrand.bad,
              ),
              const Spacer(),
              _ScoreBadge(
                label: 'Cat.',
                value: _shortCategory(q.category),
                color: PsychoBrand.accent,
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PsychoQuestionCard(
                  question: q,
                  color: PsychoBrand.accent,
                  icon: Icons.bolt_rounded,
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
                      color: PsychoBrand.accent,
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
                      onPressed: _nextQuestion,
                      icon: const Icon(Icons.arrow_forward_rounded),
                      label: const Text('Question suivante'),
                      style: FilledButton.styleFrom(
                        backgroundColor: PsychoBrand.accent,
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
  }

  Widget _buildResult() {
    final total = _correct + _wrong;
    final duration = _sessionStart == null
        ? 0
        : DateTime.now().difference(_sessionStart!).inSeconds;
    final avg = _responseTimes.isEmpty
        ? 0.0
        : _responseTimes.reduce((a, b) => a + b) / _responseTimes.length;
    return PsychoResultScreen(
      exerciseTitle: 'Mode concours',
      difficulty: _selectedDifficulty,
      icon: Icons.bolt_rounded,
      color: PsychoBrand.accent,
      correct: _correct,
      wrong: _wrong,
      total: total,
      durationSeconds: duration,
      avgResponseTime: avg,
      isSaving: _isSavingResult,
      onRestart: _startConcours,
      onChangeLevel: () => setState(() => _phase = _ConcoursPhase.setup),
      onBack: () => Navigator.maybePop(context),
    );
  }

  String _shortCategory(String c) {
    switch (c) {
      case PsychoCategory.attentionVisuelle:
        return 'Attention';
      case PsychoCategory.suiteLogique:
        return 'Suites';
      case PsychoCategory.calculMental:
        return 'Calcul';
      case PsychoCategory.logiqueVerbale:
        return 'Verbal';
      case PsychoCategory.raisonnementLogique:
        return 'Raison.';
      case PsychoCategory.raisonnementSpatial:
        return 'Spatial';
      case PsychoCategory.rotationsSymetries:
        return 'Rotation';
      case PsychoCategory.concentration:
        return 'Focus';
    }
    return c;
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool selected;
  final VoidCallback onTap;
  final Color? color;
  final bool fullWidth;
  const _Chip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
    this.color,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? PsychoBrand.accent;
    final content = AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: selected ? psychoOpa(c, .10) : PsychoBrand.surface(context),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: selected ? c : PsychoBrand.borderColor(context),
          width: 1.4,
        ),
      ),
      child: Row(
        mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18, color: selected ? c : PsychoBrand.textMuted(context)),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Text(
              label,
              style: PsychoBrand.body(context).copyWith(
                fontWeight: FontWeight.w800,
                color: selected ? c : PsychoBrand.text(context),
              ),
            ),
          ),
          if (selected) Icon(Icons.check_rounded, color: c, size: 18),
        ],
      ),
    );
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: fullWidth ? SizedBox(width: double.infinity, child: content) : content,
    );
  }
}

class _ScoreBadge extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _ScoreBadge({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: PsychoBrand.tinted(
        context,
        color: color,
        radius: 999,
        alpha: .12,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: PsychoBrand.small(context).copyWith(color: color),
          ),
          const SizedBox(width: 6),
          Text(
            value,
            style: PsychoBrand.small(context).copyWith(
              color: color,
              fontWeight: FontWeight.w800,
              fontSize: 14,
            ),
          ),
        ],
    
      ),
    );
  }
}
