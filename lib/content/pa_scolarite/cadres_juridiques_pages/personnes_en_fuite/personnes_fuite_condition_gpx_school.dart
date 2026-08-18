import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PaPersonnesFuiteConditionGpxSchool extends StatelessWidget {
  const PaPersonnesFuiteConditionGpxSchool({super.key});

  static const String routeName =
      '/pa/dps_dpg/cadres_juridiques/recherche_personnes_fuite/chapitre1';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color cardColor = isDark
        ? const Color(0xFF111218)
        : const Color(0xFFFDFDFE);
    final Color accent = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF0D47A1);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_condition_gpx_school.dart",
            "f00001",
            'Art. 74-2 – Conditions d’application',
          ),
          style: GoogleFonts.fustat(fontWeight: FontWeight.w700, fontSize: 16),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SubTitle(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_condition_gpx_school.dart",
                      "f00002",
                      'Chapitre 1 : Les conditions d’application\n',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_condition_gpx_school.dart",
                      "f00003",
                      'de l’Article 74-2 du Code de procédure pénale',
                    ),
              ),
              const SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_condition_gpx_school.dart",
                        "f00004",
                        'La procédure de l’Article 74-2 du Code de procédure pénale est ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_condition_gpx_school.dart",
                        "f00005",
                        'applicable à l’encontre d’une personne en fuite qui remplit ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_condition_gpx_school.dart",
                        "f00006",
                        'certaines conditions strictement définies par la loi.',
                      ),
                  style: TextStyle(color: Colors.red),
                ),
              ]),
              const SizedBox(height: 16),

              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_condition_gpx_school.dart",
                  "f00007",
                  '1 – La personne fait l’objet d’un mandat d’arrêt',
                ),
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: [
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_condition_gpx_school.dart",
                          "f00008",
                          'La procédure s’applique tout d’abord lorsque la personne en fuite ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_condition_gpx_school.dart",
                          "f00009",
                          'fait l’objet d’un mandat d’arrêt.',
                        ),
                  ),
                  SizedBox(height: 8),
                  _BulletPoint(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_condition_gpx_school.dart",
                          "f00010",
                          'Lors de son renvoi devant une juridiction de jugement : à ce ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_condition_gpx_school.dart",
                          "f00011",
                          'stade, le mandat d’arrêt est délivré par le juge d’instruction, ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_condition_gpx_school.dart",
                          "f00012",
                          'le juge des libertés et de la détention, la chambre de ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_condition_gpx_school.dart",
                          "f00013",
                          'l’instruction ou son président, ou le président de la cour ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_condition_gpx_school.dart",
                          "f00014",
                          'd’assises ;',
                        ),
                  ),
                  _BulletPoint(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_condition_gpx_school.dart",
                          "f00015",
                          'Lorsque le mandat d’arrêt est délivré par une juridiction de ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_condition_gpx_school.dart",
                          "f00016",
                          'jugement ou par le juge de l’application des peines.',
                        ),
                  ),
                ],
              ),

              const SizedBox(height: 22),
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_condition_gpx_school.dart",
                  "f00017",
                  '2 – La personne est condamnée à une peine privative de liberté',
                ),
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: [
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_condition_gpx_school.dart",
                          "f00018",
                          'La procédure de l’Article 74-2 du Code de procédure pénale est ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_condition_gpx_school.dart",
                          "f00019",
                          'également applicable lorsque la personne :',
                        ),
                  ),
                  SizedBox(height: 8),
                  _BulletPoint(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_condition_gpx_school.dart",
                          "f00020",
                          'est condamnée à une peine privative de liberté, sans sursis ou ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_condition_gpx_school.dart",
                          "f00021",
                          'résultant de la révocation d’un sursis assorti ou non d’une ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_condition_gpx_school.dart",
                          "f00022",
                          'probation, supérieure ou égale à un an, lorsque cette ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_condition_gpx_school.dart",
                          "f00023",
                          'condamnation est exécutoire ou passée en force de chose jugée.',
                        ),
                  ),
                ],
              ),

              const SizedBox(height: 22),
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_condition_gpx_school.dart",
                  "f00024",
                  '3 – La personne est inscrite dans certains fichiers judiciaires',
                ),
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: [
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_condition_gpx_school.dart",
                          "f00025",
                          'L’Article 74-2 du Code de procédure pénale vise aussi les situations ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_condition_gpx_school.dart",
                          "f00026",
                          'dans lesquelles la personne en fuite est soumise à des obligations ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_condition_gpx_school.dart",
                          "f00027",
                          'liées à une inscription dans un fichier judiciaire national automatisé.',
                        ),
                  ),
                  SizedBox(height: 8),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_condition_gpx_school.dart",
                            "f00028",
                            'Elle est inscrite au fichier judiciaire national automatisé des ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_condition_gpx_school.dart",
                            "f00029",
                            'auteurs d’infractions terroristes ayant manqué aux obligations ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_condition_gpx_school.dart",
                            "f00030",
                            'prévues à l’Article 706-25-7 du Code de procédure pénale ;',
                          ),
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                  SizedBox(height: 6),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_condition_gpx_school.dart",
                            "f00031",
                            'Elle est inscrite au fichier judiciaire national automatisé des ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_condition_gpx_school.dart",
                            "f00032",
                            'auteurs d’infractions sexuelles ou violentes ayant manqué aux ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_condition_gpx_school.dart",
                            "f00033",
                            'obligations prévues à l’Article 706-53-5 du Code de procédure ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_condition_gpx_school.dart",
                            "f00034",
                            'pénale.',
                          ),
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                ],
              ),

              const SizedBox(height: 22),
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_condition_gpx_school.dart",
                  "f00035",
                  '4 – Décision de retrait ou de révocation d’un aménagement de peine',
                ),
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: [
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_condition_gpx_school.dart",
                          "f00036",
                          'Enfin, la procédure de recherche des personnes en fuite s’applique ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_condition_gpx_school.dart",
                          "f00037",
                          'lorsque la personne :',
                        ),
                  ),
                  SizedBox(height: 8),
                  _BulletPoint(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_condition_gpx_school.dart",
                          "f00038",
                          'fait l’objet d’une décision de retrait ou de révocation d’un ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_condition_gpx_school.dart",
                          "f00039",
                          'aménagement de peine ou d’une libération sous contrainte ;',
                        ),
                  ),
                  _BulletPoint(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_condition_gpx_school.dart",
                          "f00040",
                          'ou d’une décision de mise à exécution de l’emprisonnement prévu ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_condition_gpx_school.dart",
                          "f00041",
                          'par la juridiction de jugement en cas de violation des obligations ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_condition_gpx_school.dart",
                          "f00042",
                          'et interdictions résultant d’une peine ;',
                        ),
                  ),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_condition_gpx_school.dart",
                          "f00043",
                          'et que cette décision a pour conséquence la mise à exécution d’un ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_condition_gpx_school.dart",
                          "f00044",
                          'quantum ou d’un reliquat de peine d’emprisonnement supérieur à un an.',
                        ),
                  ),
                ],
              ),

              const SizedBox(height: 24),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_condition_gpx_school.dart",
                          "f00045",
                          'En résumé, l’Article 74-2 du Code de procédure pénale ne vise pas ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_condition_gpx_school.dart",
                          "f00046",
                          'toute personne recherchée mais uniquement celles qui sont ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_condition_gpx_school.dart",
                          "f00047",
                          'concernées par un mandat d’arrêt, une peine d’emprisonnement ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_condition_gpx_school.dart",
                          "f00048",
                          'significative, une inscription dans certains fichiers judiciaires, ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_condition_gpx_school.dart",
                          "f00049",
                          'ou une décision de retrait ou de révocation d’un aménagement de ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_condition_gpx_school.dart",
                          "f00050",
                          'peine. Version au 01/07/2025 – SDCP – Tous droits réservés.',
                        ),
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
  const _NotaBox({required this.bodySpans});

  final List<TextSpan> bodySpans;
  final String title = 'NOTA';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color borderColor = isDark
        ? const Color(0xFFFFCA28)
        : const Color(0xFFF9A825);
    final Color bgColor = isDark
        ? const Color(0xFF26200F)
        : const Color(0xFFFFF8E1);

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
          children: [...bodySpans],
        ),
      ),
    );
  }
}
