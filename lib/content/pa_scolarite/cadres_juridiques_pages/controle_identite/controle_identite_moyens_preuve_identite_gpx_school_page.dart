import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaConntroleIdentiteDocumentGpxSchool extends StatelessWidget {
  const PaConntroleIdentiteDocumentGpxSchool({super.key});

  static const String routeName =
      '/pa/dps_dpg/cadres_juridiques/controle_identite/chapitre1/moyens_preuve_identite';

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
          'Moyens de preuve de l’identité',
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
            'Les moyens de preuve de l’identité',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              color: textMain,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Documents officiels, autres justificatifs et témoignages : comment une personne peut prouver '
            'son identité lors d’un contrôle, dans le respect des règles posées par le code de procédure pénale.',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w500,
              fontSize: 13.5,
              height: 1.35,
              color: textSoft,
            ),
          ),
          const SizedBox(height: 18),

          _ConditionCard(
            title: '1.4 – Les moyens de preuve de l’identité',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: [
              // ===================== INTRO GENERAL =======================
              _Paragraph.rich([
                const TextSpan(
                  text: 'S’agissant de la preuve de l’identité, le texte de l’',
                ),
                TextSpan(
                  text: 'article 78-2 du code de procédure pénale',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: articleColor,
                  ),
                ),
                const TextSpan(
                  text:
                      ' est volontairement peu explicite. Il se borne à indiquer que « toute personne est tenue '
                      'de se soumettre à un contrôle d’identité et peut justifier de son identité par tout moyen ». '
                      'Cette formule laisse une large place à l’interprétation et à l’appréciation de l’agent contrôleur.',
                ),
              ]),
              const SizedBox(height: 14),

              // ===================== 1.4.1 – DOCUMENTS PROBANTS ==========
              const _SubTitle('1.4.1 – Les documents officiels probants'),
              const _Paragraph(
                'Certains documents constituent, par nature, des moyens de preuve particulièrement fiables de '
                'l’identité de la personne qui les détient et les présente. Il s’agit notamment :',
              ),
              const SizedBox(height: 6),
              const _BulletPoint(text: 'De la carte nationale d’identité ;'),
              const _BulletPoint(text: 'Du passeport ;'),
              const _BulletPoint(text: 'Du permis de conduire ;'),
              const SizedBox(height: 6),
              const _Paragraph(
                'Ces documents sont des titres officiels comportant une photographie et dont la délivrance a '
                'nécessité une procédure préalable d’identification claire du titulaire. Ils sont donc, en principe, '
                'regardés comme probants, à la condition bien entendu que leur authenticité ne soit pas contestée.',
              ),
              const SizedBox(height: 14),

              // ===================== 1.4.2 – AUTRES DOCUMENTS ============
              const _SubTitle('1.4.2 – Les autres documents'),
              const _Paragraph(
                'D’autres documents ne constituent qu’un simple commencement de preuve. Dépourvus de photographie '
                'et/ou de valeur officiellement reconnue, ils ne permettent pas, à eux seuls, d’affirmer que '
                'l’identité mentionnée correspond bien à celle de la personne qui les présente.',
              ),
              const SizedBox(height: 6),
              const _Paragraph(
                'Tel est le cas, par exemple, des livrets de famille, fiches d’état civil, certificats ou cartes diverses '
                '(cartes grises, cartes d’électeur, etc.). Ces documents doivent néanmoins être pris en considération, '
                'en fonction des circonstances et de l’appréciation des fonctionnaires procédant au contrôle.',
              ),
              const SizedBox(height: 6),
              const _Paragraph(
                'Ils peuvent permettre d’éviter d’emmener la personne au service ou au poste pour mettre en œuvre '
                'une procédure formelle de vérification d’identité, lorsque les éléments réunis apparaissent suffisants.',
              ),
              const SizedBox(height: 14),

              // ===================== 1.4.3 – TEMOIGNAGES =================
              const _SubTitle('1.4.3 – Le recours à des témoignages'),
              const _Paragraph(
                'En cas de présentation d’un document non probant, la confirmation de l’identité peut également être '
                'obtenue au moyen de témoignages recueillis par les policiers au moment du contrôle.',
              ),
              const SizedBox(height: 6),
              const _Paragraph(
                'Pour être utile, ce mode de preuve suppose que les témoignages soient concomitants à l’opération de '
                'contrôle : ils doivent être recueillis simultanément et dans l’immédiate action de contrôle, auprès de '
                'personnes présentes sur les lieux et en mesure de confirmer l’identité du contrôlé.',
              ),
              const SizedBox(height: 6),
              const _Paragraph(
                'Ce recours au témoignage est également envisageable à l’égard d’une personne totalement dépourvue '
                'de pièce d’identité. Il demeure toutefois aléatoire et relève de l’appréciation des policiers, qui '
                'doivent toujours veiller à la cohérence globale des éléments recueillis.',
              ),
              const SizedBox(height: 14),

              const _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        'En pratique, l’officier de police judiciaire et l’agent de police judiciaire conservent une '
                        'marge d’appréciation importante. Ils doivent cependant pouvoir expliquer, dans la procédure, '
                        'pourquoi les pièces présentées ou les témoignages recueillis ont été jugés suffisants ou non '
                        'pour établir l’identité de la personne contrôlée.',
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
