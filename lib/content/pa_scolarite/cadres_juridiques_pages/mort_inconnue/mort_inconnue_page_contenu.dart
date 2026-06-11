// lib/pa/dps_dpg/cadres_juridiques/mort_inconnue_page_contenu.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaMortInconnueContenuPage extends StatelessWidget {
  const PaMortInconnueContenuPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/cadres_juridiques/mort_inconnue_contenu';

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
          'Mort de cause inconnue',
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
            'La découverte d’une personne décédée\n'
            '(articles 74 et 80-4 du Code de procédure pénale)',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Cadre applicable à la découverte d’un corps dont la cause du décès '
            'est inconnue ou suspecte : déclenchement de l’enquête, rôle du '
            'procureur de la République et du juge d’instruction, actes '
            'd’investigation et suites possibles.',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w500,
              fontSize: 13.5,
              height: 1.35,
              color: textSoft,
            ),
          ),
          const SizedBox(height: 18),

          // ===================== INTRO / PRÉAMBULE =========================
          _ModuleCard(
            tag: 'mi_intro',
            title: 'Introduction — Cadre général',
            subtitle:
                'Notion de découverte d’un corps, loi applicable et articulation '
                'avec la recherche des causes de la mort et la découverte d’une '
                'personne grièvement blessée.',
            imagePath: 'assets/images/stad.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/cadres_juridiques/mort_inconnue/intro',
            ),
          ),
          const SizedBox(height: 14),

          // ===================== CHAPITRE 1 ================================
          _ModuleCard(
            tag: 'mi_chap1',
            title: 'Conditions d’application des articles 74 et 80-4 du C.P.P.',
            subtitle:
                'Quand appliquer ce cadre ? Découverte du corps, caractère '
                'suspect ou inexpliqué du décès, information du parquet et '
                'ouverture éventuelle d’information judiciaire.',
            imagePath: 'assets/images/infraction_legal.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/cadres_juridiques/mort_inconnue/chapitre1',
            ),
          ),
          const SizedBox(height: 14),

          // ===================== CHAPITRE 2 — PROCÉDURE GLOBALE ===========
          _ModuleCard(
            tag: 'mi_chap2',
            title: 'Procédure des articles 74 et 80-4 du C.P.P.',
            subtitle:
                'Déroulement de l’enquête : rôle de l’O.P.J., de l’A.P.J., du '
                'procureur et du juge d’instruction, choix du cadre d’enquête et '
                'contrôle de la légalité des actes.',
            imagePath: 'assets/images/reserve.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/cadres_juridiques/mort_inconnue/chapitre2',
            ),
          ),
          const SizedBox(height: 18),

          // ===================== ACTES DE L’ENQUÊTE ========================
          _ModuleCard(
            tag: 'mi_actes_enquete',
            title: 'Les actes de l’enquête',
            subtitle:
                'Transport sur les lieux, premières constatations, réquisitions, '
                'perquisitions et saisies réalisées pour déterminer l’origine du décès.',
            imagePath: 'assets/images/gavel_desk_2.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/cadres_juridiques/mort_inconnue/actes_enquete',
            ),
          ),
          const SizedBox(height: 14),

          // ===================== ACTES DÉLÉGUÉS PAR LE JI (80-4) ==========
          _ModuleCard(
            tag: 'mi_actes_804',
            title: 'Les actes délégués par le procureur de la République',
            subtitle:
                'Enquête sur les causes de la mort dans le cadre d’une information : '
                'missions confiées aux O.P.J. par commission rogatoire en vertu de '
                'l’article 80-4.',
            imagePath: 'assets/images/action_justice.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/cadres_juridiques/mort_inconnue/actes_delegues',
            ),
          ),
          const SizedBox(height: 14),

          // ===================== ACTES DÉLÉGUÉS PAR LE JI (80-4) ==========
          _ModuleCard(
            tag: 'mi_actes_ji',
            title:
                'Les actes délégués par le juge d\'instruction (art. 80-4 C.P.Р.)',
            subtitle:
                'Enquête sur les causes de la mort dans le cadre d’une information : '
                'missions confiées aux O.P.J. par commission rogatoire en vertu de '
                'l’article 80-4.',
            imagePath: 'assets/images/action_justice.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/cadres_juridiques/mort_inconnue/actes_juge_instruction',
            ),
          ),
          const SizedBox(height: 14),

          // ===================== SUITES DE L’ENQUÊTE =======================
          _ModuleCard(
            tag: 'mi_suites',
            title:
                'Les suites de l’enquête diligentée en vertu de l’article 74 du C.P.P.',
            subtitle:
                'Classement, ouverture d’enquête préliminaire, flagrance ou '
                'information judiciaire selon que le décès est naturel, accidentel '
                'ou révèle une infraction.',
            imagePath: 'assets/images/commission_rogatoire.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/cadres_juridiques/mort_inconnue/suites_enquete',
            ),
          ),
          const SizedBox(height: 22),

          // ===================== QUIZ MODULE ===============================
          _ModuleCard(
            tag: 'mi_quiz',
            title: 'Quiz — Mort de cause inconnue',
            subtitle:
                'Vérifiez vos acquis : conditions d’application, procédure, actes '
                'et suites d’enquête.',
            imagePath: 'assets/images/quiz.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () =>
                _openRoute(context, '/gpx/generalites/quiz/mort_inconnue'),
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
//  CARTE MODULE (identique à ta template CommissionRogatoireContenuPage)
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
      ),
    );
  }
}
