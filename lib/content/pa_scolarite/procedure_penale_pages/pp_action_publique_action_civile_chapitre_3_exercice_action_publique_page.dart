import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaPPActionPubliqueChapitre3ExerciceActionPubliquePage
    extends StatelessWidget {
  const PaPPActionPubliqueChapitre3ExerciceActionPubliquePage({super.key});

  static const String routeName =
      '/pa/dps_dpg/procedure_penale/pp_action_publique_action_civile/chapitre_3_exercice_action_publique';

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
          'Chapitre 3 — Exercice de l’action publique',
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
            'L’exercice de l’action publique',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'De l’information du procureur de la République à la mise en mouvement '
            'de l’action publique, en passant par l’appréciation de la légalité, '
            'la recevabilité, le principe d’opportunité, les alternatives aux poursuites '
            'et les différentes modalités de saisine des juridictions.',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w500,
              fontSize: 13.5,
              height: 1.35,
              color: textSoft,
            ),
          ),
          const SizedBox(height: 18),

          // =================== 3.1 INFORMATION DU PROCUREUR ================
          _ConditionCard(
            title: '3.1 — Information du procureur de la République',
            cardColor: cardBg,
            accent: accentBlue,
            titleColor: titleBlue,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: 'Article 40 alinéa 1 du Code de Procédure Pénale',
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const TextSpan(
                  text:
                      ' : le procureur de la République reçoit les plaintes et '
                      'les dénonciations et apprécie la suite à leur donner.',
                ),
              ]),
              const SizedBox(height: 6),
              const _Paragraph(
                'Les sources d’information du procureur de la République peuvent être :',
              ),
              const SizedBox(height: 4),
              const _IntroBullet(text: 'une plainte émanant de la victime ;'),
              const _IntroBullet(
                text:
                    'une dénonciation (particulier, association, administration, autorité constituée, etc.).',
              ),
              const SizedBox(height: 10),

              _Paragraph.rich([
                TextSpan(
                  text: 'Article 40 alinéa 2 du Code de Procédure Pénale',
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const TextSpan(
                  text:
                      ' : toute autorité constituée, tout officier public ou fonctionnaire '
                      'qui, dans l’exercice de ses fonctions, acquiert connaissance d’un crime '
                      'ou d’un délit doit en informer sans délai le procureur de la République.',
                ),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text: 'Article 19 du Code de Procédure Pénale',
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const TextSpan(
                  text:
                      ' : les officiers de police judiciaire doivent informer sans délai '
                      'le procureur de la République des crimes, délits et contraventions '
                      'dont ils ont connaissance.',
                ),
              ]),
              const SizedBox(height: 8),

              const _SubTitle('Obligations pesant sur les citoyens'),
              _Paragraph.rich([
                TextSpan(
                  text: 'Les articles 434-1 à 434-3 du Code pénal',
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const TextSpan(
                  text:
                      ' sanctionnent l’abstention volontaire d’informer les autorités '
                      'administratives ou judiciaires de certains crimes dont on peut '
                      'prévenir ou limiter les effets, ainsi que de sévices ou privations '
                      'infligés à un mineur ou à une personne vulnérable, ou d’atteintes '
                      'aux intérêts fondamentaux de la Nation.',
                ),
              ]),
              const SizedBox(height: 4),
              _Paragraph.rich([
                TextSpan(
                  text: 'L’article 434-4-1 du Code pénal',
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const TextSpan(
                  text:
                      ' réprime le fait d’entraver les procédures de recherche concernant '
                      'la disparition d’un mineur de quinze ans.',
                ),
              ]),
              const SizedBox(height: 8),

              const _Paragraph(
                'Certaines législations spéciales prévoient aussi une obligation de signalement :',
              ),
              const _BulletPoint(
                text:
                    'les maires doivent révéler les faits délictueux dont ils ont connaissance '
                    '(article L. 132-2 du Code de la sécurité intérieure) ;',
              ),
              const _BulletPoint(
                text:
                    'les commissaires aux comptes (article L. 821-9 du Code de commerce), '
                    'et d’autres professions réglementées ayant des obligations de signalement.',
              ),
              const SizedBox(height: 10),

              const _NotaBox(
                title: 'Pour l’enquêteur',
                bodySpans: [
                  TextSpan(
                    text:
                        'l’information rapide et complète du procureur de la République est un pivot '
                        'de la procédure : toute rétention ou retard injustifié peut faire perdre '
                        'en réactivité et en efficacité dans la réponse pénale.',
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 22),

          // =================== 3.2 APPRECIATION LEGALITE ===================
          _ConditionCard(
            title: '3.2 — L’appréciation de la légalité',
            cardColor: cardBg,
            accent: accentBlue,
            titleColor: titleBlue,
            children: const [
              _Paragraph(
                'Avant d’exercer l’action publique, le ministère public vérifie d’abord '
                'si la poursuite est légalement possible, puis s’il est opportun de le faire.',
              ),
              SizedBox(height: 6),

              _SubTitle('Qualification des faits'),
              _BulletPoint(
                text:
                    'Vérifier que les faits constituent bien une infraction prévue par un texte pénal : '
                    'élément légal, élément matériel, élément moral.',
              ),
              _BulletPoint(
                text:
                    'Qualifier juridiquement l’infraction (crime, délit ou contravention, nature de l’infraction).',
              ),
              SizedBox(height: 8),

              _SubTitle('Identification des personnes poursuivies'),
              _BulletPoint(
                text:
                    'Identifier précisément la personne physique ou morale : auteur, coauteurs, complices.',
              ),
              _BulletPoint(
                text:
                    'Si l’auteur est inconnu, l’action publique peut être engagée contre X : '
                    'réquisitoire introductif contre X permettant l’ouverture d’une information.',
              ),
              SizedBox(height: 8),

              _SubTitle('Imputabilité et causes d’irresponsabilité'),
              _BulletPoint(
                text:
                    'Vérifier que l’infraction est imputable à la personne identifiée : '
                    'absence de cause d’irresponsabilité pénale (trouble psychique, contrainte, '
                    'erreur invincible, minorité pénale, etc.).',
              ),
              _BulletPoint(
                text:
                    'S’assurer qu’aucune cause légale d’exemption ou de justification '
                    '(légitime défense, état de nécessité, autorisation de la loi…) ne fait obstacle à la poursuite.',
              ),
            ],
          ),

          const SizedBox(height: 22),

          // =================== 3.3 RECEVABILITE ============================
          _ConditionCard(
            title: '3.3 — La recevabilité de l’action publique',
            cardColor: cardBg,
            accent: accentBlue,
            titleColor: titleBlue,
            children: const [
              _Paragraph(
                'Une fois la légalité vérifiée, le procureur de la République doit s’assurer '
                'que l’action publique est recevable.',
              ),
              SizedBox(height: 6),

              _SubTitle('Compétence'),
              _BulletPoint(
                text:
                    'Compétence territoriale : lien avec le lieu de commission des faits, le domicile '
                    'du prévenu ou de la victime, ou le lieu d’arrestation, selon les règles du Code de Procédure Pénale.',
              ),
              _BulletPoint(
                text:
                    'Compétence matérielle : tribunal de police, tribunal correctionnel, cour d’assises, '
                    'selon la nature de l’infraction et la peine encourue.',
              ),
              SizedBox(height: 8),

              _SubTitle('Absence de cause d’extinction de l’action publique'),
              _BulletPoint(
                text:
                    'Vérifier l’absence de prescription de l’action publique.',
              ),
              _BulletPoint(
                text:
                    'Vérifier l’absence d’amnistie, de décès du prévenu, de transaction éteignant l’action publique, '
                    'ou de décision définitive ayant déjà statué sur les mêmes faits (autorité de la chose jugée).',
              ),
            ],
          ),

          const SizedBox(height: 22),

          // =================== 3.4 DECISION DE POURSUITE ===================
          _ConditionCard(
            title: '3.4 — La décision de poursuite du ministère public',
            cardColor: cardBg,
            accent: accentBlue,
            titleColor: titleBlue,
            children: [
              const _Paragraph(
                'Une fois la légalité et la recevabilité vérifiées, le procureur de la République '
                'se trouve devant une alternative : exercer l’action publique ou renoncer à engager '
                'des poursuites. Cette liberté de choix est encadrée par le principe de l’opportunité '
                'des poursuites.',
              ),
              const SizedBox(height: 10),

              const _SubTitle('3.4.1 — Le principe de l’opportunité des poursuites'),
              _Paragraph.rich([
                TextSpan(
                  text: 'Article 40-1 du Code de Procédure Pénale',
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const TextSpan(
                  text:
                      ' : lorsque le procureur de la République estime que les faits '
                      'portés à sa connaissance constituent une infraction commise par une '
                      'personne identifiée, il décide s’il est opportun :',
                ),
              ]),
              const SizedBox(height: 4),
              const _IntroBullet(text: 'd’engager des poursuites ;'),
              const _IntroBullet(
                text:
                    'de mettre en œuvre une procédure alternative aux poursuites ;',
              ),
              const _IntroBullet(
                text:
                    'ou de classer sans suite la procédure lorsque des circonstances particulières '
                    'liées à la commission des faits le justifient.',
              ),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text: 'Article 40 alinéa 1 du Code de Procédure Pénale',
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const TextSpan(
                  text:
                      ' : le procureur de la République reçoit les plaintes et les dénonciations '
                      'et apprécie la suite à leur donner conformément à l’article 40-1.',
                ),
              ]),
              const SizedBox(height: 10),

              const _SubTitle('3.4.1.1 — Le classement sans suite'),
              const _Paragraph(
                'Le procureur peut décider de classer sans suite lorsqu’il estime :',
              ),
              const _BulletPoint(
                text:
                    'que l’infraction n’est pas constituée (élément légal, matériel ou moral manquant) ;',
              ),
              const _BulletPoint(
                text:
                    'que les faits ne sont pas imputables à la personne mise en cause ;',
              ),
              const _BulletPoint(text: 'que la preuve est insuffisante ;'),
              const _BulletPoint(
                text:
                    'ou que l’action publique n’est pas recevable (prescription, extinction…).',
              ),
              const SizedBox(height: 6),
              const _Paragraph(
                'Le classement sans suite n’est pas un déni de justice. Il est provisoire et peut '
                'être remis en cause tant que la prescription n’est pas acquise, notamment en cas '
                'd’éléments nouveaux révélant une infraction ou la gravité réelle des faits.',
              ),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text: 'Article 40-2 du Code de Procédure Pénale',
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const TextSpan(
                  text:
                      ' : le procureur de la République avise les plaignants, les victimes identifiées '
                      'et les autorités mentionnées à l’article 40 alinéa 2 des poursuites, des mesures '
                      'alternatives ou du classement décidé. En cas de classement, il indique les '
                      'raisons juridiques ou d’opportunité qui le justifient.',
                ),
              ]),
              const SizedBox(height: 4),
              const _Paragraph.rich([
                TextSpan(
                  text: 'Le bureau d’ordre national informatisé « Cassiopée »',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      ' gère les obligations d’avis motivé des classements sans suite à la victime, '
                      'conformément à l’article 48-1 du Code de Procédure Pénale.',
                ),
              ]),
              const SizedBox(height: 10),

              const _SubTitle('3.4.1.2 — Le procureur engage les poursuites'),
              const _Paragraph(
                'Lorsque le procureur décide d’exercer l’action publique, sa décision est irrévocable : '
                'il ne peut plus revenir sur la poursuite engagée. Seule la juridiction saisie peut '
                'décider d’éteindre l’action (relaxe, nullité, prescription constatée, etc.).',
              ),
              const SizedBox(height: 4),
              const _BulletPoint(
                text:
                    'Il n’existe pas de recours contre la décision d’exercer l’action publique, même de la part du supérieur hiérarchique.',
              ),
              const _BulletPoint(
                text:
                    'Le parquet ne peut ni renoncer aux voies de recours que la loi lui ouvre, ni se désister de celles qu’il a déjà exercées.',
              ),
              const SizedBox(height: 8),

              const _SubTitle('3.4.2 — Les limites au principe d’opportunité'),
              const _Paragraph(
                'Certaines situations limitent la liberté de décision du procureur : il peut être '
                'obligé d’agir, ou au contraire empêché de poursuivre.',
              ),
              const SizedBox(height: 8),

              const _SubTitle(
                '3.4.2.1 — L’obligation d’agir du ministère public',
              ),
              _Paragraph.rich([
                TextSpan(
                  text: 'Article 36 et article 37 du Code de Procédure Pénale',
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const TextSpan(
                  text:
                      ' : le procureur général peut adresser au procureur de la République des instructions écrites, '
                      'versées au dossier, pour lui enjoindre d’engager des poursuites.',
                ),
              ]),
              const SizedBox(height: 4),
              const _BulletPoint(
                text:
                    'En cas de recours auprès du procureur général contre un classement sans suite, celui-ci peut ordonner au procureur d’engager des poursuites ou confirmer le classement (article 40-3 du Code de Procédure Pénale).',
              ),
              const SizedBox(height: 6),
              const _BulletPoint(
                text:
                    'La plainte avec constitution de partie civile devant le juge d’instruction, '
                    'ou la constitution de partie civile devant la juridiction de jugement, '
                    'met automatiquement l’action publique en mouvement, même contre l’avis du procureur.',
              ),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text:
                      'La chambre de l’instruction peut également ordonner d’office la poursuite de faits principaux ou connexes (articles 202 et 204 du Code de Procédure Pénale)',
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const TextSpan(
                  text:
                      ', à l’encontre de personnes déjà mises en examen ou d’autres personnes n’ayant pas encore été renvoyées devant elle.',
                ),
              ]),
              const SizedBox(height: 10),

              const _SubTitle('3.4.2.2 — Les interdictions d’agir'),
              const _Paragraph(
                'Le procureur peut être empêché d’engager des poursuites : immunités, nécessité d’une plainte, d’une autorisation, d’un avis préalable, ou d’une décision sur une question préjudicielle.',
              ),
              const SizedBox(height: 6),

              const _SubTitle('Les immunités'),
              const _BulletPoint(
                text:
                    'Certaines infractions ne peuvent être poursuivies en raison d’immunités, par exemple familiales : vol entre époux (article 311-12 du Code pénal), sauf exceptions.',
              ),
              const SizedBox(height: 6),

              const _SubTitle('Nécessité d’une plainte préalable'),
              const _Paragraph(
                'Dans certains cas, le ministère public ne peut agir qu’après dépôt d’une plainte :',
              ),
              const _BulletPoint(
                text:
                    'considérations d’ordre moral ou familial (ex : diffamation et injure nécessitant une plainte de la victime ou de ses ayants droit).',
              ),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'De nombreux délits de presse ou certaines infractions d’atteinte à la vie privée nécessitent une plainte préalable ',
                ),
                TextSpan(
                  text: '(par exemple article 226-6 du Code pénal)',
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const TextSpan(text: '.'),
              ]),
              const SizedBox(height: 4),
              const _BulletPoint(
                text:
                    'lorsque la plainte est une condition nécessaire à la poursuite, le désistement du plaignant entraîne l’extinction de l’action publique (article 6 alinéa 3 du Code de Procédure Pénale).',
              ),
              const SizedBox(height: 6),

              const _SubTitle('Nécessité d’une plainte d’une administration'),
              const _BulletPoint(
                text:
                    'En matière d’impôts directs ou de taxe sur la valeur ajoutée, l’action publique ne peut être engagée qu’après dépôt d’une plainte de l’administration fiscale.',
              ),
              const SizedBox(height: 6),

              const _SubTitle('Nécessité d’une autorisation préalable'),
              const _BulletPoint(
                text:
                    'Parlementaires : l’action pénale peut être engagée, mais les mesures privatives ou restrictives de liberté sont, sauf flagrance, soumises à l’autorisation du bureau de l’assemblée concernée.',
              ),
              const _BulletPoint(
                text:
                    'Président de la République : irresponsabilité pour les actes accomplis en cette qualité, sous réserve de l’article 53-2 de la Constitution (crimes contre l’humanité) et de l’article 68 (destitution). Inviolabilité pendant le mandat pour les actes détachables.',
              ),
              const _BulletPoint(
                text:
                    'Premier ministre et ministres : responsables pénalement selon le droit commun pour les crimes et délits commis dans l’exercice de leurs fonctions devant la Cour de justice de la République, sur saisine organisée par la loi.',
              ),
              const SizedBox(height: 6),

              const _SubTitle('Nécessité d’un avis ou d’une mise en demeure'),
              const _BulletPoint(
                text:
                    'Dans certains délits boursiers (délit d’initié), l’avis de l’Autorité des marchés financiers est nécessaire.',
              ),
              const _BulletPoint(
                text:
                    'En matière d’hygiène et de sécurité au travail, une mise en demeure de l’inspecteur du travail peut être exigée avant poursuite (articles L. 4721-4 et suivants du Code du travail).',
              ),
              const SizedBox(height: 6),

              const _SubTitle(
                'Nécessité de résoudre une question préjudicielle',
              ),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Dans certains cas, la poursuite pénale suppose qu’une juridiction ait préalablement statué sur une question déterminante. ',
                ),
                TextSpan(
                  text: 'Article 6-1 du Code de Procédure Pénale',
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const TextSpan(
                  text:
                      ' : l’action publique ne peut être exercée pour un crime ou un délit prétendument commis à l’occasion d’une procédure qu’à condition que le caractère illégal de cette procédure ou de la décision ait été constaté par une décision définitive.',
                ),
              ]),
              const SizedBox(height: 6),
              const _Paragraph(
                'Exemple jurisprudentiel : falsification d’un procès-verbal de notification de garde à vue quant à l’heure ou au lieu (article 63-1 du Code de Procédure Pénale). Tant que le caractère illégal du procès-verbal n’a pas été constaté par une décision définitive, l’action publique pour faux ne peut être engagée (Crim., 7 décembre 2005).',
              ),
            ],
          ),

          const SizedBox(height: 24),

          // =================== 3.4.3 ALTERNATIVES =========================
          _ConditionCard(
            title:
                '3.4.3 — L’alternative aux poursuites (Article 41-1 du Code de Procédure Pénale)',
            cardColor: cardBg,
            accent: accentBlue,
            titleColor: titleBlue,
            children: const [
              _Paragraph(
                'Avant de décider d’exercer l’action publique, le procureur de la République '
                'peut mettre en œuvre des mesures alternatives aux poursuites, directement ou '
                'par l’intermédiaire d’un officier de police judiciaire, d’un délégué ou d’un '
                'médiateur du procureur.',
              ),
              SizedBox(height: 8),

              _BulletPoint(
                text:
                    'Avertissement pénal probatoire : rappel des obligations légales et des peines '
                    'encourues, valable sous condition de non-récidive dans un délai déterminé. '
                    'Réservé à certaines situations (pas de condamnation antérieure, pas de violences graves, etc.).',
              ),
              _BulletPoint(
                text:
                    'Orientation vers une structure sanitaire, sociale ou professionnelle '
                    '(stages de citoyenneté, sensibilisation à la sécurité routière, aux dangers des stupéfiants, '
                    'à la lutte contre le sexisme, les violences au sein du couple, etc.).',
              ),
              _BulletPoint(
                text:
                    'Demande de régularisation de la situation au regard de la loi '
                    '(ex : urbanisme, construction irrégulière).',
              ),
              _BulletPoint(
                text: 'Demande de réparation du dommage causé à la victime.',
              ),
              _BulletPoint(
                text:
                    'Médiation pénale entre auteur et victime, à la demande ou avec l’accord de cette dernière. En cas de succès, un procès-verbal permet à la victime d’obtenir le recouvrement des sommes dues par la procédure d’injonction de payer. La médiation est exclue en cas de violences au sein du couple relevant de l’article 132-80 du Code pénal.',
              ),
              _BulletPoint(
                text:
                    'Mise en demeure de résider hors du domicile conjugal et de ne pas s’en approcher en cas de violences intrafamiliales.',
              ),
              _BulletPoint(
                text:
                    'Interdiction temporaire de paraître dans certains lieux ou de rencontrer certaines personnes (victimes, coauteurs, complices).',
              ),
              _BulletPoint(
                text:
                    'Contribution citoyenne au profit d’une association d’aide aux victimes.',
              ),
              _BulletPoint(
                text:
                    'Réponse en lien avec le maire (transaction prévue à l’article 44-1 du Code de Procédure Pénale).',
              ),
              SizedBox(height: 8),

              _NotaBox(
                title: 'En pratique',
                bodySpans: [
                  TextSpan(
                    text:
                        'le procureur utilise ces mesures lorsqu’elles permettent d’assurer une réparation rapide, de mettre fin au trouble et de favoriser le reclassement de l’auteur. En cas d’échec ou de non-exécution, des poursuites peuvent être engagées.',
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          // =================== 3.4.4 COMPOSITION PENALE ====================
          _ConditionCard(
            title:
                '3.4.4 — La composition pénale (Articles 41-2, 41-3 et suivants du Code de Procédure Pénale)',
            cardColor: cardBg,
            accent: accentBlue,
            titleColor: titleBlue,
            children: [
              const _Paragraph(
                'Tant que l’action publique n’a pas été mise en mouvement, le procureur '
                'de la République peut proposer à une personne qui reconnaît les faits une '
                'composition pénale. C’est une réponse pénale négociée, distincte du jugement classique.',
              ),
              const SizedBox(height: 6),

              const _SubTitle('Conditions générales'),
              _Paragraph.rich([
                TextSpan(
                  text: 'Article 41-2 du Code de Procédure Pénale',
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const TextSpan(
                  text:
                      ' : la composition pénale concerne les délits punis d’une peine '
                      'd’amende ou d’emprisonnement inférieure ou égale à cinq ans, ainsi '
                      'que les contraventions. Elle peut, sous conditions, s’appliquer aux personnes morales.',
                ),
              ]),
              const SizedBox(height: 4),
              const _Paragraph('Elle n’est pas applicable :'),
              const _BulletPoint(text: 'aux mineurs de moins de treize ans ;'),
              const _BulletPoint(
                text:
                    'en matière de délits de presse, d’homicides involontaires, de délits politiques ;',
              ),
              const SizedBox(height: 8),

              const _SubTitle('Formes possibles de la composition pénale'),
              const _Paragraph(
                'La composition pénale peut prévoir : amende, stage, travail non rémunéré, remise en état, indemnisation, obligations diverses, etc., dans les limites prévues par la loi. '
                'Lorsque la victime est identifiée, une mesure de réparation du préjudice peut être proposée dans un délai de six mois.',
              ),
              const SizedBox(height: 8),

              const _SubTitle('Mise en œuvre'),
              const _BulletPoint(
                text:
                    'Proposition écrite du procureur de la République, jointe à la procédure, précisant la nature et la durée des mesures.',
              ),
              const _BulletPoint(
                text:
                    'Information de la personne sur son droit à être assistée d’un avocat avant d’accepter.',
              ),
              const _BulletPoint(
                text:
                    'Validation par le président du tribunal ou un magistrat délégué, sauf hypothèses où la validation n’est pas requise pour certains délits.',
              ),
              const _BulletPoint(
                text:
                    'En cas de validation, les mesures sont exécutées. En cas de refus d’homologation, la composition devient caduque.',
              ),
              const SizedBox(height: 6),
              const _Paragraph(
                'Si la personne refuse la composition, ou si elle n’exécute pas les mesures '
                'acceptées, le procureur de la République peut mettre en mouvement l’action '
                'publique. Les compositions exécutées sont inscrites au bulletin n°1 du casier judiciaire.',
              ),
              const SizedBox(height: 8),

              const _SubTitle('Effets'),
              _Paragraph.rich([
                TextSpan(
                  text: 'Article 41-2 du Code de Procédure Pénale',
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const TextSpan(
                  text:
                      ' : les actes tendant à la mise en œuvre ou à l’exécution de la composition pénale '
                      'interrompent la prescription de l’action publique. L’exécution complète de la composition '
                      'éteint l’action publique.',
                ),
              ]),
              const SizedBox(height: 6),
              const _NotaBox(
                title: 'Nota',
                bodySpans: [
                  TextSpan(
                    text:
                        'si l’auteur des faits s’est engagé à verser des dommages et intérêts à la victime, '
                        'celle-ci peut en demander le recouvrement par la procédure d’injonction de payer.',
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          // =================== 3.5 EXECUTION : SAISINE JURIDICTION =========
          _ConditionCard(
            title:
                '3.5 — L’exécution de la poursuite : saisine de la juridiction de jugement',
            cardColor: cardBg,
            accent: accentBlue,
            titleColor: titleBlue,
            children: const [
              _Paragraph(
                'Lorsque le procureur de la République décide d’exercer l’action publique, '
                'il doit saisir la juridiction de jugement compétente par différents procédés :',
              ),
              SizedBox(height: 10),

              _SubTitle('3.5.1 — La citation directe'),
              _Paragraph(
                'Acte par lequel le ministère public cite directement le prévenu à comparaître '
                'devant le tribunal correctionnel ou le tribunal de police. Il s’agit d’un exploit '
                'd’huissier délivré selon les formes et délais prévus par les articles 550 et suivants '
                'du Code de Procédure Pénale (article 390 notamment).',
              ),
              _Paragraph(
                'Lorsque la personne est sans domicile ou résidence connus, un procès-verbal du procureur '
                'peut valoir citation à parquet (article 559 du Code de Procédure Pénale) et permettre de '
                'juger par défaut selon l’article 412.',
              ),
              SizedBox(height: 10),

              _SubTitle(
                '3.5.2 — L’avertissement suivi de la comparution volontaire',
              ),
              _Paragraph(
                'Le procureur de la République adresse un avertissement au mis en cause pour l’inviter '
                'à se présenter volontairement devant le tribunal à une date fixée (articles 389 et 532 '
                'du Code de Procédure Pénale). La juridiction n’est saisie que si la personne comparaît effectivement.',
              ),
              SizedBox(height: 10),

              _SubTitle('3.5.3 — La convocation en justice'),
              _Paragraph(
                'C’est une citation à comparaître décidée par le parquet sans présentation préalable de la personne (article 390-1 du Code de Procédure Pénale). '
                'La convocation est notifiée par un greffier, un officier ou agent de police judiciaire, un fonctionnaire habilité, un délégué ou médiateur du procureur ou, si le prévenu est détenu, par le chef d’établissement. Un procès-verbal signé est remis au prévenu.',
              ),
              SizedBox(height: 10),

              _SubTitle('3.5.4 — La convocation par procès-verbal'),
              _Paragraph(
                'Dans la convocation par procès-verbal (article 394 du Code de Procédure Pénale), '
                'le procureur invite la personne à comparaître devant le tribunal correctionnel dans un '
                'délai de dix jours à six mois. Les faits retenus, le lieu, la date et l’heure d’audience '
                'sont notifiés. Si nécessaire, un contrôle judiciaire, une assignation à résidence avec '
                'surveillance électronique ou une détention provisoire peuvent être décidés par le juge des libertés et de la détention.',
              ),
              SizedBox(height: 10),

              _SubTitle('3.5.5 — La comparution immédiate'),
              _Paragraph(
                'Procédure rapide par laquelle le procureur fait traduire immédiatement le prévenu devant '
                'le tribunal correctionnel (article 395 du Code de Procédure Pénale), lorsque :',
              ),
              _IntroBullet(
                text:
                    'la peine encourue est au moins égale à deux ans d’emprisonnement (six mois en cas de délit flagrant) ;',
              ),
              _IntroBullet(
                text:
                    'les charges sont suffisantes et l’affaire en état d’être jugée ;',
              ),
              _IntroBullet(
                text:
                    'la gravité et les circonstances de l’espèce justifient une réponse rapide.',
              ),
              _Paragraph(
                'Si le tribunal ne peut être réuni le jour même et que la gravité le justifie, le juge des libertés '
                'et de la détention peut placer le prévenu en détention provisoire en attendant l’audience, qui doit '
                'intervenir au plus tard le troisième jour ouvrable suivant, à défaut de quoi la personne est remise en liberté.',
              ),
              SizedBox(height: 10),

              _SubTitle('3.5.6 — La comparution à délai différé'),
              _Paragraph(
                'Prévue à l’article 397-1-1 du Code de Procédure Pénale, cette procédure permet de saisir le tribunal '
                'pour une audience fixée dans un délai maximum de deux mois lorsque la culpabilité paraît pouvoir être '
                'retenue mais que l’affaire n’est pas totalement en état d’être jugée (examens techniques ou médicaux en cours, expertises, etc.).',
              ),
              _Paragraph(
                'Elle concerne les délits flagrants punis d’au moins six mois d’emprisonnement, et les délits non flagrants '
                'punis d’au moins deux ans, à condition que le prévenu soit assisté d’un avocat.',
              ),
              SizedBox(height: 10),

              _SubTitle('3.5.7 — L’ordonnance pénale'),
              _Paragraph(
                'Procédure simplifiée (articles 495 à 495-6 et 524 à 528-2 du Code de Procédure Pénale) permettant de juger '
                'certains délits et contraventions sans débat contradictoire préalable. Le président du tribunal statue sur dossier, '
                'sur réquisitions écrites du procureur, par ordonnance de relaxe ou de condamnation. Un délai est ouvert pour former opposition.',
              ),
              SizedBox(height: 10),

              _SubTitle(
                '3.5.8 — La comparution sur reconnaissance préalable de culpabilité (C.R.P.C.)',
              ),
              _Paragraph(
                'La C.R.P.C. (articles 495-8 et suivants du Code de Procédure Pénale) est une forme de poursuite fondée sur la '
                'reconnaissance de culpabilité par la personne poursuivie. Elle ne s’applique pas aux mineurs, ni à certains délits '
                '(presse, homicides involontaires, délits politiques, etc.). La personne doit être assistée d’un avocat. '
                'Le procureur propose une ou plusieurs peines ; si la personne accepte, un juge homologue la proposition. '
                'L’ordonnance d’homologation a les effets d’un jugement de condamnation et est susceptible d’appel.',
              ),
              SizedBox(height: 10),

              _SubTitle(
                '3.5.9 — Le réquisitoire introductif ou réquisitoire aux fins d’informer',
              ),
              _Paragraph.rich([
                TextSpan(
                  text:
                      'C’est l’acte par lequel le procureur de la République requiert le juge d’instruction d’ouvrir une information (article 80 du Code de Procédure Pénale',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      ') contre une personne dénommée ou non. Il est obligatoire en matière criminelle et permet de confier au juge d’instruction la conduite des investigations.',
                ),
              ]),
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
