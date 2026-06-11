// lib/pa/dps_dpg/cadres_juridiques/criminalite_organisee_contenu_page.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaCriminaliteOrganiseeContenuPage extends StatelessWidget {
  const PaCriminaliteOrganiseeContenuPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/cadres_juridiques/criminalite_organisee_contenu';

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
          'Criminalité organisée',
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
            'La procédure applicable à\nla criminalité et délinquance organisées',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Panorama des infractions relevant de la criminalité et délinquance '
            'organisées, des règles procédurales dérogatoires au droit commun et '
            'des principales techniques spéciales d’enquête (garde à vue, '
            'perquisitions, interceptions, enquête préliminaire et commission rogatoire).',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w500,
              fontSize: 13.5,
              height: 1.35,
              color: textSoft,
            ),
          ),
          const SizedBox(height: 18),

          // ===================== INFRACTIONS RELEVANT CO/DO ================
          _ModuleCard(
            tag: 'co_infractions',
            title:
                'Les infractions relevant de la criminalité et délinquance organisées',
            subtitle:
                'Définition, typologie et exemples d’infractions entrant dans le champ de la criminalité et de la délinquance organisées.',
            imagePath: 'assets/images/infraction_legal.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/cadres_juridiques/criminalite_organisee/infractions',
            ),
          ),
          const SizedBox(height: 14),

          // ===================== REGLES PROCEDURALES DEROGATOIRES ==========
          _ModuleCard(
            tag: 'co_regles_derogatoires',
            title: 'Les règles procédurales dérogatoires au droit commun',
            subtitle:
                'Cadre légal des dérogations accordées en matière de criminalité organisée : durée des mesures, compétences, contrôles.',
            imagePath: 'assets/images/reserve.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/cadres_juridiques/criminalite_organisee/regles_derogatoires',
            ),
          ),
          const SizedBox(height: 14),

          // ===================== GARDE A VUE ===============================
          _ModuleCard(
            tag: 'co_gav',
            title: 'La garde à vue',
            subtitle:
                'Durées spécifiques, régime dérogatoire, droits de la personne gardée à vue et rôle de l’avocat en matière de criminalité organisée.',
            imagePath: 'assets/images/gav.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/cadres_juridiques/criminalite_organisee/garde_a_vue',
            ),
          ),
          const SizedBox(height: 14),

          // ===================== PERQUISITIONS =============================
          _ModuleCard(
            tag: 'co_perquisitions',
            title: 'Les perquisitions',
            subtitle:
                'Horaires dérogatoires, lieux visés, formalités et spécificités des perquisitions en matière de criminalité organisée.',
            imagePath: 'assets/images/commission_rogatoire.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/cadres_juridiques/criminalite_organisee/perquisitions',
            ),
          ),
          const SizedBox(height: 14),

          // ===================== INTERCEPTIONS DE CORRESPONDANCES ==========
          _ModuleCard(
            tag: 'co_interceptions',
            title: 'Les interceptions de correspondances',
            subtitle:
                'Interceptions téléphoniques et électroniques : conditions, autorité compétente, durée et exploitation des enregistrements.',
            imagePath: 'assets/images/gavel_desk_2.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/cadres_juridiques/criminalite_organisee/interceptions',
            ),
          ),
          const SizedBox(height: 14),

          // ===================== AUTRES TECHNIQUES SPECIALES ==============
          _ModuleCard(
            tag: 'co_techniques_speciales',
            title: 'Les autres techniques spéciales d’enquête',
            subtitle:
                'Sonorisations, captations de données, infiltrations, surveillances renforcées et opérations sous couverture.',
            imagePath: 'assets/images/generalite.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/cadres_juridiques/criminalite_organisee/techniques_speciales',
            ),
          ),
          const SizedBox(height: 18),

          // ===================== ENQUETE PRELIMINAIRE ======================
          _ModuleCard(
            tag: 'co_enquete_preliminaire',
            title: 'L’enquête préliminaire relative à la criminalité organisée',
            subtitle:
                'Particularités de l’enquête préliminaire en matière de criminalité organisée : pouvoirs, durée, contrôle du parquet.',
            imagePath: 'assets/images/infraction_legal.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/cadres_juridiques/criminalite_organisee/enquete_preliminaire',
            ),
          ),
          const SizedBox(height: 14),

          // ===================== COMMISSION ROGATOIRE ======================
          _ModuleCard(
            tag: 'co_commission_rogatoire',
            title:
                'La procédure de commission rogatoire relative à la criminalité organisée',
            subtitle:
                'Délégations d’actes par le juge d’instruction aux enquêteurs dans les dossiers de criminalité organisée.',
            imagePath: 'assets/images/criminalite_organisee.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/cadres_juridiques/criminalite_organisee/commission_rogatoire',
            ),
          ),
          const SizedBox(height: 14),

          // ===================== LUTTE CONTRE LE FINANCEMENT ===============
          _ModuleCard(
            tag: 'co_financement',
            title:
                'La lutte contre le financement des activités liées à la criminalité organisée',
            subtitle:
                'Traçabilité des flux financiers, gel et saisie des avoirs, coopération avec les services spécialisés et autorités financières.',
            imagePath: 'assets/images/probite.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/cadres_juridiques/criminalite_organisee/financement',
            ),
          ),
          const SizedBox(height: 22),

          // ===================== QUIZ (OPTIONNEL, SI TU LE PRÉVOIS) ========
          _ModuleCard(
            tag: 'co_quiz',
            title: 'Quiz — Criminalité organisée',
            subtitle:
                'Testez vos connaissances sur les infractions, les règles dérogatoires et les techniques spéciales d’enquête.',
            imagePath: 'assets/images/quiz.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx/generalites/quiz/criminalite_organisee',
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
//  CARTE MODULE (même style que ta page commission rogatoire / flagrant délit)
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
