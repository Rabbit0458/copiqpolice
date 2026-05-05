// lib/features/auth/reset_password.dart
// =============================================================================
//  COP'IQ — RESET PASSWORD (Cinematic Edition)
// =============================================================================
//  ⚠️  La logique métier (Supabase RPC, AppNotifier, lifecycle, timer, success
//      overlay, resume sheet) est strictement préservée.
//      Seule la couche visuelle a été ré-écrite avec :
//        • Entrée chorégraphiée (staggered reveal + spring elastic)
//        • Mesh gradient animé + orbes flottantes + grille respirante
//        • Glassmorphism premium (BackdropFilter + bordures lumineuses)
//        • Theming light/dark synchronisé via AppSettingsController
//          (transition douce des couleurs, pas de flash)
//        • Champ email avec focus halo et shake sur erreur
//        • CTA premium (gradient + shine continu + press magnétique)
// =============================================================================

import 'dart:ui';
import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:copiqpolice/core/widgets/app_notifier.dart'
    show AppSettingsController, AppNotifier;

// =============================================================================
//  PALETTE — Dual theme tokens (synced with AppSettingsController)
// =============================================================================
class _ResetPalette {
  final Color bg;
  final Color bgDeep;
  final Color accent;
  final Color accent2;
  final Color glow;
  final Color glassFill;
  final Color glassBorder;
  final Color fieldFill;
  final Color fieldBorder;
  final Color ctaForeground;
  final Color text;
  final Color textSoft;

  const _ResetPalette({
    required this.bg,
    required this.bgDeep,
    required this.accent,
    required this.accent2,
    required this.glow,
    required this.glassFill,
    required this.glassBorder,
    required this.fieldFill,
    required this.fieldBorder,
    required this.ctaForeground,
    required this.text,
    required this.textSoft,
  });

  static const _ResetPalette dark = _ResetPalette(
    bg: Color(0xFF030713),
    bgDeep: Color(0xFF000204),
    accent: Color(0xFF6EA8FF),
    accent2: Color(0xFF7C5BFF),
    glow: Color(0xFF6EE7B7),
    glassFill: Color(0x14FFFFFF),
    glassBorder: Color(0x22FFFFFF),
    fieldFill: Color(0xFF0F1F4A),
    fieldBorder: Color(0xFF2F3C69),
    ctaForeground: Color(0xFF030713),
    text: Color(0xFFFFFFFF),
    textSoft: Color(0xE6FFFFFF),
  );

  static const _ResetPalette light = _ResetPalette(
    bg: Color(0xFF0D47E8),
    bgDeep: Color(0xFF052CA8),
    accent: Color(0xFF8FB6FF),
    accent2: Color(0xFFB6A6FF),
    glow: Color(0xFF6EE7B7),
    glassFill: Color(0x1FFFFFFF),
    glassBorder: Color(0x2EFFFFFF),
    fieldFill: Color(0xFF1A3FBA),
    fieldBorder: Color(0xFF355BE0),
    ctaForeground: Color(0xFF0D47E8),
    text: Color(0xFFFFFFFF),
    textSoft: Color(0xE6FFFFFF),
  );

  static _ResetPalette lerp(_ResetPalette a, _ResetPalette b, double t) {
    return _ResetPalette(
      bg: Color.lerp(a.bg, b.bg, t)!,
      bgDeep: Color.lerp(a.bgDeep, b.bgDeep, t)!,
      accent: Color.lerp(a.accent, b.accent, t)!,
      accent2: Color.lerp(a.accent2, b.accent2, t)!,
      glow: Color.lerp(a.glow, b.glow, t)!,
      glassFill: Color.lerp(a.glassFill, b.glassFill, t)!,
      glassBorder: Color.lerp(a.glassBorder, b.glassBorder, t)!,
      fieldFill: Color.lerp(a.fieldFill, b.fieldFill, t)!,
      fieldBorder: Color.lerp(a.fieldBorder, b.fieldBorder, t)!,
      ctaForeground: Color.lerp(a.ctaForeground, b.ctaForeground, t)!,
      text: Color.lerp(a.text, b.text, t)!,
      textSoft: Color.lerp(a.textSoft, b.textSoft, t)!,
    );
  }
}

// =============================================================================
//  PAGE
// =============================================================================
class ResetPasswordPage extends StatefulWidget {
  static const routeName = '/reset-password';

  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  // ===== LOGIQUE — INTACTE =====
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();

  bool _loading = false;
  bool _sent = false;

  Timer? _resendTimer;
  int _resendSecondsLeft = 0;
  static const int _resendTotalSeconds = 300;

  bool _showSuccess = false;
  DateTime? _backgroundedAt;
  bool _resumePromptShown = false;

  bool get _canResend => _resendSecondsLeft == 0;

  String get _resendCountdown {
    final min = (_resendSecondsLeft ~/ 60).toString().padLeft(2, '0');
    final sec = (_resendSecondsLeft % 60).toString().padLeft(2, '0');
    return "$min:$sec";
  }

