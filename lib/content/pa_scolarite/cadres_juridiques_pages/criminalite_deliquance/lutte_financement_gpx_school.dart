import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaLutteFinancementGpxSchool extends StatelessWidget {
  const PaLutteFinancementGpxSchool({super.key});

  static const String routeName =
      '/pa/dps_dpg/cadres_juridiques/criminalite_organisee/financement';

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
          'Financement des activités criminelles',
          style: GoogleFonts.fustat(fontWeight: FontWeight.w700, fontSize: 16),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SubTitle(
                '2.3.4 – La lutte contre le financement des activités liées à la criminalité organisée',
              ),
              const SizedBox(height: 6),
              const _Paragraph(
                'Le dispositif de lutte contre le financement des activités liées à la '
                'criminalité organisée permet de geler rapidement les biens de la '
                'personne mise en examen afin de garantir le paiement des amendes et, '
                'le cas échéant, l’indemnisation des victimes.',
              ),
              const SizedBox(height: 10),
              _ConditionCard(
                title: 'Fondement juridique',
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: const [
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'L’article 706-103 du Code de procédure pénale autorise les '
                          'mesures conservatoires lors de la commission d’une infraction '
                          'liée à la criminalité organisée.',
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                ],
              ),

              const SizedBox(height: 22),
              _ConditionCard(
                title: '2.3.4.1 – Le champ d’application',
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: const [
                  _Paragraph(
                    'Il s’agit d’une procédure à caractère judiciaire, propre à la lutte '
                    'contre la criminalité organisée.',
                  ),
                  SizedBox(height: 6),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'Elle permet au juge des libertés et de la détention, sur '
                          'requête du procureur de la République, dans le cadre d’une '
                          'information judiciaire portant sur les infractions relevant du '
                          'domaine d’application des articles 706-73, 706-73-1 et 706-74 '
                          'du Code de procédure pénale, d’ordonner des mesures '
                          'conservatoires.',
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                  SizedBox(height: 8),
                  _Paragraph('La mesure conservatoire doit garantir :'),
                  SizedBox(height: 4),
                  _BulletPoint(text: 'le paiement des amendes encourues ;'),
                  _BulletPoint(
                    text:
                        'et, le cas échéant, l’indemnisation des victimes (dommages et '
                        'intérêts, restitution…).',
                  ),
                ],
              ),

              const SizedBox(height: 22),
              _ConditionCard(
                title: '2.3.4.2 – Les modalités de mise en œuvre',
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: const [
                  _Paragraph(
                    'Seul le juge des libertés et de la détention peut ordonner des '
                    'mesures conservatoires en matière de criminalité organisée. Il est '
                    'compétent sur l’ensemble du territoire national.',
                  ),
                  SizedBox(height: 6),
                  _Paragraph(
                    'Le juge des libertés et de la détention est saisi par une requête du '
                    'procureur de la République.',
                  ),
                  SizedBox(height: 4),
                  _Paragraph(
                    'Le rôle du juge d’instruction est indirect : il attire l’attention du '
                    'procureur de la République sur l’intérêt de mettre en œuvre de telles '
                    'mesures (par exemple lorsqu’il découvre un patrimoine important '
                    'lié aux faits).',
                  ),
                  SizedBox(height: 8),
                  _Paragraph('Les mesures conservatoires peuvent porter sur :'),
                  SizedBox(height: 4),
                  _BulletPoint(
                    text:
                        'les biens meubles (véhicules, sommes d’argent, valeurs, etc.) ;',
                  ),
                  _BulletPoint(
                    text:
                        'les biens immeubles (maisons, appartements, terrains, locaux '
                        'professionnels, etc.) ;',
                  ),
                  _BulletPoint(
                    text:
                        'des biens divis ou indivis appartenant à la personne mise en '
                        'examen (par exemple un bien détenu en indivision avec un proche).',
                  ),
                ],
              ),

              const SizedBox(height: 22),
              _ConditionCard(
                title: '2.3.4.3 – Les suites des mesures conservatoires',
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: const [
                  _Paragraph(
                    'Le sort des mesures conservatoires dépend de l’issue de la procédure '
                    'pénale et de l’action civile.',
                  ),
                  SizedBox(height: 8),
                  _Paragraph('En cas de condamnation :'),
                  SizedBox(height: 4),
                  _BulletPoint(
                    text:
                        'la condamnation pénale vaut validation des mesures '
                        'conservatoires ;',
                  ),
                  _BulletPoint(
                    text:
                        'elle permet l’inscription définitive des sûretés (hypothèques, '
                        'saisies, etc.).',
                  ),
                  SizedBox(height: 10),
                  _Paragraph('En cas d’échec des poursuites :'),
                  SizedBox(height: 4),
                  _BulletPoint(
                    text: 'en cas de non-lieu, de relaxe ou d’acquittement ;',
                  ),
                  _BulletPoint(
                    text:
                        'ou en cas d’extinction de l’action publique et de l’action civile,',
                  ),
                  _Paragraph(
                    'la mainlevée des mesures conservatoires intervient alors de plein droit '
                    '(les biens sont « libérés » et les sûretés radiées).',
                  ),
                ],
              ),

              const SizedBox(height: 24),
              const _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        'En pratique, ces mesures visent à empêcher l’organisation '
                        'criminelle de profiter des fruits de l’infraction et à garantir, '
                        'autant que possible, l’indemnisation des victimes. Version au '
                        '01/07/2025 – SDCP – Tous droits réservés.',
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
