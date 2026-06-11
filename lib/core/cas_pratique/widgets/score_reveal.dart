// ╔════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Cas Pratique — Widget ScoreReveal                            ║
// ║  Référence : docs/cas_pratique/05_DESIGN_SYSTEM.md (§ 4.6)              ║
// ║  Tâche      : CODE-031                                                  ║
// ║                                                                         ║
// ║  Cercle de progression animé + compteur de score + couleur dynamique   ║
// ║  selon palier. Respecte MediaQuery.disableAnimations.                   ║
// ║                                                                         ║
// ║  Pas de dépendance externe (pas de package confetti pour rester light) ║
// ║  — on affiche un sous-titre de feedback ("Excellent !" / etc.).         ║
// ╚════════════════════════════════════════════════════════════════════════╝

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:copiqpolice/core/cas_pratique/theme/cp_tokens.dart';

/// Cercle de score révélé en animation.
///
/// - Score : 0..maxScore (typiquement 0..15)
/// - Couleur du cercle : rouge < 30% < orange < 70% < vert
/// - Animation : remplissage progressif du cercle + scroll du compteur
/// - Haptic feedback à la fin
class ScoreReveal extends StatefulWidget {
  const ScoreReveal({
    super.key,
    required this.score,
    required this.maxScore,
    this.size = 200.0,
    this.strokeWidth = 14.0,
    this.duration = const Duration(milliseconds: 1200),
    this.feedback,
  });

  /// Score à révéler (peut être non entier : 11.5).
  final double score;

  /// Max (typiquement 15).
  final double maxScore;

  /// Diamètre du cercle.
  final double size;

  /// Épaisseur du trait.
  final double strokeWidth;

  /// Durée de l'animation de révélation.
  final Duration duration;

  /// Texte de feedback custom (sinon généré selon palier).
  final String? feedback;

  @override
  State<ScoreReveal> createState() => _ScoreRevealState();
}

class _ScoreRevealState extends State<ScoreReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;
  bool _hapticDone = false;

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
    _ctrl = AnimationController(vsync: this, duration: widget.duration);
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
    _ctrl.addStatusListener(_onStatus);
  }

  void _onStatus(AnimationStatus s) {
    if (s == AnimationStatus.completed && !_hapticDone) {
      _hapticDone = true;
      HapticFeedback.heavyImpact();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_ctrl.isAnimating && _ctrl.value == 0.0) {
      if (_reduceMotion(context)) {
        _ctrl.value = 1.0;
      } else {
        _ctrl.forward();
      }
    }
  }

  @override
  void dispose() {
    _ctrl.removeStatusListener(_onStatus);
    _ctrl.dispose();
    super.dispose();
  }

  String _autoFeedback(double percent) {
    if (percent >= 90) return 'Excellent !';
    if (percent >= 70) return 'Solide.';
    if (percent >= 50) return 'Pas mal, mais il y a mieux.';
    if (percent >= 30) return 'À reprendre, on revoit les points clés.';
    return 'On recommence et on cible les points manqués.';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final percentTarget = widget.maxScore == 0
        ? 0.0
        : (widget.score / widget.maxScore) * 100.0;
    final ringColor = CpTokens.scoreColor(percentTarget, isDark);
    final ringBg = CpTokens.outlineVariant(isDark);
    final onSurface = CpTokens.onSurface(isDark);
    final onSurfaceMuted = CpTokens.onSurfaceMuted(isDark);

    final feedback = widget.feedback ?? _autoFeedback(percentTarget);

    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) {
        final t = _anim.value.clamp(0.0, 1.0);
        final shownScore = widget.score * t;
        final shownPercent = percentTarget * t;
        final scoreStr = shownScore < 10
            ? shownScore.toStringAsFixed(1)
            : shownScore.toStringAsFixed(1).replaceAll('.0', '');

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: widget.size,
              height: widget.size,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Cercle de fond
                  CustomPaint(
                    size: Size.square(widget.size),
                    painter: _RingPainter(
                      progress: 1.0,
                      color: ringBg.withValues(alpha: 0.45),
                      strokeWidth: widget.strokeWidth,
                    ),
                  ),
                  // Cercle de progression
                  CustomPaint(
                    size: Size.square(widget.size),
                    painter: _RingPainter(
                      progress: t * (percentTarget / 100.0),
                      color: ringColor,
                      strokeWidth: widget.strokeWidth,
                      glow: true,
                    ),
                  ),
                  // Compteur central
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        scoreStr,
                        style: GoogleFonts.montserrat(
                          color: onSurface,
                          fontWeight: FontWeight.w900,
                          fontSize: 56,
                          height: 1.0,
                          letterSpacing: -2,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '/ ${widget.maxScore.toStringAsFixed(widget.maxScore == widget.maxScore.toInt() ? 0 : 1)}',
                        style: GoogleFonts.montserrat(
                          color: onSurfaceMuted,
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: CpTokens.s5),
            Text(
              '${shownPercent.toStringAsFixed(0)} %',
              style: GoogleFonts.montserrat(
                color: ringColor,
                fontWeight: FontWeight.w900,
                fontSize: 24,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              feedback,
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                color: onSurfaceMuted,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ],
        );
      },
    );
  }
}

// ─── Painter du cercle ──────────────────────────────────────────────────────

class _RingPainter extends CustomPainter {
  _RingPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
    this.glow = false,
  });

  final double progress; // 0..1
  final Color color;
  final double strokeWidth;
  final bool glow;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    if (glow) {
      // Petite lueur derrière l'arc
      final glowPaint = Paint()
        ..color = color.withValues(alpha: 0.20)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth + 6
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
      canvas.drawArc(rect, -math.pi / 2, 2 * math.pi * progress, false, glowPaint);
    }

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    if (progress >= 1.0) {
      // Cercle complet
      canvas.drawCircle(center, radius, paint);
    } else {
      canvas.drawArc(rect, -math.pi / 2, 2 * math.pi * progress, false, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _RingPainter old) =>
      old.progress != progress ||
      old.color != color ||
      old.strokeWidth != strokeWidth ||
      old.glow != glow;
}