  // ===== ANIMATION D'ARRIVÉE =====
  late final AnimationController _entryCtrl;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _entryCtrl.forward();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _resendTimer?.cancel();
    _emailCtrl.dispose();
    _entryCtrl.dispose();
    super.dispose();
  }

  // ===== Détection retour de l'app après modif sur le web =====
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!mounted || !_sent || _showSuccess) return;

    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.hidden) {
      _backgroundedAt ??= DateTime.now();
    }

    if (state == AppLifecycleState.resumed && _backgroundedAt != null) {
      final wasAway = DateTime.now().difference(_backgroundedAt!);
      _backgroundedAt = null;

      if (wasAway > const Duration(seconds: 8) && !_resumePromptShown) {
        _resumePromptShown = true;
        Future.delayed(const Duration(milliseconds: 380), () {
          if (mounted) _showResumeSheet();
        });
      }
    }
  }

  Future<void> _showResumeSheet() async {
    if (!mounted) return;
    HapticFeedback.lightImpact();
    final result = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _ResumePromptSheet(email: _emailCtrl.text.trim()),
    );
    if (result == true && mounted) _triggerSuccessAndLogin();
  }

  void _triggerSuccessAndLogin() {
    if (!mounted || _showSuccess) return;
    HapticFeedback.mediumImpact();
    setState(() => _showSuccess = true);
  }

  void _onSuccessComplete() {
    if (!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }

  String? _validateEmail(String? v) {
    final s = v?.trim() ?? '';
    if (s.isEmpty) return "Renseigne ton email.";
    final ok = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(s);
    if (!ok) return "Email invalide.";
    return null;
  }

  bool _reduceMotion(BuildContext context) {
    final mq = MediaQuery.maybeOf(context);
    final disableByOS = WidgetsBinding
        .instance
        .platformDispatcher
        .accessibilityFeatures
        .disableAnimations;
    return (mq?.disableAnimations ?? false) || disableByOS;
  }

  void _startResendCooldown() {
    _resendTimer?.cancel();
    setState(() => _resendSecondsLeft = _resendTotalSeconds);
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_resendSecondsLeft <= 1) {
        timer.cancel();
        setState(() => _resendSecondsLeft = 0);
      } else {
        setState(() => _resendSecondsLeft--);
      }
    });
  }

  Future<bool> _emailExistsInSupabase(String email) async {
    final normalizedEmail = email.trim().toLowerCase();
    try {
      final result = await Supabase.instance.client.rpc<bool>(
        'auth_email_exists',
        params: {'p_email': normalizedEmail},
      );
      return result == true;
    } catch (e) {
      debugPrint('auth_email_exists RPC error => $e');
      rethrow;
    }
  }

  Future<void> _sendResetEmail() async {
    if (!_canResend && _sent) return;
    if (!_formKey.currentState!.validate()) return;

    final email = _emailCtrl.text.trim().toLowerCase();

    FocusScope.of(context).unfocus();
    HapticFeedback.selectionClick();
    setState(() => _loading = true);

    try {
      final exists = await _emailExistsInSupabase(email);

      if (!exists) {
        if (!mounted) return;
        AppNotifier.error(
          context,
          title: "Compte introuvable",
          message: "Aucun compte COP’IQ n’est associé à cette adresse e-mail.",
        );
        return;
      }

      debugPrint('RESET REDIRECT TO => https://copiq.fr/reset-password/');
      await Supabase.instance.client.auth.resetPasswordForEmail(
        email,
        redirectTo: 'https://copiq.fr/reset-password/',
      );

      if (!mounted) return;
      setState(() {
        _sent = true;
        _resumePromptShown = false;
      });
      _startResendCooldown();

      AppNotifier.success(
        context,
        title: "Email envoyé",
        message: "Vérifie ta boîte mail pour réinitialiser ton mot de passe.",
      );
    } on AuthException catch (e) {
      if (!mounted) return;
      AppNotifier.error(context, title: "Erreur", message: e.message);
    } catch (_) {
      if (!mounted) return;
      AppNotifier.error(
        context,
        title: "Vérification impossible",
        message:
            "Impossible de vérifier l’adresse e-mail pour le moment. Réessaie dans quelques secondes.",
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _goBackToLogin() {
    HapticFeedback.selectionClick();
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }

  // ===== Helper : interval staggered =====
  double _stage(double start, double end, [Curve curve = Curves.easeOutCubic]) {
    final t = ((_entryCtrl.value - start) / (end - start)).clamp(0.0, 1.0);
    return curve.transform(t);
  }

  // =====================================================================
  //  BUILD
  // =====================================================================
  @override
  Widget build(BuildContext context) {
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

        final reduceMotion = _reduceMotion(context);

        // Transition douce de palette quand le user toggle le thème.
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: isDark ? 1.0 : 0.0, end: isDark ? 1.0 : 0.0),
          duration: const Duration(milliseconds: 520),
          curve: Curves.easeInOut,
          builder: (context, t, _) {
            final palette = _ResetPalette.lerp(
              _ResetPalette.light,
              _ResetPalette.dark,
              t,
            );
            return _buildScaffold(
              context: context,
              palette: palette,
              isDark: isDark,
              reduceMotion: reduceMotion,
            );
          },
        );
      },
    );
  }

  Widget _buildScaffold({
    required BuildContext context,
    required _ResetPalette palette,
    required bool isDark,
    required bool reduceMotion,
  }) {
    return Scaffold(
      backgroundColor: palette.bg,
      resizeToAvoidBottomInset: true,
      body: AnimatedBuilder(
        animation: _entryCtrl,
        builder: (context, _) {
          return Stack(
            children: [
              // ----- Mesh gradient + orbes flottantes -----
              Positioned.fill(
                child: _MeshGradientBackground(
                  palette: palette,
                  enabled: !reduceMotion,
                ),
              ),
              // ----- Grille luxe respirante -----
              Positioned.fill(
                child: IgnorePointer(
                  child: _BreathingGridOverlay(
                    palette: palette,
                    enabled: !reduceMotion,
                  ),
                ),
              ),
              // ----- Particules flottantes -----
              Positioned.fill(
                child: IgnorePointer(
                  child: _FloatingParticles(
                    palette: palette,
                    enabled: !reduceMotion,
                  ),
                ),
              ),
              // ----- Vignette top/bottom -----
              const Positioned.fill(child: IgnorePointer(child: _Vignette())),

              // ----- Contenu -----
              SafeArea(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final mq = MediaQuery.of(context);
                    final keyboard = mq.viewInsets.bottom;
                    final availableH = constraints.maxHeight;
                    final compact = availableH < 700;
                    final logoH = (availableH * (compact ? 0.19 : 0.23)).clamp(
                      135.0,
                      230.0,
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
                            (compact ? 18 : 26) + keyboard * 0.25,
                          ),
                          child: Column(
                            children: [
                              // ----- Hero Logo -----
                              _Stagger(
                                opacity: _stage(0.05, 0.45),
                                offsetY: (1 - _stage(0.05, 0.45)) * 28,
                                scale:
                                    0.92 +
                                    0.08 *
                                        _stage(0.05, 0.55, Curves.elasticOut),
                                child: SizedBox(
                                  height: logoH,
                                  width: 260,
                                  child: _HeroLogoBadge(
                                    palette: palette,
                                    enabled: !reduceMotion,
                                  ),
                                ),
                              ),
                              SizedBox(height: compact ? 8 : 14),

                              // ----- Title -----
                              _Stagger(
                                opacity: _stage(0.18, 0.55),
                                offsetY: (1 - _stage(0.18, 0.55)) * 22,
                                child: _TitleBlock(
                                  palette: palette,
                                  compact: compact,
                                  sent: _sent,
                                ),
                              ),
                              const SizedBox(height: 12),

                              // ----- Subtitle -----
                              _Stagger(
                                opacity: _stage(0.28, 0.65),
                                offsetY: (1 - _stage(0.28, 0.65)) * 18,
                                child: Text(
                                  _sent
                                      ? "Un lien sécurisé a été envoyé à\n${_emailCtrl.text.trim()}\nOuvre-le pour choisir un nouveau mot de passe."
                                      : "Entre l’adresse e-mail liée à ton compte COP’IQ.\nNous t’enverrons un lien sécurisé.",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.montserrat(
                                    fontSize: 14.5,
                                    height: 1.5,
                                    color: palette.textSoft,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              SizedBox(height: compact ? 18 : 26),

                              // ----- Glass card (form OR sent state) -----
                              _Stagger(
                                opacity: _stage(0.40, 0.85),
                                offsetY: (1 - _stage(0.40, 0.85)) * 32,
                                scale:
                                    0.96 +
                                    0.04 *
                                        _stage(0.40, 0.95, Curves.easeOutBack),
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 360),
                                  switchInCurve: Curves.easeOutCubic,
                                  switchOutCurve: Curves.easeInCubic,
                                  transitionBuilder: (child, anim) {
                                    return FadeTransition(
                                      opacity: anim,
                                      child: ScaleTransition(
                                        scale: Tween<double>(
                                          begin: 0.96,
                                          end: 1.0,
                                        ).animate(anim),
                                        child: child,
                                      ),
                                    );
                                  },
                                  child: _GlassCardPremium(
                                    key: ValueKey(_sent),
                                    palette: palette,
                                    child: _sent
                                        ? _SentContent(
                                            palette: palette,
                                            loading: _loading,
                                            canResend: _canResend,
                                            countdown: _resendCountdown,
                                            onResend: _sendResetEmail,
                                            onLogin: _triggerSuccessAndLogin,
                                            enabledShine: !reduceMotion,
                                          )
                                        : Form(
                                            key: _formKey,
                                            child: Column(
                                              children: [
                                                _PremiumFormTextField(
                                                  label: "Email",
                                                  controller: _emailCtrl,
                                                  hint: "email@exemple.com",
                                                  keyboardType: TextInputType
                                                      .emailAddress,
                                                  textInputAction:
                                                      TextInputAction.done,
                                                  validator: _validateEmail,
                                                  palette: palette,
                                                  onSubmitted: (_) => _loading
                                                      ? null
                                                      : _sendResetEmail(),
                                                ),
                                                const SizedBox(height: 16),
                                                _PrimaryButton(
                                                  label:
                                                      "Recevoir le lien sécurisé",
                                                  loading: _loading,
                                                  palette: palette,
                                                  enabledShine: !reduceMotion,
                                                  leadingIcon:
                                                      Icons.send_rounded,
                                                  onPressed: _loading
                                                      ? null
                                                      : _sendResetEmail,
                                                ),
                                              ],
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 14),

                              // ----- Back to login -----
                              _Stagger(
                                opacity: _stage(0.65, 1.0),
                                offsetY: (1 - _stage(0.65, 1.0)) * 12,
                                child: _BackToLoginButton(
                                  palette: palette,
                                  onPressed: _goBackToLogin,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // ===== Overlay succès plein écran (logique inchangée) =====
              if (_showSuccess)
                _PasswordChangedSuccessOverlay(
                  onComplete: _onSuccessComplete,
                  enabled: !reduceMotion,
                ),
            ],
          );
        },
      ),
    );
  }
}

// =============================================================================
//  STAGGER HELPER
// =============================================================================
class _Stagger extends StatelessWidget {
  final double opacity;
  final double offsetY;
  final double scale;
  final Widget child;

  const _Stagger({
    required this.opacity,
    required this.offsetY,
    required this.child,
    this.scale = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity.clamp(0.0, 1.0),
      child: Transform.translate(
        offset: Offset(0, offsetY),
        child: Transform.scale(scale: scale, child: child),
      ),
    );
  }
}

// =============================================================================
//  TITLE BLOCK — gradient text + animated underline
// =============================================================================
class _TitleBlock extends StatelessWidget {
  final _ResetPalette palette;
  final bool compact;
  final bool sent;
  const _TitleBlock({
    required this.palette,
    required this.compact,
    required this.sent,
  });

  @override
  Widget build(BuildContext context) {
    final text = sent
        ? "Consulte ta\nboîte mail"
        : "Réinitialise ton\nmot de passe";
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (rect) => LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              palette.text,
              palette.text.withOpacity(0.85),
              palette.glow.withOpacity(0.85),
            ],
            stops: const [0.0, 0.6, 1.0],
          ).createShader(rect),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              fontSize: compact ? 26 : 32,
              height: 1.06,
              color: Colors.white,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.8,
            ),
          ),
        ),
        const SizedBox(height: 8),
        // Animated underline
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 900),
          curve: Curves.easeOutCubic,
          builder: (context, t, _) {
            return SizedBox(
              width: 96 * t,
              height: 3,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(99),
                  gradient: LinearGradient(
                    colors: [
                      palette.glow.withOpacity(0.0),
                      palette.glow,
                      palette.glow.withOpacity(0.0),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: palette.glow.withOpacity(0.55),
                      blurRadius: 10,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

// =============================================================================
//  HERO LOGO — Sweep gradient ring + orbital glow + lock badge
// =============================================================================
class _HeroLogoBadge extends StatefulWidget {
  final _ResetPalette palette;
  final bool enabled;
  const _HeroLogoBadge({required this.palette, required this.enabled});

  @override
  State<_HeroLogoBadge> createState() => _HeroLogoBadgeState();
}

class _HeroLogoBadgeState extends State<_HeroLogoBadge>
    with TickerProviderStateMixin {
  late final AnimationController _orbit = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 7000),
  );
  late final AnimationController _breathe = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 3200),
  );

  @override
  void initState() {
    super.initState();
    if (widget.enabled) {
      _orbit.repeat();
      _breathe.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant _HeroLogoBadge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.enabled != widget.enabled) {
      if (widget.enabled) {
        _orbit.repeat();
        _breathe.repeat(reverse: true);
      } else {
        _orbit.stop();
        _breathe.stop();
      }
    }
  }

  @override
  void dispose() {
    _orbit.dispose();
    _breathe.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_orbit, _breathe]),
      builder: (_, __) {
        final t = widget.enabled ? _orbit.value : 0.0;
        final b = widget.enabled
            ? Curves.easeInOut.transform(_breathe.value)
            : 0.5;

        return Stack(
          alignment: Alignment.center,
          children: [
            // Outer halo
            Transform.scale(
              scale: 1.0 + 0.04 * b,
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      widget.palette.glow.withOpacity(0.18),
                      widget.palette.glow.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),
            // Sweep ring
            Transform.rotate(
              angle: t * math.pi * 2,
              child: Container(
                width: 196,
                height: 196,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: SweepGradient(
                    colors: [
                      Colors.white.withOpacity(0.0),
                      Colors.white.withOpacity(0.22),
                      widget.palette.glow.withOpacity(0.55),
                      Colors.white.withOpacity(0.0),
                    ],
                    stops: const [0.0, 0.42, 0.62, 1.0],
                  ),
                ),
              ),
            ),
            // Inner glass disc
            Container(
              width: 174,
              height: 174,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  center: const Alignment(-0.3, -0.4),
                  colors: [
                    Colors.white.withOpacity(0.18),
                    Colors.white.withOpacity(0.06),
                    Colors.white.withOpacity(0.0),
                  ],
                ),
                border: Border.all(
                  color: Colors.white.withOpacity(0.14),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.30),
                    blurRadius: 44,
                    offset: const Offset(0, 24),
                  ),
                  BoxShadow(
                    color: widget.palette.accent.withOpacity(0.18),
                    blurRadius: 60,
                    spreadRadius: 6,
                  ),
                ],
              ),
            ),
            // Floating logo
            Transform.translate(
              offset: Offset(
                0,
                widget.enabled ? math.sin(t * math.pi * 2) * 5 : 0,
              ),
              child: Image.asset(
                'assets/images/onboarding.png',
                fit: BoxFit.contain,
                width: 150,
                height: 150,
                filterQuality: FilterQuality.high,
              ),
            ),
            // Orbiting glow particle
            Transform.translate(
              offset: Offset(
                math.cos(t * math.pi * 2) * 92,
                math.sin(t * math.pi * 2) * 92,
              ),
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.palette.glow,
                  boxShadow: [
                    BoxShadow(
                      color: widget.palette.glow.withOpacity(0.7),
                      blurRadius: 14,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
            ),
            // Lock badge
            Positioned(
              bottom: 14,
              right: 26,
              child: Transform.scale(
                scale: 1.0 + 0.06 * b,
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFFFFFFF), Color(0xFFE6F0FF)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: widget.palette.glow.withOpacity(0.55),
                        blurRadius: 24,
                        spreadRadius: -2,
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(0.22),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.lock_reset_rounded,
                    color: widget.palette.ctaForeground,
                    size: 22,
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

// =============================================================================
//  MESH GRADIENT BACKGROUND — multi-orb drift with parallax
// =============================================================================
class _MeshGradientBackground extends StatefulWidget {
  final _ResetPalette palette;
  final bool enabled;
  const _MeshGradientBackground({required this.palette, required this.enabled});

  @override
  State<_MeshGradientBackground> createState() =>
      _MeshGradientBackgroundState();
}

class _MeshGradientBackgroundState extends State<_MeshGradientBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 16),
  );

  @override
  void initState() {
    super.initState();
    if (widget.enabled) _c.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(covariant _MeshGradientBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.enabled != widget.enabled) {
      widget.enabled ? _c.repeat(reverse: true) : _c.stop();
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [widget.palette.bg, widget.palette.bgDeep],
        ),
      ),
      child: AnimatedBuilder(
        animation: _c,
        builder: (context, _) {
          final t = widget.enabled ? _c.value : 0.5;

          final dx1 = lerpDouble(-0.35, 0.20, t)!;
          final dy1 = lerpDouble(-0.45, 0.05, t)!;
          final dx2 = lerpDouble(0.45, -0.20, t)!;
          final dy2 = lerpDouble(0.55, -0.10, t)!;
          final dx3 = lerpDouble(-0.10, 0.45, 1 - t)!;
          final dy3 = lerpDouble(0.40, -0.30, 1 - t)!;

          return Stack(
            children: [
              _orb(
                align: Alignment(dx1, dy1),
                color: widget.palette.accent.withOpacity(0.40),
                size: 380,
                blur: 120,
              ),
              _orb(
                align: Alignment(dx2, dy2),
                color: widget.palette.accent2.withOpacity(0.35),
                size: 420,
                blur: 130,
              ),
              _orb(
                align: Alignment(dx3, dy3),
                color: widget.palette.glow.withOpacity(0.18),
                size: 340,
                blur: 100,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _orb({
    required Alignment align,
    required Color color,
    required double size,
    required double blur,
  }) {
    return Align(
      alignment: align,
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
      ),
    );
  }
}

// =============================================================================
//  BREATHING GRID OVERLAY
// =============================================================================
class _BreathingGridOverlay extends StatefulWidget {
  final _ResetPalette palette;
  final bool enabled;
  const _BreathingGridOverlay({required this.palette, required this.enabled});

  @override
  State<_BreathingGridOverlay> createState() => _BreathingGridOverlayState();
}

class _BreathingGridOverlayState extends State<_BreathingGridOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 22),
  );

  @override
  void initState() {
    super.initState();
    if (widget.enabled) _c.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(covariant _BreathingGridOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.enabled != widget.enabled) {
      widget.enabled ? _c.repeat(reverse: true) : _c.stop();
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
      builder: (_, __) {
        return CustomPaint(
          painter: _GridPainter(
            progress: widget.enabled ? _c.value : 0.0,
            color: Colors.white.withOpacity(0.06),
            accent: widget.palette.glow.withOpacity(0.10),
          ),
          child: const SizedBox.expand(),
        );
      },
    );
  }
}

class _GridPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color accent;
  _GridPainter({
    required this.progress,
    required this.color,
    required this.accent,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 0.6;
    const gap = 46.0;
    final drift = progress * gap;

    for (double x = -gap + drift; x < size.width + gap; x += gap) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = -gap + drift * 0.5; y < size.height + gap; y += gap) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Accent intersection dots
    final dotPaint = Paint()..color = accent;
    for (double x = -gap + drift; x < size.width + gap; x += gap * 3) {
      for (double y = -gap + drift * 0.5; y < size.height + gap; y += gap * 3) {
        canvas.drawCircle(Offset(x, y), 1.4, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _GridPainter old) =>
      old.progress != progress || old.color != color || old.accent != accent;
}

// =============================================================================
//  FLOATING PARTICLES
// =============================================================================
class _FloatingParticles extends StatefulWidget {
  final _ResetPalette palette;
  final bool enabled;
  const _FloatingParticles({required this.palette, required this.enabled});

  @override
  State<_FloatingParticles> createState() => _FloatingParticlesState();
}

class _FloatingParticlesState extends State<_FloatingParticles>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 12),
  );

  final List<_Particle> _particles = List.generate(
    18,
    (i) => _Particle(
      seedX: math.Random(i * 7).nextDouble(),
      seedY: math.Random(i * 13).nextDouble(),
      speed: 0.4 + math.Random(i * 19).nextDouble() * 0.8,
      size: 1.0 + math.Random(i * 23).nextDouble() * 2.4,
    ),
  );

  @override
  void initState() {
    super.initState();
    if (widget.enabled) _c.repeat();
  }

  @override
  void didUpdateWidget(covariant _FloatingParticles oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.enabled != widget.enabled) {
      widget.enabled ? _c.repeat() : _c.stop();
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
      builder: (_, __) {
        return CustomPaint(
          painter: _ParticlesPainter(
            progress: _c.value,
            particles: _particles,
            color: widget.palette.glow,
          ),
          child: const SizedBox.expand(),
        );
      },
    );
  }
}

class _Particle {
  final double seedX;
  final double seedY;
  final double speed;
  final double size;
  _Particle({
    required this.seedX,
    required this.seedY,
    required this.speed,
    required this.size,
  });
}

class _ParticlesPainter extends CustomPainter {
  final double progress;
  final List<_Particle> particles;
  final Color color;
  _ParticlesPainter({
    required this.progress,
    required this.particles,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final t = (progress * p.speed + p.seedY) % 1.0;
      final y = (1 - t) * (size.height + 60) - 30;
      final wobble = math.sin((progress * math.pi * 2) + p.seedX * 6) * 18;
      final x = p.seedX * size.width + wobble;

      final fade = (math.sin(t * math.pi)).clamp(0.0, 1.0);
      final paint = Paint()
        ..color = color.withOpacity(0.40 * fade)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.2);
      canvas.drawCircle(Offset(x, y), p.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlesPainter old) =>
      old.progress != progress;
}

// =============================================================================
//  VIGNETTE
// =============================================================================
class _Vignette extends StatelessWidget {
  const _Vignette();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.20),
            Colors.transparent,
            Colors.black.withOpacity(0.30),
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
    );
  }
}

