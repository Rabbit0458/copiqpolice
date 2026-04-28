// lib/gpx_scolarite_pages/cadres_juridiques_pages/disparition/disparitions_inquietantes_contenu.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DisparitionContenuPage extends StatelessWidget {
  const DisparitionContenuPage({super.key});

  // Route appelée par la page d’intro animée
  static const String routeName =
      '/gpx/cadres_juridiques/disparitions_inquietantes';

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
          'Disparitions inquiétantes',
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
            'Les disparitions inquiétantes',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              color: textMain,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Articles 74-1 et 80-4 du Code de procédure pénale — cadre spécifique '
            'd’enquête en cas de disparition d’un mineur, d’un majeur protégé ou '
            'd’un majeur présentant un caractère inquiétant.',
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
            tag: 'disparition_intro',
            title: 'Module 1 — Comprendre les disparitions inquiétantes',
            subtitle:
                'Fondement des articles 74-1 et 80-4 du Code de procédure pénale, '
                'notion d’enquête spécifique ou transitoire et articulation avec la '
                'flagrance et l’information judiciaire.',
            imagePath: 'assets/images/infraction_legal.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              // Page de contenu « intro cadre général »
              '/gpx/cadres_juridiques/disparitions_inquietantes/intro',
            ),
          ),
          const SizedBox(height: 18),

          // ===================== CHAPITRE 1 ================================
          _ModuleCard(
            tag: 'disparition_chap1',
            title: 'Chapitre 1 — Conditions d’application',
            subtitle:
                'Disparition flagrante ou inquiétante, disparitions '
                'obligatoirement inquiétantes et disparitions inquiétantes '
                'en raison des circonstances (âge, santé, contexte...).',
            imagePath: 'assets/images/tentative_moral.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx/cadres_juridiques/disparitions_inquietantes/chapitre1',
            ),
          ),
          const SizedBox(height: 14),

          // ===================== CHAPITRE 2 ================================
          _ModuleCard(
            tag: 'disparition_chap2',
            title: 'Chapitre 2 — Procédures des articles 74-1 et 80-4',
            subtitle:
                'Magistrats et officiers de police judiciaire compétents, actes de '
                'l’enquête, poursuite des investigations et actes délégués par le '
                'juge d’instruction.',
            imagePath: 'assets/images/reserve.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx/cadres_juridiques/disparitions_inquietantes/chapitre2',
            ),
          ),
          const SizedBox(height: 14),

          // ===================== CHAPITRE 3 ================================
          _ModuleCard(
            tag: 'disparition_chap3',
            title: 'Chapitre 3 — Suites de l’enquête',
            subtitle:
                'Hypothèses lorsque la personne disparue est retrouvée, '
                'non retrouvée, ou lorsque l’enquête permet d’établir un '
                'caractère criminel ou délictuel à la disparition.',
            imagePath: 'assets/images/procedure_penale.jpg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx/cadres_juridiques/disparitions_inquietantes/chapitre3',
            ),
          ),
          const SizedBox(height: 18),

          // ===================== QUIZ MODULE ===============================
          _ModuleCard(
            tag: 'disparition_quiz',
            title: 'Quiz — Disparitions inquiétantes',
            subtitle:
                'Vérifiez vos réflexes sur les conditions d’application, les autorités '
                'habilitées et les suites de l’enquête prévues aux articles 74-1 et 80-4.',
            imagePath: 'assets/images/quiz.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx/generalites/quiz/disparitions_inquietantes',
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
