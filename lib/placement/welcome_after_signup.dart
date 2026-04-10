// lib/placement/welcome_after_signup.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ✅ Import unique (contient AppSettingsController)
import 'package:copiqpolice/ui/app_notifier.dart'
    show AppSettingsController, AppNotifier;

class WelcomeAfterSignupPage extends StatelessWidget {
  const WelcomeAfterSignupPage({super.key});

  Color _whiteA(double o) => Color.fromRGBO(255, 255, 255, o);

  // Exigence : en LIGHT -> fond #1147D9. En DARK -> fond sombre global de l’app.
  static const Color _kLightBackground = Color(0xFF1147D9);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppSettingsController.I.themeMode,
      builder: (_, mode, __) {
        final platformDark =
            Theme.of(context).brightness ==
            Brightness.dark; // cas ThemeMode.system
        final isDark = switch (mode) {
          ThemeMode.dark => true,
          ThemeMode.light => false,
          ThemeMode.system => platformDark,
        };

        final Color pageBg = isDark
            ? Theme.of(context).scaffoldBackgroundColor
            : _kLightBackground;

        // Couleurs
        final white = const Color(0xFFFFFFFF);
        final titleColor = white;
        final bodyColor = _whiteA(.90);
        final buttonBg = Colors.white;
        final buttonFg = isDark ? Colors.black : const Color(0xFF0E44D6);

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
                    padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo / visuel avec petite anim
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.9, end: 1.0),
                          duration: const Duration(milliseconds: 420),
                          curve: Curves.easeOutCubic,
                          builder: (context, scale, child) => Transform.scale(
                            scale: scale,
                            child: SizedBox(
                              height: 180,
                              child: Image.asset(
                                'assets/images/onboarding.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Titre
                        Text(
                          "Bienvenue sur COP’IQ",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                            color: titleColor,
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.2,
                            height: 1.25,
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Texte
                        Text(
                          "Ton espace d’entraînement professionnel pour réussir les concours PA & GPX.\n"
                          "On va calibrer un plan d’attaque intelligent, clair et adapté à ton niveau.",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                            color: bodyColor,
                            fontSize: 14.5,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 26),

                        // CTA
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(
                                context,
                              ).pushNamed('/placement-intro');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: buttonBg,
                              foregroundColor: buttonFg,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              "Continuer",
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                                letterSpacing: .2,
                              ),
                            ),
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
