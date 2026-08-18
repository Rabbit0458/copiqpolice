import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

/// ===================================================================
///  COP'IQ — RÉPRESSION DE LA COMPLICITÉ
///
///  Chapitre 3 : La répression de la complicité
///   - 3.1 Sens de la règle (art. 121-6 C. pén.)
///   - 3.2 Application de la règle
///       • Circonstances personnelles à l’auteur
///       • Circonstances réelles liées à l’acte
///       • Circonstances mixtes (auteur + acte)
/// ===================================================================
class CompliciteRepressionPage extends StatelessWidget {
  const CompliciteRepressionPage({super.key});

  static const String routeName = '/gpx/generalites/complicite/repression';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color bgColor = isDark ? const Color(0xFF121212) : Colors.white;
    final Color cardColor = isDark
        ? const Color(0xFF1E1E1E)
        : const Color(0xFFF7F7F7);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF050505);
    final Color textColor = isDark
        ? Colors.white70
        : const Color(0xFF1F1F1F).withValues(alpha: .90);
    final Color accent = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: titleColor),
          tooltip: ScolariteText.value(
            "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_repression_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_repression_page.dart",
            "f00002",
            'Répression de la complicité',
          ),
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: titleColor,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
        physics: const BouncingScrollPhysics(),
        children: [
          // En-tête
          Text(
            ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_repression_page.dart",
              "f00003",
              'I. La répression de la complicité',
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 20,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 6),
          _Paragraph.rich([
            TextSpan(
              text: ScolariteText.value(
                "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_repression_page.dart",
                "f00004",
                'Selon les termes de ',
              ),
            ),
            TextSpan(
              text: ScolariteText.value(
                "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_repression_page.dart",
                "f00005",
                'l’article 121-6 du Code pénal',
              ),
              style: TextStyle(
                fontWeight: FontWeight.w700,
                decoration: TextDecoration.underline,
              ),
            ),
            TextSpan(
              text:
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_repression_page.dart",
                    "f00006",
                    ', le complice est puni comme auteur. La question est donc de savoir ',
                  ) +
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_repression_page.dart",
                    "f00007",
                    'comment cette équivalence de principe s’applique concrètement aux peines.',
                  ),
            ),
          ]),
          const SizedBox(height: 18),

          // 3.1 Sens de la règle
          _SectionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_repression_page.dart",
              "f00008",
              '1. Sens de la règle',
            ),
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_repression_page.dart",
                      "f00009",
                      'Les peines encourues par l’auteur et le complice de l’infraction sont les mêmes : ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_repression_page.dart",
                      "f00010",
                      'en théorie, chacun répond de l’infraction comme s’il en était l’auteur principal. ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_repression_page.dart",
                      "f00011",
                      'Cependant, le juge n’a pas l’obligation de prononcer des peines identiques.',
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_repression_page.dart",
                      "f00012",
                      'Cette règle permet de prendre en compte le rôle réel joué par le complice dans la commission de l’infraction, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_repression_page.dart",
                      "f00013",
                      'tout en lui appliquant le même barème légal de peines que celui prévu pour l’auteur.',
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_repression_page.dart",
                  "f00014",
                  'Idée clé',
                ),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_repression_page.dart",
                          "f00015",
                          'Complice et auteur encourent en principe la même peine légale, ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_repression_page.dart",
                          "f00016",
                          'mais la peine effectivement prononcée peut varier en fonction de la personnalité de chacun ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_repression_page.dart",
                          "f00017",
                          'et des circonstances qui leur sont propres.',
                        ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 18),

          // 3.2 Application de la règle
          _SectionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_repression_page.dart",
              "f00018",
              '2. Application de la règle',
            ),
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: [
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_repression_page.dart",
                  "f00019",
                  'Dans la pratique, le complice peut être puni :',
                ),
              ),
              SizedBox(height: 6),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_repression_page.dart",
                  "f00020",
                  'd’une peine plus forte que l’auteur principal, si sa situation personnelle le justifie ;',
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_repression_page.dart",
                  "f00021",
                  'd’une peine équivalente à celle de l’auteur ;',
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_repression_page.dart",
                  "f00022",
                  'ou d’une peine inférieure, s’il bénéficie de circonstances atténuantes.',
                ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_repression_page.dart",
                      "f00023",
                      'Le juge apprécie donc la peine du complice à la lumière des circonstances qui aggravent ou atténuent ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_repression_page.dart",
                      "f00024",
                      'sa responsabilité. D’où la distinction entre circonstances personnelles, réelles et mixtes.',
                    ),
              ),

              SizedBox(height: 16),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_repression_page.dart",
                  "f00025",
                  '2.1 — Les circonstances personnelles à l’auteur',
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_repression_page.dart",
                      "f00026",
                      'Les circonstances personnelles sont celles qui atteignent ou aggravent la culpabilité de l’auteur lui-même ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_repression_page.dart",
                      "f00027",
                      '(ex. état de démence, contrainte, qualité de récidiviste, minorité, etc.).',
                    ),
              ),
              SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_repression_page.dart",
                    "f00028",
                    'Elles ne sont pas applicables au complice : ',
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_repression_page.dart",
                    "f00029",
                    'chacun reste jugé selon ses propres caractéristiques personnelles.',
                  ),
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ]),
              SizedBox(height: 6),
              _ExempleBox(
                title: 'Exemples',
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_repression_page.dart",
                          "f00030",
                          '• L’auteur est en état de démence ou contraint : il peut être déclaré pénalement irresponsable, ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_repression_page.dart",
                          "f00031",
                          'alors que le complice, pleinement conscient, demeure punissable.\n',
                        ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_repression_page.dart",
                      "f00032",
                      '• L’auteur est récidiviste : l’aggravation de peine liée à la récidive ne s’étend pas automatiquement au complice qui ne l’est pas.',
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_repression_page.dart",
                  "f00033",
                  '2.2 — Les circonstances réelles qui touchent à la matérialité de l’acte',
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_repression_page.dart",
                      "f00034",
                      'Les circonstances réelles sont des circonstances de fait qui modifient ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_repression_page.dart",
                      "f00035",
                      'la nature ou la gravité de l’infraction (ex. réunion, usage d’une arme, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_repression_page.dart",
                      "f00036",
                      'commission de nuit, etc.).',
                    ),
              ),
              SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_repression_page.dart",
                    "f00037",
                    'Ces circonstances aggravantes ou atténuantes ',
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_repression_page.dart",
                    "f00038",
                    's’étendent au complice, même s’il en ignorait l’existence, ',
                  ),
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_repression_page.dart",
                    "f00039",
                    'dès lors qu’elles sont liées à l’acte lui-même et non à la personne de l’auteur.',
                  ),
                ),
              ]),
              SizedBox(height: 6),
              _ExempleBox(
                title: 'Exemple',
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_repression_page.dart",
                          "f00040",
                          'La réunion pour un vol aggravé : même si le complice ignorait que l’auteur agirait avec un autre individu, ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_repression_page.dart",
                          "f00041",
                          'l’aggravation liée à la réunion s’applique également à lui, car elle touche à la matérialité de l’acte de vol.',
                        ),
                  ),
                ],
              ),

              SizedBox(height: 16),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_repression_page.dart",
                  "f00042",
                  '2.3 — Les circonstances mixtes (personne + acte)',
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_repression_page.dart",
                      "f00043",
                      'Les circonstances mixtes concernent à la fois la personne de l’auteur et l’acte. ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_repression_page.dart",
                      "f00044",
                      'Elles procèdent de la qualité ou de la situation personnelle de l’auteur, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_repression_page.dart",
                      "f00045",
                      'mais se répercutent sur l’acte en modifiant la nature de l’infraction.',
                    ),
              ),
              SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_repression_page.dart",
                      "f00046",
                      'Exemples : infractions aggravées du fait des fonctions professionnelles de l’auteur, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_repression_page.dart",
                      "f00047",
                      'de l’existence d’un lien familial entre l’auteur et la victime, ou encore de la préméditation de l’acte.',
                    ),
              ),
              SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_repression_page.dart",
                        "f00048",
                        'Une question s’est alors posée : ces circonstances aggravantes liées à la qualité de l’auteur principal ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_repression_page.dart",
                        "f00049",
                        'sont-elles applicables au complice ? ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_repression_page.dart",
                    "f00050",
                    'La Cour de cassation a répondu par l’affirmative.',
                  ),
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ]),
              SizedBox(height: 6),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_repression_page.dart",
                  "f00051",
                  'Arrêt du 7 septembre 2005',
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_repression_page.dart",
                      "f00052",
                      'Dans un arrêt du 7 septembre 2005 (n° 04-84.235), la Cour de cassation a jugé que ',
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_repression_page.dart",
                      "f00053",
                      '« sont applicables au complice des circonstances aggravantes liées à la qualité de l’auteur principal »',
                    ),
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_repression_page.dart",
                      "f00054",
                      ' : ainsi, la circonstance tirée de la qualité de fonctionnaire, par exemple, peut aggraver la peine du complice même s’il n’a pas cette qualité.',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// ------------------------------------------------------------------
