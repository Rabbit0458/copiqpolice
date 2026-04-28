import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/scheduler.dart';

// ✅ ton import correct
import 'package:copiqpolice/core/widgets/app_notifier.dart' show AppSettingsController;

class GpxCasPratiqueListPage extends StatefulWidget {
  const GpxCasPratiqueListPage({super.key});

  static const String routeName = '/gpx_exam/concours/cas_pratique/list';

  @override
  State<GpxCasPratiqueListPage> createState() => _GpxCasPratiqueListPageState();
}

class _GpxCasPratiqueListPageState extends State<GpxCasPratiqueListPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 800),
  )..forward();

  /// ✅ Empêche les doubles taps / doubles navigations (fixe ! _debugLocked)
  bool _navBusy = false;

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
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  Future<void> _safeNav(Future<void> Function() action) async {
    if (_navBusy) return;
    _navBusy = true;
    try {
      // ✅ attend la fin du frame courant avant de naviguer (évite le "locked")
      await WidgetsBinding.instance.endOfFrame;
      if (!mounted) return;

      await action();
    } finally {
      _navBusy = false;
    }
  }

  void _goBack() {
    if (_navBusy) return;
    _navBusy = true;

    HapticFeedback.selectionClick();

    // On laisse Flutter finir les transitions / pops précédents
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) {
        _navBusy = false;
        return;
      }

      // micro délai = laisse finir l'unlock interne du Navigator
      await Future<void>.delayed(const Duration(milliseconds: 1));
      if (!mounted) {
        _navBusy = false;
        return;
      }

      final nav = Navigator.of(context, rootNavigator: true);

      if (nav.canPop()) {
        try {
          nav.pop();
        } finally {
          _navBusy = false;
        }
      } else {
        _navBusy = false;
      }
    });
  }

  void _openCase(String route) {
    _safeNav(() async {
      HapticFeedback.selectionClick();
      if (!mounted) return;

      await Navigator.of(context).pushNamed(route);
    });
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = _reduceMotion(context);
    final appCtrl = AppSettingsController.I;

    final cases = const <_CaseTileData>[
      _CaseTileData(
        index: 1,
        points: 15,
        eta: "~ 15 min",
        route: '/gpx_exam/concours/cas_pratique/case_1',
        status: _CaseStatus.ready,
      ),
      _CaseTileData(
        index: 2,
        points: 15,
        eta: "~ 15 min",
        route: '/gpx_exam/concours/cas_pratique/case_2',
        status: _CaseStatus.ready,
      ),
      _CaseTileData(
        index: 3,
        points: 15,
        eta: "~ 15 min",
        route: '/gpx_exam/concours/cas_pratique/case_3',
        status: _CaseStatus.ready,
      ),
      _CaseTileData(
        index: 4,
        points: 15,
        eta: "~ 15 min",
        route: '/gpx_exam/concours/cas_pratique/case_4',
        status: _CaseStatus.ready,
      ),
      _CaseTileData(
        index: 5,
        points: 15,
        eta: "~ 15 min",
        route: '/gpx_exam/concours/cas_pratique/case_5',
        status: _CaseStatus.ready,
      ),
      _CaseTileData(
        index: 6,
        points: 15,
        eta: "~ 15 min",
        route: '/gpx_exam/concours/cas_pratique/case_6',
        status: _CaseStatus.ready,
      ),
      _CaseTileData(
        index: 7,
        points: 15,
        eta: "~ 15 min",
        route: '/gpx_exam/concours/cas_pratique/case_7',
        status: _CaseStatus.ready,
      ),
      _CaseTileData(
        index: 8,
        points: 15,
        eta: "~ 15 min",
        route: '/gpx_exam/concours/cas_pratique/case_8',
        status: _CaseStatus.ready,
      ),
      _CaseTileData(
        index: 9,
        points: 15,
        eta: "~ 15 min",
        route: '/gpx_exam/concours/cas_pratique/case_9',
        status: _CaseStatus.ready,
      ),
      _CaseTileData(
        index: 10,
        points: 15,
        eta: "~ 15 min",
        route: '/gpx_exam/concours/cas_pratique/case_10',
        status: _CaseStatus.ready,
      ),
      _CaseTileData(
        index: 11,
        points: 15,
        eta: "~ 15 min",
        route: '/gpx_exam/concours/cas_pratique/case_11',
        status: _CaseStatus.ready,
      ),
      _CaseTileData(
        index: 12,
        points: 15,
        eta: "~ 15 min",
        route: '/gpx_exam/concours/cas_pratique/case_12',
        status: _CaseStatus.ready,
      ),
      _CaseTileData(
        index: 13,
        points: 15,
        eta: "~ 15 min",
        route: '/gpx_exam/concours/cas_pratique/case_13',
        status: _CaseStatus.ready,
      ),
      _CaseTileData(
        index: 14,
        points: 15,
        eta: "~ 15 min",
        route: '/gpx_exam/concours/cas_pratique/case_14',
        status: _CaseStatus.ready,
      ),
      _CaseTileData(
        index: 15,
        points: 15,
        eta: "~ 15 min",
        route: '/gpx_exam/concours/cas_pratique/case_15',
        status: _CaseStatus.ready,
      ),
      _CaseTileData(
        index: 16,
        points: 15,
        eta: "~ 15 min",
        route: '/gpx_exam/concours/cas_pratique/case_16',
        status: _CaseStatus.ready,
      ),
      _CaseTileData(
        index: 17,
        points: 15,
        eta: "~ 15 min",
        route: '/gpx_exam/concours/cas_pratique/case_17',
        status: _CaseStatus.ready,
      ),
      _CaseTileData(
        index: 18,
        points: 15,
        eta: "~ 15 min",
        route: '/gpx_exam/concours/cas_pratique/case_18',
        status: _CaseStatus.ready,
      ),
      _CaseTileData(
        index: 19,
        points: 15,
        eta: "~ 15 min",
        route: '/gpx_exam/concours/cas_pratique/case_19',
        status: _CaseStatus.ready,
      ),
      _CaseTileData(
        index: 20,
        points: 15,
        eta: "~ 15 min",
        route: '/gpx_exam/concours/cas_pratique/case_20',
        status: _CaseStatus.ready,
      ),
      _CaseTileData(
        index: 21,
        points: 15,
        eta: "~ 15 min",
        route: '/gpx_exam/concours/cas_pratique/case_21',
        status: _CaseStatus.ready,
      ),
      _CaseTileData(
        index: 22,
        points: 15,
        eta: "~ 15 min",
        route: '/gpx_exam/concours/cas_pratique/case_22',
        status: _CaseStatus.ready,
      ),
      _CaseTileData(
        index: 23,
        points: 15,
        eta: "~ 15 min",
        route: '/gpx_exam/concours/cas_pratique/case_23',
        status: _CaseStatus.ready,
      ),
      _CaseTileData(
        index: 24,
        points: 15,
        eta: "~ 15 min",
        route: '/gpx_exam/concours/cas_pratique/case_24',
        status: _CaseStatus.ready,
      ),
      _CaseTileData(
        index: 25,
        points: 15,
        eta: "~ 15 min",
        route: '/gpx_exam/concours/cas_pratique/case_25',
        status: _CaseStatus.ready,
      ),
      _CaseTileData(
        index: 26,
        points: 15,
        eta: "~ 15 min",
        route: '/gpx_exam/concours/cas_pratique/case_26',
        status: _CaseStatus.ready,
      ),
      _CaseTileData(
        index: 27,
        points: 15,
        eta: "~ 15 min",
        route: '/gpx_exam/concours/cas_pratique/case_27',
        status: _CaseStatus.ready,
      ),
      _CaseTileData(
        index: 28,
        points: 15,
        eta: "~ 15 min",
        route: '/gpx_exam/concours/cas_pratique/case_28',
        status: _CaseStatus.ready,
      ),
      _CaseTileData(
        index: 29,
        points: 15,
        eta: "~ 15 min",
        route: '/gpx_exam/concours/cas_pratique/case_29',
        status: _CaseStatus.ready,
      ),
      _CaseTileData(
        index: 30,
        points: 15,
        eta: "~ 15 min",
        route: '/gpx_exam/concours/cas_pratique/case_30',
        status: _CaseStatus.ready,
      ),
    ];

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: appCtrl.themeMode,
      builder: (_, mode, __) {
        final theme = Theme.of(context);

        // ✅ système / dark / light (comme tes autres pages)
        final platformDark = theme.brightness == Brightness.dark;
        final bool isDark = switch (mode) {
          ThemeMode.dark => true,
          ThemeMode.light => false,
          ThemeMode.system => platformDark,
        };

        final cs = theme.colorScheme;

        // ✅ Fond COP’IQ : Light vraiment clair / Dark navy
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
        final overlayTop = Colors.black.withOpacity(isDark ? 0.32 : 0.22);
        final overlayBot = Colors.black.withOpacity(isDark ? 0.42 : 0.32);

        // ✅ Halo blanc (lumière premium)
        final haloA = Colors.white.withOpacity(isDark ? 0.10 : 0.07);
        final haloB = Colors.white.withOpacity(isDark ? 0.04 : 0.03);

        return Theme(
          data: theme.copyWith(
            textTheme: GoogleFonts.montserratTextTheme(theme.textTheme),
            splashFactory: InkSparkle.splashFactory,
          ),
          child: Scaffold(
            backgroundColor: bgTop,
            body: Stack(
              children: [
                // ✅ Fond principal gradient (COPIQ)
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

                // ✅ Halo blanc radial
                Positioned.fill(
                  child: IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          center: const Alignment(0.0, -0.18),
                          radius: 1.18,
                          colors: [haloA, haloB, Colors.transparent],
                          stops: const [0.0, 0.62, 1.0],
                        ),
                      ),
                    ),
                  ),
                ),

                // ✅ Backdrop premium (lignes)
                Positioned.fill(
                  child: _PremiumBackdrop(
                    enabledMotion: !reduceMotion,
                    controller: _c,
                    colorScheme: cs,
                    isDark: isDark,
                  ),
                ),

                // ✅ Overlay final contrast
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
                      Padding(
                        padding: const EdgeInsets.fromLTRB(14, 12, 14, 6),
                        child: Row(
                          children: [
                            // ✅ bouton retour SAFE (désactivé pendant nav)
                            _BackButtonPill(
                              onTap: _navBusy ? () {} : _goBack,
                              fg: Colors.white.withOpacity(0.92),
                              stroke: Colors.white.withOpacity(0.18),
                              bg: Colors.white.withOpacity(0.12),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    "Cas pratiques",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.montserrat(
                                      color: Colors.white.withOpacity(0.98),
                                      fontWeight: FontWeight.w900,
                                      fontSize: 16.8,
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    "Entraînement concours — notation /15",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.montserrat(
                                      color: Colors.white.withOpacity(0.78),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 76),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(18, 10, 18, 12),
                        child: _BannerCard(
                          title: "Mode concours",
                          subtitle:
                              "Lis attentivement. Structure ta réponse.\nValide pour verrouiller la progression.",
                          chips: const [
                            _InfoChip(
                              icon: Icons.shield_rounded,
                              label: "Déontologie",
                            ),
                            _InfoChip(
                              icon: Icons.timer_rounded,
                              label: "Timing",
                            ),
                            _InfoChip(
                              icon: Icons.check_circle_rounded,
                              label: "Validation",
                            ),
                          ],
                          surface: cs.surface,
                          onSurface: cs.onSurface,
                          primary: cs.primary,
                          outline: cs.outlineVariant,
                          shadowOpacity: isDark ? 0.35 : 0.14,
                          chipBg: cs.primaryContainer.withOpacity(
                            isDark ? 0.35 : 0.55,
                          ),
                          chipFg: cs.onPrimaryContainer,
                          chipStroke: cs.outlineVariant,
                        ),
                      ),

                      Expanded(
                        child: ListView.separated(
                          padding: const EdgeInsets.fromLTRB(18, 8, 18, 22),
                          itemCount: cases.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 14),
                          itemBuilder: (context, i) {
                            final d = cases[i];

                            final child = _CaseTile(
                              data: d,
                              onTap: () => _openCase(d.route),
                              cs: cs,
                              isDark: isDark,
                            );

                            if (reduceMotion) return child;

                            final t = CurvedAnimation(
                              parent: _c,
                              curve: Interval(
                                math.min(0.90, 0.10 + (i * 0.10)),
                                1.0,
                                curve: Curves.easeOutCubic,
                              ),
                            );

                            return AnimatedBuilder(
                              animation: t,
                              builder: (_, __) {
                                return Opacity(
                                  opacity: t.value.clamp(0, 1),
                                  child: Transform.translate(
                                    offset: Offset(0, (1 - t.value) * 14),
                                    child: child,
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
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

/* ───────────────────────────────────────────── */
/* BACKDROP (inchangé, déjà theme-driven)        */
/* ───────────────────────────────────────────── */

class _PremiumBackdrop extends StatelessWidget {
  const _PremiumBackdrop({
    required this.enabledMotion,
    required this.controller,
    required this.colorScheme,
    required this.isDark,
  });

  final bool enabledMotion;
  final AnimationController controller;
  final ColorScheme colorScheme;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final cs = colorScheme;

    // ✅ garde ton calcul (parfait), ça reste cohérent dark/light
    final top =
        Colors.transparent; // important : le gradient COPIQ est déjà dessous
    final mid = Colors.transparent;
    final bot = Colors.transparent;

    return Stack(
      children: [
        // on laisse transparent pour ne pas écraser le fond COPIQ
        DecoratedBox(
          decoration: const BoxDecoration(),
          child: const SizedBox.expand(),
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(
              painter: _LinesPainter(
                progress: enabledMotion ? controller : null,
                ink: Colors.white.withOpacity(isDark ? 0.055 : 0.040),
                glow: Colors.white.withOpacity(isDark ? 0.11 : 0.09),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0.0, -0.2),
                  radius: 1.15,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(isDark ? 0.38 : 0.26),
                  ],
                  stops: const [0.55, 1.0],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _LinesPainter extends CustomPainter {
  _LinesPainter({required this.progress, required this.ink, required this.glow})
    : super(repaint: progress);

  final Animation<double>? progress;
  final Color ink;
  final Color glow;

  @override
  void paint(Canvas canvas, Size size) {
    final t = progress?.value ?? 0.0;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = ink;

    for (int i = 0; i < 14; i++) {
      final y = (i / 14) * size.height;
      final wobble = math.sin((t * 2 * math.pi) + i) * 6.0;

      final p = Path()
        ..moveTo(0, y + wobble)
        ..cubicTo(
          size.width * 0.25,
          y - 8 + wobble,
          size.width * 0.75,
          y + 8 + wobble,
          size.width,
          y + wobble,
        );

      canvas.drawPath(p, paint);
    }

    final glowPaint = Paint()
      ..color = glow
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 24);

    canvas.drawCircle(
      Offset(size.width * 0.18, size.height * 0.12),
      80,
      glowPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _LinesPainter oldDelegate) => false;
}

/* ───────────────────────────────────────────── */
/* TOP BUTTON                                   */
/* ───────────────────────────────────────────── */

class _BackButtonPill extends StatelessWidget {
  const _BackButtonPill({
    required this.onTap,
    required this.bg,
    required this.stroke,
    required this.fg,
  });

  final VoidCallback onTap;
  final Color bg;
  final Color stroke;
  final Color fg;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: "Retour",
      child: InkWell(
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
              Icon(Icons.chevron_left_rounded, size: 18, color: fg),
              const SizedBox(width: 4),
              Text(
                "Retour",
                style: GoogleFonts.montserrat(
                  color: fg,
                  fontWeight: FontWeight.w900,
                  fontSize: 12.5,
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

/* ───────────────────────────────────────────── */
/* BANNER                                       */
/* ───────────────────────────────────────────── */

class _BannerCard extends StatelessWidget {
  const _BannerCard({
    required this.title,
    required this.subtitle,
    required this.chips,
    required this.surface,
    required this.onSurface,
    required this.primary,
    required this.outline,
    required this.shadowOpacity,
    required this.chipBg,
    required this.chipFg,
    required this.chipStroke,
  });

  final String title;
  final String subtitle;
  final List<_InfoChip> chips;

  final Color surface;
  final Color onSurface;
  final Color primary;
  final Color outline;
  final double shadowOpacity;

  final Color chipBg;
  final Color chipFg;
  final Color chipStroke;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: outline),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(shadowOpacity),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: primary,
              boxShadow: [
                BoxShadow(
                  color: primary.withOpacity(0.35),
                  blurRadius: 14,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.assignment_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.montserrat(
                    color: onSurface,
                    fontWeight: FontWeight.w900,
                    fontSize: 15.2,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: GoogleFonts.montserrat(
                    color: onSurface.withOpacity(0.80),
                    fontWeight: FontWeight.w700,
                    fontSize: 12.6,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: chips
                      .map(
                        (c) => _InfoChip(
                          icon: c.icon,
                          label: c.label,
                          bg: chipBg,
                          fg: chipFg,
                          stroke: chipStroke,
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.icon,
    required this.label,
    this.bg,
    this.fg,
    this.stroke,
  });

  final IconData icon;
  final String label;

  final Color? bg;
  final Color? fg;
  final Color? stroke;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final chipBg = bg ?? cs.primaryContainer;
    final chipFg = fg ?? cs.onPrimaryContainer;
    final chipStroke = stroke ?? cs.outlineVariant;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: chipBg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: chipStroke),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: chipFg),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.montserrat(
              color: chipFg,
              fontWeight: FontWeight.w900,
              fontSize: 12.2,
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }
}

/* ───────────────────────────────────────────── */
/* CASE TILE                                    */
/* ───────────────────────────────────────────── */

enum _CaseStatus { ready, locked, done }

class _CaseTileData {
  final int index;
  final int points;
  final String eta;
  final String route;
  final _CaseStatus status;
  final int? score15;

  const _CaseTileData({
    required this.index,
    required this.points,
    required this.eta,
    required this.route,
    required this.status,
    this.score15,
  });
}

class _CaseTile extends StatelessWidget {
  const _CaseTile({
    required this.data,
    required this.onTap,
    required this.cs,
    required this.isDark,
  });

  final _CaseTileData data;
  final VoidCallback onTap;
  final ColorScheme cs;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final locked = data.status == _CaseStatus.locked;
    final done = data.status == _CaseStatus.done;

    final cardShadow = Colors.black.withOpacity(isDark ? 0.35 : 0.10);

    return Opacity(
      opacity: locked ? 0.55 : 1.0,
      child: Material(
        color: cs.surface,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: locked ? null : onTap,
          borderRadius: BorderRadius.circular(18),
          child: Ink(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: cs.outlineVariant),
              boxShadow: [
                BoxShadow(
                  color: cardShadow,
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: [
                _NumberBadge(index: data.index, status: data.status, cs: cs),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Cas pratique n°${data.index}",
                              style: GoogleFonts.montserrat(
                                color: cs.onSurface,
                                fontWeight: FontWeight.w900,
                                fontSize: 16,
                                letterSpacing: -0.2,
                              ),
                            ),
                          ),
                          if (done)
                            _StatusPillDone(score15: data.score15, cs: cs),
                          if (locked) _StatusPillLocked(cs: cs),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _MetaChip(
                            icon: Icons.stars_rounded,
                            label: "${data.points} points",
                            cs: cs,
                          ),
                          const SizedBox(width: 10),
                          _MetaChip(
                            icon: Icons.schedule_rounded,
                            label: data.eta,
                            cs: cs,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Icon(
                  locked ? Icons.lock_rounded : Icons.chevron_right_rounded,
                  color: cs.onSurface,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NumberBadge extends StatelessWidget {
  const _NumberBadge({
    required this.index,
    required this.status,
    required this.cs,
  });

  final int index;
  final _CaseStatus status;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color shadow;
    IconData? icon;

    switch (status) {
      case _CaseStatus.ready:
        bg = cs.primary;
        shadow = cs.primary.withOpacity(0.35);
        icon = null;
        break;
      case _CaseStatus.locked:
        bg = cs.outline;
        shadow = cs.outline.withOpacity(0.22);
        icon = Icons.lock_rounded;
        break;
      case _CaseStatus.done:
        bg = cs.tertiary;
        shadow = cs.tertiary.withOpacity(0.25);
        icon = Icons.check_rounded;
        break;
    }

    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: shadow, blurRadius: 14, offset: const Offset(0, 8)),
        ],
      ),
      child: Center(
        child: icon == null
            ? Text(
                "$index",
                style: GoogleFonts.montserrat(
                  color: cs.onPrimary,
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                  letterSpacing: -0.2,
                ),
              )
            : Icon(icon, color: cs.onPrimary, size: 20),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.label, required this.cs});

  final IconData icon;
  final String label;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: cs.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.montserrat(
              color: cs.onSurface,
              fontWeight: FontWeight.w900,
              fontSize: 12.4,
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusPillLocked extends StatelessWidget {
  const _StatusPillLocked({required this.cs});
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        children: [
          Icon(
            Icons.lock_rounded,
            size: 16,
            color: cs.onSurface.withOpacity(0.75),
          ),
          const SizedBox(width: 6),
          Text(
            "Verrouillé",
            style: GoogleFonts.montserrat(
              color: cs.onSurface,
              fontWeight: FontWeight.w900,
              fontSize: 12.0,
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusPillDone extends StatelessWidget {
  const _StatusPillDone({required this.score15, required this.cs});
  final int? score15;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    final s = score15;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: cs.tertiaryContainer,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        children: [
          Icon(
            Icons.check_circle_rounded,
            size: 16,
            color: cs.onTertiaryContainer,
          ),
          const SizedBox(width: 6),
          Text(
            s == null ? "Terminé" : "Score $s/15",
            style: GoogleFonts.montserrat(
              color: cs.onTertiaryContainer,
              fontWeight: FontWeight.w900,
              fontSize: 12.0,
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }
}
