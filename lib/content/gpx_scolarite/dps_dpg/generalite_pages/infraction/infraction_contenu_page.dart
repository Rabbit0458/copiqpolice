import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Cibles (déjà créées)
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/generalite_pages/infraction/element_legal_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/generalite_pages/infraction/element_materiel_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/generalite_pages/infraction/element_moral_page.dart';

// Page Quiz
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/generalite_pages/quizz_generalit%C3%A9/quiz_infraction_page.dart';

/// =============================================================
///  COP'IQ — L’infraction (hub)
///  - 3 cartes modules + CTA Quiz centré
///  - Style homogène avec classification_infractions_contenu_page
/// =============================================================
class InfractionContenuPage extends StatelessWidget {
  const InfractionContenuPage({super.key});

  static const String routeName = '/gpx/generalites/infraction/contenu';

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
          'L\'infractions',
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
          _ModuleCard(
            tag: 'legal',
            title: 'Élément légal',
            subtitle: 'Le texte qui fonde l’infraction.',
            imagePath: 'assets/images/infraction_legal.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _open(context, const ElementLegalPage(), 'legal'),
          ),
          const SizedBox(height: 14),
          _ModuleCard(
            tag: 'materiel',
            title: 'Élément matériel',
            subtitle: 'L’acte ou le fait concret reproché.',
            imagePath: 'assets/images/infraction_materiel.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () =>
                _open(context, const ElementMaterielPage(), 'materiel'),
          ),
          const SizedBox(height: 14),
          _ModuleCard(
            tag: 'moral',
            title: 'Élément moral',
            subtitle: 'L’intention ou la faute de l’auteur.',
            imagePath: 'assets/images/infraction_moral.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _open(context, const ElementMoralPage(), 'moral'),
          ),
          const SizedBox(height: 20),

          const SizedBox(height: 22), // un peu plus bas que les autres
          _ModuleCard(
            tag: 'quiz',
            title: 'Quiz — Infractions',
            subtitle: 'Testez vos connaissances.',
            imagePath: 'assets/images/quiz.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => Navigator.of(
              context,
            ).pushNamed('/gpx/generalites/quiz/infraction'),
          ),
          const SizedBox(height: 22), // respire en bas
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

/// Carte visuelle d’un module
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

/// ===== CTA QUIZ (carte premium, centrée) =====
class _QuizCTA extends StatelessWidget {
  const _QuizCTA({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    // Couleurs harmonisées (light/dark)
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

    // Pastille dégradée (style “feature tile”)
    final Gradient badgeGrad = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: isDark
          ? [const Color(0xFFFFB59E), const Color(0xFFE07854)]
          : [const Color(0xFFFFC7B3), const Color(0xFFF08D63)],
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
                              ? const Color(0xFFE07854).withOpacity(.35)
                              : const Color(0xFFF08D63).withOpacity(.25),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.quiz_rounded,
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
                          'Quiz — Infractions',
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
                          '15 questions • Élément légal, matériel & moral',
                          maxLines: 1,
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
