import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BraceletMaisonContenuPage extends StatelessWidget {
  const BraceletMaisonContenuPage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/procédure_pénale_pages/pp_assignation_residence_surveillance_contenu';

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
          "Assignation à résidence – Bracelet",
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
            "Assignation à résidence avec surveillance électronique\n(« bracelet à la maison »)",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 6),

          Text(
            "Conditions de mise en œuvre de l’assignation à résidence, "
            "modalités concrètes du placement sous surveillance électronique "
            "(bracelet) et déroulement pratique de la mesure au quotidien.",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w500,
              fontSize: 13.5,
              height: 1.35,
              color: textSoft,
            ),
          ),

          const SizedBox(height: 18),

          // ================= MODULE 1 — CONDITIONS DE MISE EN ŒUVRE ============
          _ModuleCard(
            tag: 'pp_assignation_residence_conditions',
            title: "Conditions de mise en œuvre de l'assignation à résidence",
            subtitle:
                "Infractions concernées, critères de recours, décision du juge, "
                "articulation avec le contrôle judiciaire et la détention provisoire.",
            imagePath: 'assets/images/procedure_penale.jpg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx_scolarite_pages/procédure_pénale_pages/pp_assignation_residence_conditions',
            ),
          ),
          const SizedBox(height: 14),

          // ========== MODULE 2 — MODALITÉS DU PLACEMENT SOUS SE ============
          _ModuleCard(
            tag: 'pp_bracelet_modalites_placement',
            title: "Modalités du placement sous surveillance électronique",
            subtitle:
                "Mise en place du bracelet, aspects techniques et matériels, "
                "périmètre autorisé, contrôle des horaires et rôle des différents acteurs.",
            imagePath: 'assets/images/bracelet.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx_scolarite_pages/procédure_pénale_pages/pp_bracelet_modalites_placement',
            ),
          ),
          const SizedBox(height: 14),

          // ================= MODULE 3 — DÉROULEMENT DE LA MESURE ==============
          _ModuleCard(
            tag: 'pp_bracelet_deroulement_mesure',
            title: 'Déroulement de la mesure',
            subtitle:
                "Vie quotidienne sous bracelet, contrôles, incidents, manquements, "
                "révocation, conversion en détention et fin de la mesure.",
            imagePath: 'assets/images/controle_identite.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx_scolarite_pages/procédure_pénale_pages/pp_bracelet_deroulement_mesure',
            ),
          ),

          const SizedBox(height: 22),
          // ================= MODULE 7 — QUIZ =================
          _ModuleCard(
            tag: 'quiz_bracelet_electronique',
            title: 'Quiz — Bracelet électronique',
            subtitle:
                'Testez votre maîtrise du déroulement de la mesure et des règles applicables au bracelet électronique.',
            imagePath: 'assets/images/quiz.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx/procedure_penale/quiz/bracelet_electronique',
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
