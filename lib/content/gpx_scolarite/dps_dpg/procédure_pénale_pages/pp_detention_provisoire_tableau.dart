import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PPDetentionProvisoireTableauPage extends StatelessWidget {
  const PPDetentionProvisoireTableauPage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/procédure_pénale_pages/pp_detention_provisoire_tableau';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bg = isDark ? const Color(0xFF303030) : const Color(0xFFF5F5F5);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF303030) : Colors.white,
        elevation: 0.6,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: textMain),
          tooltip: 'Retour',
        ),
        title: Text(
          'Tableaux — Détention provisoire',
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: textMain,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
        children: const [
          _TitleBlock(),
          SizedBox(height: 20),

          // =================== DÉLITS ======================
          _SubTitle(
            'Tableau — Détention provisoire des majeurs en matière de délits',
          ),
          SizedBox(height: 8),
          _DetentionDelitsTable(),

          SizedBox(height: 28),

          // =================== CRIMES ======================
          _SubTitle(
            'Tableau — Détention provisoire des majeurs en matière de crimes',
          ),
          SizedBox(height: 8),
          _DetentionCrimesTable(),

          SizedBox(height: 24),
          _NotaDetention(),
        ],
      ),
    );
  }
}

///////////////////////////////////////////////////////////////////////////////
///                         BLOC TITRE / INTRO                               ///
///////////////////////////////////////////////////////////////////////////////

class _TitleBlock extends StatelessWidget {
  const _TitleBlock();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF383838) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.black12,
          width: .7,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tableaux de la détention provisoire',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 20,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 8),
          const _Paragraph(
            'Ces tableaux récapitulent les durées initiales, les prolongations et les '
            'durées maximales de la détention provisoire pour les majeurs, en matière '
            'de délits et de crimes. Ils complètent les règles posées par la loi et '
            'permettent une vision globale des différents cas.',
          ),
        ],
      ),
    );
  }
}

///////////////////////////////////////////////////////////////////////////////
///                         WIDGETS TEXTE                                    ///
///////////////////////////////////////////////////////////////////////////////

class _SubTitle extends StatelessWidget {
  const _SubTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Text(
      text,
      style: GoogleFonts.fustat(
        fontWeight: FontWeight.w700,
        fontSize: 15.5,
        color: isDark ? const Color(0xFFBBDEFB) : const Color(0xFF0D47A1),
      ),
    );
  }
}

class _Paragraph extends StatelessWidget {
  const _Paragraph(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color color = isDark
        ? Colors.white70
        : const Color(0xFF1F1F1F).withValues(alpha: .92);

    return Text(
      text,
      textAlign: TextAlign.justify,
      style: GoogleFonts.fustat(
        fontSize: 13.5,
        height: 1.45,
        fontWeight: FontWeight.w500,
        color: color,
      ),
    );
  }
}

class _NotaDetention extends StatelessWidget {
  const _NotaDetention();

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
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: bgColor.withValues(alpha: isDark ? 0.8 : 1),
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: borderColor, width: 3)),
      ),
      child: RichText(
        textAlign: TextAlign.justify,
        text: TextSpan(
          style: GoogleFonts.fustat(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            height: 1.4,
            color: isDark
                ? Colors.white70
                : const Color(0xFF3E2723).withValues(alpha: .95),
          ),
          children: const [
            TextSpan(
              text: 'NOTA : ',
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
            TextSpan(
              text:
                  'Les durées mentionnées dans ces tableaux doivent toujours être '
                  'appréciées à la lumière du principe de durée raisonnable de la '
                  'détention provisoire. ',
            ),
            TextSpan(
              text: 'Article 144-1 du Code de procédure pénale',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
            ),
            TextSpan(
              text:
                  ' : la détention provisoire ne peut excéder une durée raisonnable '
                  'au regard de la gravité des faits, de la complexité de '
                  'l\'affaire et de la diligence apportée à la procédure. Dès que '
                  'ces conditions, ainsi que celles de l’article 144, ne sont plus '
                  'remplies, la mise en liberté doit être ordonnée.',
            ),
          ],
        ),
      ),
    );
  }
}

///////////////////////////////////////////////////////////////////////////////
///                       CARTE TABLEAU + CELLULES                           ///
///////////////////////////////////////////////////////////////////////////////

