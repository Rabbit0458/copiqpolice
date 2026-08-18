import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

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
          tooltip: ScolariteText.value(
            "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
            "f00002",
            "Procédures — circulation",
          ),
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
            ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
              "f00003",
              "La mise en fourrière",
            ),
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
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
              "f00004",
              "I — Élément légal",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                    "f00005",
                    "Articles L. 325-1 à L. 325-3 du Code de la route",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: ", "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                    "f00006",
                    "articles L. 325-7 à L. 325-13 du Code de la route",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: ", "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                    "f00007",
                    "article R. 325-1 du Code de la route",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: ", "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                    "f00008",
                    "article R. 325-1-1 du Code de la route",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " et "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                    "f00009",
                    "articles R. 325-12 à R. 325-52 du Code de la route",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                          "f00010",
                          "La mise en fourrière est une mesure encadrée : elle entraîne des frais à la charge du propriétaire ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                          "f00011",
                          "et suppose une procédure rigoureuse (vérifications, fiches, notifications, enregistrements).",
                        ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Définition
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
              "f00012",
              "II — Définition (à retenir)",
            ),
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                      "f00013",
                      "La mise en fourrière est le transfert d’un véhicule dans un lieu désigné par l’autorité administrative ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                      "f00014",
                      "ou judiciaire, afin qu’il y soit retenu jusqu’à décision de cette autorité, aux frais du propriétaire.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Cas d'ouverture
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
              "f00015",
              "III — Quand peut-on mettre en fourrière ?",
            ),
            cardColor: cardCases,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                  "f00016",
                  "La mesure peut être mise en œuvre dans plusieurs hypothèses prévues par les textes, notamment :",
                ),
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                  "f00017",
                  "Suite à la constatation d’une infraction prescrivant cette mesure (cf. tableaux d’infractions).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                  "f00018",
                  "Suite à une mesure d’immobilisation.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                  "f00019",
                  "Véhicule laissé sans droit dans un lieu public/privé où ne s’applique pas le Code de la route (à la demande du maître des lieux).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                  "f00020",
                  "Véhicule dépourvu d’éléments indispensables à son utilisation normale (dégradations/vols) et insusceptible de réparation immédiate.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                  "f00021",
                  "Dans le cadre d’une procédure de consignation ou de recouvrement de certaines amendes forfaitaires majorées.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                  "f00022",
                  "Suite à la constatation d’un délit ou d’une contravention de 5e classe (Code de la route ou Code pénal) lorsque la confiscation du véhicule est encourue.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Autorité compétente + immobilisation 48h/7j
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
              "f00023",
              "IV — Autorité compétente & cas lié à l’immobilisation",
            ),
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                  "f00024",
                  "Autorités pouvant prescrire la mesure (règle générale)",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                  "f00025",
                  "O.P.J. (Police nationale / Gendarmerie nationale).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                  "f00026",
                  "A.P.J.A. chef de la police municipale (ou occupant ces fonctions).",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                  "f00027",
                  "POINT CLÉ",
                ),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                          "f00028",
                          "La mise en fourrière peut aussi intervenir à Paris par les A.P.J.A. du corps des contrôleurs ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                          "f00029",
                          "de la préfecture de police (spécialité « voie publique »).",
                        ),
                  ),
                ],
              ),
              SizedBox(height: 14),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                  "f00030",
                  "Suite à une immobilisation",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                  "f00031",
                  "La mise en fourrière peut être prescrite (O.P.J. ou A.P.J.A. chef PM) notamment :",
                ),
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                  "f00032",
                  "Si le conducteur (ou l’accompagnateur de l’élève conducteur) ne justifie pas de la cessation de l’infraction dans un délai de 48 heures.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                  "f00033",
                  "Si le véhicule n’est pas présenté au contrôle technique dans le délai de 7 jours prévu par la fiche de circulation provisoire, ou si les réparations/aménagements prescrits ne sont pas exécutés.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Lieux hors CR / véhicules laissés sans droit / véhicule privé d'éléments / épave
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
              "f00034",
              "V — Cas pratiques hors infraction « classique »",
            ),
            cardColor: cardCases,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                  "f00035",
                  "A) Véhicule laissé sans droit (lieu où le C.R. ne s’applique pas)",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                      "f00036",
                      "À la demande du maître des lieux, un véhicule laissé sans droit dans un lieu public ou privé ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                      "f00037",
                      "où le Code de la route ne s’applique pas peut être mis en fourrière.",
                    ),
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                  "f00038",
                  "Le maître des lieux adresse une demande à l’O.P.J. territorialement compétent.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                  "f00039",
                  "Si l’identité/adresse du propriétaire est connue : joindre la preuve de la mise en demeure (LRAR) de retirer le véhicule sous 8 jours.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                  "f00040",
                  "Si l’identité/adresse est inconnue : joindre une demande d’identification ; si les recherches aboutissent, l’O.P.J. expédie la mise en demeure.",
                ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                  "f00041",
                  "B) Véhicule privé d’éléments indispensables (dégradations/vols)",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                      "f00042",
                      "Avant qu’il ne devienne une épave, un véhicule privé d’éléments indispensables à son utilisation normale ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                      "f00043",
                      "et insusceptible de réparation immédiate peut être mis en fourrière, même sans l’accord du propriétaire, selon sa localisation.",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                      "f00044",
                      "Un véhicule devient « épave » lorsqu’il est assimilable à un déchet. Exemple : absence d’éléments d’identification (plaques, constructeur). ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                      "f00045",
                      "Dans ce cas, l’enlèvement peut relever de l’article L. 541-3 du Code de l’environnement",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Consignation / recouvrement AFM
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
              "f00046",
              "VI — Consignation & recouvrement d’amendes forfaitaires majorées",
            ),
            cardColor: cardExec,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                  "f00047",
                  "A) Consignation (personne sans domicile/emploi en France)",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                  "f00048",
                  "Si l’auteur ne peut pas justifier d’un domicile ou d’un emploi en France, ne peut pas payer immédiatement et ne justifie pas d’une caution agréée : possibilité de mise en fourrière (procédure de consignation).",
                ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                  "f00049",
                  "B) Amende forfaitaire majorée (certaines infractions L. 121-3 C.R.)",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                    "f00050",
                    "Suite à un avis d’amende forfaitaire majorée concernant une infraction mentionnée à ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                    "f00051",
                    "l’article L. 121-3 du Code de la route",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                    "f00052",
                    " (vitesse, distances de sécurité…), si le titulaire du certificat d’immatriculation ne peut justifier d’un domicile en France et n’a ni payé ni contesté dans les délais : le véhicule peut être mis en fourrière si le versement « sur-le-champ » du montant de l’AFM n’est pas effectué.",
                  ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Exécution de la mesure (FOVeS, PV/rapport, fiche descriptive, modes de transfert)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
              "f00053",
              "VII — Exécution de la mesure (procédure terrain)",
            ),
            cardColor: cardExec,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                  "f00054",
                  "1) Acte initial : PV ou rapport",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                  "f00055",
                  "Si la mesure fait suite à une infraction : rédaction d’un procès-verbal.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                  "f00056",
                  "Dans les autres cas : rédaction d’un rapport.",
                ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                  "f00057",
                  "2) Vérification préalable obligatoire",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                  "f00058",
                  "Toute mise en fourrière est précédée d’une vérification visant à déterminer si le véhicule est signalé volé (interrogation FOVeS).",
                ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                  "f00059",
                  "3) Fiche descriptive (état sommaire)",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                  "f00060",
                  "Établir une fiche descriptive : état sommaire extérieur et intérieur, sans ouvrir le véhicule.",
                ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                  "f00061",
                  "4) Modalités de transfert vers la fourrière",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                  "f00062",
                  "Par un professionnel agréé (ou son préposé).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                  "f00063",
                  "Sur prescription de l’O.P.J. : par l’agent (qui conduit ou fait conduire, en sa présence).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                  "f00064",
                  "Par un tiers en vertu d’une réquisition.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                  "f00065",
                  "Par le conducteur ou le propriétaire en vertu d’une réquisition.",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                  "f00066",
                  "CAS PRATIQUE",
                ),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                          "f00067",
                          "Si le propriétaire est domicilié/réside dans le ressort de l’O.P.J. prescripteur, ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                          "f00068",
                          "l’O.P.J. peut l’autoriser à garder le véhicule à son domicile après retrait du certificat d’immatriculation.",
                        ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Reprise du véhicule sur place (avant/après commencement, frais, définition commencement d'exécution)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
              "f00069",
              "VIII — Reprise du véhicule sur place (si le contrevenant arrive)",
            ),
            cardColor: cardSuite,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                      "f00070",
                      "Si le contrevenant se présente, l’agent peut l’autoriser à reprendre le véhicule : ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                      "f00071",
                      "après PV et à condition de faire cesser l’infraction.",
                    ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                  "f00072",
                  "Avant commencement d’exécution",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                  "f00073",
                  "Si le véhicule d’enlèvement n’est pas encore arrivé : la reprise peut être autorisée après paiement des frais afférents aux opérations préalables (ex : déplacement du véhicule d’enlèvement).",
                ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                  "f00074",
                  "Après commencement d’exécution",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                  "f00075",
                  "Si l’enlèvement a commencé : la reprise peut être autorisée après paiement des frais d’enlèvement OU engagement écrit de les régler.",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                  "f00076",
                  "DÉFINITION",
                ),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                          "f00077",
                          "La mise en fourrière est réputée avoir reçu commencement d’exécution ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                          "f00078",
                          "si au moins deux roues ont quitté le sol (si véhicule d’enlèvement), ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                          "f00079",
                          "ou dès le début du déplacement vers la fourrière quel que soit le procédé.",
                        ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                      "f00080",
                      "Le paiement des frais est effectué au gardien de la fourrière sur présentation d’une facture détaillée ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                      "f00081",
                      "(en pratique, il peut être réglé sur place au préposé). Les tarifs maxima sont fixés par arrêtés.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Opposition / délit + non restitution CI (natinf)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
              "f00082",
              "IX — Refus / opposition & points d’attention",
            ),
            cardColor: cardSpecial,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                  "f00083",
                  "En cas de refus de régler les frais (ou l’engagement écrit) : fiche descriptive dressée contradictoirement, double remis, retrait provisoire du certificat d’immatriculation, puis enlèvement.",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                  "f00084",
                  "DÉLIT",
                ),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                          "f00085",
                          "Si le conducteur s’oppose à l’enlèvement : délit d’obstacle à un ordre d’envoi en fourrière. ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                          "f00086",
                          "Les A.P.J.A. ne sont pas habilités à constater les délits par procès-verbal.",
                        ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              _NatinfFourriereTable(),
            ],
          ),

          const SizedBox(height: 14),

          // Suites procédurales (registre, notification, transmission, mainlevée/restitution)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
              "f00087",
              "X — Suites procédurales (après enlèvement)",
            ),
            cardColor: cardSuite,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                  "f00088",
                  "1) Enregistrement (registre spécial)",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                      "f00089",
                      "Chaque mise en fourrière est enregistrée de façon minutieuse : date/heure d’enlèvement, matricule, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                      "f00090",
                      "identité du propriétaire, marque/type/immat, état général (chocs/détériorations), accessoires/objets apparents.",
                    ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                  "f00091",
                  "2) Notification au propriétaire",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                      "f00092",
                      "La mise en fourrière est notifiée par l’autorité prescriptrice : ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                      "f00093",
                      "soit lors de la présentation du propriétaire, soit par LRAR dans les 5 jours ouvrables (adresse S.I.V.) ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                      "f00094",
                      "si le propriétaire ne s’est pas présenté.",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                      "f00095",
                      "Si le S.I.V. révèle un gage, la notification vise aussi le créancier gagiste. ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                      "f00096",
                      "(LRAR)",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                  "f00097",
                  "3) Transmission des PV/rapports",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                  "f00098",
                  "PV (suite à infraction) : transmission au procureur de la République et au préfet.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                  "f00099",
                  "Rapport (autres cas) : transmission au préfet.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                  "f00100",
                  "Copie transmise sans délai à l’autorité compétente pour prononcer la mainlevée.",
                ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                  "f00101",
                  "4) Restitution (mainlevée)",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                      "f00102",
                      "La mesure prend fin par une décision de mainlevée : autorisation définitive de sortie de fourrière ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                      "f00103",
                      "et restitution du certificat d’immatriculation le cas échéant.",
                    ),
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                  "f00104",
                  "Le propriétaire ou conducteur doit justifier d’une assurance couvrant le véhicule (ou justification suffisante si prise en charge par un professionnel du remorquage).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                  "f00105",
                  "Présenter un permis de conduire en cours de validité.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                  "f00106",
                  "Présenter un des titres de circulation exigés (articles R. 322-1 et R. 322-3 du Code de la route).",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Cas particulier confiscation encourue (PR autorisation + initiative préfet)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
              "f00107",
              "XI — Cas particulier : confiscation du véhicule encourue",
            ),
            cardColor: cardSpecial,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                    "f00108",
                    "Articles L. 325-1-1 et L. 325-1-2 du Code de la route",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                title: "HABILITATION",
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                      "f00109",
                      "Les A.P.J.A. ne sont pas habilités à mettre en œuvre ces procédures particulières.",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                  "f00110",
                  "A) Avec autorisation préalable du procureur",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                      "f00111",
                      "En cas de délit ou contravention de 5e classe (C.R. ou C.P.) lorsque la confiscation est encourue, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                      "f00112",
                      "les O.P.J. ou A.P.J. peuvent, avec autorisation préalable du procureur (par tout moyen), ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                      "f00113",
                      "faire procéder à l’immobilisation et à la mise en fourrière.",
                    ),
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                  "f00114",
                  "Si le parquet requiert la MEF : vérifier que l’auteur est bien le propriétaire et que le véhicule n’est pas grevé d’un gage/opposition (vigilance véhicules étrangers).",
                ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                  "f00115",
                  "B) À l’initiative du préfet",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                      "f00116",
                      "Le préfet peut ordonner à titre provisoire l’immobilisation et la mise en fourrière du véhicule utilisé ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                      "f00117",
                      "pour certaines infractions (ex. alcool, stupéfiants, défaut de permis, refus d’obtempérer, dépassement ≥ 50 km/h…). ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                      "f00118",
                      "Le procureur est immédiatement informé et dispose de 7 jours pour confirmer la mesure.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          _Paragraph.rich([
            TextSpan(
              text: ScolariteText.value(
                "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                "f00119",
                "Mis à jour le ",
              ),
            ),
            TextSpan(
              text: "15/06/2025",
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
            TextSpan(text: "."),
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
                headerCell(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                    "f00120",
                    "Intitulé",
                  ),
                  flex: 7,
                ),
                const SizedBox(width: 8),
                headerCell(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                    "f00121",
                    "Référence",
                  ),
                  flex: 4,
                  align: TextAlign.right,
                ),
              ],
            ),
          ),

          row(
            natinf: "25818",
            intitule: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
              "f00122",
              "Obstacle à l’ordre d’envoi en fourrière (délit)",
            ),
            refSpans: [
              TextSpan(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                  "f00123",
                  "L. 325-3-1 CR",
                ),
                style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
              ),
            ],
          ),
          row(
            natinf: "21254",
            intitule: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
              "f00124",
              "Non-restitution du certificat d’immatriculation d’un véhicule mis en fourrière (délais notifiés)",
            ),
            refSpans: [
              TextSpan(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                  "f00125",
                  "R. 325-33 CR",
                ),
                style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
              ),
              TextSpan(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart",
                  "f00126",
                  " — (AF minorée 4e classe)",
                ),
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
