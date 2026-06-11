// lib/auth/signin.dart
// =============================================================================
//  COP'IQ — SIGN-IN (Cinematic Edition)
// =============================================================================
//  ⚠️  La logique métier est strictement préservée :
//        • Supabase signInWithPassword
//        • SharedPreferences "remember me"
//        • widget.onSignedIn callback
//        • Validators email + password
//        • Toggle visibility, mode découverte, navigation forgot/signup
//
//  ✨ Couche visuelle entièrement ré-écrite avec :
//        • Entrée chorégraphiée (staggered reveal + spring elastic)
//        • Mesh gradient animé + orbes flottantes + grille respirante
//        • Glassmorphism premium (BackdropFilter + bordures lumineuses)
//        • Theming light/dark synchronisé via AppSettingsController
//          (transition douce de toute la palette, plus de flash)
//        • Champs email/password avec focus halo et shake sur erreur
//        • CTA premium (gradient + shine continu + press magnétique)
//
//  🔔 Snacks remplacés par AppNotifier (success / error) — design cohérent
//     avec le reste de l'app.
// =============================================================================

import 'dart:ui';
import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:copiqpolice/core/widgets/app_notifier.dart'
    show AppSettingsController, AppNotifier;

// =============================================================================
//  PALETTE — Dual theme tokens (synced with AppSettingsController)
// =============================================================================
class _SigninPalette {
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

  const _SigninPalette({
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

  static const _SigninPalette dark = _SigninPalette(
    bg: Color(0xFF000932),
    bgDeep: Color(0xFF000418),
    accent: Color(0xFF6EA8FF),
    accent2: Color(0xFF7C5BFF),
    glow: Color(0xFF6EE7B7),
    glassFill: Color(0x14FFFFFF),
    glassBorder: Color(0x22FFFFFF),
    fieldFill: Color(0xFF0F1F4A),
    fieldBorder: Color(0xFF2F3C69),
    ctaForeground: Color(0xFF000932),
    text: Color(0xFFFFFFFF),
    textSoft: Color(0xE6FFFFFF),
  );

  static const _SigninPalette light = _SigninPalette(
    bg: Color(0xFF0E44D6),
    bgDeep: Color(0xFF062AA0),
    accent: Color(0xFF8FB6FF),
    accent2: Color(0xFFB6A6FF),
    glow: Color(0xFF6EE7B7),
    glassFill: Color(0x1FFFFFFF),
    glassBorder: Color(0x2EFFFFFF),
    fieldFill: Color(0xFF1A3FBA),
    fieldBorder: Color(0xFF355BE0),
    ctaForeground: Color(0xFF0E44D6),
    text: Color(0xFFFFFFFF),
    textSoft: Color(0xE6FFFFFF),
  );

  static _SigninPalette lerp(_SigninPalette a, _SigninPalette b, double t) {
    return _SigninPalette(
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
class SignInPage extends StatefulWidget {
  const SignInPage({super.key, this.onSignedIn});

  /// Callback appelé quand la connexion est réussie
  final VoidCallback? onSignedIn;

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> with TickerProviderStateMixin {
  // ===== LOGIQUE — INTACTE =====
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _pwdCtrl = TextEditingController();

  bool _loading = false;
  bool _obscure = true;

  // ✅ Remember me
  static const _kRememberMeKey = 'signin_remember_me';
  static const _kRememberEmailKey = 'signin_remember_email';
  bool _rememberMe = true;

  // ===== ANIMATION D'ARRIVÉE =====
  late final AnimationController _entryCtrl;

  @override
  void initState() {
    super.initState();
    _loadRememberMe();
    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _entryCtrl.forward();
    });
  }

  Future<void> _loadRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    final remember = prefs.getBool(_kRememberMeKey) ?? true;
    final email = prefs.getString(_kRememberEmailKey) ?? '';

    if (!mounted) return;
    setState(() => _rememberMe = remember);

    if (remember && email.isNotEmpty) {
      _emailCtrl.text = email;
    }
  }

  Future<void> _persistRememberMeOnSuccess() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kRememberMeKey, _rememberMe);

    if (_rememberMe) {
      await prefs.setString(_kRememberEmailKey, _emailCtrl.text.trim());
    } else {
      await prefs.remove(_kRememberEmailKey);
    }
  }

  Future<void> _persistRememberMeToggle() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kRememberMeKey, _rememberMe);
    if (!_rememberMe) {
      await prefs.remove(_kRememberEmailKey);
    }
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _pwdCtrl.dispose();
    _entryCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final supabase = Supabase.instance.client;

