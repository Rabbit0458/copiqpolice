import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// ===================================================================
///  COP'IQ — PARTICIPATION AU FAIT PRINCIPAL (COMPLICITÉ)
///
///  2.2 La participation au fait principal
///   - Nécessité d’une participation matérielle
///   - Nature des actes (actes positifs, antérieurs ou concomitants)
///   - Actes de complicité prévus par l’art. 121-7 C. pén.
///     • Complicité par provocation
///     • Complicité par fourniture d’instructions
///     • Complicité par aide ou assistance
/// ===================================================================
class CompliciteParticipationPage extends StatelessWidget {
  const CompliciteParticipationPage({super.key});

  static const String routeName = '/gpx/generalites/complicite/participation';

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
          'Participation au fait principal',
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
            'I. La participation au fait principal',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 20,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 6),
          _Paragraph(
            'Pour que la complicité soit punissable, la participation doit être '
            'matérielle et répondre aux formes prévues par l’article 121-7 du Code pénal. '
            'Le complice apporte un concours actif à la commission de l’infraction, '
            'sans pour autant réaliser lui-même tous ses éléments constitutifs.',
          ),
          const SizedBox(height: 18),

          // 2.2.1 Nécessité d'une participation matérielle
          _SectionCard(
            title: '1. Nécessité d’une participation matérielle',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: const [
              _Paragraph.rich([
                TextSpan(
                  text:
                      'Les actes de participation sont énumérés à l’article 121-7 du Code pénal. ',
                ),
                TextSpan(
                  text:
                      'Ils doivent être positifs et orientés vers la réalisation de l’infraction.',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ]),
              SizedBox(height: 10),
              _BulletPoint(
                text:
                    'Ce sont des actes positifs : la simple abstention ne peut être retenue comme acte de complicité (ex. le simple spectateur passif d’une infraction).',
              ),
              _BulletPoint(
                text:
                    'Les actes doivent être antérieurs ou concomitants au fait principal : il n’existe pas de complicité postérieure à l’infraction.',
              ),
              _BulletPoint(
                text:
                    'La participation doit présenter un lien direct avec la préparation ou la consommation de l’infraction.',
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: 'À noter',
                bodySpans: [
                  TextSpan(
                    text:
                        'Plus la frontière entre auteur et complice s’affine, plus la jurisprudence examine la réalité de la participation : '
                        'certains concours matériels très déterminants peuvent être requalifiés en coaction.',
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 18),

          // 2.2.1.2 Les actes de complicité prévus par l’article 121-7 C. pén.
          _SectionCard(
            title: '2. Les actes de complicité (art. 121-7 C. pén.)',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: const [
              _Paragraph(
                'L’article 121-7 énumère trois grands types d’actes de complicité : '
                'la provocation, la fourniture d’instructions et l’aide ou l’assistance.',
              ),
              SizedBox(height: 14),

              // 1. Provocation
              _SubTitle('1. La complicité par provocation'),
              _Paragraph(
                'Le “provocateur” ou auteur moral de l’infraction est celui qui incite '
                'une personne déterminée à commettre une infraction.',
              ),
              SizedBox(height: 6),
              _BulletPoint(
                text:
                    'La provocation doit être accompagnée de circonstances comme un don, une promesse, un ordre, une menace ou un abus d’autorité ou de pouvoir.',
              ),
              _BulletPoint(
                text:
                    'Elle doit être individuelle : la provocation vise une personne déterminée (à la différence d’un simple message général).',
              ),
              _BulletPoint(
                text:
                    'Elle doit être suivie d’effets : l’infraction doit être au moins tentée. '
                    'Un simple conseil non suivi d’effet ne suffit pas.',
              ),
              SizedBox(height: 6),
              _ExempleBox(
                title: 'Exemple jurisprudentiel',
                bodySpans: [
                  TextSpan(
                    text:
                        'La chambre criminelle a jugé complice par provocation le passager d’un véhicule '
                        'ayant donné l’ordre au conducteur de forcer un barrage constitué par un véhicule de gendarmerie : '
                        'l’ordre donné a directement entraîné la commission de l’infraction.',
                  ),
                ],
              ),

              SizedBox(height: 16),

              // 2. Fourniture d’instructions
              _SubTitle('2. La complicité par fourniture d’instructions'),
              _Paragraph(
                'La fourniture d’instructions consiste à donner des indications précises, '
                'de nature à faciliter l’exécution d’une infraction, en pleine connaissance de cause.',
              ),
              SizedBox(height: 6),
              _BulletPoint(
                text:
                    'Les instructions doivent être suffisamment concrètes pour orienter la réalisation matérielle de l’infraction.',
              ),
              _BulletPoint(
                text:
                    'Le complice sait que ces indications serviront à commettre un crime ou un délit.',
              ),
              SizedBox(height: 6),
              _ExempleBox(
                title: 'Exemple',
                bodySpans: [
                  TextSpan(
                    text:
                        'Indiquer, en vue d’un cambriolage, les heures où une personne est absente de chez elle, '
                        'ou le fonctionnement d’un système d’alarme, constitue une complicité par instruction.',
                  ),
                ],
              ),

              SizedBox(height: 16),

              // 3. Aide ou assistance
              _SubTitle('3. La complicité par aide ou assistance'),
              _Paragraph(
                'L’aide ou l’assistance suppose un concours matériel apporté à la préparation ou à la consommation de l’infraction.',
              ),
              SizedBox(height: 6),
              _BulletPoint(
                text:
                    'Elle peut consister en la fourniture de moyens matériels (arme, véhicule, outils, faux papiers, etc.).',
              ),
              _BulletPoint(
                text:
                    'Elle peut également consister en un concours apporté à l’auteur principal '
                    'au moment de la préparation ou de l’exécution de l’infraction (ex. faire le guet, neutraliser une victime…).',
              ),
              SizedBox(height: 6),
              _ExempleBox(
                title: 'Exemples',
                bodySpans: [
                  TextSpan(
                    text:
                        '• Celui qui procure une arme ou du poison à l’auteur principal.\n',
                  ),
                  TextSpan(
                    text:
                        '• La personne qui joue de la musique très fort pour couvrir les cris d’une victime pendant une agression.\n',
                  ),
                  TextSpan(
                    text:
                        'Dans ces cas, l’aide matérielle permet la commission de l’infraction '
                        'sans que le complice ne réalise lui-même tous les éléments de l’infraction.',
                  ),
                ],
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: 'Complicité et coaction',
                bodySpans: [
                  TextSpan(
                    text:
                        'La jurisprudence souligne qu’il existe parfois une “complicité corespective” : '
                        'lorsque chacun des participants apporte un concours important à l’action, '
                        'la frontière entre auteur et complice se brouille. '
                        'Les juges peuvent alors qualifier certains participants de co-auteurs plutôt que de simples complices.',
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
/// SOUS-TITRE (1., 2., 3.…)
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
