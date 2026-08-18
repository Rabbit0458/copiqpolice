import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

/// Texte rouge pour les articles de loi
TextSpan _lawRef(String text) {
  return TextSpan(
    text: text,
    style: TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.w700),
  );
}

class PaPPMandatsSanctionsIrregularitesPage extends StatelessWidget {
  const PaPPMandatsSanctionsIrregularitesPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/procedure_penale/mandats_sanctions_irregularites';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Fond global de la page
    final Color bg = isDark ? const Color(0xFF10141A) : const Color(0xFFFFFFFF);

    final textMain = GoogleFonts.fustat(
      fontSize: 15.5,
      fontWeight: FontWeight.w800,
      color: isDark ? Colors.white : const Color(0xFF0D47A1),
    );

    final textSoft = GoogleFonts.fustat(
      fontSize: 13.5,
      fontWeight: FontWeight.w600,
      color: isDark ? Colors.white70 : const Color(0xFF424242),
    );

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        // on supprime la barre bleue
        backgroundColor: bg,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: isDark ? Colors.white : const Color(0xFF050505),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/procedure_penale_pages/pp_mandats_sanctions_irregularites.dart",
            "f00001",
            'Sanctions des irrégularités',
          ),
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w800,
            fontSize: 18,
            color: isDark ? Colors.white : const Color(0xFF050505),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bandeau d’intro — Chapitre 3
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: isDark
                        ? [const Color(0xFF0D47A1), const Color(0xFF002171)]
                        : [const Color(0xFFE3F2FD), const Color(0xFFBBDEFB)],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_mandats_sanctions_irregularites.dart",
                        "f00002",
                        'CHAPITRE 3 : SANCTIONS DES IRRÉGULARITÉS DES MANDATS',
                      ),
                      style: textMain,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      ScolariteText.value(
                            "lib/content/pa_scolarite/procedure_penale_pages/pp_mandats_sanctions_irregularites.dart",
                            "f00003",
                            'Les irrégularités affectant les mandats judiciaires peuvent entraîner des ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/procedure_penale_pages/pp_mandats_sanctions_irregularites.dart",
                            "f00004",
                            'sanctions visant les personnes responsables ou les actes eux-mêmes. ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/procedure_penale_pages/pp_mandats_sanctions_irregularites.dart",
                            "f00005",
                            'Le respect des formes est essentiel pour garantir la liberté individuelle ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/procedure_penale_pages/pp_mandats_sanctions_irregularites.dart",
                            "f00006",
                            'et les droits de la défense.',
                          ),
                      style: textSoft,
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),

              //////////////////////////////////////////////////////////////
              /// 3.1 — SANCTIONS CONTRE LES PERSONNES
              //////////////////////////////////////////////////////////////
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_mandats_sanctions_irregularites.dart",
                  "f00007",
                  '3.1 — Sanctions contre les personnes',
                ),
                cardColor: isDark
                    ? const Color(0xFF10141A)
                    : const Color(0xFFF5F7FB),
                accent: isDark
                    ? const Color(0xFF64B5F6)
                    : const Color(0xFF1565C0),
                titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
                children: [
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_mandats_sanctions_irregularites.dart",
                          "f00008",
                          'Plusieurs acteurs interviennent dans la chaîne de délivrance et ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_mandats_sanctions_irregularites.dart",
                          "f00009",
                          'd’exécution des mandats. Certains d’entre eux peuvent voir leur ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_mandats_sanctions_irregularites.dart",
                          "f00010",
                          'responsabilité engagée en cas d’irrégularités.',
                        ),
                  ),

                  const SizedBox(height: 10),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_mandats_sanctions_irregularites.dart",
                      "f00011",
                      'Rôle du greffier',
                    ),
                  ),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_mandats_sanctions_irregularites.dart",
                          "f00012",
                          'Le greffier est considéré comme responsable de la régularité formelle ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_mandats_sanctions_irregularites.dart",
                          "f00013",
                          'des mandats. Il doit s’assurer que chaque mandat :',
                        ),
                  ),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_mandats_sanctions_irregularites.dart",
                      "f00014",
                      'est régulièrement signé et daté ;',
                    ),
                  ),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_mandats_sanctions_irregularites.dart",
                      "f00015",
                      'est revêtu du sceau du magistrat ou de la juridiction compétente ;',
                    ),
                  ),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_mandats_sanctions_irregularites.dart",
                      "f00016",
                      'mentionne l’identité complète de la personne visée ;',
                    ),
                  ),
                  _BulletPoint(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_mandats_sanctions_irregularites.dart",
                          "f00017",
                          'et, lorsque la loi l’exige, précise la nature des faits imputés, ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_mandats_sanctions_irregularites.dart",
                          "f00018",
                          'leur qualification juridique ainsi que les textes applicables.',
                        ),
                  ),

                  const SizedBox(height: 12),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_mandats_sanctions_irregularites.dart",
                      "f00019",
                      'Responsabilité disciplinaire des magistrats',
                    ),
                  ),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_mandats_sanctions_irregularites.dart",
                          "f00020",
                          'Les éventuelles sanctions disciplinaires à l’encontre du juge ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_mandats_sanctions_irregularites.dart",
                          "f00021",
                          'd’instruction, du juge des libertés et de la détention ou du procureur ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_mandats_sanctions_irregularites.dart",
                          "f00022",
                          'de la République ne peuvent être prononcées que dans le cadre des ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_mandats_sanctions_irregularites.dart",
                          "f00023",
                          'règles du statut de la magistrature.',
                        ),
                  ),

                  const SizedBox(height: 12),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_mandats_sanctions_irregularites.dart",
                      "f00024",
                      'Responsabilité pénale en cas de détention arbitraire',
                    ),
                  ),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/pa_scolarite/procedure_penale_pages/pp_mandats_sanctions_irregularites.dart",
                            "f00025",
                            'En cas de détention arbitraire résultant du non-respect des délais ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/procedure_penale_pages/pp_mandats_sanctions_irregularites.dart",
                            "f00026",
                            'légaux, la responsabilité pénale des autorités peut être engagée. ',
                          ),
                    ),
                    _lawRef(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_mandats_sanctions_irregularites.dart",
                        "f00027",
                        'L’article 126 du Code de procédure pénale',
                      ),
                    ),
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_mandats_sanctions_irregularites.dart",
                        "f00028",
                        ' renvoie aux dispositions des ',
                      ),
                    ),
                    _lawRef(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_mandats_sanctions_irregularites.dart",
                        "f00029",
                        'articles 432-4 à 432-6 du Code pénal',
                      ),
                    ),
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/pa_scolarite/procedure_penale_pages/pp_mandats_sanctions_irregularites.dart",
                            "f00030",
                            ', qui répriment les atteintes volontaires à la liberté individuelle ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/procedure_penale_pages/pp_mandats_sanctions_irregularites.dart",
                            "f00031",
                            'commises par une personne dépositaire de l’autorité publique.',
                          ),
                    ),
                  ]),
                  const SizedBox(height: 6),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/pa_scolarite/procedure_penale_pages/pp_mandats_sanctions_irregularites.dart",
                            "f00032",
                            'Sont notamment visés les magistrats ou fonctionnaires (procureur ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/procedure_penale_pages/pp_mandats_sanctions_irregularites.dart",
                            "f00033",
                            'de la République, juge d’instruction, chef d’établissement ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/procedure_penale_pages/pp_mandats_sanctions_irregularites.dart",
                            "f00034",
                            'pénitentiaire) qui ont ordonné ou sciemment toléré une détention ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/procedure_penale_pages/pp_mandats_sanctions_irregularites.dart",
                            "f00035",
                            'arbitraire résultant de l’inobservation du délai de 24 heures fixé ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/procedure_penale_pages/pp_mandats_sanctions_irregularites.dart",
                            "f00036",
                            'pour l’interrogatoire de la personne arrêtée en vertu d’un mandat ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/procedure_penale_pages/pp_mandats_sanctions_irregularites.dart",
                            "f00037",
                            'd’amener. ',
                          ),
                    ),
                    _lawRef(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_mandats_sanctions_irregularites.dart",
                        "f00038",
                        'Les dispositions de l’article 126 du Code de procédure pénale',
                      ),
                    ),
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_mandats_sanctions_irregularites.dart",
                        "f00039",
                        ' sont également applicables au mandat d’arrêt, conformément à ',
                      ),
                    ),
                    _lawRef(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_mandats_sanctions_irregularites.dart",
                        "f00040",
                        'l’article 133 alinéa 1 du Code de procédure pénale',
                      ),
                    ),
                    const TextSpan(text: '.'),
                  ]),
                ],
              ),

              const SizedBox(height: 20),

              //////////////////////////////////////////////////////////////
              /// 3.2 — SANCTIONS CONCERNANT LES ACTES
              //////////////////////////////////////////////////////////////
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_mandats_sanctions_irregularites.dart",
                  "f00041",
                  '3.2 — Sanctions concernant les actes',
                ),
                cardColor: isDark
                    ? const Color(0xFF10141A)
                    : const Color(0xFFF5F7FB),
                accent: isDark
                    ? const Color(0xFF64B5F6)
                    : const Color(0xFF1565C0),
                titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
                children: [
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_mandats_sanctions_irregularites.dart",
                          "f00042",
                          'Les irrégularités peuvent porter soit sur la délivrance même du mandat ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_mandats_sanctions_irregularites.dart",
                          "f00043",
                          '(vice de forme ou de fond), soit sur sa notification ou son exécution. ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_mandats_sanctions_irregularites.dart",
                          "f00044",
                          'Les conséquences juridiques ne sont pas les mêmes.',
                        ),
                  ),

                  SizedBox(height: 10),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_mandats_sanctions_irregularites.dart",
                      "f00045",
                      'Irrégularités affectant la délivrance',
                    ),
                  ),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_mandats_sanctions_irregularites.dart",
                          "f00046",
                          'Lorsque le mandat ne respecte pas les conditions de forme ou de fond ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_mandats_sanctions_irregularites.dart",
                          "f00047",
                          'prévues par la loi (mentions obligatoires, compétence du magistrat, ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_mandats_sanctions_irregularites.dart",
                          "f00048",
                          'base légale…), ces irrégularités peuvent entraîner la nullité du ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_mandats_sanctions_irregularites.dart",
                          "f00049",
                          'mandat lui-même. La mesure privative ou restrictive de liberté repose ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_mandats_sanctions_irregularites.dart",
                          "f00050",
                          'alors sur un titre irrégulier.',
                        ),
                  ),

                  SizedBox(height: 10),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_mandats_sanctions_irregularites.dart",
                      "f00051",
                      'Irrégularités de notification ou d’exécution',
                    ),
                  ),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_mandats_sanctions_irregularites.dart",
                          "f00052",
                          'Les vices affectant la notification ou les modalités d’exécution ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_mandats_sanctions_irregularites.dart",
                          "f00053",
                          'du mandat ne remettent pas nécessairement en cause l’existence du ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_mandats_sanctions_irregularites.dart",
                          "f00054",
                          'mandat. Ils peuvent, en revanche, entraîner :',
                        ),
                  ),
                  _BulletPoint(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_mandats_sanctions_irregularites.dart",
                          "f00055",
                          'la nullité de l’exécution (par exemple, si les droits de la défense ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_mandats_sanctions_irregularites.dart",
                          "f00056",
                          'n’ont pas été respectés) ;',
                        ),
                  ),
                  _BulletPoint(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_mandats_sanctions_irregularites.dart",
                          "f00057",
                          'ou la caducité du mandat lorsque son inexécution ou son exécution ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_mandats_sanctions_irregularites.dart",
                          "f00058",
                          'irrégulière en a vidé les effets.',
                        ),
                  ),

                  SizedBox(height: 10),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_mandats_sanctions_irregularites.dart",
                      "f00059",
                      'Appréciation par la jurisprudence',
                    ),
                  ),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_mandats_sanctions_irregularites.dart",
                          "f00060",
                          'La jurisprudence considère que seules les irrégularités substantielles, ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_mandats_sanctions_irregularites.dart",
                          "f00061",
                          'de nature à porter atteinte aux droits de la défense ou aux garanties ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_mandats_sanctions_irregularites.dart",
                          "f00062",
                          'fondamentales de la personne, justifient la nullité. Les simples ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_mandats_sanctions_irregularites.dart",
                          "f00063",
                          'irrégularités de pure forme, sans grief, ne suffisent pas.',
                        ),
                  ),

                  SizedBox(height: 12),
                  _NotaBox(
                    title: 'INDEMNISATION',
                    bodySpans: [
                      TextSpan(
                        text:
                            ScolariteText.value(
                              "lib/content/pa_scolarite/procedure_penale_pages/pp_mandats_sanctions_irregularites.dart",
                              "f00064",
                              'Lorsqu’une détention irrégulière a été subie, une indemnisation ',
                            ) +
                            ScolariteText.value(
                              "lib/content/pa_scolarite/procedure_penale_pages/pp_mandats_sanctions_irregularites.dart",
                              "f00065",
                              'peut être accordée. Elle est décidée par le premier président de ',
                            ) +
                            ScolariteText.value(
                              "lib/content/pa_scolarite/procedure_penale_pages/pp_mandats_sanctions_irregularites.dart",
                              "f00066",
                              'la cour d’appel. L’État dispose ensuite d’un recours contre le ',
                            ) +
                            ScolariteText.value(
                              "lib/content/pa_scolarite/procedure_penale_pages/pp_mandats_sanctions_irregularites.dart",
                              "f00067",
                              'dénonciateur de mauvaise foi ou le faux témoin ayant provoqué la ',
                            ) +
                            ScolariteText.value(
                              "lib/content/pa_scolarite/procedure_penale_pages/pp_mandats_sanctions_irregularites.dart",
                              "f00068",
                              'détention injustifiée.',
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

///////////////////////////////////////////////////////////////////////////////
///                   TES WIDGETS PERSONNALISÉS EXACTS                    ///
///////////////////////////////////////////////////////////////////////////////

class _ConditionCard extends StatelessWidget {
  const _ConditionCard({
    required this.title,
    required this.cardColor,
    required this.accent,
    required this.titleColor,
    required this.children,
  });

  final String title;
  final Color cardColor;
  final Color accent;
  final Color titleColor;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      header: true,
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: accent.withValues(alpha: .22), width: 0.8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .12),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.fustat(
                fontWeight: FontWeight.w800,
                fontSize: 16.5,
                color: titleColor,
              ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _SubTitle extends StatelessWidget {
  const _SubTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(top: 6, bottom: 6),
      child: Text(
        text,
        style: GoogleFonts.fustat(
          fontWeight: FontWeight.w700,
          fontSize: 15.5,
          color: isDark ? Colors.white : const Color(0xFF0D47A1),
        ),
      ),
    );
  }
}

class _Paragraph extends StatelessWidget {
  const _Paragraph(this.text) : spans = null;

  const _Paragraph.rich(this.spans) : text = null;

  final String? text;
  final List<TextSpan>? spans;

  @override
  Widget build(BuildContext context) {
    final isRich = spans != null;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color color = isDark
        ? Colors.white70
        : const Color(0xFF1F1F1F).withValues(alpha: .92);

    if (!isRich) {
      return Text(
        text!,
        textAlign: TextAlign.justify,
        style: GoogleFonts.fustat(
          fontSize: 14,
          height: 1.45,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      );
    }

    return RichText(
      textAlign: TextAlign.justify,
      text: TextSpan(
        style: GoogleFonts.fustat(
          fontSize: 14,
          height: 1.45,
          fontWeight: FontWeight.w500,
          color: color,
        ),
        children: spans!,
      ),
    );
  }
}

class _IntroBullet extends StatelessWidget {
  const _IntroBullet({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bulletColor = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    final Color textColor = isDark
        ? Colors.white70
        : const Color(0xFF1F1F1F).withValues(alpha: .92);

    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Icon(
              Icons.arrow_right_rounded,
              size: 18,
              color: bulletColor,
            ),
          ),
          const SizedBox(width: 2),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.fustat(
                fontSize: 14,
                height: 1.3,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BulletPoint extends StatelessWidget {
  const _BulletPoint({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_rounded,
            size: 18,
            color: isDark ? const Color(0xFF64B5F6) : const Color(0xFF1565C0),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.fustat(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 1.35,
                color: isDark
                    ? Colors.white70
                    : const Color(0xFF1F1F1F).withValues(alpha: .92),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotaBox extends StatelessWidget {
  const _NotaBox({required this.bodySpans, this.title = 'NOTA'});

  final List<TextSpan> bodySpans;
  final String title;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color borderColor = isDark
        ? const Color(0xFFFFCA28)
        : const Color(0xFFF9A825);
    final Color bgColor = isDark
        ? const Color(0xFF26200F)
        : const Color(0xFFFFF8E1);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF5D4037);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor.withValues(alpha: isDark ? .7 : .95),
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: borderColor, width: 3)),
      ),
      child: RichText(
        textAlign: TextAlign.justify,
        text: TextSpan(
          style: GoogleFonts.fustat(
            fontSize: 13.5,
            fontWeight: FontWeight.w500,
            height: 1.4,
            color: isDark
                ? Colors.white70
                : const Color(0xFF3E2723).withValues(alpha: .95),
          ),
          children: [
            TextSpan(
              text: '$title : ',
              style: TextStyle(fontWeight: FontWeight.w900, color: titleColor),
            ),
            ...bodySpans,
          ],
        ),
      ),
    );
  }
}
