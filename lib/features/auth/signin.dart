// lib/features/auth/signin.dart
// =============================================================================
//  COP'IQ — Page de connexion Premium
//  Design institutionnel Police Nationale : bleu nuit, carte blanche, stats.
//  Logique métier : Supabase signInWithPassword, SharedPreferences "remember me",
//  widget.onSignedIn callback, AppNotifier pour les messages.
// =============================================================================

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:copiqpolice/core/widgets/app_notifier.dart'
    show AppNotifier;

// =============================================================================
//  CONSTANTES COULEURS
// =============================================================================
class _C {
  // Overlay léger pour laisser le bâtiment respirer (~35-65%)
  static const bg1     = Color(0x59001B3F); // alpha 0x59 ≈ 35 %
  static const bg2     = Color(0x80002654); // alpha 0x80 ≈ 50 %
  static const bg3     = Color(0xA600122D); // alpha 0xA6 ≈ 65 %
  static const accent  = Color(0xFF0D47D9);
  static const accent2 = Color(0xFF2F80FF);
  static const red     = Color(0xFFED2939);
  static const white   = Colors.white;
  static const ink     = Color(0xFF0F172A);
  static const border  = Color(0xFFD8DEE9);
  static const grey    = Color(0xFF6B7280);
  static const divider = Color(0xFFE5E7EB);
  static const blue700 = Color(0xFF003399);
}

// =============================================================================
//  WIDGET PRINCIPAL
// =============================================================================
class SignInPage extends StatefulWidget {
  const SignInPage({super.key, this.onSignedIn});
  final VoidCallback? onSignedIn;

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey  = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _pwdCtrl   = TextEditingController();
  bool _loading    = false;
  bool _obscure    = true;
  bool _rememberMe = true;

  // ── SharedPreferences keys ──────────────────────────────────────────────
  static const _kRememberMeKey    = 'signin_remember_me';
  static const _kRememberEmailKey = 'signin_remember_email';

  @override
  void initState() {
    super.initState();
    _loadRememberMe();
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _pwdCtrl.dispose();
    super.dispose();
  }

