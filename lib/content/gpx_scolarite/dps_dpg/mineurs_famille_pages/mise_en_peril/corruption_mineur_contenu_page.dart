import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class CorruptionMineurPage extends StatelessWidget {
  const CorruptionMineurPage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/mineurs_famille_pages/mise_en_peril/corruption_mineur';

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
            "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/corruption_mineur_contenu_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/corruption_mineur_contenu_page.dart",
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
              "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/corruption_mineur_contenu_page.dart",
              "f00003",
              "La corruption de mineur",
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Définition / infractions
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/corruption_mineur_contenu_page.dart",
              "f00004",
              "Constituent des infractions",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/corruption_mineur_contenu_page.dart",
                  "f00005",
                  "Le fait de favoriser ou de tenter de favoriser la corruption d’un mineur.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/corruption_mineur_contenu_page.dart",
                  "f00006",
                  "Le fait, commis par un majeur, d’organiser des réunions comportant des exhibitions ou des relations sexuelles auxquelles un mineur assiste ou participe, ou d’assister en connaissance de cause à de telles réunions.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/corruption_mineur_contenu_page.dart",
              "f00007",
              "I — Élément légal",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/corruption_mineur_contenu_page.dart",
                    "f00008",
                    "Article 227-22 alinéas 1 et 2 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/corruption_mineur_contenu_page.dart",
                    "f00009",
                    " : prévoit et réprime la corruption de mineur.",
                  ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Élément matériel : rendu pédagogique en 3 éléments + structure clean
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/corruption_mineur_contenu_page.dart",
              "f00010",
              "II — Élément matériel",
            ),
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/corruption_mineur_contenu_page.dart",
                  "f00011",
                  "A) Un auteur des faits",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/corruption_mineur_contenu_page.dart",
                      "f00012",
                      "L’alinéa 2 vise expressément un auteur majeur dans un cas particulier. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/corruption_mineur_contenu_page.dart",
                      "f00013",
                      "Mais l’alinéa 1, qui pose l’incrimination de façon générale, ne fixe aucune condition d’âge : ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/corruption_mineur_contenu_page.dart",
                      "f00014",
                      "l’auteur peut donc être un majeur comme un mineur.",
                    ),
              ),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/corruption_mineur_contenu_page.dart",
                  "f00015",
                  "B) Une victime mineure",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/corruption_mineur_contenu_page.dart",
                      "f00016",
                      "La victime doit être un mineur de moins de 18 ans, de l’un ou l’autre sexe, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/corruption_mineur_contenu_page.dart",
                      "f00017",
                      "quelle que soit sa moralité. Le consentement du mineur est indifférent.",
                    ),
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/corruption_mineur_contenu_page.dart",
                  "f00018",
                  "La minorité de 15 ans constitue une circonstance aggravante.",
                ),
              ),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/corruption_mineur_contenu_page.dart",
                  "f00019",
                  "C) Un acte de corruption",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/corruption_mineur_contenu_page.dart",
                      "f00020",
                      "Il s’agit de tout acte visant à éveiller ou exciter la dépravation sexuelle chez un mineur, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/corruption_mineur_contenu_page.dart",
                      "f00021",
                      "ou à l’aider à se procurer les moyens de satisfaire ses pulsions dépravées.",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/corruption_mineur_contenu_page.dart",
                      "f00022",
                      "De simples propos obscènes ou de simples conseils sont insuffisants : ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/corruption_mineur_contenu_page.dart",
                      "f00023",
                      "il faut des conseils persistants et précis, ou un acte matériel à caractère obscène. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/corruption_mineur_contenu_page.dart",
                      "f00024",
                      "Si le caractère obscène fait défaut, l’infraction n’est pas caractérisée.",
                    ),
              ),

              SizedBox(height: 12),

              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/corruption_mineur_contenu_page.dart",
                  "f00025",
                  "Jurisprudence",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/corruption_mineur_contenu_page.dart",
                      "f00026",
                      "Un photographe se masturbant devant une jeune fille censée poser pour lui ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/corruption_mineur_contenu_page.dart",
                      "f00027",
                      "(Cass. crim., février 1995)",
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
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/corruption_mineur_contenu_page.dart",
                  "f00028",
                  "Jurisprudence",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/corruption_mineur_contenu_page.dart",
                      "f00029",
                      "Envoi de textes et dessins pornographiques à un mineur afin de provoquer sa libido ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/corruption_mineur_contenu_page.dart",
                      "f00030",
                      "(Cass. crim., 25 janvier 1983)",
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

              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/corruption_mineur_contenu_page.dart",
                      "f00031",
                      "Il n’est pas nécessaire d’établir que l’attitude de l’auteur a effectivement troublé le mineur, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/corruption_mineur_contenu_page.dart",
                      "f00032",
                      "ni que celui-ci se soit livré ensuite à un acte sexuel ou à connotation sexuelle.",
                    ),
              ),

              SizedBox(height: 14),

              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/corruption_mineur_contenu_page.dart",
                    "f00033",
                    "Focus : ",
                  ),
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/corruption_mineur_contenu_page.dart",
                    "f00034",
                    "l’alinéa 2 prévoit expressément un cas de corruption : pour un majeur, le fait ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/corruption_mineur_contenu_page.dart",
                    "f00035",
                    "d’organiser",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/corruption_mineur_contenu_page.dart",
                    "f00036",
                    " des réunions comportant des exhibitions ou des relations sexuelles auxquelles un mineur assiste/participe, ou ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/corruption_mineur_contenu_page.dart",
                    "f00037",
                    "d’assister",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/corruption_mineur_contenu_page.dart",
                    "f00038",
                    " en connaissance de cause à de telles réunions.",
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/corruption_mineur_contenu_page.dart",
                      "f00039",
                      "Il s’agit de « parties » d’un genre particulier (sexualité de groupe, spectacles pornographiques). ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/corruption_mineur_contenu_page.dart",
                      "f00040",
                      "Le caractère dépravant est constant : ces faits entrent dans le champ de la corruption de mineur.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Élément moral
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/corruption_mineur_contenu_page.dart",
              "f00041",
              "III — Élément moral",
            ),
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/corruption_mineur_contenu_page.dart",
                  "f00042",
                  "Conscience de l’obscénité et connaissance de l’âge",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/corruption_mineur_contenu_page.dart",
                      "f00043",
                      "Il s’agit d’une infraction intentionnelle : l’auteur doit avoir conscience du caractère obscène ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/corruption_mineur_contenu_page.dart",
                      "f00044",
                      "de son acte et connaître l’âge (minorité) de la victime.",
                    ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/corruption_mineur_contenu_page.dart",
                  "f00045",
                  "Volonté de corrompre la victime",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/corruption_mineur_contenu_page.dart",
                      "f00046",
                      "L’auteur doit avoir eu la volonté de corrompre le mineur, de l’inciter à se dépraver. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/corruption_mineur_contenu_page.dart",
                      "f00047",
                      "Cette intention se déduit des circonstances.",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/corruption_mineur_contenu_page.dart",
                      "f00048",
                      "Si l’auteur n’avait pour but que d’assouvir ses pulsions personnelles sans chercher à dépraver le mineur, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/corruption_mineur_contenu_page.dart",
                      "f00049",
                      "l’infraction n’est pas constituée (d’autres qualifications peuvent s’appliquer : viol, agressions sexuelles, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/corruption_mineur_contenu_page.dart",
                      "f00050",
                      "atteinte sexuelle, etc.).",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Circonstances aggravantes
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/corruption_mineur_contenu_page.dart",
              "f00051",
              "IV — Circonstances aggravantes",
            ),
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/corruption_mineur_contenu_page.dart",
                    "f00052",
                    "Article 227-22 alinéa 1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " :"),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/corruption_mineur_contenu_page.dart",
                  "f00053",
                  "Lorsque le mineur a été mis en contact avec l’auteur grâce à l’utilisation, pour la diffusion de messages à destination d’un public non déterminé, d’un réseau de communications électroniques.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/corruption_mineur_contenu_page.dart",
                  "f00054",
                  "Lorsque les faits sont commis dans un établissement d’enseignement/d’éducation ou dans les locaux de l’administration (ou aux abords lors des entrées/sorties, dans un temps très voisin).",
                ),
              ),
              SizedBox(height: 12),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/corruption_mineur_contenu_page.dart",
                    "f00055",
                    "Article 227-22 alinéa 3 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " :"),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/corruption_mineur_contenu_page.dart",
                  "f00056",
                  "Lorsque le mineur est âgé de moins de quinze ans.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/corruption_mineur_contenu_page.dart",
                  "f00057",
                  "Lorsque les faits sont commis en bande organisée.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Répression + tentative/complicité
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/corruption_mineur_contenu_page.dart",
              "f00058",
              "V — Répression",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/corruption_mineur_contenu_page.dart",
                  "f00059",
                  "Peines encourues — personnes physiques",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/corruption_mineur_contenu_page.dart",
                    "f00060",
                    "Qualification simple : ",
                  ),
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/corruption_mineur_contenu_page.dart",
                    "f00061",
                    "5 ans d’emprisonnement et 75 000 € d’amende — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/corruption_mineur_contenu_page.dart",
                    "f00062",
                    "article 227-22 alinéa 1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/corruption_mineur_contenu_page.dart",
                    "f00063",
                    "Cas visé (réunions sexuelles) : ",
                  ),
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/corruption_mineur_contenu_page.dart",
                    "f00064",
                    "7 ans d’emprisonnement et 100 000 € d’amende — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/corruption_mineur_contenu_page.dart",
                    "f00065",
                    "article 227-22 alinéa 2 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/corruption_mineur_contenu_page.dart",
                    "f00066",
                    "Aggravée (alinéa 1) : ",
                  ),
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/corruption_mineur_contenu_page.dart",
                    "f00067",
                    "10 ans d’emprisonnement et 150 000 € d’amende — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/corruption_mineur_contenu_page.dart",
                    "f00068",
                    "article 227-22 alinéa 1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/corruption_mineur_contenu_page.dart",
                    "f00069",
                    "Aggravée (moins de 15 ans / bande organisée) : ",
                  ),
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/corruption_mineur_contenu_page.dart",
                    "f00070",
                    "10 ans d’emprisonnement et 1 000 000 € d’amende — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/corruption_mineur_contenu_page.dart",
                    "f00071",
                    "article 227-22 alinéa 3 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),

              SizedBox(height: 12),

              _NotaBox(
                title: "NOTA",
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/corruption_mineur_contenu_page.dart",
                      "f00072",
                      "Lorsque l’infraction est commise à l’étranger par un Français (ou une personne résidant habituellement en France), la loi française peut s’appliquer sans plainte de la victime ni dénonciation officielle : ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/corruption_mineur_contenu_page.dart",
                      "f00073",
                      "article 227-27-1 du Code pénal",
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
                  "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/corruption_mineur_contenu_page.dart",
                  "f00074",
                  "Personnes morales",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/corruption_mineur_contenu_page.dart",
                    "f00075",
                    "Responsabilité pénale prévue expressément : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/corruption_mineur_contenu_page.dart",
                    "f00076",
                    "article 227-28-1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/corruption_mineur_contenu_page.dart",
                    "f00077",
                    " (amende selon l’article 131-38 et peines complémentaires visées à l’article 131-39).",
                  ),
                ),
              ]),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/corruption_mineur_contenu_page.dart",
                  "f00078",
                  "Tentative & complicité",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/corruption_mineur_contenu_page.dart",
                    "f00079",
                    "Tentative : ",
                  ),
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/corruption_mineur_contenu_page.dart",
                    "f00080",
                    "OUI — prévue expressément à l’alinéa 1 de ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/corruption_mineur_contenu_page.dart",
                    "f00081",
                    "l’article 227-22 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/corruption_mineur_contenu_page.dart",
                    "f00082",
                    "Complicité : ",
                  ),
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/corruption_mineur_contenu_page.dart",
                    "f00083",
                    "OUI — conformément à ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/corruption_mineur_contenu_page.dart",
                    "f00084",
                    "l’article 121-7 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/corruption_mineur_contenu_page.dart",
                    "f00085",
                    " (aide/assistance, provocation, instructions).",
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