// =============================================================================
//  GLASS CARD PREMIUM — real backdrop blur + light reflection
// =============================================================================
class _GlassCardPremium extends StatelessWidget {
  final Widget child;
  final _ResetPalette palette;
  const _GlassCardPremium({
    super.key,
    required this.child,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: palette.glassFill,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: palette.glassBorder, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.30),
                blurRadius: 36,
                offset: const Offset(0, 22),
              ),
              BoxShadow(
                color: palette.accent.withOpacity(0.08),
                blurRadius: 30,
                spreadRadius: -4,
              ),
            ],
          ),
          child: Stack(
            children: [
              // Top reflective highlight
              Positioned.fill(
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withOpacity(0.16),
                          Colors.white.withOpacity(0.0),
                          Colors.black.withOpacity(0.04),
                        ],
                        stops: const [0.0, 0.45, 1.0],
                      ),
                    ),
                  ),
                ),
              ),
              // Top sheen line
              Positioned(
                left: 14,
                right: 14,
                top: 0,
                child: Container(
                  height: 1,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.0),
                        Colors.white.withOpacity(0.50),
                        Colors.white.withOpacity(0.0),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 22, 18, 18),
                child: child,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
//  PREMIUM FORM TEXT FIELD — focus halo + shake-on-error
// =============================================================================
class _PremiumFormTextField extends StatefulWidget {
  const _PremiumFormTextField({
    required this.label,
    required this.controller,
    required this.hint,
    required this.validator,
    required this.palette,
    this.keyboardType,
    this.textInputAction,
    this.onSubmitted,
  });

