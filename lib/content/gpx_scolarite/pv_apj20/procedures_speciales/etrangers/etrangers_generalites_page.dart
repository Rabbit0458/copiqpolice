import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class EtrangersGeneralitesPage extends StatelessWidget {
  const EtrangersGeneralitesPage({super.key});

  static const String routeName =
      '/gpx/pv_apj20/procedures_speciales/etrangers/generalites';

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
    final Color cardCond = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardModal = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardVigi = isDark
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

    TextSpan law(String t) => TextSpan(
      text: t,
      style: const TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
    );

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
            "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart",
            "f00002",
            "Procédures spéciales",
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
              "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart",
              "f00003",
              "Contrôle de la situation des étrangers",
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Définition / principe
          _ConditionCard(
            title: "Principe",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart",
                    "f00004",
                    "Toute personne de nationalité étrangère doit pouvoir présenter aux forces de l’ordre les pièces ou documents l’autorisant à circuler ou séjourner en France — ",
                  ),
                ),
                law(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart",
                    "f00005",
                    "art. L. 812-1 du CESEDA",
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart",
                    "f00006",
                    "Ce contrôle n’est possible que si des circonstances extérieures à la personne permettent d’en déduire sa qualité d’étranger — ",
                  ),
                ),
                law(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart",
                    "f00007",
                    "art. L. 812-2 du CESEDA",
                  ),
                ),
                const TextSpan(text: "."),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut (base juridique opérationnelle)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart",
              "f00008",
              "I — Base légale & conditions de déclenchement",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart",
                  "f00009",
                  "Ce qu’il faut retenir",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart",
                      "f00010",
                      "Le contrôle de la situation d’un étranger n’est jamais “automatique”.\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart",
                      "f00011",
                      "Il doit reposer sur des éléments objectifs d’extranéité et exclure toute discrimination.",
                    ),
              ),
              const SizedBox(height: 12),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart",
                      "f00012",
                      "Fondement central : ",
                    ),
                  ),
                  law(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart",
                      "f00013",
                      "art. L. 812-2 du CESEDA",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart",
                      "f00014",
                      " (circonstances extérieures à la personne → qualité d’étranger).",
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // I — Cas de contrôle
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart",
              "f00015",
              "II — Cas de contrôle de régularité (circulation / séjour)",
            ),
            cardColor: cardCond,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart",
                  "f00016",
                  "A) Après un contrôle d’identité",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart",
                    "f00017",
                    "Lors d’un contrôle d’identité réalisé sur le fondement des articles ",
                  ),
                ),
                law(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart",
                    "f00018",
                    "78-1, 78-2, 78-2-1 et 78-2-2 du CPP",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart",
                    "f00019",
                    ", la personne doit justifier de son identité. Si le contrôle révèle une nationalité étrangère, elle peut être tenue de présenter les documents de circulation / séjour — ",
                  ),
                ),
                law(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart",
                    "f00020",
                    "art. L. 812-2 (2°) du CESEDA",
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart",
                      "f00021",
                      "La déduction de la nationalité doit reposer sur des critères objectifs excluant toute discrimination. La simple évocation “être né à l’étranger” sans précisions ne suffit pas.",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart",
                  "f00022",
                  "B) Qualité d’étranger apparente (sans contrôle d’identité préalable)",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart",
                    "f00023",
                    "Le contrôle peut être effectué directement si des éléments objectifs d’extranéité, extérieurs à la personne, permettent d’en déduire la qualité d’étranger — ",
                  ),
                ),
                law(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart",
                    "f00024",
                    "art. L. 812-2 (1°) du CESEDA",
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart",
                      "f00025",
                      "Exemples jurisprudentiels (liste non exhaustive) :\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart",
                      "f00026",
                      "• véhicule immatriculé à l’étranger ;\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart",
                      "f00027",
                      "• participation à une manifestation avec banderoles étrangères ;\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart",
                      "f00028",
                      "• tracts / affiches en langue étrangère ;\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart",
                      "f00029",
                      "• entrée/sortie d’un consulat/ambassade ;\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart",
                      "f00030",
                      "• document d’identité étranger en main ;\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart",
                      "f00031",
                      "• déclaration spontanée de sa qualité d’étranger, etc.",
                    ),
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart",
                      "f00032",
                      "Sont à exclure : couleur de peau, langue parlée, tenue vestimentaire… (risque de discrimination).",
                    ),
                  ),
                ],
                title: "VIGILANCE",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart",
                    "f00033",
                    "Durée : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart",
                    "f00034",
                    "pas de contrôle systématique",
                  ),
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " et "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart",
                    "f00035",
                    "maximum 6 heures consécutives dans un même lieu",
                  ),
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              const SizedBox(height: 14),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart",
                  "f00036",
                  "C) Visite sommaire d’un véhicule",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart",
                    "f00037",
                    "Cadre : ",
                  ),
                ),
                law(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart",
                    "f00038",
                    "art. L. 812-3 et suivants du CESEDA",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart",
                    "f00039",
                    ". Compétence exclusive de l’OPJ (assisté éventuellement d’APJ/APJA).",
                  ),
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart",
                      "f00040",
                      "Zones concernées (exemples) :\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart",
                      "f00041",
                      "• bande 20 km en deçà de la frontière terrestre Schengen ;\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart",
                      "f00042",
                      "• bande 20 km en deçà du littoral dans certains départements (arrêté) ;\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart",
                      "f00043",
                      "• rayon max 10 km autour de ports/aéroports (arrêté) ;\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart",
                      "f00044",
                      "• aires / péages autoroutiers liés à ces zones.",
                    ),
              ),
              const SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart",
                  "f00045",
                  "Mise en œuvre :",
                ),
              ),
              const SizedBox(height: 6),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart",
                  "f00046",
                  "Avec l’accord du conducteur, ou",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart",
                  "f00047",
                  "À défaut, sur instructions du procureur de la République.",
                ),
              ),
              const SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart",
                      "f00048",
                      "But : vérifier le respect des obligations de détention, port et présentation des documents ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart",
                      "f00049",
                      "ou rechercher/constater les infractions relatives à l’entrée et au séjour des étrangers en France.",
                    ),
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart",
                    "f00050",
                    "Immobilisation : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart",
                    "f00051",
                    "4 heures maximum",
                  ),
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart",
                    "f00052",
                    " dans l’attente des instructions du procureur. Sans instructions à l’issue : libre de repartir.",
                  ),
                ),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart",
                          "f00053",
                          "La retenue ne s’applique pas au conducteur : il peut téléphoner librement (sauf procédure incidente). ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart",
                          "f00054",
                          "Des dispositions similaires existent pour navires/engins flottants.",
                        ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // II — Vérification du droit au séjour
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart",
              "f00055",
              "III — Vérification du droit au séjour",
            ),
            cardColor: cardModal,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart",
                  "f00056",
                  "A) Entrée et documents",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart",
                      "f00057",
                      "Pour entrer en France : passeport ou carte d’identité en cours de validité, visa éventuel…\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart",
                      "f00058",
                      "UE/EEE/Suisse : pas de visa, mais document d’identité valide.\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart",
                      "f00059",
                      "Certaines nationalités peuvent être dispensées de visa (références internes D.C.P.A.F).",
                    ),
              ),
              const SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart",
                  "f00060",
                  "B) Séjour au-delà de 3 mois",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart",
                    "f00061",
                    "Au-delà de 3 mois, l’étranger de plus de 18 ans doit détenir un document de séjour — ",
                  ),
                ),
                law(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart",
                    "f00062",
                    "art. L. 411-1 du CESEDA",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart",
                    "f00063",
                    " (visa long séjour, cartes de séjour, carte de résident, etc.).",
                  ),
                ),
              ]),
              const SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart",
                  "f00064",
                  "C) Mineurs étrangers",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart",
                    "f00065",
                    "Les mineurs étrangers résidant en France peuvent obtenir de plein droit un document de circulation (5 ans) sous conditions — ",
                  ),
                ),
                law(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart",
                    "f00066",
                    "art. L. 414-4 à L. 414-9 du CESEDA",
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart",
                  "f00067",
                  "D) Fraude à l’identité / usage frauduleux",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart",
                    "f00068",
                    "L’utilisation par un porteur autre que le titulaire légitime d’un document authentique constitue une fraude à l’identité — ",
                  ),
                ),
                law(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart",
                    "f00069",
                    "art. 441-8 du Code pénal",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart",
                    "f00070",
                    ". Cela vise aussi l’usage frauduleux des titres de séjour et documents provisoires.",
                  ),
                ),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart",
                      "f00071",
                      "Tous les titres de séjour sont sécurisés : un examen attentif peut révéler un faux ou au minimum des anomalies justifiant vérifications OPJ.",
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Retenue vérification droit au séjour
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart",
              "f00072",
              "IV — Retenue pour vérification du droit au séjour",
            ),
            cardColor: cardVigi,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart",
                    "f00073",
                    "La retenue intervient lorsque la personne n’a pas justifié de son droit à circuler ou séjourner par la présentation de pièces et documents — ",
                  ),
                ),
                law(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart",
                    "f00074",
                    "art. L. 813-1 du CESEDA",
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart",
                      "f00075",
                      "Nature : procédure administrative.\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart",
                      "f00076",
                      "Finalité : examens de situation administrative et/ou décisions administratives la concernant.",
                    ),
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart",
                    "f00077",
                    "Durée maximale : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart",
                    "f00078",
                    "24 heures",
                  ),
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart",
                    "f00079",
                    " à compter du début du contrôle.",
                  ),
                ),
              ]),
              const SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart",
                  "f00080",
                  "Compétence & contrôle",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart",
                  "f00081",
                  "Placement : compétence exclusive de l’OPJ, sous le contrôle du procureur de la République.",
                ),
              ),
              const SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart",
                  "f00082",
                  "Droits de la personne",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart",
                        "f00083",
                        "La personne bénéficie de droits : interprète, avocat, examen médical, avis à une personne de son choix, autorités consulaires…\n",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart",
                        "f00084",
                        "Notification : motifs, durée max et droits dans une langue comprise, par OPJ (ou APJ sous contrôle) — ",
                      ),
                ),
                law(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart",
                    "f00085",
                    "art. L. 813-5 du CESEDA",
                  ),
                ),
                const TextSpan(text: "."),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Synthèse actionnable
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart",
              "f00086",
              "Synthèse terrain (mémo rapide)",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart",
                  "f00087",
                  "Toujours rattacher l’acte à une base légale CESEDA (et CPP si contrôle d’identité).",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart",
                  "f00088",
                  "Exclure tout critère discriminatoire : uniquement des éléments objectifs et extérieurs.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart",
                  "f00089",
                  "Visite sommaire véhicule : OPJ uniquement, accord conducteur ou instructions parquet, immobilisation max 4 h.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart",
                  "f00090",
                  "Retenue vérification séjour : administrative, max 24 h, droits notifiés (interprète/avocat/médecin/avis).",
                ),
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
