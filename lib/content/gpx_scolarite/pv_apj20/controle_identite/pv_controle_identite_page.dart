import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PvControleIdentitePage extends StatelessWidget {
  const PvControleIdentitePage({super.key});

  static const String routeName =
      '/gpx/pv_apj20/controle_identite/pv_controle_identite';

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
    final Color cardOp = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardProc = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardPoints = isDark
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
            "lib/content/gpx_scolarite/pv_apj20/controle_identite/pv_controle_identite_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/pv_apj20/controle_identite/pv_controle_identite_page.dart",
            "f00002",
            "PV — Contrôle & vérification d’identité",
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
              "lib/content/gpx_scolarite/pv_apj20/controle_identite/pv_controle_identite_page.dart",
              "f00003",
              "Canevas de procès-verbal de contrôle d’identité\nsuivi d’une vérification d’identité",
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // ✅ Élément légal en haut
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/controle_identite/pv_controle_identite_page.dart",
              "f00004",
              "Base légale (à viser dans le PV)",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/controle_identite/pv_controle_identite_page.dart",
                    "f00005",
                    "Contrôle d’identité : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/controle_identite/pv_controle_identite_page.dart",
                    "f00006",
                    "art. 78-2 du C.P.P.",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/controle_identite/pv_controle_identite_page.dart",
                    "f00007",
                    " (selon l’alinéa correspondant aux constatations) ou ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/controle_identite/pv_controle_identite_page.dart",
                    "f00008",
                    "art. 78-2-1 du C.P.P.",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/controle_identite/pv_controle_identite_page.dart",
                    "f00009",
                    " (locaux à usage professionnel).",
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/controle_identite/pv_controle_identite_page.dart",
                    "f00010",
                    "Vérification d’identité : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/controle_identite/pv_controle_identite_page.dart",
                    "f00011",
                    "art. 78-3 du C.P.P.",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/controle_identite/pv_controle_identite_page.dart",
                    "f00012",
                    " (si la personne ne justifie pas ou refuse de décliner son identité).",
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/pv_apj20/controle_identite/pv_controle_identite_page.dart",
                          "f00013",
                          "Formule obligatoire : l’A.P.J agit « sur l’ordre et sous la responsabilité » d’un O.P.J. ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/pv_apj20/controle_identite/pv_controle_identite_page.dart",
                          "f00014",
                          "Elle doit figurer au PV, sous peine de nullité.",
                        ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Images PV (recto/verso) avec plein écran + zoom
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/controle_identite/pv_controle_identite_page.dart",
              "f00015",
              "Modèles Canva (recto / verso)",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/controle_identite/pv_controle_identite_page.dart",
                  "f00016",
                  "Appuie sur une image pour l’ouvrir en plein écran et zoomer.",
                ),
              ),
              SizedBox(height: 12),
              _ZoomableImageTile(
                assetPath: 'assets/images/pv_canva_ci_recto.png',
                heroTag: 'pv_ci_recto',
                label: 'Recto',
              ),
              SizedBox(height: 10),
              _ZoomableImageTile(
                assetPath: 'assets/images/pv_canva_ci_verso.png',
                heroTag: 'pv_ci_verso',
                label: 'Verso',
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Lieu de saisine / instructions / assistants / mission
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/controle_identite/pv_controle_identite_page.dart",
              "f00017",
              "1 → 4 — Saisine, instructions, assistants, mission",
            ),
            cardColor: cardOp,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/controle_identite/pv_controle_identite_page.dart",
                  "f00018",
                  "1) Lieu de saisine",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/controle_identite/pv_controle_identite_page.dart",
                  "f00019",
                  "Mentionner l’endroit exact où se situe l’équipage (adresse, secteur, repère utile).",
                ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/controle_identite/pv_controle_identite_page.dart",
                  "f00020",
                  "2) Instructions",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/controle_identite/pv_controle_identite_page.dart",
                  "f00021",
                  "PV de saisine : l’équipage en patrouille agit conformément aux instructions permanentes du chef de service.",
                ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/controle_identite/pv_controle_identite_page.dart",
                  "f00022",
                  "3) Assistants",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/controle_identite/pv_controle_identite_page.dart",
                  "f00023",
                  "Mentionner les fonctionnaires accompagnants (nom/grade/service).",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/controle_identite/pv_controle_identite_page.dart",
                  "f00024",
                  "Préciser la tenue : uniforme, tenue bourgeoise, port du brassard police.",
                ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/controle_identite/pv_controle_identite_page.dart",
                  "f00025",
                  "4) Mission",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/controle_identite/pv_controle_identite_page.dart",
                  "f00026",
                  "Indiquer le but de la mission initiale (patrouille, sécurisation, présence dissuasive, réquisition…).",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Constatations + cadres possibles
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/controle_identite/pv_controle_identite_page.dart",
              "f00027",
              "5 — Constatations (justifier le contrôle)",
            ),
            cardColor: cardProc,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/controle_identite/pv_controle_identite_page.dart",
                      "f00028",
                      "Relater de manière précise les faits observés en faisant ressortir les éléments ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/controle_identite/pv_controle_identite_page.dart",
                      "f00029",
                      "objectifs qui justifient le contrôle d’identité.",
                    ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/controle_identite/pv_controle_identite_page.dart",
                  "f00030",
                  "Cadres possibles à mentionner",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/controle_identite/pv_controle_identite_page.dart",
                  "f00031",
                  "Raisons plausibles de soupçonner : infraction commise ou tentée — art. 78-2 al. 2 C.P.P.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/controle_identite/pv_controle_identite_page.dart",
                  "f00032",
                  "Préparation d’un crime ou d’un délit — art. 78-2 al. 3 C.P.P.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/controle_identite/pv_controle_identite_page.dart",
                  "f00033",
                  "Renseignements utiles à une enquête crime/délit — art. 78-2 al. 4 C.P.P.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/controle_identite/pv_controle_identite_page.dart",
                  "f00034",
                  "Violation d’obligations/interdictions (CJ, ARSE, peine/mesure) — art. 78-2 al. 5 C.P.P.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/controle_identite/pv_controle_identite_page.dart",
                  "f00035",
                  "Recherches ordonnées par une autorité judiciaire — art. 78-2 al. 6 C.P.P.",
                ),
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/controle_identite/pv_controle_identite_page.dart",
                  "f00036",
                  "Réquisitions du procureur (infractions, lieux, périodes) — art. 78-2 al. 7 C.P.P.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/controle_identite/pv_controle_identite_page.dart",
                  "f00037",
                  "Prévenir une atteinte à l’ordre public (menace caractérisée) — art. 78-2 al. 8 C.P.P.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/controle_identite/pv_controle_identite_page.dart",
                  "f00038",
                  "Zone frontière — art. 78-2 al. 9 à 17 C.P.P.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/controle_identite/pv_controle_identite_page.dart",
                  "f00039",
                  "Locaux professionnels (réquisitions) — art. 78-2-1 C.P.P.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Instructions / visa article
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/controle_identite/pv_controle_identite_page.dart",
              "f00040",
              "6 → 7 — Formule OPJ & visa de l’article",
            ),
            cardColor: cardPoints,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/controle_identite/pv_controle_identite_page.dart",
                  "f00041",
                  "6) Instructions (formule obligatoire)",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/controle_identite/pv_controle_identite_page.dart",
                    "f00042",
                    "Le PV doit mentionner : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/controle_identite/pv_controle_identite_page.dart",
                    "f00043",
                    "« sur l’ordre et sous la responsabilité »",
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : const Color(0xFF0D47A1),
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/controle_identite/pv_controle_identite_page.dart",
                    "f00044",
                    " d’un O.P.J. (obligatoire au PV).",
                  ),
                ),
              ]),
              const SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/controle_identite/pv_controle_identite_page.dart",
                  "f00045",
                  "7) Visa de l’article",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/controle_identite/pv_controle_identite_page.dart",
                    "f00046",
                    "Selon les constatations, viser l’alinéa adapté de ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/controle_identite/pv_controle_identite_page.dart",
                    "f00047",
                    "l’art. 78-2 du C.P.P.",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " ou "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/controle_identite/pv_controle_identite_page.dart",
                    "f00048",
                    "l’art. 78-2-1 du C.P.P.",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Contrôle / résultat / palpation / avis OPJ
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/controle_identite/pv_controle_identite_page.dart",
              "f00049",
              "8 → 11 — Contrôle, résultat, palpation, avis OPJ",
            ),
            cardColor: cardOp,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/controle_identite/pv_controle_identite_page.dart",
                  "f00050",
                  "8) Contrôle",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/controle_identite/pv_controle_identite_page.dart",
                  "f00051",
                  "Mentionner l’heure et le lieu du contrôle.",
                ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/controle_identite/pv_controle_identite_page.dart",
                  "f00052",
                  "9) Résultat du contrôle",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/controle_identite/pv_controle_identite_page.dart",
                  "f00053",
                  "Identifier la personne en style indirect : état civil et adresse (à l’exclusion des éléments de personnalité).",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/controle_identite/pv_controle_identite_page.dart",
                  "f00054",
                  "Si l’individu ne justifie pas / refuse : mentionner clairement l’impossibilité ou le refus.",
                ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/controle_identite/pv_controle_identite_page.dart",
                  "f00055",
                  "10) Palpation de sécurité",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/controle_identite/pv_controle_identite_page.dart",
                      "f00056",
                      "Elle n’est pas systématique. Elle se justifie uniquement selon les circonstances de temps/lieu ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/controle_identite/pv_controle_identite_page.dart",
                      "f00057",
                      "et la nécessité de vérifier l’absence d’objet dangereux (respect et discernement).",
                    ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/controle_identite/pv_controle_identite_page.dart",
                  "f00058",
                  "11) Avis O.P.J.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/controle_identite/pv_controle_identite_page.dart",
                  "f00059",
                  "Mentionner les instructions reçues. La mise en œuvre de la vérification d’identité relève de la responsabilité exclusive de l’O.P.J.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Retour / clôture / présentation OPJ / recherches / annexe
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/controle_identite/pv_controle_identite_page.dart",
              "f00060",
              "12 → 16 — Retour, clôture, présentation OPJ, recherches, annexe",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/controle_identite/pv_controle_identite_page.dart",
                  "f00061",
                  "12) Retour au service",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/controle_identite/pv_controle_identite_page.dart",
                  "f00062",
                  "Préciser si la personne suit de plein gré ou sous contrainte. Tout usage de la force doit être circonstancié.",
                ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/controle_identite/pv_controle_identite_page.dart",
                  "f00063",
                  "13) Énonciation terminale (clôture)",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/controle_identite/pv_controle_identite_page.dart",
                  "f00064",
                  "Si déclarations au style direct : signature de la personne. Si style indirect : pas de signature.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/controle_identite/pv_controle_identite_page.dart",
                  "f00065",
                  "L’indication de l’heure est facultative.",
                ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/controle_identite/pv_controle_identite_page.dart",
                  "f00066",
                  "14) Présentation à l’O.P.J.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/controle_identite/pv_controle_identite_page.dart",
                  "f00067",
                  "Mentionner l’heure de présentation, le compte-rendu verbal et les instructions données.",
                ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/controle_identite/pv_controle_identite_page.dart",
                  "f00068",
                  "15) Mention — recherches administratives",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/controle_identite/pv_controle_identite_page.dart",
                  "f00069",
                  "Préciser que les recherches ont été effectuées (F.P.R., T.A.J. le cas échéant) et qu’aucune recherche ne vise la personne (si c’est le résultat).",
                ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/controle_identite/pv_controle_identite_page.dart",
                  "f00070",
                  "16) Annexe",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/controle_identite/pv_controle_identite_page.dart",
                  "f00071",
                  "Annexer la copie de la réquisition du procureur justifiant le contrôle d’identité (si contrôle sur réquisitions).",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ZoomableImageTile extends StatelessWidget {
  const _ZoomableImageTile({
    required this.assetPath,
    required this.heroTag,
    required this.label,
  });

  final String assetPath;
  final String heroTag;
  final String label;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Semantics(
      button: true,
      label: 'Ouvrir l’image $label en plein écran',
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => _ZoomImageViewerPage(
                assetPath: assetPath,
                heroTag: heroTag,
                title: 'PV — $label',
              ),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: (isDark ? Colors.white70 : const Color(0xFF616161))
                  .withValues(alpha: .22),
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Hero(
                tag: heroTag,
                child: Image.asset(
                  assetPath,
                  fit: BoxFit.cover,
                  height: 180,
                  width: double.infinity,
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0),
                      Colors.black.withValues(alpha: .55),
                    ],
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.zoom_in_rounded, color: Colors.white),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        "Ouvrir en plein écran — $label",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.fustat(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 13.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ZoomImageViewerPage extends StatelessWidget {
  const _ZoomImageViewerPage({
    required this.assetPath,
    required this.heroTag,
    required this.title,
  });

  final String assetPath;
  final String heroTag;
  final String title;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? Colors.black : Colors.black;
    const Color textColor = Colors.white;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.close_rounded, color: Colors.white),
          tooltip: 'Fermer',
        ),
        title: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 16,
            color: textColor,
          ),
        ),
      ),
      body: Center(
        child: Hero(
          tag: heroTag,
          child: InteractiveViewer(
            minScale: 1.0,
            maxScale: 6.0,
            panEnabled: true,
            scaleEnabled: true,
            child: Image.asset(assetPath, fit: BoxFit.contain),
          ),
        ),
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