  final String label;
  final TextEditingController controller;
  final String hint;
  final String? Function(String?) validator;
  final _ResetPalette palette;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;

  @override
  State<_PremiumFormTextField> createState() => _PremiumFormTextFieldState();
}

class _PremiumFormTextFieldState extends State<_PremiumFormTextField>
    with SingleTickerProviderStateMixin {
  String? _error;
  bool _touched = false;
  late final FocusNode _focus = FocusNode();
  bool _hasFocus = false;

  late final AnimationController _shakeCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 320),
  );

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onChange);
    _focus.addListener(() {
      if (!mounted) return;
      setState(() => _hasFocus = _focus.hasFocus);
      if (_focus.hasFocus) _markTouched();
    });
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onChange);
    _focus.dispose();
    _shakeCtrl.dispose();
    super.dispose();
  }

  void _onChange() {
    if (!_touched) return;
    final msg = widget.validator(widget.controller.text);
    if (msg != _error && mounted) {
      setState(() => _error = msg);
      if (msg != null) _shakeCtrl.forward(from: 0);
    }
  }

  void _markTouched() {
    if (_touched) return;
    setState(() {
      _touched = true;
      _error = widget.validator(widget.controller.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.palette;
    const softError = Color(0xFFFFB4B4);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.alternate_email_rounded, size: 14, color: p.text),
            const SizedBox(width: 6),
            Text(
              widget.label,
              style: GoogleFonts.montserrat(
                color: p.text,
                fontSize: 13,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        AnimatedBuilder(
          animation: _shakeCtrl,
          builder: (context, _) {
            final shake =
                math.sin(_shakeCtrl.value * math.pi * 6) *
                (1 - _shakeCtrl.value) *
                6;
            return Transform.translate(
              offset: Offset(shake, 0),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: _hasFocus
                      ? [
                          BoxShadow(
                            color: p.glow.withOpacity(0.30),
                            blurRadius: 24,
                            spreadRadius: 1,
                          ),
                          BoxShadow(
                            color: p.accent.withOpacity(0.16),
                            blurRadius: 18,
                            offset: const Offset(0, 6),
                          ),
                        ]
                      : const [],
                ),
                child: TextFormField(
                  focusNode: _focus,
                  controller: widget.controller,
                  keyboardType: widget.keyboardType,
                  textInputAction: widget.textInputAction,
                  onTap: _markTouched,
                  onChanged: (_) => _markTouched(),
                  onFieldSubmitted: widget.onSubmitted,
                  cursorColor: Colors.white,
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    hintText: widget.hint,
                    hintStyle: GoogleFonts.montserrat(
                      color: Colors.white.withOpacity(0.55),
                      fontWeight: FontWeight.w500,
                    ),
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: _hasFocus
                          ? p.glow
                          : Colors.white.withOpacity(0.55),
                      size: 19,
                    ),
                    suffixIcon: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 220),
                      transitionBuilder: (c, a) =>
                          ScaleTransition(scale: a, child: c),
                      child:
                          (_touched &&
                              _error == null &&
                              widget.controller.text.isNotEmpty)
                          ? Icon(
                              key: const ValueKey('ok'),
                              Icons.check_circle_rounded,
                              color: p.glow,
                              size: 19,
                            )
                          : (_touched && _error != null)
                          ? const Icon(
                              key: ValueKey('err'),
                              Icons.error_outline_rounded,
                              color: softError,
                              size: 19,
                            )
                          : const SizedBox(
                              key: ValueKey('empty'),
                              width: 0,
                              height: 0,
                            ),
                    ),
                    filled: true,
                    fillColor: p.fieldFill,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: p.fieldBorder.withOpacity(0.70),
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white.withOpacity(0.95),
                        width: 1.4,
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: softError.withOpacity(0.85),
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: softError.withOpacity(0.95),
                        width: 1.3,
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  validator: widget.validator,
                  autovalidateMode: AutovalidateMode.disabled,
                ),
              ),
            );
          },
        ),

        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: (_touched && _error != null) ? 1 : 0,
            child: (_touched && _error != null)
                ? Padding(
                    padding: const EdgeInsets.only(top: 10, left: 4),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.info_outline_rounded,
                          size: 14,
                          color: softError,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            _error!,
                            style: GoogleFonts.montserrat(
                              color: softError,
                              fontSize: 12.5,
                              height: 1.2,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox(height: 0),
          ),
        ),
      ],
    );
  }
}

