// lib/gpx_scolarite_pages/generalite_pages/complicite/complicite_contenu_page.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/gpx_scolarite_pages/dps_dpg/generalite_pages/quizz_generalit%C3%A9/quiz_complicite_page.dart';
import 'package:copiqpolice/gpx_scolarite_pages/dps_dpg/generalite_pages/complicite/complicite_condition_page.dart';

class EnquetePreliminaireContenuPage extends StatelessWidget {
  const EnquetePreliminaireContenuPage({super.key});

  static const String routeName =
      '/gpx/generalites/enquete_preliminaire/contenu';

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
          icon: Icon(Icons.arrow_back_ios_new, color: textMain),
          tooltip: 'Retour',
        ),
        title: Text(
          'L\'enquête préliminaire',
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
          // CHAPITRE 1 — DOMAINE D'APPLICATION
          _ModuleCard(
            tag: 'chap1_domaine_enquete_preliminaire',
            title: 'Domaine d’application',
            subtitle:
                'Situations, infractions et cadre juridique relevant de l’enquête préliminaire.',
            imagePath: 'assets/images/libertes_intro.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx/cadres_juridiques/enquete_preliminaire/chapitre1_domaine',
            ),
          ),
          const SizedBox(height: 18),

          // CHAPITRE 2 — PROCÉDURE D’ENQUÊTE PRÉLIMINAIRE
          _ModuleCard(
            tag: 'chap2_procedure_enquete_preliminaire',
            title: 'Procédure d’enquête préliminaire',
            subtitle:
                'Déclenchement, direction par le parquet, déroulement et contrôle de l’enquête.',
            imagePath: 'assets/images/aggravations.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx/cadres_juridiques/enquete_preliminaire/chapitre2_procedure',
            ),
          ),
          const SizedBox(height: 18),

          // ACTES DE L’ENQUÊTE PRÉLIMINAIRE — CONSTATATIONS & RÉQUISITIONS
          _ModuleCard(
            tag: 'actes_enquete_preliminaire_constatations_requisitions',
            title: 'Constatations & réquisitions',
            subtitle:
                'Transport sur les lieux, préservation des traces, réquisitions à personnes qualifiées et aux organismes.',
            imagePath: 'assets/images/atteintes_involontaires.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx/cadres_juridiques/enquete_preliminaire/actes/constatations_requisitions',
            ),
          ),
          const SizedBox(height: 14),

          // ACTES DE L’ENQUÊTE PRÉLIMINAIRE — FOUILLES
          _ModuleCard(
            tag: 'actes_enquete_preliminaire_fouilles',
            title: 'Les fouilles',
            subtitle:
                'Fouilles de personnes, fouilles de véhicules et cadre légal des mesures de sécurité.',
            imagePath: 'assets/images/background.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx/cadres_juridiques/enquete_preliminaire/actes/fouilles',
            ),
          ),
          const SizedBox(height: 14),

          // ACTES DE L’ENQUÊTE PRÉLIMINAIRE — AUDITIONS
          _ModuleCard(
            tag: 'actes_enquete_preliminaire_auditions',
            title: 'Les auditions',
            subtitle:
                'Témoins, suspects libres, personnes gardées à vue : statuts, droits et formalisme des auditions.',
            imagePath: 'assets/images/criminalite_organisee.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx/cadres_juridiques/enquete_preliminaire/actes/auditions',
            ),
          ),
          const SizedBox(height: 14),

          // ACTES DE L’ENQUÊTE PRÉLIMINAIRE — GARDE À VUE
          _ModuleCard(
            tag: 'actes_enquete_preliminaire_gav',
            title: 'La garde à vue',
            subtitle:
                'Conditions, durée, droits de la personne retenue et contrôle de la mesure en enquête préliminaire.',
            imagePath: 'assets/images/gav.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx/cadres_juridiques/enquete_preliminaire/actes/garde_a_vue',
            ),
          ),
          const SizedBox(height: 14),

          // ACTES DE L’ENQUÊTE PRÉLIMINAIRE — SAISIE DES COMPTES BANCAIRES
          _ModuleCard(
            tag: 'actes_enquete_preliminaire_saisie_comptes',
            title: 'Saisie des comptes bancaires',
            subtitle:
                'Saisie spéciale des avoirs, rôle du procureur et contrôle du juge des libertés et de la détention.',
            imagePath: 'assets/images/generalite.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx/cadres_juridiques/enquete_preliminaire/actes/saisie_comptes_bancaires',
            ),
          ),
          const SizedBox(height: 18),

          // QUIZ — ENQUÊTE PRÉLIMINAIRE
          _ModuleCard(
            tag: 'quiz_enquete_preliminaire',
            title: 'Quiz — Enquête préliminaire',
            subtitle:
                'Testez vos connaissances : domaine d’application, procédure et actes de l’enquête préliminaire.',
            imagePath: 'assets/images/quiz.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx/generalites/quiz/enquete_preliminaire',
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
//  CARTE MODULE (même style que tentative, avec texte lisible dark/light)
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

                    // Titre (2 lignes max, plus compact)
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
