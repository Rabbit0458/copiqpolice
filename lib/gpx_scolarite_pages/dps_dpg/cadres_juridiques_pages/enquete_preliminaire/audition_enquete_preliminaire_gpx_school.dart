import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuditionEnquetePreliminaireGpxSchool extends StatelessWidget {
  const AuditionEnquetePreliminaireGpxSchool({super.key});

  static const String routeName =
      '/gpx/cadres_juridiques/enquete_preliminaire/actes/auditions';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color cardBlue = isDark
        ? const Color(0xFF0D47A1).withOpacity(.22)
        : const Color(0xFFE3F2FD);
    final Color accentBlue = isDark
        ? const Color(0xFF90CAF9)
        : const Color(0xFF1565C0);
    final Color titleBlue = isDark
        ? const Color(0xFFBBDEFB)
        : const Color(0xFF0D47A1);

    return Scaffold(
      appBar: AppBar(title: const Text('Les auditions')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '2.3.7 - Les auditions',
                style: GoogleFonts.fustat(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),

              ////////////////////////////////////////////////////////////////
              /// 2.3.7.1 - L’audition du témoin
              ////////////////////////////////////////////////////////////////
              _ConditionCard(
                title: '2.3.7.1 - L’audition du témoin',
                cardColor: cardBlue,
                accent: accentBlue,
                titleColor: titleBlue,
                children: const [
                  _Paragraph(
                    'L’article 78 alinéa 1 du Code de procédure pénale pose le principe selon '
                    'lequel les personnes convoquées par un officier de police judiciaire pour '
                    'les nécessités de l’enquête sont tenues de comparaître. « L’officier de '
                    'police judiciaire peut contraindre à comparaître par la force publique, '
                    'avec l’autorisation préalable du procureur de la République, les personnes '
                    'qui n’ont pas répondu à une convocation à comparaître ou dont on peut '
                    'craindre qu’elles ne répondent pas à une telle convocation ».',
                  ),
                  SizedBox(height: 8),
                  _Paragraph(
                    'Ces dispositions de l’article 78 alinéa 1 du Code de procédure pénale '
                    'peuvent s’appliquer, quelle que soit l’infraction (crime, délit, '
                    'contravention) aux personnes à l’encontre desquelles il existe une ou '
                    'plusieurs raisons plausibles de soupçonner qu’elles ont commis ou tenté '
                    'de commettre une infraction, mais également aux simples témoins.',
                  ),
                  SizedBox(height: 8),
                  _Paragraph(
                    'Le procureur de la République peut également autoriser la comparution par '
                    'la force publique sans convocation préalable en cas de risque de '
                    'modification des preuves ou indices matériels, de pressions sur les '
                    'témoins ou les victimes ainsi que sur leur famille ou leurs proches, ou '
                    'de concertation entre les coauteurs ou complices de l’infraction.',
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _ConditionCard(
                title:
                    'Arrêt de la Cour de cassation et limites à la contrainte au domicile',
                cardColor: cardBlue,
                accent: accentBlue,
                titleColor: titleBlue,
                children: const [
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'Dans son arrêt n° 16-82.412 du 22 février 2017, la Cour de cassation '
                          'a affirmé que la pénétration de force dans un domicile pour exécuter '
                          'un ordre de comparution était exclue. ',
                    ),
                    TextSpan(
                      text:
                          'Cette limitation vise le domicile de la personne nommément visée dans '
                          'l’ordre de comparution forcée mais également celui d’un tiers, et ce '
                          'quel que soit le moyen employé (recours à un serrurier ou utilisation '
                          'd’un bélier).',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ]),
                  SizedBox(height: 8),
                  _Paragraph(
                    'Ces dispositions concernent les personnes mises en cause ainsi que les '
                    'témoins dans le cadre de l’enquête de flagrance sur le fondement de '
                    'l’article 61 du Code de procédure pénale.',
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _ConditionCard(
                title: 'Pénétration au domicile : cas autorisés',
                cardColor: cardBlue,
                accent: accentBlue,
                titleColor: titleBlue,
                children: const [
                  _Paragraph(
                    'La pénétration dans le domicile d’une personne est toutefois autorisée en '
                    'matière :',
                  ),
                  SizedBox(height: 6),
                  _BulletPoint(
                    text:
                        'd’exécution d’une peine d’emprisonnement ou de réclusion (article 716-5 du Code de procédure pénale) ;',
                  ),
                  _BulletPoint(
                    text:
                        'd’exécution d’un mandat d’amener, d’arrêt ou de recherche ;',
                  ),
                  _BulletPoint(
                    text:
                        'de demande d’extradition ou d’un mandat d’arrêt européen (article 134 du Code de procédure pénale).',
                  ),
                  SizedBox(height: 8),
                  _Paragraph(
                    'L’article 78 du Code de procédure pénale permet seulement '
                    'l’appréhension forcée sur la voie publique de la personne convoquée. '
                    'Cette décision limite de façon explicite les pouvoirs contraignants des '
                    'agents de la force publique dans le cadre de l’article 78 du Code de '
                    'procédure pénale.',
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _ConditionCard(
                title:
                    'Mandat de recherche et perquisition / visite domiciliaire sans assentiment',
                cardColor: cardBlue,
                accent: accentBlue,
                titleColor: titleBlue,
                children: const [
                  _Paragraph(
                    'Si la pénétration dans un domicile s’avère nécessaire à l’appréhension de '
                    'la personne convoquée, le procureur de la République dispose de la '
                    'possibilité de délivrer un mandat de recherche (article 77-4 du Code de '
                    'procédure pénale), à la condition préalable que la personne recherchée '
                    'soit soupçonnée d’avoir commis ou tenté de commettre un crime ou un délit '
                    'puni d’au moins trois ans d’emprisonnement. L’agent chargé de l’exécution '
                    'du mandat est autorisé à s’introduire dans le domicile entre 6 heures et '
                    '21 heures.',
                  ),
                  SizedBox(height: 8),
                  _Paragraph(
                    'Conjointement à la réquisition délivrée par le magistrat du parquet '
                    'conformément à l’article 78 du Code de procédure pénale, une autorisation '
                    'du juge des libertés et de la détention aux fins de perquisition ou de '
                    'visite domiciliaire sans assentiment peut être sollicitée pour les crimes '
                    'ou les délits punis d’une peine égale ou supérieure à 3 ans '
                    'd’emprisonnement (article 76 du Code de procédure pénale).',
                  ),
                  SizedBox(height: 8),
                  _Paragraph(
                    'Cette perquisition ne peut être autorisée par le juge des libertés et de '
                    'la détention qu’aux fins de recueil de preuves ou de saisie de biens dont '
                    'la confiscation est prévue par l’article 131-21 du Code pénal. La preuve '
                    'recherchée peut toutefois résider dans la nécessité de procéder à une '
                    'audition.',
                  ),
                  SizedBox(height: 8),
                  _Paragraph(
                    'En dehors de ces cas, l’entrée dans les lieux pour contraindre à comparaître '
                    'une personne n’est plus possible dans le cadre de l’article 78 du Code pénal.',
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _ConditionCard(
                title: 'Durée de la retenue et principe de l’audition libre',
                cardColor: cardBlue,
                accent: accentBlue,
                titleColor: titleBlue,
                children: const [
                  _Paragraph(
                    'Les personnes à l’encontre desquelles il n’existe aucune raison plausible '
                    'de soupçonner qu’elles ont commis ou tenté de commettre une infraction ne '
                    'peuvent être retenues que le temps strictement nécessaire à leur audition, '
                    'sans que cette durée ne puisse excéder quatre heures.',
                  ),
                  SizedBox(height: 8),
                  _Paragraph(
                    'Plusieurs auditions d’une même personne, chacune d’une durée maximale de '
                    'quatre heures, peuvent être réalisées si les nécessités de l’enquête '
                    'l’exigent et si la personne a quitté librement les locaux de police au '
                    'terme de son audition. Une convocation pour une audition ultérieure doit '
                    'lui avoir été remise.',
                  ),
                  SizedBox(height: 8),
                  _Paragraph(
                    'Aucune sanction ne s’attache au fait, pour la personne retenue, de refuser '
                    'de déposer ; dans une telle hypothèse, il convient de faire mention de ce '
                    'refus dans la procédure et de ne pas retenir plus longtemps la personne, '
                    'si aucune mesure de garde à vue n’est envisagée à son encontre.',
                  ),
                  SizedBox(height: 8),
                  _Paragraph(
                    'Conformément au principe général posé par l’article 75 du Code de '
                    'procédure pénale, les agents de police judiciaire désignés à l’article 20 '
                    'du Code de procédure pénale peuvent, sous le contrôle d’un officier de '
                    'police judiciaire, procéder à l’audition des personnes convoquées.',
                  ),
                  SizedBox(height: 8),
                  _Paragraph(
                    'Le dernier alinéa de l’article 78 du Code de procédure pénale renvoie aux '
                    'articles 61 et 62-1 du Code de procédure pénale pour l’établissement des '
                    'procès-verbaux.',
                  ),
                  SizedBox(height: 8),
                  _Paragraph(
                    'Les témoins pourront, sur autorisation du procureur de la République, '
                    'déclarer comme domicile l’adresse du commissariat ou de la brigade de '
                    'gendarmerie (article 706-57 du Code de procédure pénale). L’adresse '
                    'réelle de ces personnes est inscrite sur un registre ouvert à cet effet et '
                    'tenu sous format papier ou numérique.',
                  ),
                  SizedBox(height: 8),
                  _Paragraph(
                    'Si la personne a été convoquée en raison de sa profession, l’adresse '
                    'déclarée peut être son adresse professionnelle. L’autorisation du '
                    'procureur de la République n’est pas nécessaire lorsque le témoignage est '
                    'apporté par une personne dépositaire de l’autorité publique ou chargée '
                    'd’une mission de service public pour des faits qu’elle a connus en raison '
                    'de ses fonctions ou de sa mission et que l’adresse déclarée est son '
                    'adresse professionnelle.',
                  ),
                  SizedBox(height: 8),
                  _Paragraph(
                    'Les procès-verbaux d’audition doivent comporter les questions auxquelles '
                    'il est répondu (article 429 du Code de procédure pénale).',
                  ),
                ],
              ),
              const SizedBox(height: 20),

              ////////////////////////////////////////////////////////////////
              /// 2.3.7.2 - L’audition du témoin qui devient suspect
              ////////////////////////////////////////////////////////////////
              _ConditionCard(
                title: '2.3.7.2 - L’audition du témoin qui devient suspect',
                cardColor: cardBlue,
                accent: accentBlue,
                titleColor: titleBlue,
                children: const [
                  _Paragraph(
                    'Au cours de l’audition, si l’enquêteur découvre des raisons plausibles de '
                    'soupçonner que la personne entendue a commis ou tenté de commettre un '
                    'crime ou un délit puni d’une peine d’emprisonnement, le statut de témoin '
                    'disparaît.',
                  ),
                  SizedBox(height: 8),
                  _Paragraph(
                    'L’enquêteur dispose alors de deux possibilités :',
                  ),
                  SizedBox(height: 6),
                  _BulletPoint(
                    text:
                        'poursuivre l’audition en faisant immédiatement bénéficier la personne '
                        'des droits de l’article 61-1 du Code de procédure pénale attachés au '
                        'suspect entendu en audition libre ;',
                  ),
                  _BulletPoint(
                    text:
                        'décider du placement en garde à vue si les conditions sont réunies et '
                        'que ce placement est nécessaire pour la conduite des investigations.',
                  ),
                  SizedBox(height: 8),
                  _Paragraph(
                    'Lorsque la personne manifeste sa volonté de quitter les locaux de police '
                    'et de gendarmerie, elle ne peut être placée en garde à vue du seul fait '
                    'qu’elle ne souhaite plus répondre aux questions des enquêteurs. Le témoin '
                    'retenu sous contrainte devenant suspect ne peut être maintenu à la '
                    'disposition des enquêteurs que sous le régime de la garde à vue.',
                  ),
                ],
              ),
              const SizedBox(height: 20),

              ////////////////////////////////////////////////////////////////
              /// 2.3.7.3 - Audition hors garde à vue
              ////////////////////////////////////////////////////////////////
              _ConditionCard(
                title:
                    '2.3.7.3 - L’audition hors garde à vue d’une personne suspecte',
                cardColor: cardBlue,
                accent: accentBlue,
                titleColor: titleBlue,
                children: const [
                  _Paragraph(
                    'L’article préliminaire du Code de procédure pénale dispose que si la '
                    'personne suspectée ou poursuivie ne comprend pas la langue française, '
                    'elle a droit, dans une langue qu’elle comprend et jusqu’au terme de la '
                    'procédure, à l’assistance d’un interprète, y compris pour les entretiens '
                    'avec son avocat ayant un lien direct avec tout interrogatoire.',
                  ),
                  SizedBox(height: 8),
                  _Paragraph(
                    'Les dispositions de l’audition libre s’appliquent à l’enquête '
                    'préliminaire, y compris pour les personnes convoquées en application de '
                    'l’article 78 du Code de procédure pénale.',
                  ),
                  SizedBox(height: 8),
                  _Paragraph(
                    'Au début de l’audition, l’officier ou l’agent de police judiciaire doit '
                    'systématiquement demander à la personne de confirmer qu’elle a suivi de '
                    'son plein gré les agents de la force publique et qu’elle n’a subi aucune '
                    'contrainte lors du transport.',
                  ),
                  SizedBox(height: 8),
                  _Paragraph(
                    'La personne suspectée doit ensuite être informée des droits suivants '
                    '(article 61-1 du Code de procédure pénale) :',
                  ),
                  SizedBox(height: 6),
                  _BulletPoint(
                    text:
                        'le droit d’être informée de la qualification, de la date et du lieu '
                        'présumés de l’infraction qu’elle est soupçonnée d’avoir commise ou '
                        'tenté de commettre ;',
                  ),
                  _BulletPoint(
                    text:
                        'le droit de quitter à tout moment les locaux où elle est entendue ;',
                  ),
                  _BulletPoint(
                    text:
                        'le droit d’être assistée par un interprète, le cas échéant ;',
                  ),
                  _BulletPoint(
                    text:
                        'le droit de faire des déclarations, de répondre aux questions qui lui '
                        'sont posées ou de se taire ;',
                  ),
                  _BulletPoint(
                    text:
                        'le droit d’être assistée d’un avocat au cours de son audition ou de sa '
                        'confrontation, mais également lors des reconstitutions d’infraction et '
                        'de la présentation pour identification à victime ou témoin, si '
                        'l’infraction est un crime ou un délit puni d’une peine '
                        'd’emprisonnement ;',
                  ),
                  _BulletPoint(
                    text:
                        'la possibilité de bénéficier, le cas échéant gratuitement, de conseils '
                        'juridiques dans une structure d’accès au droit.',
                  ),
                  SizedBox(height: 8),
                  _Paragraph(
                    'Si la personne souhaite mettre un terme à l’audition et quitter les locaux '
                    'de police ou de gendarmerie, un placement en garde à vue ne peut se '
                    'justifier sur le seul fait qu’elle refuse de répondre aux questions. Il '
                    'convient de laisser partir l’intéressé et de le convoquer pour une date '
                    'ultérieure.',
                  ),
                  SizedBox(height: 8),
                  _Paragraph(
                    'Toutefois, si l’un ou plusieurs des motifs prévus à l’article 62-2 du Code '
                    'de procédure pénale peuvent être retenus, le placement en garde à vue est '
                    'possible.',
                  ),
                  SizedBox(height: 8),
                  _Paragraph(
                    'Lorsqu’une personne auditionnée sous le statut de suspect libre est, dans '
                    'le prolongement immédiat, placée en garde à vue, le décompte du délai de '
                    'garde à vue commence à courir à partir de l’heure du début de l’audition '
                    'libre.',
                  ),
                ],
              ),
              const SizedBox(height: 20),

              ////////////////////////////////////////////////////////////////
              /// 2.3.7.4 à 2.3.7.6
              ////////////////////////////////////////////////////////////////
              _ConditionCard(
                title:
                    '2.3.7.4 à 2.3.7.6 - Audition de la personne gardée à vue, '
                    'enregistrement et auditions à l’étranger',
                cardColor: cardBlue,
                accent: accentBlue,
                titleColor: titleBlue,
                children: const [
                  _Paragraph(
                    'La personne placée en garde à vue peut demander à être assistée de son '
                    'avocat lors des auditions et confrontations, mais également lors des '
                    'reconstitutions d’infraction et de la présentation pour identification à '
                    'victime ou témoin. L’audition se déroule alors en présence de l’avocat, '
                    'l’enquêteur en conservant la direction exclusive. À l’issue de l’audition, '
                    'l’avocat peut poser des questions directement à son client ; les questions '
                    'et les réponses sont inscrites au procès-verbal. L’avocat peut relire le '
                    'procès-verbal d’audition, mais, contrairement à la personne gardée à vue, '
                    'il n’a pas à le signer.',
                  ),
                  SizedBox(height: 8),
                  _Paragraph(
                    'L’enregistrement des auditions durant la garde à vue, en matière '
                    'criminelle, renvoie à la procédure de flagrant délit (article 64-1 du Code '
                    'de procédure pénale).',
                  ),
                  SizedBox(height: 8),
                  _Paragraph(
                    'Enfin, l’article 18 alinéa 4 du Code de procédure pénale permet aux '
                    'officiers de police judiciaire de procéder à des auditions sur le '
                    'territoire d’un État étranger, avec l’accord des autorités compétentes de '
                    'l’État concerné et sur réquisitions du procureur de la République.',
                  ),
                ],
              ),
              const SizedBox(height: 24),
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
