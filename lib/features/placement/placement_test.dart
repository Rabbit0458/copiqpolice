// lib/placement/placement_test.dart
import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:copiqpolice/features/onboarding/mode_picker.dart';
import 'package:copiqpolice/core/widgets/app_notifier.dart'
    show AppSettingsController, AppNotifier;

/// ===========================================================================
/// Helpers UI (couleurs résultats)
/// ===========================================================================
Color scoreColorFromPct(double pct) {
  // pct = 0..100
  if (pct >= 70) return const Color(0xFF22C55E); // vert
  if (pct >= 40) return const Color(0xFFF59E0B); // orange
  return const Color(0xFFEF4444); // rouge
}

Color scoreColorFrom01(double pct01) => scoreColorFromPct(pct01 * 100);

/// ===========================================================================
/// Screen
/// ===========================================================================
class PlacementTest extends StatefulWidget {
  const PlacementTest({super.key, required this.onFinished});
  final VoidCallback onFinished;

  @override
  State<PlacementTest> createState() => _PlacementTestState();
}

class _PlacementTestState extends State<PlacementTest> {
  // Palettes alignées SignIn
  static const _bgDark = Color(0xFF000932); // navy
  static const _bgLight = Color(0xFF0E44D6); // bleu

  Color _whiteA(double o) => Color.fromRGBO(255, 255, 255, o);

  bool _reduceMotion(BuildContext context) {
    final mq = MediaQuery.maybeOf(context);
    final disableByOS = WidgetsBinding
        .instance
        .platformDispatcher
        .accessibilityFeatures
        .disableAnimations;
    return (mq?.disableAnimations ?? false) || disableByOS;
  }

  // ---- Test
  static const int _totalQuestions = 30;
  static const Duration _totalDuration = Duration(minutes: 15);

  late final _engine = _PlacementEngine(_buildQuestionBank());

  _PlacementQuestion? _current;
  int _index = 0; // 0..29

  int? _selectedIndex;
  bool _submitting = false;

  // ---- Timer
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

