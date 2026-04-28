// lib/warning/warning_screen.dart
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:copiqpolice/core/widgets/app_notifier.dart' show AppSettingsController;

class WarningScreen extends StatefulWidget {
  final VoidCallback onAccepted;
  const WarningScreen({super.key, required this.onAccepted});

  @override
  State<WarningScreen> createState() => _WarningScreenState();
}

class _WarningScreenState extends State<WarningScreen>
    with TickerProviderStateMixin {
  bool _redirecting = false;

  // Palettes alignées
  static const Color _kBlueLight = Color(0xFF1147D9);
  static const Color _kDarkNavy = Color(0xFF000B36);

  static const Color _success = Color(0xFF1FE08A);
  static const Color _danger = Color(0xFFFF5A5F);

  late final AnimationController _enterCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 620),
  );

  // Fade + slide + micro scale
  late final Animation<double> _fade = CurvedAnimation(
    parent: _enterCtrl,
    curve: Curves.easeOutCubic,
  );

  late final Animation<double> _slideT = CurvedAnimation(
    parent: _enterCtrl,
    curve: Curves.easeOutCubic,
  );

  late final Animation<double> _scaleT = CurvedAnimation(
    parent: _enterCtrl,
    curve: const Interval(0.0, 1.0, curve: Curves.easeOutBack),
  );

  // Pulse glow icon + shimmer overlay background
  late final AnimationController _pulseCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1700),
  )..repeat(reverse: true);

  late final Animation<double> _pulse = CurvedAnimation(
    parent: _pulseCtrl,
    curve: Curves.easeInOut,
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
    AppSettingsController.I.load();

    // Start “enter” animation after first frame to avoid jank
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _enterCtrl.forward();
    });
  }

  @override
  void dispose() {
    _enterCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  Future<void> _accept() async {
    HapticFeedback.selectionClick();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('warning_ack', true);

    if (!mounted) return;
    setState(() => _redirecting = true);

    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    widget.onAccepted();
  }

  Future<void> _openPrivacy() async {
    HapticFeedback.selectionClick();
    final uri = Uri.parse('https://copiq.fr/politique-de-confidentialite/');
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Impossible d’ouvrir le lien.")),
      );
    }
  }

  TextStyle _h1() => GoogleFonts.montserrat(
    fontSize: 22,
    fontWeight: FontWeight.w900,
    color: Colors.white,
    height: 1.06,
    letterSpacing: -0.2,
  );

  TextStyle _p() => GoogleFonts.montserrat(
    fontSize: 13.8,
    fontWeight: FontWeight.w600,
    color: Colors.white.withOpacity(0.86),
    height: 1.45,
  );

  @override
  Widget build(BuildContext context) {
    final reduceMotion = _reduceMotion(context);

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppSettingsController.I.themeMode,
      builder: (_, mode, __) {
        final platformDark = Theme.of(context).brightness == Brightness.dark;
        final bool isDark = switch (mode) {
          ThemeMode.dark => true,
          ThemeMode.light => false,
          ThemeMode.system => platformDark,
        };

        final bg = isDark ? _kDarkNavy : _kBlueLight;

        final overlay = SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Colors.transparent,
        );

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: overlay,
          child: Scaffold(
            backgroundColor: bg,
            body: Stack(
              children: [
                // ===== Fond blobs (vivant) =====
                Positioned.fill(
                  child: _DynamicBlobsBackground(
                    isDark: isDark,
                    enabled: !reduceMotion,
                  ),
                ),

                // ===== shimmer/blink très léger sur le fond =====
                if (!reduceMotion)
                  Positioned.fill(
                    child: AnimatedBuilder(
                      animation: _pulse,
                      builder: (_, __) {
                        // très subtil
                        final o = 0.06 + 0.06 * _pulse.value;
                        return IgnorePointer(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: const Alignment(-0.8, -0.9),
                                end: const Alignment(0.8, 0.9),
                                colors: [
                                  Colors.white.withOpacity(0.0),
                                  Colors.white.withOpacity(o),
                                  Colors.white.withOpacity(0.0),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                // overlay doux
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

                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 560),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 260),
                          switchInCurve: Curves.easeOutCubic,
                          switchOutCurve: Curves.easeOutCubic,
                          child: _redirecting
                              ? _RedirectingView(
                                  isDark: isDark,
                                  pulse: reduceMotion ? null : _pulse,
                                )
                              : AnimatedBuilder(
                                  animation: _enterCtrl,
                                  builder: (_, child) {
                                    final dy = lerpDouble(
                                      18,
                                      0,
                                      _slideT.value,
                                    )!;
                                    final sc = lerpDouble(
                                      0.985,
                                      1.0,
                                      _scaleT.value,
                                    )!;

                                    return Opacity(
                                      opacity: _fade.value,
                                      child: Transform.translate(
                                        offset: Offset(0, dy),
                                        child: Transform.scale(
                                          scale: sc,
                                          child: child,
                                        ),
                                      ),
                                    );
                                  },
                                  child: _GlassCardPremium(
                                    child: _CardContent(
                                      h1: _h1(),
                                      p: _p(),
                                      pulse: reduceMotion ? null : _pulse,
                                      onAccept: _accept,
                                      onOpenPrivacy: _openPrivacy,
                                    ),
                                  ),
                                ),
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

/// ===== Card premium =====
class _GlassCardPremium extends StatelessWidget {
  const _GlassCardPremium({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.075),
        border: Border.all(color: Colors.white.withOpacity(0.10), width: 1),
        boxShadow: [
          BoxShadow(
            blurRadius: 28,
            offset: const Offset(0, 16),
            color: Colors.black.withOpacity(0.22),
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
                        Colors.white.withOpacity(0.10),
                        Colors.transparent,
                        Colors.black.withOpacity(0.06),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}

class _CardContent extends StatelessWidget {
  const _CardContent({
    required this.h1,
    required this.p,
    required this.onAccept,
    required this.onOpenPrivacy,
    required this.pulse,
  });

  final TextStyle h1;
  final TextStyle p;
  final VoidCallback onAccept;
  final VoidCallback onOpenPrivacy;

  /// null = reduce motion ON
  final Animation<double>? pulse;

  static const Color _success = Color(0xFF1FE08A);
  static const Color _danger = Color(0xFFFF5A5F);

  @override
  Widget build(BuildContext context) {
    Widget icon = const Icon(
      Icons.warning_amber_rounded,
      size: 78,
      color: _danger,
    );

    if (pulse != null) {
      icon = AnimatedBuilder(
        animation: pulse!,
        builder: (_, __) {
          final t = pulse!.value; // 0..1
          final glow = 0.18 + 0.22 * t;
          final scale = 1.0 + 0.03 * t;

          return Transform.scale(
            scale: scale,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: _danger.withOpacity(glow),
                    blurRadius: 30,
                    spreadRadius: 1.5,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: const Icon(
                Icons.warning_amber_rounded,
                size: 78,
                color: _danger,
              ),
            ),
          );
        },
      );
    } else {
      icon = Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: _danger.withOpacity(0.22),
              blurRadius: 26,
              spreadRadius: 1,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: const Icon(
          Icons.warning_amber_rounded,
          size: 78,
          color: _danger,
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        icon,
        const SizedBox(height: 14),

        Text(
          "Avertissement",
          textAlign: TextAlign.center,
          style: h1.copyWith(fontSize: 24),
        ),
        const SizedBox(height: 10),

        Text(
          "COP’IQ est une application privée de préparation scolaire.\n"
          "Elle n’est ni affiliée ni autorisée par le Gouvernement.\n"
          "Les contenus sont pédagogiques et ne remplacent pas les instructions officielles.",
          textAlign: TextAlign.center,
          style: p.copyWith(fontSize: 14.2),
        ),

        const SizedBox(height: 18),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.12)),
          ),
          child: Row(
            children: [
              Icon(
                Icons.lock_outline_rounded,
                color: Colors.white.withOpacity(0.88),
                size: 18,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  "En continuant, tu confirmes avoir lu cet avertissement.",
                  style: GoogleFonts.montserrat(
                    color: Colors.white.withOpacity(0.88),
                    fontWeight: FontWeight.w700,
                    fontSize: 13.0,
                    height: 1.25,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: onAccept,
            style: ElevatedButton.styleFrom(
              backgroundColor: _success,
              foregroundColor: const Color(0xFF0B2A1E),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              "J’ai compris",
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w900,
                fontSize: 15.5,
                letterSpacing: -0.1,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),

        SizedBox(
          width: double.infinity,
          height: 56,
          child: OutlinedButton(
            onPressed: onOpenPrivacy,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: BorderSide(color: Colors.white.withOpacity(0.25), width: 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              "Politique de confidentialité",
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w900,
                fontSize: 14.4,
                letterSpacing: -0.1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// ===== écran de redirection =====
class _RedirectingView extends StatelessWidget {
  const _RedirectingView({required this.isDark, required this.pulse});
  final bool isDark;
  final Animation<double>? pulse;

  static const Color _success = Color(0xFF1FE08A);

  @override
  Widget build(BuildContext context) {
    Widget icon = const Icon(Icons.check_circle, color: _success, size: 84);

    if (pulse != null) {
      icon = AnimatedBuilder(
        animation: pulse!,
        builder: (_, __) {
          final t = pulse!.value;
          final glow = 0.18 + 0.22 * t;
          final scale = 1.0 + 0.02 * t;

          return Transform.scale(
            scale: scale,
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: _success.withOpacity(glow),
                    blurRadius: 28,
                    spreadRadius: 1.0,
                  ),
                ],
              ),
              child: const Icon(Icons.check_circle, color: _success, size: 84),
            ),
          );
        },
      );
    } else {
      icon = DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: _success.withOpacity(0.22),
              blurRadius: 24,
              spreadRadius: 1,
            ),
          ],
        ),
        child: const Icon(Icons.check_circle, color: _success, size: 84),
      );
    }

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          const SizedBox(height: 16),
          Text(
            "Validation réussie !",
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Redirection vers COP’IQ…",
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              color: Colors.white.withOpacity(0.78),
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 18),
          const SizedBox(
            width: 36,
            height: 36,
            child: CircularProgressIndicator(strokeWidth: 3),
          ),
        ],
      ),
    );
  }
}

/// ===== fond blobs animé =====
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
