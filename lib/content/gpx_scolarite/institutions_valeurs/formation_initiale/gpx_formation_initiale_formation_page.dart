import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class GpxFormationInitialeFormationPage extends StatelessWidget {
  const GpxFormationInitialeFormationPage({super.key});

  static const String routeName =
      '/gpx/institution/formation_initiale/formation';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette cards (propre + lisible)
    final Color cardOrg = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardPhases = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardEval = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
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
            "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_formation_initiale_formation_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_formation_initiale_formation_page.dart",
            "f00002",
            "Formation initiale",
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
              "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_formation_initiale_formation_page.dart",
              "f00003",
              "La formation initiale des gardiens de la paix",
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
              "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_formation_initiale_formation_page.dart",
              "f00004",
              "Vue d’ensemble",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_formation_initiale_formation_page.dart",
                      "f00005",
                      "La formation initiale des gardiens de la paix se déroule sur 24 mois : ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_formation_initiale_formation_page.dart",
                      "f00006",
                      "12 mois en tant qu’élèves dans une école de police, puis 12 mois en tant que gardiens de la paix stagiaires ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_formation_initiale_formation_page.dart",
                      "f00007",
                      "dans leur premier service d’affectation.",
                    ),
              ),
              SizedBox(height: 10),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_formation_initiale_formation_page.dart",
                  "f00008",
                  "Les 16 premières semaines : programme commun aux élèves policiers adjoints et aux élèves gardiens de la paix.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_formation_initiale_formation_page.dart",
                  "f00009",
                  "À l’issue des 16 semaines : les policiers adjoints rejoignent leur service d’affectation.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_formation_initiale_formation_page.dart",
                  "f00010",
                  "Des élèves gardiens de la paix (anciens P.A. affectés depuis moins de 2 ans et titulaires de l’unité de valeur « socle initial FI PA/GPX ») sont incorporés en nombre équivalent.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Nota UV + module e-formation
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_formation_initiale_formation_page.dart",
              "f00011",
              "À retenir",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_formation_initiale_formation_page.dart",
                      "f00012",
                      "À titre transitoire, les P.A. formés en 16 semaines avant l’entrée en vigueur de la scolarité P.A./GPX sont réputés lauréats de l’U.V.",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_formation_initiale_formation_page.dart",
                  "f00013",
                  "E-formation",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_formation_initiale_formation_page.dart",
                      "f00014",
                      "Préalablement à leur incorporation, ils suivent un module e-formation d’une durée de 06h00.",
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // I. Organisation
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_formation_initiale_formation_page.dart",
              "f00015",
              "I — Organisation de la formation",
            ),
            cardColor: cardOrg,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_formation_initiale_formation_page.dart",
                  "f00016",
                  "La progression pédagogique de la formation initiale est structurée en cinq phases d’apprentissages.",
                ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_formation_initiale_formation_page.dart",
                  "f00017",
                  "Les 5 phases",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_formation_initiale_formation_page.dart",
                  "f00018",
                  "Socle initial : 16 semaines (sections composées d’élèves P.A. et d’élèves G.P.X.).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_formation_initiale_formation_page.dart",
                  "f00019",
                  "Alternance : 2 semaines (ou reprise pédagogique d’une durée équivalente pour les titulaires de l’U.V. « socle initial FI PA/GPX »).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_formation_initiale_formation_page.dart",
                  "f00020",
                  "Socle avancé — 1ère partie : 18 semaines.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_formation_initiale_formation_page.dart",
                  "f00021",
                  "Alternance : 3 semaines (service opérationnel).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_formation_initiale_formation_page.dart",
                  "f00022",
                  "Socle avancé — 2ème partie : 8 semaines.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Phases détaillées
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_formation_initiale_formation_page.dart",
              "f00023",
              "Détail des phases",
            ),
            cardColor: cardPhases,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_formation_initiale_formation_page.dart",
                  "f00024",
                  "A) 1ère phase — Socle initial (16 semaines)",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_formation_initiale_formation_page.dart",
                      "f00025",
                      "Ces 16 semaines sont consacrées à l’étude des fondamentaux (institution policière et ses valeurs, bases juridiques, dimension humaine) ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_formation_initiale_formation_page.dart",
                      "f00026",
                      "et à des situations professionnelles (relation police/population, interpellation, violences intra-familiales, sécurité routière).",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_formation_initiale_formation_page.dart",
                      "f00027",
                      "Elles comprennent aussi l’apprentissage des Techniques de Sécurité et d’Intervention (T.S.I.), du secourisme, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_formation_initiale_formation_page.dart",
                      "f00028",
                      "l’aptitude à l’usage du P.A. SIG SAUER, l’habilitation aux bâtons de police, ainsi que l’utilisation des outils numériques.",
                    ),
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_formation_initiale_formation_page.dart",
                  "f00029",
                  "B) 2ème phase — Alternance (2 semaines) / Reprise pédagogique",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_formation_initiale_formation_page.dart",
                      "f00030",
                      "Cette première période d’alternance est un stage de 2 semaines, permettant aux élèves incorporés dès le début ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_formation_initiale_formation_page.dart",
                      "f00031",
                      "de découvrir les services et les missions d’un commissariat.",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_formation_initiale_formation_page.dart",
                      "f00032",
                      "Durant cette période, 3 jours en service d’investigation permettent d’identifier les différents acteurs de l’enquête ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_formation_initiale_formation_page.dart",
                      "f00033",
                      "et du procès pénal.",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_formation_initiale_formation_page.dart",
                      "f00034",
                      "La reprise pédagogique (pour les élèves titulaires de l’U.V. « socle initial FI PA/GPX » incorporés à la 17ème semaine) ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_formation_initiale_formation_page.dart",
                      "f00035",
                      "comporte notamment des enseignements généraux et des enseignements relatifs à la T.S.I., à la dimension humaine du métier ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_formation_initiale_formation_page.dart",
                      "f00036",
                      "de policier et au numérique.",
                    ),
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_formation_initiale_formation_page.dart",
                  "f00037",
                  "C) 3ème phase — Socle avancé (1ère partie : 18 semaines)",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_formation_initiale_formation_page.dart",
                  "f00038",
                  "Cette phase approfondit les contenus techniques, juridiques et humains du socle initial.",
                ),
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_formation_initiale_formation_page.dart",
                  "f00039",
                  "Aborde l’exercice de la qualité d’agent de police judiciaire (A.P.J. 20).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_formation_initiale_formation_page.dart",
                  "f00040",
                  "Dispense le module 1 de préparation à la qualification d’officier de police judiciaire (O.P.J. 16) : 6 semaines.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_formation_initiale_formation_page.dart",
                  "f00041",
                  "Délivre des habilitations TSI spécifiques (HK UMP 9 MM, DIVA) et des sensibilisations indispensables (PIE, HK G36).",
                ),
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_formation_initiale_formation_page.dart",
                  "f00042",
                  "D) 4ème phase — Alternance (3 semaines)",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_formation_initiale_formation_page.dart",
                  "f00043",
                  "Cette deuxième période d’alternance est un stage de 3 semaines en service opérationnel, dont une semaine en service d’investigations.",
                ),
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_formation_initiale_formation_page.dart",
                  "f00044",
                  "E) 5ème phase — Socle avancé (2ème partie : 8 semaines)",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_formation_initiale_formation_page.dart",
                  "f00045",
                  "Cette dernière phase comprend un tronc commun, un module de spécialisation métier (M.S.M.) et la semaine de fin de promotion.",
                ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_formation_initiale_formation_page.dart",
                      "f00046",
                      "Le tronc commun, durant les 4 semaines précédant le choix des postes, inclut l’étude de situations professionnelles ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_formation_initiale_formation_page.dart",
                      "f00047",
                      "(stupéfiants, milieu confiné, renseignement) et des apprentissages complémentaires (ex : laïcité, maltraitance animale) ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_formation_initiale_formation_page.dart",
                      "f00048",
                      "ainsi que des apprentissages spécifiques T.S.I.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // MSM
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_formation_initiale_formation_page.dart",
              "f00049",
              "Modules de spécialisation métier (M.S.M.)",
            ),
            cardColor: cardPhases,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_formation_initiale_formation_page.dart",
                  "f00050",
                  "En fonction de l’affectation choisie, les élèves suivent pendant 3 semaines le module de spécialisation adapté à leur future direction d’emploi.",
                ),
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_formation_initiale_formation_page.dart",
                  "f00051",
                  "M.S.M. Compagnies Républicaines de Sécurité (CRS).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_formation_initiale_formation_page.dart",
                  "f00052",
                  "M.S.M. Police Aux Frontières (PAF).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_formation_initiale_formation_page.dart",
                  "f00053",
                  "M.S.M. Investigations (PP/DSPAP/SAIP : Préfecture de police de Paris / Direction de la Sécurité de Proximité de l’Agglomération Parisienne / Service de l’Accueil et de l’Investigation de Proximité).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_formation_initiale_formation_page.dart",
                  "f00054",
                  "M.S.M. Protection et ordre public (PP/DOPC, SDLP : Préfecture de police de Paris / Direction de l’Ordre Public et de la Circulation / Service de la Protection).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_formation_initiale_formation_page.dart",
                  "f00055",
                  "M.S.M. Sécurité générale (DNSP, PP/DSPAP : Direction Nationale de la Sécurité Publique / Préfecture de police de Paris / Direction de la Sécurité de Proximité de l’Agglomération Parisienne).",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // II. Evaluation
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_formation_initiale_formation_page.dart",
              "f00056",
              "II — Évaluation de l’aptitude professionnelle",
            ),
            cardColor: cardEval,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_formation_initiale_formation_page.dart",
                      "f00057",
                      "Les évaluations portent sur : le discernement professionnel, l’implication personnelle, le respect déontologique, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_formation_initiale_formation_page.dart",
                      "f00058",
                      "les connaissances théoriques fondamentales, les savoir-faire en situation, les acquis techniques, la condition physique ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_formation_initiale_formation_page.dart",
                      "f00059",
                      "et la maîtrise des applications informatiques professionnelles.",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_formation_initiale_formation_page.dart",
                      "f00060",
                      "Les épreuves peuvent consister en : rédaction d’actes administratifs/judiciaires, réponses à des questions, résolution de cas pratiques, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_formation_initiale_formation_page.dart",
                      "f00061",
                      "réalisation d’exercices techniques.",
                    ),
              ),
              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_formation_initiale_formation_page.dart",
                  "f00062",
                  "Trois types d’évaluations",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_formation_initiale_formation_page.dart",
                  "f00063",
                  "1) Évaluations en « acquis / non acquis » pendant le socle initial :",
                ),
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_formation_initiale_formation_page.dart",
                  "f00064",
                  "Compétences numériques.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_formation_initiale_formation_page.dart",
                  "f00065",
                  "Test d’Endurance Cardio-Respiratoire 1 (TECR1).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_formation_initiale_formation_page.dart",
                  "f00066",
                  "Aptitude SIG.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_formation_initiale_formation_page.dart",
                  "f00067",
                  "Contrôle Écrit École 1 (CEE1).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_formation_initiale_formation_page.dart",
                  "f00068",
                  "Main Courante Police Nationale (MCPN).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_formation_initiale_formation_page.dart",
                  "f00069",
                  "Contrôle École de Simulation (CES).",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_formation_initiale_formation_page.dart",
                      "f00070",
                      "La validation de cinq compétences est nécessaire à l’acquisition de l’unité de valeur commune aux deux publics.",
                    ),
                  ),
                ],
              ),

              SizedBox(height: 14),

              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_formation_initiale_formation_page.dart",
                  "f00071",
                  "2) Évaluations en « acquis / non acquis » pendant la 1ère partie du socle avancé :",
                ),
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_formation_initiale_formation_page.dart",
                  "f00072",
                  "CEE2.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_formation_initiale_formation_page.dart",
                  "f00073",
                  "Épreuve LRPPN.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_formation_initiale_formation_page.dart",
                  "f00074",
                  "Techniques de Défense et d’Intervention (TDI).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_formation_initiale_formation_page.dart",
                  "f00075",
                  "Armement.",
                ),
              ),

              SizedBox(height: 14),

              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_formation_initiale_formation_page.dart",
                  "f00076",
                  "3) Évaluations notées pendant la 1ère partie du socle avancé :",
                ),
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_formation_initiale_formation_page.dart",
                  "f00077",
                  "Contrôle National Judiciaire (CNJ).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_formation_initiale_formation_page.dart",
                  "f00078",
                  "Vacation.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_formation_initiale_formation_page.dart",
                  "f00079",
                  "TECR 2.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_formation_initiale_formation_page.dart",
                  "f00080",
                  "Contrôle national Emploi Des Armes (EDA) 1 PM HK UMP.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_formation_initiale_formation_page.dart",
                  "f00081",
                  "Contrôle national EDA 2 au PA SIG.",
                ),
              ),

              SizedBox(height: 14),

              _NotaBox(
                title: "Jury",
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_formation_initiale_formation_page.dart",
                          "f00082",
                          "Le jury d’aptitude professionnelle (J.A.P.) se réunit à l’issue des évaluations et se prononce sur l’aptitude ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_formation_initiale_formation_page.dart",
                          "f00083",
                          "des élèves à être nommés gardiens de la paix stagiaires ou sur un éventuel redoublement.",
                        ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_formation_initiale_formation_page.dart",
                      "f00084",
                      "Les élèves inscrits sur la liste d’aptitude choisissent leur première affectation dans la liste des postes proposés, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_formation_initiale_formation_page.dart",
                      "f00085",
                      "selon leur rang dans le classement national établi au vu des évaluations chiffrées.",
                    ),
              ),
            ],
          ),

          // (Aucun article de loi spécifique fourni ici : donc pas d’affichage rouge inutile.)
          // Mais la constante _lawRed est prête si tu ajoutes des références (CP/CPP/CSI/etc.).
          const SizedBox(height: 8),

          // Petite note qualité (optionnelle et sobre)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_formation_initiale_formation_page.dart",
              "f00086",
              "Repères",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_formation_initiale_formation_page.dart",
                      "f00087",
                      "Objectif : progresser par étapes, consolider les fondamentaux, puis monter en compétences opérationnelles et judiciaires ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_formation_initiale_formation_page.dart",
                      "f00088",
                      "jusqu’à l’affectation et la titularisation.",
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
