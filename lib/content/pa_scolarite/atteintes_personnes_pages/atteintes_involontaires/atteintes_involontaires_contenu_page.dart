import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaAtteintesInvolontairesContenuPage extends StatelessWidget {
  const PaAtteintesInvolontairesContenuPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/atteintes_personnes/atteintes_involontaires';

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
          "Crimes & délits contre la personne",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
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
          Text(
            "Atteintes involontaires",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Accédez aux fiches essentielles relatives aux atteintes involontaires "
            "(définitions, éléments constitutifs, circonstances et répression).",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w500,
              fontSize: 13.5,
              height: 1.35,
              color: textSoft,
            ),
          ),
          const SizedBox(height: 18),

          // ================= 1 =================
          _ModuleCard(
            tag: 'atteintes_involontaires_participation_groupement_violent',
            title: "La participation à un groupement violent",
            subtitle: "Définition, éléments constitutifs et sanctions.",
            imagePath: 'assets/images/personnalite.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/atteintes_personnes/atteintes_involontaires/participation_groupement_violent',
            ),
          ),
          const SizedBox(height: 14),

          // ================= 2 =================
          _ModuleCard(
            tag: 'atteintes_involontaires_conducteur_vtm',
            title:
                "Les atteintes involontaires à l’intégrité de la personne commises par le conducteur d’un véhicule terrestre à moteur",
            subtitle: "Cadre légal, qualification et répression.",
            imagePath: 'assets/images/personnalite.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/atteintes_personnes/atteintes_involontaires/atteintes_involontaires_conducteur_vtm',
            ),
          ),
          const SizedBox(height: 14),

          // ================= 3 =================
          _ModuleCard(
            tag: 'atteintes_involontaires_itt_inferieure_3_mois',
            title:
                "Les atteintes involontaires à l’intégrité de la personne inférieure à 3 mois",
            subtitle: "Éléments constitutifs, aggravations et sanctions.",
            imagePath: 'assets/images/personnalite.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/atteintes_personnes/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois',
            ),
          ),
          const SizedBox(height: 14),

          // ================= 4 =================
          _ModuleCard(
            tag: 'atteintes_involontaires_itt_superieure_3_mois',
            title:
                "Les atteintes involontaires à l’intégrité de la personne ITT > 3 mois",
            subtitle: "Notion, qualification et répression.",
            imagePath: 'assets/images/personnalite.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/atteintes_personnes/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois',
            ),
          ),
          const SizedBox(height: 14),

          // ================= 5 =================
          _ModuleCard(
            tag: 'atteintes_involontaires_violation_deliberee_obligation',
            title:
                "Les atteintes involontaires par la violation manifestement délibérée d’une obligation particulière de sécurité ou de prudence",
            subtitle: "Conditions, aggravations et sanctions.",
            imagePath: 'assets/images/personnalite.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/atteintes_personnes/atteintes_involontaires/atteintes_involontaires_violation_manifestement_deliberee_obligation',
            ),
          ),
          const SizedBox(height: 14),

          // ================= 6 =================
          _ModuleCard(
            tag: 'atteintes_volontaires_qualifiees_violences',
            title:
                "Les atteintes volontaires à l’intégrité de la personne qualifiées violences",
            subtitle: "Qualification, éléments et répression.",
            imagePath: 'assets/images/personnalite.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/atteintes_personnes/atteintes_involontaires/atteintes_volontaires_qualifiees_violences',
            ),
          ),
          const SizedBox(height: 14),

          // ================= 7 =================
          _ModuleCard(
            tag: 'homicide_involontaire',
            title: "L’homicide involontaire",
            subtitle: "Définition, éléments constitutifs et sanctions.",
            imagePath: 'assets/images/personnalite.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/atteintes_personnes/atteintes_involontaires/homicide_involontaire',
            ),
          ),

          const SizedBox(height: 22),

          // ================= QUIZ =================
          _ModuleCard(
            tag: 'quiz_atteintes_involontaires',
            title: 'Quiz — Atteintes involontaires',
            subtitle:
                'Testez vos connaissances sur les qualifications, éléments constitutifs et répression.',
            imagePath: 'assets/images/quiz.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx/crimes_personne/quiz/atteintes_involontaires',
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
                      title.toLowerCase().startsWith('quiz') ? 'QUIZ' : 'PDF',
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
                      fontSize: 24,
                      height: 1.05,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
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
