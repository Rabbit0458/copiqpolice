import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaControleMissionJudiciairePage extends StatelessWidget {
  const PaControleMissionJudiciairePage({super.key});

  static const String routeName =
      '/pa/dps_dpg/procedure_penale/pp_controle_mission_pj_intro';

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
          'Le contrôle de la mission de police judiciaire',
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
            'Le contrôle de la mission de police judiciaire',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 6),

          // ====================== INTRO / CONTEXTE ==========================
          RichText(
            textAlign: TextAlign.justify,
            text: TextSpan(
              style: GoogleFonts.fustat(
                fontWeight: FontWeight.w500,
                fontSize: 13.5,
                height: 1.35,
                color: textSoft,
              ),
              children: [
                const TextSpan(
                  text:
                      'Les membres de la police sont des fonctionnaires insérés dans le cadre d’une administration hiérarchisée et, '
                      'à ce titre, contrôlés par leurs supérieurs. En raison de l’importance des pouvoirs de police judiciaire, '
                      'qui impliquent des investigations dérogatoires au principe de la liberté individuelle, un contrôle de nature '
                      'judiciaire est exercé par les magistrats garants de la liberté des citoyens. ',
                ),
                TextSpan(
                  text: 'L’Article 13 du Code de Procédure Pénale',
                  style: GoogleFonts.fustat(
                    fontWeight: FontWeight.w800,
                    fontSize: 13.5,
                    height: 1.35,
                    color: Colors.red,
                  ),
                ),
                const TextSpan(
                  text:
                      ' précise que la police judiciaire est placée sous la surveillance du procureur général près la cour d’appel '
                      'et sous le contrôle de la chambre de l’instruction.',
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // =============== CHAPITRE 1 — PROCUREUR GÉNÉRAL ===================
          _ModuleCard(
            tag: 'pp_controle_pj_chap1_procureur_general',
            title:
                'Chapitre 1 : Le rôle du procureur général près la cour d’appel',
            subtitle:
                'Surveillance de la police judiciaire, pouvoir d’orientation, directives et contrôle de l’action des enquêteurs au niveau de la cour d’appel.',
            imagePath: 'assets/images/procedure_penale.jpg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/procedure_penale/pp_controle_mission_pj_role_procureur_general',
            ),
          ),
          const SizedBox(height: 14),

          // ======= CHAPITRE 2 — INSPECTION GÉNÉRALE DE LA JUSTICE ===========
          _ModuleCard(
            tag: 'pp_controle_pj_chap2_inspection_generale_justice',
            title:
                'Chapitre 2 : Le rôle de l’Inspection générale de la justice',
            subtitle:
                'Contrôle externe, inspections, audits des services et enquêtes administratives sur le fonctionnement de la justice et de la police judiciaire.',
            imagePath: 'assets/images/controle_identite.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/procedure_penale/pp_controle_mission_pj_inspection_generale_justice',
            ),
          ),
          const SizedBox(height: 14),

          // ======== CHAPITRE 3 — CHAMBRE DE L’INSTRUCTION ===================
          _ModuleCard(
            tag: 'pp_controle_pj_chap3_chambre_instruction',
            title: 'Chapitre 3 : Le rôle de la chambre de l’instruction',
            subtitle:
                'Organe de contrôle juridictionnel, vérification de la régularité des actes, protection des libertés individuelles et contrôle des enquêtes.',
            imagePath: 'assets/images/libertes_intro.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/procedure_penale/pp_controle_mission_pj_chambre_instruction',
            ),
          ),

          const SizedBox(height: 22),
        ],
      ),
    );
  }

  // OUVERTURE D’UNE AUTRE PAGE (pas de PDF ici)
  void _openRoute(BuildContext context, String routeName) {
    Navigator.of(context).pushNamed(routeName);
  }
}

// ---------------------------------------------------------------------------
//  CARD MODULE — COHÉRENCE VISUELLE AVEC TES AUTRES PAGES
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
