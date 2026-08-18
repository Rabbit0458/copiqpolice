import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class RenseignementsARecueillirPage extends StatelessWidget {
  const RenseignementsARecueillirPage({super.key});

  static const String routeName =
      '/gpx/intervention/accident-circulation/renseignements-a-recueillir';

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
    final Color cardLieux = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardVeh = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardPers = isDark
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
            "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart",
            "f00002",
            "Accident circulation",
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
              "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart",
              "f00003",
              "Renseignements à recueillir (accident corporel)",
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Contexte
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart",
              "f00004",
              "Objectif opérationnel",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart",
                      "f00005",
                      "Une procédure de constat d’accident est d’autant plus pertinente qu’elle repose sur ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart",
                      "f00006",
                      "des renseignements complets, recueillis méthodiquement dès que les lieux sont sécurisés.\n\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart",
                      "f00007",
                      "Ces éléments servent à :\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart",
                      "f00008",
                      "• comprendre les circonstances et facteurs présumés (lieux, véhicules, usagers, témoins),\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart",
                      "f00009",
                      "• alimenter la procédure, le plan accident (positions, traces, indices),\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart",
                      "f00010",
                      "• compléter le B.A.A.C. (bulletin d’analyse des accidents corporels).",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Cadre légal en haut (comme demandé)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart",
              "f00011",
              "Cadre légal (à connaître)",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart",
                    "f00012",
                    "Les policiers agissent notamment dans les conditions fixées par ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart",
                    "f00013",
                    "l’article 20 du Code de procédure pénale",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart",
                    "f00014",
                    ", pour rechercher et constater les infractions concernées.\n",
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart",
                    "f00015",
                    "Infractions au code de la route et atteintes involontaires : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart",
                    "f00016",
                    "article L. 130-3 du Code de la route",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart",
                      "f00017",
                      "Après sécurisation : constatations + procédures adaptées (alcoolémie, stupéfiants, rétention du permis, etc.).",
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // I — Lieux
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart",
              "f00018",
              "I — Les lieux de l’accident",
            ),
            cardColor: cardLieux,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart",
                  "f00019",
                  "A) Localisation",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart",
                  "f00020",
                  "Commune : si la route est limite de deux communes → retenir celle où circulait l’usager présumé responsable.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart",
                  "f00021",
                  "Agglomération ou hors agglomération.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart",
                  "f00022",
                  "Intersection (ou proximité) : rencontre d’au moins 2 voies. Proximité : < 50 m en agglomération, < 150 m hors agglomération.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart",
                  "f00023",
                  "Voie(s) : nature + nom (ex : avenue…), catégorie administrative + numéro (ex : RD1089).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart",
                  "f00024",
                  "Point de choc initial / sortie de route : numéro + voie, et/ou n° de route, coordonnées GPS, PK (autoroute) ou repère (PR hors autoroute).",
                ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart",
                  "f00025",
                  "B) Caractéristiques de la chaussée",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart",
                  "f00026",
                  "Régime : sens unique / bidirectionnelle, chaussées séparées (terre-plein/îlot), voie à affectation variable.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart",
                  "f00027",
                  "Nombre de voies : circulation générale + voies spéciales (pistes/bandes cyclables, couloirs bus/taxis, voies réservées, tram, covoiturage…).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart",
                  "f00028",
                  "Priorité : feux, priorité à droite, STOP, cédez-le-passage, route prioritaire, giratoire à feux, etc.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart",
                  "f00029",
                  "Profil : plat, pente, sommet/bas de côte.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart",
                  "f00030",
                  "Tracé : rectiligne, courbe gauche/droite, en S.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart",
                  "f00031",
                  "État de surface : sèche, mouillée, flaques, inondée, enneigée, boueuse, verglacée, corps gras/huile, dégradations (nid de poule, affaissement…).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart",
                  "f00032",
                  "Aménagements : tunnel/souterrain, pont, bretelle, voie ferrée (PN/tram), carrefour aménagé, zone piétonne, péage, chantier…",
                ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart",
                  "f00033",
                  "C) Météo & luminosité",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart",
                      "f00034",
                      "Noter les conditions (éblouissement, pluie, neige, brouillard…) et la luminosité ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart",
                      "f00035",
                      "(aube, jour, crépuscule, nuit avec/sans éclairage public) : elles peuvent favoriser l’accident ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart",
                      "f00036",
                      "ou en aggraver les conséquences.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // II — Véhicules
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart",
              "f00037",
              "II — Véhicules impliqués",
            ),
            cardColor: cardVeh,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _SubTitle("Typologie"),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart",
                  "f00038",
                  "Accident sans collision : 1 seul véhicule sans choc (sortie de route simple, tonneau…).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart",
                  "f00039",
                  "Accident avec collision : obstacle fixe (arbre, glissière, bâtiment…) ou mobile (véhicule, piéton, animal…), ou collision entre véhicules (avant/arrière/côté), ou carambolage (chaîne / multiple).",
                ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart",
                  "f00040",
                  "Identification conventionnelle",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart",
                      "f00041",
                      "Pour la compréhension : chaque véhicule (y compris EDPM, cycle, véhicule en fuite) ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart",
                      "f00042",
                      "est identifié par une lettre (A → Z). La lettre A est attribuée au véhicule dont le conducteur ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart",
                      "f00043",
                      "est présumé responsable.",
                    ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart",
                  "f00044",
                  "A) Éléments d’identification (carte grise)",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart",
                  "f00045",
                  "Descriptifs : marque, modèle, couleur.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart",
                  "f00046",
                  "Catégorie : rubrique J1 (genre national). Exemple : MTL / MTT1 / MTT2. Véhicule spécial : préciser la fonction (scolaire, taxi, ambulance, handicar…).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart",
                  "f00047",
                  "Immatriculation.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart",
                  "f00048",
                  "Date de première mise en circulation.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart",
                  "f00049",
                  "Nom et adresse du propriétaire.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart",
                  "f00050",
                  "CNIT (rubrique D.2.1) ou type mine (anciennes cartes grises).",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart",
                      "f00051",
                      "Si non immatriculé (mini-moto, EDPM, cycle…) : relever tout élément utile (genre, marque, modèle, couleur…).",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart",
                  "f00052",
                  "B) Éléments circonstanciels",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart",
                  "f00053",
                  "Sens de circulation.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart",
                  "f00054",
                  "Manœuvre principale (ex : dépassement, ouverture de portière…).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart",
                  "f00055",
                  "Conformité de l’assurance.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart",
                  "f00056",
                  "Conformité contrôle/visite technique (si applicable).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart",
                  "f00057",
                  "État du véhicule / chargement (arrimage, pneus, éclairage…).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart",
                  "f00058",
                  "Point de choc initial (avant, arrière, avant gauche, côté droit…).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart",
                  "f00059",
                  "Conséquences : dégâts décrits + véhicule repris par conducteur ou enlevé par dépannage.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // III — Personnes
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart",
              "f00060",
              "III — Personnes concernées",
            ),
            cardColor: cardPers,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart",
                  "f00061",
                  "A) Usagers (conducteurs, passagers, piétons)",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart",
                      "f00062",
                      "Sont concernés : conducteurs, passagers, piétons (et assimilés : pousser une poussette, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart",
                      "f00063",
                      "conduire un cycle à la main, PMR en fauteuil à allure du pas, personne sortie du véhicule pour changer une roue…).",
                    ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart",
                  "f00064",
                  "Renseignements à relever pour chaque usager",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart",
                  "f00065",
                  "Petite identité.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart",
                  "f00066",
                  "État : indemne / blessé / décédé + gravité des dommages.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart",
                  "f00067",
                  "Lieu d’hospitalisation (si applicable).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart",
                  "f00068",
                  "Nature du trajet (domicile-travail, domicile-école, professionnel…).",
                ),
              ),
              SizedBox(height: 10),

              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart",
                    "f00069",
                    "Alcoolémie (contrôle obligatoire) : conducteurs et accompagnateurs d’élève conducteur — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart",
                    "f00070",
                    "article L. 234-3 alinéa 1 du Code de la route",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart",
                    "f00071",
                    "Piétons et passagers : recherche d’imprégnation alcoolique selon ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart",
                    "f00072",
                    "l’article L. 3354-1 du Code de la santé publique",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart",
                  "f00073",
                  "Stupéfiants : dépistage obligatoire puis vérifications le cas échéant (conducteurs et accompagnateurs d’élève conducteur).",
                ),
              ),

              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart",
                  "f00074",
                  "Focus conducteur",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart",
                  "f00075",
                  "Responsabilité présumée.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart",
                  "f00076",
                  "Permis : n°, validité, date d’obtention, catégorie adaptée au véhicule.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart",
                  "f00077",
                  "Infraction(s) commise(s).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart",
                  "f00078",
                  "Équipements de sécurité : ceinture, casque, gants, gilet rétro-réfléchissant…",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart",
                      "f00079",
                      "Rétention du permis : possible notamment en accident corporel/mortel s’il existe des raisons plausibles de soupçonner une infraction (téléphone tenu en main, vitesse, règles de croisement/dépassement, intersection/priorités…).",
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart",
                  "f00080",
                  "Focus passager",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart",
                  "f00081",
                  "Place occupée dans le véhicule.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart",
                  "f00082",
                  "Équipements de sécurité : ceinture, casque, dispositif enfant…",
                ),
              ),

              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart",
                  "f00083",
                  "Focus piéton",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart",
                  "f00084",
                  "Localisation : sur chaussée, trottoir, à ± 50 m d’un passage piéton…",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart",
                  "f00085",
                  "Manœuvre : sens de traversée, descente d’un véhicule, etc.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart",
                  "f00086",
                  "Infraction éventuellement commise.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Témoins
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart",
              "f00087",
              "IV — Témoins",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart",
                      "f00088",
                      "Les témoins sont des personnes présentes sur les lieux sans être impliquées, mais pouvant ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart",
                      "f00089",
                      "apporter des éléments déterminants (vitesse excessive/inadaptée, dépassement dangereux, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart",
                      "f00090",
                      "refus de priorité, téléphone, absence d’éclairage…).\n\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart",
                      "f00091",
                      "Recueillir leurs identités, coordonnées, emplacement au moment des faits et le récit précis.",
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
  const _NotaBox({required this.bodySpans});

  final List<TextSpan> bodySpans;

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
