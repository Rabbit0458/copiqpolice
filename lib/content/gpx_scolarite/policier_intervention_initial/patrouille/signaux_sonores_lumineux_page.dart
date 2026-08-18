import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class SignauxSonoresLumineuxPage extends StatelessWidget {
  const SignauxSonoresLumineuxPage({super.key});

  static const String routeName =
      '/gpx/intervention/patrouille/signaux-sonores-lumineux';

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
    final Color cardTypes = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardUse = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardInfra = isDark
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
            "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          "Patrouille",
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
              "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
              "f00002",
              "Usage des signaux sonores et lumineux",
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Intro / objectif
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
              "f00003",
              "But & logique d’emploi",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
                      "f00004",
                      "Pour faciliter l’intervention et la rapidité des secours, certains véhicules d’intérêt général ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
                      "f00005",
                      "sont équipés d’avertisseurs spéciaux (sonores et lumineux).\n\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
                      "f00006",
                      "⚠️ Deux régimes existent :\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
                      "f00007",
                      "• véhicules prioritaires (police, gendarmerie, incendie/secours…)\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
                      "f00008",
                      "• véhicules bénéficiant de facilités de passage (ambulances, interventions techniques, etc.).\n\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
                      "f00009",
                      "Dans les cas justifiés par l’urgence, et seulement avec les avertisseurs spéciaux, certaines règles ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
                      "f00010",
                      "du Code de la route peuvent ne pas s’appliquer.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
              "f00011",
              "I — Cadre légal (à connaître)",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
                    "f00012",
                    "Article R. 311-1 du Code de la route",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
                    "f00013",
                    " : définit les véhicules d’intérêt général (prioritaires / facilités de passage).",
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
                    "f00014",
                    "Catégories d’avertisseurs : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
                    "f00015",
                    "articles R. 313-34 et R. 313-27 du Code de la route",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
                    "f00016",
                    "Dérogations possibles (si urgence + avertisseurs) : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
                    "f00017",
                    "articles R. 432-1 à R. 432-4 du Code de la route",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
                    "f00018",
                    "Obligation des autres usagers de faciliter le passage : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
                    "f00019",
                    "articles R. 414-2 et R. 414-9 du Code de la route",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                title: "Nota",
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
                      "f00020",
                      "Certains véhicules lents / encombrants peuvent être dotés de feux jaune-orangé : ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
                      "f00021",
                      "article R. 313-31 (2°) du Code de la route",
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

          // Types de véhicules / catégories A-B
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
              "f00022",
              "II — Véhicules d’intérêt général : 2 régimes",
            ),
            cardColor: cardTypes,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
                  "f00023",
                  "A) Véhicules d’intérêt général prioritaires",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
                      "f00024",
                      "Exemples : police (banalisés ou non), unités militaires de sécurité civile, gendarmerie, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
                      "f00025",
                      "pompiers (incendie et secours), services de déminage, douanes, SAMU/SMUR, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
                      "f00026",
                      "ministère de la justice (transport de détenus / rétablissement de l’ordre pénitentiaire).",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
                  "f00027",
                  "Avertisseurs — Catégorie A",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
                      "f00028",
                      "• Sonore : « deux tons »\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
                      "f00029",
                      "• Lumineux : gyrophares bleus (fixes ou amovibles), à faisceaux tournants.\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
                      "f00030",
                      "• Dérogations : ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
                      "f00031",
                      "toutes les règles relatives à l’usage des voies",
                    ),
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
                      "f00032",
                      " (si urgence + avertisseurs + prudence).",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
                  "f00033",
                  "B) Véhicules bénéficiant de facilités de passage",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
                      "f00034",
                      "Exemples : ambulances, premiers secours à personnes (associations agréées), ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
                      "f00035",
                      "interventions des gestionnaires d’infrastructures électriques et gazières, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
                      "f00036",
                      "surveillance SNCF/RATP, transports de fonds Banque de France, permanence des soins, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
                      "f00037",
                      "transports de produits sanguins / organes humains, engins de service hivernal, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
                      "f00038",
                      "interventions sur autoroutes et routes à chaussées séparées.",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
                  "f00039",
                  "Avertisseurs — Catégorie B",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
                      "f00040",
                      "• Sonore : « trois tons »\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
                      "f00041",
                      "• Lumineux : feux bleus à éclats (fixes ou amovibles), à faisceaux stationnaires.\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
                      "f00042",
                      "• Dérogations principales : ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
                      "f00043",
                      "vitesse + circulation sur voies réservées",
                    ),
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                  TextSpan(text: "."),
                ],
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: "Nota",
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
                      "f00044",
                      "Les articles ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
                      "f00045",
                      "R. 432-3 et R. 432-4 du Code de la route",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
                      "f00046",
                      " prévoient, dans certains cas, des dérogations supplémentaires (autoroute/route express, engins hivernaux, etc.).",
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Conditions d'usage
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
              "f00047",
              "III — Conditions permettant de déroger au Code de la route",
            ),
            cardColor: cardUse,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
                      "f00048",
                      "L’usage des avertisseurs sonores et lumineux doit répondre à une nécessité absolue : ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
                      "f00049",
                      "interventions particulièrement urgentes, entrant strictement dans les missions de protection, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
                      "f00050",
                      "de police ou de secours.\n\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
                      "f00051",
                      "➡️ L’usage doit être limité dans la durée.\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
                      "f00052",
                      "➡️ Même en urgence, les règles générales de prudence restent impératives.",
                    ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
                  "f00053",
                  "Pratiques recommandées",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
                  "f00054",
                  "De nuit : limiter l’avertisseur sonore aux cas extrêmes ; appels de phare + gyrophare suffisent souvent.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
                  "f00055",
                  "De jour en conduite rapide : les feux spéciaux peuvent s’accompagner de l’allumage des feux de route.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
                  "f00056",
                  "Certains fourgons disposent de rampes arrière utiles en statique (constat accident), visibles de très loin.",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: "Rappel",
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
                      "f00057",
                      "Avertisseurs ≠ autorisation de prendre des risques. La prudence prime toujours.",
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Infractions
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
              "f00058",
              "IV — Infractions liées aux avertisseurs spéciaux",
            ),
            cardColor: cardInfra,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
                      "f00059",
                      "Le fait de détenir, d’utiliser, d’adapter, de placer, d’appliquer ou de transporter ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
                      "f00060",
                      "les feux / avertisseurs sonores spéciaux réservés aux véhicules d’intérêt général ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
                      "f00061",
                      "est sanctionné (contravention de 4ᵉ classe).",
                    ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
                  "f00062",
                  "Feux spéciaux",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
                    "f00063",
                    "Référence : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
                    "f00064",
                    "article R. 313-29 du Code de la route",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
                  "f00065",
                  "Usage irrégulier de feux spéciaux réservés aux véhicules d’intérêt général (contravention 4ᵉ classe).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
                  "f00066",
                  "Installation irrégulière de feux spéciaux réservés aux véhicules d’intérêt général.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
                  "f00067",
                  "Détention / transport irrégulier de feux spéciaux réservés aux véhicules d’intérêt général.",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
                  "f00068",
                  "Mesures possibles",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
                      "f00069",
                      "Saisie des feux (et, selon contexte, mesures administratives/immobilisation).",
                    ),
                  ),
                ],
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
                  "f00070",
                  "Avertisseur sonore",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
                    "f00071",
                    "Référence : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
                    "f00072",
                    "article R. 313-35 du Code de la route",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
                  "f00073",
                  "Usage irrégulier d’un avertisseur sonore spécial réservé aux véhicules d’intérêt général (contravention 4ᵉ classe).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
                  "f00074",
                  "Installation irrégulière d’un avertisseur sonore réservé aux véhicules d’intérêt général.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
                  "f00075",
                  "Détention / transport irrégulier d’un avertisseur sonore réservé aux véhicules d’intérêt général.",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
                  "f00076",
                  "Mesures possibles",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
                      "f00077",
                      "Saisie des avertisseurs (et suites adaptées selon procédure).",
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Sécurité / poursuites
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
              "f00078",
              "V — Poursuites : “le jeu en vaut-il la chandelle ?”",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
                      "f00079",
                      "Les accidents graves lors de poursuites rappellent une réalité : la poursuite expose ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
                      "f00080",
                      "policiers et usagers à des risques très importants au regard de l’enjeu.\n\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
                      "f00081",
                      "Elle ne peut se justifier qu’en raison d’un fait particulièrement grave et connu des policiers.",
                    ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
                  "f00082",
                  "Conduite à tenir (réflexes pro)",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
                  "f00083",
                  "Se poser la question en permanence : « Le jeu en vaut-il la chandelle ? »",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
                  "f00084",
                  "Respecter les règles élémentaires : ceinture, avertisseurs, ralentissement aux intersections.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
                  "f00085",
                  "Informer le CIC : progression, signalements, comportement, description, direction de fuite.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
                  "f00086",
                  "Appliquer les instructions du CIC (arrêt de la poursuite si le risque devient disproportionné).",
                ),
              ),
              SizedBox(height: 12),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
                  "f00087",
                  "À retenir",
                ),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
                          "f00088",
                          "Abandonner une poursuite après évaluation des risques n’est pas un aveu d’échec : ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
                          "f00089",
                          "c’est une preuve de sagesse et de professionnalisme.",
                        ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
                  "f00090",
                  "Focus sécurité",
                ),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
                          "f00091",
                          "Attention à l’« effet tunnel » : en poursuite, le conducteur se focalise sur le fuyard ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
                          "f00092",
                          "et peut négliger l’environnement (piétons, véhicules, adhérence, obstacles…). ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart",
                          "f00093",
                          "Les avertisseurs amplifient stress et tension : rester maître du rythme.",
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
