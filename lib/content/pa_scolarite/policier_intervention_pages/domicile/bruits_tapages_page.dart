import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PaBruitsTapagesPage extends StatelessWidget {
  const PaBruitsTapagesPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/policier_intervention/domicile/bruits-tapages';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

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
            "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          "Domicile",
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
              "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
              "f00002",
              "Les bruits et tapages",
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Contexte / idée générale
          _ConditionCard(
            title: "Comprendre",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                      "f00003",
                      "Les bruits portant atteinte à la tranquillité publique peuvent avoir des origines très diverses ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                      "f00004",
                      "(domestiques, chantiers, activités professionnelles, tapage nocturne, disputes bruyantes…). ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                      "f00005",
                      "Selon la nature du bruit, les textes applicables et la procédure diffèrent : parfois sans mesure acoustique, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                      "f00006",
                      "parfois avec sonomètre.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal EN HAUT (textes principaux)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
              "f00007",
              "I — Élément légal (textes principaux)",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                    "f00008",
                    "Article R. 1336-5 du Code de la santé publique",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                    "f00009",
                    " : bruits de voisinage d’origine domestique (durée, répétition ou intensité portant atteinte à la tranquillité).",
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                    "f00010",
                    "Article R. 1336-10 du Code de la santé publique",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                    "f00011",
                    " : bruits de chantier (travaux soumis à déclaration/autorisation) avec conditions spécifiques.",
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                    "f00012",
                    "Article R. 1336-6 du Code de la santé publique",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                    "f00013",
                    " : bruits excessifs relevant d’activités (professionnelles, sportives, culturelles, loisirs) pouvant nécessiter une mesure.",
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                    "f00014",
                    "Article R. 623-2 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                    "f00015",
                    " : bruits ou tapages injurieux ou nocturnes troublant la tranquillité d’autrui.",
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                      "f00016",
                      "Selon le cadre (CSP / CP), la classe de contravention, la procédure (amende forfaitaire) et les peines complémentaires peuvent varier.",
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Bruits de voisinage sans mesure
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
              "f00017",
              "II — Bruits constatés sans mesure acoustique",
            ),
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                  "f00018",
                  "A) Bruits d’origine domestique",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                    "f00019",
                    "Article R. 1336-5 du Code de la santé publique",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                        "f00020",
                        " : s’applique aux bruits résultant du comportement d’une personne (ou d’une chose/animal dont elle a la garde) ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                        "f00021",
                        "dès lors qu’ils portent atteinte à la tranquillité du voisinage par leur durée, leur répétition ou leur intensité.",
                      ),
                ),
              ]),
              SizedBox(height: 10),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                  "f00022",
                  "Exemples : cris d’animaux, musique, diffusion de son, jeux bruyants, fêtes familiales, travaux, outils, pièces d’artifice…",
                ),
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                    "f00023",
                    "Répression : amende 4e classe — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                    "f00024",
                    "article R. 1337-7 du Code de la santé publique",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                    "f00025",
                    "Amende forfaitaire possible — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                    "f00026",
                    "article R. 48-1 du Code de procédure pénale",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                    "f00027",
                    "Peine complémentaire possible : confiscation — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                    "f00028",
                    "article R. 1337-8 du Code de la santé publique",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                    "f00029",
                    " (sauf amende forfaitaire).",
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                    "f00030",
                    "Complicité (aide/assistance) : même peine — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                    "f00031",
                    "article R. 1337-9 du Code de la santé publique",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                  "f00032",
                  "B) Bruits de chantier",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                    "f00033",
                    "Article R. 1336-10 du Code de la santé publique",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                        "f00034",
                        " : vise les bruits provenant de chantiers (travaux publics/privés) soumis à déclaration ou autorisation, ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                        "f00035",
                        "lorsqu’ils troublent le voisinage.",
                      ),
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                      "f00036",
                      "Le trouble est caractérisé notamment en cas de :\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                      "f00037",
                      "• non-respect des conditions fixées par l’autorité compétente (réalisation des travaux, matériels, équipements)\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                      "f00038",
                      "• insuffisance de précautions appropriées pour limiter le bruit\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                      "f00039",
                      "• comportement anormalement bruyant",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                    "f00040",
                    "Répression : amende 5e classe — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                    "f00041",
                    "article R. 1337-6 du Code de la santé publique",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                    "f00042",
                    "Confiscation possible — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                    "f00043",
                    "article R. 1337-8 du Code de la santé publique",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                    "f00044",
                    "Complicité (aide/assistance) : même peine — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                    "f00045",
                    "article R. 1337-9 du Code de la santé publique",
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
                          "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                          "f00046",
                          "Le bricolage ou des travaux non soumis à déclaration/autorisation ne relèvent pas de ce régime spécifique : ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                          "f00047",
                          "ils sont en pratique traités via les textes des bruits domestiques.",
                        ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Mesure acoustique
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
              "f00048",
              "III — Bruits nécessitant une mesure acoustique",
            ),
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                    "f00049",
                    "Article R. 1336-6 du Code de la santé publique",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                    "f00050",
                    " : liste des bruits excessifs pouvant nécessiter un recours au sonomètre.",
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                      "f00051",
                      "Il s’agit notamment des bruits ayant pour origine :\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                      "f00052",
                      "• une activité professionnelle (hors chantier)\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                      "f00053",
                      "• une activité sportive\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                      "f00054",
                      "• une activité culturelle ou de loisirs\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                      "f00055",
                      "\nDans ces cas, l’activité est habituelle ou soumise à autorisation, et les conditions d’exercice relatives au bruit ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                      "f00056",
                      "n’ont pas été fixées par l’autorité compétente.",
                    ),
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                  "f00057",
                  "Sont aussi concernés les établissements devant prévoir une isolation acoustique ou les locaux recevant du public diffusant habituellement de la musique amplifiée.",
                ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                  "f00058",
                  "Le non-respect des prescriptions applicables est susceptible d’être sanctionné par des contraventions de 5e classe.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Agents habilités
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
              "f00059",
              "IV — Agents habilités à constater",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                  "f00060",
                  "Sont notamment habilités à constater les infractions :",
                ),
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                  "f00061",
                  "O.P.J, A.P.J, A.P.J.A (dans le cadre des dispositions du Code de procédure pénale).",
                ),
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                      "f00062",
                      "Agents des douanes, répression des fraudes, inspecteurs installations classées, agents commissionnés et assermentés ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                      "f00063",
                      "(environnement, agriculture, industrie, équipement, transports, mer, santé, jeunesse et sports), inspecteurs de salubrité, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                      "f00064",
                      "agents des collectivités locales.",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                    "f00065",
                    "Fondement : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                    "f00066",
                    "article L. 571-18 du Code de l’environnement",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                      "f00067",
                      "Ces agents peuvent, après accord du procureur de la République, procéder à des constatations en matière de bruits de voisinage.",
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Tapage CP : rendu pédagogique 3 éléments
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
              "f00068",
              "V — Tapage (Code pénal) : les 3 éléments",
            ),
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                  "f00069",
                  "A) Élément légal",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                    "f00070",
                    "Article R. 623-2 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                    "f00071",
                    " : incrimine les bruits ou tapages injurieux ou nocturnes troublant la tranquillité d’autrui.",
                  ),
                ),
              ]),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                  "f00072",
                  "B) Élément matériel",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                      "f00073",
                      "Le tapage peut être compris comme une série de bruits tumultueux (vacarme, brouhaha), ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                      "f00074",
                      "de nature à troubler la tranquillité publique.\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                      "f00075",
                      "\n• Tapage nocturne : entre le coucher et le lever du soleil.\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                      "f00076",
                      "• Tapage injurieux : disputes violentes et bruyantes, vociférations, invectives, grossièretés…\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                      "f00077",
                      "\nLe bruit peut provenir d’une ou plusieurs personnes, d’un animal ou d’une chose (aboiements, musique, télévision…). ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                      "f00078",
                      "Il suffit que le bruit soit perceptible à l’extérieur (voisins, passants), même si une seule personne est troublée.",
                    ),
              ),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                  "f00079",
                  "C) Élément moral",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                      "f00080",
                      "L’infraction est constituée si le bruit résulte d’un fait volontaire et personnel. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                      "f00081",
                      "L’idée-clé : l’auteur a conscience du trouble causé et refuse ou néglige de faire cesser le tapage.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Répression / procédures
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
              "f00082",
              "VI — Répression & procédure",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                  "f00083",
                  "Tapage (Code pénal)",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                    "f00084",
                    "Contravention 3e classe — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                    "f00085",
                    "article R. 623-2 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                    "f00086",
                    "Amende forfaitaire applicable — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                    "f00087",
                    "article R. 48-1 du Code de procédure pénale",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                  "f00088",
                  "Une peine complémentaire de confiscation peut être prononcée (selon les cas, notamment hors amende forfaitaire).",
                ),
              ),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                  "f00089",
                  "Bruits domestiques / chantier (CSP)",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                    "f00090",
                    "Bruits domestiques : 4e classe — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                    "f00091",
                    "article R. 1337-7 du Code de la santé publique",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                    "f00092",
                    "Bruits de chantier : 5e classe — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                    "f00093",
                    "article R. 1337-6 du Code de la santé publique",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                    "f00094",
                    "Confiscation (CSP) — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                    "f00095",
                    "article R. 1337-8 du Code de la santé publique",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Tentative & complicité (rendu clean)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
              "f00096",
              "VII — Tentative & complicité",
            ),
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _SubTitle("Tentative"),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                  "f00097",
                  "En matière de contraventions, la tentative n’est en principe pas punissable (sauf texte spécial).",
                ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                  "f00098",
                  "Complicité",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                    "f00099",
                    "Pour les bruits relevant du CSP : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                    "f00100",
                    "article R. 1337-9 du Code de la santé publique",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                    "f00101",
                    " (aide ou assistance).",
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                    "f00102",
                    "Pour le tapage (CP) : la complicité est visée dans ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                    "f00103",
                    "l’article R. 623-2 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                    "f00104",
                    " (alinéa relatif à la complicité).",
                  ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Synthèse opérationnelle (codes)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
              "f00105",
              "VIII — Synthèse opérationnelle (rappels)",
            ),
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                  "f00106",
                  "Repères utiles en intervention (sans mesure acoustique) :",
                ),
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                  "f00107",
                  "Tapage injurieux diurne : bruits/tapage injurieux troublant la tranquillité d’autrui (contravention 3e classe).",
                ),
              ),
              SizedBox(height: 6),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                  "f00108",
                  "Tapage nocturne : bruits/tapage nocturne troublant la tranquillité d’autrui (contravention 3e classe).",
                ),
              ),
              SizedBox(height: 6),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                  "f00109",
                  "Bruits domestiques : atteinte à la tranquillité du voisinage par durée/répétition/intensité (contravention 4e classe).",
                ),
              ),
              SizedBox(height: 6),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                  "f00110",
                  "Bruits de chantier (soumis à déclaration/autorisation) : conditions spécifiques + contravention 5e classe.",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                          "f00111",
                          "Toujours qualifier selon l’origine (domestique / chantier / activité / tapage CP). ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart",
                          "f00112",
                          "C’est la qualification qui conditionne la procédure (forfaitaire ou non), la classe de contravention et les suites.",
                        ),
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
