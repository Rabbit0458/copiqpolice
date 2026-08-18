import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class RecherchesInfructueusesMandatPage extends StatelessWidget {
  const RecherchesInfructueusesMandatPage({super.key});

  static const String routeName =
      '/gpx/pv_apj20/interpellation/recherches_infructueuses_mandat';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette (propre + lisible)
    final Color cardLegal = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardGuide = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardSteps = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardCanva = isDark
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
            "lib/content/gpx_scolarite/pv_apj20/interpellation/recherches_infructueuses_mandat_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          "Interpellation",
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
              "lib/content/gpx_scolarite/pv_apj20/interpellation/recherches_infructueuses_mandat_page.dart",
              "f00002",
              "PV — Perquisition / recherches infructueuses\n(exécution d’un mandat d’amener ou d’arrêt)",
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          _ConditionCard(
            title: "Objectif",
            cardColor: cardCanva,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/interpellation/recherches_infructueuses_mandat_page.dart",
                      "f00003",
                      "Ce canevas sert à rédiger un procès-verbal lorsque, en exécution d’un mandat ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/interpellation/recherches_infructueuses_mandat_page.dart",
                      "f00004",
                      "(d’amener ou d’arrêt), la personne visée n’est pas trouvée : les recherches au domicile ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/interpellation/recherches_infructueuses_mandat_page.dart",
                      "f00005",
                      "sont réalisées, puis l’absence est constatée et la transmission au magistrat est formalisée.",
                    ),
              ),
              SizedBox(height: 10),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/interpellation/recherches_infructueuses_mandat_page.dart",
                  "f00006",
                  "But exclusif : rechercher la personne visée par le mandat (et non « perquisitionner » au sens classique).",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/interpellation/recherches_infructueuses_mandat_page.dart",
                  "f00007",
                  "Respecter strictement les heures légales d’introduction au domicile : 06h00 → 21h00.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/interpellation/recherches_infructueuses_mandat_page.dart",
                  "f00008",
                  "Mentionner l’heure précise d’arrivée, les assistants, et le déroulé de la visite.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut (cadre juridique)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/interpellation/recherches_infructueuses_mandat_page.dart",
              "f00009",
              "I — Cadre juridique",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/interpellation/recherches_infructueuses_mandat_page.dart",
                    "f00010",
                    "La « visite domiciliaire » liée au mandat ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/interpellation/recherches_infructueuses_mandat_page.dart",
                    "f00011",
                    "ne doit pas être assimilée ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/interpellation/recherches_infructueuses_mandat_page.dart",
                    "f00012",
                    "à la perquisition de l’",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/interpellation/recherches_infructueuses_mandat_page.dart",
                    "f00013",
                    "article 56 du Code de procédure pénale",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/pv_apj20/interpellation/recherches_infructueuses_mandat_page.dart",
                          "f00014",
                          "Si la personne ne peut être saisie, un PV de perquisition et de recherches infructueuses ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/pv_apj20/interpellation/recherches_infructueuses_mandat_page.dart",
                          "f00015",
                          "est adressé au magistrat qui a délivré le mandat : ",
                        ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/interpellation/recherches_infructueuses_mandat_page.dart",
                      "f00016",
                      "article 134 du Code de procédure pénale",
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

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/interpellation/recherches_infructueuses_mandat_page.dart",
              "f00017",
              "II — Structure du PV (plan pédagogique)",
            ),
            cardColor: cardGuide,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/interpellation/recherches_infructueuses_mandat_page.dart",
                  "f00018",
                  "À écrire comme un déroulé chronologique",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/interpellation/recherches_infructueuses_mandat_page.dart",
                  "f00019",
                  "Style clair, factuel, daté/horodaté (heure précise d’arrivée, déroulé, clôture).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/interpellation/recherches_infructueuses_mandat_page.dart",
                  "f00020",
                  "Identité : relever l’identité succincte de la personne présente (si quelqu’un ouvre) + préciser le support de vérification.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/interpellation/recherches_infructueuses_mandat_page.dart",
                  "f00021",
                  "Déclaration éventuelle (style indirect) : absence de la personne visée, et lieu possible où elle se trouve.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/interpellation/recherches_infructueuses_mandat_page.dart",
                  "f00022",
                  "Visite des lieux : préciser les conditions (serrurier réquisitionné si nécessaire, présence de deux témoins requis).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/interpellation/recherches_infructueuses_mandat_page.dart",
                  "f00023",
                  "Avis magistrat : informer et noter les instructions reçues.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/interpellation/recherches_infructueuses_mandat_page.dart",
                  "f00024",
                  "Clôture / transmission : mentionner la transmission du PV et la fin de mission.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/interpellation/recherches_infructueuses_mandat_page.dart",
              "f00025",
              "III — Canevas détaillé (à recopier / adapter)",
            ),
            cardColor: cardSteps,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/interpellation/recherches_infructueuses_mandat_page.dart",
                  "f00026",
                  "1) Lieu de rédaction",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/interpellation/recherches_infructueuses_mandat_page.dart",
                  "f00027",
                  "Indiquer la ville / service / date et l’heure de rédaction.",
                ),
              ),

              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/interpellation/recherches_infructueuses_mandat_page.dart",
                  "f00028",
                  "2) Instructions",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/interpellation/recherches_infructueuses_mandat_page.dart",
                  "f00029",
                  "Rappeler que l’agent de police judiciaire agit sous le contrôle de l’officier de police judiciaire.",
                ),
              ),

              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/interpellation/recherches_infructueuses_mandat_page.dart",
                  "f00030",
                  "3) Exécution de mandat",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/pv_apj20/interpellation/recherches_infructueuses_mandat_page.dart",
                        "f00031",
                        "Indiquer les références du mandat en vertu duquel vous agissez :\n",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/pv_apj20/interpellation/recherches_infructueuses_mandat_page.dart",
                        "f00032",
                        "• type de mandat (amener ou arrêt)\n",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/pv_apj20/interpellation/recherches_infructueuses_mandat_page.dart",
                        "f00033",
                        "• date de délivrance + nom/qualité du magistrat mandant\n",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/pv_apj20/interpellation/recherches_infructueuses_mandat_page.dart",
                        "f00034",
                        "• identité de la personne concernée\n",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/pv_apj20/interpellation/recherches_infructueuses_mandat_page.dart",
                        "f00035",
                        "• motif (soupçonnée / témoin assisté / mise en examen)\n",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/pv_apj20/interpellation/recherches_infructueuses_mandat_page.dart",
                        "f00036",
                        "• infraction visée\n\n",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/pv_apj20/interpellation/recherches_infructueuses_mandat_page.dart",
                        "f00037",
                        "Puis : renvoyer aux articles relatifs au mandat et préciser le cadre.",
                      ),
                ),
              ]),

              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/interpellation/recherches_infructueuses_mandat_page.dart",
                  "f00038",
                  "4) Assistants",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/interpellation/recherches_infructueuses_mandat_page.dart",
                      "f00039",
                      "Mentionner les fonctionnaires accompagnants + la tenue de l’équipage ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/interpellation/recherches_infructueuses_mandat_page.dart",
                      "f00040",
                      "(uniforme, tenue bourgeoise, port du brassard police).",
                    ),
              ),

              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/interpellation/recherches_infructueuses_mandat_page.dart",
                  "f00041",
                  "5) Transport",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/interpellation/recherches_infructueuses_mandat_page.dart",
                      "f00042",
                      "Préciser l’adresse du dernier domicile connu, rappeler le respect des heures légales (06h–21h) ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/interpellation/recherches_infructueuses_mandat_page.dart",
                      "f00043",
                      "et indiquer l’heure précise d’arrivée sur place.",
                    ),
              ),

              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/interpellation/recherches_infructueuses_mandat_page.dart",
                  "f00044",
                  "6) Identité",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/interpellation/recherches_infructueuses_mandat_page.dart",
                      "f00045",
                      "Relever l’identité succincte de la personne présente (si une personne est sur place). ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/interpellation/recherches_infructueuses_mandat_page.dart",
                      "f00046",
                      "Préciser le document à partir duquel l’identité est vérifiée.",
                    ),
              ),

              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/interpellation/recherches_infructueuses_mandat_page.dart",
                  "f00047",
                  "7) Visite",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/pv_apj20/interpellation/recherches_infructueuses_mandat_page.dart",
                        "f00048",
                        "Visiter les lieux afin de s’assurer de la présence ou non de la personne visée.\n\n",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/pv_apj20/interpellation/recherches_infructueuses_mandat_page.dart",
                        "f00049",
                        "Cette visite a pour but exclusif de rechercher la personne faisant l’objet du mandat. ",
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/interpellation/recherches_infructueuses_mandat_page.dart",
                    "f00050",
                    "Elle n’est pas assimilée à la perquisition de l’article 56 du Code de procédure pénale",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: ".\n\n"),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/pv_apj20/interpellation/recherches_infructueuses_mandat_page.dart",
                        "f00051",
                        "En l’absence de la personne : la visite peut être réalisée après réquisition d’un serrurier ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/pv_apj20/interpellation/recherches_infructueuses_mandat_page.dart",
                        "f00052",
                        "et en présence de deux témoins requis.\n\n",
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/interpellation/recherches_infructueuses_mandat_page.dart",
                    "f00053",
                    "Si la personne ne peut être saisie : PV adressé au magistrat délivrant le mandat — article 134 du Code de procédure pénale",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),

              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/interpellation/recherches_infructueuses_mandat_page.dart",
                  "f00054",
                  "8) Énonciation terminale (clôture)",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/interpellation/recherches_infructueuses_mandat_page.dart",
                  "f00055",
                  "Clore le PV en précisant l’heure.",
                ),
              ),

              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/interpellation/recherches_infructueuses_mandat_page.dart",
                  "f00056",
                  "9) Avis magistrat",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/interpellation/recherches_infructueuses_mandat_page.dart",
                  "f00057",
                  "Informer le magistrat mandant et indiquer les instructions reçues.",
                ),
              ),

              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/interpellation/recherches_infructueuses_mandat_page.dart",
                  "f00058",
                  "10) Clôture / transmission",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/interpellation/recherches_infructueuses_mandat_page.dart",
                  "f00059",
                  "Mentionner la transmission du procès-verbal (et à qui), puis fin de mission.",
                ),
              ),

              SizedBox(height: 12),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/pv_apj20/interpellation/recherches_infructueuses_mandat_page.dart",
                          "f00060",
                          "Conseil : notez systématiquement les heures clés (arrivée, début/fin visite, clôture) ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/pv_apj20/interpellation/recherches_infructueuses_mandat_page.dart",
                          "f00061",
                          "et les personnes présentes (serrurier, témoins requis, assistants).",
                        ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/interpellation/recherches_infructueuses_mandat_page.dart",
              "f00062",
              "CANVA — Modèle PV (zoom)",
            ),
            cardColor: cardCanva,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/interpellation/recherches_infructueuses_mandat_page.dart",
                  "f00063",
                  "Appuyez sur l’image pour l’ouvrir en plein écran et zoomer.",
                ),
              ),
              SizedBox(height: 12),
              _ZoomableAssetImage(
                assetPath: 'assets/images/canva_infructueuse_pv_recto.png',
                label: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/interpellation/recherches_infructueuses_mandat_page.dart",
                  "f00064",
                  'Modèle PV',
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

class _ZoomableAssetImage extends StatelessWidget {
  const _ZoomableAssetImage({required this.assetPath, required this.label});

  final String assetPath;
  final String label;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color border = isDark ? Colors.white24 : Colors.black12;
    final Color chipBg = isDark
        ? Colors.black54
        : Colors.white.withValues(alpha: .92);
    final Color chipText = isDark ? Colors.white : const Color(0xFF050505);

    return Semantics(
      button: true,
      label: 'Ouvrir $label en plein écran',
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _openFullScreen(context),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: border),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              AspectRatio(
                aspectRatio: 3 / 4,
                child: Image.asset(assetPath, fit: BoxFit.cover),
              ),
              Positioned(
                left: 10,
                top: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: chipBg,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: border),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.zoom_in_rounded, size: 16, color: chipText),
                      const SizedBox(width: 6),
                      Text(
                        label,
                        style: GoogleFonts.fustat(
                          fontWeight: FontWeight.w800,
                          fontSize: 12.5,
                          color: chipText,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                right: 10,
                bottom: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: chipBg,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: border),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.open_in_full_rounded,
                        size: 16,
                        color: chipText,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/pv_apj20/interpellation/recherches_infructueuses_mandat_page.dart",
                          "f00066",
                          "Plein écran",
                        ),
                        style: GoogleFonts.fustat(
                          fontWeight: FontWeight.w800,
                          fontSize: 12.5,
                          color: chipText,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openFullScreen(BuildContext context) {
    showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Fermer',
      barrierColor: Colors.black.withValues(alpha: .92),
      pageBuilder: (_, __, ___) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                Center(
                  child: InteractiveViewer(
                    minScale: 1.0,
                    maxScale: 6.0,
                    panEnabled: true,
                    scaleEnabled: true,
                    child: Image.asset(assetPath),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded, color: Colors.white),
                    tooltip: 'Fermer',
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