  // ── Persistence ──────────────────────────────────────────────────────────
  Future<void> _loadRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    final remember = prefs.getBool(_kRememberMeKey) ?? true;
    final email    = prefs.getString(_kRememberEmailKey) ?? '';
    if (!mounted) return;
    setState(() => _rememberMe = remember);
    if (remember && email.isNotEmpty) {
      _emailCtrl.text = email;
    }
  }

  Future<void> _persistOnSuccess() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kRememberMeKey, _rememberMe);
    if (_rememberMe) {
      await prefs.setString(_kRememberEmailKey, _emailCtrl.text.trim());
    } else {
      await prefs.remove(_kRememberEmailKey);
    }
  }

  // ── Validation ──────────────────────────────────────────────────────────
  String? _validateEmail(String? v) {
    final s = v?.trim() ?? '';
    if (s.isEmpty) return 'Renseigne ton email.';
    if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(s)) {
      return 'Email invalide.';
    }
    return null;
  }

  String? _validatePassword(String? v) {
    if ((v ?? '').trim().isEmpty) return 'Renseigne ton mot de passe.';
    return null;
  }

  // ── Actions ─────────────────────────────────────────────────────────────
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    HapticFeedback.selectionClick();
    setState(() => _loading = true);

    try {
      final res = await Supabase.instance.client.auth.signInWithPassword(
        email: _emailCtrl.text.trim(),
        password: _pwdCtrl.text,
      );
      if (!mounted) return;
      if (res.user != null) {
        await _persistOnSuccess();
        HapticFeedback.mediumImpact();
        AppNotifier.success(
          context,
          title: 'Connexion réussie',
          message: 'Bon retour parmi nous !',
        );
        widget.onSignedIn?.call();
      }
    } on AuthException catch (e) {
      if (!mounted) return;
      final raw = e.message.toLowerCase();
      final msg = (raw.contains('invalid login credentials') ||
              raw.contains('invalid credentials'))
          ? 'Email ou mot de passe incorrect.'
          : e.message;
      AppNotifier.error(context, title: 'Connexion impossible', message: msg);
    } catch (_) {
      if (!mounted) return;
      AppNotifier.error(
        context,
        title: 'Erreur inattendue',
        message: 'Une erreur est survenue, réessaie dans un instant.',
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _forgotPassword() {
    HapticFeedback.selectionClick();
    Navigator.of(context).pushNamed('/reset-password');
  }

  void _goSignup() {
    HapticFeedback.selectionClick();
    Navigator.of(context).pushNamed('/signup');
  }

  // ── Build ────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final mq    = MediaQuery.of(context);
    // Hauteur réellement utilisable entre la safe area top et bottom
    final avail = mq.size.height - mq.padding.top - mq.padding.bottom;

    // Seuils ajustés pour couvrir les grands écrans (Pixel 9 Pro XL ≈ 920dp)
    final compact = avail < 750;   // petits téléphones
    final small   = avail < 960;   // tout le reste, y compris 920dp

    // Tailles 100% proportionnelles — rien ne dépasse jamais
    final logoSize  = (avail * 0.13).clamp(80.0, 130.0);
    final titleSize = (avail * 0.042).clamp(26.0, 38.0);
    final vGap      = compact ? 5.0 : (small ? 8.0 : 12.0);
    final topPad    = compact ? 12.0 : (small ? 18.0 : 26.0);
    final cardHPad  = compact ? 14.0 : 16.0;
    final cardVPad  = compact ? 12.0 : (small ? 16.0 : 20.0);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // ── Fond : image institutionnelle ────────────────────────────
          Positioned.fill(
            child: Image.asset(
              'assets/images/background_login.png',
              fit: BoxFit.cover,
            ),
          ),
          // ── Overlay dégradé bleu nuit ─────────────────────────────
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [_C.bg1, _C.bg2, _C.bg3],
                ),
              ),
            ),
          ),
          // ── Filigrane bouclier discret (haut droite) ──────────────
          Positioned(
            top: -24,
            right: -24,
            child: Opacity(
              opacity: 0.10,
              child: Icon(Icons.shield_rounded, size: 220, color: Colors.white),
            ),
          ),
          // ── Contenu — tout sur une page, zéro scroll ──────────────
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // ── Header ────────────────────────────────────────────
                _LoginHeader(
                  logoSize:  logoSize,
                  titleSize: titleSize,
                  vGap:      vGap,
                  topPad:    topPad,
                ),
                // ── Carte formulaire ──────────────────────────────────
                _LoginCard(
                  formKey:          _formKey,
                  emailCtrl:        _emailCtrl,
                  pwdCtrl:          _pwdCtrl,
                  loading:          _loading,
                  obscure:          _obscure,
                  rememberMe:       _rememberMe,
                  validateEmail:    _validateEmail,
                  validatePwd:      _validatePassword,
                  onToggleObscure:  () => setState(() => _obscure = !_obscure),
                  onToggleRemember: (v) =>
                      setState(() => _rememberMe = v ?? true),
                  onSubmit:         _submit,
                  onForgot:         _forgotPassword,
                  onSignup:         _goSignup,
                  cardHPad:         cardHPad,
                  cardVPad:         cardVPad,
                  compact:          compact,
                ),
                // ── Footer ────────────────────────────────────────────
                const _LoginFooter(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
//  HEADER
// =============================================================================
class _LoginHeader extends StatelessWidget {
  final double logoSize;
  final double titleSize;
  final double vGap;
  final double topPad;

  const _LoginHeader({
    required this.logoSize,
    required this.titleSize,
    required this.vGap,
    required this.topPad,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(28, topPad, 28, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Logo
          Image.asset(
            'assets/images/logo.png',
            width: logoSize,
            height: logoSize,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => Icon(
              Icons.shield_rounded,
              size: logoSize,
              color: Colors.white,
            ),
          ),
          SizedBox(height: vGap * 0.6),

          // "PRÉPARATION POLICE NATIONALE"
          Text(
            'PRÉPARATION POLICE NATIONALE',
            style: GoogleFonts.instrumentSans(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.white.withValues(alpha: 0.88),
              letterSpacing: 1.4,
            ),
          ),
          SizedBox(height: vGap),

          // Titre principal
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: GoogleFonts.instrumentSans(
                fontSize: titleSize,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                height: 1.05,
                letterSpacing: -0.5,
              ),
              children: const [
                TextSpan(text: 'Préparez votre carrière\ndans la '),
                TextSpan(
                  text: 'Police Nationale',
                  style: TextStyle(color: _C.accent2),
                ),
              ],
            ),
          ),
          SizedBox(height: vGap),

          // Séparateur tricolore
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _triBar(_C.accent2),
              const SizedBox(width: 7),
              _triBar(Colors.white),
              const SizedBox(width: 7),
              _triBar(_C.red),
            ],
          ),
          SizedBox(height: vGap * 0.8),

          // Sous-titre
          Text(
            'Cours, QCM, concours, scolarité et perfectionnement.',
            textAlign: TextAlign.center,
            style: GoogleFonts.instrumentSans(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.white.withValues(alpha: 0.78),
              height: 1.35,
            ),
          ),
          SizedBox(height: vGap),
        ],
      ),
    );
  }

  Widget _triBar(Color c) => Container(
        width: 34,
        height: 3,
        decoration: BoxDecoration(
          color: c,
          borderRadius: BorderRadius.circular(100),
        ),
      );
}

