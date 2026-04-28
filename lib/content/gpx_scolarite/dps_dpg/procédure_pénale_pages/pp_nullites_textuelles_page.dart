import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PPNullitesTextuellesPage extends StatelessWidget {
  const PPNullitesTextuellesPage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/procédure_pénale_pages/pp_nullites_textuelles';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);
    final Color textSoft = isDark
        ? Colors.white70
        : const Color(0xFF222222).withOpacity(.70);

    final Color cardLight = isDark
        ? const Color(0xFF424242)
        : const Color(0xFFF5F7FB);
    final Color cardAccent = isDark
        ? const Color(0xFF90CAF9)
        : const Color(0xFF1565C0);

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
          'Les nullités textuelles',
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: textMain,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
        children: [
          // ====================== TITRE PRINCIPAL ===========================
          Text(
            'Les nullités textuelles en procédure pénale',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 6),

          const _Paragraph(
            'Afin de garantir les libertés individuelles et le libre exercice des droits de la défense, '
            'tout en assurant l’efficacité des poursuites et de la répression, il est essentiel '
            'd’exercer un contrôle de légalité sur l’ensemble des actes de procédure.',
          ),
          const SizedBox(height: 6),
          const _Paragraph(
            'Si l’on ne peut pas faire disparaître la réalité matérielle d’une arrestation ou d’une '
            'détention illégale, il est en revanche possible d’annuler l’acte procédural qui a '
            'enregistré cet acte irrégulier ainsi que les actes de procédure qui en découlent.',
          ),
          const SizedBox(height: 6),
          const _Paragraph(
            'L’annulation fait disparaître les effets juridiques et les preuves engendrées par cette '
            'arrestation ou cette détention irrégulière.',
          ),

          const SizedBox(height: 18),

          // ====================== CHAPITRE 1 ================================
          const _SubTitle('CHAPITRE 1 : LES CAS DE NULLITÉ'),
          const SizedBox(height: 4),

          _Paragraph.rich([
            const TextSpan(
              text:
                  'On distingue deux grandes catégories de nullités en procédure pénale : les nullités textuelles et les nullités substantielles. ',
            ),
            const TextSpan(
              text:
                  'Les nullités textuelles existent lorsque la loi prévoit expressément la nullité d’un acte accompli de façon irrégulière ',
            ),
            const TextSpan(
              text:
                  '(par exemple une perquisition non conforme aux conditions prévues). ',
            ),
            TextSpan(
              text: 'Les nullités substantielles',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.red.shade700,
              ),
            ),
            const TextSpan(
              text:
                  ' s’appliquent lorsque, même en l’absence de texte prévoyant la nullité, le non-respect d’une règle touche une garantie essentielle, '
                  'rendant inacceptable la méconnaissance de cette formalité.',
            ),
          ]),
          const SizedBox(height: 8),
          _Paragraph.rich([
            const TextSpan(text: 'Aux termes de l’'),
            TextSpan(
              text: 'Article 802 du Code de Procédure Pénale',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: Colors.red.shade700,
              ),
            ),
            const TextSpan(
              text:
                  ', qu’elles soient textuelles ou substantielles, les nullités ne peuvent être prononcées que si l’irrégularité constatée a eu pour effet '
                  'de porter atteinte aux intérêts de la partie qui l’invoque.',
            ),
          ]),

          const SizedBox(height: 18),

          // ====================== 1.1 — NULLITÉS TEXTUELLES =================
          const _SubTitle('1.1 – Les nullités textuelles'),
          const _Paragraph(
            'Le système des nullités textuelles suppose que la loi prévoit une formalité en indiquant '
            'qu’elle est requise à peine de nullité. Dans cette hypothèse, le juge n’a aucune marge '
            'd’appréciation : si la formalité n’est pas respectée, l’acte est nul dès lors que l’atteinte '
            'aux intérêts de la partie est caractérisée.',
          ),
          const SizedBox(height: 6),
          const _Paragraph(
            'Ces nullités textuelles sont peu nombreuses et ne sont pas regroupées dans une seule disposition : '
            'elles sont disséminées au fil des articles du Code de Procédure Pénale, à la suite de chaque '
            'règle jugée particulièrement protectrice (perquisitions, réquisitions, interceptions, infiltrations, etc.).',
          ),

          const SizedBox(height: 18),

          // ====================== CARD PERQUISITIONS ========================
          _ConditionCard(
            title: '1.1.1 – En matière de perquisitions et de saisies',
            cardColor: cardLight,
            accent: cardAccent,
            titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
            children: [
              _Paragraph.rich([
                const TextSpan(text: 'L’'),
                TextSpan(
                  text: 'Article 59 du Code de Procédure Pénale',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.red.shade700,
                  ),
                ),
                const TextSpan(
                  text:
                      ' énonce que les formalités prévues par les articles relatifs aux perquisitions et saisies sont prescrites ',
                ),
                const TextSpan(
                  text: 'à peine de nullité',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const TextSpan(
                  text: '. Il s’agit notamment des formalités suivantes :',
                ),
              ]),
              const SizedBox(height: 10),
              const _IntroBullet(
                text:
                    'Présence de la personne au domicile de laquelle la perquisition se déroule ou, en cas d’impossibilité, '
                    'd’un représentant de son choix ou, à défaut, de deux témoins.',
              ),
              const _IntroBullet(
                text:
                    'Mise en œuvre de toutes mesures visant à assurer le respect du secret professionnel et des droits de la défense.',
              ),
              const SizedBox(height: 10),

              const _SubTitle('Perquisitions dans certains lieux protégés'),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Dans les lieux bénéficiant d’une protection renforcée, le Code de Procédure Pénale impose des formalités particulières, également requises ',
                ),
                const TextSpan(
                  text: 'à peine de nullité',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const TextSpan(text: ' :'),
              ]),
              const SizedBox(height: 6),

              // Mini "tableau" visuel
              _buildSimpleTable(
                context,
                header1: 'Lieu concerné',
                header2: 'Formalités imposées',
                rows: [
                  [
                    'Cabinet ou domicile d’un avocat',
                    'Perquisition par un magistrat, en présence du bâtonnier ou de son délégué, '
                        'sur décision écrite et motivée du juge des libertés et de la détention indiquant '
                        'la nature de l’infraction, l’objet de la perquisition et sa proportionnalité '
                        '(référence aux règles de l’',
                    'Article 56-1 du Code de Procédure Pénale',
                  ],
                  [
                    'Locaux d’une entreprise de presse ou de communication, '
                        'ou domicile d’un journaliste lié à son activité professionnelle',
                    'Perquisition obligatoirement effectuée par un magistrat '
                        '(règles fixées par l’',
                    'Article 56-2 du Code de Procédure Pénale',
                  ],
                  [
                    'Cabinet de médecin, notaire, huissier',
                    'Perquisition par un magistrat, en présence du responsable de l’ordre ou de '
                        'l’organisation professionnelle ou de son représentant '
                        '(application de l’',
                    'Article 56-3 du Code de Procédure Pénale',
                  ],
                  [
                    'Lieux abritant des éléments couverts par le secret de la défense nationale',
                    'Perquisition par un magistrat, en présence du président de la Commission du secret '
                        'de la défense nationale (règles de l’',
                    'Article 56-4 du Code de Procédure Pénale',
                  ],
                  [
                    'Locaux d’une juridiction ou domicile d’une personne exerçant des fonctions juridictionnelles',
                    'Perquisition effectuée par un magistrat, en présence du premier président de la cour d’appel '
                        'ou de la Cour de cassation, ou de son délégué '
                        '(conformément à l’',
                    'Article 56-5 du Code de Procédure Pénale',
                  ],
                ],
              ),
              const SizedBox(height: 10),

              const _Paragraph(
                'Doivent aussi être respectées, à peine de nullité, les heures légales de perquisition (6 h – 21 h), '
                'sauf exceptions prévues par la loi (réclamation faite de l’intérieur, maison de jeu de hasard, '
                'lieu de débauche, incendie, inondation, etc.).',
              ),
              const SizedBox(height: 8),

              _Paragraph.rich([
                const TextSpan(
                  text:
                      'En enquête préliminaire, les perquisitions peuvent désormais intervenir sans l’assentiment de la personne, '
                      'lorsqu’il s’agit d’un crime ou d’un délit puni d’au moins trois ans d’emprisonnement, ou lorsque la recherche '
                      'de biens dont la confiscation est prévue à l’',
                ),
                TextSpan(
                  text: 'Article 131-21 du Code pénal',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.red.shade700,
                  ),
                ),
                const TextSpan(
                  text:
                      ' le justifie. À peine de nullité, l’autorisation préalable du juge des libertés et de la détention doit être écrite, '
                      'motivée, préciser la qualification de l’infraction et l’adresse des lieux (conditions de l’',
                ),
                TextSpan(
                  text: 'Article 76 du Code de Procédure Pénale',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.red.shade700,
                  ),
                ),
                const TextSpan(text: ').'),
              ]),
              const SizedBox(height: 8),

              _Paragraph.rich([
                const TextSpan(
                  text:
                      'En matière de criminalité organisée, de trafic de stupéfiants ou de proxénétisme, des perquisitions et saisies peuvent être réalisées en dehors des heures légales, '
                      'mais uniquement dans le strict respect des articles spécifiques du Code de Procédure Pénale (',
                ),
                TextSpan(
                  text:
                      'Articles 706-92, 706-93, 706-28 et 706-35 du Code de Procédure Pénale',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.red.shade700,
                  ),
                ),
                const TextSpan(text: '), également prévus à peine de nullité.'),
              ]),
              const SizedBox(height: 10),

              _Paragraph.rich([
                const TextSpan(text: 'La loi du 23 mars 2019 a introduit l’'),
                TextSpan(
                  text: 'Article 802-2 du Code de Procédure Pénale',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.red.shade700,
                  ),
                ),
                const TextSpan(
                  text:
                      ', permettant à toute personne ayant fait l’objet d’une perquisition ou d’une visite domiciliaire, '
                      'sans avoir été poursuivie devant une juridiction d’instruction ou de jugement dans un délai de six mois, '
                      'de saisir, dans l’année qui suit, le juge des libertés et de la détention pour en demander l’annulation.',
                ),
              ]),
            ],
          ),

          const SizedBox(height: 18),

          // ====================== 1.1.2 — RÉQUISITIONS ======================
          _ConditionCard(
            title: '1.1.2 – En matière de réquisitions',
            cardColor: cardLight,
            accent: cardAccent,
            titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Les réquisitions adressées à des établissements ou organismes, notamment pour obtenir des données, '
                      'sont strictement encadrées par les ',
                ),
                TextSpan(
                  text: 'Articles 60-1 et 77-1-1 du Code de Procédure Pénale',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.red.shade700,
                  ),
                ),
                const TextSpan(
                  text:
                      '. À peine de nullité, les éléments obtenus par réquisition en violation des règles protégeant le secret des sources des journalistes, '
                      'issues de l’',
                ),
                TextSpan(
                  text:
                      'Article 2 de la loi du 29 juillet 1881 sur la liberté de la presse',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.red.shade700,
                  ),
                ),
                const TextSpan(
                  text: ', ne peuvent pas être versés au dossier de procédure.',
                ),
              ]),
            ],
          ),

          const SizedBox(height: 18),

          // ========== 1.1.3 — INTERCEPTION DE CORRESPONDANCES ==============
          _ConditionCard(
            title:
                '1.1.3 – En matière d’interception de correspondances électroniques',
            cardColor: cardLight,
            accent: cardAccent,
            titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Lorsque des correspondances sont interceptées par la voie des communications électroniques, le juge d’instruction '
                      'ou, en matière de criminalité organisée, le juge des libertés et de la détention, doit, avant toute interception, informer : ',
                ),
              ]),
              const _IntroBullet(
                text:
                    'Le président de l’Assemblée nationale ou du Sénat lorsque l’interception vise un député ou un sénateur.',
              ),
              const _IntroBullet(
                text:
                    'Le bâtonnier lorsqu’il s’agit d’une ligne dépendant du cabinet ou du domicile d’un avocat.',
              ),
              const _IntroBullet(
                text:
                    'Le premier président ou le procureur général lorsque l’interception concerne le cabinet ou le domicile d’un magistrat.',
              ),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'À peine de nullité, les correspondances avec un avocat, relevant de l’exercice des droits de la défense et couvertes par le secret professionnel, '
                      'ne peuvent être transcrites, sauf les exceptions prévues par l’',
                ),
                TextSpan(
                  text: 'Article 56-1-2 du Code de Procédure Pénale',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.red.shade700,
                  ),
                ),
                const TextSpan(text: '.'),
              ]),
              const SizedBox(height: 4),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'De même, les correspondances avec un journaliste permettant d’identifier une source en violation de l’',
                ),
                TextSpan(
                  text:
                      'Article 2 de la loi du 29 juillet 1881 sur la liberté de la presse',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.red.shade700,
                  ),
                ),
                const TextSpan(
                  text: ' ne peuvent être transcrites, à peine de nullité.',
                ),
              ]),
            ],
          ),

          const SizedBox(height: 18),

          // ====================== 1.1.4 – INFILTRATION ======================
          _ConditionCard(
            title: '1.1.4 – En matière d’infiltration',
            cardColor: cardLight,
            accent: cardAccent,
            titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Les opérations d’infiltration, prévues dans le cadre de la lutte contre la criminalité organisée, sont strictement encadrées. '
                      'À peine de nullité, les actes accomplis par l’agent infiltré ne doivent pas constituer ',
                ),
                const TextSpan(
                  text: 'une incitation à commettre une infraction',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const TextSpan(
                  text:
                      '. Ne sont pas considérés comme une incitation les actes qui se bornent à accompagner une infraction déjà préparée ou débutée, '
                      'y compris en cas de réitération ou d’aggravation (règles précisées par l’',
                ),
                TextSpan(
                  text: 'Article 706-81 du Code de Procédure Pénale',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.red.shade700,
                  ),
                ),
                const TextSpan(text: ').'),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'À peine de nullité, l’autorisation d’infiltration délivrée par le procureur de la République ou le juge d’instruction doit être ',
                ),
                const TextSpan(
                  text: 'écrite et spécialement motivée',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const TextSpan(
                  text:
                      ', mentionner les infractions visées, l’identité de l’officier de police judiciaire coordonnateur ainsi que la durée de l’opération, '
                      'conformément à l’',
                ),
                TextSpan(
                  text: 'Article 706-83 du Code de Procédure Pénale',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.red.shade700,
                  ),
                ),
                const TextSpan(text: '.'),
              ]),
            ],
          ),

          const SizedBox(height: 18),

          // ================== 1.1.5 – VÉRIFICATION D’IDENTITÉ =================
          _ConditionCard(
            title: '1.1.5 – En matière de vérification d’identité',
            cardColor: cardLight,
            accent: cardAccent,
            titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'La vérification d’identité qui fait suite à un contrôle d’identité est encadrée par l’',
                ),
                TextSpan(
                  text: 'Article 78-3 du Code de Procédure Pénale',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.red.shade700,
                  ),
                ),
                const TextSpan(
                  text:
                      '. À peine de nullité, plusieurs prescriptions doivent être respectées :',
                ),
              ]),
              const SizedBox(height: 8),
              const _IntroBullet(
                text:
                    'Information de la personne sur son droit de faire aviser le procureur de la République et de prévenir à tout moment sa famille ou une personne de son choix.',
              ),
              const _IntroBullet(
                text:
                    'Pour les mineurs, avis immédiat au procureur et assistance du représentant légal.',
              ),
              const _IntroBullet(
                text:
                    'Durée maximale de la rétention : quatre heures (huit heures à Mayotte et en Guyane).',
              ),
              const _IntroBullet(
                text:
                    'Établissement d’un procès-verbal retraçant l’ensemble des opérations et diligences.',
              ),
              const _IntroBullet(
                text:
                    'Absence de mise en mémoire sur des fichiers et destruction, dans les six mois, des pièces collectées si aucune enquête n’est engagée.',
              ),
              const _IntroBullet(
                text:
                    'En cas de placement en garde à vue à l’issue de la vérification, information immédiate de la personne sur son droit de faire aviser le procureur de la République.',
              ),
            ],
          ),

          const SizedBox(height: 18),

          // ============= 1.1.6 – MOYENS D’INVESTIGATION EXORBITANTS =========
          _ConditionCard(
            title: '1.1.6 – En matière de moyens d’investigation exorbitants',
            cardColor: cardLight,
            accent: cardAccent,
            titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
            children: [
              const _Paragraph(
                'Certaines investigations particulièrement intrusives (trafic de stupéfiants, criminalité organisée, enquête sous pseudonyme, '
                'techniques spéciales d’enquête) sont soumises à des conditions très strictes, dont le non-respect est expressément sanctionné '
                'par la nullité.',
              ),
              const SizedBox(height: 10),

              const _SubTitle(
                '1.1.6.1 – Lutte contre le trafic de stupéfiants et le blanchiment',
              ),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Dans le cadre de la lutte contre le trafic de stupéfiants et le blanchiment, l’',
                ),
                TextSpan(
                  text: 'Article 706-32 du Code de Procédure Pénale',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.red.shade700,
                  ),
                ),
                const TextSpan(
                  text:
                      ' permet aux officiers de police judiciaire, et sous leur autorité aux agents de police judiciaire, '
                      'avec l’autorisation du procureur de la République ou du juge d’instruction, d’acquérir des produits stupéfiants '
                      'et de mettre à disposition des moyens matériels, financiers ou juridiques.',
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'À peine de nullité, l’autorisation du magistrat, qui peut être donnée par tout moyen, doit être expressément mentionnée ou versée au dossier. '
                      'Les actes autorisés ne doivent jamais constituer une incitation déterminante à la commission de l’infraction : ne sont pas constitutifs '
                      'd’incitation les actes qui accompagnent la poursuite d’une infraction déjà préparée ou débutée, '
                      'y compris en cas de réitération ou d’aggravation de celle-ci.',
                ),
              ]),

              const SizedBox(height: 10),
              const _SubTitle('1.1.6.2 – Enquête sous pseudonyme'),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Aux seules fins de constater des crimes et délits punis d’emprisonnement commis au moyen de communications électroniques, '
                      'l’',
                ),
                TextSpan(
                  text: 'Article 230-46 du Code de Procédure Pénale',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.red.shade700,
                  ),
                ),
                const TextSpan(
                  text:
                      ' autorise certains officiers ou agents de police judiciaire spécialement habilités à intervenir sous pseudonyme, '
                      'y compris en altérant leur voix ou leur apparence.',
                ),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'À peine de nullité, les autorisations délivrées pour certaines opérations (notamment la mise à disposition de moyens ou l’acquisition de contenus illicites) '
                      'doivent être accordées par le procureur de la République ou le juge d’instruction, être mentionnées ou versées au dossier et ne pas constituer '
                      'une incitation déterminante à la commission de l’infraction, selon la même logique que pour les infiltrations.',
                ),
              ]),

              const SizedBox(height: 10),
              const _SubTitle(
                '1.1.6.3 – Autres techniques spéciales d’enquête',
              ),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Dans le cadre de la lutte contre la délinquance et la criminalité organisées, les ',
                ),
                TextSpan(
                  text:
                      'Articles 706-73 et 706-73-1 du Code de Procédure Pénale',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.red.shade700,
                  ),
                ),
                const TextSpan(
                  text:
                      ' prévoient des techniques spéciales d’enquête (interceptions, sonorisations, captations de données informatiques, etc.). ',
                ),
              ]),
              _Paragraph.rich([
                const TextSpan(text: 'L’'),
                TextSpan(
                  text: 'Article 706-95-14 du Code de Procédure Pénale',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.red.shade700,
                  ),
                ),
                const TextSpan(
                  text:
                      ' précise qu’à peine de nullité, les opérations ordonnées ne peuvent avoir d’autre objet que la recherche et la constatation des infractions visées '
                      'dans les décisions du magistrat. Le fait que ces opérations révèlent d’autres infractions ne constitue cependant pas, en soi, une cause de nullité '
                      'des procédures incidentes.',
                ),
              ]),
              const SizedBox(height: 4),

              const _Paragraph(
                'Les opérations concernées incluent notamment : le recueil des données techniques de connexion, les interceptions de '
                'correspondances électroniques, les sonorisations, les fixations d’images de certains lieux ou véhicules, ainsi que la captation '
                'de données informatiques.',
              ),
            ],
          ),

          const SizedBox(height: 26),
        ],
      ),
    );
  }
}

