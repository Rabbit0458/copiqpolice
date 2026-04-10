import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// ===================================================================
///  COP'IQ — ENQUÊTE DE FLAGRANT DÉLIT
///  CHAPITRE 3 : LA PROCÉDURE DE FLAGRANT DÉLIT
///
///  Plan repris du mémento :
///   3.1  Les autorités habilitées
///        3.1.1  Le procureur de la République
///        3.1.2  Les officiers de police judiciaire
///   3.2  La durée de l’enquête
///        3.2.1  Durée initiale
///        3.2.2  Prolongation de la durée
///   3.3  Les actes de la procédure
///        3.3.1  La saisine
///        3.3.2  La plainte (généralités, en ligne, visio-plainte,
///               violences conjugales, droits et protection des victimes)
///        3.3.3  Les constatations (traces, indices, investissement des lieux,
///               prélèvements externes et relevés signalétiques)
///        3.3.4  Les perquisitions (principes + limitations liées aux lieux)
/// ===================================================================
class FlagrantDelitProcedurePage extends StatelessWidget {
  const FlagrantDelitProcedurePage({super.key});

  static const String routeName =
      '/gpx/cadres_juridiques/enquete_flagrant_delit/chapitre3';

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
          'Procédure de flagrant délit',
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: titleColor,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
        physics: const BouncingScrollPhysics(),
        children: [
          // ---------------------------------------------------------
          // TITRE GÉNÉRAL
          // ---------------------------------------------------------
          Text(
            'Chapitre 3 — La procédure de flagrant délit',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 8),

          _Paragraph(
            'L’enquête de flagrant délit se caractérise par l’urgence et par des pouvoirs '
            'élargis reconnus aux autorités de police judiciaire. Ce chapitre précise : '
            'quelles autorités peuvent agir, pendant combien de temps l’enquête peut se '
            'poursuivre, et quels sont les principaux actes de procédure réalisables en '
            'flagrance (saisine, plainte, constatations, perquisitions, etc.).',
          ),
          const SizedBox(height: 14),

          const _IntroBullet(
            text:
                'Les autorités habilitées à conduire une enquête de flagrant délit sont strictement déterminées par le code de procédure pénale.',
          ),
          const _IntroBullet(
            text:
                'La durée de l’enquête est limitée dans le temps mais peut être prolongée dans des conditions précises.',
          ),
          const _IntroBullet(
            text:
                'Les actes de la procédure (plainte, constatations, perquisitions…) sont encadrés afin de concilier efficacité de l’enquête et protection des libertés.',
          ),
          const SizedBox(height: 20),

          // =========================================================
          // 3.1 — LES AUTORITÉS HABILITÉES
          // =========================================================
          _ConditionCard(
            title: '3.1 — Les autorités habilitées',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: const [
              _Paragraph(
                'Plusieurs autorités peuvent accomplir les actes de police judiciaire en '
                'flagrant délit : le procureur de la République, les officiers de police '
                'judiciaire de “plein exercice” et, pour certains actes déterminés, '
                'd’autres acteurs mentionnés par le code de procédure pénale.',
              ),
              SizedBox(height: 12),

              // 3.1.1 Procureur
              _SubTitle('3.1.1 — Le procureur de la République'),
              _Paragraph.rich([
                TextSpan(
                  text:
                      'En plus de ses pouvoirs de direction et de contrôle de l’enquête, le procureur de la République peut lui-même accomplir les actes de police judiciaire en flagrant délit. ',
                ),
                TextSpan(
                  text:
                      'Il dispose, sur tout le territoire national, des pouvoirs attachés à la qualité d’officier de police judiciaire prévus par le code de procédure pénale.',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    'Il peut se transporter sur tout le territoire, y compris dans le cadre d’une demande d’entraide adressée à un État étranger, afin d’y procéder à des actes d’enquête ou à des auditions.',
              ),
              _BulletPoint(
                text:
                    'En matière d’infractions flagrantes, il exerce les pouvoirs qui lui sont attribués par les dispositions du code de procédure pénale (direction des opérations, instructions données à l’officier de police judiciaire, décisions relatives à la garde à vue, etc.).',
              ),
              _BulletPoint(
                text:
                    'Il peut décider du recours à certaines mesures coercitives : mandat de recherche en cas de crime ou délit flagrant puni d’au moins trois années d’emprisonnement, demandes de prolongation de garde à vue, ouverture d’une information judiciaire lorsque le juge d’instruction est présent sur les lieux, etc.',
              ),
              SizedBox(height: 8),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        'En dehors du cadre strict de la flagrance, le procureur de la République choisit librement le service ou la unité de police auxquels il confie l’enquête, sans être obligé de se déplacer personnellement sur les lieux.',
                  ),
                ],
              ),

              SizedBox(height: 16),

              // 3.1.2 OPJ
              _SubTitle('3.1.2 — Les officiers de police judiciaire'),
              _Paragraph(
                'Seuls les officiers de police judiciaire de “plein exercice”, énumérés par les articles 16 et 16-1 du code de procédure pénale, sont compétents pour conduire une enquête de flagrant délit.',
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    'Ils disposent, en flagrance, de pouvoirs élargis portant atteinte aux libertés individuelles (perquisitions, saisies, placements en garde à vue, etc.), dans le strict respect des conditions légales.',
              ),
              _BulletPoint(
                text:
                    'Certaines infractions particulières (infractions routières, atteintes involontaires à la vie ou à l’intégrité physique à l’occasion d’accidents de la circulation) relèvent de règles de compétence spécifiques prévues par le code.',
              ),
              SizedBox(height: 8),
              _NotaBox(
                title: 'Autres intervenants possibles',
                bodySpans: [
                  TextSpan(
                    text:
                        'En plus des magistrats et des officiers de police judiciaire, la loi peut confier l’accomplissement de certains actes relevant de la flagrance à : ',
                  ),
                  TextSpan(
                    text:
                        'des agents de police judiciaire, des assistants d’enquête ou encore, pour l’appréhension de l’auteur présumé dans un lieu public, à tout citoyen en vertu de l’article 73 du code de procédure pénale.',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 22),

          // =========================================================
          // 3.2 — LA DURÉE DE L’ENQUÊTE
          // =========================================================
          _ConditionCard(
            title: '3.2 — La durée de l’enquête de flagrant délit',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: const [
              _Paragraph(
                'L’enquête de flagrant délit est par nature une enquête d’urgence. Sa durée est strictement encadrée par le code de procédure pénale, avec une durée initiale et une éventuelle prolongation sous conditions.',
              ),
              SizedBox(height: 12),

              _SubTitle('3.2.1 — La durée initiale'),
              _Paragraph.rich([
                TextSpan(
                  text:
                      'L’enquête de flagrance peut se poursuivre “sans discontinuer” pendant une durée maximale de huit jours, sous le contrôle du procureur de la République. ',
                ),
                TextSpan(
                  text:
                      'La jurisprudence retient qu’il doit exister une continuité dans les actes d’investigation réalisés, et non simplement dans la rédaction des procès-verbaux.',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ]),
              SizedBox(height: 8),
              _NotaBox(
                title: 'Jurisprudence',
                bodySpans: [
                  TextSpan(
                    text:
                        'Ce qui importe pour apprécier la validité de l’enquête, c’est la continuité des actes d’enquête et non la date à laquelle ils sont consignés par écrit. Une interruption prolongée rompt le caractère de flagrance et impose de basculer, le cas échéant, sur un autre cadre (enquête préliminaire, commission rogatoire…).',
                  ),
                ],
              ),

              SizedBox(height: 16),

              _SubTitle('3.2.2 — La prolongation de la durée'),
              _Paragraph(
                'Le procureur de la République peut décider de prolonger l’enquête de flagrant délit pour une nouvelle durée maximale de huit jours, lorsque deux conditions cumulatives sont réunies.',
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    'L’infraction en cause est un crime ou un délit puni d’une peine d’emprisonnement d’au moins cinq années.',
              ),
              _BulletPoint(
                text:
                    'Les investigations nécessaires à la manifestation de la vérité ne peuvent pas être différées sans compromettre l’enquête (complexité des faits, multiplicité des actes à réaliser, opération de grande ampleur, etc.).',
              ),
              SizedBox(height: 8),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        'Dès lors qu’il n’y a plus urgence ou qu’une interruption durable survient dans le déroulement des opérations, l’enquête ne peut plus être poursuivie sous le régime de la flagrance et doit être requalifiée (enquête préliminaire ou information judiciaire).',
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 22),

          // =========================================================
          // 3.3 — LES ACTES DE LA PROCÉDURE
          // =========================================================
          _ConditionCard(
            title: '3.3 — Les actes de la procédure de flagrant délit',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: const [
              _Paragraph(
                'L’enquête de flagrant délit comprend de nombreux actes permettant, si nécessaire, '
                'le recours à la contrainte. Ils relèvent exclusivement de l’officier de police '
                'judiciaire, sous la direction du procureur de la République.',
              ),
              SizedBox(height: 14),

              // 3.3.1 SAISINE
              _SubTitle('3.3.1 — La saisine'),
              _Paragraph(
                'La saisine de l’officier de police judiciaire résulte de la connaissance d’une '
                'situation de flagrance : appel de la victime, information par un témoin, '
                'interpellation directe, découverte de faits en patrouille, etc. Dès le premier '
                'procès-verbal de saisine, l’enquête de flagrant délit est ouverte et doit être '
                'conduite sans délai.',
              ),

              SizedBox(height: 12),

              // 3.3.2 PLAINTE
              _SubTitle('3.3.2 — La plainte'),
              _Paragraph(
                'La plainte constitue un acte central de la procédure : elle permet au victime '
                'd’officialiser les faits dont elle a été la cible, ouvre la possibilité de '
                'poursuites et déclenche des obligations précises à la charge des services de '
                'police judiciaire.',
              ),
              SizedBox(height: 8),

              _SubTitle(
                '3.3.2.1 — Généralités (article 15-3 du code de procédure pénale)',
              ),
              _BulletPoint(
                text:
                    'Les officiers et agents de police judiciaire sont tenus de recevoir les plaintes '
                    'déposées par les victimes d’infractions à la loi pénale, quel que soit le lieu '
                    'de commission des faits.',
              ),
              _BulletPoint(
                text:
                    'Toute plainte donne lieu à procès-verbal et à la délivrance d’un récépissé '
                    'mentionnant les délais de prescription de l’action publique et la possibilité '
                    'd’interrompre ce délai par une constitution de partie civile.',
              ),
              _BulletPoint(
                text:
                    'Si la victime en fait la demande, une copie du procès-verbal de plainte lui est remise immédiatement.',
              ),

              SizedBox(height: 10),

              _SubTitle('3.3.2.2 — Les plaintes en ligne'),
              _Paragraph(
                'Un dispositif de plainte dématérialisée permet, pour certains types d’infractions, '
                'de déposer plainte ou de prendre rendez-vous avec un service de police ou de '
                'gendarmerie via une plateforme en ligne. Il concerne notamment certaines escroqueries '
                'ou arnaques commises sur internet.',
              ),

              SizedBox(height: 10),

              _SubTitle('3.3.2.3 — La « visio-plainte »'),
              _Paragraph.rich([
                TextSpan(
                  text:
                      'Le code de procédure pénale autorise, dans des conditions strictement définies, '
                      'la prise de plainte à distance par moyen de télécommunication audiovisuelle. ',
                ),
                TextSpan(
                  text:
                      'Ce dispositif vise en particulier les victimes d’infractions graves '
                      '(violences, infractions sexuelles, etc.), afin de limiter leurs déplacements '
                      'tout en garantissant la confidentialité de leurs déclarations.',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ]),

              SizedBox(height: 10),

              _SubTitle('3.3.2.4 — La plainte pour violences conjugales'),
              _Paragraph(
                'Dans le cadre de la politique publique de lutte contre les violences conjugales, '
                'des mesures spécifiques améliorent l’accueil et la prise en charge des victimes '
                'dans les services de police et de gendarmerie : circuits dédiés, formation des '
                'intervenants, possibilité de plaintes accompagnées, etc.',
              ),

              SizedBox(height: 10),

              _SubTitle('3.3.2.5 — Les droits des victimes d’infraction'),
              _Paragraph(
                'Le code de procédure pénale recense de nombreux droits qui doivent être notifiés '
                'aux victimes dès le dépôt de plainte, par les officiers ou agents de police '
                'judiciaire ou, sous leur contrôle, par les assistants d’enquête.',
              ),
              SizedBox(height: 6),
              _BulletPoint(text: 'Droit à la réparation du préjudice subi.'),
              _BulletPoint(
                text:
                    'Droit de se constituer partie civile et d’être assistée par un avocat.',
              ),
              _BulletPoint(
                text:
                    'Droit d’être aidée par un service ou une association d’aide aux victimes.',
              ),
              _BulletPoint(
                text:
                    'Droit d’obtenir des informations sur la procédure, sur les suites données à la plainte et sur les mesures de protection possibles.',
              ),
              _BulletPoint(
                text:
                    'Droit, dans certains cas, de déclarer une adresse de domiciliation (professionnelle ou celle d’un tiers) pour la réception du courrier judiciaire.',
              ),
              SizedBox(height: 6),
              _NotaBox(
                title: 'Information des droits',
                bodySpans: [
                  TextSpan(
                    text:
                        'L’information de ces droits peut être faite par tout moyen, notamment par la remise d’un document écrit ou d’un récépissé de dépôt de plainte conforme aux modèles officiels. '
                        'Le non-respect de ces obligations peut être analysé comme une atteinte aux droits de la défense ou aux droits des victimes.',
                  ),
                ],
              ),

              SizedBox(height: 14),

              _SubTitle(
                '3.3.2.7 — Mesures de protection applicables à toute victime',
              ),
              _Paragraph(
                'Plusieurs dispositions prévoient des mesures de protection dès le stade de la plainte ou au cours de l’enquête :',
              ),
              SizedBox(height: 6),
              _BulletPoint(
                text:
                    'Droit à l’assistance d’un interprète et à la traduction des documents essentiels lorsque la victime ne comprend pas la langue française.',
              ),
              _BulletPoint(
                text:
                    'Droit d’être accompagnée, à tous les stades de la procédure, par un tiers de confiance (parent, proche, association d’aide aux victimes) ou par un avocat.',
              ),
              _BulletPoint(
                text:
                    'Possibilité d’organiser les auditions dans des locaux adaptés, à huis clos, et de limiter le nombre d’intervenants pour éviter toute revictimisation.',
              ),

              SizedBox(height: 10),

              _SubTitle(
                '3.3.2.8 — Évaluation personnalisée des besoins de protection',
              ),
              _Paragraph(
                'Les articles 10-5 et suivants du code de procédure pénale imposent une '
                'évaluation personnalisée des besoins de protection de la victime afin de '
                'déterminer si des mesures spéciales doivent être mises en œuvre :',
              ),
              SizedBox(height: 6),
              _BulletPoint(
                text:
                    'Importance du préjudice subi et gravité des faits (violences, infractions sexuelles, etc.).',
              ),
              _BulletPoint(
                text:
                    'Situation particulière de la victime (âge, grossesse, handicap, vulnérabilité psychologique ou sociale).',
              ),
              _BulletPoint(
                text:
                    'Existence d’un risque d’intimidation, de représailles, ou d’une emprise exercée par l’auteur présumé.',
              ),
              SizedBox(height: 6),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        'Cette évaluation initiale est réalisée par l’officier ou l’agent de police judiciaire et transmise à l’autorité judiciaire, qui décidera de l’opportunité de mesures de protection renforcées ou de l’orientation de la victime vers une association spécialisée.',
                  ),
                ],
              ),

              SizedBox(height: 14),

              _SubTitle(
                '3.3.2.9 — Mesures de protection spécifiques (articles D.1-6 et D.1-7 du code de procédure pénale)',
              ),
              _Paragraph(
                'Compte tenu de l’évaluation personnalisée, l’enquêteur peut mettre en place des mesures adaptées : auditions dans des locaux spécialement aménagés, '
                'auditions par un enquêteur formé, dispositifs de protection technique '
                '(téléphone grave danger, dispositif électronique anti-rapprochement, etc.), '
                'ou accompagnement renforcé pour certaines victimes (en particulier en cas de '
                'violences sexuelles, violences conjugales, infractions commises en raison du '
                'genre ou de l’orientation de la victime).',
              ),

              SizedBox(height: 18),

              // 3.3.3 CONSTATATIONS
              _SubTitle('3.3.3 — Les constatations'),
              _Paragraph(
                'Les constatations sont précédées, si nécessaire, d’un transport sur les lieux qui doit intervenir sans délai. '
                'Il s’agit d’examiner visuellement les lieux de l’infraction, de conserver les indices '
                'et tout élément pouvant servir à la manifestation de la vérité.',
              ),
              SizedBox(height: 10),

              _SubTitle('3.3.3.1 — Préservation des traces et indices'),
              _Paragraph(
                'L’officier de police judiciaire veille à la conservation des indices susceptibles de disparaître '
                'et de tout ce qui peut servir à la manifestation de la vérité : saisie d’armes, d’instruments, '
                'd’objets ou de tout bien paraissant provenir de l’infraction. Des périmètres de sécurité, scellés '
                'ou mesures conservatoires peuvent être mis en place.',
              ),

              SizedBox(height: 8),

              _SubTitle('3.3.3.2 — Investissement des lieux'),
              _Paragraph(
                'Présent sur les lieux, l’officier de police judiciaire peut interdire à toute personne de quitter '
                'les lieux de l’infraction avant la clôture des opérations, conserver sur place des témoins clés, '
                'et, le cas échéant, prendre des mesures coercitives pour maintenir un suspect à disposition le temps '
                'nécessaire aux premières vérifications, dans le respect des règles encadrant la garde à vue.',
              ),

              SizedBox(height: 8),

              _SubTitle(
                '3.3.3.3 — Prélèvements externes et relevés signalétiques',
              ),
              _Paragraph(
                'L’officier de police judiciaire peut faire procéder à des prélèvements externes '
                '(traces biologiques, empreintes digitales, relevés signalétiques) ou à des prises '
                'de photographies, dans les conditions prévues par le code de procédure pénale. '
                'Ces opérations sont strictement encadrées, notamment lorsqu’elles sont réalisées '
                'sans le consentement de la personne mise en cause.',
              ),
              SizedBox(height: 8),
              _NotaBox(
                title: 'Jurisprudence',
                bodySpans: [
                  TextSpan(
                    text:
                        'Le refus injustifié de se soumettre à certaines opérations de signalisation '
                        'ou de prélèvement ordonnées dans le cadre légal peut constituer un délit autonome. '
                        'Lorsque la prise d’empreintes ou de photographies est le seul moyen d’identifier '
                        'une personne gardée à vue, son refus est pénalement sanctionné.',
                  ),
                ],
              ),

              SizedBox(height: 18),

              // 3.3.4 PERQUISITIONS
              _SubTitle('3.3.4 — Les perquisitions'),
              _Paragraph(
                'La perquisition est la recherche, dans les lieux privés, d’objets, de documents ou '
                'de données informatiques relatifs aux faits incriminés. Elle ne peut être réalisée '
                'que par le procureur de la République ou par un officier de police judiciaire, dans '
                'les conditions fixées par le code de procédure pénale.',
              ),
              SizedBox(height: 8),

              _Paragraph.rich([
                TextSpan(
                  text:
                      'Le “domicile” s’entend largement : résidence principale, résidence secondaire, '
                      'dépendances (cave, garage) ou tout local assimilé à un domicile par la jurisprudence. ',
                ),
                TextSpan(
                  text:
                      'Certaines catégories de lieux bénéficient toutefois d’une protection renforcée '
                      '(cabinet d’avocat, entreprise de presse, lieux couverts par le secret de la défense nationale, etc.), '
                      'impliquant l’intervention d’un magistrat et le respect de règles complémentaires.',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ]),
              SizedBox(height: 10),

              _SubTitle(
                '3.3.4.1 — Limitation de la perquisition quant aux lieux',
              ),
              _Paragraph(
                'En raison de la nature particulière de certains lieux, la perquisition est encadrée '
                'par des formalités renforcées : locaux diplomatiques, cabinets d’avocats, entreprises '
                'de presse ou de communication audiovisuelle, locaux abritant des éléments couverts par '
                'le secret de la défense nationale, etc. Dans ces situations, la loi exige la présence '
                'ou l’autorisation préalable d’un magistrat, ainsi que le respect strict du secret '
                'professionnel, du secret des sources et de la liberté de la presse.',
              ),
              SizedBox(height: 8),

              _ExempleBox(
                title: 'Exemple pratique',
                bodySpans: [
                  TextSpan(
                    text:
                        'La perquisition dans un cabinet d’avocat ne peut être réalisée que par un magistrat, '
                        'en présence du bâtonnier ou de son représentant. Les documents saisis doivent être '
                        'directement liés à l’infraction recherchée, et l’ordonnance autorisant la perquisition '
                        'peut faire l’objet d’un recours dans un délai strictement encadré.',
                  ),
                ],
              ),
              SizedBox(height: 14),

              // --- Lieux spécialement protégés (presse, médecins, défense, etc.) ---
              _Paragraph.rich([
                TextSpan(
                  text:
                      'Dans les locaux d’une entreprise de presse ou d’une entreprise de communication audiovisuelle, '
                      'les perquisitions ne peuvent être effectuées que par un magistrat. Elles doivent respecter '
                      'la liberté de la presse et le secret des sources : la décision doit être écrite, motivée, '
                      'et le contenu des documents saisis ne peut être examiné qu’aux conditions prévues par la loi. ',
                ),
                TextSpan(
                  text:
                      'Un procès-verbal spécifique est dressé et un double du document saisi est remis à '
                      'l’entreprise de presse ou de communication audiovisuelle.',
                ),
              ]),
              SizedBox(height: 8),

              _Paragraph(
                'Les perquisitions réalisées dans le cabinet d’un médecin, d’un notaire, d’un huissier, '
                'ou dans les locaux d’une juridiction ou d’une juridiction internationale, sont également '
                'strictement encadrées : elles nécessitent l’intervention d’un magistrat et, le plus souvent, '
                'la présence du responsable de l’ordre ou de l’organisation professionnelle concernée.',
              ),
              SizedBox(height: 8),

              _Paragraph(
                'Lorsque les lieux sont couverts par le secret de la défense nationale, la perquisition '
                'est soumise à un régime très spécifique : liste limitative de sites, information de la Commission '
                'du secret de la défense nationale, mise sous scellés des éléments classifiés et conservation '
                'de ceux-ci par la Commission, selon des modalités entièrement dérogatoires.',
              ),
              SizedBox(height: 16),

              // 3.3.4.2 LIMITATION DANS LE TEMPS
              _SubTitle(
                '3.3.4.2 — Limitation de la perquisition dans le temps',
              ),
              _Paragraph(
                'La durée et l’horaire des perquisitions sont, en principe, encadrés. Les règles varient '
                'selon qu’elles sont réalisées pendant les heures légales (6h–21h) ou en dehors de ces heures, '
                'dans les hypothèses de perquisitions dites “de nuit”.',
              ),
              SizedBox(height: 10),

              _SubTitle('3.3.4.2.1 — Les heures légales'),
              _Paragraph(
                'Les perquisitions ne peuvent commencer qu’entre 6 heures et 21 heures (art. 59 C.P.P.). '
                'Toute perquisition entamée avant 21 heures peut se poursuivre au-delà de cette heure, à condition '
                'qu’elle se déroule sans discontinuer dans les différents lieux concernés.',
              ),
              SizedBox(height: 6),
              _NotaBox(
                title: 'Principe',
                bodySpans: [
                  TextSpan(
                    text:
                        'Le respect des heures légales s’apprécie au moment de la première ouverture de porte. '
                        'Le procès-verbal de perquisition doit permettre de vérifier que la perquisition a bien '
                        'débuté dans cette plage horaire.',
                  ),
                ],
              ),
              SizedBox(height: 8),

              _Paragraph(
                'Si des constatations ou une découverte incidente sont réalisées en dehors des heures légales '
                'alors qu’aucune perquisition n’a été autorisée de nuit, l’O.P.J. informe le magistrat, décrit les '
                'éléments constatés et, le cas échéant, suspend les opérations pour les reprendre ultérieurement '
                'dans le cadre légal.',
              ),
              SizedBox(height: 12),

              _SubTitle('3.3.4.2.2 — Hors heures légales'),
              _Paragraph(
                'En dehors des heures légales, la perquisition n’est possible que dans les cas strictement prévus '
                'par la loi, notamment :',
              ),
              SizedBox(height: 4),
              _BulletPoint(
                text:
                    'Une “réclamation faite de l’intérieur de la maison”, c’est-à-dire une demande claire et '
                    'non équivoque de l’occupant d’ouvrir aux enquêteurs (art. 59 C.P.P.).',
              ),
              _BulletPoint(
                text:
                    'Certaines enquêtes en matière de criminalité organisée, de trafic de stupéfiants, de traite '
                    'des êtres humains ou de proxénétisme, sur autorisation du juge des libertés et de la détention '
                    'à la requête du procureur de la République (art. 59-1 et 706-89 et s. C.P.P.).',
              ),
              _BulletPoint(
                text:
                    'La nécessité de prévenir un risque imminent d’atteinte à la vie ou à l’intégrité physique, '
                    'ou un risque de disparition immédiate de preuves et d’indices (conditions de fond du régime '
                    'des perquisitions de nuit).',
              ),
              SizedBox(height: 8),

              _ExempleBox(
                title: 'Perquisitions de nuit (art. 59-1 C.P.P.)',
                bodySpans: [
                  TextSpan(
                    text:
                        'Elles concernent principalement les crimes flagrants contre les personnes ou les infractions '
                        'relevant de la criminalité organisée. Elles nécessitent une ordonnance écrite et motivée du '
                        'juge des libertés et de la détention, saisie à la requête du procureur. Le magistrat contrôle '
                        'le déroulement des opérations et doit être informé dans les meilleurs délais des actes '
                        'accomplis par l’O.P.J.',
                  ),
                ],
              ),
              SizedBox(height: 16),

              // 3.3.4.3 PERSONNES POUVANT FAIRE L’OBJET D’UNE PERQUISITION
              _SubTitle(
                '3.3.4.3 — Personnes pouvant faire l’objet d’une perquisition',
              ),
              _Paragraph(
                'Selon l’article 56 alinéa 1 du C.P.P., les perquisitions s’effectuent au domicile des personnes '
                'qui “paraissent avoir participé au crime ou au délit” ou qui paraissent détenir des pièces, '
                'documents ou objets relatifs aux faits incriminés. Elles ne peuvent être réalisées qu’en présence '
                'de la personne concernée ou, à défaut, de son représentant ou de témoins requis.',
              ),
              SizedBox(height: 6),
              _NotaBox(
                title: 'Présence sur les lieux',
                bodySpans: [
                  TextSpan(
                    text:
                        'L’article 57 C.P.P. impose, en flagrant délit, la présence de la personne au domicile de '
                        'laquelle la perquisition a lieu ou, à défaut, celle de deux témoins requis par l’O.P.J. '
                        'Le procès-verbal mentionne cette présence et est signé par les personnes présentes.',
                  ),
                ],
              ),
              SizedBox(height: 12),

              // 3.3.4.4 RÉTENTION DES PERSONNES
              _SubTitle(
                '3.3.4.4 — Rétention des personnes lors des perquisitions',
              ),
              _Paragraph(
                'Les personnes présentes lors d’une perquisition peuvent être retenues sur place pendant le temps '
                'strictement nécessaire à l’accomplissement des opérations, afin de recueillir leurs explications '
                'ou d’éviter la disparition d’objets, de documents ou de données informatiques (art. 56 al. 11 C.P.P.).',
              ),
              SizedBox(height: 6),
              _Paragraph(
                'Si la rétention se prolonge ou si les éléments recueillis justifient une mesure privative de liberté, '
                'il peut être recouru à la garde à vue, dans le strict respect des conditions légales et des formalités '
                'd’information des droits.',
              ),
              SizedBox(height: 8),
              _NotaBox(
                title: 'Recours',
                bodySpans: [
                  TextSpan(
                    text:
                        'Toute personne ayant fait l’objet d’une perquisition ou d’une visite domiciliaire, non suivie '
                        'de poursuites devant une juridiction d’instruction ou de jugement, peut saisir le juge des '
                        'libertés et de la détention pour contester la régularité de l’acte dans le délai d’un an '
                        '(art. 802-2 C.P.P.).',
                  ),
                ],
              ),
              SizedBox(height: 18),

              // ===================================================
              // 3.3.5 — LES FOUILLES DE PERSONNES
              // ===================================================
              _SubTitle('3.3.5 — Les fouilles de personnes'),
              _Paragraph(
                'Les fouilles de personnes obéissent à un régime distinct de celui des perquisitions. '
                'Elles peuvent relever soit de la fouille intégrale judiciaire, assimilée à une perquisition, '
                'soit des investigations corporelles décidées par un magistrat, soit encore des mesures de '
                'sécurité imposées à la personne gardée à vue.',
              ),
              SizedBox(height: 10),

              _SubTitle('3.3.5.1 — La fouille intégrale judiciaire'),
              _Paragraph(
                'Prévue à l’article 63-7 du C.P.P., la fouille intégrale judiciaire est assimilée à une perquisition. '
                'Elle doit être motivée par les nécessités de l’enquête et respecter la dignité de la personne. '
                'Elle consiste en un examen minutieux des vêtements et, le cas échéant, en un déshabillage complet '
                'lorsque aucun autre moyen moins intrusif ne permet d’atteindre le même résultat.',
              ),
              SizedBox(height: 6),
              _Paragraph(
                'La fouille intégrale doit être réalisée par un O.P.J. ou sous son contrôle, par une personne du même '
                'sexe que la personne concernée. Les saisies utiles à l’enquête sont ensuite placées sous scellés.',
              ),
              SizedBox(height: 12),

              _SubTitle('3.3.5.2 — Les investigations corporelles'),
              _Paragraph(
                'Lorsque des investigations corporelles internes sont indispensables à la manifestation de la vérité '
                '(par exemple, recherche de corps étrangers), elles doivent être pratiquées par un médecin requis à cet effet, '
                'dans le strict respect de l’intégrité physique de la personne (art. 63-7 al. 2 C.P.P.).',
              ),
              SizedBox(height: 10),

              _SubTitle('3.3.5.3 — Les mesures de sécurité'),
              _Paragraph(
                'Les mesures de sécurité prévues aux articles 63-5 et 63-6 du C.P.P. visent à s’assurer que la personne '
                'gardée à vue ne détient aucun objet dangereux pour elle-même ou pour autrui. Elles ont un caractère '
                'administratif et se distinguent de la fouille intégrale judiciaire.',
              ),
              SizedBox(height: 6),
              _BulletPoint(text: 'La palpation de sécurité ;'),
              _BulletPoint(
                text: 'L’utilisation de moyens de détection électronique ;',
              ),
              _BulletPoint(
                text:
                    'Le retrait d’objets ou d’effets susceptibles de constituer un danger pour la personne ou pour autrui ;',
              ),
              _BulletPoint(
                text:
                    'Le retrait de certains vêtements, lorsque le contexte et la gravité des faits l’exigent, '
                    'dans des conditions respectueuses de la dignité de la personne.',
              ),
              SizedBox(height: 8),

              _SubTitle('3.3.5.3.1 — La palpation de sécurité'),
              _Paragraph(
                'Définie par le code de la sécurité intérieure, la palpation de sécurité consiste à découvrir et saisir '
                'tout objet susceptible de constituer un danger pour la sécurité de la personne interpellée, des policiers '
                'ou de tiers. Elle doit être pratiquée de façon méthodique et non humiliante, par une personne du même '
                'sexe, au travers des vêtements.',
              ),
              SizedBox(height: 8),

              _SubTitle(
                '3.3.5.3.2 — Utilisation de moyens de détection électronique',
              ),
              _Paragraph(
                'Les moyens de détection électronique (portiques, détecteurs manuels, etc.) complètent les palpations de '
                'sécurité. En cas d’impossibilité matérielle d’y recourir, l’O.P.J. ou l’A.P.J. en fait mention dans la procédure.',
              ),
              SizedBox(height: 8),

              _SubTitle('3.3.5.3.3 — Retrait d’objets ou d’effets dangereux'),
              _Paragraph(
                'Le retrait d’objets ou d’effets vise tout élément pouvant constituer un danger (lacets, ceintures, foulards, '
                'écharpes, bijoux, etc.). Les objets retirés sont placés sous scellés ou consignés dans un local sécurisé.',
              ),
              SizedBox(height: 8),

              _SubTitle('3.3.5.3.4 — Retrait de vêtements'),
              _Paragraph(
                'Le retrait de vêtements ne peut être systématique. Il doit être apprécié au cas par cas, en fonction notamment '
                'des conditions de l’interpellation, de la nature des faits reprochés, des antécédents judiciaires, de l’état '
                'de santé et de la vulnérabilité de la personne, ainsi que de la découverte éventuelle d’objets dangereux lors '
                'de la palpation de sécurité.',
              ),
              SizedBox(height: 6),
              _Paragraph(
                'Cette mesure est limitée au strict nécessaire : la personne ne peut être invitée à retirer qu’un sous-vêtement '
                'si celui-ci est susceptible de dissimuler un objet dangereux. Elle doit toujours être exécutée par une personne '
                'du même sexe, dans un local fermé et hors la vue de tiers, et faire l’objet d’une mention précise dans le procès-verbal.',
              ),
              SizedBox(height: 16),

              // ===================================================
              // 3.3.6 — FOUILLES DE VÉHICULES
              // ===================================================
              _SubTitle('3.3.6 — Les fouilles de véhicules'),
              _Paragraph(
                'Le véhicule n’est ni automatiquement assimilé au domicile, ni à sa dépendance. En flagrant délit, la fouille '
                'du véhicule peut être réalisée par un O.P.J. sans le consentement de la personne, dès lors qu’il existe des '
                'raisons plausibles de soupçonner une infraction et que les investigations sont utiles à la manifestation de la vérité.',
              ),
              SizedBox(height: 6),
              _Paragraph(
                'Les objets découverts et présentant un intérêt pour l’enquête sont saisis et placés sous scellés. Lorsque la fouille '
                'intervient dans le cadre de contrôles routiers ou d’infractions spécifiques au code de la route, les règles particulières '
                'des articles R.233-1, R.413-15 et suivants peuvent trouver à s’appliquer.',
              ),
              SizedBox(height: 14),

              // ===================================================
              // 3.3.7 — LES SAISIES ET SCELLÉS
              // ===================================================
              _SubTitle('3.3.7 — Les saisies et scellés'),
              _Paragraph(
                'Saisir et placer sous scellés consiste à assurer l’authentification et la conservation des pièces à conviction '
                'en vue de leur exploitation ultérieure au cours du procès pénal. Les saisies interviennent le plus souvent à '
                'l’occasion de constatations, de fouilles ou de perquisitions.',
              ),
              SizedBox(height: 6),
              _BulletPoint(
                text:
                    'En matière de constatations, les objets saisis sont mentionnés conformément à l’article 54 C.P.P. ;',
              ),
              _BulletPoint(
                text:
                    'En matière de perquisitions, l’inventaire des objets, documents et données informatiques saisis est '
                    'réalisé dans les formes prévues aux articles 56 et 57 C.P.P. ;',
              ),
              SizedBox(height: 6),
              _Paragraph(
                'Les données informatiques utiles à la manifestation de la vérité peuvent être copiées et placées sous contrôle de la justice. '
                'La restitution ou la destruction de ces données s’effectue, le cas échéant, sur instruction du procureur de la République.',
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: 'Information de la personne',
                bodySpans: [
                  TextSpan(
                    text:
                        'Lorsque la saisie concerne un bien susceptible de confiscation ultérieure, la personne concernée doit être '
                        'informée, au moment de la perquisition ou lors d’une audition ultérieure, des motifs de la saisie et de la '
                        'possibilité d’en demander la restitution.',
                  ),
                ],
              ),
              SizedBox(height: 18),

              // ===================================================
              // 3.3.8 — L’INTERPELLATION DE L’AUTEUR PRÉSUMÉ
              // ===================================================
              _SubTitle('3.3.8 — L’interpellation de l’auteur présumé'),
              _Paragraph(
                'En matière de crime ou de délit flagrant puni d’une peine d’emprisonnement, l’article 73 C.P.P. autorise toute personne '
                'à appréhender l’auteur présumé et à le conduire immédiatement devant l’O.P.J. le plus proche. L’O.P.J. reste toutefois '
                'responsable de la régularité de l’interpellation et des suites procédurales.',
              ),
              SizedBox(height: 10),

              _SubTitle('3.3.8.1 — L’appréhension de l’auteur présumé'),
              _Paragraph(
                'L’appréhension doit intervenir dans un temps très voisin de l’infraction et se faire, autant que possible, dans un lieu public '
                'et durant les heures légales. L’usage de la contrainte et, le cas échéant, de la force publique doit rester nécessaire, '
                'proportionné et faire l’objet d’une traçabilité dans la procédure.',
              ),
              SizedBox(height: 6),
              _NotaBox(
                title: 'Usage des menottes',
                bodySpans: [
                  TextSpan(
                    text:
                        'L’utilisation des menottes relève de l’appréciation de l’agent, au regard notamment des conditions de '
                        'l’interpellation, de la nature des faits reprochés, des antécédents judiciaires, de l’âge, de l’état de santé, '
                        'de l’agressivité de la personne ou de la découverte d’objets dangereux. Cet usage doit toujours rester proportionné '
                        'et compatible avec la présomption d’innocence.',
                  ),
                ],
              ),
              SizedBox(height: 14),

              _SubTitle('3.3.8.2 — Le mandat de recherche'),
              _Paragraph(
                'En flagrant délit, le procureur de la République peut décerner un mandat de recherche à l’encontre d’une personne '
                'contre laquelle il existe une ou plusieurs raisons plausibles de soupçonner la commission d’un crime ou d’un délit '
                'puni d’au moins trois ans d’emprisonnement (art. 70 C.P.P.).',
              ),
              SizedBox(height: 6),
              _SubTitle('3.3.8.2.1 — La délivrance du mandat de recherche'),
              _Paragraph(
                'Le mandat de recherche permet l’interpellation et la conduite de la personne devant l’O.P.J. ou le magistrat indiqué. '
                'Il est délivré par écrit, motivé en fait et en droit et notifié à la personne lors de son arrestation.',
              ),
              SizedBox(height: 6),
              _SubTitle('3.3.8.2.2 — Les actes d’investigations'),
              _Paragraph(
                'Les opérations réalisées en exécution d’un mandat de recherche obéissent au régime de l’enquête de flagrance ou de '
                'l’enquête préliminaire, selon le cadre juridique appliqué. Les actes doivent être consignés dans des procès-verbaux détaillés '
                'et portés à la connaissance du procureur de la République.',
              ),
              SizedBox(height: 6),
              _SubTitle('3.3.8.2.3 — La découverte de la personne recherchée'),
              _Paragraph(
                'Lorsque la personne recherchée est découverte, elle peut être placée en garde à vue dans les conditions habituelles. '
                'L’avis au procureur de la République mentionne le mandat de recherche exécuté et les circonstances de l’interpellation.',
              ),
              SizedBox(height: 8),

              // ===================================================
              // 3.3.9 — LA GARDE À VUE (DROIT COMMUN)
              // ===================================================
              _SubTitle('3.3.9 — La garde à vue (droit commun)'),
              _Paragraph(
                'La garde à vue est une mesure de contrainte décidée par l’O.P.J., sous le contrôle permanent '
                'de l’autorité judiciaire, à l’encontre d’une personne soupçonnée d’avoir commis ou tenté de '
                'commettre une infraction punie d’emprisonnement. Elle est strictement encadrée par le code de '
                'procédure pénale et entourée de garanties particulières.',
              ),
              SizedBox(height: 10),

              // 3.3.9.1 DOMAINE D’APPLICATION QUANT AUX PERSONNES
              _SubTitle(
                '3.3.9.1 — Domaine d’application de la garde à vue quant aux personnes',
              ),
              _Paragraph(
                'En principe, toute personne contre laquelle il existe une ou plusieurs raisons plausibles de soupçonner '
                'qu’elle a commis ou tenté de commettre un crime ou un délit puni d’emprisonnement peut être placée '
                'en garde à vue. Certaines catégories bénéficient cependant d’un statut particulier.',
              ),
              SizedBox(height: 6),
              const _BulletPoint(
                text:
                    'Les agents diplomatiques et certaines personnes bénéficiant d’immunités internationales ne peuvent être soumis à la garde à vue.',
              ),
              const _BulletPoint(
                text:
                    'Le président de la République bénéficie d’une inviolabilité pendant la durée de son mandat, hors hypothèses spéciales prévues par la Constitution.',
              ),
              const _BulletPoint(
                text:
                    'Les parlementaires peuvent, en cas de crime ou délit flagrant, être placés en garde à vue sous réserve de conditions renforcées et d’une information immédiate de l’autorité compétente.',
              ),
              const _BulletPoint(
                text:
                    'Les mineurs peuvent être placés en garde à vue sous des règles spécifiques, adaptées à leur âge et à leur vulnérabilité.',
              ),
              const SizedBox(height: 8),
              const _NotaBox(
                title: 'Principe',
                bodySpans: [
                  TextSpan(
                    text:
                        'La garde à vue constitue une atteinte grave à la liberté individuelle. Elle ne peut être décidée que lorsque les nécessités de l’enquête le justifient et dans le strict respect du principe de proportionnalité.',
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // 3.3.9.2 DOMAINE D’APPLICATION QUANT AUX INFRACTIONS
              _SubTitle(
                '3.3.9.2 — Domaine d’application de la garde à vue quant aux infractions',
              ),
              _Paragraph(
                'La garde à vue n’est possible que s’il s’agit d’un crime ou d’un délit puni d’une peine '
                'd’emprisonnement. Elle n’est pas applicable pour les simples contraventions.',
              ),

              const SizedBox(height: 12),

              // 3.3.9.3 CONDITIONS DE PLACEMENT EN GARDE À VUE
              _SubTitle('3.3.9.3 — Les conditions de placement en garde à vue'),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'La décision de placer une personne en garde à vue relève de l’O.P.J., qui exerce cette prérogative sous le contrôle de l’autorité judiciaire. ',
                ),
                const TextSpan(
                  text:
                      'Elle doit répondre à un double test : nécessité pour l’enquête et proportionnalité de l’atteinte à la liberté individuelle.',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ]),
              const SizedBox(height: 6),
              const _BulletPoint(
                text:
                    'Il doit exister une ou plusieurs raisons plausibles de soupçonner que la personne a commis ou tenté de commettre un crime ou un délit puni d’emprisonnement.',
              ),
              const _BulletPoint(
                text:
                    'La garde à vue doit constituer l’unique moyen de parvenir à au moins un des objectifs prévus par la loi (exécution des investigations, présentation au magistrat, prévention des pressions sur les témoins ou des concertations avec les complices, etc.).',
              ),
              const SizedBox(height: 6),
              const _NotaBox(
                title: 'Rappel jurisprudentiel',
                bodySpans: [
                  TextSpan(
                    text:
                        'Toute mesure privative de liberté doit être justifiée par les nécessités de la procédure, adaptée à la gravité des faits et ne pas porter atteinte à la dignité de la personne. L’O.P.J. doit motiver la mesure dans le procès-verbal de placement en garde à vue.',
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // 3.3.9.4 DURÉE DE LA GARDE À VUE
              _SubTitle('3.3.9.4 — La durée de la garde à vue'),
              _Paragraph(
                'La durée initiale de la garde à vue est de vingt-quatre heures. Elle peut être prolongée une fois pour une nouvelle période de vingt-quatre heures, lorsque la personne est soupçonnée d’un crime ou d’un délit dont la peine d’emprisonnement encourue est supérieure ou égale à un an et que cette prolongation constitue toujours le seul moyen d’atteindre les objectifs légaux.',
              ),
              const SizedBox(height: 6),
              const _Paragraph(
                'La prolongation est autorisée par le procureur de la République, après présentation de la personne ou, le cas échéant, par un moyen de télécommunication audiovisuelle. Elle doit être spécialement motivée au regard des éléments propres au dossier.',
              ),

              const SizedBox(height: 14),

              // 3.3.9.5 CARACTÈRE FACULTATIF DE LA GARDE À VUE
              _SubTitle(
                '3.3.9.5 — Le placement en garde à vue a un caractère facultatif',
              ),
              _Paragraph(
                'Même si les conditions légales sont réunies, le placement en garde à vue n’est jamais automatique. '
                'L’article 73 alinéa 2 C.P.P. permet, dans certains cas, de laisser la personne libre après interpellation, '
                'lorsqu’elle présente des garanties suffisantes de représentation et que les nécessités de l’enquête peuvent être satisfaites autrement.',
              ),
              const SizedBox(height: 6),
              const _ExempleBox(
                title: 'Illustration',
                bodySpans: [
                  TextSpan(
                    text:
                        'Une personne interpellée pour un délit flagrant, identifiée, domiciliée et sans antécédent peut, si le risque de fuite apparaît faible, être laissée libre avec convocation ultérieure plutôt que placée en garde à vue.',
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // 3.3.9.6 DÉBUT DE LA GARDE À VUE
              _SubTitle('3.3.9.6 — Le début de la garde à vue'),
              _Paragraph(
                'Pour le calcul des délais, le point de départ de la garde à vue est fixé, selon les cas, au moment '
                'de l’appréhension (interpellation en application de l’article 73), de la contrainte pour se présenter devant '
                'les services d’enquête ou de la notification formelle de la mesure à la personne. Toute rétention antérieure '
                'devant être prise en compte pour respecter la durée maximale autorisée, elle doit être précisément mentionnée en procédure.',
              ),

              const SizedBox(height: 14),

              // 3.3.9.7 ISSUE DE LA GARDE À VUE
              _SubTitle('3.3.9.7 — L’issue de la garde à vue'),
              _Paragraph(
                'À l’issue de la garde à vue, le procureur de la République décide, au vu des éléments recueillis, de la suite à '
                'donner : remise en liberté, éventuellement accompagnée de convocations ultérieures, ou déferrement devant la juridiction compétente.',
              ),

              const SizedBox(height: 18),

              // 3.3.9.8 GARANTIES ENTOURANT LA GARDE À VUE
              _SubTitle('3.3.9.8 — Les garanties entourant la garde à vue'),
              _Paragraph(
                'La garde à vue est encadrée par un ensemble de garanties visant à assurer le respect des droits fondamentaux '
                'de la personne retenue et le contrôle de la mesure par l’autorité judiciaire.',
              ),
              const SizedBox(height: 10),

              // 3.3.9.8.1 Garanties concernant la mise en œuvre
              _SubTitle(
                '3.3.9.8.1 — Garanties concernant la mise en œuvre de la garde à vue',
              ),
              const _Paragraph(
                'La mise en œuvre matérielle de la garde à vue relève de l’O.P.J., qui ne peut déléguer que certaines tâches pratiques '
                'à des A.P.J. ou assistants d’enquête. Les conditions de déroulement (hébergement, alimentation, hygiène, accès aux soins, '
                'temps de repos, déplacements) doivent respecter la dignité de la personne gardée à vue.',
              ),
              const SizedBox(height: 6),
              const _NotaBox(
                title: 'Traçabilité',
                bodySpans: [
                  TextSpan(
                    text:
                        'Un procès-verbal de fin de garde à vue récapitule l’ensemble de la mesure : horaires de début et de fin, auditions, temps de repos, '
                        'recours à des fouilles intégrales ou investigations corporelles, ainsi que les motifs justifiant le placement et, le cas échéant, la prolongation.',
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // 3.3.9.8.2 Garanties touchant au contrôle
              _SubTitle(
                '3.3.9.8.2 — Garanties touchant au contrôle de la garde à vue',
              ),
              _Paragraph(
                'La garde à vue est placée sous le contrôle des autorités hiérarchiques et judiciaires : visites périodiques des locaux, '
                'vérification des registres, contrôle du procureur de la République et, le cas échéant, du juge des libertés et de la détention. '
                'Des autorités indépendantes (Contrôleur général des lieux de privation de liberté, Défenseur des droits, C.P.T., etc.) peuvent également visiter les locaux de garde à vue.',
              ),

              const SizedBox(height: 16),

              // 3.3.9.8.3 DROITS DE LA PERSONNE GARDEE À VUE
              _SubTitle('3.3.9.8.3 — Droits de la personne gardée à vue'),
              _Paragraph(
                'Dès le début de la mesure, puis tout au long de la garde à vue, la personne bénéficie de droits fondamentaux dont '
                'l’O.P.J. doit assurer l’effectivité : être informée de ses droits, faire prévenir un tiers, communiquer, être examinée par un médecin, '
                'bénéficier de l’assistance d’un avocat, être assistée d’un interprète si nécessaire, et exercer son droit de se taire.',
              ),
              const SizedBox(height: 10),

              // 3.3.9.8.3.1 Droit d’être informée
              _SubTitle('3.3.9.8.3.1 — Le droit d’être informée'),
              const _Paragraph(
                'Toute personne placée en garde à vue doit être immédiatement informée, dans une langue qu’elle comprend, '
                'de la nature de l’infraction, de la durée possible de la mesure, de la possibilité de la prolonger, ainsi que '
                'de l’ensemble de ses droits (prévenir un proche, consulter un médecin, être assistée par un avocat, garder le silence, etc.).',
              ),
              const SizedBox(height: 6),
              const _BulletPoint(
                text:
                    'Les droits sont notifiés verbalement et, en principe, par la remise d’un formulaire écrit récapitulant ces informations.',
              ),
              const _BulletPoint(
                text:
                    'Si la personne ne comprend pas le français, les droits lui sont communiqués avec l’aide d’un interprète ou au moyen de formulaires adaptés.',
              ),

              const SizedBox(height: 12),

              // 3.3.9.8.3.2 Droit de faire prévenir un tiers
              _SubTitle(
                '3.3.9.8.3.2 — Le droit de faire prévenir un tiers de la mesure',
              ),
              _Paragraph(
                'La personne gardée à vue peut désigner une ou plusieurs personnes à prévenir (proche, membre de la famille, employeur, autorités consulaires). '
                'Sauf circonstances insurmontables ou décision motivée du procureur de la République, cette information doit intervenir dans un délai maximal de trois heures '
                'à compter de la demande.',
              ),
              const SizedBox(height: 6),
              const _NotaBox(
                title: 'Refus exceptionnel',
                bodySpans: [
                  TextSpan(
                    text:
                        'L’O.P.J. peut, à titre exceptionnel et sur instruction ou accord du procureur de la République, différer l’avis à un tiers lorsque cette information '
                        'risquerait de compromettre la conservation des preuves ou de créer un danger grave pour une personne.',
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // 3.3.9.8.3.3 Droit de communiquer
              _SubTitle('3.3.9.8.3.3 — Le droit de communiquer'),
              _Paragraph(
                'Sous le contrôle de l’O.P.J., la personne gardée à vue peut communiquer, par écrit, par téléphone ou lors d’un entretien, '
                'avec la personne prévenue de la mesure (proche, tiers, employeur, autorités consulaires). Ce droit ne concerne qu’une seule personne, '
                'et la communication peut être refusée ou limitée si elle risque de favoriser la commission d’une infraction ou de nuire gravement à l’enquête.',
              ),

              const SizedBox(height: 12),

              // 3.3.9.8.3.4 Droit à un examen médical
              _SubTitle('3.3.9.8.3.4 — Le droit à un examen médical'),
              _Paragraph(
                'Toute personne gardée à vue peut demander à être examinée par un médecin. Ce droit peut être exercé dès le début de la garde à vue, '
                'puis renouvelé en cas de prolongation. Le médecin est désigné par le procureur de la République ou par l’O.P.J. sur instruction de celui-ci.',
              ),
              const SizedBox(height: 6),
              const _BulletPoint(
                text:
                    'L’examen a lieu à l’abri des regards, dans le respect du secret médical et de la dignité de la personne.',
              ),
              const _BulletPoint(
                text:
                    'Le médecin apprécie l’aptitude de la personne à rester en garde à vue et peut formuler des prescriptions ou recommandations relatives à son état de santé.',
              ),

              const SizedBox(height: 12),

              // 3.3.9.8.3.5 Droit de garder le silence
              _SubTitle('3.3.9.8.3.5 — Le droit de garder le silence'),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'En matière pénale, toute personne soupçonnée dispose du droit de se taire sur les faits qui lui sont reprochés. ',
                ),
                const TextSpan(
                  text:
                      'Ce droit, rappelé par le code de procédure pénale, s’applique dès la première audition en garde à vue et tout au long de la procédure.',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ]),
              const SizedBox(height: 6),
              const _BulletPoint(
                text:
                    'La notification du droit au silence doit être faite dès le placement en garde à vue et rappelée en cas de besoin.',
              ),
              const _BulletPoint(
                text:
                    'La personne peut choisir de répondre à certaines questions seulement, ou de ne faire aucune déclaration sans que cela puisse être interprété comme un aveu.',
              ),
              const SizedBox(height: 6),
              const _NotaBox(
                title: 'Conséquence procédurale',
                bodySpans: [
                  TextSpan(
                    text:
                        'Aucune condamnation ne peut être prononcée sur le seul fondement de déclarations obtenues en méconnaissance du droit au silence. '
                        'L’absence de notification régulière de ce droit est susceptible d’entraîner la nullité des actes subséquents.',
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // 3.3.9.8.3.6 — Le droit à l’assistance d’un avocat
              _SubTitle('3.3.9.8.3.6 — Le droit à l’assistance d’un avocat'),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Dès le début de la garde à vue et à tout moment de la mesure, la personne peut demander à être assistée par un avocat '
                      '(art. 63-3-1 et 63-4 C.P.P.). ',
                ),
                const TextSpan(
                  text:
                      'Ce droit constitue une garantie essentielle de la défense et de l’équilibre de la procédure pénale.',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ]),
              const SizedBox(height: 6),

              const _SubTitle('Principe et contenu du droit'),
              const _BulletPoint(
                text:
                    'Entretien confidentiel avec l’avocat, dans la limite de trente minutes par tranche de vingt-quatre heures.',
              ),
              const _BulletPoint(
                text:
                    'Possibilité pour l’avocat de consulter certaines pièces de la procédure limitativement énumérées (procès-verbal de notification, certificat médical, procès-verbaux d’audition et de confrontation, etc.).',
              ),
              const _BulletPoint(
                text:
                    'Possibilité pour l’avocat d’assister aux auditions, confrontations, reconstitutions d’infraction et présentations pour identification de la victime ou du témoin.',
              ),
              const SizedBox(height: 6),

              const _SubTitle('Notification et renonciation'),
              const _Paragraph(
                'Le droit à l’assistance d’un avocat doit être notifié à la personne dès le début de la garde à vue, puis à chaque éventuelle prolongation. '
                'Si la personne renonce à l’assistance d’un avocat, cette renonciation doit être exprimée de manière claire et non équivoque et actée dans la procédure. '
                'La personne peut revenir sur sa décision à tout moment et demander finalement l’assistance d’un avocat.',
              ),
              const SizedBox(height: 6),

              const _SubTitle('Personne ne parlant pas français'),
              const _Paragraph(
                'Lorsque la personne gardée à vue ne comprend pas la langue française, elle a droit à l’assistance d’un interprète pour l’informer de son droit à un avocat '
                'et pour permettre les échanges avec celui-ci, y compris au moyen d’outils de télécommunication lorsque cela est nécessaire.',
              ),
              const SizedBox(height: 6),

              const _SubTitle('Désignation et contact de l’avocat'),
              const _Paragraph(
                'La personne gardée à vue peut demander à être assistée par un avocat choisi ou par un avocat commis d’office. '
                'L’assistance peut également être sollicitée par un tiers (membre de la famille, employeur, autorités consulaires) qui informe l’O.P.J. de cette demande. '
                'L’avocat doit être avisé sans délai de la demande d’assistance, par tout moyen (appel, message, fax, courriel…).',
              ),
              const SizedBox(height: 6),
              const _BulletPoint(
                text:
                    'En cas de choix d’un avocat déterminé, l’O.P.J. ou l’assistant d’enquête tente de le joindre par tous moyens et consigne les diligences accomplies (nombre d’appels, horaires, etc.).',
              ),
              const _BulletPoint(
                text:
                    'En cas de difficulté ou d’impossibilité de joindre l’avocat choisi, le bâtonnier est saisi pour désigner un avocat de permanence (art. 21-3 C.P.P.).',
              ),
              const SizedBox(height: 6),

              const _SubTitle('Information donnée à l’avocat'),
              const _Paragraph(
                'L’avocat doit être informé de la nature et de la date présumée de l’infraction reprochée, afin de pouvoir exercer utilement son rôle. '
                'Cette information peut être délivrée lors de son arrivée dans les locaux de police ou par échange téléphonique préalable.',
              ),
              const SizedBox(height: 6),

              const _SubTitle('Consultation de certaines pièces'),
              const _Paragraph(
                'L’avocat peut consulter, sans en prendre copie, certaines pièces limitativement prévues à l’article 63-4-1 C.P.P. '
                '(procès-verbal de notification, certificat médical, procès-verbaux d’audition et de confrontation, etc.). '
                'Il peut choisir de les lire avant ou après l’entretien avec la personne gardée à vue.',
              ),
              const SizedBox(height: 6),

              const _SubTitle('Entretien et présence aux actes'),
              const _Paragraph(
                'L’avocat peut s’entretenir avec la personne gardée à vue pendant trente minutes, au début de la mesure puis à chaque tranche de vingt-quatre heures. '
                'Il peut, sous réserve des dispositions spécifiques, assister aux auditions et confrontations de la personne, aux opérations de reconstitution, ainsi qu’aux séances d’identification auxquelles elle participe.',
              ),
              const SizedBox(height: 6),

              const _NotaBox(
                title: 'Limites à la présence de l’avocat',
                bodySpans: [
                  TextSpan(
                    text:
                        'En cas de nécessité impérieuse liée au bon déroulement de l’enquête (risque de compromission grave de la procédure, '
                        'menace grave et imminente pour la vie ou l’intégrité d’une personne), le procureur de la République peut différer la présence de l’avocat '
                        'ou l’accès aux procès-verbaux pendant une durée limitée, par décision écrite et motivée.',
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // 3.3.10 — LES AUDITIONS
              _SubTitle('3.3.10 — Les auditions'),
              _Paragraph(
                'Les auditions sont les actes par lesquels l’O.P.J., ou l’A.P.J. agissant sous son contrôle, recueille les déclarations des témoins, des personnes mises en cause '
                'ou des personnes suspectes. Elles peuvent être réalisées en enquête de flagrance ou dans tout autre cadre procédural.',
              ),
              const SizedBox(height: 10),

              _SubTitle('3.3.10.1 — Les parties à l’acte'),
              _SubTitle('3.3.10.1.1 — Les agents habilités'),
              _Paragraph(
                'Il s’agit de l’O.P.J. ou, sous son contrôle, de l’A.P.J. Les procès-verbaux d’audition dressés par les A.P.J. sont transmis à l’O.P.J., qui vérifie leur régularité '
                'et leur conformité aux règles de procédure (circ. 1er mars 1993).',
              ),
              const SizedBox(height: 6),

              _SubTitle(
                '3.3.10.1.2 — Les personnes susceptibles d’être entendues',
              ),
              _Paragraph(
                'Peuvent être entendues toutes personnes susceptibles de fournir des renseignements utiles sur les faits : victimes, témoins, personnes mises en cause, '
                'ou toute personne en possession d’éléments relatifs à l’infraction. Certaines catégories (agents diplomatiques, représentants d’États étrangers, etc.) '
                'bénéficient toutefois de règles particulières ou d’immunités.',
              ),
              const SizedBox(height: 10),

              _SubTitle('3.3.10.2 — L’audition de témoin'),
              _Paragraph(
                'Le témoin est une personne à l’encontre de laquelle il n’existe aucune raison plausible de soupçonner qu’elle a commis ou tenté de commettre une infraction '
                '(art. 62 al. 1 C.P.P.). Il est entendu sans mesure de garde à vue. L’audition peut, si les nécessités de l’enquête le justifient, se dérouler sous contrainte '
                'pendant une durée maximale de quatre heures (art. 62 al. 2 C.P.P.).',
              ),
              const SizedBox(height: 6),
              const _BulletPoint(
                text:
                    'Le témoin convoqué doit comparaître. Il peut, dans certains cas, être contraint à comparaître par la force publique sur autorisation du magistrat.',
              ),
              const _BulletPoint(
                text:
                    'Dans le cadre d’infractions graves, la loi permet de protéger l’adresse réelle de certains témoins en ne mentionnant qu’une adresse administrative (art. 706-58 C.P.P.).',
              ),
              const SizedBox(height: 6),

              _SubTitle(
                '3.3.10.3 — Audition du témoin qui devient auteur présumé',
              ),
              _Paragraph(
                'Si, au cours de l’audition, apparaissent des raisons plausibles de soupçonner que le témoin a commis ou tenté de commettre une infraction, '
                'il ne peut plus être entendu comme simple témoin. L’enquêteur doit soit lui faire immédiatement bénéficier des droits du mis en cause entendu librement '
                'ou placé en garde à vue, soit mettre fin à l’audition et lui notifier ses droits avant toute nouvelle audition.',
              ),
              const SizedBox(height: 8),

              _SubTitle('3.3.10.4 — Audition du mis en cause'),
              _Paragraph(
                'Le mis en cause peut être entendu sous différents statuts : personne gardée à vue, suspect libre ou personne entendue dans un autre cadre procédural. '
                'Dans tous les cas, il doit être informé de ses droits fondamentaux (droit à un interprète, à un avocat, au silence, etc.).',
              ),
              const SizedBox(height: 6),

              _SubTitle('3.3.10.4.1 — La personne placée en garde à vue'),
              _Paragraph(
                'La personne gardée à vue est informée de la possibilité d’être assistée par un avocat aux auditions et confrontations. '
                'L’avocat peut poser des questions à la fin de l’audition, qui sont consignées au procès-verbal si elles sont pertinentes pour la manifestation de la vérité.',
              ),
              const SizedBox(height: 6),

              _SubTitle('3.3.10.4.2 — Le suspect libre'),
              _Paragraph(
                'Le suspect libre bénéficie d’un véritable statut depuis la loi du 27 mai 2014. Avant toute audition, il doit être informé de la nature, de la date et du lieu '
                'des faits supposés, de son droit de quitter les locaux à tout moment, d’être assisté par un avocat, de se taire ou de répondre aux questions, '
                'et d’être assisté par un interprète si nécessaire.',
              ),
              const SizedBox(height: 6),

              _SubTitle(
                '3.3.10.5 — Enregistrement audiovisuel des auditions en matière criminelle',
              ),
              _Paragraph(
                'En matière criminelle, lorsque la personne est placée en garde à vue pour un crime mentionné à l’article 706-73 C.P.P. ou pour atteinte grave aux intérêts fondamentaux de la nation, '
                'les auditions doivent faire l’objet d’un enregistrement audiovisuel (art. 64-1 et D. 15-6 C.P.P.), sauf impossibilité technique dûment constatée.',
              ),
              const SizedBox(height: 6),

              _SubTitle(
                '3.3.10.6 — Auditions sur le territoire d’un État étranger',
              ),
              _Paragraph(
                'L’article 18 al. 4 C.P.P. permet à l’O.P.J. de procéder à des auditions sur le territoire d’un État étranger, avec l’accord des autorités compétentes de cet État '
                'et sur réquisitions du procureur de la République. Ces opérations sont strictement encadrées par le droit international et la coopération judiciaire.',
              ),
              const SizedBox(height: 18),

              // 3.3.11 — LES RÉQUISITIONS
              _SubTitle('3.3.11 — Les réquisitions'),
              _Paragraph(
                'La réquisition est l’acte par lequel une autorité judiciaire ou un O.P.J., agissant dans les conditions prévues par la loi, demande à une personne, un service ou une '
                'organisation de lui communiquer des informations, de réaliser un examen technique ou scientifique ou de fournir une prestation utile à l’enquête.',
              ),
              const SizedBox(height: 8),

              _SubTitle(
                '3.3.11.1 — Les réquisitions à personnes qualifiées (art. 60 C.P.P.)',
              ),
              _Paragraph(
                'Les personnes qualifiées (médecins, experts, services de police technique et scientifique, etc.) peuvent être requises pour procéder à des examens, constatations ou analyses. '
                'Elles interviennent en raison de leurs compétences dans une discipline donnée et peuvent placer sous scellés les objets examinés ou les prélèvements effectués.',
              ),
              const SizedBox(height: 6),
              const _BulletPoint(
                text:
                    'Les examens techniques ou scientifiques peuvent être réalisés en urgence, sans réquisition formalisée immédiatement, lorsque les nécessités de l’enquête l’imposent, '
                    'la régularisation intervenant ensuite en procédure.',
              ),
              const _BulletPoint(
                text:
                    'La différence entre examen technique et expertise résulte de la jurisprudence : l’expertise implique une analyse et des conclusions pouvant être débattues contradictoirement.',
              ),
              const SizedBox(height: 8),

              _SubTitle(
                '3.3.11.2 — Les réquisitions d’ordre général (art. 60-1 C.P.P.)',
              ),
              _Paragraph(
                'Le procureur de la République, l’O.P.J. ou, sous son contrôle, l’A.P.J. peuvent, par réquisition écrite ou électronique, demander à toute personne, organisme ou service '
                'de communiquer des documents, informations ou enregistrements utiles à l’enquête (données administratives, images de vidéosurveillance, données de transport, etc.).',
              ),
              const SizedBox(height: 6),
              const _NotaBox(
                title: 'Secret professionnel et limites',
                bodySpans: [
                  TextSpan(
                    text:
                        'Les personnes astreintes au secret professionnel peuvent refuser de répondre si la réquisition porterait atteinte au secret protégé par la loi '
                        '(avocats, médecins, journalistes pour la protection des sources, etc.). Dans ce cas, il appartient à l’autorité judiciaire d’apprécier '
                        'l’opportunité d’une perquisition dans les formes prévues par le code de procédure pénale.',
                  ),
                ],
              ),
              const SizedBox(height: 10),

              _SubTitle(
                '3.3.11.3 — Réquisitions portant sur les données de connexion (art. 60-1-2 C.P.P.)',
              ),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Les réquisitions visant les données de connexion (données techniques permettant d’identifier la source d’une communication, données de trafic et de localisation) '
                      'sont strictement encadrées. Elles ne sont possibles que si : ',
                ),
                const TextSpan(
                  text:
                      'les nécessités de la procédure l’exigent et que l’enquête porte sur un crime ou un délit puni d’au moins trois ans d’emprisonnement, ou dans certains cas précis (personne disparue, criminalité grave, etc.).',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ]),
              const SizedBox(height: 6),
              const _BulletPoint(
                text:
                    'Les données peuvent être demandées aux opérateurs de communications électroniques, aux fournisseurs d’accès à Internet ou aux hébergeurs de contenus en ligne.',
              ),
              const _BulletPoint(
                text:
                    'Les informations sollicitées concernent uniquement ce qui est nécessaire à l’identification de la source ou au reconstitution du parcours de communication, '
                    'dans le respect du droit au respect de la vie privée et des décisions des juridictions nationales et européennes.',
              ),
              const SizedBox(height: 8),

              const _NotaBox(
                title: 'Protection des droits fondamentaux',
                bodySpans: [
                  TextSpan(
                    text:
                        'La délivrance de réquisitions portant sur des données de connexion doit toujours être justifiée par la gravité des faits et les nécessités de l’enquête. '
                        'Les juridictions rappellent régulièrement que ces mesures doivent être proportionnées et motivées, en tenant compte de l’atteinte potentielle à la vie privée.',
                  ),
                ],
              ),
              const SizedBox(height: 26),
              // 3.3.11.4 — Les réquisitions informatiques et téléphoniques
              _SubTitle(
                '3.3.11.4 — Les réquisitions informatiques et téléphoniques (art. 60-2 et 60-3 C.P.P.)',
              ),
              _Paragraph(
                'L’O.P.J., ou l’A.P.J. agissant sous son contrôle, peut requérir des organismes '
                'publics ou privés afin d’obtenir la mise à disposition de données conservées '
                'dans des systèmes informatiques ou de télécommunication. Ces réquisitions '
                'sont strictement encadrées par les articles 60-2 et 60-3 du code de procédure '
                'pénale ainsi que par les textes relatifs à la protection des données et aux '
                'secrets protégés (secret professionnel, secret des affaires, secret religieux, '
                'philosophique, politique ou syndical…).',
              ),
              const SizedBox(height: 6),
              const _BulletPoint(
                text:
                    'Les organismes techniques de police ou de gendarmerie peuvent être saisis directement pour procéder à des examens techniques ou scientifiques, sans qu’il soit nécessaire d’établir une réquisition formelle.',
              ),
              const _BulletPoint(
                text:
                    'Les réquisitions adressées à des opérateurs de télécommunications visent à préserver, pour les besoins de l’enquête, le contenu des informations consultées ou échangées par les utilisateurs.',
              ),
              const SizedBox(height: 6),
              const _NotaBox(
                title: 'Refus de déférer',
                bodySpans: [
                  TextSpan(
                    text:
                        'Le refus de répondre à une réquisition régulièrement formulée, sans motif légitime, '
                        'peut constituer une infraction passible d’amende. À l’inverse, les personnes ou '
                        'organismes légalement protégés (cultes, syndicats, partis politiques…) ne peuvent être '
                        'contraints de livrer certaines informations couvertes par un secret spécialement protégé par la loi.',
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // 3.3.11.5 — Les réquisitions à interprète
              _SubTitle('3.3.11.5 — Les réquisitions à interprète'),
              _Paragraph(
                'L’O.P.J. peut requérir un interprète lorsqu’une personne placée en garde à vue, en retenue '
                'ou entendue dans le cadre de l’enquête ne comprend pas suffisamment le français, ou lorsqu’elle '
                'est atteinte d’un handicap de communication (surdité, mutisme, etc.). L’interprète garantit la '
                'compréhension des droits notifiés et des questions posées, ainsi que la fidélité des réponses '
                'rapportées en procédure.',
              ),
              const SizedBox(height: 6),
              const _BulletPoint(
                text:
                    'L’interprète peut intervenir physiquement ou, sous conditions de sécurité et de confidentialité, par un moyen de télécommunication audiovisuelle.',
              ),
              const _BulletPoint(
                text:
                    'Il prête serment de traduire fidèlement les déclarations et peut être choisi sur une liste spécialisée ou désigné à titre occasionnel.',
              ),
              const SizedBox(height: 10),

              // 3.3.11.6 — Réquisitions aux fins d’examen médical
              _SubTitle(
                '3.3.11.6 — Les réquisitions aux fins d’examen médical des personnes retenues',
              ),
              _Paragraph(
                'Toute personne placée en garde à vue, en retenue douanière ou dans un cadre assimilé peut, à sa demande '
                'ou à celle d’un tiers (proche, avocat…), faire l’objet d’un examen médical. L’O.P.J. ou le procureur de la '
                'République réquisitionne alors un médecin, conformément aux dispositions de l’article 63-3 C.P.P. et des textes '
                'spéciaux applicables aux mineurs ou majeurs protégés.',
              ),
              const SizedBox(height: 6),
              const _BulletPoint(
                text:
                    'L’examen médical a pour objet d’apprécier l’aptitude de la personne à demeurer en garde à vue ou en retenue, et de constater les éventuelles lésions ou blessures.',
              ),
              const _BulletPoint(
                text:
                    'Le certificat médical doit décrire l’état clinique et les blessures éventuelles, sans préjuger de la responsabilité pénale ni des incapacités civiles ou professionnelles.',
              ),
              const SizedBox(height: 6),
              const _NotaBox(
                title: 'Mineurs et personnes vulnérables',
                bodySpans: [
                  TextSpan(
                    text:
                        'Des réquisitions d’examen médical renforcées sont prévues pour les mineurs, les majeurs protégés et certaines personnes retenues en application de textes particuliers (C.J.P.M., C.S.E.D.A., etc.), '
                        'afin de vérifier la compatibilité de la mesure avec leur état de santé.',
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // 3.3.11.7 — Réquisitions aux fins d’autopsie
              _SubTitle('3.3.11.7 — Les réquisitions aux fins d’autopsie'),
              _Paragraph(
                'Dans le cadre d’une enquête de flagrant délit, une autopsie peut être ordonnée lorsqu’il existe un doute sur la cause '
                'du décès ou lorsqu’il est nécessaire de préciser les circonstances de commission d’une infraction. L’O.P.J., sur '
                'instructions du procureur de la République, réquisitionne un praticien qualifié en médecine légale au sens des articles '
                '230-28 et suivants du C.P.P.',
              ),
              const SizedBox(height: 6),
              const _BulletPoint(
                text:
                    'Seul un médecin spécialisé, titulaire des qualifications requises, peut être requis pour pratiquer une autopsie judiciaire.',
              ),
              const _BulletPoint(
                text:
                    'Les prélèvements effectués lors de l’autopsie sont placés sous scellés et destinés à une éventuelle exploitation ultérieure (analyses, contre-expertise…).',
              ),
              const SizedBox(height: 6),
              const _NotaBox(
                title: 'Information des proches',
                bodySpans: [
                  TextSpan(
                    text:
                        'Sous réserve des nécessités de l’enquête, la famille ou les proches du défunt sont informés de la réalisation de l’autopsie et de la restitution ultérieure du corps.',
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // 3.3.11.8 — Géolocalisation en temps réel
              _SubTitle(
                '3.3.11.8 — La géolocalisation en temps réel (art. 230-32 à 230-44 C.P.P.)',
              ),
              _Paragraph(
                'La géolocalisation en temps réel permet de suivre les déplacements d’une personne, d’un véhicule ou de tout autre '
                'objet, au moyen d’un dispositif dédié (balise) ou de l’activation à distance d’un équipement électronique '
                '(téléphone, tablette, ordinateur, système GPS embarqué…). Elle constitue une atteinte importante à la vie privée '
                'et ne peut être mise en œuvre que pour les crimes et les délits punis d’au moins trois ans d’emprisonnement, '
                'lorsque les nécessités de l’enquête l’exigent.',
              ),
              const SizedBox(height: 6),
              const _BulletPoint(
                text:
                    'En enquête de flagrance, la géolocalisation est autorisée par le procureur de la République pour une durée limitée (8 ou 15 jours selon la nature de l’infraction, renouvelable sous contrôle du juge des libertés et de la détention).',
              ),
              const _BulletPoint(
                text:
                    'L’introduction dans un lieu d’habitation pour installer ou retirer un dispositif de géolocalisation nécessite l’autorisation écrite et motivée du juge des libertés et de la détention.',
              ),
              const _BulletPoint(
                text:
                    'L’activation à distance d’un appareil électronique appartenant à certaines catégories protégées (médecin, avocat, parlementaire, journaliste…) est exclue ou soumise à un régime renforcé.',
              ),
              const SizedBox(height: 6),
              const _NotaBox(
                title: 'Jurisprudence',
                bodySpans: [
                  TextSpan(
                    text:
                        'La géolocalisation est regardée comme une ingérence grave dans la vie privée : elle doit être exécutée sous le contrôle effectif d’un magistrat et justifiée par la gravité des faits et les besoins de l’enquête.',
                  ),
                ],
              ),
              const SizedBox(height: 12),

              _ExempleBox(
                title: 'Tableau de synthèse — Géolocalisation',
                bodySpans: const [
                  TextSpan(
                    text:
                        'Champ d’application : crimes et délits punis d’au moins 3 ans ; toute personne ou tout objet, même à son insu. '
                        'Autorisation initiale : procureur de la République (décision écrite et motivée). Renouvellement : juge des libertés '
                        'et de la détention, pour un mois renouvelable, dans la limite d’un an (droit commun) ou de deux ans pour certaines '
                        'infractions graves. L’activation à distance d’un appareil nécessite toujours l’autorisation du J.L.D., sauf pour les '
                        'catégories légalement exclues.',
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // 3.3.11.9 — La réquisition à manœuvrer
              _SubTitle('3.3.11.9 — La réquisition à manœuvrer'),
              _Paragraph(
                'La réquisition à manœuvrer vise une personne dont l’intervention matérielle est nécessaire au déroulement de '
                'l’enquête (par exemple, un serrurier pour ouvrir une porte, un grutier pour déplacer un conteneur…). Elle ne repose '
                'pas sur des compétences d’expertise mais sur une prestation technique déterminée.',
              ),
              const SizedBox(height: 6),
              const _BulletPoint(
                text:
                    'La réquisition est fondée, en flagrant délit, sur les dispositions générales relatives aux constatations ou perquisitions ainsi que sur l’article R. 642-1 du code pénal sanctionnant le refus de déférer.',
              ),
              const SizedBox(height: 10),

              // 3.3.11.10 — Réquisition de l’art. L. 3354-1 du code de la santé publique
              _SubTitle(
                '3.3.11.10 — La réquisition de l’article L. 3354-1 du code de la santé publique',
              ),
              _Paragraph(
                'En cas de crime, de délit ou d’accident de la circulation laissant supposer un état alcoolique, les officiers ou agents '
                'de police judiciaire peuvent être amenés à faire procéder à des vérifications destinées à établir la preuve de la présence '
                'd’alcool (analyses cliniques, examens biologiques). Ces vérifications sont réalisées par un médecin, un interne, un étudiant '
                'en médecine autorisé ou un infirmier habilité.',
              ),
              const SizedBox(height: 6),
              const _BulletPoint(
                text:
                    'Les vérifications sont obligatoires en cas d’accident mortel ou grave de la circulation et peuvent également concerner la victime.',
              ),
              const SizedBox(height: 10),

              // 3.3.11.11 — Réquisitions des articles L. 234-4 et L. 234-9 du code de la route
              _SubTitle(
                '3.3.11.11 — Les réquisitions des articles L. 234-4 et L. 234-9 du code de la route',
              ),
              _Paragraph(
                'Ces réquisitions permettent d’établir la preuve de l’état alcoolique du conducteur ou de l’accompagnateur en cas de refus '
                'ou d’impossibilité de se soumettre aux épreuves de dépistage. Elles autorisent un prélèvement sanguin réalisé par un '
                'professionnel de santé habilité, sur décision de l’O.P.J. ou du parquet.',
              ),
              const SizedBox(height: 6),

              // 3.3.11.12 — Réquisitions de l’art. L. 235-2 du code de la route
              _SubTitle(
                '3.3.11.12 — La réquisition de l’article L. 235-2 du code de la route',
              ),
              _Paragraph(
                'Lorsque des raisons plausibles laissent supposer l’usage de stupéfiants par un conducteur impliqué dans un accident mortel '
                'ou grave, ou en cas de refus de dépistage, l’O.P.J. peut requérir un médecin ou un autre professionnel habilité pour '
                'effectuer des prélèvements destinés à rechercher la présence de substances stupéfiantes.',
              ),
              const SizedBox(height: 10),

              // 3.3.11.13 — Le policier requis
              _SubTitle('3.3.11.13 — Le policier requis'),
              _Paragraph(
                'En tant qu’agent de la force publique, le policier peut lui-même être requis par un magistrat pour accomplir certaines '
                'missions dans le cadre de l’enquête : par le procureur général, le procureur de la République ou le juge d’instruction. '
                'Dans ce cadre, il agit comme auxiliaire de justice et doit se conformer strictement aux instructions reçues.',
              ),
              const SizedBox(height: 14),

              // 3.3.12 — La saisie des comptes bancaires
              _SubTitle('3.3.12 — La saisie des comptes bancaires'),
              _Paragraph(
                'La saisie des comptes bancaires intervient principalement dans le cadre d’une procédure de confiscation de biens ou droits '
                'mobiles incorporels (sommes inscrites sur un compte de dépôt, de paiement, avoirs numériques, etc.), lorsque la loi prévoit '
                'une peine de confiscation ou en cas de crime ou délit puni d’une peine d’emprisonnement supérieure à un an.',
              ),
              const SizedBox(height: 6),
              const _BulletPoint(
                text:
                    'L’O.P.J., sur autorisation du procureur de la République, peut saisir les sommes figurant sur les comptes visés, afin d’éviter leur disparition avant jugement.',
              ),
              const _BulletPoint(
                text:
                    'Le juge des libertés et de la détention, saisi par le procureur, statue par ordonnance motivée sur le maintien ou la mainlevée de la saisie dans un délai de dix jours, y compris lorsque la juridiction de jugement est déjà saisie.',
              ),
              const SizedBox(height: 24),
            ],
          ),
        ],
      ),
    );
  }
}

/// ------------------------------------------------------------------
/// CARTE GLOBALE POUR CHAQUE BLOC (3.1 / 3.2 / 3.3)
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

/// ------------------------------------------------------------------
/// TITRE DE SOUS-PARTIE (3.1.1, 3.2.2, 3.3.2.5, etc.)
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
/// PARAGRAPHE SIMPLE / RICH
/// ------------------------------------------------------------------
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
        : const Color(0xFF1F1F1F).withOpacity(.92);

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
  const _ExempleBox({required this.title, required this.bodySpans});

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
        color: bgColor.withOpacity(isDark ? .65 : .9),
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
                    : const Color(0xFF102027).withOpacity(.95),
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
/// BLOC NOTA / INFO
/// ------------------------------------------------------------------
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
        color: bgColor.withOpacity(isDark ? .70 : .95),
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
