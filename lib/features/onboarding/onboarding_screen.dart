import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:copiqpolice/core/widgets/app_notifier.dart' show AppSettingsController;

const double kTopPadding = 70;
const double kBottomPadding = 92;
const double kPageMaxWidth = 440;

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, this.onSkip, this.onFinish, this.onLogin});
  final VoidCallback? onSkip;
  final VoidCallback? onFinish;
  final VoidCallback? onLogin;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pc = PageController();
  double _page = 0.0;
  int _index = 0;

  static const _kOnboardingThemeKey = 'onboarding_theme_dark';
  bool _isDark = false;

  // Idle animation for hero (very light)
  late final AnimationController _idle = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 5),
  )..repeat(reverse: true);

  int _lastSnap = 0;

  // Palettes
  static const Color _lightA = Color(0xFF1147D9);
  static const Color _lightB = Color(0xFF174FE0);
  static const Color _darkA = Color(0xFF000B36);
  static const Color _darkB = Color(0xFF001041);

  final List<String> _titles = const [
    "Le concours.\nTu le décroches.",
    "Tu comprends.\nTu retiens.",
    "Tu progresses.\nChaque jour.",
  ];

  final List<String> _subtitles = const [
    "Entraîne-toi comme en conditions réelles :\nQCM, cas concrets, oraux (PA & GPX).",
    "Corrections claires + explications instantanées.\nCOP’IQ cible tes lacunes automatiquement.",
    "Objectifs, stats, routine simple.\nTu vois ta progression, tu restes régulier.",
  ];

  bool get _reduceMotion {
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

    _bootTheme();

    _pc.addListener(() {
      final p = _pc.hasClients ? (_pc.page ?? 0.0) : 0.0;
      setState(() => _page = p);
      _handleSnapHaptic(p);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      GoogleFonts.montserrat();
    });
  }

  Future<void> _bootTheme() async {
    await AppSettingsController.I.load();

    final mode = AppSettingsController.I.themeMode.value;
    final platformDark =
        WidgetsBinding.instance.platformDispatcher.platformBrightness ==
        Brightness.dark;

    final isDark = switch (mode) {
      ThemeMode.dark => true,
      ThemeMode.light => false,
      ThemeMode.system => platformDark,
    };

    if (!mounted) return;
    setState(() => _isDark = isDark);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kOnboardingThemeKey, _isDark);
  }

  void _handleSnapHaptic(double p) {
    final nearest = p.round().clamp(0, 2);
    final delta = (p - nearest).abs();
    const threshold = 0.012;

    if (delta < threshold && nearest != _lastSnap) {
      _lastSnap = nearest;
      HapticFeedback.selectionClick();
      setState(() => _index = nearest);
    }
  }

  Future<void> _persistAndBroadcastTheme() async {
    final target = _isDark ? ThemeMode.dark : ThemeMode.light;
    await AppSettingsController.I.setTheme(target);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kOnboardingThemeKey, _isDark);
  }

  void _toggleThemeInstant() {
    HapticFeedback.selectionClick();
    setState(() => _isDark = !_isDark);
    _persistAndBroadcastTheme();
  }

  void _next() {
    if (_index < 2) {
      _pc.nextPage(
        duration: const Duration(milliseconds: 360),
        curve: Curves.easeOutCubic,
      );
    }
  }

  Future<void> _leaveTo(String route) async {
    await _persistAndBroadcastTheme();
    if (!mounted) return;
    Navigator.of(context).pushNamed(route);
  }

  void _goToSignup() => _leaveTo('/signup');
  void _goToLogin() => _leaveTo('/login');

  @override
  void dispose() {
    _pc.dispose();
    _idle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final w = size.width.clamp(320.0, 500.0);

    final titleStyle = GoogleFonts.montserrat(
      color: Colors.white,
      fontSize: w < 360 ? 25 : 27,
      fontWeight: FontWeight.w800,
      height: 1.12,
      letterSpacing: -0.25,
    );

    final subtitleStyle = GoogleFonts.montserrat(
      color: Colors.white.withValues(alpha: _isDark ? 0.86 : 0.92),
      fontSize: w < 360 ? 14.0 : 14.6,
      fontWeight: FontWeight.w500,
      height: 1.55,
    );
    final progress = (_page.clamp(0.0, 2.0)) / 2.0;
    final swipe = (_page - _page.roundToDouble()).abs().clamp(0.0, 0.5) / 0.5;
    final scale = _reduceMotion ? 1.0 : (1.0 - 0.04 * swipe);

    // EXACT same rule as SignIn/SignUp:
    // Foreground = background color (for readability on white button)
    final ctaFg = _isDark ? _darkA : _lightA;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            // Background: fast theme crossfade
            Positioned.fill(
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: _isDark ? 1 : 0),
                duration: const Duration(milliseconds: 260),
                curve: Curves.easeOutCubic,
                builder: (context, t, _) {
                  final a = Color.lerp(_lightA, _darkA, t)!;
                  final b = Color.lerp(_lightB, _darkB, t)!;
                  return CustomPaint(
                    painter: _PremiumGradientPainter(a: a, b: b),
                  );
                },
              ),
            ),

            // Vignette
            Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.16),
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.30),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Anti-banding
            Positioned.fill(
              child: IgnorePointer(
                child: Opacity(opacity: 0.03, child: const _NoiseOverlay()),
              ),
            ),

            SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: kPageMaxWidth),
                  child: Stack(
                    children: [
                      // Pages
                      Positioned.fill(
                        child: PageView.builder(
                          controller: _pc,
                          physics: const BouncingScrollPhysics(),
                          itemCount: 3,
                          itemBuilder: (_, i) {
                            final dist = (_page - i).abs().clamp(0.0, 1.0);
                            final textOpacity = (1 - dist).clamp(0.0, 1.0);
                            final y = 10.0 * dist;

                            // hero crossfade + parallax
                            final heroOpacity = (1 - dist).clamp(0.0, 1.0);
                            final parallaxX =
                                ((_page - i).clamp(-1.0, 1.0)) * -12;

                            // subtle blur only while swiping
                            final blur = _reduceMotion ? 0.0 : (5.0 * swipe);
                            final jitter = _reduceMotion ? 0.0 : (1.0 * swipe);

                            return Padding(
                              padding: const EdgeInsets.fromLTRB(
                                20,
                                kTopPadding,
                                20,
                                kBottomPadding,
                              ),
                              child: Column(
                                children: [
                                  OnboardingTextCard(
                                    index: _index,
                                    title: _titles[_index],
                                    subtitle: _subtitles[_index],
                                    isDark: _isDark,
                                    w: w,
                                  ),
                                  const SizedBox(height: 18),
                                  Expanded(
                                    child: Center(
                                      child: Opacity(
                                        opacity: heroOpacity,
                                        child: Transform.translate(
                                          offset: Offset(parallaxX, 0),
                                          child: AnimatedBuilder(
                                            animation: _idle,
                                            builder: (context, _) {
                                              final tt =
                                                  _idle.value * 2 * math.pi;

                                              final floatY = _reduceMotion
                                                  ? 0.0
                                                  : math.sin(tt + i) * 7.5;
                                              final tilt = _reduceMotion
                                                  ? 0.0
                                                  : math.sin(tt * 0.8 + i) *
                                                        0.05;

                                              final jitterX =
                                                  math.sin(tt * 2.2 + i) *
                                                  jitter;
                                              final jitterY =
                                                  math.cos(tt * 2.0 + i) *
                                                  jitter;

                                              return Transform.translate(
                                                offset: Offset(
                                                  jitterX,
                                                  floatY + jitterY,
                                                ),
                                                child: Transform(
                                                  alignment: Alignment.center,
                                                  transform: Matrix4.identity()
                                                    ..setEntry(3, 2, 0.0018)
                                                    ..rotateX(tilt)
                                                    ..rotateY(-tilt),
                                                  child: Transform.scale(
                                                    scale: scale,
                                                    child: const _HeroPng(
                                                      asset:
                                                          'assets/images/onboarding.png',
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),

                      // Top bar
                      Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
                          child: Row(
                            children: [
                              _ProgressCapsule(progress: progress),
                              const Spacer(),
                              _TopPillButton(
                                label: "Passer",
                                onTap: () async {
                                  await _persistAndBroadcastTheme();
                                  if (!mounted) return;
                                  (widget.onSkip ?? _goToSignup).call();
                                },
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Bottom bar
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(18, 10, 18, 14),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (_index < 2) ...[
                                _ThemeIconToggle(
                                  isDark: _isDark,
                                  onTap: _toggleThemeInstant,
                                ),
                                const SizedBox(height: 14),
                                _FlatWhiteCtaButton(
                                  label: "Continuer",
                                  foreground: ctaFg,
                                  onPressed: _next,
                                ),
                              ] else ...[
                                _FlatWhiteCtaButton(
                                  label: "Créer un compte",
                                  foreground: ctaFg,
                                  onPressed: () async {
                                    await _persistAndBroadcastTheme();
                                    if (!mounted) return;
                                    (widget.onFinish ?? _goToSignup).call();
                                  },
                                ),
                                const SizedBox(height: 20),
                                _OrDivider(),
                                const SizedBox(height: 16),
                                _FlatWhiteCtaButton(
                                  label: "Se connecter",
                                  foreground: ctaFg,
                                  onPressed: () async {
                                    await _persistAndBroadcastTheme();
                                    if (!mounted) return;
                                    (widget.onLogin ?? _goToLogin).call();
                                  },
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ---------- BACKGROUND ----------

class _PremiumGradientPainter extends CustomPainter {
  _PremiumGradientPainter({required this.a, required this.b});
  final Color a;
  final Color b;

  @override
  void paint(Canvas canvas, Size size) {
    final g = LinearGradient(
      begin: const Alignment(0.0, -0.75),
      end: const Alignment(0.0, 0.95),
      colors: [Color.lerp(a, b, 0.10)!, Color.lerp(b, a, 0.12)!],
    );

    final p = Paint()..shader = g.createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, p);

    final r = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0.0, 0.10),
        radius: 1.05,
        colors: [Colors.white.withValues(alpha: 0.06), Colors.transparent],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, r);
  }

  @override
  bool shouldRepaint(covariant _PremiumGradientPainter old) =>
      old.a != a || old.b != b;
}

/// ---------- UI ----------

class _GlassCard extends StatelessWidget {
  const _GlassCard({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // no BackdropFilter => avoids seams
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: Colors.white.withValues(alpha: 0.10),
        border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            offset: const Offset(0, 10),
            color: Colors.black.withValues(alpha: 0.16),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          children: [
            Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withValues(alpha: 0.12),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroPng extends StatelessWidget {
  const _HeroPng({required this.asset});
  final String asset;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  blurRadius: 42,
                  spreadRadius: 6,
                  offset: const Offset(0, 18),
                  color: Colors.black.withValues(alpha: 0.22),
                ),
              ],
            ),
          ),
          Image.asset(
            asset,
            fit: BoxFit.contain,
            filterQuality: FilterQuality.high,
          ),
        ],
      ),
    );
  }
}

class _ProgressCapsule extends StatelessWidget {
  const _ProgressCapsule({required this.progress});
  final double progress;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 10,
      width: 74,
      child: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
              ),
            ),
          ),
          Align(
            alignment: Alignment.lerp(
              Alignment.centerLeft,
              Alignment.centerRight,
              progress.clamp(0.0, 1.0),
            )!,
            child: Container(
              width: 26,
              height: 10,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.92),
                borderRadius: BorderRadius.circular(999),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                    color: Colors.black.withValues(alpha: 0.16),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopPillButton extends StatelessWidget {
  const _TopPillButton({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
        ),
        child: Text(
          label,
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _ThemeIconToggle extends StatefulWidget {
  const _ThemeIconToggle({required this.isDark, required this.onTap});
  final bool isDark;
  final VoidCallback onTap;

  @override
  State<_ThemeIconToggle> createState() => _ThemeIconToggleState();
}

class _ThemeIconToggleState extends State<_ThemeIconToggle> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    final scale = _down ? 0.985 : 1.0;
    final icon = widget.isDark
        ? Icons.wb_sunny_rounded
        : Icons.nights_stay_rounded;

    return Listener(
      onPointerDown: (_) => setState(() => _down = true),
      onPointerUp: (_) => setState(() => _down = false),
      onPointerCancel: (_) => setState(() => _down = false),
      child: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 110),
        curve: Curves.easeOut,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(999),
          child: Ink(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
              boxShadow: [
                BoxShadow(
                  blurRadius: 16,
                  offset: const Offset(0, 10),
                  color: Colors.black.withValues(alpha: 0.14),
                ),
              ],
            ),
            child: Icon(icon, size: 26, color: Colors.white.withValues(alpha: 0.95)),
          ),
        ),
      ),
    );
  }
}

/// ✅ EXACT SAME DESIGN AS YOUR SignIn ElevatedButton (no gradient, clean, net)
class _FlatWhiteCtaButton extends StatelessWidget {
  const _FlatWhiteCtaButton({
    required this.label,
    required this.foreground,
    required this.onPressed,
  });

  final String label;
  final Color foreground;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: foreground,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: Text(
          label,
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

class _OrDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(color: Colors.white.withValues(alpha: 0.30), thickness: 1),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            "ou",
            style: GoogleFonts.montserrat(
              color: Colors.white.withValues(alpha: 0.70),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: Divider(color: Colors.white.withValues(alpha: 0.30), thickness: 1),
        ),
      ],
    );
  }
}

/// ---------- NOISE (anti-banding) ----------

class _NoiseOverlay extends StatelessWidget {
  const _NoiseOverlay();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _NoisePainter());
  }
}

class _NoisePainter extends CustomPainter {
  static final math.Random _r = math.Random(1337);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (int i = 0; i < 1600; i++) {
      final dx = _r.nextDouble() * size.width;
      final dy = _r.nextDouble() * size.height;
      final a = 0.02 + _r.nextDouble() * 0.05;
      paint.color = (_r.nextBool() ? Colors.white : Colors.black).withValues(alpha: 
        a,
      );
      canvas.drawRect(Rect.fromLTWH(dx, dy, 1, 1), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class OnboardingTextCard extends StatelessWidget {
  const OnboardingTextCard({
    super.key,
    required this.index,
    required this.title,
    required this.subtitle,
    required this.isDark,
    required this.w,
  });

  final int index;
  final String title;
  final String subtitle;
  final bool isDark;
  final double w;

  @override
  Widget build(BuildContext context) {
    final titleStyle = GoogleFonts.montserrat(
      color: Colors.white,
      fontSize: w < 360 ? 24 : 26,
      fontWeight: FontWeight.w800,
      height: 1.06,
      letterSpacing: -0.25,
    );

    final subtitleStyle = GoogleFonts.montserrat(
      color: Colors.white.withValues(alpha: isDark ? 0.76 : 0.84),
      fontSize: w < 360 ? 13.8 : 14.2,
      fontWeight: FontWeight.w500,
      height: 1.50,
    );

    return _StaggerTextWithShine(
      key: ValueKey(index), // IMPORTANT: relance anim à chaque page
      title: title,
      subtitle: subtitle,
      titleStyle: titleStyle,
      subtitleStyle: subtitleStyle,
    );
  }
}

/// ------------------------------
/// STAGGER + SHINE (ULTRA PREMIUM)
/// ------------------------------
class _StaggerTextWithShine extends StatefulWidget {
  const _StaggerTextWithShine({
    super.key,
    required this.title,
    required this.subtitle,
    required this.titleStyle,
    required this.subtitleStyle,
  });

  final String title;
  final String subtitle;
  final TextStyle titleStyle;
  final TextStyle subtitleStyle;

  @override
  State<_StaggerTextWithShine> createState() => _StaggerTextWithShineState();
}

class _StaggerTextWithShineState extends State<_StaggerTextWithShine>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 780),
  );

  // Title appears first
  late final Animation<double> _titleOpacity = CurvedAnimation(
    parent: _c,
    curve: const Interval(0.00, 0.42, curve: Curves.easeOutCubic),
  );

  late final Animation<double> _titleSlide = Tween<double>(begin: 10, end: 0)
      .animate(
        CurvedAnimation(
          parent: _c,
          curve: const Interval(0.00, 0.55, curve: Curves.easeOutCubic),
        ),
      );

  // Subtitle appears after (stagger)
  late final Animation<double> _subOpacity = CurvedAnimation(
    parent: _c,
    curve: const Interval(0.18, 0.70, curve: Curves.easeOutCubic),
  );

  late final Animation<double> _subSlide = Tween<double>(begin: 10, end: 0)
      .animate(
        CurvedAnimation(
          parent: _c,
          curve: const Interval(0.18, 0.80, curve: Curves.easeOutCubic),
        ),
      );

  // Accent line micro pop
  late final Animation<double> _accentScale =
      Tween<double>(begin: 0.92, end: 1.0).animate(
        CurvedAnimation(
          parent: _c,
          curve: const Interval(0.00, 0.40, curve: Curves.easeOutBack),
        ),
      );

  // Shine sweep (diagonal)
  late final Animation<double> _shine = CurvedAnimation(
    parent: _c,
    curve: const Interval(0.02, 0.55, curve: Curves.easeOutCubic),
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _c.forward(from: 0);
    });
  }

  @override
  void didUpdateWidget(covariant _StaggerTextWithShine oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.title != widget.title ||
        oldWidget.subtitle != widget.subtitle) {
      _c.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _GlassCardPremium(
      child: AnimatedBuilder(
        animation: _c,
        builder: (context, _) {
          return Stack(
            children: [
              // ✅ SHINE overlay (very subtle)
              Positioned.fill(
                child: IgnorePointer(
                  child: Opacity(
                    // keep it subtle; tied to animation
                    opacity: 0.75,
                    child: _ShineSweep(t: _shine.value),
                  ),
                ),
              ),

              // Content
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Transform.scale(
                    scale: _accentScale.value,
                    child: Container(
                      width: 3,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.78),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Opacity(
                          opacity: _titleOpacity.value,
                          child: Transform.translate(
                            offset: Offset(0, _titleSlide.value),
                            child: Text(widget.title, style: widget.titleStyle),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Opacity(
                          opacity: _subOpacity.value,
                          child: Transform.translate(
                            offset: Offset(0, _subSlide.value),
                            child: Text(
                              widget.subtitle,
                              style: widget.subtitleStyle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

/// --------------------------------
/// Shine widget (diagonal gradient)
/// --------------------------------
class _ShineSweep extends StatelessWidget {
  const _ShineSweep({required this.t});
  final double t; // 0..1

  @override
  Widget build(BuildContext context) {
    // Sweep from left -> right across the card
    // We move a diagonal bright band using Transform.translate
    final dx = lerpDouble(-1.2, 1.2, t)!;

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Transform.translate(
        offset: Offset(dx * 240, 0), // 240 tuned for card width
        child: Transform.rotate(
          angle: -0.35, // ~ -20°
          child: Container(
            width: 220,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.white.withValues(alpha: 0.10),
                  Colors.white.withValues(alpha: 0.18),
                  Colors.white.withValues(alpha: 0.10),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.35, 0.5, 0.65, 1.0],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StaggerText extends StatefulWidget {
  const _StaggerText({
    super.key,
    required this.title,
    required this.subtitle,
    required this.titleStyle,
    required this.subtitleStyle,
  });

  final String title;
  final String subtitle;
  final TextStyle titleStyle;
  final TextStyle subtitleStyle;

  @override
  State<_StaggerText> createState() => _StaggerTextState();
}

class _StaggerTextState extends State<_StaggerText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 520),
  );

  late final Animation<double> _titleOpacity = CurvedAnimation(
    parent: _c,
    curve: const Interval(0.00, 0.55, curve: Curves.easeOutCubic),
  );

  late final Animation<double> _subOpacity = CurvedAnimation(
    parent: _c,
    curve: const Interval(0.20, 1.00, curve: Curves.easeOutCubic),
  );

  late final Animation<double> _titleSlide = Tween<double>(begin: 10, end: 0)
      .animate(
        CurvedAnimation(
          parent: _c,
          curve: const Interval(0.00, 0.70, curve: Curves.easeOutCubic),
        ),
      );

  late final Animation<double> _subSlide = Tween<double>(begin: 10, end: 0)
      .animate(
        CurvedAnimation(
          parent: _c,
          curve: const Interval(0.22, 1.00, curve: Curves.easeOutCubic),
        ),
      );

  late final Animation<double> _accentScale =
      Tween<double>(begin: 0.92, end: 1.0).animate(
        CurvedAnimation(
          parent: _c,
          curve: const Interval(0.00, 0.55, curve: Curves.easeOutBack),
        ),
      );

  @override
  void initState() {
    super.initState();
    // relance après build (évite un flash)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _c.forward(from: 0);
    });
  }

  @override
  void didUpdateWidget(covariant _StaggerText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.title != widget.title ||
        oldWidget.subtitle != widget.subtitle) {
      _c.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Transform.scale(
              scale: _accentScale.value,
              child: Container(
                width: 3,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.78),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Opacity(
                    opacity: _titleOpacity.value,
                    child: Transform.translate(
                      offset: Offset(0, _titleSlide.value),
                      child: Text(widget.title, style: widget.titleStyle),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Opacity(
                    opacity: _subOpacity.value,
                    child: Transform.translate(
                      offset: Offset(0, _subSlide.value),
                      child: Text(widget.subtitle, style: widget.subtitleStyle),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _GlassCardPremium extends StatelessWidget {
  const _GlassCardPremium({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        // plus transparent = plus premium
        color: Colors.white.withValues(alpha: 0.075),
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
            // subtle highlight top (no blur seams)
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
