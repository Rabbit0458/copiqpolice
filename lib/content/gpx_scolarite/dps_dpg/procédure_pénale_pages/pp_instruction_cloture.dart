import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PPInstructionCloturePage extends StatelessWidget {
  const PPInstructionCloturePage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/procédure_pénale_pages/pp_instruction_cloture';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Clôture de l’instruction',
          style: GoogleFonts.fustat(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent, // plus de barre bleue
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // CHAPITRE + titre général
              Text(
                'CHAPITRE 4',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  color: isDark
                      ? const Color(0xFF64B5F6)
                      : const Color(0xFF0D47A1),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'La clôture de l’instruction',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                'La clôture de l’instruction marque la fin des actes d’enquête '
                'conduits par le juge d’instruction. À ce stade, il doit décider '
                'des suites à donner au dossier : renvoi devant une juridiction '
                'de jugement, mise en accusation ou non-lieu.',
              ),

              const SizedBox(height: 18),
              const _SubTitle('4.1 – Le moment de la clôture'),

              const _Paragraph(
                'Dès que l’information lui paraît terminée, le juge d’instruction '
                'communique le dossier au procureur de la République et en avise '
                'les avocats des parties, ou les parties elles-mêmes lorsqu’elles '
                'ne sont pas assistées par un avocat. Cet avis peut être donné '
                'verbalement ou par lettre recommandée.',
              ),
              const SizedBox(height: 8),
              const _Paragraph.rich([
                TextSpan(
                  text:
                      'Lorsque la personne mise en examen est détenue, l’avis peut '
                      'également être notifié par le chef de l’établissement pénitentiaire, '
                      'conformément à ',
                ),
                TextSpan(
                  text: 'l’article 175 du Code de procédure pénale',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: '.'),
              ]),
              const SizedBox(height: 8),
              const _Paragraph.rich([
                TextSpan(text: 'L’'),
                TextSpan(
                  text: 'article 175-1 du Code de procédure pénale',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      ' permet à la personne mise en examen, au témoin assisté et à la '
                      'partie civile de demander au juge d’instruction de clore son '
                      'instruction, éventuellement par voie de disjonction, afin de '
                      'prononcer soit le renvoi devant une juridiction de jugement, '
                      'soit une décision de non-lieu.',
                ),
              ]),
              const SizedBox(height: 8),
              const _IntroBullet(
                text:
                    'La demande de clôture peut être formée lorsque aucun acte '
                    'd’instruction n’a été accompli pendant quatre mois.',
              ),
              const _IntroBullet(
                text:
                    'Le juge doit répondre à cette demande par une ordonnance '
                    'motivée dans le délai d’un mois.',
              ),

              const SizedBox(height: 22),
              const _SubTitle('4.2 – Les ordonnances de règlement'),

              const _Paragraph(
                'Lorsque tous les actes d’information ont été accomplis, le juge '
                'd’instruction doit se prononcer sur les suites à donner à l’affaire. '
                'Il rend alors une ordonnance de règlement, également appelée '
                'ordonnance de clôture de l’information. Cette ordonnance dessaisit '
                'le juge d’instruction.',
              ),
              const SizedBox(height: 6),
              const _Paragraph(
                'L’ordonnance de règlement peut prendre plusieurs formes : '
                'ordonnance de renvoi, ordonnance de mise en accusation ou '
                'ordonnance de non-lieu.',
              ),

              const SizedBox(height: 18),
              _ConditionCard(
                title: 'Les trois grandes issues possibles',
                cardColor: isDark
                    ? const Color(0xFF102027)
                    : const Color(0xFFE3F2FD),
                accent: const Color(0xFF1565C0),
                titleColor: isDark
                    ? const Color(0xFFBBDEFB)
                    : const Color(0xFF0D47A1),
                children: const [
                  _BulletPoint(
                    text:
                        'Ordonnance de renvoi devant une juridiction de jugement '
                        '(tribunal de police, tribunal correctionnel).',
                  ),
                  _BulletPoint(
                    text:
                        'Ordonnance de mise en accusation devant la cour d’assises '
                        'pour les crimes.',
                  ),
                  _BulletPoint(
                    text:
                        'Ordonnance de non-lieu lorsque les conditions de poursuite '
                        'ne sont pas réunies.',
                  ),
                ],
              ),

              const SizedBox(height: 24),
              const _SubTitle('4.2.1 – L’ordonnance de renvoi'),

              const _Paragraph(
                'Si le juge d’instruction estime que les faits constituent une '
                'infraction, il prononce par ordonnance le renvoi de l’affaire '
                'devant la juridiction de jugement compétente. Une fois devenue '
                'définitive, l’ordonnance de renvoi couvre les vices de la procédure, '
                's’il en existe, sauf lorsque les parties n’auraient pas pu en avoir '
                'connaissance.',
              ),

              const SizedBox(height: 16),
              const _SubTitle(
                '4.2.1.1 – Renvoi devant le tribunal de police\n(en cas de contravention)',
              ),
              const _Paragraph.rich([
                TextSpan(
                  text:
                      'Lorsque le juge d’instruction estime que les faits ne constituent '
                      'qu’une contravention, il rend une ordonnance de renvoi devant le '
                      'tribunal de police, conformément à ',
                ),
                TextSpan(
                  text: 'l’article 178 du Code de procédure pénale',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: '.'),
              ]),

              const SizedBox(height: 14),
              const _SubTitle(
                '4.2.1.2 – Renvoi devant le tribunal correctionnel\n(en cas de délit)',
              ),
              const _Paragraph.rich([
                TextSpan(
                  text:
                      'Si le juge d’instruction estime que les faits constituent un délit, '
                      'il rend une ordonnance de renvoi devant le tribunal correctionnel, '
                      'en application de ',
                ),
                TextSpan(
                  text: 'l’article 179 du Code de procédure pénale',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: '.'),
              ]),
              const SizedBox(height: 6),
              const _Paragraph('En principe, cette ordonnance met fin :'),
              const _IntroBullet(
                text:
                    'à l’assignation à résidence avec surveillance électronique,',
              ),
              const _IntroBullet(text: 'au contrôle judiciaire,'),
              const _IntroBullet(text: 'à la détention provisoire.'),
              const SizedBox(height: 8),
              const _Paragraph(
                'Si un mandat d’arrêt a été décerné, il conserve sa force exécutoire. '
                'En revanche, les mandats d’amener ou de recherche cessent de pouvoir '
                'être exécutés. Le juge d’instruction peut, le cas échéant, décerner '
                'un nouveau mandat d’arrêt.',
              ),

              const SizedBox(height: 24),
              const _SubTitle('4.2.2 – L’ordonnance de mise en accusation'),

              const _Paragraph.rich([
                TextSpan(
                  text:
                      'Lorsque le juge d’instruction estime que les faits reprochés aux '
                      'personnes mises en examen constituent une infraction qualifiée '
                      'crime, il rend une ordonnance de mise en accusation devant la cour '
                      'd’assises, conformément à ',
                ),
                TextSpan(
                  text: 'l’article 181 du Code de procédure pénale',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: '.'),
              ]),
              const SizedBox(height: 6),
              const _Paragraph.rich([
                TextSpan(
                  text:
                      'L’ordonnance précise, le cas échéant, si l’accusé bénéficie des '
                      'dispositions applicables au « repenti ». Lorsqu’elle est devenue '
                      'définitive, l’ordonnance de mise en accusation couvre les vices de la '
                      'procédure, s’il en existe, sous réserve de ',
                ),
                TextSpan(
                  text: 'l’article 269-1 du Code de procédure pénale',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      ' (absence d’information régulière de l’accusé) et hors le cas où les '
                      'parties n’auraient pas pu les connaître.',
                ),
              ]),
              const SizedBox(height: 8),
              const _Paragraph(
                'Le juge d’instruction transmet le dossier accompagné de son '
                'ordonnance au procureur de la République. Celui-ci doit l’adresser '
                'sans retard au greffe de la cour d’assises, avec les pièces à '
                'conviction.',
              ),

              const SizedBox(height: 24),
              const _SubTitle('4.2.3 – L’ordonnance de non-lieu'),

              const _SubTitle(
                '4.2.3.1 – Le fondement de l’ordonnance de non-lieu',
              ),
              const _Paragraph(
                'Lorsque le juge d’instruction estime que les faits ne constituent pas '
                'une infraction, il rend une ordonnance de non-lieu. Il peut également '
                'prendre cette décision lorsque l’auteur de l’infraction demeure '
                'inconnu ou lorsqu’il n’existe pas de charges suffisantes contre la '
                'personne mise en examen.',
              ),
              const SizedBox(height: 6),
              const _Paragraph.rich([
                TextSpan(
                  text:
                      'Si l’ordonnance de non-lieu est motivée par l’existence d’une cause '
                      'd’irresponsabilité pénale (contrainte, erreur de droit, légitime '
                      'défense, etc.) ou par le décès de la personne mise en examen, elle '
                      'doit préciser s’il existe des charges suffisantes établissant que '
                      'l’intéressé a commis les faits qui lui sont reprochés, conformément à ',
                ),
                TextSpan(
                  text:
                      'l’alinéa 2 de l’article 177 du Code de procédure pénale',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      '. Le juge d’instruction se prononce ainsi sur la culpabilité.',
                ),
              ]),
              const SizedBox(height: 8),
              const _Paragraph.rich([
                TextSpan(
                  text:
                      'Lorsqu’une ordonnance de non-lieu a été rendue, la personne ne peut '
                      'plus être recherchée pour les mêmes faits, sauf si apparaissent de '
                      'nouvelles charges, conformément à ',
                ),
                TextSpan(
                  text: 'l’article 188 du Code de procédure pénale',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: '.'),
              ]),
              const SizedBox(height: 6),
              const _Paragraph.rich([
                TextSpan(text: 'Selon '),
                TextSpan(
                  text: 'l’article 189 du Code de procédure pénale',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: ', constituent des charges nouvelles :'),
              ]),
              const _IntroBullet(
                text:
                    'les déclarations de témoins, pièces et procès-verbaux qui, n’ayant '
                    'pu être soumis au juge d’instruction, sont de nature à renforcer '
                    'des charges jugées auparavant insuffisantes,',
              ),
              const _IntroBullet(
                text:
                    'ou à apporter aux faits de nouveaux développements utiles à la '
                    'manifestation de la vérité.',
              ),
              const SizedBox(height: 8),
              const _Paragraph.rich([
                TextSpan(
                  text:
                      'La décision de rouvrir une information sur charges nouvelles '
                      'appartient au procureur de la République, en application de ',
                ),
                TextSpan(
                  text: 'l’article 190 du Code de procédure pénale',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: '.'),
              ]),

              const SizedBox(height: 18),
              const _SubTitle(
                '4.2.3.2 – Les effets de l’ordonnance de non-lieu',
              ),

              const _Paragraph(
                'L’ordonnance de non-lieu met fin à l’action publique. Elle s’oppose à '
                'ce qu’une nouvelle action soit engagée pour les mêmes faits, en '
                'dehors bien entendu de la réouverture de l’information sur charges '
                'nouvelles.',
              ),
              const SizedBox(height: 10),

              _NotaBox(
                title: 'Réparation en cas de détention provisoire',
                bodySpans: const [
                  TextSpan(
                    text:
                        'Le bénéficiaire d’un non-lieu qui a subi une détention '
                        'provisoire doit être informé de son droit de demander à '
                        'l’État réparation du préjudice matériel et moral causé par '
                        'cette détention, conformément à ',
                  ),
                  TextSpan(
                    text: 'l’article 149 du Code de procédure pénale',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(
                    text:
                        '. L’octroi de cette réparation ouvre à l’État un recours contre '
                        'le dénonciateur de mauvaise foi ou le faux témoin ayant '
                        'provoqué la détention ou sa prolongation, en application de ',
                  ),
                  TextSpan(
                    text: 'l’article 150 du Code de procédure pénale',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(text: '.'),
                ],
              ),

              const SizedBox(height: 14),
              _NotaBox(
                title: 'Effets civils pour la partie civile',
                bodySpans: const [
                  TextSpan(
                    text:
                        'Le bénéficiaire d’un non-lieu, dans une information ouverte '
                        'sur constitution de partie civile, peut demander au plaignant '
                        'des dommages-intérêts, conformément à ',
                  ),
                  TextSpan(
                    text: 'l’article 91 du Code de procédure pénale',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(
                    text:
                        '. Le non-lieu peut également conduire le juge d’instruction à '
                        'condamner la partie civile à une amende civile pouvant aller '
                        'jusqu’à 15 000 € lorsque la constitution de partie civile est '
                        'jugée abusive ou dilatoire, en application de ',
                  ),
                  TextSpan(
                    text: 'l’article 177-2 du Code de procédure pénale',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(text: '.'),
                ],
              ),

              const SizedBox(height: 26),
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
