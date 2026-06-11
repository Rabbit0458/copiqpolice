import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaMandatRecherchePage extends StatelessWidget {
  const PaMandatRecherchePage({super.key});

  static const String routeName =
      '/pa/dps_dpg/cadres_juridiques/commission_rogatoire/mandat_recherche';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF262626) : Colors.white;
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);
    final Color cardBlue = isDark
        ? const Color(0xFF0D1B2A)
        : const Color(0xFFE3F2FD);
    const cardBlueAccent = Color(0xFF1565C0);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: textMain),
        ),
        title: Text(
          'Mandat de recherche',
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 17.5,
            color: textMain,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 30),
        physics: const BouncingScrollPhysics(),
        children: [
          Text(
            '3.6 — Le mandat de recherche',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              color: textMain,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 10),

          // ================================================================
          // 3.6 — LE MANDAT DE RECHERCHE
          // ================================================================
          _ConditionCard(
            title: '3.6 — Le mandat de recherche',
            cardColor: cardBlue,
            accent: cardBlueAccent,
            titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
            children: const [
              _Paragraph.rich([
                TextSpan(
                  text:
                      'Le mandat de recherche est "l’ordre donné à la force publique de rechercher la personne à l’encontre de laquelle il est décerné et de la placer en garde à vue" ',
                ),
                TextSpan(
                  text: '(article 122 alinéa 2 du Code de procédure pénale).',
                  style: TextStyle(color: Colors.red),
                ),
              ]),
              SizedBox(height: 10),

              _Paragraph(
                'Il ne peut être décerné qu’à l’égard d’une personne pour laquelle il '
                'existe une ou plusieurs raisons plausibles de soupçonner qu’elle a '
                'commis ou tenté de commettre une infraction.',
              ),
              SizedBox(height: 8),

              // PUCE LISTE
              _BulletPoint(
                text:
                    'D’une personne ayant fait l’objet d’un réquisitoire nominatif ;',
              ),
              _BulletPoint(text: 'D’un témoin assisté ;'),
              _BulletPoint(text: 'D’une personne mise en examen ;'),

              SizedBox(height: 18),

              _SubTitle('3.6.2 — L’exécution du mandat de recherche'),

              // 3.6.2.1 NOTIFICATION
              _SubTitle(
                '3.6.2.1 — La notification du mandat de recherche '
                '(article 123 alinéa 4 du Code de procédure pénale)',
              ),
              _Paragraph.rich([
                TextSpan(
                  text:
                      'Le mandat de recherche est notifié et exécuté par un officier ou agent de police judiciaire, ou un agent de la force publique, qui l’exhibe à la personne et lui en délivre copie. ',
                ),
                TextSpan(
                  text: '(article 123 alinéa 4 du Code de procédure pénale).',
                  style: TextStyle(color: Colors.red),
                ),
              ]),
              SizedBox(height: 14),

              // 3.6.2.2 INVESTIGATIONS
              _SubTitle(
                '3.6.2.2 — Les investigations '
                '(article 134 du Code de procédure pénale)',
              ),

              _BulletPoint(
                text:
                    'L’introduction dans un domicile doit respecter les heures légales ;',
              ),
              _BulletPoint(
                text:
                    'La présence d’une force suffisante doit être garantie pour éviter toute fuite ;',
              ),
              _BulletPoint(
                text:
                    'Si la personne ne peut être saisie, un procès-verbal de perquisition et recherches infructueuses est transmis au magistrat mandant. La personne est alors considérée comme mise en examen pour l’application de l’article 176.',
              ),
              SizedBox(height: 18),

              // --------------------------------------------------------------
              // 3.6.3 — DÉCOUVERTE DE LA PERSONNE
              // --------------------------------------------------------------
              _SubTitle(
                '3.6.3 — La découverte de la personne '
                '(article 135-1 du Code de procédure pénale)',
              ),

              _Paragraph.rich([
                TextSpan(
                  text:
                      'La personne découverte en vertu d’un mandat de recherche est placée en garde à vue selon les modalités prévues ',
                ),
                TextSpan(
                  text: 'à l’article 154 du Code de procédure pénale.',
                  style: TextStyle(color: Colors.red),
                ),
              ]),
              SizedBox(height: 10),

              _Paragraph(
                'Le juge d’instruction mandant est immédiatement avisé du début de la garde à vue.',
              ),
              SizedBox(height: 10),

              _Paragraph(
                'L’OPJ du lieu de découverte peut être requis par le juge d’instruction '
                'pour procéder à l’audition de l’intéressé ainsi qu’à tous les actes '
                'nécessaires à l’information judiciaire.',
              ),
              SizedBox(height: 10),

              _Paragraph(
                'L’OPJ déjà saisi par commission rogatoire peut également réaliser '
                'l’audition. La personne peut être transférée dans les locaux du service '
                'd’enquête saisi des faits.',
              ),

              SizedBox(height: 22),

              _NotaBox(
                title: 'NOTE IMPORTANTE',
                bodySpans: [
                  TextSpan(
                    text:
                        'Le mandat de recherche autorise la garde à vue immédiate. '
                        'Toute irrégularité dans la notification ou l’exécution peut '
                        'entraîner la nullité des actes subséquents.',
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 30),
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

/// ------------------------------------------------------------------
/// SOUS-TITRE
/// ------------------------------------------------------------------
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

/// ------------------------------------------------------------------
/// PARAGRAPHES
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

/// ------------------------------------------------------------------
/// PUCE CLASSIQUE
/// ------------------------------------------------------------------
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

/// ------------------------------------------------------------------
/// NOTA BOX
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
