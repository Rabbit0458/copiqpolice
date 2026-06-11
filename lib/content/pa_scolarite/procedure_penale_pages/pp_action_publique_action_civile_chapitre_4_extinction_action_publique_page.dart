import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaPPActionPubliqueChapitre4ExtinctionActionPubliquePage
    extends StatelessWidget {
  const PaPPActionPubliqueChapitre4ExtinctionActionPubliquePage({super.key});

  static const String routeName =
      '/pa/dps_dpg/procedure_penale/pp_action_publique_action_civile/chapitre_4_extinction_action_publique';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);
    final Color textSoft = isDark
        ? Colors.white70
        : const Color(0xFF222222).withValues(alpha: .75);

    final Color cardBg = isDark
        ? const Color(0xFF2B3036)
        : const Color(0xFFF5F7FB);
    final Color accentBlue = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    final Color titleBlue = isDark ? Colors.white : const Color(0xFF0D47A1);

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
          'Chapitre 4 — Extinction de l’action publique',
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: textMain,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 26),
        children: [
          // =================== EN-TÊTE CHAPITRE ============================
          Text(
            'L’extinction de l’action publique',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Une fois l’action publique mise en mouvement, encore faut-il qu’elle ne soit pas '
            'frappée par une cause d’extinction. Certaines causes sont propres à des infractions '
            'particulières, d’autres sont générales et s’appliquent à l’ensemble du contentieux pénal.',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w500,
              fontSize: 13.5,
              height: 1.35,
              color: textSoft,
            ),
          ),
          const SizedBox(height: 18),

          // =================== 4.1 CAUSES PARTICULIERES ====================
          _ConditionCard(
            title: '4.1 — Les causes particulières à certaines infractions',
            cardColor: cardBg,
            accent: accentBlue,
            titleColor: titleBlue,
            children: const [
              _Paragraph(
                'Certaines infractions bénéficient de mécanismes spécifiques permettant '
                'd’éteindre l’action publique, indépendamment des causes générales : transaction, '
                'désistement ou retrait de plainte dans des hypothèses limitativement prévues.',
              ),
            ],
          ),

          const SizedBox(height: 18),

          // =================== 4.1.1 TRANSACTION ===========================
          _ConditionCard(
            title: '4.1.1 — La transaction',
            cardColor: cardBg,
            accent: accentBlue,
            titleColor: titleBlue,
            children: const [
              _Paragraph(
                'Dans des cas exceptionnels, l’action publique peut s’éteindre par voie de transaction. '
                'La loi accorde ce droit à certaines administrations qui proposent à l’auteur de l’infraction '
                'd’abandonner les poursuites en contrepartie du versement d’une somme d’argent ou de '
                'l’exécution d’obligations déterminées.',
              ),
              SizedBox(height: 6),

              _SubTitle('Transactions des administrations publiques'),
              _Paragraph(
                'Certaines administrations (fiscales, administration chargée des forêts, douanes, etc.) '
                'disposent d’un pouvoir de transaction. Lorsque le contrevenant accepte et exécute la transaction '
                'dans le délai imparti, l’action publique est éteinte.',
              ),
              SizedBox(height: 8),

              _SubTitle(
                'Transactions proposées par le maire en matière contraventionnelle',
              ),
              _Paragraph.rich([
                TextSpan(
                  text:
                      'Pour les contraventions que les agents de la police municipale et les gardes-champêtres sont habilités à constater, ',
                ),
                TextSpan(
                  text: 'l’article 44-1 du Code de Procédure Pénale',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      ' et les articles L. 511-1, L. 512-2, L. 521-1, L. 531-1 et L. 532-1 du Code de la sécurité intérieure ',
                ),
                TextSpan(
                  text:
                      'permettent au maire de proposer une transaction. Celle-ci doit être acceptée par le contrevenant puis homologuée, '
                      'soit par le procureur de la République, soit par le juge du tribunal de police. L’action publique est éteinte lorsque '
                      'l’auteur de l’infraction a exécuté les obligations résultant de la transaction.',
                ),
              ]),
              SizedBox(height: 8),

              _Paragraph.rich([
                TextSpan(
                  text:
                      'Il peut également y avoir transaction pour certaines infractions à la police des services publics de transports terrestres : ',
                ),
                TextSpan(
                  text: 'l’article 529-3 du Code de Procédure Pénale',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      ' prévoit une transaction entre l’exploitant et le contrevenant. Cette procédure n’est toutefois pas applicable si plusieurs infractions '
                      'dont au moins une ne peut donner lieu à transaction sont constatées simultanément.',
                ),
              ]),
              SizedBox(height: 8),

              _Paragraph.rich([
                TextSpan(
                  text:
                      'Selon le Code de la santé publique, une forme particulière de transaction existe encore : ',
                ),
                TextSpan(
                  text: 'l’article L. 3423-1 du Code de la santé publique',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      ' permet au procureur de la République d’inviter un toxicomane à se soumettre à une injonction thérapeutique ou à une surveillance médicale '
                      'plutôt que de le poursuivre pour usage de stupéfiants. Si l’intéressé se conforme à toutes les prescriptions, l’action publique n’est pas exercée.',
                ),
              ]),
              SizedBox(height: 10),

              _NotaBox(
                title: 'À retenir',
                bodySpans: [
                  TextSpan(
                    text:
                        'la transaction est une cause d’extinction de l’action publique lorsque la loi l’autorise expressément et que l’auteur exécute intégralement ses engagements. '
                        'Elle est souvent utilisée pour les infractions techniques ou économiques.',
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // =================== 4.1.2 RETRAIT PLAINTES =====================
          _ConditionCard(
            title: '4.1.2 — Le désistement ou retrait de plainte de la victime',
            cardColor: cardBg,
            accent: accentBlue,
            titleColor: titleBlue,
            children: const [
              _Paragraph.rich([
                TextSpan(
                  text:
                      'Cette cause d’extinction ne joue que si la plainte de la victime est une condition nécessaire à la poursuite. ',
                ),
                TextSpan(
                  text: 'L’article 6 alinéa 3 du Code de Procédure Pénale',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      ' le prévoit notamment pour des infractions comme la diffamation ou certaines atteintes à la vie privée.',
                ),
              ]),
              SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text: 'L’article 2 alinéa 2 du Code de Procédure Pénale',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      ' pose au contraire le principe selon lequel le retrait d’une plainte simple ou avec constitution de partie civile est, '
                      'en principe, sans effet sur l’action publique. La situation visée ici est donc une dérogation à ce principe général, '
                      'limitée aux cas où la plainte est une condition de recevabilité de la poursuite.',
                ),
              ]),
              SizedBox(height: 8),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        'lorsque la loi subordonne l’exercice de l’action publique au dépôt d’une plainte préalable, '
                        'le désistement du plaignant éteint l’action publique. Dans les autres cas, le ministère public reste libre de poursuivre.',
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          // =================== 4.2 CAUSES GENERALES ========================
          _ConditionCard(
            title:
                '4.2 — Les causes générales d’extinction de l’action publique',
            cardColor: cardBg,
            accent: accentBlue,
            titleColor: titleBlue,
            children: const [
              _Paragraph(
                'Les causes générales d’extinction de l’action publique s’appliquent à tous types d’infractions, '
                'sauf dispositions spéciales contraires : amnistie, abrogation de la loi pénale, décès du prévenu, '
                'chose jugée, prescription de l’action publique.',
              ),
            ],
          ),

          const SizedBox(height: 20),

          // =================== 4.2.1 AMNISTIE ==============================
          _ConditionCard(
            title: '4.2.1 — L’amnistie',
            cardColor: cardBg,
            accent: accentBlue,
            titleColor: titleBlue,
            children: const [
              _Paragraph(
                'L’amnistie est une mesure législative. Seul le Parlement peut décider, par une loi d’amnistie, '
                'd’effacer rétroactivement le caractère punissable de certains faits.',
              ),
              SizedBox(height: 6),
              _BulletPoint(
                text:
                    'Elle éteint immédiatement l’action publique pour tous les faits visés par la loi d’amnistie '
                    'et antérieurs à la date fixée par cette loi ;',
              ),
              _BulletPoint(
                text:
                    'elle peut être générale ou ne viser qu’une catégorie déterminée de délinquants (amnistie personnelle) ;',
              ),
              _BulletPoint(
                text:
                    'l’amnistie laisse subsister l’action civile : la victime conserve la possibilité de demander réparation du préjudice subi.',
              ),
            ],
          ),

          const SizedBox(height: 20),

          // =================== 4.2.2 ABROGATION LOI ========================
          _ConditionCard(
            title: '4.2.2 — L’abrogation de la loi pénale',
            cardColor: cardBg,
            accent: accentBlue,
            titleColor: titleBlue,
            children: const [
              _Paragraph(
                'La loi applicable à une infraction est, en principe, celle en vigueur au jour des faits. '
                'Toutefois, si la loi pénale est abrogée et que cette abrogation s’accompagne d’un effet plus doux, '
                'les poursuites déjà engagées peuvent cesser : le fait n’est plus incriminé.',
              ),
              SizedBox(height: 6),
              _Paragraph(
                'En vertu du principe de l’application immédiate de la loi pénale plus douce, une abrogation pure et simple '
                'de l’infraction entraîne l’extinction des poursuites en cours. '
                'Exceptionnellement, le législateur peut prévoir que l’abrogation ne vaudra que pour l’avenir, '
                'les poursuites déjà engagées continuant alors selon l’ancienne loi.',
              ),
            ],
          ),

          const SizedBox(height: 20),

          // =================== 4.2.3 DECES PREVENU =========================
          _ConditionCard(
            title: '4.2.3 — Le décès du prévenu',
            cardColor: cardBg,
            accent: accentBlue,
            titleColor: titleBlue,
            children: const [
              _Paragraph(
                'Le décès du prévenu éteint l’action publique. Si les poursuites n’ont pas encore été engagées, '
                'elles ne peuvent plus l’être. Si elles sont en cours, elles doivent être arrêtées.',
              ),
              SizedBox(height: 6),
              _Paragraph(
                'En application du principe de la personnalité des peines, les héritiers du délinquant ne peuvent pas '
                'être poursuivis pénalement à sa place. En revanche, l’action civile peut être exercée contre eux afin de '
                'réparer le dommage causé par l’infraction sur le patrimoine successoral.',
              ),
            ],
          ),

          const SizedBox(height: 20),

          // =================== 4.2.4 CHOSE JUGEE ===========================
          _ConditionCard(
            title: '4.2.4 — La chose jugée et le principe non bis in idem',
            cardColor: cardBg,
            accent: accentBlue,
            titleColor: titleBlue,
            children: const [
              _Paragraph(
                'Il y a chose jugée au pénal lorsque la décision de la juridiction répressive sur les faits reprochés '
                'est devenue définitive, soit parce que les voies de recours ont été épuisées, soit parce que les délais pour les exercer sont expirés.',
              ),
              SizedBox(height: 6),
              _Paragraph(
                'Cette décision définitive éteint l’action publique. Selon la jurisprudence, '
                'aucune nouvelle poursuite pénale ne peut être intentée à raison des mêmes faits, '
                'même sous une qualification différente, et même si des charges nouvelles apparaissent après une relaxe ou un acquittement. '
                'C’est l’expression du principe “non bis in idem”.',
              ),
              SizedBox(height: 6),
              _SubTitle('Cas des infractions continues'),
              _Paragraph(
                'Pour les infractions continues (par exemple le recel, lorsque le receleur reste en possession de la chose), '
                'l’action publique peut reprendre si l’état délictueux persiste après la condamnation initiale. '
                'Chaque maintien volontaire dans l’infraction peut constituer un fait nouveau, bien que de même nature.',
              ),
            ],
          ),

          const SizedBox(height: 24),

          // =================== 4.2.5 PRESCRIPTION ==========================
          _ConditionCard(
            title: '4.2.5 — La prescription de l’action publique',
            cardColor: cardBg,
            accent: accentBlue,
            titleColor: titleBlue,
            children: const [
              _Paragraph(
                'Lorsque l’action publique n’est pas exercée dans les délais fixés par la loi, elle s’éteint par la prescription. '
                'L’infraction restera impunie et l’auteur ne pourra plus être poursuivi pénalement.',
              ),
            ],
          ),

          const SizedBox(height: 18),

          // =================== 4.2.5.1 DELAIS PRESCRIPTION =================
          _ConditionCard(
            title: '4.2.5.1 — Le délai de prescription de l’action publique',
            cardColor: cardBg,
            accent: accentBlue,
            titleColor: titleBlue,
            children: const [
              _Paragraph.rich([
                TextSpan(
                  text: 'Les articles 7, 8 et 9 du Code de Procédure Pénale',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      ' fixent les délais de prescription de droit commun de l’action publique :',
                ),
              ]),
              SizedBox(height: 6),
              _BulletPoint(text: '20 ans pour les crimes ;'),
              _BulletPoint(text: '6 ans pour les délits ;'),
              _BulletPoint(text: '1 an pour les contraventions.'),
              SizedBox(height: 10),

              _SubTitle(
                'Délais exceptionnels pour certaines infractions',
              ),
              _BulletPoint(
                text:
                    'Délai imprescriptible pour les crimes de génocide et les crimes contre l’humanité '
                    '(articles 211-1 à 212-3 du Code pénal).',
              ),
              _BulletPoint(
                text:
                    '30 ans pour certains crimes liés au terrorisme et 20 ans pour les délits correspondants '
                    '(article 706-16 du Code de Procédure Pénale).',
              ),
              _BulletPoint(
                text:
                    '30 ans pour les crimes de trafic de stupéfiants et 20 ans pour les délits correspondants '
                    '(article 706-26 du Code de Procédure Pénale).',
              ),
              _BulletPoint(
                text:
                    '30 ans pour les crimes relatifs à la prolifération d’armes de destruction massive et de leurs vecteurs, '
                    'et 20 ans pour les délits punis de 10 ans d’emprisonnement (article 706-167 du Code de Procédure Pénale).',
              ),
              _BulletPoint(
                text:
                    '30 ans pour les crimes d’eugénisme et de clonage reproductif (articles 214-1 à 214-4 du Code pénal).',
              ),
              _BulletPoint(
                text:
                    '30 ans pour le crime de disparition forcée (article 221-12 du Code pénal).',
              ),
              _BulletPoint(
                text:
                    '30 ans pour les crimes de guerre et 20 ans pour les délits de guerre.',
              ),
              _BulletPoint(
                text:
                    '30 ans pour les crimes commis contre des mineurs listés à l’article 706-47 du Code de Procédure Pénale '
                    '(meurtre, tortures ou actes de barbarie, viol, proxénétisme sur mineur de quinze ans, traite des êtres humains…).',
              ),
              _BulletPoint(
                text:
                    '20 ans pour certains délits commis sur des mineurs (agressions sexuelles, atteintes sexuelles aggravées, '
                    'violences volontaires aggravées ayant entraîné une incapacité totale de travail de plus de huit jours).',
              ),
              _BulletPoint(
                text:
                    '10 ans pour certains délits commis sur des mineurs (abus frauduleux de l’état d’ignorance ou de faiblesse, '
                    'infractions sexuelles et infractions liées à la pornographie impliquant des mineurs, traite, proxénétisme, etc.).',
              ),
              _BulletPoint(
                text:
                    '1 an pour certains délits de presse à caractère discriminatoire (article 65-3 de la loi du 29 juillet 1881).',
              ),
              _BulletPoint(
                text:
                    '3 mois pour les délits de presse tels que la diffamation (article 65 de la loi du 29 juillet 1881).',
              ),
              SizedBox(height: 10),

              _SubTitle('Point de départ du délai'),
              _Paragraph(
                'En principe, le délai de prescription court à compter du jour où l’infraction a été commise pour une infraction instantanée (exemple : vol).',
              ),
              SizedBox(height: 4),
              _Paragraph(
                'Pour une infraction continue (comme le recel), le point de départ est fixé au jour où l’état délictueux cesse. '
                'En cas d’abus de confiance, il peut être reporté au moment où la victime découvre le détournement.',
              ),
              SizedBox(height: 6),

              _Paragraph.rich([
                TextSpan(
                  text: 'Les articles 7 et 8 du Code de Procédure Pénale',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      ' prévoient une règle particulière pour certains crimes et délits commis contre les mineurs : '
                      'le délai de prescription ne commence à courir qu’à compter de la majorité de la victime.',
                ),
              ]),
              SizedBox(height: 4),
              _Paragraph(
                'Le délai de prescription d’un crime de viol peut encore être prolongé lorsque, avant l’expiration du délai, '
                'l’auteur commet un nouveau viol, une agression sexuelle ou une atteinte sexuelle sur un autre mineur : '
                'le délai initial est prolongé jusqu’à la date de prescription de la nouvelle infraction. '
                'Ce mécanisme est étendu à certains délits sexuels.',
              ),
              SizedBox(height: 6),

              _Paragraph(
                'Pour le délit de non-dénonciation d’atteintes et d’agressions sexuelles sur mineur (article 434-3 du Code pénal), '
                'le délai de prescription est de 10 ans à compter de la majorité de la victime en cas d’agression ou d’atteinte sexuelle, '
                'et de 20 ans si la victime a subi un viol.',
              ),
              SizedBox(height: 6),

              _Paragraph(
                'Pour les infractions commises par le biais d’Internet, le point de départ du délai de prescription est fixé '
                'au jour de la première diffusion du message incriminé (jurisprudence de la Cour de cassation, 16 octobre 2001).',
              ),
              SizedBox(height: 6),

              _Paragraph.rich([
                TextSpan(
                  text: 'L’article 9-1 du Code de Procédure Pénale',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      ' prévoit un régime particulier pour l’infraction occulte ou dissimulée. '
                      'Dans ce cas, le délai de prescription court à compter du jour où l’infraction est apparue '
                      'et a pu être constatée dans des conditions permettant la mise en mouvement de l’action publique.',
                ),
              ]),
              SizedBox(height: 4),
              _BulletPoint(
                text:
                    'Infraction “occulte” : infraction qui, en raison de ses éléments constitutifs, ne peut être connue ni de la victime, ni de l’autorité judiciaire.',
              ),
              _BulletPoint(
                text:
                    'Infraction “dissimulée” : l’auteur accomplit des manœuvres caractérisées pour empêcher la découverte de l’infraction.',
              ),
              SizedBox(height: 4),
              _Paragraph(
                'Dans ces hypothèses, le délai de prescription ne peut toutefois excéder douze ans pour les délits et trente ans pour les crimes à compter du jour de la commission des faits.',
              ),
            ],
          ),

          const SizedBox(height: 22),

          // =================== 4.2.5.2 INTERRUPTION ========================
          _ConditionCard(
            title:
                '4.2.5.2 — L’interruption de la prescription (Article 9-2 du Code de Procédure Pénale)',
            cardColor: cardBg,
            accent: accentBlue,
            titleColor: titleBlue,
            children: const [
              _Paragraph(
                'L’interruption a pour effet de remettre le compteur à zéro : un nouveau délai complet '
                'de prescription commence à courir à partir de l’acte interruptif.',
              ),
              SizedBox(height: 6),

              _BulletPoint(
                text:
                    'Tout acte, émanant du ministère public ou de la partie civile, tendant à la mise en mouvement de l’action publique ;',
              ),
              _BulletPoint(
                text: 'Tout acte d’enquête émanant du ministère public ;',
              ),
              _BulletPoint(
                text:
                    'Tout procès-verbal dressé par un officier de police judiciaire ou un agent habilité, '
                    'tendant effectivement à la recherche et à la poursuite des auteurs ;',
              ),
              _BulletPoint(
                text:
                    'Tout acte d’instruction tendant à la recherche et à la poursuite des auteurs ;',
              ),
              _BulletPoint(
                text:
                    'Tout jugement ou arrêt, même non définitif, s’il n’est pas entaché de nullité.',
              ),
              SizedBox(height: 6),
              _Paragraph(
                'Ces actes font courir un nouveau délai de prescription d’une durée égale au délai initial.',
              ),
              SizedBox(height: 6),
              _Paragraph(
                'Le délai de prescription d’un viol, d’une agression sexuelle ou d’une atteinte sexuelle commis sur un mineur '
                'est également interrompu par un acte ou une décision concernant une infraction de même nature reprochée à la même personne, '
                'dans une autre procédure, et commise sur un autre mineur.',
              ),
            ],
          ),

          const SizedBox(height: 22),

          // =================== 4.2.5.3 SUSPENSION ==========================
          _ConditionCard(
            title:
                '4.2.5.3 — La suspension de la prescription (Article 9-3 du Code de Procédure Pénale)',
            cardColor: cardBg,
            accent: accentBlue,
            titleColor: titleBlue,
            children: const [
              _Paragraph(
                'La suspension a pour effet d’arrêter temporairement le cours de la prescription. '
                'Lorsque la cause de suspension disparaît, le délai recommence à courir là où il s’était arrêté.',
              ),
              SizedBox(height: 6),
              _Paragraph(
                'La différence avec l’interruption est essentielle : en cas d’interruption, un nouveau délai intégral court à nouveau ; '
                'en cas de suspension, le délai reprend simplement là où il avait été suspendu.',
              ),
              SizedBox(height: 6),
              _Paragraph(
                'La suspension de la prescription est rarement prévue en droit pénal. '
                'L’article 9-3 du Code de Procédure Pénale en donne une liste, mais la jurisprudence admet la suspension '
                'chaque fois que l’exercice de l’action publique rencontre un obstacle insurmontable de droit ou de fait.',
              ),
              SizedBox(height: 6),
              _BulletPoint(
                text:
                    'Obstacles de droit : par exemple la nécessité de faire trancher une question préalable, '
                    'ou d’obtenir une mainlevée, une autorisation, un avis ;',
              ),
              _BulletPoint(
                text:
                    'Obstacles de fait : événements rendant matériellement impossible la mise en mouvement de l’action publique, '
                    'comme une invasion du territoire, une catastrophe naturelle majeure, etc.',
              ),
              SizedBox(height: 8),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        'en pratique, l’enquêteur doit toujours garder à l’esprit la problématique de la prescription : '
                        'le choix des actes, leur rythme et leur chronologie sont essentiels pour éviter l’extinction de l’action publique.',
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
