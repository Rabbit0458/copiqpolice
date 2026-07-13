part of '../placement_test.dart';

class PlacementResultView extends StatelessWidget {
  const PlacementResultView({
    super.key,
    required this.auto,
    required this.scorePct,
    required this.totalScore,
    required this.maxScore,
    required this.level,
    required this.perDomain,
    required this.answers,
    required this.byId,
    required this.totalDuration,
    required this.remaining,
    required this.reduceMotion,
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
  final Duration totalDuration;
  final Duration remaining;
  final bool reduceMotion;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final correct = answers.where((a) => a.isCorrect).length;
    final wrong = answers.length - correct;
    final accuracy = answers.isEmpty ? 0.0 : correct / answers.length;
    final spent = totalDuration - remaining;
    final accent = scoreColorFromPct(scorePct);
    final strengths = _strengths();
    final weaknesses = _weaknesses();
    final analysis = _analysis(strengths, weaknesses);
    final days = _recommendedDays(scorePct, weaknesses.length);

    return Stack(
      children: [
        if (scorePct >= 80 && !reduceMotion)
          Positioned.fill(child: _ConfettiBurst(color: accent)),
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          PlacementReveal(
                            reduceMotion: reduceMotion,
                            delay: Duration.zero,
                            child: _ResultHero(
                              auto: auto,
                              scorePct: scorePct,
                              level: _publicLevel(scorePct),
                              levelDetail: level,
                              accent: accent,
                              reduceMotion: reduceMotion,
                            ),
                          ),
                          const SizedBox(height: 12),
                          PlacementReveal(
                            reduceMotion: reduceMotion,
                            delay: const Duration(milliseconds: 80),
                            child: _ResultStatsGrid(
                              correct: correct,
                              wrong: wrong,
                              accuracy: accuracy,
                              spent: spent,
                              totalScore: totalScore,
                              maxScore: maxScore,
                            ),
                          ),
                          const SizedBox(height: 12),
                          PlacementReveal(
                            reduceMotion: reduceMotion,
                            delay: const Duration(milliseconds: 150),
                            child: _ResultAnalysis(analysis: analysis),
                          ),
                          const SizedBox(height: 12),
                          PlacementReveal(
                            reduceMotion: reduceMotion,
                            delay: const Duration(milliseconds: 220),
                            child: _ResultSkills(
                              strengths: strengths,
                              weaknesses: weaknesses,
                              perDomain: perDomain,
                            ),
                          ),
                          const SizedBox(height: 12),
                          PlacementReveal(
                            reduceMotion: reduceMotion,
                            delay: const Duration(milliseconds: 290),
                            child: _ResultRecommendation(
                              days: days,
                              scorePct: scorePct,
                            ),
                          ),
                          const SizedBox(height: 18),
                        ],
                      ),
                    ),
                  ),
                  PlacementReveal(
                    reduceMotion: reduceMotion,
                    delay: const Duration(milliseconds: 340),
                    child: PlacementPrimaryButton(
                      label: 'Commencer mon parcours',
                      icon: Icons.play_arrow_rounded,
                      foreground: const Color(0xFF0E44D6),
                      onPressed: onContinue,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<String> _strengths() {
    final ordered = PlacementDomain.values.map((d) {
      final s = perDomain[d];
      final pct = s == null || s.max == 0 ? 0.0 : s.got / s.max;
      return MapEntry(d, pct);
    }).toList()..sort((a, b) => b.value.compareTo(a.value));

    final found = ordered
        .where((e) => e.value >= 0.62)
        .map((e) => placementDomainLabel(e.key))
        .toList();
    if (found.isNotEmpty) return found.take(4).toList();
    return ordered.take(2).map((e) => placementDomainLabel(e.key)).toList();
  }

  List<PlacementDomain> _weaknesses() {
    final ordered = PlacementDomain.values.map((d) {
      final s = perDomain[d];
      final pct = s == null || s.max == 0 ? 0.0 : s.got / s.max;
      return MapEntry(d, pct);
    }).toList()..sort((a, b) => a.value.compareTo(b.value));
    return ordered
        .where((e) => e.value < 0.68)
        .take(3)
        .map((e) => e.key)
        .toList();
  }

  String _analysis(List<String> strengths, List<PlacementDomain> weaknesses) {
    final strongText = strengths.isEmpty
        ? 'quelques bases utiles'
        : strengths.join(', ');
    if (weaknesses.isEmpty) {
      return 'Tu montres une maîtrise très régulière sur l’ensemble du test, avec une base solide en $strongText. COP’IQ peut maintenant te proposer un parcours plus ambitieux pour consolider ton avance.';
    }
    final weakText = weaknesses.map(placementDomainLabel).join(', ');
    return 'Tu maîtrises déjà $strongText. Les réponses montrent surtout un besoin de pratique ciblée en $weakText. Nous adapterons automatiquement les prochains quiz à ton niveau pour accélérer ta progression.';
  }

  int _recommendedDays(double pct, int weaknessCount) {
    if (pct >= 85) return 3;
    if (pct >= 70) return 5 + weaknessCount;
    if (pct >= 50) return 8 + weaknessCount;
    return 12 + weaknessCount;
  }

  String _publicLevel(double pct) {
    if (pct < 40) return 'Débutant';
    if (pct < 60) return 'Intermédiaire';
    if (pct < 80) return 'Avancé';
    return 'Expert';
  }
}

class _ResultHero extends StatelessWidget {
  const _ResultHero({
    required this.auto,
    required this.scorePct,
    required this.level,
    required this.levelDetail,
    required this.accent,
    required this.reduceMotion,
  });

  final bool auto;
  final double scorePct;
  final String level;
  final String levelDetail;
  final Color accent;
  final bool reduceMotion;

  @override
  Widget build(BuildContext context) {
    final pct01 = (scorePct.clamp(0, 100)) / 100.0;
    return PlacementSurface(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 20),
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: accent.withValues(alpha: 0.22)),
            ),
            child: Icon(
              auto ? Icons.timer_off_rounded : Icons.workspace_premium_rounded,
              color: accent,
              size: 27,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Ton niveau est...',
            style: placementText(
              size: 13,
              weight: FontWeight.w800,
              color: _placementMuted,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            level,
            textAlign: TextAlign.center,
            style: placementText(
              size: 30,
              weight: FontWeight.w900,
              height: 1.05,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            levelDetail,
            textAlign: TextAlign.center,
            style: placementText(
              size: 13.2,
              weight: FontWeight.w700,
              color: _placementMuted,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 18),
          _AnimatedScoreRing(
            pct01: pct01,
            color: accent,
            reduceMotion: reduceMotion,
          ),
        ],
      ),
    );
  }
}

