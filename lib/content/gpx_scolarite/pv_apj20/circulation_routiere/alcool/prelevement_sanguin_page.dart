import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PrelevementSanguinPage extends StatelessWidget {
  const PrelevementSanguinPage({super.key});

  static const String routeName =
      '/gpx/pv_apj20/circulation_routiere/alcool/prelevement_sanguin';

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
    final Color cardMat = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardProc = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardNota = isDark
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
            "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/prelevement_sanguin_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          "Alcool",
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
              "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/prelevement_sanguin_page.dart",
              "f00002",
              "PV — Prélèvement sanguin\nVérification de l’état alcoolique",
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Objectif
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/prelevement_sanguin_page.dart",
              "f00003",
              "Objectif du canevas",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/prelevement_sanguin_page.dart",
                      "f00004",
                      "Ce canevas guide la rédaction d’un procès-verbal de prélèvement sanguin destiné à établir la preuve ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/prelevement_sanguin_page.dart",
                      "f00005",
                      "de l’état alcoolique lorsque la vérification par éthylomètre est impossible (ex : ivresse manifeste, état de santé, impossibilité technique).\n\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/prelevement_sanguin_page.dart",
                      "f00006",
                      "Le prélèvement est réalisé par un praticien requis, avec scellés, fiches réglementaires et transmission au service compétent.",
                    ),
              ),
              SizedBox(height: 10),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/prelevement_sanguin_page.dart",
                  "f00007",
                  "Toujours préciser : lieu exact (service / hôpital), assistants, instructions O.P.J.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/prelevement_sanguin_page.dart",
                  "f00008",
                  "Toujours tracer : réquisition, matériel remis, fiches A + B/C, scellés, transmission.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/prelevement_sanguin_page.dart",
                  "f00009",
                  "Toujours assurer la concordance des informations (faits / comportement / examen).",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Cadre juridique en haut (avec articles en rouge)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/prelevement_sanguin_page.dart",
              "f00010",
              "I — Cadre juridique (fondement)",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/prelevement_sanguin_page.dart",
                    "f00011",
                    "Les vérifications destinées à établir la preuve de l’état alcoolique peuvent être faites au moyen d’analyses et examens médicaux, cliniques et biologiques : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/prelevement_sanguin_page.dart",
                    "f00012",
                    "articles L. 234-3 et suivants du Code de la route",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " et "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/prelevement_sanguin_page.dart",
                    "f00013",
                    "articles R. 3354-1 et suivants du Code de la santé publique",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/prelevement_sanguin_page.dart",
                      "f00014",
                      "En pratique, l’A.P.J. recourt au prélèvement sanguin lorsque le conducteur (ou l’accompagnateur de l’élève conducteur) ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/prelevement_sanguin_page.dart",
                      "f00015",
                      "se trouve dans un état rendant impossible l’exécution des vérifications par éthylomètre (ex : ivresse manifeste).",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Image CANVA
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/prelevement_sanguin_page.dart",
              "f00016",
              "Canevas (visuel)",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              ZoomableAssetImage(
                assetPath: 'assets/images/prelevement_sanguin.png',
              ),
            ],
          ),

          const SizedBox(height: 14),

          // 3 blocs pédagogiques “incontournables”
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/prelevement_sanguin_page.dart",
              "f00017",
              "Les 3 points indispensables",
            ),
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/prelevement_sanguin_page.dart",
                  "f00018",
                  "1) Réquisition régulière",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/prelevement_sanguin_page.dart",
                  "f00019",
                  "Remettre au praticien une réquisition aux fins d’examen clinique médical et de prélèvement sanguin.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/prelevement_sanguin_page.dart",
                  "f00020",
                  "La réquisition doit être visée et annexée (copie conservée au dossier).",
                ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/prelevement_sanguin_page.dart",
                  "f00021",
                  "2) Chaîne de conservation (scellés)",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/prelevement_sanguin_page.dart",
                  "f00022",
                  "Deux tubes étiquetés, placés dans deux contenants identifiés et scellés par l’A.P.J. présent.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/prelevement_sanguin_page.dart",
                  "f00023",
                  "Traçabilité complète : qui scelle, quand, où, et à qui les échantillons sont transmis.",
                ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/prelevement_sanguin_page.dart",
                  "f00024",
                  "3) Concordance des fiches",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/prelevement_sanguin_page.dart",
                  "f00025",
                  "Fiche A (comportement) renseignée par l’A.P.J. ; examen clinique par le médecin ; analyse par le laboratoire/biologiste.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/prelevement_sanguin_page.dart",
                  "f00026",
                  "Vérifier la cohérence : faits reprochés ↔ résumé comportemental ↔ constatations médicales.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Déroulé PV
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/prelevement_sanguin_page.dart",
              "f00027",
              "II — Déroulé chronologique (rédaction du PV)",
            ),
            cardColor: cardProc,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/prelevement_sanguin_page.dart",
                  "f00028",
                  "1 — Lieu de vérification",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/prelevement_sanguin_page.dart",
                  "f00029",
                  "Mentionner l’endroit exact où se situe l’équipage et où se déroule l’acte : service, centre hospitalier, unité d’accueil, etc.",
                ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/prelevement_sanguin_page.dart",
                  "f00030",
                  "2 — Instructions (flagrance)",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/prelevement_sanguin_page.dart",
                  "f00031",
                  "En flagrant délit, l’agent de police judiciaire agit conformément aux instructions reçues de l’officier de police judiciaire.",
                ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/prelevement_sanguin_page.dart",
                  "f00032",
                  "3 — Assistants",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/prelevement_sanguin_page.dart",
                  "f00033",
                  "Mentionner les fonctionnaires qui t’accompagnent pour l’accomplissement de la mission.",
                ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/prelevement_sanguin_page.dart",
                  "f00034",
                  "4 — Cadre juridique (rappel)",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/prelevement_sanguin_page.dart",
                    "f00035",
                    "Base légale : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/prelevement_sanguin_page.dart",
                    "f00036",
                    "L. 234-3 et s. du Code de la route",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " et "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/prelevement_sanguin_page.dart",
                    "f00037",
                    "R. 3354-1 et s. du Code de la santé publique",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/prelevement_sanguin_page.dart",
                  "f00038",
                  "5 — Visa de la réquisition",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/prelevement_sanguin_page.dart",
                    "f00039",
                    "Remettre au médecin (ou interne / étudiant en médecine autorisé / infirmier habilité) une réquisition aux fins d’examen clinique médical et de prélèvement sanguin : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/prelevement_sanguin_page.dart",
                    "f00040",
                    "article R. 3354-5 du Code de la santé publique",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/prelevement_sanguin_page.dart",
                  "f00041",
                  "6 — Mise à disposition du matériel",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/prelevement_sanguin_page.dart",
                  "f00042",
                  "Fournir au praticien requis le matériel nécessaire, comprenant notamment :",
                ),
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/prelevement_sanguin_page.dart",
                  "f00043",
                  "Tampon de stérilisation sans alcool.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/prelevement_sanguin_page.dart",
                  "f00044",
                  "Deux tubes de prélèvement sous vide (10 ml) avec héparinate de lithium + étiquettes.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/prelevement_sanguin_page.dart",
                  "f00045",
                  "Aiguille à prélèvement sous vide avec adaptateur adéquat.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/prelevement_sanguin_page.dart",
                  "f00046",
                  "Deux contenants permettant l’apposition d’un scellé et la protection des tubes.",
                ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/prelevement_sanguin_page.dart",
                  "f00047",
                  "7 — Fiches réglementaires (A / B-C)",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/prelevement_sanguin_page.dart",
                    "f00048",
                    "Renseigner la fiche d’examen de comportement dite « fiche A » : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/prelevement_sanguin_page.dart",
                    "f00049",
                    "article R. 3354-4 du Code de la santé publique",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _NotaBox(
                title: "Concordance",
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/prelevement_sanguin_page.dart",
                          "f00050",
                          "Vérifier la cohérence des rubriques : par exemple, si « Nature des faits : conduite en état d’ivresse », ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/prelevement_sanguin_page.dart",
                          "f00051",
                          "alors la synthèse comportementale doit être compatible (ex : « l’intéressé semble en état d’ivresse »).",
                        ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/prelevement_sanguin_page.dart",
                      "f00052",
                      "Le médecin consigne les résultats de l’examen clinique médical sur la partie B de la fiche B-C ; ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/prelevement_sanguin_page.dart",
                      "f00053",
                      "le laboratoire (ou le biologiste expert) consigne les résultats de l’analyse sur la partie C.",
                    ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/prelevement_sanguin_page.dart",
                  "f00054",
                  "8 — Prélèvement sanguin (scellés)",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/prelevement_sanguin_page.dart",
                      "f00055",
                      "L’A.P.J. assiste au prélèvement. Le prélèvement est réparti entre deux tubes étiquetés. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/prelevement_sanguin_page.dart",
                      "f00056",
                      "Chaque tube est placé dans un contenant identifié et scellé par l’A.P.J. ayant assisté à l’opération.",
                    ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/prelevement_sanguin_page.dart",
                  "f00057",
                  "9 — Retour au service",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/prelevement_sanguin_page.dart",
                  "f00058",
                  "Mentionner le retour au service et la mise en sécurité des scellés, en attente de transmission selon la procédure.",
                ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/prelevement_sanguin_page.dart",
                  "f00059",
                  "10 — Énonciation terminale (clôture)",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/prelevement_sanguin_page.dart",
                  "f00060",
                  "Clôturer le procès-verbal (lecture, mentions utiles, signature si possible, ou mention des difficultés / refus).",
                ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/prelevement_sanguin_page.dart",
                  "f00061",
                  "11 — Compte-rendu O.P.J.",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/prelevement_sanguin_page.dart",
                  "f00062",
                  "Effectuer un compte-rendu verbal à l’O.P.J. Mentionner les instructions éventuellement données.",
                ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/prelevement_sanguin_page.dart",
                  "f00063",
                  "12 — Mention de police (transmission)",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/prelevement_sanguin_page.dart",
                      "f00064",
                      "Transmettre les échantillons scellés ainsi que les fiches A et B-C à l’officier (ou l’agent) ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/prelevement_sanguin_page.dart",
                      "f00065",
                      "chargé d’établir la réquisition au laboratoire ou à l’expert (selon le service d’affectation).",
                    ),
              ),
              SizedBox(height: 10),

              _SubTitle("Annexe"),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/prelevement_sanguin_page.dart",
                  "f00066",
                  "Annexer : copie de la réquisition remise au praticien requis.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/prelevement_sanguin_page.dart",
              "f00067",
              "III — Check-list express (avant de clôturer)",
            ),
            cardColor: cardNota,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/prelevement_sanguin_page.dart",
                  "f00068",
                  "Lieu exact (service / hôpital) bien indiqué.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/prelevement_sanguin_page.dart",
                  "f00069",
                  "Assistants + instructions O.P.J. mentionnés.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/prelevement_sanguin_page.dart",
                  "f00070",
                  "Réquisition remise + copie en annexe.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/prelevement_sanguin_page.dart",
                  "f00071",
                  "Matériel fourni listé (tampon sans alcool, 2 tubes, etc.).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/prelevement_sanguin_page.dart",
                  "f00072",
                  "Fiche A renseignée + cohérence des rubriques.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/prelevement_sanguin_page.dart",
                  "f00073",
                  "Partie B (médecin) + partie C (labo/biologiste) tracées.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/prelevement_sanguin_page.dart",
                  "f00074",
                  "Deux contenants identifiés + scellés posés par l’A.P.J.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/prelevement_sanguin_page.dart",
                  "f00075",
                  "Transmission des scellés + fiches A/B-C tracée.",
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

