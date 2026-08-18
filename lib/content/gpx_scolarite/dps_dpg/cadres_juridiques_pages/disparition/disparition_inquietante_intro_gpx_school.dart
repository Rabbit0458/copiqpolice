import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class DisparitionInquietanteIntroGpxSchool extends StatelessWidget {
  const DisparitionInquietanteIntroGpxSchool({super.key});

  // Route de la page
  static const String routeName =
      '/gpx/cadres_juridiques/disparitions_inquietantes/intro';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color bgColor = isDark ? const Color(0xFF111111) : Colors.white;
    final Color titleColor = isDark ? Colors.white : const Color(0xFF0D47A1);
    final Color textMain = isDark
        ? Colors.white
        : const Color(0xFF1F1F1F).withValues(alpha: .95);

    // Couleurs cartes / accents
    final Color cardColor = isDark
        ? const Color(0xFF1E272E)
        : const Color(0xFFE3F2FD);
    const Color accent = Color(0xFF1565C0);

    // Couleur pour les références d’articles (rouge)
    const Color articleRed = Color(0xFFC62828);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: textMain),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/disparition/disparition_inquietante_intro_gpx_school.dart",
            "f00001",
            'Les disparitions inquiétantes',
          ),
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w800,
            fontSize: 18,
            color: textMain,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 24),
        children: [
          // -----------------------------------------------------------------
          // TITRE + CHAPEAU
          // -----------------------------------------------------------------
          Text(
            ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/disparition/disparition_inquietante_intro_gpx_school.dart",
              "f00002",
              'Introduction du cadre juridique',
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 8),
          _Paragraph.rich([
            TextSpan(
              text: ScolariteText.value(
                "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/disparition/disparition_inquietante_intro_gpx_school.dart",
                "f00003",
                'Les dispositions des ',
              ),
            ),
            TextSpan(text: 'articles '),
            TextSpan(
              text: '74-1',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            TextSpan(text: ' et '),
            TextSpan(
              text: '80-4',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            TextSpan(text: ' du '),
            TextSpan(
              text: ScolariteText.value(
                "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/disparition/disparition_inquietante_intro_gpx_school.dart",
                "f00004",
                'Code de procédure pénale',
              ),
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            TextSpan(
              text:
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/disparition/disparition_inquietante_intro_gpx_school.dart",
                    "f00005",
                    ' organisent un cadre d’enquête spécifique pour la disparition ',
                  ) +
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/disparition/disparition_inquietante_intro_gpx_school.dart",
                    "f00006",
                    'd’un mineur, d’un majeur protégé ou d’un majeur présentant ',
                  ) +
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/disparition/disparition_inquietante_intro_gpx_school.dart",
                    "f00007",
                    'un caractère inquiétant ou suspect.',
                  ),
            ),
          ]),
          const SizedBox(height: 16),

          // -----------------------------------------------------------------
          // Rappel du texte de l’article 74-1
          // -----------------------------------------------------------------
          _SubTitle(
            ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/disparition/disparition_inquietante_intro_gpx_school.dart",
              "f00008",
              '1. Rappel de l’article 74-1 du Code de procédure pénale',
            ),
          ),
          const SizedBox(height: 4),
          _Paragraph.rich([
            TextSpan(
              text: ScolariteText.value(
                "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/disparition/disparition_inquietante_intro_gpx_school.dart",
                "f00009",
                'L’',
              ),
            ),
            TextSpan(
              text: ScolariteText.value(
                "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/disparition/disparition_inquietante_intro_gpx_school.dart",
                "f00010",
                'article 74-1 du Code de procédure pénale',
              ),
              style: TextStyle(fontWeight: FontWeight.w800, color: articleRed),
            ),
            TextSpan(
              text:
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/disparition/disparition_inquietante_intro_gpx_school.dart",
                    "f00011",
                    ' prévoit que, lorsque la disparition d’un mineur ou d’un majeur protégé ',
                  ) +
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/disparition/disparition_inquietante_intro_gpx_school.dart",
                    "f00012",
                    'vient d’intervenir ou d’être constatée, les officiers de police judiciaire, ',
                  ) +
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/disparition/disparition_inquietante_intro_gpx_school.dart",
                    "f00013",
                    'ou sous leur contrôle les agents de police judiciaire, peuvent, sur ',
                  ) +
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/disparition/disparition_inquietante_intro_gpx_school.dart",
                    "f00014",
                    'instructions du procureur de la République, mettre en œuvre les actes ',
                  ) +
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/disparition/disparition_inquietante_intro_gpx_school.dart",
                    "f00015",
                    'prévus aux articles 56 à 62 afin de découvrir la personne disparue.',
                  ),
            ),
          ]),
          const SizedBox(height: 8),
          _Paragraph(
            ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/disparition/disparition_inquietante_intro_gpx_school.dart",
                  "f00016",
                  'À l’issue d’un délai de huit jours à compter des instructions du procureur ',
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/disparition/disparition_inquietante_intro_gpx_school.dart",
                  "f00017",
                  'de la République, ces investigations peuvent se poursuivre dans les formes ',
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/disparition/disparition_inquietante_intro_gpx_school.dart",
                  "f00018",
                  'de l’enquête préliminaire.',
                ),
          ),
          const SizedBox(height: 8),
          _Paragraph(
            ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/disparition/disparition_inquietante_intro_gpx_school.dart",
                  "f00019",
                  'Le procureur de la République peut également requérir l’ouverture d’une ',
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/disparition/disparition_inquietante_intro_gpx_school.dart",
                  "f00020",
                  'information pour recherche des causes de la disparition.',
                ),
          ),
          const SizedBox(height: 8),
          _Paragraph(
            ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/disparition/disparition_inquietante_intro_gpx_school.dart",
                  "f00021",
                  'Ce dispositif est également applicable en cas de disparition d’un majeur ',
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/disparition/disparition_inquietante_intro_gpx_school.dart",
                  "f00022",
                  'présentant un caractère inquiétant ou suspect, compte tenu des circonstances, ',
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/disparition/disparition_inquietante_intro_gpx_school.dart",
                  "f00023",
                  'de l’âge de l’intéressé ou de son état de santé.',
                ),
          ),

          const SizedBox(height: 18),

          // -----------------------------------------------------------------
          // Cadre spécifique et transitoire
          // -----------------------------------------------------------------
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/disparition/disparition_inquietante_intro_gpx_school.dart",
              "f00024",
              'Un cadre juridique spécifique et transitoire (article 74-1 du Code de procédure pénale)',
            ),
            cardColor: cardColor,
            accent: accent,
            titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/disparition/disparition_inquietante_intro_gpx_school.dart",
                      "f00025",
                      'L’article 74-1 du Code de procédure pénale constitue un cadre ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/disparition/disparition_inquietante_intro_gpx_school.dart",
                      "f00026",
                      'juridique particulier, distinct de la procédure administrative ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/disparition/disparition_inquietante_intro_gpx_school.dart",
                      "f00027",
                      'de recherche, qui permet de diligenter des investigations plus ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/disparition/disparition_inquietante_intro_gpx_school.dart",
                      "f00028",
                      'poussées sous le contrôle du procureur de la République.',
                    ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/disparition/disparition_inquietante_intro_gpx_school.dart",
                  "f00029",
                  'Cadre spécifique',
                ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/disparition/disparition_inquietante_intro_gpx_school.dart",
                      "f00030",
                      'L’enquête diligentée dans ce cadre ne repose pas sur la ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/disparition/disparition_inquietante_intro_gpx_school.dart",
                      "f00031",
                      'constatation préalable d’une infraction. En l’absence ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/disparition/disparition_inquietante_intro_gpx_school.dart",
                      "f00032",
                      'd’indices laissant présumer un crime ou un délit, mais ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/disparition/disparition_inquietante_intro_gpx_school.dart",
                      "f00033",
                      'lorsque les circonstances rendent la disparition inquiétante, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/disparition/disparition_inquietante_intro_gpx_school.dart",
                      "f00034",
                      'l’objectif premier est la découverte de la personne disparue.',
                    ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/disparition/disparition_inquietante_intro_gpx_school.dart",
                  "f00035",
                  'Cadre transitoire',
                ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/disparition/disparition_inquietante_intro_gpx_school.dart",
                      "f00036",
                      'Ce cadre peut prendre fin à tout moment : soit lorsque la ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/disparition/disparition_inquietante_intro_gpx_school.dart",
                      "f00037",
                      'personne est découverte et que la disparition résulte d’un ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/disparition/disparition_inquietante_intro_gpx_school.dart",
                      "f00038",
                      'fait volontaire, soit lorsque apparaissent des éléments ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/disparition/disparition_inquietante_intro_gpx_school.dart",
                      "f00039",
                      'laissant présumer qu’un crime ou un délit a été commis. ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/disparition/disparition_inquietante_intro_gpx_school.dart",
                      "f00040",
                      'Dans ce second cas, il convient de basculer immédiatement ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/disparition/disparition_inquietante_intro_gpx_school.dart",
                      "f00041",
                      'vers un cadre judiciaire de droit commun (flagrance, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/disparition/disparition_inquietante_intro_gpx_school.dart",
                      "f00042",
                      'enquête préliminaire ou commission rogatoire).',
                    ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/disparition/disparition_inquietante_intro_gpx_school.dart",
                      "f00043",
                      'Lorsque les investigations n’ont pas abouti dans les huit jours ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/disparition/disparition_inquietante_intro_gpx_school.dart",
                      "f00044",
                      'suivant les instructions du procureur de la République, elles ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/disparition/disparition_inquietante_intro_gpx_school.dart",
                      "f00045",
                      'peuvent être poursuivies dans les formes de l’enquête ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/disparition/disparition_inquietante_intro_gpx_school.dart",
                      "f00046",
                      'préliminaire, sauf si le magistrat requiert l’ouverture ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/disparition/disparition_inquietante_intro_gpx_school.dart",
                      "f00047",
                      'd’une information spécifique pour recherche des causes de la ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/disparition/disparition_inquietante_intro_gpx_school.dart",
                      "f00048",
                      'disparition.',
                    ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // -----------------------------------------------------------------
          // Nota : lien avec procédure admin et article 80-4
          // -----------------------------------------------------------------
          _NotaBox(
            bodySpans: [
              TextSpan(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/disparition/disparition_inquietante_intro_gpx_school.dart",
                      "f00049",
                      'Le recours à ce cadre permet des investigations plus poussées ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/disparition/disparition_inquietante_intro_gpx_school.dart",
                      "f00050",
                      'que la procédure administrative de recherche prévue par ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/disparition/disparition_inquietante_intro_gpx_school.dart",
                      "f00051",
                      'l’article 26 de la loi n° 95-73 du 21 janvier 1995. Il peut ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/disparition/disparition_inquietante_intro_gpx_school.dart",
                      "f00052",
                      'être relayé, le cas échéant, par l’ouverture d’une information ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/disparition/disparition_inquietante_intro_gpx_school.dart",
                      "f00053",
                      'pour recherche des causes de la disparition sur le fondement ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/disparition/disparition_inquietante_intro_gpx_school.dart",
                      "f00054",
                      'de l’article 80-4 du Code de procédure pénale.',
                    ),
              ),
            ],
          ),
        ],
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
