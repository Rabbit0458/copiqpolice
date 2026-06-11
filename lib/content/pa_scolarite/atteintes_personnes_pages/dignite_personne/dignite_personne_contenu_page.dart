import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaDignitePersonneContenuPage extends StatelessWidget {
  const PaDignitePersonneContenuPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/atteintes_personnes/dignite_personne';

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
            "Atteintes à la dignité de la personne",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Accédez aux fiches essentielles relatives aux infractions portant atteinte à la dignité "
            "de la personne (définitions, éléments constitutifs, circonstances et répression).",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w500,
              fontSize: 13.5,
              height: 1.35,
              color: textSoft,
            ),
          ),
          const SizedBox(height: 18),

          // ================= PDF 1 =================
          _ModuleCard(
            tag: 'dignite_dissimulation_forcee_visage',
            title: "La dissimulation forcée du visage",
            subtitle: "Cadre légal, éléments constitutifs et sanctions.",
            imagePath: 'assets/images/dignite_dissimulation_forcee_visage.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/atteintes_personnes/dignite_personne/dissimulation_forcee_visage',
            ),
          ),
          const SizedBox(height: 14),

          // ================= PDF 2 =================
          _ModuleCard(
            tag: 'dignite_retribution_inexistante_insuffisante',
            title:
                "La rétribution inexistante ou insuffisante du travail d’une personne vulnérable ou dépendante",
            subtitle: "Qualification, caractérisation et répression.",
            imagePath:
                'assets/images/dignite_retribution_inexistante_insuffisante.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/atteintes_personnes/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante',
            ),
          ),
          const SizedBox(height: 14),

          // ================= PDF 3 =================
          _ModuleCard(
            tag: 'dignite_soumission_conditions_travail_hebergement',
            title:
                "La soumission d’une personne vulnérable ou dépendante à des conditions de travail ou d’hébergement incompatibles avec la dignité humaine",
            subtitle: "Notion de vulnérabilité, conditions et sanctions.",
            imagePath:
                'assets/images/dignite_soumission_conditions_travail_hebergement.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/atteintes_personnes/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite',
            ),
          ),
          const SizedBox(height: 14),

          // ================= PDF 4 =================
          _ModuleCard(
            tag: 'dignite_traite_etres_humains',
            title: "La traite des êtres humains",
            subtitle: "Définition, moyens, finalités et répression.",
            imagePath: 'assets/images/dignite_traite_etres_humains.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/atteintes_personnes/dignite_personne/traite_etres_humains',
            ),
          ),
          const SizedBox(height: 14),

          // ================= PDF 5 =================
          _ModuleCard(
            tag: 'dignite_violation_profanation_tombeaux',
            title:
                "La violation et la profanation de tombeaux, de sépultures, d’urnes cinéraires ou de monuments édifiés à la mémoire des morts",
            subtitle: "Éléments constitutifs, aggravations et sanctions.",
            imagePath:
                'assets/images/dignite_violation_profanation_tombeaux.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/atteintes_personnes/dignite_personne/violation_profanation_tombeaux_sepultures_urnes_monuments',
            ),
          ),
          const SizedBox(height: 14),

          // ================= PDF 6 =================
          _ModuleCard(
            tag: 'dignite_integrite_cadavre',
            title: "L’atteinte à l’intégrité du cadavre",
            subtitle: "Notion, comportements visés et répression.",
            imagePath: 'assets/images/dignite_integrite_cadavre.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/atteintes_personnes/dignite_personne/atteinte_integrite_cadavre',
            ),
          ),
          const SizedBox(height: 14),

          // ================= PDF 7 =================
          _ModuleCard(
            tag: 'dignite_proxenetisme_hotelier',
            title: "Le proxénétisme hôtelier",
            subtitle: "Qualification, conditions et sanctions.",
            imagePath: 'assets/images/dignite_proxenetisme_hotelier.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/atteintes_personnes/dignite_personne/proxenetisme_hotelier',
            ),
          ),
          const SizedBox(height: 14),

          // ================= PDF 8 =================
          _ModuleCard(
            tag: 'dignite_proxenetisme_assimilation',
            title: "Le proxénétisme par assimilation",
            subtitle: "Comportements assimilés, preuve et répression.",
            imagePath: 'assets/images/dignite_proxenetisme_hotelier.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/atteintes_personnes/dignite_personne/proxenetisme_assimilation',
            ),
          ),
          const SizedBox(height: 14),

          // ================= PDF 9 =================
          _ModuleCard(
            tag: 'dignite_proxenetisme',
            title: "Le proxénétisme",
            subtitle: "Définition, caractérisation et sanctions.",
            imagePath: 'assets/images/dignite_proxenetisme.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/atteintes_personnes/dignite_personne/proxenetisme',
            ),
          ),
          const SizedBox(height: 14),

          // ================= PDF 10 =================
          _ModuleCard(
            tag: 'dignite_recours_prostitution_mineurs_vulnerables',
            title:
                "Le recours à la prostitution de mineurs ou de personnes particulièrement vulnérables",
            subtitle: "Protection renforcée et répression.",
            imagePath:
                'assets/images/dignite_recours_prostitution_mineurs_vulnerables.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/atteintes_personnes/dignite_personne/recours_prostitution_mineurs_personnes_vulnerables',
            ),
          ),
          const SizedBox(height: 14),

          // ================= PDF 11 =================
          _ModuleCard(
            tag: 'dignite_discriminations',
            title: "Les discriminations",
            subtitle: "Définition, éléments constitutifs et sanctions.",
            imagePath: 'assets/images/dignite_discriminations.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/atteintes_personnes/dignite_personne/discriminations',
            ),
          ),

          const SizedBox(height: 22),

          // ================= QUIZ =================
          _ModuleCard(
            tag: 'quiz_dignite_personne',
            title: 'Quiz — Atteintes à la dignité de la personne',
            subtitle:
                'Testez vos connaissances sur les qualifications, éléments constitutifs et répression.',
            imagePath: 'assets/images/quiz.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx/crimes_personne/quiz/dignite_personne',
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
