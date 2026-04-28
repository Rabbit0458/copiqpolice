import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MortInconnueIntroPage extends StatelessWidget {
  const MortInconnueIntroPage({super.key});

  static const String routeName = '/gpx/cadres_juridiques/mort_inconnue/intro';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FB);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);
    final Color textSoft = isDark
        ? Colors.white70
        : const Color(0xFF222222).withOpacity(.75);
    final Color accent = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    final Color cardColor = isDark
        ? const Color(0xFF1E1E1E)
        : const Color(0xFFFFFFFF);

    // Couleur spécifique pour les références d’articles
    const Color lawColor = Color(0xFFE53935);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: bg,
        centerTitle: true,
        leading: IconButton(
          tooltip: 'Retour',
          onPressed: () => Navigator.of(context).maybePop(),
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: textMain),
        ),
        title: Text(
          'Mort de cause inconnue',
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
          // ====================== TITRE PRINCIPAL ==========================
          Text(
            'Introduction\nProcédure de recherche des causes de la mort',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 22,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 8),
          _Paragraph.rich([
            const TextSpan(
              text:
                  'Cette introduction présente le cadre juridique applicable lorsque '
                  'les services de police ou de gendarmerie découvrent une personne '
                  'décédée dans des circonstances inconnues ou suspectes. Elle '
                  'explique comment s’articulent ',
            ),
            const TextSpan(
              text: 'l’article 74 du Code de procédure pénale',
              style: TextStyle(color: lawColor, fontWeight: FontWeight.w700),
            ),
            const TextSpan(text: ' (recherche des causes de la mort) et '),
            const TextSpan(
              text: 'l’article 80-4 du Code de procédure pénale',
              style: TextStyle(color: lawColor, fontWeight: FontWeight.w700),
            ),
            const TextSpan(
              text:
                  ' (information judiciaire confiée au juge d’instruction pour ces mêmes faits).',
            ),
          ]),
          const SizedBox(height: 18),

          // ====================== CARTE 1 : CADRE LÉGAL ====================
          _ConditionCard(
            title: '1. Le cadre légal de base',
            cardColor: cardColor,
            accent: accent,
            titleColor: textMain,
            children: [
              const _SubTitle(
                'Articles 74 et 80-4 du Code de procédure pénale',
              ),
              _Paragraph.rich([
                const TextSpan(text: 'La procédure dite de '),
                const TextSpan(
                  text: '« recherche des causes de la mort »',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const TextSpan(text: ' est prévue par '),
                const TextSpan(
                  text: 'l’article 74 du Code de procédure pénale',
                  style: TextStyle(
                    color: lawColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const TextSpan(
                  text:
                      '. Elle s’applique lorsque le décès d’une personne est entouré '
                      'de circonstances inexpliquées, suspectes ou manifestement '
                      'anormales. Le procureur de la République dirige alors les '
                      'premières investigations.',
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Lorsque la complexité des faits ou la gravité de la situation le '
                      'justifient, une information judiciaire peut être ouverte sur le '
                      'fondement de ',
                ),
                const TextSpan(
                  text: 'l’article 80-4 du Code de procédure pénale',
                  style: TextStyle(
                    color: lawColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const TextSpan(
                  text:
                      '. Le juge d’instruction est alors saisi pour « recherches des '
                      'causes de la mort » et peut déléguer certains actes aux '
                      'officiers de police judiciaire par commission rogatoire.',
                ),
              ]),
            ],
          ),
          const SizedBox(height: 16),

          // ====================== CARTE 2 : OBJECTIFS ======================
          _ConditionCard(
            title: '2. Objectifs de la procédure',
            cardColor: cardColor,
            accent: accent,
            titleColor: textMain,
            children: const [
              _SubTitle('Comprendre avant de qualifier pénalement'),
              _Paragraph(
                'La recherche des causes de la mort ne vise pas, dans un premier '
                'temps, à désigner un auteur, mais à répondre à une question '
                'fondamentale : le décès est-il naturel, accidentel ou lié à une '
                'infraction pénale ?',
              ),
              SizedBox(height: 10),
              _IntroBullet(
                text:
                    'Vérifier les circonstances exactes du décès (lieu, date, contexte, '
                    'présence ou non de témoins).',
              ),
              _IntroBullet(
                text:
                    'Distinguer les morts naturelles des décès violents, inexpliqués ou '
                    'survenus dans un contexte sensible (détention, voie publique, '
                    'conflit familial, etc.).',
              ),
              _IntroBullet(
                text:
                    'Permettre ensuite au procureur de la République, puis le cas échéant '
                    'au juge d’instruction, de choisir le cadre procédural adapté '
                    '(classement, enquête de flagrance, enquête préliminaire, '
                    'information judiciaire).',
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ====================== CARTE 3 : RÔLE DE L’ENQUÊTEUR ============
          _ConditionCard(
            title: '3. Place de l’enquêteur sur le terrain',
            cardColor: cardColor,
            accent: accent,
            titleColor: textMain,
            children: const [
              _SubTitle('Réflexes opérationnels à maîtriser'),
              _Paragraph(
                'L’officier de police judiciaire, assisté le cas échéant par l’agent de '
                'police judiciaire, est au cœur du dispositif. Il doit à la fois assurer '
                'la sécurité des lieux, préserver les traces et indices et rendre compte '
                'avec précision au parquet.',
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    'Informer immédiatement le procureur de la République de toute '
                    'découverte de corps dans des circonstances douteuses.',
              ),
              _BulletPoint(
                text:
                    'Mettre en place un périmètre de protection et limiter les '
                    'déplacements afin de préserver la scène et les indices.',
              ),
              _BulletPoint(
                text:
                    'Réaliser des constatations objectives et détaillées : position du '
                    'corps, état des vêtements, traces visibles, objets présents, état '
                    'des lieux, éventuelles caméras, témoins, etc.',
              ),
              _BulletPoint(
                text:
                    'Préparer l’intervention des autres acteurs : médecin, médecin '
                    'légiste, techniciens en identification criminelle, pompes funèbres '
                    'sur instruction du parquet.',
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ====================== CARTE 4 : ARTICULATION DES CADRES =======
          _ConditionCard(
            title: '4. Articulation avec les autres cadres juridiques',
            cardColor: cardColor,
            accent: accent,
            titleColor: textMain,
            children: [
              const _SubTitle('De la mort inexpliquée à l’enquête pénale'),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'À l’issue des premières vérifications effectuées dans le cadre de ',
                ),
                const TextSpan(
                  text: 'l’article 74 du Code de procédure pénale',
                  style: TextStyle(
                    color: lawColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const TextSpan(
                  text:
                      ', plusieurs issues sont possibles : la mort apparaît naturelle et '
                      'la procédure est classée, ou bien des éléments laissent penser '
                      'à une infraction et l’enquête bascule vers un autre cadre.',
                ),
              ]),
              const SizedBox(height: 10),
              const _IntroBullet(
                text:
                    'Le passage à l’enquête de flagrance est possible si des indices '
                    'laissent penser qu’un crime ou un délit vient d’être commis.',
              ),
              const _IntroBullet(
                text:
                    'L’enquête préliminaire est privilégiée lorsque les faits semblent '
                    'moins urgents mais nécessitent encore des investigations.',
              ),
              _IntroBullet(
                text:
                    'Une information judiciaire peut être ouverte sur le fondement de '
                    'l’',
              ),
              // On complète l’intro-bullet précédent via un petit paragraphe riche
              _Paragraph.rich([
                const TextSpan(
                  text: 'article 80-4 du Code de procédure pénale',
                  style: TextStyle(
                    color: lawColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const TextSpan(
                  text:
                      ', permettant au juge d’instruction de diriger des actes plus '
                      'intrusifs (expertises, perquisitions, commissions rogatoires, etc.).',
                ),
              ]),
            ],
          ),
          const SizedBox(height: 16),

          // ====================== CARTE 5 : REPÈRES PRATIQUES =============
          _ConditionCard(
            title: '5. Repères pratiques pour l’examen',
            cardColor: cardColor,
            accent: accent,
            titleColor: textMain,
            children: [
              const _SubTitle('Points clés à connaître par cœur'),
              _Paragraph.rich([
                const TextSpan(text: '• '),
                const TextSpan(
                  text: 'L’article 74 du Code de procédure pénale',
                  style: TextStyle(
                    color: lawColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const TextSpan(
                  text:
                      ' encadre la recherche des causes de la mort sous l’autorité du '
                      'procureur de la République.',
                ),
              ]),
              const SizedBox(height: 4),
              _Paragraph.rich([
                const TextSpan(text: '• '),
                const TextSpan(
                  text: 'L’article 80-4 du Code de procédure pénale',
                  style: TextStyle(
                    color: lawColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const TextSpan(
                  text:
                      ' permet au juge d’instruction d’ouvrir une information pour les '
                      'mêmes faits et de déléguer des actes aux officiers de police '
                      'judiciaire.',
                ),
              ]),
              const SizedBox(height: 4),
              const _BulletPoint(
                text:
                    'L’objectif initial est d’identifier la nature du décès avant de '
                    'qualifier juridiquement les faits et de viser une infraction précise.',
              ),
              const _BulletPoint(
                text:
                    'La précision des premières constatations conditionne la suite de '
                    'l’enquête : classement, enquête de flagrance, enquête préliminaire '
                    'ou instruction.',
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ====================== NOTA GLOBAL =============================
          _NotaBox(
            bodySpans: [
              TextSpan(
                text:
                    'Cette page sert de préambule. Les pages suivantes détaillent '
                    'successivement : les conditions d’application des articles 74 et '
                    '80-4 du Code de procédure pénale, la procédure et les actes de '
                    'l’enquête, les actes délégués par le juge d’instruction, puis les '
                    'différentes issues possibles à l’issue des investigations.',
                style: GoogleFonts.fustat().copyWith(
                  fontWeight: FontWeight.w500,
                ),
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
