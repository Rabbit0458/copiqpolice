import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CausesAggravationSanctionContenuPage extends StatelessWidget {
  const CausesAggravationSanctionContenuPage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/sanction_pages/causes_aggravation_sanction';

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
          "La sanction",
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
          // ====================== TITRE PRINCIPAL ===========================
          Text(
            "Les causes d’aggravation de la sanction",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 6),

          Text(
            "Accédez à l’ensemble des documents portant sur les circonstances et "
            "qualités aggravantes (mode opératoire, vulnérabilité, armes, bande organisée, etc.).",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w500,
              fontSize: 13.5,
              height: 1.35,
              color: textSoft,
            ),
          ),

          const SizedBox(height: 18),

          // ================= PDF LIST (capture écran) =================
          _ModuleCard(
            tag: 'sanction_aggrav_auteur_ivre_stupefiants',
            title: "Auteur ivre ou sous l’emprise de stupéfiants",
            subtitle: "Cause d’aggravation liée à l’état de l’auteur.",
            imagePath: 'assets/images/cat_bases_juridiques.jpg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx_scolarite_pages/sanction_pages/causes_aggravation_sanction/auteur_ivre_ou_stupefiants',
            ),
          ),
          const SizedBox(height: 14),

          _ModuleCard(
            tag: 'sanction_aggrav_reseau_communication',
            title: "Avec utilisation d’un réseau de communication",
            subtitle:
                "Aggravation liée à l’usage d’un réseau de communication.",
            imagePath: 'assets/images/infraction_legal.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx_scolarite_pages/sanction_pages/causes_aggravation_sanction/utilisation_reseau_communication',
            ),
          ),
          const SizedBox(height: 14),

          _ModuleCard(
            tag: 'sanction_aggrav_etablissement_enseignement',
            title: "Dans un établissement d’enseignement",
            subtitle:
                "Aggravation liée au lieu : établissement d’enseignement.",
            imagePath: 'assets/images/atteintes_involontaires.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx_scolarite_pages/sanction_pages/causes_aggravation_sanction/etablissement_enseignement',
            ),
          ),
          const SizedBox(height: 14),

          _ModuleCard(
            tag: 'sanction_aggrav_bande_organisee',
            title: "La bande organisée",
            subtitle:
                "Aggravation liée à l’organisation et la préparation collective.",
            imagePath: 'assets/images/complicite.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx_scolarite_pages/sanction_pages/causes_aggravation_sanction/bande_organisee',
            ),
          ),
          const SizedBox(height: 14),

          _ModuleCard(
            tag: 'sanction_aggrav_minorite_quinze_ans',
            title: "La minorité de quinze ans",
            subtitle:
                "Aggravation liée à l’âge de la victime (moins de 15 ans).",
            imagePath: 'assets/images/defaut_permis.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx_scolarite_pages/sanction_pages/causes_aggravation_sanction/minorite_quinze_ans',
            ),
          ),
          const SizedBox(height: 14),

          _ModuleCard(
            tag: 'sanction_aggrav_mort',
            title: "La mort",
            subtitle: "Aggravation liée au résultat : décès.",
            imagePath: 'assets/images/cat_bases_juridiques.jpg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx_scolarite_pages/sanction_pages/causes_aggravation_sanction/mort',
            ),
          ),
          const SizedBox(height: 14),

          _ModuleCard(
            tag: 'sanction_aggrav_mutilation_inf_permanente',
            title: "La mutilation ou l’infirmité permanente",
            subtitle:
                "Aggravation liée au résultat : mutilation / infirmité permanente.",
            imagePath: 'assets/images/infraction_legal.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx_scolarite_pages/sanction_pages/causes_aggravation_sanction/mutilation_infirmité_permanente',
            ),
          ),
          const SizedBox(height: 14),

          _ModuleCard(
            tag: 'sanction_aggrav_vulnerabilite_victime',
            title: "La particulière vulnérabilité de la victime",
            subtitle:
                "Aggravation liée à l’état ou la situation de la victime.",
            imagePath: 'assets/images/atteintes_involontaires.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx_scolarite_pages/sanction_pages/causes_aggravation_sanction/vulnerabilite_victime',
            ),
          ),
          const SizedBox(height: 14),

          _ModuleCard(
            tag: 'sanction_aggrav_premeditation',
            title: "La préméditation",
            subtitle:
                "Aggravation liée à l’intention et la préparation préalable.",
            imagePath: 'assets/images/complicite.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx_scolarite_pages/sanction_pages/causes_aggravation_sanction/premeditation',
            ),
          ),
          const SizedBox(height: 14),

          _ModuleCard(
            tag: 'sanction_aggrav_qualite_conjoint_concubin',
            title: "La qualité de conjoint, de concubin ou de partenaire",
            subtitle: "Aggravation liée au lien entre auteur et victime.",
            imagePath: 'assets/images/defaut_permis.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx_scolarite_pages/sanction_pages/causes_aggravation_sanction/qualite_conjoint_concubin_partenaire',
            ),
          ),
          const SizedBox(height: 14),

          _ModuleCard(
            tag: 'sanction_aggrav_caractere_homophobe',
            title: "Le caractère homophobe",
            subtitle: "Aggravation liée au mobile homophobe.",
            imagePath: 'assets/images/cat_bases_juridiques.jpg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx_scolarite_pages/sanction_pages/causes_aggravation_sanction/caractere_homophobe',
            ),
          ),
          const SizedBox(height: 14),

          _ModuleCard(
            tag: 'sanction_aggrav_caractere_raciste',
            title: "Le caractère raciste",
            subtitle: "Aggravation liée au mobile raciste.",
            imagePath: 'assets/images/infraction_legal.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx_scolarite_pages/sanction_pages/causes_aggravation_sanction/caractere_raciste',
            ),
          ),
          const SizedBox(height: 14),

          _ModuleCard(
            tag: 'sanction_aggrav_guet_apens',
            title: "Le guet-apens",
            subtitle: "Aggravation liée au procédé : guet-apens.",
            imagePath: 'assets/images/atteintes_involontaires.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx_scolarite_pages/sanction_pages/causes_aggravation_sanction/guet_apens',
            ),
          ),
          const SizedBox(height: 14),

          _ModuleCard(
            tag: 'sanction_aggrav_port_usage_arme',
            title: "Le port ou l’usage d’une arme",
            subtitle: "Aggravation liée à l’arme : port / usage.",
            imagePath: 'assets/images/complicite.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx_scolarite_pages/sanction_pages/causes_aggravation_sanction/port_ou_usage_arme',
            ),
          ),
          const SizedBox(height: 14),

          _ModuleCard(
            tag: 'sanction_aggrav_effraction',
            title: "L’effraction",
            subtitle: "Aggravation liée au mode d’accès : effraction.",
            imagePath: 'assets/images/defaut_permis.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx_scolarite_pages/sanction_pages/causes_aggravation_sanction/effraction',
            ),
          ),
          const SizedBox(height: 14),

          _ModuleCard(
            tag: 'sanction_aggrav_circonstances_aggravantes',
            title: "Les circonstances aggravantes",
            subtitle: "Synthèse et logique des circonstances aggravantes.",
            imagePath: 'assets/images/cat_bases_juridiques.jpg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx_scolarite_pages/sanction_pages/causes_aggravation_sanction/circonstances_aggravantes',
            ),
          ),
          const SizedBox(height: 14),

          _ModuleCard(
            tag: 'sanction_aggrav_escalade',
            title: "L’escalade",
            subtitle: "Aggravation liée au mode opératoire : escalade.",
            imagePath: 'assets/images/infraction_legal.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx_scolarite_pages/sanction_pages/causes_aggravation_sanction/escalade',
            ),
          ),
          const SizedBox(height: 14),

          _ModuleCard(
            tag: 'sanction_aggrav_incapacite_totale_travail',
            title: "L’incapacité totale de travail",
            subtitle: "Aggravation liée au résultat : ITT.",
            imagePath: 'assets/images/atteintes_involontaires.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx_scolarite_pages/sanction_pages/causes_aggravation_sanction/incapacite_totale_travail',
            ),
          ),
          const SizedBox(height: 14),

          _ModuleCard(
            tag: 'sanction_aggrav_moyen_cryptologie',
            title: "L’utilisation d’un moyen de cryptologie",
            subtitle: "Aggravation liée à l’usage d’un moyen de cryptologie.",
            imagePath: 'assets/images/complicite.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx_scolarite_pages/sanction_pages/causes_aggravation_sanction/moyen_cryptologie',
            ),
          ),
          const SizedBox(height: 14),

          _ModuleCard(
            tag: 'sanction_aggrav_auteur_abusant_autorite',
            title: "Qualité d’auteur abusant de son autorité",
            subtitle: "Aggravation liée à l’abus d’autorité par l’auteur.",
            imagePath: 'assets/images/defaut_permis.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx_scolarite_pages/sanction_pages/causes_aggravation_sanction/auteur_abusant_autorite',
            ),
          ),
          const SizedBox(height: 14),

          _ModuleCard(
            tag: 'sanction_aggrav_auteur_ascendant_victime',
            title: "Qualité d’auteur ascendant de la victime",
            subtitle: "Aggravation liée au lien : ascendant de la victime.",
            imagePath: 'assets/images/cat_bases_juridiques.jpg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx_scolarite_pages/sanction_pages/causes_aggravation_sanction/auteur_ascendant_victime',
            ),
          ),
          const SizedBox(height: 14),

          _ModuleCard(
            tag: 'sanction_aggrav_auteur_depositaire_autorite',
            title: "Qualité d’auteur dépositaire de l’autorité",
            subtitle:
                "Aggravation liée à la qualité de dépositaire de l’autorité.",
            imagePath: 'assets/images/infraction_legal.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx_scolarite_pages/sanction_pages/causes_aggravation_sanction/auteur_depositaire_autorite',
            ),
          ),
          const SizedBox(height: 14),

          _ModuleCard(
            tag: 'sanction_aggrav_victime_ascendant_auteur',
            title: "Qualité de la victime ascendant de l’auteur",
            subtitle:
                "Aggravation liée au lien : victime ascendant de l’auteur.",
            imagePath: 'assets/images/atteintes_involontaires.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx_scolarite_pages/sanction_pages/causes_aggravation_sanction/victime_ascendant_auteur',
            ),
          ),
          const SizedBox(height: 14),

          _ModuleCard(
            tag: 'sanction_aggrav_victime_chargee_mission',
            title: "Qualité de la victime chargée d’une mission",
            subtitle: "Aggravation liée à la qualité : mission de service.",
            imagePath: 'assets/images/complicite.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx_scolarite_pages/sanction_pages/causes_aggravation_sanction/victime_chargee_mission',
            ),
          ),
          const SizedBox(height: 14),

          _ModuleCard(
            tag: 'sanction_aggrav_victime_depositaire_autorite',
            title: "Qualité de la victime dépositaire de l’autorité",
            subtitle:
                "Aggravation liée à la qualité de dépositaire de l’autorité.",
            imagePath: 'assets/images/defaut_permis.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx_scolarite_pages/sanction_pages/causes_aggravation_sanction/victime_depositaire_autorite',
            ),
          ),
          const SizedBox(height: 14),

          _ModuleCard(
            tag: 'sanction_aggrav_victime_prostitution',
            title: "Qualité de la victime qui se livre à la prostitution",
            subtitle: "Aggravation liée à la situation de la victime.",
            imagePath: 'assets/images/cat_bases_juridiques.jpg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx_scolarite_pages/sanction_pages/causes_aggravation_sanction/victime_prostitution',
            ),
          ),
          const SizedBox(height: 14),

          _ModuleCard(
            tag: 'sanction_aggrav_temoin_victime_partie_civile',
            title: "Qualité de témoin, victime ou partie civile",
            subtitle:
                "Aggravation liée à la qualité procédurale de la victime.",
            imagePath: 'assets/images/infraction_legal.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx_scolarite_pages/sanction_pages/causes_aggravation_sanction/temoin_victime_partie_civile',
            ),
          ),
          const SizedBox(height: 14),

          _ModuleCard(
            tag: 'sanction_aggrav_victime_parente_personne',
            title: "Qualité de victime parente d’une personne",
            subtitle: "Aggravation liée au lien familial / parenté.",
            imagePath: 'assets/images/atteintes_involontaires.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx_scolarite_pages/sanction_pages/causes_aggravation_sanction/victime_parente_personne',
            ),
          ),

          const SizedBox(height: 22),

          // ================= QUIZ =================
          _ModuleCard(
            tag: 'sanction_causes_aggravation_quiz',
            title: 'Quiz — Causes d’aggravation',
            subtitle:
                'Entraînez-vous sur les circonstances aggravantes et leurs effets.',
            imagePath: 'assets/images/quiz.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx/sanction/quiz/sanction_causes_aggravation',
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
                  // Badge
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
                      'PDF',
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
    );
  }
}
