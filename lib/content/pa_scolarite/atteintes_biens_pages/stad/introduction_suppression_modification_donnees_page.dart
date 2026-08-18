import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PaIntroductionSuppressionModificationDonneesPage extends StatelessWidget {
  const PaIntroductionSuppressionModificationDonneesPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/atteintes_biens/stad/introduction_suppression_modification_donnees';

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
            "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
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
              "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
              "f00003",
              "Introduction, suppression ou modification frauduleuse de données",
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
              "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
              "f00004",
              "Définition",
            ),
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
                      "f00005",
                      "Le fait d’introduire frauduleusement des données dans un système de traitement automatisé, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
                      "f00006",
                      "d’extraire, de détenir, de reproduire, de transmettre, de supprimer ou de modifier frauduleusement ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
                      "f00007",
                      "les données qu’il contient constitue une infraction.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
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
                    "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
                    "f00009",
                    "Article 323-3 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
                        "f00010",
                        " : définit et réprime l’introduction, l’extraction, la détention, la reproduction, la transmission, ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
                        "f00011",
                        "la suppression ou la modification frauduleuse de données contenues dans un système de traitement automatisé de données.",
                      ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Élément matériel
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
              "f00012",
              "II — Élément matériel",
            ),
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
                  "f00013",
                  "A) Une action sur des données contenues dans le système",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
                      "f00014",
                      "L’action doit porter sur les données contenues dans le système. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
                      "f00015",
                      "Peu importe que le système soit finalisé ou en cours d’élaboration.",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
                      "f00016",
                      "Jurisprudence : système en cours d’élaboration — ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
                      "f00017",
                      "Cass. crim., 05 janvier 1994",
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
                      "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
                      "f00018",
                      "L’auteur peut avoir eu un accès licite ou non au système. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
                      "f00019",
                      "Il importe peu également que l’action ne crée aucune perturbation apparente ou immédiate du fonctionnement.",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
                  "f00020",
                  "Terme courant",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
                      "f00021",
                      "Dans la pratique, cette forme de piratage informatique est souvent appelée « cracking ».",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
                      "f00022",
                      "Il est admis que l’action sur des données sorties d’un système ne tombe pas sous le coup de la loi ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
                      "f00023",
                      "(ex. manipulation de données sur un support externe : clé USB, disque dur, CD-ROM…). ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
                      "f00024",
                      "En revanche, si ces données sont réintroduites dans le système, l’incrimination peut s’appliquer.",
                    ),
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
                  "f00025",
                  "B) Les pratiques incriminées",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
                      "f00026",
                      "L’article 323-3 vise plusieurs comportements distincts. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
                      "f00027",
                      "La jurisprudence incrimine l’action illicite qui porte directement sur les données, ou qui les atteint ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
                      "f00028",
                      "à travers leur mode de traitement ou de transmission.",
                    ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
                  "f00029",
                  "1) Introduction de données",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
                      "f00030",
                      "L’introduction peut être comprise comme l’incorporation de caractères informatiques nouveaux sur un support du système. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
                      "f00031",
                      "Dans la pratique, l’insertion d’un programme peut impliquer suppression/modification des données traitées, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
                      "f00032",
                      "et tombe alors dans le champ de l’article 323-3.",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
                          "f00033",
                          "L’introduction d’un logiciel espion entre dans le champ de l’incrimination (souvent appelée « sniffing »). ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
                          "f00034",
                          "Ce programme peut permettre une attaque ultérieure du système.",
                        ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
                  "f00035",
                  "Jurisprudence",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
                      "f00036",
                      "Cartes bancaires : insertion de nouvelles données destinées à tromper un terminal de paiement — ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
                      "f00037",
                      "TGI Paris, 25 février 2000",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
                  "f00038",
                  "2) Extraction de données",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
                      "f00039",
                      "L’extraction assure une protection spécifique aux données elles-mêmes : elle permet de réprimer celui ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
                      "f00040",
                      "qui effectue une simple copie tout en laissant les données à la disposition du propriétaire légitime. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
                      "f00041",
                      "L’incrimination de vol est souvent inadaptée car les données ne sont pas « soustraites ».",
                    ),
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
                  "f00042",
                  "3) Détention — Reproduction — Transmission",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
                      "f00043",
                      "• La détention peut s’apparenter à un recel de données extraites, reproduites ou transmises frauduleusement.\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
                      "f00044",
                      "• La reproduction vise les actes de copie de données obtenues frauduleusement, quel qu’en soit le support.\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
                      "f00045",
                      "• La transmission vise toute diffusion de données à un tiers, quel qu’en soit le moyen ou le support.",
                    ),
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
                  "f00046",
                  "4) Suppression — Modification",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
                      "f00047",
                      "Supprimer des données peut consister en une atteinte à l’intégrité des données (effacement, « écrasement »), ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
                      "f00048",
                      "ou encore un déplacement hors du système / vers une zone réservée.\n\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
                      "f00049",
                      "La modification correspond à une altération de l’information portée par les données.\n\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
                      "f00050",
                      "En pratique, il est difficile de séparer radicalement introduction, modification et suppression : ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
                      "f00051",
                      "modifier suppose souvent d’ajouter, retrancher ou déplacer des données.",
                    ),
              ),

              SizedBox(height: 12),

              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
                  "f00052",
                  "Jurisprudence",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
                      "f00053",
                      "Comptable ayant modifié des données enregistrées définitivement dans le système automatisé de comptabilité — ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
                      "f00054",
                      "Cass. crim., 08 décembre 1999",
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

          // Élément moral
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
              "f00055",
              "III — Élément moral",
            ),
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
                      "f00056",
                      "L’élément moral réside dans la violation délibérée d’un interdit : ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
                      "f00057",
                      "l’auteur agit en sachant que ce n’est pas autorisé et en voulant néanmoins le résultat ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
                      "f00058",
                      "(introduire, extraire, détenir, reproduire, transmettre, supprimer ou modifier frauduleusement).",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Circonstances aggravantes
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
              "f00059",
              "IV — Circonstances aggravantes",
            ),
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
                    "f00060",
                    "Article 323-3 alinéa 2 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
                        "f00061",
                        " : lorsque l’infraction est commise à l’encontre d’un système de traitement automatisé de données ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
                        "f00062",
                        "à caractère personnel mis en œuvre par l’État.",
                      ),
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
                    "f00063",
                    "Article 323-4-1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
                    "f00064",
                    " : lorsque l’infraction est commise en bande organisée.",
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
                    "f00065",
                    "Article 323-4-2 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
                        "f00066",
                        " : lorsque l’infraction expose autrui à un risque immédiat de mort ou de blessures graves, ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
                        "f00067",
                        "ou fait obstacle aux secours destinés à faire échapper une personne à un péril imminent ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
                        "f00068",
                        "ou à combattre un sinistre présentant un danger pour la sécurité des personnes.",
                      ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Répression + tentative/complicité
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
              "f00069",
              "V — Répression",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
                  "f00070",
                  "Peines encourues — personnes physiques",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
                    "f00071",
                    "Qualification simple : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
                    "f00072",
                    "5 ans d’emprisonnement et 150 000 € d’amende. — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
                    "f00073",
                    "article 323-3 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
                    "f00074",
                    "Aggravée (STAD personnel mis en œuvre par l’État) : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
                    "f00075",
                    "7 ans d’emprisonnement et 300 000 € d’amende. — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
                    "f00076",
                    "article 323-3 alinéa 2 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
                    "f00077",
                    "Aggravée (bande organisée) : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
                    "f00078",
                    "7 ans d’emprisonnement et 300 000 € d’amende. — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
                    "f00079",
                    "article 323-4-1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
                    "f00080",
                    "Aggravée (risque immédiat / obstacle aux secours) : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
                    "f00081",
                    "10 ans d’emprisonnement et 300 000 € d’amende. — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
                    "f00082",
                    "article 323-4-2 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
                  "f00083",
                  "Personnes morales",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
                    "f00084",
                    "Responsabilité pénale prévue par ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
                    "f00085",
                    "l’article 323-6 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
                    "f00086",
                    ", avec amende selon ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
                    "f00087",
                    "l’article 131-38 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
                    "f00088",
                    " et peines prévues par ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
                    "f00089",
                    "l’article 131-39 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
                          "f00090",
                          "L’interdiction mentionnée au 2° de l’article 131-39 porte sur l’activité dans l’exercice ou à l’occasion ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
                          "f00091",
                          "de l’exercice de laquelle l’infraction a été commise.",
                        ),
                  ),
                ],
              ),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
                  "f00092",
                  "Tentative & complicité",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
                  "f00093",
                  "Tentative : OUI — spécialement prévue et réprimée par l’article 323-7 du Code pénal.",
                ),
              ),
              SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
                      "f00094",
                      "Comme pour toute tentative : commencement d’exécution et absence de résultat en raison de circonstances ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
                      "f00095",
                      "indépendantes de la volonté de l’auteur.",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
                    "f00096",
                    "Complicité : OUI — conformément à ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
                    "f00097",
                    "l’article 121-7 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart",
                    "f00098",
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
