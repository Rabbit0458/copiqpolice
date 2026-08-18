import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

/// ===================================================================
///  COP'IQ — CONDITIONS DE LA COMPLICITÉ
///
///  Structure calquée sur ConditionTentativePage :
///   - Thème dark / light
///   - Intro + rappel des 3 conditions
///   - A. Un fait principal punissable
///   - B. Une participation à l’infraction
///   - C. Une intention de participer à l’infraction
///   - Encadrés "Exemple" + "NOTA / Sanction"
/// ===================================================================
class CompliciteConditionPage extends StatelessWidget {
  const CompliciteConditionPage({super.key});

  static const String routeName = '/gpx/generalites/complicite/conditions';

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
            "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_condition_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_condition_page.dart",
            "f00002",
            'Conditions de la complicité',
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
              "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_condition_page.dart",
              "f00003",
              'Les conditions de la complicité',
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
                "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_condition_page.dart",
                "f00004",
                'La complicité consiste en l’entente momentanée entre deux ou plusieurs personnes dans le but d’accomplir une infraction déterminée. ',
              ),
            ),
            TextSpan(
              text: ScolariteText.value(
                "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_condition_page.dart",
                "f00005",
                'Le complice est celui qui aide l’auteur dans la préparation ou l’exécution de l’infraction, ',
              ),
            ),
            TextSpan(
              text: ScolariteText.value(
                "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_condition_page.dart",
                "f00006",
                'le co-auteur réalisant, lui, les éléments constitutifs de l’infraction.',
              ),
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ]),
          const SizedBox(height: 10),
          _Paragraph.rich([
            TextSpan(
              text: ScolariteText.value(
                "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_condition_page.dart",
                "f00007",
                'La complicité punissable exige la réunion de trois conditions :',
              ),
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ]),
          const SizedBox(height: 6),
          _IntroBullet(
            text: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_condition_page.dart",
              "f00008",
              'un fait principal punissable ;',
            ),
          ),
          _IntroBullet(
            text: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_condition_page.dart",
              "f00009",
              'une participation à l’infraction ;',
            ),
          ),
          _IntroBullet(
            text: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_condition_page.dart",
              "f00010",
              'une intention de participer à cette infraction.',
            ),
          ),

          const SizedBox(height: 18),

          // A. Un fait principal punissable
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_condition_page.dart",
              "f00011",
              'A. Un fait principal punissable',
            ),
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_condition_page.dart",
                      "f00012",
                      'L’existence d’un fait principal punissable est une condition ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_condition_page.dart",
                      "f00013",
                      'indispensable à la répression de la complicité. Le complice “emprunte” ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_condition_page.dart",
                      "f00014",
                      'la criminalité de l’auteur principal : on ne peut condamner le complice ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_condition_page.dart",
                      "f00015",
                      'que si le fait principal est lui-même prévu et réprimé par la loi.',
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_condition_page.dart",
                    "f00016",
                    'Ainsi, si le fait principal échappe pour une raison légale à la répression (par exemple, ',
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_condition_page.dart",
                        "f00017",
                        'fait justifié par la légitime défense, ordre de la loi, ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_condition_page.dart",
                        "f00018",
                        'commandement de l’autorité légitime, prescription, amnistie…',
                      ),
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_condition_page.dart",
                    "f00019",
                    '), la complicité ne pourra pas être retenue.',
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_condition_page.dart",
                  "f00020",
                  'En matière contraventionnelle',
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_condition_page.dart",
                      "f00021",
                      'En contravention, le complice par aide ou assistance n’est puni que lorsqu’un texte le prévoit expressément. ',
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_condition_page.dart",
                      "f00022",
                      'En revanche, la complicité par instigation (provocation, ordres, etc.) reste toujours punissable à titre autonome (ex. art. R. 610-2 C. pén.).',
                    ),
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 18),

          // B. Une participation à l’infraction
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_condition_page.dart",
              "f00023",
              'B. Une participation à l’infraction',
            ),
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_condition_page.dart",
                    "f00024",
                    'La participation à l’infraction suppose l’accomplissement d’un des actes matériels prévus par ',
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_condition_page.dart",
                    "f00025",
                    'l’article 121-7 du Code pénal',
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.underline,
                  ),
                ),
                TextSpan(text: ' :'),
              ]),
              SizedBox(height: 10),

              // 1. Complicité par aide ou assistance
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_condition_page.dart",
                  "f00026",
                  '1. Complicité par aide ou assistance',
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_condition_page.dart",
                      "f00027",
                      'L’acte doit avoir facilité la préparation ou la consommation de l’infraction. ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_condition_page.dart",
                      "f00028",
                      'Il peut consister en la fourniture de moyens matériels, logistiques ou humains.',
                    ),
              ),
              SizedBox(height: 6),
              _ExempleBox(
                title: 'Exemple',
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_condition_page.dart",
                          "f00029",
                          'Celui qui procure une arme, du poison ou un véhicule, ou encore celui qui sert de guetteur pendant le vol, ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_condition_page.dart",
                          "f00030",
                          'apporte une aide matérielle à la commission de l’infraction.',
                        ),
                  ),
                ],
              ),
              SizedBox(height: 12),

              // 2. Complicité par provocation
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_condition_page.dart",
                  "f00031",
                  '2. Complicité par provocation',
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_condition_page.dart",
                  "f00032",
                  'Le “provocateur” ou auteur moral de l’infraction est celui qui incite une personne déterminée à commettre une infraction.',
                ),
              ),
              SizedBox(height: 6),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_condition_page.dart",
                  "f00033",
                  'la provocation doit être accompagnée de circonstances comme un don, une promesse, un ordre, une menace ou un abus d’autorité ;',
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_condition_page.dart",
                  "f00034",
                  'elle doit être individuelle, c’est-à-dire adressée à une personne déterminée ;',
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_condition_page.dart",
                  "f00035",
                  'elle doit être suivie d’effets : l’infraction doit être réalisée ou au moins tentée.',
                ),
              ),
              SizedBox(height: 6),
              _ExempleBox(
                title: 'Exemple',
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_condition_page.dart",
                          "f00036",
                          'Un individu ordonne au conducteur d’un véhicule de forcer un barrage de gendarmerie : ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_condition_page.dart",
                          "f00037",
                          'il est complice par provocation si l’ordre est exécuté.',
                        ),
                  ),
                ],
              ),
              SizedBox(height: 12),

              // 3. Complicité par fourniture d’instructions
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_condition_page.dart",
                  "f00038",
                  '3. Complicité par fourniture d’instructions',
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_condition_page.dart",
                      "f00039",
                      'Il s’agit d’indications précises, de nature à faciliter l’exécution d’une infraction, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_condition_page.dart",
                      "f00040",
                      'données en connaissance de cause : l’auteur sait que ses conseils serviront à la réalisation d’un crime ou d’un délit.',
                    ),
              ),
              SizedBox(height: 6),
              _ExempleBox(
                title: 'Exemple',
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_condition_page.dart",
                          "f00041",
                          'Indiquer à un tiers, en vue d’un cambriolage, les heures où une personne est absente de son domicile, ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_condition_page.dart",
                          "f00042",
                          'ou la localisation exacte du coffre-fort.',
                        ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 18),

          // C. Une intention de participer à l’infraction
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_condition_page.dart",
              "f00043",
              'C. Une intention de participer à l’infraction',
            ),
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: [
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_condition_page.dart",
                  "f00044",
                  'L’intention criminelle du complice doit réunir deux conditions cumulatives :',
                ),
              ),
              SizedBox(height: 6),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_condition_page.dart",
                  "f00045",
                  'une connaissance du caractère délictueux des actes envisagés ou réalisés par l’auteur principal ;',
                ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_condition_page.dart",
                      "f00046",
                      'la volonté de s’associer à l’acte délictueux : le complice et l’auteur principal ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_condition_page.dart",
                      "f00047",
                      'doivent agir “ensemble et de concert” en vue d’obtenir le résultat recherché.',
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_condition_page.dart",
                  "f00048",
                  'À retenir',
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_condition_page.dart",
                      "f00049",
                      'Celui qui ignore totalement le projet criminel de l’auteur ne peut pas être complice. ',
                    ),
                  ),
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_condition_page.dart",
                          "f00050",
                          'Inversement, celui qui adhère volontairement au projet en apportant aide, instructions ou provocation ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_condition_page.dart",
                          "f00051",
                          'engage sa responsabilité de complice.',
                        ),
                    style: TextStyle(fontWeight: FontWeight.w600),
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
/// CARTE GLOBALE POUR CHAQUE CONDITION (A / B / C)
/// ------------------------------------------------------------------
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

/// ------------------------------------------------------------------
/// TITRE DE SOUS-PARTIE (1., 2., 3. …)
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
/// PARAGRAPHES SIMPLES OU RICHES
/// ------------------------------------------------------------------
class _Paragraph extends StatelessWidget {
  const _Paragraph(this.text) : spans = null;

  const _Paragraph.rich(this.spans) : text = null;

  final String? text;
  final List<TextSpan>? spans;

  @override
  Widget build(BuildContext context) {
    final isRich = spans != null;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
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
/// PUCE D’INTRO (les 3 conditions au début)
/// ------------------------------------------------------------------
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

/// ------------------------------------------------------------------
/// PUCE (dans les sections B et C)
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
/// BLOC NOTA / INFO / SANCTION
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
