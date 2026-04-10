// lib/auth/signup.dart
import 'dart:ui';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:copiqpolice/onboarding/onboarding_screen.dart';
import 'package:copiqpolice/ui/app_notifier.dart'
    show AppSettingsController, AppNotifier;

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key, this.onSignedUp});
  final void Function(String email, String password)? onSignedUp;

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> with TickerProviderStateMixin {
  // Wizard
  static const int _steps = 4;
  final PageController _pc = PageController();
  int _index = 0;

  // Controllers
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();

  final _emailCtrl = TextEditingController();
  final _email2Ctrl = TextEditingController();

  final _pwdCtrl = TextEditingController();
  final _pwd2Ctrl = TextEditingController();

  final _cityCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  // Focus nodes (glow)
  final _fnFirst = FocusNode();
  final _fnLast = FocusNode();
  final _fnEmail = FocusNode();
  final _fnEmail2 = FocusNode();
  final _fnPwd = FocusNode();
  final _fnPwd2 = FocusNode();
  final _fnCity = FocusNode();
  final _fnPhone = FocusNode();

  // Email check
  bool _checkingEmail = false;
  bool?
  _emailAvailable; // null = pas checké, true = dispo, false = déjà utilisé
  String? _emailTakenMsg;
  Timer? _emailDebounce;
  int _emailCheckSeq = 0;

  // UI state
  bool _loading = false;
  bool _obscure1 = true;
  bool _obscure2 = true;

  // Conditions (final step)
  bool _acceptTerms = false;
  bool _refusedOnce = false;

  // Palettes AUTH (alignées onboarding/signin)
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

  @override
  void initState() {
    super.initState();

    // micro haptics quand page change
    _pc.addListener(() {
      final p = _pc.hasClients ? (_pc.page ?? 0.0) : 0.0;
      final nearest = p.round().clamp(0, _steps - 1);
      if (nearest != _index) {
        setState(() => _index = nearest);
        HapticFeedback.selectionClick();
      }
    });

    // rebuild pour lock/unlock CTA en live
    for (final c in [
      _firstNameCtrl,
      _lastNameCtrl,
      _emailCtrl,
      _email2Ctrl,
      _pwdCtrl,
      _pwd2Ctrl,
      _cityCtrl,
      _phoneCtrl,
    ]) {
      c.addListener(() {
        if (mounted) setState(() {});
      });
    }
  }

  @override
  void dispose() {
    _emailDebounce?.cancel();
    _pc.dispose();

    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _emailCtrl.dispose();
    _email2Ctrl.dispose();
    _pwdCtrl.dispose();
    _pwd2Ctrl.dispose();
    _cityCtrl.dispose();
    _phoneCtrl.dispose();

    _fnFirst.dispose();
    _fnLast.dispose();
    _fnEmail.dispose();
    _fnEmail2.dispose();
    _fnPwd.dispose();
    _fnPwd2.dispose();
    _fnCity.dispose();
    _fnPhone.dispose();

    super.dispose();
  }

  // ---------- VALIDATIONS ----------
  String? _validateEmail(String? v) {
    final s = (v ?? '').trim();
    if (s.isEmpty) return "Renseigne ton email.";
    final ok = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(s);
    if (!ok) return "Email invalide.";
    return null;
  }

  String? _validateName(String? v, {required String label}) {
    final s = (v ?? '').trim();
    if (s.isEmpty) return "Renseigne ton $label.";
    if (s.length < 2) return "$label trop court.";
    return null;
  }

  String? _validatePwd(String? v) {
    final s = v ?? '';
    if (s.length < 8) return "Au moins 8 caractères.";
    if (!RegExp(r'[A-Z]').hasMatch(s)) return "Ajoute une majuscule.";
    if (!RegExp(r'[a-z]').hasMatch(s)) return "Ajoute une minuscule.";
    if (!RegExp(r'[0-9]').hasMatch(s)) return "Ajoute un chiffre.";
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>_\-\[\]\\\/+=~`;]').hasMatch(s)) {
      return "Ajoute un caractère spécial.";
    }
    return null;
  }

  String? _validatePwd2(String? v) {
    if ((v ?? '') != _pwdCtrl.text)
      return "Les mots de passe ne correspondent pas.";
    return null;
  }

  bool get _stepValid {
    switch (_index) {
      case 0:
        return true;

      // Email step
      case 1:
        return _validateEmail(_emailCtrl.text) == null &&
            _validateEmail(_email2Ctrl.text) == null &&
            _emailCtrl.text.trim().toLowerCase() ==
                _email2Ctrl.text.trim().toLowerCase() &&
            _emailAvailable == true;

      // Password step
      case 2:
        return _validatePwd(_pwdCtrl.text) == null &&
            _validatePwd2(_pwd2Ctrl.text) == null;

      // Terms step
      case 3:
        return _acceptTerms == true;

      default:
        return false;
    }
  }

  // ---------- EMAIL AVAILABILITY ----------
  Future<void> _checkEmailAvailability(String _) async {
    final a = _emailCtrl.text.trim().toLowerCase();
    final b = _email2Ctrl.text.trim().toLowerCase();

    final aOk = _validateEmail(a) == null;
    final bOk = _validateEmail(b) == null;
    final match = a.isNotEmpty && b.isNotEmpty && a == b;

    if (!aOk || !bOk || !match) {
      _emailDebounce?.cancel();
      if (!mounted) return;
      setState(() {
        _checkingEmail = false;
        _emailAvailable = null;
        _emailTakenMsg = null;
      });
      return;
    }

    _emailDebounce?.cancel();
    _emailDebounce = Timer(const Duration(milliseconds: 350), () async {
      final int seq = ++_emailCheckSeq;

      if (!mounted) return;
      setState(() {
        _checkingEmail = true;
        _emailAvailable = null;
        _emailTakenMsg = null;
      });

      try {
        final sb = Supabase.instance.client;

        final res = await sb.rpc('is_email_available', params: {'p_email': a});

        if (!mounted) return;
        if (seq != _emailCheckSeq) return;

        // Si l’utilisateur a modifié entre temps
        final nowA = _emailCtrl.text.trim().toLowerCase();
        final nowB = _email2Ctrl.text.trim().toLowerCase();
        if (nowA != a || nowB != a) return;

        final available = (res == true);

        setState(() {
          _checkingEmail = false;
          _emailAvailable = available;
          _emailTakenMsg = available ? null : "Cet email est déjà utilisé.";
        });
      } catch (_) {
        if (!mounted) return;
        if (seq != _emailCheckSeq) return;

        setState(() {
          _checkingEmail = false;
          _emailAvailable = null;
          _emailTakenMsg = "Impossible de vérifier l’email (réessaie).";
        });
      }
    });
  }

  // ---------- NAV ----------
  Future<void> _goNext() async {
    FocusScope.of(context).unfocus();
    if (!_stepValid) return;

    if (_index < _steps - 1) {
      await _pc.nextPage(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
      );
    }
  }

  Future<void> _goPrev() async {
    FocusScope.of(context).unfocus();
    if (_index <= 0) return;

    await _pc.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  // ---------- SUPABASE SIGNUP (ULTRA CLEAN) ----------
  //
  // IMPORTANT:
  // - Ici on fait UNIQUEMENT le signUp.
  // - Le profil minimal est créé par TRIGGER DB (safe).
  // - L’acceptation CGV + complétion profil se fera APRES connexion
  //   (quand l’email est confirmé) via un UPDATE sur user_profiles.
  Future<void> _submit() async {
    if (_index != _steps - 1) return;

    if (!_acceptTerms) {
      AppNotifier.error(
        context,
        title: "Conditions requises",
        message: "Tu dois accepter les conditions pour créer ton compte.",
      );
      return;
    }

    if (_loading) return;

    final sb = Supabase.instance.client;
    final email = _emailCtrl.text.trim();
    final password = _pwdCtrl.text;

    setState(() => _loading = true);

    try {
      debugPrint('SIGNUP start -> email=$email');

      final res = await sb.auth.signUp(
        email: email,
        password: password,
        data: {'app': 'COPIQ', 'created_from': 'flutter'},
      );

      debugPrint(
        'SIGNUP success -> user=${res.user?.id} session=${res.session != null}',
      );

      if (!mounted) return;

      AppNotifier.success(
        context,
        title: "Compte créé",
        message:
            "Vérifie ta boîte mail pour activer le compte, puis reconnecte-toi.",
      );

      widget.onSignedUp?.call(email, password);
    } on AuthException catch (e, st) {
      debugPrint('SIGNUP AuthException -> message=${e.message}');
      debugPrint('SIGNUP AuthException -> statusCode=${e.statusCode}');
      debugPrint('SIGNUP AuthException -> stack=$st');

      if (!mounted) return;

      final msg = e.message.toLowerCase();
      final isAlready =
          msg.contains('already registered') ||
          msg.contains('user already registered') ||
          msg.contains('user_already_exists') ||
          msg.contains('already exists');

      if (isAlready) {
        AppNotifier.warning(
          context,
          title: "E-mail déjà utilisé",
          message:
              "Un compte existe déjà avec cette adresse. Connecte-toi ou réinitialise ton mot de passe.",
        );

        await _pc.animateToPage(
          1,
          duration: const Duration(milliseconds: 320),
          curve: Curves.easeOutCubic,
        );
      } else {
        AppNotifier.error(
          context,
          title: "Création impossible",
          message: e.message.isNotEmpty
              ? e.message
              : "Erreur de création du compte.",
        );
      }
    } catch (e, st) {
      debugPrint('SIGNUP unexpected error -> $e');
      debugPrint('SIGNUP unexpected stack -> $st');

      if (!mounted) return;
      AppNotifier.error(
        context,
        title: "Oups",
        message: "Une erreur inattendue est survenue : $e",
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _refuseTermsAndExit() {
    HapticFeedback.selectionClick();
    setState(() => _refusedOnce = true);

    AppNotifier.error(
      context,
      title: "Refus des conditions",
      message: "Les conditions doivent être acceptées pour utiliser COP’IQ. ",
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil('/onboarding', (r) => false);
    });
  }

  // ---------- UI ----------
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

        final bg = isDark ? _kDarkNavy : _kBlueLight;
        final ctaFg = isDark ? _kDarkNavy : _kBlueLight;

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
                          Colors.black.withOpacity(0.30),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: LayoutBuilder(
                  builder: (context, c) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(14, 10, 14, 6),
                          child: Row(
                            children: [
                              _TopBackPill(enabled: _index > 0, onTap: _goPrev),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _DropletProgress(
                                  count: _steps,
                                  index: _index,
                                ),
                              ),
                              const SizedBox(width: 10),
                            ],
                          ),
                        ),

                        // zone pages
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(18, 10, 18, 10),
                            child: PageView(
                              controller: _pc,
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                _WelcomeStep(h1: _h1(), p: _p()),

                                _EmailStep(
                                  h1: _h1(),
                                  p: _p(),
                                  isDark: isDark,
                                  emailCtrl: _emailCtrl,
                                  email2Ctrl: _email2Ctrl,
                                  fnEmail: _fnEmail,
                                  fnEmail2: _fnEmail2,
                                  validateEmail: _validateEmail,
                                  checkEmailAvailability:
                                      _checkEmailAvailability,
                                  emailAvailable: _emailAvailable,
                                  checkingEmail: _checkingEmail,
                                  // si ton widget le supporte, tu peux aussi lui passer:
                                  // takenMsg: _emailTakenMsg,
                                ),

                                _PasswordStep(
                                  h1: _h1(),
                                  p: _p(),
                                  isDark: isDark,
                                  pwdCtrl: _pwdCtrl,
                                  pwd2Ctrl: _pwd2Ctrl,
                                  fnPwd: _fnPwd,
                                  fnPwd2: _fnPwd2,
                                  obscure1: _obscure1,
                                  obscure2: _obscure2,
                                  onToggle1: () {
                                    HapticFeedback.selectionClick();
                                    setState(() => _obscure1 = !_obscure1);
                                  },
                                  onToggle2: () {
                                    HapticFeedback.selectionClick();
                                    setState(() => _obscure2 = !_obscure2);
                                  },
                                  validatePwd: _validatePwd,
                                  validatePwd2: _validatePwd2,
                                ),

                                _TermsStep(
                                  h1: _h1(),
                                  p: _p(),
                                  isDark: isDark,
                                  accepted: _acceptTerms,
                                  onAcceptToggle: (v) {
                                    setState(() => _acceptTerms = v);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),

                        // bottom sticky area
                        Padding(
                          padding: const EdgeInsets.fromLTRB(18, 0, 18, 14),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (_index < _steps - 1) ...[
                                _LockedContinueButton(
                                  enabled: _stepValid,
                                  isDark: isDark,
                                  foreground: ctaFg,
                                  onPressed: _goNext,
                                ),
                              ] else ...[
                                Row(
                                  children: [
                                    Expanded(
                                      child: _ChoiceButton(
                                        label: "Refuser",
                                        kind: _ChoiceKind.danger,
                                        onPressed: _loading
                                            ? null
                                            : _refuseTermsAndExit,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: _ChoiceButton(
                                        label: _loading
                                            ? "Création..."
                                            : "Accepter",
                                        kind: _ChoiceKind.success,
                                        onPressed: (_loading || !_acceptTerms)
                                            ? null
                                            : _submit,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                              const SizedBox(height: 10),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Déjà un compte ? ",
                                    style: GoogleFonts.montserrat(
                                      color: _whiteA(.85),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      HapticFeedback.selectionClick();
                                      Navigator.of(context).pushNamed('/login');
                                    },
                                    child: Text(
                                      "Se connecter",
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
                      ],
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
            color: Colors.white.withOpacity(0.10),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: Colors.white.withOpacity(0.14)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.chevron_left_rounded,
                color: Colors.white.withOpacity(0.9),
                size: 18,
              ),
              const SizedBox(width: 2),
              Text(
                "Précédent",
                style: GoogleFonts.montserrat(
                  color: Colors.white.withOpacity(0.90),
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

class _DropletProgress extends StatelessWidget {
  const _DropletProgress({required this.count, required this.index});
  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 10,
      child: Row(
        children: List.generate(count, (i) {
          final active = i <= index;
          final w = (i == index) ? 26.0 : 16.0;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            width: w,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              color: active
                  ? Colors.white.withOpacity(0.90)
                  : Colors.white.withOpacity(0.22),
              boxShadow: active
                  ? [
                      BoxShadow(
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                        color: Colors.black.withOpacity(0.14),
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

class _WelcomeStep extends StatelessWidget {
  const _WelcomeStep({required this.h1, required this.p});
  final TextStyle h1;
  final TextStyle p;

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
                "Tu t’apprêtes à créer ton compte COP’IQ.\nOn va le faire en 1 minute, étape par étape.",
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
                    "Chaque étape est vérifiée automatiquement",
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
          ],
        ),
      ),
    );
  }
}

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

class _EmailStep extends StatefulWidget {
  const _EmailStep({
    required this.h1,
    required this.p,
    required this.isDark,
    required this.emailCtrl,
    required this.email2Ctrl,
    required this.fnEmail,
    required this.fnEmail2,
    required this.validateEmail,
    // ⬇️ NOUVEAUX PARAMÈTRES
    required this.checkEmailAvailability,
    required this.emailAvailable,
    required this.checkingEmail,
  });

  final TextStyle h1;
  final TextStyle p;
  final bool isDark;

  final TextEditingController emailCtrl;
  final TextEditingController email2Ctrl;
  final FocusNode fnEmail;
  final FocusNode fnEmail2;

  final String? Function(String?) validateEmail;

  // 🔐 NOUVEAU
  final Future<void> Function(String email) checkEmailAvailability;
  final bool?
  emailAvailable; // null = inconnu / true = ok / false = déjà utilisé
  final bool checkingEmail;

  @override
  State<_EmailStep> createState() => _EmailStepState();
}

class _EmailStepState extends State<_EmailStep> {
  @override
  void initState() {
    super.initState();

    widget.emailCtrl.addListener(_onEmailChange);
    widget.email2Ctrl.addListener(_onEmailChange);
  }

  @override
  void dispose() {
    widget.emailCtrl.removeListener(_onEmailChange);
    widget.email2Ctrl.removeListener(_rebuild);
    super.dispose();
  }

  void _rebuild() {
    if (mounted) setState(() {});
  }

  void _onEmailChange() {
    final email = widget.emailCtrl.text.trim();

    if (widget.validateEmail(email) == null) {
      widget.checkEmailAvailability(email);
    }

    _rebuild();
  }

  bool get _emailsFilled =>
      widget.emailCtrl.text.trim().isNotEmpty &&
      widget.email2Ctrl.text.trim().isNotEmpty;

  bool get _emailsMatch =>
      widget.emailCtrl.text.trim() == widget.email2Ctrl.text.trim();

  bool get _emailFormatOk =>
      widget.validateEmail(widget.emailCtrl.text) == null;

  bool get _emailAvailable => widget.emailAvailable == true;

  @override
  Widget build(BuildContext context) {
    final ok =
        _emailsFilled &&
        _emailsMatch &&
        _emailFormatOk &&
        widget.emailAvailable == true;

    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 18, 10, 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Ton e-mail",
              textAlign: TextAlign.center,
              style: widget.h1.copyWith(fontSize: 24),
            ),
            const SizedBox(height: 10),

            Text(
              "On vérifie automatiquement qu’il est valide et disponible.",
              textAlign: TextAlign.center,
              style: widget.p,
            ),
            const SizedBox(height: 18),

            _GlowField(
              label: "Email",
              hint: "email@exemple.com",
              isDark: widget.isDark,
              controller: widget.emailCtrl,
              focusNode: widget.fnEmail,
              validator: widget.validateEmail,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              onSubmitted: (_) => widget.fnEmail2.requestFocus(),
            ),
            const SizedBox(height: 12),

            _GlowField(
              label: "Confirme l’email",
              hint: "Retape le même email",
              isDark: widget.isDark,
              controller: widget.email2Ctrl,
              focusNode: widget.fnEmail2,
              validator: (v) {
                if ((v ?? '').trim().isEmpty) {
                  return "Confirme ton email.";
                }
                if (!_emailsMatch) {
                  return "Les emails ne correspondent pas.";
                }
                return null;
              },
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 14),

            // 🔐 FEEDBACK EMAIL (SIMPLE + BLOQUANT)
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              child: widget.checkingEmail
                  ? const _EmailLoadingPill()
                  : _emailsFilled
                  ? _EmailAvailabilityPill(
                      ok: ok,
                      emailAvailable: widget.emailAvailable,
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmailLoadingPill extends StatelessWidget {
  const _EmailLoadingPill();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 56,
      child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
    );
  }
}

class _EmailAvailabilityPill extends StatelessWidget {
  const _EmailAvailabilityPill({
    required this.ok,
    required this.emailAvailable,
  });

  final bool ok;
  final bool? emailAvailable;

  @override
  Widget build(BuildContext context) {
    final isAvailable = emailAvailable == true;
    final isTaken = emailAvailable == false;
    final isUnknown = emailAvailable == null;

    final color = ok
        ? const Color(0xFF2AE08A)
        : isTaken
        ? const Color(0xFFFF5A5F)
        : Colors.white70;

    final text = isAvailable
        ? "Email valide et disponible"
        : isTaken
        ? "Cet email est déjà utilisé"
        : "Vérification de l’email…";

    return SizedBox(
      height: 56,
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.6)),
          color: Colors.white.withOpacity(0.06),
        ),
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.montserrat(
              color: color,
              fontWeight: FontWeight.w900,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}

class _EmailStatusPill extends StatefulWidget {
  const _EmailStatusPill({
    super.key,
    required this.ok,
    required this.a,
    required this.b,
  });

  final bool ok;
  final String a;
  final String b;

  @override
  State<_EmailStatusPill> createState() => _EmailStatusPillState();
}

class _EmailStatusPillState extends State<_EmailStatusPill>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  );

  late final Animation<double> _t = CurvedAnimation(
    parent: _pulse,
    curve: Curves.easeInOut,
  );

  @override
  void initState() {
    super.initState();
    if (widget.ok) _pulse.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(covariant _EmailStatusPill oldWidget) {
    super.didUpdateWidget(oldWidget);

    // start/stop pulse depending on ok
    if (oldWidget.ok != widget.ok) {
      if (widget.ok) {
        _pulse.repeat(reverse: true);
      } else {
        _pulse.stop();
        _pulse.value = 0;
      }
    }
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const okColor = Color(0xFF2AE08A);
    const badColor = Color(0xFFFFB4B4);

    final isOk = widget.ok;

    final color = isOk ? okColor : badColor;
    final icon = isOk ? Icons.check_circle_rounded : Icons.info_outline_rounded;

    final text = isOk
        ? "Email confirmé"
        : (widget.a.isEmpty || widget.b.isEmpty)
        ? "Renseigne les deux emails"
        : "Les emails ne correspondent pas";

    // Same size as Continue button
    const h = 56.0;
    const radius = 16.0;

    return AnimatedBuilder(
      animation: _t,
      builder: (_, __) {
        // Pulse only when OK
        final pulse = isOk ? _t.value : 0.0;

        final borderOpacity = isOk ? (0.55 + 0.25 * pulse) : 0.55;
        final bgOpacity = isOk ? (0.06 + 0.05 * pulse) : 0.08;

        // subtle bloom/glow when OK
        final glowOpacity = isOk ? (0.10 + 0.18 * pulse) : 0.0;

        return SizedBox(
          height: h,
          width: double.infinity,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(bgOpacity),
              borderRadius: BorderRadius.circular(radius),
              border: Border.all(color: color.withOpacity(borderOpacity)),
              boxShadow: [
                if (isOk)
                  BoxShadow(
                    blurRadius: 22,
                    spreadRadius: 0.5,
                    offset: const Offset(0, 10),
                    color: okColor.withOpacity(glowOpacity),
                  ),
                BoxShadow(
                  blurRadius: 16,
                  offset: const Offset(0, 10),
                  color: Colors.black.withOpacity(0.14),
                ),
              ],
            ),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 20, color: color),
                  const SizedBox(width: 10),
                  Text(
                    text,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      color: Colors.white.withOpacity(0.92),
                      fontWeight: FontWeight.w900,
                      fontSize: 14.2,
                      height: 1.0,
                      letterSpacing: -0.1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _PasswordStep extends StatefulWidget {
  const _PasswordStep({
    required this.h1,
    required this.p,
    required this.isDark,
    required this.pwdCtrl,
    required this.pwd2Ctrl,
    required this.fnPwd,
    required this.fnPwd2,
    required this.obscure1,
    required this.obscure2,
    required this.onToggle1,
    required this.onToggle2,
    required this.validatePwd,
    required this.validatePwd2,
  });

  final TextStyle h1;
  final TextStyle p;
  final bool isDark;

  final TextEditingController pwdCtrl;
  final TextEditingController pwd2Ctrl;
  final FocusNode fnPwd;
  final FocusNode fnPwd2;

  final bool obscure1;
  final bool obscure2;

  final VoidCallback onToggle1;
  final VoidCallback onToggle2;

  final String? Function(String?) validatePwd;
  final String? Function(String?) validatePwd2;

  @override
  State<_PasswordStep> createState() => _PasswordStepState();
}

class _PasswordStepState extends State<_PasswordStep> {
  @override
  void initState() {
    super.initState();
    widget.pwdCtrl.addListener(_rebuild);
    widget.pwd2Ctrl.addListener(_rebuild);
  }

  @override
  void dispose() {
    widget.pwdCtrl.removeListener(_rebuild);
    widget.pwd2Ctrl.removeListener(_rebuild);
    super.dispose();
  }

  void _rebuild() {
    if (mounted) setState(() {});
  }

  bool get _pwdOk => widget.validatePwd(widget.pwdCtrl.text) == null;
  bool get _pwd2Ok => widget.validatePwd2(widget.pwd2Ctrl.text) == null;
  bool get _bothFilled =>
      widget.pwdCtrl.text.isNotEmpty && widget.pwd2Ctrl.text.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final showStatus = _bothFilled;
    final ok = showStatus && _pwdOk && _pwd2Ok;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.fromLTRB(10, 18, 10, 12),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _FadeSlideIn(
                      delay: const Duration(milliseconds: 0),
                      child: Text(
                        "Ton mot de passe",
                        textAlign: TextAlign.center,
                        style: widget.h1.copyWith(fontSize: 24, height: 1.06),
                      ),
                    ),
                    const SizedBox(height: 10),

                    _FadeSlideIn(
                      delay: const Duration(milliseconds: 90),
                      child: Text(
                        "Sécurise ton compte en validant chaque critère.",
                        textAlign: TextAlign.center,
                        style: widget.p.copyWith(fontSize: 14.2, height: 1.45),
                      ),
                    ),
                    const SizedBox(height: 18),

                    _FadeSlideIn(
                      delay: const Duration(milliseconds: 160),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _GlowField(
                            label: "Mot de passe",
                            hint: "••••••••",
                            isDark: widget.isDark,
                            controller: widget.pwdCtrl,
                            focusNode: widget.fnPwd,
                            validator: widget.validatePwd,
                            obscureText: widget.obscure1,
                            suffix: IconButton(
                              onPressed: widget.onToggle1,
                              icon: Icon(
                                widget.obscure1
                                    ? Icons.visibility_off_rounded
                                    : Icons.visibility_rounded,
                                color: Colors.white.withOpacity(0.85),
                              ),
                            ),
                            textInputAction: TextInputAction.next,
                            onSubmitted: (_) => widget.fnPwd2.requestFocus(),
                          ),

                          const SizedBox(height: 12),

                          _PasswordLiveRules(
                            controller: widget.pwdCtrl,
                            minLen: 8,
                          ),

                          const SizedBox(height: 14),

                          _GlowField(
                            label: "Confirme le mot de passe",
                            hint: "••••••••",
                            isDark: widget.isDark,
                            controller: widget.pwd2Ctrl,
                            focusNode: widget.fnPwd2,
                            validator: widget.validatePwd2,
                            obscureText: widget.obscure2,
                            suffix: IconButton(
                              onPressed: widget.onToggle2,
                              icon: Icon(
                                widget.obscure2
                                    ? Icons.visibility_off_rounded
                                    : Icons.visibility_rounded,
                                color: Colors.white.withOpacity(0.85),
                              ),
                            ),
                            textInputAction: TextInputAction.done,
                          ),

                          const SizedBox(height: 14),

                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 180),
                            switchInCurve: Curves.easeOutCubic,
                            switchOutCurve: Curves.easeOutCubic,
                            child: !showStatus
                                ? const SizedBox.shrink()
                                : _PasswordStatusPill(
                                    key: ValueKey(ok),
                                    ok: ok,
                                    mismatch:
                                        widget.pwd2Ctrl.text.isNotEmpty &&
                                        !_pwd2Ok,
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _PasswordLiveRules extends StatelessWidget {
  const _PasswordLiveRules({required this.controller, this.minLen = 8});

  final TextEditingController controller;
  final int minLen;

  bool _hasUpper(String s) => RegExp(r'[A-Z]').hasMatch(s);
  bool _hasLower(String s) => RegExp(r'[a-z]').hasMatch(s);
  bool _hasDigit(String s) => RegExp(r'[0-9]').hasMatch(s);

  // ✅ regex safe (pas de quote qui casse)
  bool _hasSpecial(String s) =>
      RegExp(r'[!@#$%^&*(),.?":{}|<>_\-\[\]\\\/+=~`;]').hasMatch(s);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        final s = controller.text;

        final okLen = s.length >= minLen;
        final okUpper = _hasUpper(s);
        final okLower = _hasLower(s);
        final okDigit = _hasDigit(s);
        final okSpec = _hasSpecial(s);

        return Container(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.07),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.12)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Critères de sécurité",
                style: GoogleFonts.montserrat(
                  color: Colors.white.withOpacity(0.92),
                  fontWeight: FontWeight.w900,
                  fontSize: 12.6,
                  letterSpacing: -0.1,
                ),
              ),
              const SizedBox(height: 10),

              _RuleLine(ok: okLen, text: "$minLen caractères minimum"),
              _RuleLine(ok: okUpper, text: "1 majuscule (A-Z)"),
              _RuleLine(ok: okLower, text: "1 minuscule (a-z)"),
              _RuleLine(ok: okDigit, text: "1 chiffre (0-9)"),
              _RuleLine(ok: okSpec, text: "1 caractère spécial (!@#...)"),
            ],
          ),
        );
      },
    );
  }
}

