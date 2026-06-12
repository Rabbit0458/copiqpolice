import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Texte rouge pour les articles de loi / références légales
TextSpan _lawRef(String text) {
  return TextSpan(
    text: text,
    style: TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.w700),
  );
}

class PaPPMineursInstructionPreparatoirePage extends StatelessWidget {
  const PaPPMineursInstructionPreparatoirePage({super.key});

  static const String routeName =
      '/pa/dps_dpg/procedure_penale/pp_mineurs_instruction_preparatoire';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF10141A) : const Color(0xFFFFFFFF);

    final textMain = GoogleFonts.fustat(
      fontSize: 15.5,
      fontWeight: FontWeight.w800,
      color: isDark ? Colors.white : const Color(0xFF0D47A1),
    );

    final textSoft = GoogleFonts.fustat(
      fontSize: 13.5,
      fontWeight: FontWeight.w600,
      color: isDark ? Colors.white70 : const Color(0xFF424242),
    );

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: isDark ? Colors.white : const Color(0xFF050505),
          ),
          tooltip: 'Retour',
        ),
        title: Text(
          'Instruction préparatoire — mineurs',
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: isDark ? Colors.white : const Color(0xFF050505),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ======================= EN-TÊTE CHAPITRE =======================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: isDark
                        ? [const Color(0xFF0D47A1), const Color(0xFF002171)]
                        : [const Color(0xFFE3F2FD), const Color(0xFFBBDEFB)],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CHAPITRE 2 : INSTRUCTION PRÉPARATOIRE',
                      style: textMain,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Organisation et déroulement de l’instruction préparatoire lorsqu’un mineur est mis en cause : magistrats spécialisés, ouverture de l’information, '
                      'mesures éducatives et de sûreté, contrôle judiciaire, A.R.S.E., détention provisoire et clôture de l’instruction.',
                      style: textSoft,
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),

              ////////////////////////////////////////////////////////////////
              /// 2.1 — LE JUGE D'INSTRUCTION
              ////////////////////////////////////////////////////////////////
              _ConditionCard(
                title: '2.1 — Le juge d’instruction',
                cardColor: isDark
                    ? const Color(0xFF10141A)
                    : const Color(0xFFF5F7FB),
                accent: isDark
                    ? const Color(0xFF64B5F6)
                    : const Color(0xFF1565C0),
                titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
                children: [
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Les crimes et délits reprochés à un mineur sont instruits par un juge spécialisé : le juge d’instruction chargé spécialement des affaires '
                          'concernant les mineurs, conformément à ',
                    ),
                    _lawRef(
                      'l’article L. 12-1, 3° du Code de la justice pénale des mineurs',
                    ),
                    const TextSpan(text: ' (C.J.P.M.).'),
                  ]),
                  const SizedBox(height: 8),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Ce juge est désigné, dans chaque tribunal judiciaire doté d’un pôle de l’instruction et dans le ressort duquel siège un tribunal pour enfants, '
                          'par le premier président de la cour d’appel compétente, en application de ',
                    ),
                    _lawRef(
                      'l’article D. 221-1 du Code de la justice pénale des mineurs',
                    ),
                    const TextSpan(text: '.'),
                  ]),
                ],
              ),

              const SizedBox(height: 20),

              ////////////////////////////////////////////////////////////////
              /// 2.2 — DÉROULEMENT DE L’INSTRUCTION
              ////////////////////////////////////////////////////////////////
              _ConditionCard(
                title: '2.2 — Déroulement de l’instruction',
                cardColor: isDark
                    ? const Color(0xFF10141A)
                    : const Color(0xFFF5F7FB),
                accent: isDark
                    ? const Color(0xFF64B5F6)
                    : const Color(0xFF1565C0),
                titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
                children: [
                  ////////////////////////////////////////////////////////////
                  /// 2.2.1 — L’ouverture d’information
                  ////////////////////////////////////////////////////////////
                  const _SubTitle('2.2.1 — L’ouverture d’information'),

                  const _SubTitle('2.2.1.1 — Les cas'),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'En matière criminelle, l’information préalable est obligatoire (',
                    ),
                    _lawRef(
                      'article L. 423-3 du Code de la justice pénale des mineurs',
                    ),
                    const TextSpan(text: ').'),
                  ]),
                  const SizedBox(height: 4),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Lorsque l’infraction reprochée au mineur est un délit ou une contravention de cinquième classe, l’information est facultative (',
                    ),
                    _lawRef(
                      'article L. 423-2 du Code de la justice pénale des mineurs',
                    ),
                    const TextSpan(text: ').'),
                  ]),

                  const SizedBox(height: 10),

                  const _SubTitle('2.2.1.2 — La compétence territoriale'),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'L’information est ouverte près du tribunal judiciaire, siège d’un tribunal pour enfants, compétent au regard : du lieu de résidence du mineur '
                          '(ou de ses représentants légaux), du lieu où le mineur est placé, du lieu de commission de l’infraction, ou du lieu où le mineur a été trouvé (',
                    ),
                    _lawRef(
                      'article L. 231-1 du Code de la justice pénale des mineurs',
                    ),
                    const TextSpan(text: ').'),
                  ]),

                  const SizedBox(height: 10),

                  const _SubTitle('2.2.1.3 — L’enquête de personnalité'),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Lorsqu’il saisit le juge d’instruction, le procureur de la République ordonne une enquête de personnalité. Celle-ci consiste en un recueil de '
                          'renseignements socio-éducatifs, de la compétence exclusive des services de la protection judiciaire de la jeunesse (P.J.J.), destiné à procéder à '
                          'une évaluation synthétique de la personnalité et de la situation du mineur (',
                    ),
                    _lawRef(
                      'article L. 322-3 du Code de la justice pénale des mineurs',
                    ),
                    const TextSpan(text: ').'),
                  ]),

                  const SizedBox(height: 10),

                  const _SubTitle(
                    '2.2.1.4 — Les mesures prises par le juge d’instruction',
                  ),
                  const _Paragraph.rich([
                    TextSpan(
                      text: 'Lorsqu’il est saisi, le juge d’instruction :',
                    ),
                  ]),
                  const SizedBox(height: 6),
                  const _IntroBullet(
                    text:
                        'doit ordonner une mesure judiciaire d’investigation éducative (M.J.I.E.), en application de ',
                  ),
                  _Paragraph.rich([
                    _lawRef(
                      'l’article L. 432-1 du Code de la justice pénale des mineurs',
                    ),
                    const TextSpan(
                      text:
                          '. Cette mesure consiste en une évaluation approfondie et interdisciplinaire de la personnalité et de la situation du mineur.',
                    ),
                  ]),
                  const SizedBox(height: 6),
                  const _IntroBullet(
                    text:
                        'peut ordonner une mesure éducative judiciaire provisoire (M.E.J.P.) (',
                  ),
                  _Paragraph.rich([
                    _lawRef(
                      'article L. 432-2 du Code de la justice pénale des mineurs',
                    ),
                    const TextSpan(
                      text:
                          '), après audition du mineur, afin d’engager un suivi éducatif.',
                    ),
                  ]),
                  const SizedBox(height: 6),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Le contenu de la M.E.J.P. repose sur quatre grands modules (insertion, réparation, santé, placement) ainsi que sur des interdictions '
                          '(paraître en certains lieux, entrer en contact avec certaines personnes, se rendre dans certains secteurs, utiliser des comptes d’accès à des '
                          'services de plateformes en ligne) et des obligations (remettre un objet détenu, suivre un stage de formation civique, etc.), prévues aux ',
                    ),
                    _lawRef(
                      'articles L. 112-2, 1° à 9° bis du Code de la justice pénale des mineurs',
                    ),
                    const TextSpan(
                      text:
                          ', qui peuvent être prononcées alternativement ou cumulativement.',
                    ),
                  ]),

                  const SizedBox(height: 16),

                  ////////////////////////////////////////////////////////////
                  /// 2.2.2 — Le contrôle judiciaire
                  ////////////////////////////////////////////////////////////
                  const _SubTitle('2.2.2 — Le contrôle judiciaire'),

                  const _SubTitle('2.2.2.1 — Les conditions'),
                  const _Paragraph(
                    'Le recours au contrôle judiciaire pour un mineur est strictement encadré et varie en fonction de son âge et de la gravité des faits.',
                  ),
                  const SizedBox(height: 6),
                  const _SubTitle('Mineur de moins de 13 ans'),
                  const _Paragraph(
                    'Le mineur âgé de moins de 13 ans ne peut en aucun cas être placé sous contrôle judiciaire.',
                  ),
                  const SizedBox(height: 6),

                  const _SubTitle('Mineur âgé de moins de 16 ans'),
                  const _Paragraph(
                    'Le mineur âgé de moins de 16 ans peut être placé sous contrôle judiciaire :',
                  ),
                  const _IntroBullet(
                    text: 's’il encourt une peine criminelle ;',
                  ),
                  const _IntroBullet(
                    text:
                        'ou s’il encourt une peine d’emprisonnement égale ou supérieure à 7 ans ;',
                  ),
                  const _IntroBullet(
                    text:
                        'ou s’il encourt une peine d’emprisonnement égale ou supérieure à 5 ans et qu’il a déjà fait l’objet d’une mesure éducative, d’une M.J.I.E., d’une mesure de sûreté, '
                        'd’une déclaration de culpabilité ou d’une peine dans une autre procédure ayant donné lieu à un rapport datant de moins d’un an ;',
                  ),
                  const _IntroBullet(
                    text:
                        'ou si la peine encourue est au moins égale à 5 ans d’emprisonnement pour un délit de violences volontaires, d’agression sexuelle, ou un délit commis avec la circonstance aggravante de violences.',
                  ),

                  const SizedBox(height: 8),

                  const _SubTitle('Mineur âgé d’au moins 16 ans'),
                  const _Paragraph(
                    'Le mineur âgé d’au moins 16 ans peut être placé sous contrôle judiciaire :',
                  ),
                  const _IntroBullet(
                    text: 's’il encourt une peine criminelle ;',
                  ),
                  const _IntroBullet(
                    text: 'ou s’il encourt une peine d’emprisonnement.',
                  ),
                  const SizedBox(height: 8),

                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Lorsque le mineur est poursuivi pour l’une des infractions de nature sexuelle mentionnées à ',
                    ),
                    _lawRef('l’article 706-47 du Code de procédure pénale'),
                    const TextSpan(
                      text:
                          ', le C.J.P.M. prévoit une transmission d’informations : une copie de l’ordonnance de placement sous contrôle judiciaire peut être adressée à la '
                          'personne chez qui le mineur demeure, à l’autorité académique et, le cas échéant, à l’établissement scolaire où il est scolarisé (',
                    ),
                    _lawRef(
                      'article L. 331-6 du Code de la justice pénale des mineurs',
                    ),
                    const TextSpan(text: ').'),
                  ]),

                  const SizedBox(height: 10),

                  const _SubTitle('2.2.2.2 — Les obligations'),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Les obligations et interdictions susceptibles d’être prononcées dans le cadre du contrôle judiciaire sont limitativement énumérées par ',
                    ),
                    _lawRef(
                      'l’article L. 331-2 du Code de la justice pénale des mineurs',
                    ),
                    const TextSpan(
                      text:
                          ' : ne pas sortir de certaines limites territoriales, ne s’absenter du domicile qu’à certaines conditions, suivre une scolarité ou une formation, exercer une '
                          'activité professionnelle, etc.',
                    ),
                  ]),
                  const SizedBox(height: 6),
                  const _Paragraph(
                    'La durée du contrôle judiciaire n’est pas strictement limitée par les textes. Le juge d’instruction assure le suivi de cette mesure pendant toute la durée de l’instruction.',
                  ),
                  const SizedBox(height: 6),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Lorsqu’il existe une ou plusieurs raisons plausibles de soupçonner que le mineur n’a pas respecté certaines de ces obligations, il peut être placé en rétention '
                          'sur décision d’un officier de police judiciaire (',
                    ),
                    _lawRef(
                      'article L. 331-7 du Code de la justice pénale des mineurs',
                    ),
                    const TextSpan(text: ').'),
                  ]),
                  _Paragraph.rich([
                    const TextSpan(
                      text: 'Dans ce cas, il bénéficie des droits prévus par ',
                    ),
                    _lawRef(
                      'l’article L. 332-1 du Code de la justice pénale des mineurs',
                    ),
                    const TextSpan(
                      text:
                          ' (voir la partie relative à la rétention dans le cadre des mandats).',
                    ),
                  ]),

                  const SizedBox(height: 10),

                  const _SubTitle('2.2.2.3 — Déroulement et fin'),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'La révocation du contrôle judiciaire des mineurs âgés de 16 à 18 ans obéit à des conditions strictes : elle n’est possible que si deux conditions sont réunies, '
                          'conformément à ',
                    ),
                    _lawRef(
                      'l’article L. 334-5 du Code de la justice pénale des mineurs',
                    ),
                    const TextSpan(text: ' :'),
                  ]),
                  const SizedBox(height: 6),
                  const _IntroBullet(
                    text:
                        'la violation des obligations du contrôle judiciaire est répétée ou d’une particulière gravité ;',
                  ),
                  const _IntroBullet(
                    text:
                        'et le rappel ou l’aggravation de ces obligations ne suffit plus à atteindre les objectifs prévus par ',
                  ),
                  _Paragraph.rich([
                    _lawRef('l’article 144 du Code de procédure pénale'),
                    const TextSpan(text: '.'),
                  ]),
                  const SizedBox(height: 6),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Le juge des enfants ou le juge d’instruction peut ordonner la modification ou la mainlevée du contrôle judiciaire (',
                    ),
                    _lawRef(
                      'article L. 331-5 du Code de la justice pénale des mineurs',
                    ),
                    const TextSpan(text: ') :'),
                  ]),
                  const _IntroBullet(text: 'soit d’office ;'),
                  const _IntroBullet(
                    text:
                        'soit à la demande du mineur, de ses représentants légaux ou de la personne qui en a la garde ;',
                  ),
                  const _IntroBullet(
                    text: 'soit à la demande du procureur de la République.',
                  ),
                ],
              ),

              const SizedBox(height: 20),

              ////////////////////////////////////////////////////////////////
              /// 2.2.3 — A.R.S.E.
              ////////////////////////////////////////////////////////////////
              _ConditionCard(
                title:
                    '2.2.3 — L’assignation à résidence sous surveillance électronique (A.R.S.E.)',
                cardColor: isDark
                    ? const Color(0xFF10141A)
                    : const Color(0xFFF5F7FB),
                accent: isDark
                    ? const Color(0xFF64B5F6)
                    : const Color(0xFF1565C0),
                titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
                children: [
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'L’assignation à résidence sous surveillance électronique (A.R.S.E.), prévue aux ',
                    ),
                    _lawRef(
                      'articles L. 333-1 et L. 333-2 du Code de la justice pénale des mineurs',
                    ),
                    const TextSpan(
                      text:
                          ', n’est applicable qu’au mineur âgé de plus de 16 ans encourant une peine d’emprisonnement égale ou supérieure à 3 ans.',
                    ),
                  ]),
                  const SizedBox(height: 6),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Elle est mise en place dans les conditions et selon les modalités prévues pour les majeurs par ',
                    ),
                    _lawRef(
                      'les articles 137 et 142-5 à 142-13 du Code de procédure pénale',
                    ),
                    const TextSpan(text: '.'),
                  ]),
                  const SizedBox(height: 6),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'La vérification de la faisabilité technique de l’A.R.S.E. est confiée au service de la protection judiciaire de la jeunesse (P.J.J.), conformément à ',
                    ),
                    _lawRef(
                      'l’article D. 333-3 du Code de la justice pénale des mineurs',
                    ),
                    const TextSpan(text: '.'),
                  ]),
                  const SizedBox(height: 6),
                  const _Paragraph(
                    'Le mineur placé sous A.R.S.E. peut également être soumis aux obligations du contrôle judiciaire.',
                  ),
                ],
              ),

              const SizedBox(height: 20),

              ////////////////////////////////////////////////////////////////
              /// 2.2.4 — Détention provisoire
              ////////////////////////////////////////////////////////////////
              _ConditionCard(
                title:
                    '2.2.4 — La détention provisoire (art. L. 334-1 à L. 334-6 du C.J.P.M.)',
                cardColor: isDark
                    ? const Color(0xFF10141A)
                    : const Color(0xFFF5F7FB),
                accent: isDark
                    ? const Color(0xFF64B5F6)
                    : const Color(0xFF1565C0),
                titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
                children: [
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Le mineur de moins de treize ans ne peut être placé en détention provisoire. Dans le cadre de l’instruction, seul le juge des libertés et de la '
                          'détention (J.L.D.) est compétent pour prononcer et prolonger la détention provisoire des mineurs, conformément aux ',
                    ),
                    _lawRef(
                      'articles L. 334-1 à L. 334-6 du Code de la justice pénale des mineurs',
                    ),
                    const TextSpan(text: '.'),
                  ]),

                  const SizedBox(height: 10),
                  const _SubTitle('Durées en matière criminelle'),
                  const _IntroBullet(
                    text:
                        'pour les mineurs de moins de 16 ans : détention possible pour une durée de 6 mois, renouvelable une fois ;',
                  ),
                  const _IntroBullet(
                    text:
                        'pour les mineurs de 16 à 18 ans : détention possible pour une durée d’un an, renouvelable deux fois 6 mois (jusqu’à 3 ans en matière de terrorisme).',
                  ),

                  const SizedBox(height: 10),
                  const _SubTitle('Durées en matière correctionnelle'),
                  const _IntroBullet(
                    text:
                        'pour les mineurs de moins de 16 ans : détention possible pour une durée de 15 jours renouvelable une fois si la peine encourue est inférieure à 10 ans d’emprisonnement ;',
                  ),
                  const _IntroBullet(
                    text:
                        'ou pour une durée d’un mois renouvelable une fois si la peine encourue est de 10 ans d’emprisonnement ;',
                  ),
                  const _IntroBullet(
                    text:
                        'pour les mineurs de 16 à 18 ans : détention possible pour une durée d’un mois renouvelable une fois si la peine encourue est inférieure ou égale à 7 ans d’emprisonnement ;',
                  ),
                  const _IntroBullet(
                    text:
                        'ou pour une durée de quatre mois renouvelable deux fois si la peine encourue est supérieure à 7 ans d’emprisonnement (jusqu’à deux ans en matière de terrorisme).',
                  ),
                ],
              ),

              const SizedBox(height: 20),

              ////////////////////////////////////////////////////////////////
              /// 2.2.5 — Clôture de l’instruction
              ////////////////////////////////////////////////////////////////
              _ConditionCard(
                title: '2.2.5 — La clôture de l’instruction',
                cardColor: isDark
                    ? const Color(0xFF10141A)
                    : const Color(0xFFF5F7FB),
                accent: isDark
                    ? const Color(0xFF64B5F6)
                    : const Color(0xFF1565C0),
                titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
                children: const [
                  _Paragraph(
                    'Lorsque l’instruction est terminée, le juge d’instruction statue par ordonnance en fonction de la qualification des faits et de l’âge du mineur.',
                  ),
                  SizedBox(height: 8),
                  _IntroBullet(
                    text:
                        'ordonnance de non-lieu, lorsque les charges sont insuffisantes ou que l’infraction n’est pas caractérisée ;',
                  ),
                  _IntroBullet(
                    text:
                        'ordonnance de renvoi devant le tribunal de police si le fait constitue une contravention des quatre premières classes ;',
                  ),
                  _IntroBullet(
                    text:
                        'ordonnance de renvoi devant le juge des enfants, en cas de délit ou de contravention de 5ᵉ classe reprochés à un mineur âgé de moins de 13 ans ;',
                  ),
                  _IntroBullet(
                    text:
                        'ordonnance de renvoi devant le tribunal pour enfants, en cas de délit ou de contravention de 5ᵉ classe reprochés à un mineur âgé d’au moins 13 ans, ou en cas de crime reproché à un mineur de moins de 16 ans ;',
                  ),
                  _IntroBullet(
                    text:
                        'ordonnance de mise en accusation devant la cour d’assises des mineurs, en cas de crime reproché à un mineur âgé d’au moins 16 ans ;',
                  ),
                  _IntroBullet(
                    text:
                        'ordonnance de mise en accusation devant la cour d’assises des mineurs également en cas de connexité ou d’indivisibilité avec un crime reproché à un mineur d’au moins 16 ans, pour les crimes commis avant qu’il n’ait atteint cet âge, ou pour les crimes commis à compter de sa majorité.',
                  ),
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
