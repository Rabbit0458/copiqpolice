import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ClassificationInfractionsContenuPageLoiPenal extends StatelessWidget {
  const ClassificationInfractionsContenuPageLoiPenal({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/droit_pénale_général_pages/loi_penale/classification_infractions';

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
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: textMain),
          tooltip: 'Retour',
        ),
        title: Text(
          "Classification des infractions",
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
            "Classification des infractions",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 6),

          Text(
            "Accédez aux sections essentielles : définition, classification, tableau "
            "de la classification tripartite et conséquences pratiques.",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w500,
              fontSize: 13.5,
              height: 1.35,
              color: textSoft,
            ),
          ),

          const SizedBox(height: 18),

          // ================= MODULE 1 — DÉFINITION =================
          _ModuleCard(
            tag: 'loi_penale_classification_infractions_definition',
            title: "DÉFINITION",
            subtitle:
                "Comprendre ce qu’est la classification des infractions et son objectif.",
            imagePath: 'assets/images/classification.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx_scolarite_pages/droit_pénale_général_pages/loi_penale/classification_infractions/definition',
            ),
          ),
          const SizedBox(height: 14),

          // ================= MODULE 2 — CLASSIFICATION =================
          _ModuleCard(
            tag: 'loi_penale_classification_infractions_classification',
            title: "CLASSIFICATION DES INFRACTIONS",
            subtitle:
                "Contraventions, délits, crimes : critères de distinction et logique générale.",
            imagePath: 'assets/images/droit_penal_general.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx_scolarite_pages/droit_pénale_général_pages/loi_penale/classification_infractions/classification',
            ),
          ),
          const SizedBox(height: 14),

          // ================= MODULE 3 — TABLEAU =================
          _ModuleCard(
            tag: 'loi_penale_classification_infractions_tableau_tripartite',
            title: "TABLEAU : CLASSIFICATION TRIPARTITE DES INFRACTIONS",
            subtitle:
                "Tableau synthèse : catégories, juridictions, peines encourues (vue d’ensemble).",
            imagePath: 'assets/images/generalite.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx_scolarite_pages/droit_pénale_général_pages/loi_penale/classification_infractions/tableau_classification_tripartite',
            ),
          ),
          const SizedBox(height: 14),

          // ================= MODULE 4 — CONSÉQUENCES =================
          _ModuleCard(
            tag: 'loi_penale_classification_infractions_consequences',
            title: "CONSÉQUENCES DE LA CLASSIFICATION DES INFRACTIONS",
            subtitle:
                "Effets en pratique : compétence, procédure, sanctions et impacts juridiques.",
            imagePath: 'assets/images/infraction_materiel.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx_scolarite_pages/droit_pénale_général_pages/loi_penale/classification_infractions/consequences',
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
        : Colors.white.withOpacity(0.92);
    final Color badgeBg = Colors.white.withOpacity(0.14);
    final Color borderClr = Colors.white.withOpacity(0.18);

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
                    Colors.black.withOpacity(.25),
                    Colors.black.withOpacity(.60),
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
