import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PaStupefiantsTransportDetentionOffrePage extends StatelessWidget {
  const PaStupefiantsTransportDetentionOffrePage({super.key});

  static const String routeName =
      '/pa/dps_dpg/stupefiants/transport_detention_offre';

  static const Color _lawRed = Color(0xFFE53935);

  TextSpan _law(String text) {
    return TextSpan(
      text: text,
      style: const TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette cards (propre + lisible)
    final Color cardDef = isDark
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
    final Color cardAggr = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);
    final Color cardRep = isDark
        ? const Color(0xFF20242A)
        : const Color(0xFFF3F6FA);

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
            "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
            "f00002",
            "Stupéfiants",
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
              "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
              "f00003",
              "Le transport, la détention, l’offre,\nla cession, l’acquisition ou l’emploi\nillicites de stupéfiants",
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Définition
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
              "f00004",
              "Définition",
            ),
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                      "f00005",
                      "Le transport, la détention, l’offre, la cession, l’acquisition ou l’emploi illicites de stupéfiants ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                      "f00006",
                      "constituent des infractions.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
              "f00007",
              "I — Élément légal",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                _law(
                  ScolariteText.value(
                    "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                    "f00008",
                    "Article 222-37 alinéa 1 du Code pénal",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                    "f00009",
                    " : réprime le transport, la détention, l’offre, la cession, l’acquisition ou l’emploi illicites de stupéfiants.",
                  ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Élément matériel
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
              "f00010",
              "II — Élément matériel",
            ),
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                  "f00011",
                  "A) Les agissements visés",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                      "f00012",
                      "Il s’agit des comportements d’intermédiaires, grossistes ou détaillants, acheteurs ou revendeurs. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                      "f00013",
                      "Le trafic visé est celui réalisé entre plusieurs personnes : la cession à une personne déterminée ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                      "f00014",
                      "en vue de sa consommation personnelle est, elle, visée par un autre texte.",
                    ),
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                    "f00015",
                    "Référence : ",
                  ),
                ),
                _law(
                  ScolariteText.value(
                    "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                    "f00016",
                    "article 222-39 du Code pénal",
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                  "f00017",
                  "B) Trafic : preuve souvent par un faisceau d’indices",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                      "f00018",
                      "Le trafic visé ici correspond notamment à l’achat dans le but de revendre. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                      "f00019",
                      "En pratique, la jurisprudence facilite la démonstration du trafic grâce à un réseau d’indices (faisceau).",
                    ),
              ),
              const SizedBox(height: 12),

              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                  "f00020",
                  "Jurisprudence",
                ),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                          "f00021",
                          "Retenu : personne n’ayant pas seulement « offert » pour consommation personnelle, mais s’étant livrée au commerce ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                          "f00022",
                          "des stupéfiants via des déplacements réguliers, sans consommer elle-même l’héroïne — ",
                        ),
                  ),
                  _law(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                      "f00023",
                      "Cass. crim., 30 octobre 1995",
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                  "f00024",
                  "Jurisprudence",
                ),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                          "f00025",
                          "Le trafic résulte souvent d’un faisceau d’indices : témoignages de toxicomanes + découverte au domicile de stupéfiants ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                          "f00026",
                          "et de matériel (balance/peson, couteau, produit de coupe, etc.) — ",
                        ),
                  ),
                  _law(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                      "f00027",
                      "Cass. crim., 5 novembre 1998",
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),

              const SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                  "f00028",
                  "C) Les notions clés (définitions opérationnelles)",
                ),
              ),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                  "f00029",
                  "1) Le transport",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                  "f00030",
                  "C’est le fait de transporter des produits stupéfiants sans autorisation de l’administration.",
                ),
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                  "f00031",
                  "Jurisprudence",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                      "f00032",
                      "Être trouvé porteur de stupéfiants sur la voie publique caractérise à la fois le délit de détention et celui de transport — ",
                    ),
                  ),
                  _law(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                      "f00033",
                      "Cass. crim., 8 avril 1999",
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),

              const SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                  "f00034",
                  "2) La détention",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                      "f00035",
                      "Elle concerne toute personne en possession de stupéfiants. La détention peut être retenue même si le produit ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                      "f00036",
                      "n’est pas sur la personne, mais à proximité (ex : cache).",
                    ),
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                  "f00037",
                  "Jurisprudence",
                ),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                          "f00038",
                          "Détention retenue : stupéfiants dissimulés dans une cache à quelques mètres ; ex. détenu sachant que des doses ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                          "f00039",
                          "étaient cachées sous le matelas d’un autre détenu de la cellule — ",
                        ),
                  ),
                  _law(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                      "f00040",
                      "Cass. crim., 17 octobre 1994",
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),
              const SizedBox(height: 12),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                      "f00041",
                      "La jurisprudence rappelle que la détention illicite ne peut être réprimée que si elle s’inscrit dans un trafic ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                      "f00042",
                      "ou dans le cadre de l’infraction spécifique de cession/usage personnel prévue par le code pénal.",
                    ),
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                  "f00043",
                  "Jurisprudence",
                ),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                          "f00044",
                          "Non retenu : détention pour une personne trouvée porteuse de 3 g de cannabis pour sa consommation personnelle ; ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                          "f00045",
                          "l’usage implique une détention préalable et le délit de détention est réservé aux hypothèses de trafic — ",
                        ),
                  ),
                  _law(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                      "f00046",
                      "Cass. crim., 14 mars 2017",
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),

              const SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                  "f00047",
                  "3) L’offre",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                      "f00048",
                      "L’offre correspond à l’instant qui précède la remise : l’acte matériel de remise n’a pas encore eu lieu, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                      "f00049",
                      "mais des stupéfiants sont proposés.",
                    ),
              ),

              const SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                  "f00050",
                  "4) La cession",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                  "f00051",
                  "La cession signifie que le produit a changé de mains : la transaction est réalisée.",
                ),
              ),

              const SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                  "f00052",
                  "5) L’acquisition",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                  "f00053",
                  "L’acquisition est, pour celui qui reçoit le produit, le résultat de l’offre ou de la cession.",
                ),
              ),

              const SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                  "f00054",
                  "6) L’emploi",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                      "f00055",
                      "L’emploi se distingue de l’usage : il vise toute utilisation de produits stupéfiants en dehors de la consommation ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                      "f00056",
                      "(ex : couper des doses).",
                    ),
              ),

              const SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                  "f00057",
                  "D) Définition légale des « stupéfiants » (cadre commun)",
                ),
              ),
              _Paragraph.rich([
                _law(
                  ScolariteText.value(
                    "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                    "f00058",
                    "Article 222-41 du Code pénal",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                    "f00059",
                    " : « constituent des stupéfiants, des substances ou plantes classées comme stupéfiants en application de ",
                  ),
                ),
                _law(
                  ScolariteText.value(
                    "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                    "f00060",
                    "l’article L. 5132-7 du Code de la santé publique",
                  ),
                ),
                const TextSpan(text: " »."),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                _law(
                  ScolariteText.value(
                    "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                    "f00061",
                    "Article L. 5132-7 du Code de la santé publique",
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                        "f00062",
                        " : une substance est classée comme stupéfiant par décision du directeur général de l’Agence nationale de sécurité ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                        "f00063",
                        "du médicament et des produits de santé.",
                      ),
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                      "f00064",
                      "Ainsi, seules les substances figurant sur les listes arrêtées par voie réglementaire doivent être retenues ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                      "f00065",
                      "au sens de la définition légale.",
                    ),
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                    "f00066",
                    "La liste exhaustive et évolutive figure en annexes de ",
                  ),
                ),
                _law(
                  ScolariteText.value(
                    "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                    "f00067",
                    "l’arrêté du 22 février 1990",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                    "f00068",
                    " : l’infraction ne s’applique qu’à une substance figurant sur cette liste et désignée avec suffisamment de précision.",
                  ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Élément moral
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
              "f00069",
              "III — Élément moral",
            ),
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                  "f00070",
                  "Connaissance de cause",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                      "f00071",
                      "L’intention coupable est requise. Elle peut être mise en évidence aussi bien par les actes matériels ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                      "f00072",
                      "que par le profit tiré de ces actes.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Circonstances aggravantes
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
              "f00073",
              "IV — Circonstances aggravantes",
            ),
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                _law(
                  ScolariteText.value(
                    "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                    "f00074",
                    "Article 222-37-1 du Code pénal",
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                        "f00075",
                        " : lorsque l’infraction est commise par un majeur agissant avec l’aide ou l’assistance, directe ou indirecte, ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                        "f00076",
                        "d’un mineur pour le transport, la détention, l’offre, la cession, l’acquisition ou la vente de stupéfiants.",
                      ),
                ),
              ]),
              const SizedBox(height: 10),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                  "f00077",
                  "L’aide/assistance d’un mineur peut être caractérisée par tout acte de sollicitation, d’incitation ou d’organisation intégrant un mineur dans un réseau de trafic (volontaire ou contrainte).",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Répression + tentative/complicité
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
              "f00078",
              "V — Répression",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                  "f00079",
                  "Peines encourues — personnes physiques",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                    "f00080",
                    "Qualification simple (délit) : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                    "f00081",
                    "10 ans d’emprisonnement et 7 500 000 € d’amende. — ",
                  ),
                ),
                _law(
                  ScolariteText.value(
                    "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                    "f00082",
                    "article 222-37 alinéa 1 du Code pénal",
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                    "f00083",
                    "Qualification aggravée (crime) : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                    "f00084",
                    "15 ans de réclusion et 7 500 000 € d’amende. — ",
                  ),
                ),
                _law(
                  ScolariteText.value(
                    "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                    "f00085",
                    "article 222-37-1 1° du Code pénal",
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                      "f00086",
                      "Les tableaux prévoient une période de sûreté (selon les cas et les textes applicables).",
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                  "f00087",
                  "Personnes morales",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                    "f00088",
                    "Peines prévues par ",
                  ),
                ),
                _law(
                  ScolariteText.value(
                    "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                    "f00089",
                    "l’article 222-42 du Code pénal",
                  ),
                ),
                const TextSpan(text: "."),
              ]),

              const SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                  "f00090",
                  "Tentative & complicité",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                    "f00091",
                    "Tentative : OUI — prévue par ",
                  ),
                ),
                _law(
                  ScolariteText.value(
                    "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                    "f00092",
                    "l’article 222-40 du Code pénal",
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                    "f00093",
                    "Complicité : OUI — conformément aux ",
                  ),
                ),
                _law(
                  ScolariteText.value(
                    "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                    "f00094",
                    "articles 121-6 et 121-7 du Code pénal",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                    "f00095",
                    " (aide et assistance, provocation, instructions données).",
                  ),
                ),
              ]),

              const SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                  "f00096",
                  "Exemption & réduction de peine",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                    "f00097",
                    "Réduction de peine : ",
                  ),
                ),
                _law(
                  ScolariteText.value(
                    "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                    "f00098",
                    "article 222-43 du Code pénal",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                    "f00099",
                    " (réduction des deux tiers si l’auteur/complice avertit les autorités et permet de faire cesser les agissements ou d’identifier d’autres coupables).",
                  ),
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                    "f00100",
                    "Exemption de peine : ",
                  ),
                ),
                _law(
                  ScolariteText.value(
                    "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                    "f00101",
                    "article 222-43-1 du Code pénal",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart",
                    "f00102",
                    " (si la personne ayant tenté l’infraction avertit les autorités et permet d’éviter la réalisation et d’identifier, le cas échéant, d’autres auteurs/complices).",
                  ),
                ),
              ]),
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
