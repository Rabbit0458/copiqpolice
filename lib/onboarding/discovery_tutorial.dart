// lib/onboarding/discovery_tutorial.dart
import 'dart:async';
import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/onboarding/mode_picker.dart';
import 'package:copiqpolice/onboarding/grade_picker.dart';
import 'package:copiqpolice/home/home_page_gpx_school.dart'
    show HomePageGpxSchoolDiscoveryTutorial, HomePageGpxSchool;
import 'package:copiqpolice/auth/signup.dart';
import 'package:copiqpolice/home/home_page.dart' show UserMode;
import 'package:copiqpolice/onboarding/gpx_school.dart';
import 'package:copiqpolice/ui/app_notifier.dart' show AppSettingsController;

class _T {
  static const Color ink = Color(0xFF212529);

  static BoxShadow get shadow => BoxShadow(
    color: Colors.black.withValues(alpha: .12),
    blurRadius: 28,
    offset: const Offset(0, 16),
  );

  static BoxShadow get softShadow => BoxShadow(
    color: Colors.black.withValues(alpha: .08),
    blurRadius: 18,
    offset: const Offset(0, 10),
  );
}

Color _muted(BuildContext context, [double a = .72]) {
  final base =
      Theme.of(context).textTheme.bodySmall?.color ??
      (Theme.of(context).brightness == Brightness.dark ? Colors.white : _T.ink);
  return base.withValues(alpha: a);
}

class DiscoveryTutorialScreen extends StatefulWidget {
  const DiscoveryTutorialScreen({super.key});

  @override
  State<DiscoveryTutorialScreen> createState() =>
      _DiscoveryTutorialScreenState();
}

