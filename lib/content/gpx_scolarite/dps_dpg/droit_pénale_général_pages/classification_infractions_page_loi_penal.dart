import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ClassificationInfractionsGPXSchoolPageLoiPenal extends StatelessWidget {
  const ClassificationInfractionsGPXSchoolPageLoiPenal({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/droit_pénale_général_pages/loi_penale/classification_infractions/classification';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : Colors.white;
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);
    final Color textSoft = isDark
        ? Colors.white70
        : const Color(0xFF222222).withOpacity(.75);

    // Couleur unique pour TOUS les articles de loi
    const Color lawRed = Color(0xFFE53935);

    // Couleurs cartes
    final Color card1 = isDark
        ? const Color(0xFF2C2C2C)
        : const Color(0xFFF7F7F7);
    final Color card2 = isDark
        ? const Color(0xFF2B2B2B)
        : const Color(0xFFF3F6FF);
    final Color card3 = isDark
        ? const Color(0xFF2A2A2A)
        : const Color(0xFFFFF8E1);

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
          "Classification des infractions",
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
          // ====================== TITRE PRINCIPAL ===========================
          Text(
            "CHAPITRE 2 :\nCLASSIFICATION DES INFRACTIONS",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Classification tripartite, classification fondée sur la nature de l’infraction "
            "et classification fondée sur le mode de réalisation.",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w500,
              fontSize: 13.5,
              height: 1.35,
              color: textSoft,
            ),
          ),
          const SizedBox(height: 18),

          // ====================== 2.1 ===========================
          _ConditionCard(
            title: "2.1 — LA CLASSIFICATION TRIPARTITE",
            cardColor: card1,
            accent: const Color(0xFF1565C0),
            titleColor: textMain,
            children: [
              const _SubTitle("2.1.1 — Le principe"),
              _Paragraph.rich([
                const TextSpan(text: "Le Code pénal, dans son "),
                TextSpan(
                  text: "article 111-1 du Code pénal",
                  style: const TextStyle(
                    color: lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " dispose : « Les infractions pénales sont classées suivant leur gravité "
                      "en crimes, délits et contraventions. »",
                ),
              ]),
              const SizedBox(height: 10),
              const _Paragraph(
                "Il opte donc pour une classification fondée sur la gravité de l’infraction commise.",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Les infractions se divisent en crimes, délits et contraventions. "
                      "La nomenclature des peines applicables est fixée par les ",
                ),
                TextSpan(
                  text: "articles 131-1 à 131-18 du Code pénal",
                  style: const TextStyle(
                    color: lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " (cf. tableau)."),
              ]),

              const SizedBox(height: 14),
              const _SubTitle("2.1.2 — Les intérêts de cette classification"),

              const _SubTitle("2.1.2.1 — Pour les règles de fond"),
              _Paragraph.rich([
                const TextSpan(text: "✓ "),
                const TextSpan(
                  text: "La tentative",
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                const TextSpan(
                  text:
                      " : elle est toujours punissable pour les crimes, pour les délits lorsque le texte le prévoit, "
                      "et jamais pour les contraventions.",
                ),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                const TextSpan(text: "✓ "),
                const TextSpan(
                  text: "La complicité",
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                const TextSpan(
                  text:
                      " : elle est toujours prévue pour les crimes et délits, mais ne l’est, pour les contraventions, "
                      "que lorsque des dispositions réglementaires le prévoient expressément.",
                ),
              ]),

              const SizedBox(height: 14),
              const _SubTitle("2.1.2.2 — Pour la prescription"),
              const _SubTitle("2.1.2.2.1 — Prescription de l’action publique"),
              const _Paragraph(
                "Elle correspond à la date au-delà de laquelle il n’est plus possible de poursuivre l’auteur d’une infraction.",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Le délai de prescription est de vingt ans pour les crimes, six ans pour les délits et un an pour les contraventions (",
                ),
                TextSpan(
                  text: "articles 7, 8 et 9 du Code de procédure pénale",
                  style: const TextStyle(
                    color: lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: ")."),
              ]),

              const SizedBox(height: 10),
              const _Paragraph(
                "Il existe cependant des délais exceptionnels pour certaines infractions particulières :",
              ),
              const SizedBox(height: 10),

              _Paragraph.rich([
                const TextSpan(text: "✓ "),
                const TextSpan(
                  text:
                      "Délai imprescriptible de l’action publique en cas de crime de génocide ou contre l’humanité (",
                ),
                TextSpan(
                  text: "articles 211-1 à 212-3 du Code pénal",
                  style: const TextStyle(
                    color: lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: ")."),
              ]),
              const SizedBox(height: 6),

              _Paragraph.rich([
                const TextSpan(text: "✓ "),
                const TextSpan(
                  text:
                      "30 ans en cas de crime lié à des actes de terrorisme et 20 ans pour les délits relatifs aux mêmes faits (",
                ),
                TextSpan(
                  text: "article 706-16 du Code de procédure pénale",
                  style: const TextStyle(
                    color: lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: ")."),
              ]),
              const SizedBox(height: 6),

              _Paragraph.rich([
                const TextSpan(text: "✓ "),
                const TextSpan(
                  text:
                      "30 ans en cas de crime de trafic de stupéfiants ainsi que les crimes de participation à une association de malfaiteurs prévus par ",
                ),
                TextSpan(
                  text: "l’article 450-1 du Code pénal",
                  style: const TextStyle(
                    color: lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " lorsqu’ils ont pour objet de préparer une infraction de trafic de stupéfiants, et 20 ans s’il s’agit d’un délit (",
                ),
                TextSpan(
                  text: "article 706-26 du Code de procédure pénale",
                  style: const TextStyle(
                    color: lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: ")."),
              ]),
              const SizedBox(height: 6),

              _Paragraph.rich([
                const TextSpan(text: "✓ "),
                const TextSpan(
                  text: "30 ans pour les crimes sur mineurs listés à ",
                ),
                TextSpan(
                  text: "l’article 706-47 du Code de procédure pénale",
                  style: const TextStyle(
                    color: lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " (meurtre, tortures ou actes de barbarie, violences sur mineur de 15 ans ayant entraîné une mutilation ou une infirmité permanente, viol).",
                ),
              ]),
              const SizedBox(height: 6),

              const _Paragraph(
                "✓ 20 ans pour les délits d’agressions sexuelles, atteintes sexuelles aggravées sur mineur de 15 ans, "
                "et violences volontaires aggravées ayant entraîné une incapacité totale de travail de plus de 8 jours commises sur un mineur.",
              ),
              const SizedBox(height: 6),

              _Paragraph.rich([
                const TextSpan(text: "✓ "),
                const TextSpan(
                  text:
                      "10 ans pour les délits commis sur des mineurs mentionnés aux articles ",
                ),
                TextSpan(
                  text: "223-15-2 du Code pénal",
                  style: const TextStyle(
                    color: lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " (abus frauduleux de l’état d’ignorance ou de la situation de faiblesse d’un mineur), ",
                ),
                TextSpan(
                  text: "223-15-3 du Code pénal",
                  style: const TextStyle(
                    color: lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " (placement ou maintien dans un état de sujétion psychologique ou physique), ainsi que ",
                ),
                TextSpan(
                  text: "706-47 du Code de procédure pénale",
                  style: const TextStyle(
                    color: lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text: " à l’exception de ceux mentionnés aux articles ",
                ),
                TextSpan(
                  text: "222-29-1 du Code pénal",
                  style: const TextStyle(
                    color: lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " et "),
                TextSpan(
                  text: "227-26 du Code pénal",
                  style: const TextStyle(
                    color: lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " (agressions et atteintes sexuelles sur mineur de quinze ans).",
                ),
              ]),

              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(text: "✓ "),
                const TextSpan(
                  text:
                      "1 an pour certains délits de presse à caractère discriminatoire (",
                ),
                TextSpan(
                  text: "article 65-3 de la loi du 29 juillet 1881",
                  style: const TextStyle(
                    color: lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: ")."),
              ]),
              const SizedBox(height: 6),

              const _Paragraph("✓ 20 ans en cas de délits de guerre."),
              const SizedBox(height: 6),
              const _Paragraph("✓ 30 ans en cas de crimes de guerre."),
              const SizedBox(height: 6),

              _Paragraph.rich([
                const TextSpan(text: "✓ "),
                const TextSpan(
                  text:
                      "3 mois pour les délits de presse tels que la diffamation (",
                ),
                TextSpan(
                  text: "article 65 de la loi du 29 juillet 1881",
                  style: const TextStyle(
                    color: lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: ")."),
              ]),

              const SizedBox(height: 14),
              const _SubTitle("2.1.2.2.2 — Prescription de la peine"),
              const _Paragraph(
                "C’est la date au-delà de laquelle une peine prononcée ne peut plus être appliquée.",
              ),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Elle est de 20 ans pour les crimes, 6 ans pour les délits et 3 ans pour les contraventions (",
                ),
                TextSpan(
                  text: "articles 133-2 à 133-4 du Code pénal",
                  style: const TextStyle(
                    color: lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: ")."),
              ]),
              const SizedBox(height: 10),

              _Paragraph.rich([
                const TextSpan(text: "✓ "),
                const TextSpan(
                  text: "Imprescriptibilité des crimes contre l’humanité (",
                ),
                TextSpan(
                  text: "article 133-2 du Code pénal",
                  style: const TextStyle(
                    color: lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: ")."),
              ]),

              const SizedBox(height: 14),
              const _SubTitle("2.1.2.3 — Pour les règles de procédure"),
              const _SubTitle("2.1.2.3.1 — Les juridictions compétentes"),
              const _Paragraph(
                "Les contraventions sont jugées par le tribunal de police, les délits par le tribunal correctionnel "
                "et les crimes par la cour d’assises ou la cour criminelle départementale.",
              ),
              const SizedBox(height: 10),
              const _SubTitle("2.1.2.3.2 — Le cadre d’enquête"),
              const _Paragraph(
                "Pour les crimes et délits, l’enquête de flagrance peut être utilisée ; pour les contraventions, "
                "seule l’enquête préliminaire est possible.",
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ====================== 2.2 ===========================
          _ConditionCard(
            title: "2.2 — CLASSIFICATION FONDÉE SUR LA NATURE DE L’INFRACTION",
            cardColor: card2,
            accent: const Color(0xFF1E88E5),
            titleColor: textMain,
            children: [
              const _Paragraph(
                "Il existe, à côté des infractions de droit commun, des infractions spécifiques. "
                "Leur spécificité tient à la nature des intérêts lésés, qui sont souvent ceux de l’État.",
              ),

              const SizedBox(height: 12),
              const _SubTitle(
                "2.2.1 — Infractions de droit commun et infractions politiques",
              ),
              const _Paragraph(
                "Cette distinction existe de tout temps pour appliquer un régime juridique différent. "
                "À certains moments de l’histoire, les délinquants politiques ont été traités avec davantage de sévérité "
                "et à d’autres avec plus d’indulgence que les délinquants de droit commun. "
                "Le Code pénal de 1810 prévoyait l’application de peines spéciales comme la déportation ou le bannissement. "
                "Cependant, aucune définition de l’infraction politique n’a été donnée.",
              ),

              const SizedBox(height: 10),
              const _SubTitle(
                "2.2.1.1 — Critères de distinction de l’infraction politique",
              ),
              const _Paragraph(
                "En l’absence de définition légale, la doctrine et la jurisprudence ont tenté de déterminer les caractères distinctifs "
                "de l’infraction politique. Le critère retenu est un critère objectif : est considérée comme politique toute infraction "
                "portant atteinte à l’organisation et au fonctionnement des pouvoirs publics, à l’intérêt de l’État ou même à son existence. "
                "La jurisprudence prend donc en compte le seul objet de l’infraction, et non les mobiles de l’auteur : "
                "une infraction commise pour des mobiles politiques peut rester une infraction de droit commun.",
              ),

              const SizedBox(height: 10),
              const _SubTitle("2.2.1.2 — Intérêts de la distinction"),
              const _SubTitle("2.2.1.2.1 — Quant au régime applicable"),
              const _Paragraph(
                "✓ Application de peines spécifiques en matière criminelle : détention criminelle.",
              ),
              const SizedBox(height: 6),
              const _Paragraph(
                "✓ Le régime d’exécution de la peine d’emprisonnement est moins sévère que le régime commun.",
              ),
              const SizedBox(height: 6),
              const _Paragraph(
                "✓ Le condamné pourra bénéficier ultérieurement du sursis, et la condamnation ne peut pas révoquer un sursis antérieur.",
              ),

              const SizedBox(height: 10),
              const _SubTitle("2.2.1.2.2 — Quant aux règles de forme"),
              const _Paragraph(
                "✓ Depuis la suppression des juridictions d’exception, les crimes politiques relèvent de la cour d’assises.",
              ),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(text: "— Exceptions : certains crimes ("),
                TextSpan(
                  text:
                      "articles 411-1 à 411-11 et 413-1 à 413-12 du Code pénal",
                  style: const TextStyle(
                    color: lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      ") commis en temps de paix sont jugés par la cour d’assises sans jurés, par sept magistrats professionnels.",
                ),
              ]),
              const SizedBox(height: 8),
              const _Paragraph(
                "✓ Les délits politiques sont jugés par les tribunaux correctionnels.",
              ),
              const SizedBox(height: 8),
              const _Paragraph(
                "— Exceptions : les délits contre les intérêts fondamentaux de la Nation relèvent de la compétence des juridictions des forces armées en temps de guerre. "
                "En temps de paix, certains délits contre les intérêts fondamentaux de la Nation relèvent du tribunal correctionnel spécialisé en matière militaire.",
              ),

              const SizedBox(height: 14),
              const _SubTitle(
                "2.2.2 — Infractions de droit commun et infractions terroristes",
              ),
              const _SubTitle(
                "2.2.2.1 — Critères de distinction de l’infraction de terrorisme",
              ),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Le Code pénal a consacré un titre entier aux infractions de terrorisme. Il a énoncé aux ",
                ),
                TextSpan(
                  text: "articles 421-1 à 421-6 du Code pénal",
                  style: const TextStyle(
                    color: lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " une liste d’infractions qui, commises dans certaines circonstances et pour certains motifs, "
                      "sont qualifiées d’infractions de terrorisme.",
                ),
              ]),

              const SizedBox(height: 10),
              const _SubTitle("2.2.2.2 — Intérêts de la distinction"),
              const _Paragraph(
                "Il existe des règles particulières de procédure (notamment en matière de perquisition et de garde à vue).",
              ),
              const SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: "L’article 706-17 du Code de procédure pénale",
                  style: const TextStyle(
                    color: lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " prévoit une possibilité de centralisation des procédures de terrorisme à Paris "
                      "(dessaisissement au profit de la juridiction parisienne).",
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Pour le jugement des infractions terroristes, la cour d’assises est composée uniquement de magistrats professionnels (",
                ),
                TextSpan(
                  text: "articles 706-25 et 698-6 du Code de procédure pénale",
                  style: const TextStyle(
                    color: lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: ")."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Les infractions de terrorisme exposent leur auteur à des peines aggravées (",
                ),
                TextSpan(
                  text: "articles 421-3 à 421-6 du Code pénal",
                  style: const TextStyle(
                    color: lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: ")."),
              ]),

              const SizedBox(height: 14),
              const _SubTitle(
                "2.2.3 — Infractions de droit commun et infractions militaires",
              ),
              const _SubTitle("2.2.3.1 — Définition de l’infraction militaire"),
              const _Paragraph(
                "Est une infraction militaire tout acte qui constitue un manquement à la discipline "
                "(rébellion, refus d’obéissance) et aux obligations militaires (désertion, insoumission).",
              ),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Est également qualifiée d’infraction militaire l’infraction de droit commun commise par un militaire dans l’exercice de ses missions. ",
                ),
                TextSpan(
                  text: "L’article L. 2 du Code de justice militaire",
                  style: const TextStyle(
                    color: lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " précise qu’en temps de paix, les infractions commises par les membres des forces armées ou à l’encontre de celles-ci "
                      "relèvent des juridictions de droit commun spécialisées en matière militaire dans les cas prévus à l’article L. 111-1. "
                      "Hors ces cas, elles relèvent des juridictions de droit commun.",
                ),
              ]),

              const SizedBox(height: 10),
              const _SubTitle("2.2.3.2 — Conséquences de la distinction"),
              const _SubTitle("2.2.3.2.1 — Quant aux règles de fond"),
              const _Paragraph(
                "✓ Il existe des peines spécifiques comme la destitution et la perte du grade.",
              ),
              const SizedBox(height: 10),
              const _SubTitle("2.2.3.2.2 — Quant aux règles de forme"),
              const _Paragraph(
                "✓ En temps de guerre, ce sont les tribunaux territoriaux des forces armées (faits commis en France), ou les tribunaux militaires aux armées (faits commis à l’étranger).",
              ),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(text: "Référence : "),
                TextSpan(
                  text: "article 699 du Code de procédure pénale",
                  style: const TextStyle(
                    color: lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              const _Paragraph(
                "✓ L’extradition n’est pas applicable sauf exception.",
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ====================== 2.3 ===========================
          _ConditionCard(
            title:
                "2.3 — CLASSIFICATION FONDÉE SUR LE MODE DE RÉALISATION DE L’INFRACTION",
            cardColor: card3,
            accent: const Color(0xFFF9A825),
            titleColor: textMain,
            children: [
              const _SubTitle(
                "2.3.1 — Infractions de commission et infractions d’omission",
              ),
              const _SubTitle("2.3.1.1 — Infractions de commission"),
              const _Paragraph(
                "Elles consistent en la réalisation d’un acte prohibé par la loi.",
              ),

              const SizedBox(height: 10),
              const _SubTitle("2.3.1.2 — Infractions d’omission"),
              const _Paragraph(
                "Elles supposent que l’omission est réprimée en tant que telle. Ces infractions sont aujourd’hui assez nombreuses.",
              ),
              const SizedBox(height: 8),
              const _Paragraph("Exemples :"),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(
                  text: "— omission de porter secours à personne en péril (",
                ),
                TextSpan(
                  text: "article 223-6 alinéa 2 du Code pénal",
                  style: const TextStyle(
                    color: lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: ") ;"),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                const TextSpan(
                  text: "— omission de témoigner en faveur d’un innocent (",
                ),
                TextSpan(
                  text: "article 434-11 du Code pénal",
                  style: const TextStyle(
                    color: lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: ") ;"),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "— délaissement d’une personne qui n’est pas en mesure de se protéger (",
                ),
                TextSpan(
                  text: "article 223-3 du Code pénal",
                  style: const TextStyle(
                    color: lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: ") ;"),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "— privation d’aliments ou de soins à un mineur de 15 ans (",
                ),
                TextSpan(
                  text: "article 227-15 du Code pénal",
                  style: const TextStyle(
                    color: lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: ")."),
              ]),

              const SizedBox(height: 12),
              const _SubTitle(
                "2.3.1.3 — Infractions de commission par omission",
              ),
              const _Paragraph(
                "Elles supposent que leur auteur soit volontairement resté passif, et qu’il en ait résulté un dommage. "
                "En d’autres termes : peut-on assimiler une abstention à une action ?",
              ),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Exceptionnellement, l’omission est assimilée pénalement à la commission par le législateur. "
                      "C’est le cas en matière d’homicide ou de blessures par imprudence (",
                ),
                TextSpan(
                  text: "articles 221-6 et 222-19 du Code pénal",
                  style: const TextStyle(
                    color: lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: ")."),
              ]),

              const SizedBox(height: 14),
              const _SubTitle(
                "2.3.2 — Infractions instantanées et infractions continues",
              ),
              const _SubTitle("2.3.2.1 — Définitions"),
              const _Paragraph(
                "Les infractions instantanées sont constituées d’un acte qui se réalise en un instant. "
                "Si l’infraction se réalise en un trait de temps, elle est dite instantanée, peu importe que ses effets se prolongent ou non dans le temps.",
              ),
              const SizedBox(height: 8),
              const _Paragraph(
                "Exemple : la bigamie (contracter un second mariage alors que le premier n’est pas dissous) est un délit instantané, "
                "car réalisé en un instant, même si ses effets perdurent.",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "L’infraction continue est celle dont l’exécution se prolonge dans le temps. Elle suppose une réitération de la volonté coupable de l’auteur.",
              ),
              const SizedBox(height: 8),
              const _Paragraph(
                "Exemples : non-représentation d’enfants, port illégal de décoration, recel de choses volées.",
              ),

              const SizedBox(height: 12),
              const _SubTitle("2.3.2.2 — Intérêts de la distinction"),
              const _SubTitle("2.3.2.2.1 — Quant à la prescription"),
              const _Paragraph(
                "✓ Pour le délit instantané : elle part du jour où l’acte délictueux a été accompli.",
              ),
              const SizedBox(height: 6),
              const _Paragraph(
                "✓ Pour le délit continu : c’est le jour où l’acte délictueux a pris fin.",
              ),
              const SizedBox(height: 6),
              const _Paragraph(
                "Exemples : le jour où le receleur n’aura plus l’objet volé ; le jour où une séquestration se termine.",
              ),

              const SizedBox(height: 10),
              const _SubTitle(
                "2.3.2.2.2 — Quant à l’application de la loi nouvelle",
              ),
              const _Paragraph(
                "Le délit continu est régi par la loi nouvelle car, commencé sous la loi ancienne, il s’est prolongé sous l’empire de la loi nouvelle.",
              ),

              const SizedBox(height: 10),
              const _SubTitle("2.3.2.2.3 — Quant à la compétence du tribunal"),
              const _Paragraph(
                "Le délit instantané est réalisé en un seul lieu, mais le délit continu peut avoir plusieurs lieux d’exécution : "
                "les tribunaux de ces différents lieux seront compétents.",
              ),

              const SizedBox(height: 10),
              const _SubTitle("2.3.2.2.4 — Quant à l’amnistie"),
              const _Paragraph(
                "Le délit continu peut être réprimé malgré l’intervention d’une loi d’amnistie s’il se prolonge après celle-ci.",
              ),

              const SizedBox(height: 14),
              const _SubTitle(
                "2.3.3 — Infractions simples, complexes et d’habitude",
              ),
              const _SubTitle("2.3.3.1 — Définitions"),
              const _Paragraph(
                "L’infraction simple consiste en la réalisation d’un acte unique.\n"
                "Exemple : le vol (soustraction frauduleuse de la chose d’autrui).",
              ),
              const SizedBox(height: 8),
              const _Paragraph(
                "L’infraction complexe suppose la réalisation de plusieurs actes matériels de type différent.\n"
                "Exemple : l’escroquerie (manœuvres frauduleuses + remise de la chose).",
              ),
              const SizedBox(height: 8),
              const _Paragraph(
                "L’infraction d’habitude est constituée par la réalisation de plusieurs actes semblables qui, pris isolément, "
                "ne constituent pas des infractions : c’est leur répétition qui va les ériger en infractions.",
              ),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Exemple : exercice illégal de la médecine. Un acte médical unique ne constitue pas un délit : ",
                ),
                TextSpan(
                  text: "article L. 4161-1 du Code de la santé publique",
                  style: const TextStyle(
                    color: lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),

              const SizedBox(height: 12),
              const _SubTitle("2.3.3.2 — Intérêts de la distinction"),
              const _SubTitle("2.3.3.2.1 — Prescription de l’action publique"),
              const _Paragraph(
                "Pour le délit d’habitude, le point de départ du délai de prescription est le jour où a été accompli le dernier acte constitutif de l’habitude.",
              ),
              const SizedBox(height: 10),
              const _SubTitle("2.3.3.2.2 — Application de la loi nouvelle"),
              const _Paragraph(
                "La loi nouvelle s’applique si le dernier acte constitutif de l’infraction d’habitude a été accompli sous l’empire de cette loi.",
              ),
            ],
          ),

          const SizedBox(height: 22),
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
