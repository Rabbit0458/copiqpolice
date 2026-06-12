// lib/pa/dps_dpg/cadres_juridiques/mort_inconnue/mort_inconnue_procedure.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Couleur dédiée pour les articles de loi
const Color _lawColor = Color(0xFFE53935);

class PaMortInconnueProcedurePage extends StatelessWidget {
  const PaMortInconnueProcedurePage({super.key});

  static const String routeName =
      '/pa/dps_dpg/cadres_juridiques/mort_inconnue/chapitre2';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FB);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);
    final Color textSoft = isDark
        ? Colors.white70
        : const Color(0xFF222222).withValues(alpha: .75);
    final Color accent = isDark
? const Color(0xFF64B5F6)
: const Color(0xFF1565C0);
    final Color cardColor = isDark
? const Color(0xFF1E1E1E)
: const Color(0xFFFFFFFF);

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
          // ====================== EN-TÊTE CHAPITRE =========================
          Text(
            'Chapitre 2\nProcédure des articles 74 et 80-4\n'
            'du Code de procédure pénale',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 8),
          const _Paragraph.rich([
            TextSpan(
              text:
                  'Ce chapitre présente les autorités habilitées à intervenir lorsqu’une '
                  'personne est découverte décédée dans des circonstances inconnues ou '
                  'suspectes. Il précise le rôle du procureur de la République, du juge '
                  'd’instruction et des enquêteurs dans la mise en œuvre des dispositions '
                  'des ',
            ),
            TextSpan(
              text: 'articles 74 et 80-4 du Code de procédure pénale',
              style: TextStyle(color: _lawColor, fontWeight: FontWeight.w700),
            ),
            TextSpan(
              text:
                  ', ainsi que l’articulation entre enquête dirigée par le parquet et '
                  'information judiciaire pour recherche des causes de la mort.',
            ),
          ]),
          const SizedBox(height: 18),

          // ====================== CARTE 1 : LES AUTORITÉS HABILITÉES =======
          _ConditionCard(
            title: '2.1 — Les autorités habilitées',
            cardColor: cardColor,
            accent: accent,
            titleColor: textMain,
            children: const [
              _Paragraph(
                'Plusieurs intervenants peuvent être compétents dans le cadre de la '
                'recherche des causes de la mort : les magistrats (procureur de la '
                'République et juge d’instruction) et les officiers ou agents de police '
                'judiciaire qui agissent, selon les cas, par délégation du parquet ou '
                'sur commission rogatoire.',
              ),
              SizedBox(height: 8),
              _SubTitle('2.1.1 — Les magistrats'),
            ],
          ),
          const SizedBox(height: 16),

          // ====================== CARTE 2 : PROCUREUR ======================
          _ConditionCard(
            title: '2.1.1.1 — Le procureur de la République',
            cardColor: cardColor,
            accent: accent,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'En application du deuxième alinéa de l’article 74 du Code de '
                      'procédure pénale, le procureur de la République, avisé '
                      'immédiatement par l’officier de police judiciaire ou, sous son '
                      'contrôle, par l’agent de police judiciaire d’une mort suspecte, ',
                ),
                TextSpan(
                  text:
                      '« se rend sur place s’il le juge nécessaire et se fait assister '
                      'de personnes capables d’apprécier la nature des circonstances du décès. '
                      'Il peut toutefois déléguer aux mêmes fins un officier de police judiciaire '
                      'de son choix »',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: textSoft,
                  ),
                ),
                const TextSpan(text: '.'),
              ]),
              const SizedBox(height: 10),
              const _Paragraph(
                'Informé sans délai de toute découverte de cadavre dans un contexte '
                'douteux, le procureur de la République dispose de plusieurs options :',
              ),
              const SizedBox(height: 6),
              const _BulletPoint(
                text:
                    'instrumenter lui-même en se rendant sur place et en dirigeant '
                    'directement les opérations ;',
              ),
              const _BulletPoint(
                text:
                    'ordonner à l’officier ou à l’agent de police judiciaire premier saisi '
                    'de poursuivre les investigations dans le cadre de l’article 74 du '
                    'Code de procédure pénale ;',
              ),
              const _BulletPoint(
                text:
                    'dessaisir le service initialement saisi pour confier l’enquête à un autre '
                    'officier ou agent de police judiciaire de son choix ;',
              ),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'requérir l’ouverture d’une information judiciaire pour recherche des '
                      'causes de la mort : dans ce cas, ',
                ),
                TextSpan(
                  text: 'le juge d’instruction',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      ' reçoit compétence pour agir sur le fondement de l’article 80-4 du '
                      'Code de procédure pénale.',
                ),
              ]),
            ],
          ),
          const SizedBox(height: 16),

          // ====================== CARTE 3 : JUGE D’INSTRUCTION =============
          _ConditionCard(
            title: '2.1.1.2 — Le juge d’instruction',
            cardColor: cardColor,
            accent: accent,
            titleColor: textMain,
            children: const [
              _Paragraph.rich([
                TextSpan(
                  text:
                      'L’ouverture d’une information judiciaire spécifique pour recherche '
                      'des causes de la mort est prévue par ',
                ),
                TextSpan(
                  text: 'l’article 74 du Code de procédure pénale',
                  style: TextStyle(
                    color: _lawColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      ', qui précise que le procureur de la République peut requérir '
                      'une telle information. ',
                ),
                TextSpan(
                  text: 'L’article 80-4 du Code de procédure pénale',
                  style: TextStyle(
                    color: _lawColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      ' organise ensuite les pouvoirs du juge d’instruction dans ce cadre '
                      'particulier.',
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text:
                      'Le deuxième alinéa de l’article 80-4 prévoit que les membres de la '
                      'famille ou les proches de la personne décédée peuvent se constituer '
                      'partie civile à titre incident. En revanche, ils ',
                ),
                TextSpan(
                  text:
                      'ne peuvent pas provoquer directement l’ouverture d’une information pour '
                      'recherche des causes de la mort',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      ', cette prérogative demeurant réservée au procureur de la République. '
                      'En cas d’inaction du parquet, la famille conserve toutefois la '
                      'possibilité de déposer plainte avec constitution de partie civile en '
                      'invoquant la commission d’une infraction déterminée.',
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text:
                      'L’information ouverte sur le fondement des articles 74 et 80-4 du '
                      'Code de procédure pénale présente un caractère particulier : ',
                ),
                TextSpan(
                  text: 'elle est exorbitante du droit commun',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      ' car elle a pour seul but la recherche des causes de la mort et ne '
                      'saisit pas le juge de l’ensemble des faits. Elle ne met pas, à ce '
                      'stade, en mouvement l’action publique.',
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text:
                      'Le juge d’instruction dispose, dans ce cadre, de tous les pouvoirs '
                      'propres à l’instruction préparatoire ',
                ),
                TextSpan(
                  text: '(article 80-4 du Code de procédure pénale)',
                  style: TextStyle(
                    color: _lawColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      ', sous une réserve importante : la durée des interceptions de '
                      'correspondances émises par la voie des communications électroniques '
                      'est limitée à deux mois renouvelables.',
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text:
                      'Le juge d’instruction conserve par ailleurs la faculté de déléguer, '
                      'par commission rogatoire, à un officier de police judiciaire les actes '
                      'nécessaires à la recherche des causes de la mort. Dans ce cas, les '
                      'enquêteurs agissent dans le cadre de la commission rogatoire, sous le '
                      'contrôle du magistrat instructeur.',
                ),
              ]),
            ],
          ),
          const SizedBox(height: 16),

          // ====================== CARTE 4 : OPJ / APJ ======================
          _ConditionCard(
            title: '2.1.2 — L’officier ou l’agent de police judiciaire',
            cardColor: cardColor,
            accent: accent,
            titleColor: textMain,
            children: const [
              _Paragraph(
                'L’officier de police judiciaire, ou l’agent de police judiciaire agissant '
                'sous son contrôle, peut se voir déléguer les pouvoirs du procureur de la '
                'République pour déterminer les causes de la mort. Il conduit alors les '
                'investigations de terrain (constatations, auditions, réquisitions, '
                'examens techniques) dans le cadre fixé par le parquet.',
              ),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text:
                      'Lorsque le juge d’instruction est saisi d’une information pour '
                      'recherche des causes de la mort, l’officier de police judiciaire peut '
                      'également être commis par ',
                ),
                TextSpan(
                  text: 'commission rogatoire',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      '. Il agit alors au nom du juge d’instruction, dans les limites de la '
                      'mission définie par la commission, et doit lui rendre compte des actes '
                      'effectués et des résultats obtenus.',
                ),
              ]),
            ],
          ),
          const SizedBox(height: 16),

          // ====================== NOTA FINAL ===============================
          const _NotaBox(
            bodySpans: [
              TextSpan(
                text:
                    'La bonne compréhension de la répartition des rôles entre procureur '
                    'de la République, juge d’instruction et enquêteurs est essentielle. '
                    'Elle conditionne la régularité des actes accomplis et la validité des '
                    'éléments recueillis en vue, le cas échéant, de l’ouverture ultérieure '
                    'd’une véritable procédure pénale pour homicide ou violences ayant '
                    'entraîné la mort.',
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
  const _BulletPoint({required this.text}) : rich = null;

  const _BulletPoint.rich(this.rich) : text = null;

  final String? text;
  final List<TextSpan>? rich;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color iconColor = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    final Color textColor = isDark
        ? Colors.white70
        : const Color(0xFF1F1F1F).withValues(alpha: .92);

    Widget child;

    if (rich != null) {
      child = RichText(
        text: TextSpan(
          style: GoogleFonts.fustat(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 1.35,
            color: textColor,
          ),
          children: rich!,
        ),
      );
    } else {
      child = Text(
        text ?? '',
        style: GoogleFonts.fustat(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          height: 1.35,
          color: textColor,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_rounded, size: 18, color: iconColor),
          const SizedBox(width: 6),
          Expanded(child: child),
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
