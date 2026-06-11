import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaDisparitionInquietanteIntroGpxSchool extends StatelessWidget {
  const PaDisparitionInquietanteIntroGpxSchool({super.key});

  // Route de la page
  static const String routeName =
      '/pa/dps_dpg/cadres_juridiques/disparitions_inquietantes/intro';

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
    const accent = Color(0xFF1565C0);

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
          'Les disparitions inquiétantes',
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
            'Introduction du cadre juridique',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 8),
          const _Paragraph.rich([
            TextSpan(text: 'Les dispositions des '),
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
              text: 'Code de procédure pénale',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            TextSpan(
              text:
                  ' organisent un cadre d’enquête spécifique pour la disparition '
                  'd’un mineur, d’un majeur protégé ou d’un majeur présentant '
                  'un caractère inquiétant ou suspect.',
            ),
          ]),
          const SizedBox(height: 16),

          // -----------------------------------------------------------------
          // Rappel du texte de l’article 74-1
          // -----------------------------------------------------------------
          const _SubTitle(
            '1. Rappel de l’article 74-1 du Code de procédure pénale',
          ),
          const SizedBox(height: 4),
          const _Paragraph.rich([
            TextSpan(text: 'L’'),
            TextSpan(
              text: 'article 74-1 du Code de procédure pénale',
              style: TextStyle(fontWeight: FontWeight.w800, color: articleRed),
            ),
            TextSpan(
              text:
                  ' prévoit que, lorsque la disparition d’un mineur ou d’un majeur protégé '
                  'vient d’intervenir ou d’être constatée, les officiers de police judiciaire, '
                  'ou sous leur contrôle les agents de police judiciaire, peuvent, sur '
                  'instructions du procureur de la République, mettre en œuvre les actes '
                  'prévus aux articles 56 à 62 afin de découvrir la personne disparue.',
            ),
          ]),
          const SizedBox(height: 8),
          const _Paragraph(
            'À l’issue d’un délai de huit jours à compter des instructions du procureur '
            'de la République, ces investigations peuvent se poursuivre dans les formes '
            'de l’enquête préliminaire.',
          ),
          const SizedBox(height: 8),
          const _Paragraph(
            'Le procureur de la République peut également requérir l’ouverture d’une '
            'information pour recherche des causes de la disparition.',
          ),
          const SizedBox(height: 8),
          const _Paragraph(
            'Ce dispositif est également applicable en cas de disparition d’un majeur '
            'présentant un caractère inquiétant ou suspect, compte tenu des circonstances, '
            'de l’âge de l’intéressé ou de son état de santé.',
          ),

          const SizedBox(height: 18),

          // -----------------------------------------------------------------
          // Cadre spécifique et transitoire
          // -----------------------------------------------------------------
          _ConditionCard(
            title:
                'Un cadre juridique spécifique et transitoire (article 74-1 du Code de procédure pénale)',
            cardColor: cardColor,
            accent: accent,
            titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
            children: const [
              _Paragraph(
                'L’article 74-1 du Code de procédure pénale constitue un cadre '
                'juridique particulier, distinct de la procédure administrative '
                'de recherche, qui permet de diligenter des investigations plus '
                'poussées sous le contrôle du procureur de la République.',
              ),
              SizedBox(height: 10),
              _SubTitle('Cadre spécifique'),
              _BulletPoint(
                text:
                    'L’enquête diligentée dans ce cadre ne repose pas sur la '
                    'constatation préalable d’une infraction. En l’absence '
                    'd’indices laissant présumer un crime ou un délit, mais '
                    'lorsque les circonstances rendent la disparition inquiétante, '
                    'l’objectif premier est la découverte de la personne disparue.',
              ),
              SizedBox(height: 10),
              _SubTitle('Cadre transitoire'),
              _BulletPoint(
                text:
                    'Ce cadre peut prendre fin à tout moment : soit lorsque la '
                    'personne est découverte et que la disparition résulte d’un '
                    'fait volontaire, soit lorsque apparaissent des éléments '
                    'laissant présumer qu’un crime ou un délit a été commis. '
                    'Dans ce second cas, il convient de basculer immédiatement '
                    'vers un cadre judiciaire de droit commun (flagrance, '
                    'enquête préliminaire ou commission rogatoire).',
              ),
              _BulletPoint(
                text:
                    'Lorsque les investigations n’ont pas abouti dans les huit jours '
                    'suivant les instructions du procureur de la République, elles '
                    'peuvent être poursuivies dans les formes de l’enquête '
                    'préliminaire, sauf si le magistrat requiert l’ouverture '
                    'd’une information spécifique pour recherche des causes de la '
                    'disparition.',
              ),
            ],
          ),

          const SizedBox(height: 16),

          // -----------------------------------------------------------------
          // Nota : lien avec procédure admin et article 80-4
          // -----------------------------------------------------------------
          const _NotaBox(
            bodySpans: [
              TextSpan(
                text:
                    'Le recours à ce cadre permet des investigations plus poussées '
                    'que la procédure administrative de recherche prévue par '
                    'l’article 26 de la loi n° 95-73 du 21 janvier 1995. Il peut '
                    'être relayé, le cas échéant, par l’ouverture d’une information '
                    'pour recherche des causes de la disparition sur le fondement '
                    'de l’article 80-4 du Code de procédure pénale.',
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
