import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class SanctionsRecompensesPage extends StatelessWidget {
  const SanctionsRecompensesPage({super.key});

  static const String routeName =
      '/gpx/institution/deontologie/sanctions_recompenses';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette cards
    final Color cardLegal = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardMat = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
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
            "lib/content/gpx_scolarite/institutions_valeurs/deontologie/sanctions_recompenses_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/institutions_valeurs/deontologie/sanctions_recompenses_page.dart",
            "f00002",
            "Déontologie",
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
              "lib/content/gpx_scolarite/institutions_valeurs/deontologie/sanctions_recompenses_page.dart",
              "f00003",
              "Sanctions et récompenses",
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
              "lib/content/gpx_scolarite/institutions_valeurs/deontologie/sanctions_recompenses_page.dart",
              "f00004",
              "Idée essentielle",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/institutions_valeurs/deontologie/sanctions_recompenses_page.dart",
                      "f00005",
                      "Les policiers sont assujettis à un régime disciplinaire : toute faute commise dans l’exercice ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/institutions_valeurs/deontologie/sanctions_recompenses_page.dart",
                      "f00006",
                      "ou à l’occasion de l’exercice des fonctions peut entraîner une sanction.\n\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/institutions_valeurs/deontologie/sanctions_recompenses_page.dart",
                      "f00007",
                      "À l’inverse, un comportement exceptionnel (abnégation, courage, sens du devoir, esprit d’initiative) ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/institutions_valeurs/deontologie/sanctions_recompenses_page.dart",
                      "f00008",
                      "peut ouvrir droit à une récompense.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Références légales en haut
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/institutions_valeurs/deontologie/sanctions_recompenses_page.dart",
              "f00009",
              "Références (à connaître)",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/institutions_valeurs/deontologie/sanctions_recompenses_page.dart",
                    "f00010",
                    "Contrôle externe (qualité OPJ/APJ) : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/institutions_valeurs/deontologie/sanctions_recompenses_page.dart",
                    "f00011",
                    "articles 224 à 230 du Code de procédure pénale (CPP)",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/institutions_valeurs/deontologie/sanctions_recompenses_page.dart",
                    "f00012",
                    "Contrôle par le Défenseur des droits : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/institutions_valeurs/deontologie/sanctions_recompenses_page.dart",
                    "f00013",
                    "article R. 434-24 du Code de la sécurité intérieure (CSI)",
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
                      "lib/content/gpx_scolarite/institutions_valeurs/deontologie/sanctions_recompenses_page.dart",
                      "f00014",
                      "Ces contrôles sont la contrepartie des pouvoirs exercés au quotidien (interpellation, usage de la force, etc.).",
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // I — Contrôle
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/institutions_valeurs/deontologie/sanctions_recompenses_page.dart",
              "f00015",
              "I — Le contrôle de la Police nationale",
            ),
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/deontologie/sanctions_recompenses_page.dart",
                  "f00016",
                  "1) Contrôle interne",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/deontologie/sanctions_recompenses_page.dart",
                  "f00017",
                  "Par la chaîne hiérarchique.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/deontologie/sanctions_recompenses_page.dart",
                  "f00018",
                  "Par les services d’inspection de la Police nationale.",
                ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/deontologie/sanctions_recompenses_page.dart",
                  "f00019",
                  "2) Contrôle externe",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/deontologie/sanctions_recompenses_page.dart",
                  "f00020",
                  "Par les autorités judiciaires (ex. chambre de l’instruction pour l’exercice de la qualité OPJ/APJ).",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/deontologie/sanctions_recompenses_page.dart",
                  "f00021",
                  "Par des autorités et organismes nationaux ou internationaux (ex. Défenseur des droits).",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // II — Policiers actifs : sanctions
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/institutions_valeurs/deontologie/sanctions_recompenses_page.dart",
              "f00022",
              "II — Policiers actifs : sanctions disciplinaires",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/deontologie/sanctions_recompenses_page.dart",
                  "f00023",
                  "Les sanctions sont réparties en 4 groupes, par ordre croissant de gravité.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Groupe 1
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/institutions_valeurs/deontologie/sanctions_recompenses_page.dart",
              "f00024",
              "A) Sanctions — 1er groupe",
            ),
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/deontologie/sanctions_recompenses_page.dart",
                  "f00025",
                  "Avertissement : non inscrit au dossier, mais porté dans un registre spécial.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/deontologie/sanctions_recompenses_page.dart",
                  "f00026",
                  "Blâme : inscrit au dossier, effacé automatiquement au bout de 3 ans si aucune autre sanction n’intervient.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/deontologie/sanctions_recompenses_page.dart",
                  "f00027",
                  "Exclusion temporaire de fonctions (max 3 jours) : inscrite au dossier, effacée au bout de 3 ans si aucune autre sanction n’est prononcée.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Groupe 2
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/institutions_valeurs/deontologie/sanctions_recompenses_page.dart",
              "f00028",
              "B) Sanctions — 2ème groupe",
            ),
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/deontologie/sanctions_recompenses_page.dart",
                  "f00029",
                  "Radiation du tableau d’avancement (peut aussi être une sanction complémentaire des 2ème et 3ème groupes).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/deontologie/sanctions_recompenses_page.dart",
                  "f00030",
                  "Abaissement d’échelon.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/deontologie/sanctions_recompenses_page.dart",
                  "f00031",
                  "Exclusion temporaire de fonctions (4 à 15 jours) : privative de rémunération, possible avec sursis total ou partiel.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/deontologie/sanctions_recompenses_page.dart",
                  "f00032",
                  "Déplacement d’office : à distinguer d’une mutation dans l’intérêt du service.",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/institutions_valeurs/deontologie/sanctions_recompenses_page.dart",
                      "f00033",
                      "Repère : la mutation dans l’intérêt du service est prévue par ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/institutions_valeurs/deontologie/sanctions_recompenses_page.dart",
                      "f00034",
                      "l’article 25 du décret n° 95-654 du 9 mai 1995",
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

          // Groupe 3
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/institutions_valeurs/deontologie/sanctions_recompenses_page.dart",
              "f00035",
              "C) Sanctions — 3ème groupe",
            ),
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/deontologie/sanctions_recompenses_page.dart",
                  "f00036",
                  "Rétrogradation.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/deontologie/sanctions_recompenses_page.dart",
                  "f00037",
                  "Exclusion temporaire de fonctions (16 jours à 2 ans) : possible avec sursis, sans pouvoir ramener la durée à moins d’un mois.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Groupe 4
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/institutions_valeurs/deontologie/sanctions_recompenses_page.dart",
              "f00038",
              "D) Sanctions — 4ème groupe",
            ),
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/deontologie/sanctions_recompenses_page.dart",
                  "f00039",
                  "Mise à la retraite d’office.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/deontologie/sanctions_recompenses_page.dart",
                  "f00040",
                  "Révocation.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Règles + effacement + suspension
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/institutions_valeurs/deontologie/sanctions_recompenses_page.dart",
              "f00041",
              "Points de procédure (à ne pas confondre)",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/deontologie/sanctions_recompenses_page.dart",
                  "f00042",
                  "Conseil de discipline",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/deontologie/sanctions_recompenses_page.dart",
                  "f00043",
                  "Les sanctions du 1er groupe peuvent être prononcées sans consultation du conseil de discipline.",
                ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/deontologie/sanctions_recompenses_page.dart",
                  "f00044",
                  "Cumul avec le pénal",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/deontologie/sanctions_recompenses_page.dart",
                  "f00045",
                  "Les sanctions disciplinaires peuvent s’appliquer sans préjudice des peines prévues par la loi pénale.",
                ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/deontologie/sanctions_recompenses_page.dart",
                  "f00046",
                  "Effacement / suppression des mentions",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/deontologie/sanctions_recompenses_page.dart",
                  "f00047",
                  "Blâme et exclusion (max 3 jours) : effacement automatique au bout de 3 ans si aucune autre sanction n’intervient.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/deontologie/sanctions_recompenses_page.dart",
                  "f00048",
                  "Sanctions des 2ème ou 3ème groupes : possibilité de demander la suppression de toute mention après 10 ans de services effectifs à compter de la sanction.",
                ),
              ),
              SizedBox(height: 12),
              _SubTitle("Suspension"),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/deontologie/sanctions_recompenses_page.dart",
                  "f00049",
                  "La suspension n’est pas une sanction : c’est une mesure administrative provisoire, possible lorsqu’une procédure disciplinaire est engagée.",
                ),
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/deontologie/sanctions_recompenses_page.dart",
                  "f00050",
                  "Le fonctionnaire suspendu conserve pendant 4 mois son traitement ainsi que les indemnités et prestations sociales associées.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/deontologie/sanctions_recompenses_page.dart",
                  "f00051",
                  "À l’issue des 4 mois, sans décision disciplinaire : rétablissement dans les fonctions, sauf poursuites pénales.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Récompenses (actifs)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/institutions_valeurs/deontologie/sanctions_recompenses_page.dart",
              "f00052",
              "B) Récompenses — policiers actifs",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/institutions_valeurs/deontologie/sanctions_recompenses_page.dart",
                      "f00053",
                      "Toute action mettant en évidence l’abnégation, le sens du devoir, le courage ou l’esprit d’initiative ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/institutions_valeurs/deontologie/sanctions_recompenses_page.dart",
                      "f00054",
                      "doit faire l’objet d’un rapport circonstancié du supérieur hiérarchique (avec proposition éventuelle de récompense).",
                    ),
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/deontologie/sanctions_recompenses_page.dart",
                  "f00055",
                  "Lettre de félicitations versée au dossier individuel.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/deontologie/sanctions_recompenses_page.dart",
                  "f00056",
                  "Gratification.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/deontologie/sanctions_recompenses_page.dart",
                  "f00057",
                  "Prime pour résultats exceptionnels.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/deontologie/sanctions_recompenses_page.dart",
                  "f00058",
                  "Proposition de décoration.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/deontologie/sanctions_recompenses_page.dart",
                  "f00059",
                  "Proposition d’avancement au titre exceptionnel (selon les conditions statutaires).",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // III — Policiers adjoints
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/institutions_valeurs/deontologie/sanctions_recompenses_page.dart",
              "f00060",
              "III — Policiers adjoints",
            ),
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/deontologie/sanctions_recompenses_page.dart",
                  "f00061",
                  "Les sanctions disciplinaires applicables aux policiers adjoints sont prises par le préfet du département d’affectation.",
                ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/deontologie/sanctions_recompenses_page.dart",
                  "f00062",
                  "A) Sanctions (ordre croissant)",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/deontologie/sanctions_recompenses_page.dart",
                  "f00063",
                  "Avertissement.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/deontologie/sanctions_recompenses_page.dart",
                  "f00064",
                  "Blâme.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/deontologie/sanctions_recompenses_page.dart",
                  "f00065",
                  "Exclusion temporaire de fonctions (max 3 jours).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/deontologie/sanctions_recompenses_page.dart",
                  "f00066",
                  "Exclusion temporaire de fonctions (4 jours à 6 mois).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/deontologie/sanctions_recompenses_page.dart",
                  "f00067",
                  "Licenciement sans préavis ni indemnité.",
                ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/deontologie/sanctions_recompenses_page.dart",
                  "f00068",
                  "Mesure conservatoire",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/deontologie/sanctions_recompenses_page.dart",
                  "f00069",
                  "À titre conservatoire et dans l’intérêt du service, un policier adjoint peut être suspendu de ses fonctions par arrêté du préfet.",
                ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/deontologie/sanctions_recompenses_page.dart",
                  "f00070",
                  "B) Récompenses",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/deontologie/sanctions_recompenses_page.dart",
                  "f00071",
                  "Lettre de félicitations.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/deontologie/sanctions_recompenses_page.dart",
                  "f00072",
                  "Prime pour résultats exceptionnels.",
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