    FocusScope.of(context).unfocus();
    HapticFeedback.selectionClick();
    setState(() => _loading = true);

    try {
      final res = await supabase.auth.signInWithPassword(
        email: _emailCtrl.text.trim(),
        password: _pwdCtrl.text,
      );

      if (!mounted) return;

      if (res.user != null) {
        await _persistRememberMeOnSuccess();
        HapticFeedback.mediumImpact();
        AppNotifier.success(
          context,
          title: "Connexion réussie",
          message: "Bon retour parmi nous !",
        );
        widget.onSignedIn?.call();
      }
    } on AuthException catch (e) {
      if (!mounted) return;

      final rawMessage = e.message.toLowerCase();
      final message =
          rawMessage.contains('invalid login credentials') ||
              rawMessage.contains('invalid credentials')
          ? "Email ou mot de passe incorrect."
          : e.message;

      AppNotifier.error(
        context,
        title: "Connexion impossible",
        message: message,
      );
    } catch (_) {
      if (!mounted) return;
      AppNotifier.error(
        context,
        title: "Erreur inattendue",
        message: "Une erreur est survenue, réessaie dans un instant.",
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _goDiscovery() {
    HapticFeedback.selectionClick();
    Navigator.of(context).pushNamed('/discovery');
  }

  void _forgotPassword() {
    HapticFeedback.selectionClick();
    Navigator.of(context).pushNamed('/reset-password');
  }

  void _goSignup() {
    HapticFeedback.selectionClick();
    Navigator.of(context).pushNamed('/signup');
  }

  String? _validateEmail(String? v) {
    final s = v?.trim() ?? '';
    if (s.isEmpty) return "Renseigne ton email.";
    final ok = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(s);
    if (!ok) return "Email invalide.";
    return null;
  }

  String? _validatePassword(String? v) {
    final s = (v ?? '').trim();
    if (s.isEmpty) return "Renseigne ton mot de passe.";
    if (s.length < 6) return "Mot de passe trop court.";
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
        // Préserve la logique d'origine : seul ThemeMode.dark est dark.
        final isDark = mode == ThemeMode.dark;
        final reduceMotion = _reduceMotion(context);

        return TweenAnimationBuilder<double>(
          tween: Tween(begin: isDark ? 1.0 : 0.0, end: isDark ? 1.0 : 0.0),
          duration: const Duration(milliseconds: 520),
          curve: Curves.easeInOut,
          builder: (context, t, _) {
            final palette = _SigninPalette.lerp(
              _SigninPalette.light,
              _SigninPalette.dark,
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
    required _SigninPalette palette,
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
              // ----- Mesh gradient (mouvement subtil) -----
              Positioned.fill(
                child: _MeshGradientBackground(
                  palette: palette,
                  enabled: !reduceMotion,
                ),
              ),
              // ----- Particules très discrètes -----
              Positioned.fill(
                child: IgnorePointer(
                  child: _FloatingParticles(
                    palette: palette,
                    enabled: !reduceMotion,
                  ),
                ),
              ),
              // ----- Vignette douce -----
              const Positioned.fill(child: IgnorePointer(child: _Vignette())),

              // ----- Contenu harmonisé -----
              SafeArea(
                child: Center(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final availableH = constraints.maxHeight;
                      final compact = availableH < 720;
                      final ultraCompact = availableH < 620;

                      // MODIF VISUELLE : logo augmenté pour mieux remplir le téléphone.
                      final logoSize = ultraCompact
                          ? 128.0
                          : compact
                          ? 158.0
                          : 188.0;

                      final topPadding = ultraCompact
                          ? 0.0
                          : compact
                          ? 4.0
                          : 8.0;

                      final logoBottomGap = ultraCompact
                          ? 8.0
                          : compact
                          ? 10.0
                          : 12.0;

                      final cardToDividerGap = ultraCompact
                          ? 10.0
                          : compact
                          ? 12.0
                          : 14.0;

                      final dividerToDiscoveryGap = ultraCompact
                          ? 8.0
                          : compact
                          ? 9.0
                          : 10.0;

                      final discoveryToSignupGap = ultraCompact
                          ? 8.0
                          : compact
                          ? 10.0
                          : 12.0;

                      return ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 480),
                        child: SingleChildScrollView(
                          physics: const ClampingScrollPhysics(),
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          padding: EdgeInsets.fromLTRB(
                            22,
                            topPadding,
                            22,
                            ultraCompact ? 8 : 12,
                          ),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight:
                                  availableH -
                                  MediaQuery.viewInsetsOf(context).bottom -
                                  (ultraCompact ? 8 : 14),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    // ============ TOP : logo minimaliste ============
                                    _Stagger(
                                      opacity: _stage(0.05, 0.45),
                                      offsetY: (1 - _stage(0.05, 0.45)) * 24,
                                      scale:
                                          0.92 +
                                          0.08 *
                                              _stage(
                                                0.05,
                                                0.55,
                                                Curves.easeOutCubic,
                                              ),
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          top: ultraCompact ? 0 : 2,
                                          bottom: logoBottomGap,
                                        ),
                                        child: _MinimalLogo(
                                          size: logoSize,
                                          palette: palette,
                                          enabled: !reduceMotion,
                                        ),
                                      ),
                                    ),

                                    // ============ MIDDLE : formulaire ============
                                    _Stagger(
                                      opacity: _stage(0.20, 0.70),
                                      offsetY: (1 - _stage(0.20, 0.70)) * 24,
                                      scale:
                                          0.97 +
                                          0.03 *
                                              _stage(
                                                0.20,
                                                0.80,
                                                Curves.easeOutCubic,
                                              ),
                                      child: _GlassCardPremium(
                                        palette: palette,
                                        child: Form(
                                          key: _formKey,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              _PremiumFormTextField(
                                                label: "Email",
                                                controller: _emailCtrl,
                                                hint: "email@exemple.com",
                                                icon: Icons.email_outlined,
                                                keyboardType:
                                                    TextInputType.emailAddress,
                                                textInputAction:
                                                    TextInputAction.next,
                                                validator: _validateEmail,
                                                palette: palette,
                                              ),
                                              SizedBox(
                                                height: compact ? 10 : 14,
                                              ),
                                              _PremiumFormTextField(
                                                label: "Mot de passe",
                                                controller: _pwdCtrl,
                                                hint: "••••••••",
                                                icon:
                                                    Icons.lock_outline_rounded,
                                                obscureText: _obscure,
                                                textInputAction:
                                                    TextInputAction.done,
                                                onSubmitted: (_) =>
                                                    _loading ? null : _submit(),
                                                validator: _validatePassword,
                                                palette: palette,
                                                suffix: _PasswordToggle(
                                                  obscure: _obscure,
                                                  palette: palette,
                                                  onTap: () {
                                                    HapticFeedback.selectionClick();
                                                    setState(
                                                      () =>
                                                          _obscure = !_obscure,
                                                    );
                                                  },
                                                ),
                                              ),
                                              SizedBox(
                                                height: compact ? 8 : 10,
                                              ),

                                              // Remember + forgot — discret
                                              Wrap(
                                                spacing: 10,
                                                runSpacing: 4,
                                                alignment:
                                                    WrapAlignment.spaceBetween,
                                                crossAxisAlignment:
                                                    WrapCrossAlignment.center,
                                                children: [
                                                  _RememberMe(
                                                    value: _rememberMe,
                                                    palette: palette,
                                                    onChanged: (v) async {
                                                      HapticFeedback.selectionClick();
                                                      setState(
                                                        () => _rememberMe = v,
                                                      );
                                                      await _persistRememberMeToggle();
                                                    },
                                                  ),
                                                  _LinkButton(
                                                    label:
                                                        "Mot de passe oublié ?",
                                                    onPressed: _forgotPassword,
                                                  ),
                                                ],
                                              ),

                                              SizedBox(
                                                height: compact ? 10 : 14,
                                              ),

                                              _PrimaryButton(
                                                label: "Se connecter",
                                                loading: _loading,
                                                palette: palette,
                                                enabledShine: !reduceMotion,
                                                leadingIcon:
                                                    Icons.lock_open_rounded,
                                                onPressed: _loading
                                                    ? null
                                                    : _submit,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),

                                    // MODIF VISUELLE : partie découverte rapprochée du formulaire.
                                    SizedBox(height: cardToDividerGap),

                                    _Stagger(
                                      opacity: _stage(0.45, 0.85),
                                      offsetY: (1 - _stage(0.45, 0.85)) * 14,
                                      child: _OrDivider(palette: palette),
                                    ),
                                    SizedBox(height: dividerToDiscoveryGap),
                                    _Stagger(
                                      opacity: _stage(0.55, 0.92),
                                      offsetY: (1 - _stage(0.55, 0.92)) * 14,
                                      child: _DiscoveryButton(
                                        onPressed: _goDiscovery,
                                      ),
                                    ),
                                  ],
                                ),

                                // MODIF VISUELLE : CTA création de compte placé en bas.
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: discoveryToSignupGap + 18,
                                    bottom: ultraCompact ? 8 : 14,
                                  ),
                                  child: _Stagger(
                                    opacity: _stage(0.65, 1.0),
                                    offsetY: (1 - _stage(0.65, 1.0)) * 10,
                                    child: _SignupCTA(
                                      palette: palette,
                                      onSignup: _goSignup,
                                    ),
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
//  MINIMAL LOGO — pas de cadre, pas de halo, juste l'image qui flotte
//   • Image asset centrée
//   • Très subtil drop shadow elliptique sous l'image (donne de la profondeur)
//   • Floating animation discrète (~5px en sin loop)
//   • Glow translucide qui respire derrière, sans cercle visible
// =============================================================================
class _MinimalLogo extends StatefulWidget {
  final double size;
  final _SigninPalette palette;
  final bool enabled;

  const _MinimalLogo({
    required this.size,
    required this.palette,
    required this.enabled,
  });

  @override
  State<_MinimalLogo> createState() => _MinimalLogoState();
}

class _MinimalLogoState extends State<_MinimalLogo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 4200),
  );

  @override
  void initState() {
    super.initState();
    if (widget.enabled) _c.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(covariant _MinimalLogo old) {
    super.didUpdateWidget(old);
    if (old.enabled != widget.enabled) {
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
        final t = widget.enabled ? Curves.easeInOut.transform(_c.value) : 0.5;
        final lift = (t - 0.5) * 6; // -3..+3 px

        return SizedBox(
          height: widget.size + 30,
          width: widget.size + 80,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              // Glow translucide qui respire (pas de cercle, juste un halo doux)
              Positioned.fill(
                child: IgnorePointer(
                  child: Center(
                    child: Container(
                      width: widget.size * 1.55,
                      height: widget.size * 1.55,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            widget.palette.glow.withValues(alpha: 0.10 + 0.06 * t),
                            widget.palette.glow.withValues(alpha: 0.0),
                          ],
                          stops: const [0.0, 1.0],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Drop shadow elliptique sous l'image (sol implicite)
              Positioned(
                bottom: 2,
                child: Transform.scale(
                  scaleY: 0.18,
                  scaleX: 0.85,
                  child: Container(
                    width: widget.size * 0.85,
                    height: widget.size * 0.85,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.black.withValues(alpha: 0.30 - 0.08 * t),
                          Colors.black.withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // L'image — flotte doucement
              Transform.translate(
                offset: Offset(0, lift),
                child: Image.asset(
                  'assets/images/onboarding.png',
                  width: widget.size,
                  height: widget.size,
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.high,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// =============================================================================
//  MESH GRADIENT BACKGROUND
// =============================================================================
class _MeshGradientBackground extends StatefulWidget {
  final _SigninPalette palette;
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
                color: widget.palette.accent.withValues(alpha: 0.40),
                size: 380,
                blur: 120,
              ),
              _orb(
                align: Alignment(dx2, dy2),
                color: widget.palette.accent2.withValues(alpha: 0.35),
                size: 420,
                blur: 130,
              ),
              _orb(
                align: Alignment(dx3, dy3),
                color: widget.palette.glow.withValues(alpha: 0.18),
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
//  FLOATING PARTICLES
// =============================================================================
class _FloatingParticles extends StatefulWidget {
  final _SigninPalette palette;
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
        ..color = color.withValues(alpha: 0.40 * fade)
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
            Colors.black.withValues(alpha: 0.20),
            Colors.transparent,
            Colors.black.withValues(alpha: 0.30),
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
    );
  }
}

// =============================================================================
//  GLASS CARD PREMIUM
// =============================================================================
class _GlassCardPremium extends StatelessWidget {
  final Widget child;
  final _SigninPalette palette;
  const _GlassCardPremium({required this.child, required this.palette});

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
                color: Colors.black.withValues(alpha: 0.30),
                blurRadius: 36,
                offset: const Offset(0, 22),
              ),
              BoxShadow(
                color: palette.accent.withValues(alpha: 0.08),
                blurRadius: 30,
                spreadRadius: -4,
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withValues(alpha: 0.16),
                          Colors.white.withValues(alpha: 0.0),
                          Colors.black.withValues(alpha: 0.04),
                        ],
                        stops: const [0.0, 0.45, 1.0],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 14,
                right: 14,
                top: 0,
                child: Container(
                  height: 1,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withValues(alpha: 0.0),
                        Colors.white.withValues(alpha: 0.50),
                        Colors.white.withValues(alpha: 0.0),
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
//  PREMIUM FORM TEXT FIELD
// =============================================================================
class _PremiumFormTextField extends StatefulWidget {
  const _PremiumFormTextField({
    required this.label,
    required this.controller,
    required this.hint,
    required this.validator,
    required this.palette,
    required this.icon,
    this.keyboardType,
    this.textInputAction,
    this.onSubmitted,
    this.obscureText = false,
    this.suffix,
  });

  final String label;
  final TextEditingController controller;
  final String hint;
  final String? Function(String?) validator;
  final _SigninPalette palette;
  final IconData icon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;
  final bool obscureText;
  final Widget? suffix;

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
  void didUpdateWidget(covariant _PremiumFormTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onChange);
      widget.controller.addListener(_onChange);
    }
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
            Icon(widget.icon, size: 14, color: p.text),
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
                            color: p.glow.withValues(alpha: 0.30),
                            blurRadius: 24,
                            spreadRadius: 1,
                          ),
                          BoxShadow(
                            color: p.accent.withValues(alpha: 0.16),
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
                  obscureText: widget.obscureText,
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
                      color: Colors.white.withValues(alpha: 0.55),
                      fontWeight: FontWeight.w500,
                    ),
                    prefixIcon: Icon(
                      widget.icon,
                      color: _hasFocus
                          ? p.glow
                          : Colors.white.withValues(alpha: 0.55),
                      size: 19,
                    ),
                    suffixIcon:
                        widget.suffix ??
                        AnimatedSwitcher(
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
                        color: p.fieldBorder.withValues(alpha: 0.70),
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white.withValues(alpha: 0.95),
                        width: 1.4,
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: softError.withValues(alpha: 0.85),
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: softError.withValues(alpha: 0.95),
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
//  PASSWORD TOGGLE BUTTON
// =============================================================================
class _PasswordToggle extends StatelessWidget {
  final bool obscure;
  final VoidCallback onTap;
  final _SigninPalette palette;
  const _PasswordToggle({
    required this.obscure,
    required this.onTap,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      splashRadius: 22,
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 220),
        transitionBuilder: (c, a) => ScaleTransition(scale: a, child: c),
        child: Icon(
          obscure ? Icons.visibility_off_rounded : Icons.visibility_rounded,
          key: ValueKey(obscure),
          color: Colors.white.withValues(alpha: 0.78),
          size: 20,
        ),
      ),
    );
  }
}

// =============================================================================
//  PRIMARY BUTTON
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
  final _SigninPalette palette;
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
                Positioned.fill(
                  child: IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white.withValues(alpha: 0.85),
                            Colors.white.withValues(alpha: 0.0),
                          ],
                          stops: const [0.0, 0.55],
                        ),
                      ),
                    ),
                  ),
                ),
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
                                      Colors.white.withValues(alpha: 0.0),
                                      Colors.white.withValues(alpha: 0.55),
                                      Colors.white.withValues(alpha: 0.0),
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
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: widget.onPressed,
                    splashColor: widget.palette.glow.withValues(alpha: 0.18),
                    highlightColor: widget.palette.glow.withValues(alpha: 0.08),
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
                                    fg.withValues(alpha: 0.85),
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
                                          ? fg.withValues(alpha: 0.55)
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
                                        fontSize: 16,
                                        letterSpacing: -0.2,
                                        color: isDisabled
                                            ? fg.withValues(alpha: 0.65)
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
//  REMEMBER ME
// =============================================================================
class _RememberMe extends StatelessWidget {
  const _RememberMe({
    required this.value,
    required this.onChanged,
    required this.palette,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final _SigninPalette palette;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: () => onChanged(!value),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: value ? Colors.white : Colors.white.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: value ? Colors.white : Colors.white.withValues(alpha: 0.40),
                  width: 1.4,
                ),
                boxShadow: value
                    ? [
                        BoxShadow(
                          color: palette.glow.withValues(alpha: 0.35),
                          blurRadius: 12,
                          spreadRadius: -1,
                        ),
                      ]
                    : null,
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                transitionBuilder: (c, a) =>
                    ScaleTransition(scale: a, child: c),
                child: value
                    ? Icon(
                        Icons.check_rounded,
                        key: const ValueKey('on'),
                        size: 14,
                        color: palette.ctaForeground,
                      )
                    : const SizedBox(key: ValueKey('off')),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              "Se souvenir de moi",
              style: GoogleFonts.montserrat(
                color: Colors.white.withValues(alpha: 0.85),
                fontWeight: FontWeight.w700,
                fontSize: 13,
                letterSpacing: 0.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
//  LINK BUTTON
// =============================================================================
class _LinkButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  const _LinkButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        minimumSize: const Size(0, 0),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        label,
        style: GoogleFonts.montserrat(
          color: Colors.white.withValues(alpha: 0.85),
          fontWeight: FontWeight.w800,
          fontSize: 13,
          decoration: TextDecoration.underline,
          decorationColor: Colors.white.withValues(alpha: 0.40),
          decorationThickness: 1.2,
        ),
      ),
    );
  }
}

// =============================================================================
//  OR DIVIDER
// =============================================================================
class _OrDivider extends StatelessWidget {
  final _SigninPalette palette;
  const _OrDivider({required this.palette});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withValues(alpha: 0.0),
                  Colors.white.withValues(alpha: 0.30),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
            ),
            child: Text(
              "ou",
              style: GoogleFonts.montserrat(
                color: Colors.white.withValues(alpha: 0.78),
                fontWeight: FontWeight.w700,
                fontSize: 12,
                letterSpacing: 0.4,
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withValues(alpha: 0.30),
                  Colors.white.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// =============================================================================
//  DISCOVERY BUTTON
// =============================================================================
class _DiscoveryButton extends StatefulWidget {
  final VoidCallback onPressed;
  const _DiscoveryButton({required this.onPressed});

  @override
  State<_DiscoveryButton> createState() => _DiscoveryButtonState();
}

class _DiscoveryButtonState extends State<_DiscoveryButton> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => setState(() => _down = true),
      onPointerUp: (_) => setState(() => _down = false),
      onPointerCancel: (_) => setState(() => _down = false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 130),
        scale: _down ? 0.985 : 1.0,
        curve: Curves.easeOut,
        child: SizedBox(
          height: 56,
          width: double.infinity,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.20),
                          width: 1.2,
                        ),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: widget.onPressed,
                          borderRadius: BorderRadius.circular(16),
                          splashColor: Colors.white.withValues(alpha: 0.10),
                          highlightColor: Colors.white.withValues(alpha: 0.04),
                          child: Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.explore_rounded,
                                  size: 19,
                                  color: Colors.white.withValues(alpha: 0.92),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  "Mode découverte",
                                  style: GoogleFonts.montserrat(
                                    color: Colors.white.withValues(alpha: 0.95),
                                    fontWeight: FontWeight.w800,
                                    fontSize: 15,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(right: 12, top: -8, child: _NewBadge()),
            ],
          ),
        ),
      ),
    );
  }
}

class _NewBadge extends StatefulWidget {
  @override
  State<_NewBadge> createState() => _NewBadgeState();
}

class _NewBadgeState extends State<_NewBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
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
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF10B981), Color(0xFF34D399)],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF10B981).withValues(alpha: 0.40 + 0.20 * t),
                blurRadius: 14 + 6 * t,
                spreadRadius: -2,
              ),
            ],
          ),
          child: Text(
            "NOUVEAU",
            style: GoogleFonts.montserrat(
              fontSize: 9.5,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.8,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}

// =============================================================================
//  SIGN UP CTA — texte seul, sans fond, sans bulle
//   • Aucun fade / contour / cadre autour de "Pas encore de compte ?"
//   • Texte centré, propre, premium et lisible
//   • Flèche qui glisse en boucle douce → call-to-action vivant
//   • Aucun trait sous le lien
// =============================================================================
class _SignupCTA extends StatelessWidget {
  final _SigninPalette palette;
  final VoidCallback onSignup;
  const _SignupCTA({required this.palette, required this.onSignup});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 4,
        runSpacing: 4,
        children: [
          Text(
            "Pas encore de compte ?",
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              color: Colors.white.withValues(alpha: 0.78),
              fontSize: 14,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.1,
            ),
          ),
          _SignupLink(palette: palette, onTap: onSignup),
        ],
      ),
    );
  }
}

