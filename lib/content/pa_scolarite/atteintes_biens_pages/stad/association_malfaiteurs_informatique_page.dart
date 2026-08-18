import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PaAssociationMalfaiteursInformatiquePage extends StatelessWidget {
  const PaAssociationMalfaiteursInformatiquePage({super.key});

  static const String routeName =
      '/pa/dps_dpg/atteintes_biens/stad/association_malfaiteurs_informatique';

  static const Color _lawRed = Color(0xFFE53935);

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
        ? const Color(0xFF222224)
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
            "lib/content/pa_scolarite/atteintes_biens_pages/stad/association_malfaiteurs_informatique_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/atteintes_biens_pages/stad/association_malfaiteurs_informatique_page.dart",
            "f00002",
            "Atteintes aux STAD",
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
              "lib/content/pa_scolarite/atteintes_biens_pages/stad/association_malfaiteurs_informatique_page.dart",
              "f00003",
              "L’association de malfaiteurs en informatique",
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
              "lib/content/pa_scolarite/atteintes_biens_pages/stad/association_malfaiteurs_informatique_page.dart",
              "f00004",
              "Définition",
            ),
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/stad/association_malfaiteurs_informatique_page.dart",
                      "f00005",
                      "La participation à un groupement formé ou à une entente établie en vue de la préparation, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/stad/association_malfaiteurs_informatique_page.dart",
                      "f00006",
                      "caractérisée par un ou plusieurs faits matériels, d'une ou de plusieurs infractions prévues ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/stad/association_malfaiteurs_informatique_page.dart",
                      "f00007",
                      "par les articles 323-1 à 323-3-1 du Code pénal, constitue une infraction.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/atteintes_biens_pages/stad/association_malfaiteurs_informatique_page.dart",
              "f00008",
              "I — Élément légal",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/stad/association_malfaiteurs_informatique_page.dart",
                    "f00009",
                    "Article 323-4 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/stad/association_malfaiteurs_informatique_page.dart",
                    "f00010",
                    " : définit et réprime l’association de malfaiteurs en informatique.",
                  ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Élément matériel
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/atteintes_biens_pages/stad/association_malfaiteurs_informatique_page.dart",
              "f00011",
              "II — Élément matériel",
            ),
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_biens_pages/stad/association_malfaiteurs_informatique_page.dart",
                  "f00012",
                  "A) Un groupement ou une entente",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/stad/association_malfaiteurs_informatique_page.dart",
                      "f00013",
                      "La loi ne définit ni le groupement, ni l’entente. L’objectif est de permettre une défense avancée ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/stad/association_malfaiteurs_informatique_page.dart",
                      "f00014",
                      "des systèmes contre le danger que représentent certains « clubs »/« hackers » mettant en commun ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/stad/association_malfaiteurs_informatique_page.dart",
                      "f00015",
                      "leurs connaissances pour commettre des délits informatiques.",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/stad/association_malfaiteurs_informatique_page.dart",
                      "f00016",
                      "Le nombre de participants importe peu : l’entente a même été retenue pour deux personnes. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/stad/association_malfaiteurs_informatique_page.dart",
                      "f00017",
                      "Il peut s’agir de personnes physiques comme de personnes morales.",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/stad/association_malfaiteurs_informatique_page.dart",
                      "f00018",
                      "Jurisprudence : entente retenue pour deux personnes ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/stad/association_malfaiteurs_informatique_page.dart",
                      "f00019",
                      "(Tr. corr. Limoges, 14 mars 1994)",
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
                      "lib/content/pa_scolarite/atteintes_biens_pages/stad/association_malfaiteurs_informatique_page.dart",
                      "f00020",
                      "Il n’est pas nécessaire que le groupement ait été formé à l’origine pour préparer des délits informatiques. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/stad/association_malfaiteurs_informatique_page.dart",
                      "f00021",
                      "Si une association régulièrement déclarée dérive vers la délinquance informatique, seuls ceux qui continuent ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/stad/association_malfaiteurs_informatique_page.dart",
                      "f00022",
                      "à y participer peuvent tomber sous le coup de la loi.",
                    ),
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_biens_pages/stad/association_malfaiteurs_informatique_page.dart",
                  "f00023",
                  "B) La préparation d’une ou plusieurs infractions",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/stad/association_malfaiteurs_informatique_page.dart",
                      "f00024",
                      "La préparation se situe en amont de la commission. La participation à l’entente doit se concrétiser ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/stad/association_malfaiteurs_informatique_page.dart",
                      "f00025",
                      "par un ou plusieurs faits matériels.",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/stad/association_malfaiteurs_informatique_page.dart",
                      "f00026",
                      "Sont notamment visés : échanges d’informations sur les modes opératoires (communication de codes d’accès, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/stad/association_malfaiteurs_informatique_page.dart",
                      "f00027",
                      "moyens utilisés pour « casser » un code, méthodes techniques, etc.).",
                    ),
              ),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_biens_pages/stad/association_malfaiteurs_informatique_page.dart",
                  "f00028",
                  "C) Les infractions visées",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_biens_pages/stad/association_malfaiteurs_informatique_page.dart",
                  "f00029",
                  "Les infractions préparées doivent relever des atteintes aux STAD visées par le Code pénal :",
                ),
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_biens_pages/stad/association_malfaiteurs_informatique_page.dart",
                  "f00030",
                  "Accès ou maintien frauduleux dans un système de traitement automatisé de données.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_biens_pages/stad/association_malfaiteurs_informatique_page.dart",
                  "f00031",
                  "Entrave au fonctionnement d’un système de traitement automatisé de données.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_biens_pages/stad/association_malfaiteurs_informatique_page.dart",
                  "f00032",
                  "Introduction, extraction, détention, reproduction, transmission, suppression ou modification frauduleuse de données.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_biens_pages/stad/association_malfaiteurs_informatique_page.dart",
                  "f00033",
                  "Importation, détention, offre, cession ou mise à disposition de données adaptées/conçues pour commettre des infractions d’atteintes aux STAD.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Élément moral
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/atteintes_biens_pages/stad/association_malfaiteurs_informatique_page.dart",
              "f00034",
              "III — Élément moral",
            ),
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/stad/association_malfaiteurs_informatique_page.dart",
                      "f00035",
                      "Le délit suppose une participation volontaire au groupement ou à l’entente. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/stad/association_malfaiteurs_informatique_page.dart",
                      "f00036",
                      "L’auteur doit avoir conscience qu’au sein de cette structure se préparait une ou plusieurs infractions ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/stad/association_malfaiteurs_informatique_page.dart",
                      "f00037",
                      "d’atteinte au système de traitement automatisé de données.",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/stad/association_malfaiteurs_informatique_page.dart",
                      "f00038",
                      "Jurisprudence : il n’est pas nécessaire que chaque membre soit au courant de toutes les activités des autres membres ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/stad/association_malfaiteurs_informatique_page.dart",
                      "f00039",
                      "(C.A. Aix, 02 juin 1993)",
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

          // Circonstances aggravantes
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/atteintes_biens_pages/stad/association_malfaiteurs_informatique_page.dart",
              "f00040",
              "IV — Circonstances aggravantes",
            ),
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/stad/association_malfaiteurs_informatique_page.dart",
                      "f00041",
                      "L’infraction définie à l’association de malfaiteurs en informatique est punie des peines prévues ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/stad/association_malfaiteurs_informatique_page.dart",
                      "f00042",
                      "respectivement pour l’infraction elle-même ou pour l’infraction la plus sévèrement réprimée.",
                    ),
              ),
              SizedBox(height: 10),

              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/stad/association_malfaiteurs_informatique_page.dart",
                    "f00043",
                    "Article 323-4 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/stad/association_malfaiteurs_informatique_page.dart",
                    "f00044",
                    " : mécanisme de renvoi aux peines de l’infraction préparée (ou la plus sévère).",
                  ),
                ),
              ]),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_biens_pages/stad/association_malfaiteurs_informatique_page.dart",
                  "f00045",
                  "Renvois (exemples)",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/stad/association_malfaiteurs_informatique_page.dart",
                    "f00046",
                    "Article 323-1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/stad/association_malfaiteurs_informatique_page.dart",
                    "f00047",
                    " : aggravations si suppression/modification de données ou altération du fonctionnement, ou si STAD à caractère personnel mis en œuvre par l’État.",
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/stad/association_malfaiteurs_informatique_page.dart",
                    "f00048",
                    "Article 323-2 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/stad/association_malfaiteurs_informatique_page.dart",
                    "f00049",
                    " : aggravation si STAD à caractère personnel mis en œuvre par l’État.",
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/stad/association_malfaiteurs_informatique_page.dart",
                    "f00050",
                    "Article 323-3 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/stad/association_malfaiteurs_informatique_page.dart",
                    "f00051",
                    " : aggravation si STAD à caractère personnel mis en œuvre par l’État.",
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/stad/association_malfaiteurs_informatique_page.dart",
                    "f00052",
                    "Article 323-3-1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/stad/association_malfaiteurs_informatique_page.dart",
                    "f00053",
                    " : reprend le même mécanisme répressif que l’article 323-4 (renvoi à l’infraction la plus sévère).",
                  ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Répression + tentative/complicité
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/atteintes_biens_pages/stad/association_malfaiteurs_informatique_page.dart",
              "f00054",
              "V — Répression",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_biens_pages/stad/association_malfaiteurs_informatique_page.dart",
                  "f00055",
                  "Principe (peines variables)",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_biens_pages/stad/association_malfaiteurs_informatique_page.dart",
                  "f00056",
                  "En cas de pluralité d’infractions préparées, la peine retenue est celle de l’infraction la plus sévèrement réprimée.",
                ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_biens_pages/stad/association_malfaiteurs_informatique_page.dart",
                  "f00057",
                  "Repères usuels (selon l’infraction préparée)",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/stad/association_malfaiteurs_informatique_page.dart",
                    "f00058",
                    "Base (ex. ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/stad/association_malfaiteurs_informatique_page.dart",
                    "f00059",
                    "article 323-1 alinéa 1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: ") : "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/stad/association_malfaiteurs_informatique_page.dart",
                    "f00060",
                    "3 ans d’emprisonnement et 100 000 € d’amende.",
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/stad/association_malfaiteurs_informatique_page.dart",
                    "f00061",
                    "Aggravations possibles (ex. ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/stad/association_malfaiteurs_informatique_page.dart",
                    "f00062",
                    "article 323-1 alinéa 2 et 3 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: ") : "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/stad/association_malfaiteurs_informatique_page.dart",
                    "f00063",
                    "jusqu’à 5 ans / 150 000 € puis 7 ans / 300 000 € selon les cas.",
                  ),
                ),
              ]),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_biens_pages/stad/association_malfaiteurs_informatique_page.dart",
                  "f00064",
                  "Personnes morales",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/stad/association_malfaiteurs_informatique_page.dart",
                    "f00065",
                    "Responsabilité pénale prévue par ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/stad/association_malfaiteurs_informatique_page.dart",
                    "f00066",
                    "l’article 323-6 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/stad/association_malfaiteurs_informatique_page.dart",
                    "f00067",
                    " (amende selon l’article 131-38 et peines de l’article 131-39 ; interdiction d’activité liée à l’infraction).",
                  ),
                ),
              ]),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_biens_pages/stad/association_malfaiteurs_informatique_page.dart",
                  "f00068",
                  "Tentative & complicité",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_biens_pages/stad/association_malfaiteurs_informatique_page.dart",
                  "f00069",
                  "Tentative : NON (non prévue).",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/stad/association_malfaiteurs_informatique_page.dart",
                    "f00070",
                    "Complicité : OUI — conformément à ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/stad/association_malfaiteurs_informatique_page.dart",
                    "f00071",
                    "l’article 121-7 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/stad/association_malfaiteurs_informatique_page.dart",
                    "f00072",
                    " (aide et assistance, provocation ou instructions données).",
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
  const _NotaBox({required this.bodySpans});

  final List<TextSpan> bodySpans;
  final String title = 'NOTA';

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
