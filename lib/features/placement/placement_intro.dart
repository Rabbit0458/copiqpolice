// lib/placement/placement_intro.dart

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:copiqpolice/core/widgets/app_notifier.dart' show AppSettingsController;
import 'package:copiqpolice/features/placement/placement_test.dart';

class PlacementIntro extends StatelessWidget {
  const PlacementIntro({super.key});

  // Palettes alignées Onboarding/Signup (copiées de SignIn)
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

  @override
  Widget build(BuildContext context) {
    final appCtrl = AppSettingsController.I;

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: appCtrl.themeMode,
      builder: (_, mode, __) {
        final isDark = mode == ThemeMode.dark;
        final baseBg = isDark ? _bgDark : _bgLight;
        final ctaFg = isDark ? _bgDark : _bgLight;
        final reduceMotion = _reduceMotion(context);

        return Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: true,
          body: Stack(
            children: [
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: isDark
                          ? const [Color(0xFF000932), Color(0xFF000726)]
                          : const [Color(0xFF0E44D6), Color(0xFF0B38B8)],
                      stops: const [0.0, 1.0],
                    ),
                  ),
                ),
              ),

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
                          Colors.black.withValues(alpha: isDark ? 0.12 : 0.08),
                          Colors.transparent,
                          Colors.black.withValues(alpha: isDark ? 0.22 : 0.18),
                        ],
                        stops: const [0.0, 0.50, 1.0],
                      ),
                    ),
                  ),
                ),
              ),

              SafeArea(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final availableH = constraints.maxHeight;
                    final compact = availableH < 700;

                    // ✅ Logo plus grand (tu peux ajuster ici)
                    final logoH = (availableH * (compact ? 0.23 : 0.27)).clamp(
                      170.0,
                      320.0,
                    );

                    return Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 520),
                        child: SingleChildScrollView(
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          padding: EdgeInsets.fromLTRB(
                            24,
                            compact ? 18 : 28,
                            24,
                            compact ? 18 : 26,
                          ),
                          child: TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0.0, end: 1.0),
                            duration: const Duration(milliseconds: 320),
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
                            child: Column(
                              children: [
                                // ===== LOGO (halo) + glow radial =====
                                SizedBox(
                                  height: logoH,
                                  width: 260,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      // halo principal
                                      Container(
                                        width: 200,
                                        height: 200,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.white.withValues(alpha: 
                                                isDark ? 0.10 : 0.12,
                                              ),
                                              blurRadius: 70,
                                              spreadRadius: 20,
                                            ),
                                          ],
                                        ),
                                      ),

                                      // glow radial subtil
                                      // ✅ glow circulaire (évite la séparation nette)
                                      Positioned.fill(
                                        child: IgnorePointer(
                                          child: Center(
                                            child: ImageFiltered(
                                              imageFilter: ImageFilter.blur(
                                                sigmaX: 18,
                                                sigmaY: 18,
                                              ),
                                              child: Container(
                                                width: 230,
                                                height: 230,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  gradient: RadialGradient(
                                                    center: Alignment.topCenter,
                                                    radius: 0.95,
                                                    colors: [
                                                      Colors.white.withValues(alpha: 
                                                        isDark ? 0.10 : 0.12,
                                                      ),
                                                      Colors.transparent,
                                                    ],
                                                    stops: const [0.0, 1.0],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                      Image.asset(
                                        'assets/images/onboarding.png',
                                        fit: BoxFit.contain,
                                        filterQuality: FilterQuality.high,
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(height: compact ? 10 : 14),

                                // ===== Titre + sous-titre =====
                                Text(
                                  "Test de niveau",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.montserrat(
                                    fontSize: compact ? 21 : 22,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -0.35,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  "Évaluation adaptative intelligente",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.montserrat(
                                    fontSize: compact ? 13.0 : 13.5,
                                    color: _whiteA(.78),
                                    fontWeight: FontWeight.w600,
                                    height: 1.25,
                                  ),
                                ),

                                SizedBox(height: compact ? 16 : 22),

                                // ===== Card glass =====
                                const _GlassCardPremium(
                                  opacity: 0.095,
                                  child: _IntroStats(),
                                ),

                                // ✅ Plus d’air : card -> CTA
                                SizedBox(height: compact ? 22 : 28),

                                // ===== Bouton CTA =====
                                _PrimaryCTAButton(
                                  label: "Commencer le test",
                                  foreground: ctaFg,
                                  enabledShine: !reduceMotion,
                                  onPressed: () {
                                    HapticFeedback.selectionClick();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => PlacementTest(
                                          onFinished: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                ),

                                const SizedBox(height: 14),

                                // ===== Micro indice de sérieux =====
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.verified_user_rounded,
                                      size: 14,
                                      color: _whiteA(.60),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      "Résultat personnalisé et sauvegardé",
                                      style: GoogleFonts.montserrat(
                                        fontSize: 12,
                                        color: _whiteA(.60),
                                        fontWeight: FontWeight.w600,
                                        height: 1.2,
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
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// ===============================
/// Contenu de la card (séparé, propre)
/// ===============================
class _IntroStats extends StatelessWidget {
  const _IntroStats();

  Color _whiteA(double o) => Color.fromRGBO(255, 255, 255, o);

  Widget _infoRow({
    required String left,
    required String right,
    required Color color,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          left,
          style: GoogleFonts.montserrat(
            color: color,
            fontWeight: FontWeight.w800,
            fontSize: 13.5,
          ),
        ),
        Text(
          right,
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 13.5,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _infoRow(
          left: "Questions",
          right: "30 adaptatives",
          color: _whiteA(.82),
        ),
        const SizedBox(height: 12),
        _infoRow(
          left: "Progression",
          right: "Verrouillée",
          color: _whiteA(.82),
        ),
        const SizedBox(height: 12),
        _infoRow(
          left: "Durée estimée",
          right: "15 minutes",
          color: _whiteA(.82),
        ),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.psychology_alt_outlined, size: 14, color: _whiteA(.62)),
            const SizedBox(width: 6),
            Text(
              "Le test s’adapte à tes réponses",
              style: GoogleFonts.montserrat(
                fontSize: 12,
                color: _whiteA(.62),
                height: 1.2,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// ===========================================================================
/// GLASS CARD — version paramétrable (opacity)
/// ===========================================================================
class _GlassCardPremium extends StatelessWidget {
  const _GlassCardPremium({required this.child, this.opacity = 0.075});
  final Widget child;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withValues(alpha: opacity),
        border: Border.all(color: Colors.white.withValues(alpha: 0.10), width: 1),
        boxShadow: [
          BoxShadow(
            blurRadius: 28,
            offset: const Offset(0, 16),
            color: Colors.black.withValues(alpha: 0.22),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
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
                        Colors.black.withValues(alpha: 0.06),
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

/// ===========================================================================
/// FOND DYNAMIQUE BLOBS — copie 1:1 de SignIn
/// ===========================================================================
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
    if (widget.enabled) {
      _c.repeat(reverse: true);
    }
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

/// ===========================================================================
/// CTA Button blanc avec shine — même rendu que SignInPrimaryButton
/// ===========================================================================
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: widget.foreground,
                    elevation: 0,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
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
