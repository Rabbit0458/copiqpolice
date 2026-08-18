import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class ProvocationDirecteMineurCrimeDelitPage extends StatelessWidget {
  const ProvocationDirecteMineurCrimeDelitPage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/mineurs_famille_pages/mise_en_peril/provocation_directe_mineur_crime_delit';

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
            "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_directe_mineur_crime_delit_contenu_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_directe_mineur_crime_delit_contenu_page.dart",
            "f00002",
            "Mise en péril",
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
              "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_directe_mineur_crime_delit_contenu_page.dart",
              "f00003",
              "La provocation directe d’un mineur à commettre un crime ou un délit",
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
              "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_directe_mineur_crime_delit_contenu_page.dart",
              "f00004",
              "Définition",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_directe_mineur_crime_delit_contenu_page.dart",
                  "f00005",
                  "Le fait de provoquer directement un mineur à commettre un crime ou un délit constitue une infraction.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_directe_mineur_crime_delit_contenu_page.dart",
              "f00006",
              "I — Élément légal",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_directe_mineur_crime_delit_contenu_page.dart",
                    "f00007",
                    "Article 227-21 alinéa 1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_directe_mineur_crime_delit_contenu_page.dart",
                    "f00008",
                    " : prévoit et réprime la provocation d’un mineur à commettre un crime ou un délit.",
                  ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Élément matériel (3 éléments pédagogiques)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_directe_mineur_crime_delit_contenu_page.dart",
              "f00009",
              "II — Élément matériel",
            ),
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_directe_mineur_crime_delit_contenu_page.dart",
                  "f00010",
                  "A) Une provocation directe",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_directe_mineur_crime_delit_contenu_page.dart",
                      "f00011",
                      "La provocation visée ici doit être distinguée de la provocation constitutive de la complicité ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_directe_mineur_crime_delit_contenu_page.dart",
                      "f00012",
                      "(elle-même prévue par la loi). L’acte de provocation n’étant pas défini, il peut prendre différentes formes.",
                    ),
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_directe_mineur_crime_delit_contenu_page.dart",
                        "f00013",
                        "Pour être répréhensible, la provocation doit être directe : elle doit tendre à la commission de faits précisément désignés par la loi. ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_directe_mineur_crime_delit_contenu_page.dart",
                        "f00014",
                        "Il faut donc une relation précise et incontestable, ainsi qu’un lien étroit, entre la provocation et les faits visés. ",
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_directe_mineur_crime_delit_contenu_page.dart",
                    "f00015",
                    "Une simple suggestion ou un simple conseil est insuffisant.",
                  ),
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
              ]),
              const SizedBox(height: 12),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_directe_mineur_crime_delit_contenu_page.dart",
                  "f00016",
                  "À ne pas confondre",
                ),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_directe_mineur_crime_delit_contenu_page.dart",
                          "f00017",
                          "La provocation directe s’oppose à l’apologie, la propagande ou la simple publicité : ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_directe_mineur_crime_delit_contenu_page.dart",
                          "f00018",
                          "ces comportements peuvent présenter l’infraction sous un jour favorable sans inciter directement à la commettre.",
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_directe_mineur_crime_delit_contenu_page.dart",
                  "f00019",
                  "Il importe peu que la provocation ait été suivie d’effet : l’infraction peut être constituée même si le mineur ne passe pas à l’acte.",
                ),
              ),
              const SizedBox(height: 12),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_directe_mineur_crime_delit_contenu_page.dart",
                    "f00020",
                    "La provocation n’a pas nécessairement à s’adresser à une personne déterminée : la provocation commise par voie de presse est également envisagée par la loi. ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_directe_mineur_crime_delit_contenu_page.dart",
                    "f00021",
                    "(ex. diffusion publique)",
                  ),
                  style: TextStyle(
                    color: isDark ? Colors.white70 : const Color(0xFF616161),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ]),
              const SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_directe_mineur_crime_delit_contenu_page.dart",
                  "f00022",
                  "B) Adressée à un mineur",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_directe_mineur_crime_delit_contenu_page.dart",
                      "f00023",
                      "La provocation doit viser un mineur, quel que soit son âge. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_directe_mineur_crime_delit_contenu_page.dart",
                      "f00024",
                      "À noter : lorsqu’elle est adressée à un mineur de 15 ans, il s’agit d’une circonstance aggravante.",
                    ),
              ),
              const SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_directe_mineur_crime_delit_contenu_page.dart",
                  "f00025",
                  "C) À la commission d’un crime ou d’un délit",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_directe_mineur_crime_delit_contenu_page.dart",
                      "f00026",
                      "L’objet de la provocation doit être la commission d’un crime ou d’un délit : ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_directe_mineur_crime_delit_contenu_page.dart",
                      "f00027",
                      "la provocation à commettre une contravention n’est pas visée.",
                    ),
              ),
              const SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_directe_mineur_crime_delit_contenu_page.dart",
                      "f00028",
                      "La nature du crime ou du délit importe peu, mais la provocation doit porter sur une ou plusieurs infractions déterminées. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_directe_mineur_crime_delit_contenu_page.dart",
                      "f00029",
                      "Une incitation générale à la délinquance ne suffit pas.",
                    ),
              ),
              const SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_directe_mineur_crime_delit_contenu_page.dart",
                  "f00030",
                  "La condition d’habitude n’est plus requise : la provocation à la commission d’un acte unique, criminel ou délictuel, suffit à caractériser l’infraction.",
                ),
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_directe_mineur_crime_delit_contenu_page.dart",
                          "f00031",
                          "Important : la loi vise surtout la manipulation d’un mineur par un adulte, ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_directe_mineur_crime_delit_contenu_page.dart",
                          "f00032",
                          "mais aucun âge n’est exigé pour l’auteur : la provocation peut donc être le fait d’un majeur comme d’un mineur.",
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
              "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_directe_mineur_crime_delit_contenu_page.dart",
              "f00033",
              "III — Élément moral",
            ),
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_directe_mineur_crime_delit_contenu_page.dart",
                  "f00034",
                  "Conscience de provoquer un mineur à commettre un crime ou un délit",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_directe_mineur_crime_delit_contenu_page.dart",
                      "f00035",
                      "Cette infraction est intentionnelle : l’auteur doit avoir conscience que ses agissements ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_directe_mineur_crime_delit_contenu_page.dart",
                      "f00036",
                      "sont de nature à inciter un ou plusieurs mineurs à commettre des crimes ou des délits.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Circonstances aggravantes
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_directe_mineur_crime_delit_contenu_page.dart",
              "f00037",
              "IV — Circonstances aggravantes",
            ),
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_directe_mineur_crime_delit_contenu_page.dart",
                    "f00038",
                    "Article 227-21 alinéa 2 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " :"),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_directe_mineur_crime_delit_contenu_page.dart",
                  "f00039",
                  "Lorsque la provocation est adressée à un mineur de quinze ans.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_directe_mineur_crime_delit_contenu_page.dart",
                  "f00040",
                  "Lorsque le mineur est provoqué à commettre habituellement des crimes ou délits.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_directe_mineur_crime_delit_contenu_page.dart",
                  "f00041",
                  "Lorsque la provocation est commise dans des établissements d’enseignement ou d’éducation, ou dans les locaux de l’administration, ainsi que lors des entrées/sorties ou à proximité immédiate.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Répression + tentative/complicité
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_directe_mineur_crime_delit_contenu_page.dart",
              "f00042",
              "V — Répression",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_directe_mineur_crime_delit_contenu_page.dart",
                  "f00043",
                  "Peines encourues — personnes physiques",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_directe_mineur_crime_delit_contenu_page.dart",
                    "f00044",
                    "Qualification simple : ",
                  ),
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_directe_mineur_crime_delit_contenu_page.dart",
                    "f00045",
                    "5 ans d’emprisonnement et 150 000 € d’amende — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_directe_mineur_crime_delit_contenu_page.dart",
                    "f00046",
                    "article 227-21 alinéa 1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_directe_mineur_crime_delit_contenu_page.dart",
                    "f00047",
                    "Qualification aggravée : ",
                  ),
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_directe_mineur_crime_delit_contenu_page.dart",
                    "f00048",
                    "7 ans d’emprisonnement et 150 000 € d’amende — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_directe_mineur_crime_delit_contenu_page.dart",
                    "f00049",
                    "article 227-21 alinéa 2 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_directe_mineur_crime_delit_contenu_page.dart",
                  "f00050",
                  "Personnes morales",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_directe_mineur_crime_delit_contenu_page.dart",
                    "f00051",
                    "Responsabilité pénale prévue par ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_directe_mineur_crime_delit_contenu_page.dart",
                    "f00052",
                    "l’article 227-28-1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_directe_mineur_crime_delit_contenu_page.dart",
                    "f00053",
                    " (amendes selon ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_directe_mineur_crime_delit_contenu_page.dart",
                    "f00054",
                    "l’article 131-38 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_directe_mineur_crime_delit_contenu_page.dart",
                    "f00055",
                    " + peines complémentaires de ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_directe_mineur_crime_delit_contenu_page.dart",
                    "f00056",
                    "l’article 131-39 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: ")."),
              ]),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_directe_mineur_crime_delit_contenu_page.dart",
                  "f00057",
                  "Tentative & complicité",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_directe_mineur_crime_delit_contenu_page.dart",
                  "f00058",
                  "Tentative : NON (non punissable).",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_directe_mineur_crime_delit_contenu_page.dart",
                    "f00059",
                    "Complicité : OUI, conformément à ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_directe_mineur_crime_delit_contenu_page.dart",
                    "f00060",
                    "l’article 121-7 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_directe_mineur_crime_delit_contenu_page.dart",
                    "f00061",
                    " (aide et assistance, provocation, instructions données).",
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
