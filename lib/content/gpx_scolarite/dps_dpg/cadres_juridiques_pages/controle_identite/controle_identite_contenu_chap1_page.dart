// lib/gpx_scolarite_pages/cadres_juridiques/controle_identite_contenu_chap1_page.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class ControleIdentiteChap1ContenuPage extends StatelessWidget {
  const ControleIdentiteChap1ContenuPage({super.key});

  static const String routeName =
      '/gpx/cadres_juridiques/controle_identite/chapitre1';

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
            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_contenu_chap1_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_contenu_chap1_page.dart",
            "f00002",
            'Chapitre 1 — Contrôle d’identité',
          ),
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
          // ===================== TITRE & INTRO RAPIDE ======================
          Text(
            ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_contenu_chap1_page.dart",
              "f00003",
              'Chapitre 1 — Contrôle d’identité',
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              color: textMain,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_contenu_chap1_page.dart",
                  "f00004",
                  'Déclinaisons pratiques du contrôle d’identité : cadre général, contrôles préventifs, ',
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_contenu_chap1_page.dart",
                  "f00005",
                  'zones frontières, locaux professionnels, visites de véhicules et bagages, distinction ',
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_contenu_chap1_page.dart",
                  "f00006",
                  'avec le contrôle de réglementation, contrôle du séjour des étrangers et moyens de ',
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_contenu_chap1_page.dart",
                  "f00007",
                  'preuve de l’identité.',
                ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w500,
              fontSize: 13.5,
              height: 1.35,
              color: textSoft,
            ),
          ),
          const SizedBox(height: 18),

          // ===================== INTRODUCTION ==============================
          _ModuleCard(
            tag: 'chap1_intro',
            title: 'Introduction',
            subtitle:
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_contenu_chap1_page.dart",
                  "f00008",
                  'Objectifs du contrôle d’identité, place dans la procédure pénale et notions clés ',
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_contenu_chap1_page.dart",
                  "f00009",
                  'à maîtriser avant d’entrer dans le détail des différents types de contrôles.',
                ),
            imagePath: 'assets/images/controle_identité_chap1.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx/cadres_juridiques/controle_identite/chapitre1/introduction',
            ),
          ),
          const SizedBox(height: 14),

          // ===================== CADRE GENERAL DU CONTROLE =================
          _ModuleCard(
            tag: 'chap1_cadre_general',
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_contenu_chap1_page.dart",
              "f00010",
              'Cadre général du contrôle',
            ),
            subtitle:
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_contenu_chap1_page.dart",
                  "f00011",
                  'Fondements juridiques, autorités compétentes, finalités et limites du contrôle ',
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_contenu_chap1_page.dart",
                  "f00012",
                  'd’identité dans le respect des libertés individuelles.',
                ),
            imagePath: 'assets/images/controle_identité_chap1.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx/cadres_juridiques/controle_identite/chapitre1/cadre_general',
            ),
          ),
          const SizedBox(height: 14),

          // ===================== CONTROLES PREVENTIFS ======================
          _ModuleCard(
            tag: 'chap1_preventifs',
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_contenu_chap1_page.dart",
              "f00013",
              'Les contrôles préventifs',
            ),
            subtitle:
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_contenu_chap1_page.dart",
                  "f00014",
                  'Contrôles destinés à prévenir les atteintes à l’ordre public, conditions de mise ',
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_contenu_chap1_page.dart",
                  "f00015",
                  'en œuvre et exemples opérationnels.',
                ),
            imagePath: 'assets/images/controle_identité_chap1.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx/cadres_juridiques/controle_identite/chapitre1/controles_preventifs',
            ),
          ),
          const SizedBox(height: 14),

          // ===================== CONTROLES EN ZONE FRONTIERE ==============
          _ModuleCard(
            tag: 'chap1_zone_frontiere',
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_contenu_chap1_page.dart",
              "f00016",
              'Les contrôles en zone frontière',
            ),
            subtitle:
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_contenu_chap1_page.dart",
                  "f00017",
                  'Spécificités des contrôles réalisés aux frontières, zones assimilées et régime ',
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_contenu_chap1_page.dart",
                  "f00018",
                  'juridique applicable aux personnes contrôlées.',
                ),
            imagePath: 'assets/images/controle_identité_chap1.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx/cadres_juridiques/controle_identite/chapitre1/zone_frontiere',
            ),
          ),
          const SizedBox(height: 14),

          // ===================== LOCAUX PROFESSIONNELS ====================
          _ModuleCard(
            tag: 'chap1_locaux_pro',
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_contenu_chap1_page.dart",
              "f00019",
              'Les contrôles dans les locaux professionnels',
            ),
            subtitle:
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_contenu_chap1_page.dart",
                  "f00020",
                  'Conditions d’accès, finalité des contrôles et articulation avec les autres ',
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_contenu_chap1_page.dart",
                  "f00021",
                  'pouvoirs d’inspection dans les lieux ouverts au public ou aux salariés.',
                ),
            imagePath: 'assets/images/controle_identité_chap1.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx/cadres_juridiques/controle_identite/chapitre1/locaux_professionnels',
            ),
          ),
          const SizedBox(height: 14),

          // = VISITES VEHICULES / BAGAGES / NAVIRES ========================
          _ModuleCard(
            tag: 'chap1_visites_vehicules',
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_contenu_chap1_page.dart",
              "f00022",
              'Visites de véhicules, bagages et navires',
            ),
            subtitle:
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_contenu_chap1_page.dart",
                  "f00023",
                  'Règles encadrant les visites de véhicules, l’inspection visuelle ou la fouille des ',
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_contenu_chap1_page.dart",
                  "f00024",
                  'bagages et les visites de navires en lien avec le contrôle d’identité.',
                ),
            imagePath: 'assets/images/controle_identité_chap1.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx/cadres_juridiques/controle_identite/chapitre1/visites_vehicules_bagages_navires',
            ),
          ),
          const SizedBox(height: 14),

          // = DISTINCTION CONTROLE IDENTITE / REGLEMENTATION ==============
          _ModuleCard(
            tag: 'chap1_distinction_controles',
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_contenu_chap1_page.dart",
              "f00025",
              'Distinction contrôle d’identité / contrôle de réglementation',
            ),
            subtitle:
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_contenu_chap1_page.dart",
                  "f00026",
                  'Comment différencier un contrôle d’identité d’un contrôle de réglementation, ',
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_contenu_chap1_page.dart",
                  "f00027",
                  'et quelles conséquences pratiques pour la rédaction des actes.',
                ),
            imagePath: 'assets/images/controle_identité_chap1.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx/cadres_juridiques/controle_identite/chapitre1/distinction_identite_reglementation',
            ),
          ),
          const SizedBox(height: 14),

          // ================== SEJOUR DES ETRANGERS ========================
          _ModuleCard(
            tag: 'chap1_sejour_etrangers',
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_contenu_chap1_page.dart",
              "f00028",
              'Contrôle de la régularité du séjour des étrangers',
            ),
            subtitle:
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_contenu_chap1_page.dart",
                  "f00029",
                  'Spécificités des contrôles visant la régularité du séjour, coopération avec ',
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_contenu_chap1_page.dart",
                  "f00030",
                  'l’autorité préfectorale et garanties procédurales.',
                ),
            imagePath: 'assets/images/controle_identité_chap1.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx/cadres_juridiques/controle_identite/chapitre1/sejour_etrangers',
            ),
          ),
          const SizedBox(height: 14),

          // ================== MOYENS DE PREUVE DE L’IDENTITE ==============
          _ModuleCard(
            tag: 'chap1_moyens_preuve_identite',
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_contenu_chap1_page.dart",
              "f00031",
              'Les moyens de preuve de l’identité',
            ),
            subtitle:
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_contenu_chap1_page.dart",
                  "f00032",
                  'Documents et éléments permettant d’établir l’identité d’une personne, ',
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_contenu_chap1_page.dart",
                  "f00033",
                  'appréciation de leur fiabilité et bonnes pratiques pour l’officier de police judiciaire.',
                ),
            imagePath: 'assets/images/controle_identité_chap1.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx/cadres_juridiques/controle_identite/chapitre1/moyens_preuve_identite',
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
//  CARTE MODULE (même style que ta page de contenu principale)
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
      child: Semantics(
        button: true,
        label: '$title — découvrir',
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
                    // Badge "Module"
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

                    // Titre (2 lignes max)
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
                      maxLines: 3,
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
      ),
    );
  }
}
