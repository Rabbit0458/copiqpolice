// lib/pa/dps_dpg/cadres_juridiques/commission_rogatoire_contenu_page.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaCommissionRogatoireContenuPage extends StatelessWidget {
  const PaCommissionRogatoireContenuPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/cadres_juridiques/commission_rogatoire_contenu';

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
          'Commission rogatoire',
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
            'La commission rogatoire\n(art. 81 et 151 à 154-2 du Code de Procédure Pénale)',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Définition, autorités compétentes, formalisme et principaux actes '
            'd’enquête exécutés sur délégation du juge d’instruction.',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w500,
              fontSize: 13.5,
              height: 1.35,
              color: textSoft,
            ),
          ),
          const SizedBox(height: 18),

          // ===================== CHAPITRE 1 ================================
          _ModuleCard(
            tag: 'cr_chap1',
            title: 'Chapitre 1 — Autorités déléguantes et délégataires',
            subtitle:
                'Qui délègue, qui exécute ? Juge d’instruction, OPJ, APJ et répartition des pouvoirs dans l’exécution des commissions rogatoires.',
            imagePath: 'assets/images/infraction_legal.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/cadres_juridiques/commission_rogatoire/chapitre1',
            ),
          ),
          const SizedBox(height: 14),

          // ===================== CHAPITRE 2 ================================
          _ModuleCard(
            tag: 'cr_chap2',
            title: 'Chapitre 2 — Le formalisme de la commission rogatoire',
            subtitle:
                'Mentions obligatoires, portée territoriale, durée, limites de la délégation et conséquences en cas d’irrégularité.',
            imagePath: 'assets/images/reserve.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/cadres_juridiques/commission_rogatoire/chapitre2',
            ),
          ),
          const SizedBox(height: 14),

          // ===================== CHAPITRE 3 (VUE GLOBALE) ==================
          _ModuleCard(
            tag: 'cr_chap3',
            title: 'Chapitre 3 — Les actes procéduraux',
            subtitle:
                'Logique générale des actes accomplis sur commission rogatoire, contrôle du juge d’instruction et du parquet, traçabilité des opérations.',
            imagePath: 'assets/images/chap3.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/cadres_juridiques/commission_rogatoire/chapitre3',
            ),
          ),
          const SizedBox(height: 18),

          // ===================== ACTES PROCÉDURAUX : PERQUISITIONS =========
          _ModuleCard(
            tag: 'cr_perquisitions',
            title: 'Perquisitions et fouilles',
            subtitle:
                'Conditions, horaires, lieux, présence des occupants, saisies et rédaction du procès-verbal sur commission rogatoire.',
            imagePath: 'assets/images/fouille.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/cadres_juridiques/commission_rogatoire/perquisitions_fouilles',
            ),
          ),
          const SizedBox(height: 14),

          // ===================== ACTES PROCÉDURAUX : SAISIES ET SCELLES =========
          _ModuleCard(
            tag: 'cr_saisies',
            title: 'Saisies et scellés',
            subtitle: 'Conditions des saisies sur commission rogatoire.',
            imagePath: 'assets/images/stup_import_export.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/cadres_juridiques/commission_rogatoire/saisies_scelles',
            ),
          ),
          const SizedBox(height: 14),

          // ===================== ACTES PROCÉDURAUX : MANDAT DE RECHERCHE ===
          _ModuleCard(
            tag: 'cr_mandat_recherche',
            title: 'Le mandat de recherche',
            subtitle:
                'Fondement juridique, mentions essentielles, effets du mandat de recherche et articulation avec l’interpellation.',
            imagePath: 'assets/images/mandat.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/cadres_juridiques/commission_rogatoire/mandat_recherche',
            ),
          ),
          const SizedBox(height: 14),

          // ===================== ACTES PROCÉDURAUX : GARDE À VUE ===========
          _ModuleCard(
            tag: 'cr_gav',
            title: 'La garde à vue sur commission rogatoire',
            subtitle:
                'Conditions de fond et de forme, information des droits, durée, prolongations et rôle du juge d’instruction.',
            imagePath: 'assets/images/gardeavue.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/cadres_juridiques/commission_rogatoire/garde_a_vue',
            ),
          ),
          const SizedBox(height: 14),

          // ===================== ACTES PROCÉDURAUX : RÉQUISITIONS ==========
          _ModuleCard(
            tag: 'cr_requisitions',
            title: 'Les réquisitions sur commission rogatoire',
            subtitle:
                'Réquisitions judiciaires aux organismes publics ou privés : finalité, portée, limites et conservation des réponses.',
            imagePath: 'assets/images/requisitions.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/cadres_juridiques/commission_rogatoire/requisitions',
            ),
          ),
          const SizedBox(height: 22),

          // ===================== ACTES PROCÉDURAUX : VIOLATION CJ ==========
          _ModuleCard(
            tag: 'cr_violation_cj',
            title: 'Les violations du contrôle judiciaire',
            subtitle:
                'La retenue judiciaire en cas de présomption de violation de certaines obligations du contrôle judiciaire',
            imagePath: 'assets/images/retention.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/cadres_juridiques/commission_rogatoire/violation_cj',
            ),
          ),
          const SizedBox(height: 22),

          // ===================== QUIZ MODULE ===============================
          _ModuleCard(
            tag: 'flagrant_quiz',
            title: 'Quiz — Commission rogatoire',
            subtitle:
                'Testez vos réflexes : définition, conditions, pouvoirs et limites.',
            imagePath: 'assets/images/quiz.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx/generalites/quiz/commission_rogatoire',
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
//  CARTE MODULE (même style que ta page flagrant délit)
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
