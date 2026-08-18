import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PalpationSecuritePage extends StatelessWidget {
  const PalpationSecuritePage({super.key});

  static const String routeName =
      '/gpx/intervention/patrouille/palpation-securite';

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
    final Color cardDef = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
    final Color cardModal = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardCases = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardPrivate = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);

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
            "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
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
              "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
              "f00002",
              "La palpation de sécurité",
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Définition (courte + claire)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
              "f00003",
              "Définition",
            ),
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
                      "f00004",
                      "La palpation de sécurité est une mesure de sûreté : elle consiste à appliquer les mains ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
                      "f00005",
                      "par-dessus les vêtements (et sur les accessoires/objets portés : sac, banane, casquette, etc.) ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
                      "f00006",
                      "pour vérifier qu’une personne n’est pas porteuse d’un objet dangereux pour elle-même ou pour autrui.\n\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
                      "f00007",
                      "➡️ Elle est sommaire, externe, administrative et guidée par des éléments objectifs (dangerosité potentielle).",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut (en rouge)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
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
                    "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
                    "f00009",
                    "Article R. 434-16 du Code de la sécurité intérieure",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
                        "f00010",
                        " : la palpation est exclusivement une mesure de sûreté, non systématique, réservée aux cas où elle est nécessaire ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
                        "f00011",
                        "pour la sécurité du policier/gendarme ou d’autrui ; elle vise à vérifier l’absence d’objet dangereux.",
                      ),
                ),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
                      "f00012",
                      "Principe : ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
                      "f00013",
                      "pratiquée à l’abri du regard du public ",
                    ),
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
                      "f00014",
                      "lorsque les circonstances le permettent.\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
                      "f00015",
                      "Règle : ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
                      "f00016",
                      "réalisée par une personne du même sexe",
                    ),
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
                      "f00017",
                      " (sauf situations exceptionnelles liées à la dangerosité/urgence).",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
                    "f00018",
                    "À distinguer de la fouille intégrale : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
                    "f00019",
                    "article 63-7 du Code de procédure pénale",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
                    "f00020",
                    " (mesure de recherche de preuve, pouvant aller jusqu’au déshabillage complet).",
                  ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Différences (pédagogie)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
              "f00021",
              "II — Différences à connaître",
            ),
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
                  "f00022",
                  "A) Palpation de sécurité",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
                  "f00023",
                  "But : vérifier l’absence d’objet dangereux (mesure de sûreté).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
                  "f00024",
                  "Méthode : contact externe, par-dessus les vêtements, sans retrait de vêtement.",
                ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
                  "f00025",
                  "B) Fouille de sécurité",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
                  "f00026",
                  "Avant rétention (GAV, IPM…) ou sous mandat : vérifications plus poussées et adaptées au contexte.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
                  "f00027",
                  "Nécessité : suspicion d’objets dangereux ; déshabillage complet interdit.",
                ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
                  "f00028",
                  "C) Fouille intégrale",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
                  "f00029",
                  "But : recherche de preuve (poche/doublures, etc.) ; peut impliquer un déshabillage complet.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Modalités
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
              "f00030",
              "III — Modalités de mise en œuvre",
            ),
            cardColor: cardModal,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
                  "f00031",
                  "Quand la pratiquer ?",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
                  "f00032",
                  "Jamais systématique : uniquement si les circonstances (temps/lieux/comportement) rendent nécessaire la recherche d’un objet dangereux.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
                  "f00033",
                  "Respect et discernement : pas de caractère vexatoire, pas d’agressivité.",
                ),
              ),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
                  "f00034",
                  "Comment la pratiquer ? (méthodique)",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
                  "f00035",
                  "Un seul agent effectue la palpation pendant qu’un ou deux collègues assurent la couverture et la sécurité de l’environnement.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
                  "f00036",
                  "Aucune dénudation : palpation au travers des vêtements uniquement.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
                  "f00037",
                  "Cibler d’abord les zones à risque (ceinture abdominale, creux lombaire, aisselles), puis compléter du haut vers le bas.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
                  "f00038",
                  "Dès découverte d’un objet suspect : informer immédiatement les collègues.",
                ),
              ),

              SizedBox(height: 12),

              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
                  "f00039",
                  "Technique recommandée (AMARIS)",
                ),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
                          "f00040",
                          "Privilégier la technique de pince : pressions successives avec le pouce et l’index, ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
                          "f00041",
                          "plutôt que de faire glisser les mains le long du corps.",
                        ),
                  ),
                ],
              ),

              SizedBox(height: 12),

              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
                  "f00042",
                  "Saisie / procédure",
                ),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
                          "f00043",
                          "La palpation ne nécessite pas la qualité d’OPJ. Les objets dangereux découverts (armes, outils d’effraction…) ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
                          "f00044",
                          "sont appréhendés matériellement puis remis à l’OPJ aux fins de saisie dans les formes de droit.",
                        ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Cas pratiques
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
              "f00045",
              "IV — Cas pratiques (terrain)",
            ),
            cardColor: cardCases,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
                  "f00046",
                  "Avant un contrôle d’identité",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
                      "f00047",
                      "Si la personne apparaît potentiellement dangereuse, il est conseillé d’effectuer une palpation de sécurité ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
                      "f00048",
                      "avant la mise en œuvre du contrôle.",
                    ),
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
                  "f00049",
                  "Indice apparent : forme d’une arme sous un vêtement, objet saillant…",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
                  "f00050",
                  "Comportement : alcool/stupéfiants, agressivité, agitation…",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
                  "f00051",
                  "Connaissance/infos utiles : antécédents (si consultation de traitements possible), contexte à risque…",
                ),
              ),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
                  "f00052",
                  "Après un contrôle d’identité sans infraction",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
                  "f00053",
                  "Une palpation postérieure ne se justifie plus si aucun comportement dangereux ou suspect n’est constaté.",
                ),
              ),
              SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
                      "f00054",
                      "En revanche, si la personne devient menaçante ou si la situation dégénère, la palpation peut redevenir nécessaire ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
                      "f00055",
                      "car elle protège policiers et tiers.",
                    ),
              ),

              SizedBox(height: 12),

              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
                  "f00056",
                  "Trace écrite",
                ),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
                          "f00057",
                          "Si le contrôle intervient dans des conditions dangereuses, il faut faire apparaître dans la procédure ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
                          "f00058",
                          "le caractère délicat/dangereux de l’intervention.",
                        ),
                  ),
                ],
              ),

              SizedBox(height: 12),

              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
                  "f00059",
                  "Attention",
                ),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
                          "f00060",
                          "Une palpation non justifiée peut être qualifiée d’atteinte à la dignité : les saisies incidentes ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
                          "f00061",
                          "et les procédures qui suivent peuvent être annulées.",
                        ),
                  ),
                ],
              ),

              SizedBox(height: 12),

              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
                    "f00062",
                    "Exemple jurisprudentiel : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
                    "f00063",
                    "Cass. crim., 27 septembre 1988",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
                        "f00064",
                        " — opération jugée régulière dès lors que les policiers se sont bornés à prendre les mesures nécessaires ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
                        "f00065",
                        "à leur sécurité et à celle des tiers.",
                      ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Particularités / dignité / transidentité
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
              "f00066",
              "V — Dignité, discrétion et situations particulières",
            ),
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
                  "f00067",
                  "Expliquer (si possible) : annoncer la palpation et son objectif (sécurité).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
                  "f00068",
                  "Ne pas exiger le retrait de vêtements ; éviter les positions vexatoires (appui mur, amené au sol, bras levés…).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
                  "f00069",
                  "Autant que possible : pratiquer à l’abri du regard du public.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
                  "f00070",
                  "Même sexe : principe. Exceptions uniquement si dangerosité/urgence ne permet pas autrement.",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: "NOTA",
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
                          "f00071",
                          "En matière de palpation/fouille, prendre en compte le genre. Certaines personnes transgenres peuvent présenter un formulaire explicatif ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
                          "f00072",
                          "et demander que l’opération soit réalisée par un homme ou une femme. Dans la mesure du possible, il est recommandé de tenir compte de cette demande.",
                        ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Agents privés
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
              "f00073",
              "VI — Palpation par des agents privés de sécurité",
            ),
            cardColor: cardPrivate,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
                      "f00074",
                      "La loi autorise, sous conditions, des palpations par des agents de sécurité privée. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
                      "f00075",
                      "Dans tous les cas : la personne doit donner son accord exprès et l’agent doit être du même sexe.",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
                    "f00076",
                    "Article L. 613-2 du Code de la sécurité intérieure",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
                        "f00077",
                        " : agents d’entreprises de surveillance/gardiennage ou services internes de sécurité, ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
                        "f00078",
                        "en cas de menaces graves pour la sécurité publique ou périmètre de protection par arrêté préfectoral.",
                      ),
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
                    "f00079",
                    "Article L. 613-3 du Code de la sécurité intérieure",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
                        "f00080",
                        " : sécurité à l’entrée d’enceintes de manifestations sportives/récréatives/culturelles ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
                        "f00081",
                        "rassemblant plus de 300 spectateurs (agents/membres du service d’ordre).",
                      ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Mémo AMARIS
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
              "f00082",
              "Mémo terrain (AMARIS) — “Comment faire ?”",
            ),
            cardColor: cardModal,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
                  "f00083",
                  "1) J’annonce",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
                  "f00084",
                  "Informer la personne que je vais procéder à une palpation de sécurité.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
                  "f00085",
                  "Si le contexte le permet : inviter à remettre volontairement les objets estimés dangereux (politesse + calme).",
                ),
              ),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
                  "f00086",
                  "2) Je respecte la dignité",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
                  "f00087",
                  "Je ne suis ni brutal ni agressif.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
                  "f00088",
                  "Je n’exige pas qu’elle ôte ses vêtements.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
                  "f00089",
                  "J’évite les positions vexatoires (mur, amené au sol, bras levés…).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
                  "f00090",
                  "Même sexe (hors situation exceptionnelle).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
                  "f00091",
                  "À l’abri du regard du public dès que possible.",
                ),
              ),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
                  "f00092",
                  "3) Je fais une palpation efficace",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
                  "f00093",
                  "Technique de pince : pressions successives + mouvement pouce/index.",
                ),
              ),

              SizedBox(height: 10),

              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
                  "f00094",
                  "En résumé",
                ),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
                          "f00095",
                          "La palpation sert uniquement à rechercher un objet dangereux. ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart",
                          "f00096",
                          "Elle doit respecter la dignité et être réalisée selon les techniques enseignées.",
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