// =============================================================================
//  PRIMARY BUTTON — gradient + shine + magnetic press
// =============================================================================
class _PrimaryButton extends StatefulWidget {
  const _PrimaryButton({
    required this.label,
    required this.loading,
    required this.palette,
    required this.onPressed,
    required this.enabledShine,
    this.leadingIcon,
  });

  final String label;
  final bool loading;
  final _ResetPalette palette;
  final VoidCallback? onPressed;
  final bool enabledShine;
  final IconData? leadingIcon;

  @override
  State<_PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<_PrimaryButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shine = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  );
  bool _down = false;

  @override
  void initState() {
    super.initState();
    if (widget.enabledShine && !widget.loading) _shine.repeat();
  }

  @override
  void didUpdateWidget(covariant _PrimaryButton old) {
    super.didUpdateWidget(old);
    if (widget.enabledShine && !widget.loading) {
      if (!_shine.isAnimating) _shine.repeat();
    } else {
      _shine.stop();
    }
  }

  @override
  void dispose() {
    _shine.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.onPressed == null;
    final fg = widget.palette.ctaForeground;

    return Listener(
      onPointerDown: (_) => setState(() => _down = true),
      onPointerUp: (_) => setState(() => _down = false),
      onPointerCancel: (_) => setState(() => _down = false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 130),
        curve: Curves.easeOut,
        scale: _down ? 0.975 : 1.0,
        child: SizedBox(
          height: 58,
          width: double.infinity,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Stack(
              children: [
                // Background gradient (subtle iridescent)
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: isDisabled
                            ? [const Color(0xFFE2E8F0), const Color(0xFFC8D3E8)]
                            : const [Color(0xFFFFFFFF), Color(0xFFEAF1FF)],
                      ),
                    ),
                  ),
                ),
                // Inner top highlight
                Positioned.fill(
                  child: IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white.withOpacity(0.85),
                            Colors.white.withOpacity(0.0),
                          ],
                          stops: const [0.0, 0.55],
                        ),
                      ),
                    ),
                  ),
                ),
                // Shine sweep
                if (widget.enabledShine && !widget.loading && !isDisabled)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: AnimatedBuilder(
                        animation: _shine,
                        builder: (context, _) {
                          final t = _shine.value;
                          final dx = lerpDouble(-1.4, 1.4, t)!;
                          return Transform.translate(
                            offset: Offset(dx * 280, 0),
                            child: Transform.rotate(
                              angle: -0.4,
                              child: Container(
                                width: 240,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.white.withOpacity(0.0),
                                      Colors.white.withOpacity(0.55),
                                      Colors.white.withOpacity(0.0),
                                      Colors.transparent,
                                    ],
                                    stops: const [0.0, 0.42, 0.50, 0.58, 1.0],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                // Button content
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: widget.onPressed,
                    splashColor: widget.palette.glow.withOpacity(0.18),
                    highlightColor: widget.palette.glow.withOpacity(0.08),
                    child: Center(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: widget.loading
                            ? SizedBox(
                                key: const ValueKey('loader'),
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.4,
                                  valueColor: AlwaysStoppedAnimation(
                                    fg.withOpacity(0.85),
                                  ),
                                ),
                              )
                            : Row(
                                key: const ValueKey('label'),
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (widget.leadingIcon != null) ...[
                                    Icon(
                                      widget.leadingIcon,
                                      size: 18,
                                      color: isDisabled
                                          ? fg.withOpacity(0.55)
                                          : fg,
                                    ),
                                    const SizedBox(width: 10),
                                  ],
                                  Flexible(
                                    child: Text(
                                      widget.label,
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.montserrat(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 15.5,
                                        letterSpacing: -0.2,
                                        color: isDisabled
                                            ? fg.withOpacity(0.65)
                                            : fg,
                                      ),
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
        ),
      ),
    );
  }
}

// =============================================================================
//  GHOST BUTTON
// =============================================================================
class _GhostButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;

  const _GhostButton({required this.label, required this.onPressed, this.icon});

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null;
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 180),
      opacity: isDisabled ? 0.5 : 1,
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: onPressed,
          icon: Icon(
            icon ?? Icons.arrow_forward_rounded,
            size: 17,
            color: Colors.white,
          ),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            side: BorderSide(color: Colors.white.withOpacity(0.28), width: 1.2),
            backgroundColor: Colors.white.withOpacity(0.06),
          ),
          label: Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: 0.2,
            ),
          ),
        ),
      ),
    );
  }
}

