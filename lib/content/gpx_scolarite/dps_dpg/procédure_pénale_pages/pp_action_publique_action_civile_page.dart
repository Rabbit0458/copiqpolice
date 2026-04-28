import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PPActionPubliqueActionCivilePage extends StatelessWidget {
  const PPActionPubliqueActionCivilePage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/procédure_pénale_pages/pp_action_publique_action_civile';

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
          'Action publique & civile',
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
            'Action publique et action civile\nà la suite d’une infraction pénale',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Fondements, acteurs, modalités d’exercice et extinction de '
            'l’action publique, articulation avec l’action civile et '
            'tableau synthétique des différentes actions possibles.',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w500,
              fontSize: 13.5,
              height: 1.35,
              color: textSoft,
            ),
          ),
          const SizedBox(height: 18),

          // ===================== CHAPITRE 1 — TITRE PRÉLIMINAIRE ============
          _ModuleCard(
            tag: 'pp_apac_ch1',
            title: 'Chapitre 1 — Titre préliminaire',
            subtitle:
                'Principes généraux, finalités de l’action publique, place de la victime et de la société dans la répression pénale.',
            imagePath: 'assets/images/generalite.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx_scolarite_pages/procédure_pénale_pages/pp_action_publique_action_civile/chapitre_1_titre_preliminaire',
            ),
          ),
          const SizedBox(height: 14),

          // ========== CHAPITRE 2 — SUJETS DE L’ACTION PUBLIQUE ==============
          _ModuleCard(
            tag: 'pp_apac_ch2',
            title: 'Chapitre 2 — Les sujets de l’action publique',
            subtitle:
                'Ministère public, autorités de poursuite, parties privées : rôles, compétences et initiatives possibles.',
            imagePath: 'assets/images/aggravations.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx_scolarite_pages/procédure_pénale_pages/pp_action_publique_action_civile/chapitre_2_sujets_action_publique',
            ),
          ),
          const SizedBox(height: 14),

          // ======== CHAPITRE 3 — EXERCICE DE L’ACTION PUBLIQUE ==============
          _ModuleCard(
            tag: 'pp_apac_ch3',
            title: 'Chapitre 3 — L’exercice de l’action publique',
            subtitle:
                'Déclenchement, modes de poursuite, opportunité des poursuites et principaux schémas procéduraux.',
            imagePath: 'assets/images/procedure_penale.jpg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx_scolarite_pages/procédure_pénale_pages/pp_action_publique_action_civile/chapitre_3_exercice_action_publique',
            ),
          ),
          const SizedBox(height: 14),

          // ======== CHAPITRE 4 — EXTINCTION DE L’ACTION PUBLIQUE ============
          _ModuleCard(
            tag: 'pp_apac_ch4',
            title: 'Chapitre 4 — L’extinction de l’action publique',
            subtitle:
                'Prescriptions, amnistie, décès, retrait de plainte et autres causes d’extinction de l’action publique.',
            imagePath: 'assets/images/reserve.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx_scolarite_pages/procédure_pénale_pages/pp_action_publique_action_civile/chapitre_4_extinction_action_publique',
            ),
          ),
          const SizedBox(height: 14),

          // ====================== TABLEAU SYNTHÉTIQUE =======================
          _ModuleCard(
            tag: 'pp_apac_tableau',
            title:
                'Tableau — Actions publique et civile\nsuite à une faute pénale',
            subtitle:
                'Comparatif des actions possibles, titulaires, délais, objet et effets : outil de révision rapide.',
            imagePath: 'assets/images/infraction_legal.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx_scolarite_pages/procédure_pénale_pages/pp_action_publique_action_civile/tableau_actions_publique_civile',
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
//  CARD MODULE — MÊME STYLE QUE TES AUTRES PAGES
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
