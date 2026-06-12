import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaConntroleIdentitePreventionGpxSchool extends StatelessWidget {
  const PaConntroleIdentitePreventionGpxSchool({super.key});

  static const String routeName =
      '/pa/dps_dpg/cadres_juridiques/controle_identite/chapitre1/controles_preventifs';

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
          'Contrôles préventifs',
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
          // ===================== TITRE & INTRO RAPIDE ======================
          Text(
            'Les contrôles préventifs d’identité',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              color: textMain,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Contrôles d’identité sans lien direct avec une infraction, fondés sur la prévention '
            'des atteintes à l’ordre public et encadrés par l’article 78-2 du code de procédure pénale.',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w500,
              fontSize: 13.5,
              height: 1.35,
              color: textSoft,
            ),
          ),
          const SizedBox(height: 18),

          // ===================== 1.2.2 – LES CONTROLES PREVENTIFS ==========
          _ConditionCard(
            title: '1.2.2 – Les contrôles préventifs',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Les contrôles préventifs peuvent être mis en œuvre sans qu’ils aient un lien '
                      'direct avec la commission ou la préparation d’une infraction. Ces contrôles, '
                      'dits « préventifs », sont prévus par le huitième alinéa de l’article ',
                ),
                TextSpan(
                  text: '78-2 du code de procédure pénale',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: articleColor,
                  ),
                ),
                const TextSpan(
                  text:
                      '. Les officiers de police judiciaire et les agents de police judiciaire peuvent '
                      'ainsi contrôler l’identité de toute personne, quel que soit son '
                      'comportement, pour prévenir une atteinte à l’ordre public, notamment à la '
                      'sécurité des personnes ou des biens.',
                ),
              ]),
              const SizedBox(height: 10),
              const _SubTitle('Le contrôle vise « toute personne »'),
              const _Paragraph(
                'Contrairement au contrôle de police judiciaire, le contrôle préventif n’est pas '
                'individualisé. Il ne cible pas une personne déterminée en lien avec une infraction, '
                'mais toute personne présente dans le périmètre où l’opération est mise en œuvre. '
                'Le contrôle est donc généralisé à l’ensemble des personnes se trouvant sur les lieux.',
              ),
              const SizedBox(height: 8),
              const _SubTitle(
                'Le contrôle n’est pas lié au « comportement » de la personne',
              ),
              const _Paragraph(
                'La loi précise expressément que le comportement de la personne contrôlée ne '
                'constitue pas une condition de régularité du contrôle préventif. Autrement dit, le '
                'simple fait de se trouver dans la zone et au moment du dispositif suffit pour être '
                'invité à justifier de son identité, dès lors que les autres conditions légales sont réunies.',
              ),
            ],
          ),
          const SizedBox(height: 18),

          // ===================== 1.2.2.1 – CONDITIONS DE MISE EN OEUVRE ===
          _ConditionCard(
            title: '1.2.2.1 – Les conditions de mise en œuvre',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: const [
              _Paragraph(
                'Le contrôle préventif est destiné à prévenir une atteinte à l’ordre public, en '
                'particulier à la sécurité des personnes ou des biens. Il ne peut donc jamais être '
                'organisé en l’absence de toute condition de fond : il doit reposer sur des éléments '
                'objectifs permettant de présumer une menace réelle pour l’ordre public.',
              ),
              SizedBox(height: 10),
              _SubTitle('1.2.2.1.1 – Les conditions de lieux'),
              _Paragraph(
                'Les contrôles préventifs ne peuvent être pratiqués que dans des lieux publics ou '
                'ouverts au public (gares, débits de boissons, salles de spectacles, galeries '
                'marchandes, etc.). La circulaire du ministère de l’Intérieur du 21 octobre 1993 '
                'rappelle qu’un contrôle d’identité dans un lieu privé conférerait à cette opération '
                'la nature juridique d’une perquisition. En conséquence, tout contrôle d’identité au '
                'domicile d’une personne, même lorsque celle-ci fait appel aux fonctionnaires de '
                'police, ne peut être effectué que dans le cadre des missions de police judiciaire.',
              ),
              SizedBox(height: 6),
              _Paragraph(
                'En revanche, les contrôles préventifs peuvent être organisés dans des lieux où des '
                'actes de délinquance sont habituellement commis (vols à l’arraché, trafics divers, '
                'délits liés à la prostitution, etc.), ou à proximité de points sensibles (installations '
                'classées, sites stratégiques) ainsi que dans les lieux favorisant la commission de '
                'vols ou d’agressions (couloirs de métro, rues désertes la nuit…).',
              ),
              SizedBox(height: 10),
              _SubTitle('1.2.2.1.2 – Les conditions de temps'),
              _Paragraph(
                'L’exercice de contrôles préventifs peut également être justifié par la présence de '
                'circonstances particulières laissant apparaître des risques spécifiques pour la '
                'sécurité des personnes ou des biens : alertes à la bombe, grands rassemblements '
                'de personnes (manifestations, événements sportifs ou musicaux importants, etc.).',
              ),
              SizedBox(height: 6),
              _Paragraph(
                'Dans tous les cas, les policiers doivent pouvoir justifier des circonstances ayant '
                'fait apparaître le risque d’atteinte à l’ordre public qui a motivé l’opération. Il ne '
                'suffit pas d’affirmer de manière générale qu’un lieu serait simplement « propice » '
                'à la commission d’infractions.',
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text:
                      'Le Conseil constitutionnel, dans sa décision n° 93-323 du 5 août 1993, a rappelé '
                      'ces exigences en se référant à la sauvegarde de principes et de droits ayant '
                      'valeur constitutionnelle. Il souligne que la pratique de contrôles généralisés '
                      'et discrétionnaires est incompatible avec le respect de la liberté individuelle et '
                      'que l’autorité judiciaire doit surveiller les conditions relatives à la légalité, à la '
                      'réalité et à la pertinence des raisons ayant motivé ces opérations.',
                ),
              ]),
              SizedBox(height: 12),
              _SubTitle('Jurisprudence et exigences pratiques'),
              _BulletPoint(
                text:
                    'La motivation du contrôle : les agents doivent caractériser de façon suffisante '
                    'en quoi la sécurité des personnes et des biens est menacée, en décrivant les '
                    'éléments objectifs justifiant le recours au dispositif préventif.',
              ),
              _BulletPoint(
                text:
                    'L’appréciation de la menace à l’ordre public : le pouvoir d’appréciation est '
                    'laissé à l’agent qui procède au contrôle, mais il doit être exercé dans le cadre '
                    'strict défini par la loi et sous le contrôle de l’autorité judiciaire.',
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
