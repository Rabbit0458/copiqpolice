import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaPPControleMissionPJRoleProcureurGeneralPage extends StatelessWidget {
  const PaPPControleMissionPJRoleProcureurGeneralPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/procedure_penale/pp_controle_mission_pj_role_procureur_general';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color textMain = isDark
        ? Colors.white
        : const Color(0xFF0D47A1); // bleu foncé
    final Color textSoft = isDark
        ? Colors.white70
        : const Color(0xFF1F1F1F).withValues(alpha: .88);
    final Color accent = isDark ? const Color(0xFF64B5F6) : const Color(0xFF1565C0);
    final Color cardColor = isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF7F7F7);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Contrôle de la mission PJ',
          style: GoogleFonts.fustat(fontWeight: FontWeight.w700),
        ),
        elevation: 1,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ====================== TITRE PRINCIPAL =======================
              Text(
                'Chapitre 1 – Le rôle du procureur général\nprès la cour d’appel',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w900,
                  fontSize: 21,
                  height: 1.15,
                  color: textMain,
                ),
              ),
              const SizedBox(height: 8),

              const _Paragraph.rich([
                TextSpan(
                  text:
                      'Le procureur général près la cour d’appel exerce un rôle central dans le contrôle '
                      'de la mission de police judiciaire. Il ne dirige pas directement les enquêtes, mais '
                      'assure une véritable mission de tutelle sur les officiers et agents de police judiciaire, '
                      'notamment à travers la surveillance, l’habilitation et la notation des officiers de police '
                      'judiciaire.',
                ),
              ]),
              const SizedBox(height: 10),

              const _IntroBullet(
                text:
                    'Mission tutélaire de surveillance sur les officiers et agents de police judiciaire.',
              ),
              const _IntroBullet(
                text:
                    'Pouvoir d’habilitation, de suspension ou de retrait d’habilitation des officiers de police judiciaire.',
              ),
              const _IntroBullet(
                text:
                    'Rôle de coordination générale de la politique d’action publique au niveau du ressort de la cour d’appel.',
              ),

              const SizedBox(height: 20),

              // ==================== 1. RÔLE GÉNÉRAL =========================
              _ConditionCard(
                title:
                    '1. Rôle général et mission tutélaire du procureur général',
                cardColor: cardColor,
                accent: accent,
                titleColor: textMain,
                children: const [
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'Comme l’indique l’article C 34 de l’instruction générale du 27 février 1959 relative au Code '
                          'de Procédure Pénale, la surveillance exercée par le procureur général « consiste en une mission '
                          'tutélaire ». Il ne dispose donc pas, contrairement au procureur de la République, d’un pouvoir '
                          'direct de direction de la police judiciaire sur le terrain, même s’il peut intervenir de manière '
                          'indirecte.',
                    ),
                  ]),
                  SizedBox(height: 10),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'En tant que chef hiérarchique du procureur de la République, le procureur général peut faire '
                          'parvenir, par l’intermédiaire de ce dernier, des directives aux officiers de police judiciaire. '
                          'Sa position auprès de la cour d’appel, juridiction du second degré, ne lui permet toutefois pas '
                          'd’exercer efficacement des attributions personnelles de police judiciaire au quotidien.',
                    ),
                  ]),
                  SizedBox(height: 10),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'Au-delà de cette mission de surveillance, prérogative traditionnelle exercée sur les officiers '
                          'et agents de police judiciaire, le procureur général est chargé :\n',
                    ),
                  ]),
                  SizedBox(height: 4),
                  _BulletPoint(
                    text:
                        'd’habiliter les officiers de police judiciaire à exercer effectivement les attributions liées à leur qualité ;',
                  ),
                  _BulletPoint(
                    text:
                        'de procéder à leur notation, qui conditionne notamment leur avancement ;',
                  ),
                  _BulletPoint(
                    text:
                        'd’assurer une coordination générale de la prévention et de la répression des infractions au sein de son ressort.',
                  ),
                  SizedBox(height: 10),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'Ainsi, le procureur général anime et coordonne l’action des procureurs de la République en matière de politique pénale, '
                          'tant pour la prévention que pour la répression des infractions. Cette mission est rappelée par ',
                    ),
                    TextSpan(
                      text: 'l’Article 35 alinéa 2 du Code de Procédure Pénale',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text:
                          ', mais sans empiéter sur le pouvoir de direction opérationnelle de la police judiciaire exercé par le procureur de la République.',
                    ),
                  ]),
                ],
              ),

              const SizedBox(height: 18),

              // ==================== 1.1 SURVEILLANCE ========================
              _ConditionCard(
                title: '1.1 La surveillance proprement dite',
                cardColor: cardColor,
                accent: accent,
                titleColor: textMain,
                children: [
                  const _Paragraph.rich([
                    TextSpan(
                      text:
                          'La surveillance est une attribution traditionnelle du procureur général, toujours consacrée par les textes. '
                          'Le principe est énoncé par ',
                    ),
                    TextSpan(
                      text: 'l’Article 13 du Code de Procédure Pénale',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text:
                          ', qui précise que la police judiciaire est placée sous la surveillance du procureur général près la cour d’appel '
                          'et sous le contrôle de la chambre de l’instruction.',
                    ),
                  ]),
                  const SizedBox(height: 10),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Ce rôle est rappelé également par l’article 38 du même code, qui permet au procureur général de charger les officiers '
                          'et agents de police judiciaire de recueillir tous renseignements qu’il estime utiles à une bonne administration de la justice. '
                          'L’article C 34 de l’instruction générale du 27 février 1959 précise que cette surveillance consiste à : ',
                    ),
                    TextSpan(
                      text:
                          '« prévenir les fautes professionnelles, en empêcher le renouvellement et, le cas échéant, en assurer la sanction »',
                      style: GoogleFonts.fustat(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    const TextSpan(text: '.'),
                  ]),
                  const SizedBox(height: 10),
                  const _SubTitle('Les sanctions encourues'),
                  const _BulletPoint(
                    text:
                        'Sanctions pénales : responsabilité pénale en cas d’infraction.',
                  ),
                  const _BulletPoint(
                    text:
                        'Sanctions civiles : réparation des dommages causés aux victimes.',
                  ),
                  const _BulletPoint(
                    text:
                        'Sanctions disciplinaires : mesures prises par l’autorité hiérarchique ou judiciaire (avertissement, suspension, retrait d’habilitation…).',
                  ),
                  const SizedBox(height: 10),
                  const _Paragraph.rich([
                    TextSpan(
                      text:
                          'Pour les enquêtes administratives relatives au comportement d’un officier ou agent de police judiciaire dans l’exercice de ses fonctions, ',
                    ),
                  ]),
                  const _NotaBox(
                    title: 'Contrôle et enquêtes administratives',
                    bodySpans: [
                      TextSpan(
                        text:
                            'En matière de comportement professionnel des officiers ou agents de police judiciaire, ',
                      ),
                      TextSpan(
                        text: 'l’Article 15-2 du Code de Procédure Pénale',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextSpan(
                        text:
                            ' prévoit la participation de l’Inspection générale de la justice. Lorsque ces enquêtes sont ordonnées '
                            'par le garde des Sceaux, ministre de la Justice, elles sont dirigées par un magistrat.',
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const _Paragraph.rich([
                    TextSpan(
                      text:
                          'Le procureur général joue également un rôle de coordination à l’égard de certains officiers de police judiciaire dont la compétence territoriale '
                          'dépasse largement le ressort d’un seul tribunal judiciaire (chefs de directions zonales ou de services interdépartementaux de police judiciaire, '
                          'commandants régionaux de gendarmerie). Il veille à la cohérence de l’action et règle les difficultés éventuelles.',
                    ),
                  ]),
                  const SizedBox(height: 10),
                  const _Paragraph.rich([
                    TextSpan(
                      text:
                          'Les agents de police judiciaire sont eux aussi placés sous la surveillance du procureur général. '
                          'L’Article 75 du Code de Procédure Pénale précise que les enquêtes préliminaires relèvent de cette surveillance. '
                          'L’intervention du procureur général peut aller d’un simple avertissement signalé à la hiérarchie jusqu’à la saisine de la chambre de l’instruction, '
                          'en passant par la suspension ou le retrait d’habilitation lorsque les faits sont graves.',
                    ),
                  ]),
                ],
              ),

              const SizedBox(height: 18),

              // ==================== 1.2 HABILITATION OPJ ====================
              _ConditionCard(
                title: '1.2 L’habilitation des officiers de police judiciaire',
                cardColor: cardColor,
                accent: accent,
                titleColor: textMain,
                children: const [
                  _Paragraph.rich([
                    TextSpan(text: 'Aux termes de '),
                    TextSpan(
                      text: 'l’Article 16 alinéa 8 du Code de Procédure Pénale',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text:
                          ', les officiers de police judiciaire ne peuvent exercer effectivement les attributions attachées à leur qualité, '
                          'ni s’en prévaloir, que s’ils sont affectés à un emploi comportant cet exercice et en vertu d’une décision du procureur général les y habilitant personnellement.',
                    ),
                  ]),
                  SizedBox(height: 10),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'L’habilitation est délivrée par le procureur général près la cour d’appel dans le ressort de laquelle intervient la première affectation du fonctionnaire. '
                          'Elle est valable pour toute la durée de ses fonctions, y compris en cas de changement d’affectation. À chaque changement, le procureur général doit être informé, '
                          'et le dossier individuel de l’officier de police judiciaire est transféré au nouveau parquet général compétent.',
                    ),
                  ]),
                  SizedBox(height: 10),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'Chaque officier de police judiciaire fait l’objet d’un dossier individuel tenu au parquet général, justifié notamment par ',
                    ),
                    TextSpan(
                      text: 'l’Article 19-1 du Code de Procédure Pénale',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text:
                          ' et par les articles 226 et D. 44 à D. 44-5 du même code, qui encadrent la tenue et le suivi de ces dossiers.',
                    ),
                  ]),
                  SizedBox(height: 14),

                  _SubTitle(
                    '1.2.1 Les officiers de police judiciaire soumis à habilitation',
                  ),
                  _Paragraph.rich([
                    TextSpan(text: 'Sont soumis à l’habilitation :\n'),
                  ]),
                  _BulletPoint(
                    text:
                        'les inspecteurs généraux, sous-directeurs de police active, contrôleurs généraux, commissaires de police et officiers de police ;',
                  ),
                  _BulletPoint(
                    text:
                        'les officiers et gradés de la gendarmerie, ainsi que certains gendarmes désignés comme officiers de police judiciaire par arrêté conjoint du ministre de la Justice et du ministre de l’Intérieur ;',
                  ),
                  _BulletPoint(
                    text:
                        'les fonctionnaires du corps d’encadrement et d’application de la police nationale désignés comme officiers de police judiciaire par arrêté conjoint du ministre de la Justice et du ministre de l’Intérieur.',
                  ),
                  SizedBox(height: 8),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'Ces officiers doivent notamment justifier d’une expérience minimale (trente mois de services à compter du début de la formation initiale, dont au moins six mois dans un emploi comportant les attributions d’agent de police judiciaire) et être affectés dans des services déterminés par arrêté.',
                    ),
                  ]),
                  SizedBox(height: 10),

                  _SubTitle('1.2.2 Officiers non soumis à habilitation'),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'Certains officiers de police judiciaire peuvent exercer leurs fonctions du seul fait de leur qualité, sans habilitation du procureur général. Il s’agit notamment :\n',
                    ),
                  ]),
                  _BulletPoint(
                    text:
                        'des maires et de leurs adjoints, en particulier dans les communes rurales dépourvues d’autres officiers de police judiciaire (article C 45 de la circulaire générale) ;',
                  ),
                  _BulletPoint(
                    text:
                        'des directeurs ou sous-directeurs de la police judiciaire et de la gendarmerie, qui exercent par définition des fonctions de police judiciaire et commandent des fonctionnaires eux-mêmes officiers de police judiciaire.',
                  ),

                  SizedBox(height: 12),

                  _SubTitle('1.2.3 Le refus d’habilitation'),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'Lorsque le procureur général envisage de refuser l’habilitation, il informe l’intéressé, qui dispose d’un délai de quinze jours pour consulter son dossier et être entendu, avec l’assistance éventuelle d’un conseil. '
                          'Le refus prend la forme d’un arrêté motivé. Il peut être fondé non seulement sur l’absence d’affectation dans un emploi comportant l’exercice effectif des attributions d’officier de police judiciaire, '
                          'mais aussi sur le contenu du dossier individuel de l’intéressé, le refus prenant alors la forme d’une mesure à caractère disciplinaire préventif.\n\n'
                          'Ces modalités sont notamment encadrées par les articles R. 15-5 et R. 15-6-6 du Code de Procédure Pénale.',
                    ),
                  ]),

                  SizedBox(height: 12),

                  _SubTitle('1.2.4 Suspension ou retrait d’habilitation'),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'Le procureur général, compétent pour accorder l’habilitation, peut également en prononcer la suspension (pour une durée maximale de deux ans) ou le retrait définitif. '
                          'La sanction est prise par arrêté, soit d’office, soit sur proposition du chef de service.\n\n'
                          'Avant toute décision, l’officier de police judiciaire doit être entendu, mis en mesure de prendre connaissance de son dossier et peut se faire assister d’un conseil. '
                          'En cas de suspension, l’officier de police judiciaire retrouve automatiquement ses attributions à l’expiration de la sanction, sauf réduction de la durée par le procureur général. '
                          'En cas de retrait, une nouvelle habilitation ne peut être accordée que dans les formes prévues pour une première habilitation.\n\n'
                          'Les Articles R. 15-6 et R. 15-6-5 du Code de Procédure Pénale encadrent ces mesures.',
                    ),
                  ]),
                  SizedBox(height: 10),
                  _NotaBox(
                    title: 'Voies de recours',
                    bodySpans: [
                      TextSpan(
                        text:
                            'Les décisions de suspension ou de retrait d’habilitation peuvent faire l’objet :\n'
                            ' • d’un recours gracieux devant le procureur général, dans le délai d’un mois à compter de la notification de la décision ;\n'
                            ' • d’un recours contentieux devant une commission spéciale de la Cour de cassation, dans le mois suivant le rejet explicite ou implicite du recours gracieux.\n\n',
                      ),
                      TextSpan(
                        text: 'L’Article 16-1 du Code de Procédure Pénale',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextSpan(text: ' et '),
                      TextSpan(
                        text: 'l’Article 16-2 du Code de Procédure Pénale',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextSpan(
                        text:
                            ' précisent ces voies de recours et les pouvoirs de la commission, qui peut confirmer, annuler, ou transformer la mesure.',
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // ==================== 1.3 ÉVALUATION / NOTATION ===============
              _ConditionCard(
                title:
                    '1.3 Évaluation et notation des officiers de police judiciaire',
                cardColor: cardColor,
                accent: accent,
                titleColor: textMain,
                children: const [
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'L’évaluation et la notation participent à l’effectivité du contrôle exercé par le procureur général sur la police judiciaire. ',
                    ),
                    TextSpan(
                      text: 'L’Article R. 2-17-1 du Code de Procédure Pénale',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text:
                          ' prévoit que le procureur général adresse chaque année à l’autorité investie du pouvoir de nomination une appréciation sur l’action des directeurs zonaux de la police nationale en matière de police judiciaire.',
                    ),
                  ]),
                  SizedBox(height: 10),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'S’agissant des officiers de police judiciaire habilités, ',
                    ),
                    TextSpan(
                      text: 'l’Article 19-1 du Code de Procédure Pénale',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text:
                          ' dispose que leur notation par le procureur général est prise en compte pour toute décision d’avancement. Un dossier individuel est tenu pour chacun d’eux au parquet général.',
                    ),
                  ]),
                  SizedBox(height: 10),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'Tous les deux ans, le procureur de la République établit, après consultation des magistrats concernés (juges d’instruction, juges des enfants, présidents de chambres correctionnelles…), une proposition de notation pour les officiers de police judiciaire affectés dans son ressort. '
                          'Cette proposition est transmise au procureur général près la cour d’appel, qui arrête la notation définitive, après avoir, le cas échéant, recueilli l’avis d’autres procureurs généraux lorsque la compétence territoriale du service dépasse le ressort de la cour d’appel (Article D. 44-2 du Code de Procédure Pénale).',
                    ),
                  ]),
                  SizedBox(height: 10),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'L’imprimé de notation comporte une appréciation générale circonstanciée et une note chiffrée de 0 à 10. Huit critères de notation, énumérés à l’Article D. 44-3 du Code de Procédure Pénale, servent de base à cette évaluation. '
                          'Lorsque l’un des critères n’a pas pu être observé, la mention « activité judiciaire non observée » se substitue à la note chiffrée et à l’appréciation correspondante.',
                    ),
                  ]),
                  SizedBox(height: 10),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'La notation établie par le procureur général est notifiée personnellement à l’officier de police judiciaire, sous pli fermé, par l’intermédiaire de son chef de service. '
                          'L’intéressé peut présenter des observations écrites dans un délai de quinze jours. À l’issue de ce délai, la notation définitive est transmise à l’autorité administrative ou militaire chargée des propositions d’avancement, conformément à ',
                    ),
                    TextSpan(
                      text: 'l’Article D. 44-4 du Code de Procédure Pénale',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(text: '.'),
                  ]),
                ],
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
