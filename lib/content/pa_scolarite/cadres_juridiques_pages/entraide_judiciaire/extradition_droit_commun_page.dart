import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaExtraditionDroitCommunPage extends StatelessWidget {
  const PaExtraditionDroitCommunPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/cadres_juridiques/entraide_judiciaire/extradition_droit_commun';

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

    Color lawRed() => Colors.red.shade700;

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
          'Extradition — Droit commun',
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
            '3 — L’extradition',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w800,
              fontSize: 13.5,
              letterSpacing: 1.4,
              color: accent,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '3.1 — La procédure d’extradition de droit commun',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 20,
              height: 1.2,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          const _Paragraph(
            'L’extradition consiste en la remise, par l’État où une personne s’est réfugiée '
            '(État requis), à l’État où elle doit être jugée ou exécuter une peine '
            '(État requérant). Elle constitue un outil classique de coopération pénale '
            'internationale, applicable en dehors du champ du mandat d’arrêt européen.',
          ),
          const SizedBox(height: 16),

          _ConditionCard(
            title: 'Cadre juridique et champ d’application',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleCardColor,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'La procédure d’extradition de droit commun est prévue par ',
                ),
                TextSpan(
                  text:
                      'les articles 696 à 696-24 et 696-34 à 696-47-1 du Code de Procédure Pénale',
                  style: TextStyle(
                    color: lawRed(),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const TextSpan(
                  text:
                      '. Elle n’est applicable qu’en l’absence de conventions internationales spécifiques.',
                ),
              ]),
              const SizedBox(height: 8),
              const _Paragraph(
                'Toutes les demandes d’extradition émanant ou adressées à des États qui ne sont pas '
                'membres de l’Union européenne relèvent de cette procédure de droit commun. '
                'Il en va de même des demandes provenant d’États membres de l’Union européenne, '
                'ou à destination de ceux-ci, lorsque la procédure de mandat d’arrêt européen '
                'n’est pas applicable.',
              ),
            ],
          ),
          const SizedBox(height: 18),

          // ===============================================================
          // 3.1.1  CONDITIONS DE MISE EN ŒUVRE
          // ===============================================================
          const _SubTitle('3.1.1 — Conditions de mise en œuvre'),
          const SizedBox(height: 4),

          _ConditionCard(
            title: '3.1.1.1 — Conditions de fond',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleCardColor,
            children: const [
              _Paragraph(
                'La France n’extrade pas ses nationaux, ni les étrangers qui sont justiciables '
                'des tribunaux français. Il n’y a pas d’extradition pour des infractions à caractère '
                'exclusivement politique.',
              ),
              SizedBox(height: 8),
              _Paragraph(
                'L’extradition n’est envisageable que pour des faits d’une gravité suffisante :',
              ),
              SizedBox(height: 6),
              _BulletPoint(
                text:
                    'Faits passibles de peines criminelles dans l’État requérant ;',
              ),
              _BulletPoint(
                text:
                    'Faits passibles de peines correctionnelles dans l’État requérant :',
              ),
              _IntroBullet(
                text:
                    'si la personne n’a pas encore été condamnée, la peine encourue doit être '
                    'd’au moins deux ans d’emprisonnement ;',
              ),
              _IntroBullet(
                text:
                    'si la personne est déjà condamnée, la peine prononcée doit être d’au moins '
                    'deux mois d’emprisonnement.',
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    'Nécessité d’une double incrimination des faits : l’infraction doit être réprimée '
                    'à la fois par la loi de l’État requérant et par la loi française.',
              ),
              SizedBox(height: 4),
              _Paragraph.rich([
                TextSpan(
                  text:
                      'Ce principe de double incrimination est rappelé par l’ ',
                ),
                TextSpan(
                  text: 'article 696-2 du Code de Procédure Pénale',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                TextSpan(text: '.'),
              ]),
              SizedBox(height: 8),
              _Paragraph('En matière de compétence territoriale :'),
              SizedBox(height: 6),
              _IntroBullet(
                text:
                    'l’infraction a été commise sur le territoire de l’État requérant par un ressortissant '
                    'de cet État ou par un étranger ;',
              ),
              _IntroBullet(
                text:
                    'l’infraction a été commise hors du territoire de l’État requérant par un ressortissant '
                    'de cet État ;',
              ),
              _IntroBullet(
                text:
                    'l’infraction a été commise hors du territoire de l’État requérant par une personne '
                    'étrangère à cet État, alors même que la loi française autorise la poursuite en France '
                    'de ce type de faits, y compris lorsqu’ils ont été commis à l’étranger par un étranger.',
              ),
            ],
          ),
          const SizedBox(height: 18),

          // ===============================================================
          // 3.1.1.2  PROCÉDURE APPLICABLE
          // ===============================================================
          const _SubTitle('3.1.1.2 — Procédure applicable à l’extradition'),
          const SizedBox(height: 4),

          // -------------------- France État requérant ---------------------
          _ConditionCard(
            title: '3.1.1.2.1 — La France « État requérant »',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleCardColor,
            children: const [
              _Paragraph(
                'Lorsque la France sollicite l’extradition d’une personne se trouvant à l’étranger, '
                'le procureur de la République transmet au procureur général une demande d’extradition, '
                'accompagnée du jugement, de l’arrêt ou du mandat d’arrêt constitutif du titre exécutoire.',
              ),
              SizedBox(height: 8),
              _Paragraph(
                'Le procureur général adresse ensuite le dossier au ministre de la Justice. Ce dernier le '
                'transmet au ministre des Affaires étrangères, qui saisit les autorités compétentes de '
                'l’État requis.',
              ),
              SizedBox(height: 8),
              _Paragraph(
                'Au sein de l’Union européenne, la transmission peut être plus directe : le procureur '
                'général remet le dossier au ministre des Affaires étrangères sans passer par '
                'l’intermédiaire du ministre de la Justice.',
              ),
            ],
          ),
          const SizedBox(height: 14),

          // -------------------- France État requis ------------------------
          _ConditionCard(
            title: '3.1.1.2.2 — La France « État requis »',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleCardColor,
            children: [
              const _Paragraph(
                'Lorsque la France est l’État requis, la demande d’extradition est en principe adressée '
                'au ministre des Affaires étrangères par l’État requérant. Celui-ci transmet la requête '
                'au garde des Sceaux qui, après contrôle de sa régularité, la fait parvenir au procureur '
                'général territorialement compétent.',
              ),
              const SizedBox(height: 6),
              _Paragraph.rich([
                const TextSpan(text: 'Cette étape est notamment prévue par '),
                TextSpan(
                  text: 'l’article 696-9 du Code de Procédure Pénale',
                  style: TextStyle(
                    color: lawRed(),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const TextSpan(text: '.'),
              ]),
              const SizedBox(height: 8),
              const _Paragraph(
                'Lorsque la demande émane d’un État membre de l’Union européenne, elle est adressée '
                'directement au ministre de la Justice, sans passer par le ministre des Affaires étrangères.',
              ),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Pour la recherche d’une personne faisant l’objet d’une demande d’extradition ou '
                      'd’une arrestation provisoire en vue d’extradition, ',
                ),
                TextSpan(
                  text: 'l’article 696-9-1 du Code de Procédure Pénale',
                  style: TextStyle(
                    color: lawRed(),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const TextSpan(
                  text:
                      ' rend applicables les dispositions relatives notamment à la '
                      'géolocalisation prévues par les articles 74-2 et 230-33. Les attributions du '
                      'procureur de la République et du juge des libertés et de la détention sont alors '
                      'exercées respectivement par le procureur général et le président de la chambre de '
                      'l’instruction (ou le conseiller qu’il désigne).',
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'L’arrestation de la personne peut être ordonnée. L’agent chargé de son exécution ne '
                      'peut s’introduire dans un domicile que dans les plages horaires prévues par ',
                ),
                TextSpan(
                  text: 'l’article 134 alinéa 1 du Code de Procédure Pénale',
                  style: TextStyle(
                    color: lawRed(),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const TextSpan(text: ' (entre 6 heures et 21 heures).'),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'La personne interpellée bénéficie des règles de la garde à vue, en application de ',
                ),
                TextSpan(
                  text: 'l’article 696-10 du Code de Procédure Pénale',
                  style: TextStyle(
                    color: lawRed(),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const TextSpan(
                  text:
                      ', qui renvoie aux dispositions des articles 63-1 à 63-7 du Code de Procédure Pénale. '
                      'Toutefois, en pratique, le droit à l’assistance d’un avocat lors des auditions et '
                      'confrontations a peu vocation à s’appliquer, la personne n’étant pas entendue sur les '
                      'faits mais uniquement sur son identité avant la notification du titre de recherche '
                      '(circulaire CRIM 11-14/E8 du 31 mai 2011).',
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'La personne appréhendée doit être déférée dans les quarante-huit heures au procureur '
                      'général territorialement compétent (toujours en application de ',
                ),
                TextSpan(
                  text: 'l’article 696-10 du Code de Procédure Pénale',
                  style: TextStyle(
                    color: lawRed(),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const TextSpan(text: ').'),
              ]),
              const SizedBox(height: 8),
              const _Paragraph(
                'Après vérification de l’identité, le procureur général informe, dans une langue que la '
                'personne comprend, de l’existence et du contenu de la demande d’extradition, ainsi que de '
                'la possibilité d’être assistée par un avocat de son choix ou commis d’office. Mention de '
                'ces informations est portée au procès-verbal, à peine de nullité de la procédure.',
              ),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Le procureur général informe également l’intéressé de sa faculté de consentir ou non '
                      'à l’extradition et des conséquences juridiques de ce choix, conformément à ',
                ),
                TextSpan(
                  text: 'l’article 696-10 du Code de Procédure Pénale',
                  style: TextStyle(
                    color: lawRed(),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const TextSpan(text: '.'),
              ]),
              const SizedBox(height: 8),
              const _Paragraph(
                'S’il décide de ne pas laisser la personne en liberté, le procureur général la présente au '
                'premier président de la cour d’appel ou au magistrat du siège qu’il désigne. Celui-ci peut '
                'ordonner l’incarcération et le placement sous écrou extraditionnel à la maison d’arrêt du lieu '
                'de la cour d’appel.',
              ),
              const SizedBox(height: 6),
              _Paragraph.rich([
                const TextSpan(text: 'Cette décision est prévue par '),
                TextSpan(
                  text: 'l’article 696-11 alinéa 2 du Code de Procédure Pénale',
                  style: TextStyle(
                    color: lawRed(),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const TextSpan(
                  text:
                      '. Le premier président (ou le magistrat désigné) peut cependant estimer que la '
                      'représentation de la personne à tous les actes de la procédure est garantie et décider de '
                      'la placer sous contrôle judiciaire ou sous assignation à résidence avec surveillance '
                      'électronique, sur le fondement des ',
                ),
                TextSpan(
                  text: 'articles 138 et 142-5 du Code de Procédure Pénale',
                  style: TextStyle(
                    color: lawRed(),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const TextSpan(text: '.'),
              ]),
              const SizedBox(height: 8),
              const _Paragraph(
                'Un mandat d’arrêt peut être délivré contre la personne laissée libre, soumise au contrôle '
                'judiciaire ou à une assignation à résidence sous surveillance électronique, si elle se '
                'soustrait volontairement à ces obligations.',
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                'Si la personne consent à son extradition, elle comparaît devant la chambre de l’instruction '
                'dans un délai de cinq jours à compter de sa présentation au procureur général. Si elle confirme '
                'son consentement, la chambre de l’instruction lui en donne acte dans les sept jours suivant sa '
                'comparution. En cas de consentement, aucun pourvoi en cassation n’est possible.',
              ),
              const SizedBox(height: 8),
              const _Paragraph(
                'Si la personne ne consent pas à son extradition, elle comparaît devant la chambre de '
                'l’instruction dans un délai de dix jours. Si elle confirme son refus, la chambre rend un avis '
                'motivé sur la demande dans le délai d’un mois. Un pourvoi en cassation, limité à la forme, '
                'reste alors ouvert.',
              ),
            ],
          ),
          const SizedBox(height: 18),

          // ===============================================================
          // 3.1.2  EFFETS DE L’EXTRADITION
          // ===============================================================
          const _SubTitle('3.1.2 — Les effets de l’extradition'),
          const SizedBox(height: 4),

          _ConditionCard(
            title: 'Décision sur la demande et mise en liberté éventuelle',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleCardColor,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Si l’avis motivé de la chambre de l’instruction est défavorable à l’extradition, '
                      'celle-ci ne peut pas être accordée. La personne doit alors être remise en liberté si elle '
                      'n’est pas détenue pour une autre cause, en application de ',
                ),
                TextSpan(
                  text: 'l’article 696-17 du Code de Procédure Pénale',
                  style: TextStyle(
                    color: lawRed(),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const TextSpan(text: '.'),
              ]),
              const SizedBox(height: 8),
              const _Paragraph(
                'Dans les autres cas, lorsque l’avis de la chambre de l’instruction est favorable, '
                'l’extradition est autorisée par un décret du Premier ministre, pris sur le rapport '
                'du ministre de la Justice.',
              ),
              const SizedBox(height: 8),
              const _Paragraph(
                'Si, dans le délai d’un mois suivant la notification du décret à l’État requérant, la personne '
                'n’a pas été effectivement reçue par cet État, elle est remise d’office en liberté et ne peut plus '
                'être réclamée pour la même cause.',
              ),
              const SizedBox(height: 8),
              const _Paragraph(
                'Lorsque l’intéressé se trouve en liberté au moment de la mise à exécution du décret '
                'd’extradition, le procureur général peut ordonner sa recherche et son arrestation. La personne '
                'doit alors être remise à l’État requérant dans les sept jours suivant son arrestation.',
              ),
              const SizedBox(height: 10),
              const _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        'Arrestation provisoire : en cas d’urgence, et sur demande directe des autorités '
                        'compétentes de l’État requérant, le procureur général territorialement compétent peut '
                        'ordonner l’arrestation provisoire de la personne et son placement sous écrou '
                        'extraditionnel. La demande doit mentionner l’intention de transmettre une demande '
                        'd’extradition. À défaut de réception, par l’État français, des documents nécessaires à '
                        'l’extradition dans un délai de trente jours à compter de l’arrestation, la personne est '
                        'remise en liberté. La procédure d’extradition pourra toutefois être reprise ultérieurement '
                        'si les pièces requises sont transmises, conformément aux articles 696-23 et 696-24 du '
                        'Code de Procédure Pénale.',
                  ),
                ],
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
