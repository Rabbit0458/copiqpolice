// lib/placement/placement_test.dart
import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:copiqpolice/features/onboarding/mode_picker.dart';
import 'package:copiqpolice/core/widgets/app_notifier.dart'
    show AppSettingsController, AppNotifier;

part 'widgets/placement_answer_tile.dart';
part 'widgets/placement_chrome.dart';
part 'widgets/placement_progress.dart';
part 'widgets/placement_question_card.dart';
part 'widgets/placement_result_view.dart';

Color scoreColorFromPct(double pct) {
  if (pct >= 70) return const Color(0xFF22C55E);
  if (pct >= 40) return const Color(0xFFF59E0B);
  return const Color(0xFFEF4444);
}

Color scoreColorFrom01(double pct01) => scoreColorFromPct(pct01 * 100);

class PlacementTest extends StatefulWidget {
  const PlacementTest({super.key, required this.onFinished});
  final VoidCallback onFinished;

  @override
  State<PlacementTest> createState() => _PlacementTestState();
}

class _PlacementTestState extends State<PlacementTest> {
  static const _bgDark = Color(0xFF000932);
  static const _bgLight = Color(0xFF0E44D6);
  static const int _totalQuestions = 30;
  static const Duration _totalDuration = Duration(minutes: 15);

  late final _engine = _PlacementEngine(_buildQuestionBank());

  _PlacementQuestion? _current;
  int _index = 0;
  int? _selectedIndex;
  bool _answerLocked = false;
  bool _submitting = false;

  Timer? _timer;
  Duration _remaining = _totalDuration;

