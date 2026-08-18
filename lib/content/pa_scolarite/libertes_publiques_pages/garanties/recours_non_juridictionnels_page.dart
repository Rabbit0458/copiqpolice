import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

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
class PaRecoursNonJuridictionnelsPage extends StatelessWidget {
  const PaRecoursNonJuridictionnelsPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/libertes_publiques/garanties/recours_non_juridictionnels';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    final Color background = isDark ? const Color(0xFF121212) : Colors.white;
    final Color cardColor = isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF7F7F7);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF5D4037);
    final Color textColor = isDark ? Colors.white70 : const Color(0xFF424242);
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
          ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/recours_non_juridictionnels_page.dart", "f00001", 'Les recours non juridictionnels'),
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
            ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/recours_non_juridictionnels_page.dart", "f00002", 'Les recours non juridictionnels'),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 20,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 6),
          _Paragraph.rich([
             TextSpan(
              text:
                  ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/recours_non_juridictionnels_page.dart", "f00003", 'À côté des recours devant les tribunaux, le droit français offre toute une série de moyens de contestation ou de protection des libertés publiques sans passer immédiatement par un juge. '),
            ),
            TextSpan(
              text:
                  ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/recours_non_juridictionnels_page.dart", "f00004", 'Ces recours non juridictionnels sont essentiels dans la pratique policière : ils permettent aux citoyens d’alerter l’administration, ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/recours_non_juridictionnels_page.dart", "f00005", 'de faire corriger une décision, ou de signaler des atteintes graves aux droits fondamentaux.'),
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: referenceColor,
              ),
            ),
          ]),
          const SizedBox(height: 16),
           _NotaBox(
            title: 'Panorama',
            bodySpans: [
              TextSpan(
                text:
                    ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/recours_non_juridictionnels_page.dart", "f00006", 'On distingue notamment : les recours administratifs (gracieux et hiérarchique), ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/recours_non_juridictionnels_page.dart", "f00007", 'les recours à caractère politique (pétition, refus d’obéissance, résistance à l’oppression) ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/recours_non_juridictionnels_page.dart", "f00008", 'et l’intervention d’autorités indépendantes spécialisées : Défenseur des droits et Contrôleur général des lieux de privation de liberté.'),
              ),
            ],
          ),
          const SizedBox(height: 22),

          // =====================================================
          // CHAPITRE 1 — RECOURS À CARACTÈRE ADMINISTRATIF
          // =====================================================
          _HypoCard(
            title: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/recours_non_juridictionnels_page.dart", "f00009", 'Chapitre 1 — Les recours à caractère administratif'),
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children:  [
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/recours_non_juridictionnels_page.dart", "f00010", 'Ces recours sont exercés directement devant l’administration, avant toute saisine d’une juridiction. ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/recours_non_juridictionnels_page.dart", "f00011", 'Ils permettent de demander à l’auteur d’un acte administratif, ou à son supérieur, de revenir sur sa décision. ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/recours_non_juridictionnels_page.dart", "f00012", 'Ils sont très présents dans le quotidien des services de police (contestation d’une décision, d’une sanction, d’un refus, etc.).'),
              ),
              SizedBox(height: 10),
              Text(
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/recours_non_juridictionnels_page.dart", "f00013", '1.1 — Le recours gracieux'),
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
              ),
              SizedBox(height: 4),
              _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/recours_non_juridictionnels_page.dart", "f00014", 'Il s’agit d’une réclamation adressée directement à l’auteur de l’acte administratif contesté (préfet, maire, chef de service…). '),
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/recours_non_juridictionnels_page.dart", "f00015", 'La personne expose les conséquences de la décision et demande sa révision, son retrait ou sa modification. '),
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/recours_non_juridictionnels_page.dart", "f00016", 'Le recours peut être fondé sur des arguments de droit (illégalité) ou d’opportunité (inadaptation de la mesure aux circonstances).'),
                ),
              ]),
              SizedBox(height: 10),
              Text(
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/recours_non_juridictionnels_page.dart", "f00017", '1.2 — Le recours hiérarchique'),
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
              ),
              SizedBox(height: 4),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/recours_non_juridictionnels_page.dart", "f00018", 'Dans ce cas, le recours est adressé non plus à l’auteur de la décision, ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/recours_non_juridictionnels_page.dart", "f00019", 'mais à son supérieur hiérarchique (directeur, préfet, ministre…). Le supérieur peut confirmer, modifier ou annuler l’acte. ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/recours_non_juridictionnels_page.dart", "f00020", 'La nature du recours reste similaire au recours gracieux : expliciter les conséquences de l’acte et demander sa révision.'),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // =====================================================
          // CHAPITRE 2 — RECOURS À CARACTÈRE POLITIQUE
          // =====================================================
          _HypoCard(
            title: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/recours_non_juridictionnels_page.dart", "f00021", 'Chapitre 2 — Les recours à caractère politique'),
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
               _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/recours_non_juridictionnels_page.dart", "f00022", 'Certains moyens de contestation ne visent pas directement une décision administrative précise, ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/recours_non_juridictionnels_page.dart", "f00023", 'mais permettent d’exprimer une opposition politique ou de conscience face à l’action de l’État.'),
              ),
              const SizedBox(height: 8),
              Text(
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/recours_non_juridictionnels_page.dart", "f00024", '2.1 — Le droit de pétition'),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 4),
               _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/recours_non_juridictionnels_page.dart", "f00025", 'Il s’agit, pour les citoyens, d’adresser une demande ou une protestation à une autorité publique sous forme de pétition individuelle ou collective. ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/recours_non_juridictionnels_page.dart", "f00026", 'Ce moyen de pression a aujourd’hui perdu de son importance pratique, mais il demeure une expression symbolique de la participation citoyenne.'),
              ),
              const SizedBox(height: 8),
              Text(
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/recours_non_juridictionnels_page.dart", "f00027", '2.2 — Le refus d’obéissance / l’objection de conscience'),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 4),
               _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/recours_non_juridictionnels_page.dart", "f00028", 'Ce recours concerne principalement les objecteurs de conscience. L’'),
                ),
                TextSpan(
                  text: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/recours_non_juridictionnels_page.dart", "f00029", 'objection de conscience'),
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/recours_non_juridictionnels_page.dart", "f00030", ' se traduit par le refus d’accomplir un service militaire armé pour des motifs religieux, philosophiques ou moraux. ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/recours_non_juridictionnels_page.dart", "f00031", 'Le régime juridique a prévu des formes de dispense ou de service national civil équivalent.'),
                ),
              ]),
              const SizedBox(height: 8),
              Text(
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/recours_non_juridictionnels_page.dart", "f00032", '2.3 — La résistance à l’oppression'),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 4),
              _Paragraph.rich([
                 TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/recours_non_juridictionnels_page.dart", "f00033", 'Mentionnée à l’article 2 de la Déclaration de 1789, la résistance à l’oppression est à la fois un droit et parfois présentée comme un devoir. ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/recours_non_juridictionnels_page.dart", "f00034", 'Elle vise les situations où un gouvernement exerce un pouvoir manifestement contraire aux droits fondamentaux. '),
                ),
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/recours_non_juridictionnels_page.dart", "f00035", 'Pour un policier, cette notion rappelle que l’obéissance hiérarchique ne justifie jamais l’exécution d’un ordre manifestement illégal et gravement attentatoire aux libertés.'),
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
            title: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/recours_non_juridictionnels_page.dart", "f00036", 'Chapitre 3 — Le Défenseur des droits'),
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              _Paragraph.rich([
                 TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/recours_non_juridictionnels_page.dart", "f00037", 'Le Défenseur des droits est une autorité constitutionnelle indépendante, chargée de veiller au respect des droits et libertés par toute personne publique ou privée. '),
                ),
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/recours_non_juridictionnels_page.dart", "f00038", 'Il constitue un acteur central de la protection non juridictionnelle des libertés publiques.'),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: referenceColor,
                  ),
                ),
              ]),
              const SizedBox(height: 10),
              Text(
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/recours_non_juridictionnels_page.dart", "f00039", '3.1 — Missions principales'),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 4),
               _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/recours_non_juridictionnels_page.dart", "f00040", 'Défendre les droits et libertés dans le cadre des relations avec les services publics ;'),
                ),
              ]),
               _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/recours_non_juridictionnels_page.dart", "f00041", 'Protéger et promouvoir les droits de l’enfant et l’intérêt supérieur de ce dernier ;'),
                ),
              ]),
               _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/recours_non_juridictionnels_page.dart", "f00042", 'Lutter contre les discriminations et promouvoir l’égalité ;'),
                ),
              ]),
               _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/recours_non_juridictionnels_page.dart", "f00043", 'Veiller au respect de la déontologie par les personnes exerçant des activités de sécurité (art. L. 142-1 du C.S.I.) ;'),
                ),
              ]),
               _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/recours_non_juridictionnels_page.dart", "f00044", 'Informer, conseiller et orienter les personnes, notamment les lanceurs d’alerte, vers les autorités compétentes.'),
                ),
              ]),
              const SizedBox(height: 10),
              Text(
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/recours_non_juridictionnels_page.dart", "f00045", '3.2 — Organisation et nomination'),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 4),
               _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/recours_non_juridictionnels_page.dart", "f00046", 'Le Défenseur des droits est nommé par le Président de la République pour un mandat de six ans, non renouvelable. ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/recours_non_juridictionnels_page.dart", "f00047", 'Il est assisté de quatre adjoints, chacun compétent dans un domaine spécifique (droits de l’enfant, déontologie de la sécurité, lutte contre les discriminations, protection des lanceurs d’alerte).'),
              ),
              const SizedBox(height: 10),
              Text(
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/recours_non_juridictionnels_page.dart", "f00048", '3.3 — Saisine et pouvoirs'),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 4),
               _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/recours_non_juridictionnels_page.dart", "f00049", 'Le Défenseur des droits peut être saisi gratuitement par toute personne physique ou morale estimant que ses droits ne sont pas respectés, ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/recours_non_juridictionnels_page.dart", "f00050", 'ou se saisir d’office dans certaines situations. Il peut demander communication de pièces, formuler des recommandations, proposer des sanctions disciplinaires, ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/recours_non_juridictionnels_page.dart", "f00051", 'et, dans certains cas, intervenir devant le juge pour présenter des observations. '),
                ),
              ]),
              const SizedBox(height: 6),
               _ExempleBox(
                title: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/recours_non_juridictionnels_page.dart", "f00052", 'Intérêt pour le policier'),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/recours_non_juridictionnels_page.dart", "f00053", 'Un citoyen s’estimant victime d’une discrimination dans le cadre d’un contrôle d’identité ou d’une procédure peut saisir le Défenseur des droits. ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/recours_non_juridictionnels_page.dart", "f00054", 'Les policiers doivent donc connaître cette institution, répondre à ses demandes d’explications et intégrer ses recommandations dans leur pratique professionnelle.'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
               _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/recours_non_juridictionnels_page.dart", "f00055", 'Chaque année, le Défenseur des droits remet un rapport public d’activité au Président de la République et au Parlement, ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/recours_non_juridictionnels_page.dart", "f00056", 'mettant en lumière les évolutions et les difficultés en matière de respect des droits fondamentaux.'),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // =====================================================
          // CHAPITRE 4 — CONTRÔLEUR GÉNÉRAL DES LIEUX DE PRIVATION
          // =====================================================
          _HypoCard(
            title:
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/recours_non_juridictionnels_page.dart", "f00057", 'Chapitre 4 — Le Contrôleur général des lieux de privation de liberté'),
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
               _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/recours_non_juridictionnels_page.dart", "f00058", 'Institué par la loi du 30 octobre 2007, le Contrôleur général des lieux de privation de liberté est une autorité indépendante chargée de vérifier les conditions de prise en charge ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/recours_non_juridictionnels_page.dart", "f00059", 'et de transfert des personnes privées de liberté (locaux de garde à vue, centres de rétention, établissements pénitentiaires, hôpitaux psychiatriques, etc.). '),
                ),
              ]),
              const SizedBox(height: 8),
              Text(
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/recours_non_juridictionnels_page.dart", "f00060", '4.1 — Champ de compétence'),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 4),
               _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/recours_non_juridictionnels_page.dart", "f00061", 'Toute personne détenue ou toute personne morale peut informer directement le Contrôleur général de faits susceptibles de relever de sa compétence ;'),
                ),
              ]),
               _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/recours_non_juridictionnels_page.dart", "f00062", 'Le Contrôleur peut aussi être saisi par le Premier ministre, les membres du Gouvernement, les parlementaires, le Parlement européen ou le Défenseur des droits ;'),
                ),
              ]),
               _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/recours_non_juridictionnels_page.dart", "f00063", 'Il peut enfin se saisir d’office lorsqu’il estime nécessaire de vérifier une situation.'),
                ),
              ]),
              const SizedBox(height: 8),
              Text(
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/recours_non_juridictionnels_page.dart", "f00064", '4.2 — Pouvoirs d’enquête et garanties'),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 4),
               _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/recours_non_juridictionnels_page.dart", "f00065", 'Le Contrôleur général peut visiter à tout moment tout lieu de privation de liberté sur le territoire de la République. ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/recours_non_juridictionnels_page.dart", "f00066", 'Il peut demander toute information utile, sauf lorsqu’elle est couverte par certains secrets particulièrement protégés (défense nationale, secret de l’enquête ou de l’instruction, secret médical ou professionnel). ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/recours_non_juridictionnels_page.dart", "f00067", 'Il peut s’entretenir de façon confidentielle avec toute personne dont le concours lui paraît nécessaire.'),
              ),
              const SizedBox(height: 8),
               _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/recours_non_juridictionnels_page.dart", "f00068", 'En cas d’atteinte grave aux droits fondamentaux, il adresse sans délai ses observations aux autorités compétentes. ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/recours_non_juridictionnels_page.dart", "f00069", 'Il peut informer le procureur de la République en cas d’infraction pénale et signaler les faits susceptibles d’entraîner des sanctions disciplinaires.'),
              ),
              const SizedBox(height: 8),
               _ExempleBox(
                title: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/recours_non_juridictionnels_page.dart", "f00070", 'Concrètement'),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/recours_non_juridictionnels_page.dart", "f00071", 'À l’issue d’une visite de commissariat ou de local de garde à vue, le Contrôleur général formule des recommandations précises concernant les conditions matérielles, ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/recours_non_juridictionnels_page.dart", "f00072", 'le respect de la dignité des personnes retenues, l’accès aux droits (avocat, médecin, famille, etc.). Ces recommandations peuvent conduire à des réaménagements importants des pratiques policières.'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
               _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/recours_non_juridictionnels_page.dart", "f00073", 'Le Contrôleur général remet un rapport annuel d’activité rendu public et adressé au Président de la République et au Parlement. ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/garanties/recours_non_juridictionnels_page.dart", "f00074", 'Il est assisté de contrôleurs dont les modalités d’intervention sont fixées par décret.'),
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
/// PUCE (liste à points)
/// ------------------------------------------------------------------
class _BulletPoint extends StatelessWidget {
  const _BulletPoint.rich(this.spans);

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
  const _ExempleBox({required this.bodySpans, this.title = 'NOTA'});

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
    final Color titleColor = isDark ? Colors.white : const Color(0xFF5D4037);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor.withValues(alpha: isDark ? .70 : .95),
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
/// BLOC NOTA / MISE EN GARDE
/// ------------------------------------------------------------------
class _NotaBox extends StatelessWidget {
  const _NotaBox({required this.bodySpans, this.title = 'Nota bene'});

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
