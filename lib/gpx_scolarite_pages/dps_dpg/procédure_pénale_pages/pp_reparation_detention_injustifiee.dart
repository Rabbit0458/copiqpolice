import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PPReparationDetentionInjustifieePage extends StatelessWidget {
  const PPReparationDetentionInjustifieePage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/procédure_pénale_pages/pp_reparation_detention_injustifiee';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);
    final Color textSoft = isDark
        ? Colors.white70
        : const Color(0xFF222222).withOpacity(.70);

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
          'Réparation détention injustifiée',
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: textMain,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 26),
        children: [
          // ====================== CHAPITRE & TITRE ==========================
          Text(
            'CHAPITRE 4',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w800,
              fontSize: 18,
              color: isDark ? const Color(0xFF64B5F6) : const Color(0xFF0D47A1),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Réparation d’une détention provisoire injustifiée',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Droit à indemnisation après non-lieu, relaxe ou acquittement, '
            'conditions d’exclusion et recours de l’État.',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w500,
              fontSize: 13.5,
              height: 1.35,
              color: textSoft,
            ),
          ),

          const SizedBox(height: 18),

          // ====================== 4.1 – PRINCIPE ============================
          const _SubTitle(
            '4.1 – Principe de la réparation\n(art. 149 et suivants C. proc. pén.)',
          ),

          const _Paragraph.rich([
            TextSpan(
              text:
                  'Toute personne ayant fait l’objet d’une détention provisoire et qui '
                  'bénéficie ensuite d’un non-lieu, d’une relaxe ou d’un acquittement '
                  'définitif a droit d’obtenir réparation de l’État pour le préjudice '
                  'matériel et moral causé par cette détention, conformément aux ',
            ),
            TextSpan(
              text: 'articles 149 et suivants du Code de procédure pénale',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
            ),
            TextSpan(text: '.'),
          ]),

          const SizedBox(height: 10),

          const _Paragraph(
            'La personne est informée de ce droit lorsque la décision de non-lieu, '
            'de relaxe ou d’acquittement lui est notifiée. L’indemnisation a pour '
            'objet de réparer le choc de la détention, les conséquences sur la vie '
            'personnelle, familiale, professionnelle et l’atteinte à l’image de la '
            'personne mise en cause à tort.',
          ),

          const SizedBox(height: 18),

          // ====================== 4.2 – CONDITIONS & EXCLUSIONS ============
          const _SubTitle('4.2 – Conditions d’indemnisation et cas exclus'),

          _ConditionCard(
            title: 'Droit à réparation – Conditions générales',
            cardColor: isDark
                ? const Color(0xFF263238)
                : const Color(0xFFE3F2FD),
            accent: const Color(0xFF1565C0),
            titleColor: isDark
                ? const Color(0xFFBBDEFB)
                : const Color(0xFF0D47A1),
            children: const [
              _IntroBullet(
                text:
                    'Une détention provisoire a été subie dans le cadre d’une '
                    'procédure pénale (information ou jugement).',
              ),
              _IntroBullet(
                text:
                    'La procédure s’achève par une décision définitive de non-lieu, '
                    'de relaxe ou d’acquittement.',
              ),
              _IntroBullet(
                text:
                    'La décision devient définitive (absence de recours ou épuisement '
                    'des voies de recours).',
              ),
            ],
          ),

          const SizedBox(height: 12),

          const _Paragraph(
            'Certains cas sont exclus de l’indemnisation, notamment lorsque la '
            'personne a contribué, par son comportement, à la survenue ou au '
            'maintien de sa détention (mensonges, dissimulation d’éléments, '
            'fuite, etc.), ou lorsque la décision de non-lieu, relaxe ou acquittement '
            'ne remet pas réellement en cause l’existence de charges mais repose '
            'sur un motif procédural ou une cause d’extinction de l’action publique.',
          ),

          const SizedBox(height: 18),

          // ====================== 4.3 – PROCÉDURE & AUTORITÉ ===============
          const _SubTitle('4.3 – Autorité compétente et procédure'),

          const _Paragraph.rich([
            TextSpan(
              text:
                  'L’indemnisation est allouée par le premier président de la cour '
                  'd’appel compétente. La demande est adressée à cette juridiction, '
                  'dans les formes et délais prévus par ',
            ),
            TextSpan(
              text: 'les articles 149 et suivants du Code de procédure pénale',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
            ),
            TextSpan(text: '.'),
          ]),

          const SizedBox(height: 10),

          const _Paragraph(
            'Le premier président apprécie souverainement l’existence et l’étendue '
            'du préjudice, en tenant compte de la durée de la détention, de ses '
            'conséquences matérielles (perte d’emploi, de revenus, frais divers) et '
            'morales (atteinte à l’honneur, troubles psychologiques, rupture '
            'familiale, etc.). L’indemnisation est versée par l’État.',
          ),

          const SizedBox(height: 16),

          const _NotaBox(
            title: 'Important',
            bodySpans: [
              TextSpan(
                text:
                    'La réparation accordée a un caractère spécifique : elle ne vise '
                    'pas à sanctionner le fonctionnement de la justice, mais à '
                    'compenser les conséquences d’une détention jugée finalement '
                    'injustifiée pour la personne concernée.',
              ),
            ],
          ),

          const SizedBox(height: 22),

          // ====================== 4.4 – RECOURS DE L’ÉTAT ==================
          const _SubTitle('4.4 – Recours de l’État'),

          const _Paragraph.rich([
            TextSpan(
              text:
                  'Lorsque l’indemnisation est accordée, l’État dispose d’un recours '
                  'contre le dénonciateur de mauvaise foi ou le faux témoin ayant '
                  'provoqué la détention ou contribué à son maintien. Ce recours '
                  'est prévu par ',
            ),
            TextSpan(
              text: 'les articles 149 et suivants du Code de procédure pénale',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
            ),
            TextSpan(
              text:
                  ' et permet de faire supporter tout ou partie du coût de la '
                  'réparation à l’auteur de la fausse dénonciation ou du faux '
                  'témoignage.',
            ),
          ]),

          const SizedBox(height: 18),

          const _Paragraph(
            'Ce mécanisme rappelle que la fausse dénonciation et le faux témoignage '
            'sont lourdement sanctionnés, non seulement pénalement, mais aussi sur '
            'le plan financier lorsque leurs conséquences ont conduit à une '
            'détention injustifiée.',
          ),

          const SizedBox(height: 26),
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
