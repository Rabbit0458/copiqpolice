import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class TraficInfluencePage extends StatelessWidget {
  const TraficInfluencePage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/crime_delit_nation_pages/probite/trafic_influence';

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
            "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/trafic_influence_contenu_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/trafic_influence_contenu_page.dart",
            "f00002",
            "Probité",
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
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/trafic_influence_contenu_page.dart",
              "f00003",
              "Le trafic d’influence",
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
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/trafic_influence_contenu_page.dart",
              "f00004",
              "Définition",
            ),
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/trafic_influence_contenu_page.dart",
                      "f00005",
                      "Le trafic d’influence consiste, pour une personne dépositaire de l’autorité publique, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/trafic_influence_contenu_page.dart",
                      "f00006",
                      "chargée d’une mission de service public, ou investie d’un mandat électif public, à solliciter ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/trafic_influence_contenu_page.dart",
                      "f00007",
                      "ou agréer, sans droit, à tout moment, directement ou indirectement, des offres, promesses, dons, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/trafic_influence_contenu_page.dart",
                      "f00008",
                      "présents ou avantages, pour elle-même ou pour autrui, afin d’abuser (ou d’avoir abusé) de son ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/trafic_influence_contenu_page.dart",
                      "f00009",
                      "influence réelle ou supposée en vue de faire obtenir d’une autorité ou d’une administration publique ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/trafic_influence_contenu_page.dart",
                      "f00010",
                      "des distinctions, des emplois, des marchés ou toute autre décision favorable.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/trafic_influence_contenu_page.dart",
              "f00011",
              "I — Élément légal",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/trafic_influence_contenu_page.dart",
                    "f00012",
                    "Article 432-11 alinéas 1 et 3 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/trafic_influence_contenu_page.dart",
                    "f00013",
                    " : définit et réprime le trafic d’influence.",
                  ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Élément matériel
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/trafic_influence_contenu_page.dart",
              "f00014",
              "II — Élément matériel",
            ),
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/trafic_influence_contenu_page.dart",
                  "f00015",
                  "A) Un auteur particulier",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/trafic_influence_contenu_page.dart",
                  "f00016",
                  "L’infraction suppose un auteur appartenant à l’une des catégories suivantes.",
                ),
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/trafic_influence_contenu_page.dart",
                  "f00017",
                  "Personne dépositaire de l’autorité publique : détient un pouvoir de décision lié à une parcelle d’autorité publique (ex. policiers, gendarmes, douaniers, magistrats, militaires, officiers publics, etc.).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/trafic_influence_contenu_page.dart",
                  "f00018",
                  "Personne investie d’un mandat électif public : élus nationaux, régionaux, départementaux, communaux, et certains élus d’établissements publics administratifs (chambres consulaires, etc.).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/trafic_influence_contenu_page.dart",
                  "f00019",
                  "Personne chargée d’une mission de service public : accomplit ou participe à une mission d’intérêt général, temporaire ou permanente, sans nécessaire pouvoir de décision/commandement.",
                ),
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/trafic_influence_contenu_page.dart",
                  "f00020",
                  "B) Un acte : sollicitation ou agrément",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/trafic_influence_contenu_page.dart",
                  "f00021",
                  "Le trafic d’influence repose sur l’un des deux comportements suivants :",
                ),
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/trafic_influence_contenu_page.dart",
                  "f00022",
                  "La sollicitation : démarche/initiative de l’auteur (directe ou détournée) laissant entendre qu’il faut « payer » pour obtenir la décision recherchée.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/trafic_influence_contenu_page.dart",
                  "f00023",
                  "L’agrément : accord donné par l’auteur à la proposition (accord de volontés entre celui qui propose et celui qui accepte).",
                ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/trafic_influence_contenu_page.dart",
                  "f00024",
                  "La sollicitation ou l’agrément peut être direct(e) ou indirect(e) (par personne interposée).",
                ),
              ),
              SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/trafic_influence_contenu_page.dart",
                  "f00025",
                  "Le texte vise des faits possibles « à tout moment » : il inclut aussi les avantages demandés/acceptés en remerciement d’actes accomplis antérieurement.",
                ),
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/trafic_influence_contenu_page.dart",
                  "f00026",
                  "C) Un bénéfice attendu",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/trafic_influence_contenu_page.dart",
                      "f00027",
                      "L’avantage peut prendre des formes très variées : somme d’argent, cadeau, service, voyage, droits, etc. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/trafic_influence_contenu_page.dart",
                      "f00028",
                      "Les termes « offres, promesses, dons, présents ou avantages quelconques » sont entendus largement.",
                    ),
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/trafic_influence_contenu_page.dart",
                  "f00029",
                  "D) Un acte d’influence (réelle ou supposée)",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/trafic_influence_contenu_page.dart",
                  "f00030",
                  "L’auteur doit abuser (ou accepter d’abuser) de son influence réelle ou supposée auprès d’une autorité ou d’une administration publique.",
                ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/trafic_influence_contenu_page.dart",
                  "f00031",
                  "L’influence doit être directe : c’est l’auteur qui est censé intervenir lui-même auprès du service ou de la personne disposant d’un pouvoir de décision.",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/trafic_influence_contenu_page.dart",
                      "f00032",
                      "Jurisprudence : sollicitation d’une somme pour « intervenir » afin que des PV n’aient aucune suite pénale, alors même que l’auteur n’avait pas le pouvoir de classer ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/trafic_influence_contenu_page.dart",
                      "f00033",
                      "(Cass. crim., 06 juin 1989)",
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
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/trafic_influence_contenu_page.dart",
                  "f00034",
                  "Peu importe que la personne sollicitée obtienne concrètement l’avantage recherché : l’infraction peut être caractérisée même si l’influence se révèle vaine.",
                ),
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/trafic_influence_contenu_page.dart",
                  "f00035",
                  "E) Finalité : obtenir une décision favorable",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/trafic_influence_contenu_page.dart",
                  "f00036",
                  "L’influence doit tendre à faire obtenir d’une autorité ou d’une administration publique :",
                ),
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/trafic_influence_contenu_page.dart",
                  "f00037",
                  "Des distinctions (décorations, médailles, récompenses, etc.).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/trafic_influence_contenu_page.dart",
                  "f00038",
                  "Des emplois (tout poste, quel que soit le niveau, nommé/investi par l’autorité).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/trafic_influence_contenu_page.dart",
                  "f00039",
                  "Des marchés (même privés, dès lors qu’ils nécessitent l’agrément de l’autorité publique).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/trafic_influence_contenu_page.dart",
                  "f00040",
                  "Toute autre décision favorable (même régulière en elle-même : ce sont les moyens d’influence irréguliers qui constituent l’infraction).",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/trafic_influence_contenu_page.dart",
                      "f00041",
                      "Jurisprudence : acceptation de sommes pour tenter d’obtenir la délivrance d’un titre de séjour et intervention auprès d’un assistant parlementaire ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/trafic_influence_contenu_page.dart",
                      "f00042",
                      "(C.A. Toulouse, 31 janvier 2002)",
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
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/trafic_influence_contenu_page.dart",
                      "f00043",
                      "Jurisprudence : marché privé nécessitant l’agrément de l’autorité publique ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/trafic_influence_contenu_page.dart",
                      "f00044",
                      "(Cass. crim., 15 mars 2000)",
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
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/trafic_influence_contenu_page.dart",
              "f00045",
              "III — Élément moral",
            ),
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/trafic_influence_contenu_page.dart",
                  "f00046",
                  "Intention frauduleuse",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/trafic_influence_contenu_page.dart",
                      "f00047",
                      "L’auteur doit avoir conscience d’agir en violation de son devoir de probité et vouloir obtenir un avantage ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/trafic_influence_contenu_page.dart",
                      "f00048",
                      "en contrepartie de l’influence exercée (ou promise).",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/trafic_influence_contenu_page.dart",
                  "f00049",
                  "Peu importe que l’influence ne soit finalement pas exercée ou qu’elle soit inefficace. Le mobile est indifférent.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Circonstances aggravantes
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/trafic_influence_contenu_page.dart",
              "f00050",
              "IV — Circonstances aggravantes",
            ),
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/trafic_influence_contenu_page.dart",
                    "f00051",
                    "Article 432-11 alinéa 4 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/trafic_influence_contenu_page.dart",
                    "f00052",
                    " : aggravation lorsque l’infraction est commise en bande organisée.",
                  ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Répression + tentative/complicité + réduction
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/trafic_influence_contenu_page.dart",
              "f00053",
              "V — Répression",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/trafic_influence_contenu_page.dart",
                  "f00054",
                  "Peines encourues — personnes physiques",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/trafic_influence_contenu_page.dart",
                    "f00055",
                    "Qualification simple : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/trafic_influence_contenu_page.dart",
                    "f00056",
                    "10 ans d’emprisonnement et 1 000 000 € d’amende ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/trafic_influence_contenu_page.dart",
                    "f00057",
                    "(montant pouvant être porté au double du produit tiré de l’infraction). — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/trafic_influence_contenu_page.dart",
                    "f00058",
                    "article 432-11 alinéa 3 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/trafic_influence_contenu_page.dart",
                    "f00059",
                    "Aggravée (bande organisée) : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/trafic_influence_contenu_page.dart",
                    "f00060",
                    "10 ans d’emprisonnement et 2 000 000 € d’amende ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/trafic_influence_contenu_page.dart",
                    "f00061",
                    "(montant pouvant être porté au double du produit tiré de l’infraction). — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/trafic_influence_contenu_page.dart",
                    "f00062",
                    "article 432-11 alinéa 4 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/trafic_influence_contenu_page.dart",
                  "f00063",
                  "Personnes morales",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/trafic_influence_contenu_page.dart",
                  "f00064",
                  "Les personnes morales peuvent être reconnues responsables.",
                ),
              ),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/trafic_influence_contenu_page.dart",
                  "f00065",
                  "Tentative & complicité",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/trafic_influence_contenu_page.dart",
                  "f00066",
                  "Tentative : NON (non punissable).",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/trafic_influence_contenu_page.dart",
                    "f00067",
                    "Complicité : OUI, conformément à ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/trafic_influence_contenu_page.dart",
                    "f00068",
                    "l’article 121-6 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " et "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/trafic_influence_contenu_page.dart",
                    "f00069",
                    "l’article 121-7 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/trafic_influence_contenu_page.dart",
                    "f00070",
                    " (aide/assistance, provocation, instructions données).",
                  ),
                ),
              ]),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/trafic_influence_contenu_page.dart",
                  "f00071",
                  "Réduction ou exemption de peine",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/trafic_influence_contenu_page.dart",
                    "f00072",
                    "Article 432-11-1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/trafic_influence_contenu_page.dart",
                        "f00073",
                        " : l’auteur ou le complice de trafic d’influence qui permet soit de faire cesser l’infraction, ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/trafic_influence_contenu_page.dart",
                        "f00074",
                        "soit d’identifier les autres auteurs/complices, voit sa peine privative de liberté réduite de moitié.",
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
