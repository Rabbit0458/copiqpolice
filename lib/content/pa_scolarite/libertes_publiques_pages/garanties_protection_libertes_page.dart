import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ===================== PAGES CONTENU GARANTIES / PROTECTION =====================
// (adapte les chemins à ton arborescence réelle)
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/generalite_pages/libert%C3%A9s_publiques/garanties/controle_constitutionnalite_lois_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/generalite_pages/libert%C3%A9s_publiques/garanties/recours_juridictionnels_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/generalite_pages/libert%C3%A9s_publiques/garanties/recours_non_juridictionnels_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/generalite_pages/libert%C3%A9s_publiques/garanties/recours_organes_internationaux_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/quiz_scolarite_gpx/gpx_quiz_libertes_publiques_garanties_page.dart';

/// =============================================================
///  COP'IQ — Garanties et protection des libertés publiques (hub)
///  - 4 cartes modules :
///      • Contrôle de la constitutionnalité des lois
///      • Les recours juridictionnels
///      • Les recours non juridictionnels
///      • Les recours devant les organes internationaux
///  - Pas de carte Quiz ici
/// =============================================================
class PaGarantiesProtectionLibertesPage extends StatelessWidget {
  const PaGarantiesProtectionLibertesPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/libertes_publiques/garanties_protection';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);
    final Color textSoft = isDark ? Colors.white70 : const Color(0xFF222222).withValues(alpha: .70);

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
          'Garanties des libertés publiques',
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
          // ===== Le contrôle de la constitutionnalité des lois =====
          _ModuleCard(
            tag: 'controle_constitutionnalite',
            title: 'Contrôle de la constitutionnalité des lois',
            subtitle:
                'Rôle du Conseil constitutionnel et protection des droits fondamentaux.',
            imagePath: 'assets/images/libertes_intro.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _open(
              context,
              const ControleConstitutionnaliteLoisPage(),
              'controle_constitutionnalite',
            ),
          ),
          const SizedBox(height: 14),

          // ===== Les recours juridictionnels =====
          _ModuleCard(
            tag: 'recours_juridictionnels',
            title: 'Les recours juridictionnels',
            subtitle:
                'Voies de recours devant les juridictions internes (administratives et judiciaires).',
            imagePath: 'assets/images/pv_regles.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _open(
              context,
              const RecoursJuridictionnelsPage(),
              'recours_juridictionnels',
            ),
          ),
          const SizedBox(height: 14),

          // ===== Les recours non juridictionnels =====
          _ModuleCard(
            tag: 'recours_non_juridictionnels',
            title: 'Les recours non juridictionnels',
            subtitle:
                'Médiateur, Défenseur des droits, autorités administratives indépendantes…',
            imagePath: 'assets/images/pv_regles.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _open(
              context,
              const RecoursNonJuridictionnelsPage(),
              'recours_non_juridictionnels',
            ),
          ),
          const SizedBox(height: 14),

          // ===== Les recours devant les organes internationaux =====
          _ModuleCard(
            tag: 'recours_organes_internationaux',
            title: 'Recours devant les organes internationaux',
            subtitle:
                'Cour européenne des droits de l’homme, comités de l’Organisation des Nations unies…',
            imagePath: 'assets/images/pv_regles.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _open(
              context,
              const RecoursOrganesInternationauxPage(),
              'recours_organes_internationaux',
            ),
          ),
          const SizedBox(height: 22),
          // ===== QUIZ LIBERTÉS PUBLIQUES =====
          const SizedBox(height: 22),
          _ModuleCard(
            tag: 'quiz_libertes',
            title: 'Quiz — Garanties',
            subtitle:
                'Testez votre maîtrise de la liberté individuelle / sûreté et de la liberté d’aller et venir.',
            imagePath: 'assets/images/quiz.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => Navigator.of(
              context,
            ).pushNamed(QuizGarantiesLibertesPageGPX.routeName),
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
    final Color badgeBg = Colors.white.withValues(alpha: 0.14);
    final Color borderClr = Colors.white.withValues(alpha: 0.18);

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
                      Colors.black.withValues(alpha: .25),
                      Colors.black.withValues(alpha: .55),
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
                        color: Colors.white.withValues(alpha: .85),
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
      color: Colors.white.withValues(alpha: .12),
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
