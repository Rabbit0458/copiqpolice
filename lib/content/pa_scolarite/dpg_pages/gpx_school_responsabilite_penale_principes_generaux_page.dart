import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaGPXSchoolResponsabilitePenalePrincipesGenerauxPage
    extends StatelessWidget {
  const PaGPXSchoolResponsabilitePenalePrincipesGenerauxPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/droit_penal_general/responsabilite_penale/principes_generaux';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Principes généraux de la responsabilité pénale',
          style: GoogleFonts.fustat(fontWeight: FontWeight.w800),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
        children: [
          _ConditionCard(
            title: 'Définition de la responsabilité pénale',
            cardColor: isDark
                ? const Color(0xFF1F2A38)
                : const Color(0xFFE3F2FD),
            accent: const Color(0xFF1565C0),
            titleColor: const Color(0xFF0D47A1),
            children: const [
              _Paragraph(
                'La responsabilité pénale consiste dans l’obligation, pour une personne, '
                'de répondre de ses actes délictueux et, en cas de condamnation, '
                'd’exécuter la sanction pénale prévue pour l’infraction commise.',
              ),
              SizedBox(height: 6),
              _Paragraph(
                'Elle ne constitue pas un élément de l’infraction : elle en est la conséquence '
                'juridique. Elle intervient après la constatation de l’infraction.',
              ),
            ],
          ),

          const SizedBox(height: 18),

          _ConditionCard(
            title: 'Principe de responsabilité personnelle',
            cardColor: isDark
                ? const Color(0xFF263238)
                : const Color(0xFFE0F7FA),
            accent: const Color(0xFF00838F),
            titleColor: const Color(0xFF006064),
            children: const [
              _Paragraph(
                'Le droit pénal repose sur le principe fondamental de responsabilité personnelle. '
                'Le Code pénal pose le principe selon lequel nul ne peut être déclaré responsable '
                'pénalement des faits d’autrui.',
              ),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(text: 'Ce principe est affirmé par '),
                TextSpan(
                  text: 'l’article 121-1 du Code pénal',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      ' qui dispose que « nul n’est responsable pénalement que de son propre fait ».',
                ),
              ]),
              SizedBox(height: 6),
              _Paragraph(
                'Ce principe s’applique aussi bien aux personnes physiques qu’aux personnes morales, '
                'ce qui constitue une innovation majeure par rapport à la législation antérieure.',
              ),
            ],
          ),

          const SizedBox(height: 18),

          _ConditionCard(
            title: 'Conditions de la responsabilité pénale',
            cardColor: isDark
                ? const Color(0xFF2E1A1A)
                : const Color(0xFFFFEBEE),
            accent: const Color(0xFFC62828),
            titleColor: const Color(0xFFB71C1C),
            children: const [
              _SubTitle('Culpabilité'),
              _Paragraph(
                'Pour qu’il y ait responsabilité pénale, il faut que l’auteur ait commis une faute. '
                'Cette faute correspond à l’élément moral de l’infraction.',
              ),
              SizedBox(height: 10),
              _SubTitle('Imputabilité'),
              _Paragraph(
                'La faute doit pouvoir être imputée à son auteur. Cela suppose que la personne '
                'ait été en mesure de comprendre et de vouloir l’acte commis.',
              ),
            ],
          ),

          const SizedBox(height: 18),

          _ConditionCard(
            title: 'Qualité de l’auteur',
            cardColor: isDark
                ? const Color(0xFF1B263B)
                : const Color(0xFFE8EAF6),
            accent: const Color(0xFF303F9F),
            titleColor: const Color(0xFF1A237E),
            children: const [
              _Paragraph(
                'Pour être déclarée pénalement responsable, une personne doit avoir participé '
                'à la commission de l’infraction.',
              ),
              SizedBox(height: 6),
              _BulletPoint(text: 'Soit en qualité d’auteur'),
              _BulletPoint(text: 'Soit en qualité de complice'),
            ],
          ),

          const SizedBox(height: 18),

          const _NotaBox(
            title: 'À retenir',
            bodySpans: [
              TextSpan(
                text:
                    'Certaines circonstances prévues par la loi peuvent constituer des causes '
                    'd’irresponsabilité pénale ou d’atténuation de la responsabilité, '
                    'limitant ou supprimant les effets de la sanction pénale.',
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