// =============================================================================
//  CARTE FORMULAIRE
// =============================================================================
class _LoginCard extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailCtrl;
  final TextEditingController pwdCtrl;
  final bool loading;
  final bool obscure;
  final bool rememberMe;
  final String? Function(String?) validateEmail;
  final String? Function(String?) validatePwd;
  final VoidCallback onToggleObscure;
  final ValueChanged<bool?> onToggleRemember;
  final VoidCallback onSubmit;
  final VoidCallback onForgot;
  final VoidCallback onSignup;
  final double cardHPad;
  final double cardVPad;
  final bool compact;

  const _LoginCard({
    required this.formKey,
    required this.emailCtrl,
    required this.pwdCtrl,
    required this.loading,
    required this.obscure,
    required this.rememberMe,
    required this.validateEmail,
    required this.validatePwd,
    required this.onToggleObscure,
    required this.onToggleRemember,
    required this.onSubmit,
    required this.onForgot,
    required this.onSignup,
    required this.cardHPad,
    required this.cardVPad,
    required this.compact,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: cardHPad),
      padding: EdgeInsets.fromLTRB(20, cardVPad, 20, cardVPad),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(34),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.22),
            blurRadius: 28,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Email ────────────────────────────────────────────────
            _LoginTextField(
              controller: emailCtrl,
              placeholder: 'Email',
              icon: Icons.mail_outline_rounded,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validator: validateEmail,
              compact: compact,
            ),
            SizedBox(height: compact ? 10 : 14),

            // ── Mot de passe ─────────────────────────────────────────
            _LoginTextField(
              controller: pwdCtrl,
              placeholder: 'Mot de passe',
              icon: Icons.lock_outline_rounded,
              obscure: obscure,
              textInputAction: TextInputAction.done,
              validator: validatePwd,
              onSubmitted: (_) => onSubmit(),
              compact: compact,
              suffixIcon: IconButton(
                icon: Icon(
                  obscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: _C.grey,
                  size: 21,
                ),
                onPressed: onToggleObscure,
              ),
            ),

            // ── Mot de passe oublié ───────────────────────────────────
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: onForgot,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.only(
                    top: compact ? 5 : 8,
                    bottom: 2,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Mot de passe oublié ?',
                  style: GoogleFonts.instrumentSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _C.accent,
                  ),
                ),
              ),
            ),
            SizedBox(height: compact ? 4 : 6),

            // ── Bouton Se connecter ───────────────────────────────────
            _PrimaryLoginButton(
              loading: loading,
              onPressed: loading ? null : onSubmit,
              compact: compact,
            ),
            SizedBox(height: compact ? 12 : 18),

            // ── Séparateur ou ─────────────────────────────────────────
            Row(
              children: [
                const Expanded(child: Divider(color: _C.divider, thickness: 1)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    'ou',
                    style: GoogleFonts.instrumentSans(
                      fontSize: 13,
                      color: _C.grey,
                    ),
                  ),
                ),
                const Expanded(child: Divider(color: _C.divider, thickness: 1)),
              ],
            ),
            SizedBox(height: compact ? 10 : 14),

            // ── Créer un compte ───────────────────────────────────────
            GestureDetector(
              onTap: onSignup,
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: GoogleFonts.instrumentSans(
                    fontSize: 14,
                    color: _C.grey,
                  ),
                  children: [
                    const TextSpan(text: 'Pas encore membre ? '),
                    TextSpan(
                      text: 'Créer un compte ',
                      style: const TextStyle(
                        color: _C.blue700,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const TextSpan(
                      text: '→',
                      style: TextStyle(
                        color: _C.blue700,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: compact ? 12 : 18),

            // ── Divider ───────────────────────────────────────────────
            const Divider(color: _C.divider, thickness: 1),
            SizedBox(height: compact ? 10 : 14),

            // ── Statistiques ─────────────────────────────────────────
            const _StatsRow(),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
//  CHAMP DE TEXTE
// =============================================================================
class _LoginTextField extends StatelessWidget {
  final TextEditingController controller;
  final String placeholder;
  final IconData icon;
  final bool obscure;
  final bool compact;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onSubmitted;
  final Widget? suffixIcon;

  const _LoginTextField({
    required this.controller,
    required this.placeholder,
    required this.icon,
    this.obscure = false,
    this.compact = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.validator,
    this.onSubmitted,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final vPad = compact ? 14.0 : 18.0;
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onFieldSubmitted: onSubmitted,
      validator: validator,
      style: GoogleFonts.instrumentSans(
        fontSize: 15,
        color: _C.ink,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        hintText: placeholder,
        hintStyle: GoogleFonts.instrumentSans(
          fontSize: 15,
          color: const Color(0xFF9CA3AF),
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Icon(icon, color: _C.grey, size: 20),
        ),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: vPad,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _C.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _C.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _C.accent, width: 1.8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _C.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _C.red, width: 1.8),
        ),
      ),
    );
  }
}

// =============================================================================
//  BOUTON PRINCIPAL
// =============================================================================
class _PrimaryLoginButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final bool loading;
  final bool compact;

  const _PrimaryLoginButton({
    required this.onPressed,
    required this.loading,
    this.compact = false,
  });

  @override
  State<_PrimaryLoginButton> createState() => _PrimaryLoginButtonState();
}

class _PrimaryLoginButtonState extends State<_PrimaryLoginButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onPressed?.call();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: Container(
          height: widget.compact ? 50 : 56,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF002654),
                Color(0xFF0039C7),
                Color(0xFF0D47D9),
              ],
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: _C.accent.withValues(alpha: 0.40),
                blurRadius: 30,
                spreadRadius: 1,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: widget.loading
              ? const Center(
                  child: SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.lock_open_rounded,
                      color: Colors.white,
                      size: 19,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Se connecter',
                      style: GoogleFonts.instrumentSans(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white,
                      size: 19,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

// =============================================================================
//  STATISTIQUES
// =============================================================================
class _StatsRow extends StatelessWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          _StatItem(
            icon: Icons.quiz_rounded,
            value: '+15 000',
            label: 'QCM',
          ),
          const VerticalDivider(color: _C.divider, thickness: 1, width: 1),
          _StatItem(
            icon: Icons.article_rounded,
            value: '+200',
            label: 'Fiches de révision',
          ),
          const VerticalDivider(color: _C.divider, thickness: 1, width: 1),
          _StatItem(
            icon: Icons.shield_rounded,
            value: 'Mises à jour',
            label: 'régulières',
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: _C.blue700, size: 22),
          const SizedBox(height: 5),
          Text(
            value,
            style: GoogleFonts.instrumentSans(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: _C.blue700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.instrumentSans(
              fontSize: 12,
              color: _C.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// =============================================================================
//  FOOTER
// =============================================================================
class _LoginFooter extends StatelessWidget {
  const _LoginFooter();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 12, 28, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.shield_outlined,
            size: 22,
            color: Colors.white.withValues(alpha: 0.80),
          ),
          const SizedBox(width: 8),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "COP'IQ © 2026",
                style: GoogleFonts.instrumentSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withValues(alpha: 0.85),
                ),
              ),
              Text(
                'Tous droits réservés',
                style: GoogleFonts.instrumentSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withValues(alpha: 0.65),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
