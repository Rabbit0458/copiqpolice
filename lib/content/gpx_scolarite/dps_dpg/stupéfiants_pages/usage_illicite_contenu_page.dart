import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class StupefiantsUsageIllicitePage extends StatelessWidget {
  const StupefiantsUsageIllicitePage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/stupéfiants_pages/usage_illicite';

  static const Color _lawRed = Color(0xFFE53935);

  TextSpan _law(String text) {
    return TextSpan(
      text: text,
      style: const TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
    );
  }

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
        ? const Color(0xFF20242A)
        : const Color(0xFFF3F6FA);

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
            "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/usage_illicite_contenu_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/usage_illicite_contenu_page.dart",
            "f00002",
            "Stupéfiants",
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
              "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/usage_illicite_contenu_page.dart",
              "f00003",
              "L’usage illicite de stupéfiants",
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
              "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/usage_illicite_contenu_page.dart",
              "f00004",
              "Définition",
            ),
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/usage_illicite_contenu_page.dart",
                  "f00005",
                  "L’usage illicite de l’une des substances ou plantes classées comme stupéfiants constitue une infraction.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/usage_illicite_contenu_page.dart",
              "f00006",
              "I — Élément légal",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                _law(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/usage_illicite_contenu_page.dart",
                    "f00007",
                    "Article L. 3421-1 alinéa 1 du Code de la santé publique",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/usage_illicite_contenu_page.dart",
                    "f00008",
                    " : définit et réprime l’usage illicite de stupéfiants.",
                  ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Élément matériel
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/usage_illicite_contenu_page.dart",
              "f00009",
              "II — Élément matériel",
            ),
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/usage_illicite_contenu_page.dart",
                  "f00010",
                  "A) Un usage illicite",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/usage_illicite_contenu_page.dart",
                      "f00011",
                      "L’usage s’entend comme une consommation ou une absorption : ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/usage_illicite_contenu_page.dart",
                      "f00012",
                      "individuelle ou collective, occasionnelle ou répétée, publique ou privée. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/usage_illicite_contenu_page.dart",
                      "f00013",
                      "Le mode d’administration importe peu.",
                    ),
              ),
              const SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/usage_illicite_contenu_page.dart",
                      "f00014",
                      "C’est la classification du produit consommé comme stupéfiant qui matérialise ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/usage_illicite_contenu_page.dart",
                      "f00015",
                      "le caractère illicite de l’usage.",
                    ),
              ),
              const SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/usage_illicite_contenu_page.dart",
                  "f00016",
                  "B) Assimilés à l’usage (quand c’est pour soi)",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/usage_illicite_contenu_page.dart",
                      "f00017",
                      "Sont également considérés comme usage : l’acquisition, la détention ou le transport ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/usage_illicite_contenu_page.dart",
                      "f00018",
                      "lorsqu’il est établi que les substances sont destinées à l’usage exclusif de la personne concernée. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/usage_illicite_contenu_page.dart",
                      "f00019",
                      "La qualification d’usage sera privilégiée selon la nature et la quantité de stupéfiants, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/usage_illicite_contenu_page.dart",
                      "f00020",
                      "ou le degré d’intoxication. Ces critères s’apprécient au cas par cas.",
                    ),
              ),
              const SizedBox(height: 12),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/usage_illicite_contenu_page.dart",
                  "f00021",
                  "Jurisprudence",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/usage_illicite_contenu_page.dart",
                      "f00022",
                      "Interpellation en possession de 20 g d’herbe de cannabis après avoir fumé un joint dans un train — ",
                    ),
                  ),
                  _law(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/usage_illicite_contenu_page.dart",
                      "f00023",
                      "C.A. Paris, 25 juin 2001",
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/usage_illicite_contenu_page.dart",
                  "f00024",
                  "Jurisprudence",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/usage_illicite_contenu_page.dart",
                      "f00025",
                      "Personne contrôlée se confectionnant un joint — ",
                    ),
                  ),
                  _law(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/usage_illicite_contenu_page.dart",
                      "f00026",
                      "C.A. Paris, 6 septembre 2005",
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/usage_illicite_contenu_page.dart",
                  "f00027",
                  "Jurisprudence",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/usage_illicite_contenu_page.dart",
                      "f00028",
                      "Culture de plants de cannabis en vue de la consommation personnelle — ",
                    ),
                  ),
                  _law(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/usage_illicite_contenu_page.dart",
                      "f00029",
                      "C.A. Pau, 4 novembre 2004",
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),

              const SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/usage_illicite_contenu_page.dart",
                  "f00030",
                  "C) Une substance/plante classée comme stupéfiant",
                ),
              ),
              _Paragraph.rich([
                _law(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/usage_illicite_contenu_page.dart",
                    "f00031",
                    "Article L. 5132-7 du Code de la santé publique",
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/usage_illicite_contenu_page.dart",
                        "f00032",
                        " : une substance est classée comme stupéfiant par décision du directeur général de l’Agence ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/usage_illicite_contenu_page.dart",
                        "f00033",
                        "nationale de sécurité du médicament et des produits de santé.",
                      ),
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/usage_illicite_contenu_page.dart",
                      "f00034",
                      "Ainsi, seules les substances figurant sur les listes arrêtées par voie réglementaire ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/usage_illicite_contenu_page.dart",
                      "f00035",
                      "doivent être retenues au sens de la définition légale.",
                    ),
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/usage_illicite_contenu_page.dart",
                    "f00036",
                    "La liste exhaustive et évolutive figure en annexes de ",
                  ),
                ),
                _law(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/usage_illicite_contenu_page.dart",
                    "f00037",
                    "l’arrêté du 22 février 1990",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/usage_illicite_contenu_page.dart",
                    "f00038",
                    " : l’infraction ne peut viser qu’une substance figurant sur cette liste, désignée avec suffisamment de précision.",
                  ),
                ),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/usage_illicite_contenu_page.dart",
                  "f00039",
                  "Jurisprudence",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/usage_illicite_contenu_page.dart",
                      "f00040",
                      "Un juge ne peut se contenter de viser « des substances stupéfiantes » sans préciser lesquelles — ",
                    ),
                  ),
                  _law(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/usage_illicite_contenu_page.dart",
                      "f00041",
                      "Cass. crim., 16 septembre 1985",
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),
              const SizedBox(height: 12),
              _NotaBox(
                title: "Constitution",
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/usage_illicite_contenu_page.dart",
                          "f00042",
                          "La définition légale des stupéfiants a été déclarée conforme à la Constitution : ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/usage_illicite_contenu_page.dart",
                          "f00043",
                          "la notion vise des substances psychotropes présentant un risque de dépendance et des effets nocifs pour la santé ; ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/usage_illicite_contenu_page.dart",
                          "f00044",
                          "le classement relève de l’autorité administrative, sous contrôle du juge, selon l’évolution des connaissances.",
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
              "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/usage_illicite_contenu_page.dart",
              "f00045",
              "III — Élément moral",
            ),
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/usage_illicite_contenu_page.dart",
                  "f00046",
                  "Usage intentionnel",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/usage_illicite_contenu_page.dart",
                      "f00047",
                      "L’auteur agit volontairement et en connaissance de cause : ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/usage_illicite_contenu_page.dart",
                      "f00048",
                      "il a pleinement conscience d’user de produits classés stupéfiants.",
                    ),
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/usage_illicite_contenu_page.dart",
                  "f00049",
                  "L’absorption ne serait pas punissable si la personne consomme à son insu.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/usage_illicite_contenu_page.dart",
                  "f00050",
                  "L’usage peut aussi être exclu lorsqu’il s’inscrit dans un traitement médical prescrit.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Circonstances aggravantes
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/usage_illicite_contenu_page.dart",
              "f00051",
              "IV — Circonstances aggravantes",
            ),
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                _law(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/usage_illicite_contenu_page.dart",
                    "f00052",
                    "Article L. 3421-1 alinéa 2 du Code de la santé publique",
                  ),
                ),
                const TextSpan(text: " :"),
              ]),
              const SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/usage_illicite_contenu_page.dart",
                      "f00053",
                      "Si l’infraction est commise dans l’exercice ou à l’occasion de l’exercice des fonctions :\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/usage_illicite_contenu_page.dart",
                      "f00054",
                      "• d’une personne dépositaire de l’autorité publique ou chargée d’une mission de service public ;\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/usage_illicite_contenu_page.dart",
                      "f00055",
                      "• ou par le personnel d’une entreprise de transport (routier, ferroviaire, maritime ou aérien) exerçant ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/usage_illicite_contenu_page.dart",
                      "f00056",
                      "des fonctions mettant en cause la sécurité du transport (liste fixée par décret en Conseil d’État),\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/usage_illicite_contenu_page.dart",
                      "f00057",
                      "les peines sont portées à 5 ans d’emprisonnement et 75 000 € d’amende.\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/usage_illicite_contenu_page.dart",
                      "f00058",
                      "Sont assimilés au personnel de transport les travailleurs mis à disposition par une entreprise extérieure.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Répression + thérapeutique + AFD + tentative/complicité
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/usage_illicite_contenu_page.dart",
              "f00059",
              "V — Répression",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/usage_illicite_contenu_page.dart",
                  "f00060",
                  "Peines encourues — personnes physiques",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/usage_illicite_contenu_page.dart",
                    "f00061",
                    "Simple (délit) : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/usage_illicite_contenu_page.dart",
                    "f00062",
                    "1 an d’emprisonnement et 3 750 € d’amende. — ",
                  ),
                ),
                _law(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/usage_illicite_contenu_page.dart",
                    "f00063",
                    "article L. 3421-1 alinéa 1 du Code de la santé publique",
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/usage_illicite_contenu_page.dart",
                    "f00064",
                    "Aggravée : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/usage_illicite_contenu_page.dart",
                    "f00065",
                    "5 ans d’emprisonnement et 75 000 € d’amende. — ",
                  ),
                ),
                _law(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/usage_illicite_contenu_page.dart",
                    "f00066",
                    "article L. 3421-1 alinéa 2 du Code de la santé publique",
                  ),
                ),
                const TextSpan(text: "."),
              ]),

              const SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/usage_illicite_contenu_page.dart",
                  "f00067",
                  "Dispositions thérapeutiques",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/usage_illicite_contenu_page.dart",
                      "f00068",
                      "Un traitement médical peut être prescrit ou ordonné par les autorités judiciaires ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/usage_illicite_contenu_page.dart",
                      "f00069",
                      "à tous les stades de la procédure pénale engagée contre l’auteur.",
                    ),
              ),
              const SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/usage_illicite_contenu_page.dart",
                    "f00070",
                    "• Injonction thérapeutique du procureur (suspend les poursuites) — ",
                  ),
                ),
                _law(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/usage_illicite_contenu_page.dart",
                    "f00071",
                    "article L. 3423-1 du Code de la santé publique",
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/usage_illicite_contenu_page.dart",
                    "f00072",
                    "• Injonction thérapeutique du juge d’instruction ou du JLD — ",
                  ),
                ),
                _law(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/usage_illicite_contenu_page.dart",
                    "f00073",
                    "article L. 3424-1 du Code de la santé publique",
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/usage_illicite_contenu_page.dart",
                    "f00074",
                    "• Injonction thérapeutique du juge des enfants (usager mineur) — ",
                  ),
                ),
                _law(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/usage_illicite_contenu_page.dart",
                    "f00075",
                    "article L. 3424-1 du Code de la santé publique",
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/usage_illicite_contenu_page.dart",
                    "f00076",
                    "• Injonction thérapeutique de la juridiction de jugement — ",
                  ),
                ),
                _law(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/usage_illicite_contenu_page.dart",
                    "f00077",
                    "article L. 3425-1 du Code de la santé publique",
                  ),
                ),
                const TextSpan(text: "."),
              ]),

              const SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/usage_illicite_contenu_page.dart",
                  "f00078",
                  "Amende forfaitaire délictuelle",
                ),
              ),
              _Paragraph.rich([
                _law(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/usage_illicite_contenu_page.dart",
                    "f00079",
                    "Article L. 3421-1 du Code de la santé publique",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/usage_illicite_contenu_page.dart",
                    "f00080",
                    " : étend la possibilité de recourir à l’amende forfaitaire délictuelle, prévue par ",
                  ),
                ),
                _law(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/usage_illicite_contenu_page.dart",
                    "f00081",
                    "les articles 495-17 à 495-25 du Code de procédure pénale",
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  _law(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/usage_illicite_contenu_page.dart",
                      "f00082",
                      "L’article L. 3421-1 alinéa 2 du Code de la santé publique",
                    ),
                  ),
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/usage_illicite_contenu_page.dart",
                          "f00083",
                          " exclut l’amende forfaitaire délictuelle lorsque l’usage est commis dans l’exercice ou à l’occasion ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/usage_illicite_contenu_page.dart",
                          "f00084",
                          "de fonctions (dépositaire de l’autorité publique/mission de service public) ou par du personnel de transport ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/usage_illicite_contenu_page.dart",
                          "f00085",
                          "avec fonctions liées à la sécurité du transport.",
                        ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/usage_illicite_contenu_page.dart",
                  "f00086",
                  "Tentative & complicité",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/usage_illicite_contenu_page.dart",
                  "f00087",
                  "Tentative : NON (non prévue).",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/usage_illicite_contenu_page.dart",
                    "f00088",
                    "Complicité : OUI, conformément aux ",
                  ),
                ),
                _law(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/usage_illicite_contenu_page.dart",
                    "f00089",
                    "articles 121-6 et 121-7 du Code pénal",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/usage_illicite_contenu_page.dart",
                    "f00090",
                    " (aide et assistance, provocation, instructions données).",
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