// =============================================================================
//  BACK TO LOGIN
// =============================================================================
class _BackToLoginButton extends StatelessWidget {
  final _ResetPalette palette;
  final VoidCallback onPressed;
  const _BackToLoginButton({required this.palette, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 18),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      ),
      label: Text(
        "Retour à la connexion",
        style: GoogleFonts.montserrat(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: 13.5,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

// =============================================================================
//  SECURITY PILLS
// =============================================================================
class _SecurityPills extends StatelessWidget {
  const _SecurityPills();

  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.shield_moon_rounded, "Chiffré"),
      (Icons.verified_user_rounded, "Lien vérifié"),
      (Icons.lock_clock_rounded, "Expire en 1h"),
    ];
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final i in items)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.07),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: Colors.white.withOpacity(0.14)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(i.$1, size: 13, color: Colors.white.withOpacity(0.85)),
                const SizedBox(width: 6),
                Text(
                  i.$2,
                  style: GoogleFonts.montserrat(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

// =============================================================================
//  SENT CONTENT — premium redesign
// =============================================================================
class _SentContent extends StatelessWidget {
  final _ResetPalette palette;
  final bool loading;
  final bool canResend;
  final String countdown;
  final VoidCallback onResend;
  final VoidCallback onLogin;
  final bool enabledShine;

  const _SentContent({
    required this.palette,
    required this.loading,
    required this.canResend,
    required this.countdown,
    required this.onResend,
    required this.onLogin,
    required this.enabledShine,
  });

  double get _progress {
    final remaining = _parseCountdown(countdown);
    const total = 300;
    final elapsed = total - remaining;
    return (elapsed / total).clamp(0.0, 1.0);
  }

  int _parseCountdown(String s) {
    final parts = s.split(':');
    if (parts.length != 2) return 0;
    final m = int.tryParse(parts[0]) ?? 0;
    final sec = int.tryParse(parts[1]) ?? 0;
    return m * 60 + sec;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 118,
          width: 118,
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (enabledShine)
                _BreathingHalo(
                  color: canResend ? const Color(0xFF34D399) : Colors.white,
                ),
              Container(
                width: 84,
                height: 84,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: canResend
                        ? const [Color(0xFF10B981), Color(0xFF34D399)]
                        : [
                            Colors.white.withOpacity(0.18),
                            Colors.white.withOpacity(0.06),
                          ],
                  ),
                  border: Border.all(
                    color: Colors.white.withOpacity(canResend ? 0.40 : 0.20),
                    width: 1.3,
                  ),
                  boxShadow: canResend
                      ? [
                          BoxShadow(
                            color: const Color(0xFF10B981).withOpacity(0.50),
                            blurRadius: 32,
                            spreadRadius: -6,
                          ),
                        ]
                      : null,
                ),
                child: Icon(
                  canResend
                      ? Icons.task_alt_rounded
                      : Icons.mark_email_read_rounded,
                  color: Colors.white,
                  size: 36,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        Text(
          canResend ? "Délai écoulé" : "Email envoyé",
          textAlign: TextAlign.center,
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontSize: 19,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.4,
          ),
        ),

        const SizedBox(height: 6),

        Text(
          canResend
              ? "Tu peux renvoyer un nouveau lien sécurisé."
              : "Vérifie ta boîte mail pour finaliser la modification.",
          textAlign: TextAlign.center,
          style: GoogleFonts.montserrat(
            fontSize: 13,
            height: 1.45,
            color: Colors.white.withOpacity(0.85),
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(height: 18),

        _PrimaryButton(
          label: "Renvoyer l’e-mail",
          loading: loading,
          palette: palette,
          enabledShine: enabledShine && canResend,
          onPressed: loading || !canResend ? null : onResend,
          leadingIcon: canResend
              ? Icons.refresh_rounded
              : Icons.lock_outline_rounded,
        ),

        const SizedBox(height: 10),

        _GhostButton(
          label: "J’ai déjà changé mon mot de passe",
          icon: Icons.check_circle_outline_rounded,
          onPressed: onLogin,
        ),
      ],
    );
  }
}

// =============================================================================
//  COUNTDOWN PILL & READY PILL
// =============================================================================
class _CountdownPill extends StatelessWidget {
  final String countdown;
  final double progress;
  final bool enabledShine;

  const _CountdownPill({
    super.key,
    required this.countdown,
    required this.progress,
    required this.enabledShine,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withOpacity(0.16), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (enabledShine)
            const _PulsingDot(color: Color(0xFFF59E0B))
          else
            const Icon(
              Icons.hourglass_top_rounded,
              size: 14,
              color: Color(0xFFF59E0B),
            ),
          const SizedBox(width: 10),
          Text(
            countdown,
            style: GoogleFonts.jetBrainsMono(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 70,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: Stack(
                children: [
                  Container(height: 5, color: Colors.white.withOpacity(0.10)),
                  AnimatedFractionallySizedBox(
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeOutCubic,
                    widthFactor: progress.clamp(0.0, 1.0),
                    child: Container(
                      height: 5,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF4F7CFF), Color(0xFF7EA5FF)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF4F7CFF).withOpacity(0.55),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                    ),
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

class _ReadyPill extends StatelessWidget {
  const _ReadyPill({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF10B981).withOpacity(0.16),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: const Color(0xFF10B981).withOpacity(0.45),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.bolt_rounded, size: 16, color: Color(0xFF6EE7B7)),
          const SizedBox(width: 8),
          Text(
            "Prêt à renvoyer",
            style: GoogleFonts.montserrat(
              color: const Color(0xFF6EE7B7),
              fontSize: 12.5,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _PulsingDot extends StatefulWidget {
  final Color color;
  const _PulsingDot({required this.color});

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1500),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (_, __) {
        final t = Curves.easeInOut.transform(_c.value);
        return Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.color,
            boxShadow: [
              BoxShadow(
                color: widget.color.withOpacity(0.55 * t),
                blurRadius: 8 + 4 * t,
                spreadRadius: 1 + 1 * t,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _BreathingHalo extends StatefulWidget {
  final Color color;
  const _BreathingHalo({required this.color});

  @override
  State<_BreathingHalo> createState() => _BreathingHaloState();
}

class _BreathingHaloState extends State<_BreathingHalo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2400),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (_, __) {
        final t = Curves.easeInOut.transform(_c.value);
        return Container(
          width: 116 - 6 * (1 - t),
          height: 116 - 6 * (1 - t),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                widget.color.withOpacity(0.18 + 0.10 * t),
                widget.color.withOpacity(0.0),
              ],
            ),
          ),
        );
      },
    );
  }
}

// =============================================================================
//  PASSWORD CHANGED SUCCESS OVERLAY (logique inchangée)
// =============================================================================
class _PasswordChangedSuccessOverlay extends StatefulWidget {
  final VoidCallback onComplete;
  final bool enabled;

  const _PasswordChangedSuccessOverlay({
    required this.onComplete,
    required this.enabled,
  });

  @override
  State<_PasswordChangedSuccessOverlay> createState() =>
      _PasswordChangedSuccessOverlayState();
}

class _PasswordChangedSuccessOverlayState
    extends State<_PasswordChangedSuccessOverlay>
    with TickerProviderStateMixin {
  late final AnimationController _master;
  late final Animation<double> _bgFade;
  late final Animation<double> _circleScale;
  late final Animation<double> _haloPulse;
  late final Animation<double> _checkProgress;
  late final Animation<double> _titleOpacity;
  late final Animation<double> _titleScale;
  late final Animation<double> _subtitleOpacity;
  Timer? _redirectTimer;

  @override
  void initState() {
    super.initState();

    _master = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1700),
    );

    _bgFade = CurvedAnimation(
      parent: _master,
      curve: const Interval(0.0, 0.20, curve: Curves.easeOut),
    );

    _circleScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _master,
        curve: const Interval(0.05, 0.45, curve: Curves.elasticOut),
      ),
    );

    _haloPulse = Tween<double>(begin: 0.55, end: 1.0).animate(
      CurvedAnimation(
        parent: _master,
        curve: const Interval(0.30, 0.95, curve: Curves.easeInOut),
      ),
    );

    _checkProgress = CurvedAnimation(
      parent: _master,
      curve: const Interval(0.30, 0.60, curve: Curves.easeOutCubic),
    );

    _titleOpacity = CurvedAnimation(
      parent: _master,
      curve: const Interval(0.50, 0.78, curve: Curves.easeOut),
    );

    _titleScale = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(
        parent: _master,
        curve: const Interval(0.50, 0.85, curve: Curves.easeOutBack),
      ),
    );

    _subtitleOpacity = CurvedAnimation(
      parent: _master,
      curve: const Interval(0.68, 0.95, curve: Curves.easeOut),
    );

    if (widget.enabled) {
      _master.forward();
    } else {
      _master.value = 1.0;
    }

    HapticFeedback.mediumImpact();

    const animationDuration = Duration(milliseconds: 1700);
    const displayExtra = Duration(milliseconds: 3300);

    _redirectTimer = Timer(animationDuration + displayExtra, () {
      if (!mounted) return;
      widget.onComplete();
    });
  }

  @override
  void dispose() {
    _redirectTimer?.cancel();
    _master.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: _master,
        builder: (context, _) {
          return Stack(
            fit: StackFit.expand,
            children: [
              Opacity(
                opacity: _bgFade.value,
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 18 * _bgFade.value,
                    sigmaY: 18 * _bgFade.value,
                  ),
                  child: Container(
                    color: Colors.black.withOpacity(0.55 * _bgFade.value),
                  ),
                ),
              ),
              IgnorePointer(
                child: Opacity(
                  opacity: 0.55 * _bgFade.value,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment.center,
                        radius: 0.9,
                        colors: [
                          const Color(
                            0xFF10B981,
                          ).withOpacity(0.18 * _haloPulse.value),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 180,
                      height: 180,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Transform.scale(
                            scale: 0.85 + 0.30 * _haloPulse.value,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    const Color(
                                      0xFF10B981,
                                    ).withOpacity(0.32 * _haloPulse.value),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Transform.scale(
                            scale: _circleScale.value,
                            child: Container(
                              width: 116,
                              height: 116,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFF10B981),
                                    Color(0xFF34D399),
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0x6610B981),
                                    blurRadius: 38,
                                    spreadRadius: -6,
                                  ),
                                ],
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Colors.white.withOpacity(0.18),
                                          Colors.white.withOpacity(0.0),
                                        ],
                                      ),
                                    ),
                                  ),
                                  CustomPaint(
                                    size: const Size(116, 116),
                                    painter: _CheckmarkPainter(
                                      progress: _checkProgress.value,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    Opacity(
                      opacity: _titleOpacity.value,
                      child: Transform.scale(
                        scale: _titleScale.value,
                        child: Text(
                          "Mot de passe modifié",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.4,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.35),
                                blurRadius: 18,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Opacity(
                      opacity: _subtitleOpacity.value,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 36),
                        child: Text(
                          "Tu peux maintenant te connecter\navec ton nouveau mot de passe.",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                            color: Colors.white.withOpacity(0.88),
                            fontSize: 14.5,
                            height: 1.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _CheckmarkPainter extends CustomPainter {
  final double progress;
  _CheckmarkPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path()
      ..moveTo(w * 0.30, h * 0.52)
      ..lineTo(w * 0.46, h * 0.66)
      ..lineTo(w * 0.72, h * 0.38);

    final metrics = path.computeMetrics().toList();
    if (metrics.isEmpty) return;
    final m = metrics.first;
    final extracted = m.extractPath(0, m.length * progress);
    canvas.drawPath(extracted, paint);
  }

  @override
  bool shouldRepaint(covariant _CheckmarkPainter old) =>
      old.progress != progress;
}

// =============================================================================
//  RESUME PROMPT BOTTOM SHEET (logique inchangée)
// =============================================================================
class _ResumePromptSheet extends StatelessWidget {
  final String email;
  const _ResumePromptSheet({required this.email});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF0B1437).withOpacity(0.92),
                border: Border.all(
                  color: Colors.white.withOpacity(0.10),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.35),
                    blurRadius: 26,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF4F7CFF), Color(0xFF6F4EF2)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF4F7CFF).withOpacity(0.45),
                          blurRadius: 24,
                          spreadRadius: -4,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.sync_lock_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "As-tu terminé la modification ?",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Si tu viens de modifier ton mot de passe sur le site COP'IQ, on te bascule sur l'écran de connexion.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      color: Colors.white.withOpacity(0.78),
                      fontSize: 13.5,
                      height: 1.45,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            side: BorderSide(
                              color: Colors.white.withOpacity(0.20),
                              width: 1.2,
                            ),
                            backgroundColor: Colors.white.withOpacity(0.04),
                          ),
                          child: Text(
                            "Pas encore",
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontSize: 13.5,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton.icon(
                          onPressed: () => Navigator.of(context).pop(true),
                          icon: const Icon(
                            Icons.check_circle_rounded,
                            size: 18,
                            color: Color(0xFF000932),
                          ),
                          label: Text(
                            "Oui, c'est fait",
                            style: GoogleFonts.montserrat(
                              color: const Color(0xFF000932),
                              fontSize: 13.5,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
