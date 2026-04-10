import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PersonnesFuiteConditionGpxSchool extends StatelessWidget {
  const PersonnesFuiteConditionGpxSchool({super.key});

  static const String routeName =
      '/gpx/cadres_juridiques/recherche_personnes_fuite/chapitre1';

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
          'Art. 74-2 – Conditions d’application',
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
                'Chapitre 1 : Les conditions d’application\n'
                'de l’Article 74-2 du Code de procédure pénale',
              ),
              const SizedBox(height: 8),
              const _Paragraph.rich([
                TextSpan(
                  text:
                      'La procédure de l’Article 74-2 du Code de procédure pénale est '
                      'applicable à l’encontre d’une personne en fuite qui remplit '
                      'certaines conditions strictement définies par la loi.',
                  style: TextStyle(color: Colors.red),
                ),
              ]),
              const SizedBox(height: 16),

              _ConditionCard(
                title: '1 – La personne fait l’objet d’un mandat d’arrêt',
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: const [
                  _Paragraph(
                    'La procédure s’applique tout d’abord lorsque la personne en fuite '
                    'fait l’objet d’un mandat d’arrêt.',
                  ),
                  SizedBox(height: 8),
                  _BulletPoint(
                    text:
                        'Lors de son renvoi devant une juridiction de jugement : à ce '
                        'stade, le mandat d’arrêt est délivré par le juge d’instruction, '
                        'le juge des libertés et de la détention, la chambre de '
                        'l’instruction ou son président, ou le président de la cour '
                        'd’assises ;',
                  ),
                  _BulletPoint(
                    text:
                        'Lorsque le mandat d’arrêt est délivré par une juridiction de '
                        'jugement ou par le juge de l’application des peines.',
                  ),
                ],
              ),

              const SizedBox(height: 22),
              _ConditionCard(
                title:
                    '2 – La personne est condamnée à une peine privative de liberté',
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: const [
                  _Paragraph(
                    'La procédure de l’Article 74-2 du Code de procédure pénale est '
                    'également applicable lorsque la personne :',
                  ),
                  SizedBox(height: 8),
                  _BulletPoint(
                    text:
                        'est condamnée à une peine privative de liberté, sans sursis ou '
                        'résultant de la révocation d’un sursis assorti ou non d’une '
                        'probation, supérieure ou égale à un an, lorsque cette '
                        'condamnation est exécutoire ou passée en force de chose jugée.',
                  ),
                ],
              ),

              const SizedBox(height: 22),
              _ConditionCard(
                title:
                    '3 – La personne est inscrite dans certains fichiers judiciaires',
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: const [
                  _Paragraph(
                    'L’Article 74-2 du Code de procédure pénale vise aussi les situations '
                    'dans lesquelles la personne en fuite est soumise à des obligations '
                    'liées à une inscription dans un fichier judiciaire national automatisé.',
                  ),
                  SizedBox(height: 8),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'Elle est inscrite au fichier judiciaire national automatisé des '
                          'auteurs d’infractions terroristes ayant manqué aux obligations '
                          'prévues à l’Article 706-25-7 du Code de procédure pénale ;',
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                  SizedBox(height: 6),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'Elle est inscrite au fichier judiciaire national automatisé des '
                          'auteurs d’infractions sexuelles ou violentes ayant manqué aux '
                          'obligations prévues à l’Article 706-53-5 du Code de procédure '
                          'pénale.',
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                ],
              ),

              const SizedBox(height: 22),
              _ConditionCard(
                title:
                    '4 – Décision de retrait ou de révocation d’un aménagement de peine',
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: const [
                  _Paragraph(
                    'Enfin, la procédure de recherche des personnes en fuite s’applique '
                    'lorsque la personne :',
                  ),
                  SizedBox(height: 8),
                  _BulletPoint(
                    text:
                        'fait l’objet d’une décision de retrait ou de révocation d’un '
                        'aménagement de peine ou d’une libération sous contrainte ;',
                  ),
                  _BulletPoint(
                    text:
                        'ou d’une décision de mise à exécution de l’emprisonnement prévu '
                        'par la juridiction de jugement en cas de violation des obligations '
                        'et interdictions résultant d’une peine ;',
                  ),
                  _Paragraph(
                    'et que cette décision a pour conséquence la mise à exécution d’un '
                    'quantum ou d’un reliquat de peine d’emprisonnement supérieur à un an.',
                  ),
                ],
              ),

              const SizedBox(height: 24),
              const _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        'En résumé, l’Article 74-2 du Code de procédure pénale ne vise pas '
                        'toute personne recherchée mais uniquement celles qui sont '
                        'concernées par un mandat d’arrêt, une peine d’emprisonnement '
                        'significative, une inscription dans certains fichiers judiciaires, '
                        'ou une décision de retrait ou de révocation d’un aménagement de '
                        'peine. Version au 01/07/2025 – SDCP – Tous droits réservés.',
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
