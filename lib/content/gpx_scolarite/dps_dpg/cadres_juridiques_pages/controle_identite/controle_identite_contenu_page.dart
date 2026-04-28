// lib/gpx_scolarite_pages/cadres_juridiques/controle_identite_contenu_page.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ControleIdentiteContenuPage extends StatelessWidget {
  const ControleIdentiteContenuPage({super.key});

  static const String routeName = '/gpx/cadres_juridiques/controle_identite';

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
          'Contrôle d’identité',
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
            'Le contrôle d’identité en procédure pénale',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              color: textMain,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Cadre général du contrôle d’identité, relevé d’identité et vérification d’identité : '
            'principales catégories de contrôles et obligations de l’officier de police judiciaire.',
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
            tag: 'controle_intro',
            title: 'Introduction au contrôle d’identité',
            subtitle:
                'Finalités du contrôle d’identité, place dans la procédure pénale et articulation '
                'avec les autres cadres juridiques.',
            imagePath: 'assets/images/infraction_legal.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx/cadres_juridiques/controle_identite/intro',
            ),
          ),
          const SizedBox(height: 18),

          // ===================== CHAPITRE 1 ================================
          _ModuleCard(
            tag: 'controle_chap1',
            title: 'Contrôle d’identité',
            subtitle:
                'Introduction, cadre général du contrôle, contrôles préventifs, contrôles en zone '
                'frontière, contrôles dans les locaux professionnels, visites de véhicules et bagages, '
                'distinction contrôle d’identité / contrôle de réglementation, contrôle du séjour des '
                'étrangers et moyens de preuve de l’identité.',
            imagePath: 'assets/images/controle_identité_chap1.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx/cadres_juridiques/controle_identite/chapitre1',
            ),
          ),
          const SizedBox(height: 14),

          // ===================== CHAPITRE 2 ================================
          _ModuleCard(
            tag: 'controle_chap2',
            title: 'Relevé d’identité',
            subtitle:
                'Notion de relevé d’identité, finalité, conditions de mise en œuvre et rédaction '
                'des mentions sur les actes de procédure.',
            imagePath: 'assets/images/releve_identite_chap2.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx/cadres_juridiques/controle_identite/chapitre2',
            ),
          ),
          const SizedBox(height: 14),

          // ===================== CHAPITRE 3 ================================
          _ModuleCard(
            tag: 'controle_chap3',
            title: 'Vérification d’identité',
            subtitle:
                'Rétention de la personne contrôlée, conditions d’exécution, recherche de '
                'l’identité, obligations légales de procédure et procès-verbal de vérification.',
            imagePath: 'assets/images/verficiation_identite_chap3.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx/cadres_juridiques/controle_identite/chapitre3',
            ),
          ),
          const SizedBox(height: 18),

          // ===================== QUIZ MODULE (OPTIONNEL) ===================
          _ModuleCard(
            tag: 'controle_quiz',
            title: 'Quiz — Contrôle d’identité',
            subtitle:
                'Testez vos réflexes : conditions légales, limites des contrôles et distinctions '
                'entre contrôle, relevé et vérification d’identité.',
            imagePath: 'assets/images/quiz.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () =>
                _openRoute(context, '/gpx/generalites/quiz/controle_identite'),
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
