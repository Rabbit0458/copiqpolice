import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaDisparitionInquietanteEnqueteGpxSchool extends StatelessWidget {
  const PaDisparitionInquietanteEnqueteGpxSchool({super.key});

  static const String routeName =
      '/pa/dps_dpg/cadres_juridiques/disparitions_inquietantes/chapitre3';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    final Color bgColor = isDark
        ? const Color(0xFF303030)
        : const Color(0xFFF3F4F6);
    final Color textMain = isDark ? Colors.white : const Color(0xFF111827);
    final Color textSoft = isDark
        ? Colors.white70
        : const Color(0xFF374151).withValues(alpha: .88);

    final Color cardColor = isDark
? const Color(0xFF424242)
: const Color(0xFFFFFFFF);
    final Color accent = isDark
? const Color(0xFF90CAF9)
: const Color(0xFF1565C0);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF0D47A1);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: textMain),
        title: Text(
          'Disparitions inquiétantes',
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: textMain,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
        children: [
          Text(
            'Chapitre 3 – Suites de l’enquête diligentée en vertu des articles '
            '74-1 et 80-4 du code de procédure pénale',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 19,
              height: 1.25,
              color: textMain,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Conséquences de l’enquête selon que la personne disparue est retrouvée, '
            'demeure introuvable ou que l’enquête révèle une infraction pénale.',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w500,
              fontSize: 13.5,
              height: 1.4,
              color: textSoft,
            ),
          ),
          const SizedBox(height: 18),

          _ConditionCard(
            title:
                '2.3 – Les suites de l’enquête diligentée en vertu des articles 74-1 et 80-4 du code de procédure pénale',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: const [
              // 2.3.1
              _SubTitle('2.3.1 – La personne disparue est retrouvée'),
              _Paragraph(
                'Lorsque la personne disparue est retrouvée et que les causes de la disparition '
                'ne sont ni criminelles, ni délictuelles, la protection de sa vie privée et de sa '
                'sécurité demeure prioritaire.',
              ),
              SizedBox(height: 6),
              _Paragraph(
                'S’il s’agit d’un mineur ou d’un majeur protégé, l’adresse de la personne retrouvée '
                'ainsi que les pièces permettant d’avoir directement ou indirectement '
                'connaissance de cette adresse ne peuvent être communiquées au représentant '
                'légal ou à la partie civile qu’avec l’accord du juge des enfants ou du juge des '
                'tutelles lorsque l’enquête a été menée sur le fondement de l’article 74-1, ou '
                'avec l’accord du juge d’instruction lorsque l’information a été ouverte en '
                'application de l’article 80-4 du code de procédure pénale.',
              ),
              SizedBox(height: 6),
              _Paragraph(
                'Lorsque la personne disparue est un majeur qui n’est pas protégé, son adresse '
                'ne peut être communiquée qu’avec son accord exprès.',
              ),
              SizedBox(height: 6),
              _Paragraph(
                'En conséquence, le droit à la communication du dossier prévu par l’article 114 '
                'du code de procédure pénale ne peut s’exercer qu’en respectant ces limitations, '
                'édictées pour protéger la vie privée du majeur ou la sécurité du mineur ou du '
                'majeur protégé.',
              ),

              SizedBox(height: 18),

              // 2.3.2
              _SubTitle(
                '2.3.2 – La personne disparue n’est pas retrouvée',
              ),
              _Paragraph(
                'Lorsque la personne disparue demeure introuvable, il est alors nécessaire '
                'd’adapter la suite procédurale. Plusieurs options s’offrent aux autorités '
                'judiciaires :',
              ),
              SizedBox(height: 6),
              _BulletPoint(
                text:
                    'Requérir l’ouverture d’une information pour recherche des causes de la '
                    'disparition en vertu de l’article 80-4 du code de procédure pénale.',
              ),
              _BulletPoint(
                text:
                    'Poursuivre l’information judiciaire déjà ouverte pour recherche des causes '
                    'de la disparition.',
              ),
              _BulletPoint(
                text:
                    'Ordonner à l’officier de police judiciaire ou à l’agent de police judiciaire '
                    'qui a enquêté sur le fondement de l’article 74-1 du code de procédure '
                    'pénale de poursuivre ses investigations selon le mode de l’enquête '
                    'préliminaire.',
              ),

              SizedBox(height: 18),

              // 2.3.3
              _SubTitle(
                '2.3.3 – L’enquête diligentée a permis d’établir le caractère '
                'criminel ou délictuel à l’origine de la disparition',
              ),
              _Paragraph(
                'Si les investigations menées dans le cadre des articles 74-1 et 80-4 du code de '
                'procédure pénale permettent d’établir que la disparition a une origine '
                'criminelle ou délictuelle, le procureur de la République dispose de plusieurs '
                'choix procéduraux.',
              ),
              SizedBox(height: 6),
              _Paragraph('Le procureur de la République peut alors :'),
              SizedBox(height: 4),
              _BulletPoint(
                text:
                    'Autoriser les enquêteurs à poursuivre leurs investigations selon le mode '
                    'de l’enquête de flagrant délit ou celui de l’enquête préliminaire, en '
                    'fonction des circonstances et des nécessités de l’enquête.',
              ),
              _BulletPoint(
                text:
                    'Délivrer un réquisitoire introductif ouvrant une information judiciaire '
                    'relative à l’infraction ainsi découverte.',
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
