import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OrganigrammeMinistereInterieurPage extends StatelessWidget {
  const OrganigrammeMinistereInterieurPage({super.key});

  static const String routeName =
      '/pa/institution/organisation_pn/organigramme_mi';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    final Color card = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color accent = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);

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
          "Organigramme MI",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: textMain,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
        children: [
          Text(
            "Organigramme — Ministère de l’Intérieur",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          _CardBox(
            title: "Lecture simple (format tableau)",
            cardColor: card,
            accent: accent,
            titleColor: textMain,
            children: [
              const _InfoLine(
                icon: Icons.swipe_rounded,
                text:
                    "Glisse horizontalement + verticalement pour lire toutes les cases.",
              ),
              const SizedBox(height: 6),
              const _InfoLine(
                icon: Icons.table_rows_rounded,
                text:
                    "Chaque colonne correspond à un grand bloc de l’organigramme.",
              ),
              const SizedBox(height: 10),
              RichText(
                textAlign: TextAlign.justify,
                text: TextSpan(
                  style: GoogleFonts.fustat(
                    fontSize: 13.8,
                    height: 1.4,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                  children: const [
                    TextSpan(text: "Document : "),
                    TextSpan(
                      text: "mis à jour le 15/06/2025",
                      style: TextStyle(
                        color: _lawRed,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    TextSpan(text: "."),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          _CardBox(
            title: "Tableau complet",
            cardColor: card,
            accent: accent,
            titleColor: textMain,
            children: const [SizedBox(height: 6), _OrganigrammeMiTable()],
          ),
        ],
      ),
    );
  }
}

///////////////////////////////////////////////////////////////////////////////
///                               TABLEAU MI                                ///
///////////////////////////////////////////////////////////////////////////////

class _OrganigrammeMiTable extends StatelessWidget {
  const _OrganigrammeMiTable();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color border = isDark ? Colors.white24 : Colors.black12;
    final Color headerBg = isDark
        ? const Color(0xFF0B1F3A)
        : const Color(0xFFE8F0FF);
    final Color cellBg = isDark ? const Color(0xFF111827) : Colors.white;

    // En-tête (haut du schéma)
    const List<String> topLine = [
      "INSPECTION GÉNÉRALE DE L’ADMINISTRATION",
      "CONSEIL SUPÉRIEUR DE L’APPUI TERRITORIAL ET DE L’ÉVALUATION",
      "MINISTÈRE DE L’INTÉRIEUR",
      "CABINET",
      "CONTRÔLE BUDGÉTAIRE ET COMPTABLE MINISTÉRIEL",
    ];

    const List<String> topLine2 = [
      "",
      "",
      "Haut fonctionnaire de défense",
      "",
      "",
    ];

    const List<String> topLine3 = [
      "",
      "",
      "Haut fonctionnaire au développement durable",
      "",
      "",
    ];

    // Colonnes principales (comme sur le schéma)
    const headers = <String>[
      "DGSCGC",
      "DGPN",
      "DGGN",
      "DGSI",
      "Secrétariat général",
      "DGCL",
      "Sécurité routière",
      "Outre-mer",
      "DGEF",
    ];

    const colDGSCGC = [
      "DIRECTION GÉNÉRALE DE LA SÉCURITÉ CIVILE\nET DE LA GESTION DES CRISES",
      "Inspection générale de la sécurité civile",
      "Direction des sapeurs-pompiers",
      "Sous-direction de la préparation,\nanticipation et gestion des crises",
      "Sous-direction des affaires internationales",
      "Sous-direction des ressources et de la stratégie",
    ];

    const colDGPN = [
      "DIRECTION GÉNÉRALE DE LA POLICE NATIONALE",
      "Service national des enquêtes administratives de sécurité",
      "Service national des enquêtes d’autorisation de voyage",
      "Agence du numérique des forces de sécurité intérieure",
      "IGPN",
      "DRHFS",
      "DNPJ",
      "DNSP",
      "DNPAF",
      "DNRT",
      "DCCRS",
      "Académie",
      "SDLP",
      "SNPS",
      "RAID",
    ];

    const colDGGN = [
      "DIRECTION GÉNÉRALE DE LA GENDARMERIE NATIONALE",
      "Inspection générale de la gendarmerie nationale",
      "Direction des opérations et de l’emploi",
      "Direction des ressources humaines",
      "Direction des soutiens et des finances",
      "Service de la transformation",
      "Service de l’information et des relations publiques",
      "COMCYBER-MI",
    ];

    const colDGSI = ["DIRECTION GÉNÉRALE DE LA SÉCURITÉ INTÉRIEURE"];

    const colSG = [
      "SECRÉTARIAT GÉNÉRAL",
      "Direction du management de l’administration territoriale\net de l’encadrement supérieur",
      "Service du haut fonctionnaire de défense",
      "Direction de l’évaluation de la performance,\nde l’achat, des finances et de l’immobilier",
      "Direction des libertés publiques et des affaires juridiques",
      "Direction des ressources humaines",
      "Délégation à l’information et à la communication",
      "Direction de la transformation numérique",
      "Direction des affaires européennes et internationales",
      "Institut des hautes études du ministère de l’intérieur",
      "Direction des entreprises et partenariats\nde sécurité et des armes",
    ];

    const colDGCL = [
      "DIRECTION GÉNÉRALE DES COLLECTIVITÉS LOCALES",
      "Sous-direction des finances locales\net de l’action économique",
      "Sous-direction des élus locaux\net de la fonction publique territoriale",
      "Sous-direction des compétences\net des institutions locales",
      "Sous-direction de la cohésion\net de l’aménagement du territoire",
      "Département des études et des statistiques locales",
    ];

    const colDSR = [
      "DÉLÉGATION À LA SÉCURITÉ ROUTIÈRE",
      "Département communication et information",
      "Sous-direction éducation routière\net permis de conduire",
      "Sous-direction protection des usagers de la route",
      "Sous-direction des actions transversales\net des ressources",
      "Département du contrôle automatisé",
      "Conservatoire national interministériel\nde la sécurité routière",
    ];

    const colDGOM = [
      "OUTRE-MER",
      "Sous-direction des politiques publiques",
      "Sous-direction des affaires juridiques\net institutionnelles",
      "Sous-direction évaluation, prospective\net dépense de l’État",
      "Commandement du service militaire adapté",
    ];

    const colDGEF = [
      "DIRECTION GÉNÉRALE DES ÉTRANGERS EN FRANCE",
      "Direction de l’immigration",
      "Direction de l’intégration\net de l’accès à la nationalité",
      "Direction de l’asile",
      "Service de la performance et des ressources",
      "Département des statistiques,\ndes études et de la documentation",
      "Direction de programme :\nAdministration numérique des étrangers en France",
      "Mission numérique",
    ];

    const footerLines = [
      "DIRECTION DE LA COOPÉRATION INTERNATIONALE DE SÉCURITÉ (DCIS)",
      "AGENCE DU NUMÉRIQUE DES FORCES DE SÉCURITÉ INTÉRIEURE",
      "SERVICE STATISTIQUE MINISTÉRIEL DE LA SÉCURITÉ INTÉRIEURE (SSMI)",
    ];

    final columns = <List<String>>[
      colDGSCGC,
      colDGPN,
      colDGGN,
      colDGSI,
      colSG,
      colDGCL,
      colDSR,
      colDGOM,
      colDGEF,
    ];

    final int maxRows = columns
        .map((c) => c.length)
        .reduce((a, b) => a > b ? a : b);

    // Construit les lignes
    final List<TableRow> rows = [];

    // ✅ Bloc haut (5 colonnes) séparé (pour rester lisible)
    Widget topHeader = Column(
      children: [
        _MiniTitle("En-tête"),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: 1100,
            child: Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,

              border: TableBorder.all(color: border, width: 1),
              columnWidths: const {
                0: FlexColumnWidth(1.2),
                1: FlexColumnWidth(1.4),
                2: FlexColumnWidth(1.4),
                3: FlexColumnWidth(1.0),
                4: FlexColumnWidth(1.2),
              },
              children: [
                TableRow(
                  children: [
                    _TableBox(text: topLine[0], bgColor: headerBg, bold: true),
                    _TableBox(text: topLine[1], bgColor: headerBg, bold: true),
                    _TableBox(text: topLine[2], bgColor: headerBg, bold: true),
                    _TableBox(text: topLine[3], bgColor: headerBg, bold: true),
                    _TableBox(text: topLine[4], bgColor: headerBg, bold: true),
                  ],
                ),
                TableRow(
                  children: [
                    _TableBox(text: topLine2[0], bgColor: cellBg),
                    _TableBox(text: topLine2[1], bgColor: cellBg),
                    _TableBox(
                      text: topLine2[2],
                      bgColor: isDark
                          ? const Color(0xFF0F2A22)
                          : const Color(0xFFEFFAF3),
                      bold: true,
                    ),
                    _TableBox(text: topLine2[3], bgColor: cellBg),
                    _TableBox(text: topLine2[4], bgColor: cellBg),
                  ],
                ),
                TableRow(
                  children: [
                    _TableBox(text: topLine3[0], bgColor: cellBg),
                    _TableBox(text: topLine3[1], bgColor: cellBg),
                    _TableBox(
                      text: topLine3[2],
                      bgColor: isDark
                          ? const Color(0xFF0F2A22)
                          : const Color(0xFFEFFAF3),
                      bold: true,
                    ),
                    _TableBox(text: topLine3[3], bgColor: cellBg),
                    _TableBox(text: topLine3[4], bgColor: cellBg),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );

    // Header row (9 colonnes)
    rows.add(
      TableRow(
        children: List.generate(headers.length, (i) {
          return _TableBox(
            text: headers[i],
            bgColor: headerBg,
            borderColor: border,
            bold: true,
            center: true,
          );
        }),
      ),
    );

    // Body
    for (int r = 0; r < maxRows; r++) {
      rows.add(
        TableRow(
          children: List.generate(columns.length, (c) {
            final col = columns[c];
            final String value = r < col.length ? col[r] : "";

            final bool isMainTitle = r == 0 && value.isNotEmpty;

            final Color bg = isMainTitle
                ? (isDark ? const Color(0xFF0F2A22) : const Color(0xFFEFFAF3))
                : cellBg;

            return _TableBox(
              text: value,
              bgColor: bg,
              borderColor: border,
              bold: isMainTitle,
              center: isMainTitle,
            );
          }),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        topHeader,
        const SizedBox(height: 14),

        _MiniTitle("Colonnes principales"),
        const SizedBox(height: 8),

        // ✅ Scroll horizontal + vertical
        SizedBox(
          height: 560,
          child: Scrollbar(
            thumbVisibility: true,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: 1500,
                child: Scrollbar(
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    child: Table(
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,

                      border: TableBorder.all(color: border, width: 1),
                      columnWidths: const {
                        0: FlexColumnWidth(1.05),
                        1: FlexColumnWidth(1.05),
                        2: FlexColumnWidth(1.05),
                        3: FlexColumnWidth(.7),
                        4: FlexColumnWidth(1.2),
                        5: FlexColumnWidth(1.0),
                        6: FlexColumnWidth(1.0),
                        7: FlexColumnWidth(1.0),
                        8: FlexColumnWidth(1.05),
                      },
                      children: rows,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        _MiniTitle("Blocs transversaux"),
        const SizedBox(height: 8),
        _FooterStrip(lines: footerLines),
      ],
    );
  }
}

///////////////////////////////////////////////////////////////////////////////
///                         CELLULE (REMPLISSAGE TOTAL)                      ///
///////////////////////////////////////////////////////////////////////////////

class _TableBox extends StatelessWidget {
  const _TableBox({
    required this.text,
    required this.bgColor,
    this.borderColor = Colors.black12,
    this.bold = false,
    this.center = false,
    this.minHeight = 64, // ✅ règle visuelle : hauteur uniforme
  });

  final String text;
  final Color bgColor;
  final Color borderColor;
  final bool bold;
  final bool center;
  final double minHeight;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: minHeight),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(color: borderColor, width: 1),
        ),
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        alignment: center ? Alignment.center : Alignment.centerLeft,
        child: Text(
          text,
          textAlign: center ? TextAlign.center : TextAlign.left,
          style: GoogleFonts.fustat(
            fontSize: bold ? 13.1 : 12.7,
            height: 1.2,
            fontWeight: bold ? FontWeight.w900 : FontWeight.w600,
            color: isDark ? Colors.white : const Color(0xFF111827),
          ),
        ),
      ),
    );
  }
}

class _MiniTitle extends StatelessWidget {
  const _MiniTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Text(
      text,
      style: GoogleFonts.fustat(
        fontWeight: FontWeight.w900,
        fontSize: 15.5,
        color: isDark ? Colors.white : const Color(0xFF0D47A1),
      ),
    );
  }
}

class _FooterStrip extends StatelessWidget {
  const _FooterStrip({required this.lines});

  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF1B1B1B) : const Color(0xFFF3F4F6);
    final Color border = isDark ? Colors.white24 : Colors.black12;
    final Color txt = isDark ? Colors.white : const Color(0xFF111827);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
      ),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Structures associées",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 14.5,
              color: txt,
            ),
          ),
          const SizedBox(height: 8),
          ...lines.map(
            (t) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    size: 18,
                    color: isDark
                        ? const Color(0xFF64B5F6)
                        : const Color(0xFF1565C0),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      t,
                      style: GoogleFonts.fustat(
                        fontSize: 13.5,
                        height: 1.25,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white70 : Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

///////////////////////////////////////////////////////////////////////////////
///                                 UI BOX                                  ///
///////////////////////////////////////////////////////////////////////////////

class _CardBox extends StatelessWidget {
  const _CardBox({
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
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: accent.withValues(alpha: .22), width: 0.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .10),
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
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: isDark ? const Color(0xFF64B5F6) : const Color(0xFF1565C0),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.fustat(
              fontSize: 13.5,
              height: 1.3,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
        ),
      ],
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
