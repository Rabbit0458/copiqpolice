import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class RetributionInexistanteInsuffisantePersonneVulnerableDependantePage
    extends StatelessWidget {
  const RetributionInexistanteInsuffisantePersonneVulnerableDependantePage({
    super.key,
  });

  static const String routeName =
      '/gpx_scolarite_pages/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante';

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
            "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
            "f00002",
            "Atteintes à la dignité",
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
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
              "f00003",
              "La rétribution inexistante ou insuffisante du travail d’une personne vulnérable ou dépendante",
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
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
              "f00004",
              "Définition",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
                      "f00005",
                      "Le fait d’obtenir d’une personne dont la vulnérabilité ou l’état de dépendance sont apparents ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
                      "f00006",
                      "ou connus de l’auteur, la fourniture de services non rétribués ou en échange d’une rétribution ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
                      "f00007",
                      "manifestement sans rapport avec l’importance du travail accompli, constitue une infraction.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
              "f00008",
              "I — Élément légal",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
                    "f00009",
                    "Article 225-13 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
                    "f00010",
                    " : définit et réprime la rétribution inexistante ou insuffisante du travail d’une personne vulnérable ou dépendante.",
                  ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Élément matériel
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
              "f00011",
              "II — Élément matériel",
            ),
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
                  "f00012",
                  "A) La fourniture de services",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
                      "f00013",
                      "Il s’agit d’obtenir l’accomplissement d’un travail ou d’une tâche, et non la remise d’un bien ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
                      "f00014",
                      "ou d’une somme d’argent (qui peuvent relever d’autres incriminations).",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
                      "f00015",
                      "Exemple d’infraction voisine (hors champ de l’article 225-13) : ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
                      "f00016",
                      "article 223-15-2 du Code pénal",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
                      "f00017",
                      " (abus frauduleux de l’état d’ignorance / faiblesse).",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
                      "f00018",
                      "La loi vise une fourniture de services au pluriel : une simple prestation isolée ne suffit pas. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
                      "f00019",
                      "La réitération facilite la preuve de l’abus, qui peut se déduire de l’accomplissement journalier ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
                      "f00020",
                      "de tâches inadaptées.",
                    ),
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
                  "f00021",
                  "B) Absence ou insuffisance de rémunération",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
                    "f00022",
                    "Le texte vise : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
                    "f00023",
                    "l’absence totale de rétribution",
                  ),
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
                    "f00024",
                    " ou une ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
                    "f00025",
                    "rétribution manifestement sans rapport",
                  ),
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
                    "f00026",
                    " avec le travail accompli.",
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
                      "f00027",
                      "• Absence totale : appréciation stricte (aucune contrepartie, même en nature : logement, nourriture, etc.).\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
                      "f00028",
                      "• Insuffisance : appréciation par les juges du fond. Le non-respect du SMIC ou le non-paiement ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
                      "f00029",
                      "des heures supplémentaires ne suffisent pas : il faut une disproportion manifeste entre la rémunération ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
                      "f00030",
                      "et le travail accompli.",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
                      "f00031",
                      "Les juges peuvent comparer avec le salaire minimum de la profession, et procéder à des décomptes précis ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
                      "f00032",
                      "du temps de travail et de la rémunération pour faire apparaître l’absence de rapport.",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
                      "f00033",
                      "Si la rémunération est à ce point réduite qu’elle ne permet pas de satisfaire les besoins élémentaires, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
                      "f00034",
                      "et maintient la personne dans un rapport de dépendance, l’infraction est nécessairement constituée.",
                    ),
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
                  "f00035",
                  "C) Jurisprudences (illustrations)",
                ),
              ),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
                  "f00036",
                  "Jurisprudence",
                ),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
                          "f00037",
                          "Infraction retenue pour des stagiaires affectés à la réception de l’hôtel, ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
                          "f00038",
                          "de 23h à 7h, 7j/7 (56 à 63h/semaine), pour une rémunération de 1 760 francs ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
                          "f00039",
                          "pour 190 heures ",
                        ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
                      "f00040",
                      "(Cass. crim., 03 décembre 2002)",
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
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
                  "f00041",
                  "Jurisprudence",
                ),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
                          "f00042",
                          "Délit constitué pour le travail d’une jeune handicapée employée au magasin ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
                          "f00043",
                          "et au service domestique, moyennant seulement le gîte et le couvert ",
                        ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
                      "f00044",
                      "(T.A. Toulouse, 14 février 2002)",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
                  "f00045",
                  "D) Une victime vulnérable ou en état de dépendance",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
                      "f00046",
                      "La vulnérabilité ou la dépendance doivent être entendues largement, mais elles doivent être ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
                      "f00047",
                      "apparentes ou connues de l’auteur.\n\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
                      "f00048",
                      "• Vulnérabilité : liée à l’état physique ou mental (grossesse, âge, maladie, handicap…), ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
                      "f00049",
                      "ou à l’environnement économique/social/culturel (personnes immigrées, chômeurs, sans-abri…).\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
                      "f00050",
                      "• Dépendance : économique (précarité) ou morale (ascendant : maître/domestique, parents/enfants…).\n\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
                      "f00051",
                      "L’une ou l’autre doit exister (elles peuvent aussi se confondre).",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
                    "f00052",
                    "Présomption : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
                    "f00053",
                    "article 225-15-1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
                    "f00054",
                    " : présomption de vulnérabilité/dépendance concernant les mineurs et certaines victimes à leur arrivée sur le territoire français.",
                  ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Élément moral
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
              "f00055",
              "III — Élément moral",
            ),
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
                  "f00056",
                  "A) Conscience de la vulnérabilité / dépendance",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
                      "f00057",
                      "L’auteur doit mesurer la vulnérabilité ou l’état de dépendance de la victime. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
                      "f00058",
                      "Cet état doit être apparent ou connu.",
                    ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
                  "f00059",
                  "B) Conscience d’exiger des services non ou insuffisamment rétribués",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
                      "f00060",
                      "L’auteur sait qu’il n’obtient ces services à ce “prix” qu’en raison de la vulnérabilité ou ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
                      "f00061",
                      "de l’état de dépendance. L’intention libérale de la victime ne peut être invoquée lorsqu’il ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
                      "f00062",
                      "existe un rapport de domination (le bénévolat suppose le respect).",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Circonstances aggravantes
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
              "f00063",
              "IV — Circonstances aggravantes",
            ),
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
                  "f00064",
                  "Premier degré d’aggravation",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
                    "f00065",
                    "Article 225-15 I 1° du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
                    "f00066",
                    " : lorsque l’infraction est commise à l’égard de plusieurs personnes.",
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
                    "f00067",
                    "Article 225-15 II 1° du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
                    "f00068",
                    " : lorsqu’elle est commise à l’égard d’un mineur.",
                  ),
                ),
              ]),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
                  "f00069",
                  "Second degré d’aggravation",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
                    "f00070",
                    "Article 225-15 III 1° du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
                    "f00071",
                    " : lorsqu’elle est commise à l’égard de plusieurs personnes parmi lesquelles figurent un ou plusieurs mineurs.",
                  ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Répression + tentative/complicité
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
              "f00072",
              "V — Répression",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
                  "f00073",
                  "Peines encourues — personnes physiques",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
                    "f00074",
                    "Qualification simple : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
                    "f00075",
                    "5 ans d’emprisonnement et 150 000 € d’amende — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
                    "f00076",
                    "article 225-13 alinéa 1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
                    "f00077",
                    "Aggravée (1er degré) : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
                    "f00078",
                    "7 ans d’emprisonnement et 200 000 € d’amende — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
                    "f00079",
                    "articles 225-15 I 1° et 225-15 II 1° du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
                    "f00080",
                    "Aggravée (2nd degré) : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
                    "f00081",
                    "10 ans d’emprisonnement et 300 000 € d’amende — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
                    "f00082",
                    "article 225-15 III 1° du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
                  "f00083",
                  "Personnes morales",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
                    "f00084",
                    "Responsabilité expressément prévue par ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
                    "f00085",
                    "l’article 225-16 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
                    "f00086",
                    ". Peine d’amende selon ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
                    "f00087",
                    "l’article 131-38 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
                    "f00088",
                    " + peines complémentaires ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
                    "f00089",
                    "article 131-39 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
                    "f00090",
                    " (dissolution, interdictions, etc.).",
                  ),
                ),
              ]),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
                  "f00091",
                  "Tentative & complicité",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
                  "f00092",
                  "Tentative : NON.",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
                    "f00093",
                    "Complicité : OUI, conformément aux ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
                    "f00094",
                    "articles 121-6 et 121-7 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart",
                    "f00095",
                    " (aide/assistance, provocation, instructions données).",
                  ),
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
