// lib/gpx_scolarite_pages/generalite_pages/complicite/complicite_contenu_page.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/generalite_pages/quizz_generalit%C3%A9/quiz_complicite_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_condition_page.dart';

class HierarchieContenuPage extends StatelessWidget {
  const HierarchieContenuPage({super.key});

  static const String routeName = '/gpx/generalites/hierarchie/contenu';

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
          'La hiérarchie',
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
          // MODULE 5 — INTRO GLOBALE (Structure & direction PJ)
          _ModuleCard(
            tag: 'intro_hierarchie',
            title: 'Structure de la police judiciaire',
            subtitle:
                'Direction du procureur, contrôle du procureur général et chambre de l’instruction.',
            imagePath: 'assets/images/image4.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx/generalites/hierarchie/intro_structure',
            ),
          ),
          const SizedBox(height: 18),

          // MODULE 1 — OPJ (Officiers de Police Judiciaire)
          _ModuleCard(
            tag: 'opj_hierarchie',
            title: 'Les Officiers de Police Judiciaire',
            subtitle:
                'Qualité, pouvoirs, conditions d’exercice, habilitation et rôle dans la procédure pénale.',
            imagePath: 'assets/images/image4.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(context, '/gpx/generalites/hierarchie/opj'),
          ),
          const SizedBox(height: 14),

          // MODULE 2 — APJ (Agents de Police Judiciaire)
          _ModuleCard(
            tag: 'apj_hierarchie',
            title: 'Les Agents de Police Judiciaire',
            subtitle:
                'Art. 20, 20-1 et 21 C.P.P. — trois catégories, attributions et limites légales.',
            imagePath: 'assets/images/image4.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(context, '/gpx/generalites/hierarchie/apj'),
          ),
          const SizedBox(height: 14),

          // MODULE 3 — APJA (Agents de Police Judiciaire Adjoints)
          _ModuleCard(
            tag: 'apja_hierarchie',
            title: 'Les Agents de Police Judiciaire Adjoints',
            subtitle:
                'Auxiliaires judiciaires : policiers adjoints, réservistes, agents municipaux, etc.',
            imagePath: 'assets/images/image4.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () =>
                _openRoute(context, '/gpx/generalites/hierarchie/apja'),
          ),
          const SizedBox(height: 14),

          // MODULE 4 — ASSISTANTS D’ENQUÊTE
          _ModuleCard(
            tag: 'assistants_enquete_hierarchie',
            title: 'Les assistants d’enquête',
            subtitle:
                'Appui technique : personnels B, CSTAGN, APJA. Missions et cadre légal.',
            imagePath: 'assets/images/image4.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx/generalites/hierarchie/assistants_enquete',
            ),
          ),
          const SizedBox(height: 18),

          // QUIZ
          _ModuleCard(
            tag: 'quiz_hierarchie',
            title: 'Quiz — Hiérarchie judiciaire',
            subtitle:
                'Testez votre maîtrise : OPJ, APJ, APJA, assistants, pouvoirs et cadre légal.',
            imagePath: 'assets/images/quiz.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () =>
                _openRoute(context, '/gpx/generalites/quiz/hierarchie'),
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
