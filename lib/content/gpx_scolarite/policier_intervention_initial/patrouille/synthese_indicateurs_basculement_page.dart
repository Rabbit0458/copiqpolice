import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class SyntheseIndicateursBasculementPage extends StatelessWidget {
  const SyntheseIndicateursBasculementPage({super.key});

  static const String routeName =
      '/gpx/intervention/patrouille/synthese-indicateurs-basculement';

  static const Color _lawRed = Color(
    0xFFE53935,
  ); // (garde la constante, même si non utilisée ici)

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette cards
    final Color cardRef = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
    final Color cardRuptures = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardEnv = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardDiscours = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardIdentitaire = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);
    final Color cardJud = isDark
        ? const Color(0xFF2A2A2A)
        : const Color(0xFFF6F6F6);

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
            "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          "Patrouille",
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
              "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
              "f00002",
              "Synthèse — indicateurs de basculement",
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
              "f00003",
              "Référence & lecture",
            ),
            cardColor: cardRef,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                      "f00004",
                      "Tableau de synthèse des indicateurs de basculement — extrait de la mallette pédagogique ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                      "f00005",
                      "EN019 (janvier 2017), reprise « Le policier en intervention » (mise à jour 15/06/2025).\n\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                      "f00006",
                      "⚠️ Ce tableau sert au repérage de signaux (faibles/forts) et à l’analyse de situation : ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                      "f00007",
                      "il ne remplace pas l’évaluation professionnelle, ni les procédures internes, ni le discernement.",
                    ),
              ),
              SizedBox(height: 8),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                  "f00008",
                  "Rappel simple",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                  "f00009",
                  "Un indicateur isolé ne suffit pas : c’est l’accumulation, la cohérence et l’évolution dans le temps qui comptent.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                  "f00010",
                  "Distinguer signaux faibles (changements progressifs, ambigus) et signaux forts (ruptures nettes, comportements structurés).",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
              "f00011",
              "1 — Ruptures",
            ),
            cardColor: cardRuptures,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                  "f00012",
                  "Comportement de rupture avec l’environnement habituel",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                  "f00013",
                  "Ce domaine regroupe les modifications soudaines ou persistantes du quotidien, des liens et des habitudes.",
                ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                  "f00014",
                  "Signaux forts (exemples)",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                  "f00015",
                  "Rejet brutal des habitudes quotidiennes, rupture avec la famille, éloignement des proches.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                  "f00016",
                  "Rupture avec les anciens amis, modification nette des centres d’intérêts.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                  "f00017",
                  "Absences prolongées et inexpliquées du domicile.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                  "f00018",
                  "Clivage exacerbé entre les hommes et les femmes.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                  "f00019",
                  "Intérêt soudain pour les armes.",
                ),
              ),

              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                  "f00020",
                  "Signaux faibles (exemples)",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                  "f00021",
                  "Rupture avec l’école / déscolarisation soudaine.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                  "f00022",
                  "Modification des humeurs (exaltation, fuite dans l’imaginaire/virtualité, indifférence, perte des affects).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                  "f00023",
                  "Privations de soins conventionnels, manque d’hygiène important, négligence extrême des conditions de vie/santé.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                  "f00024",
                  "Investissements financiers disproportionnés dans un domaine exclusif (y compris financement d’actions humanitaires/caritatifs orientées).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                  "f00025",
                  "Privation de sommeil et de repos.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                  "f00026",
                  "Incitation à un régime alimentaire carencé.",
                ),
              ),

              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                  "f00027",
                  "Changement d’apparence (physique/vestimentaire)",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                  "f00028",
                  "Modification soudaine et jugée non cohérente par l’entourage (volonté de dissimulation, signes d’affichage très marqués).",
                ),
              ),

              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                  "f00029",
                  "Pratique hyper ritualisée",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                  "f00030",
                  "Participation à des groupes/cercle de réflexion radicaux et/ou conférences de prédicateurs extrémistes.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                  "f00031",
                  "Agressivité ou hostilité justifiée par un motif religieux.",
                ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                  "f00032",
                  "Signaux faibles associés",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                  "f00033",
                  "Interdits étendus à l’entourage, obsession autour des rituels.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                  "f00034",
                  "Changement de décoration au domicile (réorganisation ascétique, retrait de photos/représentations humaines).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                  "f00035",
                  "Incidents lors de contrôles/accès (refus de se soumettre à certaines mesures), mimétisme culturel/identitaire.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
              "f00036",
              "2 — Environnement personnel",
            ),
            cardColor: cardEnv,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                  "f00037",
                  "Image paternelle / parentale défaillante",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                  "f00038",
                  "Absence ou rejet du père ; placement en protection de l’enfance / famille d’accueil ; recherche d’identité dégradée.",
                ),
              ),

              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                  "f00039",
                  "Environnement familial fragilisé",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                  "f00040",
                  "Immersion dans une famille radicalisée (signal fort).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                  "f00041",
                  "Traumatismes personnels ou dont l’individu a été témoin (violences, incestes, agressions sexuelles).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                  "f00042",
                  "Suivi psychiatrique d’un des parents ; repli sur soi ; fragilités relationnelles.",
                ),
              ),

              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                  "f00043",
                  "Environnement social",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                  "f00044",
                  "Fragilité sociale ; difficulté d’intégration.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
              "f00045",
              "3 — Traits, discours & réseaux",
            ),
            cardColor: cardDiscours,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                  "f00046",
                  "Traits de personnalité",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                  "f00047",
                  "Dépendance à une personne/un groupe/à des sites internet (signal fort).",
                ),
              ),
              SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                      "f00048",
                      "Signaux faibles souvent cités : immaturité, instabilité, fragilités narcissiques, intolérance à la frustration, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                      "f00049",
                      "pauvreté/absence d’affects, hypersensibilité, dogmatisme, refus du compromis, quête de réparation/reconnaissance, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                      "f00050",
                      "antécédents psychiatriques ou troubles du comportement, recherche affective, anesthésie affective, imperméabilité à la critique, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                      "f00051",
                      "provocation / besoin d’être vu.",
                    ),
              ),

              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                  "f00052",
                  "Réseaux relationnels",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                  "f00053",
                  "Contact avec des réseaux réputés pour leur radicalisme (signal fort).",
                ),
              ),

              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                  "f00054",
                  "Théories complotistes / conspirationnistes",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                  "f00055",
                  "Allusions à la fin des temps / apocalypse ; vision binaire et manichéenne du monde (signal fort).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                  "f00056",
                  "Double discours, admiration/vénération d’auteurs d’actes terroristes (signal fort).",
                ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                  "f00057",
                  "Signaux faibles associés",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                  "f00058",
                  "Allusions complotistes ; changement de vocabulaire et de sémantique employés.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
              "f00059",
              "4 — Changements identitaires & prosélytisme",
            ),
            cardColor: cardIdentitaire,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                  "f00060",
                  "Changements de comportements identitaires",
                ),
              ),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                  "f00061",
                  "Signaux forts (exemples)",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                  "f00062",
                  "Menace de l’État français ; soutien explicite à des groupes djihadistes ; hostilité à l’Occident.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                  "f00063",
                  "Discours antisémites ; dénonciation véhémente de ceux qui ne partagent pas la foi.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                  "f00064",
                  "Totalitarisme ; absence d’expression autonome (auto-récitation / discours instrumentalisé).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                  "f00065",
                  "Distinction « bons / mauvais » croyants ; logique de rejet radical.",
                ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                  "f00066",
                  "Signaux faibles (exemples)",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                  "f00067",
                  "Propos associaux ; remise en cause de l’autorité ; rejet de la vie en collectivité.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                  "f00068",
                  "Contestation du système démocratique ; critique de l’État ; attitude discriminatoire envers les femmes.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                  "f00069",
                  "Changement de sémantique, discours stéréotypé.",
                ),
              ),

              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                  "f00070",
                  "Prosélytisme",
                ),
              ),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                  "f00071",
                  "Signaux forts (exemples)",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                  "f00072",
                  "Activité visant à radicaliser l’entourage / recrutement.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                  "f00073",
                  "Incitation au départ vers une zone de conflit / à l’action violente.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                  "f00074",
                  "Conversion tenue secrète vis-à-vis des parents (mineurs).",
                ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                  "f00075",
                  "Signaux faibles (exemples)",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                  "f00076",
                  "Cas de prosélytisme à l’école ; conversion soudaine.",
                ),
              ),

              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                  "f00077",
                  "Usage des réseaux virtuels (techniques ou humains)",
                ),
              ),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                  "f00078",
                  "Signaux forts (exemples)",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                  "f00079",
                  "Changements réguliers de puces téléphoniques.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                  "f00080",
                  "Fréquentation de sites/réseaux sociaux à caractère radical ou extrémiste.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                  "f00081",
                  "Fréquentation de lieux/personnes défavorablement connus (parcours radical, criminel ou terroriste).",
                ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                  "f00082",
                  "Signaux faibles (exemples)",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                  "f00083",
                  "Comptes ouverts sous nouvelles identités (double compte).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                  "f00084",
                  "Communications compulsives (sms, courriels, réseaux) ; usage excessif intense jour/nuit.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
              "f00085",
              "5 — Judiciaire & détention",
            ),
            cardColor: cardJud,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                  "f00086",
                  "Stratégies de dissimulation / duplicité",
                ),
              ),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                  "f00087",
                  "Signaux forts (exemples)",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                  "f00088",
                  "Découverte de cartes d’itinéraires / brochures de voyage vers zones de passage ; historique de consultations de sites radicaux.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                  "f00089",
                  "Recours à des itinéraires de sécurité pour déjouer une surveillance.",
                ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                  "f00090",
                  "Signaux faibles (exemples)",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                  "f00091",
                  "Voyages touristiques ou projets humanitaires vers zones de transit ; attitude conformiste ; double discours.",
                ),
              ),

              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                  "f00092",
                  "Condamnation / incarcération",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                  "f00093",
                  "Incarcération pour des faits de terrorisme ; écrou pour des faits de terrorisme (signaux forts).",
                ),
              ),

              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                  "f00094",
                  "Antécédents / signalements (milieu pénitentiaire)",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                  "f00095",
                  "Signalement par cellules renseignement / services partenaires ; classement DPS ; antécédents de violences graves ; séjour en zone de conflit (signaux forts).",
                ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                  "f00096",
                  "Signal faible",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                  "f00097",
                  "Commission de certaines infractions d’appropriation (acquisition de moyens pour partir en zone de conflit).",
                ),
              ),

              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                  "f00098",
                  "Comportement en détention (signaux faibles)",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                  "f00099",
                  "Nie les faits, conteste l’incarcération ; influence/tentative d’influence ; pratique sportive intensive.",
                ),
              ),

              SizedBox(height: 12),
              _NotaBox(
                title: "Nota",
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                          "f00100",
                          "Cette synthèse est un support de repérage. Toute situation doit être appréciée avec discernement, ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart",
                          "f00101",
                          "en évitant les conclusions hâtives : on documente, on recoupe, on contextualise, puis on applique la doctrine/chaîne interne.",
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
