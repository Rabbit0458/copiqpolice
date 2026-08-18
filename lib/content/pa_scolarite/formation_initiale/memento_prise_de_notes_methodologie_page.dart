import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class MementoPriseDeNotesMethodologiePage extends StatelessWidget {
  const MementoPriseDeNotesMethodologiePage({super.key});

  static const String routeName =
      '/pa/institution/formation_initiale/memento_notes';

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
    final Color cardTools = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardAbbrev = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);
    final Color cardOrg = isDark
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
            "lib/content/pa_scolarite/formation_initiale/memento_prise_de_notes_methodologie_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/formation_initiale/memento_prise_de_notes_methodologie_page.dart",
            "f00002",
            "Méthodologie",
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
              "lib/content/pa_scolarite/formation_initiale/memento_prise_de_notes_methodologie_page.dart",
              "f00003",
              "Mémento — prise de notes & méthodologie",
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
                      "lib/content/pa_scolarite/formation_initiale/memento_prise_de_notes_methodologie_page.dart",
                      "f00004",
                      "Ce mémento a pour objectif d’aider les futurs élèves à appréhender des éléments concrets ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/formation_initiale/memento_prise_de_notes_methodologie_page.dart",
                      "f00005",
                      "afin de mieux aborder la scolarité.\n\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/formation_initiale/memento_prise_de_notes_methodologie_page.dart",
                      "f00006",
                      "La mise en pratique de ces conseils peut se faire progressivement.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Pourquoi prendre des notes ?
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/formation_initiale/memento_prise_de_notes_methodologie_page.dart",
              "f00007",
              "Pourquoi prendre des notes ?",
            ),
            cardColor: cardWhy,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/formation_initiale/memento_prise_de_notes_methodologie_page.dart",
                      "f00008",
                      "La prise de notes est un excellent moyen d’apprendre le cours : elle consiste à transcrire à l’écrit ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/formation_initiale/memento_prise_de_notes_methodologie_page.dart",
                      "f00009",
                      "les informations essentielles données à l’oral, avec ou sans support pédagogique.",
                    ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/formation_initiale/memento_prise_de_notes_methodologie_page.dart",
                  "f00010",
                  "Ce que ça t’apporte",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/formation_initiale/memento_prise_de_notes_methodologie_page.dart",
                  "f00011",
                  "T’adapter au débit oral (≈ 150 mots/min) et transformer l’information dans ton propre vocabulaire.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/formation_initiale/memento_prise_de_notes_methodologie_page.dart",
                  "f00012",
                  "Structurer l’information de façon claire et synthétique pour mieux comprendre.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/formation_initiale/memento_prise_de_notes_methodologie_page.dart",
                  "f00013",
                  "Repérer et mettre en valeur les éléments pertinents pour organiser tes connaissances et mémoriser.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/formation_initiale/memento_prise_de_notes_methodologie_page.dart",
                  "f00014",
                  "Rester concentré pendant tout l’exposé pour profiter intégralement du contenu.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/formation_initiale/memento_prise_de_notes_methodologie_page.dart",
                  "f00015",
                  "Noter les questions ou points à éclaircir pour interagir avec le formateur au bon moment.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/formation_initiale/memento_prise_de_notes_methodologie_page.dart",
                  "f00016",
                  "Accélérer l’apprentissage et préparer les révisions (autonomie + gain de temps).",
                ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/formation_initiale/memento_prise_de_notes_methodologie_page.dart",
                  "f00017",
                  "Quand prendre des notes ?",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/formation_initiale/memento_prise_de_notes_methodologie_page.dart",
                  "f00018",
                  "Pendant un cours : exposé, groupe de travail, étude de cas, observation d’une simulation…",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/formation_initiale/memento_prise_de_notes_methodologie_page.dart",
                  "f00019",
                  "Lors d’un stage : après une vacation, pour garder une situation intéressante.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/formation_initiale/memento_prise_de_notes_methodologie_page.dart",
                  "f00020",
                  "Lors d’une étude documentaire : livre, texte, film…",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Comment prendre des notes ?
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/formation_initiale/memento_prise_de_notes_methodologie_page.dart",
              "f00021",
              "Comment prendre des notes ?",
            ),
            cardColor: cardHow,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/formation_initiale/memento_prise_de_notes_methodologie_page.dart",
                  "f00022",
                  "Les règles d’or — avant le cours",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/formation_initiale/memento_prise_de_notes_methodologie_page.dart",
                  "f00023",
                  "Le sujet tu connaîtras et tes notes précédentes sur le thème tu reliras.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/formation_initiale/memento_prise_de_notes_methodologie_page.dart",
                  "f00024",
                  "Ton matériel tu prépareras.",
                ),
              ),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/formation_initiale/memento_prise_de_notes_methodologie_page.dart",
                  "f00025",
                  "Les règles d’or — pendant le cours",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/formation_initiale/memento_prise_de_notes_methodologie_page.dart",
                  "f00026",
                  "La date, la séquence, l’objectif, les intervenants et le plan sur ta feuille tu noteras.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/formation_initiale/memento_prise_de_notes_methodologie_page.dart",
                  "f00027",
                  "Les pages tu numéroteras (lisible, aéré, uniquement au recto).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/formation_initiale/memento_prise_de_notes_methodologie_page.dart",
                  "f00028",
                  "Pour tes commentaires et tes questions, une marge à gauche tu laisseras.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/formation_initiale/memento_prise_de_notes_methodologie_page.dart",
                  "f00029",
                  "Des phrases courtes, schémas, symboles et abréviations tu utiliseras.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/formation_initiale/memento_prise_de_notes_methodologie_page.dart",
                  "f00030",
                  "L’essentiel tu prendras : avec des couleurs/surligneurs tu mettras en évidence.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/formation_initiale/memento_prise_de_notes_methodologie_page.dart",
                  "f00031",
                  "Définitions, mots-clés et références à retenir : en entier et en rouge tu noteras.",
                ),
              ),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/formation_initiale/memento_prise_de_notes_methodologie_page.dart",
                  "f00032",
                  "Les règles d’or — après le cours",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/formation_initiale/memento_prise_de_notes_methodologie_page.dart",
                  "f00033",
                  "Le jour même : tes notes tu reliras, tu complèteras, et au bon endroit tu les classeras.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/formation_initiale/memento_prise_de_notes_methodologie_page.dart",
                  "f00034",
                  "Régulièrement : sur tes notes tu reviendras.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Supports
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/formation_initiale/memento_prise_de_notes_methodologie_page.dart",
              "f00035",
              "Supports de prise de notes",
            ),
            cardColor: cardTools,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/formation_initiale/memento_prise_de_notes_methodologie_page.dart",
                      "f00036",
                      "Selon ton organisation, tu peux utiliser : cahier spirale, bloc à feuilles détachables, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/formation_initiale/memento_prise_de_notes_methodologie_page.dart",
                      "f00037",
                      "ou feuilles volantes (qui demandent plus de rigueur).\n\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/formation_initiale/memento_prise_de_notes_methodologie_page.dart",
                      "f00038",
                      "La règle impérative : être capable de retrouver tes notes facilement et dans l’ordre.",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/formation_initiale/memento_prise_de_notes_methodologie_page.dart",
                      "f00039",
                      "Tu peux aussi annoter des supports distribués par les formateurs (diaporama, texte, etc.). ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/formation_initiale/memento_prise_de_notes_methodologie_page.dart",
                      "f00040",
                      "Ces documents doivent être classés avec soin.",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/formation_initiale/memento_prise_de_notes_methodologie_page.dart",
                          "f00041",
                          "La prise de notes informatique « à la volée » est souvent moins efficace pour l’apprentissage. ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/formation_initiale/memento_prise_de_notes_methodologie_page.dart",
                          "f00042",
                          "Si tu maîtrises l’outil, il peut être utile pour remettre au propre tes notes.",
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
              "lib/content/pa_scolarite/formation_initiale/memento_prise_de_notes_methodologie_page.dart",
              "f00043",
              "La clef : les abréviations",
            ),
            cardColor: cardAbbrev,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/formation_initiale/memento_prise_de_notes_methodologie_page.dart",
                      "f00044",
                      "Les abréviations permettent de synthétiser les mots les plus utilisés.\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/formation_initiale/memento_prise_de_notes_methodologie_page.dart",
                      "f00045",
                      "On distingue :\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/formation_initiale/memento_prise_de_notes_methodologie_page.dart",
                      "f00046",
                      "• abréviations générales (ex. cordialement = cdlt) ;\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/formation_initiale/memento_prise_de_notes_methodologie_page.dart",
                      "f00047",
                      "• abréviations techniques (métier) (ex. policier adjoint = P.A., gardien de la paix = Gpx, brigadier-chef = B/C, major = Mj…).",
                    ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/formation_initiale/memento_prise_de_notes_methodologie_page.dart",
                  "f00048",
                  "Règles importantes",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/formation_initiale/memento_prise_de_notes_methodologie_page.dart",
                  "f00049",
                  "Commence par celles que tu maîtrises et enrichis progressivement.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/formation_initiale/memento_prise_de_notes_methodologie_page.dart",
                  "f00050",
                  "Utilise toujours les mêmes abréviations pour les mêmes termes (sinon confusion).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/formation_initiale/memento_prise_de_notes_methodologie_page.dart",
                  "f00051",
                  "Ne retranscris pas mot pour mot : vise le sens simplifié.",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/formation_initiale/memento_prise_de_notes_methodologie_page.dart",
                      "f00052",
                      "Exemple : « L’eau est bonne pour la santé » devient « Eau bonne pr santé ».",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/formation_initiale/memento_prise_de_notes_methodologie_page.dart",
                  "f00053",
                  "Méthodes pour abréger",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/formation_initiale/memento_prise_de_notes_methodologie_page.dart",
                  "f00054",
                  "Retirer les voyelles : cependant → cpdt.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/formation_initiale/memento_prise_de_notes_methodologie_page.dart",
                  "f00055",
                  "Remplacer la fin du mot : « -ion » → « ° » ; « -ère » → « R » ; « -que » → « q ».",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/formation_initiale/memento_prise_de_notes_methodologie_page.dart",
                  "f00056",
                  "Garder les liens logiques (verbes, flèches, mots de liaison) pour préserver le sens.",
                ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/formation_initiale/memento_prise_de_notes_methodologie_page.dart",
                  "f00057",
                  "Attention : abréviation ≠ sigle",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/formation_initiale/memento_prise_de_notes_methodologie_page.dart",
                      "f00058",
                      "Certaines abréviations métier seront communiquées en formation.\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/formation_initiale/memento_prise_de_notes_methodologie_page.dart",
                      "f00059",
                      "Ne confonds pas abréviation et sigle : Gpx est une abréviation, OPJ est un sigle.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Organisation + planification
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/formation_initiale/memento_prise_de_notes_methodologie_page.dart",
              "f00060",
              "S’organiser en formation",
            ),
            cardColor: cardOrg,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/formation_initiale/memento_prise_de_notes_methodologie_page.dart",
                  "f00061",
                  "Planifier son travail",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/formation_initiale/memento_prise_de_notes_methodologie_page.dart",
                      "f00062",
                      "Travaille régulièrement :\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/formation_initiale/memento_prise_de_notes_methodologie_page.dart",
                      "f00063",
                      "• un temps quotidien de reprise des notes (chaque jour) ;\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/formation_initiale/memento_prise_de_notes_methodologie_page.dart",
                      "f00064",
                      "• un temps de consolidation (généralement le week-end).\n\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/formation_initiale/memento_prise_de_notes_methodologie_page.dart",
                      "f00065",
                      "À cela s’ajoutent des périodes de révision selon les évaluations.",
                    ),
              ),
              SizedBox(height: 12),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/formation_initiale/memento_prise_de_notes_methodologie_page.dart",
                  "f00066",
                  "Repère",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/formation_initiale/memento_prise_de_notes_methodologie_page.dart",
                      "f00067",
                      "50% du contenu d’un cours est oublié en 24h si on ne l’apprend pas.",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/formation_initiale/memento_prise_de_notes_methodologie_page.dart",
                  "f00068",
                  "Calendrier simple (très efficace)",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/formation_initiale/memento_prise_de_notes_methodologie_page.dart",
                  "f00069",
                  "J0 (le jour même) : relire, compléter les trous, souligner/surligner, réécrire si besoin, classer ; annoter les supports distribués.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/formation_initiale/memento_prise_de_notes_methodologie_page.dart",
                  "f00070",
                  "J+1 : apprendre une première fois le lendemain (tu maîtrises encore le plan et l’enchaînement). Creuser ce qui n’est pas compris.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/formation_initiale/memento_prise_de_notes_methodologie_page.dart",
                  "f00071",
                  "Week-end suivant : revoir plus facilement, refaire exercices/études de cas, commencer les fiches de révision.",
                ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/formation_initiale/memento_prise_de_notes_methodologie_page.dart",
                  "f00072",
                  "Stratégie d’apprentissage & mémorisation",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/formation_initiale/memento_prise_de_notes_methodologie_page.dart",
                  "f00073",
                  "Identifier les mots-clés et écrire des questions (dont les réponses sont dans tes notes).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/formation_initiale/memento_prise_de_notes_methodologie_page.dart",
                  "f00074",
                  "Masquer les notes et reformuler l’info (écrit ou oral) à partir des mots-clés/questions.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/formation_initiale/memento_prise_de_notes_methodologie_page.dart",
                  "f00075",
                  "Questionner le contenu : qui ? quoi ? quand ? où ? comment ? pourquoi ? combien ?",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/formation_initiale/memento_prise_de_notes_methodologie_page.dart",
                  "f00076",
                  "10 minutes par jour : réviser en s’assurant de comprendre (pas juste relire).",
                ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/formation_initiale/memento_prise_de_notes_methodologie_page.dart",
                  "f00077",
                  "La fiche de révision",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/formation_initiale/memento_prise_de_notes_methodologie_page.dart",
                      "f00078",
                      "Une fiche de révision est une synthèse de tes notes :\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/formation_initiale/memento_prise_de_notes_methodologie_page.dart",
                      "f00079",
                      "• elle aide à mémoriser en la rédigeant ;\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/formation_initiale/memento_prise_de_notes_methodologie_page.dart",
                      "f00080",
                      "• elle aide à préparer les examens en l’apprenant.\n\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/formation_initiale/memento_prise_de_notes_methodologie_page.dart",
                      "f00081",
                      "Fais pareil pour les supports distribués.",
                    ),
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/formation_initiale/memento_prise_de_notes_methodologie_page.dart",
                  "f00082",
                  "Une couleur de fiche par thématique + titres clairs + numérotation.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/formation_initiale/memento_prise_de_notes_methodologie_page.dart",
                  "f00083",
                  "Une fiche par thème à partir des notes + supports.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/formation_initiale/memento_prise_de_notes_methodologie_page.dart",
                  "f00084",
                  "Reprendre schématiquement les éléments clefs en gardant la cohérence.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/formation_initiale/memento_prise_de_notes_methodologie_page.dart",
                  "f00085",
                  "Mettre en avant les points importants et en rouge les éléments à savoir par cœur.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/formation_initiale/memento_prise_de_notes_methodologie_page.dart",
                  "f00086",
                  "Au verso : écrire des questions pour s’auto-interroger (seul ou en groupe).",
                ),
              ),
              SizedBox(height: 6),

              // Pas d'article de loi dans cette page, mais on garde _lawRed prêt si besoin
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/formation_initiale/memento_prise_de_notes_methodologie_page.dart",
                    "f00087",
                    "Astuce : note en rouge les références à retenir (définitions, mots-clés, points à connaître).",
                  ),
                ),
                TextSpan(text: " "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/formation_initiale/memento_prise_de_notes_methodologie_page.dart",
                    "f00088",
                    "(même logique que les références juridiques en rouge)",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
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