class _AnimatedScoreRing extends StatelessWidget {
  const _AnimatedScoreRing({
    required this.pct01,
    required this.color,
    required this.reduceMotion,
  });

  final double pct01;
  final Color color;
  final bool reduceMotion;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: pct01),
      duration: Duration(milliseconds: reduceMotion ? 0 : 1100),
      curve: Curves.easeOutCubic,
      builder: (context, value, _) {
        return SizedBox(
          width: 170,
          height: 170,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 164,
                height: 164,
                child: CircularProgressIndicator(
                  value: 1,
                  strokeWidth: 14,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFFE9EEF6),
                  ),
                ),
              ),
              SizedBox(
                width: 164,
                height: 164,
                child: CircularProgressIndicator(
                  value: value,
                  strokeWidth: 14,
                  strokeCap: StrokeCap.round,
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${(value * 100).toStringAsFixed(0)}%',
                    style: placementText(size: 34, weight: FontWeight.w900),
                  ),
                  Text(
                    'score',
                    style: placementText(
                      size: 12,
                      weight: FontWeight.w800,
                      color: _placementMuted,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ResultStatsGrid extends StatelessWidget {
  const _ResultStatsGrid({
    required this.correct,
    required this.wrong,
    required this.accuracy,
    required this.spent,
    required this.totalScore,
    required this.maxScore,
  });

  final int correct;
  final int wrong;
  final double accuracy;
  final Duration spent;
  final int totalScore;
  final int maxScore;

  @override
  Widget build(BuildContext context) {
    final minutes = spent.inMinutes;
    final seconds = spent.inSeconds - minutes * 60;
    final time =
        '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    return PlacementSurface(
      child: GridView.count(
        crossAxisCount: MediaQuery.sizeOf(context).width >= 620 ? 3 : 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.62,
        children: [
          _StatCard(
            icon: Icons.check_circle_rounded,
            label: 'Bonnes réponses',
            value: '$correct',
            color: const Color(0xFF22C55E),
          ),
          _StatCard(
            icon: Icons.cancel_rounded,
            label: 'Erreurs',
            value: '$wrong',
            color: const Color(0xFFEF4444),
          ),
          _StatCard(
            icon: Icons.timer_rounded,
            label: 'Temps',
            value: time,
            color: const Color(0xFF2453E6),
          ),
          _StatCard(
            icon: Icons.center_focus_strong_rounded,
            label: 'Précision',
            value: '${(accuracy * 100).round()}%',
            color: const Color(0xFF14B8A6),
          ),
          _StatCard(
            icon: Icons.bolt_rounded,
            label: 'Points',
            value: '$totalScore/$maxScore',
            color: _placementGold,
          ),
          _StatCard(
            icon: Icons.trending_up_rounded,
            label: 'Adaptation',
            value: 'Active',
            color: const Color(0xFF8B5CF6),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FC),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _placementLine),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, size: 22, color: color),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: placementText(size: 17, weight: FontWeight.w900),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: placementText(
                  size: 10.8,
                  weight: FontWeight.w700,
                  color: _placementMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ResultAnalysis extends StatelessWidget {
  const _ResultAnalysis({required this.analysis});
  final String analysis;

  @override
  Widget build(BuildContext context) {
    return PlacementSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PlacementSectionTitle(
            title: 'Analyse IA',
            icon: Icons.auto_awesome_rounded,
          ),
          const SizedBox(height: 12),
          Text(
            analysis,
            style: placementText(
              size: 13.5,
              weight: FontWeight.w700,
              color: const Color(0xFF273244),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultSkills extends StatelessWidget {
  const _ResultSkills({
    required this.strengths,
    required this.weaknesses,
    required this.perDomain,
  });

  final List<String> strengths;
  final List<PlacementDomain> weaknesses;
  final Map<PlacementDomain, _DomainScore> perDomain;

  @override
  Widget build(BuildContext context) {
    return PlacementSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PlacementSectionTitle(
            title: 'Forces',
            icon: Icons.verified_rounded,
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: strengths
                .map(
                  (s) => PlacementPill(
                    label: s,
                    icon: Icons.check_rounded,
                    accent: const Color(0xFF22C55E),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 18),
          const PlacementSectionTitle(
            title: 'Compétences à renforcer',
            icon: Icons.school_rounded,
          ),
          const SizedBox(height: 10),
          if (weaknesses.isEmpty)
            Text(
              'Aucune faiblesse majeure détectée sur ce test.',
              style: placementText(
                size: 13,
                weight: FontWeight.w700,
                color: _placementMuted,
              ),
            )
          else
            ...weaknesses.map(
              (d) => _SkillFocusCard(domain: d, score: perDomain[d]),
            ),
        ],
      ),
    );
  }
}

class _SkillFocusCard extends StatelessWidget {
  const _SkillFocusCard({required this.domain, required this.score});

  final PlacementDomain domain;
  final _DomainScore? score;

  @override
  Widget build(BuildContext context) {
    final pct = score == null || score!.max == 0
        ? 0.0
        : score!.got / score!.max;
    final color = scoreColorFrom01(pct);
    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.18)),
      ),
      child: Row(
        children: [
          Icon(Icons.trending_up_rounded, size: 20, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              placementDomainLabel(domain),
              style: placementText(size: 13.2, weight: FontWeight.w900),
            ),
          ),
          Text(
            '${(pct * 100).round()}%',
            style: placementText(
              size: 13,
              weight: FontWeight.w900,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultRecommendation extends StatelessWidget {
  const _ResultRecommendation({required this.days, required this.scorePct});

  final int days;
  final double scorePct;

  @override
  Widget build(BuildContext context) {
    final text = scorePct >= 80
        ? 'Nous estimons que $days jours suffisent pour sécuriser ton niveau actuel et viser l’excellence.'
        : 'Nous estimons que $days jours de pratique ciblée suffisent pour atteindre le niveau suivant.';
    return PlacementSurface(
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0xFF2453E6).withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.flag_rounded, color: Color(0xFF2453E6)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Objectif recommandé',
                  style: placementText(size: 14.2, weight: FontWeight.w900),
                ),
                const SizedBox(height: 4),
                Text(
                  text,
                  style: placementText(
                    size: 12.8,
                    weight: FontWeight.w700,
                    color: _placementMuted,
                    height: 1.38,
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

class _ConfettiBurst extends StatefulWidget {
  const _ConfettiBurst({required this.color});
  final Color color;

  @override
  State<_ConfettiBurst> createState() => _ConfettiBurstState();
}

class _ConfettiBurstState extends State<_ConfettiBurst>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..forward();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) => CustomPaint(
          painter: _ConfettiPainter(
            progress: _controller.value,
            color: widget.color,
          ),
        ),
      ),
    );
  }
}

class _ConfettiPainter extends CustomPainter {
  const _ConfettiPainter({required this.progress, required this.color});

  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final origin = Offset(size.width / 2, size.height * 0.18);
    for (var i = 0; i < 34; i++) {
      final angle = (-math.pi * 0.95) + (i / 33) * (math.pi * 1.9);
      final distance = 36 + (i % 7) * 18 + progress * (90 + (i % 5) * 16);
      final fall = progress * progress * 130;
      final p =
          origin +
          Offset(math.cos(angle) * distance, math.sin(angle) * distance + fall);
      paint.color = [
        color,
        const Color(0xFF2453E6),
        _placementGold,
        const Color(0xFF14B8A6),
      ][i % 4].withValues(alpha: (1 - progress).clamp(0.0, 1.0));
      canvas.save();
      canvas.translate(p.dx, p.dy);
      canvas.rotate(angle + progress * math.pi);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset.zero, width: 8, height: 4),
          const Radius.circular(2),
        ),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
