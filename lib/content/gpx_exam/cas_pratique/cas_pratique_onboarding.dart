import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

// ✅ ton import
import 'package:copiqpolice/core/widgets/app_notifier.dart' show AppSettingsController;

class GpxCasPratiqueEtapesReussitePage extends StatefulWidget {
  const GpxCasPratiqueEtapesReussitePage({super.key});

  static const String routeName =
      '/gpx_exam/concours/cas_pratique/cas_pratique_etapes_reussite';

  @override
  State<GpxCasPratiqueEtapesReussitePage> createState() =>
      _GpxCasPratiqueEtapesReussitePageState();
}

class _GpxCasPratiqueEtapesReussitePageState
    extends State<GpxCasPratiqueEtapesReussitePage> {
  static const Color _kBlue = Color(0xFF1147D9);

  final PageController _pageController = PageController();
  int _index = 0;

  final List<_MethodStepData> _steps = const [
    _MethodStepData(
      title: "1. Avant d’agir",
      items: [
        "Adopter une posture calme et professionnelle",
        "Priorité absolue à la sécurité",
        "Aucune opinion personnelle",
        "Toujours raisonner en équipe",
      ],
    ),
    _MethodStepData(
      title: "2. Lecture du sujet",
      items: [
        "Identifier les faits objectifs",
        "Distinguer faits / paroles / émotions",
        "Repérer les dangers immédiats",
        "Noter victimes, auteurs, témoins",
      ],
    ),
    _MethodStepData(
      title: "3. Analyse policière",
      items: [
        "Y a-t-il un danger immédiat ?",
        "Faut-il sécuriser ou interpeller ?",
        "Mission police secours / judiciaire / administrative",
        "Peut-on différer l’action ?",
      ],
    ),
    _MethodStepData(
      title: "4. Structure de réponse",
      items: ["Situation", "Priorités", "Actions", "Suites"],
    ),
    _MethodStepData(
      title: "5. Ce que le jury attend",
      items: [
        "Logique chronologique",
        "Justification de chaque action",
        "Respect du cadre légal",
        "Compte-rendu hiérarchique",
      ],
    ),
  ];

  bool _reduceMotion(BuildContext context) {
    final mq = MediaQuery.maybeOf(context);
    final disableByOS = WidgetsBinding
        .instance
        .platformDispatcher
        .accessibilityFeatures
        .disableAnimations;
    return (mq?.disableAnimations ?? false) || disableByOS;
  }

  void _next() {
    HapticFeedback.selectionClick();

    if (_index < _steps.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
      );
    } else {
      Navigator.of(
        context,
      ).pushReplacementNamed('/gpx_exam/concours/cas_pratique/list');
    }
  }

  @override
  Widget build(BuildContext context) {
    final appCtrl = AppSettingsController.I;

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: appCtrl.themeMode,
      builder: (_, mode, __) {
        final isDark = _CopiqTheme.isDarkFromMode(context, mode);
        final reduceMotion = _reduceMotion(context);

        // ✅ Fond COPIQ (Dark / Light vraiment différents)
        final bgTop = isDark
            ? const Color(0xFF000B36)
            : const Color(0xFF1147D9);
        final bgMid = isDark
            ? const Color(0xFF000A33)
            : const Color(0xFF1A55E6);
        final bgBot = isDark
            ? const Color(0xFF00082D)
            : const Color(0xFF0E2F9E);

        // ✅ Overlay contrast
        final overlayTop = Colors.black.withValues(alpha: isDark ? 0.32 : 0.22);
        final overlayBot = Colors.black.withValues(alpha: isDark ? 0.42 : 0.32);

        // ✅ Halo blanc (la “lumière” derrière le texte)
        final haloA = Colors.white.withValues(alpha: isDark ? 0.10 : 0.07);
        final haloB = Colors.white.withValues(alpha: isDark ? 0.04 : 0.03);

        // Text
        final onBgSoft = Colors.white.withValues(alpha: 0.90);
        final onBgSofter = Colors.white.withValues(alpha: 0.78);

        // CTA
        final ctaBg = Colors.white;
        final ctaFg = _kBlue; // ton bleu branding (comme avant)

        return Scaffold(
          backgroundColor: bgTop,
          body: Stack(
            children: [
              // ✅ Fond principal
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

              // ✅ Halo blanc (radial) -> c’est ça qui fait le rendu “premium”
              Positioned.fill(
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: const Alignment(0.0, -0.08),
                        radius: 1.08,
                        colors: [haloA, haloB, Colors.transparent],
                        stops: const [0.0, 0.62, 1.0],
                      ),
                    ),
                  ),
                ),
              ),

              // ✅ Blobs (si animations activées)
              Positioned.fill(
                child: _DynamicBlobsBackground(
                  enabled: !reduceMotion,
                  blobA: Colors.white.withValues(alpha: isDark ? 0.10 : 0.08),
                  blobB: Colors.white.withValues(alpha: isDark ? 0.06 : 0.05),
                ),
              ),

              // ✅ Overlay (contrast)
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

              SafeArea(
                child: Column(
                  children: [
                    // ───────── TOP BAR ─────────
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 10, 14, 6),
                      child: Row(
                        children: [
                          _BackPill(
                            onTap: () {
                              HapticFeedback.selectionClick();
                              Navigator.of(context).pop();
                            },
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _DropletProgress(
                              count: _steps.length,
                              index: _index,
                              activeColor: Colors.white.withValues(alpha: 0.92),
                              idleColor: Colors.white.withValues(alpha: 0.22),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "${_index + 1}/${_steps.length}",
                            style: GoogleFonts.montserrat(
                              color: onBgSofter,
                              fontWeight: FontWeight.w800,
                              fontSize: 12.5,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ───────── CONTENT ─────────
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        physics: const ClampingScrollPhysics(),
                        onPageChanged: (i) {
                          HapticFeedback.selectionClick();
                          setState(() => _index = i);
                        },
                        itemCount: _steps.length,
                        itemBuilder: (_, i) {
                          return _MethodStepSlide(
                            data: _steps[i],
                            titleColor: Colors.white,
                            itemColor: onBgSoft,
                          );
                        },
                      ),
                    ),

                    // ───────── CTA ─────────
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 0, 18, 16),
                      child: SizedBox(
                        height: 56,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _next,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ctaBg,
                            foregroundColor: ctaFg,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            _index == _steps.length - 1
                                ? "Passer au cas pratique"
                                : "Suivant",
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
      },
    );
  }
}

/* ───────────────────────────────────────────── */
/* THEME HELPER                                  */
/* ───────────────────────────────────────────── */

class _CopiqTheme {
  const _CopiqTheme._();

  static bool isDarkFromMode(BuildContext context, ThemeMode mode) {
    final platformDark =
        MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    return switch (mode) {
      ThemeMode.dark => true,
      ThemeMode.light => false,
      ThemeMode.system => platformDark,
    };
  }
}

/* ───────────────────────────────────────────── */
/* DATA MODEL                                    */
/* ───────────────────────────────────────────── */

class _MethodStepData {
  final String title;
  final List<String> items;

  const _MethodStepData({required this.title, required this.items});
}

class _MethodStepSlide extends StatelessWidget {
  const _MethodStepSlide({
    required this.data,
    required this.titleColor,
    required this.itemColor,
  });

  final _MethodStepData data;
  final Color titleColor;
  final Color itemColor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 36, 24, 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              data.title,
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                fontSize: 26,
                fontWeight: FontWeight.w900,
                height: 1.05,
                color: titleColor,
              ),
            ),
            const SizedBox(height: 26),

            ...data.items.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      size: 18,
                      color: Colors.white.withValues(alpha: 0.95),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.65,
                      child: Text(
                        item,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          color: itemColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 14.4,
                          height: 1.45,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DropletProgress extends StatelessWidget {
  const _DropletProgress({
    required this.count,
    required this.index,
    required this.activeColor,
    required this.idleColor,
  });

  final int count;
  final int index;
  final Color activeColor;
  final Color idleColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 10,
      child: Row(
        children: List.generate(count, (i) {
          final active = i <= index;
          final width = i == index ? 26.0 : 16.0;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            width: width,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              color: active ? activeColor : idleColor,
              boxShadow: active && i == index
                  ? [
                      BoxShadow(
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                        color: Colors.black.withValues(alpha: 0.20),
                      ),
                    ]
                  : null,
            ),
          );
        }),
      ),
    );
  }
}

class _BackPill extends StatelessWidget {
  const _BackPill({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
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
            const Icon(
              Icons.chevron_left_rounded,
              size: 18,
              color: Colors.white,
            ),
            const SizedBox(width: 4),
            Text(
              "Retour",
              style: GoogleFonts.montserrat(
                color: Colors.white.withValues(alpha: 0.92),
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

class _DynamicBlobsBackground extends StatefulWidget {
  const _DynamicBlobsBackground({
    required this.enabled,
    required this.blobA,
    required this.blobB,
  });

  final bool enabled;
  final Color blobA;
  final Color blobB;

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
                    color: widget.blobA,
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
                    color: widget.blobB,
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