  @override
  void initState() {
    super.initState();

    // ✅ EDGE TO EDGE (supprime les bandes Android)
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    // ✅ barres transparentes + pas de “scrim” automatique
    SystemChrome.setSystemUIOverlayStyle(_overlay);

    _current = _engine.nextQuestion();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();

    // ✅ on laisse edgeToEdge (cohérent app-wide)
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
    return "$mm:$ss";
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
          title: "Connexion requise",
          message: "Connecte-toi pour sauvegarder le résultat du test.",
        );
      }
      widget.onFinished();
      return;
    }

    // ✅ on calcule ici le thème + bg (car showDialog est hors build)
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
          title: "Erreur",
          message: "Impossible de sauvegarder le résultat. Réessaie.",
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
      barrierLabel: "result",
      barrierColor: Colors.transparent,
      transitionDuration: Duration(milliseconds: reduceMotion ? 0 : 260),
      pageBuilder: (ctx, a1, a2) {
        final topPad = MediaQuery.paddingOf(ctx).top;
        final bottomPad = MediaQuery.paddingOf(ctx).bottom;

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: _overlay,
          child: Material(
            color: Colors.transparent,
            child: Stack(
              children: [
                // Fond app (bleu)
                Positioned.fill(child: ColoredBox(color: baseBg)),

                // Blobs
                Positioned.fill(
                  child: _DynamicBlobsBackground(
                    isDark: isDark,
                    enabled: !reduceMotion,
                  ),
                ),

                // Voile premium
                Positioned.fill(
                  child: IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: isDark ? 0.12 : 0.08),
                            Colors.transparent,
                            Colors.black.withValues(alpha: isDark ? 0.22 : 0.16),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Blur léger (bleu glass)
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: reduceMotion ? 0 : 18,
                      sigmaY: reduceMotion ? 0 : 18,
                    ),
                    child: Container(
                      color: Colors.black.withValues(alpha: isDark ? 0.18 : 0.14),
                    ),
                  ),
                ),

                // Contenu (VISIBLE direct — pas d’opacité ici)
                Padding(
                  padding: EdgeInsets.only(top: topPad, bottom: bottomPad),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 520),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: _ResultDialogCard(
                          auto: auto,
                          scorePct: scorePct,
                          totalScore: totalScore,
                          maxScore: maxScore,
                          level: level,
                          perDomain: perDomain,
                          answers: answers,
                          byId: byId,
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
                    ),
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
            scale: 0.985 + (t * 0.015),
            child: Transform.translate(
              offset: Offset(0, (1 - t) * 10),
              child: child,
            ),
          ),
        );
      },
    );
  }

  void _submitAnswer() {
    if (_current == null) return;
    if (_selectedIndex == null) return;

    final q = _current!;
    final selected = _selectedIndex!;

    _engine.submit(q, selected);
    HapticFeedback.selectionClick();

    final next = _engine.nextQuestion();
    if (next == null || _index >= _totalQuestions - 1) {
      _finish(auto: false);
      return;
    }

    setState(() {
      _index += 1;
      _current = next;
      _selectedIndex = null;
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
        final compact = MediaQuery.sizeOf(context).height < 700;

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: _overlay,
          child: Scaffold(
            backgroundColor: baseBg, // ✅ identique SignIn
            body: Stack(
              children: [
                // ✅ même ambiance que SignIn
                Positioned.fill(
                  child: _DynamicBlobsBackground(
                    isDark: isDark,
                    enabled: !reduceMotion,
                  ),
                ),
                Positioned.fill(
                  child: IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.14),
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.24),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                if (q == null)
                  const Center(child: CircularProgressIndicator())
                else
                  SafeArea(
                    // ✅ SafeArea normal ici (pas de bandes, car fond = baseBg)
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 720),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
                          child: Column(
                            children: [
                              _HeaderPremium(
                                index: _index,
                                total: _totalQuestions,
                                remaining: _remaining,
                                formatTime: _formatTime,
                                whiteA: _whiteA,
                              ),
                              SizedBox(height: compact ? 12 : 16),
                              Expanded(
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    final content = TweenAnimationBuilder<double>(
                                      key: ValueKey(q.id),
                                      tween: Tween(begin: 0.0, end: 1.0),
                                      duration: Duration(
                                        milliseconds: reduceMotion ? 0 : 240,
                                      ),
                                      curve: Curves.easeOutCubic,
                                      builder: (context, v, child) {
                                        return Opacity(
                                          opacity: v,
                                          child: Transform.translate(
                                            offset: Offset(0, (1 - v) * 12),
                                            child: child,
                                          ),
                                        );
                                      },
                                      child: ConstrainedBox(
                                        constraints: const BoxConstraints(
                                          maxWidth: 520,
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            _GlassCardPremium(
                                              opacity: 0.09,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      _Pill(
                                                        text: _domainLabel(
                                                          q.domain,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 8),
                                                      _Pill(
                                                        text: _difficultyLabel(
                                                          q.difficulty,
                                                        ),
                                                      ),
                                                      const Spacer(),
                                                      _WeightMeta(
                                                        weight: q.weight,
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 14),
                                                  Text(
                                                    q.question,
                                                    style:
                                                        GoogleFonts.montserrat(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w900,
                                                          fontSize: compact
                                                              ? 15
                                                              : 16.5,
                                                          height: 1.35,
                                                          letterSpacing: -0.2,
                                                        ),
                                                  ),
                                                  const SizedBox(height: 14),
                                                  ...List.generate(q.answers.length, (
                                                    i,
                                                  ) {
                                                    final selected =
                                                        _selectedIndex == i;
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                            bottom: 10,
                                                          ),
                                                      child: _AnswerTile(
                                                        label: q.answers[i],
                                                        selected: selected,
                                                        onTap: () {
                                                          HapticFeedback.selectionClick();
                                                          setState(
                                                            () =>
                                                                _selectedIndex =
                                                                    i,
                                                          );
                                                        },
                                                      ),
                                                    );
                                                  }),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 14),
                                            AnimatedSwitcher(
                                              duration: const Duration(
                                                milliseconds: 180,
                                              ),
                                              switchInCurve: Curves.easeOut,
                                              switchOutCurve: Curves.easeOut,
                                              child: (_selectedIndex == null)
                                                  ? const SizedBox(height: 22)
                                                  : _SelectedHint(
                                                      key: const ValueKey(
                                                        "sel",
                                                      ),
                                                      text: q
                                                          .answers[_selectedIndex!],
                                                      whiteA: _whiteA,
                                                    ),
                                            ),
                                            const SizedBox(height: 16),
                                            if (_selectedIndex == null ||
                                                _submitting)
                                              const _LockedCTAButton(
                                                label: "Valider",
                                              )
                                            else
                                              _PrimaryCTAButton(
                                                label: "Valider",
                                                foreground: baseBg,
                                                enabledShine: !reduceMotion,
                                                onPressed: _submitAnswer,
                                              ),
                                            const SizedBox(height: 12),
                                            Text(
                                              "Progression verrouillée • aucune question ne peut être rejouée",
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.montserrat(
                                                color: _whiteA(.62),
                                                fontSize: 12.2,
                                                height: 1.25,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );

                                    return Center(
                                      child: SingleChildScrollView(
                                        physics: const BouncingScrollPhysics(),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 4,
                                        ),
                                        child: ConstrainedBox(
                                          constraints: BoxConstraints(
                                            minHeight: constraints.maxHeight,
                                          ),
                                          child: Center(child: content),
                                        ),
                                      ),
                                    );
                                  },
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

  String _domainLabel(PlacementDomain d) {
    switch (d) {
      case PlacementDomain.francais:
        return "Français";
      case PlacementDomain.logique:
        return "Logique";
      case PlacementDomain.deontologie:
        return "Déontologie";
      case PlacementDomain.histoire:
        return "Histoire";
      case PlacementDomain.sport:
        return "Sport";
    }
  }

  String _difficultyLabel(_Difficulty d) {
    switch (d) {
      case _Difficulty.easy:
        return "Facile";
      case _Difficulty.medium:
        return "Intermédiaire";
      case _Difficulty.hard:
        return "Avancé";
    }
  }
}

/// ===========================================================================
/// Header
/// ===========================================================================
class _HeaderPremium extends StatelessWidget {
  const _HeaderPremium({
    required this.index,
    required this.total,
    required this.remaining,
    required this.formatTime,
    required this.whiteA,
  });

  final int index;
  final int total;
  final Duration remaining;
  final String Function(Duration) formatTime;
  final Color Function(double) whiteA;

  @override
  Widget build(BuildContext context) {
    final progress = (index + 1) / total;

    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 6, 6, 0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  "Question ${index + 1} / $total",
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
              Icon(Icons.timer_rounded, size: 16, color: whiteA(.85)),
              const SizedBox(width: 6),
              Text(
                formatTime(remaining),
                style: GoogleFonts.montserrat(
                  color: whiteA(.92),
                  fontWeight: FontWeight.w900,
                  fontSize: 13.5,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              minHeight: 7,
              value: progress,
              backgroundColor: Colors.white.withValues(alpha: 0.18),
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.white.withValues(alpha: 0.92),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ===========================================================================
/// Result Dialog (PRO : couleurs + détails + corrections)
/// ===========================================================================
/// ===========================================================================
/// Result Dialog (WOUAW : hero header + glass + halo + gauge + erreurs premium)
/// ===========================================================================

class _ResultDialogCard extends StatelessWidget {
  const _ResultDialogCard({
    required this.auto,
    required this.scorePct,
    required this.totalScore,
    required this.maxScore,
    required this.level,
    required this.perDomain,
    required this.answers,
    required this.byId,
    required this.onContinue,
  });

  final bool auto;
  final double scorePct;
  final int totalScore;
  final int maxScore;
  final String level;
  final Map<PlacementDomain, _DomainScore> perDomain;
  final List<_AnswerLog> answers;
  final Map<String, _PlacementQuestion> byId;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final maxH = MediaQuery.sizeOf(context).height * 0.82;

    final main = scoreColorFromPct(scorePct);
    final pct01 = (scorePct.clamp(0, 100)) / 100.0;

    final correctCount = answers.where((a) => a.isCorrect).length;
    final wrong = answers.where((a) => !a.isCorrect).toList()
      ..sort((a, b) => b.weight.compareTo(a.weight));
    final wrongCount = wrong.length;

    // un peu plus lumineux en bas
    final bg = const Color(0xFF061339);
    final card = const Color(0xFF0B2B86);

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxH),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          children: [
            Positioned(
              bottom: -120,
              right: -80,
              child: _GlowBlob(
                color: Colors.white.withValues(alpha: 0.10),
                size: 300,
              ),
            ),

            // ✅ Contenu
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Column(
                children: [
                  // ================== HERO HEADER ==================
                  _GlassPanel(
                    radius: 18,
                    opacity: 0.14,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _ScoreGauge(pct01: pct01, color: main),
                          const SizedBox(width: 14),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      auto
                                          ? Icons.timer_off_rounded
                                          : Icons.verified_rounded,
                                      size: 18,
                                      color: Colors.white.withValues(alpha: 0.95),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      auto
                                          ? "Temps écoulé"
                                          : "Résultats du test",
                                      style: GoogleFonts.montserrat(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 14.5,
                                        letterSpacing: -0.2,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),

                                Text(
                                  level,
                                  style: GoogleFonts.montserrat(
                                    color: Colors.white.withValues(alpha: 0.88),
                                    fontWeight: FontWeight.w800,
                                    fontSize: 13,
                                    height: 1.2,
                                  ),
                                ),

                                const SizedBox(height: 10),

                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    _StatPill(
                                      label: "Bonnes",
                                      value:
                                          "$correctCount / ${answers.length}",
                                      valueColor: const Color(0xFF22C55E),
                                      icon: Icons.check_circle_rounded,
                                    ),
                                    _StatPill(
                                      label: "Erreurs",
                                      value: "$wrongCount",
                                      valueColor: const Color(0xFFEF4444),
                                      icon: Icons.close_rounded,
                                    ),
                                    _StatPill(
                                      label: "Score",
                                      value: "$totalScore / $maxScore",
                                      valueColor: Colors.white,
                                      icon: Icons.bolt_rounded,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ================== BODY SCROLL ==================
                  Expanded(
                    child: _GlassPanel(
                      radius: 22,
                      opacity: 0.12,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            children: [
                              // ====== Domain performance ======
                              _SectionTitle(
                                title: "Performance par domaine",
                                icon: Icons.bar_chart_rounded,
                              ),
                              const SizedBox(height: 10),

                              _DomainBar(
                                label: "Français",
                                icon: Icons.menu_book_rounded,
                                score: perDomain[PlacementDomain.francais]!,
                              ),
                              _DomainBar(
                                label: "Logique",
                                icon: Icons.grid_view_rounded,
                                score: perDomain[PlacementDomain.logique]!,
                              ),
                              _DomainBar(
                                label: "Déontologie",
                                icon: Icons.gavel_rounded,
                                score: perDomain[PlacementDomain.deontologie]!,
                              ),
                              _DomainBar(
                                label: "Histoire",
                                icon: Icons.account_balance_rounded,
                                score: perDomain[PlacementDomain.histoire]!,
                              ),
                              _DomainBar(
                                label: "Sport",
                                icon: Icons.directions_run_rounded,
                                score: perDomain[PlacementDomain.sport]!,
                              ),

                              const SizedBox(height: 16),

                              // ====== Mistakes ======
                              _SectionTitle(
                                title: "À revoir",
                                icon: Icons.school_rounded,
                                trailing: Text(
                                  "($wrongCount)",
                                  style: GoogleFonts.montserrat(
                                    color: Colors.white.withValues(alpha: 0.78),
                                    fontWeight: FontWeight.w900,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),

                              if (wrong.isEmpty)
                                _SuccessBanner()
                              else ...[
                                ...wrong.take(8).map((a) {
                                  final q = byId[a.questionId];
                                  if (q == null) return const SizedBox.shrink();

                                  final your = q.answers[a.selectedIndex];
                                  final good = q.answers[a.correctIndex];

                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: _MistakeCard(
                                      domain: q.domain,
                                      weight: a.weight,
                                      question: q.question,
                                      yourAnswer: your,
                                      goodAnswer: good,
                                    ),
                                  );
                                }),

                                if (wrong.length > 8)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text(
                                      "Astuce : on affiche les 8 plus importantes (poids élevé) pour garder l’écran lisible.",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.montserrat(
                                        color: Colors.white.withValues(alpha: 0.60),
                                        fontWeight: FontWeight.w700,
                                        fontSize: 11.8,
                                        height: 1.25,
                                      ),
                                    ),
                                  ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ================== CTA ==================
                  _PrimaryCTAButton(
                    label: "Continuer",
                    foreground: const Color(0xFF061339),
                    enabledShine: true,
                    onPressed: onContinue,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ================== Widgets “WOUAW” ==================

class _GlowBlob extends StatelessWidget {
  const _GlowBlob({required this.color, required this.size});
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      ),
    );
  }
}

class _GlassPanel extends StatelessWidget {
  const _GlassPanel({
    required this.child,
    this.radius = 18,
    this.opacity = 0.10,
  });

  final Widget child;
  final double radius;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    final r = BorderRadius.circular(radius);

    return ClipRRect(
      borderRadius: r,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: r,
            color: Colors.white.withValues(alpha: opacity),
            // ✅ plus de border + plus de shadow + plus de gradient
          ),
          child: child,
        ),
      ),
    );
  }
}

class _ScoreGauge extends StatelessWidget {
  const _ScoreGauge({required this.pct01, required this.color});
  final double pct01; // 0..1
  final Color color;

  @override
  Widget build(BuildContext context) {
    final pctText = "${(pct01 * 100).toStringAsFixed(1)}%";
    return SizedBox(
      width: 74,
      height: 74,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // base ring
          SizedBox(
            width: 74,
            height: 74,
            child: CircularProgressIndicator(
              value: 1,
              strokeWidth: 9,
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.white.withValues(alpha: 0.10),
              ),
            ),
          ),
          // progress
          SizedBox(
            width: 74,
            height: 74,
            child: CircularProgressIndicator(
              value: pct01,
              strokeWidth: 9,
              strokeCap: StrokeCap.round,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              backgroundColor: Colors.transparent,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                pctText,
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 13.2,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 2),
              Container(
                width: 26,
                height: 3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  color: color.withValues(alpha: 0.85),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  const _StatPill({
    required this.label,
    required this.value,
    required this.valueColor,
    required this.icon,
  });

  final String label;
  final String value;
  final Color valueColor;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: Colors.white.withValues(alpha: 0.08),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: Colors.white.withValues(alpha: 0.88)),
            const SizedBox(width: 8),
            Text(
              "$label : ",
              style: GoogleFonts.montserrat(
                color: Colors.white.withValues(alpha: 0.78),
                fontWeight: FontWeight.w800,
                fontSize: 12,
              ),
            ),
            Text(
              value,
              style: GoogleFonts.montserrat(
                color: valueColor,
                fontWeight: FontWeight.w900,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.icon, this.trailing});
  final String title;
  final IconData icon;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.white.withValues(alpha: 0.90)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 14.2,
              letterSpacing: -0.2,
            ),
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

class _DomainBar extends StatelessWidget {
  const _DomainBar({
    required this.label,
    required this.icon,
    required this.score,
  });

  final String label;
  final IconData icon;
  final _DomainScore score;

  @override
  Widget build(BuildContext context) {
    final pct = score.max == 0 ? 0.0 : (score.got / score.max); // 0..1
    final color = scoreColorFrom01(pct);
    final pctTxt = "${(pct * 100).toStringAsFixed(0)}%";

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Colors.white.withValues(alpha: 0.06),
          border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: color.withValues(alpha: 0.18),
                      border: Border.all(color: color.withValues(alpha: 0.35)),
                    ),
                    child: Icon(icon, size: 16, color: color),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      label,
                      style: GoogleFonts.montserrat(
                        color: Colors.white.withValues(alpha: 0.92),
                        fontWeight: FontWeight.w900,
                        fontSize: 12.8,
                      ),
                    ),
                  ),
                  Text(
                    pctTxt,
                    style: GoogleFonts.montserrat(
                      color: color,
                      fontWeight: FontWeight.w900,
                      fontSize: 12.8,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  minHeight: 7,
                  value: pct,
                  backgroundColor: Colors.white.withValues(alpha: 0.10),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SuccessBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: const Color(0xFF22C55E).withValues(alpha: 0.14),
        border: Border.all(color: const Color(0xFF22C55E).withValues(alpha: 0.35)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            const Icon(Icons.celebration_rounded, color: Color(0xFF22C55E)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                "Parfait : aucune erreur détectée ✅",
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 12.8,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MistakeCard extends StatelessWidget {
  const _MistakeCard({
    required this.domain,
    required this.weight,
    required this.question,
    required this.yourAnswer,
    required this.goodAnswer,
  });

  final PlacementDomain domain;
  final int weight;
  final String question;
  final String yourAnswer;
  final String goodAnswer;

  @override
  Widget build(BuildContext context) {
    final domainLabel = _domainLabelStatic(domain);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.08),
            Colors.white.withValues(alpha: 0.05),
          ],
        ),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
        boxShadow: [
          BoxShadow(
            blurRadius: 16,
            offset: const Offset(0, 10),
            color: Colors.black.withValues(alpha: 0.18),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _Tag(text: domainLabel),
                const SizedBox(width: 8),
                _Tag(text: "Poids $weight", subtle: true),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              question,
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 12.8,
                height: 1.25,
              ),
            ),
            const SizedBox(height: 10),
            _AnswerRow(
              label: "Ta réponse",
              value: yourAnswer,
              color: const Color(0xFFEF4444),
              icon: Icons.close_rounded,
            ),
            const SizedBox(height: 6),
            _AnswerRow(
              label: "Bonne réponse",
              value: goodAnswer,
              color: const Color(0xFF22C55E),
              icon: Icons.check_rounded,
            ),
          ],
        ),
      ),
    );
  }

  static String _domainLabelStatic(PlacementDomain d) {
    switch (d) {
      case PlacementDomain.francais:
        return "Français";
      case PlacementDomain.logique:
        return "Logique";
      case PlacementDomain.deontologie:
        return "Déontologie";
      case PlacementDomain.histoire:
        return "Histoire";
      case PlacementDomain.sport:
        return "Sport";
    }
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.text, this.subtle = false});
  final String text;
  final bool subtle;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: Colors.white.withValues(alpha: subtle ? 0.06 : 0.10),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Text(
          text,
          style: GoogleFonts.montserrat(
            color: Colors.white.withValues(alpha: subtle ? 0.78 : 0.92),
            fontWeight: FontWeight.w900,
            fontSize: 11.4,
            letterSpacing: -0.1,
          ),
        ),
      ),
    );
  }
}

class _AnswerRow extends StatelessWidget {
  const _AnswerRow({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  final String label;
  final String value;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            color: color.withValues(alpha: 0.18),
            border: Border.all(color: color.withValues(alpha: 0.35)),
          ),
          child: Icon(icon, size: 14, color: color),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: GoogleFonts.montserrat(
                color: Colors.white.withValues(alpha: 0.86),
                fontWeight: FontWeight.w800,
                fontSize: 12.2,
                height: 1.25,
              ),
              children: [
                TextSpan(text: "$label : "),
                TextSpan(
                  text: value,
                  style: GoogleFonts.montserrat(
                    color: color,
                    fontWeight: FontWeight.w900,
                    fontSize: 12.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MiniStatChip extends StatelessWidget {
  const _MiniStatChip({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: RichText(
          text: TextSpan(
            style: GoogleFonts.montserrat(
              fontSize: 12.2,
              fontWeight: FontWeight.w800,
              color: Colors.white.withValues(alpha: 0.85),
            ),
            children: [
              TextSpan(text: "$label : "),
              TextSpan(
                text: value,
                style: GoogleFonts.montserrat(
                  fontSize: 12.2,
                  fontWeight: FontWeight.w900,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ===========================================================================
/// UI pieces
/// ===========================================================================
class _Pill extends StatelessWidget {
  const _Pill({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white.withValues(alpha: 0.10),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Text(
          text,
          style: GoogleFonts.montserrat(
            color: Colors.white.withValues(alpha: 0.88),
            fontWeight: FontWeight.w800,
            fontSize: 11.4,
            letterSpacing: -0.1,
          ),
        ),
      ),
    );
  }
}

class _WeightMeta extends StatelessWidget {
  const _WeightMeta({required this.weight});
  final int weight;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.bolt_rounded,
          size: 14,
          color: Colors.white.withValues(alpha: 0.72),
        ),
        const SizedBox(width: 6),
        Text(
          "$weight",
          style: GoogleFonts.montserrat(
            color: Colors.white.withValues(alpha: 0.78),
            fontWeight: FontWeight.w900,
            fontSize: 12,
            letterSpacing: -0.1,
          ),
        ),
      ],
    );
  }
}

class _AnswerTile extends StatelessWidget {
  const _AnswerTile({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  Color _whiteA(double o) => Color.fromRGBO(255, 255, 255, o);

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(12);

    final bg = selected
        ? Colors.white.withValues(alpha: 0.14)
        : Colors.white.withValues(alpha: 0.07);

    final stroke = selected
        ? Colors.white.withValues(alpha: 0.22)
        : Colors.white.withValues(alpha: 0.12);

    return InkWell(
      borderRadius: radius,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          borderRadius: radius,
          color: bg,
          border: Border.all(color: stroke, width: 1),
          boxShadow: selected
              ? [
                  BoxShadow(
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                    color: Colors.black.withValues(alpha: 0.20),
                  ),
                ]
              : const [],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              curve: Curves.easeOutCubic,
              width: 3,
              height: 26,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: selected ? Colors.white : Colors.transparent,
              ),
            ),
            const SizedBox(width: 12),
            AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              curve: Curves.easeOutCubic,
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? Colors.white : Colors.transparent,
                border: Border.all(
                  color: selected ? Colors.white : _whiteA(.50),
                  width: 1.4,
                ),
              ),
              child: AnimatedScale(
                duration: const Duration(milliseconds: 160),
                curve: Curves.easeOutCubic,
                scale: selected ? 1.0 : 0.0,
                child: const Icon(
                  Icons.check_rounded,
                  size: 13,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontWeight: selected ? FontWeight.w900 : FontWeight.w800,
                  fontSize: 13.8,
                  height: 1.22,
                  letterSpacing: -0.1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DomainLine extends StatelessWidget {
  const _DomainLine({required this.label, required this.score});

  final String label;
  final _DomainScore score;

  @override
  Widget build(BuildContext context) {
    final pct = score.max == 0 ? 0.0 : (score.got / score.max);
    final c = scoreColorFrom01(pct);

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.montserrat(
                    color: Colors.white.withValues(alpha: 0.86),
                    fontWeight: FontWeight.w800,
                    fontSize: 12.8,
                  ),
                ),
              ),
              Text(
                "${(pct * 100).toStringAsFixed(0)}%",
                style: GoogleFonts.montserrat(
                  color: c,
                  fontWeight: FontWeight.w900,
                  fontSize: 12.8,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              minHeight: 6,
              value: pct,
              backgroundColor: Colors.white.withValues(alpha: 0.12),
              valueColor: AlwaysStoppedAnimation<Color>(c),
            ),
          ),
        ],
      ),
    );
  }
}

class _LockedCTAButton extends StatelessWidget {
  const _LockedCTAButton({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(14);

    return SizedBox(
      height: 56,
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: radius,
          color: Colors.black.withValues(alpha: 0.28),
          border: Border.all(color: Colors.white.withValues(alpha: 0.10), width: 1),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.lock_rounded,
                size: 18,
                color: Colors.white.withValues(alpha: 0.70),
              ),
              const SizedBox(width: 10),
              Text(
                label,
                style: GoogleFonts.montserrat(
                  color: Colors.white.withValues(alpha: 0.78),
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SelectedHint extends StatelessWidget {
  const _SelectedHint({super.key, required this.text, required this.whiteA});
  final String text;
  final Color Function(double) whiteA;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_rounded, size: 14, color: whiteA(.68)),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              "Sélection : $text",
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.montserrat(
                fontSize: 12.2,
                color: whiteA(.68),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ===========================================================================
/// Glass card + background blobs + CTA shine
/// ===========================================================================
class _GlassCardPremium extends StatelessWidget {
  const _GlassCardPremium({required this.child, this.opacity = 0.075});
  final Widget child;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    final r = BorderRadius.circular(18);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: r,
        color: Colors.white.withValues(alpha: opacity),
        border: Border.all(color: Colors.white.withValues(alpha: 0.11), width: 1),
        boxShadow: [
          BoxShadow(
            blurRadius: 26,
            offset: const Offset(0, 14),
            color: Colors.black.withValues(alpha: 0.22),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: r,
        child: Stack(
          children: [
            Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withValues(alpha: 0.10),
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.08),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}

class _DynamicBlobsBackground extends StatefulWidget {
  const _DynamicBlobsBackground({required this.isDark, required this.enabled});
  final bool isDark;
  final bool enabled;

  @override
  State<_DynamicBlobsBackground> createState() =>
      _DynamicBlobsBackgroundState();
}

class _DynamicBlobsBackgroundState extends State<_DynamicBlobsBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 14),
  );

  @override
  void initState() {
    super.initState();
    if (widget.enabled) _c.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(covariant _DynamicBlobsBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.enabled != widget.enabled) {
      if (widget.enabled) {
        _c.repeat(reverse: true);
      } else {
        _c.stop();
      }
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return const SizedBox.expand();

    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        final t = _c.value;

        final dx1 = lerpDouble(-0.20, 0.12, t)!;
        final dy1 = lerpDouble(-0.10, 0.18, t)!;

        final dx2 = lerpDouble(0.18, -0.10, t)!;
        final dy2 = lerpDouble(0.22, -0.06, t)!;

        final c1 = widget.isDark
            ? Colors.white.withValues(alpha: 0.06)
            : Colors.white.withValues(alpha: 0.10);
        final c2 = widget.isDark
            ? Colors.white.withValues(alpha: 0.04)
            : Colors.white.withValues(alpha: 0.08);

        return Stack(
          children: [
            Align(
              alignment: Alignment(dx1, dy1),
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 48, sigmaY: 48),
                child: Container(
                  width: 320,
                  height: 320,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: c1),
                ),
              ),
            ),
            Align(
              alignment: Alignment(dx2, dy2),
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 54, sigmaY: 54),
                child: Container(
                  width: 380,
                  height: 380,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: c2),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _PrimaryCTAButton extends StatefulWidget {
  const _PrimaryCTAButton({
    required this.label,
    required this.foreground,
    required this.onPressed,
    required this.enabledShine,
  });

  final String label;
  final Color foreground;
  final VoidCallback? onPressed;
  final bool enabledShine;

  @override
  State<_PrimaryCTAButton> createState() => _PrimaryCTAButtonState();
}

class _PrimaryCTAButtonState extends State<_PrimaryCTAButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shine = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1050),
  );

  bool _down = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (widget.enabledShine) _shine.forward(from: 0);
    });
  }

  @override
  void didUpdateWidget(covariant _PrimaryCTAButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabledShine && !oldWidget.enabledShine) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _shine.forward(from: 0);
      });
    }
    if (!widget.enabledShine && _shine.isAnimating) _shine.stop();
  }

  @override
  void dispose() {
    _shine.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scale = _down ? 0.985 : 1.0;

    return Listener(
      onPointerDown: (_) => setState(() => _down = true),
      onPointerUp: (_) => setState(() => _down = false),
      onPointerCancel: (_) => setState(() => _down = false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        scale: scale,
        child: SizedBox(
          height: 56,
          width: double.infinity,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                ElevatedButton(
                  onPressed: widget.onPressed,
                  style:
                      ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: widget.foreground,
                        elevation: 0,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ).copyWith(
                        splashFactory: NoSplash.splashFactory,
                        overlayColor: MaterialStateProperty.all(
                          Colors.transparent,
                        ),
                      ),
                  child: Center(
                    child: Text(
                      widget.label,
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ),
                ),
                if (widget.enabledShine)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: AnimatedBuilder(
                        animation: _shine,
                        builder: (context, _) {
                          final t = Curves.easeOutCubic.transform(_shine.value);
                          final dx = lerpDouble(-1.25, 1.25, t)!;

                          return Opacity(
                            opacity: 0.55,
                            child: Transform.translate(
                              offset: Offset(dx * 260, 0),
                              child: Transform.rotate(
                                angle: -0.35,
                                child: Container(
                                  width: 220,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.white.withValues(alpha: 0.00),
                                        Colors.white.withValues(alpha: 0.18),
                                        Colors.white.withValues(alpha: 0.00),
                                        Colors.transparent,
                                      ],
                                      stops: const [0.0, 0.42, 0.50, 0.58, 1.0],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                Positioned.fill(
                  child: IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white.withValues(alpha: 0.10),
                            Colors.transparent,
                          ],
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
    );
  }
}

/// ===========================================================================
/// Engine + models (adaptatif intra-domaine)
/// ===========================================================================
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
      if (current == _Difficulty.easy)
        _difficulty[q.domain] = _Difficulty.medium;
      if (current == _Difficulty.medium)
        _difficulty[q.domain] = _Difficulty.hard;
    } else {
      if (current == _Difficulty.hard)
        _difficulty[q.domain] = _Difficulty.medium;
      if (current == _Difficulty.medium)
        _difficulty[q.domain] = _Difficulty.easy;
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
      _PlacementQuestion(
        id: "fr_e1",
        domain: PlacementDomain.francais,
        difficulty: _Difficulty.easy,
        weight: w1,
        question:
            "Quel mot complète correctement : « Il a ____ le rapport ce matin. »",
        answers: ["rédigé", "rédiger", "rédige", "rédaction"],
        correctIndex: 0,
      ),
      _PlacementQuestion(
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
      _PlacementQuestion(
        id: "fr_m1",
        domain: PlacementDomain.francais,
        difficulty: _Difficulty.medium,
        weight: w2,
        question:
            "Quelle est la nature de la proposition : « …qu’il interviendra immédiatement » ?",
        answers: ["relative", "complétive", "circonstancielle", "juxtaposée"],
        correctIndex: 1,
      ),
      _PlacementQuestion(
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
      _PlacementQuestion(
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
      _PlacementQuestion(
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
      _PlacementQuestion(
        id: "lo_e1",
        domain: PlacementDomain.logique,
        difficulty: _Difficulty.easy,
        weight: w1,
        question: "Suite : 2, 4, 8, 16, …",
        answers: ["18", "20", "24", "32"],
        correctIndex: 3,
      ),
      _PlacementQuestion(
        id: "lo_e2",
        domain: PlacementDomain.logique,
        difficulty: _Difficulty.easy,
        weight: w1,
        question: "Si A > B et B > C, alors :",
        answers: ["A > C", "A = C", "A < C", "Impossible"],
        correctIndex: 0,
      ),
      _PlacementQuestion(
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
      _PlacementQuestion(
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
      _PlacementQuestion(
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
      _PlacementQuestion(
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
      _PlacementQuestion(
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
      _PlacementQuestion(
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
      _PlacementQuestion(
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
      _PlacementQuestion(
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
      _PlacementQuestion(
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
      _PlacementQuestion(
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
      _PlacementQuestion(
        id: "hi_e1",
        domain: PlacementDomain.histoire,
        difficulty: _Difficulty.easy,
        weight: w1,
        question: "Le préfet représente l’État dans :",
        answers: ["la commune", "le département", "l’école", "l’entreprise"],
        correctIndex: 1,
      ),
      _PlacementQuestion(
        id: "hi_e2",
        domain: PlacementDomain.histoire,
        difficulty: _Difficulty.easy,
        weight: w1,
        question: "La Constitution actuelle de la France date de :",
        answers: ["1946", "1958", "1968", "1875"],
        correctIndex: 1,
      ),
      _PlacementQuestion(
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
      _PlacementQuestion(
        id: "hi_m2",
        domain: PlacementDomain.histoire,
        difficulty: _Difficulty.medium,
        weight: w2,
        question: "Quelle autorité dirige une enquête de flagrance ?",
        answers: ["le juge civil", "le parquet", "le maire", "le préfet"],
        correctIndex: 1,
      ),
      _PlacementQuestion(
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
      _PlacementQuestion(
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
      _PlacementQuestion(
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
      _PlacementQuestion(
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
      _PlacementQuestion(
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
      _PlacementQuestion(
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
      _PlacementQuestion(
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
      _PlacementQuestion(
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
