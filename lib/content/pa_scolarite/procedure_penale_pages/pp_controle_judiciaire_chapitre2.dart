import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaPPControleJudiciaireChapitre2Page extends StatelessWidget {
  const PaPPControleJudiciaireChapitre2Page({super.key});

  static const String routeName =
      '/pa/dps_dpg/procedure_penale/pp_controle_judiciaire_chapitre2';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);
    final Color textSoft = isDark
        ? Colors.white70
        : const Color(0xFF222222).withValues(alpha: .75);

    final Color accent = isDark ? const Color(0xFF64B5F6) : const Color(0xFF1565C0);
    final Color cardColor = isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF7F7F7);
    const Color articleRed = Color(0xFFD32F2F);

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
          'Contrôle judiciaire — Chapitre 2',
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: textMain,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 28),
        children: [
          // ====================== TITRE PRINCIPAL ===========================
          Text(
            'CHAPITRE 2\nDÉROULEMENT ET FIN DU CONTRÔLE JUDICIAIRE',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              letterSpacing: .3,
              color: textMain,
            ),
          ),
          const SizedBox(height: 8),

          Text(
            'Ce chapitre traite de l’évolution du contrôle judiciaire au cours de la procédure : '
            'modification des obligations, mainlevée de la mesure, durée normale et transformation '
            'éventuelle en détention provisoire, notamment en cas de manquements.',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w500,
              fontSize: 13.5,
              height: 1.35,
              color: textSoft,
            ),
          ),

          const SizedBox(height: 16),

          // ==================== 2.1 — MODIFICATION DU CJ ====================
          _ConditionCard(
            title: '2.1 — La modification du contrôle judiciaire',
            cardColor: cardColor,
            accent: accent,
            titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
            children: const [
              _Paragraph(
                'La décision de placement sous contrôle judiciaire est prise en fonction de la situation '
                'existante à un moment déterminé de l’information. Lorsque ces circonstances évoluent '
                '(situation personnelle, professionnelle, familiale, état de santé, garanties de représentation, etc.), '
                'le juge d’instruction doit adapter les mesures pour conserver leur pertinence et leur proportionnalité.',
              ),
              SizedBox(height: 8),
              _Paragraph(
                'La modification du contrôle judiciaire peut consister à :',
              ),
              SizedBox(height: 4),
              _BulletPoint(
                text: 'imposer une ou plusieurs obligations nouvelles ;',
              ),
              _BulletPoint(
                text: 'supprimer tout ou partie des obligations existantes ;',
              ),
              _BulletPoint(
                text: 'modifier une ou plusieurs obligations déjà imposées ;',
              ),
              _BulletPoint(
                text:
                    'accorder, lorsque la situation le justifie, une dispense temporaire d’observer certaines obligations.',
              ),
              SizedBox(height: 10),
              _Paragraph(
                'Outre le juge d’instruction, la chambre de l’instruction, le juge des libertés et de la détention, '
                'ainsi que les juridictions de jugement peuvent également modifier les modalités du contrôle judiciaire '
                'lorsqu’elles sont saisies de la procédure.',
              ),
            ],
          ),

          const SizedBox(height: 18),

          // ==================== 2.2 — MAINLEVÉE DU CJ =======================
          _ConditionCard(
            title: '2.2 — La demande de mainlevée du contrôle judiciaire',
            cardColor: cardColor,
            accent: accent,
            titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
            children: const [
              _SubTitle('2.2.1 — Rôle du juge d’instruction'),
              _Paragraph.rich([
                TextSpan(
                  text:
                      'La mainlevée du contrôle judiciaire peut intervenir à tout moment au cours de l’instruction. '
                      'Selon ',
                ),
                TextSpan(
                  text: 'l’article 140 alinéa 1 du Code de procédure pénale',
                  style: TextStyle(
                    color: articleRed,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: ', la mainlevée peut :'),
              ]),
              SizedBox(height: 6),
              _BulletPoint(
                text:
                    'être ordonnée d’office par le juge d’instruction, lorsqu’il estime que les mesures ne sont plus nécessaires ;',
              ),
              _BulletPoint(
                text:
                    'intervenir à la suite de réquisitions du procureur de la République ;',
              ),
              _BulletPoint(
                text:
                    'faire suite à une demande de l’intéressé, après avis du ministère public.',
              ),

              SizedBox(height: 12),

              _SubTitle('2.2.2 — Saisine de la chambre de l’instruction'),
              _SubTitle(
                '2.2.2.1 — En cas de carence du juge d’instruction',
              ),
              _Paragraph.rich([
                TextSpan(
                  text:
                      'En cas de silence du juge d’instruction, un mécanisme de « carence » permet la saisine de la chambre de l’instruction. '
                      'Conformément à ',
                ),
                TextSpan(
                  text: 'l’article 140 alinéa 3 du Code de procédure pénale',
                  style: TextStyle(
                    color: articleRed,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      ', lorsque le juge d’instruction n’a pas répondu dans les 5 jours à une demande de mainlevée :',
                ),
              ]),
              SizedBox(height: 6),
              _BulletPoint(
                text:
                    'la chambre de l’instruction est saisie et doit statuer dans un délai de 20 jours ;',
              ),
              _BulletPoint(
                text:
                    'si la chambre de l’instruction ne statue pas dans ce délai, la mainlevée du contrôle judiciaire est de plein droit ;',
              ),
              _BulletPoint(
                text:
                    'le procureur de la République peut également saisir directement la chambre de l’instruction lorsque, '
                    'suite à ses réquisitions adressées au juge d’instruction, il n’a pas obtenu de réponse dans les 5 jours.',
              ),

              SizedBox(height: 10),

              _SubTitle('2.2.2.2 — Autres cas de saisine'),
              _Paragraph(
                'La chambre de l’instruction peut encore être saisie :',
              ),
              SizedBox(height: 4),
              _BulletPoint(
                text:
                    'en cas de dessaisissement du juge d’instruction par une ordonnance de règlement, à la suite de l’évocation de l’affaire par la chambre de l’instruction ;',
              ),
              _BulletPoint(
                text:
                    'lorsque la chambre de l’instruction s’est expressément réservée le contentieux du contrôle judiciaire.',
              ),

              SizedBox(height: 12),

              _SubTitle('2.2.3 — Rôle des juridictions de jugement'),
              _Paragraph(
                'Lorsque les juridictions de jugement (tribunal correctionnel, cour d’assises, juridiction pour mineurs) '
                'sont saisies de la procédure, elles disposent des mêmes pouvoirs que le juge d’instruction pour statuer '
                'sur les demandes de mainlevée du contrôle judiciaire. Elles peuvent ainsi maintenir, modifier ou lever '
                'le contrôle judiciaire en fonction de l’évolution du dossier et de la situation de la personne mise en cause.',
              ),
            ],
          ),

          const SizedBox(height: 18),

          // ==================== 2.3 — FIN DU CJ =============================
          _ConditionCard(
            title: '2.3 — La fin du contrôle judiciaire',
            cardColor: cardColor,
            accent: accent,
            titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
            children: const [
              _SubTitle(
                '2.3.1 — La durée normale du contrôle judiciaire',
              ),
              _Paragraph(
                'En principe, le contrôle judiciaire se poursuit jusqu’à la fin de l’information. Il prend fin lorsque '
                'l’instruction est close et que l’affaire est soit réglée, soit renvoyée devant une juridiction de jugement.',
              ),
              SizedBox(height: 6),
              _Paragraph(
                'En matière correctionnelle, l’ordonnance de renvoi devant le tribunal correctionnel met en principe fin '
                'au contrôle judiciaire, sauf décision contraire spécialement motivée.',
              ),
              SizedBox(height: 4),
              _Paragraph(
                'En matière criminelle, l’ordonnance de mise en accusation ne met pas fin au contrôle judiciaire, '
                'qui continue de produire ses effets jusqu’au jugement devant la cour d’assises.',
              ),

              SizedBox(height: 12),

              _SubTitle(
                '2.3.2 — Transformation du contrôle judiciaire en placement en détention',
              ),

              _SubTitle(
                '2.3.2.1 — En cas d’insuffisance du contrôle judiciaire',
              ),
              _Paragraph.rich([
                TextSpan(
                  text:
                      'Lorsque le contrôle judiciaire ne suffit plus à garantir le bon déroulement de l’instruction, '
                      'il peut être remplacé par une détention provisoire. ',
                ),
                TextSpan(
                  text: 'L’article 137 du Code de procédure pénale',
                  style: TextStyle(
                    color: articleRed,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      ' prévoit en effet que, si le contrôle judiciaire ne permet pas d’atteindre les objectifs poursuivis, '
                      'la détention provisoire peut être ordonnée. Le juge d’instruction doit alors saisir le juge des libertés '
                      'et de la détention, compétent pour décider du placement en détention.',
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph(
                'La chambre de l’instruction peut également, lorsqu’elle est saisie du dossier, substituer la détention provisoire '
                'au contrôle judiciaire si elle estime les obligations insuffisantes au regard des nécessités de la procédure.',
              ),

              SizedBox(height: 12),

              _SubTitle(
                '2.3.2.2 — Les manquements aux obligations du contrôle judiciaire',
              ),
              _Paragraph.rich([
                TextSpan(
                  text:
                      'En cas de manquement aux obligations, un régime spécifique d’appréhension et de retenue est prévu. '
                      'Selon ',
                ),
                TextSpan(
                  text: 'l’article 141-4 du Code de procédure pénale',
                  style: TextStyle(
                    color: articleRed,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      ', les services de police et les unités de gendarmerie peuvent, d’office ou sur instructions du juge '
                      'd’instruction, appréhender toute personne placée sous contrôle judiciaire lorsqu’il existe une ou '
                      'plusieurs raisons plausibles de soupçonner qu’elle a manqué à ses obligations, notamment celles '
                      'énumérées aux 1°, 2°, 3°, 8°, 9°, 14°, 17° et 17° bis de l’article 138 du Code de procédure pénale.',
                ),
              ]),

              SizedBox(height: 12),

              _SubTitle('2.3.2.3 — La révocation du contrôle judiciaire'),
              _Paragraph.rich([
                TextSpan(
                  text:
                      'La révocation du contrôle judiciaire intervient lorsque la personne se soustrait volontairement aux obligations '
                      'qui lui ont été imposées. ',
                ),
                TextSpan(
                  text: 'L’article 141-2 du Code de procédure pénale',
                  style: TextStyle(
                    color: articleRed,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      ' prévoit que, dans une telle hypothèse, le juge d’instruction peut, quelle que soit la peine '
                      'd’emprisonnement encourue, décerner contre l’intéressé un mandat d’arrêt ou un mandat d’amener. '
                      'Il peut aussi saisir le juge des libertés et de la détention en vue du placement en détention provisoire. '
                      'La détention provisoire est alors possible quel que soit le quantum de la peine encourue.',
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text:
                      'La chambre de l’instruction peut, elle aussi, révoquer le contrôle judiciaire lorsqu’elle statue sur un appel '
                      'relatif à ce contrôle, lorsqu’elle est saisie de l’ensemble du dossier d’information ou lorsqu’elle s’est '
                      'réservée le contentieux du contrôle judiciaire. ',
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text:
                      'Lorsque la personne se soustrait aux obligations du contrôle judiciaire alors qu’elle est déjà renvoyée '
                      'devant la juridiction de jugement, le procureur de la République peut saisir le juge des libertés et de la '
                      'détention afin que ce dernier délivre un mandat d’arrêt ou d’amener et puisse, le cas échéant, ordonner '
                      'le placement en détention provisoire de l’intéressé, conformément à ',
                ),
                TextSpan(
                  text: 'l’article 141-2 alinéa 2 du Code de procédure pénale',
                  style: TextStyle(
                    color: articleRed,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: '.'),
              ]),
              SizedBox(height: 10),

              _Paragraph.rich([
                TextSpan(
                  text:
                      'Dans ce cadre, la personne peut être retenue, sur décision d’un officier de police judiciaire, pour une '
                      'durée maximale de 24 heures dans un local de police ou de gendarmerie, afin que sa situation soit vérifiée '
                      'et qu’elle soit entendue sur la violation de ses obligations. Ce régime de retenue est également prévu par ',
                ),
                TextSpan(
                  text: 'l’article 141-4 du Code de procédure pénale',
                  style: TextStyle(
                    color: articleRed,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: '.'),
              ]),
              SizedBox(height: 8),
              _Paragraph(
                'Dès le début de cette mesure, l’officier de police judiciaire informe le juge d’instruction.',
              ),

              SizedBox(height: 10),

              _SubTitle('Les droits de la personne retenue'),
              _Paragraph.rich([
                TextSpan(
                  text:
                      'La personne retenue est immédiatement informée, dans une langue qu’elle comprend, de la durée maximale '
                      'de la mesure, de la nature des obligations qu’elle est soupçonnée d’avoir violées et des droits dont elle '
                      'bénéficie :',
                ),
              ]),
              SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text:
                      '1°) du droit de faire prévenir un proche et son employeur, ainsi que, si elle est de nationalité étrangère, '
                      'les autorités consulaires de l’État dont elle est ressortissante, conformément à ',
                ),
                TextSpan(
                  text: 'l’article 63-2 du Code de procédure pénale',
                  style: TextStyle(
                    color: articleRed,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: ' ;'),
              ]),
              SizedBox(height: 4),
              _Paragraph.rich([
                TextSpan(
                  text:
                      '2°) du droit d’être examinée par un médecin, conformément à ',
                ),
                TextSpan(
                  text: 'l’article 63-3 du Code de procédure pénale',
                  style: TextStyle(
                    color: articleRed,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: ' ;'),
              ]),
              SizedBox(height: 4),
              _Paragraph.rich([
                TextSpan(
                  text:
                      '3°) du droit d’être assistée par un avocat, conformément aux ',
                ),
                TextSpan(
                  text: 'articles 63-3-1 à 63-4-3 du Code de procédure pénale',
                  style: TextStyle(
                    color: articleRed,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: ' ;'),
              ]),
              SizedBox(height: 4),
              _Paragraph(
                '4°) le cas échéant, du droit d’être assistée par un interprète ;',
              ),
              SizedBox(height: 4),
              _Paragraph(
                '5°) du droit, lors des auditions, après avoir décliné son identité, de faire des déclarations, '
                'de répondre aux questions qui lui sont posées ou de se taire.',
              ),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text:
                      'Les pouvoirs normalement conférés au procureur de la République par ',
                ),
                TextSpan(
                  text: 'les articles 63-2 et 63-3 du Code de procédure pénale',
                  style: TextStyle(
                    color: articleRed,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      ' sont, dans ce cadre, exercés par le juge d’instruction.',
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph(
                'La retenue doit s’exécuter dans des conditions assurant le respect de la dignité de la personne. '
                'Seules peuvent être imposées les mesures de sécurité strictement nécessaires. La personne retenue ne peut '
                'faire l’objet d’investigations corporelles internes durant la mesure.',
              ),
              SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text:
                      'Un procès-verbal récapitulatif de la mesure est établi conformément à ',
                ),
                TextSpan(
                  text: 'l’article 64 du Code de procédure pénale',
                  style: TextStyle(
                    color: articleRed,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: '.'),
              ]),
              SizedBox(height: 8),
              _Paragraph(
                'À l’issue de la retenue, le juge d’instruction peut ordonner que la personne soit conduite devant lui, '
                'le cas échéant afin qu’il saisisse le juge des libertés et de la détention aux fins de révocation du contrôle '
                'judiciaire. Il peut également demander à un officier ou à un agent de police judiciaire d’aviser la personne '
                'qu’elle est convoquée devant lui à une date ultérieure.',
              ),

              SizedBox(height: 12),

              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        'Cette procédure de retenue est également applicable lorsque la personne se soustrait aux obligations '
                        'du contrôle judiciaire alors qu’elle est déjà renvoyée devant la juridiction de jugement, conformément à ',
                  ),
                  TextSpan(
                    text:
                        'l’article 141-2 alinéa 2 du Code de procédure pénale',
                    style: TextStyle(
                      color: articleRed,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(
                    text:
                        ', ou lorsqu’elle est invitée à comparaître devant le tribunal par le procureur de la République, en vertu de ',
                  ),
                  TextSpan(
                    text: 'l’article 394 alinéa 3 du Code de procédure pénale',
                    style: TextStyle(
                      color: articleRed,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(
                    text:
                        '. Dans ces hypothèses, les attributions normalement confiées au juge d’instruction par ',
                  ),
                  TextSpan(
                    text: 'l’article 141-4 du Code de procédure pénale',
                    style: TextStyle(
                      color: articleRed,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(
                    text:
                        ' sont alors exercées par le procureur de la République.',
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),
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