class _PasswordStatusPill extends StatefulWidget {
  const _PasswordStatusPill({
    super.key,
    required this.ok,
    required this.mismatch,
  });

  final bool ok;
  final bool mismatch;

  @override
  State<_PasswordStatusPill> createState() => _PasswordStatusPillState();
}

class _PasswordStatusPillState extends State<_PasswordStatusPill>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  );

  late final Animation<double> _t = CurvedAnimation(
    parent: _pulse,
    curve: Curves.easeInOut,
  );

  @override
  void initState() {
    super.initState();
    if (widget.ok) _pulse.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(covariant _PasswordStatusPill oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.ok != widget.ok) {
      if (widget.ok) {
        _pulse.repeat(reverse: true);
      } else {
        _pulse.stop();
        _pulse.value = 0;
      }
    }
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const okColor = Color(0xFF2AE08A);
    const badColor = Color(0xFFFFB4B4);

    final isOk = widget.ok;

    final color = isOk ? okColor : badColor;
    final icon = isOk ? Icons.check_circle_rounded : Icons.info_outline_rounded;

    final text = isOk
        ? "Mot de passe validé"
        : widget.mismatch
        ? "Les mots de passe ne correspondent pas"
        : "Complète tous les critères";

    const h = 56.0;
    const radius = 16.0;

    return AnimatedBuilder(
      animation: _t,
      builder: (_, __) {
        final pulse = isOk ? _t.value : 0.0;

        final borderOpacity = isOk ? (0.55 + 0.25 * pulse) : 0.55;
        final bgOpacity = isOk ? (0.06 + 0.05 * pulse) : 0.08;
        final glowOpacity = isOk ? (0.10 + 0.18 * pulse) : 0.0;

        return SizedBox(
          height: h,
          width: double.infinity,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(bgOpacity),
              borderRadius: BorderRadius.circular(radius),
              border: Border.all(color: color.withOpacity(borderOpacity)),
              boxShadow: [
                if (isOk)
                  BoxShadow(
                    blurRadius: 22,
                    spreadRadius: 0.5,
                    offset: const Offset(0, 10),
                    color: okColor.withOpacity(glowOpacity),
                  ),
                BoxShadow(
                  blurRadius: 16,
                  offset: const Offset(0, 10),
                  color: Colors.black.withOpacity(0.14),
                ),
              ],
            ),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 20, color: color),
                  const SizedBox(width: 10),
                  Text(
                    text,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      color: Colors.white.withOpacity(0.92),
                      fontWeight: FontWeight.w900,
                      fontSize: 14.2,
                      height: 1.0,
                      letterSpacing: -0.1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _RuleLine extends StatelessWidget {
  const _RuleLine({required this.ok, required this.text});

  final bool ok;
  final String text;

  @override
  Widget build(BuildContext context) {
    final okColor = const Color(0xFF2AE08A);
    final offColor = Colors.white.withOpacity(0.78);
    final border = Colors.white.withOpacity(0.18);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      curve: Curves.easeOutCubic,
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            curve: Curves.easeOutCubic,
            height: 18,
            width: 18,
            decoration: BoxDecoration(
              color: ok
                  ? okColor.withOpacity(0.18)
                  : Colors.white.withOpacity(0.06),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: ok ? okColor.withOpacity(0.70) : border,
              ),
            ),
            child: Icon(
              ok ? Icons.check_rounded : Icons.circle_outlined,
              size: 14,
              color: ok ? okColor : Colors.white.withOpacity(0.45),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 160),
              curve: Curves.easeOutCubic,
              style: GoogleFonts.montserrat(
                color: ok ? okColor : offColor,
                fontWeight: ok ? FontWeight.w800 : FontWeight.w700,
                fontSize: 12.8,
                height: 1.15,
              ),
              child: Text(text),
            ),
          ),
        ],
      ),
    );
  }
}