// =============================================================================
//  SIGN UP LINK — "Créer un compte →" sans trait, avec flèche qui glisse en loop
// =============================================================================
class _SignupLink extends StatefulWidget {
  final _SigninPalette palette;
  final VoidCallback onTap;
  const _SignupLink({required this.palette, required this.onTap});

  @override
  State<_SignupLink> createState() => _SignupLinkState();
}

class _SignupLinkState extends State<_SignupLink>
    with SingleTickerProviderStateMixin {
  late final AnimationController _arrow = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  )..repeat(reverse: true);

  bool _down = false;

  @override
  void dispose() {
    _arrow.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => setState(() => _down = true),
      onPointerUp: (_) => setState(() => _down = false),
      onPointerCancel: (_) => setState(() => _down = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _arrow,
          builder: (context, _) {
            final t = Curves.easeInOut.transform(_arrow.value);
            return AnimatedScale(
              duration: const Duration(milliseconds: 130),
              scale: _down ? 0.96 : 1.0,
              curve: Curves.easeOut,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Texte avec gradient subtil + glow doux, sans trait dessous.
                  ShaderMask(
                    shaderCallback: (rect) => LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.white, Colors.white, widget.palette.glow],
                      stops: const [0.0, 0.55, 1.0],
                    ).createShader(rect),
                    child: Text(
                      "Créer un compte",
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontSize: 14.5,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.2,
                        shadows: [
                          Shadow(
                            color: widget.palette.glow.withValues(alpha: 0.35),
                            blurRadius: 14,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  // Flèche qui oscille doucement
                  Transform.translate(
                    offset: Offset(2 + 4 * t, 0),
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      size: 17,
                      color: widget.palette.glow,
                      shadows: [
                        Shadow(
                          color: widget.palette.glow.withValues(alpha: 0.55),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
