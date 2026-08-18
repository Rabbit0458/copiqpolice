import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class AsControleAlcoolemiePage extends StatelessWidget {
  const AsControleAlcoolemiePage({super.key});

  static const String routeName =
      '/gpx/pv_apj20/circulation_routiere/alcool/generalites';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette cards
    final Color cardLegal = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardFacts = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardModal = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
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
            "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/as_controle_alcoolemie_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/as_controle_alcoolemie_page.dart",
            "f00002",
            "Alcoolémie",
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
              "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/as_controle_alcoolemie_page.dart",
              "f00003",
              "Cas de contrôle de l’alcoolémie",
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Intro (objectif pédagogique)
          _ConditionCard(
            title: "Objectif",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/as_controle_alcoolemie_page.dart",
                      "f00004",
                      "Synthèse opérationnelle des cas de contrôle de l’alcoolémie : ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/as_controle_alcoolemie_page.dart",
                      "f00005",
                      "quand le contrôle est obligatoire, facultatif ou préventif, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/as_controle_alcoolemie_page.dart",
                      "f00006",
                      "et quelles vérifications peuvent être réalisées.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut (obligatoire)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/as_controle_alcoolemie_page.dart",
              "f00007",
              "I — Élément légal",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/as_controle_alcoolemie_page.dart",
                    "f00008",
                    "Article L.234-3 du Code de la route",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/as_controle_alcoolemie_page.dart",
                    "f00009",
                    " : fixe les hypothèses de contrôle (notamment après accident corporel et certaines infractions entraînant S.P.C.).",
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/as_controle_alcoolemie_page.dart",
                    "f00010",
                    "Article L.234-9 du Code de la route",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/as_controle_alcoolemie_page.dart",
                    "f00011",
                    " : prévoit le contrôle préventif (instructions du procureur / initiative O.P.J. ou A.P.J.), sans infraction préalable nécessaire.",
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/as_controle_alcoolemie_page.dart",
                      "f00012",
                      "Les vérifications destinées à établir la preuve de la présence d’alcool dans l’organisme peuvent aussi être réalisées dans les cas prévus par ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/as_controle_alcoolemie_page.dart",
                      "f00013",
                      "l’article L.3354-1 du Code de la santé publique",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: ". "),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/as_controle_alcoolemie_page.dart",
                      "f00014",
                      "Un dépistage préalable peut être effectué (loi n°70-597 du 09/07/1970 – art.3).",
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // I/ Faits constatés (table “propre” en cartes)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/as_controle_alcoolemie_page.dart",
              "f00015",
              "II — Cas de contrôle (faits constatés)",
            ),
            cardColor: cardFacts,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/as_controle_alcoolemie_page.dart",
                  "f00016",
                  "A) Contrôle OBLIGATOIRE",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/as_controle_alcoolemie_page.dart",
                    "f00017",
                    "C.R. — Article L.234-3 alinéa 1",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/as_controle_alcoolemie_page.dart",
                    "f00018",
                    " : accident corporel de la circulation.",
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/as_controle_alcoolemie_page.dart",
                  "f00019",
                  "Personnes concernées : conducteur ou accompagnateur d’un élève conducteur.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/as_controle_alcoolemie_page.dart",
                  "f00020",
                  "Condition : être en présence des conducteurs/accompagnateurs impliqués dans l’accident, ou de l’auteur présumé de l’infraction.",
                ),
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/as_controle_alcoolemie_page.dart",
                  "f00021",
                  "Modalités : vérifications sans dépistage préalable OU dépistage puis vérifications le cas échéant.",
                ),
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/as_controle_alcoolemie_page.dart",
                  "f00022",
                  "B) Contrôle OBLIGATOIRE (infractions entraînant S.P.C.)",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/as_controle_alcoolemie_page.dart",
                    "f00023",
                    "C.R. — Article L.234-3 alinéa 2",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/as_controle_alcoolemie_page.dart",
                    "f00024",
                    " : infractions au code de la route entraînant S.P.C. (ex : excès de vitesse ≥ 30 km/h, C.E.I.).",
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/as_controle_alcoolemie_page.dart",
                  "f00025",
                  "Modalités : dépistage puis vérifications le cas échéant.",
                ),
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/as_controle_alcoolemie_page.dart",
                  "f00026",
                  "C) Contrôle FACULTATIF",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/as_controle_alcoolemie_page.dart",
                    "f00027",
                    "C.R. — Article L.234-3 alinéa 2",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/as_controle_alcoolemie_page.dart",
                    "f00028",
                    " : toutes les autres infractions au code de la route.",
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/as_controle_alcoolemie_page.dart",
                  "f00029",
                  "Modalités : dépistage puis vérifications le cas échéant.",
                ),
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/as_controle_alcoolemie_page.dart",
                  "f00030",
                  "D) Contrôle PRÉVENTIF",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/as_controle_alcoolemie_page.dart",
                    "f00031",
                    "C.R. — Article L.234-9",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/as_controle_alcoolemie_page.dart",
                    "f00032",
                    " : instructions du procureur ou initiative de l’O.P.J./A.P.J. (aucune infraction préalable nécessaire).",
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/as_controle_alcoolemie_page.dart",
                  "f00033",
                  "Modalités : dépistage puis vérifications le cas échéant.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/as_controle_alcoolemie_page.dart",
                  "f00034",
                  "OU vérifications sans dépistage préalable uniquement si réalisées immédiatement et sur les lieux (ex : éthylomètre embarqué).",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Personnes / conditions complémentaires (bloc très pédagogique)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/as_controle_alcoolemie_page.dart",
              "f00035",
              "III — Personnes concernées & conditions",
            ),
            cardColor: cardModal,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/as_controle_alcoolemie_page.dart",
                  "f00036",
                  "A) Faits ouvrant la possibilité de vérifications",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/as_controle_alcoolemie_page.dart",
                  "f00037",
                  "Accident de la circulation",
                ),
              ),
              _IntroBullet(text: "Crime"),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/as_controle_alcoolemie_page.dart",
                  "f00038",
                  "Délit",
                ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/as_controle_alcoolemie_page.dart",
                  "f00039",
                  "B) Qui peut être contrôlé ? (auteur présumé)",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/as_controle_alcoolemie_page.dart",
                  "f00040",
                  "Conducteur de véhicule soumis au Code de la route.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/as_controle_alcoolemie_page.dart",
                  "f00041",
                  "Conducteur de véhicule non soumis au Code de la route (train, tramway — R.110-3 et R.422-3 C.R.).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/as_controle_alcoolemie_page.dart",
                  "f00042",
                  "Autre personne : piéton, cavalier, conducteur de troupeaux, conducteur d’un bateau ou membre d’équipage participant à la conduite/manœuvre/exploitation, responsable(s) d’un accident du travail, auteur de violences, etc.",
                ),
              ),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/as_controle_alcoolemie_page.dart",
                  "f00043",
                  "C) Conditions pratiques",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/as_controle_alcoolemie_page.dart",
                  "f00044",
                  "Être en présence d’un mis en cause dont le comportement extérieur laisse présumer un état alcoolique au moment des faits.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/as_controle_alcoolemie_page.dart",
                  "f00045",
                  "Être en présence d’un mort : vérifications possibles même sans présomption d’alcoolémie.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/as_controle_alcoolemie_page.dart",
                  "f00046",
                  "Victime(s) : si les vérifications paraissent utiles à l’administration de la preuve.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Modalités / procédure (éthylomètre + prélèvement sanguin)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/as_controle_alcoolemie_page.dart",
              "f00047",
              "IV — Nature & modalités des vérifications",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/as_controle_alcoolemie_page.dart",
                  "f00048",
                  "A) Principe : privilégier l’éthylomètre",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/as_controle_alcoolemie_page.dart",
                      "f00049",
                      "Le choix du mode de vérifications revient exclusivement aux policiers intervenants, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/as_controle_alcoolemie_page.dart",
                      "f00050",
                      "qui doivent privilégier l’utilisation de l’éthylomètre. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/as_controle_alcoolemie_page.dart",
                      "f00051",
                      "La valeur juridique des mesures par éthylomètre est équivalente à celle d’une analyse sanguine.",
                    ),
              ),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/as_controle_alcoolemie_page.dart",
                  "f00052",
                  "B) Quand recourir au prélèvement sanguin ?",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/as_controle_alcoolemie_page.dart",
                  "f00053",
                  "Éthylomètre en panne ou indisponible.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/as_controle_alcoolemie_page.dart",
                  "f00054",
                  "Conducteur gravement blessé (sauf contre-indication médicale) ou décédé.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/as_controle_alcoolemie_page.dart",
                  "f00055",
                  "Handicap / incapacité physique attestée par un médecin.",
                ),
              ),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/as_controle_alcoolemie_page.dart",
                  "f00056",
                  "C) Dépistage impossible ou refus",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/as_controle_alcoolemie_page.dart",
                  "f00057",
                  "Dépistage impossible : conducteur gravement blessé/décédé/incapacité physique attestée.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/as_controle_alcoolemie_page.dart",
                  "f00058",
                  "Refus de dépistage : conducteur ou accompagnateur d’un élève conducteur (quel que soit le cas de contrôle).",
                ),
              ),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/as_controle_alcoolemie_page.dart",
                  "f00059",
                  "D) Réquisitions médicales & formalités",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/as_controle_alcoolemie_page.dart",
                      "f00060",
                      "Réquisition d’un médecin (ou à défaut : interne/étudiant autorisé, ou infirmier). ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/as_controle_alcoolemie_page.dart",
                      "f00061",
                      "Deux échantillons de sang sont prélevés, avec examen clinique.",
                    ),
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/as_controle_alcoolemie_page.dart",
                  "f00062",
                  "Fiche A renseignée par le policier.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/as_controle_alcoolemie_page.dart",
                  "f00063",
                  "Fiche B-C renseignée par le médecin.",
                ),
              ),
              SizedBox(height: 10),

              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/as_controle_alcoolemie_page.dart",
                  "f00064",
                  "Circuit d’analyse",
                ),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/as_controle_alcoolemie_page.dart",
                          "f00065",
                          "Envoi au laboratoire/biologiste expert : 1 échantillon + 4 exemplaires des fiches A et B-C. ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/as_controle_alcoolemie_page.dart",
                          "f00066",
                          "Le 2e échantillon + 1 exemplaire des fiches A et B-C sont envoyés à un autre laboratoire pour une éventuelle analyse de contrôle.",
                        ),
                  ),
                ],
              ),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/as_controle_alcoolemie_page.dart",
                  "f00067",
                  "E) Notification du taux & marge d’erreur",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/as_controle_alcoolemie_page.dart",
                      "f00068",
                      "Doivent être notifiés à l’intéressé :\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/as_controle_alcoolemie_page.dart",
                      "f00069",
                      "• le taux affiché (mg/l)\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/as_controle_alcoolemie_page.dart",
                      "f00070",
                      "• le taux retenu après soustraction de la marge d’erreur (mg/l) :",
                    ),
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/as_controle_alcoolemie_page.dart",
                  "f00071",
                  "Taux affiché < 0,40 mg/l → soustraire 0,032 mg/l.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/as_controle_alcoolemie_page.dart",
                  "f00072",
                  "Taux affiché entre 0,40 mg/l et 2 mg/l → soustraire 8%.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/as_controle_alcoolemie_page.dart",
                  "f00073",
                  "Taux affiché > 2 mg/l → soustraire 30%.",
                ),
              ),
              SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/as_controle_alcoolemie_page.dart",
                  "f00074",
                  "Référence pratique : application CONVERTAUX via NEO.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Qualification selon seuils (contrav/délit) — rendu net
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/as_controle_alcoolemie_page.dart",
              "f00075",
              "V — Seuils & qualification (rappel)",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/as_controle_alcoolemie_page.dart",
                  "f00076",
                  "A) Contravention",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/as_controle_alcoolemie_page.dart",
                  "f00077",
                  "≥ 0,10 et < 0,40 mg/l air expiré (ou ≥ 0,20 et < 0,80 g/l sang) : transport en commun, EAD, permis probatoire, apprentissage → contravention.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/as_controle_alcoolemie_page.dart",
                  "f00078",
                  "≥ 0,25 et < 0,40 mg/l air expiré (ou ≥ 0,50 et < 0,80 g/l sang) : autre conducteur ou accompagnateur d’un élève conducteur → contravention.",
                ),
              ),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/as_controle_alcoolemie_page.dart",
                  "f00079",
                  "B) Délit",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/as_controle_alcoolemie_page.dart",
                  "f00080",
                  "≥ 0,40 mg/l air expiré (ou ≥ 0,80 g/l sang) : tout conducteur ou accompagnateur d’un élève conducteur → délit.",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/as_controle_alcoolemie_page.dart",
                      "f00081",
                      "Si C.E.I. : penser à constater les deux délits (selon la situation).",
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Tentative & complicité (comme tu l’exiges)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/as_controle_alcoolemie_page.dart",
              "f00082",
              "VI — Tentative & complicité",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle("Tentative"),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/as_controle_alcoolemie_page.dart",
                  "f00083",
                  "Non applicable ici : il s’agit d’un régime de contrôle et de constatations (pas une infraction autonome).",
                ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/as_controle_alcoolemie_page.dart",
                  "f00084",
                  "Complicité",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/as_controle_alcoolemie_page.dart",
                    "f00085",
                    "En matière d’infractions liées à l’alcool au volant : la complicité peut être retenue selon le droit commun, conformément à ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/as_controle_alcoolemie_page.dart",
                    "f00086",
                    "l’article 121-6 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " et "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/as_controle_alcoolemie_page.dart",
                    "f00087",
                    "l’article 121-7 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
            ],
          ),

          const SizedBox(height: 18),
          _ConditionCard(
            title: "Source",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/as_controle_alcoolemie_page.dart",
                  "f00088",
                  "Recueil de PV / Retour Sommaire — mise à jour : 16/07/2024.",
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
