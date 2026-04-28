import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ViolationControleJudiciairePage extends StatelessWidget {
  const ViolationControleJudiciairePage({super.key});

  static const String routeName =
      '/gpx/cadres_juridiques/commission_rogatoire/violation_cj';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF262626) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);
    final Color textSoft = isDark
        ? Colors.white70
        : const Color(0xFF1F1F1F).withOpacity(.88);

    final Color cardBlue = isDark
        ? const Color(0xFF0D1B2A)
        : const Color(0xFFE3F2FD);
    final Color cardBlueAccent = const Color(0xFF1565C0);

    final lawStyle = TextStyle(
      color: Colors.red.shade700,
      fontWeight: FontWeight.w700,
    );

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
          'Violation du contrôle judiciaire',
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 17.5,
            color: textMain,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
        children: [
          // ================================================================
          // TITRE PRINCIPAL
          // ================================================================
          Text(
            '3.9 — Violation des obligations du contrôle judiciaire',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Retenue d’une personne placée sous contrôle judiciaire (ou sous assignation '
            'à résidence avec surveillance électronique) en cas de suspicion de '
            'violation de ses obligations, et droits reconnus durant cette mesure.',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w500,
              fontSize: 13.5,
              height: 1.35,
              color: textSoft,
            ),
          ),
          const SizedBox(height: 10),

          const _IntroBullet(
            text:
                'La retenue pour violation des obligations du contrôle judiciaire est une '
                'mesure spécifique, distincte de la garde à vue, mais qui reprend une '
                'grande partie des droits reconnus au gardé à vue.',
          ),
          const _IntroBullet(
            text:
                'La mesure est décidée et contrôlée par le juge d’instruction, qui est '
                'immédiatement informé par l’officier de police judiciaire.',
          ),
          const SizedBox(height: 20),

          // ================================================================
          // CARTE PRINCIPALE
          // ================================================================
          _ConditionCard(
            title: '3.9 — Retenue pour violation du contrôle judiciaire',
            cardColor: cardBlue,
            accent: cardBlueAccent,
            titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
            children: [
              _Paragraph.rich([
                const TextSpan(text: 'Dans le cadre du contrôle judiciaire, '),
                TextSpan(
                  text: 'l’article 141-4 du Code de procédure pénale',
                  style: lawStyle,
                ),
                const TextSpan(
                  text:
                      ' prévoit que les services de police et les unités de gendarmerie '
                      'peuvent, d’office ou sur instruction du juge d’instruction, '
                      'appréhender toute personne placée sous contrôle judiciaire à '
                      'l’encontre de laquelle il existe une ou plusieurs raisons plausibles '
                      'de soupçonner qu’elle a manqué à certaines obligations prévues à ',
                ),
                TextSpan(
                  text: 'l’article 138 du Code de procédure pénale',
                  style: lawStyle,
                ),
                const TextSpan(
                  text:
                      ' (notamment les 1°, 2°, 3°, 8°, 9°, 14°, 17° et 17° bis).',
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph(
                'Sur décision d’un officier de police judiciaire, cette personne peut alors '
                'être retenue pour une durée maximale de vingt-quatre heures dans un '
                'local de police ou de gendarmerie afin que sa situation soit vérifiée et '
                'qu’elle soit entendue sur la violation de ses obligations.',
              ),
              const SizedBox(height: 6),
              _Paragraph(
                'Dès le début de la mesure, l’officier de police judiciaire informe sans '
                'délai le juge d’instruction.',
              ),
              const SizedBox(height: 14),

              const _SubTitle('Information immédiate de la personne retenue'),
              _Paragraph(
                'La personne retenue est immédiatement informée, par l’officier de police '
                'judiciaire ou, sous son contrôle, par un agent de police judiciaire, dans '
                'une langue qu’elle comprend, de la durée maximale de la mesure, de la '
                'nature des obligations qu’elle est soupçonnée d’avoir violées, ainsi que '
                'des droits dont elle bénéficie.',
              ),
              const SizedBox(height: 10),

              const _SubTitle('Droits reconnus pendant la retenue'),
              _BulletPoint(
                text:
                    'Droit de faire prévenir un proche et son employeur ainsi que, si elle '
                    'est de nationalité étrangère, les autorités consulaires de l’État dont '
                    'elle est ressortissante, conformément à ',
              ),
              _Paragraph.rich([
                TextSpan(
                  text: 'l’article 63-2 du Code de procédure pénale',
                  style: lawStyle,
                ),
                const TextSpan(text: '.'),
              ]),
              const SizedBox(height: 4),
              const _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        'Par le renvoi à l’article 63-2 du Code de procédure pénale, la '
                        'personne retenue peut demander à faire prévenir, par téléphone, la '
                        'personne avec laquelle elle vit habituellement ou l’un de ses '
                        'parents en ligne directe, ou l’un de ses frères et sœurs, ou '
                        'toute autre personne qu’elle désigne, ainsi que son employeur et, '
                        'le cas échéant, les autorités consulaires de son pays.',
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _BulletPoint(
                text:
                    'Droit d’être examinée par un médecin, conformément à l’article 63-3 du '
                    'Code de procédure pénale.',
              ),
              _Paragraph.rich([
                TextSpan(
                  text: 'Article 63-3 du Code de procédure pénale',
                  style: lawStyle,
                ),
                const TextSpan(text: '.'),
              ]),
              const SizedBox(height: 4),
              _BulletPoint(
                text:
                    'Droit d’être assistée par un avocat, conformément aux articles 63-3-1 à '
                    '63-4-3 du Code de procédure pénale (droit à l’entretien confidentiel, '
                    'présence lors des auditions, etc.).',
              ),
              _Paragraph.rich([
                TextSpan(
                  text: 'Articles 63-3-1 à 63-4-3 du Code de procédure pénale',
                  style: lawStyle,
                ),
                const TextSpan(text: '.'),
              ]),
              const SizedBox(height: 4),
              const _BulletPoint(
                text:
                    'Droit d’être assistée par un interprète, s’il y a lieu (langue qu’elle '
                    'comprend).',
              ),
              const _BulletPoint(
                text:
                    'Droit, lors des auditions, après avoir décliné son identité, de faire '
                    'des déclarations, de répondre aux questions qui lui sont posées ou de '
                    'se taire.',
              ),
              const SizedBox(height: 10),

              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Les pouvoirs habituellement conférés au procureur de la République par ',
                ),
                TextSpan(
                  text: 'les articles 63-2 et 63-3 du Code de procédure pénale',
                  style: lawStyle,
                ),
                const TextSpan(
                  text:
                      ' sont exercés, dans le cadre de cette retenue, par le juge '
                      'd’instruction.',
                ),
              ]),
              const SizedBox(height: 12),

              const _SubTitle('Conditions d’exécution de la retenue'),
              _Paragraph(
                'La retenue doit s’exécuter dans des conditions assurant le respect de la '
                'dignité de la personne. Seules peuvent être imposées les mesures de '
                'sécurité strictement nécessaires.',
              ),
              const SizedBox(height: 6),
              _Paragraph(
                'La personne retenue ne peut pas faire l’objet d’investigations corporelles '
                'internes au cours de la retenue par le service de police ou par l’unité '
                'de gendarmerie.',
              ),
              const SizedBox(height: 6),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Un procès-verbal récapitulatif de la mesure est dressé conformément à ',
                ),
                TextSpan(
                  text: 'l’article 64 du Code de procédure pénale',
                  style: lawStyle,
                ),
                const TextSpan(text: '.'),
              ]),
              const SizedBox(height: 12),

              const _SubTitle('Issue de la mesure'),
              _Paragraph(
                'À l’issue de la retenue, le juge d’instruction peut ordonner que la '
                'personne soit conduite devant lui, notamment pour envisager la '
                'révocation du contrôle judiciaire, le cas échéant en saisissant le juge '
                'des libertés et de la détention.',
              ),
              const SizedBox(height: 6),
              _Paragraph(
                'Le juge d’instruction peut également demander à un officier ou à un agent '
                'de police judiciaire d’aviser la personne qu’elle est convoquée devant '
                'lui à une date ultérieure.',
              ),
              const SizedBox(height: 10),
              _Paragraph(
                'Les dispositions de cet article sont également applicables aux personnes '
                'placées sous assignation à résidence avec surveillance électronique.',
              ),
            ],
          ),
          const SizedBox(height: 26),
        ],
      ),
    );
  }
}

///////////////////////////////////////////////////////////////////////////////
///                   TES WIDGETS PERSONNALISÉS EXACTS                     ///
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
        : const Color(0xFF1F1F1F).withOpacity(.92);

    if (!isRich) {
      return Text(
        text ?? '',
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
                    : const Color(0xFF1F1F1F).withOpacity(.92),
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
        color: bgColor.withOpacity(isDark ? .7 : .95),
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
