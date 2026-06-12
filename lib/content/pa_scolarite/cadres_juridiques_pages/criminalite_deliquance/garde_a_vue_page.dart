import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaGardeAVuePageGpxSchool extends StatelessWidget {
  const PaGardeAVuePageGpxSchool({super.key});

  static const String routeName =
      '/pa/dps_dpg/cadres_juridiques/criminalite_organisee/garde_a_vue';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color cardColor = isDark
? const Color(0xFF111218)
: const Color(0xFFFDFDFE);
    final Color accent = isDark
? const Color(0xFF64B5F6)
: const Color(0xFF1565C0);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF0D47A1);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Garde à vue – criminalité organisée',
          style: GoogleFonts.fustat(fontWeight: FontWeight.w700, fontSize: 17),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SubTitle('2.1.4 - La garde à vue'),
              const SizedBox(height: 4),
              const _Paragraph(
                'Dans le cadre de la criminalité et de la délinquance organisées, '
                'le législateur a prévu des règles spécifiques en matière de garde à vue.',
              ),

              const SizedBox(height: 20),
              const _SubTitle(
                '2.1.4.1 - Les dispositions applicables aux majeurs',
              ),

              const SizedBox(height: 10),
              _ConditionCard(
                title: 'Principe et cadre légal – article 706-88',
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: const [
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'L\'article 706-88 du Code de procédure pénale dispose :',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ]),
                  SizedBox(height: 8),
                  _Paragraph(
                    '« Pour l’application des articles 63, 77 et 154, si les nécessités de '
                    'l’enquête ou de l’instruction relatives à l’une des infractions entrant '
                    'dans le champ d’application de l’article 706-73 l’exigent, la garde à vue '
                    'd’une personne peut, à titre exceptionnel, faire l’objet de deux '
                    'prolongations supplémentaires de vingt-quatre heures chacune. '
                    'Ces prolongations sont autorisées, par décision écrite et motivée, soit, '
                    'à la requête du procureur de la République, par le juge des libertés et '
                    'de la détention, soit par le juge d’instruction. '
                    'La personne gardée à vue doit être présentée au magistrat qui statue '
                    'sur la prolongation préalablement à cette décision. '
                    'La seconde prolongation peut toutefois, à titre exceptionnel, être '
                    'autorisée sans présentation préalable de la personne en raison des '
                    'nécessités des investigations en cours ou à effectuer. »',
                  ),
                  SizedBox(height: 10),
                  _Paragraph(
                    'Lorsque la première prolongation est décidée, la personne gardée à vue '
                    'est examinée par un médecin désigné par le procureur de la République, '
                    'le juge d’instruction ou l’officier de police judiciaire. Le médecin '
                    'délivre un certificat médical par lequel il doit notamment se prononcer '
                    'sur l’aptitude au maintien en garde à vue, certificat qui est versé au '
                    'dossier. La personne est avisée par l’officier de police judiciaire de '
                    'son droit de demander un nouvel examen médical. Ces examens médicaux '
                    'sont de droit. Mention de cet avis est portée au procès-verbal et '
                    'émargée par la personne intéressée ; en cas de refus d’émargement, il en '
                    'est fait mention.',
                  ),
                  SizedBox(height: 8),
                  _Paragraph(
                    'Par dérogation aux dispositions du premier alinéa, si la durée prévisible '
                    'des investigations restant à réaliser à l’issue des premières quarante-huit '
                    'heures de garde à vue le justifie, le juge des libertés et de la détention '
                    'ou le juge d’instruction peuvent décider, selon les modalités prévues au '
                    'deuxième alinéa, que la garde à vue fera l’objet d’une seule prolongation '
                    'supplémentaire de quarante-huit heures.',
                  ),
                  SizedBox(height: 8),
                  _Paragraph(
                    'Par dérogation aux dispositions des articles 63-4 à 63-4-2, lorsque la '
                    'personne est gardée à vue pour une infraction entrant dans le champ '
                    'd’application de l’article 706-73, l’intervention de l’avocat peut être '
                    'différée, en considération de raisons impérieuses tenant aux circonstances '
                    'particulières de l’enquête ou de l’instruction, soit pour permettre le '
                    'recueil ou la conservation des preuves, soit pour prévenir une atteinte '
                    'grave à la vie, à la liberté ou à l’intégrité physique d’une personne, '
                    'pendant une durée maximale de quarante-huit heures ou, s’il s’agit d’une '
                    'infraction mentionnée aux 3° ou 11° du même article 706-73, pendant une '
                    'durée maximale de soixante-douze heures.',
                  ),
                  SizedBox(height: 8),
                  _Paragraph(
                    'Le report de l’intervention de l’avocat jusqu’à la fin de la vingt-quatrième '
                    'heure est décidé par le procureur de la République, d’office ou à la '
                    'demande de l’officier de police judiciaire. Le report de l’intervention de '
                    'l’avocat au-delà de la vingt-quatrième heure est décidé, dans les limites '
                    'fixées au sixième alinéa, par le juge des libertés et de la détention '
                    'statuant à la requête du procureur de la République. Lorsque la garde à '
                    'vue intervient au cours d’une commission rogatoire, le report est décidé '
                    'par le juge d’instruction. Dans tous les cas, la décision du magistrat, '
                    'écrite et motivée, précise la durée pour laquelle l’intervention de '
                    'l’avocat est différée.',
                  ),
                  SizedBox(height: 8),
                  _Paragraph(
                    'Lorsqu’il est fait application des sixième et septième alinéas de cet '
                    'article, l’avocat dispose, à partir du moment où il est autorisé à '
                    'intervenir en garde à vue, des droits prévus aux articles 63-4 et 63-4-1, '
                    'au premier alinéa de l’article 63-4-2 et à l’article 63-4-3. '
                    'Cet article n’est pas applicable aux délits prévus au 21° de l’article '
                    '706-73.',
                  ),
                  SizedBox(height: 6),
                  _NotaBox(
                    bodySpans: [
                      TextSpan(
                        text:
                            'Version au 01/07/2025 – SDCP – Tous droits réservés.',
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 22),
              const _SubTitle(
                '2.1.4.1.1 - Les différents cas de prolongations supplémentaires de la durée de la garde à vue',
              ),

              const SizedBox(height: 10),
              _ConditionCard(
                title: 'Au-delà de la durée de droit commun (48 heures)',
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: const [
                  _Paragraph(
                    'Au-delà de la durée de droit commun (48 heures), la garde à vue peut, à '
                    'titre exceptionnel, faire l’objet de deux types de prolongations '
                    'supplémentaires :',
                  ),
                  SizedBox(height: 6),
                  _BulletPoint(
                    text:
                        'Soit deux prolongations supplémentaires de 24 heures chacune, portant '
                        'la durée totale de la mesure à 96 heures. À l’issue de la première '
                        'prolongation supplémentaire de 24 heures, le magistrat peut accorder '
                        'une nouvelle prolongation de 24 heures.',
                  ),
                  _BulletPoint(
                    text:
                        'Soit une seule prolongation supplémentaire de 48 heures, lorsque la '
                        'durée des investigations restant à réaliser le justifie.',
                  ),
                  SizedBox(height: 8),
                  _Paragraph(
                    'La prolongation supplémentaire de la durée de garde à vue est applicable, '
                    'quel que soit le cadre d’enquête, aux seules infractions listées à '
                    'l’article 706-73 du Code de procédure pénale, à l’exception des délits '
                    'douaniers prévus au 21°.',
                  ),
                  SizedBox(height: 4),
                  _Paragraph(
                    'Pour les infractions listées aux articles 706-73-1 et 706-74 du Code de '
                    'procédure pénale, la garde à vue est identique à celle de droit commun.',
                  ),
                  SizedBox(height: 4),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'Dès le début de la mesure, lors de l’information du placement en garde à vue, '
                          'l’officier de police judiciaire est tenu d’aviser le procureur de la République '
                          'de la qualification des faits qu’il a notifiée à la personne (article 63 alinéa 2 '
                          'du Code de procédure pénale).',
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                  SizedBox(height: 4),
                  _Paragraph(
                    'Le procureur de la République peut modifier cette qualification, qui sera '
                    'notifiée à la personne gardée à vue.',
                  ),
                  SizedBox(height: 8),
                  _IntroBullet(
                    text:
                        'La mise en œuvre de ces prolongations suppose que les nécessités de '
                        'l’enquête ou de l’instruction l’exigent et que l’utilisation de cette '
                        'possibilité reste exceptionnelle.',
                  ),
                  _IntroBullet(
                    text:
                        'La ou les prolongations supplémentaires doivent être autorisées par une '
                        'décision écrite et motivée.',
                  ),
                  _IntroBullet(
                    text:
                        'Si la garde à vue a été prescrite sur commission rogatoire, la '
                        'prolongation est autorisée par le juge d’instruction.',
                  ),
                  _IntroBullet(
                    text:
                        'Si la garde à vue a été prescrite dans le cadre d’une enquête de '
                        'flagrance ou préliminaire, la prolongation est autorisée par le juge '
                        'des libertés et de la détention, à la requête du procureur de la '
                        'République.',
                  ),
                  SizedBox(height: 6),
                  _Paragraph(
                    'La présentation préalable de la personne gardée à vue au magistrat est '
                    'obligatoire pour obtenir l’autorisation de prolongation supplémentaire. '
                    'À titre exceptionnel, la seconde prolongation supplémentaire peut être '
                    'autorisée sans présentation préalable de la personne en raison des '
                    'nécessités des investigations en cours ou à effectuer.',
                  ),
                ],
              ),

              const SizedBox(height: 18),
              _ConditionCard(
                title: 'Régimes dérogatoires : terrorisme et « mules »',
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: const [
                  _SubTitle('En matière de terrorisme'),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'En matière de terrorisme, l’article 706-88-1 du Code de procédure pénale ',
                      style: TextStyle(color: Colors.red),
                    ),
                    TextSpan(
                      text:
                          'prévoit que la durée totale de la garde à vue peut, à titre '
                          'exceptionnel, atteindre six jours (144 heures).',
                    ),
                  ]),
                  SizedBox(height: 4),
                  _Paragraph(
                    'La mesure peut faire l’objet d’une prolongation supplémentaire de 24 '
                    'heures, renouvelable une fois, portant la durée maximale de quatre à six '
                    'jours. Cette durée ne s’applique qu’aux infractions expressément visées '
                    'par l’article 706-73, 11°, c’est-à-dire les crimes et délits constituant '
                    'des actes de terrorisme prévus par les articles 421-1 à 421-6 du code '
                    'pénal.',
                  ),
                  SizedBox(height: 6),
                  _IntroBullet(
                    text:
                        'Ce dispositif doit rester exceptionnel et ne peut être mis en œuvre '
                        'que s’il existe un risque sérieux d’imminence d’une action terroriste '
                        'en France ou à l’étranger,',
                  ),
                  _IntroBullet(
                    text:
                        'ou si les nécessités de la coopération internationale le requièrent '
                        'impérativement.',
                  ),
                  SizedBox(height: 10),
                  _Paragraph(
                    'Les prolongations supplémentaires ne peuvent être autorisées que par une '
                    'décision écrite et motivée du juge des libertés et de la détention, soit à '
                    'la requête du procureur de la République, soit à celle du juge '
                    'd’instruction. La présentation préalable de la personne gardée à vue au '
                    'juge des libertés et de la détention doit intervenir lors de chaque '
                    'demande de prolongation.',
                  ),
                  SizedBox(height: 12),
                  _SubTitle(
                    'Pour les passeurs de produits stupéfiants in corpore',
                  ),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'Pour les passeurs de produits stupéfiants in corpore, l’article 706-88-2 du '
                          'Code de procédure pénale ',
                      style: TextStyle(color: Colors.red),
                    ),
                    TextSpan(
                      text:
                          'prévoit que, dans le cadre des crimes et délits de trafic de '
                          'stupéfiants visés au 3° de l’article 706-73 du Code de procédure '
                          'pénale, la garde à vue d’une personne dont il apparaît qu’elle a '
                          'ingéré des produits stupéfiants aux fins d’assurer leur transport '
                          '(« mule »), peut faire l’objet d’une prolongation exceptionnelle de '
                          '24 heures, portant la durée maximale de quatre à cinq jours '
                          '(24 + 24 + [24 + 24] + 24 = 120 heures).',
                    ),
                  ]),
                  SizedBox(height: 6),
                  _Paragraph(
                    'Si une prolongation supplémentaire de la garde à vue est envisagée, la '
                    'personne doit être examinée par un médecin avant l’expiration du délai '
                    'de 96 heures. Le praticien établit alors un certificat indiquant la '
                    'présence ou l’absence de substances stupéfiantes dans le corps de la '
                    'personne et se prononce sur l’aptitude au maintien en garde à vue. Ce '
                    'certificat est versé au dossier.',
                  ),
                  SizedBox(height: 6),
                  _Paragraph(
                    'Cette prolongation ne peut être autorisée que par une décision écrite et '
                    'motivée du juge des libertés et de la détention, soit à la requête du '
                    'procureur de la République, soit à celle du juge d’instruction. '
                    'L’article 706-88-2 du Code de procédure pénale ne prévoit pas de '
                    'présentation préalable de la personne.',
                  ),
                ],
              ),

              const SizedBox(height: 22),
              const _SubTitle('2.1.4.1.2 - Le droit à un examen médical'),

              const SizedBox(height: 10),
              _ConditionCard(
                title: 'Examens médicaux pendant la garde à vue',
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: const [
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'Durant les premières 48 heures, le droit commun s’applique conformément à '
                          'l’article 63-3 du Code de procédure pénale :',
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                  SizedBox(height: 4),
                  _Paragraph(
                    'la personne gardée à vue peut solliciter un examen médical au début de la '
                    'mesure, puis un second examen lors de la prolongation.',
                  ),
                  SizedBox(height: 8),
                  _Paragraph(
                    'Lors de la première prolongation supplémentaire (au début de la 49ème '
                    'heure), le procureur de la République, le juge d’instruction ou '
                    'l’officier de police judiciaire désigne un médecin pour examiner la '
                    'personne. Le médecin délivre un certificat médical par lequel il se '
                    'prononce sur l’aptitude au maintien en garde à vue du mis en cause. Le '
                    'certificat est joint à la procédure.',
                  ),
                  SizedBox(height: 4),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'L’officier de police judiciaire avise également l’intéressé de son droit à '
                          'solliciter un nouvel examen médical et lui fait émarger le procès-verbal '
                          'comportant cet avis (article 706-88 alinéa 4 du Code de procédure pénale).',
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                  SizedBox(height: 8),
                  _Paragraph(
                    'Le texte ne prévoit rien à l’issue de la 72ème heure. Toutefois, la '
                    'circulaire CRIM 04-13 du 02/09/2004 précise qu’il est évident, bien que '
                    'la loi ne le mentionne pas expressément pour les prolongations '
                    'supplémentaires, que le magistrat chargé du contrôle de la mesure ou '
                    'l’officier de police judiciaire peut ordonner un nouvel examen médical '
                    'à tout moment si cela apparaît nécessaire, notamment en cas de garde à '
                    'vue longue concernant des personnes malades ou toxicomanes.',
                  ),
                  SizedBox(height: 10),
                  _SubTitle('En matière de terrorisme'),
                  _Paragraph(
                    'En matière de terrorisme, un examen médical est obligatoire au début de '
                    'chacune des deux prolongations supplémentaires (début de la 97ème et de '
                    'la 121ème heure). Lors de chacune de ces prolongations, la personne '
                    'gardée à vue est avisée de son droit de solliciter un nouvel examen '
                    'médical. Le médecin désigné se prononce sur la compatibilité de la '
                    'prolongation de la mesure avec l’état de santé de l’intéressé (article '
                    '706-88-1 alinéa 3 du Code de procédure pénale).',
                  ),
                  SizedBox(height: 10),
                  _SubTitle(
                    'Pour le cas du passeur de produits stupéfiants in corpore',
                  ),
                  _Paragraph(
                    'Outre l’examen obligatoire préalable à l’autorisation du juge des libertés '
                    'et de la détention, la personne dont la prolongation de la garde à vue a '
                    'été décidée est avisée de son droit de demander un nouvel examen médical '
                    '(article 706-88-2 alinéa 4 du Code de procédure pénale).',
                  ),
                ],
              ),

              const SizedBox(height: 22),
              const _SubTitle(
                '2.1.4.1.3 - Le droit à l’assistance d’un avocat',
              ),

              const SizedBox(height: 10),
              _ConditionCard(
                title: 'Principe général',
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: const [
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'L’article 63-3-1 du Code de procédure pénale dispose que, dès le début de '
                          'la garde à vue et à tout moment au cours de celle-ci, la personne peut '
                          'demander à être assistée d’un avocat.',
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                  SizedBox(height: 6),
                  _IntroBullet(
                    text: 'la possibilité de s’entretenir avec lui ;',
                  ),
                  _IntroBullet(
                    text:
                        'la possibilité de consulter certaines pièces de la procédure ;',
                  ),
                  _IntroBullet(
                    text:
                        'la possibilité pour l’avocat d’assister aux auditions et confrontations, '
                        'ainsi qu’aux opérations de reconstitution d’infraction et de présentation '
                        'pour identification à victime ou témoin.',
                  ),
                ],
              ),

              const SizedBox(height: 14),
              _ConditionCard(
                title: '2.1.4.1.3.1 - Un entretien confidentiel',
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: const [
                  _Paragraph(
                    'En matière de criminalité organisée, les dispositions relatives à '
                    'l’entretien avec l’avocat sont prévues par les articles 706-88 (alinéas 6 '
                    'à 8) et 63-4 du Code de procédure pénale.',
                  ),
                  SizedBox(height: 4),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'L’article 63-4 du Code de procédure pénale précise que : ',
                      style: TextStyle(color: Colors.red),
                    ),
                    TextSpan(
                      text:
                          '« Lorsque la garde à vue fait l’objet de prolongations, la personne '
                          'peut demander à s’entretenir avec un avocat dès le début de la '
                          'prolongation. »',
                    ),
                  ]),
                  SizedBox(height: 6),
                  _Paragraph(
                    'La personne peut s’entretenir avec son avocat une fois par tranche de 24 '
                    'heures. La circulaire (CRIM. 00-13 F1) du 4 décembre 2000 du ministère '
                    'de la Justice précise que, dès la notification de ses droits, la personne '
                    'gardée à vue doit être avisée de ce droit à entretien, aux différentes '
                    'échéances prévues, et doit demander à en bénéficier. Ces demandes sont '
                    'mentionnées dans le procès-verbal de notification.',
                  ),
                  SizedBox(height: 6),
                  _Paragraph(
                    'Lors des notifications des différentes prolongations, la personne gardée à '
                    'vue est à nouveau informée de son droit à être assistée par un avocat.',
                  ),
                  SizedBox(height: 6),
                  _Paragraph(
                    'Dans le cadre des infractions visées aux articles 706-73-1 et 706-74 du '
                    'Code de procédure pénale, ainsi que pour les délits douaniers commis en '
                    'bande organisée visés au 21° de l’article 706-73, la garde à vue peut '
                    'durer 48 heures. Le régime est alors identique au droit commun : deux '
                    'entretiens avec l’avocat, l’un dès le début de la garde à vue, l’autre '
                    'dès le début de la prolongation.',
                  ),
                  SizedBox(height: 6),
                  _Paragraph(
                    'L’avocat désigné peut s’entretenir avec la personne gardée à vue pendant '
                    'une durée de trente minutes dès le début de la mesure. Cet entretien '
                    'permet notamment à la personne gardée à vue de préparer ses auditions, '
                    'auxquelles l’avocat peut assister.',
                  ),
                  SizedBox(height: 10),
                  _SubTitle('En matière de terrorisme et pour les « mules »'),
                  _Paragraph(
                    'En matière de terrorisme, la personne peut également demander à '
                    's’entretenir avec un avocat à l’expiration de la 96ème heure et de la '
                    '120ème heure (article 706-88-1 alinéa 2 du Code de procédure pénale).',
                  ),
                  SizedBox(height: 4),
                  _Paragraph(
                    'Les passeurs de produits stupéfiants in corpore (« mules ») peuvent aussi '
                    'solliciter un entretien à l’expiration de la 96ème heure lorsque leur '
                    'garde à vue est prolongée dans ce cadre (article 706-88-2 alinéa 3 du '
                    'Code de procédure pénale).',
                  ),
                ],
              ),

              const SizedBox(height: 16),
              _ConditionCard(
                title:
                    '2.1.4.1.3.2 - Consultation de certaines pièces de procédure',
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: const [
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'L’avocat peut consulter certaines pièces de procédure limitativement '
                          'énumérées à l’article 63-4-1 du Code de procédure pénale :',
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                  SizedBox(height: 6),
                  _BulletPoint(
                    text:
                        'le procès-verbal de placement en garde à vue et des droits ;',
                  ),
                  _BulletPoint(
                    text:
                        'le certificat médical établi en application de l’article 63-3 ;',
                  ),
                  _BulletPoint(
                    text:
                        'les procès-verbaux d’auditions et de confrontations de la personne '
                        'qu’il assiste, y compris celles réalisées en son absence et celles '
                        'antérieures à la garde à vue en cours, lorsqu’elles concernent les '
                        'mêmes faits.',
                  ),
                  SizedBox(height: 6),
                  _Paragraph(
                    'L’avocat décide s’il souhaite prendre connaissance de ces pièces avant ou '
                    'après l’entretien confidentiel. Il ne peut en demander ou en réaliser une '
                    'copie, mais peut prendre des notes. Il ne peut conserver ces documents '
                    'lors de l’entretien.',
                  ),
                ],
              ),

              const SizedBox(height: 16),
              _ConditionCard(
                title:
                    '2.1.4.1.3.3 - Présence de l’avocat lors de certains actes de la procédure',
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: const [
                  _Paragraph(
                    'À l’exclusion de tout autre acte de procédure, l’avocat peut assister :',
                  ),
                  SizedBox(height: 4),
                  _BulletPoint(
                    text:
                        'aux auditions et confrontations de la personne gardée à vue '
                        '(article 63-4-2 du Code de procédure pénale) ;',
                  ),
                  _BulletPoint(
                    text:
                        'aux opérations de reconstitution d’infraction auxquelles elle participe '
                        '(article 61-3 alinéa 2 du Code de procédure pénale) ;',
                  ),
                  _BulletPoint(
                    text:
                        'aux séances d’identification de suspects dont elle fait partie '
                        '(article 61-3 alinéa 3 du Code de procédure pénale).',
                  ),
                  SizedBox(height: 6),
                  _Paragraph(
                    'Si la personne gardée à vue a demandé l’assistance d’un avocat pour ses '
                    'auditions et confrontations, elle ne peut être entendue sur les faits sans '
                    'la présence de l’avocat choisi ou commis d’office, sauf renonciation '
                    'expresse de sa part mentionnée au procès-verbal.',
                  ),
                  SizedBox(height: 4),
                  _Paragraph(
                    'Si l’avocat désigné ne peut être contacté ou déclare ne pas pouvoir se '
                    'présenter dans un délai de deux heures à compter de l’avis qui lui a été '
                    'adressé, ou s’il ne se présente pas dans ce délai, l’officier de police '
                    'judiciaire, ou sous son contrôle l’agent de police judiciaire ou '
                    'l’assistant d’enquête, saisit sans délai le bâtonnier aux fins de '
                    'désignation d’un avocat commis d’office, et en informe la personne '
                    'gardée à vue.',
                  ),
                  SizedBox(height: 6),
                  _Paragraph(
                    'L’officier de police judiciaire conserve la direction exclusive de '
                    'l’audition. L’avocat peut prendre des notes mais ne peut pas intervenir '
                    'au cours de l’audition ni conseiller son client pendant celle-ci. À '
                    'l’issue de l’audition, l’avocat peut poser des questions directement à '
                    'son client ; les questions et réponses sont consignées au procès-verbal. '
                    'L’enquêteur peut s’opposer à une question si elle nuit au bon déroulement '
                    'de l’enquête, ce refus étant acté au procès-verbal.',
                  ),
                  SizedBox(height: 6),
                  _Paragraph(
                    'L’avocat peut relire le procès-verbal d’audition et de confrontation, mais '
                    'il ne le signe pas. Il peut formuler des observations écrites qui seront '
                    'annexées à la procédure.',
                  ),
                  SizedBox(height: 6),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'En cas de transport de la personne gardée à vue pour les nécessités de '
                          'l’enquête, son avocat en est informé sans délai. L’article 63-4-3-1 du '
                          'Code de procédure pénale ',
                      style: TextStyle(color: Colors.red),
                    ),
                    TextSpan(
                      text:
                          'prévoit que cet avis doit se limiter aux déplacements donnant lieu à '
                          'une audition, une opération de reconstitution ou une séance '
                          'd’identification des suspects à laquelle participe la personne '
                          'gardée à vue. Cette information ne concerne pas les transports liés '
                          'à une hospitalisation, à un examen médical ou à une présentation '
                          'devant un magistrat.',
                    ),
                  ]),
                  SizedBox(height: 6),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'L’article D. 15-5-6 du Code de procédure pénale précise que ',
                      style: TextStyle(color: Colors.red),
                    ),
                    TextSpan(
                      text:
                          'la personne placée en garde à vue ayant sollicité l’assistance d’un '
                          'avocat ne peut faire l’objet d’une audition dans un autre lieu que '
                          'celui du service enquêteur si son avocat n’a pas été avisé de ce '
                          'déplacement.',
                    ),
                  ]),
                  SizedBox(height: 6),
                  _Paragraph(
                    'En pratique, l’information est le plus souvent donnée lors d’une audition '
                    'préalable en présence de l’avocat. Si l’avocat n’est pas présent au '
                    'moment où le transport est décidé, il doit en être informé par tout '
                    'moyen, sans que les enquêteurs aient toutefois l’obligation matérielle '
                    'd’emmener l’avocat sur les lieux.',
                  ),
                  SizedBox(height: 6),
                  _Paragraph(
                    'L’avocat n’a pas à assister aux perquisitions. Les objets saisis peuvent '
                    'être présentés à la personne gardée à vue ; cette présentation doit se '
                    'limiter à une interpellation simple sans entraîner d’explications longues '
                    'et détaillées. À son retour au service, l’officier de police judiciaire '
                    'peut entendre la personne en présence de l’avocat afin de faire confirmer '
                    'les déclarations faites au cours de la perquisition.',
                  ),
                  SizedBox(height: 6),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'À l’issue de chacune des opérations auxquelles il assiste, l’avocat peut '
                          'présenter des observations écrites qui sont jointes à la procédure. Il '
                          'peut également les adresser directement au procureur de la République '
                          '(article 63-4-3 du Code de procédure pénale).',
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                ],
              ),

              const SizedBox(height: 16),
              _ConditionCard(
                title: '2.1.4.1.3.4 - Autorisation d’audition immédiate',
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: const [
                  _Paragraph.rich([
                    TextSpan(
                      text: 'L’article 63-4-2-1 du Code de procédure pénale ',
                      style: TextStyle(color: Colors.red),
                    ),
                    TextSpan(
                      text:
                          'prévoit qu’à la demande de l’officier de police judiciaire, le '
                          'procureur de la République peut décider de faire procéder '
                          'immédiatement à l’audition de la personne gardée à vue ou à des '
                          'confrontations.',
                    ),
                  ]),
                  SizedBox(height: 4),
                  _IntroBullet(
                    text:
                        'Cette décision doit être écrite, motivée et indispensable pour éviter '
                        'une situation susceptible de compromettre sérieusement une procédure '
                        'pénale,',
                  ),
                  _IntroBullet(
                    text:
                        'ou pour prévenir une atteinte grave à la vie, à la liberté ou à '
                        'l’intégrité physique d’une personne.',
                  ),
                  SizedBox(height: 6),
                  _Paragraph(
                    'L’audition ou la confrontation peut alors débuter sans l’assistance de '
                    'l’avocat. Dès son arrivée, la personne gardée à vue est immédiatement '
                    'informée de cette décision. L’audition est interrompue à sa demande afin '
                    'de lui permettre de s’entretenir avec son avocat dans les conditions de '
                    'l’article 63-4 et pour que celui-ci prenne connaissance des documents '
                    'mentionnés à l’article 63-4-1. Si la personne ne demande pas cet '
                    'entretien, l’avocat peut néanmoins assister à l’audition ou à la '
                    'confrontation dès son arrivée dans les locaux de police judiciaire.',
                  ),
                ],
              ),

              const SizedBox(height: 16),
              _ConditionCard(
                title: '2.1.4.1.3.5 - Report de l’intervention de l’avocat',
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: const [
                  _Paragraph.rich([
                    TextSpan(
                      text: 'L’article 706-88 du Code de procédure pénale ',
                      style: TextStyle(color: Colors.red),
                    ),
                    TextSpan(
                      text:
                          'permet que l’intervention de l’avocat soit différée, en considération '
                          'de raisons impérieuses tenant aux circonstances particulières de '
                          'l’enquête ou de l’instruction : pour permettre le recueil ou la '
                          'conservation des preuves, ou pour prévenir une atteinte grave à la '
                          'vie, à la liberté ou à l’intégrité physique d’une personne.',
                    ),
                  ]),
                  SizedBox(height: 6),
                  _Paragraph(
                    'Ce report peut atteindre une durée maximale de 48 heures, voire de 72 '
                    'heures lorsqu’il s’agit d’une infraction mentionnée aux 3° ou 11° de '
                    'l’article 706-73 (stupéfiants ou terrorisme). Ces durées s’apprécient '
                    'à compter du début de la mesure de garde à vue.',
                  ),
                  SizedBox(height: 4),
                  _Paragraph(
                    'Le report fait l’objet d’une décision écrite et motivée qui en précise la '
                    'durée :',
                  ),
                  SizedBox(height: 4),
                  _BulletPoint(
                    text:
                        'jusqu’à la 24ème heure : par le procureur de la République, d’office '
                        'ou sur demande de l’officier de police judiciaire ;',
                  ),
                  _BulletPoint(
                    text:
                        'au-delà de la 24ème heure : par le juge des libertés et de la '
                        'détention, à la requête du procureur de la République.',
                  ),
                  SizedBox(height: 6),
                  _Paragraph(
                    'Pendant la durée du report, l’avocat ne peut ni s’entretenir avec la '
                    'personne gardée à vue, ni consulter les documents, ni assister aux '
                    'auditions et confrontations. L’avis à avocat est donc retardé, et le '
                    'gardé à vue est informé que l’avocat ne se présentera qu’à l’issue du '
                    'délai de report accordé.',
                  ),
                ],
              ),

              const SizedBox(height: 22),
              const _SubTitle(
                '2.1.4.1.4 - Droit de faire prévenir, défèrement et remise en liberté',
              ),

              const SizedBox(height: 10),
              _ConditionCard(
                title: '2.1.4.1.4 - Droit de faire prévenir un proche',
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: const [
                  _Paragraph(
                    'En matière de terrorisme ou pour les « mules », si la demande de la '
                    'personne gardée à vue de faire prévenir une personne avec laquelle elle '
                    'vit habituellement, l’un de ses parents en ligne directe, l’un de ses '
                    'frères et sœurs ou son employeur n’a pas été satisfaite, elle peut '
                    'réitérer cette demande à compter de la 96ème heure de garde à vue, dans '
                    'les conditions prévues aux articles 63-1 et 63-2 du Code de procédure '
                    'pénale (article 706-88-1 alinéa 4 et article 706-88-2 alinéa 5 du Code '
                    'de procédure pénale).',
                  ),
                  SizedBox(height: 4),
                  _Paragraph(
                    'Le report de l’avis aux autorités consulaires est impossible au-delà de '
                    'la 48ème heure.',
                  ),
                ],
              ),

              const SizedBox(height: 14),
              _ConditionCard(
                title: '2.1.4.1.4.1 - Le défèrement',
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: const [
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'Les dispositions des articles 803-2 et 803-3 du Code de procédure pénale ',
                      style: TextStyle(color: Colors.red),
                    ),
                    TextSpan(
                      text:
                          's’appliquent de la même façon qu’en droit commun, à une exception '
                          'près : la personne ayant fait l’objet d’une garde à vue d’une durée '
                          'supérieure à 72 heures, en application des articles 706-88 ou '
                          '706-88-1 du Code de procédure pénale, doit comparaître devant le '
                          'magistrat le jour même de la levée de la garde à vue.',
                    ),
                  ]),
                ],
              ),

              const SizedBox(height: 14),
              _ConditionCard(
                title: '2.1.4.1.4.2 - La remise en liberté',
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: const [
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'En matière de criminalité organisée, l’article 706-105 du Code de procédure '
                          'pénale ',
                      style: TextStyle(color: Colors.red),
                    ),
                    TextSpan(
                      text:
                          'se substitue à l’article 77-2 du Code de procédure pénale applicable en '
                          'droit commun. Il permet à une personne placée en garde à vue et à '
                          'l’égard de laquelle il a été fait usage des dispositions des '
                          'articles 706-80 à 706-95 du Code de procédure pénale (surveillance, '
                          'infiltration, garde à vue, perquisitions, interception de '
                          'correspondances) d’interroger le procureur de la République dans le '
                          'ressort duquel la garde à vue s’est déroulée, six mois après le '
                          'placement, sur les suites données à l’affaire.',
                    ),
                  ]),
                ],
              ),

              const SizedBox(height: 24),
              const _SubTitle(
                '2.1.4.2 - Les dispositions applicables aux mineurs',
              ),

              const SizedBox(height: 10),
              _ConditionCard(
                title: '2.1.4.2.1 - Le principe',
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: const [
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'L’article L. 413-11 du code de la justice pénale des mineurs ',
                      style: TextStyle(color: Colors.red),
                    ),
                    TextSpan(
                      text:
                          'dispose que le régime de garde à vue des majeurs en matière de '
                          'criminalité organisée (article 706-88 du Code de procédure pénale) '
                          's’applique aux mineurs âgés de plus de 16 ans si deux conditions '
                          'sont cumulativement remplies :',
                    ),
                  ]),
                  SizedBox(height: 6),
                  _BulletPoint(
                    text:
                        'il existe une ou plusieurs raisons plausibles de soupçonner le mineur '
                        'd’avoir commis l’une des infractions de l’article 706-73 du Code de '
                        'procédure pénale (sauf le 21°) ;',
                  ),
                  _BulletPoint(
                    text:
                        'une ou plusieurs personnes majeures ont participé, comme auteurs ou '
                        'complices, à la commission de cette infraction.',
                  ),
                ],
              ),

              const SizedBox(height: 14),
              _ConditionCard(
                title: '2.1.4.2.2 - Les limites',
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: const [
                  _BulletPoint(
                    text:
                        'La garde à vue des mineurs de moins de 16 ans ne peut être prolongée '
                        'au-delà de 48 heures.',
                  ),
                  _BulletPoint(
                    text:
                        'Les dispositions relatives au report de l’assistance de l’avocat dans '
                        'le cadre de la criminalité organisée (sixième à huitième alinéas de '
                        'l’article 706-88 du Code de procédure pénale) ne sont pas applicables '
                        'aux mineurs.',
                  ),
                ],
              ),

              const SizedBox(height: 26),
              const _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        'Version au 01/07/2025 – SDCP – Tous droits réservés. '
                        'Cette fiche est destinée à un usage pédagogique interne et doit être '
                        'mise à jour en cas de réforme du Code de procédure pénale ou du code '
                        'de la justice pénale des mineurs.',
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
