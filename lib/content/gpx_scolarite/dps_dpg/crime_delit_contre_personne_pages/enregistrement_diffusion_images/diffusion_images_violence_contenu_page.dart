import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class DiffusionImagesViolenceContenuPage extends StatelessWidget {
  const DiffusionImagesViolenceContenuPage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/crime_delit_contre_personne_pages/enregistrement_diffusion_images/diffusion';

  static const Color _lawRed = Color(0xFFE53935);

  TextSpan _law(String text) => TextSpan(
    text: text,
    style: const TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
  );

  TextSpan _t(String text, {bool bold = false}) => TextSpan(
    text: text,
    style: TextStyle(fontWeight: bold ? FontWeight.w800 : FontWeight.w500),
  );

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
    final Color cardMoral = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardAggr = isDark
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
            "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/enregistrement_diffusion_images/diffusion_images_violence_contenu_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/enregistrement_diffusion_images/diffusion_images_violence_contenu_page.dart",
            "f00002",
            "Crimes & délits contre la personne",
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
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/enregistrement_diffusion_images/diffusion_images_violence_contenu_page.dart",
              "f00003",
              "La diffusion d’images de violence",
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
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/enregistrement_diffusion_images/diffusion_images_violence_contenu_page.dart",
              "f00004",
              "Définition",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/enregistrement_diffusion_images/diffusion_images_violence_contenu_page.dart",
                      "f00005",
                      "Le fait de diffuser l’enregistrement d’images relatives à la commission d’atteintes volontaires ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/enregistrement_diffusion_images/diffusion_images_violence_contenu_page.dart",
                      "f00006",
                      "à l’intégrité de la personne (liste limitative du Code pénal) constitue une infraction autonome.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut (article en rouge)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/enregistrement_diffusion_images/diffusion_images_violence_contenu_page.dart",
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
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/enregistrement_diffusion_images/diffusion_images_violence_contenu_page.dart",
                    "f00008",
                    "Article 222-33-3 alinéa 2 du Code pénal",
                  ),
                ),
                _t(
                  ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/enregistrement_diffusion_images/diffusion_images_violence_contenu_page.dart",
                        "f00009",
                        " : incrimine et réprime le fait de diffuser l’enregistrement d’images relatives ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/enregistrement_diffusion_images/diffusion_images_violence_contenu_page.dart",
                        "f00010",
                        "aux infractions prévues aux ",
                      ),
                ),
                _law(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/enregistrement_diffusion_images/diffusion_images_violence_contenu_page.dart",
                    "f00011",
                    "articles 222-1 à 222-14-1, 222-23 à 222-31 et 222-33 du Code pénal",
                  ),
                ),
                _t("."),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Élément matériel
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/enregistrement_diffusion_images/diffusion_images_violence_contenu_page.dart",
              "f00012",
              "II — Élément matériel",
            ),
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/enregistrement_diffusion_images/diffusion_images_violence_contenu_page.dart",
                  "f00013",
                  "A) Une diffusion d’images de violence",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/enregistrement_diffusion_images/diffusion_images_violence_contenu_page.dart",
                      "f00014",
                      "La diffusion d’images de violences est érigée en infraction autonome : ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/enregistrement_diffusion_images/diffusion_images_violence_contenu_page.dart",
                      "f00015",
                      "il ne s’agit pas seulement d’un acte de complicité.",
                    ),
              ),
              const SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/enregistrement_diffusion_images/diffusion_images_violence_contenu_page.dart",
                  "f00016",
                  "B) Nature des violences concernées (liste limitative)",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/enregistrement_diffusion_images/diffusion_images_violence_contenu_page.dart",
                      "f00017",
                      "Les violences visées sont limitativement énumérées. Les infractions voisines non citées ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/enregistrement_diffusion_images/diffusion_images_violence_contenu_page.dart",
                      "f00018",
                      "sont exclues du champ d’application.",
                    ),
              ),
              const SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/enregistrement_diffusion_images/diffusion_images_violence_contenu_page.dart",
                  "f00019",
                  "Tortures et actes de barbarie.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/enregistrement_diffusion_images/diffusion_images_violence_contenu_page.dart",
                  "f00020",
                  "Violences délictuelles même aggravées (hors violences sur FSI prévues à l’article 222-14-5).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/enregistrement_diffusion_images/diffusion_images_violence_contenu_page.dart",
                  "f00021",
                  "Viol.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/enregistrement_diffusion_images/diffusion_images_violence_contenu_page.dart",
                  "f00022",
                  "Agressions sexuelles délictuelles.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/enregistrement_diffusion_images/diffusion_images_violence_contenu_page.dart",
                  "f00023",
                  "Administration d’une substance afin de commettre un viol ou une agression sexuelle.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/enregistrement_diffusion_images/diffusion_images_violence_contenu_page.dart",
                  "f00024",
                  "Harcèlement sexuel.",
                ),
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                _t(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/enregistrement_diffusion_images/diffusion_images_violence_contenu_page.dart",
                    "f00025",
                    "Référence : ",
                  ),
                ),
                _law(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/enregistrement_diffusion_images/diffusion_images_violence_contenu_page.dart",
                    "f00026",
                    "article 222-33-3 du Code pénal",
                  ),
                ),
                _t("."),
              ]),

              const SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/enregistrement_diffusion_images/diffusion_images_violence_contenu_page.dart",
                  "f00027",
                  "C) L’acte de diffusion",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/enregistrement_diffusion_images/diffusion_images_violence_contenu_page.dart",
                      "f00028",
                      "La diffusion s’entend largement : répandre, émettre, transmettre. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/enregistrement_diffusion_images/diffusion_images_violence_contenu_page.dart",
                      "f00029",
                      "Cela peut aller d’un transfert entre téléphones à une mise en ligne sur Internet, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/enregistrement_diffusion_images/diffusion_images_violence_contenu_page.dart",
                      "f00030",
                      "ou encore le prêt de l’original / la distribution de copies.",
                    ),
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/enregistrement_diffusion_images/diffusion_images_violence_contenu_page.dart",
                          "f00031",
                          "Il n’est pas nécessaire que le diffuseur soit l’auteur de l’enregistrement : ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/enregistrement_diffusion_images/diffusion_images_violence_contenu_page.dart",
                          "f00032",
                          "la responsabilité peut être engagée dès lors qu’il autorise (même tacitement) ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/enregistrement_diffusion_images/diffusion_images_violence_contenu_page.dart",
                          "f00033",
                          "la diffusion d’images dont il connaît le caractère illicite.",
                        ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/enregistrement_diffusion_images/diffusion_images_violence_contenu_page.dart",
                  "f00034",
                  "D) Faits justificatifs",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/enregistrement_diffusion_images/diffusion_images_violence_contenu_page.dart",
                  "f00035",
                  "Le texte prévoit des hypothèses limitatives où l’enregistrement/diffusion n’est pas applicable.",
                ),
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/enregistrement_diffusion_images/diffusion_images_violence_contenu_page.dart",
                  "f00036",
                  "Exception d’information",
                ),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/enregistrement_diffusion_images/diffusion_images_violence_contenu_page.dart",
                          "f00037",
                          "La diffusion est justifiée lorsqu’elle est effectuée par des professionnels de l’information. ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/enregistrement_diffusion_images/diffusion_images_violence_contenu_page.dart",
                          "f00038",
                          "La liberté d’informer peut justifier la reproduction d’une image d’actualité, sous réserve du respect ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/enregistrement_diffusion_images/diffusion_images_violence_contenu_page.dart",
                          "f00039",
                          "de la loi du 29 juillet 1881 (notamment dignité et non-identification).",
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/enregistrement_diffusion_images/diffusion_images_violence_contenu_page.dart",
                  "f00040",
                  "Exception probatoire",
                ),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/enregistrement_diffusion_images/diffusion_images_violence_contenu_page.dart",
                          "f00041",
                          "Elle est difficilement applicable à la diffusion : si la personne diffuse les images, ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/enregistrement_diffusion_images/diffusion_images_violence_contenu_page.dart",
                          "f00042",
                          "l’infraction est en principe constituée. Il paraît incompatible qu’une diffusion TV/Internet ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/enregistrement_diffusion_images/diffusion_images_violence_contenu_page.dart",
                          "f00043",
                          "serve « de preuve ».",
                        ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Élément moral
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/enregistrement_diffusion_images/diffusion_images_violence_contenu_page.dart",
              "f00044",
              "III — Élément moral",
            ),
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/enregistrement_diffusion_images/diffusion_images_violence_contenu_page.dart",
                  "f00045",
                  "A) Connaissance du contenu des images",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/enregistrement_diffusion_images/diffusion_images_violence_contenu_page.dart",
                  "f00046",
                  "L’auteur doit savoir que les images qu’il diffuse sont des images d’atteintes à l’intégrité physique des personnes.",
                ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/enregistrement_diffusion_images/diffusion_images_violence_contenu_page.dart",
                  "f00047",
                  "B) Volonté de diffuser",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/enregistrement_diffusion_images/diffusion_images_violence_contenu_page.dart",
                  "f00048",
                  "La diffusion doit être intentionnelle : l’auteur transmet volontairement des images de violences qu’il détient.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Circonstances aggravantes
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/enregistrement_diffusion_images/diffusion_images_violence_contenu_page.dart",
              "f00049",
              "IV — Circonstances aggravantes",
            ),
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/enregistrement_diffusion_images/diffusion_images_violence_contenu_page.dart",
                  "f00050",
                  "Aucune circonstance aggravante spécifique n’est prévue pour cette infraction.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Répression
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/enregistrement_diffusion_images/diffusion_images_violence_contenu_page.dart",
              "f00051",
              "V — Répression",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/enregistrement_diffusion_images/diffusion_images_violence_contenu_page.dart",
                  "f00052",
                  "Peines encourues — personnes physiques",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/enregistrement_diffusion_images/diffusion_images_violence_contenu_page.dart",
                    "f00053",
                    "Délit — ",
                  ),
                ),
                _law(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/enregistrement_diffusion_images/diffusion_images_violence_contenu_page.dart",
                    "f00054",
                    "article 222-33-3 alinéa 2 du Code pénal",
                  ),
                ),
                const TextSpan(text: " : "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/enregistrement_diffusion_images/diffusion_images_violence_contenu_page.dart",
                    "f00055",
                    "5 ans d’emprisonnement et 75 000 € d’amende.",
                  ),
                ),
              ]),
              const SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/enregistrement_diffusion_images/diffusion_images_violence_contenu_page.dart",
                  "f00056",
                  "Personnes morales",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/enregistrement_diffusion_images/diffusion_images_violence_contenu_page.dart",
                  "f00057",
                  "Les personnes morales peuvent être déclarées pénalement responsables.",
                ),
              ),

              const SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/enregistrement_diffusion_images/diffusion_images_violence_contenu_page.dart",
                  "f00058",
                  "Tentative & complicité",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/enregistrement_diffusion_images/diffusion_images_violence_contenu_page.dart",
                  "f00059",
                  "Tentative : NON.",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/enregistrement_diffusion_images/diffusion_images_violence_contenu_page.dart",
                    "f00060",
                    "Complicité : OUI, conformément à ",
                  ),
                ),
                _law(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/enregistrement_diffusion_images/diffusion_images_violence_contenu_page.dart",
                    "f00061",
                    "l’article 121-6 du Code pénal",
                  ),
                ),
                const TextSpan(text: " et "),
                _law(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/enregistrement_diffusion_images/diffusion_images_violence_contenu_page.dart",
                    "f00062",
                    "l’article 121-7 du Code pénal",
                  ),
                ),
                const TextSpan(text: "."),
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
