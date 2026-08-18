import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PaAtteintesInviolabiliteDomicilePage extends StatelessWidget {
  const PaAtteintesInviolabiliteDomicilePage({super.key});

  static const String routeName =
      '/pa/dps_dpg/atteintes_nation_pages/abus_autorite_particuliers/atteintes_inviolabilite_domicile';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette (lisible + propre)
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
            "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
            "f00002",
            "Abus d’autorité",
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
              "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
              "f00003",
              "Les atteintes à l’inviolabilité du domicile",
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
              "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
              "f00004",
              "Définition",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
                      "f00005",
                      "Constitue une atteinte à l’inviolabilité du domicile le fait, par une personne dépositaire ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
                      "f00006",
                      "de l’autorité ou chargée d’une mission de service public, agissant dans l’exercice ou à ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
                      "f00007",
                      "l’occasion de l’exercice de ses fonctions ou de sa mission, de s’introduire ou de tenter ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
                      "f00008",
                      "de s’introduire dans le domicile d’autrui contre le gré de celui-ci, hors les cas prévus par la loi.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
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
                    "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
                    "f00010",
                    "Article 432-8 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
                    "f00011",
                    " : l’infraction est prévue et réprimée par ce texte.",
                  ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Élément matériel
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
              "f00012",
              "II — Élément matériel",
            ),
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
                  "f00013",
                  "A) Un auteur qualifié",
                ),
              ),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
                  "f00014",
                  "1) Une personne dépositaire de l’autorité publique",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
                      "f00015",
                      "Est dépositaire de l’autorité publique celui qui dispose d’un pouvoir de décision ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
                      "f00016",
                      "fondé sur une parcelle d’autorité publique que lui confèrent ses fonctions (fonctionnaire, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
                      "f00017",
                      "militaire, magistrat, officier public ou ministériel, etc.).",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
                      "f00018",
                      "Sont notamment concernés : policiers, gendarmes, douaniers, huissiers de justice, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
                      "f00019",
                      "commissaires-priseurs, fonctionnaires des eaux et forêts.",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
                      "f00020",
                      "Les responsables des exécutifs locaux (maires, présidents d’intercommunalités, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
                      "f00021",
                      "conseils départementaux et régionaux), ainsi que certains adjoints et conseillers municipaux ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
                      "f00022",
                      "délégués, peuvent aussi avoir cette qualité.",
                    ),
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
                  "f00023",
                  "2) Une personne chargée d’une mission de service public",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
                      "f00024",
                      "Est chargée d’une mission de service public la personne qui accomplit, à titre temporaire ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
                      "f00025",
                      "ou permanent, volontairement ou sur réquisition, un service public quelconque : elle ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
                      "f00026",
                      "participe à une mission d’intérêt général sans pouvoir de décision ou de commandement.",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
                      "f00027",
                      "Les élus locaux qui ne détiennent aucune prérogative de puissance publique par délégation, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
                      "f00028",
                      "ainsi que les parlementaires, peuvent relever de cette catégorie.",
                    ),
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
                  "f00029",
                  "B) Agissant dans l’exercice ou à l’occasion des fonctions / mission",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
                      "f00030",
                      "L’auteur doit avoir abusé de sa qualité pour pénétrer au domicile. Il doit agir dans le cadre ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
                      "f00031",
                      "de ses attributions : sont exclues les intrusions motivées par des raisons personnelles.",
                    ),
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
                  "f00032",
                  "C) Un domicile",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
                      "f00033",
                      "Le domicile est le lieu où une personne, qu’elle y habite ou non, a le droit de se dire chez elle, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
                      "f00034",
                      "quel que soit le titre juridique d’occupation et l’affectation des locaux. L’idée centrale : ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
                      "f00035",
                      "le lieu protège l’intimité.",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
                      "f00036",
                      "Cela vise : domicile légal, résidence, lieu de séjour occasionnel, occupation précaire. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
                      "f00037",
                      "La notion peut s’étendre à un logement inoccupé contenant des meubles, si ces éléments ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
                      "f00038",
                      "traduisent une occupation effective (ex. table, chaises, lit, canapé, électroménager). ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
                      "f00039",
                      "À l’inverse, une simple bicyclette ou un carton de livres ne suffit pas.",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
                          "f00040",
                          "Le domicile comprend aussi une habitation avec ses dépendances (caves, terrasses, etc.). ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
                          "f00041",
                          "Cours/jardins/parcs peuvent être assimilés au domicile s’ils sont clos et attenants. ",
                        ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
                      "f00042",
                      "(Cass. crim., 26 septembre 1990)",
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
                      "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
                      "f00043",
                      "La jurisprudence exige en pratique un lien étroit et immédiat : la dépendance doit être une annexe ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
                      "f00044",
                      "au domicile et se trouver à proximité de l’habitation.",
                    ),
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
                  "f00045",
                  "D) Une introduction (ou tentative) illicite",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
                      "f00046",
                      "L’acte incriminé est l’introduction ou la tentative d’introduction dans un domicile, quel que soit le moyen, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
                      "f00047",
                      "même sans violence ni artifice. Le maintien dans le domicile n’est pas visé par ce texte.",
                    ),
              ),
              SizedBox(height: 12),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
                          "f00048",
                          "Exemple : en enquête préliminaire, l’O.P.J. ayant obtenu une autorisation écrite de perquisition ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
                          "f00049",
                          "ne commet pas ce délit en refusant de quitter les lieux si la personne « retire » ensuite son autorisation ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
                          "f00050",
                          "(dans certaines hypothèses analysées).",
                        ),
                  ),
                ],
              ),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
                  "f00051",
                  "Jurisprudences (illustrations)",
                ),
              ),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
                          "f00052",
                          "Des policiers se rendent dans le hall d’un hôtel et demandent par téléphone à l’occupant d’une chambre ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
                          "f00053",
                          "de les rejoindre : pas de pénétration dans un domicile. ",
                        ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
                      "f00054",
                      "(Cass. crim., 06 avril 1993)",
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
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
                          "f00055",
                          "Des gendarmes se placent au seuil d’un garage ouvert par l’agent immobilier et photographient des véhicules ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
                          "f00056",
                          "sans pénétrer : pas d’introduction dans un domicile. ",
                        ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
                      "f00057",
                      "(Cass. crim., 29 mars 1994)",
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
                  "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
                  "f00058",
                  "E) Contre le gré de l’occupant",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
                      "f00059",
                      "L’infraction suppose une introduction contre le gré de l’occupant. Si l’agent pénètre avec le consentement, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
                      "f00060",
                      "l’infraction n’est pas constituée.",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
                          "f00061",
                          "Des agents entrent chez les parents d’un conducteur venant de causer un accident et présentant des signes d’ivresse, ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
                          "f00062",
                          "avec l’accord des parents : délit non constitué. ",
                        ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
                      "f00063",
                      "(Cass. crim., 28 juin 1990)",
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
                      "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
                      "f00064",
                      "Attention : le consentement ne doit pas être vicié par des manœuvres ou « stratagèmes policiers ». ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
                      "f00065",
                      "(Cass. crim., 27 février 1996)",
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
                  "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
                  "f00066",
                  "F) Hors les cas prévus par la loi",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
                        "f00067",
                        "Certains textes permettent de pénétrer dans le domicile au nom d’intérêts supérieurs : une introduction peut être régulière ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
                        "f00068",
                        "si elle respecte strictement les conditions légales. ",
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
                    "f00069",
                    "(Cass. crim., 12 mai 1992)",
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
                          "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
                          "f00070",
                          "Toute introduction en vue de constater une infraction peut constituer une visite domiciliaire irrégulière si opérée ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
                          "f00071",
                          "hors les heures légales. ",
                        ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
                      "f00072",
                      "(Cass. crim., 03 juin 1991)",
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
                      "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
                      "f00073",
                      "L’article 432-8 du Code pénal sanctionne le non-respect des conditions de fond des interventions, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
                      "f00074",
                      "et non les actes accessoires qui peuvent accompagner l’intervention.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Élément moral
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
              "f00075",
              "III — Élément moral",
            ),
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
                  "f00076",
                  "A) Conscience de pénétrer irrégulièrement",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
                      "f00077",
                      "L’auteur doit avoir conscience de l’irrégularité de ses agissements : il sait qu’il pénètre (ou tente de pénétrer) ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
                      "f00078",
                      "dans le domicile d’autrui en dehors des conditions légales.",
                    ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
                  "f00079",
                  "B) Volonté de passer outre le consentement",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
                  "f00080",
                  "Il doit exister la volonté de passer outre l’absence de consentement (ou l’opposition) de l’occupant.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Circonstances aggravantes
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
              "f00081",
              "IV — Circonstances aggravantes",
            ),
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
                  "f00082",
                  "Aucune circonstance aggravante n’est prévue pour cette infraction.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Répression + tentative/complicité
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
              "f00083",
              "V — Répression",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
                  "f00084",
                  "Peines encourues — personnes physiques",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
                    "f00085",
                    "Délit — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
                    "f00086",
                    "2 ans d’emprisonnement et 30 000 € d’amende — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
                    "f00087",
                    "article 432-8 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
                  "f00088",
                  "Personnes morales",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
                  "f00089",
                  "Les personnes morales peuvent être reconnues responsables pénalement (selon les règles générales de responsabilité).",
                ),
              ),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
                  "f00090",
                  "Tentative & complicité",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
                    "f00091",
                    "Tentative : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
                    "f00092",
                    "OUI. ",
                  ),
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
                    "f00093",
                    "L’article 432-8 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
                    "f00094",
                    " incrimine spécifiquement la tentative de violation de domicile par une personne dépositaire de l’autorité publique ou chargée d’une mission de service public.",
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
                    "f00095",
                    "Complicité : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
                    "f00096",
                    "OUI, ",
                  ),
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
                    "f00097",
                    "conformément aux ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
                    "f00098",
                    "articles 121-6",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " et "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
                    "f00099",
                    "121-7 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart",
                    "f00100",
                    " (aide/assistance, provocation, instructions…).",
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
