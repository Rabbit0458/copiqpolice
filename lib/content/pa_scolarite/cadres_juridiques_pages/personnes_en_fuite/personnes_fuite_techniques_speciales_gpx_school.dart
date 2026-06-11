import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaPersonnesFuiteTechniqueSpecialesGpxSchool extends StatelessWidget {
  const PaPersonnesFuiteTechniqueSpecialesGpxSchool({super.key});

  static const String routeName =
      '/pa/dps_dpg/cadres_juridiques/recherche_personnes_fuite/chapitre3';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color cardColor = isDark
? const Color(0xFF111827)
: const Color(0xFFE3F2FD);
    final Color accent = isDark
? const Color(0xFF64B5F6)
: const Color(0xFF1565C0);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF0D47A1);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Personnes en fuite – Tech. spéciales',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SubTitle('2.2.3 – Les techniques spéciales d’enquête'),
              const SizedBox(height: 8),
              const _Paragraph(
                'Lorsque les nécessités de l’enquête l’exigent, l’Article 74-2 du Code de '
                'procédure pénale permet de mettre en œuvre certaines des techniques '
                'd’enquête applicables à la criminalité et à la délinquance organisées, '
                'ainsi qu’aux crimes. Ces techniques s’inscrivent dans le cadre de la '
                'procédure applicable à la délinquance et à la criminalité organisées.',
              ),
              const SizedBox(height: 20),

              // 2.2.3.1 – Dispositifs procéduraux applicables
              const _SubTitle(
                '2.2.3.1 – Les dispositifs procéduraux applicables',
              ),
              const SizedBox(height: 8),
              _ConditionCard(
                title: 'Principales techniques d’enquête mobilisables',
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: const [
                  _IntroBullet(
                    text:
                        'Les techniques suivantes peuvent être mises en œuvre, sous le '
                        'contrôle de l’autorité judiciaire, pour rechercher une personne '
                        'en fuite lorsque les conditions légales sont réunies :',
                  ),
                  SizedBox(height: 8),
                  _BulletPoint(
                    text:
                        'La surveillance (Articles 706-80 à 706-80-2 du Code de procédure pénale) ;',
                  ),
                  _BulletPoint(
                    text:
                        'L’infiltration (Articles 706-81 à 706-87 du Code de procédure pénale) ;',
                  ),
                  _BulletPoint(
                    text:
                        'Les perquisitions dérogatoires (Articles 706-89 à 706-94 du Code de procédure pénale) ;',
                  ),
                  _BulletPoint(
                    text:
                        'L’accès à distance aux correspondances stockées par la voie des '
                        'communications électroniques (Articles 706-95 à 706-95-3 du Code de procédure pénale) ;',
                  ),
                  _BulletPoint(
                    text:
                        'Les IMSI-catcher (Article 706-95-20 du Code de procédure pénale) ;',
                  ),
                  _BulletPoint(
                    text:
                        'La sonorisation et la fixation d’images de certains lieux ou véhicules '
                        '(Articles 706-96 à 706-100 du Code de procédure pénale) ;',
                  ),
                  _BulletPoint(
                    text:
                        'La captation de données informatiques (Articles 706-102-1 à 706-102-5 du Code de procédure pénale).',
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // 2.2.3.2 – Conditions de mise en œuvre
              const _SubTitle('2.2.3.2 – Les conditions de mise en œuvre'),
              const SizedBox(height: 8),
              _ConditionCard(
                title: 'Conditions pour recourir aux techniques spéciales',
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: const [
                  _Paragraph(
                    'Ces dispositions ne sont applicables que lorsque la personne concernée '
                    'a fait l’objet, pour l’une des infractions visées par les Articles 706-73 '
                    'ou 706-73-1 du Code de procédure pénale (infractions relevant de la '
                    'criminalité et de la délinquance organisées, infractions économiques '
                    'et financières ou atteintes aux systèmes de traitement automatisé de '
                    'données), de l’une des décisions suivantes :',
                  ),
                  SizedBox(height: 10),
                  _BulletPoint(
                    text:
                        'Mandat d’arrêt visant une personne renvoyée devant une juridiction de jugement ;',
                  ),
                  _BulletPoint(
                    text:
                        'Mandat d’arrêt délivré par une juridiction de jugement ou par le juge '
                        'de l’application des peines ;',
                  ),
                  _BulletPoint(
                    text:
                        'Condamnation à une peine privative de liberté sans sursis supérieure '
                        'ou égale à un an, ou à une peine privative de liberté supérieure ou '
                        'égale à un an résultant de la révocation d’un sursis assorti ou non '
                        'd’une probation, lorsque cette condamnation est exécutoire ou '
                        'passée en force de chose jugée ;',
                  ),
                  _BulletPoint(
                    text:
                        'Décision de retrait ou de révocation d’un aménagement de peine ou '
                        'd’une libération sous contrainte, ou décision de mise à exécution de '
                        'l’emprisonnement prévu par la juridiction de jugement en cas de '
                        'violation des obligations et interdictions résultant d’une peine, '
                        'dès lors que cette décision a pour conséquence la mise à exécution '
                        'd’un quantum ou d’un reliquat de peine d’emprisonnement supérieur '
                        'à un an.',
                  ),
                  SizedBox(height: 14),
                  _NotaBox(
                    bodySpans: [
                      TextSpan(
                        text:
                            'Si la personne en fuite est découverte, il est procédé soit à '
                            'l’exécution du mandat d’arrêt (référence au fascicule sur les '
                            'mandats), soit à l’exécution de la fiche de recherche relative au '
                            'jugement par itératif défaut (guide de procédure – les décisions '
                            'de justice).',
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  _NotaBox(
                    title: 'Rappel',
                    bodySpans: [
                      TextSpan(
                        text:
                            'Les dispositions de l’Article 74-2 du Code de procédure pénale '
                            'sont également applicables en matière de mandat d’arrêt européen '
                            '(Article 695-36 du Code de procédure pénale) et en matière '
                            'd’extradition (Article 696-21 du Code de procédure pénale).',
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
