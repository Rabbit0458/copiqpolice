import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class DestructionsDangereusesPersonnesIntentionnellePage
    extends StatelessWidget {
  const DestructionsDangereusesPersonnesIntentionnellePage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/crime_delit_bien_pages/destructions_degradations/dangereuses_personnes_intentionnelle';

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
            "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/dangereuses_personnes_intentionnelle_contenu_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/dangereuses_personnes_intentionnelle_contenu_page.dart",
            "f00002",
            "Destructions, dégradations",
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
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/dangereuses_personnes_intentionnelle_contenu_page.dart",
              "f00003",
              "Les destructions, dégradations et détériorations dangereuses pour les personnes (infraction intentionnelle)",
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 20.5,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Définition
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/dangereuses_personnes_intentionnelle_contenu_page.dart",
              "f00004",
              "Définition",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/dangereuses_personnes_intentionnelle_contenu_page.dart",
                      "f00005",
                      "La destruction, la dégradation ou la détérioration d’un bien appartenant à autrui ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/dangereuses_personnes_intentionnelle_contenu_page.dart",
                      "f00006",
                      "par l’effet d’une substance explosive, d’un incendie ou de tout autre moyen ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/dangereuses_personnes_intentionnelle_contenu_page.dart",
                      "f00007",
                      "de nature à créer un danger pour les personnes, constitue une infraction.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/dangereuses_personnes_intentionnelle_contenu_page.dart",
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
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/dangereuses_personnes_intentionnelle_contenu_page.dart",
                    "f00009",
                    "Article 322-6 alinéa 1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/dangereuses_personnes_intentionnelle_contenu_page.dart",
                    "f00010",
                    " : définit et réprime les destructions, dégradations ou détériorations volontaires et dangereuses pour les personnes.",
                  ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Élément matériel
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/dangereuses_personnes_intentionnelle_contenu_page.dart",
              "f00011",
              "II — Élément matériel",
            ),
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/dangereuses_personnes_intentionnelle_contenu_page.dart",
                  "f00012",
                  "A) Une atteinte matérielle de nature à créer un danger pour les personnes",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/dangereuses_personnes_intentionnelle_contenu_page.dart",
                    "f00013",
                    "Les moyens employés sont précisés par ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/dangereuses_personnes_intentionnelle_contenu_page.dart",
                    "f00014",
                    "l’article 322-6 alinéa 1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/dangereuses_personnes_intentionnelle_contenu_page.dart",
                        "f00015",
                        ". Ils doivent être de nature à créer un danger pour les personnes.\n",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/dangereuses_personnes_intentionnelle_contenu_page.dart",
                        "f00016",
                        "Il suffit que l’intégrité physique des personnes ait été mise en danger (danger potentiel).",
                      ),
                ),
              ]),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/dangereuses_personnes_intentionnelle_contenu_page.dart",
                  "f00017",
                  "B) Les moyens visés",
                ),
              ),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/dangereuses_personnes_intentionnelle_contenu_page.dart",
                  "f00018",
                  "Idée clé",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/dangereuses_personnes_intentionnelle_contenu_page.dart",
                      "f00019",
                      "On recherche un moyen dangereux (explosion, incendie, ou tout autre procédé) + un bien atteint (détruit/dégradé/détérioré) + une mise en danger des personnes.",
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/dangereuses_personnes_intentionnelle_contenu_page.dart",
                  "f00020",
                  "1) L’effet d’une substance explosive",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/dangereuses_personnes_intentionnelle_contenu_page.dart",
                    "f00021",
                    "Article 322-6 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/dangereuses_personnes_intentionnelle_contenu_page.dart",
                        "f00022",
                        " vise une substance explosive utilisée du fait de l’homme (pas un phénomène naturel). ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/dangereuses_personnes_intentionnelle_contenu_page.dart",
                        "f00023",
                        "Sont concernés les explosifs de toute nature (déflagration/détonation), de confection artisanale ou industrielle. ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/dangereuses_personnes_intentionnelle_contenu_page.dart",
                        "f00024",
                        "La présentation (cocktail Molotov, dynamite…) et le mode d’action importent peu.",
                      ),
                ),
              ]),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/dangereuses_personnes_intentionnelle_contenu_page.dart",
                  "f00025",
                  "2) L’incendie",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/dangereuses_personnes_intentionnelle_contenu_page.dart",
                      "f00026",
                      "L’incendie consiste à allumer un feu : provoquer une combustion rapide et brutale. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/dangereuses_personnes_intentionnelle_contenu_page.dart",
                      "f00027",
                      "Le commencement d’exécution recouvre la période allant des premiers actes accomplis sur place révélant l’intention coupable ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/dangereuses_personnes_intentionnelle_contenu_page.dart",
                      "f00028",
                      "jusqu’au moment de l’embrasement du bien visé.\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/dangereuses_personnes_intentionnelle_contenu_page.dart",
                      "f00029",
                      "L’incendie se distingue du simple feu par ses conséquences : il se propage, n’est pas maîtrisé et représente un danger pour les personnes. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/dangereuses_personnes_intentionnelle_contenu_page.dart",
                      "f00030",
                      "Pour cette raison, la qualification de l’article 322-6 est retenue plutôt que celle de 322-1.",
                    ),
              ),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/dangereuses_personnes_intentionnelle_contenu_page.dart",
                  "f00031",
                  "3) Tout autre moyen de nature à créer un danger",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/dangereuses_personnes_intentionnelle_contenu_page.dart",
                      "f00032",
                      "La formule doit s’entendre largement : dès lors que la sécurité des personnes est gravement mise en danger ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/dangereuses_personnes_intentionnelle_contenu_page.dart",
                      "f00033",
                      "(ex. dérèglement volontaire du freinage d’un autocar, création d’une voie d’eau dans la coque d’un bateau, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/dangereuses_personnes_intentionnelle_contenu_page.dart",
                      "f00034",
                      "ou favorisation d’un phénomène type avalanche/éboulement…).",
                    ),
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/dangereuses_personnes_intentionnelle_contenu_page.dart",
                  "f00035",
                  "C) Sur un bien appartenant à autrui",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/dangereuses_personnes_intentionnelle_contenu_page.dart",
                      "f00036",
                      "La notion de « bien » est large : immeubles, véhicules, meubles, documents, forêts, bois… ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/dangereuses_personnes_intentionnelle_contenu_page.dart",
                      "f00037",
                      "Le bien endommagé ou détruit doit appartenir à une autre personne que l’auteur.\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/dangereuses_personnes_intentionnelle_contenu_page.dart",
                      "f00038",
                      "La jurisprudence peut retenir l’infraction même lorsque l’auteur a un droit limité sur le bien (ex. copropriétaire).",
                    ),
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/dangereuses_personnes_intentionnelle_contenu_page.dart",
                  "f00039",
                  "D) Entraînant un dommage",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/dangereuses_personnes_intentionnelle_contenu_page.dart",
                  "f00040",
                  "Le texte vise 3 résultats possibles : destruction, dégradation, détérioration.",
                ),
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/dangereuses_personnes_intentionnelle_contenu_page.dart",
                  "f00041",
                  "Destruction : atteinte la plus grave, le bien devient impropre à l’usage (totale ou partielle).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/dangereuses_personnes_intentionnelle_contenu_page.dart",
                  "f00042",
                  "Dégradation : diminution des qualités du bien, sans le rendre inutilisable.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/dangereuses_personnes_intentionnelle_contenu_page.dart",
                  "f00043",
                  "Détérioration : atteinte moins grave, perte de valeur mais bien réparable et encore apte à son rôle.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Élément moral
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/dangereuses_personnes_intentionnelle_contenu_page.dart",
              "f00044",
              "III — Élément moral",
            ),
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/dangereuses_personnes_intentionnelle_contenu_page.dart",
                  "f00045",
                  "Agir en connaissant l’efficacité du moyen et le danger pour les personnes",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/dangereuses_personnes_intentionnelle_contenu_page.dart",
                        "f00046",
                        "La Cour de cassation considère que l’emploi d’une substance explosive ou de l’incendie caractérise suffisamment l’intention, ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/dangereuses_personnes_intentionnelle_contenu_page.dart",
                        "f00047",
                        "en raison du danger grave inhérent à ces moyens, dont chacun est censé connaître l’efficacité. ",
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/dangereuses_personnes_intentionnelle_contenu_page.dart",
                    "f00048",
                    "(Cass. crim., 24 juin 1998)",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Circonstances aggravantes
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/dangereuses_personnes_intentionnelle_contenu_page.dart",
              "f00049",
              "IV — Circonstances aggravantes",
            ),
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/dangereuses_personnes_intentionnelle_contenu_page.dart",
                    "f00050",
                    "Article 322-6 alinéa 2 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " :"),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/dangereuses_personnes_intentionnelle_contenu_page.dart",
                  "f00051",
                  "Incendie de bois, forêts, landes, maquis, plantations ou reboisements d’autrui, dans des conditions exposant les personnes à un dommage corporel ou créant un dommage irréversible à l’environnement.",
                ),
              ),
              SizedBox(height: 12),

              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/dangereuses_personnes_intentionnelle_contenu_page.dart",
                    "f00052",
                    "Article 322-7 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " :"),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/dangereuses_personnes_intentionnelle_contenu_page.dart",
                  "f00053",
                  "Lorsqu’elle a entraîné pour autrui une ITT ≤ 8 jours.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/dangereuses_personnes_intentionnelle_contenu_page.dart",
                  "f00054",
                  "Lorsqu’il s’agit de l’incendie de bois, forêts, landes, maquis, plantations ou reboisements d’autrui.",
                ),
              ),

              SizedBox(height: 12),

              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/dangereuses_personnes_intentionnelle_contenu_page.dart",
                    "f00055",
                    "Article 322-8 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " :"),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/dangereuses_personnes_intentionnelle_contenu_page.dart",
                  "f00056",
                  "Commission en bande organisée.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/dangereuses_personnes_intentionnelle_contenu_page.dart",
                  "f00057",
                  "ITT > 8 jours.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/dangereuses_personnes_intentionnelle_contenu_page.dart",
                  "f00058",
                  "Commission en raison de la qualité (magistrat, militaire gendarmerie, fonctionnaire police nationale, douanes, administration pénitentiaire, dépositaire de l’autorité publique/mission de service public, sapeur-pompier/marin-pompier) du propriétaire ou utilisateur du bien.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/dangereuses_personnes_intentionnelle_contenu_page.dart",
                  "f00059",
                  "Incendie de bois, forêts, landes, maquis, plantations ou reboisements d’autrui.",
                ),
              ),

              SizedBox(height: 12),

              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/dangereuses_personnes_intentionnelle_contenu_page.dart",
                    "f00060",
                    "Article 322-9 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " :"),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/dangereuses_personnes_intentionnelle_contenu_page.dart",
                  "f00061",
                  "Mutilation ou infirmité permanente.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/dangereuses_personnes_intentionnelle_contenu_page.dart",
                  "f00062",
                  "Incendie de bois, forêts, landes, maquis, plantations ou reboisements d’autrui.",
                ),
              ),

              SizedBox(height: 12),

              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/dangereuses_personnes_intentionnelle_contenu_page.dart",
                    "f00063",
                    "Article 322-10 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " :"),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/dangereuses_personnes_intentionnelle_contenu_page.dart",
                  "f00064",
                  "Mort d’autrui.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Répression + tentative/complicité
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/dangereuses_personnes_intentionnelle_contenu_page.dart",
              "f00065",
              "V — Répression",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/dangereuses_personnes_intentionnelle_contenu_page.dart",
                  "f00066",
                  "Peines encourues — personnes physiques",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/dangereuses_personnes_intentionnelle_contenu_page.dart",
                    "f00067",
                    "Infraction de base (délit) : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/dangereuses_personnes_intentionnelle_contenu_page.dart",
                    "f00068",
                    "10 ans d’emprisonnement et 150 000 € d’amende — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/dangereuses_personnes_intentionnelle_contenu_page.dart",
                    "f00069",
                    "article 322-6 alinéa 1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                title: "Important",
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/dangereuses_personnes_intentionnelle_contenu_page.dart",
                          "f00070",
                          "Les circonstances aggravantes (322-6 al.2, 322-7, 322-8, 322-9, 322-10) font basculer vers des peines criminelles ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/dangereuses_personnes_intentionnelle_contenu_page.dart",
                          "f00071",
                          "(réclusion 15 ans, 20 ans, 30 ans, voire perpétuité) selon le résultat (ITT, infirmité, décès) et le contexte (bande organisée, incendies de forêts…).",
                        ),
                  ),
                ],
              ),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/dangereuses_personnes_intentionnelle_contenu_page.dart",
                  "f00072",
                  "Personnes morales",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/dangereuses_personnes_intentionnelle_contenu_page.dart",
                    "f00073",
                    "Peines prévues par ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/dangereuses_personnes_intentionnelle_contenu_page.dart",
                    "f00074",
                    "l’article 322-17 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/dangereuses_personnes_intentionnelle_contenu_page.dart",
                  "f00075",
                  "Tentative & complicité",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/dangereuses_personnes_intentionnelle_contenu_page.dart",
                    "f00076",
                    "Tentative : OUI — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/dangereuses_personnes_intentionnelle_contenu_page.dart",
                    "f00077",
                    "article 322-11 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/dangereuses_personnes_intentionnelle_contenu_page.dart",
                    "f00078",
                    " prévoit la tentative punissable pour le délit de l’article 322-6.",
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/dangereuses_personnes_intentionnelle_contenu_page.dart",
                      "f00079",
                      "Complicité : OUI. Elle est punissable au regard de l’infraction consommée comme tentée, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/dangereuses_personnes_intentionnelle_contenu_page.dart",
                      "f00080",
                      "si un fait de complicité est caractérisé et si l’intention de s’associer à l’action de l’auteur principal est démontrée.",
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
