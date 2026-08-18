import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class RefusVerificationsGPXPage extends StatelessWidget {
  const RefusVerificationsGPXPage({super.key});

  static const String routeName =
      '/gpx/pv_apj20/circulation_routiere/alcool_stupefiants/refus_verifications';

  static const Color _lawRed = Color(0xFFE53935);

  // ⚠️ IMPORTANT : pas de copyWith sur TextSpan (sinon erreur).
  // Donc on crée nos TextSpan "loi" directement :
  TextSpan _lawSpan(String text) => TextSpan(
    text: text,
    style: const TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
  );

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette cards (propre + lisible)
    final Color cardIntro = isDark
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
    final Color cardProc = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);
    final Color cardRep = isDark
        ? const Color(0xFF202632)
        : const Color(0xFFF2F2FF);

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
            "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
            "f00002",
            "Alcool & stupéfiants",
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
              "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
              "f00003",
              "PV — Refus de se soumettre aux vérifications",
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Intro (objectif)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
              "f00004",
              "Objectif du canevas",
            ),
            cardColor: cardIntro,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                      "f00005",
                      "Ce canevas sert à structurer le procès-verbal de conduite au poste d’un individu ayant refusé ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                      "f00006",
                      "de se soumettre aux vérifications tendant à établir l’état alcoolique et/ou l’usage de stupéfiants. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                      "f00007",
                      "Il aide à rédiger de manière complète, pédagogique et juridiquement sécurisée.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Images (CANVA)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
              "f00008",
              "Canevas (visuels)",
            ),
            cardColor: cardIntro,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              ZoomableAssetImage(
                assetPath: 'assets/images/refus_verifications_recto.png',
              ),
              SizedBox(height: 12),
              ZoomableAssetImage(
                assetPath: 'assets/images/refus_verifications_verso.png',
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
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
                    "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                    "f00010",
                    "Le refus de se soumettre aux vérifications constitue un délit dès lors qu’une injonction régulière a été faite au conducteur : ",
                  ),
                ),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                      "f00011",
                      "Alcool — ",
                    ),
                  ),
                  _lawSpan(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                      "f00012",
                      "Article L. 234-8 du Code de la route",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                      "f00013",
                      " : refus de se soumettre aux vérifications tendant à établir l’état alcoolique.",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                      "f00014",
                      "Stupéfiants — ",
                    ),
                  ),
                  _lawSpan(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                      "f00015",
                      "Article L. 235-3 du Code de la route",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                      "f00016",
                      " : refus de se soumettre aux analyses ou examens en vue d’établir l’usage de stupéfiants.",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                    "f00017",
                    "Important : le refus de dépistage (souffle/salivaire) n’est pas, à lui seul, une infraction pénale ; il déclenche l’obligation de se soumettre aux vérifications : ",
                  ),
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                _lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                    "f00018",
                    "Article L. 234-4 du Code de la route",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                    "f00019",
                    " (alcool) et ",
                  ),
                ),
                _lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                    "f00020",
                    "Article L. 235-2 du Code de la route",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                    "f00021",
                    " (stupéfiants).",
                  ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Élément matériel (3 éléments)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
              "f00022",
              "II — Élément matériel",
            ),
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                  "f00023",
                  "A) Une injonction régulière de se soumettre",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                      "f00024",
                      "Le délit suppose que le conducteur ait été informé de l’obligation de se soumettre aux vérifications ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                      "f00025",
                      "et qu’une injonction claire lui ait été faite (vérifications alcool et/ou stupéfiants).",
                    ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                  "f00026",
                  "B) Un refus caractérisé et réitéré",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                      "f00027",
                      "Le refus doit être persistant et déterminé, de manière à faire apparaître la volonté délibérée ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                      "f00028",
                      "du conducteur de refuser les vérifications. La réitération de l’injonction et la réitération du refus ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                      "f00029",
                      "doivent être décrites précisément dans le PV.",
                    ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                  "f00030",
                  "C) Constatations utiles à consigner",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                      "f00031",
                      "Consigner : les propos exacts (style direct si possible), l’attitude, les circonstances de temps et de lieu, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                      "f00032",
                      "l’information donnée au conducteur, et toute mention utile permettant d’établir la réalité et la constance du refus.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Élément moral
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
              "f00033",
              "III — Élément moral",
            ),
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                      "f00034",
                      "Ces délits sont intentionnels : il faut caractériser la volonté de refuser. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                      "f00035",
                      "Le PV doit faire ressortir que le conducteur a compris la demande, a été informé des conséquences, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                      "f00036",
                      "et a néanmoins maintenu son refus.",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                      "f00037",
                      "Bon réflexe rédactionnel : noter la réitération de l’injonction + la réitération du refus pour matérialiser l’intention.",
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Procédure / canevas détaillé
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
              "f00038",
              "IV — Canevas de rédaction (plan complet)",
            ),
            cardColor: cardProc,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                  "f00039",
                  "1) Lieu de saisine",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                  "f00040",
                  "Mentionner l’endroit exact où se situe l’équipage (commune, voie, point de repère).",
                ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                  "f00041",
                  "2) Instructions",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                      "f00042",
                      "Indiquer que l’équipage, en patrouille, agit conformément aux instructions permanentes du chef de service ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                      "f00043",
                      "(ou selon les instructions reçues).",
                    ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                  "f00044",
                  "3) Assistants",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                  "f00045",
                  "Citer les fonctionnaires accompagnants et préciser la tenue (uniforme, tenue civile, port du brassard POLICE).",
                ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                  "f00046",
                  "4) Mission",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                  "f00047",
                  "Indiquer le but de la mission initiale.",
                ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                  "f00048",
                  "5) Interception du véhicule",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                      "f00049",
                      "Préciser le cadre :\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                      "f00050",
                      "• suite à la constatation d’une infraction au code de la route (relater les faits observés), ou\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                      "f00051",
                      "• suite à un contrôle routier sans infraction préalable, ou\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                      "f00052",
                      "• suite à un contrôle préventif (initiative de l’agent / réquisition du procureur de la République).",
                    ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                  "f00053",
                  "6) Contrôle",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                      "f00054",
                      "Mentionner le contrôle : pièces afférentes à la conduite et à la circulation, obligation d’assurance ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                      "f00055",
                      "(consultation du fichier des véhicules assurés), et identification en style indirect (état civil + adresse), ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                      "f00056",
                      "à l’exclusion de tout autre élément de personnalité (familial/professionnel).",
                    ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                  "f00057",
                  "7) Dépistages (alcool et stupéfiants)",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                    "f00058",
                    "Rappeler que le refus de dépistage n’est pas une infraction pénale, mais entraîne l’obligation de se soumettre aux vérifications (",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                    "f00059",
                    "Article L. 234-4 du Code de la route",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " et "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                    "f00060",
                    "Article L. 235-2 du Code de la route",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: ")."),
              ]),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                  "f00061",
                  "8) Information",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                      "f00062",
                      "En cas de refus du dépistage, préciser que le conducteur est informé que ce refus entraîne l’obligation ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                      "f00063",
                      "de procéder aux vérifications destinées à :\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                      "f00064",
                      "• établir un état alcoolique,\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                      "f00065",
                      "• rechercher et confirmer la présence d’un ou plusieurs produits stupéfiants.",
                    ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                  "f00066",
                  "9) Déclarations",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                      "f00067",
                      "Consigner les déclarations du contrevenant sur son premier refus de se soumettre aux vérifications ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                      "f00068",
                      "(style direct si possible).",
                    ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                  "f00069",
                  "10) Réitération de l’injonction",
                ),
              ),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                      "f00070",
                      "Refus alcool — ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                      "f00071",
                      "Article L. 234-8 du Code de la route",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                      "f00072",
                      " : puni de 2 ans d’emprisonnement et de 4 500 € d’amende.",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                      "f00073",
                      "Refus stupéfiants — ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                      "f00074",
                      "Article L. 235-3 du Code de la route",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                      "f00075",
                      " : puni de 2 ans d’emprisonnement et de 4 500 € d’amende.",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                  "f00076",
                  "11) Réitération du refus",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                      "f00077",
                      "Le refus doit être persistant et déterminé : il doit faire apparaître la volonté délibérée du conducteur ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                      "f00078",
                      "de refuser les vérifications. Détailler précisément.",
                    ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                  "f00079",
                  "12) Cadre juridique",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                      "f00080",
                      "Dès que les délits sont caractérisés, l’action de l’agent de police judiciaire se situe dans le cadre ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                      "f00081",
                      "du flagrant délit (à qualifier selon la situation).",
                    ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                  "f00082",
                  "13) Retour au service",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                  "f00083",
                  "Mentionner que la personne appréhendée accepte d’accompagner de son plein gré les fonctionnaires de police.",
                ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                  "f00084",
                  "14) Palpation de sécurité",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                      "f00085",
                      "Uniquement si nécessaire (temps/lieu/risque). Si découverte d’objets : situer, décrire, présenter à la personne ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                      "f00086",
                      "qui peut faire une brève déclaration sur l’appartenance (style direct) sans que cela constitue une audition. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                      "f00087",
                      "Objets appréhendés aux fins de remise à l’OPJ (D.R.D.A).",
                    ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                  "f00088",
                  "15) Compte-rendu OPJ",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                  "f00089",
                  "Compte-rendu verbal à l’OPJ. Mentionner les instructions éventuellement données.",
                ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                  "f00090",
                  "16) Énonciation terminale (clôture)",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                      "f00091",
                      "Signature : si déclarations au style direct, la personne doit signer. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                      "f00092",
                      "Si déclarations au style indirect, pas de signature. L’heure est facultative.",
                    ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                  "f00093",
                  "17) Présentation à l’OPJ",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                      "f00094",
                      "Présentation de l’individu en précisant l’heure. Compte-rendu verbal et éventuelle remise d’objets appréhendés. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                      "f00095",
                      "Mentionner les instructions reçues.",
                    ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                  "f00096",
                  "18) Mention — fichiers",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                  "f00097",
                  "Recherches administratives (FPR, SNPC). Préciser que les recherches ont été effectuées et que la personne ne fait l’objet d’aucune recherche.",
                ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                  "f00098",
                  "19) Mention — immobilisation",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                      "f00099",
                      "Il peut être procédé d’office à l’immobilisation du véhicule pendant la durée de rétention du permis de conduire. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                      "f00100",
                      "Elle est levée dès qu’un conducteur qualifié (proposé par le conducteur / l’accompagnateur de l’élève conducteur / ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                      "f00101",
                      "ou le propriétaire) peut assurer la conduite. Remettre un exemplaire de la fiche d’immobilisation.",
                    ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                  "f00102",
                  "20) Mention — avis de rétention",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                  "f00103",
                  "Remettre un exemplaire de l’avis de rétention du permis de conduire au conducteur.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Répression + tentative / complicité
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
              "f00104",
              "V — Répression, tentative & complicité",
            ),
            cardColor: cardRep,
            accent: accentIndigo,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                  "f00105",
                  "Peines principales (rappel)",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                    "f00106",
                    "Refus alcool : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                    "f00107",
                    "2 ans d’emprisonnement et 4 500 € d’amende — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                    "f00108",
                    "Article L. 234-8 du Code de la route",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                    "f00109",
                    "Refus stupéfiants : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                    "f00110",
                    "2 ans d’emprisonnement et 4 500 € d’amende — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                    "f00111",
                    "Article L. 235-3 du Code de la route",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                  "f00112",
                  "Tentative & complicité",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                  "f00113",
                  "Tentative : en pratique, le refus se consomme instantanément ; la tentative est rarement pertinente à caractériser.",
                ),
              ),
              SizedBox(height: 6),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                  "f00114",
                  "Complicité : possible en théorie, mais à apprécier au cas par cas selon l’aide ou l’assistance apportée au refus.",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                          "f00115",
                          "Conseil rédactionnel : rester factuel (paroles, injonctions, refus) et bien chronologiser. ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                          "f00116",
                          "C’est ce qui rend le PV “béton” et pédagogique.",
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
        "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
        "f00117",
        "Image zoomable",
      ),
      hint: ScolariteText.value(
        "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
        "f00118",
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
                    "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                    "f00119",
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
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart",
                  "f00120",
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
