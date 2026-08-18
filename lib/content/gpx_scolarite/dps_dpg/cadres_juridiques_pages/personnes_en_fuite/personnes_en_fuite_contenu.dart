// lib/gpx_scolarite_pages/cadres_juridiques/enquete_flagrant_delit_contenu_page.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PersonnesFuiteContenuPage extends StatelessWidget {
  const PersonnesFuiteContenuPage({super.key});

  static const String routeName = '/gpx/generalites/personnes_fuite_contenu';

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
            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/personnes_en_fuite/personnes_en_fuite_contenu.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/personnes_en_fuite/personnes_en_fuite_contenu.dart",
            "f00002",
            'La recherche des personnes en fuite',
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
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/personnes_en_fuite/personnes_en_fuite_contenu.dart",
              "f00003",
              'Les conditions d\'application de l\'article 74-2 du Code de procédure pénale.',
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
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/personnes_en_fuite/personnes_en_fuite_contenu.dart",
                  "f00004",
                  'Articles 74-2 du code de procédure pénale — définition, champ ',
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/personnes_en_fuite/personnes_en_fuite_contenu.dart",
                  "f00005",
                  'd’application et déroulement procédural.',
                ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w500,
              fontSize: 13.5,
              height: 1.35,
              color: textSoft,
            ),
          ),
          const SizedBox(height: 18),

          // ===================== MODULE INTRO GLOBAL =======================
          _ModuleCard(
            tag: 'fuite_intro',
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/personnes_en_fuite/personnes_en_fuite_contenu.dart",
              "f00006",
              'Panorama de la recherche des personnes en fuite',
            ),
            subtitle: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/personnes_en_fuite/personnes_en_fuite_contenu.dart",
              "f00007",
              'Cadre juridique de l’article 74-2 du C.P.P., objectifs, missions de l’O.P.J. et place de ce dispositif après la clôture de l’information.',
            ),
            imagePath: 'assets/images/mandat_arret.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx/cadres_juridiques/recherche_personnes_fuite/intro',
            ),
          ),
          const SizedBox(height: 18),

          // ===================== CHAPITRE 1 ================================
          _ModuleCard(
            tag: 'fuite_chap1',
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/personnes_en_fuite/personnes_en_fuite_contenu.dart",
              "f00008",
              'Les conditions d’application',
            ),
            subtitle: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/personnes_en_fuite/personnes_en_fuite_contenu.dart",
              "f00009",
              'Personnes visées par l’article 74-2, types de mandats, condamnations, décisions juridictionnelles et fichages concernés.',
            ),
            imagePath: 'assets/images/infraction_legal.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx/cadres_juridiques/recherche_personnes_fuite/chapitre1',
            ),
          ),
          const SizedBox(height: 14),

          // ===================== CHAPITRE 2 ================================
          _ModuleCard(
            tag: 'fuite_chap2',
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/personnes_en_fuite/personnes_en_fuite_contenu.dart",
              "f00010",
              'La procédure applicable',
            ),
            subtitle: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/personnes_en_fuite/personnes_en_fuite_contenu.dart",
              "f00011",
              'Rôle du procureur, du JLD et de l’O.P.J., actes possibles, interceptions, techniques spéciales et limites procédurales.',
            ),
            imagePath: 'assets/images/procedure_penale.jpg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx/cadres_juridiques/recherche_personnes_fuite/chapitre2',
            ),
          ),
          const SizedBox(height: 14),

          // ===================== CHAPITRE 3 ================================
          _ModuleCard(
            tag: 'fuite_chap3',
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/personnes_en_fuite/personnes_en_fuite_contenu.dart",
              "f00012",
              'Les techniques spéciales d’enquête',
            ),
            subtitle: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/personnes_en_fuite/personnes_en_fuite_contenu.dart",
              "f00013",
              'Interceptions téléphoniques, IMSI-catcher, sonorisations, captations de données et conditions d’emploi.',
            ),
            imagePath: 'assets/images/copic_institutions.jpg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx/cadres_juridiques/recherche_personnes_fuite/chapitre3',
            ),
          ),
          const SizedBox(height: 18),

          // ===================== QUIZ MODULE ===============================
          _ModuleCard(
            tag: 'flagrant_quiz',
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/personnes_en_fuite/personnes_en_fuite_contenu.dart",
              "f00014",
              'Quiz — Personnes en fuite',
            ),
            subtitle: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/personnes_en_fuite/personnes_en_fuite_contenu.dart",
              "f00015",
              'Testez vos réflexes : définition, conditions.',
            ),
            imagePath: 'assets/images/quiz.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx/generalites/quiz/personnes_fuite',
            ), // à créer plus tard
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
//  CARTE MODULE (même style que tes autres pages contenu)
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
      ),
    );
  }
}
