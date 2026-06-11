import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaConntroleIdentiteIntroGpxSchool extends StatelessWidget {
  const PaConntroleIdentiteIntroGpxSchool({super.key});

  static const String routeName =
      '/pa/dps_dpg/cadres_juridiques/controle_identite/intro';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);
    final Color textSoft = isDark
        ? Colors.white70
        : const Color(0xFF222222).withValues(alpha: .72);

    final Color cardColor = isDark
? const Color(0xFF424242)
: const Color(0xFFF5F5F5);
    final Color accent = isDark
? const Color(0xFF64B5F6)
: const Color(0xFF1565C0);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF0D47A1);
    final Color articleColor = isDark
        ? const Color(0xFFFF8A80)
        : const Color(0xFFC62828);

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
          'Introduction',
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: textMain,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
        children: [
          // ===================== TITRE & INTRO ============================
          Text(
            'Introduction au contrôle d’identité',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              color: textMain,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Place des contrôles, relevés et vérifications d’identité dans l’activité de police, équilibre entre '
            'protection des libertés individuelles et nécessités de la recherche des infractions et de la prévention '
            'des atteintes à l’ordre public.',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w500,
              fontSize: 13.5,
              height: 1.35,
              color: textSoft,
            ),
          ),
          const SizedBox(height: 18),

          _ConditionCard(
            title: 'Les opérations de contrôle d’identité',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: [
              // ===================== PARAGRAPHE 1 ========================
              const _Paragraph(
                'Les contrôles, les relevés et les vérifications d’identité font partie des opérations de police '
                'tendant à établir l’identité d’une personne. Ils doivent toujours être mis en œuvre dans le respect '
                'd’un équilibre entre, d’une part, l’exercice des libertés individuelles dont l’autorité judiciaire est '
                'gardienne et, d’autre part, la nécessité de rechercher les infractions et de prévenir les atteintes '
                'à l’ordre public.',
              ),
              const SizedBox(height: 12),

              // ===================== PARAGRAPHE 2 (ARTICLES ROUGES) ======
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Les conditions juridiques de mise en œuvre de ces opérations et leurs modalités d’application '
                      'sont prévues par le ',
                ),
                TextSpan(
                  text: 'code de procédure pénale',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: articleColor,
                  ),
                ),
                const TextSpan(text: ', aux '),
                TextSpan(
                  text: 'articles 78-1 à 78-7',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: articleColor,
                  ),
                ),
                const TextSpan(
                  text:
                      '. Ces dispositions encadrent la façon dont le policier, qu’il agisse dans un cadre de police '
                      'judiciaire ou de police administrative, peut inviter une personne à justifier de son identité, '
                      'relever celle-ci ou procéder à une vérification plus approfondie.',
                ),
              ]),
              const SizedBox(height: 12),

              // ===================== PARAGRAPHE 3 (CESEDA) ================
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Ces différents textes sont complétés par les dispositions contenues dans le ',
                ),
                TextSpan(
                  text:
                      'code de l’entrée et du séjour des étrangers et du droit d’asile',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: articleColor,
                  ),
                ),
                const TextSpan(
                  text:
                      ' (CESEDA), qui fait obligation aux personnes de nationalité étrangère, à la suite d’un contrôle '
                      'd’identité, de présenter les pièces ou documents sous le couvert desquels elles sont autorisées '
                      'à circuler ou séjourner en France.',
                ),
              ]),
              const SizedBox(height: 14),

              const _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        'L’enjeu pour l’officier de police judiciaire et l’agent de police judiciaire est donc de maîtriser '
                        'ces différents cadres juridiques afin de sécuriser la procédure, de respecter les droits des '
                        'personnes contrôlées et de pouvoir justifier, à tout moment, de la finalité et de la légalité '
                        'de l’opération menée.',
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
