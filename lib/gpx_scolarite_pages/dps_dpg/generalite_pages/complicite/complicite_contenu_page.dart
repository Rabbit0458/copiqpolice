// lib/gpx_scolarite_pages/generalite_pages/complicite/complicite_contenu_page.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/gpx_scolarite_pages/dps_dpg/generalite_pages/quizz_generalit%C3%A9/quiz_complicite_page.dart';
import 'package:copiqpolice/gpx_scolarite_pages/dps_dpg/generalite_pages/complicite/complicite_condition_page.dart';

class CompliciteContenuPage extends StatelessWidget {
  const CompliciteContenuPage({super.key});

  static const String routeName = '/gpx/generalites/complicite/contenu';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);
    final Color textSoft = isDark
        ? Colors.white70
        : const Color(0xFF222222).withOpacity(.70);

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
          'La complicité',
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: textMain,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
        children: [
          // Module 1 : conditions de la complicité
          _ModuleCard(
            tag: 'conditions_complicite',
            title: 'Les conditions de la complicité',
            subtitle:
                'Définition, criminalité d’emprunt et lien avec le fait principal.',
            imagePath: 'assets/images/complicite_conditions.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () =>
                _openRoute(context, '/gpx/generalites/complicite/conditions'),
          ),
          const SizedBox(height: 14),

          // Module 2 : participation au fait principal
          _ModuleCard(
            tag: 'participation_complicite',
            title: 'La participation au fait principal',
            subtitle:
                'Actes de complicité (provocation, instructions, aide ou assistance).',
            imagePath: 'assets/images/complicite_participation.jpg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx/generalites/complicite/participation',
            ),
          ),
          const SizedBox(height: 14),

          // Module 3 : répression de la complicité
          _ModuleCard(
            tag: 'repression_complicite',
            title: 'La répression de la complicité',
            subtitle:
                'Règle de l’art. 121-6 C. pén., peines encourues et circonstances.',
            imagePath: 'assets/images/repression.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () =>
                _openRoute(context, '/gpx/generalites/complicite/repression'),
          ),
          const SizedBox(height: 18),

          // Quiz
          _ModuleCard(
            tag: 'quiz_complicite',
            title: 'Quiz — Complicité',
            subtitle:
                'Vérifiez votre maîtrise des conditions, de la participation et de la répression.',
            imagePath: 'assets/images/quiz.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(context, '/gpx/complicite/quiz/complicite'),
          ),
          const SizedBox(height: 22),
        ],
      ),
    );
  }

  void _openRoute(BuildContext context, String routeName) {
    Navigator.of(context).pushNamed(routeName);
  }
}

// ---------------------------------------------------------------------------
//  CARTE MODULE (même style que tentative, avec texte lisible dark/light)
// ---------------------------------------------------------------------------
class _ModuleCard extends StatelessWidget {
  const _ModuleCard({
    required this.tag,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.textMain,
    required this.textSoft,
    required this.onTap,
  });

  final String tag;
  final String title;
  final String subtitle;
  final String imagePath;
  final Color textMain;
  final Color textSoft;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Sous-titre : toujours bien lisible sur l’image
    final Color subtitleColor = isDark
        ? textSoft
        : Colors.white.withOpacity(0.90);

    final Color badgeBg = Colors.white.withOpacity(0.14);
    final Color borderClr = Colors.white.withOpacity(0.18);

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
                    // Badge "Module"
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
                    // Titre
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.fustat(
                        fontWeight: FontWeight.w900,
                        fontSize: 28,
                        color: Colors.white,
                        height: 1.0,
                      ),
                    ),
                    const SizedBox(height: 6),
                    // Sous-titre
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.fustat(
                        fontWeight: FontWeight.w500,
                        fontSize: 13.5,
                        height: 1.3,
                        color: subtitleColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