class _TableCard extends StatelessWidget {
  const _TableCard({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color borderColor = isDark
        ? Colors.white.withValues(alpha: .22)
        : Colors.grey.shade300;

    final double minWidth = MediaQuery.of(context).size.width - 32; // padding

    return Container(
      margin: const EdgeInsets.only(top: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: isDark ? const Color(0xFF383838) : Colors.white,
        border: Border.all(color: borderColor, width: 0.7),
      ),
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: minWidth),
          child: child,
        ),
      ),
    );
  }
}

class _TableCell extends StatelessWidget {
  const _TableCell({
    required this.text,
    this.isHeader = false,
    this.isEmphasis = false,
    this.textAlign = TextAlign.left,
  });

  final String text;
  final bool isHeader;
  final bool isEmphasis;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color bg = Colors.transparent;
    if (isHeader) {
      bg = isDark ? const Color(0xFF12427C) : const Color(0xFFE7F0FF);
    }

    final baseStyle = GoogleFonts.fustat(
      fontSize: isHeader ? 12.5 : 11.5,
      height: 1.25,
      fontWeight: isHeader
          ? FontWeight.w800
          : (isEmphasis ? FontWeight.w600 : FontWeight.w500),
      color: isDark
          ? Colors.white
          : (isHeader ? const Color(0xFF0D47A1) : const Color(0xFF111111)),
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
      color: bg,
      alignment: Alignment.topLeft,
      child: Text(text, textAlign: textAlign, style: baseStyle),
    );
  }
}

///////////////////////////////////////////////////////////////////////////////
///                   TABLEAU DÉTENTION – DÉLITS                             ///
///////////////////////////////////////////////////////////////////////////////

