import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ===================== PAGES CONTENU LD (à adapter selon ton arbo) =====================
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_conditions_prealables_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_lien_legitime_defense_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

// ===================== PAGE QUIZ LD =====================

/// =============================================================
///  COP'IQ — Légitime défense (hub)
///  - 3 cartes modules (personnes, biens, cas présumés)
///  - + CTA Quiz dédié
///  - Style homogène avec InfractionContenuPage
/// =============================================================
class UsageArmesPage extends StatelessWidget {
  const UsageArmesPage({super.key});

  static const String routeName = '/gpx/generalites/usagedesarmes_contenu';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);
    final Color textSoft = isDark
        ? Colors.white70
        : const Color(0xFF222222).withValues(alpha: .70);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: Icon(Icons.arrow_back_ios_new, color: textMain),
          tooltip: ScolariteText.value(
            "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/usage_des_armes_contenu_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/usage_des_armes_contenu_page.dart",
            "f00002",
            'LE CADRE LÉGAL D\'USAGE DES ARMES',
          ),
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
          // ===== 3 CONDITIONS PRÉALABLES =====
          _ModuleCard(
            tag: 'ua_conditions',
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/usage_des_armes_contenu_page.dart",
              "f00003",
              'Les 3 conditions préalables',
            ),
            subtitle: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/usage_des_armes_contenu_page.dart",
              "f00004",
              'Exercice des fonctions, port apparent et nécessité absolue.',
            ),
            imagePath:
                'assets/images/legitime_defense.jpeg', // à adapter si tu as un visuel dédié
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _open(
              context,
              const UaConditionsPrealablesPage(),
              'ua_conditions',
            ),
          ),
          const SizedBox(height: 10),

          // ===== LES 5 SITUATIONS L. 435-1 C.S.I. =====
          _ModuleCard(
            tag: 'ua_situations',
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/usage_des_armes_contenu_page.dart",
              "f00005",
              'Les 5 situations d’usage des armes',
            ),
            subtitle: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/usage_des_armes_contenu_page.dart",
              "f00006",
              'Atteintes à la vie, défense de lieux, fuite, véhicule, périple meurtrier.',
            ),
            imagePath:
                'assets/images/armes_cat_ab.jpeg', // visuel générique à changer
            textMain: textMain,
            textSoft: textSoft,
            onTap: () =>
                _open(context, const UaSituationsPage(), 'ua_situations'),
          ),
          const SizedBox(height: 10),

          // ===== LIEN AVEC LA LÉGITIME DÉFENSE =====
          _ModuleCard(
            tag: 'ua_legitimedefense',
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/usage_des_armes_contenu_page.dart",
              "f00007",
              'Lien avec la légitime défense',
            ),
            subtitle: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/usage_des_armes_contenu_page.dart",
              "f00008",
              'Art. 122-5 C. pén. et articulation avec l’art. L. 435-1 C.S.I.',
            ),
            imagePath: 'assets/images/crime.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _open(
              context,
              const UaLienLegitimeDefensePage(),
              'ua_legitimedefense',
            ),
          ),
          const SizedBox(height: 10),

          // ===== QUIZ =====
          const SizedBox(height: 10),
          _ModuleCard(
            tag: 'quiz_ua',
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/usage_des_armes_contenu_page.dart",
              "f00009",
              'Quiz — Usage des armes',
            ),
            subtitle: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/usage_des_armes_contenu_page.dart",
              "f00010",
              'Testez votre maîtrise du cadre légal L. 435-1 C.S.I.',
            ),
            imagePath: 'assets/images/quiz.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => Navigator.of(
              context,
            ).pushNamed('/gpx/generalites/quiz/usagearmes'),
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
    final Color badgeBg = Colors.white.withValues(alpha: 0.14);
    final Color borderClr = Colors.white.withValues(alpha: 0.18);

    return GestureDetector(
      onTap: onTap,
      child: Semantics(
        button: true,
        label: '$title — découvrir',
        child: SizedBox(
          height:
              ((MediaQuery.sizeOf(context).height -
                          MediaQuery.paddingOf(context).vertical -
                          kToolbarHeight -
                          94) /
                      4)
                  .clamp(158.0, 200.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
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
                      // badge "Module"
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

                      const SizedBox(height: 8),

                      // zone texte (titre + sous-titre) qui s'adapte à la hauteur restante
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.fustat(
                                fontWeight: FontWeight.w900,
                                fontSize: 22,
                                color: Colors.white,
                                height: 1.05,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Padding(
                              padding: const EdgeInsets.only(right: 126),
                              child: Text(
                                subtitle,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.fustat(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                  height: 1.25,
                                  color: Colors.white.withValues(alpha: .85),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // CTA en bas à droite (hors flex, donc n'impacte pas la hauteur de la Column)
                const Positioned(right: 16, bottom: 16, child: _RoundCTA()),
              ],
            ),
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
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.arrow_forward_rounded,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 4),
            Text(
              ScolariteText.value(
                "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/usage_des_armes_contenu_page.dart",
                "f00013",
                'Découvrir',
              ),
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
        ? const Color(0xFF0C0F14).withValues(alpha: .72)
        : cs.surface.withValues(alpha: .92);
    final Color stroke = isDark
        ? Colors.white.withValues(alpha: .08)
        : Colors.black.withValues(alpha: .06);
    final Color shadow = isDark
        ? Colors.black.withValues(alpha: .35)
        : Colors.black.withValues(alpha: .08);
    final Color textMain = isDark ? Colors.white : cs.onSurface;
    final Color textSub = textMain.withValues(alpha: .72);

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
            splashColor: base.withValues(alpha: .06),
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
                              ? const Color(0xFF48BB78).withValues(alpha: .35)
                              : const Color(0xFF38A169).withValues(alpha: .25),
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
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/usage_des_armes_contenu_page.dart",
                            "f00014",
                            'Quiz — Légitime défense',
                          ),
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
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/usage_des_armes_contenu_page.dart",
                            "f00015",
                            'Conditions, cas présumés et limites à ne pas dépasser.\nPrêt(e) pour un survol express avant la fiche complète ?',
                          ),
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
        ),
      ),
    );
  }
}
