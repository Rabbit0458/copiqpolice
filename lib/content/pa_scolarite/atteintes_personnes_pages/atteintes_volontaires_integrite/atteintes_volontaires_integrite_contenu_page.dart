import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaAtteintesVolontairesIntegriteContenuPage extends StatelessWidget {
  const PaAtteintesVolontairesIntegriteContenuPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/atteintes_personnes/atteintes_volontaires_integrite';

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
            "Atteintes volontaires à l’intégrité",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Accédez aux fiches essentielles relatives aux atteintes volontaires à l’intégrité "
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
            tag: 'menace_sans_condition',
            title:
                "La menace sans condition de commettre un crime ou un délit contre les personnes",
            subtitle: "Définition, conditions et sanctions.",
            imagePath: 'assets/images/atteintes_integrite.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/atteintes_personnes/atteintes_volontaires_integrite/menace_sans_condition',
            ),
          ),
          const SizedBox(height: 14),

          // ================= 2 =================
          _ModuleCard(
            tag: 'embuscade',
            title: "L’embuscade",
            subtitle: "Cadre légal, éléments constitutifs et peines.",
            imagePath: 'assets/images/atteintes_integrite.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/atteintes_personnes/atteintes_volontaires_integrite/embuscade',
            ),
          ),
          const SizedBox(height: 14),

          // ================= 3 =================
          _ModuleCard(
            tag: 'appels_messages_malveillants_agressions_sonores',
            title:
                "Les appels téléphoniques et les envois de messages malveillants ou agressions sonores",
            subtitle: "Qualification, éléments et répression.",
            imagePath: 'assets/images/atteintes_integrite.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/atteintes_personnes/atteintes_volontaires_integrite/appels_messages_malveillants_agressions_sonores',
            ),
          ),
          const SizedBox(height: 14),

          // ================= 4 =================
          _ModuleCard(
            tag: 'menaces_avec_condition',
            title:
                "Les menaces de crime ou délit avec ordre de remplir une condition",
            subtitle: "Conditions, aggravations et sanctions.",
            imagePath: 'assets/images/atteintes_integrite.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/atteintes_personnes/atteintes_volontaires_integrite/menaces_avec_condition',
            ),
          ),
          const SizedBox(height: 14),

          // ================= 5 =================
          _ModuleCard(
            tag: 'tortures_actes_barbarie',
            title: "Les tortures et actes de barbarie",
            subtitle: "Définition, aggravations et répression.",
            imagePath: 'assets/images/atteintes_integrite.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/atteintes_personnes/atteintes_volontaires_integrite/tortures_actes_barbarie',
            ),
          ),
          const SizedBox(height: 14),

          // ================= 6 =================
          _ModuleCard(
            tag: 'violences_habituelles_couple_ex',
            title:
                "Les violences habituelles au sein du couple ou bien commises par un ex-",
            subtitle: "Cadre légal, aggravations et peines.",
            imagePath: 'assets/images/atteintes_integrite.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/atteintes_personnes/atteintes_volontaires_integrite/violences_habituelles_couple_ex',
            ),
          ),
          const SizedBox(height: 14),

          // ================= 7 =================
          _ModuleCard(
            tag: 'violences_habituelles_mineur_vulnerable',
            title:
                "Les violences habituelles sur mineur ou personne vulnérable",
            subtitle: "Éléments constitutifs, aggravations et sanctions.",
            imagePath: 'assets/images/atteintes_integrite.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/atteintes_personnes/atteintes_volontaires_integrite/violences_habituelles_mineur_vulnerable',
            ),
          ),
          const SizedBox(height: 14),

          // ================= 8 =================
          _ModuleCard(
            tag: 'violences_sur_fsi',
            title: "Les violences sur FSI",
            subtitle: "Qualification, aggravations et répression.",
            imagePath: 'assets/images/atteintes_integrite.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/atteintes_personnes/atteintes_volontaires_integrite/violences_sur_fsi',
            ),
          ),

          const SizedBox(height: 22),

          // ================= QUIZ =================
          _ModuleCard(
            tag: 'quiz_atteintes_volontaires_integrite',
            title: 'Quiz — Atteintes volontaires à l’intégrité',
            subtitle:
                'Testez vos connaissances sur les qualifications, éléments constitutifs et répression.',
            imagePath: 'assets/images/quiz.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx/crimes_personne/quiz/atteintes_volontaires_integrite',
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
