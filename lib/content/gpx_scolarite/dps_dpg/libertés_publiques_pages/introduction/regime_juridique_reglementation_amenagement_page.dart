import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class RegimeJuridiqueReglementationAmenagementPage extends StatelessWidget {
  const RegimeJuridiqueReglementationAmenagementPage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette cards (propre + lisible)
    final Color cardIntro = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
    final Color cardChap1 = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardExe = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardException = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardAmenagement = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);

    final Color accentGrey = isDark ? Colors.white70 : const Color(0xFF616161);
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
            "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
            "f00002",
            "Libertés publiques",
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
              "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
              "f00003",
              "Régime juridique : réglementation et aménagement des libertés publiques",
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // ===================== INTRO =====================
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
              "f00004",
              "Idée générale",
            ),
            cardColor: cardIntro,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                      "f00005",
                      "Il n’existe pas de liberté publique « absolue » : une liberté sans limites ferait disparaître l’État ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                      "f00006",
                      "au profit de l’anarchie. Les libertés sont donc garanties, mais encadrées, pour permettre la vie en société.",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                    "f00007",
                    "La Déclaration de 1789 rappelle déjà la logique : la liberté consiste à pouvoir faire tout ce qui ne nuit pas à autrui — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                    "f00008",
                    "Art. 4 de la DDHC",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // ===================== CHAPITRE 1 : AUTORITÉS =====================
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
              "f00009",
              "Chapitre 1 — Les autorités qui réglementent les libertés",
            ),
            cardColor: cardChap1,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                  "f00010",
                  "La réglementation des libertés publiques relève principalement du législateur, et subsidiairement du pouvoir exécutif.",
                ),
              ),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                  "f00011",
                  "1.1 — Rôle du législateur (compétence de principe)",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                    "f00012",
                    "Seule la loi peut fixer des « bornes » aux libertés publiques — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                    "f00013",
                    "Art. 4 de la DDHC",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                    "f00014",
                    "La Constitution de 1958 confirme : la loi fixe les règles concernant les droits civiques et les garanties fondamentales accordées aux citoyens pour l’exercice des libertés publiques — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                    "f00015",
                    "Art. 34 de la Constitution",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                  "f00016",
                  "Ce que le législateur peut faire",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                  "f00017",
                  "Créer de nouvelles libertés (dans le respect de la hiérarchie des normes).",
                ),
              ),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                      "f00018",
                      "Exemples : ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                      "f00019",
                      "loi n° 70-643 du 17 juillet 1970 (vie privée) — art. 9 du Code civil",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: " ; "),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                      "f00020",
                      "loi n° 2024-200 du 8 mars 2024 (IVG).",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                  "f00021",
                  "Définir les modalités concrètes d’exercice (ex. droit de grève encadré par des lois).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                  "f00022",
                  "Restreindre une liberté (même constitutionnelle) pour concilier un autre objectif constitutionnel (ex. continuité du service public).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                  "f00023",
                  "Supprimer une liberté sous contrôle (ex. interdiction du droit de grève de certains fonctionnaires).",
                ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                  "f00024",
                  "Limites : remise en cause de situations existantes",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                      "f00025",
                      "Le législateur ne peut remettre en cause des situations intéressant une liberté publique que :\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                      "f00026",
                      "• si elles ont été illégalement acquises ;\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                      "f00027",
                      "• ou si cette remise en cause est réellement nécessaire pour atteindre l’objectif constitutionnel poursuivi.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ===================== POUVOIR EXÉCUTIF =====================
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
              "f00028",
              "1.2 — Rôle du pouvoir exécutif (pouvoir réglementaire)",
            ),
            cardColor: cardExe,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                      "f00029",
                      "Si la loi fixe le cadre, le pouvoir réglementaire est essentiel pour la mise en œuvre : ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                      "f00030",
                      "il complète la loi et peut aussi réglementer pour le maintien de l’ordre public.",
                    ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                  "f00031",
                  "Deux hypothèses principales",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                  "f00032",
                  "Compléter la loi (ex. le code de la route : partie réglementaire complète la partie législative).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                  "f00033",
                  "Maintien de l’ordre public (hypothèse la plus importante).",
                ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                  "f00034",
                  "Autorités compétentes",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                      "f00035",
                      "Au plan national : Président de la République / Premier ministre.\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                      "f00036",
                      "Au plan local : préfet, maire, président du conseil départemental (selon compétences).",
                    ),
              ),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                  "f00037",
                  "Période normale : règles de contrôle",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                  "f00038",
                  "Interdiction générale et absolue d’une liberté : impossible.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                  "f00039",
                  "Une interdiction temporaire n’est légale que si elle est indispensable au maintien de l’ordre public.",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                      "f00040",
                      "Jurisprudence : ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                      "f00041",
                      "C.E., 19 mai 1933, Benjamin",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                      "f00042",
                      " — plus une liberté est fondamentale, plus le contrôle du juge est exigeant.",
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ===================== PÉRIODES EXCEPTIONNELLES =====================
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
              "f00043",
              "1.2.2 — Périodes exceptionnelles : extension des restrictions",
            ),
            cardColor: cardException,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                      "f00044",
                      "En période de troubles graves, la réglementation des libertés publiques s’intensifie. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                      "f00045",
                      "Les régimes exceptionnels élargissent les pouvoirs de police et peuvent restreindre certaines libertés.",
                    ),
              ),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                  "f00046",
                  "A) État de siège",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                    "f00047",
                    "Prévu par ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                    "f00048",
                    "l’Art. 36 de la Constitution",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                    "f00049",
                    " (décrété en Conseil des ministres ; prorogation > 12 jours = Parlement).",
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                    "f00050",
                    "Conditions : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                    "f00051",
                    "art. L. 2121-1 du Code de la défense",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                    "f00052",
                    " — péril imminent résultant d’une guerre étrangère ou d’une insurrection armée.",
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                  "f00053",
                  "Conséquences : transfert de pouvoirs aux autorités militaires ; extension des pouvoirs de police (perquisitions jour/nuit, censure, contrôle correspondances…) ; réactivation des juridictions militaires.",
                ),
              ),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                  "f00054",
                  "B) Pouvoirs exceptionnels (état de crise)",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                    "f00055",
                    "Fondement : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                    "f00056",
                    "Art. 16 de la Constitution",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                    "f00057",
                    " — menace grave et immédiate + interruption du fonctionnement régulier des pouvoirs publics.",
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                  "f00058",
                  "Le Président prend les mesures exigées par les circonstances (après consultations prévues).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                  "f00059",
                  "Régime risqué pour les libertés : contrôle limité (acte de gouvernement) et durée non précisée dans la Constitution.",
                ),
              ),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                  "f00060",
                  "C) État d’urgence",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                    "f00061",
                    "Prévu par ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                    "f00062",
                    "la loi n° 55-385 du 3 avril 1955",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                    "f00063",
                    " — péril imminent (atteintes graves à l’ordre public) ou calamité publique.",
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                  "f00064",
                  "Déclaration initiale 12 jours ; prorogation par une loi fixant la durée.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                  "f00065",
                  "Permet des restrictions ciblées (assignations à résidence, perquisitions administratives, interdictions…).",
                ),
              ),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                  "f00066",
                  "D) État d’urgence sanitaire",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                    "f00067",
                    "Créé par ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                    "f00068",
                    "la loi n° 2020-290 du 23 mars 2020",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                    "f00069",
                    " pour faire face à l’épidémie de Covid-19 (mesures exceptionnelles limitant certaines libertés).",
                  ),
                ),
              ]),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                  "f00070",
                  "E) Théorie des circonstances exceptionnelles",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                      "f00071",
                      "Théorie jurisprudentielle : en situation anormale (guerre, troubles, grèves, cataclysmes, épidémies…), ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                      "f00072",
                      "le juge admet une extension des pouvoirs de police, avec des atteintes possibles aux libertés.",
                    ),
              ),
              SizedBox(height: 8),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                      "f00073",
                      "Arrêts repères : ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                      "f00074",
                      "C.E., 28 mai 1918, Heyriès",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: " ; "),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                      "f00075",
                      "C.E., 14 déc. 1943, Devaux",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: " ; "),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                      "f00076",
                      "C.E., 7 déc. 1979, Société « Les Fils de Henri Ramel »",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: " ; "),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                      "f00077",
                      "C.E., 18 mai 1983, Félix Rodes",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                  "f00078",
                  "F) Mesure intermédiaire : plan Vigipirate",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                      "f00079",
                      "Plan gouvernemental (Premier ministre) : dispositif permanent de vigilance, prévention et protection contre le terrorisme. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                      "f00080",
                      "Il s’appuie sur l’évaluation de la menace et organise une réaction coordonnée.",
                    ),
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                  "f00081",
                  "Niveaux depuis 1er décembre 2016 : Vigilance / Sécurité renforcée – risque attentat / Urgence attentat.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ===================== CHAPITRE 2 : AMÉNAGEMENT =====================
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
              "f00082",
              "Chapitre 2 — Les moyens de réglementation : l’aménagement",
            ),
            cardColor: cardAmenagement,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                      "f00083",
                      "Aménager les libertés publiques, c’est fixer des limites à leur exercice. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                      "f00084",
                      "En démocratie, deux grandes techniques existent : le régime répressif et le régime préventif.",
                    ),
              ),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                  "f00085",
                  "2.1 — Régime répressif (le plus favorable)",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                  "f00086",
                  "Principe : la liberté est la règle ; seuls les abus sont sanctionnés.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                  "f00087",
                  "Si l’abus constitue une infraction : sanction prononcée par un juge.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                  "f00088",
                  "Si le trouble à l’ordre public n’est pas une infraction : le préfet ou le maire peut interdire pour faire cesser le trouble.",
                ),
              ),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                    "f00089",
                    "Fondement : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                    "f00090",
                    "Art. 5 de la DDHC",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                    "f00091",
                    " — « tout ce qui n’est pas défendu par la loi ne peut être empêché ».",
                  ),
                ),
              ]),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                  "f00092",
                  "2.2 — Régime préventif",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                  "f00093",
                  "Objectif : éviter les abus (on agit avant, pas après).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                  "f00094",
                  "L’exercice de la liberté dépend d’une décision administrative (ordre public).",
                ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                  "f00095",
                  "2.2.1 — Autorisation préalable",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                      "f00096",
                      "Régime rigoureux : sans autorisation (ou en cas de refus), la liberté ne s’exerce pas.\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                      "f00097",
                      "Exemples : visa d’exploitation cinématographique, permis de construire, permis de conduire.",
                    ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                  "f00098",
                  "2.2.2 — Déclaration préalable",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                      "f00099",
                      "Moins attentatoire : l’exercice est soumis à une déclaration à l’administration.\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                      "f00100",
                      "Exemples : manifestations, associations, préavis de grève, déclaration au parquet pour la presse.",
                    ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                  "f00101",
                  "2.2.3 — Interdiction préalable",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                      "f00102",
                      "L’autorité administrative peut interdire :\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                      "f00103",
                      "• au titre d’une police spéciale (texte) ;\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                      "f00104",
                      "• ou au titre de la police générale (sans texte) si l’ordre public l’exige.",
                    ),
              ),
              SizedBox(height: 10),

              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                    "f00105",
                    "Police spéciale : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                    "f00106",
                    "art. L. 211-4 du CSI",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                    "f00107",
                    " (interdiction d’une manifestation si risque de trouble).",
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                    "f00108",
                    "Dissolution administrative : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                    "f00109",
                    "art. L. 212-1 du CSI",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),

              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                      "f00110",
                      "Dans les communes à police étatisée, seul le préfet est compétent pour interdire une manifestation. Référence : ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                      "f00111",
                      "C.E., 28 avril 1989, Commune de Montgeron",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),
              SizedBox(height: 10),

              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                      "f00112",
                      "Contrôle du juge : ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                      "f00113",
                      "compétence, forme, but, motivations, et examen détaillé des circonstances. Exemple majeur : ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                      "f00114",
                      "C.E., 19 mai 1933, Benjamin",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart",
                      "f00115",
                      " — l’interdiction n’est légale que si elle est l’unique moyen de maintenir l’ordre.",
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