class _DetentionDelitsTable extends StatelessWidget {
  const _DetentionDelitsTable();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color borderInside = isDark
        ? Colors.white.withValues(alpha: .15)
        : Colors.grey.shade300;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TableCard(
          child: Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.top,
            border: TableBorder.symmetric(
              inside: BorderSide(color: borderInside, width: 0.5),
            ),
            columnWidths: const {
              0: FlexColumnWidth(3.6),
              1: FlexColumnWidth(1.5),
              2: FlexColumnWidth(2.2),
              3: FlexColumnWidth(2.1),
            },
            children: const [
              TableRow(
                children: [
                  _TableCell(
                    text: 'Emprisonnement encouru',
                    isHeader: true,
                    textAlign: TextAlign.center,
                  ),
                  _TableCell(
                    text: 'Durée initiale',
                    isHeader: true,
                    textAlign: TextAlign.center,
                  ),
                  _TableCell(
                    text:
                        'Prolongations\n(chaque prolongation suppose un débat contradictoire)',
                    isHeader: true,
                    textAlign: TextAlign.center,
                  ),
                  _TableCell(
                    text: 'Durée maximum\nde détention provisoire',
                    isHeader: true,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              TableRow(
                children: [
                  _TableCell(text: 'Pas d’emprisonnement', isEmphasis: true),
                  _TableCell(text: '—', textAlign: TextAlign.center),
                  _TableCell(
                    text:
                        'La détention provisoire n’est pas possible\n(quel que soit le type de délit).',
                  ),
                  _TableCell(text: '—', textAlign: TextAlign.center),
                ],
              ),
              TableRow(
                children: [
                  _TableCell(text: 'Moins de 3 ans\nd’emprisonnement'),
                  _TableCell(text: '4 mois', textAlign: TextAlign.center),
                  _TableCell(text: 'Pas de prolongation possible.'),
                  _TableCell(text: '4 mois', textAlign: TextAlign.center),
                ],
              ),
              TableRow(
                children: [
                  _TableCell(
                    text:
                        'Égal ou supérieur à 3 ans\net inférieur ou égal à 5 ans\nd’emprisonnement',
                    isEmphasis: true,
                  ),
                  _TableCell(
                    text: '4 mois',
                    isEmphasis: true,
                    textAlign: TextAlign.center,
                  ),
                  _TableCell(
                    text: '2 × 4 mois',
                    isEmphasis: true,
                    textAlign: TextAlign.center,
                  ),
                  _TableCell(
                    text: '1 an',
                    isEmphasis: true,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              TableRow(
                children: [
                  _TableCell(
                    text:
                        'Supérieure à 5 ans\nd’emprisonnement\n(délits non listés ci-dessous)',
                  ),
                  _TableCell(text: '4 mois', textAlign: TextAlign.center),
                  _TableCell(text: '4 × 4 mois', textAlign: TextAlign.center),
                  _TableCell(text: '2 ans', textAlign: TextAlign.center),
                ],
              ),
              TableRow(
                children: [
                  _TableCell(
                    text:
                        'Délits punis de plus de 10 ans,\nnotamment :\n- terrorisme,\n- trafic de stupéfiants,\n- proxénétisme aggravé,\n- extorsion de fonds,\n- délits commis en bande organisée…',
                    isEmphasis: true,
                  ),
                  _TableCell(
                    text: '4 mois',
                    isEmphasis: true,
                    textAlign: TextAlign.center,
                  ),
                  _TableCell(
                    text: '6 × 4 mois',
                    isEmphasis: true,
                    textAlign: TextAlign.center,
                  ),
                  _TableCell(
                    text:
                        '3 ans (4 ans si faits commis\nhors du territoire national\nou en bande organisée).',
                    isEmphasis: true,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        const _Paragraph(
          'Tout placement en détention et toute prolongation de cette mesure supposent '
          'la tenue d’un débat contradictoire.',
        ),
      ],
    );
  }
}

///////////////////////////////////////////////////////////////////////////////
///                   TABLEAU DÉTENTION – CRIMES                             ///
///////////////////////////////////////////////////////////////////////////////

class _DetentionCrimesTable extends StatelessWidget {
  const _DetentionCrimesTable();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color borderInside = isDark
        ? Colors.white.withValues(alpha: .15)
        : Colors.grey.shade300;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TableCard(
          child: Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.top,
            border: TableBorder.symmetric(
              inside: BorderSide(color: borderInside, width: 0.5),
            ),
            columnWidths: const {
              0: FlexColumnWidth(3.6),
              1: FlexColumnWidth(1.5),
              2: FlexColumnWidth(2.2),
              3: FlexColumnWidth(2.1),
            },
            children: const [
              TableRow(
                children: [
                  _TableCell(
                    text: 'Peine criminelle encourue',
                    isHeader: true,
                    textAlign: TextAlign.center,
                  ),
                  _TableCell(
                    text: 'Durée initiale',
                    isHeader: true,
                    textAlign: TextAlign.center,
                  ),
                  _TableCell(
                    text:
                        'Prolongations\n(chaque prolongation suppose un débat contradictoire)',
                    isHeader: true,
                    textAlign: TextAlign.center,
                  ),
                  _TableCell(
                    text: 'Durée maximum\nde détention provisoire',
                    isHeader: true,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              TableRow(
                children: [
                  _TableCell(
                    text:
                        'Crime puni d’une peine\ninférieure à 20 ans\nde réclusion criminelle',
                  ),
                  _TableCell(text: '1 an', textAlign: TextAlign.center),
                  _TableCell(text: '2 × 6 mois', textAlign: TextAlign.center),
                  _TableCell(
                    text:
                        '2 ans\n(3 ans si un des faits\na été commis à l’étranger).',
                  ),
                ],
              ),
              TableRow(
                children: [
                  _TableCell(
                    text:
                        'Crime puni d’une peine\négale ou supérieure à 20 ans\nde réclusion criminelle',
                    isEmphasis: true,
                  ),
                  _TableCell(
                    text: '1 an',
                    isEmphasis: true,
                    textAlign: TextAlign.center,
                  ),
                  _TableCell(
                    text: '4 × 6 mois',
                    isEmphasis: true,
                    textAlign: TextAlign.center,
                  ),
                  _TableCell(
                    text:
                        '3 ans\n(4 ans si un des faits\na été commis à l’étranger).',
                    isEmphasis: true,
                  ),
                ],
              ),
              TableRow(
                children: [
                  _TableCell(
                    text:
                        'Crimes les plus graves :\n- terrorisme,\n- trafic de stupéfiants de\n  nature criminelle,\n- proxénétisme aggravé,\n- extorsion de fonds,\n- crime commis en bande organisée,\n- certains crimes contre la personne,\n- crimes contre la nation…',
                    isEmphasis: true,
                  ),
                  _TableCell(
                    text: '1 an',
                    isEmphasis: true,
                    textAlign: TextAlign.center,
                  ),
                  _TableCell(
                    text: '6 × 6 mois',
                    isEmphasis: true,
                    textAlign: TextAlign.center,
                  ),
                  _TableCell(
                    text: '4 ans',
                    isEmphasis: true,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        const _Paragraph(
          'Une révocation du contrôle judiciaire ou d’une mesure d’assignation à résidence '
          'avec surveillance électronique permet le placement en détention ou sa '
          'prolongation dans les limites ci-dessus.',
        ),
      ],
    );
  }
}
