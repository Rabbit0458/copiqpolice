import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ResponsabilitePenaleContenuPage extends StatelessWidget {
  const ResponsabilitePenaleContenuPage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/droit_pénale_général_pages/responsabilite_penale';

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
          "Responsabilité pénale",
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
            "Responsabilité pénale",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 6),

          Text(
            "Étudiez les fondements de la responsabilité pénale : principes généraux, "
            "complicité et coaction, responsabilité des personnes morales ainsi que "
            "les causes d’irresponsabilité ou d’atténuation.",
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
            tag: 'dpg_responsabilite_penale_principes_generaux',
            title: "Principes généraux de la responsabilité pénale",
            subtitle:
                "Fondements, conditions et logique générale de l’imputabilité pénale.",
            imagePath: 'assets/images/cat_bases_juridiques.jpg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx_scolarite_pages/droit_pénale_général_pages/responsabilite_penale/principes_generaux',
            ),
          ),
          const SizedBox(height: 14),

          // ================= MODULE 2 =================
          _ModuleCard(
            tag: 'dpg_responsabilite_penale_complicite_coaction',
            title: "La complicité et la coaction",
            subtitle:
                "Aide, assistance, provocation et participation à l’infraction.",
            imagePath: 'assets/images/complicite.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx_scolarite_pages/droit_pénale_général_pages/responsabilite_penale/complicite_coaction',
            ),
          ),
          const SizedBox(height: 14),

          // ================= MODULE 3 =================
          _ModuleCard(
            tag: 'dpg_responsabilite_penale_personnes_morales',
            title: "La responsabilité pénale des personnes morales",
            subtitle:
                "Conditions d’engagement et spécificités de la responsabilité des personnes morales.",
            imagePath: 'assets/images/atteintes_involontaires.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx_scolarite_pages/droit_pénale_général_pages/responsabilite_penale/personnes_morales',
            ),
          ),
          const SizedBox(height: 14),

          // ================= MODULE 4 =================
          _ModuleCard(
            tag: 'dpg_responsabilite_penale_irresponsabilite_attenuation',
            title:
                "Les causes d’irresponsabilité ou d’atténuation de la responsabilité",
            subtitle:
                "Troubles psychiques, contrainte, erreur, minorité et causes légales.",
            imagePath: 'assets/images/defaut_permis.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx_scolarite_pages/droit_pénale_général_pages/responsabilite_penale/causes_irresponsabilite',
            ),
          ),

          const SizedBox(height: 22),
          // ================= MODULE 7 — QUIZ =================
          _ModuleCard(
            tag: 'responsabilite_penal_general',
            title: 'Quiz — Responsabilité pénale',
            subtitle:
                'Testez votre maîtrise des principes fondamentaux et des notions clés des responsabilité pénale.',
            imagePath: 'assets/images/quiz.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx/droit_penal/quiz/responsabilite_penal_general',
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
