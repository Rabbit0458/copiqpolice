// lib/pa/dps_dpg/cadres_juridiques/commission_rogatoire_contenu_page.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaPersonneBlesseGrievementContenuPage extends StatelessWidget {
  const PaPersonneBlesseGrievementContenuPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/cadres_juridiques/personne_blesse_contenu';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);
    final Color textSoft = isDark
        ? Colors.white70
        : const Color(0xFF222222).withValues(alpha: .72);

    final Color cardPurple = isDark
        ? const Color(0xFF2E2645)
        : const Color(0xFFEDE7F6);
    const cardPurpleAccent = Color(0xFF5E35B1);

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
          'Personne grièvement blessée',
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
          // ================================================================
          // TITRE PRINCIPAL
          // ================================================================
          Text(
            'La découverte d’une personne grièvement blessée',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 6),
          _Paragraph.rich([
            const TextSpan(
              text:
                  'Cadre juridique spécifique inspiré de la procédure de recherche '
                  'des causes de la mort, applicable en cas de découverte d’une '
                  'personne grièvement blessée lorsque la cause des blessures est '
                  'inconnue ou suspecte, conformément à l’',
            ),
            TextSpan(
              text: 'article 74 alinéa 6 du Code de procédure pénale',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.red.shade700,
              ),
            ),
            const TextSpan(text: '.'),
          ]),
          const SizedBox(height: 16),

          const _IntroBullet(
            text:
                'La loi du 9 mars 2004 a étendu les règles de l’enquête pour causes '
                'de la mort à la découverte d’une personne grièvement blessée.',
          ),
          const _IntroBullet(
            text:
                'Le cadre reste une enquête de type « causes de la mort » mais adapté '
                'à une victime vivante dont les blessures sont inexpliquées ou suspectes.',
          ),
          const SizedBox(height: 20),

          // ================================================================
          // CHAPITRE 1 — CONDITIONS D’APPLICATION
          // ================================================================
          _ConditionCard(
            title:
                'Chapitre 1 — Conditions d’application de l’article 74 alinéa 6 du Code de procédure pénale',
            cardColor: cardPurple,
            accent: cardPurpleAccent,
            titleColor: isDark ? Colors.white : const Color(0xFF311B92),
            children: const [
              _Paragraph(
                'Deux conditions doivent être réunies pour appliquer ce cadre '
                'juridique : la découverte d’une personne grièvement blessée et '
                'un doute ou mystère entourant l’origine de ses blessures.',
              ),
              SizedBox(height: 10),

              _SubTitle(
                '1.1 — La découverte d’une personne grièvement blessée',
              ),

              _SubTitle('1.1.1 — La notion de découverte'),
              _Paragraph(
                'La « découverte » ne signifie pas que la personne était cachée. '
                'L’article 74 alinéa 6 du Code de procédure pénale s’applique aussi '
                'si le corps meurtri de la personne n’a pas été dissimulé (voie '
                'publique, domicile, établissement ouvert au public, etc.).',
              ),
              SizedBox(height: 6),

              _SubTitle('1.1.2 — La personne est grièvement blessée'),
              _Paragraph(
                'La personne est retrouvée dans un état qui ne lui permet pas de '
                's’exprimer : elle est inconsciente, en coma, choquée ou plongée dans '
                'un état manifestement critique. Le pronostic vital peut être engagé.',
              ),
              SizedBox(height: 12),

              _SubTitle(
                '1.2 — La cause des blessures est inconnue ou suspecte',
              ),
              _Paragraph(
                'Les blessures ne trouvent pas d’explication immédiate et claire. '
                'Elles paraissent d’origine indéterminée, anormale ou potentiellement '
                'liée à une infraction pénale.',
              ),
              SizedBox(height: 6),
              _Paragraph(
                'Les premiers éléments constatés par les forces de l’ordre ne '
                'permettent pas d’exclure la commission d’un crime ou d’un délit.',
              ),
              SizedBox(height: 8),

              _Paragraph(
                'La suspicion sur l’origine des blessures peut notamment résulter :',
              ),
              SizedBox(height: 4),
              _BulletPoint(
                text:
                    'de l’examen des traces visibles sur le corps de la victime (coups, '
                    'plaies, étranglement, traces de ligotage, etc.) ;',
              ),
              _BulletPoint(
                text:
                    'de circonstances de fait manifestement anormales ou '
                    'inexplicables (lieu de découverte, mise en scène, incohérences '
                    'dans les déclarations, etc.) ;',
              ),
              _BulletPoint(
                text:
                    'de renseignements recueillis sur place ou auprès de témoins, '
                    'proches, voisins, susceptibles d’éveiller les soupçons.',
              ),
            ],
          ),
          const SizedBox(height: 22),

          // ================================================================
          // CHAPITRE 2 — PROCÉDURE
          // ================================================================
          _ConditionCard(
            title:
                'Chapitre 2 — Procédure de l’article 74 alinéa 6 du Code de procédure pénale',
            cardColor: cardPurple,
            accent: cardPurpleAccent,
            titleColor: isDark ? Colors.white : const Color(0xFF311B92),
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'L’article 74 alinéa 6 renvoie aux actes d’enquête prévus par les '
                      'quatre premiers alinéas de l’',
                ),
                TextSpan(
                  text: 'article 74 du Code de procédure pénale',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.red.shade700,
                  ),
                ),
                const TextSpan(
                  text:
                      '. L’officier ou l’agent de police judiciaire, agissant sous le '
                      'contrôle du procureur de la République, procède aux premières '
                      'constatations puis, le cas échéant, aux actes prévus par les ',
                ),
                TextSpan(
                  text: 'articles 56 à 62 du Code de procédure pénale',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.red.shade700,
                  ),
                ),
                const TextSpan(text: '.'),
              ]),
              const SizedBox(height: 14),

              const _SubTitle(
                '2.1 — Les actes prévus par l’article 74 alinéa 1 du Code de procédure pénale',
              ),

              const _SubTitle('2.1.1 — Le transport sur les lieux'),
              const _Paragraph(
                'L’enquête débute par un transport sur les lieux de découverte. '
                'Les premières constatations permettent d’identifier le cadre juridique '
                'adapté (article 74 alinéa 6, flagrance, enquête préliminaire, etc.).',
              ),
              const SizedBox(height: 6),
              const _Paragraph(
                'Le procureur de la République, informé sans délai de la découverte, '
                'peut se rendre sur place, poursuivre lui-même les investigations ou '
                'confier l’enquête à un service déterminé.',
              ),
              const SizedBox(height: 10),

              const _SubTitle('2.1.2 — Les constatations'),
              const _Paragraph(
                'L’O.P.J. ou l’A.P.J. réalise toutes constatations utiles pour '
                'déterminer les causes et les circonstances des blessures : position de '
                'la victime, traces matérielles, environnement, témoins présents, etc.',
              ),
              const SizedBox(height: 6),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'La nécessité de protéger les lieux, ou une réclamation provenant '
                      'de l’intérieur de la maison, autorise l’O.P.J. ou l’A.P.J. à '
                      'introduire les policiers à l’intérieur, dans le respect du principe '
                      'des heures légales (',
                ),
                TextSpan(
                  text: 'article 59 du Code de procédure pénale',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.red.shade700,
                  ),
                ),
                const TextSpan(text: ').'),
              ]),
              const SizedBox(height: 10),

              const _SubTitle('2.1.3 — Les réquisitions'),
              const _Paragraph(
                'Sur la délégation du procureur de la République, l’O.P.J. ou l’A.P.J. '
                'peut délivrer des réquisitions aux fins :',
              ),
              const SizedBox(height: 4),
              const _BulletPoint(
                text:
                    'd’apprécier la nature des blessures (expertise médicale, examens '
                    'techniques) ;',
              ),
              const _BulletPoint(
                text:
                    'de recueillir des documents ou informations utiles (images de '
                    'vidéosurveillance, identités des personnes présentes, etc.).',
              ),
              const SizedBox(height: 8),
              const _Paragraph(
                'Les personnes ainsi requises prêtent serment d’apporter leur '
                'concours à la justice, sauf lorsqu’elles sont déjà tenues au secret '
                'professionnel par la loi.',
              ),
              const SizedBox(height: 16),

              const _SubTitle(
                '2.2 — Les actes prévus par les articles 56 à 62 du Code de procédure pénale',
              ),
              const _Paragraph(
                'Lorsque les éléments recueillis révèlent un caractère possiblement '
                'criminel ou délictuel, les officiers de police judiciaire peuvent, dans '
                'les conditions prévues par ces textes :',
              ),
              const SizedBox(height: 4),
              const _BulletPoint(
                text:
                    'procéder aux perquisitions nécessaires (domicile, véhicule, locaux '
                    'professionnels) ;',
              ),
              const _BulletPoint(
                text:
                    'effectuer les saisies utiles à la manifestation de la vérité ;',
              ),
              const _BulletPoint(
                text:
                    'adresser des réquisitions à toute personne, établissement ou '
                    'organisme public ou privé ;',
              ),
              const _BulletPoint(
                text:
                    'empêcher toute personne de s’éloigner du lieu de découverte, le '
                    'temps nécessaire aux opérations ;',
              ),
              const _BulletPoint(
                text:
                    'procéder aux auditions de témoins, voire au recours à la '
                    'comparution forcée lorsque la loi le permet.',
              ),
              const SizedBox(height: 12),

              const _SubTitle(
                '2.3 — Suites de l’enquête diligentée en vertu de l’article 74 alinéa 6 du Code de procédure pénale',
              ),
              const _Paragraph(
                'À l’issue des investigations, plusieurs hypothèses sont possibles :',
              ),
              const SizedBox(height: 4),
              const _BulletPoint(
                text:
                    'les blessures apparaissent comme non imputables à un tiers : la '
                    'procédure est classée ;',
              ),
              const _BulletPoint(
                text:
                    'le caractère criminel ou délictuel des blessures est établi : '
                    'l’enquête se poursuit dans un cadre classique (flagrance, enquête '
                    'préliminaire ou information judiciaire) ;',
              ),
              const _BulletPoint(
                text:
                    'des doutes subsistent : l’enquête se poursuit sous la forme de '
                    'l’enquête préliminaire, dans la limite des délais légaux ;',
              ),
              const _BulletPoint(
                text:
                    'la personne décède et les circonstances de la mort restent '
                    'suspectes : la procédure bascule dans le cadre de la recherche '
                    'des causes de la mort prévu par l’article 74 du Code de procédure '
                    'pénale.',
              ),
            ],
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
