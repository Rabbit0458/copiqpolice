import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HierarchieApjaPage extends StatelessWidget {
  const HierarchieApjaPage({super.key});

  static const String routeName = '/gpx/generalites/hierarchie/apja';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color bgColor = isDark ? const Color(0xFF121212) : Colors.white;
    final Color cardColor = isDark
        ? const Color(0xFF1E1E1E)
        : const Color(0xFFF7F7F7);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF050505);
    final Color textColor = isDark
        ? Colors.white70
        : const Color(0xFF1F1F1F).withOpacity(.90);
    // Accent différent pour bien distinguer visuellement le module APJA
    final Color accent = isDark
        ? const Color(0xFFBA68C8)
        : const Color(0xFF8E24AA);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: titleColor),
          tooltip: 'Retour',
        ),
        title: Text(
          'Agents de police judiciaire adjoints',
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: titleColor,
          ),
        ),
      ),

      // ===================== CONTENU ============================
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
        physics: const BouncingScrollPhysics(),
        children: [
          // ---------------------- TITRE --------------------------
          Text(
            'Les agents de police judiciaire adjoints (APJA)',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 8),

          // -------------------- INTRO ----------------------------
          _Paragraph.rich([
            const TextSpan(
              text:
                  'Les agents de police judiciaire adjoints sont définis par l’article 21 du code de procédure pénale. ',
            ),
            const TextSpan(
              text:
                  'Ils disposent de pouvoirs en matière de police judiciaire moins étendus que ceux des agents de police judiciaire, '
                  'mais contribuent directement au fonctionnement de la police judiciaire sur le terrain.',
            ),
          ]),
          const SizedBox(height: 10),

          _Paragraph(
            'Ils interviennent aux côtés des officiers de police judiciaire et des agents de police judiciaire, notamment dans les missions de constatation des infractions, de recueil d’éléments utiles à l’enquête et d’appui opérationnel.',
          ),
          const SizedBox(height: 14),

          const _IntroBullet(
            text:
                'Les agents de police judiciaire adjoints exercent leurs attributions dans un cadre strictement défini par la loi.',
          ),
          const _IntroBullet(
            text:
                'Ils constituent un maillon important de la chaîne judiciaire : policiers adjoints, agents de police municipale, gardes champêtres, réservistes, etc.',
          ),

          const SizedBox(height: 20),

          // =======================================================
          // A. QUALITÉ D’AGENT DE POLICE JUDICIAIRE ADJOINT
          // =======================================================
          _ConditionCard(
            title: 'A. La qualité d’agent de police judiciaire adjoint',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: const [
              _Paragraph(
                'Les agents de police judiciaire adjoints visés à l’article 21 du code de procédure pénale disposent de pouvoirs en matière de police judiciaire moins étendus que ceux des agents de police judiciaire. '
                'Ils sont néanmoins expressément investis par la loi de prérogatives judiciaires, qu’ils exercent sous la responsabilité et le contrôle de l’autorité judiciaire.',
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text:
                      'Ils sont placés, selon les cas, au sein des services actifs de la police nationale, de la gendarmerie nationale, des polices municipales ou encore parmi les gardes champêtres. ',
                ),
                TextSpan(
                  text:
                      'Leur statut et leurs missions varient, mais tous relèvent du régime commun des agents de police judiciaire adjoints de l’article 21 du code de procédure pénale.',
                ),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                title: 'Pouvoirs moins étendus',
                bodySpans: [
                  TextSpan(
                    text:
                        'Les agents de police judiciaire adjoints n’ont pas la même amplitude de pouvoirs que les agents de police judiciaire ou les officiers de police judiciaire. '
                        'Leurs attributions sont limitées et s’exercent en appui des autres acteurs de la chaîne judiciaire.',
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // =======================================================
          // B. CATÉGORIES D’APJA — ARTICLE 21 DU CODE DE PROCÉDURE PÉNALE
          // =======================================================
          _ConditionCard(
            title:
                'B. Les catégories d’agents de police judiciaire adjoints de l’article 21 du code de procédure pénale',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: const [
              _Paragraph(
                'L’article 21 du code de procédure pénale énumère les différentes catégories de personnels qui disposent de la qualité d’agent de police judiciaire adjoint, avec des pouvoirs de police judiciaire moins étendus.',
              ),
              SizedBox(height: 10),

              _SubTitle(
                'Personnels des services actifs de la police nationale',
              ),
              _BulletPoint(
                text:
                    'Les fonctionnaires des services actifs de la police nationale qui ne remplissent pas les conditions prévues à l’article 20 du code de procédure pénale.',
              ),
              SizedBox(height: 8),

              _SubTitle('Militaires de la gendarmerie nationale'),
              _BulletPoint(
                text:
                    'Les volontaires servant en qualité de militaire dans la gendarmerie nationale et les militaires servant au titre de la réserve opérationnelle de la gendarmerie nationale qui ne remplissent pas les conditions prévues par l’article 20-1 du code de procédure pénale.',
              ),
              SizedBox(height: 8),

              _SubTitle(
                'Policiers adjoints et réservistes de la police nationale',
              ),
              _BulletPoint(
                text:
                    'Les policiers adjoints et les membres de la réserve opérationnelle de la police nationale qui ne remplissent pas les conditions prévues par les articles 16-1 A ou 20-1 du code de procédure pénale.',
              ),
              SizedBox(height: 8),

              _SubTitle('Personnels de la préfecture de police'),
              _BulletPoint(
                text:
                    'Les contrôleurs de la préfecture de police exerçant la spécialité « voie publique » ainsi que les agents de surveillance de Paris.',
              ),
              SizedBox(height: 8),

              _SubTitle('Polices municipales et gardes champêtres'),
              _BulletPoint(
                text:
                    'Les agents de police municipale, pour les missions de police judiciaire qui leur sont confiées par la loi.',
              ),
              _BulletPoint(
                text:
                    'Les gardes champêtres, lorsqu’ils agissent pour l’exercice des attributions fixées à l’avant-dernier alinéa de l’article L. 521-1 du code de la sécurité intérieure.',
              ),

              SizedBox(height: 12),
              _NotaBox(
                title: 'À retenir',
                bodySpans: [
                  TextSpan(
                    text:
                        'Ces différents personnels partagent la même qualité d’agent de police judiciaire adjoint, mais interviennent dans des cadres institutionnels variés (police nationale, gendarmerie nationale, collectivités territoriales, préfecture de police). ',
                  ),
                  TextSpan(
                    text:
                        'Cette diversité reflète l’ancrage local et la complémentarité des missions de police judiciaire sur le territoire.',
                    style: TextStyle(fontWeight: FontWeight.w600),
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

/// ------------------------------------------------------------------
/// TITRE DE SOUS-PARTIE (1., 2., 3. …)
/// ------------------------------------------------------------------
class _SubTitle extends StatelessWidget {
  const _SubTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color color = isDark ? Colors.white : const Color(0xFF0D47A1);

    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 4),
      child: Text(
        text,
        style: GoogleFonts.fustat(
          fontWeight: FontWeight.w700,
          fontSize: 14.5,
          color: color,
        ),
      ),
    );
  }
}

/// ------------------------------------------------------------------
/// PARAGRAPHES SIMPLES OU RICHES
/// ------------------------------------------------------------------
class _Paragraph extends StatelessWidget {
  const _Paragraph(this.text) : spans = null;

  const _Paragraph.rich(this.spans) : text = null;

  final String? text;
  final List<TextSpan>? spans;

  @override
  Widget build(BuildContext context) {
    final isRich = spans != null;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final Color color = isDark
        ? Colors.white70
        : const Color(0xFF1F1F1F).withOpacity(.92);

    if (!isRich) {
      return Text(
        text ?? '',
        textAlign: TextAlign.justify,
        style: GoogleFonts.fustat(
          fontSize: 14,
          height: 1.4,
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
          height: 1.4,
          fontWeight: FontWeight.w500,
          color: color,
        ),
        children: spans,
      ),
    );
  }
}

/// ------------------------------------------------------------------
/// PUCE D’INTRO (les 3 conditions au début)
/// ------------------------------------------------------------------
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

/// ------------------------------------------------------------------
/// PUCE (dans les sections B et C)
/// ------------------------------------------------------------------
class _BulletPoint extends StatelessWidget {
  const _BulletPoint({required this.text});

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
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Icon(Icons.check_rounded, size: 18, color: bulletColor),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.fustat(
                fontSize: 14,
                height: 1.35,
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

/// ------------------------------------------------------------------
/// BLOC EXEMPLE
/// ------------------------------------------------------------------
class _ExempleBox extends StatelessWidget {
  const _ExempleBox({required this.title, required this.bodySpans});

  final String title;
  final List<TextSpan> bodySpans;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color borderColor = isDark
        ? const Color(0xFF42A5F5)
        : const Color(0xFF1E88E5);
    final Color bgColor = isDark
        ? const Color(0xFF0D1B26)
        : const Color(0xFFE3F2FD);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF0D47A1);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor.withOpacity(isDark ? .65 : .9),
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: borderColor, width: 3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title :',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w800,
              fontSize: 13.5,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 4),
          RichText(
            textAlign: TextAlign.justify,
            text: TextSpan(
              style: GoogleFonts.fustat(
                fontSize: 13.5,
                height: 1.4,
                fontWeight: FontWeight.w500,
                color: isDark
                    ? Colors.white70
                    : const Color(0xFF102027).withOpacity(.95),
              ),
              children: bodySpans,
            ),
          ),
        ],
      ),
    );
  }
}

/// ------------------------------------------------------------------
/// BLOC NOTA / INFO / SANCTION
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
        color: bgColor.withOpacity(isDark ? .70 : .95),
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: borderColor, width: 3)),
      ),
      child: RichText(
        textAlign: TextAlign.justify,
        text: TextSpan(
          style: GoogleFonts.fustat(
            fontSize: 13.5,
            height: 1.4,
            fontWeight: FontWeight.w500,
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
