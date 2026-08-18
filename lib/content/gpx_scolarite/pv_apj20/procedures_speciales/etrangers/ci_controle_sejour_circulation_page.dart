import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class CIControleSejourCirculationPage extends StatelessWidget {
  const CIControleSejourCirculationPage({super.key});

  static const String routeName =
      '/gpx/pv_apj20/procedures_speciales/etrangers/ci_controle_sejour_circulation';

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
    final Color cardCanevas = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
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
            "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/ci_controle_sejour_circulation_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/ci_controle_sejour_circulation_page.dart",
            "f00002",
            "Procès-verbal",
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
              "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/ci_controle_sejour_circulation_page.dart",
              "f00003",
              "Contrôle d’identité + contrôle du séjour et de la circulation (étranger)",
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // ✅ Base légale EN HAUT (comme demandé)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/ci_controle_sejour_circulation_page.dart",
              "f00004",
              "Base légale (à viser en tête d’acte)",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/ci_controle_sejour_circulation_page.dart",
                    "f00005",
                    "Contrôle d’identité : ",
                  ),
                ),
                law(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/ci_controle_sejour_circulation_page.dart",
                    "f00006",
                    "article 78-2 du Code de procédure pénale",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/ci_controle_sejour_circulation_page.dart",
                    "f00007",
                    " (ou ",
                  ),
                ),
                law(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/ci_controle_sejour_circulation_page.dart",
                    "f00008",
                    "article 78-2-1 du Code de procédure pénale",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/ci_controle_sejour_circulation_page.dart",
                    "f00009",
                    " selon le cadre).",
                  ),
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/ci_controle_sejour_circulation_page.dart",
                    "f00010",
                    "Contrôle de la régularité de circulation et de séjour à la suite d’un contrôle d’identité : ",
                  ),
                ),
                law(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/ci_controle_sejour_circulation_page.dart",
                    "f00011",
                    "article L. 812-2 (2°) du CESEDA",
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/ci_controle_sejour_circulation_page.dart",
                  "f00012",
                  "NULLITÉ",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/ci_controle_sejour_circulation_page.dart",
                      "f00013",
                      "La formule « sur l’ordre et sous la responsabilité d’un OPJ » doit figurer au PV lors de l’action APJ.",
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Aperçu Canva (recto/verso)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/ci_controle_sejour_circulation_page.dart",
              "f00014",
              "Modèle (Canva) — recto / verso",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              ZoomableAssetImage(
                assetPath:
                    'assets/images/ci_controle_sejour_circulation_recto.png',
                heroTag: 'ci_cs_recto',
              ),
              SizedBox(height: 12),
              ZoomableAssetImage(
                assetPath:
                    'assets/images/ci_controle_sejour_circulation_verso.png',
                heroTag: 'ci_cs_verso',
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Canevas PV — déroulé
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/ci_controle_sejour_circulation_page.dart",
              "f00015",
              "Canevas PV — déroulé opérationnel (1 → 19)",
            ),
            cardColor: cardCanevas,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/ci_controle_sejour_circulation_page.dart",
                  "f00016",
                  "1) Lieu de saisine",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/ci_controle_sejour_circulation_page.dart",
                  "f00017",
                  "Mentionner l’endroit exact où se situe l’équipage (adresse précise / point remarquable).",
                ),
              ),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/ci_controle_sejour_circulation_page.dart",
                  "f00018",
                  "2) Instructions (patrouille / saisine)",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/ci_controle_sejour_circulation_page.dart",
                  "f00019",
                  "En patrouille : agir conformément aux instructions permanentes du chef de service.",
                ),
              ),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/ci_controle_sejour_circulation_page.dart",
                  "f00020",
                  "3) Assistants",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/ci_controle_sejour_circulation_page.dart",
                  "f00021",
                  "Nommer les fonctionnaires accompagnants + préciser la tenue (uniforme / tenue bourgeoise / brassard).",
                ),
              ),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/ci_controle_sejour_circulation_page.dart",
                  "f00022",
                  "4) Mission",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/ci_controle_sejour_circulation_page.dart",
                  "f00023",
                  "Indiquer clairement le but initial de la mission (présence dissuasive, contrôle ciblé, sécurisation, etc.).",
                ),
              ),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/ci_controle_sejour_circulation_page.dart",
                  "f00024",
                  "5) Constatations (justifier le contrôle d’identité)",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/ci_controle_sejour_circulation_page.dart",
                  "f00025",
                  "Relater les faits observés de façon précise et factuelle, en faisant ressortir les éléments qui justifient le contrôle, puis indiquer le cadre retenu.",
                ),
              ),
              const SizedBox(height: 8),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/ci_controle_sejour_circulation_page.dart",
                  "f00026",
                  "CADRES POSSIBLES",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/ci_controle_sejour_circulation_page.dart",
                      "f00027",
                      "Selon la situation, viser notamment :\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/ci_controle_sejour_circulation_page.dart",
                      "f00028",
                      "• raisons plausibles de soupçonner — ",
                    ),
                  ),
                  law(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/ci_controle_sejour_circulation_page.dart",
                      "f00029",
                      "art. 78-2 al. 2 à 6 du CPP",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/ci_controle_sejour_circulation_page.dart",
                      "f00030",
                      "\n• réquisition procureur — ",
                    ),
                  ),
                  law(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/ci_controle_sejour_circulation_page.dart",
                      "f00031",
                      "art. 78-2 al. 7 du CPP",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/ci_controle_sejour_circulation_page.dart",
                      "f00032",
                      "\n• prévention atteinte à l’ordre public — ",
                    ),
                  ),
                  law(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/ci_controle_sejour_circulation_page.dart",
                      "f00033",
                      "art. 78-2 al. 8 du CPP",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/ci_controle_sejour_circulation_page.dart",
                      "f00034",
                      "\n• zone frontalière — ",
                    ),
                  ),
                  law(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/ci_controle_sejour_circulation_page.dart",
                      "f00035",
                      "art. 78-2 al. 9 du CPP",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/ci_controle_sejour_circulation_page.dart",
                      "f00036",
                      "\n• locaux professionnels (réquisition) — ",
                    ),
                  ),
                  law(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/ci_controle_sejour_circulation_page.dart",
                      "f00037",
                      "art. 78-2-1 du CPP",
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/ci_controle_sejour_circulation_page.dart",
                  "f00038",
                  "6) Formule impérative APJ",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/ci_controle_sejour_circulation_page.dart",
                  "f00039",
                  "Inscrire : « Sur l’ordre et sous la responsabilité d’un OPJ » (sinon risque de nullité).",
                ),
              ),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/ci_controle_sejour_circulation_page.dart",
                  "f00040",
                  "7) Visa CPP du contrôle d’identité",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/ci_controle_sejour_circulation_page.dart",
                  "f00041",
                  "Faire référence à l’alinéa exact de l’article 78-2 CPP (ou 78-2-1 CPP) correspondant aux constatations.",
                ),
              ),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/ci_controle_sejour_circulation_page.dart",
                  "f00042",
                  "8) Contrôle (heure + lieu)",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/ci_controle_sejour_circulation_page.dart",
                  "f00043",
                  "L’heure est fondamentale (début d’une éventuelle retenue séjour) + lieu exact mentionné.",
                ),
              ),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/ci_controle_sejour_circulation_page.dart",
                  "f00044",
                  "9) Résultat du contrôle / qualité d’étranger",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/ci_controle_sejour_circulation_page.dart",
                  "f00045",
                  "Identifier la personne au style indirect : état civil + adresse uniquement (pas de situation familiale/pro).",
                ),
              ),
              const SizedBox(height: 6),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/ci_controle_sejour_circulation_page.dart",
                  "f00046",
                  "EXTRANÉITÉ",
                ),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/ci_controle_sejour_circulation_page.dart",
                          "f00047",
                          "Élément objectif déduit de circonstances extérieures : déclaration verbale, passeport étranger présenté, etc. ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/ci_controle_sejour_circulation_page.dart",
                          "f00048",
                          "Ne suffit pas : être né hors de France ou nom à consonance étrangère.",
                        ),
                  ),
                ],
              ),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/ci_controle_sejour_circulation_page.dart",
                  "f00049",
                  "10) Visa CESEDA",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/ci_controle_sejour_circulation_page.dart",
                    "f00050",
                    "Viser : ",
                  ),
                ),
                law(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/ci_controle_sejour_circulation_page.dart",
                    "f00051",
                    "article L. 812-2 (2°) du CESEDA",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/ci_controle_sejour_circulation_page.dart",
                    "f00052",
                    " relatif au contrôle de régularité de circulation/séjour après contrôle d’identité.",
                  ),
                ),
              ]),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/ci_controle_sejour_circulation_page.dart",
                  "f00053",
                  "11) Contrôle du séjour et de circulation",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/ci_controle_sejour_circulation_page.dart",
                  "f00054",
                  "Contrôler les pièces/documents autorisant la circulation et le séjour sur le territoire français.",
                ),
              ),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/ci_controle_sejour_circulation_page.dart",
                  "f00055",
                  "12) Interrogation AGDREF2",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/ci_controle_sejour_circulation_page.dart",
                      "f00056",
                      "Rappeler l’objet : données liées aux titres de séjour, mesures d’éloignement, conditions d’entrée Schengen, etc. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/ci_controle_sejour_circulation_page.dart",
                      "f00057",
                      "Préciser que l’interrogation se fait via l’état civil ou le numéro du titre présenté.",
                    ),
              ),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/ci_controle_sejour_circulation_page.dart",
                  "f00058",
                  "13) Palpation de sécurité",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/ci_controle_sejour_circulation_page.dart",
                  "f00059",
                  "Jamais systématique : uniquement si circonstances (temps/lieux) et nécessité (objet dangereux).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/ci_controle_sejour_circulation_page.dart",
                  "f00060",
                  "Peut être réalisée avant le point 9 selon le comportement/attitude de l’individu.",
                ),
              ),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/ci_controle_sejour_circulation_page.dart",
                  "f00061",
                  "14) Avis OPJ",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/ci_controle_sejour_circulation_page.dart",
                  "f00062",
                  "Mentionner les instructions reçues de l’OPJ (contenu + moment).",
                ),
              ),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/ci_controle_sejour_circulation_page.dart",
                  "f00063",
                  "15) Retour au service",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/ci_controle_sejour_circulation_page.dart",
                  "f00064",
                  "Mentionner que l’intéressé accompagne de plein gré ; en cas de refus, transport possible, tout usage de la force doit être circonstancié et proportionné.",
                ),
              ),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/ci_controle_sejour_circulation_page.dart",
                  "f00065",
                  "16) Énonciation terminale / signature",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/ci_controle_sejour_circulation_page.dart",
                  "f00066",
                  "Style direct : la personne signe. Style indirect : pas de signature. Heure de clôture facultative (selon modèle).",
                ),
              ),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/ci_controle_sejour_circulation_page.dart",
                  "f00067",
                  "17) Présentation à l’OPJ",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/ci_controle_sejour_circulation_page.dart",
                  "f00068",
                  "Préciser l’heure + compte-rendu verbal + mentionner les instructions éventuellement données.",
                ),
              ),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/ci_controle_sejour_circulation_page.dart",
                  "f00069",
                  "18) Mention FPR",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/ci_controle_sejour_circulation_page.dart",
                  "f00070",
                  "Indiquer que les recherches administratives au FPR ont été effectuées (et résultat).",
                ),
              ),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/ci_controle_sejour_circulation_page.dart",
                  "f00071",
                  "19) Annexe",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/ci_controle_sejour_circulation_page.dart",
                  "f00072",
                  "Annexer la copie de la réquisition du procureur si le contrôle est fondé sur réquisitions.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Mémo rapide (pédago + visuel)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/ci_controle_sejour_circulation_page.dart",
              "f00073",
              "Mémo rapide (ce qui fait souvent tomber un PV)",
            ),
            cardColor: cardVigi,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/ci_controle_sejour_circulation_page.dart",
                  "f00074",
                  "Oublier la formule « sur l’ordre et sous la responsabilité d’un OPJ » (risque nullité).",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/ci_controle_sejour_circulation_page.dart",
                  "f00075",
                  "Ne pas préciser l’alinéa exact de l’article 78-2 CPP / ou 78-2-1 CPP.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/ci_controle_sejour_circulation_page.dart",
                  "f00076",
                  "Motifs d’extranéité non objectifs (ou discriminatoires) : interdit.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/ci_controle_sejour_circulation_page.dart",
                  "f00077",
                  "Heure de début du contrôle absente alors qu’elle conditionne la retenue séjour.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/ci_controle_sejour_circulation_page.dart",
                  "f00078",
                  "Signature incohérente avec le style d’écriture : direct = signe / indirect = ne signe pas.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),
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
        "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/ci_controle_sejour_circulation_page.dart",
        "f00080",
        "Image zoomable",
      ),
      hint: ScolariteText.value(
        "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/ci_controle_sejour_circulation_page.dart",
        "f00081",
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
                    "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/ci_controle_sejour_circulation_page.dart",
                    "f00082",
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
                  "lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/ci_controle_sejour_circulation_page.dart",
                  "f00083",
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
