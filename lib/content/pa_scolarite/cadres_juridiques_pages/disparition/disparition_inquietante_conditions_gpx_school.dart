import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PaDisparitionInquietanteConditionsGpxSchool extends StatelessWidget {
  const PaDisparitionInquietanteConditionsGpxSchool({super.key});

  static const String routeName =
      '/pa/dps_dpg/cadres_juridiques/disparitions_inquietantes/chapitre1';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color bgColor = isDark ? const Color(0xFF111111) : Colors.white;
    final Color titleColor = isDark ? Colors.white : const Color(0xFF0D47A1);
    final Color textMain = isDark
        ? Colors.white
        : const Color(0xFF1F1F1F).withValues(alpha: .95);

    final Color cardColor = isDark
        ? const Color(0xFF1E272E)
        : const Color(0xFFE3F2FD);
    const accent = Color(0xFF1565C0);

    // Couleur pour les références d’articles
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
            "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparition_inquietante_conditions_gpx_school.dart",
            "f00001",
            'Disparitions inquiétantes — Chapitre 1',
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
          // ---------------------------------------------------------------
          // Titre principal
          // ---------------------------------------------------------------
          Text(
            ScolariteText.value(
              "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparition_inquietante_conditions_gpx_school.dart",
              "f00002",
              'Conditions d’application des articles 74-1 et 80-4 du Code de procédure pénale',
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 20.5,
              color: titleColor,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 10),

          _Paragraph(
            ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparition_inquietante_conditions_gpx_school.dart",
                  "f00003",
                  'Deux conditions doivent être réunies pour mettre en œuvre le cadre ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparition_inquietante_conditions_gpx_school.dart",
                  "f00004",
                  'juridique des disparitions inquiétantes :',
                ),
          ),
          const SizedBox(height: 8),
          _IntroBullet(
            text: ScolariteText.value(
              "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparition_inquietante_conditions_gpx_school.dart",
              "f00005",
              'La disparition doit être flagrante.',
            ),
          ),
          _IntroBullet(
            text: ScolariteText.value(
              "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparition_inquietante_conditions_gpx_school.dart",
              "f00006",
              'La disparition doit présenter un caractère inquiétant.',
            ),
          ),

          const SizedBox(height: 18),

          // ---------------------------------------------------------------
          // 1.1 La disparition flagrante
          // ---------------------------------------------------------------
          _SubTitle(
            ScolariteText.value(
              "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparition_inquietante_conditions_gpx_school.dart",
              "f00007",
              '1.1 — La disparition « flagrante »',
            ),
          ),
          _Paragraph.rich([
            TextSpan(
              text: ScolariteText.value(
                "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparition_inquietante_conditions_gpx_school.dart",
                "f00008",
                'L’',
              ),
            ),
            TextSpan(
              text: ScolariteText.value(
                "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparition_inquietante_conditions_gpx_school.dart",
                "f00009",
                'article 74-1 du Code de procédure pénale',
              ),
              style: TextStyle(fontWeight: FontWeight.w800, color: articleRed),
            ),
            TextSpan(
              text:
                  ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparition_inquietante_conditions_gpx_school.dart",
                    "f00010",
                    ' exige le caractère flagrant de la disparition d’un mineur ou d’un ',
                  ) +
                  ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparition_inquietante_conditions_gpx_school.dart",
                    "f00011",
                    'majeur protégé. Il est précisé que la disparition « vient ',
                  ) +
                  ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparition_inquietante_conditions_gpx_school.dart",
                    "f00012",
                    'd’intervenir ou d’être constatée ». Cette exigence vaut également ',
                  ) +
                  ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparition_inquietante_conditions_gpx_school.dart",
                    "f00013",
                    'pour la disparition inquiétante d’un majeur.',
                  ),
            ),
          ]),
          const SizedBox(height: 8),
          _Paragraph(
            ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparition_inquietante_conditions_gpx_school.dart",
                  "f00014",
                  'En l’absence de flagrance, le procureur de la République conserve la ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparition_inquietante_conditions_gpx_school.dart",
                  "f00015",
                  'possibilité soit d’ordonner une enquête préliminaire, soit de requérir ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparition_inquietante_conditions_gpx_school.dart",
                  "f00016",
                  'l’ouverture d’une information pour recherche des causes de la disparition.',
                ),
          ),

          const SizedBox(height: 18),

          // ---------------------------------------------------------------
          // 1.2 La disparition est inquiétante
          // ---------------------------------------------------------------
          _SubTitle(
            ScolariteText.value(
              "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparition_inquietante_conditions_gpx_school.dart",
              "f00017",
              '1.2 — La disparition est inquiétante',
            ),
          ),
          _Paragraph.rich([
            TextSpan(
              text: ScolariteText.value(
                "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparition_inquietante_conditions_gpx_school.dart",
                "f00018",
                'Les articles 74-1 et 80-4 du Code de procédure pénale',
              ),
              style: TextStyle(fontWeight: FontWeight.w800, color: articleRed),
            ),
            TextSpan(
              text:
                  ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparition_inquietante_conditions_gpx_school.dart",
                    "f00019",
                    ' instaurent un cadre spécifique d’enquête reposant sur la notion ',
                  ) +
                  ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparition_inquietante_conditions_gpx_school.dart",
                    "f00020",
                    'de disparition inquiétante. Ce cadre peut être mis en œuvre dans ',
                  ) +
                  ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparition_inquietante_conditions_gpx_school.dart",
                    "f00021",
                    'deux grandes hypothèses : les disparitions obligatoirement ',
                  ) +
                  ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparition_inquietante_conditions_gpx_school.dart",
                    "f00022",
                    'inquiétantes et les disparitions inquiétantes en raison des ',
                  ) +
                  ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparition_inquietante_conditions_gpx_school.dart",
                    "f00023",
                    'circonstances.',
                  ),
            ),
          ]),

          const SizedBox(height: 14),

          // ---------------------------------------------------------------
          // Carte 1 : disparitions obligatoirement inquiétantes
          // ---------------------------------------------------------------
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparition_inquietante_conditions_gpx_school.dart",
              "f00024",
              '1.2.1 — Les disparitions obligatoirement inquiétantes',
            ),
            cardColor: cardColor,
            accent: accent,
            titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
            children: [
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparition_inquietante_conditions_gpx_school.dart",
                  "f00025",
                  'Toute disparition de mineur.',
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparition_inquietante_conditions_gpx_school.dart",
                  "f00026",
                  'Toute disparition de majeur protégé.',
                ),
              ),
              SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparition_inquietante_conditions_gpx_school.dart",
                      "f00027",
                      'Les majeurs protégés sont les personnes placées sous sauvegarde ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparition_inquietante_conditions_gpx_school.dart",
                      "f00028",
                      'de justice, sous tutelle ou sous curatelle. ',
                    ),
              ),
              SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparition_inquietante_conditions_gpx_school.dart",
                      "f00029",
                      'À ce stade, toute disparition doit être considérée comme inquiétante, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparition_inquietante_conditions_gpx_school.dart",
                      "f00030",
                      'même si l’intéressé a l’habitude de fuguer ou s’il apparaît ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparition_inquietante_conditions_gpx_school.dart",
                      "f00031",
                      'clairement qu’il s’agit d’une disparition volontaire.',
                    ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ---------------------------------------------------------------
          // Carte 2 : disparitions inquiétantes en raison des circonstances
          // ---------------------------------------------------------------
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparition_inquietante_conditions_gpx_school.dart",
              "f00032",
              '1.2.2 — Les disparitions inquiétantes en raison des circonstances',
            ),
            cardColor: cardColor,
            accent: accent,
            titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparition_inquietante_conditions_gpx_school.dart",
                      "f00033",
                      'Une disparition peut être qualifiée d’inquiétante ou suspecte lorsqu’elle ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparition_inquietante_conditions_gpx_school.dart",
                      "f00034",
                      'fait craindre que la personne disparue est en danger, en fonction ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparition_inquietante_conditions_gpx_school.dart",
                      "f00035",
                      'de plusieurs critères.',
                    ),
              ),
              SizedBox(height: 8),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparition_inquietante_conditions_gpx_school.dart",
                  "f00036",
                  'Critères liés à la personne',
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparition_inquietante_conditions_gpx_school.dart",
                  "f00037",
                  'Son âge (très jeune, personne âgée, personne vulnérable…).',
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparition_inquietante_conditions_gpx_school.dart",
                  "f00038",
                  'Son état de santé :',
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparition_inquietante_conditions_gpx_school.dart",
                  "f00039",
                  'Personne sous traitement médical lourd ou atteinte d’une grave maladie.',
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparition_inquietante_conditions_gpx_school.dart",
                  "f00040",
                  'Personne en situation de handicap ou ayant subi un accident récent.',
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparition_inquietante_conditions_gpx_school.dart",
                  "f00041",
                  'Personne dépressive ou présentant des tendances suicidaires.',
                ),
              ),
              SizedBox(height: 8),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparition_inquietante_conditions_gpx_school.dart",
                  "f00042",
                  'Critères liés aux circonstances de la disparition',
                ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparition_inquietante_conditions_gpx_school.dart",
                      "f00043",
                      'Disparition survenue de manière subite et inexpliquée, sans ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparition_inquietante_conditions_gpx_school.dart",
                      "f00044",
                      'élément laissant penser à une simple volonté de rompre avec ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparition_inquietante_conditions_gpx_school.dart",
                      "f00045",
                      'l’entourage habituel.',
                    ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // ---------------------------------------------------------------
          // Nota + Rappel pénal
          // ---------------------------------------------------------------
          _NotaBox(
            bodySpans: [
              TextSpan(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparition_inquietante_conditions_gpx_school.dart",
                      "f00046",
                      'Chaque situation signalée doit faire l’objet d’un examen attentif. ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparition_inquietante_conditions_gpx_school.dart",
                      "f00047",
                      'En cas de doute, le fonctionnaire de police doit se rapprocher de ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparition_inquietante_conditions_gpx_school.dart",
                      "f00048",
                      'son supérieur hiérarchique et du procureur de la République.',
                    ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _NotaBox(
            title: 'RAPPEL',
            bodySpans: [
              TextSpan(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparition_inquietante_conditions_gpx_school.dart",
                      "f00049",
                      'Le fait, pour une personne ayant connaissance de la disparition ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparition_inquietante_conditions_gpx_school.dart",
                      "f00050",
                      'd’un mineur de quinze ans, de ne pas informer les autorités ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparition_inquietante_conditions_gpx_school.dart",
                      "f00051",
                      'judiciaires ou administratives afin d’empêcher ou de retarder la ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparition_inquietante_conditions_gpx_school.dart",
                      "f00052",
                      'mise en œuvre des procédures de recherche prévues par l’article ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparition_inquietante_conditions_gpx_school.dart",
                      "f00053",
                      '74-1 du Code de procédure pénale, est puni de deux ans ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparition_inquietante_conditions_gpx_school.dart",
                      "f00054",
                      'd’emprisonnement et de 30 000 € d’amende (article 434-4-1 du ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparition_inquietante_conditions_gpx_school.dart",
                      "f00055",
                      'Code pénal).',
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
