// lib/pa/dps_dpg/cadres_juridiques/enquete_flagrant_delit_contenu_page.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaFlagrantDelitContenuPage extends StatelessWidget {
  const PaFlagrantDelitContenuPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/cadres_juridiques/enquete_flagrant_delit';

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
          tooltip: 'Retour',
        ),
        title: Text(
          'Enquête de flagrant délit',
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
            'L’enquête de police sur infraction flagrante',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              color: textMain,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Articles 53 à 73 du code de procédure pénale — définition, champ '
            'd’application et déroulement procédural.',
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
            tag: 'flagrant_intro',
            title: 'Panorama de la flagrance',
            subtitle:
                'Logique générale, rôle de la flagrance dans la procédure pénale et place des articles 53 à 73 du code de procédure pénale.',
            imagePath: 'assets/images/infraction_legal.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/cadres_juridiques/enquete_flagrant_delit/intro',
            ), // page à configurer plus tard
          ),
          const SizedBox(height: 18),

          // ===================== CHAPITRE 1 ================================
          _ModuleCard(
            tag: 'flagrant_chap1',
            title: 'Chapitre 1 — La notion de flagrance',
            subtitle:
                'Situations de flagrance, critères légaux, durée et bascule vers les autres cadres d’enquête.',
            imagePath: 'assets/images/tentative_moral.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/cadres_juridiques/enquete_flagrant_delit/chapitre1',
            ), // à configurer plus tard
          ),
          const SizedBox(height: 14),

          // ===================== CHAPITRE 2 ================================
          _ModuleCard(
            tag: 'flagrant_chap2',
            title: 'Chapitre 2 — Le domaine d’application',
            subtitle:
                'Infractions concernées, limites matérielles et territoriales, articulation avec les autres enquêtes.',
            imagePath: 'assets/images/reserve.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/cadres_juridiques/enquete_flagrant_delit/chapitre2',
            ), // à configurer plus tard
          ),
          const SizedBox(height: 14),

          // ===================== CHAPITRE 3 ================================
          _ModuleCard(
            tag: 'flagrant_chap3',
            title: 'Chapitre 3 — La procédure de flagrant délit',
            subtitle:
                'Pouvoirs de l’officier de police judiciaire, actes possibles, contrôles du parquet et suites de l’enquête.',
            imagePath: 'assets/images/procedure_penale.jpg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/cadres_juridiques/enquete_flagrant_delit/chapitre3',
            ), // à configurer plus tard
          ),
          const SizedBox(height: 18),

          // ===================== QUIZ MODULE ===============================
          _ModuleCard(
            tag: 'flagrant_quiz',
            title: 'Quiz — Flagrant délit',
            subtitle:
                'Testez vos réflexes : définition, conditions, pouvoirs et limites de la flagrance.',
            imagePath: 'assets/images/quiz.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx/generalites/quiz/flagrant_delit',
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