// ======================== PETIT TABLEAU VISUEL ==========================
Widget _buildSimpleTable(
  BuildContext context, {
  required String header1,
  required String header2,
  required List<List<String>> rows,
}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final Color headerBg = isDark
      ? const Color(0xFF1E3A5F)
      : const Color(0xFF0D47A1);
  final Color headerText = Colors.white;
  final Color rowBg = isDark
      ? const Color(0xFF303030)
      : const Color(0xFFEFF3FB);

  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(14),
      border: Border.all(
        color: isDark ? Colors.white12 : Colors.black12,
        width: 0.9,
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: headerBg,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  header1,
                  style: GoogleFonts.fustat(
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                    color: headerText,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                flex: 5,
                child: Text(
                  header2,
                  style: GoogleFonts.fustat(
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                    color: headerText,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Rows
        ...rows.map((row) {
          // row[0] = lieu ; row[1] = texte avant ; row[2] = libellé article (optionnel)
          final String lieu = row[0];
          final String beforeArticle = row[1];
          final String? article = row.length > 2
              ? row[2]
              : null; // nom complet à afficher en rouge

          return Container(
            color: rowBg,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    lieu,
                    style: GoogleFonts.fustat(
                      fontWeight: FontWeight.w700,
                      fontSize: 12.5,
                      height: 1.3,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  flex: 5,
                  child: RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                      style: GoogleFonts.fustat(
                        fontWeight: FontWeight.w500,
                        fontSize: 12.5,
                        height: 1.3,
                        color: isDark
                            ? Colors.white70
                            : const Color(0xFF1F1F1F).withOpacity(.92),
                      ),
                      children: [
                        TextSpan(text: beforeArticle),
                        if (article != null)
                          TextSpan(
                            text: article,
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: Colors.red.shade700,
                            ),
                          ),
                        if (article != null) const TextSpan(text: '.'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    ),
  );
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
