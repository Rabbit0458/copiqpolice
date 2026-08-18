import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class ViolencesHabituellesCoupleExPage extends StatelessWidget {
  const ViolencesHabituellesCoupleExPage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_couple_ex';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette cards (propre + lisible)
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
            "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_couple_ex_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_couple_ex_page.dart",
            "f00002",
            "Atteintes volontaires à l’intégrité",
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
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_couple_ex_page.dart",
              "f00003",
              "Les violences habituelles au sein du couple (ou commises par un « ex »)",
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
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_couple_ex_page.dart",
              "f00004",
              "Définition",
            ),
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_couple_ex_page.dart",
                      "f00005",
                      "Les violences habituelles commises par le conjoint ou le concubin de la victime, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_couple_ex_page.dart",
                      "f00006",
                      "ou par le partenaire lié à celle-ci par un pacte civil de solidarité, constituent une infraction. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_couple_ex_page.dart",
                      "f00007",
                      "Le même régime s’applique lorsque les faits sont commis par un ancien conjoint/concubin/partenaire (« ex »), ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_couple_ex_page.dart",
                      "f00008",
                      "dès lors qu’ils sont commis en raison des relations ayant existé.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_couple_ex_page.dart",
              "f00009",
              "I — Élément légal",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_couple_ex_page.dart",
                    "f00010",
                    "Article 222-14 alinéa 6 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_couple_ex_page.dart",
                        "f00011",
                        " : définit les violences habituelles au sein du couple ou commises par un « ex » ; ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_couple_ex_page.dart",
                        "f00012",
                        "les alinéas 2 à 5 précisent la répression selon la gravité du résultat.",
                      ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Élément matériel
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_couple_ex_page.dart",
              "f00013",
              "II — Élément matériel",
            ),
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_couple_ex_page.dart",
                  "f00014",
                  "A) Un acte positif",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_couple_ex_page.dart",
                      "f00015",
                      "Les violences supposent un acte : une action positive. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_couple_ex_page.dart",
                      "f00016",
                      "La simple abstention ne constitue pas une violence (d’autres qualifications peuvent alors s’appliquer : privation de soins, etc.).",
                    ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_couple_ex_page.dart",
                  "f00017",
                  "1) Un contact physique (direct ou indirect)",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_couple_ex_page.dart",
                      "f00018",
                      "Sont compris tous les comportements impliquant un contact physique entre l’auteur et la victime ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_couple_ex_page.dart",
                      "f00019",
                      "(coups, gifles, morsures, etc.). Le contact peut être indirect : l’auteur peut utiliser un moyen ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_couple_ex_page.dart",
                      "f00020",
                      "pour atteindre la victime (arme, objet, animal excité, etc.).",
                    ),
              ),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_couple_ex_page.dart",
                  "f00021",
                  "2) Une atteinte psychique (violences psychologiques)",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_couple_ex_page.dart",
                        "f00022",
                        "Le délit de violences peut être constitué même sans atteinte physique, par tout acte de nature à impressionner vivement la victime ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_couple_ex_page.dart",
                        "f00023",
                        "et à lui causer un choc émotif ",
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_couple_ex_page.dart",
                    "f00024",
                    "(Cass. crim., 18 mars 2008, n° 07-86.075)",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_couple_ex_page.dart",
                    "f00025",
                    "Cette approche est codifiée par ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_couple_ex_page.dart",
                    "f00026",
                    "l’article 222-14-3 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_couple_ex_page.dart",
                        "f00027",
                        " : les violences au sens des articles 222-7 et suivants sont constituées quelle que soit leur nature, ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_couple_ex_page.dart",
                        "f00028",
                        "y compris lorsqu’il s’agit de violences psychologiques.",
                      ),
                ),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_couple_ex_page.dart",
                      "f00029",
                      "Jurisprudence : individu descendant de sa voiture avec une barre de fer et frappant l’arrière du véhicule de la victime ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_couple_ex_page.dart",
                      "f00030",
                      "(Cass. crim., 18 mars 2008)",
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
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_couple_ex_page.dart",
                  "f00031",
                  "B) Des violences habituelles (répétition)",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_couple_ex_page.dart",
                      "f00032",
                      "L’habitude suppose que les violences aient été commises à plusieurs reprises. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_couple_ex_page.dart",
                      "f00033",
                      "Ce n’est pas un fait isolé : c’est la répétition qui caractérise l’habitude.",
                    ),
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_couple_ex_page.dart",
                  "f00034",
                  "C) Un lien particulier entre la victime et l’auteur",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_couple_ex_page.dart",
                  "f00035",
                  "L’infraction vise :",
                ),
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_couple_ex_page.dart",
                  "f00036",
                  "Le conjoint, le concubin ou le partenaire lié par un pacte civil de solidarité (même sans cohabitation).",
                ),
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_couple_ex_page.dart",
                        "f00037",
                        "Le régime s’étend à l’« ex » : la circonstance aggravante est constituée lorsque les faits sont commis par l’ancien conjoint, l’ancien concubin ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_couple_ex_page.dart",
                        "f00038",
                        "ou l’ancien partenaire lié par un pacte civil de solidarité, dès lors que l’infraction est commise en raison des relations ayant existé ",
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_couple_ex_page.dart",
                    "f00039",
                    "(article 132-80 alinéa 2 du Code pénal)",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_couple_ex_page.dart",
                  "f00040",
                  "D) Un résultat dommageable",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_couple_ex_page.dart",
                      "f00041",
                      "Les violences supposent une atteinte à l’intégrité physique et/ou psychique de la personne. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_couple_ex_page.dart",
                      "f00042",
                      "La réalité de l’atteinte doit être établie (notamment par certificat médical).",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_couple_ex_page.dart",
                      "f00043",
                      "Selon l’article 222-14 du Code pénal, la gravité est appréciée selon que les violences :\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_couple_ex_page.dart",
                      "f00044",
                      "• ont entraîné la mort ;\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_couple_ex_page.dart",
                      "f00045",
                      "• ont entraîné une mutilation ou une infirmité permanente ;\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_couple_ex_page.dart",
                      "f00046",
                      "• ont entraîné une I.T.T. > 8 jours ;\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_couple_ex_page.dart",
                      "f00047",
                      "• n’ont pas entraîné d’I.T.T. > 8 jours.",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_couple_ex_page.dart",
                      "f00048",
                      "Jurisprudence : brimades ayant plongé une salariée dans un état anxio-dépressif grave avec I.T.T. > 8 jours ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_couple_ex_page.dart",
                      "f00049",
                      "(Cass. crim., 4 mars 2003)",
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

          // Élément moral
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_couple_ex_page.dart",
              "f00050",
              "III — Élément moral",
            ),
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_couple_ex_page.dart",
                      "f00051",
                      "Le délit est consommé lorsque les violences sont intentionnelles : ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_couple_ex_page.dart",
                      "f00052",
                      "l’auteur agit avec la conscience que son acte va affecter l’intégrité physique et/ou psychique d’autrui.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Circonstances aggravantes
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_couple_ex_page.dart",
              "f00053",
              "IV — Circonstances aggravantes",
            ),
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_couple_ex_page.dart",
                  "f00054",
                  "Aucune (au titre de cette fiche).",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Répression + tentative/complicité
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_couple_ex_page.dart",
              "f00055",
              "V — Répression",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_couple_ex_page.dart",
                  "f00056",
                  "Peines encourues — personnes physiques",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_couple_ex_page.dart",
                    "f00057",
                    "Violences habituelles (I.T.T. de 0 à 8 jours) : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_couple_ex_page.dart",
                    "f00058",
                    "5 ans d’emprisonnement et 75 000 € d’amende — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_couple_ex_page.dart",
                    "f00059",
                    "article 222-14 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_couple_ex_page.dart",
                    "f00060",
                    "Violences habituelles (I.T.T. > 8 jours) : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_couple_ex_page.dart",
                    "f00061",
                    "10 ans d’emprisonnement et 150 000 € d’amende — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_couple_ex_page.dart",
                    "f00062",
                    "article 222-14 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_couple_ex_page.dart",
                    "f00063",
                    "Mutilation ou infirmité permanente : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_couple_ex_page.dart",
                    "f00064",
                    "20 ans de réclusion criminelle + période de sûreté — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_couple_ex_page.dart",
                    "f00065",
                    "article 222-14 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_couple_ex_page.dart",
                    "f00066",
                    "Mort sans intention de la donner : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_couple_ex_page.dart",
                    "f00067",
                    "30 ans de réclusion criminelle + période de sûreté — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_couple_ex_page.dart",
                    "f00068",
                    "article 222-14 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_couple_ex_page.dart",
                  "f00069",
                  "Personnes morales",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_couple_ex_page.dart",
                    "f00070",
                    "Les personnes morales encourent les peines prévues par ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_couple_ex_page.dart",
                    "f00071",
                    "l’article 222-16-1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_couple_ex_page.dart",
                  "f00072",
                  "Tentative & complicité",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_couple_ex_page.dart",
                  "f00073",
                  "Tentative : NON pour les violences délictuelles (les textes ne visent pas la tentative).",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_couple_ex_page.dart",
                    "f00074",
                    "En matière criminelle, la tentative est théoriquement punissable, mais elle est difficile à établir car l’infraction dépend en partie du résultat (mort, infirmité, etc.). ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_couple_ex_page.dart",
                    "f00075",
                    "(article 121-4 (2°) du Code pénal)",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_couple_ex_page.dart",
                    "f00076",
                    "Complicité : OUI, conformément à ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_couple_ex_page.dart",
                    "f00077",
                    "l’article 121-6 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " et "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_couple_ex_page.dart",
                    "f00078",
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
