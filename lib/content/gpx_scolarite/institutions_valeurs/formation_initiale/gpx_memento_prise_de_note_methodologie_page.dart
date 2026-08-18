import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class GpxMementoPriseDeNoteMethodologiePage extends StatelessWidget {
  const GpxMementoPriseDeNoteMethodologiePage({super.key});

  static const String routeName =
      '/gpx/institution/formation_initiale/memento_notes';

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
    final Color cardWhy = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardHow = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardAbbrev = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardOrg = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);
    final Color cardMethod = isDark
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
            "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_memento_prise_de_note_methodologie_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_memento_prise_de_note_methodologie_page.dart",
            "f00002",
            "Mémo",
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
              "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_memento_prise_de_note_methodologie_page.dart",
              "f00003",
              "Mémento prise de note & méthodologie",
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Intro
          _ConditionCard(
            title: "Objectif",
            cardColor: cardIntro,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_memento_prise_de_note_methodologie_page.dart",
                      "f00004",
                      "Ce document a pour objectif d’aider les futurs élèves à appréhender des éléments qui leur permettront ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_memento_prise_de_note_methodologie_page.dart",
                      "f00005",
                      "de mieux aborder leur scolarité. La mise en pratique de ces conseils pourra se faire progressivement.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Pourquoi prendre des notes
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_memento_prise_de_note_methodologie_page.dart",
              "f00006",
              "Pourquoi prendre des notes ?",
            ),
            cardColor: cardWhy,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_memento_prise_de_note_methodologie_page.dart",
                      "f00007",
                      "La prise de notes est le meilleur moyen d’apprendre le cours. Elle consiste à transcrire à l’écrit ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_memento_prise_de_note_methodologie_page.dart",
                      "f00008",
                      "les éléments essentiels d’information donnés à l’oral, avec ou sans l’aide d’un support pédagogique.",
                    ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_memento_prise_de_note_methodologie_page.dart",
                  "f00009",
                  "Ce que ça t’apporte",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_memento_prise_de_note_methodologie_page.dart",
                  "f00010",
                  "Adapter ton écriture au débit oral (≈ 150 mots/min) et reformuler avec ton propre vocabulaire pour mieux retenir.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_memento_prise_de_note_methodologie_page.dart",
                  "f00011",
                  "Présenter l’information de façon claire et synthétique pour faciliter la compréhension.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_memento_prise_de_note_methodologie_page.dart",
                  "f00012",
                  "Mettre en valeur les éléments pertinents pour organiser tes connaissances et enclencher la mémorisation.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_memento_prise_de_note_methodologie_page.dart",
                  "f00013",
                  "Maintenir ta concentration pendant tout l’exposé et profiter intégralement du contenu.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_memento_prise_de_note_methodologie_page.dart",
                  "f00014",
                  "Noter tes questions / points à éclaircir pour interagir avec le formateur au bon moment.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_memento_prise_de_note_methodologie_page.dart",
                  "f00015",
                  "Accélérer l’apprentissage et préparer les révisions pour gagner en autonomie et en efficacité.",
                ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_memento_prise_de_note_methodologie_page.dart",
                  "f00016",
                  "Quand l’utiliser ?",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_memento_prise_de_note_methodologie_page.dart",
                  "f00017",
                  "Pendant un cours : exposé, groupe de travail, étude de cas, observation d’une simulation…",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_memento_prise_de_note_methodologie_page.dart",
                  "f00018",
                  "Lors d’un stage : à l’issue d’une vacation, pour relever une situation intéressante.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_memento_prise_de_note_methodologie_page.dart",
                  "f00019",
                  "Lors d’une étude documentaire : livre, texte, film…",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Comment prendre des notes
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_memento_prise_de_note_methodologie_page.dart",
              "f00020",
              "Comment prendre des notes ?",
            ),
            cardColor: cardHow,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_memento_prise_de_note_methodologie_page.dart",
                  "f00021",
                  "Les règles d’or",
                ),
              ),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_memento_prise_de_note_methodologie_page.dart",
                  "f00022",
                  "Avant le cours",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_memento_prise_de_note_methodologie_page.dart",
                      "f00023",
                      "• Le sujet tu connaîtras et tes notes précédentes sur le thème tu reliras.\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_memento_prise_de_note_methodologie_page.dart",
                      "f00024",
                      "• Ton matériel tu préparerás.",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_memento_prise_de_note_methodologie_page.dart",
                  "f00025",
                  "Pendant le cours",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_memento_prise_de_note_methodologie_page.dart",
                      "f00026",
                      "• La date, la séquence, l’objectif, les intervenants et le plan sur ta feuille tu noteras.\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_memento_prise_de_note_methodologie_page.dart",
                      "f00027",
                      "• Les pages tu numéroteras et de manière lisible, aérée et uniquement au recto tu écriras.\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_memento_prise_de_note_methodologie_page.dart",
                      "f00028",
                      "• Pour tes commentaires et tes questions, une marge à gauche tu laisseras.\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_memento_prise_de_note_methodologie_page.dart",
                      "f00029",
                      "• Des phrases courtes, des schémas, des symboles et des abréviations tu utiliseras.\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_memento_prise_de_note_methodologie_page.dart",
                      "f00030",
                      "• L’essentiel tu prendras, et avec des couleurs / surligneurs tu le mettras en évidence.\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_memento_prise_de_note_methodologie_page.dart",
                      "f00031",
                      "• Les définitions, mots-clés et références à retenir, en entier et en rouge tu noteras.\n",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_memento_prise_de_note_methodologie_page.dart",
                  "f00032",
                  "Après le cours",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_memento_prise_de_note_methodologie_page.dart",
                      "f00033",
                      "• Le jour même, tes notes tu reliras, tu les compléteras et au bon endroit tu les classeras.\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_memento_prise_de_note_methodologie_page.dart",
                      "f00034",
                      "• Régulièrement sur tes notes tu reviendras.",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_memento_prise_de_note_methodologie_page.dart",
                  "f00035",
                  "Les supports",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_memento_prise_de_note_methodologie_page.dart",
                      "f00036",
                      "Selon ton organisation : cahier spirale (pratique), bloc/cahier à feuilles détachables, ou feuilles volantes ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_memento_prise_de_note_methodologie_page.dart",
                      "f00037",
                      "(qui demandent une rigueur). La règle impérative : être capable de tout retrouver facilement.",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_memento_prise_de_note_methodologie_page.dart",
                  "f00038",
                  "Tu peux aussi annoter les supports distribués (diaporama, texte…). Ils doivent être classés avec soin.",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_memento_prise_de_note_methodologie_page.dart",
                  "f00039",
                  "Attention",
                ),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_memento_prise_de_note_methodologie_page.dart",
                          "f00040",
                          "La prise de note informatique « à la volée » est moins efficace pour l’apprentissage. ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_memento_prise_de_note_methodologie_page.dart",
                          "f00041",
                          "Si tu maîtrises l’outil, il peut être utile pour remettre tes notes au propre.",
                        ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Abréviations
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_memento_prise_de_note_methodologie_page.dart",
              "f00042",
              "La clef : les abréviations",
            ),
            cardColor: cardAbbrev,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_memento_prise_de_note_methodologie_page.dart",
                      "f00043",
                      "Les abréviations permettent de synthétiser les mots les plus utilisés. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_memento_prise_de_note_methodologie_page.dart",
                      "f00044",
                      "On distingue les abréviations générales (ex : cordialement → cdlt) et les abréviations techniques « métier » ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_memento_prise_de_note_methodologie_page.dart",
                      "f00045",
                      "(policier adjoint : P.A., gardien de la paix : Gpx, brigadier-chef : B/C, major : Mj…).",
                    ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_memento_prise_de_note_methodologie_page.dart",
                  "f00046",
                  "Règles à respecter",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_memento_prise_de_note_methodologie_page.dart",
                  "f00047",
                  "Les raccourcis doivent devenir instinctifs : commence par ceux que tu maîtrises et enrichis progressivement.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_memento_prise_de_note_methodologie_page.dart",
                  "f00048",
                  "Utilise toujours les mêmes abréviations pour les mêmes termes (sinon tu te perds en relisant).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_memento_prise_de_note_methodologie_page.dart",
                  "f00049",
                  "Ne retranscris pas mot pour mot : vise le sens simplifié (ex. « L’eau est bonne pour la santé » → « Eau bonne pr santé »).",
                ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_memento_prise_de_note_methodologie_page.dart",
                  "f00050",
                  "Méthodes pour abréger",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_memento_prise_de_note_methodologie_page.dart",
                  "f00051",
                  "Retirer les voyelles : cependant → cpdt.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_memento_prise_de_note_methodologie_page.dart",
                  "f00052",
                  "Remplacer la fin du mot : ion → « ° » ; ère → « R » ; ent → « » ; que → q.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_memento_prise_de_note_methodologie_page.dart",
                  "f00053",
                  "Garder les liens logiques : verbes, flèches, mots de liaison… pour ne pas perdre le sens.",
                ),
              ),
              SizedBox(height: 12),
              _NotaBox(
                title: "Important",
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_memento_prise_de_note_methodologie_page.dart",
                          "f00054",
                          "Ne confonds pas abréviation et sigle : « Gpx » = abréviation de gardien de la paix, ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_memento_prise_de_note_methodologie_page.dart",
                          "f00055",
                          "alors que « OPJ » est un sigle (Officier de Police Judiciaire).",
                        ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Organisation / Planification
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_memento_prise_de_note_methodologie_page.dart",
              "f00056",
              "S’organiser en formation",
            ),
            cardColor: cardOrg,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_memento_prise_de_note_methodologie_page.dart",
                  "f00057",
                  "Planifier son travail",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_memento_prise_de_note_methodologie_page.dart",
                      "f00058",
                      "Il convient de travailler régulièrement : un temps quotidien de reprise des notes de la journée et un temps de ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_memento_prise_de_note_methodologie_page.dart",
                      "f00059",
                      "consolidation (souvent le week-end). À cela s’ajoutent des périodes de révision selon les évaluations.",
                    ),
              ),
              SizedBox(height: 12),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_memento_prise_de_note_methodologie_page.dart",
                  "f00060",
                  "Mémo",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_memento_prise_de_note_methodologie_page.dart",
                      "f00061",
                      "50 % du contenu d’un cours est oublié au bout de 24 heures si on ne l’apprend pas.",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_memento_prise_de_note_methodologie_page.dart",
                  "f00062",
                  "Calendrier simple",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_memento_prise_de_note_methodologie_page.dart",
                  "f00063",
                  "J0 (le jour même) : relis, complète, souligne/surligne, réécris si besoin, classe tes notes et annote les supports.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_memento_prise_de_note_methodologie_page.dart",
                  "f00064",
                  "J+1 : apprends une première fois le lendemain (tu te souviens encore du plan et des concepts).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_memento_prise_de_note_methodologie_page.dart",
                  "f00065",
                  "Week-end suivant : reprise plus aisée, exercices/études de cas, début des fiches de révision.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Stratégie d’apprentissage + Fiche de révision
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_memento_prise_de_note_methodologie_page.dart",
              "f00066",
              "Apprendre & mémoriser",
            ),
            cardColor: cardMethod,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_memento_prise_de_note_methodologie_page.dart",
                  "f00067",
                  "Stratégie d’apprentissage",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_memento_prise_de_note_methodologie_page.dart",
                  "f00068",
                  "Après le cours : identifie les mots-clés.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_memento_prise_de_note_methodologie_page.dart",
                  "f00069",
                  "Note des questions dont les réponses sont dans tes notes.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_memento_prise_de_note_methodologie_page.dart",
                  "f00070",
                  "Masque tes notes et reformule l’information (écrit / oral) avec mots-clés + questions.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_memento_prise_de_note_methodologie_page.dart",
                  "f00071",
                  "Analyse avec : qui ? quoi ? quand ? où ? comment ? pourquoi ? combien ?",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_memento_prise_de_note_methodologie_page.dart",
                  "f00072",
                  "10 minutes par jour : réviser de cette façon en vérifiant que tu comprends vraiment la matière.",
                ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_memento_prise_de_note_methodologie_page.dart",
                  "f00073",
                  "La fiche de révision",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_memento_prise_de_note_methodologie_page.dart",
                      "f00074",
                      "C’est une synthèse de tes notes (souvent sur une fiche). Elle aide à mémoriser en la rédigeant, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_memento_prise_de_note_methodologie_page.dart",
                      "f00075",
                      "et à préparer les examens en l’apprenant. Fais de même pour les supports distribués.",
                    ),
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_memento_prise_de_note_methodologie_page.dart",
                  "f00076",
                  "Une couleur de fiche par thématique, titres clairs, fiches numérotées.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_memento_prise_de_note_methodologie_page.dart",
                  "f00077",
                  "Une fiche par thème à partir des notes et supports.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_memento_prise_de_note_methodologie_page.dart",
                  "f00078",
                  "Reprendre schématiquement les éléments clefs en gardant la cohérence du cours.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_memento_prise_de_note_methodologie_page.dart",
                  "f00079",
                  "Mettre en avant les points importants (et en rouge les éléments à savoir par cœur).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_memento_prise_de_note_methodologie_page.dart",
                  "f00080",
                  "Au verso : écrire des questions pour t’auto-interroger seul ou en groupe.",
                ),
              ),
            ],
          ),

          // Aucun article de loi ici : pas d’affichage rouge nécessaire.
          // _lawRed reste dispo si tu ajoutes des références à colorer.
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