// Les class suivantes doivent être utilisées dans ta page si je dois affiché une image de caneva : (UNIQUMENT POUR AFFICHER UNE IMAGE CANVA)

class ZoomableAssetImage extends StatelessWidget {
  const ZoomableAssetImage({
    super.key,
    required this.assetPath,
    this.heroTag,
    this.borderRadius = 16,
    this.backgroundColor,
    this.minScale = 1.0,
    this.maxScale = 4.0,
    this.enableHero = true,
  });

  final String assetPath;

  /// Si tu veux un Hero stable : passe un tag unique.
  /// Sinon, par défaut on utilise assetPath.
  final Object? heroTag;

  final double borderRadius;
  final Color? backgroundColor;

  final double minScale;
  final double maxScale;

  final bool enableHero;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color cardBg =
        backgroundColor ??
        (isDark ? const Color(0xFF1E1E1E) : const Color(0xFFFFFFFF));

    final Color border = isDark
        ? Colors.white.withValues(alpha: .10)
        : Colors.black.withValues(alpha: .08);

    final Color shadow = Colors.black.withValues(alpha: isDark ? .28 : .12);

    final tag = heroTag ?? assetPath;

    Widget image = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Image.asset(
        assetPath,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.high,
      ),
    );

    if (enableHero) {
      image = Hero(tag: tag, child: image);
    }

    return Semantics(
      label: ScolariteText.value(
        "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/prelevement_sanguin_page.dart",
        "f00077",
        "Image zoomable",
      ),
      hint: ScolariteText.value(
        "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/prelevement_sanguin_page.dart",
        "f00078",
        "Touchez pour ouvrir, pincez pour zoomer, glissez pour déplacer",
      ),
      button: true,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: () => _openViewer(context, tag),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(color: border, width: 1),
              boxShadow: [
                BoxShadow(
                  color: shadow,
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Stack(
              children: [
                Center(child: image),
                Positioned(
                  top: 8,
                  right: 8,
                  child: _Badge(
                    isDark: isDark,
                    text: "Zoom",
                    icon: Icons.zoom_in_rounded,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openViewer(BuildContext context, Object tag) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        transitionDuration: const Duration(milliseconds: 220),
        reverseTransitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (_, __, ___) => _ZoomableImageViewer(
          assetPath: assetPath,
          heroTag: enableHero ? tag : null,
          minScale: minScale,
          maxScale: maxScale,
        ),
        transitionsBuilder: (_, animation, __, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
            reverseCurve: Curves.easeInCubic,
          );
          return FadeTransition(opacity: curved, child: child);
        },
      ),
    );
  }
}

class _ZoomableImageViewer extends StatelessWidget {
  const _ZoomableImageViewer({
    required this.assetPath,
    required this.heroTag,
    required this.minScale,
    required this.maxScale,
  });

  final String assetPath;
  final Object? heroTag;

  final double minScale;
  final double maxScale;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color scrim = isDark
        ? Colors.black.withValues(alpha: .92)
        : Colors.black.withValues(alpha: .86);

    Widget image = Image.asset(
      assetPath,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
    );

    if (heroTag != null) {
      image = Hero(tag: heroTag!, child: image);
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.of(context).maybePop(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            // Fond sombre
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              color: scrim,
            ),

            // Image zoom/pan
            SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 6),
                  _TopBar(
                    onClose: () => Navigator.of(context).maybePop(),
                    isDark: isDark,
                  ),
                  const SizedBox(height: 6),
                  Expanded(
                    child: Center(
                      child: InteractiveViewer(
                        panEnabled: true,
                        scaleEnabled: true,
                        minScale: minScale,
                        maxScale: maxScale,
                        clipBehavior: Clip.none,
                        child: image,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _HintBar(isDark: isDark),
                  const SizedBox(height: 14),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.onClose, required this.isDark});

  final VoidCallback onClose;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final Color fg = Colors.white.withValues(alpha: .95);
    final Color bg = isDark
        ? Colors.white.withValues(alpha: .10)
        : Colors.white.withValues(alpha: .12);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          _Pill(
            bg: bg,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.touch_app_rounded, size: 18, color: fg),
                const SizedBox(width: 8),
                Text(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/prelevement_sanguin_page.dart",
                    "f00079",
                    "Aperçu",
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: fg,
                    fontSize: 13.5,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Material(
            color: bg,
            borderRadius: BorderRadius.circular(999),
            child: InkWell(
              borderRadius: BorderRadius.circular(999),
              onTap: onClose,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.close_rounded, size: 18, color: fg),
                    const SizedBox(width: 6),
                    Text(
                      "Fermer",
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: fg,
                        fontSize: 13.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HintBar extends StatelessWidget {
  const _HintBar({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final Color fg = Colors.white.withValues(alpha: .92);
    final Color bg = isDark
        ? Colors.white.withValues(alpha: .10)
        : Colors.white.withValues(alpha: .12);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: _Pill(
        bg: bg,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.pinch_rounded, size: 18, color: fg),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/prelevement_sanguin_page.dart",
                  "f00080",
                  "Pincez pour zoomer • Glissez pour déplacer • Tapez pour fermer",
                ),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: fg,
                  fontWeight: FontWeight.w700,
                  fontSize: 12.8,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.isDark, required this.text, required this.icon});

  final bool isDark;
  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final Color bg = isDark
        ? Colors.white.withValues(alpha: .12)
        : Colors.black.withValues(alpha: .06);
    final Color fg = isDark
        ? Colors.white
        : Colors.black.withValues(alpha: .78);

    return _Pill(
      bg: bg,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: fg),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 12.5,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.bg, required this.child});

  final Color bg;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: Colors.white.withValues(alpha: .12),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: child,
    );
  }
}
