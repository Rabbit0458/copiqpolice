import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PPAutoritesInvestiesPJOccasionnellesPage extends StatelessWidget {
  const PPAutoritesInvestiesPJOccasionnellesPage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/procédure_pénale_pages/pp_autorites_investies_pj_occasionnelles';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color textMain = isDark
        ? Colors.white
        : const Color(0xFF0D47A1); // bleu principal
    final Color textSoft = isDark
        ? Colors.white70
        : const Color(0xFF1F1F1F).withOpacity(.88);
    final Color accent = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    final Color cardColor = isDark ? const Color(0xFF111317) : Colors.white;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mission occasionnelle de police judiciaire',
          style: GoogleFonts.fustat(fontWeight: FontWeight.w700),
        ),
        elevation: 1,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 26),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ====================== TITRE PRINCIPAL =======================
              Text(
                'Chapitre 2 – Les autorités investies d’une\nmission occasionnelle de police judiciaire',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w900,
                  fontSize: 21,
                  height: 1.15,
                  color: textMain,
                ),
              ),
              const SizedBox(height: 8),

              _Paragraph.rich([
                const TextSpan(
                  text:
                      'En dehors des officiers, agents et assistants d’enquête dont l’activité de police judiciaire est habituelle, '
                      'la loi investit certains magistrats de fonctions de police judiciaire. Il s’agit principalement du procureur de la République '
                      'et du juge d’instruction. Leur mission de police judiciaire est dite occasionnelle : ils interviennent de façon directe ou par délégation, '
                      'mais confient la plupart du temps l’exécution matérielle des actes aux officiers de police judiciaire.',
                ),
              ]),

              const SizedBox(height: 18),

              // ==================== 2.1 PROCUREUR ===========================
              _ConditionCard(
                title:
                    '2.1 Les pouvoirs personnels du procureur de la République',
                cardColor: cardColor,
                accent: accent,
                titleColor: textMain,
                children: [
                  const _SubTitle(
                    '2.1.1 Le procureur de la République, autorité de police judiciaire',
                  ),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Même s’il ne figure pas sur la liste des officiers de police judiciaire, le procureur de la République possède, dans l’exercice de ses fonctions, '
                          'tous les pouvoirs et prérogatives attachés à la qualité d’officier de police judiciaire. Cette règle résulte de ',
                    ),
                    TextSpan(
                      text: 'l’Article 41 alinéa 5 du Code de Procédure Pénale',
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const TextSpan(
                      text:
                          ', qui lui reconnaît notamment la faculté de requérir directement la force publique. '
                          'En revanche, il ne peut pas recevoir délégation d’un juge d’instruction pour l’exécution d’une commission rogatoire.',
                    ),
                  ]),
                  const SizedBox(height: 10),

                  const _SubTitle(
                    '2.1.2 Prévention de la délinquance et animation locale',
                  ),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Le procureur de la République est expressément chargé de veiller à la prévention de la délinquance par ',
                    ),
                    TextSpan(
                      text: 'l’Article 39-2 du Code de Procédure Pénale',
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const TextSpan(text: '. Cette mission s’exerce :'),
                  ]),
                  const SizedBox(height: 6),
                  const _BulletPoint(
                    text:
                        'Par l’usage de toutes ses attributions : alternatives aux poursuites, mise en mouvement et exercice de l’action publique, '
                        'direction de la police judiciaire, contrôles d’identité et exécution des peines.',
                  ),
                  const _BulletPoint(
                    text:
                        'Par la prise de réquisitions aux fins de recherche et de poursuite d’infractions permettant, par exemple, '
                        'd’autoriser des contrôles d’identité dans le cadre de l’Article 78-2 du Code de Procédure Pénale (réquisitions de contrôles ciblés).',
                  ),
                  const _BulletPoint(
                    text:
                        'Par un rôle d’animateur et de coordinateur des actions de prévention dans le ressort du tribunal judiciaire, '
                        'en lien avec le préfet, les collectivités et les partenaires institutionnels.',
                  ),
                  const SizedBox(height: 10),

                  const _SubTitle('2.1.3 Direction de la police judiciaire'),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Le procureur de la République dirige l’activité de la police judiciaire. '
                          'Selon ',
                    ),
                    TextSpan(
                      text: 'l’Article 39-3 du Code de Procédure Pénale',
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const TextSpan(
                      text:
                          ', il peut adresser aux enquêteurs des instructions générales ou particulières, '
                          'contrôler la légalité des moyens employés, la proportionnalité des actes d’investigation, l’orientation donnée à l’enquête '
                          'et la qualité des investigations menées.',
                    ),
                  ]),
                  const SizedBox(height: 6),
                  const _Paragraph(
                    'Il veille également à ce que les investigations tendent à la manifestation de la vérité, '
                    'qu’elles soient accomplies à charge et à décharge et qu’elles respectent les droits de la victime, du plaignant et de la personne suspectée.',
                  ),
                  const SizedBox(height: 6),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Le procureur de la République près le tribunal judiciaire dont relève la direction départementale ou interdépartementale de la police nationale '
                          'adresse chaque année à l’autorité investie du pouvoir de nomination une évaluation littérale de l’action du directeur en matière de police judiciaire, '
                          'conformément à ',
                    ),
                    TextSpan(
                      text: 'l’Article R 2-17-1 du Code de Procédure Pénale',
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const TextSpan(
                      text:
                          '. Cette appréciation est prise en compte dans l’évaluation générale du directeur.',
                    ),
                  ]),

                  const SizedBox(height: 10),

                  const _SubTitle('2.1.4 Compétence territoriale du procureur'),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'La compétence territoriale du procureur de la République est définie par ',
                    ),
                    TextSpan(
                      text: 'l’Article 43 du Code de Procédure Pénale',
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const TextSpan(
                      text:
                          '. Sont compétents : le procureur du lieu de l’infraction, celui de la résidence de l’une des personnes soupçonnées, '
                          'celui du lieu de l’arrestation ou du lieu de détention de l’une de ces personnes, même si ces dernières résultent d’une autre cause.',
                    ),
                  ]),
                  const SizedBox(height: 6),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Pour les infractions commises au moyen d’un réseau de communication électronique, la compétence est également reconnue au procureur de la République '
                          'du lieu de résidence ou du siège des personnes physiques ou morales visées par ',
                    ),
                    TextSpan(
                      text: 'l’Article 113-2-1 du Code pénal',
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const TextSpan(text: '.'),
                  ]),
                  const SizedBox(height: 6),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'En flagrant délit, le procureur de la République peut se transporter dans les ressorts des tribunaux limitrophes de celui où il exerce ses fonctions. '
                          'Il doit alors aviser le procureur du ressort dans lequel il se déplace et mentionner, dans son procès-verbal, les motifs de ce transport, conformément à ',
                    ),
                    TextSpan(
                      text: 'l’Article 69 du Code de Procédure Pénale',
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const TextSpan(text: '.'),
                  ]),
                ],
              ),

              const SizedBox(height: 22),

              // ==================== 2.2 JUGE D'INSTRUCTION ==================
              _ConditionCard(
                title: '2.2 Les pouvoirs personnels du juge d’instruction',
                cardColor: cardColor,
                accent: accent,
                titleColor: textMain,
                children: [
                  const _SubTitle(
                    '2.2.1 Direction de l’information judiciaire',
                  ),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Lorsque l’information est ouverte, le juge d’instruction est le maître de l’information. '
                          'La police judiciaire exécute les délégations des juridictions d’instruction, et les officiers de police judiciaire exercent les pouvoirs que le juge leur délègue par commission rogatoire. '
                          'Cette direction de l’action des officiers de police judiciaire découle des règles posées notamment par ',
                    ),
                    TextSpan(
                      text: 'l’Article D 33 du Code de Procédure Pénale',
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const TextSpan(
                      text:
                          ', qui prévoit que lorsqu’une commission rogatoire est adressée à un officier de police judiciaire, chef de service, celui-ci peut en faire assurer l’exécution par un officier de police judiciaire placé sous son autorité.',
                    ),
                  ]),
                  const SizedBox(height: 8),
                  const _Paragraph(
                    'Le juge d’instruction dirige donc l’exécution des actes prescrits par la commission rogatoire. '
                    'Cette autorité n’a pas un caractère permanent comme celle du procureur de la République : elle est limitée à la durée d’exécution de la commission rogatoire. '
                    'Pendant cette période, toutefois, le pouvoir de direction du procureur de la République est écarté au profit de celui du juge d’instruction.',
                  ),
                  const SizedBox(height: 8),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'En outre, il peut, pour diriger et contrôler l’exécution de la commission rogatoire, se transporter sur les lieux sans être assisté de son greffier, '
                          'dès lors qu’il ne procède pas lui-même à des actes d’instruction. '
                          'À cette occasion, il peut ordonner la prolongation des gardes à vue décidées dans le cadre de la commission rogatoire, conformément à ',
                    ),
                    TextSpan(
                      text: 'l’Article 152 du Code de Procédure Pénale',
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const TextSpan(text: '.'),
                  ]),

                  const SizedBox(height: 12),

                  const _SubTitle(
                    '2.2.2 Compétence territoriale du juge d’instruction',
                  ),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'La compétence territoriale du juge d’instruction est définie sur le même modèle que celle du ministère public. '
                          'Ainsi, sont compétents : le juge d’instruction du lieu de l’infraction, celui de la résidence de l’une des personnes soupçonnées '
                          'et celui du lieu de l’arrestation ou de la détention de l’une de ces personnes. Ces règles sont prévues par ',
                    ),
                    TextSpan(
                      text: 'l’Article 52 du Code de Procédure Pénale',
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const TextSpan(text: '.'),
                  ]),
                  const SizedBox(height: 6),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Pour les infractions réalisées au moyen d’un réseau de communication électronique, la compétence peut également appartenir au juge d’instruction '
                          'du lieu de résidence ou du siège des personnes visées par ',
                    ),
                    TextSpan(
                      text: 'l’Article 113-2-1 du Code pénal',
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const TextSpan(text: '.'),
                  ]),
                  const SizedBox(height: 6),
                  _Paragraph.rich([
                    const TextSpan(text: 'Enfin, '),
                    TextSpan(
                      text: 'l’Article 93 du Code de Procédure Pénale',
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const TextSpan(
                      text:
                          ' lui accorde une extension de compétence territoriale importante : il peut se transporter, avec son greffier, sur l’ensemble du territoire national, '
                          'afin d’y procéder à tous actes d’instruction. Ce transport doit être justifié par les nécessités de l’information, donner lieu à un avis au procureur de la République de son tribunal '
                          'et à celui du tribunal dans le ressort duquel il se rend. Le motif du transport est mentionné au procès-verbal. Le procureur de la République peut l’accompagner et prendre des réquisitions à cette occasion.',
                    ),
                  ]),
                ],
              ),

              const SizedBox(height: 24),

              // ================== TABLEAU DE SYNTHÈSE =======================
              _ConditionCard(
                title:
                    'Synthèse – Autorités investies d’une mission occasionnelle de police judiciaire',
                cardColor: cardColor,
                accent: accent,
                titleColor: textMain,
                children: const [
                  _Paragraph(
                    'Le tableau ci-dessous reprend, dans l’esprit de ton support papier, les principales caractéristiques des missions occasionnelles de police judiciaire '
                    'du procureur de la République et du juge d’instruction : nature des pouvoirs, champ territorial et textes de référence.',
                  ),
                  SizedBox(height: 12),
                  _OccasionalAuthoritiesTable(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ======================================================================
//                       TABLEAU DE SYNTHÈSE
// ======================================================================

class _OccasionalAuthoritiesTable extends StatelessWidget {
  const _OccasionalAuthoritiesTable();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color headerBg = isDark
        ? const Color(0xFF1C2833)
        : const Color(0xFFE3F2FD);
    final Color headerText = isDark ? Colors.white : const Color(0xFF0D47A1);

    final TextStyle cellStyle = GoogleFonts.fustat(
      fontSize: 12,
      height: 1.3,
      fontWeight: FontWeight.w500,
      color: isDark ? Colors.white70 : const Color(0xFF1F1F1F),
    );

    TextSpan art(String label) => TextSpan(
      text: label,
      style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
    );

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: MaterialStateProperty.all<Color>(headerBg),
        columnSpacing: 18,
        dataRowMinHeight: 44,
        dataRowMaxHeight: 80,
        columns: [
          DataColumn(
            label: Text(
              'Autorité',
              style: GoogleFonts.fustat(
                fontWeight: FontWeight.w800,
                fontSize: 12.5,
                color: headerText,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Nature de la mission\nde police judiciaire',
              style: GoogleFonts.fustat(
                fontWeight: FontWeight.w800,
                fontSize: 12.5,
                color: headerText,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Compétence\nterritoriale',
              style: GoogleFonts.fustat(
                fontWeight: FontWeight.w800,
                fontSize: 12.5,
                color: headerText,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Articles de référence',
              style: GoogleFonts.fustat(
                fontWeight: FontWeight.w800,
                fontSize: 12.5,
                color: headerText,
              ),
            ),
          ),
        ],
        rows: [
          // ====================== PROCUREUR ================================
          DataRow(
            cells: [
              DataCell(
                Text(
                  'Procureur de la République',
                  style: cellStyle.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              DataCell(
                Text(
                  'Autorité de poursuite et de direction de la police judiciaire. '
                  'Dispose de tous les pouvoirs d’un officier de police judiciaire dans l’exercice de ses fonctions, '
                  'dirige les enquêtes, veille à la légalité et à la proportionnalité des actes, anime la prévention de la délinquance.',
                  style: cellStyle,
                ),
              ),
              DataCell(
                Text(
                  'Compétence du lieu de l’infraction, de la résidence, de\nl’arrestation ou de la détention de la personne soupçonnée.\n'
                  'Compétence élargie pour les infractions commises via un réseau de communication électronique.',
                  style: cellStyle,
                ),
              ),
              DataCell(
                RichText(
                  text: TextSpan(
                    style: cellStyle,
                    children: [
                      art('Article 41 alinéa 5 du Code de Procédure Pénale'),
                      const TextSpan(text: '\n'),
                      art('Article 39-2 du Code de Procédure Pénale'),
                      const TextSpan(text: '\n'),
                      art('Article 39-3 du Code de Procédure Pénale'),
                      const TextSpan(text: '\n'),
                      art('Article 43 du Code de Procédure Pénale'),
                      const TextSpan(text: '\n'),
                      art('Article 69 du Code de Procédure Pénale'),
                      const TextSpan(text: '\n'),
                      art('Article 113-2-1 du Code pénal'),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // ====================== JUGE D'INSTRUCTION ======================
          DataRow(
            cells: [
              DataCell(
                Text(
                  'Juge d’instruction',
                  style: cellStyle.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              DataCell(
                Text(
                  'Magistrat instructeur, maître de l’information judiciaire.\n'
                  'Dirige l’exécution des commissions rogatoires, contrôle l’action de la police judiciaire dans le cadre de l’information, '
                  'peut se transporter sur les lieux et prolonger des gardes à vue prononcées dans le cadre de la commission rogatoire.',
                  style: cellStyle,
                ),
              ),
              DataCell(
                Text(
                  'Compétence du lieu de l’infraction, de la résidence,\n'
                  'de l’arrestation ou de la détention de la personne mise en cause.\n'
                  'Possibilité de se transporter sur tout le territoire national pour les actes d’instruction.',
                  style: cellStyle,
                ),
              ),
              DataCell(
                RichText(
                  text: TextSpan(
                    style: cellStyle,
                    children: [
                      art('Article D 33 du Code de Procédure Pénale'),
                      const TextSpan(text: '\n'),
                      art('Article 152 du Code de Procédure Pénale'),
                      const TextSpan(text: '\n'),
                      art('Article 52 du Code de Procédure Pénale'),
                      const TextSpan(text: '\n'),
                      art('Article 113-2-1 du Code pénal'),
                      const TextSpan(text: '\n'),
                      art('Article 93 du Code de Procédure Pénale'),
                    ],
                  ),
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
