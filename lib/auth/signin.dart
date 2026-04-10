// lib/auth/signin.dart
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// 👉 contrôleur global (thème synchro onboarding)
import 'package:copiqpolice/ui/app_notifier.dart'
    show AppSettingsController, AppNotifier;

class SignInPage extends StatefulWidget {
  const SignInPage({super.key, this.onSignedIn});

  /// Callback appelé quand la connexion est réussie
  final VoidCallback? onSignedIn;

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _pwdCtrl = TextEditingController();

  bool _loading = false;
  bool _obscure = true;

  // ✅ Remember me
  static const _kRememberMeKey = 'signin_remember_me';
  static const _kRememberEmailKey = 'signin_remember_email';
  bool _rememberMe = true;

  // Palettes alignées Onboarding/Signup
  static const _bgDark = Color(0xFF000932); // navy
  static const _bgLight = Color(0xFF0E44D6); // bleu

  Color _whiteA(double o) => Color.fromRGBO(255, 255, 255, o);

  @override
  void initState() {
    super.initState();
    _loadRememberMe();
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
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final supabase = Supabase.instance.client;

    FocusScope.of(context).unfocus();
    setState(() => _loading = true);

    try {
      final res = await supabase.auth.signInWithPassword(
        email: _emailCtrl.text.trim(),
        password: _pwdCtrl.text,
      );

      if (!mounted) return;

      if (res.user != null) {
        await _persistRememberMeOnSuccess();
        HapticFeedback.selectionClick();
        widget.onSignedIn?.call();
      }
    } on AuthException catch (e) {
      _snack(e.message);
    } catch (_) {
      _snack("Erreur inattendue, réessaie.");
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
    _snack("À brancher : page de réinitialisation mot de passe.");
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: GoogleFonts.montserrat()),
        behavior: SnackBarBehavior.floating,
      ),
    );
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

  @override
  Widget build(BuildContext context) {
    final appCtrl = AppSettingsController.I;

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: appCtrl.themeMode,
      builder: (_, mode, __) {
        final isDark = mode == ThemeMode.dark;
        final bg = isDark ? _bgDark : _bgLight;
        final ctaFg = isDark ? _bgDark : _bgLight;

        final reduceMotion = _reduceMotion(context);

        final h = MediaQuery.sizeOf(context).height;
        final logoH = (h * 0.24).clamp(170.0, 240.0);

        return Scaffold(
          backgroundColor: bg,
          resizeToAvoidBottomInset: true,
          body: Stack(
            children: [
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
                          Colors.black.withOpacity(0.18),
                          Colors.transparent,
                          Colors.black.withOpacity(0.28),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              SafeArea(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final mq = MediaQuery.of(context);
                    final keyboard = mq.viewInsets.bottom;

                    // ✅ Scaling léger selon la hauteur dispo
                    final availableH = constraints.maxHeight;
                    final compact = availableH < 700;

                    final logoH = (availableH * (compact ? 0.20 : 0.24)).clamp(
                      140.0,
                      240.0,
                    );

                    return Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 520),
                        child: SingleChildScrollView(
                          // ✅ Important: évite les bugs de "scroll bizarre" quand clavier
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          padding: EdgeInsets.fromLTRB(
                            24,
                            compact ? 18 : 28,
                            24,
                            (compact ? 18 : 26) + keyboard * 0.25,
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
                                // ===== LOGO (halo) =====
                                SizedBox(
                                  height: logoH,
                                  width: 240,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Container(
                                        width: 180,
                                        height: 180,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.white.withOpacity(
                                                isDark ? 0.10 : 0.12,
                                              ),
                                              blurRadius: 60,
                                              spreadRadius: 18,
                                            ),
                                          ],
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

                                Text(
                                  "Reprends tes révisions\navec COP’IQ",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.montserrat(
                                    fontSize: compact ? 14 : 15,
                                    height: 1.45,
                                    color: _whiteA(.92),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),

                                SizedBox(height: compact ? 16 : 22),

                                // ===== Formulaire (glass) =====
                                _GlassCardPremium(
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      children: [
                                        _PremiumFormTextField(
                                          label: "Email",
                                          controller: _emailCtrl,
                                          hint: "email@exemple.com",
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          textInputAction: TextInputAction.next,
                                          validator: _validateEmail,
                                          isDark: isDark,
                                        ),
                                        const SizedBox(height: 12),
                                        _PremiumFormTextField(
                                          label: "Mot de passe",
                                          controller: _pwdCtrl,
                                          hint: "••••••••",
                                          obscureText: _obscure,
                                          textInputAction: TextInputAction.done,
                                          onSubmitted: (_) =>
                                              _loading ? null : _submit(),
                                          validator: (v) {
                                            final s = (v ?? '').trim();
                                            if (s.isEmpty)
                                              return "Renseigne ton mot de passe.";
                                            if (s.length < 6)
                                              return "Mot de passe trop court.";
                                            return null;
                                          },
                                          isDark: isDark,
                                          suffix: IconButton(
                                            onPressed: () {
                                              HapticFeedback.selectionClick();
                                              setState(
                                                () => _obscure = !_obscure,
                                              );
                                            },
                                            icon: Icon(
                                              _obscure
                                                  ? Icons.visibility_off_rounded
                                                  : Icons.visibility_rounded,
                                              color: _whiteA(.8),
                                            ),
                                          ),
                                        ),

                                        const SizedBox(height: 10),

                                        // ✅ FIX OVERFLOW : Wrap au lieu de Row
                                        Wrap(
                                          spacing: 10,
                                          runSpacing: 6,
                                          alignment: WrapAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              WrapCrossAlignment.center,
                                          children: [
                                            _RememberMe(
                                              value: _rememberMe,
                                              textColor: _whiteA(.82),
                                              onChanged: (v) async {
                                                HapticFeedback.selectionClick();
                                                setState(() => _rememberMe = v);
                                                await _persistRememberMeToggle();
                                              },
                                            ),

                                            TextButton(
                                              onPressed: _forgotPassword,
                                              style: TextButton.styleFrom(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 6,
                                                    ),
                                                minimumSize: const Size(0, 0),
                                                tapTargetSize:
                                                    MaterialTapTargetSize
                                                        .shrinkWrap,
                                              ),
                                              child: Text(
                                                "Mot de passe oublié ?",
                                                style: GoogleFonts.montserrat(
                                                  color: _whiteA(.82),
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                        const SizedBox(height: 6),

                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.lock_outline_rounded,
                                              size: 14,
                                              color: _whiteA(.62),
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              "Connexion sécurisée",
                                              style: GoogleFonts.montserrat(
                                                fontSize: 12,
                                                color: _whiteA(.62),
                                                height: 1.2,
                                              ),
                                            ),
                                          ],
                                        ),

                                        const SizedBox(height: 16),

                                        _SignInPrimaryButton(
                                          label: "Se connecter",
                                          loading: _loading,
                                          foreground: ctaFg,
                                          enabledShine: !reduceMotion,
                                          onPressed: _loading ? null : _submit,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 18),

                                Row(
                                  children: [
                                    Expanded(
                                      child: Divider(
                                        color: _whiteA(.26),
                                        thickness: 1,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                      ),
                                      child: Text(
                                        "ou",
                                        style: GoogleFonts.montserrat(
                                          color: _whiteA(.70),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Divider(
                                        color: _whiteA(.26),
                                        thickness: 1,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 14),

                                SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton.icon(
                                    onPressed: _goDiscovery,
                                    icon: const Icon(
                                      Icons.explore_rounded,
                                      size: 20,
                                      color: Color(0xFFB0B6C3),
                                    ),
                                    label: Text(
                                      "Mode découverte",
                                      style: GoogleFonts.montserrat(
                                        fontWeight: FontWeight.w800,
                                        color: const Color(0xFFB0B6C3),
                                      ),
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: const Color(0xFF1E2A55),
                                      side: const BorderSide(
                                        color: Color(0xFF3A466F),
                                        width: 1,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 18,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 10),

                                Text(
                                  "Tester COP’IQ sans inscription • progression non sauvegardée",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.montserrat(
                                    color: const Color(0xFF9AA1B2),
                                    fontSize: 12.5,
                                    height: 1.25,
                                  ),
                                ),

                                const SizedBox(height: 18),

                                Wrap(
                                  alignment: WrapAlignment.center,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Text(
                                      "Pas encore de compte ? ",
                                      style: GoogleFonts.montserrat(
                                        color: _whiteA(.85),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        HapticFeedback.selectionClick();
                                        Navigator.of(
                                          context,
                                        ).pushNamed('/signup');
                                      },
                                      child: Text(
                                        "Créer un compte",
                                        style: GoogleFonts.montserrat(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w900,
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

/// ------------------------------
/// TEXT FIELD PREMIUM + VALIDATION
/// ------------------------------
/// ------------------------------
/// TEXT FIELD PREMIUM + VALIDATION
/// + MICRO FOCUS GLOW (ultra léger)
/// ------------------------------
class _PremiumFormTextField extends StatefulWidget {
  const _PremiumFormTextField({
    required this.label,
    required this.controller,
    required this.hint,
    required this.validator,
    required this.isDark,
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
  final bool isDark;

  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;

  final bool obscureText;
  final Widget? suffix;

  @override
  State<_PremiumFormTextField> createState() => _PremiumFormTextFieldState();
}

class _PremiumFormTextFieldState extends State<_PremiumFormTextField> {
  String? _error;
  bool _touched = false;

  late final FocusNode _focus = FocusNode();
  bool _hasFocus = false;

  Color _whiteA(double o) => Color.fromRGBO(255, 255, 255, o);

  @override
  void initState() {
    super.initState();

    widget.controller.addListener(_onChange);

    _focus.addListener(() {
      if (!mounted) return;
      setState(() => _hasFocus = _focus.hasFocus);
      if (_focus.hasFocus) _markTouched(); // petit bonus: déclenche proprement
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
    super.dispose();
  }

  void _onChange() {
    if (!_touched) return;
    final msg = widget.validator(widget.controller.text);
    if (msg != _error && mounted) setState(() => _error = msg);
  }

  void _markTouched() {
    if (_touched) return;
    setState(() {
      _touched = true;
      _error = widget.validator(widget.controller.text);
    });
  }

  InputDecoration _decoration() {
    final fill = widget.isDark
        ? const Color(0xFF0F1F4A)
        : const Color(0xFF1A3FBA);

    const softError = Color(0xFFFFB4B4);

    // Bordure focus un poil plus “cristal”
    final focusedBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.white.withOpacity(0.90),
        width: 1.25,
      ),
      borderRadius: BorderRadius.circular(12),
    );

    // Bordure normale
    final border = widget.isDark
        ? const Color(0xFF2F3C69)
        : const Color(0xFF355BE0);

    return InputDecoration(
      hintText: widget.hint,
      hintStyle: GoogleFonts.montserrat(color: _whiteA(.55)),
      filled: true,
      fillColor: fill,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),

      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: border.withOpacity(0.70)),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: focusedBorder,

      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: softError.withOpacity(0.85), width: 1.0),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: softError.withOpacity(0.95), width: 1.2),
        borderRadius: BorderRadius.circular(12),
      ),

      suffixIcon: widget.suffix,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Glow ultra subtil (bleuté/blanc) — cohérent avec ton fond
    final glow = widget.isDark
        ? Colors.white.withOpacity(0.14)
        : Colors.white.withOpacity(0.18);

    // Intensité contrôlée
    final blur = _hasFocus ? 18.0 : 0.0;
    final spread = _hasFocus ? 1.0 : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),

        // ✅ Wrapper animé qui fait le glow autour du champ
        AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: _hasFocus
                ? [
                    BoxShadow(
                      color: glow,
                      blurRadius: blur,
                      spreadRadius: spread,
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
            style: GoogleFonts.montserrat(color: Colors.white),
            decoration: _decoration(),
            validator: widget.validator,
            autovalidateMode: AutovalidateMode.disabled,
          ),
        ),

        // ✅ Validation inline douce + micro animation
        AnimatedSize(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 180),
            opacity: (_touched && _error != null) ? 1 : 0,
            child: (_touched && _error != null)
                ? Padding(
                    padding: const EdgeInsets.only(top: 8, left: 2),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.info_outline_rounded,
                          size: 14,
                          color: Color(0xFFFFB4B4),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            _error!,
                            style: GoogleFonts.montserrat(
                              color: const Color(0xFFFFB4B4),
                              fontSize: 12.5,
                              height: 1.15,
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

/// -----------------------------------
/// BOUTON PRIMARY "SE CONNECTER" (WOW)
/// - taille parfaite (56)
/// - micro scale press
/// - shine subtil
/// - safe (aucun MediaQuery en initState)
/// -----------------------------------
class _SignInPrimaryButton extends StatefulWidget {
  const _SignInPrimaryButton({
    required this.label,
    required this.loading,
    required this.foreground,
    required this.onPressed,
    required this.enabledShine,
  });

  final String label;
  final bool loading;
  final Color foreground;
  final VoidCallback? onPressed;
  final bool enabledShine;

  @override
  State<_SignInPrimaryButton> createState() => _SignInPrimaryButtonState();
}

class _SignInPrimaryButtonState extends State<_SignInPrimaryButton>
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
      if (widget.enabledShine && !widget.loading) _shine.forward(from: 0);
    });
  }

  @override
  void didUpdateWidget(covariant _SignInPrimaryButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabledShine &&
        !widget.loading &&
        (!oldWidget.enabledShine || oldWidget.loading)) {
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
          height: 56, // ✅ taille parfaite
          width: double.infinity,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                // Base button
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
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 160),
                      child: widget.loading
                          ? const SizedBox(
                              key: ValueKey('loader'),
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(
                              widget.label,
                              key: const ValueKey('label'),
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w900,
                                fontSize: 16,
                                letterSpacing: -0.2,
                              ),
                            ),
                    ),
                  ),
                ),

                // Shine overlay subtil
                if (widget.enabledShine && !widget.loading)
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
                                        Colors.white.withOpacity(0.00),
                                        Colors.white.withOpacity(0.18),
                                        Colors.white.withOpacity(0.00),
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

                // Micro highlight haut (donne du “premium”)
                Positioned.fill(
                  child: IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white.withOpacity(0.10),
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

/// ---------------------------------------
/// MODE DÉCOUVERTE + BADGE (ultra premium)
/// ---------------------------------------
class _DiscoveryButtonWithBadge extends StatelessWidget {
  const _DiscoveryButtonWithBadge({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Button
          Positioned.fill(
            child: OutlinedButton.icon(
              onPressed: () {
                HapticFeedback.selectionClick();
                onPressed();
              },
              icon: const Icon(
                Icons.explore_rounded,
                size: 20,
                color: Color(0xFFB0B6C3),
              ),
              label: Text(
                "Mode découverte",
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFFB0B6C3),
                  letterSpacing: -0.1,
                ),
              ),
              style: OutlinedButton.styleFrom(
                backgroundColor: const Color(0xFF1E2A55),
                side: const BorderSide(color: Color(0xFF3A466F), width: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),

          // Badge (petit, propre)
          Positioned(right: 10, top: -10, child: _BadgePill(text: "NOUVEAU")),
        ],
      ),
    );
  }
}

class _BadgePill extends StatelessWidget {
  const _BadgePill({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: const Color(0xFF2B355E),
        border: Border.all(color: const Color(0xFF56618C), width: 1),
        boxShadow: [
          BoxShadow(
            blurRadius: 16,
            offset: const Offset(0, 6),
            color: Colors.black.withOpacity(0.20),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Text(
          text,
          style: GoogleFonts.montserrat(
            fontSize: 10.5,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.6,
            color: const Color(0xFFB0B6C3),
          ),
        ),
      ),
    );
  }
}

/// -------- InputDecoration (externe) --------
InputDecoration _inputDecoration({
  required String hint,
  required bool isDark,
  required Color Function(double) whiteA,
}) {
  final fill = isDark ? const Color(0xFF0F1F4A) : const Color(0xFF1A3FBA);
  final border = isDark ? const Color(0xFF2F3C69) : const Color(0xFF355BE0);

  return InputDecoration(
    hintText: hint,
    hintStyle: GoogleFonts.montserrat(color: whiteA(.55)),
    filled: true,
    fillColor: fill,
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: border.withOpacity(0.70)),
      borderRadius: BorderRadius.circular(12),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.white, width: 1.2),
      borderRadius: BorderRadius.circular(12),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.redAccent),
      borderRadius: BorderRadius.circular(12),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.redAccent, width: 1.2),
      borderRadius: BorderRadius.circular(12),
    ),
  );
}

/// --------- UI Helpers ---------

class _FieldWrapper extends StatelessWidget {
  const _FieldWrapper({required this.label, required this.child});
  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        child,
      ],
    );
  }
}

class _RememberMe extends StatelessWidget {
  const _RememberMe({
    required this.value,
    required this.onChanged,
    required this.textColor,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: () => onChanged(!value),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Transform.scale(
            scale: 1.05,
            child: Checkbox(
              value: value,
              onChanged: (v) => onChanged(v ?? false),
              side: BorderSide(color: Colors.white.withOpacity(0.35), width: 1),
              activeColor: Colors.white,
              checkColor: const Color(0xFF000932),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: const VisualDensity(horizontal: -2, vertical: -2),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            "Se souvenir de moi",
            style: GoogleFonts.montserrat(
              color: textColor,
              fontWeight: FontWeight.w800,
              fontSize: 13,
            ),
          ),
        ],
      ),
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
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}

/// ✅ Fond dynamique (blobs) — SAFE: aucune lecture MediaQuery en initState
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

/// ✅ Bouton CTA avec shine — SAFE: pas de MediaQuery en initState
class _ShinyPrimaryButton extends StatefulWidget {
  const _ShinyPrimaryButton({
    required this.loading,
    required this.foreground,
    required this.onPressed,
    required this.label,
    required this.enabledShine,
  });

  final bool loading;
  final Color foreground;
  final VoidCallback? onPressed;
  final String label;
  final bool enabledShine;

  @override
  State<_ShinyPrimaryButton> createState() => _ShinyPrimaryButtonState();
}

class _ShinyPrimaryButtonState extends State<_ShinyPrimaryButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  );

  @override
  void initState() {
    super.initState();
    // ✅ pas de MediaQuery ici
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (widget.enabledShine && !widget.loading) {
        _c.forward(from: 0);
      }
    });
  }

  @override
  void didUpdateWidget(covariant _ShinyPrimaryButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Si on réactive le shine ou si on passe de loading -> non loading
    if (widget.enabledShine &&
        !widget.loading &&
        (!oldWidget.enabledShine || oldWidget.loading)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _c.forward(from: 0);
      });
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: widget.loading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(
                      widget.label,
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
            ),

            if (widget.enabledShine && !widget.loading)
              Positioned.fill(
                child: IgnorePointer(
                  child: AnimatedBuilder(
                    animation: _c,
                    builder: (context, _) {
                      final t = Curves.easeOutCubic.transform(_c.value);
                      final dx = lerpDouble(-1.2, 1.2, t)!;

                      return Opacity(
                        opacity: 0.65,
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
                                    Colors.white.withOpacity(0.0),
                                    Colors.white.withOpacity(0.18),
                                    Colors.white.withOpacity(0.0),
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
          ],
        ),
      ),
    );
  }
}
