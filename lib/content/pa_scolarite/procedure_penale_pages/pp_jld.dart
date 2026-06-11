import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaPPJLDPage extends StatelessWidget {
  const PaPPJLDPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/procedure_penale/pp_jld';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        // garde le bouton retour automatiquement si tu viens via Navigator.push
        automaticallyImplyLeading: true,
        elevation: 0, // pas d’ombre moche
        backgroundColor: Colors.transparent, // plus de barre bleue
        surfaceTintColor:
            Colors.transparent, // évite le voile gris/bleu en Material 3
        title: Text(
          'Juge des libertés et de la détention',
          style: GoogleFonts.fustat(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // CHAPITRE + titre
              Text(
                'CHAPITRE 6',
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
                'Le juge des libertés et de la détention (J.L.D.)',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 10),

              // INTRO
              const _Paragraph(
                'La loi du 15 juin 2000 renforçant la protection de la présomption '
                'd’innocence et les droits des victimes a profondément réformé la '
                'procédure pénale. Elle a créé le juge des libertés et de la détention '
                '(J.L.D.), initialement compétent en matière de détention provisoire, '
                'avant que le législateur ne lui confère progressivement d’autres '
                'attributions dans le domaine des libertés individuelles.',
              ),
              const SizedBox(height: 8),
              const _Paragraph(
                'Depuis le 1er septembre 2017, la fonction de juge des libertés et de '
                'la détention est une fonction statutaire : le J.L.D. devient un juge '
                'spécialisé, au même titre que le juge d’instruction, le juge des '
                'enfants ou le juge de l’application des peines.',
              ),

              const SizedBox(height: 22),
              const _SubTitle(
                '6.1 – Statut du juge des libertés et de la détention',
              ),

              const _Paragraph.rich([
                TextSpan(
                  text:
                      'Le juge des libertés et de la détention (J.L.D.) est un magistrat du '
                      'siège. Il est nommé par décret en Conseil d’État, après avis conforme '
                      'du Conseil supérieur de la magistrature, conformément à ',
                ),
                TextSpan(
                  text:
                      'l’article 3 de l’ordonnance n° 58-1270 du 22 décembre 1958',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: '.'),
              ]),
              const SizedBox(height: 8),
              const _Paragraph.rich([
                TextSpan(
                  text:
                      'En cas de vacance d’emploi, d’absence ou d’empêchement, le J.L.D. '
                      'peut être suppléé par un magistrat du siège du premier grade ou hors '
                      'hiérarchie, désigné par le président du tribunal judiciaire. En cas '
                      'd’empêchement de ces magistrats, le président peut désigner un '
                      'magistrat du second grade, conformément à ',
                ),
                TextSpan(
                  text: 'l’article 137-1-1 du Code de procédure pénale',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: '.'),
              ]),

              const SizedBox(height: 24),
              const _SubTitle('6.2 – Le J.L.D. et l’instruction préparatoire'),

              // 6.2.1
              const _SubTitle('6.2.1 – La détention provisoire'),
              const _Paragraph('Le J.L.D. est compétent pour statuer sur :'),
              const _IntroBullet(
                text: 'les demandes de placement en détention provisoire ;',
              ),
              const _IntroBullet(
                text:
                    'les demandes de prolongation de la détention provisoire ;',
              ),
              const _IntroBullet(text: 'les demandes de mise en liberté.'),
              const SizedBox(height: 6),
              const _Paragraph.rich([
                TextSpan(
                  text:
                      'Lorsque la qualification criminelle ne peut être retenue et que les '
                      'faits sont correctionnalisés, le J.L.D. reste saisi pour le maintien '
                      'en détention provisoire de l’intéressé, conformément aux ',
                ),
                TextSpan(
                  text: 'articles 137-1 et 137-3 du Code de procédure pénale',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: '.'),
              ]),

              const SizedBox(height: 16),
              // 6.2.2
              const _SubTitle('6.2.2 – Le contrôle judiciaire'),
              const _Paragraph.rich([
                TextSpan(
                  text:
                      'Le contrôle judiciaire est en principe ordonné par le juge '
                      'd’instruction. Cependant, lorsqu’il est saisi, le J.L.D. peut également '
                      'ordonner un contrôle judiciaire et déterminer les obligations imposées '
                      'à la personne mise en examen, en application des ',
                ),
                TextSpan(
                  text: 'articles 137-2 et 138 du Code de procédure pénale',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: '.'),
              ]),
              const SizedBox(height: 6),
              const _Paragraph(
                'En cas d’inobservation des obligations, le J.L.D. peut :',
              ),
              const _IntroBullet(text: 'révoquer le contrôle judiciaire ;'),
              const _IntroBullet(
                text:
                    'décider un placement en détention provisoire, après saisine par '
                    'le juge d’instruction par ordonnance motivée, accompagnée des '
                    'réquisitions du procureur de la République ;',
              ),
              const SizedBox(height: 6),
              const _Paragraph(
                'Dans ce cadre, le J.L.D. peut décerner un mandat de dépôt à '
                'l’encontre de l’intéressé.',
              ),

              const SizedBox(height: 16),
              // 6.2.3
              const _SubTitle(
                '6.2.3 – L’assignation à résidence\navec surveillance électronique',
              ),
              const _Paragraph.rich([
                TextSpan(
                  text:
                      'L’assignation à résidence avec surveillance électronique peut être '
                      'ordonnée par le juge d’instruction ou par le juge des libertés et de '
                      'la détention, par ordonnance motivée, en application de ',
                ),
                TextSpan(
                  text: 'l’article 142-5 du Code de procédure pénale',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: '.'),
              ]),

              const SizedBox(height: 24),
              const _SubTitle(
                '6.3 – Intervention du J.L.D. durant l’enquête de police',
              ),

              // 6.3.1 – Écoutes téléphoniques
              const _SubTitle('6.3.1 – Les écoutes téléphoniques'),
              _ConditionCard(
                title:
                    'Domaines d’intervention du J.L.D. (écoutes téléphoniques)',
                cardColor: isDark
                    ? const Color(0xFF102027)
                    : const Color(0xFFE3F2FD),
                accent: const Color(0xFF1565C0),
                titleColor: isDark
                    ? const Color(0xFFBBDEFB)
                    : const Color(0xFF0D47A1),
                children: const [
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'Procédure de recherche d’une personne en fuite : sur requête '
                          'du procureur de la République, le J.L.D. peut autoriser '
                          'l’interception, l’enregistrement et la transcription de '
                          'correspondances émises par la voie des télécommunications, '
                          'sous son autorité et son contrôle, conformément à ',
                    ),
                    TextSpan(
                      text: 'l’article 74-2 du Code de procédure pénale',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(text: '.'),
                  ]),
                  SizedBox(height: 6),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'Écoutes sur une ligne dépendant d’un cabinet d’avocat ou de '
                          'son domicile : la décision est prise par ordonnance motivée '
                          'du J.L.D., saisi par le juge d’instruction après avis du '
                          'procureur de la République, conformément à ',
                    ),
                    TextSpan(
                      text: 'l’article 100 du Code de procédure pénale',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(text: '.'),
                  ]),
                  SizedBox(height: 6),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'Écoutes judiciaires en matière de criminalité organisée : sur '
                          'requête du procureur de la République, le J.L.D. peut autoriser '
                          'l’interception de correspondances électroniques pour certaines '
                          'infractions relevant de la criminalité organisée, en application '
                          'de ',
                    ),
                    TextSpan(
                      text: 'l’article 706-95 du Code de procédure pénale',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(text: '.'),
                  ]),
                ],
              ),

              const SizedBox(height: 20),
              // 6.3.2 – Perquisitions
              const _SubTitle(
                '6.3.2 – Les perquisitions, visites domiciliaires et saisies',
              ),
              const _Paragraph.rich([
                TextSpan(
                  text:
                      'En enquête préliminaire, les perquisitions sont en principe subordonnées '
                      'à l’assentiment de la personne chez laquelle elles ont lieu. Toutefois, '
                      'pour une enquête relative à un crime ou un délit puni d’au moins trois ans '
                      'd’emprisonnement, ou pour la recherche de biens susceptibles de confiscation '
                      'en vertu de ',
                ),
                TextSpan(
                  text: 'l’article 131-21 du Code pénal',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      ', le J.L.D. peut autoriser une perquisition sans assentiment, conformément à ',
                ),
                TextSpan(
                  text: 'l’article 76 du Code de procédure pénale',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: '.'),
              ]),
              const SizedBox(height: 6),
              const _Paragraph('Le J.L.D. intervient également :'),
              const _IntroBullet(
                text:
                    'pour autoriser les perquisitions au cabinet ou au domicile d’un '
                    'avocat, par ordonnance écrite et motivée, en présence du bâtonnier '
                    'ou de son délégué ;',
              ),
              const _Paragraph.rich([
                TextSpan(text: 'Cette intervention est prévue par '),
                TextSpan(
                  text: 'l’article 56-1 du Code de procédure pénale',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: '.'),
              ]),
              const _IntroBullet(
                text:
                    'pour trancher, dans les cinq jours, les contestations du bâtonnier '
                    'relatives à la saisie de documents, après mise sous scellés.',
              ),
              const SizedBox(height: 6),
              const _Paragraph.rich([
                TextSpan(
                  text:
                      'En matière de délinquance et de criminalité organisées, le J.L.D. peut, '
                      'sur requête du procureur de la République, autoriser l’O.P.J. à procéder '
                      'à des perquisitions, visites domiciliaires et saisies en dehors des heures '
                      'légales, en application des ',
                ),
                TextSpan(
                  text:
                      'articles 706-89, 706-90 et 706-92 du Code de procédure pénale',
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
                      'Il peut aussi, en enquête de flagrance portant sur certains crimes contre '
                      'les personnes, autoriser des perquisitions et saisies en dehors des heures '
                      'légales, conformément à ',
                ),
                TextSpan(
                  text: 'l’article 59-1 du Code de procédure pénale',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: ' et à '),
                TextSpan(
                  text: 'l’article 706-92 du Code de procédure pénale',
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
                      'En enquête préliminaire, le J.L.D. peut autoriser une perquisition sans '
                      'présence ni assentiment de la personne lorsque le transport d’une '
                      'personne gardée à vue présente un risque grave de trouble à l’ordre public, '
                      'd’évasion ou de disparition de preuves, conformément à ',
                ),
                TextSpan(
                  text: 'l’article 706-94 du Code de procédure pénale',
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
                      'Il intervient aussi pour autoriser la saisie de biens dont la confiscation '
                      'est prévue par ',
                ),
                TextSpan(
                  text: 'l’article 131-21 du Code pénal',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      ', à la suite d’une perquisition, ainsi que pour statuer sur la saisie de '
                      'documents susceptibles d’être couverts par le secret du délibéré lors de '
                      'perquisitions dans les locaux d’une juridiction ou au domicile d’un magistrat, '
                      'en application de ',
                ),
                TextSpan(
                  text: 'l’article 56-5 du Code de procédure pénale',
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
                      'Enfin, le J.L.D. intervient pour autoriser certaines visites domiciliaires et '
                      'saisies conduites par : les douanes, en vertu de ',
                ),
                TextSpan(
                  text: 'l’article 64 du Code des douanes',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text: ', l’administration fiscale, en application de ',
                ),
                TextSpan(
                  text: 'l’article L.16 B du Livre des procédures fiscales',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: ', ou la DGCCRF, en vertu de '),
                TextSpan(
                  text: 'l’article L.450-4 du Code de commerce',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: '.'),
              ]),

              const SizedBox(height: 20),
              // 6.3.3 – Garde à vue
              const _SubTitle('6.3.3 – La garde à vue'),

              const _SubTitle('6.3.3.1 – Prolongation de garde à vue'),
              const _Paragraph.rich([
                TextSpan(
                  text:
                      'Pour certaines infractions relevant de la criminalité organisée, au sens des ',
                ),
                TextSpan(
                  text: 'articles 706-73 du Code de procédure pénale',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      ' (sauf 21°), la garde à vue peut, à titre exceptionnel, faire l’objet de deux '
                      'prolongations supplémentaires de vingt-quatre heures chacune. Ces prolongations '
                      'sont autorisées, sur requête du procureur de la République, par décision écrite '
                      'et motivée du J.L.D., conformément à ',
                ),
                TextSpan(
                  text: 'l’article 706-88 du Code de procédure pénale',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: '.'),
              ]),
              const SizedBox(height: 6),
              const _Paragraph(
                'Par dérogation, si la durée prévisible des investigations à l’issue des '
                'premières quarante-huit heures le justifie, le J.L.D. peut décider une '
                'seule prolongation supplémentaire de quarante-huit heures.',
              ),
              const SizedBox(height: 6),
              const _Paragraph.rich([
                TextSpan(
                  text:
                      'En matière de terrorisme, pour les infractions visées au 11° de ',
                ),
                TextSpan(
                  text: 'l’article 706-73 du Code de procédure pénale',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      ', et en présence d’un risque sérieux d’action terroriste imminente ou de '
                      'nécessités impérieuses de coopération internationale, le J.L.D. peut décider '
                      'une prolongation supplémentaire de vingt-quatre heures, renouvelable une fois, '
                      'conformément à ',
                ),
                TextSpan(
                  text: 'l’article 706-88-1 du Code de procédure pénale',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: '.'),
              ]),

              const SizedBox(height: 14),
              const _SubTitle('6.3.3.2 – Report de l’intervention de l’avocat'),
              const _Paragraph.rich([
                TextSpan(
                  text:
                      'En droit commun, le report de l’intervention de l’avocat au-delà de la '
                      '12e heure et jusqu’à la 24e heure de garde à vue peut être autorisé par '
                      'le J.L.D., sur requête du procureur de la République ou du juge '
                      'd’instruction, pour les crimes et délits punis d’au moins cinq ans '
                      'd’emprisonnement, conformément à ',
                ),
                TextSpan(
                  text: 'l’article 63-4-2 du Code de procédure pénale',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: '.'),
              ]),
              const SizedBox(height: 6),
              const _Paragraph(
                'En matière de criminalité organisée, le procureur ou le juge d’instruction '
                'peut différer la présence de l’avocat jusqu’à la 24e heure. Le procureur '
                'peut saisir le J.L.D. pour reporter cette présence jusqu’à la 48e heure. '
                'Pour les infractions de trafic de stupéfiants (3°) ou de terrorisme (11° '
                'de l’article 706-73), l’intervention de l’avocat peut être différée jusqu’à '
                '72 heures. Pour ces infractions, le juge d’instruction est seul compétent '
                'pour autoriser ce report.',
              ),

              const SizedBox(height: 20),
              // 6.3.4 – Réquisitions
              const _SubTitle('6.3.4 – Les réquisitions'),
              const _Paragraph.rich([
                TextSpan(
                  text:
                      'En enquête de flagrance ou en enquête préliminaire, sur réquisition du '
                      'procureur de la République et autorisation du J.L.D. par ordonnance, '
                      'l’O.P.J. ou, sous son contrôle, l’A.P.J. peut demander aux opérateurs '
                      'de télécommunications de prendre sans délai toutes mesures propres à '
                      'assurer la préservation, pour une durée maximale d’un an, du contenu '
                      'des informations consultées par les utilisateurs, en application des ',
                ),
                TextSpan(
                  text:
                      'articles 60-2 alinéa 2 et 77-1-2 du Code de procédure pénale',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: '.'),
              ]),

              const SizedBox(height: 16),
              // 6.3.5 – Protection des témoins
              const _SubTitle('6.3.5 – La protection des témoins'),
              const _Paragraph.rich([
                TextSpan(
                  text:
                      'Pour les crimes ou délits punis d’au moins trois ans d’emprisonnement, '
                      'lorsque l’audition d’une personne au sens de ',
                ),
                TextSpan(
                  text: 'l’article 706-57 du Code de procédure pénale',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      ' est susceptible de mettre gravement en danger sa vie ou son intégrité, ou '
                      'celle de ses proches, le J.L.D., saisi par requête motivée du procureur ou '
                      'du juge d’instruction, peut autoriser que ses déclarations soient recueillies '
                      'sans que son identité figure au dossier, conformément à ',
                ),
                TextSpan(
                  text:
                      'l’article 706-58 et aux articles R.53-29 et R.53-32 du Code de procédure pénale',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text: '. Il peut décider de procéder lui-même à l’audition.',
                ),
              ]),

              const SizedBox(height: 16),
              // 6.3.6 – Techniques spéciales d’enquête
              const _SubTitle(
                '6.3.6 – Les techniques spéciales d’enquête\n(articles 706-95-11 et suivants du Code de procédure pénale)',
              ),
              const _Paragraph.rich([
                TextSpan(
                  text:
                      'Au cours de l’enquête de flagrance ou de l’enquête préliminaire, certaines '
                      'techniques spéciales d’enquête sont autorisées par le J.L.D., sur requête '
                      'du procureur de la République, en application de ',
                ),
                TextSpan(
                  text: 'l’article 706-95-12 du Code de procédure pénale',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: '. Sont notamment concernées :'),
              ]),
              const _IntroBullet(
                text:
                    'le recueil de données techniques de connexion et l’interception de '
                    'correspondances électroniques ;',
              ),
              const _IntroBullet(
                text:
                    'les sonorisations et fixations d’images de certains lieux ou véhicules ;',
              ),
              const _IntroBullet(
                text: 'la captation de données informatiques.',
              ),

              const SizedBox(height: 16),
              // 6.3.7 – Saisies du patrimoine
              const _SubTitle(
                '6.3.7 – Les saisies du patrimoine\n(article 706-148 du Code de procédure pénale)',
              ),
              const _Paragraph.rich([
                TextSpan(
                  text:
                      'En enquête préliminaire ou de flagrance pour une infraction punie d’au '
                      'moins cinq ans d’emprisonnement, le J.L.D. peut ordonner, sur requête du '
                      'procureur, la saisie de tout ou partie du patrimoine d’une personne, '
                      'conformément à ',
                ),
                TextSpan(
                  text: 'l’article 706-148 du Code de procédure pénale',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      ', lorsque l’origine de ces biens ne peut être établie ou lorsque la loi '
                      'réprimant l’infraction prévoit la confiscation de tout ou partie des biens '
                      'du condamné.',
                ),
              ]),
              const SizedBox(height: 6),
              const _Paragraph(
                'L’O.P.J. peut, sur autorisation du procureur ou du juge d’instruction, '
                'procéder d’urgence à la saisie de ces biens lorsqu’il existe un risque '
                'imminent de disparition. Le J.L.D., saisi ensuite, statue dans les dix jours '
                'sur le maintien ou la mainlevée de la saisie, même si la juridiction de '
                'jugement est saisie.',
              ),

              const SizedBox(height: 16),
              // 6.3.8 – Saisies conservatoires
              const _SubTitle('6.3.8 – Les saisies conservatoires'),
              const _Paragraph.rich([
                TextSpan(
                  text:
                      'Les saisies conservatoires visent à appréhender le patrimoine des '
                      'délinquants pour garantir le paiement des amendes et l’indemnisation '
                      'éventuelle des victimes. Pour les infractions entrant dans le champ des ',
                ),
                TextSpan(
                  text:
                      'articles 706-73, 706-73-1 et 706-74 du Code de procédure pénale',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      ', le J.L.D. peut, sur requête du procureur de la République, ordonner des mesures '
                      'conservatoires sur les biens de la personne mise en examen, en application de ',
                ),
                TextSpan(
                  text: 'l’article 706-103 du Code de procédure pénale',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: '.'),
              ]),

              const SizedBox(height: 24),
              const _SubTitle(
                '6.4 – Autres interventions du J.L.D. au cours d’une procédure judiciaire',
              ),

              // 6.4.1 – Détention provisoire et contrôle judiciaire
              const _SubTitle(
                '6.4.1 – Détention provisoire et contrôle judiciaire',
              ),

              const _SubTitle(
                '6.4.1.1 – En cas de convocation par procès-verbal',
              ),
              const _Paragraph.rich([
                TextSpan(
                  text:
                      'En matière correctionnelle, en cas de convocation par procès-verbal, '
                      'si le procureur de la République estime nécessaire de soumettre le '
                      'prévenu à des obligations de contrôle judiciaire ou à une assignation '
                      'à résidence avec surveillance électronique jusqu’à sa comparution, il le '
                      'fait présenter devant le J.L.D., qui statue en chambre du conseil avec '
                      'l’assistance d’un greffier, conformément à ',
                ),
                TextSpan(
                  text: 'l’article 394 du Code de procédure pénale',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: '.'),
              ]),

              const SizedBox(height: 8),
              const _SubTitle('6.4.1.2 – Comparution immédiate ou différée'),
              const _Paragraph.rich([
                TextSpan(
                  text:
                      'En cas de comparution immédiate, si le tribunal ne peut être réuni le '
                      'jour même et que les éléments de l’espèce justifient une détention '
                      'provisoire, le procureur peut traduire le prévenu devant le J.L.D., qui '
                      'statue en chambre du conseil, conformément à ',
                ),
                TextSpan(
                  text: 'l’article 396 du Code de procédure pénale',
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
                      'Dans le cadre de la comparution à délai différé, le J.L.D. statue dans les '
                      'mêmes conditions sur les réquisitions du ministère public aux fins de contrôle '
                      'judiciaire, d’assignation à résidence avec surveillance électronique ou de '
                      'détention provisoire, conformément à ',
                ),
                TextSpan(
                  text: 'l’article 397-1-1 du Code de procédure pénale',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: '.'),
              ]),

              const SizedBox(height: 8),
              const _SubTitle(
                '6.4.1.3 – Comparution sur reconnaissance préalable de culpabilité',
              ),
              const _Paragraph.rich([
                TextSpan(
                  text:
                      'Lorsqu’une comparution sur reconnaissance préalable de culpabilité '
                      '(C.R.P.C.) est proposée, la personne peut demander un délai de réflexion '
                      'de 10 jours. Pendant ce délai, elle peut être placée sous contrôle '
                      'judiciaire, assignée à résidence avec surveillance électronique ou placée '
                      'en détention provisoire par décision du J.L.D., conformément à ',
                ),
                TextSpan(
                  text: 'l’article 495-11 du Code de procédure pénale',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: '.'),
              ]),

              const SizedBox(height: 8),
              const _SubTitle(
                '6.4.1.4 – Renvoi devant le tribunal correctionnel',
              ),
              const _Paragraph(
                'Lorsqu’une personne renvoyée devant le tribunal correctionnel est '
                'placée ou maintenue sous contrôle judiciaire, le J.L.D. peut, à tout '
                'moment, sur réquisitions du ministère public ou demande du prévenu :',
              ),
              const _IntroBullet(
                text: 'imposer de nouvelles obligations ou interdictions ;',
              ),
              const _IntroBullet(
                text: 'supprimer ou modifier certaines obligations ;',
              ),
              const _IntroBullet(
                text:
                    'accorder une dispense occasionnelle ou temporaire d’observer '
                    'certaines obligations.',
              ),
              const _Paragraph.rich([
                TextSpan(text: 'Ces pouvoirs sont exercés en application de '),
                TextSpan(
                  text: 'l’article 141-1 du Code de procédure pénale',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: '.'),
              ]),

              const SizedBox(height: 8),
              const _SubTitle(
                '6.4.1.5 – Arrestation après clôture de l’information',
              ),
              const _Paragraph.rich([
                TextSpan(
                  text:
                      'Si une personne faisant l’objet d’un mandat d’arrêt est découverte après '
                      'le règlement de l’information, elle est conduite devant le procureur de '
                      'la République, conformément à ',
                ),
                TextSpan(
                  text: 'l’article 135-2 du Code de procédure pénale',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      ', qui la présente ensuite devant le J.L.D. après notification du mandat.',
                ),
              ]),
              const SizedBox(height: 6),
              const _Paragraph(
                'Le J.L.D. peut alors, sur réquisitions du parquet :',
              ),
              const _IntroBullet(
                text: 'placer la personne sous contrôle judiciaire ;',
              ),
              const _IntroBullet(
                text:
                    'ou ordonner son placement en détention provisoire jusqu’à sa '
                    'comparution devant la juridiction de jugement.',
              ),
              const SizedBox(height: 6),
              const _Paragraph(
                'Il statue par ordonnance motivée, après débat contradictoire. Lorsque la '
                'personne est arrêtée à plus de 200 km de la juridiction de jugement et '
                'qu’elle ne peut être présentée dans les 24 h, elle est conduite devant le '
                'J.L.D. du lieu d’arrestation.',
              ),

              const SizedBox(height: 20),
              // 6.4.2 – Application des peines
              const _SubTitle('6.4.2 – Application des peines'),
              const _Paragraph(
                'Le juge de l’application des peines (J.A.P.) peut délivrer un mandat '
                'd’amener contre un condamné placé sous son contrôle judiciaire en cas '
                'd’inobservation des obligations. Si le condamné ne peut être présenté '
                'immédiatement au J.A.P., il est présenté devant le J.L.D.',
              ),
              const SizedBox(height: 6),
              const _Paragraph.rich([
                TextSpan(
                  text:
                      'Sur réquisitions du procureur, le J.L.D. peut ordonner l’incarcération du '
                      'condamné jusqu’à sa comparution devant le J.A.P., dans un délai de huit '
                      'jours en matière correctionnelle ou d’un mois en matière criminelle, en '
                      'application des ',
                ),
                TextSpan(
                  text: 'articles 122 et 712-17 du Code de procédure pénale',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: '.'),
              ]),

              const SizedBox(height: 24),
              const _SubTitle(
                '6.5 – Autre domaine d’intervention : sécurité intérieure\net lutte contre le terrorisme',
              ),
              const _Paragraph(
                'La loi n° 2017-1510 du 30 octobre 2017 renforçant la sécurité intérieure '
                'et la lutte contre le terrorisme a confié au J.L.D. de Paris de nouvelles '
                'prérogatives spécifiques en matière de mesures de sûreté et de '
                'surveillance.',
              ),
              const SizedBox(height: 6),
              const _Paragraph(
                'Les développements détaillés relatifs à ces compétences particulières du '
                'J.L.D. peuvent être consultés dans le fascicule 8 consacré aux libertés '
                'publiques.',
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
