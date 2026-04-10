import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MiseEnFourrierePage extends StatelessWidget {
  const MiseEnFourrierePage({super.key});

  static const String routeName =
      '/gpx/memento_circulation/procedures/mise_en_fourriere';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette cards (propre + lisible)
    final Color cardLegal = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardDef = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
    final Color cardCases = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardExec = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);
    final Color cardSuite = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardSpecial = isDark
        ? const Color(0xFF1A1A1A)
        : const Color(0xFFF6F7FB);

    final Color accentBlue = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    final Color accentGrey = isDark ? Colors.white70 : const Color(0xFF616161);
    final Color accentGreen = isDark
        ? const Color(0xFF66BB6A)
        : const Color(0xFF2E7D32);
    final Color accentAmber = isDark
        ? const Color(0xFFFFCA28)
        : const Color(0xFFF9A825);
    final Color accentPink = isDark
        ? const Color(0xFFF48FB1)
        : const Color(0xFFC2185B);

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
          "Procédures — circulation",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: textMain,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
        children: [
          Text(
            "La mise en fourrière",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // ✅ Élément légal en haut
          _ConditionCard(
            title: "I — Élément légal",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: "Articles L. 325-1 à L. 325-3 du Code de la route",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: ", "),
                TextSpan(
                  text: "articles L. 325-7 à L. 325-13 du Code de la route",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: ", "),
                TextSpan(
                  text: "article R. 325-1 du Code de la route",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: ", "),
                TextSpan(
                  text: "article R. 325-1-1 du Code de la route",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " et "),
                TextSpan(
                  text: "articles R. 325-12 à R. 325-52 du Code de la route",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: const [
                  TextSpan(
                    text:
                        "La mise en fourrière est une mesure encadrée : elle entraîne des frais à la charge du propriétaire "
                        "et suppose une procédure rigoureuse (vérifications, fiches, notifications, enregistrements).",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Définition
          _ConditionCard(
            title: "II — Définition (à retenir)",
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "La mise en fourrière est le transfert d’un véhicule dans un lieu désigné par l’autorité administrative "
                "ou judiciaire, afin qu’il y soit retenu jusqu’à décision de cette autorité, aux frais du propriétaire.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Cas d'ouverture
          _ConditionCard(
            title: "III — Quand peut-on mettre en fourrière ?",
            cardColor: cardCases,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "La mesure peut être mise en œuvre dans plusieurs hypothèses prévues par les textes, notamment :",
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text:
                    "Suite à la constatation d’une infraction prescrivant cette mesure (cf. tableaux d’infractions).",
              ),
              _BulletPoint(text: "Suite à une mesure d’immobilisation."),
              _BulletPoint(
                text:
                    "Véhicule laissé sans droit dans un lieu public/privé où ne s’applique pas le Code de la route (à la demande du maître des lieux).",
              ),
              _BulletPoint(
                text:
                    "Véhicule dépourvu d’éléments indispensables à son utilisation normale (dégradations/vols) et insusceptible de réparation immédiate.",
              ),
              _BulletPoint(
                text:
                    "Dans le cadre d’une procédure de consignation ou de recouvrement de certaines amendes forfaitaires majorées.",
              ),
              _BulletPoint(
                text:
                    "Suite à la constatation d’un délit ou d’une contravention de 5e classe (Code de la route ou Code pénal) lorsque la confiscation du véhicule est encourue.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Autorité compétente + immobilisation 48h/7j
          _ConditionCard(
            title: "IV — Autorité compétente & cas lié à l’immobilisation",
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              const _SubTitle(
                "Autorités pouvant prescrire la mesure (règle générale)",
              ),
              const _BulletPoint(
                text: "O.P.J. (Police nationale / Gendarmerie nationale).",
              ),
              const _BulletPoint(
                text:
                    "A.P.J.A. chef de la police municipale (ou occupant ces fonctions).",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "POINT CLÉ",
                bodySpans: const [
                  TextSpan(
                    text:
                        "La mise en fourrière peut aussi intervenir à Paris par les A.P.J.A. du corps des contrôleurs "
                        "de la préfecture de police (spécialité « voie publique »).",
                  ),
                ],
              ),
              const SizedBox(height: 14),
              const _SubTitle("Suite à une immobilisation"),
              const _Paragraph(
                "La mise en fourrière peut être prescrite (O.P.J. ou A.P.J.A. chef PM) notamment :",
              ),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "Si le conducteur (ou l’accompagnateur de l’élève conducteur) ne justifie pas de la cessation de l’infraction dans un délai de 48 heures.",
              ),
              const _BulletPoint(
                text:
                    "Si le véhicule n’est pas présenté au contrôle technique dans le délai de 7 jours prévu par la fiche de circulation provisoire, ou si les réparations/aménagements prescrits ne sont pas exécutés.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Lieux hors CR / véhicules laissés sans droit / véhicule privé d'éléments / épave
          _ConditionCard(
            title: "V — Cas pratiques hors infraction « classique »",
            cardColor: cardCases,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              const _SubTitle(
                "A) Véhicule laissé sans droit (lieu où le C.R. ne s’applique pas)",
              ),
              const _Paragraph(
                "À la demande du maître des lieux, un véhicule laissé sans droit dans un lieu public ou privé "
                "où le Code de la route ne s’applique pas peut être mis en fourrière.",
              ),
              const SizedBox(height: 10),
              const _BulletPoint(
                text:
                    "Le maître des lieux adresse une demande à l’O.P.J. territorialement compétent.",
              ),
              const _BulletPoint(
                text:
                    "Si l’identité/adresse du propriétaire est connue : joindre la preuve de la mise en demeure (LRAR) de retirer le véhicule sous 8 jours.",
              ),
              const _BulletPoint(
                text:
                    "Si l’identité/adresse est inconnue : joindre une demande d’identification ; si les recherches aboutissent, l’O.P.J. expédie la mise en demeure.",
              ),
              const SizedBox(height: 12),
              const _SubTitle(
                "B) Véhicule privé d’éléments indispensables (dégradations/vols)",
              ),
              const _Paragraph(
                "Avant qu’il ne devienne une épave, un véhicule privé d’éléments indispensables à son utilisation normale "
                "et insusceptible de réparation immédiate peut être mis en fourrière, même sans l’accord du propriétaire, selon sa localisation.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Un véhicule devient « épave » lorsqu’il est assimilable à un déchet. Exemple : absence d’éléments d’identification (plaques, constructeur). ",
                  ),
                  TextSpan(
                    text:
                        "Dans ce cas, l’enlèvement peut relever de l’article L. 541-3 du Code de l’environnement",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Consignation / recouvrement AFM
          _ConditionCard(
            title:
                "VI — Consignation & recouvrement d’amendes forfaitaires majorées",
            cardColor: cardExec,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              const _SubTitle(
                "A) Consignation (personne sans domicile/emploi en France)",
              ),
              const _BulletPoint(
                text:
                    "Si l’auteur ne peut pas justifier d’un domicile ou d’un emploi en France, ne peut pas payer immédiatement et ne justifie pas d’une caution agréée : possibilité de mise en fourrière (procédure de consignation).",
              ),
              const SizedBox(height: 12),
              const _SubTitle(
                "B) Amende forfaitaire majorée (certaines infractions L. 121-3 C.R.)",
              ),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Suite à un avis d’amende forfaitaire majorée concernant une infraction mentionnée à ",
                ),
                TextSpan(
                  text: "l’article L. 121-3 du Code de la route",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " (vitesse, distances de sécurité…), si le titulaire du certificat d’immatriculation ne peut justifier d’un domicile en France et n’a ni payé ni contesté dans les délais : le véhicule peut être mis en fourrière si le versement « sur-le-champ » du montant de l’AFM n’est pas effectué.",
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Exécution de la mesure (FOVeS, PV/rapport, fiche descriptive, modes de transfert)
          _ConditionCard(
            title: "VII — Exécution de la mesure (procédure terrain)",
            cardColor: cardExec,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              const _SubTitle("1) Acte initial : PV ou rapport"),
              const _BulletPoint(
                text:
                    "Si la mesure fait suite à une infraction : rédaction d’un procès-verbal.",
              ),
              const _BulletPoint(
                text: "Dans les autres cas : rédaction d’un rapport.",
              ),
              const SizedBox(height: 12),
              const _SubTitle("2) Vérification préalable obligatoire"),
              const _BulletPoint(
                text:
                    "Toute mise en fourrière est précédée d’une vérification visant à déterminer si le véhicule est signalé volé (interrogation FOVeS).",
              ),
              const SizedBox(height: 12),
              const _SubTitle("3) Fiche descriptive (état sommaire)"),
              const _BulletPoint(
                text:
                    "Établir une fiche descriptive : état sommaire extérieur et intérieur, sans ouvrir le véhicule.",
              ),
              const SizedBox(height: 12),
              const _SubTitle("4) Modalités de transfert vers la fourrière"),
              const _BulletPoint(
                text: "Par un professionnel agréé (ou son préposé).",
              ),
              const _BulletPoint(
                text:
                    "Sur prescription de l’O.P.J. : par l’agent (qui conduit ou fait conduire, en sa présence).",
              ),
              const _BulletPoint(
                text: "Par un tiers en vertu d’une réquisition.",
              ),
              const _BulletPoint(
                text:
                    "Par le conducteur ou le propriétaire en vertu d’une réquisition.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "CAS PRATIQUE",
                bodySpans: const [
                  TextSpan(
                    text:
                        "Si le propriétaire est domicilié/réside dans le ressort de l’O.P.J. prescripteur, "
                        "l’O.P.J. peut l’autoriser à garder le véhicule à son domicile après retrait du certificat d’immatriculation.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Reprise du véhicule sur place (avant/après commencement, frais, définition commencement d'exécution)
          _ConditionCard(
            title:
                "VIII — Reprise du véhicule sur place (si le contrevenant arrive)",
            cardColor: cardSuite,
            accent: accentPink,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "Si le contrevenant se présente, l’agent peut l’autoriser à reprendre le véhicule : "
                "après PV et à condition de faire cesser l’infraction.",
              ),
              const SizedBox(height: 12),
              const _SubTitle("Avant commencement d’exécution"),
              const _BulletPoint(
                text:
                    "Si le véhicule d’enlèvement n’est pas encore arrivé : la reprise peut être autorisée après paiement des frais afférents aux opérations préalables (ex : déplacement du véhicule d’enlèvement).",
              ),
              const SizedBox(height: 12),
              const _SubTitle("Après commencement d’exécution"),
              const _BulletPoint(
                text:
                    "Si l’enlèvement a commencé : la reprise peut être autorisée après paiement des frais d’enlèvement OU engagement écrit de les régler.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "DÉFINITION",
                bodySpans: const [
                  TextSpan(
                    text:
                        "La mise en fourrière est réputée avoir reçu commencement d’exécution "
                        "si au moins deux roues ont quitté le sol (si véhicule d’enlèvement), "
                        "ou dès le début du déplacement vers la fourrière quel que soit le procédé.",
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "Le paiement des frais est effectué au gardien de la fourrière sur présentation d’une facture détaillée "
                "(en pratique, il peut être réglé sur place au préposé). Les tarifs maxima sont fixés par arrêtés.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Opposition / délit + non restitution CI (natinf)
          _ConditionCard(
            title: "IX — Refus / opposition & points d’attention",
            cardColor: cardSpecial,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              const _BulletPoint(
                text:
                    "En cas de refus de régler les frais (ou l’engagement écrit) : fiche descriptive dressée contradictoirement, double remis, retrait provisoire du certificat d’immatriculation, puis enlèvement.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "DÉLIT",
                bodySpans: const [
                  TextSpan(
                    text:
                        "Si le conducteur s’oppose à l’enlèvement : délit d’obstacle à un ordre d’envoi en fourrière. "
                        "Les A.P.J.A. ne sont pas habilités à constater les délits par procès-verbal.",
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const _NatinfFourriereTable(),
            ],
          ),

          const SizedBox(height: 14),

          // Suites procédurales (registre, notification, transmission, mainlevée/restitution)
          _ConditionCard(
            title: "X — Suites procédurales (après enlèvement)",
            cardColor: cardSuite,
            accent: accentPink,
            titleColor: textMain,
            children: [
              const _SubTitle("1) Enregistrement (registre spécial)"),
              const _Paragraph(
                "Chaque mise en fourrière est enregistrée de façon minutieuse : date/heure d’enlèvement, matricule, "
                "identité du propriétaire, marque/type/immat, état général (chocs/détériorations), accessoires/objets apparents.",
              ),
              const SizedBox(height: 12),
              const _SubTitle("2) Notification au propriétaire"),
              const _Paragraph(
                "La mise en fourrière est notifiée par l’autorité prescriptrice : "
                "soit lors de la présentation du propriétaire, soit par LRAR dans les 5 jours ouvrables (adresse S.I.V.) "
                "si le propriétaire ne s’est pas présenté.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Si le S.I.V. révèle un gage, la notification vise aussi le créancier gagiste. ",
                  ),
                  TextSpan(
                    text: "(LRAR)",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),
              const SizedBox(height: 12),
              const _SubTitle("3) Transmission des PV/rapports"),
              const _BulletPoint(
                text:
                    "PV (suite à infraction) : transmission au procureur de la République et au préfet.",
              ),
              const _BulletPoint(
                text: "Rapport (autres cas) : transmission au préfet.",
              ),
              const _BulletPoint(
                text:
                    "Copie transmise sans délai à l’autorité compétente pour prononcer la mainlevée.",
              ),
              const SizedBox(height: 12),
              const _SubTitle("4) Restitution (mainlevée)"),
              const _Paragraph(
                "La mesure prend fin par une décision de mainlevée : autorisation définitive de sortie de fourrière "
                "et restitution du certificat d’immatriculation le cas échéant.",
              ),
              const SizedBox(height: 10),
              const _BulletPoint(
                text:
                    "Le propriétaire ou conducteur doit justifier d’une assurance couvrant le véhicule (ou justification suffisante si prise en charge par un professionnel du remorquage).",
              ),
              const _BulletPoint(
                text: "Présenter un permis de conduire en cours de validité.",
              ),
              const _BulletPoint(
                text:
                    "Présenter un des titres de circulation exigés (articles R. 322-1 et R. 322-3 du Code de la route).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Cas particulier confiscation encourue (PR autorisation + initiative préfet)
          _ConditionCard(
            title: "XI — Cas particulier : confiscation du véhicule encourue",
            cardColor: cardSpecial,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: "Articles L. 325-1-1 et L. 325-1-2 du Code de la route",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                title: "HABILITATION",
                bodySpans: const [
                  TextSpan(
                    text:
                        "Les A.P.J.A. ne sont pas habilités à mettre en œuvre ces procédures particulières.",
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const _SubTitle("A) Avec autorisation préalable du procureur"),
              const _Paragraph(
                "En cas de délit ou contravention de 5e classe (C.R. ou C.P.) lorsque la confiscation est encourue, "
                "les O.P.J. ou A.P.J. peuvent, avec autorisation préalable du procureur (par tout moyen), "
                "faire procéder à l’immobilisation et à la mise en fourrière.",
              ),
              const SizedBox(height: 10),
              const _BulletPoint(
                text:
                    "Si le parquet requiert la MEF : vérifier que l’auteur est bien le propriétaire et que le véhicule n’est pas grevé d’un gage/opposition (vigilance véhicules étrangers).",
              ),
              const SizedBox(height: 12),
              const _SubTitle("B) À l’initiative du préfet"),
              const _Paragraph(
                "Le préfet peut ordonner à titre provisoire l’immobilisation et la mise en fourrière du véhicule utilisé "
                "pour certaines infractions (ex. alcool, stupéfiants, défaut de permis, refus d’obtempérer, dépassement ≥ 50 km/h…). "
                "Le procureur est immédiatement informé et dispose de 7 jours pour confirmer la mesure.",
              ),
            ],
          ),

          const SizedBox(height: 12),
          _Paragraph.rich([
            const TextSpan(text: "Mis à jour le "),
            const TextSpan(
              text: "15/06/2025",
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
            const TextSpan(text: "."),
          ]),
        ],
      ),
    );
  }
}

class _NatinfFourriereTable extends StatelessWidget {
  const _NatinfFourriereTable();

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color headerBg = isDark
        ? const Color(0xFF101010)
        : const Color(0xFFF0F0F0);
    final Color rowBg = isDark ? const Color(0xFF151515) : Colors.white;
    final Color border = isDark ? Colors.white12 : Colors.black12;
    final Color text = isDark ? Colors.white : const Color(0xFF111111);
    final Color subText = isDark ? Colors.white70 : const Color(0xFF444444);

    Widget headerCell(
      String t, {
      int flex = 3,
      TextAlign align = TextAlign.left,
    }) {
      return Expanded(
        flex: flex,
        child: Text(
          t,
          textAlign: align,
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 13.5,
            color: text,
          ),
        ),
      );
    }

    Widget cell(
      String t, {
      int flex = 3,
      TextAlign align = TextAlign.left,
      bool strong = false,
    }) {
      return Expanded(
        flex: flex,
        child: Text(
          t,
          textAlign: align,
          style: GoogleFonts.fustat(
            fontWeight: strong ? FontWeight.w900 : FontWeight.w700,
            fontSize: 13.5,
            color: subText,
          ),
        ),
      );
    }

    Widget row({
      required String natinf,
      required String intitule,
      required List<TextSpan> refSpans,
    }) {
      return Container(
        decoration: BoxDecoration(
          color: rowBg,
          border: Border(top: BorderSide(color: border)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            cell(natinf, flex: 2, strong: true),
            const SizedBox(width: 8),
            cell(intitule, flex: 7),
            const SizedBox(width: 8),
            Expanded(
              flex: 4,
              child: RichText(
                textAlign: TextAlign.right,
                text: TextSpan(
                  style: GoogleFonts.fustat(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: subText,
                    height: 1.25,
                  ),
                  children: refSpans,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: headerBg,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
            ),
            child: Row(
              children: [
                headerCell("NATINF", flex: 2),
                const SizedBox(width: 8),
                headerCell("Intitulé", flex: 7),
                const SizedBox(width: 8),
                headerCell("Référence", flex: 4, align: TextAlign.right),
              ],
            ),
          ),

          row(
            natinf: "25818",
            intitule: "Obstacle à l’ordre d’envoi en fourrière (délit)",
            refSpans: const [
              TextSpan(
                text: "L. 325-3-1 CR",
                style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
              ),
            ],
          ),
          row(
            natinf: "21254",
            intitule:
                "Non-restitution du certificat d’immatriculation d’un véhicule mis en fourrière (délais notifiés)",
            refSpans: const [
              TextSpan(
                text: "R. 325-33 CR",
                style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
              ),
              TextSpan(text: " — (AF minorée 4e classe)"),
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
