import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PaNonRepresentationEnfantMineurPage extends StatelessWidget {
  const PaNonRepresentationEnfantMineurPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/mineurs_famille_pages/autorite_parentale/non_representation_enfant_mineur';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette cards
    final Color cardDef = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
    final Color cardLegal = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardMat = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardMoral = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardAggr = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);
    final Color cardRep = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);

    final Color accentBlue = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    final Color accentGreen = isDark
        ? const Color(0xFF66BB6A)
        : const Color(0xFF2E7D32);
    final Color accentPink = isDark
        ? const Color(0xFFF48FB1)
        : const Color(0xFFC2185B);
    final Color accentAmber = isDark
        ? const Color(0xFFFFCA28)
        : const Color(0xFFF9A825);
    final Color accentGrey = isDark ? Colors.white70 : const Color(0xFF616161);

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
            "lib/content/pa_scolarite/mineurs_famille_pages/autorite_parentale/non_representation_enfant_mineur_contenu_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/mineurs_famille_pages/autorite_parentale/non_representation_enfant_mineur_contenu_page.dart",
            "f00002",
            "Autorité parentale",
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
              "lib/content/pa_scolarite/mineurs_famille_pages/autorite_parentale/non_representation_enfant_mineur_contenu_page.dart",
              "f00003",
              "La non-représentation d’enfant mineur",
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Définition
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/mineurs_famille_pages/autorite_parentale/non_representation_enfant_mineur_contenu_page.dart",
              "f00004",
              "Définition",
            ),
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/mineurs_famille_pages/autorite_parentale/non_representation_enfant_mineur_contenu_page.dart",
                  "f00005",
                  "Le fait de refuser indûment de représenter un enfant mineur à la personne qui a le droit de le réclamer constitue une infraction.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal (en haut)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/mineurs_famille_pages/autorite_parentale/non_representation_enfant_mineur_contenu_page.dart",
              "f00006",
              "I — Élément légal",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/mineurs_famille_pages/autorite_parentale/non_representation_enfant_mineur_contenu_page.dart",
                    "f00007",
                    "Article 227-5 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/mineurs_famille_pages/autorite_parentale/non_representation_enfant_mineur_contenu_page.dart",
                    "f00008",
                    " : définit et réprime la non-représentation d’enfant mineur.",
                  ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Élément matériel
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/mineurs_famille_pages/autorite_parentale/non_representation_enfant_mineur_contenu_page.dart",
              "f00009",
              "II — Élément matériel",
            ),
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/mineurs_famille_pages/autorite_parentale/non_representation_enfant_mineur_contenu_page.dart",
                      "f00010",
                      "Le délit consiste à refuser indûment de représenter un enfant mineur à une personne qui a le droit de le réclamer. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/mineurs_famille_pages/autorite_parentale/non_representation_enfant_mineur_contenu_page.dart",
                      "f00011",
                      "Les faits s’inscrivent fréquemment dans un contexte de conflit parental à la suite d’une séparation.",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/mineurs_famille_pages/autorite_parentale/non_representation_enfant_mineur_contenu_page.dart",
                    "f00012",
                    "Est mineure toute personne âgée de moins de 18 ans — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/mineurs_famille_pages/autorite_parentale/non_representation_enfant_mineur_contenu_page.dart",
                    "f00013",
                    "article 388 du code civil",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/mineurs_famille_pages/autorite_parentale/non_representation_enfant_mineur_contenu_page.dart",
                  "f00014",
                  "A) Le droit de réclamer le mineur",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/mineurs_famille_pages/autorite_parentale/non_representation_enfant_mineur_contenu_page.dart",
                      "f00015",
                      "Le droit de réclamer l’enfant provient le plus souvent d’une décision judiciaire : ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/mineurs_famille_pages/autorite_parentale/non_representation_enfant_mineur_contenu_page.dart",
                      "f00016",
                      "décision de justice, convention homologuée, ou convention de divorce.",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/mineurs_famille_pages/autorite_parentale/non_representation_enfant_mineur_contenu_page.dart",
                      "f00017",
                      "La jurisprudence exige que la décision soit exécutoire et qu’elle ait été portée, dans les formes légales, à la connaissance de celui qui refuse de représenter l’enfant.",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/mineurs_famille_pages/autorite_parentale/non_representation_enfant_mineur_contenu_page.dart",
                      "f00018",
                      "Ce droit est aussi reconnu à toute personne investie de l’autorité parentale (père, mère, tuteur). ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/mineurs_famille_pages/autorite_parentale/non_representation_enfant_mineur_contenu_page.dart",
                      "f00019",
                      "En l’absence de décision délimitant les droits de chacun, le délit ne peut pas être constitué lorsque le conflit oppose deux personnes ayant des droits égaux sur le mineur (ex. parents séparés de fait).",
                    ),
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/mineurs_famille_pages/autorite_parentale/non_representation_enfant_mineur_contenu_page.dart",
                  "f00020",
                  "B) Le refus de représenter le mineur",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/mineurs_famille_pages/autorite_parentale/non_representation_enfant_mineur_contenu_page.dart",
                      "f00021",
                      "Le refus peut être commis :\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/mineurs_famille_pages/autorite_parentale/non_representation_enfant_mineur_contenu_page.dart",
                      "f00022",
                      "• par le parent qui a la garde, en empêchant l’autre d’exercer son droit de visite ;\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/mineurs_famille_pages/autorite_parentale/non_representation_enfant_mineur_contenu_page.dart",
                      "f00023",
                      "• ou par le parent bénéficiaire d’un hébergement, en ne remettant pas l’enfant à l’issue de la période autorisée.",
                    ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/mineurs_famille_pages/autorite_parentale/non_representation_enfant_mineur_contenu_page.dart",
                  "f00024",
                  "1) Comportement actif (direct ou indirect)",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/mineurs_famille_pages/autorite_parentale/non_representation_enfant_mineur_contenu_page.dart",
                  "f00025",
                  "Refus pur et simple de remettre l’enfant, dissimulation du mineur, absence du domicile lors de la présentation, etc.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/mineurs_famille_pages/autorite_parentale/non_representation_enfant_mineur_contenu_page.dart",
                  "f00026",
                  "Comportement actif indirect : manipulation du mineur pour l’inciter à refuser la visite ou l’hébergement.",
                ),
              ),

              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/mineurs_famille_pages/autorite_parentale/non_representation_enfant_mineur_contenu_page.dart",
                  "f00027",
                  "2) Comportement passif",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/mineurs_famille_pages/autorite_parentale/non_representation_enfant_mineur_contenu_page.dart",
                  "f00028",
                  "Le refus peut aussi résulter d’une abstention : par exemple, lorsque le parent titulaire de la garde n’intervient pas alors que l’enfant refuse spontanément de se soumettre au droit de visite/hébergement.",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/mineurs_famille_pages/autorite_parentale/non_representation_enfant_mineur_contenu_page.dart",
                      "f00029",
                      "La résistance du mineur ne constitue ni une excuse légale, ni un fait justificatif : le parent doit agir pour permettre l’exécution du droit.",
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Élément moral
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/mineurs_famille_pages/autorite_parentale/non_representation_enfant_mineur_contenu_page.dart",
              "f00030",
              "III — Élément moral",
            ),
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/mineurs_famille_pages/autorite_parentale/non_representation_enfant_mineur_contenu_page.dart",
                  "f00031",
                  "Conscience de faire échec aux droits de celui qui réclame l’enfant",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/mineurs_famille_pages/autorite_parentale/non_representation_enfant_mineur_contenu_page.dart",
                      "f00032",
                      "La non-représentation d’enfant est une infraction intentionnelle. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/mineurs_famille_pages/autorite_parentale/non_representation_enfant_mineur_contenu_page.dart",
                      "f00033",
                      "Le terme « refus » implique une attitude consciente et volontaire, et l’adverbe « indûment » souligne la mauvaise foi.",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/mineurs_famille_pages/autorite_parentale/non_representation_enfant_mineur_contenu_page.dart",
                      "f00034",
                      "L’auteur doit agir en pleine connaissance de cause des droits qu’il empêche de s’exercer. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/mineurs_famille_pages/autorite_parentale/non_representation_enfant_mineur_contenu_page.dart",
                      "f00035",
                      "Une décision préalable doit donc, en principe, lui avoir été signifiée ou portée à sa connaissance.",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/mineurs_famille_pages/autorite_parentale/non_representation_enfant_mineur_contenu_page.dart",
                  "f00036",
                  "Jurisprudence",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/mineurs_famille_pages/autorite_parentale/non_representation_enfant_mineur_contenu_page.dart",
                      "f00037",
                      "Élément intentionnel caractérisé par le refus délibéré de remettre l’enfant à la personne qui a le droit de le réclamer, quel que soit le mobile, en l’absence de tout danger actuel ou imminent — ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/mineurs_famille_pages/autorite_parentale/non_representation_enfant_mineur_contenu_page.dart",
                      "f00038",
                      "Cass. crim., 08 septembre 1999",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/mineurs_famille_pages/autorite_parentale/non_representation_enfant_mineur_contenu_page.dart",
                  "f00039",
                  "Le mobile importe peu. La justification peut être admise si un danger actuel et imminent est démontré (faits justificatifs).",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Circonstances aggravantes
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/mineurs_famille_pages/autorite_parentale/non_representation_enfant_mineur_contenu_page.dart",
              "f00040",
              "IV — Circonstances aggravantes",
            ),
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/mineurs_famille_pages/autorite_parentale/non_representation_enfant_mineur_contenu_page.dart",
                    "f00041",
                    "Article 227-9 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " :"),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/mineurs_famille_pages/autorite_parentale/non_representation_enfant_mineur_contenu_page.dart",
                  "f00042",
                  "Si l’enfant mineur est retenu au-delà de cinq jours sans que ceux qui ont droit de le réclamer sachent où il se trouve.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/mineurs_famille_pages/autorite_parentale/non_representation_enfant_mineur_contenu_page.dart",
                  "f00043",
                  "Si l’enfant mineur est retenu indûment hors du territoire de la République.",
                ),
              ),
              SizedBox(height: 12),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/mineurs_famille_pages/autorite_parentale/non_representation_enfant_mineur_contenu_page.dart",
                    "f00044",
                    "Article 227-10 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/mineurs_famille_pages/autorite_parentale/non_representation_enfant_mineur_contenu_page.dart",
                    "f00045",
                    " : si l’auteur a été déchu de l’autorité parentale ou fait l’objet d’une décision de retrait de l’exercice de cette autorité.",
                  ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Répression + tentative/complicité
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/mineurs_famille_pages/autorite_parentale/non_representation_enfant_mineur_contenu_page.dart",
              "f00046",
              "V — Répression",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/mineurs_famille_pages/autorite_parentale/non_representation_enfant_mineur_contenu_page.dart",
                  "f00047",
                  "Peines encourues — personnes physiques",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/mineurs_famille_pages/autorite_parentale/non_representation_enfant_mineur_contenu_page.dart",
                    "f00048",
                    "Qualification simple — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/mineurs_famille_pages/autorite_parentale/non_representation_enfant_mineur_contenu_page.dart",
                    "f00049",
                    "article 227-5 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " :"),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/mineurs_famille_pages/autorite_parentale/non_representation_enfant_mineur_contenu_page.dart",
                  "f00050",
                  "1 an d’emprisonnement.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/mineurs_famille_pages/autorite_parentale/non_representation_enfant_mineur_contenu_page.dart",
                  "f00051",
                  "15 000 € d’amende.",
                ),
              ),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/mineurs_famille_pages/autorite_parentale/non_representation_enfant_mineur_contenu_page.dart",
                  "f00052",
                  "Peines en cas d’aggravation",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/mineurs_famille_pages/autorite_parentale/non_representation_enfant_mineur_contenu_page.dart",
                    "f00053",
                    "Si une circonstance prévue par ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/mineurs_famille_pages/autorite_parentale/non_representation_enfant_mineur_contenu_page.dart",
                    "f00054",
                    "l’article 227-9 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " ou "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/mineurs_famille_pages/autorite_parentale/non_representation_enfant_mineur_contenu_page.dart",
                    "f00055",
                    "l’article 227-10 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/mineurs_famille_pages/autorite_parentale/non_representation_enfant_mineur_contenu_page.dart",
                    "f00056",
                    " est caractérisée :",
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/mineurs_famille_pages/autorite_parentale/non_representation_enfant_mineur_contenu_page.dart",
                  "f00057",
                  "3 ans d’emprisonnement.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/mineurs_famille_pages/autorite_parentale/non_representation_enfant_mineur_contenu_page.dart",
                  "f00058",
                  "45 000 € d’amende.",
                ),
              ),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/mineurs_famille_pages/autorite_parentale/non_representation_enfant_mineur_contenu_page.dart",
                  "f00059",
                  "Personnes morales",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/mineurs_famille_pages/autorite_parentale/non_representation_enfant_mineur_contenu_page.dart",
                    "f00060",
                    "Responsabilité pénale possible via ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/mineurs_famille_pages/autorite_parentale/non_representation_enfant_mineur_contenu_page.dart",
                    "f00061",
                    "l’article 121-2 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/mineurs_famille_pages/autorite_parentale/non_representation_enfant_mineur_contenu_page.dart",
                    "f00062",
                    " (applicable depuis le 31 décembre 2005).",
                  ),
                ),
              ]),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/mineurs_famille_pages/autorite_parentale/non_representation_enfant_mineur_contenu_page.dart",
                  "f00063",
                  "Tentative & complicité",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/mineurs_famille_pages/autorite_parentale/non_representation_enfant_mineur_contenu_page.dart",
                  "f00064",
                  "Tentative : NON.",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/mineurs_famille_pages/autorite_parentale/non_representation_enfant_mineur_contenu_page.dart",
                    "f00065",
                    "Complicité : OUI, conformément à ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/mineurs_famille_pages/autorite_parentale/non_representation_enfant_mineur_contenu_page.dart",
                    "f00066",
                    "l’article 121-7 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/mineurs_famille_pages/autorite_parentale/non_representation_enfant_mineur_contenu_page.dart",
                    "f00067",
                    " (aide et assistance, provocation, instructions).",
                  ),
                ),
              ]),

              SizedBox(height: 12),

              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/mineurs_famille_pages/autorite_parentale/non_representation_enfant_mineur_contenu_page.dart",
                  "f00068",
                  "Jurisprudence",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/mineurs_famille_pages/autorite_parentale/non_representation_enfant_mineur_contenu_page.dart",
                      "f00069",
                      "Complicité retenue du grand-père ayant encouragé son fils à ne pas rendre l’enfant et s’étant opposé à l’intervention d’un huissier, allant jusqu’à financer un départ à l’étranger — ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/mineurs_famille_pages/autorite_parentale/non_representation_enfant_mineur_contenu_page.dart",
                      "f00070",
                      "Cass. crim., 19 février 1963",
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
