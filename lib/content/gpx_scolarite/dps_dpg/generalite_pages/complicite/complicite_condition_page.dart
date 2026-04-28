import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
        : const Color(0xFF1F1F1F).withOpacity(.90);
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
          tooltip: 'Retour',
        ),
        title: Text(
          'Conditions de la complicité',
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
            'Les conditions de la complicité',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 20,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 6),
          _Paragraph.rich([
            const TextSpan(
              text:
                  'La complicité consiste en l’entente momentanée entre deux ou plusieurs personnes dans le but d’accomplir une infraction déterminée. ',
            ),
            const TextSpan(
              text:
                  'Le complice est celui qui aide l’auteur dans la préparation ou l’exécution de l’infraction, ',
            ),
            TextSpan(
              text:
                  'le co-auteur réalisant, lui, les éléments constitutifs de l’infraction.',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ]),
          const SizedBox(height: 10),
          _Paragraph.rich(const [
            TextSpan(
              text:
                  'La complicité punissable exige la réunion de trois conditions :',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ]),
          const SizedBox(height: 6),
          const _IntroBullet(text: 'un fait principal punissable ;'),
          const _IntroBullet(text: 'une participation à l’infraction ;'),
          const _IntroBullet(
            text: 'une intention de participer à cette infraction.',
          ),

          const SizedBox(height: 18),

          // A. Un fait principal punissable
          _ConditionCard(
            title: 'A. Un fait principal punissable',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: const [
              _Paragraph(
                'L’existence d’un fait principal punissable est une condition '
                'indispensable à la répression de la complicité. Le complice “emprunte” '
                'la criminalité de l’auteur principal : on ne peut condamner le complice '
                'que si le fait principal est lui-même prévu et réprimé par la loi.',
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text:
                      'Ainsi, si le fait principal échappe pour une raison légale à la répression (par exemple, ',
                ),
                TextSpan(
                  text:
                      'fait justifié par la légitime défense, ordre de la loi, '
                      'commandement de l’autorité légitime, prescription, amnistie…',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
                TextSpan(text: '), la complicité ne pourra pas être retenue.'),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                title: 'En matière contraventionnelle',
                bodySpans: [
                  TextSpan(
                    text:
                        'En contravention, le complice par aide ou assistance n’est puni que lorsqu’un texte le prévoit expressément. ',
                  ),
                  TextSpan(
                    text:
                        'En revanche, la complicité par instigation (provocation, ordres, etc.) reste toujours punissable à titre autonome (ex. art. R. 610-2 C. pén.).',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 18),

          // B. Une participation à l’infraction
          _ConditionCard(
            title: 'B. Une participation à l’infraction',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: const [
              _Paragraph.rich([
                TextSpan(
                  text:
                      'La participation à l’infraction suppose l’accomplissement d’un des actes matériels prévus par ',
                ),
                TextSpan(
                  text: 'l’article 121-7 du Code pénal',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.underline,
                  ),
                ),
                TextSpan(text: ' :'),
              ]),
              SizedBox(height: 10),

              // 1. Complicité par aide ou assistance
              _SubTitle('1. Complicité par aide ou assistance'),
              _Paragraph(
                'L’acte doit avoir facilité la préparation ou la consommation de l’infraction. '
                'Il peut consister en la fourniture de moyens matériels, logistiques ou humains.',
              ),
              SizedBox(height: 6),
              _ExempleBox(
                title: 'Exemple',
                bodySpans: [
                  TextSpan(
                    text:
                        'Celui qui procure une arme, du poison ou un véhicule, ou encore celui qui sert de guetteur pendant le vol, '
                        'apporte une aide matérielle à la commission de l’infraction.',
                  ),
                ],
              ),
              SizedBox(height: 12),

              // 2. Complicité par provocation
              _SubTitle('2. Complicité par provocation'),
              _Paragraph(
                'Le “provocateur” ou auteur moral de l’infraction est celui qui incite une personne déterminée à commettre une infraction.',
              ),
              SizedBox(height: 6),
              _BulletPoint(
                text:
                    'la provocation doit être accompagnée de circonstances comme un don, une promesse, un ordre, une menace ou un abus d’autorité ;',
              ),
              _BulletPoint(
                text:
                    'elle doit être individuelle, c’est-à-dire adressée à une personne déterminée ;',
              ),
              _BulletPoint(
                text:
                    'elle doit être suivie d’effets : l’infraction doit être réalisée ou au moins tentée.',
              ),
              SizedBox(height: 6),
              _ExempleBox(
                title: 'Exemple',
                bodySpans: [
                  TextSpan(
                    text:
                        'Un individu ordonne au conducteur d’un véhicule de forcer un barrage de gendarmerie : '
                        'il est complice par provocation si l’ordre est exécuté.',
                  ),
                ],
              ),
              SizedBox(height: 12),

              // 3. Complicité par fourniture d’instructions
              _SubTitle('3. Complicité par fourniture d’instructions'),
              _Paragraph(
                'Il s’agit d’indications précises, de nature à faciliter l’exécution d’une infraction, '
                'données en connaissance de cause : l’auteur sait que ses conseils serviront à la réalisation d’un crime ou d’un délit.',
              ),
              SizedBox(height: 6),
              _ExempleBox(
                title: 'Exemple',
                bodySpans: [
                  TextSpan(
                    text:
                        'Indiquer à un tiers, en vue d’un cambriolage, les heures où une personne est absente de son domicile, '
                        'ou la localisation exacte du coffre-fort.',
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 18),

          // C. Une intention de participer à l’infraction
          _ConditionCard(
            title: 'C. Une intention de participer à l’infraction',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: const [
              _Paragraph(
                'L’intention criminelle du complice doit réunir deux conditions cumulatives :',
              ),
              SizedBox(height: 6),
              _BulletPoint(
                text:
                    'une connaissance du caractère délictueux des actes envisagés ou réalisés par l’auteur principal ;',
              ),
              _BulletPoint(
                text:
                    'la volonté de s’associer à l’acte délictueux : le complice et l’auteur principal '
                    'doivent agir “ensemble et de concert” en vue d’obtenir le résultat recherché.',
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: 'À retenir',
                bodySpans: [
                  TextSpan(
                    text:
                        'Celui qui ignore totalement le projet criminel de l’auteur ne peut pas être complice. ',
                  ),
                  TextSpan(
                    text:
                        'Inversement, celui qui adhère volontairement au projet en apportant aide, instructions ou provocation '
                        'engage sa responsabilité de complice.',
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
          border: Border.all(color: accent.withOpacity(.22), width: 0.8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.12),
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
        : const Color(0xFF1F1F1F).withOpacity(.92);

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
        : const Color(0xFF1F1F1F).withOpacity(.92);

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
        : const Color(0xFF1F1F1F).withOpacity(.92);

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
        color: bgColor.withOpacity(isDark ? .65 : .9),
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
                    : const Color(0xFF102027).withOpacity(.95),
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
        color: bgColor.withOpacity(isDark ? .70 : .95),
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
                : const Color(0xFF3E2723).withOpacity(.95),
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
