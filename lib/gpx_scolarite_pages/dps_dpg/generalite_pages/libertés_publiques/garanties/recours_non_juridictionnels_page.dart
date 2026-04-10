import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// ===================================================================
///  COP'IQ — RECOURS NON JURIDICTIONNELS
///
///  Synthèse complète des mécanismes de protection hors juge :
///   • Recours gracieux et hiérarchique (administration)
///   • Recours à caractère politique (pétition, objection de conscience,
///     résistance à l’oppression)
///   • Défenseur des droits
///   • Contrôleur général des lieux de privation de liberté
/// ===================================================================
class RecoursNonJuridictionnelsPage extends StatelessWidget {
  const RecoursNonJuridictionnelsPage({super.key});

  static const String routeName =
      '/gpx/generalites/libertes_publiques/garanties/recours_non_juridictionnels';

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
        ? const Color(0xFF00796B)
        : const Color(0xFF00695C);
    final Color referenceColor = isDark
        ? const Color(0xFF80CBC4)
        : const Color(0xFF00897B);

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
          'Les recours non juridictionnels',
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
            'Les recours non juridictionnels',
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
                  'À côté des recours devant les tribunaux, le droit français offre toute une série de moyens de contestation ou de protection des libertés publiques sans passer immédiatement par un juge. ',
            ),
            TextSpan(
              text:
                  'Ces recours non juridictionnels sont essentiels dans la pratique policière : ils permettent aux citoyens d’alerter l’administration, '
                  'de faire corriger une décision, ou de signaler des atteintes graves aux droits fondamentaux.',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: referenceColor,
              ),
            ),
          ]),
          const SizedBox(height: 16),
          const _NotaBox(
            title: 'Panorama',
            bodySpans: [
              TextSpan(
                text:
                    'On distingue notamment : les recours administratifs (gracieux et hiérarchique), '
                    'les recours à caractère politique (pétition, refus d’obéissance, résistance à l’oppression) '
                    'et l’intervention d’autorités indépendantes spécialisées : Défenseur des droits et Contrôleur général des lieux de privation de liberté.',
              ),
            ],
          ),
          const SizedBox(height: 22),

          // =====================================================
          // CHAPITRE 1 — RECOURS À CARACTÈRE ADMINISTRATIF
          // =====================================================
          _HypoCard(
            title: 'Chapitre 1 — Les recours à caractère administratif',
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: const [
              _Paragraph(
                'Ces recours sont exercés directement devant l’administration, avant toute saisine d’une juridiction. '
                'Ils permettent de demander à l’auteur d’un acte administratif, ou à son supérieur, de revenir sur sa décision. '
                'Ils sont très présents dans le quotidien des services de police (contestation d’une décision, d’une sanction, d’un refus, etc.).',
              ),
              SizedBox(height: 10),
              Text(
                '1.1 — Le recours gracieux',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
              ),
              SizedBox(height: 4),
              _BulletPoint.rich([
                TextSpan(
                  text:
                      'Il s’agit d’une réclamation adressée directement à l’auteur de l’acte administratif contesté (préfet, maire, chef de service…). ',
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text:
                      'La personne expose les conséquences de la décision et demande sa révision, son retrait ou sa modification. ',
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text:
                      'Le recours peut être fondé sur des arguments de droit (illégalité) ou d’opportunité (inadaptation de la mesure aux circonstances).',
                ),
              ]),
              SizedBox(height: 10),
              Text(
                '1.2 — Le recours hiérarchique',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
              ),
              SizedBox(height: 4),
              _Paragraph(
                'Dans ce cas, le recours est adressé non plus à l’auteur de la décision, '
                'mais à son supérieur hiérarchique (directeur, préfet, ministre…). Le supérieur peut confirmer, modifier ou annuler l’acte. '
                'La nature du recours reste similaire au recours gracieux : expliciter les conséquences de l’acte et demander sa révision.',
              ),
            ],
          ),

          const SizedBox(height: 24),

          // =====================================================
          // CHAPITRE 2 — RECOURS À CARACTÈRE POLITIQUE
          // =====================================================
          _HypoCard(
            title: 'Chapitre 2 — Les recours à caractère politique',
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              const _Paragraph(
                'Certains moyens de contestation ne visent pas directement une décision administrative précise, '
                'mais permettent d’exprimer une opposition politique ou de conscience face à l’action de l’État.',
              ),
              const SizedBox(height: 8),
              Text(
                '2.1 — Le droit de pétition',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 4),
              const _Paragraph(
                'Il s’agit, pour les citoyens, d’adresser une demande ou une protestation à une autorité publique sous forme de pétition individuelle ou collective. '
                'Ce moyen de pression a aujourd’hui perdu de son importance pratique, mais il demeure une expression symbolique de la participation citoyenne.',
              ),
              const SizedBox(height: 8),
              Text(
                '2.2 — Le refus d’obéissance / l’objection de conscience',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 4),
              const _Paragraph.rich([
                TextSpan(
                  text:
                      'Ce recours concerne principalement les objecteurs de conscience. L’',
                ),
                TextSpan(
                  text: 'objection de conscience',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      ' se traduit par le refus d’accomplir un service militaire armé pour des motifs religieux, philosophiques ou moraux. '
                      'Le régime juridique a prévu des formes de dispense ou de service national civil équivalent.',
                ),
              ]),
              const SizedBox(height: 8),
              Text(
                '2.3 — La résistance à l’oppression',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 4),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Mentionnée à l’article 2 de la Déclaration de 1789, la résistance à l’oppression est à la fois un droit et parfois présentée comme un devoir. '
                      'Elle vise les situations où un gouvernement exerce un pouvoir manifestement contraire aux droits fondamentaux. ',
                ),
                TextSpan(
                  text:
                      'Pour un policier, cette notion rappelle que l’obéissance hiérarchique ne justifie jamais l’exécution d’un ordre manifestement illégal et gravement attentatoire aux libertés.',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: referenceColor,
                  ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 24),

          // =====================================================
          // CHAPITRE 3 — LE DÉFENSEUR DES DROITS
          // =====================================================
          _HypoCard(
            title: 'Chapitre 3 — Le Défenseur des droits',
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Le Défenseur des droits est une autorité constitutionnelle indépendante, chargée de veiller au respect des droits et libertés par toute personne publique ou privée. ',
                ),
                TextSpan(
                  text:
                      'Il constitue un acteur central de la protection non juridictionnelle des libertés publiques.',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: referenceColor,
                  ),
                ),
              ]),
              const SizedBox(height: 10),
              Text(
                '3.1 — Missions principales',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 4),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Défendre les droits et libertés dans le cadre des relations avec les services publics ;',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Protéger et promouvoir les droits de l’enfant et l’intérêt supérieur de ce dernier ;',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Lutter contre les discriminations et promouvoir l’égalité ;',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Veiller au respect de la déontologie par les personnes exerçant des activités de sécurité (art. L. 142-1 du C.S.I.) ;',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Informer, conseiller et orienter les personnes, notamment les lanceurs d’alerte, vers les autorités compétentes.',
                ),
              ]),
              const SizedBox(height: 10),
              Text(
                '3.2 — Organisation et nomination',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 4),
              const _Paragraph(
                'Le Défenseur des droits est nommé par le Président de la République pour un mandat de six ans, non renouvelable. '
                'Il est assisté de quatre adjoints, chacun compétent dans un domaine spécifique (droits de l’enfant, déontologie de la sécurité, lutte contre les discriminations, protection des lanceurs d’alerte).',
              ),
              const SizedBox(height: 10),
              Text(
                '3.3 — Saisine et pouvoirs',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 4),
              const _Paragraph.rich([
                TextSpan(
                  text:
                      'Le Défenseur des droits peut être saisi gratuitement par toute personne physique ou morale estimant que ses droits ne sont pas respectés, '
                      'ou se saisir d’office dans certaines situations. Il peut demander communication de pièces, formuler des recommandations, proposer des sanctions disciplinaires, '
                      'et, dans certains cas, intervenir devant le juge pour présenter des observations. ',
                ),
              ]),
              const SizedBox(height: 6),
              const _ExempleBox(
                title: 'Intérêt pour le policier',
                bodySpans: [
                  TextSpan(
                    text:
                        'Un citoyen s’estimant victime d’une discrimination dans le cadre d’un contrôle d’identité ou d’une procédure peut saisir le Défenseur des droits. '
                        'Les policiers doivent donc connaître cette institution, répondre à ses demandes d’explications et intégrer ses recommandations dans leur pratique professionnelle.',
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const _Paragraph(
                'Chaque année, le Défenseur des droits remet un rapport public d’activité au Président de la République et au Parlement, '
                'mettant en lumière les évolutions et les difficultés en matière de respect des droits fondamentaux.',
              ),
            ],
          ),

          const SizedBox(height: 24),

          // =====================================================
          // CHAPITRE 4 — CONTRÔLEUR GÉNÉRAL DES LIEUX DE PRIVATION
          // =====================================================
          _HypoCard(
            title:
                'Chapitre 4 — Le Contrôleur général des lieux de privation de liberté',
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              const _Paragraph.rich([
                TextSpan(
                  text:
                      'Institué par la loi du 30 octobre 2007, le Contrôleur général des lieux de privation de liberté est une autorité indépendante chargée de vérifier les conditions de prise en charge '
                      'et de transfert des personnes privées de liberté (locaux de garde à vue, centres de rétention, établissements pénitentiaires, hôpitaux psychiatriques, etc.). ',
                ),
              ]),
              const SizedBox(height: 8),
              Text(
                '4.1 — Champ de compétence',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 4),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Toute personne détenue ou toute personne morale peut informer directement le Contrôleur général de faits susceptibles de relever de sa compétence ;',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Le Contrôleur peut aussi être saisi par le Premier ministre, les membres du Gouvernement, les parlementaires, le Parlement européen ou le Défenseur des droits ;',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Il peut enfin se saisir d’office lorsqu’il estime nécessaire de vérifier une situation.',
                ),
              ]),
              const SizedBox(height: 8),
              Text(
                '4.2 — Pouvoirs d’enquête et garanties',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 4),
              const _Paragraph(
                'Le Contrôleur général peut visiter à tout moment tout lieu de privation de liberté sur le territoire de la République. '
                'Il peut demander toute information utile, sauf lorsqu’elle est couverte par certains secrets particulièrement protégés (défense nationale, secret de l’enquête ou de l’instruction, secret médical ou professionnel). '
                'Il peut s’entretenir de façon confidentielle avec toute personne dont le concours lui paraît nécessaire.',
              ),
              const SizedBox(height: 8),
              const _Paragraph(
                'En cas d’atteinte grave aux droits fondamentaux, il adresse sans délai ses observations aux autorités compétentes. '
                'Il peut informer le procureur de la République en cas d’infraction pénale et signaler les faits susceptibles d’entraîner des sanctions disciplinaires.',
              ),
              const SizedBox(height: 8),
              const _ExempleBox(
                title: 'Concrètement',
                bodySpans: [
                  TextSpan(
                    text:
                        'À l’issue d’une visite de commissariat ou de local de garde à vue, le Contrôleur général formule des recommandations précises concernant les conditions matérielles, '
                        'le respect de la dignité des personnes retenues, l’accès aux droits (avocat, médecin, famille, etc.). Ces recommandations peuvent conduire à des réaménagements importants des pratiques policières.',
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const _Paragraph(
                'Le Contrôleur général remet un rapport annuel d’activité rendu public et adressé au Président de la République et au Parlement. '
                'Il est assisté de contrôleurs dont les modalités d’intervention sont fixées par décret.',
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
        child: DefaultTextStyle(
          style: GoogleFonts.fustat(
            fontSize: 14,
            height: 1.4,
            color: textColor,
          ),
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
      padding: const EdgeInsets.only(left: 4, bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('✓ ', style: TextStyle(fontSize: 15, height: 1.4, color: color)),
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
        ? const Color(0xFF26A69A)
        : const Color(0xFF00897B);
    final Color bgColor = isDark
        ? const Color(0xFF00332C)
        : const Color(0xFFE0F2F1);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF004D40);

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
/// BLOC NOTA / MISE EN GARDE
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