  static const SystemUiOverlayStyle _overlay = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarIconBrightness: Brightness.light,
    systemStatusBarContrastEnforced: false,
    systemNavigationBarContrastEnforced: false,
  );

  bool _reduceMotion(BuildContext context) {
    final mq = MediaQuery.maybeOf(context);
    final disableByOS = WidgetsBinding
        .instance
        .platformDispatcher
        .accessibilityFeatures
        .disableAnimations;
    return (mq?.disableAnimations ?? false) || disableByOS;
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(_overlay);
    _current = _engine.nextQuestion();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(_overlay);
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      if (_remaining.inSeconds <= 1) {
        setState(() => _remaining = Duration.zero);
        _finish(auto: true);
        return;
      }
      setState(() => _remaining -= const Duration(seconds: 1));
    });
  }

  String _formatTime(Duration d) {
    final m = d.inMinutes;
    final s = d.inSeconds - m * 60;
    final mm = m.toString().padLeft(2, '0');
    final ss = s.toString().padLeft(2, '0');
    return '$mm:$ss';
  }

  Future<void> _finish({required bool auto}) async {
    if (_submitting) return;
    if (mounted) setState(() => _submitting = true);
    _timer?.cancel();

    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user == null) {
      if (mounted) {
        AppNotifier.error(
          context,
          title: 'Connexion requise',
          message: 'Connecte-toi pour sauvegarder le résultat du test.',
        );
      }
      widget.onFinished();
      return;
    }

    final mode = AppSettingsController.I.themeMode.value;
    final isDark = mode == ThemeMode.dark;
    final baseBg = isDark ? _bgDark : _bgLight;

    try {
      final totalScore = _engine.totalScore;
      final maxScore = _engine.maxScore;
      final pct = maxScore == 0 ? 0.0 : (totalScore / maxScore) * 100.0;

      final inserted = await supabase
          .from('placement_results')
          .insert({
            'user_id': user.id,
            'email': user.email ?? '',
            'total_score': totalScore,
            'max_score': maxScore,
            'score_pct': pct,
          })
          .select('id')
          .single();

      final resultId = inserted['id'] as String;
      final answersPayload = _engine.answers.map((a) {
        return {
          'result_id': resultId,
          'user_id': user.id,
          'question_id': a.questionId,
          'domain': a.domain.name,
          'selected_index': a.selectedIndex,
          'correct_index': a.correctIndex,
          'is_correct': a.isCorrect,
        };
      }).toList();

      if (answersPayload.isNotEmpty) {
        await supabase.from('placement_answers').insert(answersPayload);
      }

      if (!mounted) return;
      HapticFeedback.selectionClick();

      _showResultDialog(
        scorePct: pct,
        totalScore: totalScore,
        maxScore: maxScore,
        auto: auto,
        perDomain: _engine.scoreByDomain,
        answers: _engine.answers,
        byId: _engine.byId,
        isDark: isDark,
        baseBg: baseBg,
      );
    } catch (_) {
      if (mounted) {
        AppNotifier.error(
          context,
          title: 'Erreur',
          message: 'Impossible de sauvegarder le résultat. Réessaie.',
        );
        widget.onFinished();
      }
    }
  }

  void _showResultDialog({
    required double scorePct,
    required int totalScore,
    required int maxScore,
    required bool auto,
    required Map<PlacementDomain, _DomainScore> perDomain,
    required List<_AnswerLog> answers,
    required Map<String, _PlacementQuestion> byId,
    required bool isDark,
    required Color baseBg,
  }) {
    final level = _engine.levelLabel(scorePct);
    final reduceMotion = _reduceMotion(context);

    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'result',
      barrierColor: Colors.transparent,
      transitionDuration: Duration(milliseconds: reduceMotion ? 0 : 320),
      pageBuilder: (ctx, a1, a2) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: _overlay,
          child: Material(
            color: baseBg,
            child: Stack(
              children: [
                Positioned.fill(
                  child: PlacementBackdrop(isDark: isDark, animate: false),
                ),
                SafeArea(
                  child: PlacementResultView(
                    auto: auto,
                    scorePct: scorePct,
                    totalScore: totalScore,
                    maxScore: maxScore,
                    level: level,
                    perDomain: perDomain,
                    answers: answers,
                    byId: byId,
                    totalDuration: _totalDuration,
                    remaining: _remaining,
                    reduceMotion: reduceMotion,
                    onContinue: () {
                      Navigator.of(ctx).pop();
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (_) => const ModePickerScreen(),
                        ),
                        (route) => false,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
      transitionBuilder: (ctx, anim, _, child) {
        final t = Curves.easeOutCubic.transform(anim.value);
        return Opacity(
          opacity: t,
          child: Transform.scale(
            scale: 0.98 + (t * 0.02),
            child: Transform.translate(
              offset: Offset(0, (1 - t) * 18),
              child: child,
            ),
          ),
        );
      },
    );
  }

  Future<void> _submitAnswer() async {
    if (_current == null || _selectedIndex == null) return;
    if (_answerLocked || _submitting) return;

    final q = _current!;
    final selected = _selectedIndex!;

    setState(() => _answerLocked = true);
    _engine.submit(q, selected);
    HapticFeedback.selectionClick();

    final next = _engine.nextQuestion();
    await Future.delayed(const Duration(milliseconds: 620));
    if (!mounted) return;

    if (next == null || _index >= _totalQuestions - 1) {
      _finish(auto: false);
      return;
    }

    setState(() {
      _index += 1;
      _current = next;
      _selectedIndex = null;
      _answerLocked = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appCtrl = AppSettingsController.I;

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: appCtrl.themeMode,
      builder: (_, mode, __) {
        final isDark = mode == ThemeMode.dark;
        final baseBg = isDark ? _bgDark : _bgLight;
        final reduceMotion = _reduceMotion(context);
        final q = _current;

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: _overlay,
          child: Scaffold(
            backgroundColor: baseBg,
            body: Stack(
              children: [
                Positioned.fill(
                  child: PlacementBackdrop(
                    isDark: isDark,
                    animate: !reduceMotion,
                  ),
                ),
                if (q == null)
                  const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  )
                else
                  SafeArea(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 760),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
                          child: Column(
                            children: [
                              PlacementProgressHeader(
                                index: _index,
                                total: _totalQuestions,
                                remaining: _remaining,
                                currentWeight: q.weight,
                                formatTime: _formatTime,
                                reduceMotion: reduceMotion,
                              ),
                              const SizedBox(height: 14),
                              Expanded(
                                child: PlacementQuestionCard(
                                  key: ValueKey(q.id),
                                  question: q,
                                  index: _index,
                                  total: _totalQuestions,
                                  selectedIndex: _selectedIndex,
                                  locked: _answerLocked,
                                  submitting: _submitting,
                                  reduceMotion: reduceMotion,
                                  foreground: baseBg,
                                  domainLabel: placementDomainLabel(q.domain),
                                  difficultyLabel: placementDifficultyLabel(
                                    q.difficulty,
                                  ),
                                  onSelect: (i) {
                                    if (_answerLocked || _submitting) return;
                                    HapticFeedback.selectionClick();
                                    setState(() => _selectedIndex = i);
                                  },
                                  onValidate: _submitAnswer,
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
      },
    );
  }
}

String placementDomainLabel(PlacementDomain d) {
  switch (d) {
    case PlacementDomain.francais:
      return 'Français';
    case PlacementDomain.logique:
      return 'Logique';
    case PlacementDomain.deontologie:
      return 'Déontologie';
    case PlacementDomain.histoire:
      return 'Histoire';
    case PlacementDomain.sport:
      return 'Sport';
  }
}

String placementDifficultyLabel(_Difficulty d) {
  switch (d) {
    case _Difficulty.easy:
      return 'Débutant';
    case _Difficulty.medium:
      return 'Intermédiaire';
    case _Difficulty.hard:
      return 'Avancé';
  }
}

enum PlacementDomain { francais, logique, deontologie, histoire, sport }

enum _Difficulty { easy, medium, hard }

class _PlacementQuestion {
  final String id;
  final PlacementDomain domain;
  final _Difficulty difficulty;
  final int weight;
  final String question;
  final List<String> answers;
  final int correctIndex;

  const _PlacementQuestion({
    required this.id,
    required this.domain,
    required this.difficulty,
    required this.weight,
    required this.question,
    required this.answers,
    required this.correctIndex,
  });
}

class _AnswerLog {
  final String questionId;
  final PlacementDomain domain;
  final int selectedIndex;
  final int correctIndex;
  final bool isCorrect;
  final int weight;

  const _AnswerLog({
    required this.questionId,
    required this.domain,
    required this.selectedIndex,
    required this.correctIndex,
    required this.isCorrect,
    required this.weight,
  });
}

class _DomainScore {
  int got = 0;
  int max = 0;
}

class _PlacementEngine {
  _PlacementEngine(this.bank) {
    for (final d in PlacementDomain.values) {
      _difficulty[d] = _Difficulty.medium;
      _askedCount[d] = 0;
      scoreByDomain[d] = _DomainScore();
    }
    byId = {for (final q in bank) q.id: q};
  }

  final List<_PlacementQuestion> bank;

  late final Map<String, _PlacementQuestion> byId;

  final Map<PlacementDomain, _Difficulty> _difficulty = {};
  final Map<PlacementDomain, int> _askedCount = {};
  final Set<String> _used = {};

  int totalScore = 0;
  int maxScore = 0;

  final List<_AnswerLog> answers = [];
  final Map<PlacementDomain, _DomainScore> scoreByDomain = {};

  _PlacementQuestion? nextQuestion() {
    // 5 domaines x 6 questions = 30
    for (final d in PlacementDomain.values) {
      if ((_askedCount[d] ?? 0) >= 6) continue;

      final diff = _difficulty[d]!;
      final pool = bank
          .where(
            (q) =>
                q.domain == d && q.difficulty == diff && !_used.contains(q.id),
          )
          .toList();

      List<_PlacementQuestion> fallback = pool;
      if (fallback.isEmpty) {
        fallback = bank
            .where((q) => q.domain == d && !_used.contains(q.id))
            .toList();
      }
      if (fallback.isEmpty) return null;

      final q = fallback.first;
      _used.add(q.id);
      _askedCount[d] = (_askedCount[d] ?? 0) + 1;

      maxScore += q.weight;
      scoreByDomain[d]!.max += q.weight;

      return q;
    }
    return null;
  }

  void submit(_PlacementQuestion q, int selectedIndex) {
    final correct = selectedIndex == q.correctIndex;

    if (correct) {
      totalScore += q.weight;
      scoreByDomain[q.domain]!.got += q.weight;
    }

    answers.add(
      _AnswerLog(
        questionId: q.id,
        domain: q.domain,
        selectedIndex: selectedIndex,
        correctIndex: q.correctIndex,
        isCorrect: correct,
        weight: q.weight,
      ),
    );

    // adaptation : bon -> monte, faux -> descend (borné)
    final current = _difficulty[q.domain]!;
    if (correct) {
      if (current == _Difficulty.easy) {
        _difficulty[q.domain] = _Difficulty.medium;
      }
      if (current == _Difficulty.medium) {
        _difficulty[q.domain] = _Difficulty.hard;
      }
    } else {
      if (current == _Difficulty.hard) {
        _difficulty[q.domain] = _Difficulty.medium;
      }
      if (current == _Difficulty.medium) {
        _difficulty[q.domain] = _Difficulty.easy;
      }
    }
  }

  String levelLabel(double pct) {
    if (pct < 40) return "Fondamentaux à renforcer";
    if (pct < 60) return "Niveau intermédiaire";
    if (pct < 80) return "Bon niveau";
    return "Niveau avancé";
  }
}

List<_PlacementQuestion> _buildQuestionBank() {
  const w1 = 1, w2 = 2, w3 = 3;

  return [
      // ================== FRANCAIS (6) ==================
      const _PlacementQuestion(
        id: "fr_e1",
        domain: PlacementDomain.francais,
        difficulty: _Difficulty.easy,
        weight: w1,
        question:
            "Quel mot complète correctement : « Il a ____ le rapport ce matin. »",
        answers: ["rédigé", "rédiger", "rédige", "rédaction"],
        correctIndex: 0,
      ),
      const _PlacementQuestion(
        id: "fr_e2",
        domain: PlacementDomain.francais,
        difficulty: _Difficulty.easy,
        weight: w1,
        question: "Dans « Les agents se sont parlé », le verbe est :",
        answers: [
          "transitif direct",
          "transitif indirect",
          "intransitif",
          "pronominal réfléchi",
        ],
        correctIndex: 1,
      ),
      const _PlacementQuestion(
        id: "fr_m1",
        domain: PlacementDomain.francais,
        difficulty: _Difficulty.medium,
        weight: w2,
        question:
            "Quelle est la nature de la proposition : « …qu’il interviendra immédiatement » ?",
        answers: ["relative", "complétive", "circonstancielle", "juxtaposée"],
        correctIndex: 1,
      ),
      const _PlacementQuestion(
        id: "fr_m2",
        domain: PlacementDomain.francais,
        difficulty: _Difficulty.medium,
        weight: w2,
        question:
            "Quel temps exprime le plus souvent une action antérieure : « Lorsqu’il eut terminé… » ?",
        answers: [
          "plus-que-parfait",
          "passé antérieur",
          "passé simple",
          "futur antérieur",
        ],
        correctIndex: 1,
      ),
      const _PlacementQuestion(
        id: "fr_h1",
        domain: PlacementDomain.francais,
        difficulty: _Difficulty.hard,
        weight: w3,
        question: "Quel énoncé est grammaticalement correct ?",
        answers: [
          "Bien que il soit tard, il continue.",
          "Bien qu’il soit tard, il continue.",
          "Bien qu’il est tard, il continue.",
          "Bien que tard, il continue.",
        ],
        correctIndex: 1,
      ),
      const _PlacementQuestion(
        id: "fr_h2",
        domain: PlacementDomain.francais,
        difficulty: _Difficulty.hard,
        weight: w3,
        question:
            "Dans « C’est une mesure dont on ne peut se passer », « dont » reprend :",
        answers: ["une mesure", "on", "se passer", "ne peut"],
        correctIndex: 0,
      ),

      // ================== LOGIQUE (6) ==================
      const _PlacementQuestion(
        id: "lo_e1",
        domain: PlacementDomain.logique,
        difficulty: _Difficulty.easy,
        weight: w1,
        question: "Suite : 2, 4, 8, 16, …",
        answers: ["18", "20", "24", "32"],
        correctIndex: 3,
      ),
      const _PlacementQuestion(
        id: "lo_e2",
        domain: PlacementDomain.logique,
        difficulty: _Difficulty.easy,
        weight: w1,
        question: "Si A > B et B > C, alors :",
        answers: ["A > C", "A = C", "A < C", "Impossible"],
        correctIndex: 0,
      ),
      const _PlacementQuestion(
        id: "lo_m1",
        domain: PlacementDomain.logique,
        difficulty: _Difficulty.medium,
        weight: w2,
        question:
            "Dans une équipe, 12 agents. 5 sont habilités A, 7 habilités B, 3 les deux. Combien n’ont aucune habilitation ?",
        answers: ["0", "1", "2", "3"],
        correctIndex:
            2, // 5+7-3=9 -> 12-9=3 (oops) let's compute carefully: 5+7-3=9, none=3 -> correctIndex should be 3
      ),
      const _PlacementQuestion(
        id: "lo_m2",
        domain: PlacementDomain.logique,
        difficulty: _Difficulty.medium,
        weight: w2,
        question:
            "On a 4 boîtes : une contient un document. On sait qu’une boîte ment toujours, une dit toujours vrai, deux sont aléatoires. Quelle stratégie garantit de trouver le document en 2 questions ?",
        answers: [
          "Impossible",
          "Questionner seulement la boîte 'vrai'",
          "Poser une question auto-référente (type 'si je te demandais…')",
          "Choisir au hasard",
        ],
        correctIndex: 2,
      ),
      const _PlacementQuestion(
        id: "lo_h1",
        domain: PlacementDomain.logique,
        difficulty: _Difficulty.hard,
        weight: w3,
        question:
            "Si tous les A sont B, et aucun B n’est C, peut-on conclure que :",
        answers: [
          "aucun A n’est C",
          "certains A sont C",
          "tous les C sont A",
          "impossible",
        ],
        correctIndex: 0,
      ),
      const _PlacementQuestion(
        id: "lo_h2",
        domain: PlacementDomain.logique,
        difficulty: _Difficulty.hard,
        weight: w3,
        question:
            "Série : 3, 6, 12, 21, 33, … (règle : +3, +6, +9, +12…) Prochain nombre ?",
        answers: ["45", "48", "46", "51"],
        correctIndex: 0, // +15 => 48 (oops). 33+15=48 -> correctIndex 1
      ),

      // ================== DEONTOLOGIE (6) ==================
      const _PlacementQuestion(
        id: "de_e1",
        domain: PlacementDomain.deontologie,
        difficulty: _Difficulty.easy,
        weight: w1,
        question: "Le respect du secret professionnel s’impose :",
        answers: [
          "uniquement en service",
          "même hors service",
          "seulement pour les OPJ",
          "uniquement si écrit",
        ],
        correctIndex: 1,
      ),
      const _PlacementQuestion(
        id: "de_e2",
        domain: PlacementDomain.deontologie,
        difficulty: _Difficulty.easy,
        weight: w1,
        question: "La proportionnalité dans l’usage de la force signifie :",
        answers: [
          "toujours utiliser la force",
          "adapter la force à la situation",
          "utiliser la force maximale",
          "éviter toute intervention",
        ],
        correctIndex: 1,
      ),
      const _PlacementQuestion(
        id: "de_m1",
        domain: PlacementDomain.deontologie,
        difficulty: _Difficulty.medium,
        weight: w2,
        question:
            "Un collègue diffuse une info opérationnelle sur un réseau social privé. Ta réaction prioritaire :",
        answers: [
          "ne rien faire",
          "lui demander de supprimer + informer la hiérarchie",
          "partager pour prévenir",
          "attendre la fin de service",
        ],
        correctIndex: 1,
      ),
      const _PlacementQuestion(
        id: "de_m2",
        domain: PlacementDomain.deontologie,
        difficulty: _Difficulty.medium,
        weight: w2,
        question:
            "Tu constates une erreur de procédure qui peut impacter les droits d’une personne. Tu dois :",
        answers: [
          "la cacher pour éviter un conflit",
          "la corriger/faire remonter immédiatement",
          "attendre une plainte",
          "modifier le PV après coup",
        ],
        correctIndex: 1,
      ),
      const _PlacementQuestion(
        id: "de_h1",
        domain: PlacementDomain.deontologie,
        difficulty: _Difficulty.hard,
        weight: w3,
        question:
            "Cas pratique : une personne insultante refuse d’obtempérer sans violence. L’option la plus conforme :",
        answers: [
          "usage immédiat de la force",
          "désescalade + injonctions claires + recours gradué si nécessaire",
          "menace verbale",
          "abandon de l’intervention",
        ],
        correctIndex: 1,
      ),
      const _PlacementQuestion(
        id: "de_h2",
        domain: PlacementDomain.deontologie,
        difficulty: _Difficulty.hard,
        weight: w3,
        question: "La neutralité implique notamment :",
        answers: [
          "afficher ses opinions en service",
          "traiter chacun avec impartialité",
          "refuser toute décision",
          "agir uniquement sur ordre écrit",
        ],
        correctIndex: 1,
      ),

      // ================== HISTOIRE / INSTITUTIONS (6) ==================
      const _PlacementQuestion(
        id: "hi_e1",
        domain: PlacementDomain.histoire,
        difficulty: _Difficulty.easy,
        weight: w1,
        question: "Le préfet représente l’État dans :",
        answers: ["la commune", "le département", "l’école", "l’entreprise"],
        correctIndex: 1,
      ),
      const _PlacementQuestion(
        id: "hi_e2",
        domain: PlacementDomain.histoire,
        difficulty: _Difficulty.easy,
        weight: w1,
        question: "La Constitution actuelle de la France date de :",
        answers: ["1946", "1958", "1968", "1875"],
        correctIndex: 1,
      ),
      const _PlacementQuestion(
        id: "hi_m1",
        domain: PlacementDomain.histoire,
        difficulty: _Difficulty.medium,
        weight: w2,
        question: "Le maire est :",
        answers: [
          "agent de l’État et exécutif communal",
          "uniquement agent de l’État",
          "uniquement élu national",
          "chef de région",
        ],
        correctIndex: 0,
      ),
      const _PlacementQuestion(
        id: "hi_m2",
        domain: PlacementDomain.histoire,
        difficulty: _Difficulty.medium,
        weight: w2,
        question: "Quelle autorité dirige une enquête de flagrance ?",
        answers: ["le juge civil", "le parquet", "le maire", "le préfet"],
        correctIndex: 1,
      ),
      const _PlacementQuestion(
        id: "hi_h1",
        domain: PlacementDomain.histoire,
        difficulty: _Difficulty.hard,
        weight: w3,
        question: "Dans l’organisation administrative, une région est :",
        answers: [
          "une collectivité territoriale",
          "un service de police",
          "un établissement public",
          "une juridiction",
        ],
        correctIndex: 0,
      ),
      const _PlacementQuestion(
        id: "hi_h2",
        domain: PlacementDomain.histoire,
        difficulty: _Difficulty.hard,
        weight: w3,
        question: "La séparation des pouvoirs vise principalement à :",
        answers: [
          "accroître l’exécutif",
          "éviter la concentration du pouvoir",
          "supprimer le judiciaire",
          "remplacer les lois",
        ],
        correctIndex: 1,
      ),

      // ================== SPORT (6) ==================
      const _PlacementQuestion(
        id: "sp_e1",
        domain: PlacementDomain.sport,
        difficulty: _Difficulty.easy,
        weight: w1,
        question: "Pour progresser en endurance, on privilégie :",
        answers: [
          "des sprints très courts uniquement",
          "un travail régulier à intensité modérée",
          "zéro récupération",
          "uniquement musculation lourde",
        ],
        correctIndex: 1,
      ),
      const _PlacementQuestion(
        id: "sp_e2",
        domain: PlacementDomain.sport,
        difficulty: _Difficulty.easy,
        weight: w1,
        question: "L’échauffement sert principalement à :",
        answers: [
          "fatiguer le corps",
          "préparer muscles et articulations",
          "remplacer l’entraînement",
          "faire baisser la température",
        ],
        correctIndex: 1,
      ),
      const _PlacementQuestion(
        id: "sp_m1",
        domain: PlacementDomain.sport,
        difficulty: _Difficulty.medium,
        weight: w2,
        question: "La récupération est meilleure si l’on :",
        answers: [
          "stoppe toute activité brutalement",
          "fait un retour au calme progressif",
          "mange uniquement sucré",
          "évite de dormir",
        ],
        correctIndex: 1,
      ),
      const _PlacementQuestion(
        id: "sp_m2",
        domain: PlacementDomain.sport,
        difficulty: _Difficulty.medium,
        weight: w2,
        question: "Lors d’un test cardio, la progression correcte est :",
        answers: [
          "augmenter brutalement l’intensité",
          "augmenter progressivement et contrôler la respiration",
          "ne pas boire pendant 24h",
          "courir à jeun sans échauffement",
        ],
        correctIndex: 1,
      ),
      const _PlacementQuestion(
        id: "sp_h1",
        domain: PlacementDomain.sport,
        difficulty: _Difficulty.hard,
        weight: w3,
        question: "Quelle filière énergétique domine sur un sprint ~100 m ?",
        answers: [
          "aérobie",
          "anaérobie lactique",
          "anaérobie alactique",
          "oxydative",
        ],
        correctIndex: 2,
      ),
      const _PlacementQuestion(
        id: "sp_h2",
        domain: PlacementDomain.sport,
        difficulty: _Difficulty.hard,
        weight: w3,
        question:
            "Le meilleur indicateur simple d’intensité en endurance (sans matériel) :",
        answers: [
          "fréquence des pas",
          "test de la parole (pouvoir parler)",
          "température extérieure",
          "poids corporel",
        ],
        correctIndex: 1,
      ),
    ]
    // ⚠️ Correction logique : 2 questions avaient des index faux dans la version brouillon.
    // On les fixe ici proprement :
    .._fixBankIndexes();
}

extension on List<_PlacementQuestion> {
  void _fixBankIndexes() {
    for (var i = 0; i < length; i++) {
      final q = this[i];
      if (q.id == "lo_m1") {
        // 5+7-3=9 -> none=12-9=3 => index 3
        this[i] = _PlacementQuestion(
          id: q.id,
          domain: q.domain,
          difficulty: q.difficulty,
          weight: q.weight,
          question: q.question,
          answers: q.answers,
          correctIndex: 3,
        );
      }
      if (q.id == "lo_h2") {
        // 33 + 15 = 48 => index 1
        this[i] = _PlacementQuestion(
          id: q.id,
          domain: q.domain,
          difficulty: q.difficulty,
          weight: q.weight,
          question: q.question,
          answers: q.answers,
          correctIndex: 1,
        );
      }
    }
  }
}
