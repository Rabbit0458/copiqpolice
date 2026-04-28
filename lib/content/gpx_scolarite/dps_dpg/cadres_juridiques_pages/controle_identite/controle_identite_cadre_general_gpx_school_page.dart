import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ConntroleIdentiteCadreGpxSchool extends StatelessWidget {
  const ConntroleIdentiteCadreGpxSchool({super.key});

  static const String routeName =
      '/gpx/cadres_juridiques/controle_identite/chapitre1/cadre_general';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);
    final Color textSoft = isDark
        ? Colors.white70
        : const Color(0xFF222222).withOpacity(.72);

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
          'Cadre général du contrôle',
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
            'Cadre général du contrôle d’identité',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              color: textMain,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Personnes concernées, autorités habilitées, distinction entre les différents '
            'cas dans lesquels le policier peut procéder à un contrôle d’identité en '
            'matière de police judiciaire.',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w500,
              fontSize: 13.5,
              height: 1.35,
              color: textSoft,
            ),
          ),
          const SizedBox(height: 18),

          // ===================== 1.1 CADRE GÉNÉRAL DU CONTRÔLE =============
          _ConditionCard(
            title: '1.1 – Cadre général du contrôle',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: [
              const _SubTitle('1.1.1 – Les personnes concernées'),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Le contrôle d’identité vise toute personne qui se trouve sur le territoire '
                      'national. Tel est le principe énoncé par l’article ',
                ),
                TextSpan(
                  text: '78-1 du code de procédure pénale',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: articleColor,
                  ),
                ),
                const TextSpan(
                  text:
                      '. L’identité d’un ressortissant étranger peut donc être contrôlée dans les '
                      'mêmes conditions que celle d’un citoyen français.',
                ),
              ]),
              const SizedBox(height: 10),
              const _SubTitle(
                '1.1.2 – Les autorités habilitées à procéder à un contrôle',
              ),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Seuls les officiers de police judiciaire et, sur l’ordre et sous la responsabilité '
                      'de ceux-ci, les agents de police judiciaire et certains agents de police '
                      'judiciaire adjoints visés à l’article 21, 1° du ',
                ),
                TextSpan(
                  text: 'code de procédure pénale',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: articleColor,
                  ),
                ),
                const TextSpan(
                  text:
                      ', sont habilités à procéder à des contrôles d’identité. '
                      'Sont donc exclus les volontaires servant en qualité de militaire dans la '
                      'gendarmerie et les militaires servant au titre de la réserve opérationnelle '
                      'de la gendarmerie, les agents de police municipale (article 21, 2°), les '
                      'policiers adjoints et les membres de la réserve opérationnelle de la police '
                      'nationale (article 21, 1° ter), ainsi que les fonctionnaires et agents chargés '
                      'de certaines fonctions de police judiciaire dans des domaines très '
                      'spécifiques : agents des eaux et forêts, gardes champêtres, gardes '
                      'particuliers, conformément aux articles 22 à 29 du ',
                ),
                TextSpan(
                  text: 'code de procédure pénale',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: articleColor,
                  ),
                ),
                const TextSpan(text: '.'),
              ]),
              const SizedBox(height: 10),
              const _Paragraph(
                'L’exigence « sur l’ordre » énoncée à l’article 78-2 du code de procédure pénale '
                'ne signifie pas que l’agent de police judiciaire ou l’agent de police judiciaire '
                'adjoint soit dans l’obligation de solliciter systématiquement une autorisation '
                'préalable d’un officier de police judiciaire. Cette formule rappelle leur mission : '
                'seconder les officiers de police judiciaire dans l’exercice de leurs fonctions et '
                'agir sous leurs ordres. En revanche, la mention « sur l’ordre et sous la '
                'responsabilité de l’officier de police judiciaire » doit obligatoirement figurer, à '
                'peine de nullité du contrôle, sur le rapport ou sur le procès-verbal établi.',
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        'Pour les agents de police judiciaire adjoints, se reporter au chapitre 2 '
                        'consacré au relevé d’identité.',
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),

          // ===================== 1.2 CAS OÙ LE POLICIER PEUT CONTRÔLER =====
          _ConditionCard(
            title:
                '1.2 – Cas dans lesquels le policier peut procéder à un contrôle d’identité',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: [
              const _Paragraph(
                'Selon les termes de l’article 78-2 du code de procédure pénale, il convient de '
                'distinguer les contrôles qui se pratiquent en matière de police judiciaire et '
                'ceux qui interviennent dans des situations de police administrative visant à '
                'prévenir les atteintes à la sécurité des personnes et des biens.',
              ),
              const SizedBox(height: 10),
              const _SubTitle(
                '1.2.1 – Les contrôles relevant de la police judiciaire',
              ),
              const _Paragraph(
                'Le premier alinéa de l’article 78-2 du code de procédure pénale fixe le régime '
                'des contrôles effectués sur la seule initiative des policiers.',
              ),
              const SizedBox(height: 6),
              const _SubTitle(
                '1.2.1.1 – Les contrôles de police judiciaire effectués à la seule initiative des policiers',
              ),
              const _Paragraph(
                'Le contrôle d’identité d’une personne est possible lorsqu’il existe une ou '
                'plusieurs raisons plausibles de soupçonner qu’elle se trouve dans l’un des cinq '
                'cas expressément prévus. Ces raisons plausibles doivent être matérialisées par '
                'les agissements de l’intéressé, son comportement et sa façon d’être dans un '
                'certain contexte (fuite devant les policiers, passages répétés de nuit devant la '
                'vitrine d’une bijouterie, attitude laissant présumer l’usage de stupéfiants, '
                'dissimulation d’un sac à la vue des policiers, etc.).',
              ),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    'La personne a commis ou tenté de commettre une infraction (article 78-2 '
                    'alinéa 2 du code de procédure pénale), qu’il s’agisse d’un crime, d’un délit '
                    'ou d’une contravention.',
              ),
              const _BulletPoint(
                text:
                    'Elle se prépare à commettre un crime ou un délit (article 78-2 alinéa 3 du '
                    'code de procédure pénale). Le contrôle est alors possible dès la phase des '
                    'actes préparatoires, même si ceux-ci ne suffisent pas à caractériser une '
                    'tentative punissable.',
              ),
              const _BulletPoint(
                text:
                    'Elle est susceptible de fournir des renseignements utiles à l’enquête en cas '
                    'de crime ou de délit (article 78-2 alinéa 4 du code de procédure pénale).',
              ),
              const _BulletPoint(
                text:
                    'Elle a violé les obligations ou interdictions auxquelles elle est soumise dans '
                    'le cadre d’un contrôle judiciaire, d’une mesure d’assignation à résidence '
                    'avec surveillance électronique, d’une peine ou d’une mesure suivie par le '
                    'juge de l’application des peines (article 78-2 alinéa 5 du code de procédure '
                    'pénale).',
              ),
              const _BulletPoint(
                text:
                    'Elle fait l’objet de recherches ordonnées par une autorité judiciaire '
                    '(article 78-2 alinéa 6 du code de procédure pénale), notamment sur la base '
                    'de mandats ou décisions émanant du parquet, d’une juridiction d’instruction '
                    'ou de jugement ou du juge des enfants.',
              ),
              const SizedBox(height: 8),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        'Les contrôles d’identité peuvent également être mis en œuvre lorsque des '
                        'recherches sont ordonnées par les officiers de police judiciaire au cours '
                        'de leurs enquêtes à l’égard de personnes soupçonnées d’infraction ou '
                        'susceptibles de fournir des renseignements utiles à l’enquête.',
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const _SubTitle(
                '1.2.1.2 – Les contrôles effectués sur réquisitions du procureur de la République',
              ),
              const _Paragraph(
                'Pour réaliser ce type de contrôle, plusieurs conditions doivent être respectées.',
              ),
              const SizedBox(height: 6),
              const _BulletPoint(
                text:
                    'Le procureur de la République doit donner des réquisitions écrites qui '
                    'précisent les infractions à rechercher, afin d’éviter que le contrôle ne soit '
                    'déclenché de façon aléatoire.',
              ),
              const _BulletPoint(
                text:
                    'Les réquisitions sont en général prises à la suite de constatations '
                    'd’infractions répétées ou à partir de renseignements laissant supposer que '
                    'la commission de ces infractions est probable (trafic de stupéfiants, recel, '
                    'proxénétisme, infractions à la législation sur l’entrée et le séjour des '
                    'étrangers, etc.).',
              ),
              const _BulletPoint(
                text:
                    'Les contrôles doivent être effectués dans des lieux et sur une période de '
                    'temps déterminés par le magistrat, ce qui implique un périmètre précis et '
                    'des horaires de début et de fin de l’opération.',
              ),
              const _BulletPoint(
                text:
                    'Les contrôles s’appuient sur une concertation parquet-police : le procureur '
                    'de la République décide de l’opportunité de l’opération, mais la définition '
                    'concrète des lieux, des périodes et des moyens se fait en lien étroit avec '
                    'les services de police.',
              ),
              const _BulletPoint(
                text:
                    'Les contrôles visent « toute personne » présente dans le périmètre et sur la '
                    'durée fixés par les réquisitions. En pratique, le policier doit veiller à éviter '
                    'toute méthode de sélection pouvant apparaître comme discriminatoire et '
                    'adapter le contrôle aux infractions recherchées.',
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
