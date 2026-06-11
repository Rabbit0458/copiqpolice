import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class GpxCasPratiqueEntrainementWelcomePage extends StatelessWidget {
  const GpxCasPratiqueEntrainementWelcomePage({super.key});

  static const String routeName = '/gpx_exam/concours/cas_pratique/welcome';

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
    final reduceMotion = _reduceMotion(context);

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // ✅ Palette COP’IQ (comme signup/onboarding)
    const kBlueLight = Color(0xFF1147D9);
    const kDarkNavy = Color(0xFF000B36);

    // ⚠️ si ton thème global est bien sync, isDark est fiable.
    // sinon, ça suivra juste Theme.of(context)
    final bgTop = isDark ? kDarkNavy : kBlueLight;
    final bgMid = isDark ? const Color(0xFF000A33) : const Color(0xFF0B2FAE);
    final bgBot = isDark ? const Color(0xFF00082D) : const Color(0xFF072894);

    final overlayTop = Colors.black.withValues(alpha: isDark ? 0.22 : 0.18);
    final overlayBot = Colors.black.withValues(alpha: isDark ? 0.32 : 0.30);

    final onBgStrong = Colors.white.withValues(alpha: 0.98);
    final onBgSoft = Colors.white.withValues(alpha: 0.88);
    final onBgSofter = Colors.white.withValues(alpha: 0.78);

    // ✅ CTA comme capture
    final ctaBg = Colors.white;
    final ctaFg = const Color(0xFF000B36);

    return Scaffold(
      backgroundColor: bgTop,
      body: Stack(
        children: [
          // 1) ✅ Fond principal (en premier, toujours)
          Positioned.fill(
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [bgTop, bgMid, bgBot],
                  ),
                ),
              ),
            ),
          ),

          // 2) Background blobs
          Positioned.fill(
            child: _DynamicBlobsBackground(
              enabled: !reduceMotion,
              blobColorA: Colors.white.withValues(alpha: isDark ? 0.10 : 0.08),
              blobColorB: Colors.white.withValues(alpha: isDark ? 0.06 : 0.05),
            ),
          ),

          // 3) ✅ Halo blanc derrière le texte (LA lumière de ta capture)
          const Positioned.fill(
            child: _CenterGlow(isDark: true), // sera remplacé ci-dessous
          ),

          // ⚠️ petit trick: on ne peut pas mettre isDark dans const
          Positioned.fill(child: _CenterGlow(isDark: isDark)),

          // 4) Overlay top/bot (contraste)
          Positioned.fill(
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [overlayTop, Colors.transparent, overlayBot],
                  ),
                ),
              ),
            ),
          ),

          // 5) ✅ Vignette douce pour le rendu “premium” + focus central
          Positioned.fill(child: _SoftVignette(isDark: isDark)),

          // 6) UI
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 10, 14, 6),
                  child: Row(
                    children: [
                      _TopBackPill(
                        enabled: true, // false si première étape
                        onTap: () {
                          HapticFeedback.selectionClick();
                          Navigator.of(context).pop();
                        },
                      ),

                      const SizedBox(width: 10),

                      // ✅ Titre parfaitement centré
                      Expanded(
                        child: Text(
                          "Entraînement",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                            color: onBgSofter,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),

                      // ✅ Spacer “fantôme” pour équilibrer
                      const SizedBox(width: 92),
                    ],
                  ),
                ),

                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(18, 24, 18, 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Cas pratique.\nOn s’entraîne pour gagner.",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              height: 1.05,
                              color: onBgStrong,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            "Tu progresses comme en conditions réelles.\n"
                            "Objectif : sécurité, cadre légal, action claire.",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(
                              fontSize: 14.4,
                              fontWeight: FontWeight.w600,
                              height: 1.5,
                              color: onBgSoft,
                            ),
                          ),
                          const SizedBox(height: 22),
                          _InfoLine(
                            text: "Lecture d’un scénario terrain",
                            color: Colors.white.withValues(alpha: 0.90),
                          ),
                          const SizedBox(height: 10),
                          _InfoLine(
                            text: "Structure claire et logique",
                            color: Colors.white.withValues(alpha: 0.90),
                          ),
                          const SizedBox(height: 10),
                          _InfoLine(
                            text: "Correction expliquée et utile",
                            color: Colors.white.withValues(alpha: 0.90),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 0, 18, 16),
                  child: SizedBox(
                    height: 56,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        HapticFeedback.selectionClick();
                        Navigator.of(context).pushNamed(
                          '/gpx_exam/concours/cas_pratique/cas_pratique_etapes_reussite',
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ctaBg,
                        foregroundColor: ctaFg,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        "Commencer l’entraînement",
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                        ),
                      ),
                    ),
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

