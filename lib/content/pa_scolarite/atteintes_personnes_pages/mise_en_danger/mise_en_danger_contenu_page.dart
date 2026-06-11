import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaMiseEnDangerContenuPage extends StatelessWidget {
  const PaMiseEnDangerContenuPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/atteintes_personnes/mise_en_danger';

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
            "La mise en danger de la personne",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Accédez aux documents essentiels relatifs aux infractions de mise en danger "
            "et aux comportements pénalement réprimés qui exposent autrui à un risque.",
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
            tag: 'mise_en_danger_diffusion_informations',
            title: "La mise en danger par la diffusion d’informations",
            subtitle:
                "Conditions, éléments constitutifs et logique de répression.",
            imagePath: 'assets/images/mise_en_danger.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/atteintes_personnes/mise_en_danger/mise_en_danger_diffusion_informations',
            ),
          ),
          const SizedBox(height: 14),

          // ================= PDF 2 =================
          _ModuleCard(
            tag: 'mise_en_danger_non_assistance_peril',
            title: "La non-assistance à personne en péril",
            subtitle:
                "Notion de péril, obligation d’assistance et limites légales.",
            imagePath: 'assets/images/mise_en_danger.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/atteintes_personnes/mise_en_danger/non_assistance_personne_peril',
            ),
          ),
          const SizedBox(height: 14),

          // ================= PDF 3 =================
          _ModuleCard(
            tag: 'mise_en_danger_abus_frauduleux_ignorance_faiblesse',
            title: "L’abus frauduleux de l’état d’ignorance ou de faiblesse",
            subtitle:
                "Victime vulnérable, manœuvres, élément intentionnel et preuve.",
            imagePath: 'assets/images/mise_en_danger.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/atteintes_personnes/mise_en_danger/abus_frauduleux_ignorance_faiblesse',
            ),
          ),
          const SizedBox(height: 14),

          // ================= PDF 4 =================
          _ModuleCard(
            tag: 'mise_en_danger_delaissement_personne',
            title: "Le délaissement d’une personne hors d’état de se protéger",
            subtitle: "Définition, circonstances, éléments matériels et moral.",
            imagePath: 'assets/images/mise_en_danger.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/atteintes_personnes/mise_en_danger/delaissement_personne_hors_etat',
            ),
          ),
          const SizedBox(height: 14),

          // ================= PDF 5 =================
          _ModuleCard(
            tag: 'mise_en_danger_non_obstacle_crime_delit',
            title: "Le non-obstacle à la commission d’un crime ou d’un délit",
            subtitle:
                "Cas visés, conditions d’engagement de responsabilité, limites.",
            imagePath: 'assets/images/mise_en_danger.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/atteintes_personnes/mise_en_danger/non_obstacle_commission_crime_delit',
            ),
          ),
          const SizedBox(height: 14),

          // ================= PDF 6 =================
          _ModuleCard(
            tag: 'mise_en_danger_risque_cause_autrui',
            title: "Le risque causé à autrui",
            subtitle:
                "Mise en danger délibérée, violation d’une obligation, caractérisation.",
            imagePath: 'assets/images/mise_en_danger.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/atteintes_personnes/mise_en_danger/risque_cause_autrui',
            ),
          ),

          const SizedBox(height: 22),

          // ================= QUIZ =================
          _ModuleCard(
            tag: 'quiz_mise_en_danger',
            title: 'Quiz — Mise en danger de la personne',
            subtitle:
                'Testez vos connaissances sur les notions clés et les infractions du module.',
            imagePath: 'assets/images/quiz.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () =>
                _openRoute(context, '/gpx/crimes_personne/quiz/mise_en_danger'),
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
                      title.toLowerCase().startsWith('quiz') ? 'QUIZ' : 'PDF',
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