class _DiscoveryTutorialScreenState extends State<DiscoveryTutorialScreen>
    with TickerProviderStateMixin {
  static const int _steps = 7;

  final PageController _pc = PageController();
  int _index = 0;

  static const Color _kBlueLight = Color(0xFF1147D9);
  static const Color _kDarkNavy = Color(0xFF000B36);

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

  TextStyle _h1() => GoogleFonts.montserrat(
    fontSize: 22,
    fontWeight: FontWeight.w900,
    color: Colors.white,
    height: 1.08,
    letterSpacing: -0.2,
  );

  TextStyle _p() => GoogleFonts.montserrat(
    fontSize: 13.8,
    fontWeight: FontWeight.w600,
    color: _whiteA(.86),
    height: 1.35,
  );

  @override
  void initState() {
    super.initState();
    _pc.addListener(() {
      final p = _pc.hasClients ? (_pc.page ?? 0.0) : 0.0;
      final nearest = p.round().clamp(0, _steps - 1);
      if (nearest != _index) {
        setState(() => _index = nearest);
        HapticFeedback.selectionClick();
      }
    });
  }

  @override
  void dispose() {
    _pc.dispose();
    super.dispose();
  }

  Future<void> _goNext() async {
    FocusScope.of(context).unfocus();
    if (_index >= _steps - 1) return;
    await _pc.nextPage(
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  void _skipToSignup() {
    HapticFeedback.selectionClick();
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const SignUpPage()));
  }

  void _finishToSignup() {
    HapticFeedback.selectionClick();
    _skipToSignup();
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = _reduceMotion(context);
    final appCtrl = AppSettingsController.I;

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: appCtrl.themeMode,
      builder: (_, mode, __) {
        final platformDark = Theme.of(context).brightness == Brightness.dark;
        final bool isDark = switch (mode) {
          ThemeMode.dark => true,
          ThemeMode.light => false,
          ThemeMode.system => platformDark,
        };

        // ✅ mêmes couleurs que SignUp
        final bg = isDark ? _kDarkNavy : _kBlueLight;

        return Scaffold(
          backgroundColor: bg,
          body: Stack(
            children: [
              Positioned.fill(
                child: _DynamicBlobsBackground(
                  isDark: isDark, // ✅ plus "true"
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
                          Colors.black.withOpacity(0.18),
                          Colors.transparent,
                          Colors.black.withOpacity(0.30),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // ✅ IMPORTANT : on retire le SafeArea autour du PageView
              Positioned.fill(
                child: PageView(
                  controller: _pc,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _HumanCheckStep(
                      h1: _h1(),
                      p: _p(),
                      onVerified: _goNext,
                      blue: _kBlueLight,
                    ),
                    _DiscoveryWelcomeStep(h1: _h1(), p: _p(), onNext: _goNext),
                    _ModePickerRealStep(onPickedSchool: _goNext),
                    _GradePickerRealStep(onPickedGpx: _goNext),
                    _GpxSpaceRealStep(
                      active: _index == 4,
                      onPickedProgram: (program) {
                        HomePageGpxSchool.program = program;
                        _goNext();
                      },
                    ),
                    HomePageGpxSchoolDiscoveryTutorial(
                      active: _index == 5,
                      onFinished: _goNext,
                    ),
                    _FinishStep(
                      h1: _h1(),
                      p: _p(),
                      onCreateAccount: _finishToSignup,
                      autoRedirect: !reduceMotion,
                    ),
                  ],
                ),
              ),

              // Header overlay
              Positioned(
                left: 12,
                right: 12,
                top: 0,
                child: SafeArea(
                  bottom: false,
                  child: Row(
                    children: [
                      _TopTextButton(label: "Quitter", onTap: _skipToSignup),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _GpxSpaceRealStep extends StatefulWidget {
  const _GpxSpaceRealStep({
    required this.active,
    required this.onPickedProgram,
  });

  final bool active;
  final ValueChanged<GpxSchoolProgram> onPickedProgram;

  @override
  State<_GpxSpaceRealStep> createState() => _GpxSpaceRealStepState();
}

class _GpxSchoolArtProxy extends StatelessWidget {
  const _GpxSchoolArtProxy({
    required this.apj20CardKey,
    required this.onTapApj20Override,
  });

  final GlobalKey apj20CardKey;
  final VoidCallback onTapApj20Override;

  @override
  Widget build(BuildContext context) {
    // On reconstruit la page, mais en injectant une Key + un override TAP sur APJ20
    // => tu gardes exactement ton design (blur/spotlight/badges) puisque c’est tes cards.
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
          children: [
            // Header identique
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Espace GPX',
                        style: GoogleFonts.instrumentSans(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          letterSpacing: .2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Qu’est-ce que tu révises aujourd’hui ?',
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(height: 1.25),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  height: 46,
                  width: 46,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    Icons.auto_awesome_rounded,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              '💡 Ce choix n’est pas mémorisé : tu le sélectionnes à chaque démarrage.',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(height: 1.35),
            ),
            const SizedBox(height: 18),

            // Tes cartes (on laisse tout pareil)
            _ProgramHeroCard(
              program: GpxSchoolProgram.institutionValeurs,
              selected: false,
              disabled: true, // en tuto on bloque tout
              onTap: () {},
            ),
            const SizedBox(height: 16),
            _ProgramHeroCard(
              program: GpxSchoolProgram.dpsDpg,
              selected: false,
              disabled: true,
              onTap: () {},
            ),
            const SizedBox(height: 16),
            _ProgramHeroCard(
              program: GpxSchoolProgram.mememtoCirculationRoutiere,
              selected: false,
              disabled: true,
              onTap: () {},
            ),
            const SizedBox(height: 16),
            _ProgramHeroCard(
              program: GpxSchoolProgram.policierEnIntervention,
              selected: false,
              disabled: true,
              onTap: () {},
            ),
            const SizedBox(height: 16),
            _ProgramHeroCard(
              program: GpxSchoolProgram.policierEnInterventionsa,
              selected: false,
              disabled: true,
              onTap: () {},
            ),
            const SizedBox(height: 16),

            // ✅ APJ20 : seul activé + key pour mesurer
            KeyedSubtree(
              key: apj20CardKey,
              child: _ProgramHeroCard(
                program: GpxSchoolProgram.recueilPvApj20,
                selected: true,
                disabled: false,
                onTap: onTapApj20Override,
              ),
            ),

            const SizedBox(height: 16),
            _ProgramHeroCard(
              program: GpxSchoolProgram.dimensionHumaine,
              selected: false,
              disabled: true,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgramHeroCard extends StatelessWidget {
  final GpxSchoolProgram program;
  final bool selected;
  final bool disabled;
  final VoidCallback? onTap;

  const _ProgramHeroCard({
    super.key,
    required this.program,
    required this.selected,
    required this.disabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Widget img;
    try {
      img = Image.asset(program.heroImage, fit: BoxFit.cover);
    } catch (_) {
      img = Container(color: Colors.black.withValues(alpha: .06));
    }

    final borderColor = selected
        ? (isDark
              ? const Color(0xFF90CAF9)
              : const Color(0xFF1565C0).withValues(alpha: .92))
        : theme.dividerColor.withValues(alpha: .18);

    final canTap = !disabled && onTap != null;

    return AnimatedScale(
      scale: selected ? 1.0 : 0.975,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 180),
        opacity: disabled ? .75 : (selected ? 1 : 0.965),
        child: GestureDetector(
          onTap: canTap ? onTap : null,
          child: Container(
            height: 245,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(26),
              boxShadow: [_T.shadow],
              border: Border.all(color: borderColor, width: selected ? 2 : 1),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Positioned.fill(child: img),
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: .42),
                            Colors.black.withValues(alpha: .22),
                            Colors.black.withValues(alpha: .50),
                          ],
                          stops: const [0.0, 0.52, 1.0],
                        ),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    width: 300,
                    height: 170,
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment.center,
                        radius: 0.72,
                        colors: [
                          Colors.white.withValues(alpha: .38),
                          Colors.white.withValues(alpha: .14),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.50, 1.0],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 14,
                  top: 14,
                  child: _GlassPill(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(program.icon, size: 16, color: Colors.white),
                        const SizedBox(width: 8),
                        Text(
                          program.badge,
                          style: GoogleFonts.instrumentSans(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 12.5,
                            letterSpacing: .2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          program.title,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.instrumentSans(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 23,
                            letterSpacing: .3,
                            height: 1.05,
                            shadows: const [
                              Shadow(
                                offset: Offset(0, 2),
                                blurRadius: 10,
                                color: Colors.black87,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          program.subtitle,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.instrumentSans(
                            color: Colors.white.withValues(alpha: .92),
                            fontWeight: FontWeight.w600,
                            fontSize: 13.8,
                            height: 1.25,
                            shadows: const [
                              Shadow(
                                offset: Offset(0, 2),
                                blurRadius: 10,
                                color: Colors.black54,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 14,
                  right: 14,
                  bottom: 14,
                  child: _DiscoverButton(
                    label: selected ? 'Continuer' : 'Choisir',
                    onTap: canTap ? onTap : null,
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

class _GlassPill extends StatelessWidget {
  final Widget child;
  const _GlassPill({required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .14),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withValues(alpha: .18)),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _GpxSpaceRealStepState extends State<_GpxSpaceRealStep>
    with SingleTickerProviderStateMixin {
  final GlobalKey _apj20Key = GlobalKey();

  Rect? _hole;
  bool _showOverlay = false;
  bool _didRun = false;

  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 560),
  );

  late final Animation<double> _drop = CurvedAnimation(
    parent: _c,
    curve: Curves.easeOutCubic,
  );

  static const double _dimOpacity = 0.44;
  static const double _pad = 8;

  @override
  void didUpdateWidget(covariant _GpxSpaceRealStep oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.active && !_didRun) {
      _didRun = true;
      _runIntro();
    }
  }

  Future<void> _runIntro() async {
    // petit délai pour laisser la page se peindre
    await Future.delayed(const Duration(milliseconds: 280));
    if (!mounted) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _measure();
      setState(() => _showOverlay = true);
      _c.forward(from: 0);
      HapticFeedback.selectionClick();
    });
  }

  void _measure() {
    final ctx = _apj20Key.currentContext;
    if (ctx == null) return;

    final targetBox = ctx.findRenderObject() as RenderBox;
    final targetTopLeftGlobal = targetBox.localToGlobal(Offset.zero);
    final targetSize = targetBox.size;

    final overlayBox = context.findRenderObject() as RenderBox;
    final topLeftLocal = overlayBox.globalToLocal(targetTopLeftGlobal);

    setState(() {
      _hole = Rect.fromLTWH(
        topLeftLocal.dx - _pad,
        topLeftLocal.dy - _pad,
        targetSize.width + _pad * 2,
        targetSize.height + _pad * 2,
      );
    });
  }

  Future<void> _pickApj20() async {
    HapticFeedback.selectionClick();
    widget.onPickedProgram(GpxSchoolProgram.recueilPvApj20);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hole = _hole;

    return Stack(
      children: [
        // ✅ L’espace GPX réel
        Positioned.fill(
          child: GpxSchoolArt(
            apj20CardKey: _apj20Key,
            lockToApj20Only: true,
            onApj20TapOverride: _pickApj20,
          ),
        ),

        if (_showOverlay && hole != null) ...[
          // ✅ dim + trou (sans BackdropFilter => stable Impeller)
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: _SpotlightPainter(
                  hole: hole,
                  dimOpacity: _dimOpacity,
                  radius: 26,
                ),
              ),
            ),
          ),

          // ✅ animation “qui descend” : on fait tomber une bordure/glow au bon endroit
          AnimatedBuilder(
            animation: _drop,
            builder: (context, _) {
              final t = _drop.value;

              // départ un peu au-dessus + descend sur la target
              final startDy = -48.0;
              final dy = lerpDouble(startDy, 0.0, t)!;

              return Positioned.fromRect(
                rect: hole.shift(Offset(0, dy)),
                child: IgnorePointer(
                  child: Opacity(
                    opacity: t,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(26),
                        border: Border.all(
                          color: const Color(0xFF1147D9).withOpacity(0.60),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 28,
                            offset: const Offset(0, 18),
                            color: const Color(0xFF1147D9).withOpacity(0.16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          // ✅ bulle + CTA (et surtout : pas de recouvrement de la carte)
          Positioned(
            left: 18,
            right: 18,
            bottom: 16,
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const _TipBubble(
                    title: "Espace GPX",
                    text:
                        "Bienvenue dans l’espace GPX.\n"
                        "On va commencer par un module essentiel : APJ 20.",
                  ),
                  const SizedBox(height: 12),
                  _PrimaryButton(
                    label: "Choisir APJ 20",
                    enabled: true,
                    foreground: const Color(0xFF000B36),
                    onPressed: _pickApj20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _TopTextButton extends StatelessWidget {
  const _TopTextButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = (isDark ? Colors.white : _T.ink).withOpacity(
      isDark ? 0.72 : 0.70,
    );

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.translucent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        child: Text(
          label,
          style: GoogleFonts.montserrat(
            color: color,
            fontWeight: FontWeight.w700,
            fontSize: 13.5,
            letterSpacing: -0.1,
          ),
        ),
      ),
    );
  }
}

class _StepCounter extends StatelessWidget {
  const _StepCounter({
    required this.current,
    required this.total,
    required this.color,
  });

  final int current;
  final int total;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withOpacity(0.10)),
      ),
      child: Text(
        "$current/$total",
        style: GoogleFonts.montserrat(
          color: color,
          fontWeight: FontWeight.w900,
          fontSize: 12.5,
          letterSpacing: -0.1,
        ),
      ),
    );
  }
}

class _DiscoverButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String label;
  const _DiscoverButton({required this.onTap, required this.label});

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 160),
        opacity: disabled ? .55 : 1,
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: _T.ink.withValues(alpha: .92),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .18),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    label,
                    style: GoogleFonts.instrumentSans(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 14.5,
                      letterSpacing: .2,
                      shadows: const [
                        Shadow(
                          offset: Offset(0, 1),
                          blurRadius: 3,
                          color: Colors.black54,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const CircleAvatar(
                radius: 14,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.arrow_forward_rounded,
                  size: 18,
                  color: _T.ink,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ===============================================================
/// STEP 0 — Vérification humaine (aéré + fullscreen, sans card)
/// ===============================================================
class _HumanCheckStep extends StatelessWidget {
  const _HumanCheckStep({
    required this.h1,
    required this.p,
    required this.onVerified,
    required this.blue,
  });

  final TextStyle h1;
  final TextStyle p;
  final VoidCallback onVerified;
  final Color blue;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 42, 18, 0),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _FadeSlideIn(
                delay: const Duration(milliseconds: 0),
                child: Icon(
                  Icons.visibility_off_rounded,
                  size: 46,
                  color: Colors.white.withOpacity(0.92),
                ),
              ),
              const SizedBox(height: 22),
              _FadeSlideIn(
                delay: const Duration(milliseconds: 90),
                child: Text(
                  "Vérification rapide",
                  textAlign: TextAlign.center,
                  style: h1.copyWith(fontSize: 27, height: 1.06),
                ),
              ),
              const SizedBox(height: 14),
              _FadeSlideIn(
                delay: const Duration(milliseconds: 170),
                child: Text(
                  "Nous avons besoin de vérifier que\nvous êtes bien une personne.",
                  textAlign: TextAlign.center,
                  style: p.copyWith(fontSize: 14.6, height: 1.6),
                ),
              ),
              const SizedBox(height: 26),
              _FadeSlideIn(
                delay: const Duration(milliseconds: 240),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.verified_rounded,
                      size: 18,
                      color: Colors.white.withOpacity(0.90),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "Validation automatique en un seul geste",
                      style: GoogleFonts.montserrat(
                        color: Colors.white.withOpacity(0.88),
                        fontWeight: FontWeight.w800,
                        fontSize: 13.4,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              _FadeSlideIn(
                delay: const Duration(milliseconds: 320),
                child: _SlideToContinue(
                  blue: blue,
                  radius: 16,
                  onDone: onVerified,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ===============================================================
/// STEP 1 — Welcome Mode Découverte (style signup)
/// ===============================================================
class _DiscoveryWelcomeStep extends StatelessWidget {
  const _DiscoveryWelcomeStep({
    required this.h1,
    required this.p,
    required this.onNext,
  });

  final TextStyle h1;
  final TextStyle p;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 28, 10, 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _FadeSlideIn(
              delay: const Duration(milliseconds: 0),
              child: Text(
                "Bienvenue 👋",
                textAlign: TextAlign.center,
                style: h1.copyWith(fontSize: 26, height: 1.05),
              ),
            ),
            const SizedBox(height: 12),
            _FadeSlideIn(
              delay: const Duration(milliseconds: 90),
              child: Text(
                "Tu vas découvrir COP’IQ grâce au mode Découverte.\n"
                "On te montre l’essentiel, étape par étape.",
                textAlign: TextAlign.center,
                style: p.copyWith(fontSize: 14.4, height: 1.5),
              ),
            ),
            const SizedBox(height: 18),
            _FadeSlideIn(
              delay: const Duration(milliseconds: 170),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.verified_rounded,
                    size: 18,
                    color: Colors.white.withOpacity(0.90),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "Mode guidé : pas de quiz ici",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      color: Colors.white.withOpacity(0.88),
                      fontWeight: FontWeight.w800,
                      fontSize: 13.2,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            _FadeSlideIn(
              delay: const Duration(milliseconds: 240),
              child: Text(
                "À la fin, tu devras créer un compte pour accéder\n"
                "aux quiz, enregistrer ta progression et retrouver tes résultats.",
                textAlign: TextAlign.center,
                style: p.copyWith(fontSize: 14.0, height: 1.45),
              ),
            ),
            const SizedBox(height: 20),
            _FadeSlideIn(
              delay: const Duration(milliseconds: 320),
              child: _PrimaryButton(
                label: "Continuer",
                enabled: true,
                foreground: const Color(0xFF000B36),
                onPressed: onNext,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModePickerRealStep extends StatefulWidget {
  const _ModePickerRealStep({required this.onPickedSchool});
  final VoidCallback onPickedSchool;

  @override
  State<_ModePickerRealStep> createState() => _ModePickerRealStepState();
}

class _ModePickerRealStepState extends State<_ModePickerRealStep> {
  final GlobalKey _schoolKey = GlobalKey();
  Rect? _hole;

  static const double _blurSigma = 3.2; // ✅ plus léger
  static const double _dimOpacity = 0.32; // ✅ on voit l’app
  static const double _pad = 4;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _measure());
  }

  void _measure() {
    final targetCtx = _schoolKey.currentContext;
    if (targetCtx == null) return;

    final targetBox = targetCtx.findRenderObject() as RenderBox;
    final targetTopLeftGlobal = targetBox.localToGlobal(Offset.zero);
    final targetSize = targetBox.size;

    // ✅ conversion GLOBAL -> LOCAL du Stack de CE step
    final overlayBox = context.findRenderObject() as RenderBox;
    final topLeftLocal = overlayBox.globalToLocal(targetTopLeftGlobal);

    setState(() {
      _hole = Rect.fromLTWH(
        topLeftLocal.dx - _pad,
        topLeftLocal.dy - _pad,
        targetSize.width + _pad * 2,
        targetSize.height + _pad * 2,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final hole = _hole;

    return Stack(
      children: [
        // ✅ page réelle fullscreen
        Positioned.fill(
          child: ModePickerScreen(
            schoolCardKey: _schoolKey,
            lockToSchoolOnly: true,
            onModeSelectedOverride: (mode) async {
              if (mode == UserMode.school) {
                HapticFeedback.selectionClick();
                widget.onPickedSchool();
              }
            },
          ),
        ),

        if (hole != null) ...[
          // ✅ overlay dim + blur léger avec trou
          Positioned.fill(
            child: ClipPath(
              clipper: _HoleClipper(hole),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: _blurSigma,
                  sigmaY: _blurSigma,
                ),
                child: Container(color: Colors.black.withOpacity(_dimOpacity)),
              ),
            ),
          ),

          // ✅ glow clean autour du focus (moins agressif)
          Positioned.fromRect(
            rect: hole,
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(26),
                  border: Border.all(
                    color: const Color(0xFF1147D9).withOpacity(0.45),
                    width: 1.3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 18,
                      offset: const Offset(0, 12),
                      color: const Color(0xFF1147D9).withOpacity(0.12),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ✅ Bulle en bas : SafeArea UNIQUEMENT ici
          Positioned(
            left: 18,
            right: 18,
            bottom: 18,
            child: SafeArea(
              top: false,
              child: const _TipBubble(
                title: "Choisis ton mode",
                text:
                    "Si tu es en école, sélectionne “Je suis en scolarité”.\n"
                    "Les modules proposés seront adaptés à ta formation.",
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _GradePickerRealStep extends StatefulWidget {
  const _GradePickerRealStep({required this.onPickedGpx});
  final VoidCallback onPickedGpx;

  @override
  State<_GradePickerRealStep> createState() => _GradePickerRealStepState();
}

class _GradePickerRealStepState extends State<_GradePickerRealStep> {
  final GlobalKey _gpxKey = GlobalKey();
  Rect? _hole;

  static const double _dimOpacity = 0.42;
  static const double _pad = 6;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _measure());
  }

  void _measure() {
    final targetCtx = _gpxKey.currentContext;
    if (targetCtx == null) return;

    final targetBox = targetCtx.findRenderObject() as RenderBox;
    final targetTopLeftGlobal = targetBox.localToGlobal(Offset.zero);
    final targetSize = targetBox.size;

    final overlayBox = context.findRenderObject() as RenderBox;
    final topLeftLocal = overlayBox.globalToLocal(targetTopLeftGlobal);

    setState(() {
      _hole = Rect.fromLTWH(
        topLeftLocal.dx - _pad,
        topLeftLocal.dy - _pad,
        targetSize.width + _pad * 2,
        targetSize.height + _pad * 2,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final hole = _hole;

    return LayoutBuilder(
      builder: (context, c) {
        final size = Size(c.maxWidth, c.maxHeight);
        final padTop = MediaQuery.of(context).padding.top;
        final padBot = MediaQuery.of(context).padding.bottom;

        // ✅ Position intelligente de la bulle :
        // - si la carte est trop basse => bulle AU-DESSUS de la carte
        // - sinon bulle EN BAS
        const bubbleHeight = 112.0; // approx stable (évite les overlaps)
        const bubbleMargin = 14.0;

        bool placeBubbleAbove = false;
        if (hole != null) {
          final safeBottomLimit =
              size.height - padBot - (bubbleHeight + bubbleMargin);
          // si le bas de la carte descend dans la zone où la bulle serait en bas -> on la met au-dessus
          placeBubbleAbove = hole.bottom > safeBottomLimit;
        }

        double? bubbleTop;
        double? bubbleBottom;

        if (hole != null && placeBubbleAbove) {
          bubbleBottom = null;
          bubbleTop = (hole.top - bubbleHeight - 10).clamp(
            padTop + 10,
            size.height - padBot - bubbleHeight - 10,
          );
        } else {
          bubbleTop = null;
          bubbleBottom = 10; // ✅ plus bas et discret, mais pas collé au bord
        }

        return Stack(
          children: [
            // Page réelle dessous
            Positioned.fill(
              child: GradePickerScreen(
                gpxCardKey: _gpxKey,
                lockToGpxOnly: true,
                onGradeSelectedOverride: (grade) async {
                  HapticFeedback.selectionClick();
                  widget.onPickedGpx();
                },
              ),
            ),

            if (hole != null) ...[
              // ✅ Overlay dim + trou (SANS BackdropFilter => pas de bug Impeller)
              Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(
                    painter: _SpotlightPainter(
                      hole: hole,
                      dimOpacity: _dimOpacity,
                      radius: 26,
                    ),
                  ),
                ),
              ),

              // ✅ Bordure + glow autour de la zone focus
              Positioned.fromRect(
                rect: hole,
                child: IgnorePointer(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(26),
                      border: Border.all(
                        color: const Color(0xFF1147D9).withOpacity(0.55),
                        width: 1.4,
                      ),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 26,
                          offset: const Offset(0, 16),
                          color: const Color(0xFF1147D9).withOpacity(0.14),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ✅ Bulle repositionnée (ne recouvre plus la carte)
              Positioned(
                left: 18,
                right: 18,
                top: bubbleTop,
                bottom: bubbleBottom,
                child: SafeArea(
                  top: false,
                  bottom: true,
                  child: const _TipBubble(
                    title: "Grade",
                    text:
                        "Dans cet exemple, on te montre la scolarité “Gardien de la paix”.\n"
                        "Tu pourras changer ça plus tard dans ton compte.",
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

/// ✅ Spotlight sans BackdropFilter (stable, pas d’Impeller error)
class _SpotlightPainter extends CustomPainter {
  _SpotlightPainter({
    required this.hole,
    required this.dimOpacity,
    required this.radius,
  });

  final Rect hole;
  final double dimOpacity;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black.withOpacity(dimOpacity);

    final full = Path()..addRect(Offset.zero & size);
    final cut = Path()
      ..addRRect(RRect.fromRectAndRadius(hole, Radius.circular(radius)));

    // evenOdd => on peint tout SAUF le trou
    final overlay = Path.combine(PathOperation.difference, full, cut);
    canvas.drawPath(overlay, paint);
  }

  @override
  bool shouldRepaint(covariant _SpotlightPainter oldDelegate) {
    return oldDelegate.hole != hole ||
        oldDelegate.dimOpacity != dimOpacity ||
        oldDelegate.radius != radius;
  }
}

class _ModulesRealStep extends StatefulWidget {
  const _ModulesRealStep({required this.active, required this.onNext});
  final bool active;
  final VoidCallback onNext;

  @override
  State<_ModulesRealStep> createState() => _ModulesRealStepState();
}

class _ModulesRealStepState extends State<_ModulesRealStep> {
  final GlobalKey _apjKey = GlobalKey();
  Rect? _hole;
  bool _focused = false;
  bool _didRun = false;

  static const double _blurSigma = 4.2;
  static const double _dimOpacity = 0.34;
  static const double _pad = 10;

  @override
  void didUpdateWidget(covariant _ModulesRealStep oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.active && !_didRun) {
      _didRun = true;
      _runFocus();
    }
  }

  Future<void> _runFocus() async {
    await Future.delayed(const Duration(milliseconds: 550));
    if (!mounted) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _measure();
      setState(() => _focused = true);
      HapticFeedback.selectionClick();
    });
  }

  void _measure() {
    final targetCtx = _apjKey.currentContext;
    if (targetCtx == null) return;

    final targetBox = targetCtx.findRenderObject() as RenderBox;
    final targetTopLeftGlobal = targetBox.localToGlobal(Offset.zero);
    final targetSize = targetBox.size;

    final overlayBox = context.findRenderObject() as RenderBox;
    final topLeftLocal = overlayBox.globalToLocal(targetTopLeftGlobal);

    setState(() {
      _hole = Rect.fromLTWH(
        topLeftLocal.dx - _pad,
        topLeftLocal.dy - _pad,
        targetSize.width + _pad * 2,
        targetSize.height + _pad * 2,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final hole = _hole;

    return Stack(
      children: [
        Positioned.fill(
          child: HomePageGpxSchool(
            apjTileKey: _apjKey,
            discoveryLockToApj: true,
            onApjTapOverride: () => HapticFeedback.selectionClick(),
          ),
        ),

        if (_focused && hole != null) ...[
          Positioned.fill(
            child: ClipPath(
              clipper: _HoleClipper(hole),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: _blurSigma,
                  sigmaY: _blurSigma,
                ),
                child: Container(color: Colors.black.withOpacity(_dimOpacity)),
              ),
            ),
          ),

          Positioned.fromRect(
            rect: hole,
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: const Color(0xFF1147D9).withOpacity(0.45),
                    width: 1.3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 18,
                      offset: const Offset(0, 12),
                      color: const Color(0xFF1147D9).withOpacity(0.12),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            left: 18,
            right: 18,
            bottom: 18,
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const _TipBubble(
                    title: "Module APJ",
                    text:
                        "Voici un module clé : “Recueil de procès-verbaux”.\n"
                        "Dans l’app complète, tu pourras ouvrir tous les modules.",
                  ),
                  const SizedBox(height: 12),
                  _PrimaryButton(
                    label: "Suivant",
                    enabled: true,
                    foreground: const Color(0xFF000B36),
                    onPressed: widget.onNext,
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// ===============================================================
/// STEP 2 — Focus "Je suis en scolarité"
/// ===============================================================
class _ModeFocusStep extends StatelessWidget {
  const _ModeFocusStep({
    required this.h1,
    required this.p,
    required this.onPickSchool,
  });

  final TextStyle h1;
  final TextStyle p;
  final VoidCallback onPickSchool;

  @override
  Widget build(BuildContext context) {
    // Base UI (derrière)
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          "Bienvenue 👋",
          textAlign: TextAlign.center,
          style: h1.copyWith(fontSize: 24),
        ),
        const SizedBox(height: 10),
        Text(
          "Choisis ton mode pour adapter l’application.",
          textAlign: TextAlign.center,
          style: p.copyWith(fontSize: 14.1, height: 1.45),
        ),
        const SizedBox(height: 18),
        _DimChoiceCard(title: "Je prépare le concours"),
        const SizedBox(height: 14),
        // Carte cible (on la remettra au-dessus)
        _ChoiceCard(title: "Je suis en scolarité", onTap: () {}),
      ],
    );

    return Stack(
      children: [
        // Contenu derrière, non interactif
        AbsorbPointer(
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: content,
          ),
        ),

        // Overlay blur + sombre
        Positioned.fill(
          child: IgnorePointer(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 9, sigmaY: 9),
              child: Container(color: Colors.black.withOpacity(0.45)),
            ),
          ),
        ),

        // Carte éclairée (seule cliquable) + bulle
        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 70, 0, 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _ChoiceCard(
                  title: "Je suis en scolarité",
                  onTap: onPickSchool,
                  spotlight: true,
                ),
                const SizedBox(height: 14),
                _TipBubble(
                  title: "Choisis ton mode",
                  text:
                      "Si tu es en école, sélectionne “Je suis en scolarité”.\n"
                      "Les modules proposés seront adaptés à ta formation.",
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// ===============================================================
/// STEP 3 — Focus "Gardien de la paix"
/// ===============================================================
class _GradeFocusStep extends StatelessWidget {
  const _GradeFocusStep({
    required this.h1,
    required this.p,
    required this.onPickGpx,
  });

  final TextStyle h1;
  final TextStyle p;
  final VoidCallback onPickGpx;

  @override
  Widget build(BuildContext context) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          "Choisis ton grade",
          textAlign: TextAlign.center,
          style: h1.copyWith(fontSize: 24),
        ),
        const SizedBox(height: 10),
        Text(
          "Sélectionne le grade pour accéder aux modules adaptés.",
          textAlign: TextAlign.center,
          style: p.copyWith(fontSize: 14.1, height: 1.45),
        ),
        const SizedBox(height: 18),
        _DimChoiceCard(title: "Réserviste"),
        const SizedBox(height: 14),
        _DimChoiceCard(title: "Policier adjoint"),
        const SizedBox(height: 14),
        _ChoiceCard(title: "Gardien de la paix", onTap: () {}),
      ],
    );

    return Stack(
      children: [
        AbsorbPointer(
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: content,
          ),
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 9, sigmaY: 9),
              child: Container(color: Colors.black.withOpacity(0.45)),
            ),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 90, 0, 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _ChoiceCard(
                  title: "Gardien de la paix",
                  onTap: onPickGpx,
                  spotlight: true,
                ),
                const SizedBox(height: 14),
                _TipBubble(
                  title: "Grade",
                  text:
                      "Dans cet exemple, on te montre la scolarité “Gardien de la paix”.\n"
                      "Tu pourras choisir un autre grade dans ton compte.",
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// ===============================================================
/// STEP 4 — Modules : auto-scroll + focus APJ + bouton suivant
/// ===============================================================
class _ModulesFocusStep extends StatefulWidget {
  const _ModulesFocusStep({
    required this.h1,
    required this.p,
    required this.active,
    required this.onOpenApj,
    required this.onNext,
  });

  final TextStyle h1;
  final TextStyle p;
  final bool active;
  final VoidCallback onOpenApj;
  final VoidCallback onNext;

  @override
  State<_ModulesFocusStep> createState() => _ModulesFocusStepState();
}

class _ModulesFocusStepState extends State<_ModulesFocusStep> {
  final ScrollController _scroll = ScrollController();
  bool _focused = false;
  bool _didRun = false;

  @override
  void didUpdateWidget(covariant _ModulesFocusStep oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.active && !_didRun) {
      _didRun = true;
      _runAutoScrollAndFocus();
    }
  }

  Future<void> _runAutoScrollAndFocus() async {
    await Future.delayed(const Duration(milliseconds: 350));
    if (!mounted) return;

    await _scroll.animateTo(
      620,
      duration: const Duration(milliseconds: 2200),
      curve: Curves.easeInOutCubic,
    );
    if (!mounted) return;

    setState(() => _focused = true);
    HapticFeedback.selectionClick();
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final apjCard = _ModuleCard(
      title: "Recueil de procès-verbaux",
      subtitle: "APJ — procédure & canevas",
      minutes: "≈ 20 min",
      onTap: widget.onOpenApj,
      highlight: true,
    );

    return Stack(
      children: [
        ListView(
          controller: _scroll,
          padding: const EdgeInsets.fromLTRB(0, 6, 0, 90),
          children: [
            Text(
              "Modules — Scolarité GPX",
              textAlign: TextAlign.center,
              style: widget.h1.copyWith(fontSize: 24),
            ),
            const SizedBox(height: 10),
            Text(
              "Petit aperçu : on te guide vers un module essentiel.",
              textAlign: TextAlign.center,
              style: widget.p.copyWith(fontSize: 14.1, height: 1.45),
            ),
            const SizedBox(height: 18),

            _ModuleCard(
              title: "Institutions & valeurs",
              subtitle: "Repères fondamentaux",
              minutes: "≈ 12 min",
              onTap: () {},
            ),
            const SizedBox(height: 12),
            _ModuleCard(
              title: "DPS / DPG",
              subtitle: "Cadre & réflexes",
              minutes: "≈ 15 min",
              onTap: () {},
            ),
            const SizedBox(height: 12),
            _ModuleCard(
              title: "Mémento circulation",
              subtitle: "Procédures terrain",
              minutes: "≈ 10 min",
              onTap: () {},
            ),
            const SizedBox(height: 22),
            Text(
              "Modules avancés",
              textAlign: TextAlign.left,
              style: GoogleFonts.montserrat(
                color: Colors.white.withOpacity(0.80),
                fontWeight: FontWeight.w900,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 12),

            _ModuleCard(
              title: "Interventions",
              subtitle: "Mises en situation",
              minutes: "≈ 18 min",
              onTap: () {},
            ),
            const SizedBox(height: 12),

            // zone focus
            apjCard,

            const SizedBox(height: 12),
            _ModuleCard(
              title: "Dimension humaine",
              subtitle: "Communication & posture",
              minutes: "≈ 14 min",
              onTap: () {},
            ),
          ],
        ),

        if (_focused) ...[
          // overlay
          Positioned.fill(
            child: IgnorePointer(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 9, sigmaY: 9),
                child: Container(color: Colors.black.withOpacity(0.48)),
              ),
            ),
          ),

          // carte APJ seule cliquable + tip + bouton suivant
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 120, 0, 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  apjCard,
                  const SizedBox(height: 14),
                  _TipBubble(
                    title: "Module APJ",
                    text:
                        "Ici, tu peux accéder au module “Recueil de procès-verbaux”.\n"
                        "Dans l’app complète, tu pourras ouvrir tous les modules.",
                  ),
                  const SizedBox(height: 18),
                  _PrimaryButton(
                    label: "Suivant",
                    enabled: true,
                    foreground: const Color(0xFF000B36),
                    onPressed: widget.onNext,
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// ===============================================================
/// STEP 5 — Fin + redirection signup
/// ===============================================================
class _FinishStep extends StatefulWidget {
  const _FinishStep({
    required this.h1,
    required this.p,
    required this.onCreateAccount,
    required this.autoRedirect, // gardé pour compat, mais ignoré
  });

  final TextStyle h1;
  final TextStyle p;
  final VoidCallback onCreateAccount;
  final bool autoRedirect;

  @override
  State<_FinishStep> createState() => _FinishStepState();
}

class _FinishStepState extends State<_FinishStep> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 34, 18, 0),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _FadeSlideIn(
                delay: const Duration(milliseconds: 0),
                child: Icon(
                  Icons.check_circle_rounded,
                  size: 46,
                  color: Colors.white.withOpacity(0.92),
                ),
              ),
              const SizedBox(height: 18),
              _FadeSlideIn(
                delay: const Duration(milliseconds: 180),
                child: Text(
                  "C’est bon 👌",
                  textAlign: TextAlign.center,
                  style: widget.h1.copyWith(fontSize: 27, height: 1.06),
                ),
              ),
              const SizedBox(height: 14),
              _FadeSlideIn(
                delay: const Duration(milliseconds: 170),
                child: Text(
                  "Tu viens de découvrir les bases de COP’IQ.\n"
                  "Pour accéder aux quiz et suivre ta progression,\n"
                  "tu dois maintenant créer ton compte.",
                  textAlign: TextAlign.center,
                  style: widget.p.copyWith(fontSize: 14.6, height: 1.6),
                ),
              ),
              const SizedBox(height: 22),
              _FadeSlideIn(
                delay: const Duration(milliseconds: 260),
                child: _PrimaryButton(
                  label: "Créer mon compte",
                  enabled: true,
                  foreground: const Color(0xFF000B36),
                  onPressed: widget.onCreateAccount,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ===============================================================
/// UI components (style signup)
/// ===============================================================

class _PrimaryButton extends StatefulWidget {
  const _PrimaryButton({
    required this.label,
    required this.enabled,
    required this.foreground,
    required this.onPressed,
  });

  final String label;
  final bool enabled;
  final Color foreground;
  final VoidCallback onPressed;

  @override
  State<_PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<_PrimaryButton> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    final scale = _down ? 0.985 : 1.0;

    final disabledBg = const Color(0xFF1E2A55);
    final disabledFg = const Color(0xFFB0B6C3);

    final bg = widget.enabled ? Colors.white : disabledBg;
    final fg = widget.enabled ? widget.foreground : disabledFg;

    return Listener(
      onPointerDown: (_) => setState(() => _down = true),
      onPointerUp: (_) => setState(() => _down = false),
      onPointerCancel: (_) => setState(() => _down = false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        scale: widget.enabled ? scale : 1.0,
        child: SizedBox(
          height: 56,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: widget.enabled ? widget.onPressed : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: bg,
              foregroundColor: fg,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              widget.label,
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w900,
                fontSize: 16,
                letterSpacing: -0.1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TipBubble extends StatelessWidget {
  const _TipBubble({required this.title, required this.text});

  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bg = isDark ? Colors.white : Theme.of(context).cardColor;
    final titleColor = isDark
        ? Colors.black
        : Theme.of(context).textTheme.titleMedium?.color ?? _T.ink;
    final bodyColor = (isDark ? Colors.black : titleColor).withOpacity(
      isDark ? 0.78 : 0.72,
    );

    return Container(
      constraints: const BoxConstraints(maxWidth: 520),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            blurRadius: 22,
            offset: const Offset(0, 14),
            color: Colors.black.withOpacity(isDark ? 0.22 : 0.10),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            style: GoogleFonts.montserrat(
              color: titleColor,
              fontWeight: FontWeight.w900,
              fontSize: 16,
              letterSpacing: -0.1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            text,
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              color: bodyColor,
              fontWeight: FontWeight.w700,
              fontSize: 13.3,
              height: 1.25,
            ),
          ),
        ],
      ),
    );
  }
}

/// Cards "mode/grade"
class _ChoiceCard extends StatelessWidget {
  const _ChoiceCard({
    required this.title,
    required this.onTap,
    this.spotlight = false,
  });

  final String title;
  final VoidCallback onTap;
  final bool spotlight;

  @override
  Widget build(BuildContext context) {
    final border = spotlight
        ? const Color(0xFF1147D9).withOpacity(0.65)
        : Colors.white.withOpacity(0.12);

    final shadow = spotlight ? 0.26 : 0.14;

    return SizedBox(
      height: 210,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: Colors.white.withOpacity(0.06),
            border: Border.all(color: border, width: spotlight ? 1.4 : 1),
            boxShadow: [
              BoxShadow(
                blurRadius: 26,
                offset: const Offset(0, 14),
                color: Colors.black.withOpacity(shadow),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.10),
                        Colors.transparent,
                        Colors.black.withOpacity(0.10),
                      ],
                    ),
                  ),
                ),
              ),
              Center(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                    height: 1.1,
                  ),
                ),
              ),
              Positioned(
                left: 16,
                right: 16,
                bottom: 16,
                child: Container(
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: Colors.white.withOpacity(0.10)),
                  ),
                  child: Row(
                    children: [
                      Text(
                        "Découvrir",
                        style: GoogleFonts.montserrat(
                          color: Colors.white.withOpacity(0.88),
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.94),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: const Icon(
                          Icons.arrow_forward_rounded,
                          size: 18,
                          color: Color(0xFF1147D9),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DimChoiceCard extends StatelessWidget {
  const _DimChoiceCard({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      child: Opacity(
        opacity: 0.45,
        child: ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
          child: _ChoiceCard(title: title, onTap: () {}),
        ),
      ),
    );
  }
}

/// Module card
class _ModuleCard extends StatelessWidget {
  const _ModuleCard({
    required this.title,
    required this.subtitle,
    required this.minutes,
    required this.onTap,
    this.highlight = false,
  });

  final String title;
  final String subtitle;
  final String minutes;
  final VoidCallback onTap;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final border = highlight
        ? const Color(0xFF1147D9).withOpacity(0.65)
        : Colors.white.withOpacity(0.12);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 110,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white.withOpacity(0.06),
          border: Border.all(color: border, width: highlight ? 1.4 : 1),
          boxShadow: [
            BoxShadow(
              blurRadius: highlight ? 26 : 16,
              offset: const Offset(0, 12),
              color: Colors.black.withOpacity(highlight ? 0.22 : 0.14),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: Colors.white.withOpacity(0.08),
              ),
              child: Icon(
                Icons.menu_book_outlined,
                color: Colors.white.withOpacity(0.85),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.montserrat(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w700,
                      color: Colors.white.withOpacity(0.72),
                      fontSize: 13,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Text(
              minutes,
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w800,
                color: Colors.white.withOpacity(0.70),
                fontSize: 12.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Slider "glissez"
class _SlideToContinue extends StatefulWidget {
  const _SlideToContinue({
    required this.blue,
    required this.onDone,
    this.radius = 16,
  });

  final Color blue;
  final VoidCallback onDone;
  final double radius;

  @override
  State<_SlideToContinue> createState() => _SlideToContinueState();
}

class _SlideToContinueState extends State<_SlideToContinue> {
  double _dx = 0;
  bool _done = false;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final trackW = (w - 44).clamp(260.0, 420.0);
    const h = 56.0;
    const knob = 52.0;
    final maxDx = trackW - knob;

    return SizedBox(
      width: trackW,
      height: h,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(widget.radius),
          border: Border.all(color: Colors.white.withOpacity(0.12)),
          boxShadow: [
            BoxShadow(
              blurRadius: 18,
              offset: const Offset(0, 10),
              color: Colors.black.withOpacity(0.16),
            ),
          ],
        ),
        child: Stack(
          children: [
            Center(
              child: Text(
                _done ? "Validé" : "Glissez pour continuer",
                style: GoogleFonts.montserrat(
                  color: Colors.white.withOpacity(_done ? 0.92 : 0.82),
                  fontWeight: FontWeight.w900,
                  fontSize: 13.8,
                  letterSpacing: -0.1,
                ),
              ),
            ),
            Positioned(
              left: _dx,
              top: 2,
              bottom: 2,
              child: GestureDetector(
                onHorizontalDragUpdate: _done
                    ? null
                    : (d) => setState(() {
                        _dx = (_dx + d.delta.dx).clamp(0, maxDx);
                      }),
                onHorizontalDragEnd: _done
                    ? null
                    : (_) {
                        if (_dx >= maxDx * 0.92) {
                          setState(() {
                            _dx = maxDx;
                            _done = true;
                          });
                          HapticFeedback.selectionClick();
                          Future.delayed(
                            const Duration(milliseconds: 160),
                            widget.onDone,
                          );
                        } else {
                          setState(() => _dx = 0);
                        }
                      },
                child: Container(
                  width: knob,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Icon(Icons.arrow_forward_rounded, color: widget.blue),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Fade/slide
class _FadeSlideIn extends StatefulWidget {
  const _FadeSlideIn({
    required this.child,
    this.delay = Duration.zero,
    this.fromY = 10,
    this.duration = const Duration(milliseconds: 420),
  });

  final Widget child;
  final Duration delay;
  final double fromY;
  final Duration duration;

  @override
  State<_FadeSlideIn> createState() => _FadeSlideInState();
}

class _FadeSlideInState extends State<_FadeSlideIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: widget.duration,
  );

  late final Animation<double> _t = CurvedAnimation(
    parent: _c,
    curve: Curves.easeOutCubic,
  );

  @override
  void initState() {
    super.initState();
    Future.delayed(widget.delay, () {
      if (mounted) _c.forward();
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _t,
      builder: (_, child) {
        final v = _t.value;
        return Opacity(
          opacity: v,
          child: Transform.translate(
            offset: Offset(0, (1 - v) * widget.fromY),
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}

/// Background blobs (signup)
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
            ? Colors.white.withOpacity(0.06)
            : Colors.white.withOpacity(0.10);
        final c2 = widget.isDark
            ? Colors.white.withOpacity(0.04)
            : Colors.white.withOpacity(0.08);

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

class _HoleClipper extends CustomClipper<Path> {
  _HoleClipper(this.hole);
  final Rect hole;

  @override
  Path getClip(Size size) {
    final p = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    p.addRRect(RRect.fromRectAndRadius(hole, const Radius.circular(26)));
    p.fillType = PathFillType.evenOdd;
    return p;
  }

  @override
  bool shouldReclip(covariant _HoleClipper old) => old.hole != hole;
}
