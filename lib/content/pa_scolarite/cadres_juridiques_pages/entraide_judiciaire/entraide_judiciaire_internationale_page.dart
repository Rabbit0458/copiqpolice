import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaEntraideJudiciaireInternationalePage extends StatelessWidget {
  const PaEntraideJudiciaireInternationalePage({super.key});

  static const String routeName =
      '/pa/dps_dpg/cadres_juridiques/entraide_judiciaire/entraide_internationale';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF2F2F2F) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);
    final Color accent = isDark
? const Color(0xFF64B5F6)
: const Color(0xFF1565C0);
    final Color cardColor = isDark
? const Color(0xFF424242)
: const Color(0xFFF5F7FB);
    final Color titleCardColor = isDark
        ? Colors.white
        : const Color(0xFF0D47A1);

    Color lawRed(BuildContext context) => Colors.red.shade700;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          tooltip: 'Retour',
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: textMain),
        ),
        title: Text(
          'Entraide judiciaire internationale',
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: textMain,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 24),
        children: [
          // ===============================================================
          // EN-TÊTE GÉNÉRAL
          // ===============================================================
          Text(
            'L’entraide judiciaire internationale',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w800,
              fontSize: 13.5,
              letterSpacing: 1.4,
              color: accent,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '1.4 — L’entraide judiciaire internationale',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 20,
              height: 1.2,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // ===============================================================
          // 1.4.1  EN L’ABSENCE DE CONVENTION INTERNATIONALE
          // ===============================================================
          const _SubTitle('1.4.1 — En l’absence de convention internationale'),
          const SizedBox(height: 4),

          _ConditionCard(
            title: 'Principe de la transmission indirecte',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleCardColor,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Le principe de la transmission indirecte des demandes d’entraide est posé par ',
                ),
                TextSpan(
                  text: 'l’article 694 du Code de procédure pénale',
                  style: TextStyle(
                    color: lawRed(context),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const TextSpan(text: ' :'),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    'Par l’intermédiaire du ministère de la Justice pour les demandes émanant des '
                    'autorités judiciaires françaises ; le retour des pièces d’exécution s’effectue '
                    'par la même voie.',
              ),
              const _BulletPoint(
                text:
                    'Par la voie diplomatique pour les demandes d’entraide étrangères à destination '
                    'des autorités françaises ; un avis est donné par voie diplomatique au ministère '
                    'des Affaires étrangères et le retour des pièces d’exécution se fait par la même voie.',
              ),
              const SizedBox(height: 8),
              const _Paragraph(
                'En cas d’urgence, les demandes d’entraide sollicitées par les autorités françaises '
                'ou étrangères peuvent être transmises directement aux autorités judiciaires de '
                'l’État requis compétentes pour les exécuter.',
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Les demandes d’entraide émanant des autorités judiciaires étrangères sont '
                      'exécutées par le procureur de la République ou par les officiers de police '
                      'judiciaire ou les agents de police judiciaire requis à cette fin par ce magistrat. '
                      'Elles peuvent également être exécutées par le juge d’instruction ou par des '
                      'officiers de police judiciaire agissant sur commission rogatoire dans le cadre '
                      'd’une instruction, conformément à ',
                ),
                TextSpan(
                  text: 'l’article 694-2 du Code de procédure pénale',
                  style: TextStyle(
                    color: lawRed(context),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const TextSpan(text: '.'),
              ]),
              const SizedBox(height: 12),
              const _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        'Les demandes d’entraide sont exécutées selon les règles du Code de procédure pénale français. '
                        'Les règles procédurales de l’État requérant peuvent cependant être appliquées si l’autorité '
                        'judiciaire le demande, à condition qu’elles ne réduisent pas les droits des parties ni les '
                        'garanties procédurales prévues par le Code de procédure pénale ; à défaut, la nullité est encourue.',
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),

          // ===============================================================
          // 1.4.1.1  CLAUSE DE SAUVEGARDE
          // ===============================================================
          const _SubTitle(
            '1.4.1.1 — Clause de sauvegarde de l’ordre public et des intérêts essentiels de la Nation',
          ),
          const SizedBox(height: 4),

          _ConditionCard(
            title:
                'Protection de l’ordre public et des intérêts fondamentaux de la Nation',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleCardColor,
            children: const [
              _Paragraph(
                'Lorsqu’une demande d’entraide est de nature à porter atteinte à l’ordre public '
                'ou aux intérêts essentiels de la Nation, le procureur de la République saisi de '
                'la demande, ou informé par le juge d’instruction, la transmet au procureur général, '
                'qui peut à son tour saisir le ministre de la Justice.',
              ),
              SizedBox(height: 8),
              _Paragraph(
                'Si le ministre de la Justice estime que la demande porte atteinte à l’ordre public '
                'ou aux intérêts fondamentaux de la Nation, il informe l’autorité requérante de '
                'l’impossibilité de donner suite. Cette information est également notifiée à '
                'l’autorité judiciaire française concernée et fait obstacle à l’exécution de la demande d’entraide.',
              ),
            ],
          ),
          const SizedBox(height: 18),

          // ===============================================================
          // 1.4.1.2  MOYENS D’ENTRAIDE
          // ===============================================================
          const _SubTitle('1.4.1.2 — Moyens d’entraide'),
          const SizedBox(height: 4),

          const _Paragraph(
            'Le Code de procédure pénale prévoit expressément certains moyens d’entraide, '
            'notamment l’audition à distance et les procédures de surveillance et d’infiltration '
            'sur le territoire national.',
          ),
          const SizedBox(height: 10),

          // 1.4.1.2.1 Audition à distance
          _ConditionCard(
            title: '1.4.1.2.1 — Audition à distance',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleCardColor,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Les auditions, interrogatoires et confrontations par vidéoconférence sont prévues par ',
                ),
                TextSpan(
                  text: 'l’article 694-5 du Code de procédure pénale',
                  style: TextStyle(
                    color: lawRed(context),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const TextSpan(
                  text:
                      '. Elles permettent l’exécution simultanée, sur le territoire français et à '
                      'l’étranger, des demandes d’entraide.',
                ),
              ]),
              const SizedBox(height: 8),
              const _Paragraph(
                'Lorsque ces actes sont réalisés à l’étranger à la demande des autorités françaises, '
                'les règles du Code de procédure pénale français demeurent applicables.',
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 1.4.1.2.2 Surveillance et infiltration
          _ConditionCard(
            title: '1.4.1.2.2 — Procédure de surveillance et d’infiltration',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleCardColor,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Les procédures de surveillance et d’infiltration sont prévues par ',
                ),
                TextSpan(
                  text:
                      'les articles 694-6, 694-7 et 694-8 du Code de procédure pénale',
                  style: TextStyle(
                    color: lawRed(context),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const TextSpan(text: ' :'),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    'Surveillance poursuivie dans un État étranger : elle est autorisée, dans les '
                    'conditions fixées par les conventions internationales, par le procureur de la '
                    'République chargé de l’enquête.',
              ),
              const _BulletPoint(
                text:
                    'Infiltration d’agents étrangers sur le territoire français : elle n’est possible '
                    'que pour les crimes ou délits entrant dans le champ d’application des articles '
                    '706-73 et 706-73-1 du Code de procédure pénale. Elle requiert l’accord préalable '
                    'du ministre de la Justice et l’autorisation du procureur de la République de Paris '
                    'ou du juge d’instruction. Les agents étrangers infiltrés sont placés sous la direction '
                    'd’officiers de police judiciaire français et doivent appartenir dans leur pays '
                    'd’origine à un service spécialisé.',
              ),
            ],
          ),
          const SizedBox(height: 22),

          // ===============================================================
          // 1.4.2  ENTRAIDE ENTRE LES ÉTATS MEMBRES DE L’UNION EUROPÉENNE
          // ===============================================================
          const _SubTitle(
            '1.4.2 — Entraide entre les États membres de l’Union européenne',
          ),
          const SizedBox(height: 4),

          _ConditionCard(
            title: 'Cadre juridique de la décision d’enquête européenne',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleCardColor,
            children: [
              const _Paragraph(
                'La circulaire D.A.C.G. du 16 mai 2017 présente les dispositions de '
                'l’ordonnance n° 2016-1636 du 1ᵉʳ décembre 2016 et du décret n° 2017-511 du 7 avril 2017, '
                'qui transposent la directive 2014/41/UE du Parlement européen et du Conseil du 3 avril 2014 '
                'relative à la décision d’enquête européenne en matière pénale.',
              ),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(text: 'Conformément à '),
                TextSpan(
                  text: 'l’article 694-15 du Code de procédure pénale',
                  style: TextStyle(
                    color: lawRed(context),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const TextSpan(
                  text:
                      ', au sein de l’Union européenne, toutes les demandes d’entraide judiciaire en matière '
                      'pénale tendant à l’obtention d’éléments de preuve doivent en principe être formulées sous '
                      'forme de décision d’enquête européenne, sauf exceptions précisées par la circulaire D.A.C.G. '
                      'du 16 mai 2017.',
                ),
              ]),
            ],
          ),
          const SizedBox(height: 16),

          // 1.4.2.1  DÉCISION D’ENQUÊTE EUROPÉENNE
          const _SubTitle(
            '1.4.2.1 — La décision d’enquête européenne (D.E.E.)',
          ),
          const SizedBox(height: 4),

          _ConditionCard(
            title: 'Nature et effets de la décision d’enquête européenne',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleCardColor,
            children: [
              _Paragraph.rich([
                const TextSpan(text: 'Définie par '),
                TextSpan(
                  text: 'l’article 694-16 du Code de procédure pénale',
                  style: TextStyle(
                    color: lawRed(context),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const TextSpan(
                  text:
                      ', la décision d’enquête européenne est une décision judiciaire émise par un État membre de '
                      'l’Union européenne à destination d’un autre État membre. Elle utilise des formulaires communs '
                      'et permet :',
                ),
              ]),
              const SizedBox(height: 8),
              const _IntroBullet(
                text:
                    'De réaliser, dans certains délais, sur le territoire de l’État d’exécution, des '
                    'investigations visant à obtenir, conserver ou transmettre des éléments de preuve ;',
              ),
              const _IntroBullet(
                text:
                    'D’organiser la communication d’éléments de preuve déjà recueillis ;',
              ),
              const _IntroBullet(
                text:
                    'De transférer temporairement une personne détenue afin de lui permettre de participer à des actes d’enquête.',
              ),
              const SizedBox(height: 8),
              const _Paragraph(
                'Toute décision d’enquête européenne doit être reconnue et exécutée de la même manière '
                'qu’une décision émanant d’une juridiction nationale de l’État d’exécution.',
              ),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Les décisions d’enquête européenne peuvent être émises d’office par les autorités '
                      'judiciaires mentionnées à ',
                ),
                TextSpan(
                  text: 'l’article 694-20 du Code de procédure pénale',
                  style: TextStyle(
                    color: lawRed(context),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const TextSpan(text: '.'),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Elles ne doivent toutefois pas être utilisées lorsque l’affaire relève d’une équipe '
                      'commune d’enquête, de mesures de gel de biens ou d’observation transfrontalière, ces dernières étant '
                      'régies par ',
                ),
                TextSpan(
                  text: 'l’article 694-18 du Code de procédure pénale',
                  style: TextStyle(
                    color: lawRed(context),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const TextSpan(text: '.'),
              ]),
            ],
          ),
          const SizedBox(height: 18),

          // 1.4.2.2  ÉQUIPES COMMUNES D’ENQUÊTE
          const _SubTitle('1.4.2.2 — Les équipes communes d’enquête'),
          const SizedBox(height: 4),

          _ConditionCard(
            title: 'Création et conditions des équipes communes d’enquête',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleCardColor,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'La circulaire du ministère de la Justice du 23 mars 2009 précise le régime des équipes '
                      'communes d’enquête. Il n’y a pas lieu d’émettre une décision d’enquête européenne lorsque '
                      'est mise en place une telle équipe, en application ',
                ),
                TextSpan(
                  text:
                      'des articles 695-2 et 695-3 du Code de procédure pénale',
                  style: TextStyle(
                    color: lawRed(context),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const TextSpan(text: '.'),
              ]),
              const SizedBox(height: 8),
              const _Paragraph(
                'L’autorité judiciaire compétente peut créer une équipe commune d’enquête sous réserve :',
              ),
              const SizedBox(height: 6),
              const _BulletPoint(
                text: 'De l’accord préalable du ministre de la Justice ;',
              ),
              const _BulletPoint(
                text: 'Du consentement des autres États membres concernés.',
              ),
              const SizedBox(height: 8),
              const _IntroBullet(
                text:
                    'Lorsque, dans le cadre d’une procédure française, des enquêtes complexes nécessitent la mobilisation de moyens importants et impliquent d’autres États membres ;',
              ),
              const _IntroBullet(
                text:
                    'Lorsque plusieurs États membres conduisent des enquêtes relatives à des infractions '
                    'nécessitant une action coordonnée et concertée.',
              ),
              const SizedBox(height: 8),
              const _Paragraph(
                'L’équipe commune ne peut être constituée que dans le cadre d’une procédure judiciaire '
                'préexistante (enquête préliminaire, flagrance ou information judiciaire). Elle peut être '
                'créée à l’initiative du procureur de la République, dans le cadre d’une enquête préliminaire, '
                'ou du juge d’instruction après ouverture d’une information judiciaire. L’autorité judiciaire '
                'étrangère compétente peut être un magistrat du parquet ou du siège.',
              ),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'L’Agence Eurojust, agissant par l’intermédiaire du membre national ou en tant que collège, '
                      'peut demander au procureur général de mettre en place une équipe commune d’enquête, en vertu de ',
                ),
                TextSpan(
                  text:
                      'l’article 695-5, alinéa 4, du Code de procédure pénale',
                  style: TextStyle(
                    color: lawRed(context),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const TextSpan(text: '.'),
              ]),
            ],
          ),
          const SizedBox(height: 18),

          // 1.4.2.3  MISSIONS DES AGENTS
          const _SubTitle(
            '1.4.2.3 — Mission des agents auprès des équipes communes d’enquête',
          ),
          const SizedBox(height: 4),

          _ConditionCard(
            title:
                '1.4.2.3.1 — Agents d’un État membre détachés dans l’équipe commune agissant en France',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleCardColor,
            children: const [
              _Paragraph(
                'Les agents d’un État membre détachés dans l’équipe commune agissant en France peuvent :',
              ),
              SizedBox(height: 6),
              _BulletPoint(
                text:
                    'Constater tous crimes, délits ou contraventions et en dresser procès-verbal, '
                    'au besoin dans les formes prévues par le droit de leur État ;',
              ),
              _BulletPoint(
                text:
                    'Recevoir par procès-verbal les déclarations de toute personne susceptible '
                    'd’apporter des renseignements ;',
              ),
              _BulletPoint(
                text:
                    'Assister, participer ou procéder à des auditions, à condition qu’elles se réalisent '
                    'sous la direction d’un ou plusieurs enquêteurs français ;',
              ),
              _BulletPoint(
                text:
                    'Assister l’officier de police judiciaire français dans l’exercice de ses fonctions, '
                    'sans accomplir d’acte de coercition (mise en garde à vue, contrainte à comparaître, etc.) ;',
              ),
              _BulletPoint(
                text:
                    'Procéder à des surveillances et, s’ils sont spécialement habilités, à des infiltrations.',
              ),
              SizedBox(height: 8),
              _Paragraph(
                'Ces agents n’interviennent que dans la limite de la mission qui leur a été confiée. '
                'L’original des procès-verbaux qu’ils établissent est versé à la procédure française.',
              ),
            ],
          ),
          const SizedBox(height: 16),

          _ConditionCard(
            title:
                '1.4.2.3.2 — Agents français détachés dans l’équipe commune agissant sur le territoire d’un État membre',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleCardColor,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Les officiers de police judiciaire et les agents de police judiciaire français détachés '
                      'auprès d’une équipe commune d’enquête peuvent procéder aux opérations prescrites par le '
                      'responsable d’équipe, dans la limite des pouvoirs qui leur sont conférés par le Code de '
                      'procédure pénale. Leurs missions sont définies par l’autorité de l’État sur le territoire '
                      'duquel ils interviennent, conformément à ',
                ),
                TextSpan(
                  text: 'l’article 695-3 du Code de procédure pénale',
                  style: TextStyle(
                    color: lawRed(context),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const TextSpan(text: '.'),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    'Ils peuvent recevoir des déclarations et constater les infractions dans les formes prévues '
                    'par le Code de procédure pénale de l’État d’exécution, sous réserve de l’accord de cet État ;',
              ),
              const _BulletPoint(
                text:
                    'Lorsqu’ils dressent des procès-verbaux, un exemplaire est adressé à l’autorité judiciaire '
                    'qui leur a confié l’exécution de l’enquête (procureur de la République ou juge d’instruction).',
              ),
            ],
          ),
          const SizedBox(height: 18),

          // 1.4.2.4  PRÉCISIONS PROCÉDURALES
          const _SubTitle('1.4.2.4 — Précisions procédurales'),
          const SizedBox(height: 4),

          _ConditionCard(
            title: '1.4.2.4.1 — La garde à vue',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleCardColor,
            children: const [
              _Paragraph(
                'Une garde à vue commencée sur le territoire d’un État membre cocontractant ne peut se '
                'poursuivre en France, aucun texte ne le prévoyant. La remise des personnes ne peut intervenir '
                'que dans les cadres prévus par les mécanismes de coopération judiciaire (mandat d’arrêt '
                'européen, extradition, etc.).',
              ),
              SizedBox(height: 8),
              _Paragraph(
                'À défaut de convention l’autorisant, il n’est pas possible de continuer sur un territoire '
                'étranger une garde à vue débutée en France.',
              ),
            ],
          ),
          const SizedBox(height: 12),

          _ConditionCard(
            title: '1.4.2.4.2 — La perquisition',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleCardColor,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Lorsqu’une personne est en garde à vue dans un État membre cocontractant et qu’une '
                      'perquisition urgente de son domicile en France est nécessaire, cette mesure peut être '
                      'demandée à un magistrat français par un agent français détaché, sur le fondement de ',
                ),
                TextSpan(
                  text:
                      'l’article 13, paragraphe 7, de la convention européenne d’entraide judiciaire du 29 mai 2000',
                  style: TextStyle(
                    color: lawRed(context),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const TextSpan(text: ' :'),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    'La perquisition peut être effectuée, sur le fondement des articles 57, alinéa 2, '
                    'et 95 du Code de procédure pénale, en présence de deux témoins ou d’un représentant '
                    'désigné par la personne dont le domicile est en cause ;',
              ),
              const _BulletPoint(
                text:
                    'En enquête préliminaire, la même possibilité existe sur le fondement de '
                    'l’article 76 du Code de procédure pénale pour les perquisitions sans assentiment.',
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
