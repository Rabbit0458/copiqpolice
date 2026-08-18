import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class ViolencesHabituellesMineurVulnerablePage extends StatelessWidget {
  const ViolencesHabituellesMineurVulnerablePage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_mineur_vulnerable';

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
            "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_mineur_vulnerable_contenu_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_mineur_vulnerable_contenu_page.dart",
            "f00002",
            "Atteintes volontaires",
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
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_mineur_vulnerable_contenu_page.dart",
              "f00003",
              "Les violences habituelles sur mineur ou personne vulnérable",
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
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_mineur_vulnerable_contenu_page.dart",
              "f00004",
              "Définition",
            ),
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_mineur_vulnerable_contenu_page.dart",
                        "f00005",
                        "Les violences habituelles commises sur un mineur de quinze ans ou sur une personne dont la particulière vulnérabilité ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_mineur_vulnerable_contenu_page.dart",
                        "f00006",
                        "(âge, maladie, infirmité, déficience physique ou psychique, grossesse) est apparente ou connue de l’auteur, ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_mineur_vulnerable_contenu_page.dart",
                        "f00007",
                        "ou encore sur une personne en état de sujétion psychologique ou physique, constituent une infraction.",
                      ),
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_mineur_vulnerable_contenu_page.dart",
                    "f00008",
                    "La sujétion est appréciée au sens de ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_mineur_vulnerable_contenu_page.dart",
                    "f00009",
                    "l’article 223-15-3 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_mineur_vulnerable_contenu_page.dart",
              "f00010",
              "I — Élément légal",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_mineur_vulnerable_contenu_page.dart",
                    "f00011",
                    "Article 222-14 du Code pénal (alinéa 1)",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_mineur_vulnerable_contenu_page.dart",
                    "f00012",
                    " : définit les violences habituelles sur mineur ou personne vulnérable.",
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_mineur_vulnerable_contenu_page.dart",
                    "f00013",
                    "Article 222-14 du Code pénal (alinéas 2 à 5)",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_mineur_vulnerable_contenu_page.dart",
                    "f00014",
                    " : fixe la répression selon le résultat.",
                  ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Élément matériel
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_mineur_vulnerable_contenu_page.dart",
              "f00015",
              "II — Élément matériel",
            ),
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_mineur_vulnerable_contenu_page.dart",
                  "f00016",
                  "A) Un acte positif de violences",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_mineur_vulnerable_contenu_page.dart",
                      "f00017",
                      "Les violences supposent un comportement actif : la simple abstention ne suffit pas ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_mineur_vulnerable_contenu_page.dart",
                      "f00018",
                      "(en cas d’omissions, d’autres qualifications peuvent être retenues : privation de soins, etc.).",
                    ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_mineur_vulnerable_contenu_page.dart",
                  "f00019",
                  "1) Un contact physique (direct ou indirect)",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_mineur_vulnerable_contenu_page.dart",
                      "f00020",
                      "Sont visés tous les comportements impliquant un contact physique : coups, gifles, morsures, etc. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_mineur_vulnerable_contenu_page.dart",
                      "f00021",
                      "Le contact peut être indirect : arme (par nature ou destination), objet, animal excité par l’auteur, etc.",
                    ),
              ),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_mineur_vulnerable_contenu_page.dart",
                  "f00022",
                  "2) Une atteinte psychique (violences psychologiques)",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_mineur_vulnerable_contenu_page.dart",
                        "f00023",
                        "Les violences volontaires peuvent être matérialisées par une agression psychique : ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_mineur_vulnerable_contenu_page.dart",
                        "f00024",
                        "tout acte de nature à impressionner vivement la victime et à lui causer un choc émotif, ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_mineur_vulnerable_contenu_page.dart",
                        "f00025",
                        "même sans atteinte physique.",
                      ),
                ),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_mineur_vulnerable_contenu_page.dart",
                      "f00026",
                      "« Le délit de violences est constitué… » — ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_mineur_vulnerable_contenu_page.dart",
                      "f00027",
                      "Cass. crim., 18 mars 2008, n°07-86.075",
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
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_mineur_vulnerable_contenu_page.dart",
                    "f00028",
                    "Article 222-14-3 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_mineur_vulnerable_contenu_page.dart",
                        "f00029",
                        " : codifie la jurisprudence en précisant que les violences sont constituées quelle que soit leur nature, ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_mineur_vulnerable_contenu_page.dart",
                        "f00030",
                        "y compris psychologiques.",
                      ),
                ),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                title: "Exemple",
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_mineur_vulnerable_contenu_page.dart",
                      "f00031",
                      "Individu descendant avec une barre de fer et frappant le véhicule de la victime — ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_mineur_vulnerable_contenu_page.dart",
                      "f00032",
                      "Cass. crim., 18 mars 2008",
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
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_mineur_vulnerable_contenu_page.dart",
                  "f00033",
                  "B) Des violences habituelles (répétition)",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_mineur_vulnerable_contenu_page.dart",
                      "f00034",
                      "L’habitude implique que les violences aient été commises à plusieurs reprises. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_mineur_vulnerable_contenu_page.dart",
                      "f00035",
                      "La répétition peut s’apprécier sur une durée relativement courte si les faits sont réitérés.",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: "Jurisprudences",
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_mineur_vulnerable_contenu_page.dart",
                      "f00036",
                      "Institution spécialisée : privations, enfermements, douches froides… assimilés à des traitements inhumains ou dégradants — ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_mineur_vulnerable_contenu_page.dart",
                      "f00037",
                      "Cass. crim., 2 décembre 1998",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: ". "),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_mineur_vulnerable_contenu_page.dart",
                      "f00038",
                      "Violences sur une période de deux mois : constitutives de violences habituelles — ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_mineur_vulnerable_contenu_page.dart",
                      "f00039",
                      "C.A. Grenoble, 5 novembre 1999",
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
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_mineur_vulnerable_contenu_page.dart",
                  "f00040",
                  "C) Une victime particulière",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_mineur_vulnerable_contenu_page.dart",
                  "f00041",
                  "La loi protège spécifiquement :",
                ),
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_mineur_vulnerable_contenu_page.dart",
                  "f00042",
                  "Un mineur de 15 ans.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_mineur_vulnerable_contenu_page.dart",
                  "f00043",
                  "Une personne dont la particulière vulnérabilité est apparente ou connue (âge, maladie, infirmité, déficience physique/psychique, grossesse).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_mineur_vulnerable_contenu_page.dart",
                  "f00044",
                  "Une personne en état de sujétion psychologique ou physique (pressions graves/réitérées ou techniques altérant le jugement, avec effets graves ou actes/abstentions gravement préjudiciables).",
                ),
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_mineur_vulnerable_contenu_page.dart",
                    "f00045",
                    "Sujétion au sens de ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_mineur_vulnerable_contenu_page.dart",
                    "f00046",
                    "l’article 223-15-3 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_mineur_vulnerable_contenu_page.dart",
                  "f00047",
                  "D) Un résultat dommageable",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_mineur_vulnerable_contenu_page.dart",
                      "f00048",
                      "Les violences supposent une atteinte à l’intégrité physique et/ou psychique. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_mineur_vulnerable_contenu_page.dart",
                      "f00049",
                      "La réalité de l’atteinte doit être établie (notamment par certificat médical).",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_mineur_vulnerable_contenu_page.dart",
                      "f00050",
                      "L’article 222-14 distingue quatre types de préjudices selon que les violences :\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_mineur_vulnerable_contenu_page.dart",
                      "f00051",
                      "• ont entraîné la mort ;\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_mineur_vulnerable_contenu_page.dart",
                      "f00052",
                      "• ont entraîné une mutilation ou une infirmité permanente ;\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_mineur_vulnerable_contenu_page.dart",
                      "f00053",
                      "• ont entraîné une I.T.T. > 8 jours ;\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_mineur_vulnerable_contenu_page.dart",
                      "f00054",
                      "• n’ont pas entraîné une I.T.T. > 8 jours.",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_mineur_vulnerable_contenu_page.dart",
                  "f00055",
                  "Jurisprudence",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_mineur_vulnerable_contenu_page.dart",
                      "f00056",
                      "Brimades ayant entraîné un état anxio-dépressif grave et une I.T.T. > 8 jours — ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_mineur_vulnerable_contenu_page.dart",
                      "f00057",
                      "Cass. crim., 4 mars 2003, n°2003-018405",
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
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_mineur_vulnerable_contenu_page.dart",
              "f00058",
              "III — Élément moral",
            ),
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_mineur_vulnerable_contenu_page.dart",
                      "f00059",
                      "Le délit est consommé lorsque les violences sont intentionnelles : ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_mineur_vulnerable_contenu_page.dart",
                      "f00060",
                      "l’auteur a conscience de commettre un acte affectant l’intégrité physique et/ou psychique d’autrui, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_mineur_vulnerable_contenu_page.dart",
                      "f00061",
                      "avec la connaissance qu’il en résultera un préjudice pour la victime.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Circonstances aggravantes
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_mineur_vulnerable_contenu_page.dart",
              "f00062",
              "IV — Circonstances aggravantes",
            ),
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_mineur_vulnerable_contenu_page.dart",
                  "f00063",
                  "Aucune (au titre de cette fiche).",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Répression + tentative/complicité
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_mineur_vulnerable_contenu_page.dart",
              "f00064",
              "V — Répression",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_mineur_vulnerable_contenu_page.dart",
                  "f00065",
                  "Peines encourues — personnes physiques",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_mineur_vulnerable_contenu_page.dart",
                    "f00066",
                    "I.T.T. 0 à 8 jours (délit) : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_mineur_vulnerable_contenu_page.dart",
                    "f00067",
                    "5 ans d’emprisonnement et 75 000 € d’amende. — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_mineur_vulnerable_contenu_page.dart",
                    "f00068",
                    "article 222-14 4° du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_mineur_vulnerable_contenu_page.dart",
                    "f00069",
                    "I.T.T. > 8 jours (délit) : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_mineur_vulnerable_contenu_page.dart",
                    "f00070",
                    "10 ans d’emprisonnement et 150 000 € d’amende. — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_mineur_vulnerable_contenu_page.dart",
                    "f00071",
                    "article 222-14 3° du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_mineur_vulnerable_contenu_page.dart",
                    "f00072",
                    "Mutilation / infirmité permanente (crime) : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_mineur_vulnerable_contenu_page.dart",
                    "f00073",
                    "20 ans de réclusion (période de sûreté). — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_mineur_vulnerable_contenu_page.dart",
                    "f00074",
                    "article 222-14 2° du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_mineur_vulnerable_contenu_page.dart",
                    "f00075",
                    "Mort sans intention de la donner (crime) : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_mineur_vulnerable_contenu_page.dart",
                    "f00076",
                    "30 ans de réclusion (période de sûreté). — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_mineur_vulnerable_contenu_page.dart",
                    "f00077",
                    "article 222-14 1° du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_mineur_vulnerable_contenu_page.dart",
                  "f00078",
                  "Personnes morales",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_mineur_vulnerable_contenu_page.dart",
                    "f00079",
                    "Responsabilité pénale prévue par ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_mineur_vulnerable_contenu_page.dart",
                    "f00080",
                    "l’article 222-16-1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_mineur_vulnerable_contenu_page.dart",
                    "f00081",
                    " (amende + peines complémentaires).",
                  ),
                ),
              ]),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_mineur_vulnerable_contenu_page.dart",
                  "f00082",
                  "Tentative & complicité",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_mineur_vulnerable_contenu_page.dart",
                  "f00083",
                  "Tentative : NON (non visée pour les violences délictuelles).",
                ),
              ),
              SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_mineur_vulnerable_contenu_page.dart",
                    "f00084",
                    "En matière criminelle, la tentative est théoriquement punissable, mais difficile à établir car l’infraction dépend en partie du résultat.",
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_mineur_vulnerable_contenu_page.dart",
                    "f00085",
                    "Complicité : OUI, conformément à ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_mineur_vulnerable_contenu_page.dart",
                    "f00086",
                    "l’article 121-6 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " et "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/violences_habituelles_mineur_vulnerable_contenu_page.dart",
                    "f00087",
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
