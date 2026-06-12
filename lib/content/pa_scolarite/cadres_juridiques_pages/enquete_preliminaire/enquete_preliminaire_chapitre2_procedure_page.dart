import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaEnquetePreliminaireChapitre2ProcedurePage extends StatelessWidget {
  const PaEnquetePreliminaireChapitre2ProcedurePage({super.key});

  static const String routeName =
      '/pa/dps_dpg/cadres_juridiques/enquete_preliminaire/chapitre2_procedure';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color bgColor = isDark ? const Color(0xFF121212) : Colors.white;
    final Color cardColor = isDark
? const Color(0xFF1E1E1E)
: const Color(0xFFF7F7F7);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF050505);
    final Color accent = isDark
? const Color(0xFF64B5F6)
: const Color(0xFF1565C0);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: titleColor),
          tooltip: 'Retour',
        ),
        title: Text(
          'Procédure d’enquête préliminaire',
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: titleColor,
          ),
        ),
      ),

      // ===================== CONTENU ============================
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
        physics: const BouncingScrollPhysics(),
        children: [
          // ---------------------- TITRE --------------------------
          Text(
            'Chapitre 2 — La procédure d’enquête préliminaire',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 8),

          // -------------------- INTRO ----------------------------
          const _Paragraph(
            'L’enquête préliminaire est encadrée par des règles strictes quant aux autorités habilitées à la conduire, '
            'à sa durée et aux garanties offertes aux personnes mises en cause et aux victimes. Ce chapitre précise, '
            'd’une part, qui peut diriger et mettre en œuvre l’enquête et, d’autre part, les conditions de durée et '
            'd’ouverture au contradictoire de cette procédure.',
          ),
          const SizedBox(height: 12),

          const _IntroBullet(
            text:
                'Le procureur de la République dirige l’enquête préliminaire et contrôle les mesures de garde à vue (art. 77 C.P.P.).',
          ),
          const _IntroBullet(
            text:
                'Les officiers de police judiciaire, et sous leur contrôle les agents de police judiciaire, procèdent aux enquêtes préliminaires (art. 75 C.P.P.).',
          ),
          const _IntroBullet(
            text:
                'La durée de l’enquête est strictement limitée par la loi, avec des règles particulières pour la criminalité organisée et le terrorisme.',
          ),

          const SizedBox(height: 20),

          // =======================================================
          // 2.1 — LES AUTORITÉS HABILITÉES
          // =======================================================
          _ConditionCard(
            title: '2.1 — Les autorités habilitées',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: const [
              _SubTitle('2.1.1 — Le procureur de la République'),
              _Paragraph(
                'Le procureur de la République dirige l’enquête préliminaire, que l’initiative de cette dernière '
                'revienne au parquet ou à la police judiciaire. Le procureur de la République peut intervenir à tout moment '
                'pour orienter l’activité de la police judiciaire. C’est lui qui contrôle la garde à vue, en ordonne la levée '
                'ou en autorise la prolongation (article 77 du C.P.P.).',
              ),
              SizedBox(height: 8),
              _Paragraph(
                'Le procureur de la République peut également procéder lui-même aux actes de l’enquête préliminaire. '
                'S’agissant de la garde à vue, il peut donner pour instruction à l’officier de police judiciaire de placer '
                'une personne en garde à vue.',
              ),
              SizedBox(height: 14),

              _SubTitle('2.1.2 — Les officiers et agents de police judiciaire'),
              _Paragraph.rich([
                TextSpan(
                  text:
                      'Conformément aux dispositions de l’article 75 du C.P.P., ',
                ),
                TextSpan(
                  text:
                      '« les officiers de police judiciaire, et sous le contrôle de ceux-ci, les agents de police judiciaire désignés à l’article 20 procèdent à des enquêtes préliminaires, soit sur les instructions du procureur de la République, soit d’office ». ',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph(
                'L’enquête préliminaire peut être ouverte d’office par des O.P.J. ou, sous leur contrôle, des A.P.J. '
                'dès lors qu’ils sont informés de l’existence possible d’une infraction pénale, quelle que soit la source '
                'de leur information, qui peut être notamment un renseignement anonyme.',
              ),
              SizedBox(height: 8),
              _ExempleBox(
                title: 'Jurisprudence',
                bodySpans: [
                  TextSpan(
                    text:
                        'Un renseignement anonyme informant la D.I.P.J. de Lyon de la réalisation imminente d’une importante opération '
                        'd’importation de stupéfiants justifie l’ouverture d’une enquête préliminaire, la poursuite n’étant elle-même '
                        'fondée que sur les seules investigations menées pendant l’enquête, à la suite de cette information '
                        '(Cass. crim., n°10-82.918 du 9 novembre 2010).',
                  ),
                ],
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        'En dehors des magistrats et des officiers ou agents de police judiciaire, la possibilité d’accomplir certains actes '
                        'en enquête préliminaire est également accordée par la loi aux assistants d’enquête (article 21-3 du C.P.P.).',
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // =======================================================
          // 2.2 — LES GARANTIES
          // =======================================================
          _ConditionCard(
            title: '2.2 — Les garanties',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: const [
              _SubTitle('2.2.1 — La durée'),
              _SubTitle('2.2.1.1 — Dispositions générales'),
              _Paragraph(
                'Lorsque le procureur de la République donne instruction aux officiers de police judiciaire de procéder à une enquête, '
                'il fixe le délai dans lequel elle doit être effectuée. Il peut proroger ce délai au vu des justifications fournies par les enquêteurs '
                '(article 75-1 du C.P.P.).',
              ),
              SizedBox(height: 8),
              _Paragraph(
                'Si l’enquête est menée d’office, les officiers de police judiciaire doivent rendre compte au procureur de la République de son état d’avancement '
                'lorsqu’elle est commencée depuis plus de six mois. Le décompte de ce délai commence à la date du premier procès-verbal.',
              ),
              SizedBox(height: 8),
              _Paragraph(
                'Lors d’une enquête relative à un crime ou un délit, dès qu’une personne à l’encontre de laquelle existent des indices faisant présumer qu’elle a commis '
                'ou tenté de commettre l’infraction est identifiée, l’officier de police judiciaire doit en aviser le procureur de la République '
                '(article 75-2 du C.P.P.).',
              ),
              SizedBox(height: 8),
              _Paragraph(
                'Les officiers de police judiciaire peuvent mettre en œuvre tous les actes de l’enquête préliminaire. En revanche, les agents de police judiciaire ont une '
                'compétence plus limitée : ils ne peuvent notamment pas décider des mesures de garde à vue.',
              ),
              SizedBox(height: 10),
              _Paragraph(
                'L’article 75-3 du code de procédure pénale prévoit que la durée d’une enquête préliminaire ne peut excéder deux ans à compter du premier acte '
                'd’audition libre, de garde à vue ou de perquisition d’une personne, y compris si celui-ci est intervenu dans le cadre d’une enquête de flagrance. '
                'Ainsi, le délai d’enquête ne s’apprécie pas de façon générale, mais individuellement, à l’encontre de chaque personne mise en cause.',
              ),
              SizedBox(height: 8),
              _Paragraph(
                'Le procureur de la République a la possibilité de prolonger une fois cette enquête pour une durée maximale d’un an, par une décision écrite et motivée, '
                'qui est versée au dossier de la procédure.',
              ),
              SizedBox(height: 8),
              _Paragraph(
                'Avant l’expiration de ce délai (deux ans, ou trois ans en cas de prolongation), les enquêteurs doivent clôturer la procédure et la transmettre au parquet. '
                'Tout acte d’enquête concernant la personne ayant fait l’objet d’une audition libre, d’une garde à vue ou d’une perquisition intervenant '
                'après l’expiration des délais prévus par la loi est nul.',
              ),
              SizedBox(height: 8),
              _Paragraph(
                'À titre exceptionnel, à l’expiration du délai de trois ans (après une première prolongation), le procureur de la République peut décider de la prolongation '
                'de l’enquête pendant une durée d’un an, renouvelable une fois, par décision écrite et motivée versée au dossier de la procédure. '
                'Ces prolongations exceptionnelles impliquent néanmoins une ouverture automatique au contradictoire avec mise à disposition de la procédure '
                'et possibilité de formuler des observations ou des demandes d’actes (voir § 2.2.2.4).',
              ),
              SizedBox(height: 8),
              _Paragraph(
                'L’enquête préliminaire de droit commun peut donc atteindre une durée maximale de cinq ans.',
              ),
            ],
          ),

          const SizedBox(height: 18),

          // =======================================================
          // 2.2.1.2 — CDO / TERRORISME
          // =======================================================
          _ConditionCard(
            title:
                '2.2.1.2 — Criminalité et délinquance organisées — Terrorisme',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: const [
              _Paragraph(
                'Lorsque l’enquête porte sur des crimes et délits relevant de la criminalité et délinquance organisées '
                '(articles 706-73 ou 706-73-1 du C.P.P.) ou de la compétence du parquet national antiterroriste '
                '(article 706-16 du C.P.P.), sa durée est limitée à trois ans, renouvelable pour deux ans sur autorisation écrite et motivée '
                'du procureur de la République.',
              ),
              SizedBox(height: 8),
              _Paragraph(
                'La prolongation exceptionnelle prévue à l’article 75-3 alinéa 4 ne s’applique pas : l’enquête préliminaire portant sur ces infractions '
                'peut donc atteindre une durée maximale de cinq ans, mais uniquement sur le fondement des prolongations ordinaires autorisées par les textes spéciaux.',
              ),
              SizedBox(height: 8),
              _Paragraph(
                'Le choix de la qualification pénale est donc déterminant pour le délai butoir de l’enquête. Il convient d’y apporter une attention particulière '
                'pour chaque mis en cause et ce dès le début de l’enquête.',
              ),
              SizedBox(height: 8),
              _Paragraph(
                'Ce choix appartient au procureur de la République, qui devra par exemple vérifier la possibilité de retenir la circonstance aggravante '
                'de bande organisée, susceptible de faire entrer certaines infractions dans le champ d’application des articles 706-73 et 706-73-1 du C.P.P.',
              ),
            ],
          ),

          const SizedBox(height: 18),

          // =======================================================
          // 2.2.1.3 — COMPUTATION DES DÉLAIS
          // =======================================================
          _ConditionCard(
            title: '2.2.1.3 — Computation des délais',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: const [
              _Paragraph(
                'Pour la computation des délais, il est prévu notamment :',
              ),
              SizedBox(height: 6),
              _BulletPoint(
                text:
                    'Si l’enquête reprend après un classement sans suite, il n’est pas tenu compte du délai pendant lequel elle a été suspendue.',
              ),
              _BulletPoint(
                text:
                    'En cas d’entraide judiciaire internationale, il n’est pas tenu compte du délai entre la signature de la demande et la réception des pièces d’exécution.',
              ),
              _BulletPoint(
                text:
                    'En cas de regroupement d’enquêtes, il est tenu compte de la date de l’audition libre, de la garde à vue ou de la perquisition la plus ancienne.',
              ),
              SizedBox(height: 8),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        'Ces dispositions concernant la durée de l’enquête préliminaire s’appliquent aux procédures initiées après le 23 décembre 2021, '
                        'date à laquelle a été introduit dans le C.P.P. l’article 75-3, qui créait une limitation de cette durée à deux voire trois ans '
                        'sans possibilité de prolongation exceptionnelle.',
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 18),

          // =======================================================
          // 2.2.1.4 — TABLEAU RÉCAPITULATIF
          // =======================================================
          _ConditionCard(
            title:
                '2.2.1.4 — Tableau récapitulatif des conditions d’encadrement de la durée des enquêtes',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: const [
              _Paragraph(
                'Le tableau suivant récapitule les principales conditions d’encadrement de la durée des enquêtes préliminaires :',
              ),
              SizedBox(height: 8),
              _ExempleBox(
                title: 'Synthèse des délais',
                bodySpans: [
                  TextSpan(
                    text:
                        'Objet de l’enquête : droit commun / infraction relevant de la criminalité et délinquance organisées (CDO, art. 706-73 ou 706-73-1 du C.P.P.) '
                        'ou relevant de la compétence du PNAT (article 706-16 du C.P.P.).\n\n'
                        'Délai butoir initial :\n'
                        '• Droit commun : 2 ans à compter du premier acte d’audition libre, de garde à vue ou de perquisition réalisé à l’encontre d’une personne, '
                        'y compris si elle a débuté en flagrance.\n'
                        '• CDO / PNAT : 3 ans, à compter du premier acte d’audition libre, de garde à vue ou de perquisition.\n\n'
                        'En cas de regroupement d’enquêtes, la date de la plus ancienne mesure est prise en compte.\n\n'
                        'Prolongation ordinaire :\n'
                        '• Droit commun : une fois pour un an, à compter de l’expiration du délai initial de 2 ans.\n'
                        '• CDO / PNAT : une fois pour 2 ans, à compter de l’expiration du délai initial de 3 ans.\n\n'
                        'Prolongation exceptionnelle :\n'
                        '• Droit commun : un an renouvelable une fois, avec mise en place d’un contradictoire renforcé (voir article 77-2 du C.P.P.).\n'
                        '• CDO / PNAT : non applicable.\n\n'
                        'Délai butoir en cas de prolongation : 5 ans dans les deux hypothèses, sur autorisation écrite et motivée du procureur de la République.\n\n'
                        'Hypothèses de suspension du délai :\n'
                        '• Décision de classement sans suite suivie d’une reprise de l’enquête sur décision du procureur de la République (suspension du délai entre la décision '
                        'de classement et l’instruction de reprise).\n'
                        '• Demande d’entraide pénale internationale (suspension entre la signature de la demande par le procureur émetteur et la réception des pièces d’exécution '
                        'transmises en retour par le pays requis).',
                  ),
                ],
              ),
              SizedBox(height: 6),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        'Source : Annexe à la circulaire D.A.C.G. CRIM2023 – 20 / H2. Ces repères doivent être connus pour vérifier la régularité '
                        'des délais d’enquête et anticiper les échéances procédurales.',
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // =======================================================
          // 2.2.2 — L’OUVERTURE AU CONTRADICTOIRE
          // =======================================================
          _ConditionCard(
            title: '2.2.2 — L’ouverture au contradictoire',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: [
              const _Paragraph.rich([
                TextSpan(
                  text:
                      'Les modalités d’ouverture au contradictoire de l’enquête préliminaire sont prévues par l’article 77-2 du code de procédure pénale, ',
                ),
                TextSpan(
                  text:
                      'qui détermine les possibilités pour la personne mise en cause ou la victime d’avoir accès au dossier de la procédure.',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ]),
              const SizedBox(height: 10),

              const _SubTitle(
                '2.2.2.1 — À l’initiative du procureur de la République',
              ),
              const _Paragraph(
                'À tout moment, le procureur de la République peut, s’il estime que cela ne risque pas de porter atteinte à l’efficacité des investigations, '
                'indiquer à la personne mise en cause, à la victime ou à leurs avocats qu’une copie de tout ou partie du dossier de la procédure est mise à leur disposition '
                'et que les intéressés ont la possibilité de formuler des observations.',
              ),
              const SizedBox(height: 6),
              const _Paragraph(
                'Ces observations peuvent notamment porter sur la régularité de la procédure, sur la qualification des faits, sur la nécessité de procéder à de nouveaux actes '
                'et sur les modalités d’engagement éventuel des poursuites.',
              ),
              const SizedBox(height: 12),

              const _SubTitle('2.2.2.2 — À la demande de la personne mise en cause'),
              const _Paragraph(
                'Toute personne contre laquelle il existe une ou plusieurs raisons plausibles de soupçonner qu’elle a commis ou tenté de commettre une infraction punie d’une peine '
                'd’emprisonnement peut demander à consulter le dossier.',
              ),
              const SizedBox(height: 6),
              const _Paragraph(
                'Cette demande ne pourra toutefois aboutir que si l’une des conditions suivantes est remplie :',
              ),
              const SizedBox(height: 6),
              const _BulletPoint(
                text:
                    'La personne mise en cause a été interrogée dans le cadre d’une audition libre ou d’une garde à vue qui s’est tenue il y a plus d’un an ;',
              ),
              const _BulletPoint(
                text:
                    'Il a été procédé à une perquisition chez la personne en cause il y a plus d’un an ;',
              ),
              const _BulletPoint(
                text:
                    'Il a été porté atteinte à la présomption d’innocence de la personne par un moyen de communication au public.',
              ),
              const SizedBox(height: 6),
              const _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        'Cette dernière condition n’est cependant pas applicable si les révélations émanent de l’intéressé ou de son avocat, '
                        'ou si l’enquête porte sur une infraction relevant de la criminalité organisée ou de la compétence du procureur de la République antiterroriste, '
                        'domaines dans lesquels le « droit à l’information » du public revêt une importance particulière.',
                  ),
                ],
              ),
              const SizedBox(height: 12),

              const _SubTitle('2.2.2.3 — À la demande de la victime'),
              const _Paragraph(
                'Lorsque la personne mise en cause a obtenu l’accès à la procédure, la victime, si elle a déposé plainte, est avisée par le procureur de la République '
                'qu’elle dispose alors du même droit d’accès au dossier.',
              ),
              const SizedBox(height: 12),

              const _SubTitle('2.2.2.4 — De droit'),
              const _Paragraph(
                'L’ouverture au contradictoire est automatique lorsque deux conditions sont réunies :',
              ),
              const SizedBox(height: 6),
              const _BulletPoint(
                text:
                    'L’enquête fait l’objet d’une prolongation exceptionnelle au-delà de trois ans, en application du quatrième alinéa de l’article 75-3 du C.P.P. ;',
              ),
              const _BulletPoint(
                text:
                    'Les personnes soupçonnées n’ont pas fait l’objet d’une audition libre, d’une garde à vue ou d’une perquisition depuis plus de deux ans.',
              ),
              const SizedBox(height: 8),
              const _Paragraph(
                'Dans ce cas, lorsque le procureur de la République décide d’une prolongation exceptionnelle de l’enquête, l’intégralité de la procédure doit être communiquée '
                'à la personne mise en cause, à la victime ou à leurs avocats. Les intéressés ont alors la possibilité de formuler des observations et des demandes d’actes.',
              ),
              const SizedBox(height: 8),
              const _Paragraph(
                'De plus, l’avocat de la personne soupçonnée doit être convoqué au moins cinq jours ouvrables avant toute audition réalisée en application de l’article 61-1 du C.P.P. '
                '(audition libre).',
              ),
              const SizedBox(height: 8),
              const _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        'Comme pour l’article 75-3 fixant les durées maximales des enquêtes, ces dispositions d’ouverture au contradictoire s’appliquent aux procédures initiées '
                        'après le 23 décembre 2021.',
                  ),
                ],
              ),
              // =======================================================
              // 2.3.7 — LES AUDITIONS
              // =======================================================
              _ConditionCard(
                title: '2.3.7 — Les auditions',
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: const [
                  _SubTitle('2.3.7.1 — L’audition du témoin'),
                  _Paragraph(
                    "L'article 78 alinéa 1 du C.P.P. pose le principe selon lequel les personnes convoquées par un O.P.J. pour les nécessités de l'enquête sont tenues de comparaître. "
                    "L’O.P.J. peut contraindre à comparaître par la force publique, avec l’autorisation préalable du procureur de la République, les personnes n’ayant pas répondu à une convocation ou "
                    "dont on peut craindre qu’elles ne répondent pas. Cela s’applique aux mis en cause comme aux simples témoins, quelle que soit la nature de l’infraction.",
                  ),
                  _Paragraph(
                    "Le procureur de la République peut également autoriser la comparution forcée sans convocation préalable en cas de risque de disparition ou modification des preuves, de pressions sur "
                    "les témoins ou victimes ou encore de concertation entre coauteurs ou complices.",
                  ),
                  _Paragraph(
                    "Cependant, la Cour de cassation (arrêt n° 16-82.412 du 22 février 2017) interdit toute pénétration de force dans un domicile pour exécuter un ordre de comparution, que le domicile soit "
                    "celui de la personne visée ou d’un tiers, et ce quel que soit le moyen utilisé (serrurier, bélier…).",
                  ),
                  _Paragraph(
                    "L’article 78 du C.P.P. permet uniquement l'appréhension forcée sur la voie publique. Pour pénétrer dans un domicile, un mandat de recherche (art. 77-4 C.P.P.) ou une autorisation du "
                    "juge des libertés et de la détention (art. 76 C.P.P.) peut être nécessaire, sous conditions.",
                  ),
                  _Paragraph(
                    "Les témoins ne pouvant être soupçonnés ne peuvent être retenus que le temps strictement nécessaire à leur audition, dans la limite de quatre heures. Ils peuvent refuser de déposer, "
                    "sans sanction, et doivent alors être laissés libres, sauf placement en garde à vue envisagé.",
                  ),
                  _Paragraph(
                    "Les A.P.J. peuvent procéder à l’audition sous contrôle d’un O.P.J. et les procès-verbaux doivent comporter les questions et réponses. Les témoins peuvent déclarer comme domicile le "
                    "commissariat ou la brigade (art. 706-57 C.P.P.), sous conditions.",
                  ),

                  SizedBox(height: 14),

                  _SubTitle(
                    '2.3.7.2 — L’audition du témoin qui devient suspect',
                  ),
                  _Paragraph(
                    "Si au cours de l’audition des raisons plausibles de soupçonner la commission d’un crime ou délit apparaissent, le statut de témoin disparaît. L’enquêteur peut soit poursuivre l’audition "
                    "en appliquant les droits du suspect entendu librement (art. 61-1 C.P.P.), soit placer la personne en garde à vue si les conditions sont réunies.",
                  ),
                  _Paragraph(
                    "Si la personne souhaite quitter les locaux, elle ne peut être placée en garde à vue au seul motif qu’elle refuse de répondre. Un témoin retenu devenu suspect ne peut être maintenu "
                    "que sous le régime légal de la garde à vue.",
                  ),

                  SizedBox(height: 14),

                  _SubTitle(
                    '2.3.7.3 — L’audition hors garde à vue d’une personne suspecte',
                  ),
                  _Paragraph(
                    "Une personne suspectée doit comprendre ses droits dans une langue qu’elle comprend. L’audition libre s’applique en enquête préliminaire, y compris pour les personnes convoquées "
                    "sur le fondement de l’article 78 C.P.P.",
                  ),
                  _Paragraph(
                    "Avant l’audition, l’enquêteur doit demander à la personne de confirmer qu’elle a suivi les agents sans contrainte. Puis, les droits prévus à l’article 61-1 C.P.P. lui sont notifiés :",
                  ),
                  _BulletPoint(
                    text: 'Qualification, date et lieu présumés des faits.',
                  ),
                  _BulletPoint(
                    text: 'Droit de quitter les locaux à tout moment.',
                  ),
                  _BulletPoint(text: 'Droit à un interprète.'),
                  _BulletPoint(text: 'Droit de parler, répondre ou se taire.'),
                  _BulletPoint(
                    text:
                        'Droit à l’assistance d’un avocat (auditions, confrontations, reconstitutions…).',
                  ),
                  _BulletPoint(
                    text:
                        'Possibilité d’obtenir des conseils juridiques gratuits.',
                  ),
                  _Paragraph(
                    "Si la personne souhaite partir, elle ne peut être retenue sauf si un motif de garde à vue (art. 62-2) est caractérisé. En cas de placement immédiat en garde à vue, le délai court "
                    "depuis le début de l’audition libre.",
                  ),

                  SizedBox(height: 14),

                  _SubTitle('2.3.7.4 — L’audition de la personne gardée à vue'),
                  _Paragraph(
                    "La personne gardée à vue peut demander l’assistance d’un avocat lors des auditions, confrontations et reconstitutions. L’avocat peut poser des questions à l’issue de l’audition, "
                    "ces questions et réponses sont consignées au procès-verbal. L’avocat peut relire mais ne signe pas le procès-verbal.",
                  ),

                  SizedBox(height: 14),

                  _SubTitle(
                    '2.3.7.5 — L’enregistrement des auditions en matière criminelle',
                  ),
                  _Paragraph(
                    'Conformément à l’article 64-1 du C.P.P., les auditions des personnes gardées à vue en matière criminelle doivent être enregistrées.',
                  ),

                  SizedBox(height: 14),

                  _SubTitle(
                    '2.3.7.6 — Les auditions sur le territoire d’un État étranger',
                  ),
                  _Paragraph(
                    "L’article 18 alinéa 4 du C.P.P. permet aux O.P.J. de procéder à des auditions à l’étranger, sous réserve de l’accord préalable des autorités de l’État concerné.",
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

/// ------------------------------------------------------------------
/// CARTE GLOBALE POUR CHAQUE BLOC
/// ------------------------------------------------------------------
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

/// ------------------------------------------------------------------
/// TITRE DE SOUS-PARTIE
/// ------------------------------------------------------------------
class _SubTitle extends StatelessWidget {
  const _SubTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color color = isDark ? Colors.white : const Color(0xFF0D47A1);

    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 4),
      child: Text(
        text,
        style: GoogleFonts.fustat(
          fontWeight: FontWeight.w700,
          fontSize: 14.5,
          color: color,
        ),
      ),
    );
  }
}

/// ------------------------------------------------------------------
/// PARAGRAPHES SIMPLES OU RICHES
/// ------------------------------------------------------------------
class _Paragraph extends StatelessWidget {
  const _Paragraph(this.text) : spans = null;

  const _Paragraph.rich(this.spans) : text = null;

  final String? text;
  final List<TextSpan>? spans;

  @override
  Widget build(BuildContext context) {
    final isRich = spans != null;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final Color color = isDark
        ? Colors.white70
        : const Color(0xFF1F1F1F).withValues(alpha: .92);

    if (!isRich) {
      return Text(
        text ?? '',
        textAlign: TextAlign.justify,
        style: GoogleFonts.fustat(
          fontSize: 14,
          height: 1.4,
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
          height: 1.4,
          fontWeight: FontWeight.w500,
          color: color,
        ),
        children: spans,
      ),
    );
  }
}

/// ------------------------------------------------------------------
/// PUCE D’INTRO
/// ------------------------------------------------------------------
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

/// ------------------------------------------------------------------
/// PUCE CLASSIQUE
/// ------------------------------------------------------------------
class _BulletPoint extends StatelessWidget {
  const _BulletPoint({required this.text});

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
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Icon(Icons.check_rounded, size: 18, color: bulletColor),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.fustat(
                fontSize: 14,
                height: 1.35,
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

/// ------------------------------------------------------------------
/// BLOC EXEMPLE
/// ------------------------------------------------------------------
class _ExempleBox extends StatelessWidget {
  const _ExempleBox({required this.bodySpans, this.title = 'NOTA'});

  final String title;
  final List<TextSpan> bodySpans;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color borderColor = isDark
        ? const Color(0xFF42A5F5)
        : const Color(0xFF1E88E5);
    final Color bgColor = isDark
        ? const Color(0xFF0D1B26)
        : const Color(0xFFE3F2FD);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF0D47A1);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor.withValues(alpha: isDark ? .65 : .9),
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: borderColor, width: 3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title :',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w800,
              fontSize: 13.5,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 4),
          RichText(
            textAlign: TextAlign.justify,
            text: TextSpan(
              style: GoogleFonts.fustat(
                fontSize: 13.5,
                height: 1.4,
                fontWeight: FontWeight.w500,
                color: isDark
                    ? Colors.white70
                    : const Color(0xFF102027).withValues(alpha: .95),
              ),
              children: bodySpans,
            ),
          ),
        ],
      ),
    );
  }
}

/// ------------------------------------------------------------------
/// BLOC NOTA
/// ------------------------------------------------------------------
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
        color: bgColor.withValues(alpha: isDark ? .70 : .95),
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: borderColor, width: 3)),
      ),
      child: RichText(
        textAlign: TextAlign.justify,
        text: TextSpan(
          style: GoogleFonts.fustat(
            fontSize: 13.5,
            height: 1.4,
            fontWeight: FontWeight.w500,
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
