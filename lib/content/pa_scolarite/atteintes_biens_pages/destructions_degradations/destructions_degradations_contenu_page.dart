import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaDestructionsDegradationsContenuPage extends StatelessWidget {
  const PaDestructionsDegradationsContenuPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/atteintes_biens/destructions_degradations';

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
          "Crimes & délits contre les biens",
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
            "Les destructions, dégradations et détériorations",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Accédez aux fiches essentielles : définitions, conditions de caractérisation, "
            "circonstances aggravantes, tentative, complicité et répression.",
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
            tag: 'dd_detention_transport_preparation',
            title:
                "La détention ou le transport de substances ou produits incendiaires ou explosifs en vue de la préparation de destruction, dégradation ou détérioration dangereuses ou d’une atteinte aux personnes",
            subtitle: "Cadre légal, éléments et sanctions.",
            imagePath: 'assets/images/destructions.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/atteintes_biens/destructions_degradations/detention_transport_substances_preparation',
            ),
          ),
          const SizedBox(height: 14),

          // ================= 2 =================
          _ModuleCard(
            tag: 'dd_detention_transport_sans_motif',
            title:
                "La détention ou le transport de substances ou produits incendiaires ou explosifs sans motif légitime permettant de commettre des destructions, dégradations ou détériorations dangereuses",
            subtitle: "Conditions, preuve et répression.",
            imagePath: 'assets/images/destructions.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/atteintes_biens/destructions_degradations/detention_transport_sans_motif_legitime',
            ),
          ),
          const SizedBox(height: 14),

          // ================= 3 =================
          _ModuleCard(
            tag: 'dd_diffusion_procedes_engins',
            title:
                "La diffusion de procédés permettant la fabrication d’engins de destruction",
            subtitle: "Qualification, éléments et sanctions.",
            imagePath: 'assets/images/destructions.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/atteintes_biens/destructions_degradations/diffusion_procedes_fabrication_engins',
            ),
          ),
          const SizedBox(height: 14),

          // ================= 4 =================
          _ModuleCard(
            tag: 'dd_dangereuses_intentionnelle',
            title:
                "Les destructions, dégradations et détériorations dangereuses pour les personnes (infraction intentionnelle)",
            subtitle: "Éléments constitutifs et répression.",
            imagePath: 'assets/images/destructions.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/atteintes_biens/destructions_degradations/dangereuses_personnes_intentionnelle',
            ),
          ),
          const SizedBox(height: 14),

          // ================= 5 =================
          _ModuleCard(
            tag: 'dd_dangereuses_non_intentionnelle',
            title:
                "Les destructions, dégradations et détériorations dangereuses pour les personnes (infraction non intentionnelle)",
            subtitle: "Faute, causalité et sanctions.",
            imagePath: 'assets/images/destructions.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/atteintes_biens/destructions_degradations/dangereuses_personnes_non_intentionnelle',
            ),
          ),
          const SizedBox(height: 14),

          // ================= 6 =================
          _ModuleCard(
            tag: 'dd_sans_danger_dommage_important',
            title:
                "Les destructions, dégradations et détériorations ne présentant pas un danger pour les personnes et entraînant un dommage important",
            subtitle: "Qualification et répression.",
            imagePath: 'assets/images/destructions.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/atteintes_biens/destructions_degradations/sans_danger_dommage_important',
            ),
          ),
          const SizedBox(height: 14),

          // ================= 7 =================
          _ModuleCard(
            tag: 'dd_sans_danger_dommage_leger',
            title:
                "Les destructions, dégradations et détériorations ne présentant pas un danger pour les personnes et entraînant un dommage léger",
            subtitle: "Qualification et sanctions.",
            imagePath: 'assets/images/destructions.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/atteintes_biens/destructions_degradations/sans_danger_dommage_leger',
            ),
          ),
          const SizedBox(height: 14),

          // ================= 8 =================
          _ModuleCard(
            tag: 'dd_tags_inscriptions',
            title:
                "Les destructions, dégradations et détériorations par inscriptions, signes et dessins communément appelés tags",
            subtitle: "Cadre légal et répression.",
            imagePath: 'assets/images/destructions.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/atteintes_biens/destructions_degradations/tags_inscriptions_signes_dessins',
            ),
          ),
          const SizedBox(height: 14),

          // ================= 9 =================
          _ModuleCard(
            tag: 'dd_biens_culturels',
            title:
                "Les destructions, dégradations et détériorations portant sur des biens culturels publics ou classés",
            subtitle: "Protection renforcée et sanctions.",
            imagePath: 'assets/images/destructions.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/atteintes_biens/destructions_degradations/biens_culturels_publics_classes',
            ),
          ),
          const SizedBox(height: 14),

          // ================= 10 =================
          _ModuleCard(
            tag: 'dd_fausses_alertes',
            title: "Les fausses alertes",
            subtitle: "Qualification et répression.",
            imagePath: 'assets/images/destructions.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/atteintes_biens/destructions_degradations/fausses_alertes',
            ),
          ),
          const SizedBox(height: 14),

          // ================= 11 =================
          _ModuleCard(
            tag: 'dd_menaces_avec_condition',
            title:
                "Les menaces de destruction, de dégradation ou de détérioration avec condition",
            subtitle: "Éléments et sanctions.",
            imagePath: 'assets/images/destructions.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/atteintes_biens/destructions_degradations/menaces_avec_condition',
            ),
          ),
          const SizedBox(height: 14),

          // ================= 12 =================
          _ModuleCard(
            tag: 'dd_menaces_sans_condition',
            title:
                "Les menaces de destruction, de dégradation ou de détérioration sans condition",
            subtitle: "Éléments et sanctions.",
            imagePath: 'assets/images/destructions.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/atteintes_biens/destructions_degradations/menaces_sans_condition',
            ),
          ),

          const SizedBox(height: 22),

          // ================= QUIZ =================
          _ModuleCard(
            tag: 'quiz_dd',
            title: 'Quiz — Destructions, dégradations et détériorations',
            subtitle:
                'Testez vos connaissances sur les qualifications et sanctions.',
            imagePath: 'assets/images/quiz.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx/crimes_biens/quiz/destructions_degradations',
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
