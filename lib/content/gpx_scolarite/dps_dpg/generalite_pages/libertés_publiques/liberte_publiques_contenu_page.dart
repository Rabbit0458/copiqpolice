import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ===================== PAGE LIBERTÉS PUBLIQUES =====================
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/generalite_pages/libert%C3%A9s_publiques/garanties_protection_libertes_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/generalite_pages/libert%C3%A9s_publiques/introduction_libertes_publiques_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/generalite_pages/libert%C3%A9s_publiques/libertes_individuelles_vie_privee_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/generalite_pages/libert%C3%A9s_publiques/libertes_expression_collectives_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/generalite_pages/quizz_generalit%C3%A9/quiz_libertes_publiques_page.dart';

/// =============================================================
///  COP'IQ — Les libertés publiques (hub)
///  - 2 cartes modules (liberté individuelle / sûreté, liberté d’aller et venir)
///  - + carte Quiz
///  - Style homogène avec InfractionContenuPage
/// =============================================================
class LibertesPubliquesContenuPage extends StatelessWidget {
  const LibertesPubliquesContenuPage({super.key});

  static const String routeName = '/gpx/generalites/libertes_publiques/contenu';

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
          'Les libertés publiques',
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
          // ===== Introduction générale aux libertés publiques =====
          _ModuleCard(
            tag: 'intro_libertes_publiques',
            title: 'Introduction générale aux libertés publiques',
            subtitle: 'Notion, sources et grandes catégories de libertés.',
            imagePath: 'assets/images/cat_bases_juridiques.jpg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _open(
              context,
              const IntroductionLibertesPubliquesPage(), // à créer
              'intro_libertes_publiques',
            ),
          ),
          const SizedBox(height: 14),

          // ===== Garanties et protection des libertés publiques =====
          _ModuleCard(
            tag: 'garanties_protection_libertes',
            title: 'Garanties et protection des libertés publiques',
            subtitle: 'Contrôle du juge, hiérarchie des normes, recours.',
            imagePath: 'assets/images/gav.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _open(
              context,
              const GarantiesProtectionLibertesPage(), // à créer
              'garanties_protection_libertes',
            ),
          ),
          const SizedBox(height: 14),

          // ===== Libertés d’expression collectives =====
          _ModuleCard(
            tag: 'libertes_expression_collectives',
            title: 'Les libertés d’expression collectives',
            subtitle: 'Réunion, association, manifestation, presse…',
            imagePath: 'assets/images/libertes_intro.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _open(
              context,
              const LibertesExpressionCollectivesPage(), // à créer
              'libertes_expression_collectives',
            ),
          ),
          const SizedBox(height: 14),

          // ===== Libertés individuelles et vie privée =====
          _ModuleCard(
            tag: 'libertes_individuelles_vie_privee',
            title: 'Les libertés individuelles et la vie privée',
            subtitle: 'Sûreté, domicile, correspondances, données perso.',
            imagePath: 'assets/images/libertes_garanties.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _open(
              context,
              const LibertesIndividuellesViePriveePage(), // à créer – tu peux y inclure LiberteIndividuellePage + vie privée
              'libertes_individuelles_vie_privee',
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

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

/// ==================== Carte visuelle d’un module ====================
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
                    // pastille "Module"
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
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.fustat(
                        fontWeight: FontWeight.w900,
                        fontSize: 26,
                        color: Colors.white,
                        height: 1.05,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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
