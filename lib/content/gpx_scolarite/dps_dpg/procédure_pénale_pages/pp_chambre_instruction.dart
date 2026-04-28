import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PPChambreInstructionPage extends StatelessWidget {
  const PPChambreInstructionPage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/procédure_pénale_pages/pp_chambre_instruction';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chambre de l’instruction',
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
              // Titre principal
              Text(
                'CHAPITRE 5',
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
                'Rôle de la chambre de l’instruction',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              Text.rich(
                TextSpan(
                  children: const [
                    TextSpan(text: '('),
                    TextSpan(
                      text: 'articles 191 à 221-3 du Code de procédure pénale',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(text: ')'),
                  ],
                ),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w600,
                  fontSize: 13.5,
                  color: isDark
                      ? Colors.white70
                      : const Color(0xFF1F1F1F).withOpacity(.75),
                ),
              ),
              const SizedBox(height: 12),
              const _Paragraph(
                'La chambre de l’instruction est la juridiction d’instruction du second '
                'degré. Elle exerce un contrôle sur le déroulement de l’instruction, '
                'sur la régularité de la procédure et sur certaines décisions du juge '
                'd’instruction et du juge des libertés et de la détention.',
              ),

              const SizedBox(height: 20),
              const _SubTitle('5.1 – Composition et rôle'),

              const _Paragraph(
                'Il existe au moins une chambre de l’instruction par cour d’appel. '
                'Juridiction d’instruction du second degré, elle est composée d’un '
                'président et de deux conseillers. Elle statue par arrêts, qui ne sont '
                'susceptibles que d’un pourvoi en cassation.',
              ),
              const SizedBox(height: 8),
              const _Paragraph(
                'Les fonctions du ministère public sont assurées auprès d’elle par le '
                'procureur général près la cour d’appel.',
              ),

              const SizedBox(height: 14),
              _ConditionCard(
                title: 'Recours portés devant la chambre de l’instruction',
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
                        'L’appel des ordonnances du juge d’instruction ou du juge des '
                        'libertés et de la détention.',
                  ),
                  _BulletPoint(
                    text: 'Le contentieux des nullités de la procédure.',
                  ),
                  _BulletPoint(
                    text:
                        'Le contentieux de la détention provisoire et du contrôle '
                        'judiciaire.',
                  ),
                ],
              ),

              const SizedBox(height: 16),
              const _Paragraph.rich([
                TextSpan(
                  text:
                      'La chambre de l’instruction peut confirmer, infirmer ou annuler l’acte '
                      'litigieux qui lui est soumis. Chaque fois qu’elle est saisie, elle doit '
                      'examiner la régularité de la procédure et annuler les actes entachés '
                      'd’irrégularité, ainsi que, s’il y a lieu, tout ou partie de la procédure '
                      'postérieure, conformément à ',
                ),
                TextSpan(
                  text: 'l’article 206 du Code de procédure pénale',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: '.'),
              ]),
              const SizedBox(height: 8),
              const _Paragraph(
                'Seule la chambre de l’instruction peut prononcer une annulation : le '
                'juge d’instruction ne peut pas annuler lui-même l’un de ses propres '
                'actes, même s’il y découvre une irrégularité.',
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: const [
                  TextSpan(
                    text:
                        'La chambre de l’instruction peut également condamner une '
                        'partie civile à une amende civile pouvant aller jusqu’à 15 000 € '
                        'lorsqu’elle estime que la constitution de partie civile a été '
                        'abusive ou dilatoire. ',
                  ),
                  TextSpan(
                    text:
                        'Lorsque la partie civile est une personne morale, l’amende '
                        'peut être prononcée contre son représentant légal, si sa '
                        'mauvaise foi est établie.',
                  ),
                ],
                title: 'Partie civile abusive',
              ),

              const SizedBox(height: 18),
              const _Paragraph(
                'Certains recours permettent à la chambre de l’instruction d’exercer :',
              ),
              const _IntroBullet(
                text:
                    'un pouvoir de révision, lui permettant de refaire ou compléter '
                    'l’instruction ;',
              ),
              const _IntroBullet(
                text:
                    'un droit d’évocation, lui permettant de se saisir elle-même de '
                    'l’information au-delà du seul point contesté.',
              ),

              const SizedBox(height: 24),
              const _SubTitle('5.2 – Le pouvoir de révision'),

              const _Paragraph(
                'Le pouvoir de révision s’exerce lorsque le juge d’instruction n’est '
                'plus en charge de l’affaire, par exemple en cas d’appel d’une '
                'ordonnance de règlement. Dans ce cadre, la chambre de l’instruction '
                'peut décider de refaire totalement l’instruction.',
              ),
              const SizedBox(height: 8),
              const _Paragraph.rich([
                TextSpan(
                  text:
                      'Ce pouvoir se traduit essentiellement par un supplément d’information '
                      'confié à un magistrat désigné, qui agit conformément aux règles de '
                      'l’instruction préparatoire, en application de ',
                ),
                TextSpan(
                  text: 'l’article 205 du Code de procédure pénale',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: '.'),
              ]),

              const SizedBox(height: 10),
              _ConditionCard(
                title: 'Pouvoir de révision – caractéristiques',
                cardColor: isDark
                    ? const Color(0xFF1A237E)
                    : const Color(0xFFE8EAF6),
                accent: const Color(0xFF283593),
                titleColor: isDark
                    ? const Color(0xFFC5CAE9)
                    : const Color(0xFF1A237E),
                children: const [
                  _BulletPoint(
                    text:
                        'Le juge d’instruction n’est plus saisi de l’affaire (ex. : '
                        'appel d’une ordonnance de règlement).',
                  ),
                  _BulletPoint(
                    text:
                        'La chambre peut ordonner un supplément d’information.',
                  ),
                  _BulletPoint(
                    text:
                        'Le magistrat désigné exerce tous les pouvoirs d’investigation '
                        'du juge d’instruction et peut délivrer commission rogatoire.',
                  ),
                ],
              ),

              const SizedBox(height: 24),
              const _SubTitle('5.3 – Le droit d’évocation'),

              const _Paragraph(
                'Le droit d’évocation s’exerce alors que l’information est encore en '
                'cours devant le juge d’instruction. Il permet à la chambre de '
                'l’instruction de dessaisir ce magistrat et de prendre en charge '
                'l’ensemble de la procédure.',
              ),
              const SizedBox(height: 8),
              const _Paragraph.rich([
                TextSpan(
                  text:
                      'L’évocation peut être totale ou partielle : la chambre peut décider '
                      'de ne procéder qu’à certains actes d’instruction avant de renvoyer '
                      'le dossier au juge d’instruction, conformément à ',
                ),
                TextSpan(
                  text: 'l’article 207 du Code de procédure pénale',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: '.'),
              ]),

              const SizedBox(height: 10),
              _ConditionCard(
                title: 'Situations permettant l’évocation',
                cardColor: isDark
                    ? const Color(0xFF263238)
                    : const Color(0xFFE0F2F1),
                accent: const Color(0xFF00796B),
                titleColor: isDark
                    ? const Color(0xFFB2DFDB)
                    : const Color(0xFF004D40),
                children: const [
                  _BulletPoint(
                    text:
                        'Saisine par requête directe devant la chambre de l’instruction.',
                  ),
                  _BulletPoint(
                    text: 'Annulation d’un acte de procédure par la chambre.',
                  ),
                  _BulletPoint(
                    text:
                        'Infirma­tion d’une ordonnance dans un domaine autre que la '
                        'détention provisoire.',
                  ),
                  _BulletPoint(
                    text:
                        'Durée exagérée de l’instruction constatée par le président de '
                        'la chambre de l’instruction.',
                  ),
                ],
              ),

              const SizedBox(height: 10),
              const _Paragraph(
                'Lorsque la chambre use de son droit d’évocation, elle accède '
                'également au pouvoir de révision, qui s’exerce alors dans les mêmes '
                'conditions que précédemment décrites.',
              ),

              const SizedBox(height: 24),
              const _SubTitle(
                '5.4 – Autres conséquences possibles d’une infirmation ou d’une annulation',
              ),

              const _Paragraph(
                'Dans les situations où l’usage du droit d’évocation serait possible, '
                'la chambre de l’instruction dispose de deux autres options pour la '
                'suite de la procédure lorsqu’elle choisit de ne pas évoquer :',
              ),
              const _IntroBullet(
                text:
                    'laisser le juge d’instruction initialement saisi poursuivre son '
                    'information ;',
              ),
              const _IntroBullet(
                text: 'ou confier l’affaire à un autre juge d’instruction.',
              ),
              const SizedBox(height: 8),
              const _Paragraph(
                'Dans ces deux hypothèses, la chambre de l’instruction ne peut pas '
                'adresser de directives sur le fond au magistrat instructeur. Elle ne '
                'peut que fixer le cadre procédural (annulations, renvois, dessaisissement...).',
              ),

              const SizedBox(height: 24),
              const _SubTitle('5.5 – Audience de contrôle'),

              const _Paragraph.rich([
                TextSpan(text: 'L’'),
                TextSpan(
                  text: 'article 221-3 du Code de procédure pénale',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      ' prévoit une audience publique de contrôle de l’ensemble de la '
                      'procédure d’instruction devant la chambre de l’instruction.',
                ),
              ]),
              const SizedBox(height: 8),
              const _Paragraph(
                'Cette audience peut intervenir en cas de détention provisoire datant '
                'de trois mois, sur décision du président de la chambre de '
                'l’instruction, statuant :',
              ),
              const _IntroBullet(text: 'à la demande de la personne détenue ;'),
              const _IntroBullet(text: 'à la demande du ministère public ;'),
              const _IntroBullet(text: 'ou d’office.'),
              const SizedBox(height: 8),
              const _Paragraph(
                'Lorsque l’instruction a déjà donné lieu à une audience de contrôle, '
                'une nouvelle saisine est possible six mois après que l’arrêt est '
                'devenu définitif, à condition qu’une détention provisoire soit '
                'toujours en cours.',
              ),

              const SizedBox(height: 12),
              _NotaBox(
                title: 'Décisions possibles',
                bodySpans: const [
                  TextSpan(text: 'Les alinéas 7 à 14 de '),
                  TextSpan(
                    text: 'l’article 221-3 du Code de procédure pénale',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(
                    text:
                        ' énumèrent les décisions que peut prendre la chambre de '
                        'l’instruction à l’issue de l’audience de contrôle : mise en liberté, '
                        'nullité d’un ou de plusieurs actes de procédure, évocation du '
                        'dossier, co-saisine d’un autre magistrat, et plus largement '
                        'toutes mesures utiles pour assurer la régularité et la '
                        'bonne conduite de l’instruction.',
                  ),
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
