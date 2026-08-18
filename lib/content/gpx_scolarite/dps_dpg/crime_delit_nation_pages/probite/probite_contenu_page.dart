import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class ProbiteContenuPage extends StatelessWidget {
  const ProbiteContenuPage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/crime_delit_nation_pages/probite';

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
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: textMain),
          tooltip: ScolariteText.value(
            "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/probite_contenu_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/probite_contenu_page.dart",
            "f00002",
            "Crime & délit contre la nation",
          ),
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
            ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/probite_contenu_page.dart",
              "f00003",
              "La probité",
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/probite_contenu_page.dart",
                  "f00004",
                  "Accédez aux fiches essentielles relatives aux atteintes à la probité ",
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/probite_contenu_page.dart",
                  "f00005",
                  "(définitions, éléments constitutifs, circonstances et répression).",
                ),
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
            tag: 'nation_probite_concussion',
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/probite_contenu_page.dart",
              "f00006",
              "La concussion",
            ),
            subtitle: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/probite_contenu_page.dart",
              "f00007",
              "Définition, éléments constitutifs et répression.",
            ),
            imagePath: 'assets/images/probite.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx_scolarite_pages/crime_delit_nation_pages/probite/concussion',
            ),
          ),
          const SizedBox(height: 14),

          // ================= 2 =================
          _ModuleCard(
            tag: 'nation_probite_corruption',
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/probite_contenu_page.dart",
              "f00008",
              "La corruption",
            ),
            subtitle: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/probite_contenu_page.dart",
              "f00009",
              "Définition, éléments constitutifs et répression.",
            ),
            imagePath: 'assets/images/probite.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx_scolarite_pages/crime_delit_nation_pages/probite/corruption',
            ),
          ),
          const SizedBox(height: 14),

          // ================= 3 =================
          _ModuleCard(
            tag: 'nation_probite_trafic_influence',
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/probite_contenu_page.dart",
              "f00010",
              "Le trafic d’influence",
            ),
            subtitle: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/probite_contenu_page.dart",
              "f00011",
              "Définition, éléments constitutifs et répression.",
            ),
            imagePath: 'assets/images/probite.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx_scolarite_pages/crime_delit_nation_pages/probite/trafic_influence',
            ),
          ),

          const SizedBox(height: 22),

          // ================= QUIZ =================
          _ModuleCard(
            tag: 'quiz_probite',
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/probite_contenu_page.dart",
              "f00012",
              'Quiz — La probité',
            ),
            subtitle: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/probite_contenu_page.dart",
              "f00013",
              'Testez vos connaissances sur les qualifications, éléments constitutifs et répression.',
            ),
            imagePath: 'assets/images/quiz.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(context, '/gpx/nation/quiz/probite'),
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
        height: ScolariteText.adaptiveCardHeight(context, cardCount: 4),
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
