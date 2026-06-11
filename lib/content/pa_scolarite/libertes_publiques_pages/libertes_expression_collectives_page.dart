import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// === PAGES CIBLES ===
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/generalite_pages/libert%C3%A9s_publiques/collectives/liberte_presse_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/generalite_pages/libert%C3%A9s_publiques/collectives/regime_attroupements_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/generalite_pages/libert%C3%A9s_publiques/collectives/regime_manifestations_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/quiz_scolarite_gpx/gpx_quiz_libertes_publiques_collectives_page.dart';

/// =============================================================
///  COP'IQ — Les libertés d’expression collectives (hub)
/// =============================================================
class PaLibertesExpressionCollectivesPage extends StatelessWidget {
  const PaLibertesExpressionCollectivesPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/libertes_publiques/libertes_expression_collectives';

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
          'Les libertés d’expression collectives',
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
          // ===== Liberté de la presse =====
          _ModuleCard(
            tag: 'liberte_presse',
            title: 'La liberté de la presse',
            subtitle: 'Cadre juridique, limites et responsabilités.',
            imagePath: 'assets/images/liberte_presse.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () =>
                _open(context, const LibertePressePage(), 'liberte_presse'),
          ),
          const SizedBox(height: 14),

          // ===== Régime des attroupements =====
          _ModuleCard(
            tag: 'regime_attroupements',
            title: 'Le régime des attroupements',
            subtitle: 'Définition, conditions de dispersion, responsabilités.',
            imagePath: 'assets/images/regime_attroupements.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _open(
              context,
              const RegimeAttroupementsPage(),
              'regime_attroupements',
            ),
          ),
          const SizedBox(height: 14),

          // ===== Régime des manifestations =====
          _ModuleCard(
            tag: 'regime_manifestations',
            title: 'Le régime des manifestations',
            subtitle: 'Déclaration, encadrement, pouvoirs de police.',
            imagePath: 'assets/images/regime_manifestations.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _open(
              context,
              const RegimeManifestationsPage(),
              'regime_manifestations',
            ),
          ),
          // ===== QUIZ LIBERTÉS PUBLIQUES =====
          const SizedBox(height: 22),
          _ModuleCard(
            tag: 'quiz_libertes',
            title: 'Quiz — Collectives',
            subtitle:
                'Testez votre maîtrise de la liberté individuelle / sûreté et de la liberté d’aller et venir.',
            imagePath: 'assets/images/quiz.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => Navigator.of(
              context,
            ).pushNamed(QuizLibertesPubliquesCollectivesPageGPX.routeName),
          ),
          const SizedBox(height: 22),
        ],
      ),
    );
  }

  // Animation de navigation (fade)
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