/// CARTE DE SECTION
/// ------------------------------------------------------------------
class _SectionCard extends StatelessWidget {
  const _SectionCard({
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

/// ------------------------------------------------------------------
/// SOUS-TITRE
/// ------------------------------------------------------------------
class _SubTitle extends StatelessWidget {
  const _SubTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color color = isDark ? Colors.white : const Color(0xFF0D47A1);

    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 4),
      child: Text(
        text,
        style: GoogleFonts.fustat(
          fontWeight: FontWeight.w700,
          fontSize: 14.5,
          color: color,
        ),
      ),
    );
  }
}

/// ------------------------------------------------------------------
/// PARAGRAPHE SIMPLE / RICHE
/// ------------------------------------------------------------------
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
        text ?? '',
        textAlign: TextAlign.justify,
        style: GoogleFonts.fustat(
          fontSize: 14,
          height: 1.4,
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
          height: 1.4,
          fontWeight: FontWeight.w500,
          color: color,
        ),
        children: spans,
      ),
    );
  }
}

/// ------------------------------------------------------------------
/// PUCE (CHECK)
/// ------------------------------------------------------------------
class _BulletPoint extends StatelessWidget {
  const _BulletPoint({required this.text});

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
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Icon(Icons.check_rounded, size: 18, color: bulletColor),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.fustat(
                fontSize: 14,
                height: 1.35,
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

/// ------------------------------------------------------------------
/// BLOC EXEMPLE
/// ------------------------------------------------------------------
class _ExempleBox extends StatelessWidget {
  const _ExempleBox({required this.title, required this.bodySpans});

  final String title;
  final List<TextSpan> bodySpans;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color borderColor = isDark
        ? const Color(0xFF42A5F5)
        : const Color(0xFF1E88E5);
    final Color bgColor = isDark
        ? const Color(0xFF0D1B26)
        : const Color(0xFFE3F2FD);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF0D47A1);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor.withValues(alpha: isDark ? .65 : .9),
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: borderColor, width: 3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title :',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w800,
              fontSize: 13.5,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 4),
          RichText(
            textAlign: TextAlign.justify,
            text: TextSpan(
              style: GoogleFonts.fustat(
                fontSize: 13.5,
                height: 1.4,
                fontWeight: FontWeight.w500,
                color: isDark
                    ? Colors.white70
                    : const Color(0xFF102027).withValues(alpha: .95),
              ),
              children: bodySpans,
            ),
          ),
        ],
      ),
    );
  }
}

/// ------------------------------------------------------------------
/// BLOC NOTA / FOCUS
/// ------------------------------------------------------------------
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
        color: bgColor.withValues(alpha: isDark ? .70 : .95),
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: borderColor, width: 3)),
      ),
      child: RichText(
        textAlign: TextAlign.justify,
        text: TextSpan(
          style: GoogleFonts.fustat(
            fontSize: 13.5,
            height: 1.4,
            fontWeight: FontWeight.w500,
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
