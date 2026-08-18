import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PaProcedureRadioPage extends StatelessWidget {
  const PaProcedureRadioPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/policier_intervention/patrouille/procedure-radio';

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
            "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
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
              "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
              "f00002",
              "Procédure radio (ACROPOL)",
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Résumé ultra opérationnel (tout en haut)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
              "f00003",
              "Mémo express (à appliquer à chaque prise d’ondes)",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
                      "f00004",
                      "Les messages doivent être : clairs, calmes, précis et concis.\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
                      "f00005",
                      "Le vouvoiement est de rigueur. La discipline radio fait partie de la sécurité opérationnelle.",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: "TRIPTYQUE",
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
                      "f00006",
                      "Indicatif — Motif — Infos essentielles (localisation / effectifs / mission).",
                    ),
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // 1) Essai radio
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
              "f00007",
              "1 — Effectuer un essai radio (avec la station directrice)",
            ),
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
                  "f00008",
                  "Avant l’essai",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
                  "f00009",
                  "S’assurer que les ondes sont libres avant de procéder à l’essai.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
                  "f00010",
                  "Après appui PTT, attendre ~1 seconde avant de parler (activation des circuits).",
                ),
              ),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
                  "f00011",
                  "Message à émettre (modèle)",
                ),
              ),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
                  "f00012",
                  "MODÈLE",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
                      "f00013",
                      "« TN ",
                    ),
                  ),
                  TextSpan(
                    text: "**",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
                      "f00014",
                      " de TV… pour un essai radio, comment reçu ? »",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
                  "f00015",
                  "Réponse attendue du CIC (exemple)",
                ),
              ),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
                  "f00016",
                  "RÉPONSE",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
                      "f00017",
                      "« TV… de TN ",
                    ),
                  ),
                  TextSpan(
                    text: "**",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
                      "f00018",
                      " je vous reçois 5/5, fort et clair. »",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
                  "f00019",
                  "À faire ensuite",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
                  "f00020",
                  "Accuser réception pour confirmer que l’émission est bonne en retour.",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
                  "f00021",
                  "EN CAS D’ANOMALIE",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
                      "f00022",
                      "Aviser la supervision du réseau radio (chefs de poste), le référent logistique local, le référent ACROPOL et le CIC.",
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // 2) Terminologie
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
              "f00023",
              "2 — Terminologie radio (standard)",
            ),
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
                  "f00024",
                  "Règle d’or",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
                  "f00025",
                  "Le vouvoiement est de rigueur.",
                ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
                  "f00026",
                  "Termes à utiliser",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
                  "f00027",
                  "Parlez…",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
                  "f00028",
                  "Transmettez…",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
                  "f00029",
                  "Attendez…",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
                  "f00030",
                  "Répétez…",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
                  "f00031",
                  "Reçu…",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
                  "f00032",
                  "Correct…",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
                  "f00033",
                  "Je vous reçois…",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
                  "f00034",
                  "J’épelle…",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
                  "f00035",
                  "Je décompose…",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
                  "f00036",
                  "Je réitère…",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: "ASTUCE",
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
                      "f00037",
                      "Si c’est long : tu coupes en blocs, tu annonces « Attendez », puis tu reprends proprement.",
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // 3) Alphabet international + chiffres
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
              "f00038",
              "3 — Épeler & décomposer (procédure)",
            ),
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
                      "f00039",
                      "Les noms propres, groupes de lettres et mots pouvant prêter à confusion doivent être épelés. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
                      "f00040",
                      "Les chiffres doivent être décomposés selon la procédure.",
                    ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
                  "f00041",
                  "Alphabet international (lettres)",
                ),
              ),
              _NotaBox(
                title: "LETTRES",
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
                      "f00042",
                      "ALPHA — BRAVO — CHARLIE — DELTA\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
                      "f00043",
                      "ECHO — FOX-TROT — GOLF — HOTEL\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
                      "f00044",
                      "INDIA — JULIETTE — KILO — LIMA\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
                      "f00045",
                      "MIKE — NOVEMBER — OSCAR — PAPA\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
                      "f00046",
                      "QUEBEC — ROMEO — SIERRA — TANGO\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
                      "f00047",
                      "UNIFORM — VICTOR — WISKEY — X-RAY\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
                      "f00048",
                      "YANKEE — ZOULOU",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
                  "f00049",
                  "Énoncé des chiffres",
                ),
              ),
              _NotaBox(
                title: "CHIFFRES",
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
                      "f00050",
                      "0 : zéro comme rien\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
                      "f00051",
                      "1 : un tout seul\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
                      "f00052",
                      "2 : un et un\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
                      "f00053",
                      "3 : deux et un\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
                      "f00054",
                      "4 : deux fois deux\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
                      "f00055",
                      "5 : trois et deux\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
                      "f00056",
                      "6 : deux fois trois\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
                      "f00057",
                      "7 : quatre et trois\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
                      "f00058",
                      "8 : deux fois quatre\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
                      "f00059",
                      "9 : cinq et quatre",
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // 4) Prendre en compte un terminal portatif
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
              "f00060",
              "4 — Prendre en compte un terminal portatif (P2G)",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
                  "f00061",
                  "Contrôles essentiels",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
                  "f00062",
                  "Vérifier l’état général : antenne, batterie + accroche, écran, boutons (conférences/volume).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
                  "f00063",
                  "Allumer le terminal.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
                  "f00064",
                  "Vérifier le numéro de RFGI (MENU 81).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
                  "f00065",
                  "Vérifier le niveau de batterie (MENU 51).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
                  "f00066",
                  "Vérifier le son : écoute privative/collective (MENU 73) + mode silence (MENU 72).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
                  "f00067",
                  "Vérifier les voyants lumineux (MENU 78).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
                  "f00068",
                  "Prendre une batterie de rechange (2 batteries pour 1 P2G).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
                  "f00069",
                  "Émarger le registre ad hoc.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
                  "f00070",
                  "Faire un essai radio avec le CIC.",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
                  "f00071",
                  "PERTE / VOL",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
                      "f00072",
                      "En cas de perte ou de vol du terminal : aviser le CIC dans les plus brefs délais.",
                    ),
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // 5) Annoncer sa sortie / prise de service sur les ondes
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
              "f00073",
              "5 — Annoncer sa prise de service sur les ondes",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
                  "f00074",
                  "Avant émission",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
                  "f00075",
                  "S’assurer que les ondes sont libres avant de procéder à l’émission.",
                ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
                  "f00076",
                  "Message de prise d’ondes (modèle)",
                ),
              ),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
                  "f00077",
                  "MODÈLE",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
                      "f00078",
                      "« TN ",
                    ),
                  ),
                  TextSpan(
                    text: "**",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
                      "f00079",
                      " de TV… annonce sa prise de service »",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
                  "f00080",
                  "Éléments à énoncer (obligatoires)",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
                  "f00081",
                  "Nombre d’effectifs (présence de gradés, ADS, H/F).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
                  "f00082",
                  "Immatriculation du véhicule.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
                  "f00083",
                  "Numéros radio : embarquée + portatifs (communiquer les 5 derniers chiffres du RFGI).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
                  "f00084",
                  "Matériel embarqué (MO, PIE, terro…).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
                  "f00085",
                  "Mission (patrouille portée, pédestre, etc.).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
                  "f00086",
                  "Horaires de vacation.",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
                  "f00087",
                  "GÉOLOCALISATION",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
                      "f00088",
                      "La géolocalisation d’un véhicule dépend de la mise en fonction de la radio embarquée (ou d’un P2G dans le BIV) et de l’annonce du numéro RFGI (voire du numéro de la poire géolocalisée si utilisée sur un P2G).",
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // 6) Prendre en compte une mission
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
              "f00089",
              "6 — Prendre en compte une mission (CIC / hiérarchie / initiative)",
            ),
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
                  "f00090",
                  "Séquence obligatoire (4 annonces)",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
                  "f00091",
                  "1) Confirmer la prise en compte de la mission.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
                  "f00092",
                  "2) Annoncer l’arrivée sur les lieux.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
                  "f00093",
                  "3) Communiquer toute information utile sur l’évènement au CIC : 1ère physionomie, évolution, avis, demandes de renfort / autre service.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
                  "f00094",
                  "4) Annoncer la fin d’intervention.",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
                  "f00095",
                  "QUALITÉ DU MESSAGE",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
                      "f00096",
                      "Toujours : clair, calme, précis, concis — et uniquement l’essentiel opérationnel.",
                    ),
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Conclusion ultra utile
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
              "f00097",
              "Synthèse (à mémoriser)",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
                  "f00098",
                  "Je vérifie mon matériel → je fais un essai radio → j’annonce ma prise de service → je traite mes missions avec 4 annonces.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
                  "f00099",
                  "Je vouvoie, j’utilise la terminologie standard, j’épelle/décompose quand c’est nécessaire.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart",
                  "f00100",
                  "En anomalie / perte / vol : j’avise immédiatement le CIC (et la chaîne concernée).",
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
