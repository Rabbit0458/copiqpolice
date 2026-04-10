import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ===================== PAGES CONTENU LD (à adapter selon ton arbo) =====================
import 'package:copiqpolice/gpx_scolarite_pages/dps_dpg/generalite_pages/legitime_defense/ld_personnes_page.dart';
import 'package:copiqpolice/gpx_scolarite_pages/dps_dpg/generalite_pages/legitime_defense/ld_biens_page.dart';
import 'package:copiqpolice/gpx_scolarite_pages/dps_dpg/generalite_pages/legitime_defense/ld_cas_presumes_page.dart';

// ===================== PAGE QUIZ LD =====================
import 'package:copiqpolice/gpx_scolarite_pages/dps_dpg/generalite_pages/quizz_generalit%C3%A9/quiz_legitime_defense_page.dart';

/// =============================================================
///  COP'IQ — Légitime défense (hub)
///  - 3 cartes modules (personnes, biens, cas présumés)
///  - + CTA Quiz dédié
///  - Style homogène avec InfractionContenuPage
/// =============================================================
class LdContenuPage extends StatelessWidget {
  const LdContenuPage({super.key});

  static const String routeName = '/gpx/generalites/legitime-defense/contenu';

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
          'La légitime défense',
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
          // ===== LD PERSONNES =====
          _ModuleCard(
            tag: 'ld_personnes',
            title: 'Légitime défense des personnes',
            subtitle: 'Réaction immédiate face à une atteinte injustifiée.',
            imagePath: 'assets/images/legitime_defense.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () =>
                _open(context, const LdPersonnesPage(), 'ld_personnes'),
          ),
          const SizedBox(height: 14),

          // ===== LD BIENS =====
          _ModuleCard(
            tag: 'ld_biens',
            title: 'Légitime défense des biens',
            subtitle: 'Protéger un bien sans excès.',
            imagePath: 'assets/images/recel.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _open(context, const LdBiensPage(), 'ld_biens'),
          ),
          const SizedBox(height: 14),

          // ===== CAS PRESUMES =====
          _ModuleCard(
            tag: 'ld_presomptions',
            title: 'Cas présumés de légitime défense',
            subtitle: 'Situations où la LD est présumée.',
            imagePath: 'assets/images/contre_biens.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () =>
                _open(context, const LdCasPresumesPage(), 'ld_presomptions'),
          ),
          const SizedBox(height: 24),

          const SizedBox(height: 22), // un peu plus bas que les autres
          _ModuleCard(
            tag: 'quiz',
            title: 'Quiz — Légitime Défense',
            subtitle: 'Testez vos connaissances.',
            imagePath: 'assets/images/quiz.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => Navigator.of(
              context,
            ).pushNamed('/gpx/generalites/quiz/legitimedefense'),
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
          // un poil plus haut pour laisser respirer texte + CTA
          height: 200,
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
                    SizedBox(height: 60), // réduit l’espace poussé vers le bas
                    // titre un tout petit peu plus petit
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.fustat(
                        fontWeight: FontWeight.w900,
                        fontSize: 24,
                        color: Colors.white,
                        height: 1.05,
                      ),
                    ),
                    const SizedBox(height: 6),
                    // on “réserve” la zone à droite pour le bouton Découvrir
                    Padding(
                      padding: const EdgeInsets.only(right: 80),
                      child: Text(
                        subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.fustat(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          height: 1.25,
                          color: Colors.white.withOpacity(.85),
                        ),
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
        // un peu plus compact
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Row(
          children: [
            const Icon(
              Icons.arrow_forward_rounded,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 4),
            Text(
              'Découvrir',
              style: GoogleFonts.fustat(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ==================== CTA QUIZ (carte premium centrée) ====================
class _QuizCTA extends StatelessWidget {
  const _QuizCTA({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final Color base = isDark ? Colors.white : Colors.black;
    final Color cardBg = isDark
        ? const Color(0xFF0C0F14).withOpacity(.72)
        : cs.surface.withOpacity(.92);
    final Color stroke = isDark
        ? Colors.white.withOpacity(.08)
        : Colors.black.withOpacity(.06);
    final Color shadow = isDark
        ? Colors.black.withOpacity(.35)
        : Colors.black.withOpacity(.08);
    final Color textMain = isDark ? Colors.white : cs.onSurface;
    final Color textSub = textMain.withOpacity(.72);

    final Gradient badgeGrad = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: isDark
          ? [const Color(0xFF9AE6B4), const Color(0xFF48BB78)]
          : [const Color(0xFFC6F6D5), const Color(0xFF38A169)],
    );

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 540),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(18),
            splashColor: base.withOpacity(.06),
            highlightColor: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: stroke),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                    color: shadow,
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Tuile icône (44x44)
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: badgeGrad,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: isDark
                              ? const Color(0xFF48BB78).withOpacity(.35)
                              : const Color(0xFF38A169).withOpacity(.25),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.shield_moon_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Titre + sous-titre
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Quiz — Légitime défense',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.fustat(
                            color: textMain,
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                            letterSpacing: .2,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Conditions, cas présumés et limites à ne pas dépasser.\nPrêt(e) pour un survol express avant la fiche complète ?',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.fustat(
                            color: textSub,
                            fontWeight: FontWeight.w600,
                            fontSize: 13.2,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Bouton flèche (cercle)
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: base.withOpacity(.06),
                      border: Border.all(color: base.withOpacity(.12)),
                    ),
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      size: 18,
                      color: textMain,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
