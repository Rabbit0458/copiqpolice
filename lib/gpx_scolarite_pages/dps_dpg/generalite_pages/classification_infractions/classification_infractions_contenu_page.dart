import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'crime_page.dart';
import 'delit_page.dart';
import 'contravention_page.dart';
import 'package:copiqpolice/gpx_scolarite_pages/dps_dpg/generalite_pages/quizz_generalit%C3%A9/quiz_classification_infractions_page.dart';

/// =============================================================
///  COP'IQ — Classification des infractions
///  - 3 cartes + 1 carte Quiz
///  - Gère les thèmes light/dark
///  - Redirection sécurisée vers le quiz avec Supabase
/// =============================================================
class ClassificationInfractionsContenuPage extends StatelessWidget {
  const ClassificationInfractionsContenuPage({super.key});

  static const String routeName =
      '/gpx/generalites/classification_infractions_cards';

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final bool isDark = brightness == Brightness.dark;

    // Palette de couleurs
    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);
    final Color textSoft = isDark
        ? Colors.white70
        : const Color(0xFF222222).withOpacity(.70);
    final Color iconOnImage = Colors.white;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: Icon(Icons.arrow_back_ios_new, color: textMain),
          tooltip: 'Retour',
        ),
        title: Text(
          'Classification des infractions',
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: textMain,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          _InfractionCard(
            tag: 'crime',
            title: 'Crimes',
            subtitle: 'Les infractions les plus graves',
            imagePath: 'assets/images/crime.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            iconOnImage: iconOnImage,
            isDark: isDark,
            onTap: () => _open(context, const CrimePage(), 'crime'),
          ),
          const SizedBox(height: 14),
          _InfractionCard(
            tag: 'delit',
            title: 'Délits',
            subtitle: 'Infractions intermédiaires',
            imagePath: 'assets/images/delit.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            iconOnImage: iconOnImage,
            isDark: isDark,
            onTap: () => _open(context, const DelitPage(), 'delit'),
          ),
          const SizedBox(height: 14),
          _InfractionCard(
            tag: 'contravention',
            title: 'Contraventions',
            subtitle: 'De la 1re à la 5e classe',
            imagePath: 'assets/images/contravention.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            iconOnImage: iconOnImage,
            isDark: isDark,
            onTap: () =>
                _open(context, const ContraventionPage(), 'contravention'),
          ),

          const SizedBox(height: 22), // un peu plus bas que les autres (voulu)
          _InfractionCard(
            tag: 'quiz',
            title: 'Quiz — Classification des infractions',
            subtitle: 'Testez vos connaissances.',
            imagePath: 'assets/images/quiz.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            iconOnImage: iconOnImage,
            isDark: isDark,
            onTap: () async {
              final supabase = Supabase.instance.client;

              try {
                // Rafraîchit la session pour s'assurer que le user est bien chargé
                await supabase.auth.refreshSession();
                final user = supabase.auth.currentUser;

                if (user == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Erreur : utilisateur non connecté ou session expirée.',
                      ),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                  return;
                }

                // ✅ Redirection avec les vraies infos utilisateur
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => QuizClassificationInfractionsPage(
                      uid: user.id,
                      email: user.email!,
                    ),
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Erreur lors de la récupération du compte : $e',
                    ),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              }
            },
          ),
          const SizedBox(height: 22), // Respiration en bas
        ],
      ),
    );
  }

  /// Animation douce entre les modules
  void _open(BuildContext context, Widget page, String tag) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 380),
        reverseTransitionDuration: const Duration(milliseconds: 280),
        pageBuilder: (_, animation, __) => FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          ),
          child: page,
        ),
      ),
    );
  }
}

/// =============================================================
///  Carte visuelle d’un module (réutilisable)
/// =============================================================
class _InfractionCard extends StatelessWidget {
  const _InfractionCard({
    required this.tag,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.textMain,
    required this.textSoft,
    required this.iconOnImage,
    required this.isDark,
    required this.onTap,
  });

  final String tag;
  final String title;
  final String subtitle;
  final String imagePath;
  final Color textMain;
  final Color textSoft;
  final Color iconOnImage;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color badgeBg = Colors.white.withOpacity(isDark ? 0.14 : 0.10);
    final Color borderClr = Colors.white.withOpacity(isDark ? 0.18 : 0.14);

    return GestureDetector(
      onTap: onTap,
      child: Semantics(
        button: true,
        label: '$title — découvrir',
        child: Container(
          height: 190,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: Colors.transparent,
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Hero(
                tag: 'hero_$tag',
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  filterQuality: FilterQuality.high,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(.25),
                      Colors.black.withOpacity(.55),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: badgeBg,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: borderClr),
                      ),
                      child: Text(
                        'Module',
                        style: GoogleFonts.fustat(
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      title,
                      style: GoogleFonts.fustat(
                        fontWeight: FontWeight.w900,
                        fontSize: 28,
                        color: Colors.white,
                        height: 1.0,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: GoogleFonts.fustat(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Colors.white.withOpacity(.85),
                      ),
                    ),
                  ],
                ),
              ),
              const Positioned(right: 16, bottom: 16, child: _RoundCTA()),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoundCTA extends StatelessWidget {
  const _RoundCTA();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withOpacity(.12),
      shape: const StadiumBorder(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            const Icon(
              Icons.arrow_forward_rounded,
              color: Colors.white,
              size: 22,
            ),
            const SizedBox(width: 6),
            Text(
              'Découvrir',
              style: GoogleFonts.fustat(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
