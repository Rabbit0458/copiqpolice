import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaLoiPenaleContenuPage extends StatelessWidget {
  const PaLoiPenaleContenuPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/droit_penal_general/loi_penale';

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
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: textMain),
          tooltip: 'Retour',
        ),
        title: Text(
          "De la loi pénale",
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
          // ====================== TITRE PRINCIPAL ===========================
          Text(
            "De la loi pénale",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 6),

          Text(
            "Accédez aux fiches PDF essentielles : classification des infractions, "
            "application de la loi pénale, bases de la législation pénale et éléments "
            "constitutifs de l’infraction.",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w500,
              fontSize: 13.5,
              height: 1.35,
              color: textSoft,
            ),
          ),

          const SizedBox(height: 18),

          // ================= MODULE 1 =================
          _ModuleCard(
            tag: 'dpg_loi_penale_classification_infractions',
            title: "Classification des infractions",
            subtitle:
                "Contraventions, délits, crimes : critères de distinction et logique générale.",
            imagePath: 'assets/images/classification.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx/generalites/classification_infractions',
            ),
          ),
          const SizedBox(height: 14),

          // ================= MODULE 2 =================
          _ModuleCard(
            tag: 'dpg_loi_penale_etendue_application_lois',
            title: "Étendue d’application des lois",
            subtitle:
                "Application dans le temps et dans l’espace : principes et exceptions.",
            imagePath: 'assets/images/droit_penal_general.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/droit_penal_general/loi_penale/etendue_application_lois',
            ),
          ),
          const SizedBox(height: 14),

          // ================= MODULE 3 =================
          _ModuleCard(
            tag: 'dpg_loi_penale_generalites_legislation_penale',
            title: "Généralités sur la législation pénale",
            subtitle:
                "Définitions clés, sources, grands principes et architecture générale.",
            imagePath: 'assets/images/generalite.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/droit_penal_general/loi_penale/generalites_legislation_penale',
            ),
          ),
          const SizedBox(height: 14),

          // ================= MODULE 4 =================
          _ModuleCard(
            tag: 'dpg_loi_penale_elements_constitutifs_infraction',
            title: "Les éléments constitutifs de l’infraction",
            subtitle:
                "Élément légal, matériel et moral : comment se forme l’infraction.",
            imagePath: 'assets/images/infraction_materiel.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/droit_penal_general/loi_penale/elements_constitutifs_infraction',
            ),
          ),

          const SizedBox(height: 22),

          // ================= MODULE 7 — QUIZ =================
          _ModuleCard(
            tag: 'droit_penal_general',
            title: 'Quiz — Droit pénal général',
            subtitle:
                'Testez votre maîtrise des principes fondamentaux et des notions clés du droit pénal général.',
            imagePath: 'assets/images/quiz.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx/droit_penal/quiz/droit_penal_general',
            ),
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
//  CARD MODULE — identique à ton template
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

    final Color subtitleColor = isDark
        ? textSoft
        : Colors.white.withValues(alpha: 0.92);
    final Color badgeBg = Colors.white.withValues(alpha: 0.14);
    final Color borderClr = Colors.white.withValues(alpha: 0.18);

    return GestureDetector(
      onTap: onTap,
      child: Container(
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
                    Colors.black.withValues(alpha: .25),
                    Colors.black.withValues(alpha: .60),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badge
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
                      'PDF',
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
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.fustat(
                      fontWeight: FontWeight.w900,
                      fontSize: 24,
                      height: 1.05,
                      color: Colors.white,
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
    );
  }
}
