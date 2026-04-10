import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ===================== PAGES CONTENU RÉTENTION =====================
import 'package:copiqpolice/gpx_scolarite_pages/dps_dpg/generalite_pages/retention_locaux_police/retention_principes_page.dart';
import 'package:copiqpolice/gpx_scolarite_pages/dps_dpg/generalite_pages/retention_locaux_police/retention_mesures_judiciaires_page.dart';
import 'package:copiqpolice/gpx_scolarite_pages/dps_dpg/generalite_pages/retention_locaux_police/retention_mesures_admin_page.dart';

// ===================== PAGE QUIZ RÉTENTION (à créer si besoin) =====================
import 'package:copiqpolice/gpx_scolarite_pages/dps_dpg/generalite_pages/quizz_generalit%C3%A9/quiz_retention_locaux_page.dart';

/// =============================================================
///  COP'IQ — Rétention dans les locaux de police (hub)
///  - 3 cartes modules (principes, mesures judiciaires, mesures admin)
///  - + CTA Quiz dédié
///  - Style calqué sur LdContenuPage
/// =============================================================
class RetentionLocauxContenuPage extends StatelessWidget {
  const RetentionLocauxContenuPage({super.key});

  static const String routeName =
      '/gpx/generalites/retention_locaux_police/contenu';

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
          'Rétention dans les locaux de police',
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
          // ===== PRINCIPES GÉNÉRAUX =====
          _ModuleCard(
            tag: 'retention_principes',
            title: 'Principes généraux',
            subtitle:
                'Liberté individuelle, contrôle judiciaire et limites à la coercition.',
            imagePath: 'assets/images/pv_regles.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _open(
              context,
              const RetentionPrincipesPage(),
              'retention_principes',
            ),
          ),
          const SizedBox(height: 14),

          // ===== MESURES À CARACTÈRE JUDICIAIRE =====
          _ModuleCard(
            tag: 'retention_judiciaire',
            title: 'Mesures à caractère judiciaire',
            subtitle:
                'Garde à vue, retenue des mineurs, vérification d’identité, mandats…',
            imagePath: 'assets/images/repression.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _open(
              context,
              const RetentionMesuresJudiciairesPage(),
              'retention_judiciaire',
            ),
          ),
          const SizedBox(height: 14),

          // ===== MESURES À CARACTÈRE ADMINISTRATIF =====
          _ModuleCard(
            tag: 'retention_admin',
            title: 'Mesures à caractère administratif',
            subtitle:
                'Droit au séjour, chambre de sûreté, mineurs en fugue, terrorisme…',
            imagePath: 'assets/images/infraction_legal.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _open(
              context,
              const RetentionMesuresAdminPage(),
              'retention_admin',
            ),
          ),
          const SizedBox(height: 24),

          // ===== QUIZ =====
          _ModuleCard(
            tag: 'quiz_retention',
            title: 'Quiz — Rétention locaux de police',
            subtitle:
                'Durées, bases légales et bonnes pratiques opérationnelles.',
            imagePath: 'assets/images/quiz.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => Navigator.of(
              context,
            ).pushNamed('/gpx/generalites/quiz/retention_locaux_police'),
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
          // on garde la même hauteur de carte
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
                  mainAxisSize: MainAxisSize.min, // <-- important
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
                    const SizedBox(
                      height: 52,
                    ), // 60 -> 52 pour gagner de la place
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.fustat(
                        fontWeight: FontWeight.w900,
                        fontSize: 23, // 24 -> 23, un poil plus compact
                        color: Colors.white,
                        height: 1.05,
                      ),
                    ),
                    const SizedBox(height: 6),
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
          ? [const Color(0xFF90CDF4), const Color(0xFF3182CE)]
          : [const Color(0xFFBEE3F8), const Color(0xFF2B6CB0)],
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
                              ? const Color(0xFF3182CE).withOpacity(.35)
                              : const Color(0xFF2B6CB0).withOpacity(.25),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.local_police_rounded,
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
                          'Quiz — Rétention locaux de police',
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
                          'Cadre juridique, durées maximales et distinction judiciaire / administratif.',
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
