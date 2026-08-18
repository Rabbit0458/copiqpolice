import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PaNonAssistancePersonnePerilPage extends StatelessWidget {
  const PaNonAssistancePersonnePerilPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/atteintes_personnes/mise_en_danger/non_assistance_personne_peril';

  static const _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette cartes (cohérente avec tes autres pages)
    final Color card1 = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color card2 = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color card3 = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color card4 = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);
    final Color card5 = isDark
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
            "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
            "f00002",
            "Mise en danger",
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
              "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
              "f00003",
              "La non-assistance à personne en péril",
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
              "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
              "f00004",
              "Définition",
            ),
            cardColor: card5,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
                      "f00005",
                      "Le fait, pour quiconque, de s’abstenir volontairement de porter à une personne en péril ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
                      "f00006",
                      "l’assistance que, sans risque pour lui ou pour les tiers, il pouvait lui prêter ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
                      "f00007",
                      "soit par son action personnelle, soit en provoquant un secours, constitue une infraction.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
              "f00008",
              "I — Élément légal",
            ),
            cardColor: card1,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
                    "f00009",
                    "Article 223-6 alinéa 2 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
                    "f00010",
                    " : incrimination.\n",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
                    "f00011",
                    "Article 223-6 alinéa 1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
                    "f00012",
                    " : peine applicable.",
                  ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Élément matériel
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
              "f00013",
              "II — Élément matériel",
            ),
            cardColor: card2,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
                  "f00014",
                  "Le délit consiste à s’abstenir d’aider autrui dans une situation de péril.",
                ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
                  "f00015",
                  "A) Imminence d’un péril",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
                      "f00016",
                      "Le péril doit être caractérisé et non simplement présumé : il doit être impérativement et ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
                      "f00017",
                      "expressément constaté. La notion de péril suppose un danger présent : les risques éventuels ou ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
                      "f00018",
                      "hypothétiques ne suffisent pas.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Jurisprudence (imminence)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
              "f00019",
              "Jurisprudence — imminence",
            ),
            cardColor: card4,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
                        "f00020",
                        "Des médecins qui s’abstiennent de faire passer un test de dépistage du sida à une patiente ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
                        "f00021",
                        "polytransfusée ne sont pas coupables de non-assistance, car le caractère imminent du péril n’est pas établi. ",
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
                    "f00022",
                    "(Cass. crim., 4 novembre 1999)",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
                    "f00023",
                    "C.A. Poitiers, 03 février 1977",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
                    "f00024",
                    " : le péril doit être constaté expressément, pas seulement présumé.",
                  ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Matériel : nature du péril + cause indifférente
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
              "f00025",
              "II — Élément matériel (suite)",
            ),
            cardColor: card2,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
                  "f00026",
                  "B) Nature du péril",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
                      "f00027",
                      "L’état de péril correspond à un état dangereux ou une situation critique qui fait craindre ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
                      "f00028",
                      "de graves conséquences : risque de mort ou d’atteintes corporelles graves.",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
                      "f00029",
                      "Le péril peut être d’origine ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
                      "f00030",
                      "naturelle, accidentelle ou infractionnelle. ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
                      "f00031",
                      "\nPrincipe d’indifférence confirmé par ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
                      "f00032",
                      "Cass. crim., 31 mai 1949",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
                      "f00033",
                      " : aucune distinction selon la cause ou la nature du péril.",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
                  "f00034",
                  "C) L’auteur du péril est indifférent",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
                      "f00035",
                      "Peu importe que le péril soit le fait d’un tiers, du débiteur de l’obligation de secours ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
                      "f00036",
                      "ou même de la victime. Il est fréquent que l’auteur d’un accident soit la personne la mieux placée ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
                      "f00037",
                      "pour porter les premiers secours.",
                    ),
              ),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
                    "f00038",
                    "Exemple : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
                    "f00039",
                    "Cass. crim., 04 mars 1998",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
                    "f00040",
                    " : l’auteur d’un accident qui néglige de porter secours peut être coupable.",
                  ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Cumul avec violences volontaires
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
              "f00041",
              "Cumul de qualifications",
            ),
            cardColor: card1,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
                      "f00042",
                      "Les qualifications de violences volontaires et de non-assistance à personne en péril peuvent ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
                      "f00043",
                      "être retenues cumulativement si elles sont constituées dans des temps d’action différents.",
                    ),
              ),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
                    "f00044",
                    "Cass. crim., 24 juin 1980",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
                    "f00045",
                    " : l’inculpation de violences n’est pas nécessairement exclusive de celle d’abstention volontaire de porter secours.",
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
                    "f00046",
                    "Cass. crim., 22 mars 2016",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
                    "f00047",
                    " : deux temps d’action différents → poursuites concomitantes possibles.",
                  ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Absence d'assistance + modalités + efficacité
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
              "f00048",
              "II — Élément matériel (points clés)",
            ),
            cardColor: card2,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
                  "f00049",
                  "D) Une absence d’assistance",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
                      "f00050",
                      "Infraction formelle : elle existe du seul fait de l’abstention de secours. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
                      "f00051",
                      "L’assistance doit être suffisante (apte à faire cesser le péril), mais peu importe qu’elle réussisse.",
                    ),
              ),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
                    "f00052",
                    "C.A. Nancy, 27 octobre 1965",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
                    "f00053",
                    " : l’infraction n’est pas de ne pas avoir sauvé, mais de ne pas avoir prêté une aide.",
                  ),
                ),
              ]),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
                  "f00054",
                  "E) Possibilité d’intervenir",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
                      "f00055",
                      "Le délit vise une abstention d’assistance à la victime, pas une abstention de combattre le péril. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
                      "f00056",
                      "On ne peut pas se défendre en disant que le secours aurait été inefficace.",
                    ),
              ),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
                    "f00057",
                    "Cass. crim., 23 mars 1953",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
                    "f00058",
                    " : l’auteur ne peut invoquer l’inefficacité supposée du secours.",
                  ),
                ),
              ]),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
                  "f00059",
                  "F) Nature de l’assistance : agir ou provoquer un secours",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
                      "f00060",
                      "L’assistance peut consister à agir personnellement ou à rechercher/provoquer l’intervention d’autrui. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
                      "f00061",
                      "Mais l’appel à autrui ne suffit pas si une action personnelle aurait été manifestement plus efficace.",
                    ),
              ),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
                    "f00062",
                    "Cass. crim., 26 juillet 1954",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
                    "f00063",
                    " : obligation d’intervenir par le mode que la nécessité commande, voire cumulativement.",
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
                    "f00064",
                    "Cass. crim., 07 mars 1991",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
                    "f00065",
                    " : tenter de provoquer un secours n’exclut pas le délit si une action immédiate était possible sans risque.",
                  ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Absence de risque
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
              "f00066",
              "Condition essentielle",
            ),
            cardColor: card5,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
                  "f00067",
                  "Une absence de risque pour soi-même ou pour autrui",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
                      "f00068",
                      "La loi n’impose ni héroïsme ni témérité : l’assistance doit pouvoir être apportée sans risque ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
                      "f00069",
                      "pour l’intervenant ou pour les tiers.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Élément moral
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
              "f00070",
              "III — Élément moral",
            ),
            cardColor: card3,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
                        "f00071",
                        "Pour que le délit soit constitué, il faut que la personne ait connu l’existence d’un péril ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
                        "f00072",
                        "immédiat et constant rendant son intervention nécessaire, et qu’elle ait volontairement refusé ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
                        "f00073",
                        "d’intervenir par les modes possibles. ",
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
                    "f00074",
                    "(Cass. crim., 25 juin 1964)",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
                  "f00075",
                  "A) Conscience du péril imminent",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
                    "f00076",
                    "Le délit n’est constitué que si le prévenu a eu conscience du degré de gravité du péril et s’est abstenu volontairement. ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
                    "f00077",
                    "(Cass. crim., 3 février 1993)",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
                          "f00078",
                          "Exemple : un pilote d’avion militaire survolant à basse altitude un accident d’hélicoptère dont il est à l’origine ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
                          "f00079",
                          "ne pouvait ignorer que les occupants avaient besoin de soins urgents. ",
                        ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
                      "f00080",
                      "(Cass. crim., 04 mars 1998)",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
                  "f00081",
                  "B) Volonté de ne pas agir",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
                      "f00082",
                      "Elle se traduit par une volonté consciente et assumée de ne pas porter assistance à une personne ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
                      "f00083",
                      "que l’on sait en péril.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Circonstances aggravantes
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
              "f00084",
              "IV — Circonstances aggravantes",
            ),
            cardColor: card1,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
                    "f00085",
                    "Article 223-6 alinéa 3 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " :"),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
                  "f00086",
                  "Lorsque la personne en péril est un mineur de 15 ans.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Répression + personnes morales + tentative/complicité
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
              "f00087",
              "V — Répression",
            ),
            cardColor: card2,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
                  "f00088",
                  "Peines encourues — personnes physiques",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
                    "f00089",
                    "Qualification simple : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
                    "f00090",
                    "5 ans d’emprisonnement et 75 000 € d’amende. ",
                  ),
                ),
                TextSpan(text: "— "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
                    "f00091",
                    "article 223-6 alinéa 2 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
                    "f00092",
                    "Qualification aggravée : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
                    "f00093",
                    "7 ans d’emprisonnement et 100 000 € d’amende. ",
                  ),
                ),
                TextSpan(text: "— "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
                    "f00094",
                    "article 223-6 alinéa 3 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
                  "f00095",
                  "Personnes morales",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
                    "f00096",
                    "Responsabilité pénale prévue par ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
                    "f00097",
                    "l’article 223-7-1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
                  "f00098",
                  "Tentative & complicité",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
                  "f00099",
                  "Tentative : NON (non punissable).",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
                    "f00100",
                    "Complicité : OUI, conformément à ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
                    "f00101",
                    "l’article 121-6 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " et "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart",
                    "f00102",
                    "l’article 121-7 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
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
  const _NotaBox({required this.bodySpans});

  final List<TextSpan> bodySpans;
  final String title = 'NOTA';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color borderColor = isDark
        ? const Color(0xFFFFCA28)
        : const Color(0xFFF9A825);
    final Color bgColor = isDark
        ? const Color(0xFF26200F)
        : const Color(0xFFFFF8E1);

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
          children: [...bodySpans],
        ),
      ),
    );
  }
}
