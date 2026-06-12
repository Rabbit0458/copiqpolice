import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaReglesDerogatoiresCriminaliteOrganiseePage extends StatelessWidget {
  const PaReglesDerogatoiresCriminaliteOrganiseePage({super.key});

  static const String routeName =
      '/pa/dps_dpg/cadres_juridiques/criminalite_organisee/regles_derogatoires';

  TextSpan _lawArticle(String text) {
    return TextSpan(
      text: text,
      style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color cardColor = isDark ? const Color(0xFF121212) : Colors.white;
    final Color accent = isDark
? const Color(0xFF64B5F6)
: const Color(0xFF1565C0);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF0D47A1);

    return Scaffold(
      appBar: AppBar(title: const Text('Règles procédurales dérogatoires')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SubTitle(
                'Les règles procédurales dérogatoires au droit commun',
              ),
              const SizedBox(height: 4),
              const _Paragraph(
                'Le champ d\'application de la criminalité organisée étant clairement défini, '
                'la mise en œuvre d\'instruments procéduraux spécifiques doit renforcer l\'efficacité '
                'de la lutte contre cette forme particulière de délinquance. Nous examinerons les '
                'aspects procéduraux spécifiques applicables à chacun des trois cadres juridiques '
                'd\'enquêtes.',
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        'Certaines des techniques spéciales d\'enquête applicables à la criminalité organisée '
                        'peuvent également être mises en œuvre, sous conditions, dans le cadre de la procédure '
                        'de l\'article ',
                  ),
                  _lawArticle('74-2'),
                  const TextSpan(
                    text:
                        ' du Code de procédure pénale (voir « La recherche des personnes en fuite »).',
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // 2.1 – Procédure de flagrant délit
              _ConditionCard(
                title:
                    '2.1 – La procédure de flagrant délit relative à la criminalité organisée',
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: [
                  // 2.1.1
                  const _SubTitle('2.1.1 – La géolocalisation en temps réel'),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'La géolocalisation en temps réel est encadrée par les articles ',
                    ),
                    _lawArticle('230-32 à 230-44'),
                    const TextSpan(
                      text:
                          ' du Code de procédure pénale. Comme en matière de droit commun, des réquisitions '
                          'peuvent être établies dans le but de suivre à tout moment et à son insu les déplacements '
                          'd\'une personne, d\'un véhicule ou d\'un objet qu\'elle détient. Il peut s\'agir du suivi '
                          'dynamique d\'un terminal de télécommunication ou de l\'utilisation d\'un dispositif dédié '
                          'de géolocalisation (balise).',
                    ),
                  ]),
                  const SizedBox(height: 8),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Des dispositions spécifiques sont applicables lorsque l\'enquête porte sur une infraction '
                          'mentionnée aux articles ',
                    ),
                    _lawArticle('706-73'),
                    const TextSpan(text: ' ou '),
                    _lawArticle('706-73-1'),
                    const TextSpan(text: ' du Code de procédure pénale :'),
                  ]),
                  const SizedBox(height: 6),
                  const _BulletPoint(
                    text:
                        'L’autorisation initiale est délivrée par le procureur de la République pour une durée '
                        'maximale de quinze jours consécutifs ;',
                  ),
                  const _BulletPoint(
                    text:
                        'La durée totale de la géolocalisation peut aller jusqu’à deux ans.',
                  ),

                  const SizedBox(height: 16),

                  // 2.1.2
                  const _SubTitle('2.1.2 – La surveillance'),
                  const _Paragraph(
                    'Le dispositif de surveillance vise à concilier la célérité dans la prise de décision des '
                    'enquêteurs en matière d\'investigation, tout en maintenant les prérogatives de direction de la '
                    'police judiciaire reconnues au procureur de la République.',
                  ),
                  const SizedBox(height: 10),

                  // 2.1.2.1
                  const _SubTitle('2.1.2.1 – Le champ d’application'),
                  _Paragraph.rich([
                    const TextSpan(text: 'L’article '),
                    _lawArticle('706-80'),
                    const TextSpan(
                      text:
                          ' du Code de procédure pénale prévoit que les officiers de police judiciaire et, sous leur '
                          'autorité, les agents de police judiciaire, peuvent étendre à l\'ensemble du territoire national '
                          'la surveillance :',
                    ),
                  ]),
                  const SizedBox(height: 6),
                  const _BulletPoint(
                    text:
                        'Des personnes, lorsqu’il existe une ou plusieurs raisons plausibles de soupçonner qu’elles '
                        'ont commis l’un des crimes ou délits relevant de la criminalité organisée entrant dans le champ '
                        'd’application des articles 706-73, 706-73-1 ou 706-74 du Code de procédure pénale ;',
                  ),
                  const _BulletPoint(
                    text:
                        'De l’acheminement ou du transport des objets, biens ou produits tirés de la commission de ces '
                        'infractions ou servant à les commettre.',
                  ),
                  const SizedBox(height: 12),

                  // 2.1.2.2
                  const _SubTitle(
                    '2.1.2.2 – Les modalités de mise en œuvre des opérations de surveillance',
                  ),
                  const _Paragraph(
                    'Les enquêteurs peuvent étendre leurs opérations de surveillance à l’ensemble du territoire national. '
                    'Préalablement à cette éventuelle extension de compétence, le procureur de la République saisi des faits '
                    'doit en être informé, tout comme le procureur de la République près le tribunal judiciaire dans le ressort '
                    'duquel les opérations de surveillance sont susceptibles de débuter. Cette information doit être donnée '
                    '« par tout moyen ». Le procureur de la République peut s’opposer à l’extension de l’opération de surveillance.',
                  ),
                  const SizedBox(height: 10),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Dans le cadre de ces opérations de surveillance, lorsque les nécessités de l’enquête l’exigent, '
                          'les officiers de police judiciaire et, sous leur autorité, les agents de police judiciaire chargés des '
                          'investigations peuvent demander à tout fonctionnaire ou agent public de ne pas procéder au contrôle, '
                          'à l’interpellation de ces personnes, ni à la saisie de ces objets, biens ou produits, afin de ne pas '
                          'compromettre la poursuite des investigations. Cette demande ne peut toutefois intervenir qu’avec '
                          'l’autorisation du procureur de la République chargé de l’enquête (article ',
                    ),
                    _lawArticle('706-80-1'),
                    const TextSpan(text: ' du Code de procédure pénale).'),
                  ]),
                  const SizedBox(height: 8),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Dans les mêmes conditions, les officiers de police judiciaire et, sous leur autorité, les agents de '
                          'police judiciaire peuvent également livrer ou délivrer, à la place des prestataires de services postaux '
                          'et des opérateurs de fret, ces objets, biens ou produits, sans être pénalement responsables. '
                          'L’autorisation du procureur de la République doit alors être écrite et motivée (article ',
                    ),
                    _lawArticle('706-80-2'),
                    const TextSpan(text: ' du Code de procédure pénale).'),
                  ]),
                  const SizedBox(height: 8),
                  _NotaBox(
                    bodySpans: [
                      const TextSpan(
                        text:
                            'La poursuite des opérations de surveillance dans un État étranger peut être autorisée en application de l’article ',
                      ),
                      _lawArticle('694-6'),
                      const TextSpan(text: ' du Code de procédure pénale.'),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // 2.1.3
                  const _SubTitle('2.1.3 – L’infiltration'),

                  // 2.1.3.1 – Principe
                  const _SubTitle('2.1.3.1 – Le principe'),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'L’officier de police judiciaire (ou un agent de police judiciaire) surveille les personnes suspectées '
                          'de commettre un crime ou un délit en se faisant passer, auprès de ces personnes, pour l’un de leurs '
                          'coauteurs, complices ou receleurs, ou comme une victime, un tiers mandaté par cette dernière, ou toute '
                          'personne intéressée à la commission de l’infraction (article ',
                    ),
                    _lawArticle('706-81'),
                    const TextSpan(
                      text:
                          ' du Code de procédure pénale). L’objectif poursuivi est de révéler une infraction liée à la criminalité '
                          'organisée et d’en identifier les membres.',
                    ),
                  ]),
                  const SizedBox(height: 8),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'L’infiltration ne peut être mise en œuvre que dans le cadre d’une enquête portant sur l’un des crimes ou '
                          'délits prévus par les articles ',
                    ),
                    _lawArticle('706-73'),
                    const TextSpan(text: ' et '),
                    _lawArticle('706-73-1'),
                    const TextSpan(
                      text:
                          ' du Code de procédure pénale. Un officier de police judiciaire coordonne l’opération d’infiltration ; '
                          'les agents infiltrés opèrent sous sa responsabilité.',
                    ),
                  ]),
                  const SizedBox(height: 8),
                  const _Paragraph(
                    'À peine de nullité, les actes réalisés par l’agent durant sa mission d’infiltration ne peuvent constituer une '
                    'incitation ayant déterminé la commission d’infractions. À l’exception du cas où l’agent infiltré dépose sous '
                    'sa véritable identité, aucune condamnation ne peut être prononcée sur le seul fondement des déclarations '
                    'faites par l’officier de police judiciaire ou l’agent de police judiciaire ayant procédé à une opération '
                    'd’infiltration.',
                  ),

                  const SizedBox(height: 14),

                  // 2.1.3.2 – Modalités de mise en œuvre
                  const _SubTitle('2.1.3.2 – Les modalités de mise en œuvre'),

                  // 2.1.3.2.1
                  const _SubTitle(
                    '2.1.3.2.1 – L’autorisation préalable du magistrat',
                  ),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'À peine de nullité, l’opération d’infiltration doit être autorisée par le procureur de la République. '
                          'Elle doit être justifiée par les nécessités de l’enquête (ou de l’instruction). Cette autorisation est '
                          'délivrée par écrit et doit être spécialement motivée. Cette décision doit mentionner la ou les '
                          'infractions qui justifient le recours à cette procédure et l’identité de l’officier de police judiciaire '
                          'sous la responsabilité duquel se déroule l’opération (articles ',
                    ),
                    _lawArticle('706-81'),
                    const TextSpan(text: ' et '),
                    _lawArticle('706-83'),
                    const TextSpan(text: ' du Code de procédure pénale).'),
                  ]),
                  const SizedBox(height: 8),
                  const _Paragraph(
                    'Elle fixe la durée de l’infiltration, qui ne peut excéder quatre mois, renouvelable dans les mêmes conditions '
                    'de forme et de durée. Le magistrat peut, à tout moment, ordonner l’interruption de l’infiltration, avant '
                    'l’expiration de la durée fixée. L’autorisation est versée au dossier de la procédure après l’achèvement de '
                    'l’opération d’infiltration.',
                  ),

                  const SizedBox(height: 12),

                  // 2.1.3.2.2 – Actes d’infiltration
                  const _SubTitle('2.1.3.2.2 – Les actes d’infiltration'),
                  const _Paragraph(
                    'L’opération d’infiltration est réalisée par un officier de police judiciaire ou un agent de police judiciaire '
                    'spécialement habilité par le procureur général près la cour d’appel de Paris dans les conditions prévues '
                    'par le décret n° 2004-1026 du 29 septembre 2004. Il agit sous la responsabilité d’un officier de police '
                    'judiciaire chargé de coordonner l’opération.',
                  ),
                  const SizedBox(height: 8),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Les officiers ou agents de police judiciaire autorisés à procéder à une opération d’infiltration peuvent, '
                          'sans être pénalement responsables, sur l’ensemble du territoire national (article ',
                    ),
                    _lawArticle('706-82'),
                    const TextSpan(text: ' du Code de procédure pénale) :'),
                  ]),
                  const SizedBox(height: 6),
                  const _BulletPoint(
                    text:
                        'Acquérir, détenir, transporter, livrer ou délivrer des substances, biens, produits, documents ou '
                        'informations tirés de la commission des infractions ou servant à la commission de ces infractions ;',
                  ),
                  const _BulletPoint(
                    text:
                        'Utiliser ou mettre à disposition des personnes se livrant à ces infractions des moyens de caractère '
                        'juridique ou financier ainsi que des moyens de transport, de dépôt, d’hébergement, de conservation '
                        'et de télécommunications.',
                  ),

                  const SizedBox(height: 14),

                  // 2.1.3.2.3 – Protection des agents infiltrés
                  const _SubTitle(
                    '2.1.3.2.3 – La protection des agents infiltrés',
                  ),
                  const _SubTitle(
                    '2.1.3.2.3.1 – La protection personnelle de l’agent infiltré',
                  ),
                  const _Paragraph(
                    'L’officier de police judiciaire (ou l’agent de police judiciaire) est autorisé à faire usage d’une identité '
                    'd’emprunt, y compris en utilisant un dispositif permettant d’altérer ou de transformer sa voix ou son '
                    'apparence physique. L’identité réelle des enquêteurs infiltrés ne doit apparaître à aucun stade de la procédure.',
                  ),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'La révélation de cette identité d’emprunt est érigée en infraction pénale (cinq ans d’emprisonnement '
                          'et 75 000 € d’amende). Les peines sont aggravées lorsque la révélation a entraîné des violences, coups '
                          'et blessures à l’encontre de l’agent infiltré, de ses conjoints, enfants ou ascendants directs, ou leur '
                          'mort (article ',
                    ),
                    _lawArticle('706-84'),
                    const TextSpan(text: ' du Code de procédure pénale).'),
                  ]),
                  const SizedBox(height: 8),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'L’enquêteur infiltré est exonéré de toute responsabilité pénale lorsqu’il accomplit les actes de '
                          'l’opération d’infiltration. Cette exonération bénéficie également à toute personne requise par l’agent '
                          'infiltré pour la réalisation de sa mission (article ',
                    ),
                    _lawArticle('706-82'),
                    const TextSpan(text: ' du Code de procédure pénale).'),
                  ]),
                  const SizedBox(height: 8),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Lorsque l’opération d’infiltration est terminée (décision d’interruption ou terme du délai fixé), '
                          'l’agent infiltré a la possibilité de continuer ses activités, sans être pénalement responsable, pendant '
                          'le temps strictement nécessaire pour assurer sa sortie du réseau criminel en toute sécurité. Le délai ne '
                          'peut excéder quatre mois. Le magistrat ayant autorisé l’infiltration en est informé dans les meilleurs '
                          'délais. Si ce délai n’est pas suffisant, sur autorisation expresse du magistrat, l’agent peut prolonger '
                          'ses activités pour une durée qui ne peut excéder quatre mois supplémentaires (article ',
                    ),
                    _lawArticle('706-85'),
                    const TextSpan(text: ' du Code de procédure pénale).'),
                  ]),

                  const SizedBox(height: 12),

                  // 2.1.3.2.3.2 – Protection procédurale
                  const _SubTitle(
                    '2.1.3.2.3.2 – La protection procédurale de l’agent infiltré',
                  ),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'L’officier de police judiciaire coordonnateur, sous la responsabilité duquel se déroule l’opération, '
                          'rédige le rapport qui comprend les éléments strictement nécessaires à la constatation des infractions '
                          'et ne mettant pas en danger la sécurité de l’agent infiltré ou des personnes requises pour l’assister '
                          '(article ',
                    ),
                    _lawArticle('706-81'),
                    const TextSpan(text: ' du Code de procédure pénale).'),
                  ]),
                  const SizedBox(height: 8),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'En principe, seul l’officier de police judiciaire ayant coordonné l’enquête peut être entendu en qualité '
                          'de témoin sur l’opération. Toutefois, en cas de mise en cause fondée directement sur les constatations '
                          'de l’agent infiltré, la personne comparaissant devant la juridiction de jugement (ou mise en examen) peut '
                          'demander à être confrontée avec l’agent. Les questions posées durant la confrontation ne doivent en aucun '
                          'cas remettre en cause l’anonymat de l’agent. La confrontation doit se dérouler dans les conditions prévues '
                          'par l’article ',
                    ),
                    _lawArticle('706-61'),
                    const TextSpan(
                      text:
                          ' du Code de procédure pénale : l’anonymat de l’agent est préservé par tout moyen (audition à distance, '
                          'utilisation de dispositifs techniques permettant l’altération ou la transformation de sa voix ou de son '
                          'apparence physique).',
                    ),
                  ]),
                ],
              ),
            ],
          ),
        ),
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
