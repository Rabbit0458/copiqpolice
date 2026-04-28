import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AutresTechniquesGpxSchool extends StatelessWidget {
  const AutresTechniquesGpxSchool({super.key});

  static const String routeName =
      '/gpx/cadres_juridiques/criminalite_organisee/techniques_speciales';

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
          'Techniques spéciales d’enquête',
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
              const _SubTitle(
                '2.1.7 - Les autres techniques spéciales d’enquête',
              ),
              const SizedBox(height: 4),
              const _Paragraph.rich([
                TextSpan(
                  text:
                      'Une section dans le code de procédure pénale intitulée « Des autres '
                      'techniques spéciales d’enquête », comprenant les articles 706-95-11 à '
                      '706-102-5, institue un régime commun à trois techniques d’enquête :',
                  style: TextStyle(color: Colors.red),
                ),
              ]),
              const SizedBox(height: 6),
              const _IntroBullet(text: 'le recours à l’IMSI-catcher ;'),
              const _IntroBullet(
                text: 'la sonorisation et la fixation d’images ;',
              ),
              const _IntroBullet(
                text: 'la captation de données informatiques.',
              ),

              const SizedBox(height: 18),
              const _SubTitle('2.1.7.1 - Champ d’application'),
              const SizedBox(height: 8),
              _ConditionCard(
                title: 'Champ d’application des techniques spéciales',
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: const [
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'Ces techniques peuvent être mises en œuvre si les nécessités de '
                          'l’enquête relative à l’une des infractions entrant dans le champ '
                          'd’application des articles 706-73 et 706-73-1 du Code de procédure '
                          'pénale l’exigent (article 706-95-11 du Code de procédure pénale).',
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                  SizedBox(height: 8),
                  _NotaBox(
                    bodySpans: [
                      TextSpan(
                        text:
                            'Ces techniques sont également applicables à certaines infractions '
                            'relatives aux systèmes de traitement automatisé de données '
                            'commises en bande organisée (article 706-72 du code de procédure '
                            'pénale), à certaines infractions économiques et financières '
                            '(articles 706-1-1 et 706-1-2 du code de procédure pénale), et à '
                            'certaines infractions en matière de santé publique (article '
                            '706-2-2 du code de procédure pénale).',
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),
              const _SubTitle('2.1.7.2 - Modalités'),
              const SizedBox(height: 8),
              _ConditionCard(
                title: 'Autorisation, durée et contrôle',
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: const [
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'L’autorisation de recourir à ces techniques d’enquête doit être '
                          'délivrée par le juge des libertés et de la détention, à la requête '
                          'du procureur de la République (article 706-95-12 du Code de '
                          'procédure pénale).',
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                  SizedBox(height: 6),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'Elle est délivrée pour une durée maximale d’un mois, renouvelable '
                          'une fois dans les mêmes conditions de forme et de durée (article '
                          '706-95-16 du Code de procédure pénale).',
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                  SizedBox(height: 6),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'Le juge des libertés et de la détention doit être informé sans délai '
                          'par le procureur de la République des actes accomplis et se voir '
                          'communiquer les procès-verbaux dressés en exécution de sa décision, '
                          'de manière à ce qu’il puisse exercer son contrôle sur la légalité '
                          'des actes ainsi réalisés (article 706-95-14 du Code de procédure '
                          'pénale).',
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                  SizedBox(height: 6),
                  _Paragraph(
                    'S’il estime que les opérations n’ont pas été réalisées conformément à son '
                    'autorisation ou que les dispositions applicables du code de procédure '
                    'pénale n’ont pas été respectées, il peut ordonner la destruction des '
                    'procès-verbaux et des enregistrements effectués.',
                  ),
                  SizedBox(height: 4),
                  _Paragraph(
                    'La décision de destruction des procès-verbaux et des enregistrements '
                    'prend la forme d’une ordonnance motivée, notifiée au procureur de la '
                    'République, que ce dernier peut contester dans un délai de dix jours '
                    'suivant sa notification, devant le président de la chambre de '
                    'l’instruction.',
                  ),
                  SizedBox(height: 8),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'L’article 706-95-17 du Code de procédure pénale prévoit que ces techniques '
                          'sont mises en place par un officier de police judiciaire requis par '
                          'le procureur de la République ou, sous sa responsabilité, par un '
                          'agent de police judiciaire. Il est possible de requérir tout agent '
                          'dont la liste est fixée par décret pour l’installation et le retrait '
                          'des dispositifs techniques.',
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                  SizedBox(height: 6),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'Ces personnes doivent, en application de l’article 706-95-18 du Code '
                          'de procédure pénale, dresser procès-verbal de leurs diligences, en '
                          'mentionnant la date et l’heure du début et de la fin des '
                          'opérations. Les enregistrements sont placés sous scellés fermés.',
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                  SizedBox(height: 8),
                  _Paragraph(
                    'Les données enregistrées utiles à la manifestation de la vérité sont '
                    'décrites ou transcrites dans un procès-verbal par l’officier de police '
                    'judiciaire, l’agent de police judiciaire agissant sous sa responsabilité '
                    'ou l’assistant d’enquête agissant sous son contrôle.',
                  ),
                  SizedBox(height: 4),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'L’assistant d’enquête ne peut cependant agir qu’à la demande expresse '
                          'et sous le contrôle de l’officier de police judiciaire, qui aura '
                          'préalablement identifié les enregistrements nécessaires à la '
                          'manifestation de la vérité (articles 21-3 et 706-95-18 du Code de '
                          'procédure pénale).',
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                  SizedBox(height: 6),
                  _Paragraph(
                    'Aucune séquence relative à la vie privée étrangère aux infractions visées '
                    'dans les autorisations ne peut être conservée dans le dossier de la '
                    'procédure.',
                  ),
                  SizedBox(height: 6),
                  _NotaBox(
                    bodySpans: [
                      TextSpan(
                        text:
                            'Conformément à la circulaire conjointe DACG–DGGN–DGPN du 16 novembre '
                            '2018 relative à la simplification de la procédure pénale à droit '
                            'constant, pour les enquêtes de flagrance et en préliminaire, il '
                            'est possible de relater dans un seul procès-verbal plusieurs '
                            'opérations effectuées au cours de la même enquête, sauf '
                            'prescription contraire du parquet. Ces dispositions s’appliquent '
                            'aux trois techniques d’enquête décrites ci-après.',
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 22),
              const _SubTitle(
                '2.1.7.3 - IMSI-catcher : interceptions de correspondances et données de connexion',
              ),

              const SizedBox(height: 8),
              _ConditionCard(
                title:
                    '2.1.7.3.1 - Généralités (article 706-95-20 du Code de procédure pénale)',
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: const [
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'L’IMSI-catcher est un appareil ou un dispositif technique de recueil '
                          'des données techniques de connexion permettant l’identification d’un '
                          'équipement terminal ou du numéro d’abonnement de son utilisateur, '
                          'ainsi que les données relatives à la localisation d’un équipement '
                          'terminal utilisé. Il permet également d’intercepter des '
                          'correspondances (article 706-95-20 du Code de procédure pénale).',
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                ],
              ),

              const SizedBox(height: 14),
              _ConditionCard(
                title: '2.1.7.3.2 - Mise en place dans un lieu privé',
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: const [
                  _Paragraph(
                    'En vue de mettre en place ce dispositif et sur requête du procureur de '
                    'la République, le juge des libertés et de la détention peut autoriser '
                    'l’introduction dans un lieu privé, y compris en dehors des heures '
                    'prévues à l’article 59, à l’insu ou sans le consentement du propriétaire '
                    'ou de l’occupant des lieux, ou de toute personne titulaire d’un droit '
                    'sur ceux-ci.',
                  ),
                  SizedBox(height: 4),
                  _Paragraph(
                    'Ces opérations, qui ne peuvent avoir d’autre fin que la mise en place du '
                    'dispositif technique, sont effectuées sous le contrôle du juge des '
                    'libertés et de la détention. Les mêmes règles s’appliquent aux '
                    'opérations de désinstallation du dispositif.',
                  ),
                  SizedBox(height: 6),
                  _Paragraph(
                    'La mise en place du dispositif ne peut concerner les lieux visés aux '
                    'articles 56-1, 56-2, 56-3 et 56-5 ni être mise en œuvre dans le bureau '
                    'ou le domicile des personnes mentionnées à l’article 100-7 du Code de '
                    'procédure pénale.',
                  ),
                  SizedBox(height: 6),
                  _Paragraph('Elle est donc toujours illégale :'),
                  SizedBox(height: 4),
                  _BulletPoint(
                    text: 'dans un cabinet d’avocat ou à son domicile ;',
                  ),
                  _BulletPoint(
                    text:
                        'dans les locaux professionnels d’une entreprise ou agence de presse, '
                        'd’une entreprise de communication audiovisuelle ou de communication '
                        'au public en ligne ;',
                  ),
                  _BulletPoint(text: 'au domicile d’un journaliste ;'),
                  _BulletPoint(text: 'dans les locaux d’une juridiction ;'),
                  _BulletPoint(
                    text:
                        'au domicile d’une personne exerçant des fonctions juridictionnelles ;',
                  ),
                  _BulletPoint(
                    text: 'dans le bureau ou au domicile d’un magistrat ;',
                  ),
                  _BulletPoint(
                    text: 'dans le bureau ou au domicile d’un parlementaire.',
                  ),
                ],
              ),

              const SizedBox(height: 22),
              const _SubTitle(
                '2.1.7.4 - La sonorisation et la fixation d’images (articles 706-96 à 706-98 du Code de procédure pénale)',
              ),

              const SizedBox(height: 8),
              _ConditionCard(
                title: '2.1.7.4.1 - Généralités',
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: const [
                  _Paragraph(
                    'Il peut être recouru à la mise en place d’un dispositif technique ayant '
                    'pour objet, sans le consentement des intéressés, la captation, la '
                    'fixation, la transmission et l’enregistrement de paroles prononcées par '
                    'une ou plusieurs personnes à titre privé ou confidentiel dans des lieux '
                    'ou véhicules privés ou publics, ou de l’image d’une ou de plusieurs '
                    'personnes se trouvant dans un lieu privé.',
                  ),
                  SizedBox(height: 4),
                  _Paragraph(
                    'Il s’agit en général de la pose d’un micro et/ou d’une caméra.',
                  ),
                ],
              ),

              const SizedBox(height: 14),
              _ConditionCard(
                title:
                    '2.1.7.4.2 - Introduction dans les véhicules ou lieux privés',
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: const [
                  _Paragraph(
                    'Au cours de l’enquête, en vue de mettre en place ou de désinstaller un '
                    'dispositif permettant la sonorisation ou la fixation d’images, le juge '
                    'des libertés et de la détention peut autoriser l’introduction dans un '
                    'véhicule ou un lieu privé, y compris en dehors des heures prévues à '
                    'l’article 59, à l’insu ou sans le consentement du propriétaire ou du '
                    'possesseur du véhicule, ou de l’occupant des lieux ou de toute personne '
                    'titulaire d’un droit sur ceux-ci. Ces opérations, qui ne peuvent avoir '
                    'd’autre fin que la mise en place ou le retrait du dispositif, sont '
                    'effectuées sous son contrôle.',
                  ),
                  SizedBox(height: 6),
                  _Paragraph(
                    'La mise en place de ce dispositif technique ne peut concerner les lieux '
                    'visés aux articles 56-1, 56-2, 56-3 et 56-5, ni être mise en œuvre dans '
                    'le véhicule, le bureau ou le domicile des personnes visées aux articles '
                    '100-7 et 803-10 du Code de procédure pénale.',
                  ),
                  SizedBox(height: 6),
                  _Paragraph('Elle est donc toujours illégale :'),
                  SizedBox(height: 4),
                  _BulletPoint(
                    text:
                        'dans un cabinet d’avocat, à son domicile ou dans son véhicule ;',
                  ),
                  _BulletPoint(
                    text:
                        'dans les locaux ou véhicules professionnels d’une entreprise ou '
                        'agence de presse ;',
                  ),
                  _BulletPoint(
                    text:
                        'dans une entreprise de communication audiovisuelle ou de '
                        'communication au public en ligne ;',
                  ),
                  _BulletPoint(text: 'au domicile d’un journaliste ;'),
                  _BulletPoint(text: 'dans les locaux d’une juridiction ;'),
                  _BulletPoint(
                    text:
                        'au domicile d’une personne exerçant des fonctions juridictionnelles ;',
                  ),
                  _BulletPoint(
                    text:
                        'dans le véhicule, au bureau ou au domicile d’un magistrat ;',
                  ),
                  _BulletPoint(
                    text:
                        'dans le véhicule, au bureau ou au domicile de parlementaires.',
                  ),
                ],
              ),

              const SizedBox(height: 18),
              _ConditionCard(
                title:
                    '2.1.7.4.3 - Activation à distance des appareils électroniques connectés',
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: const [
                  _Paragraph(
                    'Pour certaines infractions graves, la loi permet de recourir à '
                    'l’activation à distance d’appareils électroniques fixes ou mobiles, en '
                    'alternative à la pose physique de micros ou de caméras, qui peut être '
                    'trop risquée pour les enquêteurs.',
                  ),
                  SizedBox(height: 6),
                  _Paragraph('On distingue :'),
                  SizedBox(height: 4),
                  _IntroBullet(
                    text:
                        'les appareils connectés dits fixes : tout appareil électronique '
                        'connecté nécessitant un raccordement au réseau électrique pour '
                        'fonctionner et ne pouvant, par nature, être déplacé (par exemple : '
                        'ordinateur fixe, téléphone fixe) ;',
                  ),
                  _IntroBullet(
                    text:
                        'les appareils connectés dits mobiles : ensemble des appareils '
                        'électroniques dotés d’une batterie leur assurant une autonomie '
                        'suffisante pour être portables (téléphones portables, tablettes, '
                        'ordinateurs portables, etc.).',
                  ),
                ],
              ),

              const SizedBox(height: 18),
              _ConditionCard(
                title:
                    '2.1.7.4.3.1 - Conditions communes aux appareils fixes et mobiles',
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: const [
                  _Paragraph(
                    'L’activation à distance est réservée aux infractions particulièrement '
                    'graves prévues aux 1° à 6° et 11° à 12° de l’article 706-73 du code de '
                    'procédure pénale (meurtres en bande organisée ou en concours, tortures '
                    'et actes de barbarie en bande organisée, viols en concours, trafics de '
                    'stupéfiants, enlèvement et séquestration en bande organisée, traite des '
                    'êtres humains, proxénétisme, actes de terrorisme, atteintes aux intérêts '
                    'fondamentaux de la nation, délits en matière d’armes et de produits '
                    'explosifs), ainsi qu’au blanchiment de ces infractions ou à une '
                    'association de malfaiteurs en vue de les préparer.',
                  ),
                  SizedBox(height: 6),
                  _NotaBox(
                    bodySpans: [
                      TextSpan(
                        text:
                            'Par une réserve d’interprétation, le Conseil constitutionnel a jugé '
                            'que ces dispositions ne peuvent s’appliquer aux délits que s’ils '
                            'sont commis en bande organisée et punis d’une peine '
                            'd’emprisonnement d’une durée égale ou supérieure à cinq ans.',
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 18),
              _ConditionCard(
                title: '2.1.7.4.3.2 - Appareils électroniques fixes',
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: const [
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'L’opération doit être autorisée par le juge des libertés et de la '
                          'détention, à la requête du procureur de la République. '
                          'L’autorisation doit comporter tous les éléments permettant '
                          'd’identifier les lieux et l’appareil visés, ainsi que l’infraction '
                          'motivant la mesure et sa durée. Conformément à l’article 706-95-16 '
                          'du Code de procédure pénale, elle est délivrée au cours de '
                          'l’enquête pour une durée maximale d’un mois, renouvelable une fois.',
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                  SizedBox(height: 6),
                  _Paragraph(
                    'Le procureur de la République peut désigner toute personne physique ou '
                    'morale habilitée, inscrite sur l’une des listes prévues à l’article 157 '
                    'du code de procédure pénale, pour effectuer les opérations techniques '
                    'permettant la mise en œuvre du dispositif. Il peut également prescrire '
                    'le recours aux moyens de l’État soumis au secret de la défense nationale, '
                    'dans les formes prévues au chapitre Ier du titre IV du livre Ier du code '
                    'de procédure pénale.',
                  ),
                  SizedBox(height: 6),
                  _Paragraph(
                    'L’activation à distance d’un appareil électronique fixe ne peut concerner '
                    'les lieux mentionnés aux articles 56-1, 56-2, 56-3 et 56-5 du code de '
                    'procédure pénale, ni être mise en œuvre dans le véhicule, le bureau ou '
                    'le domicile d’un membre du Parlement, d’un avocat ou d’un magistrat.',
                  ),
                ],
              ),

              const SizedBox(height: 18),
              _ConditionCard(
                title:
                    'Appareils électroniques mobiles (articles 706-99 et 706-100)',
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: const [
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'L’opération est prévue par les articles 706-99 et 706-100 du Code de '
                          'procédure pénale.',
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                  SizedBox(height: 6),
                  _Paragraph(
                    'L’activation à distance d’un appareil électronique mobile n’est possible '
                    'que lorsque les circonstances de l’enquête ne permettent pas la mise en '
                    'place d’un dispositif fixe, notamment :',
                  ),
                  SizedBox(height: 4),
                  _BulletPoint(
                    text:
                        'en cas d’impossibilité de déterminer les lieux où un dispositif '
                        'technique pourrait être utilement installé ;',
                  ),
                  _BulletPoint(
                    text:
                        'en cas de risques d’atteinte à la vie ou à l’intégrité physique des '
                        'agents chargés de la mise en œuvre du dispositif.',
                  ),
                  SizedBox(height: 6),
                  _Paragraph(
                    'L’opération doit être autorisée par le juge des libertés et de la '
                    'détention, à la requête du procureur de la République, pour une durée '
                    'strictement proportionnée à l’objectif recherché et ne pouvant excéder '
                    'quinze jours, renouvelable une fois.',
                  ),
                  SizedBox(height: 4),
                  _Paragraph(
                    'L’autorisation doit préciser l’infraction à l’origine de la mesure, la '
                    'durée, ainsi que tous les éléments permettant d’identifier l’appareil. '
                    'Elle doit être motivée par référence aux éléments de fait et de droit '
                    'justifiant la nécessité de l’opération et l’impossibilité de recourir au '
                    'dispositif fixe.',
                  ),
                  SizedBox(height: 6),
                  _Paragraph(
                    'Le dispositif d’activation à distance d’un appareil électronique mobile '
                    'aux fins de captation de sons et d’images ne peut, à peine de nullité, '
                    'concerner les appareils utilisés par un magistrat, un avocat, un '
                    'parlementaire, un journaliste ou un médecin.',
                  ),
                  SizedBox(height: 6),
                  _Paragraph(
                    'Ne peuvent être transcrites en procédure les données relatives aux '
                    'échanges avec un avocat qui relèvent de l’exercice des droits de la '
                    'défense et sont couvertes par le secret professionnel, ni celles '
                    'permettant d’identifier une source journalistique, ni celles captées '
                    'dans certains lieux protégés (locaux et domicile d’un avocat ou d’un '
                    'journaliste, cabinet d’un médecin, d’un notaire, d’un commissaire de '
                    'justice, juridiction ou domicile d’un magistrat).',
                  ),
                ],
              ),

              const SizedBox(height: 22),
              const _SubTitle(
                '2.1.1.2 - La captation de données informatiques (articles 706-102-1 à 706-102-5)',
              ),

              const SizedBox(height: 8),
              _ConditionCard(
                title: 'La captation de données informatiques',
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: const [
                  _Paragraph(
                    'La captation de données informatiques consiste, au moyen d’un dispositif '
                    'technique, à accéder, sans le consentement des intéressés, à des données '
                    'informatiques, à les enregistrer, les conserver et les transmettre, '
                    'qu’elles soient stockées dans un système informatique, qu’elles '
                    's’affichent sur l’écran utilisé par la personne ou qu’elles soient reçues '
                    'ou émises par des périphériques (clé USB, imprimante, disque dur externe, '
                    'etc.).',
                  ),
                  SizedBox(height: 6),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'L’article 706-102-5 du Code de procédure pénale précise qu’en vue de mettre '
                          'en place le dispositif visé à l’article 706-102-1, le juge des '
                          'libertés et de la détention, à la requête du procureur de la '
                          'République, peut autoriser l’introduction dans un véhicule ou dans '
                          'un lieu privé, y compris hors des heures prévues à l’article 59, à '
                          'l’insu ou sans le consentement du propriétaire ou du possesseur du '
                          'véhicule ou de l’occupant des lieux ou de toute personne titulaire '
                          'd’un droit sur celui-ci. Lorsque le lieu est un lieu d’habitation et '
                          'que l’opération doit intervenir en dehors des heures prévues à '
                          'l’article 59, l’autorisation est délivrée par le juge des libertés et '
                          'de la détention saisi à cette fin. Ces opérations, qui ne peuvent '
                          'avoir d’autre fin que la mise en place du dispositif technique, sont '
                          'effectuées sous l’autorité et le contrôle du juge des libertés et de '
                          'la détention. Les mêmes règles s’appliquent aux opérations de '
                          'désinstallation.',
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                  SizedBox(height: 6),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'Le juge des libertés et de la détention, à la requête du procureur '
                          'de la République, peut aussi autoriser la transmission du dispositif '
                          'par un réseau de communications électroniques. Ces opérations sont '
                          'également réalisées sous son autorité et son contrôle.',
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                  SizedBox(height: 6),
                  _Paragraph(
                    'La mise en place du dispositif technique ne peut concerner les systèmes '
                    'automatisés de traitement des données se trouvant dans les lieux visés '
                    'aux articles 56-1, 56-2, 56-3 et 56-5, ni être réalisée dans le véhicule, '
                    'le bureau ou le domicile des personnes visées aux articles 100-7 et '
                    '803-10 du Code de procédure pénale (députés, sénateurs, représentants au '
                    'Parlement européen élus en France, avocats, magistrats).',
                  ),
                ],
              ),

              const SizedBox(height: 22),
              const _SubTitle(
                '2.1.2 - Le dispositif du « dossier coffre » (articles 706-104 et 706-104-1)',
              ),

              const SizedBox(height: 8),
              _ConditionCard(
                title: 'Principe du « dossier coffre »',
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: const [
                  _Paragraph(
                    'Le « dossier coffre » est un procès-verbal distinct de la procédure, auquel '
                    'les parties n’ont pas accès. On y consigne notamment :',
                  ),
                  SizedBox(height: 4),
                  _BulletPoint(
                    text:
                        'les informations relatives à la date, l’heure et le lieu de la mise '
                        'en place des dispositifs techniques d’enquête ;',
                  ),
                  _BulletPoint(
                    text:
                        'les éléments permettant d’identifier une personne ayant concouru à '
                        'l’installation ou au retrait du dispositif technique.',
                  ),
                  SizedBox(height: 6),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'Sont concernés l’ensemble des dispositifs techniques visés aux articles '
                          '706-95 à 706-102-5 du Code de procédure pénale : interceptions de '
                          'correspondances émises par la voie des communications électroniques, '
                          'accès à distance aux correspondances stockées, recueil des données '
                          'techniques de connexion (IMSI-catcher), sonorisation et fixation '
                          'd’images de certains lieux ou véhicules, captation de données '
                          'informatiques.',
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                  SizedBox(height: 6),
                  _Paragraph(
                    'Le « dossier coffre » ne peut être utilisé que sur autorisation du juge '
                    'des libertés et de la détention, à la requête du procureur de la '
                    'République, et seulement lorsque la divulgation des informations '
                    'concernées serait de nature à mettre gravement en danger la vie ou '
                    'l’intégrité physique d’une personne, de sa famille ou de ses proches.',
                  ),
                  SizedBox(height: 4),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'L’article 706-104-1 du Code de procédure pénale précise enfin les '
                          'conditions dans lesquelles le versement d’informations dans ce '
                          'dossier distinct peut être contesté, ainsi que celles dans '
                          'lesquelles les éléments de preuve recueillis au moyen d’une '
                          'technique spéciale d’enquête donnant lieu à un tel versement '
                          'peuvent être utilisés.',
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                ],
              ),

              const SizedBox(height: 26),
              const _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        'Version au 01/07/2025 – SDCP – Tous droits réservés. Toujours vérifier '
                        'la base légale exacte (articles 706-95-11 à 706-104-1 du Code de '
                        'procédure pénale) avant la mise en œuvre d’une technique spéciale '
                        'd’enquête.',
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
