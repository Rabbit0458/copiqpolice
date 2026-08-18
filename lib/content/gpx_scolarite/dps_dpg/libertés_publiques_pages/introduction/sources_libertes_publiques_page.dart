import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class SourcesLibertesPubliquesPage extends StatelessWidget {
  const SourcesLibertesPubliquesPage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/libertés_publiques_pages/introduction/sources_libertes_publiques';

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
    final Color cardHist = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardDecl1789 = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardPost = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardCurrent = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);
    final Color cardIntl = isDark
        ? const Color(0xFF20272A)
        : const Color(0xFFEFFBFF);
    final Color cardHierarchy = isDark
        ? const Color(0xFF262626)
        : const Color(0xFFF7F7F7);

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
    final Color accentCyan = isDark
        ? const Color(0xFF4DD0E1)
        : const Color(0xFF00838F);

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
            "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
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
              "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
              "f00003",
              "Les sources des libertés publiques",
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
              "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
              "f00004",
              "Repère",
            ),
            cardColor: cardIntro,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                      "f00005",
                      "Aujourd’hui, nous bénéficions en France d’un ensemble de droits et libertés acquis tout au long de l’histoire. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                      "f00006",
                      "Ces libertés proviennent de sources philosophiques, juridiques, constitutionnelles et internationales.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ===================== CHAPITRE 1 : HISTOIRE =====================
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
              "f00007",
              "Chapitre 1 — Évolution historique jusqu’en 1958",
            ),
            cardColor: cardHist,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                  "f00008",
                  "1.1 — Apports antérieurs à 1789",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                  "f00009",
                  "Avant la Déclaration de 1789, des courants d’idées et des textes fondamentaux ont posé les premières garanties contre l’arbitraire.",
                ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                  "f00010",
                  "A) Sources philosophiques",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                  "f00011",
                  "1) Pensée chrétienne",
                ),
              ),
              SizedBox(height: 6),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                  "f00012",
                  "Affirmation de l’égalité de tous les hommes.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                  "f00013",
                  "Valeur et respect de la personne humaine.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                  "f00014",
                  "Limitation du pouvoir de l’État et légitimation de la résistance à l’oppression.",
                ),
              ),
              SizedBox(height: 10),

              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                  "f00015",
                  "2) Droit naturel & Contrat social",
                ),
              ),
              SizedBox(height: 6),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                  "f00016",
                  "Idée antique : droits naturels, universels et intangibles, visant une société idéale.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                  "f00017",
                  "Contrat social (Jean-Jacques Rousseau) : les hommes quittent l’état de nature pour fonder une société civile.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                  "f00018",
                  "Par convention : abandon d’une partie de la liberté initiale contre davantage de sécurité.",
                ),
              ),
              SizedBox(height: 10),

              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                  "f00019",
                  "3) Philosophie des Lumières (XVIIIe siècle)",
                ),
              ),
              SizedBox(height: 6),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                  "f00020",
                  "Influence des systèmes anglo-saxons.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                  "f00021",
                  "Esprit de résistance au pouvoir (notamment dans les Parlements).",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                  "f00022",
                  "Physiocrates : respect de l’individu et de ses droits ; propriété comme base de la société.",
                ),
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                  "f00023",
                  "B) Sources juridiques",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                  "f00024",
                  "1) Pactes anglais",
                ),
              ),
              SizedBox(height: 6),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                  "f00025",
                  "Grande Charte (Magna Carta, 1215) : limitation de la toute-puissance royale et garantie minimale de libertés.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                  "f00026",
                  "Pétition des droits (1627) : revendications renforcées ; monarchie constitutionnelle limitée par le droit.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                  "f00027",
                  "Habeas Corpus (1679) : garantie de la sûreté ; intervention du juge contre une détention arbitraire.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                  "f00028",
                  "Bill of Rights (1689) : garantie des libertés publiques du Parlement.",
                ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                  "f00029",
                  "Ces textes proclament des principes de libertés et mettent en place des garanties contre l’arbitraire de l’État.",
                ),
              ),
              SizedBox(height: 12),

              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                  "f00030",
                  "2) Déclarations américaines",
                ),
              ),
              SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                      "f00031",
                      "Les premières déclarations de droits rédigées sous influence anglaise. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                      "f00032",
                      "La plus célèbre : déclaration d’indépendance du 4 juillet 1776, souvent décrite comme un « hymne à l’individualisme optimiste ».",
                    ),
              ),
              SizedBox(height: 8),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                  "f00033",
                  "Notion d’égalité.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                  "f00034",
                  "Droits inaliénables : liberté, vie, bonheur, honneur.",
                ),
              ),
              SizedBox(height: 8),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                      "f00035",
                      "Le texte de référence en France reste la ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                      "f00036",
                      "Déclaration des Droits de l’Homme et du Citoyen de 1789",
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

          // ===================== DDHC 1789 =====================
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
              "f00037",
              "1.2 — Déclaration des Droits de l’Homme et du Citoyen (1789)",
            ),
            cardColor: cardDecl1789,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                    "f00038",
                    "Déclaration du 26 août 1789",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                    "f00039",
                    " : élaborée par l’Assemblée nationale constituante, issue de la Révolution.",
                  ),
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                      "f00040",
                      "Les constituants posent les bases d’une société fondée sur la liberté et l’égalité. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                      "f00041",
                      "La Déclaration impose l’existence d’une puissance publique (pour garantir les libertés), la démocratie et la séparation des pouvoirs.",
                    ),
              ),

              const SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                  "f00042",
                  "1.2.1 — Caractéristiques",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                  "f00043",
                  "A) Individualisme",
                ),
              ),
              const SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                      "f00044",
                      "Inspirée par le droit naturel, la Déclaration vise d’abord l’homme en tant qu’individu : ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                      "f00045",
                      "il est titulaire des droits. Elle ne proclame pas de droits collectifs (association, grève, réunion), ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                      "f00046",
                      "qui seront reconnus plus tard.",
                    ),
              ),
              const SizedBox(height: 10),

              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                  "f00047",
                  "B) Aspect métaphysique",
                ),
              ),
              const SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                  "f00048",
                  "Reconnaissance solennelle de droits naturels, inaliénables et sacrés.",
                ),
              ),
              const SizedBox(height: 10),

              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                  "f00049",
                  "C) Universalité",
                ),
              ),
              const SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                      "f00050",
                      "Les droits proclamés sont ceux de l’homme et du citoyen : ils valent pour tout être humain, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                      "f00051",
                      "et non pour les seuls citoyens français de 1789.",
                    ),
              ),
              const SizedBox(height: 10),

              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                  "f00052",
                  "D) Caractère abstrait",
                ),
              ),
              const SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                      "f00053",
                      "La Déclaration pose de grands principes (liberté, égalité, sûreté, propriété) mais ne détaille pas ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                      "f00054",
                      "concrètement les moyens d’exercice : l’aménagement viendra par les lois et les régimes politiques.",
                    ),
              ),

              const SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                  "f00055",
                  "1.2.2 — Contenu",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                  "f00056",
                  "A) Droits de l’Homme",
                ),
              ),
              const SizedBox(height: 8),

              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                  "f00057",
                  "Les 4 piliers",
                ),
                cardColor: isDark
                    ? const Color(0xFF1B1F25)
                    : const Color(0xFFFFFFFF),
                accent: accentBlue,
                titleColor: textMain,
                children: [
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                      "f00058",
                      "Égalité : condition première de la liberté ; égalité devant la loi, devant les charges, égal accès aux emplois publics…",
                    ),
                  ),
                  SizedBox(height: 6),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                      "f00059",
                      "Liberté : « pouvoir faire tout ce qui ne nuit pas à autrui » ; principe selon lequel « tout ce qui n’est pas défendu par la loi ne peut être empêché ».",
                    ),
                  ),
                  SizedBox(height: 6),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                      "f00060",
                      "Propriété : droit inviolable et sacré, mais pouvant être limité/supprimé si nécessité publique + juste et préalable indemnité (ex. expropriation, nationalisations).",
                    ),
                  ),
                  SizedBox(height: 6),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                      "f00061",
                      "Résistance à l’oppression : droit et devoir lorsque le pouvoir n’est plus conforme au contrat social.",
                    ),
                  ),
                  SizedBox(height: 10),
                  _Paragraph.rich([
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                        "f00062",
                        "Fondement : ",
                      ),
                    ),
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                        "f00063",
                        "Art. 2 de la DDHC",
                      ),
                      style: TextStyle(
                        color: _lawRed,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                        "f00064",
                        " (la résistance à l’oppression sera précisée dans la Déclaration montagnarde de 1793).",
                      ),
                    ),
                  ]),
                ],
              ),

              const SizedBox(height: 12),

              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                  "f00065",
                  "B) Droits du Citoyen",
                ),
              ),
              const SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                      "f00066",
                      "Droits politiques : concourir personnellement ou par représentants à la formation de la loi, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                      "f00067",
                      "consentir à l’impôt, égalité devant les charges publiques, respect de la légalité, etc.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ===================== POST 1789 =====================
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
              "f00068",
              "1.3 — Évolution postérieure (1789 → 1958)",
            ),
            cardColor: cardPost,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                  "f00069",
                  "Après 1789, la reconnaissance des libertés publiques se poursuit, mais varie selon les régimes politiques.",
                ),
              ),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                  "f00070",
                  "Repères chronologiques",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                  "f00071",
                  "Constituante (1789–1791) : liberté quasi totale de réunion et d’expression (journaux, clubs).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                  "f00072",
                  "Projet girondin (1793) : nouveaux droits (instruction, secours publics), droits économiques.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                  "f00073",
                  "Constitution montagnarde (1793–1794) : suffrage universel direct, garanties renforcées (application brève).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                  "f00074",
                  "Directoire (1795) : propriété comme fondement ; censure et restrictions pratiques.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                  "f00075",
                  "Consulat & Empire (1799–1815) : période sombre ; commissions « façades », décret de 1810 et prisons d’État.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                  "f00076",
                  "Chartes de 1814 et 1830 : progression sur certaines libertés (presse, culte), mais suffrage censitaire.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                  "f00077",
                  "Constitution de 1848 : suffrage universel, libertés réaffirmées puis lois restrictives (clubs, presse, suffrage).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                  "f00078",
                  "Second Empire : autorisations préalables (presse, réunions), interdictions d’associations ; assouplissement après 1860.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                  "f00079",
                  "IIIe République : grandes lois libérales (réunion, presse, association).",
                ),
              ),
              SizedBox(height: 10),

              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                      "f00080",
                      "Lois majeures : ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                      "f00081",
                      "loi du 30 juin 1881 (liberté de réunion)",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: " ; "),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                      "f00082",
                      "loi du 29 juillet 1881 (liberté de la presse)",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: " ; "),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                      "f00083",
                      "loi du 1er juillet 1901 (liberté d’association)",
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
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                  "f00084",
                  "Preambule de 1946 (IVe République)",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                      "f00085",
                      "Réaffirme les droits hérités de 1789 et garantit de nouveaux droits sociaux : égalité politique homme/femme, droit d’asile, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                      "f00086",
                      "droits des travailleurs (discussion collective, participation), droit à l’emploi, droit syndical, droit à l’instruction et formation.",
                    ),
              ),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                    "f00087",
                    "Droit de grève : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                    "f00088",
                    "« s’exerce dans le cadre des lois qui le réglementent »",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // ===================== CHAPITRE 2 : SOURCES ACTUELLES =====================
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
              "f00089",
              "Chapitre 2 — Sources actuelles des libertés publiques",
            ),
            cardColor: cardCurrent,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                  "f00090",
                  "2.1 — Préambule de la Constitution de 1958",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                    "f00091",
                    "Source principale : le préambule de la Constitution du 4 octobre 1958 (Ve République) se réfère explicitement à ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                    "f00092",
                    "la DDHC de 1789",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                    "f00093",
                    ", au ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                    "f00094",
                    "préambule de 1946",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                    "f00095",
                    " et à la ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                    "f00096",
                    "Charte de l’environnement de 2004",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                  "f00097",
                  "La Constitution de 1958 reprend l’évolution des libertés : droits individuels, droits sociaux et économiques, et leur protection.",
                ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                  "f00098",
                  "Droits modernes complétant le socle",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                  "f00099",
                  "Droit au respect de la vie privée (loi du 17 juillet 1970).",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                  "f00100",
                  "Informatique et libertés (6 janvier 1978).",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                  "f00101",
                  "Droit d’accès aux documents administratifs (11 juillet 1979).",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ===================== TEXTES INTERNATIONAUX =====================
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
              "f00102",
              "2.2 — Textes internationaux",
            ),
            cardColor: cardIntl,
            accent: accentCyan,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                      "f00103",
                      "L’internationalisation des droits de l’homme est liée aux événements guerriers (Société des Nations après 1918, ONU après 1945). ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                      "f00104",
                      "Progressivement, des textes protecteurs ont été adoptés : on parle de droit des conflits armés et de protection internationale.",
                    ),
              ),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                  "f00105",
                  "2.2.1 — Droit international humanitaire (conflits armés)",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                  "f00106",
                  "Droit de La Haye (1899–1907) : droits/devoirs des belligérants et limitation des moyens (ex. interdiction de certains gaz).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                  "f00107",
                  "Droit de Genève (12 août 1949) : protection des blessés/malades, prisonniers de guerre, populations civiles.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                  "f00108",
                  "Protocoles additionnels de 1977 : adaptation aux conflits modernes (guérillas, décolonisation, guerres civiles, terrorisme).",
                ),
              ),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                  "f00109",
                  "2.2.2 — Déclaration universelle des droits de l’homme",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                    "f00110",
                    "Adoptée le ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                    "f00111",
                    "10 décembre 1948 (ONU)",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                    "f00112",
                    " : objectif de respect universel et effectif des droits de l’homme et libertés fondamentales.",
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                      "f00113",
                      "Limite : textes souvent non contraignants (recommandations), du fait de la souveraineté des États. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                      "f00114",
                      "Mais elle proclame de nombreux droits : personnels, politiques, économiques et sociaux.",
                    ),
              ),
              SizedBox(height: 10),

              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                      "f00115",
                      "Textes notables : ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                      "f00116",
                      "prévention du génocide (9/12/1948)",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: " ; "),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                      "f00117",
                      "imprescriptibilité crimes de guerre/crimes contre l’humanité (26/11/1968)",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: " ; "),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                      "f00118",
                      "texte contre la torture (10/12/1984)",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: " ; "),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                      "f00119",
                      "statut des réfugiés (28/07/1951)",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: " ; "),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                      "f00120",
                      "lutte discrimination raciale (1965)",
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
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                  "f00121",
                  "2.2.3 — Convention européenne des droits de l’homme",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                    "f00122",
                    "Signée le ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                    "f00123",
                    "4 novembre 1950",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                    "f00124",
                    ", ratifiée par la France en ",
                  ),
                ),
                TextSpan(
                  text: "1974",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                    "f00125",
                    " : mécanismes effectifs de protection en cas de violation.",
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                    "f00126",
                    "Réforme majeure : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                    "f00127",
                    "protocole n°11 du 11 mai 1994",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                    "f00128",
                    " (entrée en vigueur 1er novembre 1998) : suppression de la Commission et création d’une Cour permanente unique (CEDH).",
                  ),
                ),
              ]),
              SizedBox(height: 10),

              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                      "f00129",
                      "Exemples de condamnations : ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                      "f00130",
                      "26 avril 1990, Clerc (lenteur)",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: " ; "),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                      "f00131",
                      "24 avril 1990, Kruslin et Huvig (écoutes)",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: " ; "),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                      "f00132",
                      "28 juillet 1999, Selmouni (torture)",
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
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                      "f00133",
                      "À noter : compétence concurrente de la CJUE sur le respect des droits fondamentaux ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                      "f00134",
                      "(ex. condamnation de la France en 1988 concernant des quotas femmes dans la police ; décret du 03 mars 1992 supprimant ces quotas).",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ===================== CHAPITRE 3 : HIÉRARCHIE =====================
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
              "f00135",
              "Chapitre 3 — Valeur juridique des sources (hiérarchie des normes)",
            ),
            cardColor: cardHierarchy,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                      "f00136",
                      "La protection d’une liberté dépend du rang du texte qui la proclame dans la hiérarchie des normes : ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                      "f00137",
                      "plus le texte est élevé, plus la liberté est protégée (toute règle doit respecter la norme supérieure).",
                    ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                  "f00138",
                  "Hiérarchie (ordre décroissant)",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                  "f00139",
                  "Constitution : texte + révisions + préambule (DDHC 1789, Préambule 1946, PFRLR).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                  "f00140",
                  "Engagements internationaux.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                  "f00141",
                  "Lois et textes de valeur législative.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                  "f00142",
                  "Principes généraux du droit (jurisprudence administrative).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart",
                  "f00143",
                  "Règlements.",
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