class _TermsStep extends StatefulWidget {
  const _TermsStep({
    required this.h1,
    required this.p,
    required this.isDark,
    required this.accepted,
    required this.onAcceptToggle,
  });

  final TextStyle h1;
  final TextStyle p;
  final bool isDark;

  final bool accepted;
  final ValueChanged<bool> onAcceptToggle;

  @override
  State<_TermsStep> createState() => _TermsStepState();
}

class _TermsStepState extends State<_TermsStep> {
  final ScrollController _scrollCtrl = ScrollController();
  bool _reachedBottom = false;

  @override
  void initState() {
    super.initState();
    _scrollCtrl.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollCtrl.position.pixels >=
        _scrollCtrl.position.maxScrollExtent - 8) {
      if (!_reachedBottom) {
        setState(() => _reachedBottom = true);
        widget.onAcceptToggle(true); // ✅ autorise le bouton vert du bas
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 18, 12, 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Conditions",
              textAlign: TextAlign.center,
              style: widget.h1.copyWith(fontSize: 24),
            ),
            const SizedBox(height: 10),

            Text(
              "Merci de lire attentivement les conditions avant de continuer.",
              textAlign: TextAlign.center,
              style: widget.p,
            ),
            const SizedBox(height: 18),

            // ✅ ZONE BLANCHE FIXE
            Container(
              height: 260,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                    color: Colors.black.withOpacity(0.18),
                  ),
                ],
              ),
              child: Scrollbar(
                thumbVisibility: true,
                child: SingleChildScrollView(
                  controller: _scrollCtrl,
                  child: Text(
                    // 🔧 TU METTRAS LE VRAI TEXTE PLUS TARD
                    List.generate(
                      25,
                      (_) =>
                          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. "
                          "Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n\n",
                    ).join(),
                    style: GoogleFonts.montserrat(
                      color: Colors.black87,
                      fontSize: 13.8,
                      height: 1.45,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: _reachedBottom ? 1 : 0.6,
              child: Text(
                _reachedBottom
                    ? "Conditions lues ✔"
                    : "Fais défiler jusqu’en bas pour continuer",
                style: GoogleFonts.montserrat(
                  color: _reachedBottom
                      ? const Color(0xFF1FE08A)
                      : Colors.white70,
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DualChoiceRow extends StatelessWidget {
  const _DualChoiceRow({required this.onAccept, required this.onRefuse});

  final VoidCallback onAccept;
  final VoidCallback onRefuse;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ChoiceCta(
            label: "Je refuse",
            kind: _ChoiceKind.danger,
            onTap: onRefuse,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _ChoiceCta(
            label: "J’accepte",
            kind: _ChoiceKind.success,
            onTap: onAccept,
          ),
        ),
      ],
    );
  }
}

enum _ChoiceKind { success, danger }

class _ChoiceCta extends StatefulWidget {
  const _ChoiceCta({
    required this.label,
    required this.kind,
    required this.onTap,
  });

  final String label;
  final _ChoiceKind kind;
  final VoidCallback onTap;

  @override
  State<_ChoiceCta> createState() => _ChoiceCtaState();
}

class _ChoiceCtaState extends State<_ChoiceCta> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    final bg = widget.kind == _ChoiceKind.success
        ? const Color(0xFF1FE08A)
        : const Color(0xFFFF5A5F);

    final fg = widget.kind == _ChoiceKind.success
        ? const Color(0xFF0B2A1E)
        : const Color(0xFF3A0C0E);

    final scale = _down ? 0.985 : 1.0;

    return Listener(
      onPointerDown: (_) => setState(() => _down = true),
      onPointerUp: (_) => setState(() => _down = false),
      onPointerCancel: (_) => setState(() => _down = false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 110),
        curve: Curves.easeOut,
        scale: scale,
        child: SizedBox(
          height: 56,
          child: ElevatedButton(
            onPressed: widget.onTap,
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
                fontSize: 15.5,
                letterSpacing: -0.1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TermsStatusPill extends StatefulWidget {
  const _TermsStatusPill({super.key, required this.ok, required this.text});

  final bool ok;
  final String text;

  @override
  State<_TermsStatusPill> createState() => _TermsStatusPillState();
}

class _TermsStatusPillState extends State<_TermsStatusPill>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  );

  late final Animation<double> _t = CurvedAnimation(
    parent: _pulse,
    curve: Curves.easeInOut,
  );

  @override
  void initState() {
    super.initState();
    if (widget.ok) _pulse.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(covariant _TermsStatusPill oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.ok != widget.ok) {
      if (widget.ok) {
        _pulse.repeat(reverse: true);
      } else {
        _pulse.stop();
        _pulse.value = 0;
      }
    }
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const okColor = Color(0xFF2AE08A);
    const badColor = Color(0xFFFFB4B4);

    final isOk = widget.ok;
    final color = isOk ? okColor : badColor;
    final icon = isOk ? Icons.check_circle_rounded : Icons.info_outline_rounded;

    const h = 56.0;
    const radius = 16.0;

    return AnimatedBuilder(
      animation: _t,
      builder: (_, __) {
        final pulse = isOk ? _t.value : 0.0;
        final borderOpacity = isOk ? (0.55 + 0.25 * pulse) : 0.55;
        final bgOpacity = isOk ? (0.06 + 0.05 * pulse) : 0.08;
        final glowOpacity = isOk ? (0.10 + 0.18 * pulse) : 0.0;

        return SizedBox(
          height: h,
          width: double.infinity,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(bgOpacity),
              borderRadius: BorderRadius.circular(radius),
              border: Border.all(color: color.withOpacity(borderOpacity)),
              boxShadow: [
                if (isOk)
                  BoxShadow(
                    blurRadius: 22,
                    spreadRadius: 0.5,
                    offset: const Offset(0, 10),
                    color: okColor.withOpacity(glowOpacity),
                  ),
                BoxShadow(
                  blurRadius: 16,
                  offset: const Offset(0, 10),
                  color: Colors.black.withOpacity(0.14),
                ),
              ],
            ),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 20, color: color),
                  const SizedBox(width: 10),
                  Text(
                    widget.text,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      color: Colors.white.withOpacity(0.92),
                      fontWeight: FontWeight.w900,
                      fontSize: 14.2,
                      height: 1.0,
                      letterSpacing: -0.1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Bullet extends StatelessWidget {
  const _Bullet({required this.text, required this.opacity});
  final String text;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(opacity),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.montserrat(
              color: Colors.white.withOpacity(opacity),
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }
}

class _GlowField extends StatefulWidget {
  const _GlowField({
    required this.label,
    required this.hint,
    required this.isDark,
    required this.controller,
    required this.focusNode,
    required this.validator,
    this.keyboardType,
    this.textInputAction,
    this.onSubmitted,
    this.obscureText = false,
    this.suffix,
  });

  final String label;
  final String hint;
  final bool isDark;
  final TextEditingController controller;
  final FocusNode focusNode;
  final String? Function(String?) validator;

  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;

  final bool obscureText;
  final Widget? suffix;

  @override
  State<_GlowField> createState() => _GlowFieldState();
}

class _GlowFieldState extends State<_GlowField> {
  bool _touched = false;
  String? _error;

  Color _whiteA(double o) => Color.fromRGBO(255, 255, 255, o);

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onChange);
    widget.focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onChange);
    widget.focusNode.removeListener(_onFocusChange);
    super.dispose();
  }

  void _onFocusChange() {
    if (!mounted) return;
    if (!widget.focusNode.hasFocus) {
      // quand on sort du champ : on force une validation douce
      _markTouched();
    }
    setState(() {});
  }

  void _onChange() {
    if (!_touched) return;
    final msg = widget.validator(widget.controller.text);
    if (msg != _error && mounted) setState(() => _error = msg);
  }

  void _markTouched() {
    if (_touched) {
      final msg = widget.validator(widget.controller.text);
      if (msg != _error && mounted) setState(() => _error = msg);
      return;
    }
    setState(() {
      _touched = true;
      _error = widget.validator(widget.controller.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    final focused = widget.focusNode.hasFocus;

    final fill = widget.isDark
        ? const Color(0xFF0F1F4A)
        : const Color(0xFF1A3FBA);
    final border = widget.isDark
        ? const Color(0xFF2F3C69)
        : const Color(0xFF355BE0);

    // Glow super léger
    final glowColor = Colors.white.withOpacity(widget.isDark ? 0.12 : 0.16);

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

        AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: focused
                ? [
                    BoxShadow(
                      blurRadius: 18,
                      spreadRadius: 1,
                      offset: const Offset(0, 6),
                      color: glowColor,
                    ),
                  ]
                : [],
          ),
          child: TextFormField(
            controller: widget.controller,
            focusNode: widget.focusNode,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            onTap: _markTouched,
            onChanged: (_) => _markTouched(),
            onFieldSubmitted: widget.onSubmitted,
            obscureText: widget.obscureText,
            style: GoogleFonts.montserrat(fontSize: 15, color: Colors.white),
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: GoogleFonts.montserrat(color: _whiteA(.55)),
              filled: true,
              fillColor: fill,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: border.withOpacity(0.70)),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white, width: 1.2),
                borderRadius: BorderRadius.circular(12),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color(0xFFFFB4B4)),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Color(0xFFFFB4B4),
                  width: 1.2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              suffixIcon: widget.suffix,
            ),
            validator: widget.validator,
            autovalidateMode: AutovalidateMode.disabled,
          ),
        ),

        // Validation inline douce
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
                              fontWeight: FontWeight.w700,
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

class _LockedContinueButton extends StatefulWidget {
  const _LockedContinueButton({
    required this.enabled,
    required this.isDark,
    required this.foreground,
    required this.onPressed,
  });

  final bool enabled;
  final bool isDark;
  final Color foreground;
  final VoidCallback onPressed;

  @override
  State<_LockedContinueButton> createState() => _LockedContinueButtonState();
}

class _LockedContinueButtonState extends State<_LockedContinueButton> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    final scale = _down ? 0.985 : 1.0;

    final disabledBg = widget.isDark
        ? const Color(0xFF1E2A55)
        : const Color(0xFFD9DDE7);
    final disabledFg = widget.isDark
        ? const Color(0xFFB0B6C3)
        : const Color(0xFF6B7280);

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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!widget.enabled) ...[
                  Icon(Icons.lock_rounded, size: 18, color: fg),
                  const SizedBox(width: 10),
                ],
                Text(
                  "Continuer",
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                    letterSpacing: -0.1,
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

class _ChoiceButton extends StatelessWidget {
  const _ChoiceButton({
    required this.label,
    required this.kind,
    required this.onPressed,
  });

  final String label;
  final _ChoiceKind kind;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final bg = switch (kind) {
      _ChoiceKind.success => const Color(0xFF1FE08A),
      _ChoiceKind.danger => const Color(0xFFFF5A5F),
    };

    final fg = switch (kind) {
      _ChoiceKind.success => const Color(0xFF0B2A1E),
      _ChoiceKind.danger => const Color(0xFF3A0C0E),
    };

    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: onPressed == null ? bg.withOpacity(0.45) : bg,
          foregroundColor: fg,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w900,
            fontSize: 15.5,
            letterSpacing: -0.1,
          ),
        ),
      ),
    );
  }
}

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
