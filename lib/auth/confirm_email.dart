// lib/auth/confirm_email.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// ✅ Unique import pour le thème global (et AppNotifier si tu veux l'utiliser ailleurs)
import 'package:copiqpolice/core/widgets/app_notifier.dart'
    show AppSettingsController, AppNotifier;

class ConfirmEmailPage extends StatefulWidget {
  static const routeName = '/confirm-email';

  final String email;
  final String password;

  const ConfirmEmailPage({
    super.key,
    required this.email,
    required this.password,
  });

  @override
  State<ConfirmEmailPage> createState() => _ConfirmEmailPageState();
}

class _ConfirmEmailPageState extends State<ConfirmEmailPage>
    with SingleTickerProviderStateMixin {
  bool _checking = false;
  String? _error;

  late final AnimationController _ctl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 600),
  );
  late final Animation<double> _scale = CurvedAnimation(
    parent: _ctl,
    curve: Curves.elasticOut,
  );

  @override
  void dispose() {
    _ctl.dispose();
    super.dispose();
  }

  Future<void> _checkNow() async {
    if (_checking) return;
    setState(() {
      _checking = true;
      _error = null;
    });

    final sb = Supabase.instance.client;

    try {
      await sb.auth.signInWithPassword(
        email: widget.email,
        password: widget.password,
      );
      if (!mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil('/welcome', (r) => false);
    } on AuthException catch (e) {
      _error = e.message.isNotEmpty
          ? e.message
          : "Adresse e-mail non confirmée pour le moment.";
      _ctl
        ..reset()
        ..forward();
    } catch (_) {
      _error =
          "Impossible de vérifier pour l’instant. Réessaie dans quelques secondes.";
      _ctl
        ..reset()
        ..forward();
    } finally {
      if (mounted) setState(() => _checking = false);
    }
  }

  // Palettes
  static const Color _kBlueLight = Color(0xFF1147D9); // fond LIGHT
  static const Color _kDarkNavy = Color(0xFF000B36); // fond DARK (exigé)
  Color _whiteA(double o) => Color.fromRGBO(255, 255, 255, o);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppSettingsController.I.themeMode,
      builder: (_, mode, __) {
        final platformDark =
            Theme.of(context).brightness == Brightness.dark; // cas system
        final bool isDark = switch (mode) {
          ThemeMode.dark => true,
          ThemeMode.light => false,
          ThemeMode.system => platformDark,
        };

        // 👉 Fond exact selon le thème
        final Color pageBg = isDark ? _kDarkNavy : _kBlueLight;

        // Lisibilité
        final Color titleColor = Colors.white;
        final Color bodyColor = _whiteA(.95);
        final Color hintColor = _whiteA(.70);

        // Bouton : blanc, texte miroir du fond
        final Color buttonBg = Colors.white;
        final Color buttonFg = isDark ? _kDarkNavy : _kBlueLight;

        return Theme(
          data: Theme.of(context).copyWith(
            textTheme: GoogleFonts.montserratTextTheme(
              Theme.of(context).textTheme,
            ),
          ),
          child: Scaffold(
            backgroundColor: pageBg,
            body: SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 36, 24, 28),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/image.png', height: 250),
                        const SizedBox(height: 12),
                        Text(
                          "Confirme ton e-mail",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                            color: titleColor,
                            fontWeight: FontWeight.w800,
                            fontSize: 22,
                            letterSpacing: .2,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Nous avons envoyé un lien d’activation à :\n${widget.email}",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                            color: bodyColor,
                            fontSize: 14.5,
                            height: 1.45,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // CTA
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _checking ? null : _checkNow,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: buttonBg,
                              foregroundColor: buttonFg,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 0,
                              textStyle: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w700,
                                fontSize: 16.5,
                                letterSpacing: .2,
                              ),
                            ),
                            child: _checking
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text("J’ai vérifié mon e-mail"),
                          ),
                        ),

                        const SizedBox(height: 14),

                        // Message d’erreur (anim)
                        if (_error != null) ...[
                          ScaleTransition(
                            scale: _scale,
                            child: Container(
                              width: 56,
                              height: 56,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFFE53935),
                              ),
                              child: const Icon(
                                Icons.close_rounded,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _error!,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(
                              color: bodyColor,
                              fontSize: 13.5,
                              height: 1.45,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],

                        const SizedBox(height: 16),
                        Text(
                          "Astuce : ouvre le lien depuis l’e-mail puis reviens et appuie sur le bouton ci-dessus.",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                            color: hintColor,
                            fontSize: 12.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