/* ───────────────────────────────────────────── */
/* COMPONENTS                                   */
/* ───────────────────────────────────────────── */

class _BackPill extends StatelessWidget {
  const _BackPill({
    required this.onTap,
    required this.fg,
    required this.bg,
    required this.stroke,
  });

  final VoidCallback onTap;
  final Color fg;
  final Color bg;
  final Color stroke;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: stroke),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.chevron_left_rounded, color: fg, size: 18),
            const SizedBox(width: 4),
            Text(
              "Retour",
              style: GoogleFonts.montserrat(
                color: fg,
                fontWeight: FontWeight.w800,
                fontSize: 12.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({required this.text, required this.color});
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.check_circle_rounded, size: 18, color: color),
        const SizedBox(width: 10),
        Text(
          text,
          style: GoogleFonts.montserrat(
            color: color.withValues(alpha: 0.98),
            fontWeight: FontWeight.w700,
            fontSize: 13.6,
          ),
        ),
      ],
    );
  }
}

class _TopBackPill extends StatelessWidget {
  const _TopBackPill({required this.enabled, required this.onTap});
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1 : 0.45,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(999),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.chevron_left_rounded,
                color: Colors.white.withValues(alpha: 0.9),
                size: 18,
              ),
              const SizedBox(width: 2),
              Text(
                "Précédent",
                style: GoogleFonts.montserrat(
                  color: Colors.white.withValues(alpha: 0.90),
                  fontWeight: FontWeight.w800,
                  fontSize: 12.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CenterGlow extends StatelessWidget {
  const _CenterGlow({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final a = isDark ? 0.01 : 0.05;

    return IgnorePointer(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(0.0, -0.10),
            radius: 0.07,
            colors: [
              Colors.white.withValues(alpha: a),
              Colors.white.withValues(alpha: a * 0.35),
              Colors.transparent,
            ],
            stops: const [0.0, 0.65, 1.0],
          ),
        ),
      ),
    );
  }
}

class _SoftVignette extends StatelessWidget {
  const _SoftVignette({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    // vignette sombre pour redonner du contraste
    final o = isDark ? 0.40 : 0.30;

    return IgnorePointer(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(0.0, -0.15),
            radius: 1.10,
            colors: [Colors.transparent, Colors.black.withValues(alpha: o)],
            stops: const [0.55, 1.0],
          ),
        ),
      ),
    );
  }
}

/* ───────────────────────────────────────────── */
/* BLOBS                                        */
/* ───────────────────────────────────────────── */

class _DynamicBlobsBackground extends StatefulWidget {
  const _DynamicBlobsBackground({
    required this.enabled,
    required this.blobColorA,
    required this.blobColorB,
  });

  final bool enabled;
  final Color blobColorA;
  final Color blobColorB;

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
      builder: (_, __) {
        final t = _c.value;
        return Stack(
          children: [
            Align(
              alignment: Alignment(-0.2 + t * 0.3, -0.1 + t * 0.2),
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 48, sigmaY: 48),
                child: Container(
                  width: 320,
                  height: 320,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.blobColorA,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment(0.2 - t * 0.3, 0.3 - t * 0.2),
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 54, sigmaY: 54),
                child: Container(
                  width: 380,
                  height: 380,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.blobColorB,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
