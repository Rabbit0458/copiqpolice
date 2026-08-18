import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PaEtatAlcooliquePage extends StatelessWidget {
  const PaEtatAlcooliquePage({super.key});

  static const String routeName =
      '/pa/dps_dpg/socle_initial/circulation/etat_alcoolique';

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
            "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
            "f00002",
            "Infraction circulation routière",
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
              "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
              "f00003",
              "La conduite sous l’empire d’un état alcoolique",
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
              "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
              "f00004",
              "Définition",
            ),
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                      "f00005",
                      "Constitue une infraction, même en l’absence de tout signe d’ivresse manifeste, le fait de conduire un véhicule ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                      "f00006",
                      "sous l’empire d’un état alcoolique caractérisé :\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                      "f00007",
                      "• par une concentration d’alcool dans le sang égale ou supérieure à 0,80 g/L ;\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                      "f00008",
                      "• ou par une concentration d’alcool dans l’air expiré égale ou supérieure à 0,40 mg/L.\n\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                      "f00009",
                      "Ces dispositions sont applicables à l’accompagnateur d’un élève conducteur.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
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
                    "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                    "f00011",
                    "Article L. 234-1 / I et V du Code de la route",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                        "f00012",
                        " : définit et réprime la conduite sous l’empire d’un état alcoolique par un conducteur ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                        "f00013",
                        "ou par l’accompagnateur d’un élève conducteur.",
                      ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Élément matériel
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
              "f00014",
              "II — Élément matériel",
            ),
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                  "f00015",
                  "A) Une personne visée",
                ),
              ),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                  "f00016",
                  "1) Un conducteur de véhicule",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                      "f00017",
                      "Sont visés les conducteurs de véhicules à moteur (voitures particulières, poids lourds, véhicules de transport en commun, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                      "f00018",
                      "motocyclettes, cyclomoteurs, matériels agricoles et forestiers, engins de travaux publics, engins spéciaux, trolleybus), ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                      "f00019",
                      "mais aussi les conducteurs des autres véhicules en circulation (cycles, véhicules à traction animale).",
                    ),
              ),
              const SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                  "f00020",
                  "2) Un accompagnateur d’élève conducteur",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                      "f00021",
                      "Sont également concernés les accompagnateurs des élèves conducteurs, qu’ils interviennent dans le cadre ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                      "f00022",
                      "de l’enseignement de la conduite à titre gracieux, de la conduite accompagnée, ou en qualité de moniteur.",
                    ),
              ),

              const SizedBox(height: 12),

              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                  "f00023",
                  "Jurisprudence",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                      "f00024",
                      "Les seuls faits d’avoir pris le volant, mis le contact et enclenché une vitesse suffisent pour caractériser la conduite d’un véhicule ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                      "f00025",
                      "(Cass. crim., 23 mars 1994)",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                  "f00026",
                  "Jurisprudence",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                      "f00027",
                      "L’infraction peut être relevée même si le prévenu vient de quitter son véhicule, dès lors qu’il peut être prouvé qu’il l’a conduit sous l’emprise de l’alcool ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                      "f00028",
                      "(Cass. crim., 7 mars 1989)",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),

              const SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                  "f00029",
                  "B) Les cas de contrôle de l’alcoolémie",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                    "f00030",
                    "La recherche de l’état alcoolique doit être systématique dans les cas visés par ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                    "f00031",
                    "l’article L. 234-3 alinéa 1 du Code de la route",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " :"),
              ]),
              const SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                  "f00032",
                  "Auteur présumé d’une infraction (délit ou contravention) au code de la route punie de la peine complémentaire de suspension du permis de conduire.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                  "f00033",
                  "Conducteur ou accompagnateur d’élève conducteur impliqué dans un accident corporel de la circulation.",
                ),
              ),

              const SizedBox(height: 12),

              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                    "f00034",
                    "La recherche peut aussi être effectuée dans les cas visés par ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                    "f00035",
                    "l’article L. 234-3 alinéa 2 du Code de la route",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " :"),
              ]),
              const SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                  "f00036",
                  "Conducteur ou accompagnateur d’élève conducteur impliqué dans un accident quelconque de la circulation.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                  "f00037",
                  "Auteur présumé d’une infraction aux prescriptions du code de la route (autre que celles mentionnées au 1er alinéa).",
                ),
              ),

              const SizedBox(height: 12),

              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                    "f00038",
                    "Même sans infraction préalable ni accident, la recherche peut être effectuée dans le cadre de ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                    "f00039",
                    "l’article L. 234-9 du Code de la route",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " :"),
              ]),
              const SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                  "f00040",
                  "Par OPJ/APJ : sur instruction du procureur de la République ou à leur initiative.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                  "f00041",
                  "Par APJA : sur ordre et sous responsabilité des OPJ.",
                ),
              ),

              const SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                  "f00042",
                  "C) Les moyens de recherche de l’alcoolémie",
                ),
              ),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                  "f00043",
                  "1) Le dépistage",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                      "f00044",
                      "Le dépistage de l’imprégnation alcoolique par l’air expiré s’effectue à l’aide :\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                      "f00045",
                      "• d’un éthylotest de type A (alcootest) ;\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                      "f00046",
                      "• ou d’un éthylotest de type B (appareil portatif à affichage électronique).",
                    ),
              ),
              const SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                      "f00047",
                      "Les opérations de dépistage doivent être effectuées préalablement à toute vérification notamment :\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                      "f00048",
                      "• lorsque la recherche est effectuée par un APJA (sur ordre et sous responsabilité d’un OPJ) ;\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                      "f00049",
                      "• dans le cadre des recherches préventives, si OPJ/APJ ne disposent pas du matériel permettant la vérification immédiate sur place.",
                    ),
              ),

              const SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                  "f00050",
                  "2) La preuve : les vérifications",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                      "f00051",
                      "Lorsque le dépistage permet de présumer l’existence d’un état alcoolique, ou en cas de refus de se soumettre au dépistage, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                      "f00052",
                      "ou en cas d’impossibilité (incapacité physique attestée par médecin requis), OPJ/APJ font procéder aux vérifications destinées à établir la preuve.",
                    ),
              ),
              const SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                      "f00053",
                      "Les vérifications sont faites :\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                      "f00054",
                      "• soit au moyen d’analyses ou examens médicaux, cliniques ou biologiques ;\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                      "f00055",
                      "• soit au moyen d’un éthylomètre homologué (analyse de l’air expiré).",
                    ),
              ),

              const SizedBox(height: 10),

              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                    "f00056",
                    "Pour une prise de sang, l’OPJ/APJ peut requérir (notamment) un médecin ou un infirmier conformément à ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                    "f00057",
                    "l’article L. 234-4 du Code de la route",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " et "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                    "f00058",
                    "l’article R. 3354-5 du Code de la santé publique",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),

              const SizedBox(height: 12),

              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                    "f00059",
                    "En cas d’éthylomètre, un second contrôle peut être immédiatement effectué ; il est de droit si demandé par l’intéressé (",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                    "f00060",
                    "article L. 234-5 du Code de la route",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: ")."),
              ]),

              const SizedBox(height: 12),

              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                  "f00061",
                  "Règle pratique",
                ),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                          "f00062",
                          "L’indication du taux affichée par l’éthylomètre constitue à elle seule la base légale de toute procédure et sa valeur juridique ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                          "f00063",
                          "est équivalente à celle de l’analyse de sang. Le choix du mode de vérification appartient à l’enquêteur : la demande de prélèvement sanguin ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                          "f00064",
                          "à la place de l’éthylomètre ne peut pas être imposée par l’intéressé.",
                        ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                    "f00065",
                    "Si la personne persiste à refuser les vérifications, le délit de refus est retenu (",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                    "f00066",
                    "article L. 234-8 du Code de la route",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: ")."),
              ]),

              const SizedBox(height: 12),

              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                  "f00067",
                  "Jurisprudence",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                      "f00068",
                      "L’interprétation des mesures de concentration d’alcool dans l’air expiré effectuées au moyen d’un éthylomètre est une obligation pour le juge ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                      "f00069",
                      "(Cass. crim., 26 mars 2019)",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),

              const SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                  "f00070",
                  "D) Seuils : délit / contravention",
                ),
              ),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                  "f00071",
                  "1) Le taux délictuel",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                      "f00072",
                      "Même sans signe d’ivresse manifeste, le délit est constitué lorsque la concentration d’alcool est :\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                      "f00073",
                      "• égale ou supérieure à 0,80 g/L de sang ;\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                      "f00074",
                      "• ou égale ou supérieure à 0,40 mg/L d’air expiré.",
                    ),
              ),
              const SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                  "f00075",
                  "2) Le taux contraventionnel",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                    "f00076",
                    "Même sans signe d’ivresse manifeste, l’infraction est contraventionnelle dans les cas prévus par ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                    "f00077",
                    "l’article R. 234-1 du Code de la route",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " :"),
              ]),
              const SizedBox(height: 8),
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                  "f00078",
                  "Cas particuliers (seuil 0,20 g/L)",
                ),
                cardColor: isDark
                    ? const Color(0xFF263238)
                    : const Color(0xFFEFF7FF),
                accent: accentBlue,
                titleColor: textMain,
                children: [
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                      "f00079",
                      "Conducteur de transport en commun (véhicule > 9 places assises, conducteur compris).",
                    ),
                  ),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                      "f00080",
                      "Conducteur dont le droit de conduire est limité aux véhicules équipés d’un EAD (anti-démarrage).",
                    ),
                  ),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                      "f00081",
                      "Conducteur en apprentissage ou titulaire d’un permis probatoire.",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                  "f00082",
                  "Pour ces conducteurs : contravention si alcoolémie ≥ 0,20 g/L de sang (≥ 0,10 mg/L d’air expiré) sans atteindre 0,80 g/L (0,40 mg/L).",
                ),
              ),
              const SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                  "f00083",
                  "Pour les autres conducteurs : contravention si alcoolémie ≥ 0,50 g/L de sang (≥ 0,25 mg/L d’air expiré) sans atteindre 0,80 g/L (0,40 mg/L).",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Élément moral
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
              "f00084",
              "III — Élément moral",
            ),
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                  "f00085",
                  "Volonté de conduire après avoir consommé de l’alcool",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                    "f00086",
                    "La conduite sous l’empire d’un état alcoolique procède d’un comportement volontaire : c’est une infraction intentionnelle au regard de ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                    "f00087",
                    "l’article 121-3 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " ("),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                    "f00088",
                    "Cass. crim., 19 décembre 1994",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " et "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                    "f00089",
                    "18 octobre 1995",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: ")."),
              ]),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                    "f00090",
                    "L’élément moral peut résulter du simple fait de consommer de l’alcool alors que le conducteur sait qu’il va prendre le volant ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                    "f00091",
                    "(Cass. crim., 19 décembre 1994)",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                title: "Contraventions",
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                      "f00092",
                      "Pour les infractions contraventionnelles, l’élément moral n’est pas exigé.",
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Circonstances aggravantes
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
              "f00093",
              "IV — Circonstances aggravantes",
            ),
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                  "f00094",
                  "Aucune circonstance aggravante spécifique n’est prévue pour cette infraction.",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                  "f00095",
                  "Attention",
                ),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                          "f00096",
                          "La conduite sous l’empire d’un état alcoolique peut aggraver les peines en cas d’homicide involontaire ou d’atteintes involontaires : ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                          "f00097",
                          "le délit peut constituer une circonstance aggravante (",
                        ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                      "f00098",
                      "articles 221-6-1, 222-19-1 et 222-20-1 du Code pénal",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: ")."),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Répression
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
              "f00099",
              "V — Répression",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                  "f00100",
                  "Peines encourues",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                    "f00101",
                    "Contravention : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                    "f00102",
                    "750 € d’amende (amende forfaitaire). — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                    "f00103",
                    "article R. 234-1 (I 1° et V) du Code de la route",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                    "f00104",
                    "Contravention (autres conducteurs) : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                    "f00105",
                    "750 € d’amende (amende forfaitaire). — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                    "f00106",
                    "article R. 234-1 (I 2° et V) du Code de la route",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                    "f00107",
                    "Délit : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                    "f00108",
                    "2 ans d’emprisonnement et 4 500 € d’amende. — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                    "f00109",
                    "article L. 234-1 (I et V) du Code de la route",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                  "f00110",
                  "Tentative & complicité",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                  "f00111",
                  "Tentative : NON.",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                    "f00112",
                    "Complicité : OUI, conformément à ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                    "f00113",
                    "l’article 121-6 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " et "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                    "f00114",
                    "l’article 121-7 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                  "f00115",
                  "Immunité",
                ),
              ),
              _SubTitle("Diplomates"),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                    "f00116",
                    "La convention de Vienne (",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                    "f00117",
                    "article 27, décret n°71-284 du 29/03/1971",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                        "f00118",
                        ") prévoit que les diplomates ne peuvent être soumis à aucune forme d’arrestation. ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                        "f00119",
                        "Ne pas faire subir de dépistage ou de vérification de l’alcoolémie.",
                      ),
                ),
              ]),

              SizedBox(height: 12),

              _SubTitle("Parlementaires"),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                    "f00120",
                    "La Constitution de 1958 (",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                    "f00121",
                    "article 26",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                        "f00122",
                        ") consacre l’inviolabilité des parlementaires. Concernant les épreuves de dépistage obligatoires à la suite d’un flagrant délit ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart",
                        "f00123",
                        "(accident mortel ou corporel grave, etc.), le dépistage peut être effectué, mais si possible, le procureur doit être préalablement informé.",
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
