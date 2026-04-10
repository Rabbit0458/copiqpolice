import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// ===================================================================
///  COP'IQ — LES RECOURS JURIDICTIONNELS
///
///  Page d’étude complète inspirée du polycopié :
///
///   CHAPITRE 1 : RECOURS DEVANT LES JURIDICTIONS JUDICIAIRES
///     - Répression pénale des atteintes aux libertés
///     - Sanction des actes administratifs illégaux
///
///   CHAPITRE 2 : RECOURS DEVANT LES JURIDICTIONS ADMINISTRATIVES
///     - Recours en indemnité
///     - Recours pour excès de pouvoir
///     - Responsabilité de l’État du fait des lois
///
/// ===================================================================
class RecoursJuridictionnelsPage extends StatelessWidget {
  const RecoursJuridictionnelsPage({super.key});

  static const String routeName =
      '/gpx/generalites/libertes_publiques/garanties/recours_juridictionnels';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    final Color background = isDark ? const Color(0xFF121212) : Colors.white;
    final Color cardColor = isDark
        ? const Color(0xFF1E1E1E)
        : const Color(0xFFF7F7F7);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF050505);
    final Color textColor = isDark
        ? Colors.white70
        : const Color(0xFF1F1F1F).withOpacity(.92);
    final Color accentColor = isDark
        ? const Color(0xFF2E7D32)
        : const Color(0xFF1B5E20);
    final Color referenceColor = isDark
        ? const Color(0xFF81C784)
        : const Color(0xFF2E7D32);

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: titleColor),
        ),
        title: Text(
          'Les recours juridictionnels',
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: titleColor,
          ),
        ),
      ),

      // ===================== CONTENU =====================
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
        physics: const BouncingScrollPhysics(),
        children: [
          // ================= TITRE + INTRO =================
          Text(
            'Les recours juridictionnels',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 20,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 6),
          _Paragraph.rich([
            const TextSpan(
              text:
                  'Les recours juridictionnels sont les moyens mis à la disposition des individus '
                  'pour contester l’activité des gouvernants et faire sanctionner les atteintes '
                  'aux libertés publiques devant un juge. Ils permettent de passer d’une '
                  'atteinte ressentie à une décision de justice, fondée sur le droit.\n\n',
            ),
            TextSpan(
              text:
                  'Pour un policier, connaître ces recours, c’est comprendre comment ses propres '
                  'actes pourront être contrôlés a posteriori (pénalement, civilement ou '
                  'administrativement).',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: referenceColor,
              ),
            ),
          ]),
          const SizedBox(height: 18),

          _NotaBox(
            title: 'Définition doctrinale',
            bodySpans: [
              TextSpan(
                text:
                    'Les recours juridictionnels sont « des moyens mis à la disposition des individus '
                    'pour présenter leurs réclamations contre l’activité des gouvernants, sur la base '
                    'du respect de la règle de droit qu’ils prétendent violée, devant les autorités '
                    'chargées de la fonction juridictionnelle ». (Professeur C.A. Colliard)',
              ),
            ],
          ),
          const SizedBox(height: 20),

          // =====================================================
          // CHAPITRE 1 — RECOURS DEVANT LES JURIDICTIONS JUDICIAIRES
          // =====================================================
          _HypoCard(
            title:
                'Chapitre 1 — Les recours devant les juridictions judiciaires',
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              _Paragraph(
                'Les juridictions judiciaires (pénales et civiles) interviennent principalement '
                'pour sanctionner les atteintes aux libertés commises par des particuliers '
                'ou par l’administration lorsqu’elle agit comme toute personne privée.',
              ),
              const SizedBox(height: 14),

              // -------------------- 1.1 Répression pénale --------------------
              Text(
                '1.1 — La répression des infractions pénales',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Lorsque l’atteinte à une liberté constitue une infraction prévue et réprimée '
                      'par le Code pénal (ou un texte spécial), la victime peut saisir le juge pénal. '
                      'L’article ',
                ),
                TextSpan(
                  text: '431-1 du Code pénal',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: referenceColor,
                  ),
                ),
                const TextSpan(
                  text:
                      ' incrimine par exemple le fait d’entraver, de manière concertée et à l’aide de '
                      'menaces, l’exercice de certaines libertés (expression, travail, association, '
                      'réunion ou manifestation, fonctionnement d’une assemblée élue…)',
                ),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Les faits d’entrave ne sont pénalement sanctionnés que lorsqu’ils acquièrent '
                      'une dimension collective et organisée ;',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'La responsabilité est individuelle : chaque auteur ou complice peut être poursuivi '
                      'et condamné ;',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'La victime peut, devant la juridiction pénale, obtenir des dommages-intérêts '
                      'en réparation de son préjudice (ex. atteinte à la vie privée).',
                ),
              ]),
              const SizedBox(height: 10),
              const _ExempleBox(
                title: 'Illustration',
                bodySpans: [
                  TextSpan(
                    text:
                        'Des manifestants bloquent, sous la menace, l’accès d’un établissement scolaire, '
                        'empêchant les élèves d’entrer. Les organisateurs peuvent être poursuivis pour '
                        'entrave à la liberté d’enseignement sur le fondement de l’article 431-1.',
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // -------------------- 1.2 Sanction actes admin illégaux --------------------
              Text(
                '1.2 — La sanction des actes administratifs illégaux',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              _Paragraph(
                'Dans certains cas, un acte administratif illégal portant atteinte aux libertés '
                'peut être contesté devant le juge judiciaire. Le polycopié distingue trois '
                'hypothèses principales.',
              ),
              const SizedBox(height: 10),

              // 1.2.1 Exception d’illégalité
              Text(
                '1.2.1 — L’exception d’illégalité',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 4),
              _Paragraph(
                'Il s’agit d’un moyen de défense soulevé devant le juge pénal pour neutraliser '
                'les effets individuels d’un acte réglementaire illégal (par exemple un arrêté '
                'interdisant abusivement une manifestation). L’acte n’est pas annulé, mais le juge '
                'refuse de l’appliquer au litige dont il est saisi.',
              ),
              const SizedBox(height: 10),

              // 1.2.2 Atteinte à la propriété privée
              Text(
                '1.2.2 — L’atteinte à la propriété privée',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 4),
              _Paragraph(
                'Lorsque l’administration porte atteinte à la propriété privée dans un but d’utilité '
                'publique, l’atteinte doit reposer sur une base légale (expropriation) et respecter '
                'les garanties prévues par les textes. Deux grandes figures sont étudiées :',
              ),
              const SizedBox(height: 6),
              const _BulletPoint.rich([
                TextSpan(
                  text: 'L’expropriation pour cause d’utilité publique : ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      'procédure encadrée qui peut aboutir à la dépossession forcée d’un bien, avec '
                      'indemnisation intégrale et préalable de l’intéressé.',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text: 'L’emprise irrégulière : ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      'prise de possession d’un bien par l’administration en dehors des conditions '
                      'légales. Le juge judiciaire, gardien de la propriété privée, contrôle la '
                      'légalité de l’emprise et fixe l’indemnisation due à la victime.',
                ),
              ]),
              const SizedBox(height: 10),

              // 1.2.3 Voie de fait
              Text(
                '1.2.3 — La voie de fait',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 4),
              _Paragraph(
                'La voie de fait est une atteinte particulièrement grave portée par '
                'l’administration à une liberté fondamentale ou à la propriété, par un acte '
                'manifestement insusceptible de se rattacher à un pouvoir administratif '
                '(ex. violences injustifiées, rétention illégale de passeport…).\n\n'
                'Dans cette hypothèse exceptionnelle, le juge judiciaire redevient compétent pour '
                'ordonner la cessation de l’atteinte et indemniser la victime.',
              ),
            ],
          ),

          const SizedBox(height: 26),

          // =====================================================
          // CHAPITRE 2 — RECOURS DEVANT LES JURIDICTIONS ADMINISTRATIVES
          // =====================================================
          _HypoCard(
            title:
                'Chapitre 2 — Les recours devant les juridictions administratives',
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              _Paragraph(
                'Les juridictions administratives contrôlent la légalité de l’action de '
                'l’administration et réparent, le cas échéant, les dommages qu’elle cause. '
                'Ce sont elles qui se prononcent le plus fréquemment sur les atteintes '
                'aux libertés publiques imputables aux autorités de police.',
              ),
              const SizedBox(height: 14),

              // -------------------- 2.1 Recours en indemnité --------------------
              Text(
                '2.1 — Le recours en indemnité',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              _Paragraph(
                'Il vise à obtenir réparation d’un dommage causé par un acte administratif '
                'illégal ou par le fonctionnement défectueux d’un service public. On parle de '
                'recours de pleine juridiction : le juge peut condamner l’administration à '
                'verser une indemnité, tout en laissant subsister l’acte à l’origine du dommage.',
              ),
              const SizedBox(height: 8),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Délai de droit commun : deux mois à compter de la décision explicite ou de sa notification ;',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Peut viser aussi bien un comportement fautif (ex. usage disproportionné de la force) '
                      'qu’une illégalité d’un acte de police.',
                ),
              ]),
              const SizedBox(height: 14),

              // -------------------- 2.2 Recours pour excès de pouvoir --------------------
              Text(
                '2.2 — Le recours pour excès de pouvoir',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Recours « objectif », largement ouvert, qui poursuit un but : l’annulation d’un acte administratif illégal. '
                      'L’acte annulé est réputé n’avoir jamais existé (effet ',
                ),
                TextSpan(
                  text: 'erga omnes',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: referenceColor,
                  ),
                ),
                const TextSpan(
                  text:
                      '). Le requérant doit seulement justifier d’un intérêt à agir.\n\n'
                      'L’illégalité de l’acte peut résulter notamment :',
                ),
              ]),
              const SizedBox(height: 6),
              const _BulletPoint.rich([
                TextSpan(text: 'De l’incompétence de l’auteur de l’acte ;'),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Du non-respect des règles de forme ou de procédure (signature, publication…) ;',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'De la violation de la loi (arrêté contraire à une norme supérieure) ;',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Du détournement de pouvoir (but de l’acte étranger à l’intérêt général).',
                ),
              ]),
              const SizedBox(height: 10),

              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Lorsque l’acte contesté restreint ou interdit une liberté publique, le juge '
                      'administratif exerce un contrôle particulièrement exigeant, fondé sur trois règles '
                      'célèbres dégagées notamment par l’arrêt ',
                ),
                TextSpan(
                  text: 'CE, 19 mai 1933, Benjamin',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: referenceColor,
                  ),
                ),
                const TextSpan(text: ' :'),
              ]),
              const SizedBox(height: 6),
              const _BulletPoint.rich([
                TextSpan(
                  text: '1ʳᵉ règle – Libre choix des moyens : ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      'l’administration dispose d’une marge d’appréciation pour maintenir l’ordre, '
                      'mais elle doit éviter de recourir à des moyens manifestement excessifs (ex. '
                      'interdiction générale d’une manifestation alors que des mesures moins '
                      'restrictives suffiraient).',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text: '2ᵉ règle – Nécessité : ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      'la mesure de police doit être indispensable au maintien de l’ordre public. '
                      'Si d’autres moyens moins attentatoires aux libertés existent, la mesure est '
                      'illégale.',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text: '3ᵉ règle – Proportionnalité : ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      'l’atteinte portée à la liberté doit être strictement proportionnée à la '
                      'gravité du risque. Une interdiction totale et définitive d’une activité '
                      'peut ainsi être jugée excessive.',
                ),
              ]),
              const SizedBox(height: 12),
              const _NotaBox(
                title: 'Conséquence pratique',
                bodySpans: [
                  TextSpan(
                    text:
                        'Un arrêté municipal ou préfectoral portant sur les libertés (réunion, '
                        'manifestation, circulation…) doit toujours être motivé, limité dans le temps '
                        'et adapté au contexte. En cas d’illégalité, le juge peut l’annuler en urgence '
                        '(référé-liberté).',
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // -------------------- 2.3 Responsabilité de l’État du fait des lois --------------------
              Text(
                '2.3 — La responsabilité de l’État du fait des lois',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'En principe, un justiciable ne peut pas obtenir l’annulation d’une loi qui limite '
                      'une liberté publique : le juge administratif n’est pas juge de la constitutionnalité '
                      'des lois (sauf QPC relevant du Conseil constitutionnel). En revanche, il peut, à titre '
                      'exceptionnel, engager la responsabilité de l’État pour le préjudice causé par une loi, '
                      'dans la lignée de la célèbre décision ',
                ),
                TextSpan(
                  text:
                      'CE, 14 janv. 1938, Société des produits laitiers « La Fleurette »',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: referenceColor,
                  ),
                ),
                const TextSpan(text: '.'),
              ]),
              const SizedBox(height: 6),
              _Paragraph(
                'La réparation est subordonnée à trois conditions cumulatives :',
              ),
              const SizedBox(height: 6),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Le préjudice doit résulter de la suppression d’une activité licite et non frauduleuse ;',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Le préjudice doit être spécial et anormal pour le requérant ;',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Le législateur ne doit pas avoir entendu exclure toute indemnisation dans le texte de loi.',
                ),
              ]),
              const SizedBox(height: 8),
              const _ExempleBox(
                title: 'À retenir',
                bodySpans: [
                  TextSpan(
                    text:
                        'Même une loi votée par le Parlement peut, dans des cas exceptionnels, '
                        'engager la responsabilité de l’État lorsqu’elle porte une atteinte '
                        'disproportionnée à certaines libertés ou intérêts individuels.',
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
/// CARTE DE CONTENU (bloc structuré)
/// ------------------------------------------------------------------
class _HypoCard extends StatelessWidget {
  const _HypoCard({
    required this.title,
    required this.cardColor,
    required this.accent,
    required this.titleColor,
    required this.textColor,
    required this.children,
  });

  final String title;
  final Color cardColor;
  final Color accent;
  final Color titleColor;
  final Color textColor;
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
/// PARAGRAPHES (texte simple ou riche)
/// ------------------------------------------------------------------
class _Paragraph extends StatelessWidget {
  const _Paragraph(this.text) : spans = null;
  const _Paragraph.rich(this.spans) : text = null;

  final String? text;
  final List<TextSpan>? spans;

  @override
  Widget build(BuildContext context) {
    final bool isRich = spans != null;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
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
/// PUCE (liste à points)
/// ------------------------------------------------------------------
class _BulletPoint extends StatelessWidget {
  const _BulletPoint.rich(this.spans, {super.key});

  final List<InlineSpan> spans;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color color = isDark ? Colors.white70 : const Color(0xFF1F1F1F);

    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• ', style: TextStyle(fontSize: 15, height: 1.4, color: color)),
          Expanded(
            child: Text.rich(
              TextSpan(
                style: TextStyle(fontSize: 14, height: 1.35, color: color),
                children: spans,
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
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color borderColor = isDark
        ? const Color(0xFF66BB6A)
        : const Color(0xFF2E7D32);
    final Color bgColor = isDark
        ? const Color(0xFF0B2512)
        : const Color(0xFFE8F5E9);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF1B5E20);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor.withOpacity(isDark ? .70 : .95),
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
/// BLOC NOTA
/// ------------------------------------------------------------------
class _NotaBox extends StatelessWidget {
  const _NotaBox({required this.bodySpans, this.title = 'NOTA'});

  final List<TextSpan> bodySpans;
  final String title;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
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
