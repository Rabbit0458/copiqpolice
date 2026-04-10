// lib/gpx_scolarite_pages/cadres_juridiques/entraide_judiciaire_contenu_page.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EntraideJudiciaireContenuPage extends StatelessWidget {
  const EntraideJudiciaireContenuPage({super.key});

  static const String routeName =
      '/gpx/cadres_juridiques/entraide_judiciaire_contenu';

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
          'Entraide judiciaire internationale',
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
            'L’entraide judiciaire internationale\net la coopération pénale',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Vue d’ensemble des principaux mécanismes de coopération pénale et policière, '
            'du mandat d’arrêt européen et des procédures d’extradition. '
            'Repères pratiques pour comprendre les acteurs, les étapes et le rôle des services enquêteurs.',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w500,
              fontSize: 13.5,
              height: 1.35,
              color: textSoft,
            ),
          ),
          const SizedBox(height: 22),

          // =================================================================
          //                          CHAPITRE 1
          //            LA COOPÉRATION PÉNALE POLICIÈRE
          // =================================================================
          Text(
            'CHAPITRE 1',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w800,
              fontSize: 12,
              letterSpacing: 2,
              color: textSoft,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'La coopération pénale policière',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 18,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          _ModuleCard(
            tag: 'eji_eurojust',
            title: 'L’Agence EUROJUST',
            subtitle:
                'Rôle, missions et fonctionnement d’EUROJUST dans la coordination des enquêtes et des poursuites entre États membres.',
            imagePath: 'assets/images/generalite.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx/cadres_juridiques/entraide_judiciaire/eurojust',
            ),
          ),
          const SizedBox(height: 14),

          _ModuleCard(
            tag: 'eji_prum',
            title: 'Le traité de Prüm',
            subtitle:
                'Échanges automatisés de données (ADN, empreintes, immatriculations) et coopération renforcée pour la lutte contre la criminalité.',
            imagePath: 'assets/images/commission_rogatoire.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx/cadres_juridiques/entraide_judiciaire/traité_prum',
            ),
          ),
          const SizedBox(height: 14),

          _ModuleCard(
            tag: 'eji_rje',
            title: 'Le Réseau judiciaire européen (R.J.E.)',
            subtitle:
                'Point de contact, assistance pratique et résolution des difficultés dans la mise en œuvre de l’entraide judiciaire.',
            imagePath: 'assets/images/infraction_legal.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx/cadres_juridiques/entraide_judiciaire/reseau_judiciaire_europeen',
            ),
          ),
          const SizedBox(height: 14),

          _ModuleCard(
            tag: 'eji_entraide_internationale',
            title: 'L’entraide judiciaire internationale',
            subtitle:
                'Principes, bases juridiques, circuits de transmission et rôle des autorités centrales en matière d’entraide pénale.',
            imagePath: 'assets/images/gavel_desk_2.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx/cadres_juridiques/entraide_judiciaire/entraide_internationale',
            ),
          ),
          const SizedBox(height: 22),

          // =================================================================
          //                          CHAPITRE 2
          //                  LE MANDAT D’ARRÊT EUROPÉEN
          // =================================================================
          Text(
            'CHAPITRE 2',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w800,
              fontSize: 12,
              letterSpacing: 2,
              color: textSoft,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Le mandat d’arrêt européen',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 18,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          _ModuleCard(
            tag: 'eji_mae_definition',
            title: 'Définition du mandat d’arrêt européen',
            subtitle:
                'Notion, finalité et conditions de recours au M.A.E. dans l’espace judiciaire européen.',
            imagePath: 'assets/images/probite.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx/cadres_juridiques/entraide_judiciaire/mae_definition',
            ),
          ),
          const SizedBox(height: 14),

          _ModuleCard(
            tag: 'eji_mae_mise_en_oeuvre',
            title: 'Mise en œuvre du mandat d’arrêt européen',
            subtitle:
                'Étapes principales, acteurs compétents et articulation avec les procédures nationales.',
            imagePath: 'assets/images/reserve.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx/cadres_juridiques/entraide_judiciaire/mae_mise_en_oeuvre',
            ),
          ),
          const SizedBox(height: 14),

          _ModuleCard(
            tag: 'eji_mae_mission_fr',
            title:
                'Mission d’un mandat d’arrêt européen\npar les juridictions françaises',
            subtitle:
                'Délivrance du M.A.E. par les autorités françaises, contenu de la décision et suites procédurales.',
            imagePath: 'assets/images/criminalite_organisee.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx/cadres_juridiques/entraide_judiciaire/mae_mandat_par_juridictions_fr',
            ),
          ),
          const SizedBox(height: 14),

          _ModuleCard(
            tag: 'eji_mae_execution_fr',
            title:
                'Exécution d’un mandat d’arrêt européen\npar les juridictions françaises',
            subtitle:
                'Réception d’un M.A.E., droits de la personne arrêtée, contrôle juridictionnel et remise à l’État émetteur.',
            imagePath: 'assets/images/gav.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx/cadres_juridiques/entraide_judiciaire/mae_execution_par_juridictions_fr',
            ),
          ),
          const SizedBox(height: 22),

          // =================================================================
          //                          CHAPITRE 3
          //                           L’EXTRADITION
          // =================================================================
          Text(
            'CHAPITRE 3',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w800,
              fontSize: 12,
              letterSpacing: 2,
              color: textSoft,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'L’extradition',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 18,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          _ModuleCard(
            tag: 'eji_extradition_droit_commun',
            title: 'La procédure d’extradition de droit commun',
            subtitle:
                'Conditions de recevabilité, phases administrative et judiciaire, garanties offertes à la personne recherchée.',
            imagePath: 'assets/images/infraction_legal.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx/cadres_juridiques/entraide_judiciaire/extradition_droit_commun',
            ),
          ),
          const SizedBox(height: 14),

          _ModuleCard(
            tag: 'eji_extradition_simplifiee_ue',
            title:
                'La procédure simplifiée d’extradition\nentre États membres de l’Union européenne',
            subtitle:
                'Spécificités de la procédure allégée, délais raccourcis et articulation avec le mandat d’arrêt européen.',
            imagePath: 'assets/images/generalite.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx/cadres_juridiques/entraide_judiciaire/extradition_simplifiee_ue',
            ),
          ),
          const SizedBox(height: 14),

          _ModuleCard(
            tag: 'eji_extradition_modalites_transmission',
            title: 'Modalités de transmission de la demande d’extradition',
            subtitle:
                'Rôle du ministère de la Justice, voies diplomatiques ou directes, échanges d’informations complémentaires.',
            imagePath: 'assets/images/commission_rogatoire.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx/cadres_juridiques/entraide_judiciaire/extradition_modalites_transmission',
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
//  CARTE MODULE (même style que ta page criminalité organisée)
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
