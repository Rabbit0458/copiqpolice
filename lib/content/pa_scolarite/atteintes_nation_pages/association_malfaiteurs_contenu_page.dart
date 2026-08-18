import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PaAssociationMalfaiteursPage extends StatelessWidget {
  const PaAssociationMalfaiteursPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/atteintes_nation_pages/association_malfaiteurs';

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
    final Color cardBonus = isDark
        ? const Color(0xFF1F1F1F)
        : const Color(0xFFF5F5FF);

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
    final Color accentIndigo = isDark
        ? const Color(0xFF9FA8DA)
        : const Color(0xFF303F9F);
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
            "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
            "f00002",
            "Crime & délit — Nation",
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
              "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
              "f00003",
              "La participation à une association de malfaiteurs",
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
              "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
              "f00004",
              "Définition",
            ),
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                      "f00005",
                      "Constitue une association de malfaiteurs tout groupement formé ou entente établie ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                      "f00006",
                      "en vue de la préparation, caractérisée par un ou plusieurs faits matériels, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                      "f00007",
                      "d’un ou plusieurs crimes ou d’un ou plusieurs délits punis d’au moins cinq ans d’emprisonnement.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
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
                    "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                    "f00009",
                    "Article 450-1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                        "f00010",
                        " : définit et réprime l’association de malfaiteurs. ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                        "f00011",
                        "C’est une infraction formelle, indépendante des crimes/délits préparés ou commis.",
                      ),
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                      "f00012",
                      "Elle est retenue au stade des actes préparatoires : la « préparation » suffit, dès lors ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                      "f00013",
                      "qu’elle est caractérisée par un ou plusieurs faits matériels.",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: "Important",
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                          "f00014",
                          "L’association de malfaiteurs est un délit autonome : elle se cumule avec l’infraction projetée/commise. ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                          "f00015",
                          "Cependant, les mêmes faits peuvent aussi caractériser une bande organisée. Dans ce cas, l’incrimination ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                          "f00016",
                          "d’association de malfaiteurs peut disparaître si la bande organisée est expressément prévue pour l’infraction poursuivie ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                          "f00017",
                          "(principe non bis in idem).",
                        ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              _SubTitle("Jurisprudences"),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                      "f00018",
                      "Cumul possible si faits distincts entre l’association de malfaiteurs et la bande organisée : ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                      "f00019",
                      "(Cass. crim., 19 janvier 2010)",
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
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                      "f00020",
                      "Association distincte de la bande organisée si elle visait d’autres infractions que celles finalement tentées/commises : ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                      "f00021",
                      "(Cass. crim., 9 mai 2019)",
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

          // Élément matériel
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
              "f00022",
              "II — Élément matériel",
            ),
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                  "f00023",
                  "A) Une résolution d’agir en commun",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                      "f00024",
                      "Le texte exige que les participants passent du stade purement intellectuel aux actes préparatoires : ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                      "f00025",
                      "il ne suffit pas d’un échange d’opinions. L’entente est souvent tacite et se déduit des faits.",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                      "f00026",
                      "Passage aux actes préparatoires exigé : ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                      "f00027",
                      "(Cass. crim., 29 janvier 1991)",
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
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                      "f00028",
                      "La jurisprudence retient l’entente au regard notamment :\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                      "f00029",
                      "• des prises de contact, réunions, habitudes\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                      "f00030",
                      "• de l’usage commun de véhicules\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                      "f00031",
                      "• de la persistance de rassemblements\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                      "f00032",
                      "• d’éléments issus de filatures ou d’écoutes\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                      "f00033",
                      "• et surtout des actes préparatoires réalisés.",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                      "f00034",
                      "Réunions et prises de contact : ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                      "f00035",
                      "(Cass. crim., 4 mars 1992)",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: ". "),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                      "f00036",
                      "Débits de boissons fréquentés : ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                      "f00037",
                      "(Cass. crim., 30 mai 1988)",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: ". "),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                      "f00038",
                      "Filatures : ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                      "f00039",
                      "(Cass. crim., 6 septembre 1990)",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: ". "),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                      "f00040",
                      "Écoutes téléphoniques : ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                      "f00041",
                      "(Cass. crim., 20 février 1990)",
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
                  "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                  "f00042",
                  "B) « Caractérisée par un ou plusieurs faits matériels »",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                      "f00043",
                      "Le législateur a voulu exclure le simple projet : sont visés les faits concrets ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                      "f00044",
                      "(réunions où des renseignements s’échangent, plans élaborés, moyens d’action rassemblés).",
                    ),
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                  "f00045",
                  "C) Nombre de participants",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                      "f00046",
                      "Peu importe le nombre : deux personnes suffisent. Peu importe aussi la durée de l’entente ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                      "f00047",
                      "et le fait que certains membres ne soient pas identifiés.",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                          "f00048",
                          "Deux personnes organisant de concert une livraison d’héroïne (contacts fournisseur, véhicules, somme importante) : ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                          "f00049",
                          "faits matériels caractérisant l’association de malfaiteurs ",
                        ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                      "f00050",
                      "(Cass. crim., 3 juin 2004)",
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
                  "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                  "f00051",
                  "D) La nécessité d’une organisation",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                      "f00052",
                      "La preuve d’une organisation (direction, hiérarchie, répartition des rôles) aide à établir ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                      "f00053",
                      "l’existence du groupement ou de l’entente.",
                    ),
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                  "f00054",
                  "E) Le but poursuivi",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                      "f00055",
                      "L’entente est punissable si elle vise la préparation :\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                      "f00056",
                      "• d’un ou plusieurs crimes, ou\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                      "f00057",
                      "• d’un ou plusieurs délits punis d’au moins 5 ans d’emprisonnement.\n\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                      "f00058",
                      "Les infractions projetées n’ont pas besoin d’être déjà déterminées avec précision.",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                      "f00059",
                      "Infractions pas nécessairement déterminées : ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                      "f00060",
                      "(Cass. crim., 15 décembre 1993)",
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
              "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
              "f00061",
              "III — Élément moral",
            ),
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                  "f00062",
                  "A) Intégration au groupement en connaissance de cause",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                      "f00063",
                      "Chaque participant doit s’être intégré à un groupement délictueux en connaissant ses buts ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                      "f00064",
                      "et son caractère répréhensible.",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                      "f00065",
                      "Connaissance des buts et du caractère répréhensible : ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                      "f00066",
                      "(Cass. crim., 28 février 2001)",
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
                  "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                  "f00067",
                  "B) Volonté d’apporter un concours au groupement",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                      "f00068",
                      "La responsabilité est retenue si la personne agit avec la volonté d’apporter un concours efficace ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                      "f00069",
                      "à la préparation du crime/délit projeté (ex. fournir des moyens matériels : armes, explosifs, etc.).",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                      "f00070",
                      "Concours matériel au groupement (armes/explosifs) : ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                      "f00071",
                      "(Cass. crim., 2 juillet 1991)",
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

          // Circonstances aggravantes
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
              "f00072",
              "IV — Circonstances aggravantes",
            ),
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                  "f00073",
                  "Aucune circonstance aggravante spécifique indiquée ici.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Répression
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
              "f00074",
              "V — Répression",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                  "f00075",
                  "Peines encourues — personnes physiques",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                    "f00076",
                    "Article 450-1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                    "f00077",
                    " : peines selon l’objet de l’entente.",
                  ),
                ),
              ]),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                  "f00078",
                  "1) Lorsque l’entente vise un ou plusieurs délits (≥ 5 ans)",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                  "f00079",
                  "5 ans d’emprisonnement.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                  "f00080",
                  "75 000 € d’amende.",
                ),
              ),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                    "f00081",
                    "Fondement : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                    "f00082",
                    "article 450-1 (alinéa relatif au délit) du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                  "f00083",
                  "2) Lorsque l’entente vise un ou plusieurs crimes",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                  "f00084",
                  "10 ans d’emprisonnement.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                  "f00085",
                  "150 000 € d’amende.",
                ),
              ),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                    "f00086",
                    "Fondement : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                    "f00087",
                    "article 450-1 (alinéa relatif au crime) du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                  "f00088",
                  "3) Hypothèse la plus grave (réclusion)",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                  "f00089",
                  "15 ans de réclusion.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                  "f00090",
                  "225 000 € d’amende.",
                ),
              ),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                    "f00091",
                    "Fondement : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                    "f00092",
                    "article 450-1 (alinéa réclusion) du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                  "f00093",
                  "Personnes morales",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                    "f00094",
                    "Article 450-4 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                    "f00095",
                    " : prévoit la responsabilité pénale des personnes morales.",
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                          "f00096",
                          "Les peines applicables aux personnes morales suivent les règles du Code pénal ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                          "f00097",
                          "(notamment amende et peines complémentaires selon les textes généraux).",
                        ),
                  ),
                ],
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                  "f00098",
                  "Tentative & complicité",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                  "f00099",
                  "Tentative : NON (la consommation intervient à un stade antérieur à la tentative ; aucun texte spécial ne la prévoit).",
                ),
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                    "f00100",
                    "Complicité : OUI, conformément à ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                    "f00101",
                    "l’article 121-7 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                  "f00102",
                  "Lecture pratique",
                ),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                          "f00103",
                          "Il faut distinguer :\n",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                          "f00104",
                          "• la complicité de l’association de malfaiteurs (aider le groupement à naître / s’étendre / maintenir des contacts),\n",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                          "f00105",
                          "• et la complicité des infractions ensuite commises/tentées (si l’aide a servi à réaliser l’infraction décidée).\n\n",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                          "f00106",
                          "Chaque cas se traite en évitant le cumul interdit par le principe non bis in idem.",
                        ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Exemption & réduction de peine
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
              "f00107",
              "VI — Exemption & réduction de peine",
            ),
            cardColor: cardBonus,
            accent: accentIndigo,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                    "f00108",
                    "Article 450-2 alinéa 1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                        "f00109",
                        " : exemption de peine si la personne révèle le groupement/entente avant toute poursuite ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                        "f00110",
                        "et permet l’identification des autres participants.",
                      ),
                ),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                          "f00111",
                          "Condition clé : agir avant toute poursuite. La dénonciation doit être faite aux autorités compétentes ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                          "f00112",
                          "(judiciaires ou administratives) et permettre l’identification des autres participants.",
                        ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                    "f00113",
                    "Article 450-2 alinéa 2 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                        "f00114",
                        " : réduction des deux tiers de la peine si, en avertissant l’autorité, la personne a permis ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart",
                        "f00115",
                        "de faire cesser l’infraction, d’éviter la commission d’une infraction préparée, ou d’identifier d’autres auteurs/complices.",
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
