import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaRequisitionsPage extends StatelessWidget {
  const PaRequisitionsPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/cadres_juridiques/commission_rogatoire/requisitions';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF262626) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);
    final Color textSoft = isDark
        ? Colors.white70
        : const Color(0xFF1F1F1F).withValues(alpha: .88);

    final Color cardBlue = isDark
        ? const Color(0xFF0D1B2A)
        : const Color(0xFFE3F2FD);
    const cardBlueAccent = Color(0xFF1565C0);

    final Color cardIndigo = isDark
        ? const Color(0xFF1A1533)
        : const Color(0xFFEDE7F6);
    const cardIndigoAccent = Color(0xFF4527A0);

    final Color cardTeal = isDark
        ? const Color(0xFF00363A)
        : const Color(0xFFE0F2F1);
    const cardTealAccent = Color(0xFF00695C);

    final lawStyle = TextStyle(
      color: Colors.red.shade700,
      fontWeight: FontWeight.w700,
    );

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
          'Réquisitions',
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
            '3.8 — Les réquisitions',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Réquisitions sur commission rogatoire : réquisitions d’ordre général, '
            'réquisitions informatiques et téléphoniques, géolocalisation en temps réel '
            'et interceptions de correspondances par la voie des communications '
            'électroniques.',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w500,
              fontSize: 13.5,
              height: 1.35,
              color: textSoft,
            ),
          ),
          const SizedBox(height: 10),

          const _IntroBullet(
            text:
                'Sur commission rogatoire, les réquisitions se font toujours sous le contrôle '
                'du juge d’instruction et dans le respect des règles de fond et de forme '
                'propres à l’information judiciaire.',
          ),
          const _IntroBullet(
            text:
                'Dès qu’une question d’ordre technique se pose, le juge d’instruction peut '
                'ordonner une expertise et non de simples réquisitions techniques.',
          ),
          const SizedBox(height: 20),

          // ================================================================
          // 3.8 — PRINCIPE GÉNÉRAL + 3.8.1 / 3.8.2
          // ================================================================
          _ConditionCard(
            title:
                '3.8 — Principe général et réquisitions d’ordre général / informatiques',
            cardColor: cardBlue,
            accent: cardBlueAccent,
            titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Sur commission rogatoire, les officiers de police judiciaire, les agents '
                      'de police judiciaire et les assistants d’enquête ne peuvent pas adresser '
                      'de réquisitions aux fins de constatations ou d’examens techniques ou '
                      'scientifiques telles qu’elles sont prévues en flagrant délit ou en '
                      'enquête préliminaire par les ',
                ),
                TextSpan(
                  text: 'articles 60 et 77-1 du Code de procédure pénale',
                  style: lawStyle,
                ),
                const TextSpan(
                  text:
                      '. Lorsque se pose une question d’ordre technique, le juge '
                      'd’instruction ordonne une expertise, conformément à ',
                ),
                TextSpan(
                  text: 'l’article 156 du Code de procédure pénale',
                  style: lawStyle,
                ),
                const TextSpan(text: '.'),
              ]),
              const SizedBox(height: 14),

              const _SubTitle('3.8.1 — Les réquisitions d’ordre général'),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Sur commission rogatoire générale ou spéciale, l’officier de police '
                      'judiciaire peut, par tout moyen, requérir de toute personne, de tout '
                      'établissement ou organisme privé ou public ou de toute administration '
                      'publique qui sont susceptibles de détenir des documents intéressant '
                      'l’instruction, y compris, sous réserve des limites imposées par ',
                ),
                TextSpan(
                  text: 'l’article 60-1-2 du Code de procédure pénale',
                  style: lawStyle,
                ),
                const TextSpan(
                  text:
                      ', ceux issus d’un système informatique ou d’un traitement de données '
                      'nominatives, afin qu’il lui soit remis ces documents, notamment sous '
                      'forme numérique, sans qu’il puisse lui être opposé, sans motif légitime, '
                      'le secret professionnel.',
                ),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                const TextSpan(
                  text: 'Ces réquisitions d’ordre général sont prévues par ',
                ),
                TextSpan(
                  text: 'l’article 99-3 du Code de procédure pénale',
                  style: lawStyle,
                ),
                const TextSpan(
                  text:
                      '. Pour ces réquisitions « générales », l’officier de police judiciaire '
                      'commis par le juge d’instruction dispose des mêmes prérogatives que '
                      'celles définies par ',
                ),
                TextSpan(
                  text: 'l’article 60-1 du Code de procédure pénale',
                  style: lawStyle,
                ),
                const TextSpan(text: ' en matière de flagrant délit.'),
              ]),
              const SizedBox(height: 14),

              const _SubTitle(
                '3.8.2 — Les réquisitions informatiques et téléphoniques',
              ),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Sur commission rogatoire, l’officier de police judiciaire peut procéder '
                      'aux réquisitions prévues par le premier alinéa de ',
                ),
                TextSpan(
                  text: 'l’article 60-2 du Code de procédure pénale',
                  style: lawStyle,
                ),
                const TextSpan(
                  text:
                      ' : les organismes publics ou les personnes morales de droit privé, à '
                      'l’exception de certains organismes spécialement protégés par le droit '
                      'européen et la loi Informatique et libertés, doivent mettre à la '
                      'disposition de l’enquête les informations utiles à la manifestation de '
                      'la vérité, à l’exception de celles protégées par un secret prévu par la '
                      'loi, sous réserve des limites fixées par ',
                ),
                TextSpan(
                  text: 'l’article 60-1-2 du Code de procédure pénale',
                  style: lawStyle,
                ),
                const TextSpan(
                  text:
                      ', contenues dans les systèmes informatiques ou traitements de données '
                      'nominatives qu’ils administrent.',
                ),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Avec l’autorisation expresse du juge d’instruction, l’officier de police '
                      'judiciaire ou, sous son contrôle, l’agent de police judiciaire peut aussi '
                      'mettre en œuvre les réquisitions prévues par le deuxième alinéa de ',
                ),
                TextSpan(
                  text: 'l’article 60-2 du Code de procédure pénale',
                  style: lawStyle,
                ),
                const TextSpan(
                  text:
                      ', en requérant les opérateurs de télécommunications, notamment ceux '
                      'mentionnés par la loi du 21 juin 2004 pour la confiance dans '
                      'l’économie numérique, afin de prendre toutes mesures propres à assurer, '
                      'sans délai, la préservation pour une durée maximale d’un an du contenu '
                      'des informations consultées par les utilisateurs.',
                ),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Avec la même autorisation expresse du juge d’instruction, l’officier de '
                      'police judiciaire ou, sous son contrôle, l’agent de police judiciaire '
                      'ou l’assistant d’enquête peut procéder aux réquisitions prévues par ',
                ),
                TextSpan(
                  text: 'l’article 60-3 du Code de procédure pénale',
                  style: lawStyle,
                ),
                const TextSpan(
                  text:
                      '. Il peut alors requérir toute personne qualifiée inscrite sur l’une '
                      'des listes d’experts prévues à ',
                ),
                TextSpan(
                  text: 'l’article 157 du Code de procédure pénale',
                  style: lawStyle,
                ),
                const TextSpan(text: ' ou ayant prêté serment conformément à '),
                TextSpan(
                  text: 'l’article 60 du Code de procédure pénale',
                  style: lawStyle,
                ),
                const TextSpan(
                  text:
                      ' pour ouvrir des scellés supportant des données informatiques, en '
                      'réaliser des copies ou effectuer les opérations techniques nécessaires '
                      'pour les mettre à disposition de l’enquête sans en altérer l’intégrité.',
                ),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Ces opérations peuvent également être réalisées par les services ou '
                      'organismes de police technique et scientifique de la police nationale '
                      'ou de la gendarmerie nationale, sans qu’il soit nécessaire d’établir '
                      'une réquisition ni qu’ils prêtent serment. Les opérations réalisées '
                      'font l’objet d’un rapport établi conformément aux ',
                ),
                TextSpan(
                  text: 'articles 163 et 166 du Code de procédure pénale',
                  style: lawStyle,
                ),
                const TextSpan(text: '.'),
              ]),
            ],
          ),
          const SizedBox(height: 22),

          // ================================================================
          // 3.8.3 — GÉOLOCALISATION
          // ================================================================
          _ConditionCard(
            title: '3.8.3 — La géolocalisation en temps réel',
            cardColor: cardIndigo,
            accent: cardIndigoAccent,
            titleColor: isDark ? Colors.white : const Color(0xFF311B92),
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Des réquisitions peuvent viser à suivre en temps réel, et à l’insu de '
                      'la personne, les déplacements d’une personne, d’un véhicule ou d’un '
                      'objet (suivi d’un terminal de télécommunication ou utilisation d’une '
                      'balise de géolocalisation). Ces techniques sont encadrées par les ',
                ),
                TextSpan(
                  text: 'articles 230-32 à 230-44 du Code de procédure pénale',
                  style: lawStyle,
                ),
                const TextSpan(
                  text:
                      ', dans les mêmes conditions qu’en enquête de flagrance ou préliminaire '
                      'pour les crimes et délits punis d’au moins trois ans d’emprisonnement.',
                ),
              ]),
              const SizedBox(height: 6),
              const _Paragraph(
                'Le recours à cette technique n’est pas limité à la personne soupçonnée : '
                'il peut également viser l’entourage familial ou amical du suspect, '
                'lorsque les nécessités de l’enquête l’exigent.',
              ),
              const SizedBox(height: 6),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'La géolocalisation en temps réel peut aussi être utilisée dans le cadre '
                      'd’une information ouverte pour rechercher les causes de la mort ou de '
                      'la disparition, conformément à ',
                ),
                TextSpan(
                  text: 'l’article 80-4 du Code de procédure pénale',
                  style: lawStyle,
                ),
                const TextSpan(text: '.'),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Le juge d’instruction autorise les opérations pour une durée '
                      'maximale de quatre mois, renouvelable. La durée totale ne peut dépasser '
                      'un an pour les infractions de droit commun et deux ans pour les '
                      'infractions relevant de la criminalité ou de la délinquance organisée '
                      'mentionnées aux ',
                ),
                TextSpan(
                  text:
                      'articles 706-73 et 706-73-1 du Code de procédure pénale',
                  style: lawStyle,
                ),
                const TextSpan(text: '.'),
              ]),
              const SizedBox(height: 10),

              const _SubTitle(
                'Introduction dans des lieux privés ou des véhicules',
              ),
              const _Paragraph(
                'Pour mettre en place ou retirer le moyen technique de géolocalisation, le '
                'juge d’instruction peut autoriser l’introduction dans des lieux privés ou '
                'dans des véhicules, y compris en dehors des heures légales, dans des '
                'conditions strictement encadrées.',
              ),
              const SizedBox(height: 6),
              const _BulletPoint(
                text:
                    'Lieux d’entrepôt de véhicules, fonds, valeurs, marchandises ou matériel : '
                    'autorisation du juge d’instruction (crimes, délits punis d’au moins '
                    'trois ans, enquête décès ou disparition).',
              ),
              const _BulletPoint(
                text:
                    'Véhicules situés sur la voie publique ou dans de tels lieux : même '
                    'magistrat compétent et mêmes conditions d’application.',
              ),
              const _BulletPoint(
                text:
                    'Autres lieux privés (banque, administration, entreprise, etc.) : '
                    'autorisation du juge d’instruction pour les crimes, les délits punis '
                    'd’au moins cinq ans, les enquêtes décès et les disparitions.',
              ),
              const _BulletPoint(
                text:
                    'Lieux d’habitation : autorisation du juge d’instruction entre 6h00 et '
                    '21h00, et du juge des libertés et de la détention entre 21h00 et 6h00.',
              ),
              const _BulletPoint(
                text:
                    'Lieux protégés (cabinet ou domicile d’un avocat, locaux ou véhicules de '
                    'presse, cabinet d’un médecin, notaire ou commissaire de justice, lieux '
                    'couverts par le secret de la défense, cabinet ou domicile d’un '
                    'magistrat, bureau ou domicile d’un député, d’un sénateur ou d’un '
                    'parlementaire européen) : introduction strictement encadrée et '
                    'réservée au juge d’instruction ou au juge des libertés et de la '
                    'détention selon les cas.',
              ),
              const SizedBox(height: 10),

              const _SubTitle(
                'Activation à distance d’un appareil électronique',
              ),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Lorsque l’enquête porte sur un crime ou un délit puni d’au moins cinq '
                      'ans d’emprisonnement, le juge d’instruction peut autoriser, à l’insu '
                      'ou sans le consentement du propriétaire ou du possesseur, l’activation '
                      'à distance d’un appareil électronique (téléphone portable, tablette, '
                      'ordinateur, système GPS autonome ou intégré, montre connectée, etc.) '
                      'afin de procéder à sa géolocalisation en temps réel, dans les '
                      'conditions prévues par ',
                ),
                TextSpan(
                  text: 'l’article 230-34-1 du Code de procédure pénale',
                  style: lawStyle,
                ),
                const TextSpan(text: '.'),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Cette activation ne peut pas concerner un appareil utilisé par un '
                      'médecin, un notaire, un commissaire de justice, un député, un '
                      'sénateur, un avocat, un magistrat ou un journaliste. Les députés, '
                      'sénateurs et parlementaires européens élus en France sont protégés par ',
                ),
                TextSpan(
                  text:
                      'l’article 230-34-1 et l’article 803-10 du Code de procédure pénale',
                  style: lawStyle,
                ),
                const TextSpan(text: '.'),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Le juge d’instruction peut désigner une personne physique ou morale '
                      'habilitée inscrite sur les listes prévues à ',
                ),
                TextSpan(
                  text: 'l’article 157 du Code de procédure pénale',
                  style: lawStyle,
                ),
                const TextSpan(
                  text:
                      ', ou prescrire le recours aux moyens de l’État soumis au secret de la '
                      'défense nationale, conformément à ',
                ),
                TextSpan(
                  text: 'l’article 230-36 du Code de procédure pénale',
                  style: lawStyle,
                ),
                const TextSpan(text: '.'),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Ces dispositions ne s’appliquent pas lorsque la géolocalisation porte '
                      'sur un équipement, un véhicule ou un objet appartenant à la victime et '
                      'que les opérations ont pour objet de retrouver la victime ou le bien '
                      'dérobé : dans ce cas, la géolocalisation en temps réel relève des '
                      'réquisitions prévues par ',
                ),
                TextSpan(
                  text: 'les articles 99-3 ou 99-4 du Code de procédure pénale',
                  style: lawStyle,
                ),
                const TextSpan(text: '.'),
              ]),
            ],
          ),
          const SizedBox(height: 22),

          // ================================================================
          // 3.8.4 — INTERCEPTIONS
          // ================================================================
          _ConditionCard(
            title:
                '3.8.4 — Interceptions de correspondances par voie de communications électroniques',
            cardColor: cardTeal,
            accent: cardTealAccent,
            titleColor: isDark ? Colors.white : const Color(0xFF004D40),
            children: [
              const _SubTitle('3.8.4.1 — Le magistrat compétent'),
              _Paragraph.rich([
                const TextSpan(text: 'Aux termes de '),
                TextSpan(
                  text: 'l’article 100 du Code de procédure pénale',
                  style: lawStyle,
                ),
                const TextSpan(
                  text:
                      ', le juge d’instruction peut, lorsque les nécessités de '
                      'l’information l’exigent, prescrire l’interception, l’enregistrement et '
                      'la transcription de correspondances émises par la voie des '
                      'communications électroniques.',
                ),
              ]),
              const SizedBox(height: 10),

              const _SubTitle('3.8.4.2 — Nature des infractions'),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'L’interception n’est possible qu’en matière criminelle ou en matière '
                      'correctionnelle lorsque la peine encourue est au moins égale à trois '
                      'ans d’emprisonnement, conformément à ',
                ),
                TextSpan(
                  text: 'l’article 100 du Code de procédure pénale',
                  style: lawStyle,
                ),
                const TextSpan(text: '.'),
              ]),
              const SizedBox(height: 6),
              const _Paragraph(
                'Ce seuil de trois ans n’est pas exigé lorsqu’il s’agit d’un délit puni '
                'd’emprisonnement commis par la voie des communications électroniques sur '
                'la ligne de la victime, et que l’interception intervient sur cette ligne à '
                'la demande de la victime (par exemple en cas d’appels téléphoniques '
                'malveillants).',
              ),
              const SizedBox(height: 10),

              const _SubTitle(
                '3.8.4.3 — Personnes susceptibles d’être écoutées',
              ),
              const _Paragraph(
                'L’interception peut viser les personnes mises en examen, celles paraissant '
                'avoir participé aux faits ou toute personne susceptible de détenir des '
                'renseignements utiles à la manifestation de la vérité.',
              ),
              const SizedBox(height: 6),
              _Paragraph.rich([
                const TextSpan(text: 'Le dernier alinéa de '),
                TextSpan(
                  text: 'l’article 100 du Code de procédure pénale',
                  style: lawStyle,
                ),
                const TextSpan(
                  text:
                      ' renforce les garanties lorsque la ligne interceptée dépend du '
                      'cabinet ou du domicile d’un avocat. Aucune interception ne peut porter '
                      'sur une telle ligne, sauf s’il existe des raisons plausibles de '
                      'soupçonner l’avocat d’avoir commis ou tenté de commettre, comme auteur '
                      'ou complice, l’infraction objet de la procédure ou une infraction '
                      'connexe, et si la mesure est proportionnée à la gravité des faits.',
                ),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Dans ce cas, la décision est prise par le juge des libertés et de la '
                      'détention, saisi par ordonnance motivée du juge d’instruction, après '
                      'avis du procureur de la République, conformément à ',
                ),
                TextSpan(
                  text: 'l’article 100-5 du Code de procédure pénale',
                  style: lawStyle,
                ),
                const TextSpan(text: '.'),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Le même article prévoit que ne peuvent être transcrites, à peine de '
                      'nullité, les correspondances avec un avocat dans l’exercice des droits '
                      'de la défense, protégées par la loi du 31 décembre 1971, ni les '
                      'correspondances avec un journaliste permettant d’identifier une '
                      'source, en application de la loi du 29 juillet 1881 sur la liberté de '
                      'la presse, sauf exception prévue à ',
                ),
                TextSpan(
                  text: 'l’article 56-1-2 du Code de procédure pénale',
                  style: lawStyle,
                ),
                const TextSpan(text: '.'),
              ]),
              const SizedBox(height: 10),

              const _SubTitle('3.8.4.4 — Conditions de forme'),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'La décision d’interception doit être écrite, motivée en fait et en droit '
                      'et n’est susceptible d’aucun recours. Elle doit comporter tous les '
                      'éléments d’identification de la liaison à intercepter, l’infraction '
                      'justifiant l’interception ainsi que la durée de la mesure, conformément '
                      'à ',
                ),
                TextSpan(
                  text: 'l’article 100-1 du Code de procédure pénale',
                  style: lawStyle,
                ),
                const TextSpan(text: '.'),
              ]),
              const SizedBox(height: 6),
              const _Paragraph(
                'La décision est prise pour une durée maximale de quatre mois, renouvelable '
                'dans les mêmes conditions de forme et de durée, sans que la durée totale '
                'ne puisse excéder un an (sauf dispositions spécifiques pour la criminalité '
                'organisée). Aucune disposition n’impose que la commission rogatoire figure '
                'au dossier pendant toute la durée de l’exécution.',
              ),
              const SizedBox(height: 6),
              const _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        'La décision peut revêtir la forme d’une ordonnance ou celle d’une '
                        'commission rogatoire, selon que le juge exerce directement ou non '
                        'le pouvoir que la loi lui confère.',
                  ),
                ],
              ),
              const SizedBox(height: 10),

              const _SubTitle(
                '3.8.4.5 — Mise en œuvre de l’interception judiciaire',
              ),
              _Paragraph.rich([
                const TextSpan(text: 'Selon '),
                TextSpan(
                  text: 'l’article 100-3 du Code de procédure pénale',
                  style: lawStyle,
                ),
                const TextSpan(
                  text:
                      ', le juge d’instruction ou l’officier de police judiciaire commis par '
                      'lui peut requérir, sous son contrôle, un agent qualifié d’un service ou '
                      'organisme placé sous l’autorité du ministre chargé des communications '
                      'électroniques ou d’un exploitant de réseau ou fournisseur de services '
                      'de communications électroniques autorisé, afin d’installer le '
                      'dispositif d’interception.',
                ),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Les agents requis sont astreints au secret de l’instruction (',
                ),
                TextSpan(
                  text: 'article 11 du Code de procédure pénale',
                  style: lawStyle,
                ),
                const TextSpan(
                  text:
                      ') et au secret des correspondances (code des postes et des '
                      'communications électroniques). Ils ne peuvent ni révéler l’existence '
                      'des interceptions, ni prendre connaissance du contenu intercepté, ni '
                      'le divulguer.',
                ),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Chaque opération d’interception et d’enregistrement fait l’objet d’un '
                      'procès-verbal mentionnant la date et l’heure de début et de fin de '
                      'l’opération. Les enregistrements sont placés sous scellés fermés, '
                      'conformément à ',
                ),
                TextSpan(
                  text: 'l’article 100-4 du Code de procédure pénale',
                  style: lawStyle,
                ),
                const TextSpan(text: '.'),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Seules les correspondances utiles à la manifestation de la vérité sont '
                      'transcrites par le juge d’instruction, l’officier de police judiciaire '
                      'commis ou l’agent de police judiciaire. À peine de nullité, ne peuvent '
                      'être transcrites les correspondances avec un avocat ou avec un '
                      'journaliste permettant d’identifier une source, conformément à ',
                ),
                TextSpan(
                  text: 'l’article 100-5 du Code de procédure pénale',
                  style: lawStyle,
                ),
                const TextSpan(text: '.'),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'À l’expiration du délai de prescription de l’action publique (six ans en '
                      'matière correctionnelle, vingt ans en matière criminelle), les '
                      'enregistrements sont détruits à la diligence du procureur de la '
                      'République ou du procureur général. Cette destruction donne lieu à un '
                      'procès-verbal conformément à ',
                ),
                TextSpan(
                  text: 'l’article 100-6 du Code de procédure pénale',
                  style: lawStyle,
                ),
                const TextSpan(text: '.'),
              ]),
              const SizedBox(height: 8),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        'La violation du secret des correspondances émises par voie de '
                        'télécommunications est réprimée par ',
                  ),
                  TextSpan(
                    text: 'l’article 226-15 alinéa 2 du Code pénal',
                    style: lawStyle,
                  ),
                  const TextSpan(
                    text:
                        '. La fabrication, l’importation, la détention, l’exposition, '
                        'l’offre, la location ou la vente, sans autorisation ministérielle, '
                        'd’appareils destinés à intercepter de telles correspondances sont '
                        'sanctionnées par ',
                  ),
                  TextSpan(
                    text: 'l’article 226-3 alinéa 1 du Code pénal',
                    style: lawStyle,
                  ),
                  const TextSpan(
                    text:
                        '. La publicité en faveur de ces appareils peut également être '
                        'réprimée par ',
                  ),
                  TextSpan(
                    text: 'l’article 226-3 alinéa 2 du Code pénal',
                    style: lawStyle,
                  ),
                  const TextSpan(text: '.'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 26),
        ],
      ),
    );
  }
}

///////////////////////////////////////////////////////////////////////////////
///                   TES WIDGETS PERSONNALISÉS EXACTS                     ///
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
        text ?? '',
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
