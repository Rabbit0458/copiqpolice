import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ===================== PAGES CONTENU INTRO LIBERTÉS PUBLIQUES =====================
// (chemins adaptés à ton arbo "libertés_publiques/introduction")
import 'package:copiqpolice/gpx_scolarite_pages/dps_dpg/generalite_pages/libert%C3%A9s_publiques/introduction/declaration_droits_homme_page.dart';
import 'package:copiqpolice/gpx_scolarite_pages/dps_dpg/generalite_pages/libert%C3%A9s_publiques/introduction/regime_juridique_libertes_publiques_page.dart';
import 'package:copiqpolice/gpx_scolarite_pages/dps_dpg/generalite_pages/libert%C3%A9s_publiques/introduction/sources_libertes_publiques_page.dart';
import 'package:copiqpolice/gpx_scolarite_pages/dps_dpg/generalite_pages/libert%C3%A9s_publiques/introduction/notion_libertes_publiques_page.dart';
import 'package:copiqpolice/gpx_scolarite_pages/dps_dpg/generalite_pages/quizz_generalit%C3%A9/quiz_libertes_publiques_page.dart';

/// =============================================================
///  COP'IQ — Introduction générale aux libertés publiques (hub)
///
///  Dossier : "Introduction générale aux libertés publiques"
///  - La Déclaration des droits de l’homme et du citoyen
///  - Le régime juridique / la réglementation des libertés publiques
///  - Les sources des libertés publiques
///  - Notion de libertés publiques
/// =============================================================
class IntroductionLibertesPubliquesPage extends StatelessWidget {
  const IntroductionLibertesPubliquesPage({super.key});

  static const String routeName =
      '/gpx/generalites/libertes_publiques/introduction';

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
          'Introduction aux libertés publiques',
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
          // ===== La Déclaration des droits de l’homme et du citoyen =====
          _ModuleCard(
            tag: 'ddhc',
            title: 'La Déclaration des droits\nde l’homme et du citoyen',
            subtitle:
                'Texte fondateur de 1789, valeur constitutionnelle, portée en matière de libertés publiques.',
            imagePath: 'assets/images/libertes_intro_ddhc.jpg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () =>
                _open(context, const DeclarationDroitsHommePage(), 'ddhc'),
          ),
          const SizedBox(height: 14),

          // ===== Le régime juridique / la réglementation des libertés =====
          _ModuleCard(
            tag: 'regime_juridique_libertes',
            title:
                'Le régime juridique ou la\nréglementation des libertés publiques',
            subtitle:
                'Encadrement légal et réglementaire, police administrative, limites nécessaires à l’ordre public.',
            imagePath: 'assets/images/libertes_garanties.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _open(
              context,
              const RegimeJuridiqueLibertesPubliquesPage(),
              'regime_juridique_libertes',
            ),
          ),
          const SizedBox(height: 14),

          // ===== Les sources des libertés publiques =====
          _ModuleCard(
            tag: 'sources_libertes',
            title: 'Les sources des libertés publiques',
            subtitle:
                'Constitution, lois, jurisprudence, conventions internationales (notamment C.E.D.H.).',
            imagePath: 'assets/images/libertes_publiques.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _open(
              context,
              const SourcesLibertesPubliquesPage(),
              'sources_libertes',
            ),
          ),
          const SizedBox(height: 14),

          // ===== Notion de libertés publiques =====
          _ModuleCard(
            tag: 'notion_libertes',
            title: 'Notion de libertés publiques',
            subtitle:
                'Définition, caractéristiques, distinction droits fondamentaux / libertés individuelles…',
            imagePath: 'assets/images/contre_nation.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _open(
              context,
              const NotionLibertesPubliquesPage(),
              'notion_libertes',
            ),
          ),
          const SizedBox(height: 22),
          // ===== QUIZ LIBERTÉS PUBLIQUES =====
          const SizedBox(height: 22),
          _ModuleCard(
            tag: 'quiz_libertes',
            title: 'Quiz — Introduction',
            subtitle:
                'Testez votre maîtrise de la liberté individuelle / sûreté et de la liberté d’aller et venir.',
            imagePath: 'assets/images/quiz.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => Navigator.of(
              context,
            ).pushNamed(QuizLibertesPubliquesPage.routeName),
          ),
          const SizedBox(height: 22),
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
                      maxLines: 3,
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
