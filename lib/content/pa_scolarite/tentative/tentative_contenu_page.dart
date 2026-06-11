/// lib/gpx_scolarite_pages/generalite_pages/tentative/tentative_contenu_page.dart
library;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/generalite_pages/tentative/condition_tentative_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/generalite_pages/tentative/repression_tentative_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/generalite_pages/tentative/infructueuse_tentative_page.dart';

/// =============================================================
///  COP'IQ — La tentative punissable (hub)
///  - 3 cartes modules (éléments légal, matériel, moral)
///  - Style homogène avec infraction_contenu_page, adapté à la tentative
/// =============================================================
class TentativeContenuPagePA extends StatelessWidget {
  const TentativeContenuPagePA({super.key});

  static const String routeName = '/pa/generalites/tentative/contenu';

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
          'La tentative punissable',
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
          // MODULES
          _ModuleCard(
            tag: 'conditions',
            title: 'Les conditions de la tentative',
            subtitle:
                'Définition, éléments constitutifs et critères opérationnels',
            imagePath: 'assets/images/tentative_legal.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () =>
                _open(context, const ConditionTentativePage(), 'conditions'),
          ),
          const SizedBox(height: 14),
          _ModuleCard(
            tag: 'repression',
            title: 'La répression',
            subtitle:
                'Fondements juridiques, portée pénale et modalités d’application.',
            imagePath: 'assets/images/repression.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () =>
                _open(context, const RepressionTentativePage(), 'repression'),
          ),
          const SizedBox(height: 14),
          _ModuleCard(
            tag: 'tentative',
            title: 'La tentative infructueuse',
            subtitle:
                'Analyse, qualification et limites de l’infraction manquée.',
            imagePath: 'assets/images/tentative_moral.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _open(
              context,
              const InfructueuseTentativePage(),
              'infructueuse',
            ),
          ),
          const SizedBox(height: 18),

          // Carte quiz “module” en bas
          _ModuleCard(
            tag: 'quiz',
            title: 'Quiz — Tentative',
            subtitle: 'Vérifiez votre maîtrise de la tentative punissable.',
            imagePath: 'assets/images/quiz.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => Navigator.of(
              context,
            ).pushNamed('/pa/generalites/quiz/tentative'),
          ),
          const SizedBox(height: 22), // respire en bas
        ],
      ),
    );
  }

  void _open(BuildContext context, Widget page, String tag) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return Hero(
            tag: 'hero_$tag',
            child: Material(color: Colors.transparent, child: page),
          );
        },
        transitionDuration: const Duration(milliseconds: 380),
        transitionsBuilder: (context, animation, secondary, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          );
          return FadeTransition(opacity: curved, child: child);
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
//  RUBAN QUIZ (petit bloc horizontal, au centre de la page)
// ---------------------------------------------------------------------------
class _QuizStripe extends StatelessWidget {
  const _QuizStripe({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final Color base = isDark ? Colors.white : Colors.black;
    final Color cardBg = isDark
        ? const Color(0xFF0C0F14).withValues(alpha: .72)
        : cs.surface.withValues(alpha: .92);
    final Color stroke = isDark
        ? Colors.white.withValues(alpha: .08)
        : Colors.black.withValues(alpha: .06);
    final Color shadow = isDark
        ? Colors.black.withValues(alpha: .35)
        : Colors.black.withValues(alpha: .08);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);
    final Color textSub = textMain.withValues(alpha: .72);

    // Pastille dégradée (style “feature tile”)
    const Gradient badgeGrad = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFF08D63), Color(0xFFFFC857)],
    );

    return Semantics(
      button: true,
      label: 'Quiz tentative punissable',
      child: Container(
        margin: const EdgeInsets.only(top: 6, bottom: 4),
        padding: const EdgeInsets.symmetric(horizontal: 6),
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
                          ? const Color(0xFFE07854).withValues(alpha: .35)
                          : const Color(0xFFF08D63).withValues(alpha: .25),
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
                      'Quiz — Tentative',
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
                      '15 questions • Légal, matériel & moral de la tentative',
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
                  color: base.withValues(alpha: .06),
                  border: Border.all(color: base.withValues(alpha: .12)),
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
    );
  }
}

// ---------------------------------------------------------------------------
//  CARTE MODULE
// ---------------------------------------------------------------------------
// ---------------------------------------------------------------------------
//  CARTE MODULE
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

    // 👉 Sous-titre : toujours clair sur l’image,
    // mais en gardant un léger ajustement selon le thème.
    final Color subtitleColor = isDark
        ? textSoft // déjà un blanc cassé
        : Colors.white.withValues(alpha: 0.90);

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
              // Voile sombre pour que le texte reste lisible
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
                    // Sous-titre (lisible en light & dark)
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
