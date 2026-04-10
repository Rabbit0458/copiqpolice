import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CommissionRogatoireChapitre3Page extends StatelessWidget {
  const CommissionRogatoireChapitre3Page({super.key});

  static const String routeName =
      '/gpx/cadres_juridiques/commission_rogatoire/chapitre3';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF262626) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);
    final Color textSoft = isDark
        ? Colors.white70
        : const Color(0xFF1F1F1F).withOpacity(.88);

    final Color cardBlue = isDark
        ? const Color(0xFF0D1B2A)
        : const Color(0xFFE3F2FD);
    final Color cardBlueAccent = const Color(0xFF1565C0);

    final Color cardGreen = isDark
        ? const Color(0xFF0F2416)
        : const Color(0xFFE8F5E9);
    final Color cardGreenAccent = const Color(0xFF2E7D32);

    final Color cardPurple = isDark
        ? const Color(0xFF1B1530)
        : const Color(0xFFEDE7F6);
    final Color cardPurpleAccent = const Color(0xFF5E35B1);

    final Color cardTeal = isDark
        ? const Color(0xFF00363A)
        : const Color(0xFFE0F2F1);
    final Color cardTealAccent = const Color(0xFF00695C);

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
          'Commission rogatoire — Chapitre 3',
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 17.5,
            color: textMain,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
        children: [
          // ================================================================
          // TITRE PRINCIPAL
          // ================================================================
          Text(
            'Chapitre 3\nLes actes procéduraux de l’enquête sur commission rogatoire',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Pouvoirs des officiers de police judiciaire agissant sur commission '
            'rogatoire, contrôle du juge d’instruction et principaux actes '
            'd’enquête : constatations, prélèvements, auditions des témoins, '
            'témoins assistés et parties.',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w500,
              fontSize: 13.5,
              height: 1.35,
              color: textSoft,
            ),
          ),
          const SizedBox(height: 12),

          // ================================================================
          // INTRO : ARTICLE 152 CPP ET CONTROLE DU JUGE
          // ================================================================
          _ExempleBox(
            title: 'Article 152 alinéa 1 du Code de procédure pénale',
            bodySpans: const [
              TextSpan(
                text:
                    'Les magistrats ou officiers de police judiciaire commis pour '
                    'l’exécution exercent, dans les limites de la commission '
                    'rogatoire, tous les pouvoirs du juge d’instruction.',
              ),
            ],
          ),
          const SizedBox(height: 10),
          const _Paragraph(
            'Les pouvoirs de l’officier de police judiciaire sont donc très larges, '
            'mais restent strictement cantonnés au cadre de la commission '
            'rogatoire délivrée par le juge d’instruction.',
          ),
          const SizedBox(height: 6),
          const _Paragraph.rich([
            TextSpan(
              text: 'L’alinéa 2 de l’article 152 du Code de procédure pénale ',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            TextSpan(
              text:
                  'limite cependant ces pouvoirs, en particulier en matière '
                  'd’interrogatoire et de confrontation. Il est également évident que '
                  'l’officier de police judiciaire ne peut jamais se voir déléguer les '
                  'pouvoirs juridictionnels du juge d’instruction.',
            ),
          ]),
          const SizedBox(height: 8),
          const _Paragraph.rich([
            TextSpan(
              text:
                  'Lorsque l’officier de police judiciaire est chargé, par son chef '
                  'hiérarchique, de l’exécution d’une commission rogatoire, ',
            ),
            TextSpan(
              text:
                  'il doit, conformément à l’article D.33 alinéa 2 du Code de '
                  'procédure pénale, en rendre compte immédiatement au magistrat '
                  'mandant si celui-ci a prescrit cette diligence.',
            ),
          ]),
          const SizedBox(height: 10),
          const _Paragraph.rich([
            TextSpan(
              text: 'L’article 152 alinéa 3 du Code de procédure pénale ',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            TextSpan(
              text:
                  'renforce encore le contrôle du juge d’instruction sur les officiers '
                  'de police judiciaire : le juge peut se déplacer sur les lieux, sans '
                  'être assisté de son greffier, pour diriger et contrôler l’exécution '
                  'de la commission rogatoire, tant qu’il ne procède pas lui-même à '
                  'des actes d’instruction. Il appartient alors à l’officier de police '
                  'judiciaire de mentionner ce transport dans le corps de la procédure.',
            ),
          ]),
          const SizedBox(height: 10),
          _NotaBox(
            bodySpans: const [
              TextSpan(
                text:
                    'si la commission rogatoire émane d’un juge d’instruction situé '
                    'hors du ressort habituel de compétence de l’officier de police '
                    'judiciaire, ce dernier informe en outre le ou les procureurs de la '
                    'République compétents en raison du lieu d’exécution des actes '
                    'prescrits.',
              ),
            ],
          ),
          const SizedBox(height: 10),
          const _Paragraph(
            'En matière d’instruction, le procès-verbal de saisine matérialise, en '
            'réalité, l’enregistrement par l’officier de police judiciaire des pouvoirs '
            'qui lui sont délégués pour l’exécution de la commission rogatoire. '
            'Dès qu’il est saisi, l’officier de police judiciaire doit retourner la '
            'commission rogatoire, ainsi que les procès-verbaux d’exécution, dans le '
            'délai fixé par le juge d’instruction. À défaut de délai fixé, la commission '
            'rogatoire et les procès-verbaux sont transmis au plus tard dans les huit '
            'jours suivant la fin des opérations (article 151 alinéa 4 du Code de '
            'procédure pénale).',
          ),
          const SizedBox(height: 20),

          // ================================================================
          // 3.1 — LES CONSTATATIONS
          // ================================================================
          _ConditionCard(
            title: '3.1 — Les constatations',
            cardColor: cardBlue,
            accent: cardBlueAccent,
            titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
            children: const [
              _SubTitle('3.1.1 — Les constatations proprement dites'),
              _Paragraph(
                'Les constatations sur commission rogatoire ne sont pas détaillées '
                'comme telles dans le Code de procédure pénale, mais elles sont '
                'impliquées par les articles 81 et 151 du Code de procédure pénale. '
                'Le juge d’instruction peut accomplir lui-même, ou faire accomplir '
                'par commission rogatoire, tous les actes d’information qu’il juge '
                'utiles à la manifestation de la vérité.',
              ),
              SizedBox(height: 6),
              _Paragraph(
                'L’officier de police judiciaire délégué peut ainsi procéder à toutes '
                'les constatations nécessaires : sur les lieux de l’infraction, sur '
                'tout lieu, objet ou document utile aux investigations en cours, etc.',
              ),
              SizedBox(height: 6),
              _Paragraph(
                'Les règles à observer lors de ces constatations sont les mêmes que '
                'celles applicables en matière d’enquête de flagrant délit. Dès lors '
                'qu’il souhaite recueillir des explications des personnes présentes, '
                'l’officier de police judiciaire doit toutefois appliquer les règles '
                'propres aux auditions sur commission rogatoire, en fonction du statut '
                'de la personne (témoin, témoin assisté, mis en examen, partie civile).',
              ),
              SizedBox(height: 12),

              _SubTitle(
                '3.1.2 — Les prélèvements externes et les relevés signalétiques '
                '(article 154-1 Code de procédure pénale)',
              ),
              _Paragraph(
                'Pour les besoins de l’exécution de la commission rogatoire, l’officier '
                'de police judiciaire peut faire procéder, sur tout témoin ou toute '
                'personne mise en cause, aux prélèvements externes nécessaires à des '
                'examens techniques et scientifiques de comparaison avec les traces '
                'et indices déjà relevés (article 55-1 alinéa 1 du Code de procédure '
                'pénale).',
              ),
              SizedBox(height: 6),
              _Paragraph(
                'L’officier de police judiciaire peut également procéder, ou faire '
                'procéder sous son contrôle :',
              ),
              SizedBox(height: 6),
              _BulletPoint(
                text:
                    'aux opérations de relevés signalétiques (empreintes digitales, '
                    'palmaires, photographies) nécessaires à l’alimentation et à la '
                    'consultation des fichiers de police, selon les règles propres à '
                    'chacun de ces fichiers (article 55-1 alinéa 2 Code de procédure '
                    'pénale) ;',
              ),
              _BulletPoint(
                text:
                    'aux opérations permettant l’enregistrement, la comparaison et '
                    'l’identification des traces et indices ainsi que des résultats des '
                    'relevés signalétiques dans les fichiers de police, toujours selon '
                    'les règles propres à chaque fichier (article 55-1 alinéa 3 Code de '
                    'procédure pénale).',
              ),
              SizedBox(height: 6),
              _Paragraph(
                'Le refus, par une personne à l’encontre de laquelle il existe une ou '
                'plusieurs raisons plausibles de soupçonner qu’elle a commis ou tenté '
                'de commettre une infraction, de se soumettre à ces opérations de '
                'prélèvement ou de signalisation ordonnées par l’officier de police '
                'judiciaire constitue un délit puni d’un an d’emprisonnement et de '
                '15 000 euros d’amende.',
              ),
              SizedBox(height: 6),
              _Paragraph(
                'Lorsque la prise d’empreintes digitales ou palmaires, ou la prise d’une '
                'photographie, constitue l’unique moyen d’identifier une personne '
                'placée en garde à vue pour un crime ou un délit puni d’au moins trois '
                'ans d’emprisonnement, et que cette personne refuse de justifier de son '
                'identité ou fournit des éléments manifestement inexacts, l’opération '
                'peut être réalisée sans son consentement, sur autorisation écrite du '
                'juge d’instruction (article 55-1 alinéa 5 Code de procédure pénale).',
              ),
              SizedBox(height: 6),
              _Paragraph(
                'Dans ce cas, si la personne a demandé l’assistance d’un avocat au cours '
                'de la garde à vue, celui-ci est avisé par tout moyen et peut assister à '
                'l’opération. Celle-ci ne peut avoir lieu en son absence qu’après '
                'l’expiration d’un délai de deux heures à compter de l’avis donné. Pour '
                'les majeurs comme pour les mineurs, lorsque ces opérations sont '
                'effectuées sans consentement, la présence d’un avocat ou d’un '
                'représentant légal, ou d’un adulte approprié, est requise et elles ne '
                'peuvent jamais intervenir dans le cadre d’une audition libre.',
              ),
            ],
          ),
          const SizedBox(height: 22),

          // ================================================================
          // 3.2 — LES AUDITIONS
          // ================================================================
          _ConditionCard(
            title: '3.2 — Les auditions',
            cardColor: cardGreen,
            accent: cardGreenAccent,
            titleColor: isDark ? Colors.white : const Color(0xFF1B5E20),
            children: const [
              _Paragraph(
                'Les auditions réalisées sur commission rogatoire obéissent à des '
                'règles différentes selon le statut de la personne entendue '
                '(témoin, témoin assisté, personne mise en examen, partie civile).',
              ),
              SizedBox(height: 6),
              _Paragraph(
                'Tout procès-verbal d’audition doit mentionner les questions posées '
                'et les réponses apportées (article 429 alinéa 2 Code de procédure '
                'pénale). Le Code de procédure pénale prévoit également le droit à '
                'l’interprète pour la personne qui ne comprend pas la langue '
                'française, depuis le début de la procédure jusqu’à son terme.',
              ),
              SizedBox(height: 10),
              _SubTitle('3.2.1 — Les témoins'),
              _Paragraph(
                'En pratique, le terme “témoin” désigne une personne qui n’est pas '
                'suspectée d’avoir participé à l’infraction et qui peut apporter des '
                'informations utiles à l’enquête. Cependant, peut aussi être entendue '
                'comme témoin toute personne suspectée qui n’est ni mise en examen '
                'ni titulaire du statut de témoin assisté, à condition qu’il n’existe '
                'pas déjà à son encontre d’indices graves et concordants.',
              ),
              SizedBox(height: 6),
              _Paragraph(
                'À peine de nullité, ne peut être entendue comme simple témoin la '
                'personne nommément visée par un réquisitoire introductif ou '
                'supplétif sans être mise en examen : dans ce cas, elle doit être '
                'entendue comme témoin assisté (article 113-1 Code de procédure pénale).',
              ),
              SizedBox(height: 6),
              _Paragraph(
                'L’audition des témoins par l’officier de police judiciaire exécutant une '
                'commission rogatoire est prévue par l’article 152 du Code de procédure '
                'pénale. L’article 153 soumet les témoins cités à trois obligations : '
                'obligation de comparaître, obligation de prêter serment, obligation '
                'de déposer.',
              ),
              SizedBox(height: 12),

              // 3.2.1.1 Obligation de comparaître
              _SubTitle('3.2.1.1 — L’obligation de comparaître'),
              _Paragraph(
                'Toute personne contre laquelle il n’existe aucune raison plausible '
                'de soupçonner une infraction et qui est régulièrement convoquée '
                'comme témoin au cours d’une commission rogatoire est tenue de '
                'comparaître. Le juge ou l’officier de police judiciaire peut recourir, '
                'le cas échéant, aux dispositions relatives au témoin retenu sous '
                'contrainte et au témoin forcé à comparaître, sous le contrôle du '
                'magistrat instructeur.',
              ),
              SizedBox(height: 6),
              _Paragraph(
                'La contrainte ne peut être appliquée que s’il est établi que la '
                'personne a eu connaissance effective de sa convocation (remise en '
                'main propre, récépissé, etc.). Une convocation uniquement verbale '
                'ou téléphonique est insuffisante.',
              ),
              SizedBox(height: 10),

              // 3.2.1.2 Obligation de prêter serment
              _SubTitle('3.2.1.2 — L’obligation de prêter serment'),
              _Paragraph.rich([
                TextSpan(
                  text:
                      'Les témoins entendus sur commission rogatoire doivent prêter '
                      'serment de dire la vérité et décliner leur identité complète, '
                      'leur état, profession, domicile, ainsi que leurs éventuels liens '
                      'avec les parties (article 103 Code de procédure pénale). ',
                ),
              ]),
              SizedBox(height: 6),
              _Paragraph(
                'Sont dispensés de cette obligation de prêter serment :',
              ),
              SizedBox(height: 6),
              _BulletPoint(
                text:
                    'les mineurs de moins de seize ans et les proches de la personne '
                    'mise en examen ou du témoin assisté (ascendants, descendants, '
                    'frères et sœurs, alliés, conjoint, partenaire, etc.) ;',
              ),
              _BulletPoint(
                text:
                    'les personnes condamnées à l’interdiction de témoigner en justice '
                    'autrement que pour de simples déclarations ;',
              ),
              _BulletPoint(
                text:
                    'les personnes gardées à vue dans le cadre de l’information judiciaire.',
              ),
              SizedBox(height: 10),

              // 3.2.1.3 Obligation de déposer
              _SubTitle('3.2.1.3 — L’obligation de déposer'),
              _Paragraph(
                'L’obligation de déposer, prévue par l’article 153 alinéa 1 du Code de '
                'procédure pénale, ne concerne que les auditions réalisées dans le '
                'cadre d’une information judiciaire.',
              ),
              SizedBox(height: 6),
              _Paragraph(
                'Les personnes astreintes au secret professionnel doivent comparaître '
                'et décliner leur identité avant d’invoquer le secret. Elles peuvent '
                'en être déliées dans les cas où la loi impose ou autorise la révélation '
                'du secret. Les journalistes professionnels peuvent, quant à eux, ne pas '
                'révéler l’origine de leurs informations, sous conditions légales.',
              ),
              SizedBox(height: 6),
              _Paragraph(
                'La personne placée en garde à vue n’est pas tenue de déposer : après '
                'avoir décliné son identité, elle peut se taire.',
              ),
              SizedBox(height: 10),

              // 3.2.1.4 Sanctions
              _SubTitle(
                '3.2.1.4 — Sanctions pénales en cas de non-respect des obligations',
              ),
              _Paragraph(
                'Le témoin qui ne comparaît pas, refuse de prêter serment ou refuse de '
                'déposer sans excuse légitime encourt une amende prévue par le Code '
                'pénal. Par ailleurs, le témoignage mensonger devant un officier de '
                'police judiciaire exécutant une commission rogatoire est réprimé par '
                'les dispositions relatives au faux témoignage.',
              ),
              SizedBox(height: 10),

              // 3.2.1.5 Enregistrement GAV
              _SubTitle(
                '3.2.1.5 — Enregistrement audiovisuel des interrogatoires en garde à vue',
              ),
              _Paragraph(
                'L’article 64-1 du Code de procédure pénale prévoit que les auditions '
                'des personnes gardées à vue pour crime font l’objet d’un '
                'enregistrement audiovisuel. Il en va de même pour certains crimes '
                'particuliers (par exemple ceux mentionnés à l’article 706-73 du Code '
                'de procédure pénale ou portant atteinte aux intérêts fondamentaux '
                'de la Nation).',
              ),
              SizedBox(height: 12),

              // 3.2.1.6 Indices graves et concordants
              _SubTitle(
                '3.2.1.6 — Apparition d’indices graves et concordants à l’encontre '
                'd’une personne jusque-là considérée comme simple témoin',
              ),
              _Paragraph(
                'Si, avant, pendant ou après l’audition d’une personne entendue comme '
                'simple témoin, apparaissent des indices graves et concordants de sa '
                'culpabilité, l’article 105 du Code de procédure pénale interdit de '
                'la maintenir dans ce statut : elle doit être entendue comme mise en '
                'examen ou témoin assisté, afin de garantir ses droits de défense.',
              ),
              SizedBox(height: 6),
              _Paragraph(
                'Si l’officier de police judiciaire persiste à l’entendre comme simple '
                'témoin, il porte atteinte aux droits de la défense : l’audition est alors '
                'nulle, ainsi que les actes d’enquête qui en découlent.',
              ),
              SizedBox(height: 10),
              _SubTitle(
                '3.2.1.6.1 — La notion d’indices graves et concordants',
              ),
              _Paragraph(
                'Les indices peuvent être matériels (pièces à conviction, traces, '
                'empreintes) ou immatériels (aveu, témoignage, etc.), mais doivent '
                'présenter un caractère apparent et objectif. Ils doivent cumuler :',
              ),
              SizedBox(height: 6),
              _BulletPoint(
                text:
                    'la pluralité (plusieurs éléments concordants renforcent la force '
                    'probante) ;',
              ),
              _BulletPoint(text: 'la gravité ;'),
              _BulletPoint(
                text:
                    'la concordance (les indices ne sont pas contradictoires et forment '
                    'un faisceau).',
              ),
              SizedBox(height: 6),
              _Paragraph(
                'Il n’y a, par exemple, pas d’indices graves et concordants lorsque les '
                'soupçons reposent uniquement sur les déclarations d’un tiers, '
                'lorsque la personne nie constamment les faits et dispose d’alibis, '
                'ou encore lorsque les aveux recueillis ne coïncident pas avec les '
                'résultats des investigations.',
              ),
              SizedBox(height: 10),
              _SubTitle(
                '3.2.1.6.2 — Conséquences pour l’officier de police judiciaire',
              ),
              _Paragraph(
                'Dès qu’il estime que des indices graves et concordants existent à '
                'l’encontre d’une personne initialement entendue comme simple témoin, '
                'l’officier de police judiciaire doit immédiatement en informer le juge '
                'd’instruction.',
              ),
              SizedBox(height: 6),
              _Paragraph(
                'Si ces indices apparaissent pendant l’audition, l’officier doit, à peine '
                'de nullité, y mettre fin et aviser sans délai le magistrat instructeur. '
                'S’ils apparaissent avant ou après l’audition, il ne peut plus procéder '
                'à une audition comme simple témoin sans l’accord du juge.',
              ),
              SizedBox(height: 6),
              _Paragraph(
                'Le juge d’instruction décidera alors de placer la personne en examen, '
                'de lui conférer le statut de témoin assisté ou de la laisser simple '
                'témoin si les indices ne sont finalement pas caractérisés.',
              ),
              SizedBox(height: 12),

              // 3.2.1.7 Autres éléments permettant le statut de témoin assisté
              _SubTitle(
                '3.2.1.7 — Apparition d’éléments, autres que des indices graves '
                'et concordants, permettant à un simple témoin de bénéficier du '
                'statut de témoin assisté',
              ),
              _Paragraph(
                'Une plainte contre personne dénommée, une mise en cause par la '
                'victime ou par un autre témoin, ou des éléments nouveaux peuvent '
                'justifier, sans atteindre le seuil des indices graves et concordants, '
                'l’attribution du statut de témoin assisté par le juge d’instruction.',
              ),
              SizedBox(height: 6),
              _Paragraph(
                'La Chancellerie précise que l’attribution de ce statut relève de la '
                'seule appréciation du magistrat instructeur. Tant que le seuil des '
                'indices graves et concordants n’est pas atteint, l’officier de police '
                'judiciaire continue à entendre la personne comme simple témoin, sans '
                'nullité, sous réserve d’informer le magistrat lorsque la personne est '
                'visée par une plainte avec constitution de partie civile ou mise en '
                'cause de manière précise.',
              ),
              SizedBox(height: 10),

              // 3.2.2 Témoins assistés
              _SubTitle('3.2.2 — Les témoins assistés'),
              _Paragraph(
                'Le témoin assisté occupe une position intermédiaire entre le simple '
                'témoin et la personne mise en examen. Il bénéficie notamment du '
                'droit d’être assisté d’un avocat lorsqu’il est entendu par le juge '
                'd’instruction. Son audition par l’officier de police judiciaire sur '
                'commission rogatoire est prévue par l’article 152 du Code de '
                'procédure pénale.',
              ),
              SizedBox(height: 6),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        'l’audition par l’officier de police judiciaire d’un témoin assisté '
                        'suppose que ce dernier ait lui-même demandé à être entendu. '
                        'Cette circonstance doit être mentionnée au début du procès-'
                        'verbal.',
                  ),
                ],
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    'l’audition peut résulter d’une demande écrite adressée au juge '
                    'd’instruction, qui délivre alors une commission rogatoire en ce '
                    'sens ;',
              ),
              _BulletPoint(
                text:
                    'en cas d’urgence, les enquêteurs déjà saisis d’une commission '
                    'rogatoire peuvent, après accord du juge d’instruction, entendre un '
                    'témoin assisté qui se présente spontanément.',
              ),
              SizedBox(height: 6),
              _BulletPoint(
                text:
                    'le témoin assisté est entendu hors la présence de son avocat, qui '
                    'peut toutefois être admis si les enquêteurs acceptent sa présence ;',
              ),
              _BulletPoint(
                text:
                    'le témoin assisté ne prête pas serment, ne peut faire l’objet '
                    'd’aucune mesure de contrainte ni d’une garde à vue pour les faits '
                    'en cause, et peut mettre fin à tout moment à son audition ;',
              ),
              _BulletPoint(
                text:
                    'le témoin assisté peut, à tout moment, demander à être mis en '
                    'examen ; il est alors considéré comme mis en examen à compter de '
                    'sa demande.',
              ),
              SizedBox(height: 10),

              // 3.2.3 Les parties
              _SubTitle('3.2.3 — Les parties'),
              _SubTitle('3.2.3.1 — La personne mise en examen'),
              _Paragraph(
                'Les officiers de police judiciaire ne peuvent pas procéder, sur '
                'commission rogatoire, aux interrogatoires et confrontations de la '
                'personne mise en examen : ces actes relèvent exclusivement du juge '
                'd’instruction. La mise en examen résulte d’une notification faite par '
                'le juge, soit lors de l’interrogatoire de première comparution, soit '
                'par courrier dans les conditions prévues par le Code de procédure '
                'pénale.',
              ),
              SizedBox(height: 8),
              _Paragraph(
                'Le témoin assisté peut également, à tout moment, demander à être mis '
                'en examen : il acquiert alors ce statut dès sa demande ou dès '
                'l’envoi de la lettre recommandée adressée au juge. Il peut aussi, par '
                'la suite, solliciter la conversion de sa mise en examen en statut de '
                'témoin assisté, sous le contrôle du juge d’instruction.',
              ),
              SizedBox(height: 10),
              _SubTitle('3.2.3.2 — La partie civile'),
              _Paragraph(
                'La partie civile est la personne qui se constitue pour obtenir la '
                'réparation de son préjudice. Elle peut être entendue, interrogée ou '
                'confrontée seulement en présence de son avocat, sauf renonciation '
                'expresse ou convocation de ce dernier (article 114 Code de '
                'procédure pénale).',
              ),
              SizedBox(height: 6),
              _Paragraph(
                'Les officiers de police judiciaire ne peuvent entendre la partie '
                'civile que si celle-ci en fait la demande (article 152 alinéa 2 Code '
                'de procédure pénale). Le procès-verbal doit mentionner que la partie '
                'civile a elle-même souhaité être entendue et qu’elle consent, le cas '
                'échéant, à déposer hors la présence de son avocat.',
              ),
              SizedBox(height: 6),
              _Paragraph(
                'Partie à l’information, la partie civile est entendue sans prêter '
                'serment, comme la personne mise en examen, et elle n’est pas soumise '
                'au secret de l’instruction.',
              ),
            ],
          ),
          const SizedBox(height: 26),
        ],
      ),
    );
  }
}

/// =====================================================================
///  WIDGETS UTILISÉS (mêmes classes que dans les chapitres 1 et 2)
/// =====================================================================

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
/// BLOC NOTA / INFO / SANCTION
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
