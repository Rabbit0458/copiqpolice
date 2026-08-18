import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PaTagsInscriptionsSignesDessinsPage extends StatelessWidget {
  const PaTagsInscriptionsSignesDessinsPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/atteintes_biens/destructions_degradations/tags_inscriptions_signes_dessins';

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
            "lib/content/pa_scolarite/atteintes_biens_pages/destructions_degradations/tags_inscriptions_signes_dessins_contenu_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/atteintes_biens_pages/destructions_degradations/tags_inscriptions_signes_dessins_contenu_page.dart",
            "f00002",
            "Destructions / Dégradations",
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
              "lib/content/pa_scolarite/atteintes_biens_pages/destructions_degradations/tags_inscriptions_signes_dessins_contenu_page.dart",
              "f00003",
              "Destructions, dégradations et détériorations par inscriptions, signes et dessins\ncommunément appelés « tags »",
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
              "lib/content/pa_scolarite/atteintes_biens_pages/destructions_degradations/tags_inscriptions_signes_dessins_contenu_page.dart",
              "f00004",
              "Définition",
            ),
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/destructions_degradations/tags_inscriptions_signes_dessins_contenu_page.dart",
                      "f00005",
                      "Le fait de tracer des inscriptions, des signes ou des dessins, sans autorisation préalable, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/destructions_degradations/tags_inscriptions_signes_dessins_contenu_page.dart",
                      "f00006",
                      "sur les façades, les véhicules, les voies publiques ou le mobilier urbain, lorsqu’il n’en est ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/destructions_degradations/tags_inscriptions_signes_dessins_contenu_page.dart",
                      "f00007",
                      "résulté qu’un dommage léger, constitue une infraction.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/atteintes_biens_pages/destructions_degradations/tags_inscriptions_signes_dessins_contenu_page.dart",
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
                    "lib/content/pa_scolarite/atteintes_biens_pages/destructions_degradations/tags_inscriptions_signes_dessins_contenu_page.dart",
                    "f00009",
                    "Article 322-1 II du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/destructions_degradations/tags_inscriptions_signes_dessins_contenu_page.dart",
                    "f00010",
                    " : définit et réprime les « tags » (inscriptions, signes et dessins).",
                  ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Élément matériel
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/atteintes_biens_pages/destructions_degradations/tags_inscriptions_signes_dessins_contenu_page.dart",
              "f00011",
              "II — Élément matériel",
            ),
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/destructions_degradations/tags_inscriptions_signes_dessins_contenu_page.dart",
                      "f00012",
                      "Ce texte permet de réprimer les auteurs de graffiti (« tags »). Le dommage doit être léger : ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/destructions_degradations/tags_inscriptions_signes_dessins_contenu_page.dart",
                      "f00013",
                      "l’inscription doit pouvoir être enlevée facilement, sans altération du support.",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_biens_pages/destructions_degradations/tags_inscriptions_signes_dessins_contenu_page.dart",
                          "f00014",
                          "Si les faits occasionnent des dommages importants (ex. signes indélébiles ou altération du support), ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_biens_pages/destructions_degradations/tags_inscriptions_signes_dessins_contenu_page.dart",
                          "f00015",
                          "ils relèvent des dispositions de ",
                        ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/destructions_degradations/tags_inscriptions_signes_dessins_contenu_page.dart",
                      "f00016",
                      "l’article 322-1 I du Code pénal",
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
                  "lib/content/pa_scolarite/atteintes_biens_pages/destructions_degradations/tags_inscriptions_signes_dessins_contenu_page.dart",
                  "f00017",
                  "A) Une atteinte matérielle par traçage",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/destructions_degradations/tags_inscriptions_signes_dessins_contenu_page.dart",
                      "f00018",
                      "Il s’agit d’un acte positif de traçage. Le terme « tracer » n’ayant pas de sens technique particulier, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/destructions_degradations/tags_inscriptions_signes_dessins_contenu_page.dart",
                      "f00019",
                      "tout procédé peut être retenu : écriture, peinture, gravure…\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/destructions_degradations/tags_inscriptions_signes_dessins_contenu_page.dart",
                      "f00020",
                      "Le procédé employé ne doit toutefois pas être de nature à entraîner un dommage important.",
                    ),
              ),
              SizedBox(height: 8),
              _BulletPoint(text: "Inscriptions"),
              _BulletPoint(text: "Signes"),
              _BulletPoint(text: "Dessins"),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_biens_pages/destructions_degradations/tags_inscriptions_signes_dessins_contenu_page.dart",
                  "f00021",
                  "B) Sur un bien appartenant à autrui",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_biens_pages/destructions_degradations/tags_inscriptions_signes_dessins_contenu_page.dart",
                  "f00022",
                  "Les biens protégés sont clairement énoncés et aucune autorisation préalable ne doit avoir été donnée à l’auteur.",
                ),
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_biens_pages/destructions_degradations/tags_inscriptions_signes_dessins_contenu_page.dart",
                  "f00023",
                  "Façades",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_biens_pages/destructions_degradations/tags_inscriptions_signes_dessins_contenu_page.dart",
                  "f00024",
                  "Véhicules",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_biens_pages/destructions_degradations/tags_inscriptions_signes_dessins_contenu_page.dart",
                  "f00025",
                  "Voies publiques",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_biens_pages/destructions_degradations/tags_inscriptions_signes_dessins_contenu_page.dart",
                  "f00026",
                  "Mobilier urbain",
                ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_biens_pages/destructions_degradations/tags_inscriptions_signes_dessins_contenu_page.dart",
                  "f00027",
                  "La loi ne distingue pas selon le caractère public ou privé des façades. Il en va de même pour les véhicules.",
                ),
              ),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_biens_pages/destructions_degradations/tags_inscriptions_signes_dessins_contenu_page.dart",
                  "f00028",
                  "C) Entraînant un dommage léger",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/destructions_degradations/tags_inscriptions_signes_dessins_contenu_page.dart",
                      "f00029",
                      "Le dommage doit être léger (ex. inscription effaçable sans abîmer le crépi). ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/destructions_degradations/tags_inscriptions_signes_dessins_contenu_page.dart",
                      "f00030",
                      "Si l’inscription altère le support, le comportement relève alors du régime du dommage important.",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/destructions_degradations/tags_inscriptions_signes_dessins_contenu_page.dart",
                    "f00031",
                    "Dans ce cas, application de ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/destructions_degradations/tags_inscriptions_signes_dessins_contenu_page.dart",
                    "f00032",
                    "l’article 322-1 I du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Élément moral
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/atteintes_biens_pages/destructions_degradations/tags_inscriptions_signes_dessins_contenu_page.dart",
              "f00033",
              "III — Élément moral",
            ),
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/destructions_degradations/tags_inscriptions_signes_dessins_contenu_page.dart",
                      "f00034",
                      "Il s’agit du même élément moral que pour l’article 322-1 I : l’intention simple suffit. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/destructions_degradations/tags_inscriptions_signes_dessins_contenu_page.dart",
                      "f00035",
                      "L’auteur est punissable dès lors qu’il a agi sciemment et volontairement.",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/destructions_degradations/tags_inscriptions_signes_dessins_contenu_page.dart",
                      "f00036",
                      "Il doit avoir agi en sachant ne pas être propriétaire du bien et n’avoir aucun droit de disposition. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/destructions_degradations/tags_inscriptions_signes_dessins_contenu_page.dart",
                      "f00037",
                      "Aucun dol spécial n’est exigé : le mobile importe peu (vengeance, vandalisme, etc.).",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/destructions_degradations/tags_inscriptions_signes_dessins_contenu_page.dart",
                      "f00038",
                      "Référence jurisprudentielle : ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/destructions_degradations/tags_inscriptions_signes_dessins_contenu_page.dart",
                      "f00039",
                      "Cass. crim., 18 septembre 1991",
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
              "lib/content/pa_scolarite/atteintes_biens_pages/destructions_degradations/tags_inscriptions_signes_dessins_contenu_page.dart",
              "f00040",
              "IV — Circonstances aggravantes",
            ),
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/destructions_degradations/tags_inscriptions_signes_dessins_contenu_page.dart",
                    "f00041",
                    "Article 322-2 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/destructions_degradations/tags_inscriptions_signes_dessins_contenu_page.dart",
                    "f00042",
                    " : lorsque le bien détruit, dégradé ou détérioré est un registre, une minute ou un acte original de l’autorité publique.",
                  ),
                ),
              ]),
              SizedBox(height: 12),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/destructions_degradations/tags_inscriptions_signes_dessins_contenu_page.dart",
                    "f00043",
                    "Article 322-3 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/destructions_degradations/tags_inscriptions_signes_dessins_contenu_page.dart",
                    "f00044",
                    " : notamment lorsque :",
                  ),
                ),
              ]),
              SizedBox(height: 8),

              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_biens_pages/destructions_degradations/tags_inscriptions_signes_dessins_contenu_page.dart",
                  "f00045",
                  "L’infraction est commise par plusieurs personnes agissant en qualité d’auteur ou de complice.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_biens_pages/destructions_degradations/tags_inscriptions_signes_dessins_contenu_page.dart",
                  "f00046",
                  "Elle est facilitée par la particulière vulnérabilité d’une personne (âge, maladie, infirmité, déficience physique/psychique, grossesse), apparente ou connue.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_biens_pages/destructions_degradations/tags_inscriptions_signes_dessins_contenu_page.dart",
                  "f00047",
                  "Elle est commise au préjudice de personnes dépositaires de l’autorité publique ou chargées d’une mission de service public, pour influencer leur comportement.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_biens_pages/destructions_degradations/tags_inscriptions_signes_dessins_contenu_page.dart",
                  "f00048",
                  "Elle est commise au préjudice du conjoint/ascendant/descendant (ou personne vivant habituellement au domicile) des personnes visées ci-dessus, en raison de leurs fonctions.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_biens_pages/destructions_degradations/tags_inscriptions_signes_dessins_contenu_page.dart",
                  "f00049",
                  "Elle est commise au préjudice d’un témoin, d’une victime ou d’une partie civile, pour empêcher/faire cesser une dénonciation, plainte ou déposition, ou en raison de celles-ci.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_biens_pages/destructions_degradations/tags_inscriptions_signes_dessins_contenu_page.dart",
                  "f00050",
                  "Elle est commise dans un local d’habitation ou un lieu d’entrepôt de fonds/valeurs/marchandises/matériels, avec ruse, effraction ou escalade.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_biens_pages/destructions_degradations/tags_inscriptions_signes_dessins_contenu_page.dart",
                  "f00051",
                  "Elle est commise à l’encontre d’un lieu classifié au titre du secret de la défense nationale.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_biens_pages/destructions_degradations/tags_inscriptions_signes_dessins_contenu_page.dart",
                  "f00052",
                  "L’auteur dissimule volontairement tout ou partie de son visage afin de ne pas être identifié.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_biens_pages/destructions_degradations/tags_inscriptions_signes_dessins_contenu_page.dart",
                  "f00053",
                  "Le bien est destiné à l’utilité ou à la décoration publique et appartient à une personne publique ou chargée d’une mission de service public.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_biens_pages/destructions_degradations/tags_inscriptions_signes_dessins_contenu_page.dart",
                  "f00054",
                  "Elle porte sur du matériel destiné à prodiguer des soins de premiers secours.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_biens_pages/destructions_degradations/tags_inscriptions_signes_dessins_contenu_page.dart",
                  "f00055",
                  "Le bien détruit, dégradé ou détérioré est destiné à la vaccination.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Répression + tentative/complicité + attention flagrance/GAV
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/atteintes_biens_pages/destructions_degradations/tags_inscriptions_signes_dessins_contenu_page.dart",
              "f00056",
              "V — Répression",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_biens_pages/destructions_degradations/tags_inscriptions_signes_dessins_contenu_page.dart",
                  "f00057",
                  "Peines encourues — personnes physiques",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/destructions_degradations/tags_inscriptions_signes_dessins_contenu_page.dart",
                    "f00058",
                    "Qualification simple : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/destructions_degradations/tags_inscriptions_signes_dessins_contenu_page.dart",
                    "f00059",
                    "3 750 € d’amende + T.I.G. — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/destructions_degradations/tags_inscriptions_signes_dessins_contenu_page.dart",
                    "f00060",
                    "article 322-1 II du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/destructions_degradations/tags_inscriptions_signes_dessins_contenu_page.dart",
                    "f00061",
                    "Aggravée : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/destructions_degradations/tags_inscriptions_signes_dessins_contenu_page.dart",
                    "f00062",
                    "7 500 € d’amende + T.I.G. — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/destructions_degradations/tags_inscriptions_signes_dessins_contenu_page.dart",
                    "f00063",
                    "article 322-2 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/destructions_degradations/tags_inscriptions_signes_dessins_contenu_page.dart",
                    "f00064",
                    "Aggravée (hypothèses prévues par l’article 322-3) : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/destructions_degradations/tags_inscriptions_signes_dessins_contenu_page.dart",
                    "f00065",
                    "15 000 € d’amende + T.I.G. — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/destructions_degradations/tags_inscriptions_signes_dessins_contenu_page.dart",
                    "f00066",
                    "article 322-3 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_biens_pages/destructions_degradations/tags_inscriptions_signes_dessins_contenu_page.dart",
                  "f00067",
                  "Personnes morales",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/destructions_degradations/tags_inscriptions_signes_dessins_contenu_page.dart",
                    "f00068",
                    "Les personnes morales encourent les peines prévues par ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/destructions_degradations/tags_inscriptions_signes_dessins_contenu_page.dart",
                    "f00069",
                    "l’article 322-17 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_biens_pages/destructions_degradations/tags_inscriptions_signes_dessins_contenu_page.dart",
                  "f00070",
                  "Amende forfaitaire délictuelle",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/destructions_degradations/tags_inscriptions_signes_dessins_contenu_page.dart",
                    "f00071",
                    "Article 322-1 II du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/destructions_degradations/tags_inscriptions_signes_dessins_contenu_page.dart",
                    "f00072",
                    " : permet de recourir à la procédure d’amende forfaitaire prévue par ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/destructions_degradations/tags_inscriptions_signes_dessins_contenu_page.dart",
                    "f00073",
                    "les articles 495-17 à 495-25 du Code de procédure pénale",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/destructions_degradations/tags_inscriptions_signes_dessins_contenu_page.dart",
                    "f00074",
                    ", y compris en cas de récidive.",
                  ),
                ),
              ]),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_biens_pages/destructions_degradations/tags_inscriptions_signes_dessins_contenu_page.dart",
                  "f00075",
                  "Tentative & complicité",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/destructions_degradations/tags_inscriptions_signes_dessins_contenu_page.dart",
                    "f00076",
                    "Tentative : OUI — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/destructions_degradations/tags_inscriptions_signes_dessins_contenu_page.dart",
                    "f00077",
                    "article 322-4 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/destructions_degradations/tags_inscriptions_signes_dessins_contenu_page.dart",
                    "f00078",
                    " (prévoit la tentative punissable pour ces délits).",
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/destructions_degradations/tags_inscriptions_signes_dessins_contenu_page.dart",
                      "f00079",
                      "Complicité : OUI. Elle est punissable pour l’infraction consommée comme pour l’infraction tentée, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/destructions_degradations/tags_inscriptions_signes_dessins_contenu_page.dart",
                      "f00080",
                      "si un fait de complicité et l’intention de s’associer à l’auteur principal sont caractérisés.",
                    ),
              ),

              SizedBox(height: 12),

              _NotaBox(
                title: "ATTENTION",
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_biens_pages/destructions_degradations/tags_inscriptions_signes_dessins_contenu_page.dart",
                          "f00081",
                          "Ce délit n’étant pas sanctionné d’une peine d’emprisonnement, il interdit la mise en œuvre du cadre juridique de flagrance ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_biens_pages/destructions_degradations/tags_inscriptions_signes_dessins_contenu_page.dart",
                          "f00082",
                          "et d’une mesure de garde à vue.",
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
