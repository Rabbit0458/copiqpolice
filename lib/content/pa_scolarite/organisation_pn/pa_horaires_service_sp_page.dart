import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PaHorairesServiceSpPage extends StatelessWidget {
  const PaHorairesServiceSpPage({super.key});

  static const String routeName =
      '/pa/institution/organisation_pn/horaires_service_sp';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    // ✅ Helper: TextSpan “article de loi” en rouge (SANS copyWith)
    TextSpan lawSpan(String text) {
      return TextSpan(
        text: text,
        style: const TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
      );
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette cards (propre + lisible)
    final Color cardIntro = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
    final Color cardHebdo = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardCyclique = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardConges = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardSup = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);
    final Color cardComptes = isDark
        ? const Color(0xFF1E2A2A)
        : const Color(0xFFF1FBFB);

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
    final Color accentTeal = isDark
        ? const Color(0xFF4DB6AC)
        : const Color(0xFF00796B);

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
            "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
            "f00002",
            "Horaires SP",
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
              "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
              "f00003",
              "Les horaires de service en Sécurité publique",
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
            title: ScolariteText.value(
              "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
              "f00004",
              "À retenir",
            ),
            cardColor: cardIntro,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                      "f00005",
                      "Le temps de travail en Police nationale peut s’organiser en régime hebdomadaire ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                      "f00006",
                      "ou en régime cyclique (continuité du service). En Sécurité publique, les policiers adjoints ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                      "f00007",
                      "sont soumis au même régime de travail que les personnels actifs qu’ils assistent.",
                    ),
              ),
              SizedBox(height: 10),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                  "f00008",
                  "Régime hebdomadaire : calqué sur la semaine civile (ou grande/petite semaine).",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                  "f00009",
                  "Régime cyclique : organisation en équipes successives (jour/nuit, dimanches/jours fériés).",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                  "f00010",
                  "Congés, repos et compensations : RL, RC, CA, CF, RPS, ARTT…",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // I — Hebdomadaire
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
              "f00011",
              "I — Régime de travail hebdomadaire",
            ),
            cardColor: cardHebdo,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                  "f00012",
                  "Applicable de jour ou de nuit. Il peut être :",
                ),
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                  "f00013",
                  "Calqué sur la semaine civile : 5 jours de travail / 2 jours de repos consécutifs.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                  "f00014",
                  "Basé sur grande/petite semaine : 6 jours de travail / 2 jours de repos puis 4 jours de travail / 2 jours de repos.",
                ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                  "f00015",
                  "Organisation de la journée",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                  "f00016",
                  "Sans interruption : pause obligatoire de 20 minutes (sauf nécessités imprévisibles et impérieuses), en principe au milieu de la journée.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                  "f00017",
                  "Avec interruption : coupure méridienne de 45 minutes à 2 heures entre 11h30 et 14h30.",
                ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                  "f00018",
                  "Horaires variables",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                      "f00019",
                      "Le régime hebdomadaire peut être décliné en horaires variables :\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                      "f00020",
                      "• 2 plages variables (arrivée/départ)\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                      "f00021",
                      "• 2 plages fixes de 2 heures\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                      "f00022",
                      "• 1 interruption médiane de 45 minutes minimum à 2 heures maximum\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                      "f00023",
                      "Les prises de service, pauses et fins de service sont saisies par l’agent dans l’outil de gestion du temps de travail ; le décompte est quotidien.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // II — Cyclique
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
              "f00024",
              "II — Régimes de travail cyclique",
            ),
            cardColor: cardCyclique,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                      "f00025",
                      "Le régime cyclique permet d’assurer la continuité du service public. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                      "f00026",
                      "Il fonctionne en continu par équipes successives, de jour et/ou de nuit, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                      "f00027",
                      "en horaires décalés (dimanches et jours fériés compris) : il ne correspond pas à la semaine civile.",
                    ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                  "f00028",
                  "A) Cycle 4/2",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                  "f00029",
                  "Trois versions existent :",
                ),
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                  "f00030",
                  "« Classique » : 4 matin / 2 repos / 4 après-midi / 2 repos.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                  "f00031",
                  "« Panaché » : 2 matin / 2 après-midi / 2 repos.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                  "f00032",
                  "« Compressé » : 3 après-midi / 2 repos — 4 matin / 1 repos — 4 après-midi / 2 repos — 3 matin / 2 repos.",
                ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                      "f00033",
                      "Les cycles 4/2 nécessitent 3 brigades de jour et une brigade de nuit (3 groupes).\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                      "f00034",
                      "La durée moyenne d’une vacation est de 8 h 10.\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                      "f00035",
                      "La prise de service des vacations de matinée doit être comprise entre 5h20 et 6h30 (sauf nécessités de service).",
                    ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                  "f00036",
                  "B) Cycles à vacation de 11h08 ou 12h08",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                  "f00037",
                  "Cycle 2/2 : 2 vacations / 2 jours de repos.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                  "f00038",
                  "Cycle 3/3 : 3 vacations / 3 jours de repos.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                  "f00039",
                  "Cycle 2/2/3/2/2/3 : 2 vacations / 2 repos / 3 vacations / 2 repos / 2 vacations / 3 repos.",
                ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                      "f00040",
                      "Ces cycles nécessitent 1 brigade de jour et 1 brigade de nuit (2 groupes chacune).\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                      "f00041",
                      "Ils prévoient 2 pauses de 20 minutes, divisant la journée en 3 périodes de travail équilibrées.",
                    ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                  "f00042",
                  "C) Cycle « vacation forte » (2/2/3/2/3/2)",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                      "f00043",
                      "2 vacations / 2 repos / 3 vacations / 2 repos / 3 vacations / 2 repos.\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                      "f00044",
                      "Il permet la présence de 2 brigades ou 2 groupes durant chaque vacation forte.\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                      "f00045",
                      "• Jour : « vacation forte de lundi », « de mercredi » ou « de vendredi » (2 brigades de jour, 2 groupes chacune)\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                      "f00046",
                      "• Nuit : « vacation forte de mardi » ou « de jeudi » (1 brigade, 2 groupes)\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                      "f00047",
                      "Durée moyenne d’une vacation : 9 h 31.",
                    ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                  "f00048",
                  "D) Cycles spécifiques U.C.L (unités cynotechniques légères)",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                  "f00049",
                  "Cycle 4/2 UCL : 3 vacations de nuit de 9 h 30 + 1 vacation de jour de 4 h 10.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                  "f00050",
                  "Cycle « vacation forte » UCL : cycle de nuit, avec la vacation du mardi ou du jeudi effectuée de jour.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // III — Congés & repos
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
              "f00051",
              "III — Congés et repos",
            ),
            cardColor: cardConges,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                  "f00052",
                  "A) Repos légal (R.L.)",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                      "f00053",
                      "• Régime hebdomadaire : le dimanche.\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                      "f00054",
                      "• Régime cyclique : le jour de repos suivant le ou les deux jours de repos compensateurs.",
                    ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                  "f00055",
                  "B) Repos compensateur (R.C.)",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                      "f00056",
                      "• Régime hebdomadaire : le samedi ou le lundi.\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                      "f00057",
                      "• Régime cyclique : le premier jour de repos.\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                      "f00058",
                      "  Pour les cycles avec 3 jours de repos consécutifs : les 2 premiers jours (ex : cycle 3/3).",
                    ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                  "f00059",
                  "C) Congés annuels (C.A.)",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                      "f00060",
                      "En principe : 5 fois les obligations hebdomadaires, soit 25 jours ouvrés en régime hebdomadaire.\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                      "f00061",
                      "Exceptions :\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                      "f00062",
                      "• Cycles 4/2, 4/2 compressé, 4/2 panaché : 23 jours\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                      "f00063",
                      "• Cycle « vacation forte » : 20 jours\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                      "f00064",
                      "• Cycles 2/2, 3/3, 2/2/3/2/2/3 : 18 jours\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                      "f00065",
                      "L’absence du service ne peut excéder 31 jours consécutifs.",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                      "f00066",
                      "Jours supplémentaires :\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                      "f00067",
                      "• +1 jour si 5 à 7 jours de CA sont pris hors période du 1er mai au 31 octobre\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                      "f00068",
                      "• +2 jours si au moins 8 jours sont pris hors période",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                      "f00069",
                      "Sont exclus du rappel au service et du report de repos les agents ayant positionné leurs C.A. sur le plan prévisionnel de congés.",
                    ),
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                  "f00070",
                  "D) Crédit férié (C.F.)",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                      "f00071",
                      "Compensation propre aux régimes cycliques destinée à restituer les jours fériés et chômés (ponts compris).\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                      "f00072",
                      "Volume annuel forfaitaire : 109 h 12.",
                    ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                  "f00073",
                  "E) Temps compensés (R.P.S.)",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                      "f00074",
                      "Repos de pénibilité spécifique : crédit d’heures calculé avec des coefficients multiplicateurs.\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                      "f00075",
                      "Cas principaux :\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                      "f00076",
                      "• Régime cyclique : période nocturne (21h00–06h00) et dimanche\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                      "f00077",
                      "• Régime hebdomadaire : heures de nuit, prise de service décalée sur R.C./R.L./jour férié, services supplémentaires récurrents",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                  "f00078",
                  "Périodes de prise : du 01 janvier au 30 avril et du 01 octobre au 31 décembre.",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                      "f00079",
                      "Sont exclus du rappel au service et du report de repos les agents ayant positionné leurs R.P.S. sur le plan prévisionnel de congés.",
                    ),
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                  "f00080",
                  "F) Jours ARTT & crédit annuel ARTT",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                      "f00081",
                      "• Jours ARTT (régime hebdomadaire) : attribués lorsque le service permanent dépasse le volume horaire annuel maximum autorisé.\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                      "f00082",
                      "• Heures ARTT (régime cyclique) : crédit annuel ARTT exprimé en heures (A.R.T.C.), ARTT indemnisées et journée de solidarité déduites.",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                      "f00083",
                      "Sont exclus du rappel au service et du report de repos les agents ayant positionné leurs A.R.T.T. ou A.R.T.C. sur le plan prévisionnel de congés.",
                    ),
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // IV — Services supplémentaires (NOTA PA)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
              "f00084",
              "IV — Services supplémentaires",
            ),
            cardColor: cardSup,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                  "f00085",
                  "Constituent des services supplémentaires :",
                ),
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                  "f00086",
                  "Le rappel au service.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                  "f00087",
                  "Le dépassement horaire.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                  "f00088",
                  "La permanence.",
                ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                  "f00089",
                  "Ces services ouvrent droit à des repos compensateurs égaux ou équivalents.",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                          "f00090",
                          "Les policiers adjoints ne peuvent pas être soumis à l’astreinte. ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                          "f00091",
                          "En revanche, ils peuvent être volontaires dans le cadre des permanences.",
                        ),
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // V & VI — Comptes
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
              "f00092",
              "V — CET & VI — RCSS",
            ),
            cardColor: cardComptes,
            accent: accentTeal,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                  "f00093",
                  "V) Compte épargne-temps (CET)",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                      "f00094",
                      "Le CET permet d’accumuler des droits à congés rémunérés. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                      "f00095",
                      "Il est ouvert sur demande à tout agent : titulaire (tous corps) ou non titulaire (policiers adjoints), ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                      "f00096",
                      "ayant accompli au moins une année de service.",
                    ),
              ),
              const SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                  "f00097",
                  "VI) Repos compensateurs pour services supplémentaires (RCSS)",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                      "f00098",
                      "Chaque agent dispose d’un compte personnel de RCSS. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                      "f00099",
                      "Au-delà d’un seuil de 160 heures, l’agent récupère ses RCSS dans un délai de 30 jours ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                      "f00100",
                      "dès que le pourcentage de présence nécessaire à l’exercice des missions le permet.",
                    ),
              ),
              const SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                      "f00101",
                      "À défaut, les chefs de service prescrivent la récupération des repos restants au terme du délai ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                      "f00102",
                      "par journées, sous réserve des nécessités de service.",
                    ),
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                      "f00103",
                      "Les RCSS placés sur le compte peuvent faire l’objet d’une indemnisation.",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // ✅ Petit rappel des références “code” (en rouge quand présent)
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                  "f00104",
                  "Rappel législatif",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                      "f00105",
                      "Les règles de temps de travail et les prérogatives en service s’inscrivent notamment dans le cadre du ",
                    ),
                  ),
                  lawSpan(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                      "f00106",
                      "Code de procédure pénale",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart",
                      "f00107",
                      " et des textes réglementaires applicables.",
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
